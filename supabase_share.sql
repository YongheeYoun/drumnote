-- 드럼노트 2단계: 악보 주고받기 (선생님 → 학생 과제, 학생 → 선생님 제출)
-- Supabase SQL Editor에서 한 번 실행

-- 사용자 목록 (아이디로 상대를 찾기 위해). 가입/로그인 시 앱이 자기 행을 채움
create table if not exists public.dn_profiles (
  user_id     uuid primary key references auth.users(id) on delete cascade,
  username    text unique not null,
  name        text not null default '',
  created_at  timestamptz not null default now()
);
alter table public.dn_profiles enable row level security;
drop policy if exists "dn_profiles_read"   on public.dn_profiles;
drop policy if exists "dn_profiles_insert" on public.dn_profiles;
drop policy if exists "dn_profiles_update" on public.dn_profiles;
create policy "dn_profiles_read"   on public.dn_profiles for select to authenticated using (true);
create policy "dn_profiles_insert" on public.dn_profiles for insert to authenticated with check (auth.uid() = user_id);
create policy "dn_profiles_update" on public.dn_profiles for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 주고받은 악보
create table if not exists public.dn_shares (
  id           text primary key,
  from_user    uuid not null references auth.users(id) on delete cascade,
  to_user      uuid not null references auth.users(id) on delete cascade,
  kind         text not null default 'assign',   -- assign(과제) | submit(제출)
  title        text not null default '',
  note         text not null default '',
  data         jsonb not null,
  created_at   timestamptz not null default now(),
  accepted_at  timestamptz
);
create index if not exists dn_shares_to_idx   on public.dn_shares(to_user);
create index if not exists dn_shares_from_idx on public.dn_shares(from_user);
alter table public.dn_shares enable row level security;
drop policy if exists "dn_shares_insert" on public.dn_shares;
drop policy if exists "dn_shares_read"   on public.dn_shares;
drop policy if exists "dn_shares_update" on public.dn_shares;
drop policy if exists "dn_shares_delete" on public.dn_shares;
create policy "dn_shares_insert" on public.dn_shares for insert to authenticated with check (auth.uid() = from_user);
create policy "dn_shares_read"   on public.dn_shares for select to authenticated using (auth.uid() = from_user or auth.uid() = to_user);
create policy "dn_shares_update" on public.dn_shares for update to authenticated using (auth.uid() = to_user) with check (auth.uid() = to_user);
create policy "dn_shares_delete" on public.dn_shares for delete to authenticated using (auth.uid() = from_user or auth.uid() = to_user);
