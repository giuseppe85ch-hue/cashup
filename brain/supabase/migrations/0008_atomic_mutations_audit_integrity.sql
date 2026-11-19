-- CASHUP BRAIN — atomic task/approval mutations and audit integrity (0008)
-- SECURITY INVOKER only: RLS and founder AAL2 policies remain the authority.
-- Task/approval state changes and their audit rows commit or roll back together.

begin;

drop policy if exists brain_audit_log_founder_insert on public.brain_audit_log;
create policy brain_audit_log_founder_insert
  on public.brain_audit_log
  for insert
  to authenticated
  with check (
    (select private.brain_is_founder())
    and actor_user_id = (select auth.uid())
    and actor_type = 'founder'
    and outcome = 'recorded'
  );

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

  insert into public.brain_audit_log
    (actor_user_id, actor_type, action, object_type, object_id, outcome, details)
  values
    ((select auth.uid()), 'founder', 'task_created', 'brain_task', v_id::text,
     'recorded', pg_catalog.jsonb_build_object('title', v_title));

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
     set status = p_decision,
         decided_by = (select auth.uid()),
         decided_at = pg_catalog.now()
   where id = p_approval_id
     and status = 'pending'
  returning id into v_id;

  if v_id is null then
    return null;
  end if;

  insert into public.brain_audit_log
    (actor_user_id, actor_type, action, object_type, object_id, outcome, details)
  values
    ((select auth.uid()), 'founder', 'approval_' || p_decision,
     'brain_approval', v_id::text, 'recorded',
     pg_catalog.jsonb_build_object('decision', p_decision));

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