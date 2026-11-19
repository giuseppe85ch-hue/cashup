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

-- Riepilogo automatico post-migrazione: il risultato deve mostrare i valori attesi.
select jsonb_pretty(jsonb_build_object(
  'private_schema_exists', exists (
    select 1 from pg_namespace where nspname = 'private'
  ),
  'private_function_exists', exists (
    select 1 from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'private' and p.proname = 'brain_is_founder'
  ),
  'private_function_security_definer', coalesce((
    select p.prosecdef from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'private' and p.proname = 'brain_is_founder'
    limit 1
  ), false),
  'private_function_search_path', coalesce((
    select to_jsonb(p.proconfig) from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'private' and p.proname = 'brain_is_founder'
    limit 1
  ), '[]'::jsonb),
  'anon_can_execute_private_function', coalesce((
    select has_function_privilege('anon', p.oid, 'EXECUTE') from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'private' and p.proname = 'brain_is_founder'
    limit 1
  ), false),
  'authenticated_can_execute_private_function', coalesce((
    select has_function_privilege('authenticated', p.oid, 'EXECUTE') from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'private' and p.proname = 'brain_is_founder'
    limit 1
  ), false),
  'private_schema_anon_usage', coalesce(has_schema_privilege('anon', 'private', 'USAGE'), false),
  'private_schema_authenticated_usage', coalesce(has_schema_privilege('authenticated', 'private', 'USAGE'), false),
  'legacy_public_function_exists', exists (
    select 1 from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public' and p.proname = 'brain_is_founder'
  ),
  'brain_policy_count', (
    select count(*) from pg_policies
    where schemaname = 'public' and tablename like 'brain_%'
  ),
  'brain_rls_enabled_tables', (
    select count(*) from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r'
      and c.relname in (
        'brain_founders','brain_tasks','brain_agents','brain_memory',
        'brain_approvals','brain_settings','brain_audit_log'
      )
      and c.relrowsecurity and c.relforcerowsecurity
  ),
  'anon_or_public_table_grants', (
    select count(*) from information_schema.role_table_grants
    where table_schema = 'public' and table_name like 'brain_%'
      and grantee in ('PUBLIC', 'anon')
  )
)) as cashup_brain_migration_check;
