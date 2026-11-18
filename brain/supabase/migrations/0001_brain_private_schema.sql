-- CASHUP BRAIN — schema iniziale privato
-- ATTENZIONE: questo file NON viene eseguito automaticamente.
-- Eseguirlo solo nel progetto Supabase CASHUP corretto, dopo revisione.

begin;

create table if not exists public.brain_founders (
  user_id uuid primary key references auth.users(id) on delete cascade,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.brain_founders enable row level security;
alter table public.brain_founders force row level security;

-- Il fondatore può vedere soltanto la propria autorizzazione.
drop policy if exists brain_founders_read_self on public.brain_founders;
create policy brain_founders_read_self
  on public.brain_founders for select
  to authenticated
  using (user_id = auth.uid() and active = true);

revoke all on public.brain_founders from anon, authenticated;
grant select on public.brain_founders to authenticated;

create or replace function public.brain_is_founder()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.brain_founders f
    where f.user_id = auth.uid()
      and f.active = true
  );
$$;

revoke all on function public.brain_is_founder() from public, anon;
grant execute on function public.brain_is_founder() to authenticated;

create table if not exists public.brain_tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null default '',
  status text not null default 'pending'
    check (status in ('pending','in_progress','blocked','done','cancelled')),
  priority text not null default 'normal'
    check (priority in ('low','normal','high','urgent')),
  sector text not null default 'core',
  due_at timestamptz,
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.brain_agents (
  id uuid primary key default gen_random_uuid(),
  agent_key text not null unique,
  display_name text not null,
  description text not null default '',
  status text not null default 'planned'
    check (status in ('planned','disabled','testing','active','paused')),
  permission_level text not null default 'read_only'
    check (permission_level in ('read_only','limited','approval_required')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.brain_memory (
  id uuid primary key default gen_random_uuid(),
  category text not null,
  title text not null,
  content text not null,
  source text not null default 'founder',
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.brain_approvals (
  id uuid primary key default gen_random_uuid(),
  action_type text not null,
  description text not null,
  risk_level text not null default 'high'
    check (risk_level in ('medium','high','critical')),
  status text not null default 'pending'
    check (status in ('pending','approved','rejected','executed','expired')),
  requested_by uuid not null default auth.uid() references auth.users(id),
  decided_by uuid references auth.users(id),
  decision_note text not null default '',
  created_at timestamptz not null default now(),
  decided_at timestamptz
);

create table if not exists public.brain_settings (
  setting_key text primary key,
  setting_value jsonb not null,
  description text not null default '',
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now()
);

create table if not exists public.brain_audit_log (
  id bigint generated always as identity primary key,
  actor_user_id uuid references auth.users(id),
  actor_type text not null default 'founder'
    check (actor_type in ('founder','agent','system')),
  action text not null,
  object_type text not null,
  object_id text,
  outcome text not null default 'recorded',
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- RLS: nessun dato BRAIN è accessibile agli utenti ordinari.
do $$
declare
  t text;
begin
  foreach t in array array[
    'brain_tasks',
    'brain_agents',
    'brain_memory',
    'brain_approvals',
    'brain_settings',
    'brain_audit_log'
  ]
  loop
    execute format('alter table public.%I enable row level security', t);
    execute format('alter table public.%I force row level security', t);
    execute format('drop policy if exists %I on public.%I', t || '_founder_all', t);
    execute format(
      'create policy %I on public.%I for all to authenticated using (public.brain_is_founder()) with check (public.brain_is_founder())',
      t || '_founder_all', t
    );
    execute format('revoke all on public.%I from anon', t);
    execute format('grant select, insert, update, delete on public.%I to authenticated', t);
  end loop;
end $$;

-- Il registro attività è consultabile e append-only: niente update/delete per il fondatore.
drop policy if exists brain_audit_log_founder_all on public.brain_audit_log;
create policy brain_audit_log_founder_read
  on public.brain_audit_log for select
  to authenticated
  using (public.brain_is_founder());
create policy brain_audit_log_founder_insert
  on public.brain_audit_log for insert
  to authenticated
  with check (public.brain_is_founder());
revoke update, delete on public.brain_audit_log from authenticated;

commit;
