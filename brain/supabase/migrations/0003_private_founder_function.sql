-- CASHUP BRAIN — hardening della funzione fondatore
-- Sposta la funzione SECURITY DEFINER fuori dallo schema API esposto public.
-- Eseguire una sola volta dopo 0001 e 0002.
-- Non attiva agenti e non abilita automazioni.

begin;

create schema if not exists private;
revoke all on schema private from public, anon;
grant usage on schema private to authenticated;

create or replace function private.brain_is_founder()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.brain_founders f
    where f.user_id = (select auth.uid())
      and f.active = true
  );
$$;

revoke all on function private.brain_is_founder() from public, anon;
grant execute on function private.brain_is_founder() to authenticated;

drop policy if exists brain_agents_founder_all on public.brain_agents;
create policy brain_agents_founder_all
  on public.brain_agents for all to authenticated
  using ((select private.brain_is_founder()))
  with check ((select private.brain_is_founder()));

drop policy if exists brain_approvals_founder_all on public.brain_approvals;
create policy brain_approvals_founder_all
  on public.brain_approvals for all to authenticated
  using ((select private.brain_is_founder()))
  with check ((select private.brain_is_founder()));

drop policy if exists brain_memory_founder_all on public.brain_memory;
create policy brain_memory_founder_all
  on public.brain_memory for all to authenticated
  using ((select private.brain_is_founder()))
  with check ((select private.brain_is_founder()));

drop policy if exists brain_settings_founder_all on public.brain_settings;
create policy brain_settings_founder_all
  on public.brain_settings for all to authenticated
  using ((select private.brain_is_founder()))
  with check ((select private.brain_is_founder()));

drop policy if exists brain_tasks_founder_all on public.brain_tasks;
create policy brain_tasks_founder_all
  on public.brain_tasks for all to authenticated
  using ((select private.brain_is_founder()))
  with check ((select private.brain_is_founder()));

drop policy if exists brain_audit_log_founder_insert on public.brain_audit_log;
create policy brain_audit_log_founder_insert
  on public.brain_audit_log for insert to authenticated
  with check ((select private.brain_is_founder()));

drop policy if exists brain_audit_log_founder_read on public.brain_audit_log;
create policy brain_audit_log_founder_read
  on public.brain_audit_log for select to authenticated
  using ((select private.brain_is_founder()));

-- La vecchia funzione non deve restare richiamabile dallo schema esposto.
revoke all on function public.brain_is_founder() from public, anon, authenticated;
drop function public.brain_is_founder();

commit;
