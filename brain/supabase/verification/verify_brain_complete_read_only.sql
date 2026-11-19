-- CASHUP BRAIN — verifica completa di sola lettura
-- Eseguire dopo le migrazioni 0001–0005 sul progetto CASHUP.
-- Non modifica dati, policy, permessi o impostazioni.

with expected_agents(agent_key) as (
  values ('orchestrator'),('engineering'),('security'),('finance'),
         ('growth'),('support'),('operations'),('compliance')
),
expected_settings(setting_key) as (
  values ('autonomy_enabled'),('require_human_approval_for_high_risk'),
         ('require_human_approval_for_financial_actions'),
         ('max_automated_spend_eur'),('emergency_stop')
),
brain as (
  select c.oid,c.relname,c.relrowsecurity,c.relforcerowsecurity
  from pg_class c join pg_namespace n on n.oid=c.relnamespace
  where n.nspname='public' and c.relkind='r'
    and c.relname in ('brain_founders','brain_tasks','brain_agents','brain_memory',
      'brain_approvals','brain_settings','brain_audit_log')
),
fn as (
  select p.oid,p.prosecdef,p.proconfig
  from pg_proc p join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='private' and p.proname='brain_is_founder'
)
select jsonb_pretty(jsonb_build_object(
  'agents_total',(select count(*) from public.brain_agents),
  'agents_missing',(select coalesce(jsonb_agg(e.agent_key),'[]'::jsonb)
    from expected_agents e left join public.brain_agents a using(agent_key)
    where a.agent_key is null),
  'agents_active',(select count(*) from public.brain_agents where status='active'),
  'settings_missing',(select coalesce(jsonb_agg(e.setting_key),'[]'::jsonb)
    from expected_settings e left join public.brain_settings s using(setting_key)
    where s.setting_key is null),
  'settings_values',(select jsonb_object_agg(setting_key,setting_value) from public.brain_settings),
  'brain_tables',(select count(*) from brain),
  'rls_force_count',(select count(*) from brain where relrowsecurity and relforcerowsecurity),
  'policy_count',(select count(*) from pg_policies
    where schemaname='public' and tablename in (select relname from brain)),
  'unexpected_policies',(select coalesce(jsonb_agg(tablename||'.'||policyname),'[]'::jsonb)
    from pg_policies
    where schemaname='public' and tablename in (select relname from brain)
      and not (
        (tablename='brain_founders' and policyname='brain_founders_read_self') or
        (tablename='brain_tasks' and policyname='brain_tasks_founder_all') or
        (tablename='brain_agents' and policyname='brain_agents_founder_all') or
        (tablename='brain_memory' and policyname='brain_memory_founder_all') or
        (tablename='brain_approvals' and policyname='brain_approvals_founder_all') or
        (tablename='brain_settings' and policyname='brain_settings_founder_all') or
        (tablename='brain_audit_log' and policyname in
          ('brain_audit_log_founder_read','brain_audit_log_founder_insert'))
      )),
  'anon_privilege_tables',(select count(*) from brain
    where has_table_privilege('anon',oid,'SELECT')
       or has_table_privilege('anon',oid,'INSERT')
       or has_table_privilege('anon',oid,'UPDATE')
       or has_table_privilege('anon',oid,'DELETE')
       or has_table_privilege('anon',oid,'TRUNCATE')
       or has_table_privilege('anon',oid,'REFERENCES')
       or has_table_privilege('anon',oid,'TRIGGER')),
  'service_role_privilege_tables',(select count(*) from brain
    where has_table_privilege('service_role',oid,'SELECT')
       or has_table_privilege('service_role',oid,'INSERT')
       or has_table_privilege('service_role',oid,'UPDATE')
       or has_table_privilege('service_role',oid,'DELETE')
       or has_table_privilege('service_role',oid,'TRUNCATE')),
  'founder_table_privileges',jsonb_build_object(
    'select',has_table_privilege('authenticated','public.brain_founders','SELECT'),
    'insert',has_table_privilege('authenticated','public.brain_founders','INSERT'),
    'update',has_table_privilege('authenticated','public.brain_founders','UPDATE'),
    'delete',has_table_privilege('authenticated','public.brain_founders','DELETE'),
    'truncate',has_table_privilege('authenticated','public.brain_founders','TRUNCATE')),
  'core_authenticated_full_crud_tables',(select count(*) from brain
    where relname in ('brain_tasks','brain_agents','brain_memory','brain_approvals','brain_settings')
      and has_table_privilege('authenticated',oid,'SELECT')
      and has_table_privilege('authenticated',oid,'INSERT')
      and has_table_privilege('authenticated',oid,'UPDATE')
      and has_table_privilege('authenticated',oid,'DELETE')),
  'audit_privileges',jsonb_build_object(
    'select',has_table_privilege('authenticated','public.brain_audit_log','SELECT'),
    'insert',has_table_privilege('authenticated','public.brain_audit_log','INSERT'),
    'update',has_table_privilege('authenticated','public.brain_audit_log','UPDATE'),
    'delete',has_table_privilege('authenticated','public.brain_audit_log','DELETE'),
    'truncate',has_table_privilege('authenticated','public.brain_audit_log','TRUNCATE')),
  'founder_function',jsonb_build_object(
    'exists',exists(select 1 from fn),
    'security_definer',coalesce((select prosecdef from fn),false),
    'empty_search_path',coalesce((select proconfig @> array['search_path=""'] from fn),false),
    'requires_aal2',coalesce((select position('aal2' in pg_get_functiondef(oid))>0 from fn),false),
    'anon_execute',coalesce((select has_function_privilege('anon',oid,'EXECUTE') from fn),false),
    'authenticated_execute',coalesce((select has_function_privilege('authenticated',oid,'EXECUTE') from fn),false),
    'old_public_function_exists',exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
      where n.nspname='public' and p.proname='brain_is_founder')),
  'private_schema',jsonb_build_object(
    'exists',exists(select 1 from pg_namespace where nspname='private'),
    'anon_usage',has_schema_privilege('anon','private','USAGE'),
    'authenticated_usage',has_schema_privilege('authenticated','private','USAGE')),
  'postgres_public_default_api_grants',(select count(*) from pg_default_acl d
    cross join lateral aclexplode(d.defaclacl) a
    where d.defaclrole='postgres'::regrole
      and d.defaclnamespace='public'::regnamespace
      and a.grantee in (select oid from pg_roles where rolname in ('anon','authenticated','service_role'))),
  'postgres_global_public_function_execute',(select count(*) from pg_default_acl d
    cross join lateral aclexplode(d.defaclacl) a
    where d.defaclrole='postgres'::regrole and d.defaclnamespace=0
      and d.defaclobjtype='f' and a.grantee=0 and a.privilege_type='EXECUTE'),
  'public_security_definer_functions',(select count(*) from pg_proc p
    join pg_namespace n on n.oid=p.pronamespace
    where n.nspname='public' and p.prosecdef)
)) as cashup_brain_complete_check;
