-- CASHUP — least privilege for application tables (0007)
-- Revoke unused dangerous privileges and enforce RLS for table owners.
-- Preserve only the operations currently required by the CASHUP prototype.
begin;

alter table public.profiles enable row level security;
alter table public.profiles force row level security;
alter table public.daily_steps enable row level security;
alter table public.daily_steps force row level security;
alter table public.points_ledger enable row level security;
alter table public.points_ledger force row level security;
alter table public.affiliate_clicks enable row level security;
alter table public.affiliate_clicks force row level security;
alter table public.commissions enable row level security;
alter table public.commissions force row level security;

revoke all on table public.profiles, public.daily_steps, public.points_ledger,
  public.affiliate_clicks, public.commissions from anon;

revoke all on table public.profiles, public.daily_steps, public.points_ledger,
  public.affiliate_clicks, public.commissions from authenticated;

grant select, insert, update on table public.profiles to authenticated;
grant select, insert on table public.daily_steps to authenticated;
grant select on table public.points_ledger to authenticated;
grant select on table public.affiliate_clicks to authenticated;
grant select on table public.commissions to authenticated;

revoke truncate, references, trigger on table public.profiles, public.daily_steps,
  public.points_ledger, public.affiliate_clicks, public.commissions
  from anon, authenticated, service_role;

commit;
