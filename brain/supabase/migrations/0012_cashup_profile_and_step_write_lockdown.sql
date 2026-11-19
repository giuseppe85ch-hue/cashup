-- CASHUP — prevent client-side step spoofing and limit profile writes (0012)
-- Real step ingestion is not active yet. Until a trusted server-side verification flow exists,
-- browser clients must not create step records. Profile clients may only set their own display_name.

begin;

-- Profiles: id is insert-only and must match auth.uid() through RLS; created_at is DB-managed.
revoke insert, update on table public.profiles from public, anon, authenticated, service_role;
grant insert (id, display_name) on table public.profiles to authenticated;
grant update (display_name) on table public.profiles to authenticated;

alter table public.profiles
  add constraint profiles_display_name_valid_check
  check (
    display_name is null
    or (
      pg_catalog.btrim(display_name) <> ''
      and pg_catalog.char_length(display_name) <= 80
    )
  );

-- Step data cannot be submitted/fabricated by the browser. Enable writes only after
-- integrating a server-verified HealthKit / Health Connect ingestion path.
revoke insert on table public.daily_steps from public, anon, authenticated, service_role;
drop policy if exists steps_insert_demo_own on public.daily_steps;

commit;