# Ch005 · H3 — Git 협업 워크플로: 환경점검 — 팀 GitHub 셋업

> **이 H에서 얻을 것**
> - GitHub Organization·Team·Repository 셋의 관계 — 개인 계정과 무엇이 다른가, 자경단을 왜 Organization으로 옮겨야 하는가
> - Branch protection rule 7체크 깊이 — `main`을 사람과 시간으로부터 지키는 도구의 한 면 한 면
> - CODEOWNERS의 글로브 패턴·복수 owner·우선순위·`.github/` 위치 — 자경단 5명을 파일 경로로 나누는 한 장
> - Conventional Commits + commitlint + husky pre-commit hook — 합의를 도구가 평생 기억하게 만드는 셋업 30분
> - PAT·SSH 키·deploy key·fine-grained token — 협업 환경에서 비밀의 종류와 각각의 자리

---

## 회수: H2의 이론에서 본 H의 셋업으로

지난 H2에서 본인은 세 패턴(GitHub Flow·Git Flow·Trunk-based)의 깊이를 봤어요. branch 모델, release vs deploy, 환경 셋(dev·staging·prod)까지. 한 페이지 표로 셋이 다 들어왔고, 자경단의 답은 GitHub Flow + dev/prod 둘 환경 + PR preview가 staging 역할이었어요.

이번 H3는 **그 이론을 GitHub 화면에 박는 시간**이에요. 본인이 H2에서 결정한 8개 답(패턴·branch 모델·release·deploy·hotfix·환경·feature flag·release vs deploy)을 GitHub의 organization 설정·branch protection·CODEOWNERS·commitlint·husky 5개 도구에 한 줄씩 박는 30분 셋업. **합의가 도구로 옮겨가는 한 시간**이에요.

지난 Ch004의 H3은 본인 노트북의 git 설치·config·SSH 키였죠. 그건 1인용 셋업. 이번 H3는 **5명용 셋업**이에요. 1명이 5명이 되면 셋업이 어떻게 바뀌는지 — `git config --global` 7줄이 organization·team·protected branch·CODEOWNERS·commitlint·husky 30줄로 늘어나요. 늘어난 23줄이 협업의 안전장치예요. 지금부터 한 줄씩 박아 봐요.

---

## 1. 개인 계정 vs Organization — 자경단을 어디에 둘까

GitHub엔 두 종류의 "주체"가 있어요. **Personal account**(개인 계정)과 **Organization**(조직 계정). 본인이 지금까지 쓴 `github.com/mo`는 Personal. 자경단 5명이 함께 일하려면 `github.com/cat-vigilante` 같은 Organization을 새로 파야 해요.

**왜 옮기나** — Personal account의 repo는 한 사람이 owner. 다른 사람을 collaborator로 초대할 순 있지만 **권한 단순**(Read/Write 둘)이고 **결제도 한 사람**. 자경단 5명이 함께 진짜로 일하면 5분 안에 한계가 와요. 까미한테 백엔드만 권한 주고, 노랭이한테 프론트만, 미니한테 인프라만 — 이런 권한 분리가 안 돼요. 결제도 분리 안 되고요.

**Organization**으로 옮기면 — repo 여러 개를 한 우산 아래. team 여러 개로 쪼개기. 권한 5단계로 정밀 분리. billing 따로. owner 여러 명. audit log(누가 언제 무엇을 했나). SSO(나중에 회사 되면). 이 7가지가 자경단 5명이 일주일만 함께 일해 봐도 필요해져요.

**비용** — 자경단처럼 오픈소스(public repo)면 **Organization 무료**. private repo도 무료(다만 일부 고급 기능은 Team plan $4/user/month). 자경단은 일단 public + 무료로 시작. 5명 무료 + 모든 기능 → 1년쯤 운영해 보고 필요시 유료 옮김.

**organization 만들기 5단계** — github.com 우상단 + → "New organization" → Free plan 선택 → org 이름(`cat-vigilante`) + 본인 이메일 → 멤버 5명 초대 (이메일·GitHub 핸들). 5분 끝.

**도메인 이름 비유** — Personal account는 본인 이름의 명함. Organization은 자경단의 회사 명함. 회사가 되면 명함이 바뀌듯, 자경단이 5명이 되면 GitHub도 회사 명함으로 바뀌어야 해요. **명함이 협업의 첫 도구**.

본인의 자경단도 처음 1주일은 `github.com/mo/cat-vigilante` 같은 personal repo로 시작해도 OK. 다만 까미가 합류하는 순간 organization으로 옮기는 게 정답. 옮기는 건 GitHub 메뉴에서 "Transfer ownership" 한 번. 5분.

---

## 2. Team — 5명을 어떻게 묶나

Organization 안에 여러 **team**을 만들 수 있어요. team은 사람들의 묶음. 각 team은 권한과 접근 범위를 따로 가져요.

**자경단 team 셋업 (표준 5팀)**:

| Team | 멤버 | 책임 영역 | 기본 권한 |
|------|------|----------|----------|
| `@cat-vigilante/maintainers` | 본인 | 전체 메인테이너, 모든 PR 1차 리뷰, release | Admin |
| `@cat-vigilante/backend` | 까미 | `/backend/`, FastAPI, DB | Write (백엔드 repo만) |
| `@cat-vigilante/frontend` | 노랭이 | `/frontend/`, React, TS | Write (프론트 repo만) |
| `@cat-vigilante/infra` | 미니 | `/infra/`, `.github/`, Terraform, AWS | Write (전체) + Admin (.github) |
| `@cat-vigilante/design-qa` | 깜장이 | `/design/`, `/qa/`, Figma, 테스트 | Write (design·qa만) + Read (전체) |

team 이름 컨벤션 — kebab-case 영어. `@org/team-name` 형식으로 PR·issue·CODEOWNERS에서 mention 가능. 팀 mention 한 번 = 그 팀의 모든 사람이 알림.

**Nested team**(team 안에 team) 가능 — 큰 회사는 `@company/engineering` 안에 `@company/engineering/backend`·`@company/engineering/frontend` 식으로 트리. 자경단 5명은 평면 1층으로 충분. nested는 50명+부터.

**team 권한 vs 개인 권한** — team 권한이 기본, 개인 권한이 덧붙음. 까미가 backend team의 Write를 받고, 추가로 특정 repo의 Admin을 따로 받을 수도. 권한은 **합집합**. 가장 넓은 권한이 적용.

**team 만들기 3단계** — Organization 페이지 → Teams 탭 → New team. 이름·설명·visibility(visible vs secret) → 멤버 초대. 끝. 30초.

**자경단 첫 주 시뮬레이션** — 본인이 organization 만들고 maintainers team부터. 까미·노랭이·미니·깜장이를 각자 team에 초대. 4명이 이메일로 invite 받음 → GitHub에서 accept → 자기 team의 repo 접근 가능. 첫 PR이 30분 안에. **team은 협업의 첫 합의를 도구로 박는 한 줄**.

---

## 3. Repository 권한 5단계 — 누가 무엇을 할 수 있나

team 또는 개인에게 repository 권한을 줄 때 GitHub은 5단계 중 하나를 골라요:

| 단계 | 할 수 있는 것 | 할 수 없는 것 | 자경단 누가 |
|------|-------------|--------------|-----------|
| **Read** | clone·pull·issue 읽기·PR 읽기 | push·머지·issue 만들기 | (없음) |
| **Triage** | Read + issue/PR 라벨·assignee·close | push·머지 | 외부 contributor (옵션) |
| **Write** | Triage + push·branch 만들기·PR 머지(보호 안 된 branch) | repo 설정·다른 팀원 추가 | 까미·노랭이·미니·깜장이 |
| **Maintain** | Write + repo 일부 설정(branch protection 제외)·release 만들기 | 결제·삭제·org 설정 | (자경단은 안 씀, 큰 팀에서 유용) |
| **Admin** | 전부. branch protection·삭제·secret 관리 | (없음) | 본인 |

**Triage**는 2018년에 추가된 단계 — 외부 contributor가 issue/PR 정리만 하고 push는 못 하는 자리. 오픈소스 프로젝트가 자주 활용. 자경단도 길고양이 사진 신고만 하는 외부 분이 있다면 Triage로 초대.

**황금 규칙 — 최소 권한** — 까미는 backend Write만 충분. 굳이 Admin 안 줘도 PR 작업·머지(보호 안 된 branch)·issue 다 가능. Admin은 본인 한 사람. **Admin이 많으면 사고 위험**. 자경단 첫 1년은 Admin 1명이 정답.

**권한 분리의 첫 사고 시나리오** — 6개월 후 까미가 Admin을 갖고 있는데 실수로 main에 force-push. 5명이 다같이 한 시간 동안 reflog로 복원. 만약 까미가 Write만 갖고 있었다면 main(보호된)에 force-push 자체가 거부 → 사고 안 일어남. **권한 한 단계가 사고 한 시간을 막아요**.

**권한 부여 흐름** — repo Settings → Collaborators and teams → Add team or person → 권한 5단계 선택 → Add. 30초. 잘못 줬으면 같은 화면에서 변경.

---

## 4. Branch Protection Rule 7체크 — main을 지키는 7장의 자물쇠

자경단의 `main`은 사용자가 보는 코드. **`main`이 한 번 깨지면 사용자 사이트가 깨져요**. 그래서 GitHub는 main에 7장의 자물쇠를 채울 수 있게 해 줘요.

repo Settings → Branches → Branch protection rules → Add rule → Branch name pattern: `main` → 아래 7체크박스를 한 칸씩.

### 4-1. 체크 1: Require a pull request before merging

main에 직접 push 금지. 무조건 PR을 열어야 머지 가능. 본인이 main에 한 줄 commit 했다 → push 거부. PR을 만들어야 함. **자경단의 가장 큰 자물쇠**. 이 한 칸이 100가지 사고를 막아요.

하위 옵션: **Required approvals**(승인 N명 필요) — 자경단 표준 1명. 본인 PR도 까미·노랭이·미니·깜장이 중 1명이 승인. **자기 PR을 자기가 승인 못 함** (GitHub 기본 정책).

### 4-2. 체크 2: Require status checks to pass before merging

PR 안에서 CI(GitHub Actions)가 통과해야 머지 가능. lint·test·type check 다 초록불이어야 함. 빨간불이면 Merge 버튼이 비활성. **CI는 협업의 안전벨트**. Ch005 H4·H5·H8에서 자세히.

하위 옵션: 어떤 status check가 필수인지 선택. 자경단 표준 — `lint`·`test`·`type-check` 3개 필수.

추가 옵션: **Require branches to be up to date before merging** — feature branch가 main의 최신 commit을 갖고 있어야 머지 가능. 안 하면 "rebase 또는 merge main" 강제. 단단하지만 머지 비용 증가. 자경단 표준 ON (단단한 게 우선).

### 4-3. 체크 3: Require conversation resolution before merging

PR의 모든 review comment가 resolve(해결됨)되어야 머지 가능. 까미가 "이 부분 다시 봐 주세요" 단 코멘트가 unresolved면 머지 불가. **대화가 끝나야 머지**. 의도(왜)의 합의를 코드보다 더 단단히.

자경단 표준 ON. 5명이 한 PR에 5개 코멘트 단 적도 있어요 (특히 첫 PR). 다 resolve 해야 다음으로 넘어가는 게 신뢰의 첫 신호.

### 4-4. 체크 4: Require signed commits

GPG·SSH 서명이 박힌 commit만 main에 들어올 수 있어요. 서명 없는 commit은 거부. **누가 정말 본인인가** 검증. 큰 회사는 필수, 자경단은 옵션(설정 비용 있음).

자경단 첫 6개월 — OFF (설정 비용이 부담). 6개월 후 — ON 검토. 면접에서 "signed commit 써 봤어요?" 단골이라 1년 안에 도입할 만해요. Ch004 H3에서 GPG·SSH 서명 셋업 다뤘어요.

### 4-5. 체크 5: Require linear history

merge commit 금지. squash 또는 rebase로만 머지 가능. main의 그래프가 한 직선. **`git log --oneline`이 깨끗**해요.

자경단 표준 ON — squash merge 80% (PR 한 개 = 한 commit). rebase merge 20% (commit 의미 보존이 중요할 때). merge commit 금지. log가 책처럼 읽혀요.

### 4-6. 체크 6: Do not allow bypassing the above settings (Include administrators)

Admin도 위 규칙에 걸리게. 본인(Admin)도 main에 직접 push 금지. **자기 자물쇠를 자기가 못 풀기**. 새벽 3시에 본인이 "급한데 이번 한 번만 main에 직접 push" 하다 사고 — 이걸 막아요.

자경단 표준 ON. **Admin이 자물쇠 위에 있으면 자물쇠가 의미 없음**. 본인을 묶는 한 칸이 자경단의 단단함.

### 4-7. 체크 7: Allow force pushes / Allow deletions (둘 다 OFF)

main에 force push 금지. main 삭제 금지. 둘 다 기본 OFF, 그대로 둬요. 이 두 칸이 ON이면 자물쇠 6개를 다 채워도 누가 main을 강제 갈아끼우거나 삭제할 수 있어요. **자물쇠의 마지막 두 알갱이**.

자경단 표준 — 둘 다 OFF (기본).

### 4-8. 7체크 한 줄 요약표

| 체크 | 핵심 한 줄 | 자경단 |
|------|----------|-------|
| 1. PR 필수 + 승인 N명 | main에 직접 push 금지 | ON, 1명 승인 |
| 2. status check 필수 | CI 통과해야 머지 | ON, 3개 (lint·test·type) |
| 3. conversation 해결 | 코멘트 다 resolve | ON |
| 4. signed commit | 서명 박힌 commit만 | OFF (6개월 후 ON) |
| 5. linear history | merge commit 금지 | ON (squash/rebase만) |
| 6. include administrators | Admin도 자물쇠 적용 | ON |
| 7. force push/삭제 금지 | 강제 갈아끼우기·삭제 봉쇄 | OFF (기본 그대로) |

7체크 셋업 시간 — 처음이면 5분. main 한 번 → develop 한 번(Git Flow면) → release/* 한 번. 자경단은 main 한 번이면 끝. **5분이 1년의 단단함**.

---

## 5. CODEOWNERS — 파일 경로로 사람 묶기

CODEOWNERS는 한 파일이에요. `.github/CODEOWNERS` 위치에 저장. 안에 글로브 패턴 + GitHub 핸들·team 매핑이 줄줄이.

### 5-1. 자경단 CODEOWNERS 표준

```
# .github/CODEOWNERS

# 기본값: 본인이 모든 PR 1차 리뷰
*                          @cat-vigilante/maintainers

# 백엔드: 까미
/backend/                  @cat-vigilante/backend
/backend/**/*.py           @cat-vigilante/backend
*.sql                      @cat-vigilante/backend

# 프론트: 노랭이
/frontend/                 @cat-vigilante/frontend
*.tsx                      @cat-vigilante/frontend
*.css                      @cat-vigilante/frontend
*.scss                     @cat-vigilante/frontend

# 인프라: 미니
/infra/                    @cat-vigilante/infra
/.github/workflows/        @cat-vigilante/infra
/Dockerfile                @cat-vigilante/infra
/docker-compose.yml        @cat-vigilante/infra

# 디자인·QA: 깜장이
/design/                   @cat-vigilante/design-qa
/qa/                       @cat-vigilante/design-qa
/tests/                    @cat-vigilante/design-qa @cat-vigilante/backend

# 보안 민감 파일: 본인 + 미니 둘 다 승인 필요
/.env.example              @cat-vigilante/maintainers @cat-vigilante/infra
/SECURITY.md               @cat-vigilante/maintainers
```

### 5-2. CODEOWNERS 6규칙

1. **글로브 패턴** — `*.tsx`(어디든 .tsx), `/frontend/`(루트의 frontend 폴더만), `**/*.py`(어디든 .py), `*.sql`(어디든 .sql).
2. **위치는 셋 중 하나** — `CODEOWNERS`(루트), `.github/CODEOWNERS`, `docs/CODEOWNERS`. **자경단 표준 `.github/`** (다른 GitHub 설정과 같은 자리).
3. **마지막 줄이 우선** — 위에서 아래로 읽고, 마지막에 매치된 줄의 owner가 적용. 그래서 `*` 가장 위, 구체적인 패턴 아래로.
4. **복수 owner = OR** — 한 줄에 owner 여러 개면 그 중 1명 승인이면 충분 (branch protection의 required approvals 1과 결합). **AND는 GitHub 기본 지원 안 함** — branch protection의 "Require approval from someone in CODEOWNERS"로 우회.
5. **team mention만 가능, organization 외부 불가** — `@username` 또는 `@org/team`. 외부 사람은 owner 못 됨.
6. **CODEOWNERS 파일 자체의 owner** — 한 줄 추가 권장: `/.github/CODEOWNERS @cat-vigilante/maintainers` — 이 파일은 본인만 수정 가능하게.

### 5-3. branch protection과의 결합

branch protection rule에 **"Require review from Code Owners"** 체크박스가 있어요. ON 하면 PR이 변경한 파일의 CODEOWNERS 매칭 owner의 승인이 필수. 까미가 `/backend/`만 건드린 PR이면 까미 팀의 승인이 있어야 함(또는 maintainers).

자경단 표준 — ON. CODEOWNERS + branch protection 결합 = **파일 경로가 사람 합의를 강제**.

### 5-4. 자경단 시나리오: 노랭이가 백엔드 건드린 PR

노랭이가 `/frontend/` 작업 중에 `/backend/api.py`를 한 줄 고침 (백엔드 API 호출 형식 변경). PR 열림 → CODEOWNERS가 `/backend/**/*.py`를 매치 → 까미 자동 reviewer 추가 → 까미 승인 + 본인(maintainers) 승인 후 머지. 노랭이 혼자 머지 못 함. **파일 경로가 동료를 자동으로 부름**. 한 칸이 합의 5분의 한 줄.

---

## 6. Conventional Commits + commitlint — commit 메시지에 합의 박기

자경단의 commit 메시지를 한 양식으로 통일해요. **Conventional Commits** 표준.

### 6-1. 양식

```
<type>(<scope>): <subject>

<body>

<footer>
```

- **type 7개**: `feat`(새 기능)·`fix`(버그)·`docs`(문서)·`style`(포맷·세미콜론)·`refactor`(기능 변경 없는 구조)·`test`(테스트)·`chore`(빌드·도구). 추가로 `perf`(성능)·`ci`(CI 설정)·`build`(빌드 시스템) 3개도 자주.
- **scope**: 영향 범위. `auth`, `cat-card`, `api` 등. 옵션.
- **subject**: 50자 이내, 영어 명령형 또는 한국어 짧게. 마침표 ❌.
- **body**: 왜·어떻게. 72자 줄바꿈. 옵션.
- **footer**: `BREAKING CHANGE:` 또는 `Closes #123`. 옵션.

**예시**:

```
feat(cat-card): 길고양이 신고 카드 컴포넌트 추가

- CatCard 컴포넌트 (사진·이름·위치·상태 표시)
- 사진 lazy load (intersection observer)
- 위치 클릭 시 지도 이동

Closes #42
```

### 6-2. 왜 Conventional Commits인가

1. **machine-readable** — 도구가 commit 메시지를 파싱해서 자동 release 노트 생성. release-please·standard-version·semantic-release 같은 도구가 이걸 먹고 SemVer 자동 결정 (`feat` = minor, `fix` = patch, `BREAKING CHANGE` = major).
2. **searchable** — `git log --grep '^feat'` 한 줄로 새 기능만 모음. `^fix`로 버그 수정만. **log가 검색 가능한 데이터**.
3. **review-friendly** — PR 제목이 commit 메시지면 리뷰어가 1초 안에 종류 파악. `feat:`인지 `fix:`인지 색깔이 보임.
4. **CHANGELOG 자동** — release 시 `CHANGELOG.md` 자동 생성. 본인이 손으로 안 써도 됨.
5. **신입성 자산** — 면접에서 "Conventional Commits 써 봤어요?" 단골. **한 양식이 본인의 시니어 신호**.

### 6-3. commitlint 셋업 (5분)

`commitlint`는 commit 메시지를 검사하는 도구. 양식에 안 맞으면 commit 거부.

> ▶ **같이 쳐보기** — Conventional Commits 검사기 5분 셋업
>
> ```bash
> # 자경단 repo 에서 (Node.js 프로젝트 가정)
> npm install --save-dev @commitlint/cli @commitlint/config-conventional
> echo "module.exports = { extends: ['@commitlint/config-conventional'] }" > commitlint.config.js
> ```

이제 husky로 commit-msg hook에 연결 (다음 절).

### 6-4. 자경단 commit 메시지 한 페이지

자경단 표준 — type 10개(7기본 + perf·ci·build), scope 영어, subject 한국어 OK. 본문은 한국어. footer 영어(`Closes #N`).

```bash
# 좋은 예
git commit -m 'feat(cat-card): 길고양이 신고 카드 추가'
git commit -m 'fix(api): photo upload 500 에러 수정'
git commit -m 'docs: CONTRIBUTING.md 첫 PR 가이드 추가'
git commit -m 'chore(deps): React 18.3 → 19.0 업그레이드'

# 나쁜 예
git commit -m 'wip'                    # type 없음
git commit -m 'update.'                # 의미 없음
git commit -m 'feat: 추가했어요.'       # subject 마침표·모호
```

**한 줄이 한 사람 30초 vs 5명 5분의 차이**. commit 메시지 한 줄이 좋으면 리뷰어가 30초에 파악. 나쁘면 PR 본문 다 읽어서 5분. **하루 PR 5개 × 5명 = 25번**. commit 메시지 양식 한 줄이 자경단의 매일 25번을 절약해요.

---

## 7. husky + pre-commit hooks — 합의를 .git/hooks에 박기

`husky`는 git hook 관리 도구. `.git/hooks/`는 commit 시점에 실행되는 스크립트인데, 그건 git이 추적 안 함(.git은 .gitignore와 무관하게 추적 밖). husky는 hook 스크립트를 `.husky/` 디렉토리(추적됨)에 넣고, install 시 `.git/hooks/`에 자동 연결. **합의가 repo에 박혀요**.

### 7-1. husky 셋업 (5분)

> ▶ **같이 쳐보기** — pre-commit + commit-msg hook 두 개 박기
>
> ```bash
> npm install --save-dev husky
> npx husky init        # .husky/ 생성 + package.json prepare 스크립트
>
> echo "npx lint-staged" > .husky/pre-commit
> echo 'npx --no -- commitlint --edit "$1"' > .husky/commit-msg
> ```

이제 `git commit` 칠 때마다:
1. **pre-commit**: `lint-staged`가 staged 파일에 lint·format 자동 실행
2. **commit-msg**: `commitlint`가 메시지 검사 — 양식 안 맞으면 거부

### 7-2. lint-staged 셋업

`lint-staged`는 staged 파일에만 lint·format 실행. 전체 repo lint(느림) 안 하고 변경 파일만(빠름).

```bash
npm install --save-dev lint-staged
```

`package.json`에 추가:

```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],
    "*.{css,scss}": ["stylelint --fix", "prettier --write"],
    "*.{md,json,yaml,yml}": ["prettier --write"],
    "*.py": ["ruff check --fix", "ruff format"]
  }
}
```

**5명이 다른 에디터 써도 commit 후엔 한 양식**. 본인은 VS Code, 까미는 Vim, 노랭이는 WebStorm — 셋이 다 달라도 hook이 통일. **편집기 자유, 결과 통일**.

### 7-3. pre-commit hook의 5계명 (Ch004 H7 회수)

1. **빠르게** — 1초 이내. 5초 넘기면 사람이 hook을 우회(`--no-verify`)함.
2. **변경된 파일만** — lint-staged 사용. 전체 repo 검사 ❌.
3. **읽기·쓰기 분리** — pre-commit은 lint·format(읽기 + 자동 수정). 큰 빌드는 CI(Actions)로.
4. **복구 가능하게** — hook이 실패해도 staging 보존. 사람이 fix 후 다시 commit.
5. **bypass 정책** — `--no-verify` 허용은 응급용. 자경단 표준은 "bypass 시 PR 본문에 이유 기재".

### 7-4. 자경단 hook 4가지 표준

| Hook | 자경단 표준 | 안 하면 |
|------|----------|--------|
| pre-commit | lint-staged (eslint·prettier·ruff) | 포맷 안 맞은 코드가 main에 |
| commit-msg | commitlint (Conventional Commits) | 메시지 양식 깨짐 |
| pre-push | (선택) test 일부 | 깨진 코드가 push |
| post-merge | (선택) `npm install` 알림 | dependency 안 맞아 빌드 실패 |

자경단 첫 6개월 — pre-commit + commit-msg 둘만. pre-push는 CI가 있으니 중복. post-merge는 합의로 충분.

### 7-5. .husky/ 디렉토리 트리

```
.husky/
├── _/                       # husky 내부 (자동)
├── pre-commit               # 한 줄: npx lint-staged
├── commit-msg               # 한 줄: npx --no -- commitlint --edit "$1"
└── (선택) pre-push          # 한 줄: npm test
```

**셋업 후 첫 commit 시연** — 본인이 `console.log('test');` 한 줄 추가 → `git add .` → `git commit -m 'wip'` → husky 발동:
1. pre-commit: lint-staged → eslint가 `console.log` 경고 → 본인이 `// eslint-disable-next-line` 또는 제거
2. commit-msg: commitlint → `wip`은 양식 안 맞음 → "type 필요" 거부 → 본인이 `feat: console.log 임시 디버깅` 으로 재시도

5초의 hook이 5년의 일관성. 처음엔 답답하지만 1주일 지나면 손가락이 자동.

---

## 8. SSH 키 vs PAT vs Deploy Key vs Fine-grained Token — 비밀의 종류

자경단이 GitHub와 인증할 때 4종류의 비밀이 있어요. 각각 자리가 달라요.

### 8-1. 비교표

| 종류 | 무엇 | 어디 쓰나 | 만료 | 권한 |
|------|------|---------|------|------|
| **SSH 키 (개인)** | `~/.ssh/id_ed25519` | 본인 노트북에서 git push | 없음 (본인 책임) | 본인의 모든 권한 |
| **PAT (classic)** | GitHub Settings → Developer → Tokens | HTTPS git·CLI 도구·CI | 7~365일 | scope 단위 (repo·workflow 등) |
| **Fine-grained PAT** | 위 + 새 옵션 | 위와 같지만 더 좁게 | 1~366일 | repo별·권한별 (read·write) |
| **Deploy key** | repo Settings → Deploy keys | 한 repo만 read 또는 write (배포 서버) | 없음 | 그 repo만 |

### 8-2. 각 비밀의 자리

**SSH 키** — 본인 노트북에서 자경단 repo에 매일 push. ed25519 키 한 번 생성, GitHub에 등록(Settings → SSH keys), 평생 사용. 패스프레이즈 권장. macOS keychain 통합. Ch004 H3에서 셋업 다뤘어요.

**PAT (classic)** — git CLI를 HTTPS로 쓸 때 패스워드 자리. 또는 GitHub API 호출(스크립트). 또는 CI에서 GitHub에 push할 때. classic은 "scope 단위" — `repo`·`workflow`·`admin:org` 식. 한 token이 넓게 적용.

**Fine-grained PAT** (2022년 새로 도입) — classic의 단점(너무 넓음) 보완. 특정 repo 1개에 read·write 식. 큰 회사·보안 민감 환경 표준. 자경단도 6개월 후 fine-grained로 마이그레이션 권장.

**Deploy key** — 한 repo만 접근. 보통 배포 서버(EC2·VPS)에 둠. 자경단의 prod 서버가 자경단 repo에서 코드 pull 받을 때 deploy key 사용. **사람이 아니라 기계가 쓰는 키**.

### 8-3. 자경단 비밀 셋업 표준

| 자리 | 비밀 | 비고 |
|------|------|------|
| 본인 노트북 (개인) | SSH 키 (ed25519) | macOS keychain |
| GitHub Actions (CI) | `GITHUB_TOKEN` (자동 발급) | 별도 설정 불필요 (read/write 자동) |
| 외부 CI 도구 (있다면) | Fine-grained PAT | 그 repo만 read·write |
| 본인 prod 서버 | Deploy key | 한 repo만 read |
| 외부 서비스 (Vercel·Netlify) | OAuth 또는 Fine-grained PAT | OAuth 우선 |

**1Password SSH agent** (보너스) — 1Password가 SSH 키를 보관하고 git이 1Password에 매번 비밀번호 묻기. macOS keychain보다 단단. 자경단 1년 후 도입 검토.

### 8-4. 사고 시나리오와 처방

**사고 1: 까미가 본인 PAT를 실수로 GitHub에 commit** — 1분 안에 알람(GitHub secret scanning이 자동 감지·이메일). 처방: **즉시 PAT revoke** + **fine-grained로 새로 발급** + git history 정리(`filter-repo`).

**사고 2: 노랭이가 deploy key를 잘못된 서버에 둠** — 처방: GitHub Settings → Deploy keys → 해당 키 삭제 + 새 deploy key 발급 + 올바른 서버에 둠.

**사고 3: 미니가 macOS keychain의 SSH 패스프레이즈 잊음** — 처방: 새 SSH 키 생성 + 기존 키 GitHub에서 삭제. ed25519는 1초 생성, 패스프레이즈 잊은 것보단 새로 만드는 게 빠름.

**비밀 5계명**:
1. **commit 안 함** — `.gitignore`에 `.env`·`*.pem`. 그래도 실수하면 secret scanning이 잡음.
2. **만료 짧게** — PAT 90일 권장. 1년은 너무 길어요.
3. **scope 좁게** — fine-grained 우선. classic의 `repo` 권한은 너무 넓음.
4. **사람과 기계 분리** — 사람 = SSH 키, 기계 = deploy key 또는 PAT.
5. **누출 시 1분 안에 revoke** — 늦으면 1분이 1주일이 됨.

---

## 9. 자경단 적용 — 한 페이지 셋업 체크리스트 10단계

본인이 H1·H2·H3의 모든 결정을 GitHub에 박는 30분 셋업. 한 줄씩.

```
[ ] 1. github.com/cat-vigilante organization 생성 (Free plan)
[ ] 2. 5팀 생성 (maintainers·backend·frontend·infra·design-qa) + 멤버 초대
[ ] 3. cat-vigilante repo 생성 (public, README·LICENSE·.gitignore 자동)
[ ] 4. team별 repo 권한 부여 (5단계 표 따라)
[ ] 5. main에 branch protection rule 7체크 셋업
[ ] 6. .github/CODEOWNERS 작성·commit (자경단 5팀 매핑)
[ ] 7. branch protection에 "Require review from Code Owners" ON
[ ] 8. commitlint + husky 설치 (npm install --save-dev) + .husky/ 셋업
[ ] 9. lint-staged + ESLint·Prettier·Ruff 설정 (package.json + 설정 파일들)
[ ] 10. 첫 PR로 셋업 검증 (5명 누구나 PR 1개 생성 → CI·CODEOWNERS·husky 다 작동 확인)
```

**30분이 5년의 단단함**. 첫 셋업이 손가락 5분 × 10단계. 매년 회고로 점검·갱신. 1년 후 fine-grained PAT 마이그·signed commit ON·deploy key 추가 식으로 한 칸씩.

**왜 30분이 5년인가** — 셋업한 7체크가 사고 한 번을 막음. 사고 한 번 = 5명 × 1시간 = 5시간 손해. 30분 셋업으로 1년에 사고 5번 방지하면 5 × 5시간 = 25시간 절약. 5년이면 125시간 = 5일. **30분이 5일을 사요**.

**셋업 후 첫 PR 시뮬레이션** — 노랭이가 `feat(landing): 메인 페이지 헤더 추가` PR. 변경 파일 `/frontend/Header.tsx`. CODEOWNERS가 frontend team을 자동 reviewer 추가. 본인(maintainers) + 노랭이(자기 PR 승인 못 함) 중 본인이 승인. CI(lint·test·type) 3개 초록불. husky가 `console.log` 한 줄 잡아서 노랭이가 fix 후 재push. 첫 PR 머지에 30분. **셋업의 모든 도구가 한 PR에 다 쓰임**.

---

## 10. 흔한 오해 7가지

**오해 1: "Personal account만으로도 자경단 충분해요."** — 1주일은 OK. 까미 합류 즉시 한계. 권한 단순(2단계 vs 5단계)·결제 한 사람·team 없음·audit log 없음. organization 옮기는 비용은 5분, 안 옮기는 비용은 1년.

**오해 2: "branch protection은 큰 회사용이에요."** — 5명도 필수. 한 사고가 5명 × 1시간. 자물쇠 7장이 사고 5번을 막음. **자물쇠 비용 0, 사고 비용 무한**.

**오해 3: "CODEOWNERS는 50명+ 회사 도구예요."** — 5명도 효과적. 파일 경로가 사람을 부름. 노랭이가 백엔드 건드리면 까미 자동 reviewer. 한 줄이 합의 30초.

**오해 4: "Conventional Commits는 강박이에요."** — 1주일 지나면 손가락 자동. 강박 아니라 자산. release-please·CHANGELOG 자동·log 검색 가능. 한 양식이 5년의 가치.

**오해 5: "husky는 Node.js 프로젝트만 가능해요."** — 다른 언어도 가능. Python은 `pre-commit` 도구(별도, 같은 이름). Go는 `lefthook`. 어느 언어든 hook 도구 있음. **어느 stack이든 hook은 평등**.

**오해 6: "PAT 한 개로 다 해결돼요."** — 사고 위험. PAT 누출 시 모든 repo 모든 권한. fine-grained PAT은 한 repo만, deploy key는 그 repo만. 비밀의 자리를 분리하는 게 사고 비용을 1/100로.

**오해 7: "Admin이 많으면 협업이 빨라요."** — 거꾸로. Admin이 많으면 사고도 많음. 누가 main에 force-push 해도 누구 책임인지 모호. **Admin 한 사람**이 1년의 단단함. 자경단 첫 1년은 본인 한 명.

---

## 11. FAQ 7가지

**Q1. organization 이름은 어떻게 정하나요?**
A. kebab-case 영어 단축형. `cat-vigilante` (자경단), `acme-corp`, `gogocomputer`. 한국어·공백·대문자 안 됨. 한 번 정하면 바꿀 수 있지만 URL이 바뀌어 외부 링크 깨짐. **첫 결정을 신중히**. 5분 고민하고 1년 사용.

**Q2. team을 몇 개 만들면 되나요?**
A. 5명 미만은 1~2팀(maintainers + 모두). 5~15명은 4~6팀(역할별). 15~50명은 10~15팀(중첩). 50명+는 부서 트리. 자경단은 5팀이 표준 — 5명이 5팀이라 1:1 매핑이지만 1년 후 10명이 되면 같은 팀에 2명씩 자연스레 합류.

**Q3. branch protection의 "approvals 1명"이 너무 약하지 않나요?**
A. 5명 팀에선 적정. 큰 회사는 2~3명. 자경단도 1년 후 5명이 7명이 되면 2명으로 올림. 다만 "1명 + CODEOWNERS owner 승인 필수"의 조합이 단단해서 1명도 충분. **숫자만 보지 말고 구조를 봐요**.

**Q4. CODEOWNERS의 OR vs AND 어떻게 처리하나요?**
A. GitHub은 기본 OR. AND가 필요하면 한 줄에 여러 owner + branch protection에 "Require approval from Code Owners" ON으로 우회. 매치되는 모든 패턴의 owner 중 1명씩 승인 받아야 함. 자경단 보안 파일 `.env.example`은 maintainers + infra 둘 매치 → 둘 다에서 한 명씩 승인 필요.

**Q5. commitlint를 한국어 메시지에도 적용 가능한가요?**
A. 가능. `@commitlint/config-conventional`은 type만 검사 (영어 7개 prefix 강제). subject는 어떤 언어든 OK. `feat: 길고양이 카드 추가` 통과. type만 영어, 본문은 한국어가 자경단 표준.

**Q6. fine-grained PAT으로 마이그레이션은 언제?**
A. organization 생성 후 6개월 ~ 1년 시점. 처음엔 SSH 키 + classic PAT으로 단순하게 시작. 6개월쯤 외부 CI·서비스가 늘어나면 그때 fine-grained로 한 개씩 옮김. **단순 → 정밀**의 진화.

**Q7. 자경단 셋업 30분이 부담스러우면 어떻게?**
A. **30분을 5분 × 6일**로 쪼개기. 월요일 organization·team 5분, 화요일 권한·branch protection 5분, 수요일 CODEOWNERS 5분, 목요일 commitlint 5분, 금요일 husky·lint-staged 5분, 토요일 첫 PR 검증 5분. 한 주의 5분씩이 모이면 30분. 처음엔 부담스럽지만 결과물은 같음. **걸음마로 산을 오르기**.

---

## 12. 추신

organization은 자경단의 회사 명함 — 5명 되는 순간 옮겨요. team 5개의 페르소나 분리가 권한 5단계의 한 줄 표예요. branch protection 7체크는 면접 단골 질문이라 종이에 적어 두세요 — "main 보호 어떻게 하셨어요?"에 7개 다 말하면 시니어 신호. CODEOWNERS는 파일 경로의 사람 묶기 — 노랭이가 백엔드 건드리면 까미 자동.

Conventional Commits 7 prefix(feat·fix·docs·style·refactor·test·chore) + perf·ci·build 3개 = 10개로 본인의 모든 commit이 분류돼요. husky pre-commit 5초의 답답함이 5년의 일관성. lint-staged는 staged 파일만, 전체 lint는 CI에서 — **빠른 hook + 깊은 CI**의 분업. SSH 키는 사람의 비밀, deploy key는 기계의 비밀, PAT은 90일 만료가 표준, fine-grained PAT은 6개월 후 마이그레이션. branch protection의 "Include administrators" 한 칸이 본인을 묶어 진짜 자물쇠로 만들어요.

셋업 30분 × 5년 사고 방지 = 125시간 절약. ROI 무한대. 다음 H4는 카탈로그 — 협업 명령어 23~30개의 한 표 + 위험도 신호등 + 매일·주간·월간 리듬. 그리고 한 가지 실험 — 본인이 좋아하는 오픈소스(facebook/react·fastapi·next.js)의 `.github/CODEOWNERS`를 열어 보세요. 큰 회사의 한 페이지가 본인의 5년 학습이에요. 🐾
