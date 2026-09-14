-- 드럼노트 클라우드 저장용 테이블 (Supabase SQL Editor에서 한 번 실행)
-- 아이디/핀번호 로그인은 Supabase Auth(이메일: 아이디@drumnote.app)로 처리되므로
-- 사용자 테이블은 따로 필요 없습니다. 악보만 저장합니다.

create table if not exists public.dn_scores (
  id          text primary key,
  user_id     uuid not null references auth.users(id) on delete cascade,
  title       text not null default '',
  data        jsonb not null,
  updated_at  timestamptz not null default now()
);

create index if not exists dn_scores_user_idx on public.dn_scores(user_id);

alter table public.dn_scores enable row level security;

-- 본인 악보만 읽고 쓰고 지울 수 있음
drop policy if exists "dn_scores_own" on public.dn_scores;
create policy "dn_scores_own" on public.dn_scores
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- ─────────────────────────────────────────────
-- 그리고 대시보드에서 아래 설정을 꼭 바꿔 주세요:
--   Authentication → Providers → Email → "Confirm email" 을 OFF
--   (아이디@drumnote.app 은 실제 메일이 아니라 인증 메일을 받을 수 없습니다)
-- ─────────────────────────────────────────────
