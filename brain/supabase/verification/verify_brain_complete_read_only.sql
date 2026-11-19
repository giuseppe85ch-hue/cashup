-- CASHUP BRAIN — controllo completo di sola lettura
-- Eseguire dopo le migrazioni 0001, 0002, 0003 e 0004.
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
fn as (
  select p.oid,p.prosecdef,p.proconfig,n.nspname
  from pg_proc p join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='private' and p.proname='brain_is_founder'
  limit 1
)
select jsonb_pretty(jsonb_build_object(
  'agents', jsonb_build_object(
    'total', (select count(*) from public.brain_agents),
    'expected_missing', (select coalesce(jsonb_agg(e.agent_key),'[]'::jsonb)
      from expected_agents e left join public.brain_agents a using(agent_key)
      where a.agent_key is null),
    'active_count', (select count(*) from public.brain_agents where status='active')
  ),
  'settings', jsonb_build_object(
    'missing', (select coalesce(jsonb_agg(e.setting_key),'[]'::jsonb)
      from expected_settings e left join public.brain_settings s using(setting_key)
      where s.setting_key is null),
    'autonomy_enabled', (select setting_value from public.brain_settings where setting_key='autonomy_enabled'),
    'emergency_stop', (select setting_value from public.brain_settings where setting_key='emergency_stop'),
    'max_automated_spend_eur', (select setting_value from public.brain_settings where setting_key='max_automated_spend_eur'),
    'human_approval_financial', (select setting_value from public.brain_settings where setting_key='require_human_approval_for_financial_actions'),
    'human_approval_high_risk', (select setting_value from public.brain_settings where setting_key='require_human_approval_for_high_risk')
  ),
  'founder_function', jsonb_build_object(
    'exists_in_private', exists(select 1 from fn),
    'security_definer', coalesce((select prosecdef from fn),false),
    'search_path_empty', coalesce((select proconfig @> array['search_path=""'] from fn),false),
    'anon_can_execute', coalesce((select has_function_privilege('anon',oid,'EXECUTE') from fn),false),
    'authenticated_can_execute', coalesce((select has_function_privilege('authenticated',oid,'EXECUTE') from fn),false),
    'old_public_function_exists', exists(
      select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
      where n.nspname='public' and p.proname='brain_is_founder'
    )
  ),
  'policies',jsonb_build_object(
    'expected_policy_count',8,
    'actual_policy_count',(
      select count(*) from pg_policies
      where schemaname='public' and tablename in (
        'brain_founders','brain_tasks','brain_agents','brain_memory',
        'brain_approvals','brain_settings','brain_audit_log'
      )
    ),
    'unexpected_policies',coalesce((
      select jsonb_agg(tablename||'.'||policyname)
      from pg_policies
      where schemaname='public' and tablename in (
        'brain_founders','brain_tasks','brain_agents','brain_memory',
        'brain_approvals','brain_settings','brain_audit_log'
      )
      and not (
        (tablename='brain_founders' and policyname='brain_founders_read_self') or
        (tablename='brain_tasks' and policyname='brain_tasks_founder_all') or
        (tablename='brain_agents' and policyname='brain_agents_founder_all') or
        (tablename='brain_memory' and policyname='brain_memory_founder_all') or
        (tablename='brain_approvals' and policyname='brain_approvals_founder_all') or
        (tablename='brain_settings' and policyname='brain_settings_founder_all') or
        (tablename='brain_audit_log' and policyname in ('brain_audit_log_founder_read','brain_audit_log_founder_insert'))
      )
    ),'[]'::jsonb)
  ),
  'tables', jsonb_build_object(
    'expected_total',7,
    'rls_and_force_rls_count',(
      select count(*) from pg_class c join pg_namespace n on n.oid=c.relnamespace
      where n.nspname='public' and c.relkind='r'
        and c.relname in ('brain_founders','brain_tasks','brain_agents','brain_memory',
          'brain_approvals','brain_settings','brain_audit_log')
        and c.relrowsecurity and c.relforcerowsecurity
    ),
    'anon_effective_privilege_tables',(
      select count(*) from pg_class c join pg_namespace n on n.oid=c.relnamespace
      where n.nspname='public' and c.relkind='r'
        and c.relname in ('brain_founders','brain_tasks','brain_agents','brain_memory',
          'brain_approvals','brain_settings','brain_audit_log')
        and (
          has_table_privilege('anon',c.oid,'SELECT') or
          has_table_privilege('anon',c.oid,'INSERT') or
          has_table_privilege('anon',c.oid,'UPDATE') or
          has_table_privilege('anon',c.oid,'DELETE') or
          has_table_privilege('anon',c.oid,'TRUNCATE') or
          has_table_privilege('anon',c.oid,'REFERENCES') or
          has_table_privilege('anon',c.oid,'TRIGGER')
        )
    ),
    'founder_authenticated_write_privileges',jsonb_build_object(
      'insert',has_table_privilege('authenticated','public.brain_founders','INSERT'),
      'update',has_table_privilege('authenticated','public.brain_founders','UPDATE'),
      'delete',has_table_privilege('authenticated','public.brain_founders','DELETE'),
      'truncate',has_table_privilege('authenticated','public.brain_founders','TRUNCATE')
    ),
    'audit_authenticated_forbidden_privileges',jsonb_build_object(
      'update',has_table_privilege('authenticated','public.brain_audit_log','UPDATE'),
      'delete',has_table_privilege('authenticated','public.brain_audit_log','DELETE'),
      'truncate',has_table_privilege('authenticated','public.brain_audit_log','TRUNCATE')
    ),
    'audit_authenticated_required_privileges',jsonb_build_object(
      'select',has_table_privilege('authenticated','public.brain_audit_log','SELECT'),
      'insert',has_table_privilege('authenticated','public.brain_audit_log','INSERT')
    )
  ),
  'private_schema',jsonb_build_object(
    'exists',exists(select 1 from pg_namespace where nspname='private'),
    'anon_usage',coalesce(has_schema_privilege('anon','private','USAGE'),false),
    'authenticated_usage',coalesce(has_schema_privilege('authenticated','private','USAGE'),false)
  )
)) as cashup_brain_complete_check;
