-- CASHUP BRAIN — richiede MFA AAL2 anche nelle policy database (0006)
-- L'interfaccia non è l'unica barriera: la funzione RLS richiede un JWT AAL2.
-- Non modifica dati, agenti o impostazioni.

begin;

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
      and (select auth.jwt() ->> 'aal') = 'aal2'
  );
$$;

revoke all on function private.brain_is_founder() from public, anon, service_role;
grant execute on function private.brain_is_founder() to authenticated;

commit;
