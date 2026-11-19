-- CASHUP BRAIN — extended read-only security audit
-- Run only in the intended Supabase project. This query makes no changes.
select json_build_object(
  'public_tables', (
    select coalesce(json_agg(json_build_object(
      'table', c.relname,
      'rls_enabled', c.relrowsecurity,
      'force_rls', c.relforcerowsecurity
    ) order by c.relname), '[]'::json)
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r'
  ),
  'anon_table_grants', (
    select coalesce(json_agg(json_build_object(
      'table', table_name, 'privilege', privilege_type
    ) order by table_name, privilege_type), '[]'::json)
    from information_schema.role_table_grants
    where table_schema = 'public' and grantee = 'anon'
  ),
  'public_views', (
    select coalesce(json_agg(json_build_object(
      'name', c.relname, 'kind', c.relkind, 'owner', r.rolname,
      'options', c.reloptions
    ) order by c.relname), '[]'::json)
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    join pg_roles r on r.oid = c.relowner
    where n.nspname = 'public' and c.relkind in ('v', 'm')
  ),
  'public_functions', (
    select coalesce(json_agg(json_build_object(
      'name', p.proname, 'owner', r.rolname,
      'security_definer', p.prosecdef,
      'config', p.proconfig,
      'anon_execute', has_function_privilege('anon', p.oid, 'EXECUTE'),
      'authenticated_execute', has_function_privilege('authenticated', p.oid, 'EXECUTE')
    ) order by p.proname), '[]'::json)
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    join pg_roles r on r.oid = p.proowner
    where n.nspname = 'public'
  ),
  'brain_triggers', (
    select coalesce(json_agg(json_build_object(
      'table', t.tgrelid::regclass::text,
      'trigger', t.tgname,
      'function', t.tgfoid::regprocedure::text,
      'enabled', t.tgenabled
    ) order by t.tgrelid::regclass::text, t.tgname), '[]'::json)
    from pg_trigger t
    join pg_class c on c.oid = t.tgrelid
    join pg_namespace n on n.oid = c.relnamespace
    where not t.tgisinternal
      and n.nspname = 'public' and c.relname like 'brain_%'
  ),
  'brain_anti_forgery', json_build_object(
    'authenticated_task_table_insert', has_table_privilege('authenticated','public.brain_tasks','INSERT'),
    'authenticated_task_insert_title', has_column_privilege('authenticated','public.brain_tasks','title','INSERT'),
    'authenticated_task_insert_description', has_column_privilege('authenticated','public.brain_tasks','description','INSERT'),
    'authenticated_task_insert_priority', has_column_privilege('authenticated','public.brain_tasks','priority','INSERT'),
    'authenticated_task_insert_status', has_column_privilege('authenticated','public.brain_tasks','status','INSERT'),
    'authenticated_task_insert_sector', has_column_privilege('authenticated','public.brain_tasks','sector','INSERT'),
    'authenticated_task_insert_created_by', has_column_privilege('authenticated','public.brain_tasks','created_by','INSERT'),
    'authenticated_audit_insert', has_table_privilege('authenticated','public.brain_audit_log','INSERT'),
    'task_rpc_security_definer', (select prosecdef from pg_proc where oid='public.brain_create_task(text,text,text)'::regprocedure),
    'task_rpc_search_path_empty', (select coalesce(proconfig @> array['search_path=""'],false) from pg_proc where oid='public.brain_create_task(text,text,text)'::regprocedure),
    'task_rpc_anon_execute', has_function_privilege('anon','public.brain_create_task(text,text,text)','EXECUTE'),
    'task_rpc_authenticated_execute', has_function_privilege('authenticated','public.brain_create_task(text,text,text)','EXECUTE'),
    'audit_insert_policy_count', (select count(*) from pg_policies where schemaname='public' and tablename='brain_audit_log' and cmd='INSERT'),
    'task_insert_policy_count', (select count(*) from pg_policies where schemaname='public' and tablename='brain_tasks' and cmd='INSERT'),
    'task_update_delete_policy_count', (select count(*) from pg_policies where schemaname='public' and tablename='brain_tasks' and cmd in ('UPDATE','DELETE','ALL'))
  ),
  'cashup_app_write_lockdown', json_build_object(
    'daily_steps_insert', has_table_privilege('authenticated','public.daily_steps','INSERT'),
    'daily_steps_select', has_table_privilege('authenticated','public.daily_steps','SELECT'),
    'daily_steps_insert_policy_count', (select count(*) from pg_policies where schemaname='public' and tablename='daily_steps' and cmd='INSERT'),
    'profiles_insert_id', has_column_privilege('authenticated','public.profiles','id','INSERT'),
    'profiles_insert_display_name', has_column_privilege('authenticated','public.profiles','display_name','INSERT'),
    'profiles_insert_created_at', has_column_privilege('authenticated','public.profiles','created_at','INSERT'),
    'profiles_update_display_name', has_column_privilege('authenticated','public.profiles','display_name','UPDATE'),
    'profiles_update_id', has_column_privilege('authenticated','public.profiles','id','UPDATE'),
    'profiles_update_created_at', has_column_privilege('authenticated','public.profiles','created_at','UPDATE'),
    'points_ledger_insert', has_table_privilege('authenticated','public.points_ledger','INSERT'),
    'affiliate_clicks_insert', has_table_privilege('authenticated','public.affiliate_clicks','INSERT'),
    'commissions_insert', has_table_privilege('authenticated','public.commissions','INSERT')
  ),
  'brain_client_privileges', (
    select coalesce(json_agg(json_build_object(
      'table', table_name, 'grantee', grantee, 'privilege', privilege_type
    ) order by table_name, grantee, privilege_type), '[]'::json)
    from information_schema.role_table_grants
    where table_schema = 'public' and table_name like 'brain_%'
      and grantee in ('anon', 'authenticated', 'service_role')
  ),
  'public_security_definer_functions', (
    select coalesce(json_agg(json_build_object(
      'name', p.proname, 'owner', r.rolname,
      'search_path', p.proconfig,
      'anon_execute', has_function_privilege('anon', p.oid, 'EXECUTE')
    ) order by p.proname), '[]'::json)
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    join pg_roles r on r.oid = p.proowner
    where n.nspname = 'public' and p.prosecdef
  ),
  'supabase_admin_owned_public_objects', (
    select coalesce(json_agg(json_build_object(
      'name', c.relname, 'kind', c.relkind
    ) order by c.relname), '[]'::json)
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    join pg_roles r on r.oid = c.relowner
    where n.nspname = 'public' and r.rolname = 'supabase_admin'
  ),
  'postgres_default_privileges', (
    select coalesce(json_agg(json_build_object(
      'object_type', d.defaclobjtype, 'acl', d.defaclacl::text
    ) order by d.defaclobjtype), '[]'::json)
    from pg_default_acl d
    join pg_roles r on r.oid = d.defaclrole
    join pg_namespace n on n.oid = d.defaclnamespace
    where r.rolname = 'postgres' and n.nspname = 'public'
  ),
  'storage_buckets', (
    select coalesce(json_agg(json_build_object(
      'id', id, 'public', public
    ) order by id), '[]'::json)
    from storage.buckets
  ),
  'verified_mfa_factors', (
    select count(*) from auth.mfa_factors where status = 'verified'
  ),
  'registered_passkeys', (
    select count(*) from auth.webauthn_credentials
  )
) as extended_security_audit;
