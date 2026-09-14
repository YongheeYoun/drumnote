-- 드럼노트 3단계: 이름으로 로그인 (아이디 변경 가능하게 내부 식별자와 분리)
-- Supabase SQL Editor에서 한 번 실행

alter table public.dn_profiles add column if not exists login_email text;
alter table public.dn_profiles add column if not exists avatar text;

-- 이미 있는 계정(선생님 등)의 로그인 키 채우기
update public.dn_profiles p
   set login_email = u.email
  from auth.users u
 where u.id = p.user_id and p.login_email is null;

-- 로그인 화면(비로그인 상태)에서 이름 → 로그인 키 조회. 이름이 정확히 일치할 때만 답함
create or replace function public.dn_login_email(uname text)
returns text
language sql
security definer
stable
set search_path = public
as $$
  select login_email from public.dn_profiles where username = uname limit 1;
$$;
grant execute on function public.dn_login_email(text) to anon, authenticated;
