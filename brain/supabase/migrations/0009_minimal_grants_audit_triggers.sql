-- CASHUP BRAIN — least-privilege client grants and automatic audit triggers (0009)
-- Authenticated users can only perform operations used by the current console.
-- Every task insert and approval decision is audited in the same transaction.

begin;

revoke all on table public.brain_tasks from authenticated;
grant select, insert on table public.brain_tasks to authenticated;

revoke all on table public.brain_agents from authenticated;
grant select on table public.brain_agents to authenticated;

revoke all on table public.brain_memory from authenticated;
grant select on table public.brain_memory to authenticated;

revoke all on table public.brain_settings from authenticated;
grant select on table public.brain_settings to authenticated;

revoke all on table public.brain_approvals from authenticated;
grant select on table public.brain_approvals to authenticated;
grant update (status) on table public.brain_approvals to authenticated;

revoke all on table public.brain_founders from authenticated;
grant select on table public.brain_founders to authenticated;

revoke all on table public.brain_audit_log from authenticated;
grant select, insert on table public.brain_audit_log to authenticated;

create or replace function private.brain_set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  new.updated_at := pg_catalog.now();
  return new;
end;
$function$;

revoke all on function private.brain_set_updated_at() from public, anon, authenticated, service_role;

drop trigger if exists brain_tasks_set_updated_at on public.brain_tasks;
create trigger brain_tasks_set_updated_at
  before update on public.brain_tasks
  for each row execute function private.brain_set_updated_at();

drop trigger if exists brain_agents_set_updated_at on public.brain_agents;
create trigger brain_agents_set_updated_at
  before update on public.brain_agents
  for each row execute function private.brain_set_updated_at();

drop trigger if exists brain_settings_set_updated_at on public.brain_settings;
create trigger brain_settings_set_updated_at
  before update on public.brain_settings
  for each row execute function private.brain_set_updated_at();

create or replace function private.brain_audit_task_insert()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  insert into public.brain_audit_log
    (actor_user_id, actor_type, action, object_type, object_id, outcome, details)
  values
    ((select auth.uid()), 'founder', 'task_created', 'brain_task', new.id::text,
     'recorded', pg_catalog.jsonb_build_object('title', new.title));
  return new;
end;
$function$;

revoke all on function private.brain_audit_task_insert() from public, anon, authenticated, service_role;

drop trigger if exists brain_tasks_audit_insert on public.brain_tasks;
create trigger brain_tasks_audit_insert
  after insert on public.brain_tasks
  for each row execute function private.brain_audit_task_insert();

create or replace function private.brain_audit_approval_status_change()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $function$
begin
  if new.status is distinct from old.status then
    if old.status <> 'pending' or new.status not in ('approved', 'rejected') then
      raise exception using errcode = '22023',
        message = 'Transizione approvazione non consentita: serve un flusso dedicato.';
    end if;

    new.decided_by := (select auth.uid());
    new.decided_at := pg_catalog.now();

    insert into public.brain_audit_log
      (actor_user_id, actor_type, action, object_type, object_id, outcome, details)
    values
      ((select auth.uid()), 'founder', 'approval_' || new.status,
       'brain_approval', new.id::text, 'recorded',
       pg_catalog.jsonb_build_object('decision', new.status));
  end if;
  return new;
end;
$function$;

revoke all on function private.brain_audit_approval_status_change() from public, anon, authenticated, service_role;

drop trigger if exists brain_approvals_audit_status_change on public.brain_approvals;
create trigger brain_approvals_audit_status_change
  before update of status on public.brain_approvals
  for each row execute function private.brain_audit_approval_status_change();

drop policy if exists brain_approvals_founder_all on public.brain_approvals;
create policy brain_approvals_founder_read
  on public.brain_approvals
  for select to authenticated
  using ((select private.brain_is_founder()));
create policy brain_approvals_founder_update
  on public.brain_approvals
  for update to authenticated
  using ((select private.brain_is_founder()))
  with check ((select private.brain_is_founder()));

create or replace function public.brain_create_task(
  p_title text,
  p_description text default '',
  p_priority text default 'normal'
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  v_id uuid;
  v_title text;
  v_description text;
begin
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
    (title, description, priority, sector, created_by)
  values
    (v_title, v_description, p_priority, 'core', (select auth.uid()))
  returning id into v_id;

  return v_id;
end;
$function$;

create or replace function public.brain_decide_approval(
  p_approval_id uuid,
  p_decision text
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $function$
declare
  v_id uuid;
begin
  if p_approval_id is null or p_decision is null
     or p_decision not in ('approved', 'rejected') then
    raise exception using errcode = '22023', message = 'Richiesta o decisione non valida.';
  end if;

  update public.brain_approvals
     set status = p_decision
   where id = p_approval_id
     and status = 'pending'
  returning id into v_id;

  return v_id;
end;
$function$;

revoke all on function public.brain_create_task(text, text, text)
  from public, anon, authenticated, service_role;
revoke all on function public.brain_decide_approval(uuid, text)
  from public, anon, authenticated, service_role;
grant execute on function public.brain_create_task(text, text, text)
  to authenticated;
grant execute on function public.brain_decide_approval(uuid, text)
  to authenticated;

commit;