-- Applied to CASHUP Supabase project on 2026-11-19.
-- Additive player save tables. All rows are private to the authenticated owner.
create table if not exists public.player_game_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  game_id text not null check (game_id ~ '^[a-z0-9][a-z0-9._-]{1,79}$'),
  save_slot smallint not null default 1 check (save_slot between 1 and 10),
  progress jsonb not null default '{}'::jsonb
    check (jsonb_typeof(progress) = 'object' and octet_length(progress::text) <= 65536),
  level integer not null default 0 check (level >= 0),
  score bigint not null default 0 check (score >= 0),
  play_time_seconds bigint not null default 0 check (play_time_seconds >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, game_id, save_slot)
);
create table if not exists public.player_content_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  content_id text not null check (char_length(content_id) between 1 and 160),
  content_type text not null check (content_type in ('book','audiobook','video','course','recipe','music')),
  progress_percent numeric(5,2) not null default 0 check (progress_percent between 0 and 100),
  position_data jsonb not null default '{}'::jsonb
    check (jsonb_typeof(position_data) = 'object' and octet_length(position_data::text) <= 16384),
  completed boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, content_id, content_type)
);
create index if not exists player_game_progress_user_updated_idx
  on public.player_game_progress (user_id, updated_at desc);
create index if not exists player_content_progress_user_updated_idx
  on public.player_content_progress (user_id, updated_at desc);
alter table public.player_game_progress enable row level security;
alter table public.player_game_progress force row level security;
alter table public.player_content_progress enable row level security;
alter table public.player_content_progress force row level security;
create policy "Players read own game progress" on public.player_game_progress
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "Players insert own game progress" on public.player_game_progress
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Players update own game progress" on public.player_game_progress
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "Players delete own game progress" on public.player_game_progress
  for delete to authenticated using ((select auth.uid()) = user_id);
create policy "Players read own content progress" on public.player_content_progress
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "Players insert own content progress" on public.player_content_progress
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Players update own content progress" on public.player_content_progress
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "Players delete own content progress" on public.player_content_progress
  for delete to authenticated using ((select auth.uid()) = user_id);
revoke all on public.player_game_progress from anon;
revoke all on public.player_content_progress from anon;
grant select, insert, update, delete on public.player_game_progress to authenticated;
grant select, insert, update, delete on public.player_content_progress to authenticated;
