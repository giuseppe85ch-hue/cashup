-- CASHUP BRAIN — remove public SECURITY DEFINER RPC while preserving narrow task creation (0011)
-- The RPC becomes SECURITY INVOKER. Column grants + RLS + database constraints
-- allow only a founder with AAL2 to create a pending core task; audit remains trigger-only.

begin;

-- Add database-level input constraints (no task rows exist at migration time, but validate anyway).
alter table public.brain_tasks
  add constraint brain_tasks_title_length_check
  check (pg_catalog.char_length(pg_catalog.btrim(title)) between 1 and 120);
alter table public.brain_tasks
  add constraint brain_tasks_description_length_check
  check (pg_catalog.char_length(description) <= 1000);

-- Revoke table-level INSERT, then grant only the fields users are allowed to provide.
revoke insert on table public.brain_tasks from public, anon, authenticated, service_role;
grant insert (title, description, priority) on table public.brain_tasks to authenticated;

drop policy if exists brain_tasks_founder_insert on public.brain_tasks;
create policy brain_tasks_founder_insert
  on public.brain_tasks
  for insert to authenticated
  with check (
    (select private.brain_is_founder())
    and created_by = (select auth.uid())
    and status = 'pending'
    and sector = 'core'
  );

-- With SECURITY INVOKER, the function can insert only the granted columns.
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
  if (select auth.uid()) is null or not (select private.brain_is_founder()) then
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

  insert into public.brain_tasks (title, description, priority)
  values (v_title, v_description, p_priority)
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