-- CASHUP BRAIN — hardening dei privilegi e delle policy (0004)
-- Applicata al progetto Supabase CASHUP.
-- Solo tabelle BRAIN e privilegi predefiniti degli oggetti creati da postgres in public.
-- Non modifica dati applicativi, non attiva agenti o automazioni.

begin;

-- Rimuove tutte le policy precedenti dalle sole sette tabelle BRAIN.
do $$
declare r record;
begin
  for r in
    select schemaname, tablename, policyname
    from pg_policies
    where schemaname='public'
      and tablename in ('brain_founders','brain_tasks','brain_agents','brain_memory',
                        'brain_approvals','brain_settings','brain_audit_log')
  loop
    execute format('drop policy %I on %I.%I',r.policyname,r.schemaname,r.tablename);
  end loop;
end $$;

-- Registro fondatori: sola lettura della propria riga attiva.
alter table public.brain_founders enable row level security;
alter table public.brain_founders force row level security;
create policy brain_founders_read_self
  on public.brain_founders for select to authenticated
  using (user_id=(select auth.uid()) and active=true);
revoke all on table public.brain_founders from public, anon, authenticated, service_role;
grant select on table public.brain_founders to authenticated;

-- Cinque tabelle operative: accesso solo al fondatore verificato.
do $$
declare t text;
begin
  foreach t in array array['brain_tasks','brain_agents','brain_memory','brain_approvals','brain_settings']
  loop
    execute format('alter table public.%I enable row level security',t);
    execute format('alter table public.%I force row level security',t);
    execute format('revoke all on table public.%I from public, anon, authenticated, service_role',t);
    execute format('grant select, insert, update, delete on table public.%I to authenticated',t);
    execute format(
      'create policy %I on public.%I for all to authenticated using ((select private.brain_is_founder())) with check ((select private.brain_is_founder()))',
      t||'_founder_all',t
    );
  end loop;
end $$;

-- Audit append-only.
alter table public.brain_audit_log enable row level security;
alter table public.brain_audit_log force row level security;
revoke all on table public.brain_audit_log from public, anon, authenticated, service_role;
grant select, insert on table public.brain_audit_log to authenticated;
create policy brain_audit_log_founder_read
  on public.brain_audit_log for select to authenticated
  using ((select private.brain_is_founder()));
create policy brain_audit_log_founder_insert
  on public.brain_audit_log for insert to authenticated
  with check ((select private.brain_is_founder()));

-- Default-deny per gli oggetti futuri creati dal ruolo postgres nello schema API public.
-- Gli oggetti esistenti non vengono modificati da ALTER DEFAULT PRIVILEGES.
alter default privileges for role postgres in schema public
  revoke all on tables from anon, authenticated, service_role;
alter default privileges for role postgres in schema public
  revoke all on sequences from anon, authenticated, service_role;
alter default privileges for role postgres in schema public
  revoke all on functions from anon, authenticated, service_role;
-- Le nuove funzioni non devono essere eseguibili da PUBLIC per impostazione predefinita.
alter default privileges for role postgres
  revoke execute on functions from public;

commit;
