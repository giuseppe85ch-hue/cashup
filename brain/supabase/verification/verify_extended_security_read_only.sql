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
