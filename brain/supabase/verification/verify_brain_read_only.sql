-- CASHUP BRAIN — verifica di sola lettura
-- Eseguire nel progetto Supabase CASHUP dopo le migrazioni 0001 e 0002.
-- Questa query NON modifica dati, policy o impostazioni.

with expected_agents(agent_key) as (
  values
    ('orchestrator'),
    ('engineering'),
    ('security'),
    ('finance'),
    ('growth'),
    ('support'),
    ('operations'),
    ('compliance')
),
expected_settings(setting_key) as (
  values
    ('autonomy_enabled'),
    ('require_human_approval_for_high_risk'),
    ('require_human_approval_for_financial_actions'),
    ('max_automated_spend_eur'),
    ('emergency_stop')
)
select jsonb_pretty(jsonb_build_object(
  'agents_total', (select count(*) from public.brain_agents),
  'expected_agents_missing', (
    select coalesce(jsonb_agg(e.agent_key order by e.agent_key), '[]'::jsonb)
    from expected_agents e
    where not exists (
      select 1 from public.brain_agents a where a.agent_key = e.agent_key
    )
  ),
  'agents_active', (
    select coalesce(jsonb_agg(agent_key order by agent_key), '[]'::jsonb)
    from public.brain_agents where status = 'active'
  ),
  'settings_missing', (
    select coalesce(jsonb_agg(e.setting_key order by e.setting_key), '[]'::jsonb)
    from expected_settings e
    where not exists (
      select 1 from public.brain_settings s where s.setting_key = e.setting_key
    )
  ),
  'settings_values', (
    select coalesce(jsonb_object_agg(setting_key, setting_value), '{}'::jsonb)
    from public.brain_settings
    where setting_key in (
      'autonomy_enabled',
      'require_human_approval_for_high_risk',
      'require_human_approval_for_financial_actions',
      'max_automated_spend_eur',
      'emergency_stop'
    )
  ),
  'rls_tables', (
    select coalesce(jsonb_object_agg(c.relname, jsonb_build_object(
      'rls_enabled', c.relrowsecurity,
      'force_rls', c.relforcerowsecurity
    ) order by c.relname), '{}'::jsonb)
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind = 'r'
      and c.relname in (
        'brain_founders',
        'brain_tasks',
        'brain_agents',
        'brain_memory',
        'brain_approvals',
        'brain_settings',
        'brain_audit_log'
      )
  )
)) as cashup_brain_verification;
