-- CASHUP — ottimizzazione RLS e indici FK (0005)
-- Applicata al progetto Supabase CASHUP.
-- Nessuna modifica ai dati; mantiene invariati i criteri di accesso.
begin;

alter policy clicks_read_own on public.affiliate_clicks
  using ((select auth.uid()) = user_id);
alter policy commissions_read_own on public.commissions
  using ((select auth.uid()) = user_id);
alter policy steps_insert_demo_own on public.daily_steps
  with check ((select auth.uid()) = user_id and status = 'pending' and source = 'demo');
alter policy steps_read_own on public.daily_steps
  using ((select auth.uid()) = user_id);
alter policy ledger_read_own on public.points_ledger
  using ((select auth.uid()) = user_id);
alter policy profile_insert_own on public.profiles
  with check ((select auth.uid()) = id);
alter policy profile_read_own on public.profiles
  using ((select auth.uid()) = id);
alter policy profile_update_own on public.profiles
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

create index if not exists idx_affiliate_clicks_user_id
  on public.affiliate_clicks(user_id);
create index if not exists idx_brain_approvals_decided_by
  on public.brain_approvals(decided_by);
create index if not exists idx_brain_approvals_requested_by
  on public.brain_approvals(requested_by);
create index if not exists idx_brain_audit_log_actor_user_id
  on public.brain_audit_log(actor_user_id);
create index if not exists idx_brain_memory_created_by
  on public.brain_memory(created_by);
create index if not exists idx_brain_settings_updated_by
  on public.brain_settings(updated_by);
create index if not exists idx_brain_tasks_created_by
  on public.brain_tasks(created_by);
create index if not exists idx_commissions_click_ref
  on public.commissions(click_ref);
create index if not exists idx_commissions_user_id
  on public.commissions(user_id);

commit;
