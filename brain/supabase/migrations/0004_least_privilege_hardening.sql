-- CASHUP BRAIN — hardening dei privilegi e delle policy
-- Eseguire solo dopo revisione e verifica di 0001, 0002 e 0003.
-- Non abilita agenti, automazioni, pagamenti o accessi esterni.
-- Rende esplicito il principio del privilegio minimo sulle sole tabelle brain_*.

begin;

-- Rimuove ogni policy preesistente sulle sole tabelle BRAIN, incluse eventuali
-- policy permissive aggiunte in seguito da configurazioni non previste.
do $
declare
  r record;
begin
  for r in
    select schemaname, tablename, policyname
    from pg_policies
    where schemaname = 'public'
      and tablename in (
        'brain_founders','brain_tasks','brain_agents','brain_memory',
        'brain_approvals','brain_settings','brain_audit_log'
      )
  loop
    execute format('drop policy %I on %I.%I',
      r.policyname, r.schemaname, r.tablename);
  end loop;
end $;

-- Il registro fondatori è consultabile solo dall'utente autenticato sulla propria riga.
alter table public.brain_founders enable row level security;
alter table public.brain_founders force row level security;
drop policy if exists brain_founders_read_self on public.brain_founders;
create policy brain_founders_read_self
  on public.brain_founders for select
  to authenticated
  using (user_id = (select auth.uid()) and active = true);

revoke all on table public.brain_founders from public, anon, authenticated;
grant select on table public.brain_founders to authenticated;

-- Tutte le altre tabelle BRAIN: accesso solo al fondatore verificato da funzione privata.
do $$
declare
  t text;
begin
  foreach t in array array[
    'brain_tasks',
    'brain_agents',
    'brain_memory',
    'brain_approvals',
    'brain_settings'
  ]
  loop
    execute format('alter table public.%I enable row level security', t);
    execute format('alter table public.%I force row level security', t);
    execute format('revoke all on table public.%I from public, anon, authenticated', t);
    execute format('grant select, insert, update, delete on table public.%I to authenticated', t);
    execute format('drop policy if exists %I on public.%I', t || '_founder_all', t);
    execute format(
      'create policy %I on public.%I for all to authenticated using ((select private.brain_is_founder())) with check ((select private.brain_is_founder()))',
      t || '_founder_all', t
    );
  end loop;
end $$;

-- Audit append-only: lettura e inserimento per il fondatore; mai update/delete.
alter table public.brain_audit_log enable row level security;
alter table public.brain_audit_log force row level security;
revoke all on table public.brain_audit_log from public, anon, authenticated;
grant select, insert on table public.brain_audit_log to authenticated;

drop policy if exists brain_audit_log_founder_all on public.brain_audit_log;
drop policy if exists brain_audit_log_founder_read on public.brain_audit_log;
drop policy if exists brain_audit_log_founder_insert on public.brain_audit_log;
create policy brain_audit_log_founder_read
  on public.brain_audit_log for select
  to authenticated
  using ((select private.brain_is_founder()));
create policy brain_audit_log_founder_insert
  on public.brain_audit_log for insert
  to authenticated
  with check ((select private.brain_is_founder()));

commit;
