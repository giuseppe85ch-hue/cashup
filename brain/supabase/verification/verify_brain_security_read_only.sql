-- CASHUP BRAIN — verifica sicurezza di sola lettura
-- Eseguire dopo le migrazioni 0001, 0002 e 0003 nel progetto corretto.
-- Non modifica dati, policy, permessi o impostazioni.

with expected_tables(table_name) as (
  values
    ('brain_founders'),
    ('brain_tasks'),
    ('brain_agents'),
    ('brain_memory'),
    ('brain_approvals'),
    ('brain_settings'),
    ('brain_audit_log')
)
select jsonb_pretty(jsonb_build_object(
  'tables', (
    select coalesce(jsonb_agg(jsonb_build_object(
      'table', e.table_name,
      'exists', c.oid is not null,
      'rls_enabled', coalesce(c.relrowsecurity, false),
      'force_rls', coalesce(c.relforcerowsecurity, false)
    ) order by e.table_name), '[]'::jsonb)
    from expected_tables e
    left join pg_namespace n on n.nspname = 'public'
    left join pg_class c on c.relnamespace = n.oid
      and c.relname = e.table_name and c.relkind = 'r'
  ),
  'policies', (
    select coalesce(jsonb_agg(jsonb_build_object(
      'table', tablename,
      'policy', policyname,
      'command', cmd,
      'roles', roles,
      'using', qual,
      'with_check', with_check
    ) order by tablename, policyname), '[]'::jsonb)
    from pg_policies
    where schemaname = 'public'
      and tablename like 'brain_%'
  ),
  'table_grants', (
    select coalesce(jsonb_agg(jsonb_build_object(
      'table', table_name,
      'grantee', grantee,
      'privilege', privilege_type
    ) order by table_name, grantee, privilege_type), '[]'::jsonb)
    from information_schema.role_table_grants
    where table_schema = 'public'
      and table_name like 'brain_%'
      and grantee in ('PUBLIC', 'anon', 'authenticated')
  ),
  'effective_table_privileges', (
    select coalesce(jsonb_agg(jsonb_build_object(
      'table', e.table_name,
      'anon_select', coalesce(has_table_privilege('anon', 'public.' || e.table_name, 'SELECT'), false),
      'anon_insert', coalesce(has_table_privilege('anon', 'public.' || e.table_name, 'INSERT'), false),
      'anon_update', coalesce(has_table_privilege('anon', 'public.' || e.table_name, 'UPDATE'), false),
      'anon_delete', coalesce(has_table_privilege('anon', 'public.' || e.table_name, 'DELETE'), false),
      'authenticated_select', coalesce(has_table_privilege('authenticated', 'public.' || e.table_name, 'SELECT'), false),
      'authenticated_insert', coalesce(has_table_privilege('authenticated', 'public.' || e.table_name, 'INSERT'), false),
      'authenticated_update', coalesce(has_table_privilege('authenticated', 'public.' || e.table_name, 'UPDATE'), false),
      'authenticated_delete', coalesce(has_table_privilege('authenticated', 'public.' || e.table_name, 'DELETE'), false)
    ) order by e.table_name), '[]'::jsonb)
    from expected_tables e
    where exists (
      select 1 from pg_class c
      join pg_namespace n on n.oid = c.relnamespace
      where n.nspname = 'public' and c.relname = e.table_name and c.relkind = 'r'
    )
  ),
  'private_schema', (
    select jsonb_build_object(
      'exists', n.oid is not null,
      'anon_can_use', coalesce(has_schema_privilege('anon', n.oid, 'USAGE'), false),
      'authenticated_can_use', coalesce(has_schema_privilege('authenticated', n.oid, 'USAGE'), false)
    )
    from (select oid from pg_namespace where nspname = 'private') n
    right join (select 1) seed on true
  ),
  'founder_check_function', (
    select jsonb_build_object(
      'exists', p.oid is not null,
      'schema', n.nspname,
      'security_definer', coalesce(p.prosecdef, false),
      'anon_can_execute', coalesce(has_function_privilege('anon', p.oid, 'EXECUTE'), false),
      'authenticated_can_execute', coalesce(has_function_privilege('authenticated', p.oid, 'EXECUTE'), false),
      'configuration', coalesce(to_jsonb(p.proconfig), '[]'::jsonb),
      'execute_grants', coalesce((
        select jsonb_agg(jsonb_build_object(
          'grantee', coalesce(r.rolname, 'PUBLIC'),
          'privilege', a.privilege_type
        ))
        from aclexplode(coalesce(p.proacl, acldefault('f', p.proowner))) a
        left join pg_roles r on r.oid = a.grantee
        where a.privilege_type = 'EXECUTE'
      ), '[]'::jsonb)
    )
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'private' and p.proname = 'brain_is_founder'
    limit 1
  ),
  'legacy_public_function_exists', (
    select exists (
      select 1 from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public' and p.proname = 'brain_is_founder'
    )
  )
)) as cashup_brain_security_verification;
