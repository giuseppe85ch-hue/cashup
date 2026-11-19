-- CASHUP BRAIN — close direct-write and audit-forgery paths (0010)
-- Restrict task creation to the validated founder RPC and audit writes to database triggers.
-- SECURITY DEFINER is limited to fixed, schema-qualified functions with empty search_path.

begin;

-- Remove client ability to forge audit entries. Trigger functions below write them as postgres.
revoke insert on table public.brain_audit_log from public, anon, authenticated, service_role;
drop policy if exists brain_audit_log_founder_insert on public.brain_audit_log;

-- Task creation must pass the RPC's validation and founder AAL2 check.
revoke insert on table public.brain_tasks from public, anon, authenticated, service_role;
drop policy if exists brain_tasks_founder_all on public.brain_tasks;
create policy brain_tasks_founder_read
  on public.brain_tasks
  for select to authenticated
  using ((select private.brain_is_founder()));

-- Audit trigger functions are privileged narrowly so that RLS/INSERT grants do not need
-- to be weakened for the founder's browser session.
create or replace function private.brain_audit_task_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_actor uuid;
begin
  v_actor := (select auth.uid());
  if v_actor is null or not (select private.brain_is_founder()) then
    raise exception using errcode = '42501', message = 'Operazione riservata al fondatore con MFA.';
  end if;

  insert into public.brain_audit_log
    (actor_user_id, actor_type, action, object_type, object_id, outcome, details)
  values
    (v_actor, 'founder', 'task_created', 'brain_task', new.id::text,
     'recorded', pg_catalog.jsonb_build_object('title', new.title));
  return new;
end;
$function$;

create or replace function private.brain_audit_approval_status_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_actor uuid;
begin
  if new.status is distinct from old.status then
    v_actor := (select auth.uid());
    if v_actor is null or not (select private.brain_is_founder()) then
      raise exception using errcode = '42501', message = 'Decisione riservata al fondatore con MFA.';
    end if;

    if old.status <> 'pending' or new.status not in ('approved', 'rejected') then
      raise exception using errcode = '22023',
        message = 'Transizione approvazione non consentita: serve un flusso dedicato.';
    end if;

    new.decided_by := v_actor;
    new.decided_at := pg_catalog.now();

    insert into public.brain_audit_log
      (actor_user_id, actor_type, action, object_type, object_id, outcome, details)
    values
      (v_actor, 'founder', 'approval_' || new.status,
       'brain_approval', new.id::text, 'recorded',
       pg_catalog.jsonb_build_object('decision', new.status));
  end if;
  return new;
end;
$function$;

alter function private.brain_audit_task_insert() owner to postgres;
alter function private.brain_audit_approval_status_change() owner to postgres;
revoke all on function private.brain_audit_task_insert() from public, anon, authenticated, service_role;
revoke all on function private.brain_audit_approval_status_change() from public, anon, authenticated, service_role;

-- The only client-facing task creation path validates identity, AAL2 and every field.
create or replace function public.brain_create_task(
  p_title text,
  p_description text default '',
  p_priority text default 'normal'
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_id uuid;
  v_title text;
  v_description text;
  v_actor uuid;
begin
  v_actor := (select auth.uid());
  if v_actor is null or not (select private.brain_is_founder()) then
    raise exception using errcode = '42501', message = 'Creazione attività riservata al fondatore con MFA.';
  end if;

  v_title := pg_catalog.btrim(coalesce(p_title, ''));
  v_description := coalesce(p_description, '');

  if v_title = '' or pg_catalog.char_length(v_title) > 120 then
    raise exception using errcode = '22023', message = 'Titolo non valido: usa da 1 a 120 caratteri.';
  end if;
  if pg_catalog.char_length(v_description) > 1000 then
    raise exception using errcode = '22023', message = 'Descrizione troppo lunga: massimo 1000 caratteri.';
  end if;
  if p_priority is null or p_priority not in ('low', 'normal', 'high', 'urgent') then
    raise exception using errcode = '22023', message = 'Priorità non valida.';
  end if;

  insert into public.brain_tasks
    (title, description, status, priority, sector, created_by)
  values
    (v_title, v_description, 'pending', p_priority, 'core', v_actor)
  returning id into v_id;

  return v_id;
end;
$function$;

alter function public.brain_create_task(text, text, text) owner to postgres;
revoke all on function public.brain_create_task(text, text, text)
  from public, anon, authenticated, service_role;
grant execute on function public.brain_create_task(text, text, text)
  to authenticated;

commit;