# 드럼노트

드럼 전용 악보 편집기. 아이디·핀번호로 들어가면 어느 기기에서든 내 악보가 보입니다.

## 파일

| 파일 | 역할 |
|---|---|
| `index.html` | 앱 본체 (로그인 · 홈 갤러리 · 편집기 · 재생) |
| `config.js` | Supabase 연결정보 (URL · publishable 키). 비워두면 로그인 없이 "이 기기에만 저장" 모드 |
| `supabase.js` | Supabase 클라이언트 (로컬 복사본) |
| `supabase_setup.sql` | Supabase에서 한 번 실행할 테이블·권한 설정 |
| `manifest.webmanifest`, `icon-*.png`, `icon.svg` | 홈 화면 추가용 이름·아이콘 |

## 처음 설정 (1회, 약 10분)

### 1. Supabase 프로젝트
1. https://supabase.com → New project (무료). 이름은 `drumnote` 등 아무거나.
2. **SQL Editor** → `supabase_setup.sql` 내용을 붙여넣고 Run.
3. **Authentication → Providers → Email** → `Confirm email` **OFF** → Save.
4. **Project Settings → API** 에서 `Project URL` 과 `publishable (anon) key` 복사.

### 2. config.js 에 붙여넣기
```js
window.DRUMNOTE_CONFIG = {
  url: 'https://xxxx.supabase.co',
  key: 'sb_publishable_xxxx'
};
```

### 3. GitHub → Cloudflare Pages
1. GitHub에 비공개 저장소 `drumnote` 생성 → 이 폴더의 파일을 전부 업로드.
2. Cloudflare → Workers & Pages → Create → Pages → **Connect to Git** → `drumnote` 선택.
   - Framework preset: None / Build command: 비움 / Output directory: `/`
3. `https://drumnote.pages.dev` 같은 주소가 생기면 그걸 학생들에게 공유.

이후 수정은 GitHub에 파일만 다시 올리면 자동 배포됩니다.

## 학생에게 안내할 내용

1. 주소 열기 → **가입하기** → 아이디(영문·숫자)·이름·핀번호(숫자 4~6자리) → 시작
2. Safari 공유 → **홈 화면에 추가** 하면 앱처럼 열림
3. 같은 아이디·핀번호로 폰·아이패드 어디서든 같은 악보

핀번호를 잊으면 선생님이 Supabase → Authentication → Users 에서 해당 계정을 지우고 다시 가입하게 하면 됩니다. (악보는 계정과 함께 삭제됩니다)

## 동작 방식

- 악보는 기기(localStorage)에 먼저 저장되고 1초 뒤 클라우드로 올라갑니다. 오프라인이어도 편집되고, 다시 연결되면 자동으로 올라갑니다.
- 같은 악보를 두 기기에서 고쳤으면 **더 나중에 저장한 쪽**이 남습니다.
- 다른 기기에서 지운 악보는 이 기기에 남아 있으면 다시 올라갈 수 있습니다. 지울 때는 한 기기에서만 지우세요.

## 키보드 (아이패드 키보드 연결 시)

| 키 | 동작 |
|---|---|
| Space | 재생 / 정지 |
| ← → | 이전 / 다음 음표 |
| 1 ~ 6 | 온음표 ~ 32분음표 |
| Backspace | 음표 지우기 (쉼표로) |
| Cmd+Z / Cmd+Shift+Z | 실행 취소 / 다시 실행 |
