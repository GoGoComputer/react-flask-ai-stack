# Ch005 · H7 — Git 협업 워크플로: 원리/내부 — 도구의 비밀과 알고리즘

> **이 H에서 얻을 것**
> - branch protection이 GitHub 서버에서 강제되는 방식 — push 거부 응답·refs/heads 보호 흐름
> - CODEOWNERS 매칭 알고리즘 — 위에서 아래·마지막 매치 우선·글로브 처리·우선순위 4규칙
> - conflict 알고리즘 4종 비교 — myers·histogram·patience·minimal, 3-way merge·diff3 base
> - 분산 git의 협업 비밀 — refspec·fetch protocol·packfile delta·smart vs dumb HTTP·shallow clone
> - GitHub Actions 내부 — runner·workflow trigger·secrets 격리·matrix·reusable workflow
> - gh CLI 내부 — REST API + GraphQL API + OAuth token + cache
> - 큰 회사가 5명 자경단보다 어떤 깊이를 더 쓰는가 — 5가지 추가 깊이

---

## 회수: H6의 운영에서 본 H의 원리로

지난 H6에서 본인은 자경단의 1년 운영 — 자동화 5종·회고 5단계·5사고 일지를 봤어요. 그건 운영의 그림. 도구가 무엇을 해 주는지의 그림.

이번 H7는 **그 도구가 어떻게 그렇게 해 주는지의 그림**이에요. branch protection이 어떻게 push를 거부하나? CODEOWNERS는 어떤 알고리즘으로 사람을 매칭하나? conflict 풀 때 git은 어떤 알고리즘으로 두 변경을 합치나? 분산 git이 어떻게 5명의 노트북을 동기화하나?

지난 Ch004의 H7은 `.git/` 9슬롯 + 4종 객체(blob·tree·commit·tag) + refs + index + hooks. 그건 1인 git의 내부. 이번 H7는 5명 협업 git의 내부. 1인 → 5명으로 늘어나면 내부 비밀이 5배 깊어져요. 같은 git 내부지만 협업 측면을 보는 새 시각.

**왜 원리를 보는가** — 도구를 손가락으로 쓰는 건 1년이면 충분. 다만 도구의 원리를 알면 사고가 났을 때 5분 진단. 모르면 5시간 검색. **원리가 시니어의 차이**.

---

## 1. branch protection의 강제 흐름 — push 거부의 비밀

본인이 main에 직접 push하면 GitHub이 거부해요. 그 거부가 어떻게 일어나는지 5단계.

### 1-1. push 거부 5단계

```
[본인 노트북]                              [GitHub 서버]
  git push origin main
       │
       │  1. SSH/HTTPS pack 전송 (smart HTTP)
       ▼
  packfile + ref 갱신 요청
                                         2. 인증 (SSH key 또는 PAT)
                                            
                                         3. 권한 검사 (admin·write·read)
                                         
                                         4. branch protection 검사
                                            ├─ require PR? ✗ 거부
                                            ├─ require status check? ✗
                                            ├─ require linear history? ✗
                                            └─ ...
                                         
                                         5. ref 갱신 거부 → 본인에게 응답
       ◀──────────────────────────────────
  ! [remote rejected] main -> main
  (protected branch hook declined)
```

거부 응답은 **pre-receive hook의 거부 메시지**. GitHub은 내부적으로 Git의 server-side hook (`pre-receive`)을 사용해 7체크를 강제. 본인의 `git push`는 packfile을 전송하지만, 서버가 ref(`refs/heads/main`)를 업데이트하기 전에 hook이 검사. 한 체크라도 실패하면 hook이 exit 1 → ref 갱신 안 됨 → 클라이언트에 거부 응답.

### 1-2. server-side hook의 9가지 단계

GitHub의 pre-receive hook이 한 push마다 9가지 검사:

1. **SSH/HTTPS 인증** — 진짜 본인인가
2. **repository 권한** — read/write/admin 중 어느 단계?
3. **branch 규칙 매칭** — `main`·`develop`·`release/*` 중 어디?
4. **PR 필수** — 직접 push 금지면 거부
5. **승인 N명** — required approvals 충족?
6. **status check** — CI 통과? `lint`·`test`·`type-check` 모두 ✓?
7. **conversation 해결** — 모든 review 코멘트 resolve?
8. **linear history** — merge commit 있나? 있으면 거부 (squash·rebase만)
9. **include administrators** — Admin도 위 8개 적용?

9 검사 중 하나라도 ✗ → 거부. 클라이언트는 한 줄 응답 (`protected branch hook declined`).

### 1-3. 자경단의 push 거부 시나리오

본인이 새벽 3시에 main에 직접 push 하려 함:

```bash
$ git push origin main
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 1.23 KiB | 1.23 MiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: error: GH006: Protected branch update failed for refs/heads/main.
remote: error: At least 1 approving review is required by reviewers with write access.
To github.com:cat-vigilante/cat-vigilante.git
 ! [remote rejected] main -> main (protected branch hook declined)
error: failed to push some refs to 'github.com:cat-vigilante/cat-vigilante.git'
```

`GH006`은 GitHub의 protected branch 거부 코드. 다른 코드들:
- `GH001` — 권한 부족
- `GH002` — branch 이름 잘못
- `GH006` — branch protection 위반
- `GH013` — push limit (큰 파일)

본인이 거부 메시지 한 줄 보고 처방 — "Ah, 1 approving review 필요. PR 만들자".

---

## 2. CODEOWNERS 매칭 알고리즘 — 4규칙

CODEOWNERS 파일을 GitHub이 읽고 PR의 변경 파일에 사람을 매칭. 알고리즘 4규칙.

### 2-1. 매칭 4규칙

```
.github/CODEOWNERS:
*                          @cat-vigilante/maintainers      # 줄 1
/backend/                  @cat-vigilante/backend          # 줄 2
*.tsx                      @cat-vigilante/frontend         # 줄 3
/backend/api.py            @cat-vigilante/maintainers      # 줄 4
```

**규칙 1: 위에서 아래로 읽기.** 모든 줄을 평가하지만 **마지막에 매칭된 줄의 owner가 적용**.

**규칙 2: 마지막 매치 우선.** PR이 `/backend/api.py` 변경 시:
- 줄 1 `*` 매치 → maintainers
- 줄 2 `/backend/` 매치 → backend
- 줄 4 `/backend/api.py` 매치 → maintainers ← **이게 적용**

**규칙 3: 글로브 처리.** `*` (어디든), `**` (재귀 디렉토리), `?` (한 글자), `[abc]` (집합), `/path/`(특정 경로). gitignore와 비슷.

**규칙 4: 한 줄에 owner 여러 명 = OR.** 한 명만 승인하면 충분 (branch protection의 required approvals 1과 결합).

### 2-2. 매칭 트레이스 예시

```
변경 파일: /backend/api.py + /frontend/Header.tsx

파일 1: /backend/api.py
  줄 1 `*` 매치 ✓ → maintainers
  줄 2 `/backend/` 매치 ✓ → backend
  줄 4 `/backend/api.py` 매치 ✓ → maintainers ← 마지막 매치
  결과: maintainers

파일 2: /frontend/Header.tsx
  줄 1 `*` 매치 ✓ → maintainers
  줄 3 `*.tsx` 매치 ✓ → frontend ← 마지막 매치
  결과: frontend

PR 자동 reviewer: maintainers + frontend (합집합)
```

GitHub은 변경 파일 각각에 대해 매칭 → 결과 owner들의 합집합 → 자동 reviewer 알람.

### 2-3. 알고리즘 의사코드

```python
def find_codeowners(changed_files, codeowners_rules):
    reviewers = set()
    for file_path in changed_files:
        last_match_owners = None
        for rule in codeowners_rules:
            if glob_match(rule.pattern, file_path):
                last_match_owners = rule.owners
        if last_match_owners:
            reviewers.update(last_match_owners)
    return reviewers
```

O(N × M) — N 파일 × M 규칙. 50파일 × 50규칙 = 2,500 매칭 검사. 1ms 안에 끝남.

### 2-4. 자경단의 매칭 함정 5가지

1. **순서 바꾸면 결과 달라짐** — 가장 일반적인 패턴(`*`)이 위, 구체적(`/backend/api.py`)이 아래.
2. **`/backend/`와 `/backend`** — slash 끝에 있으면 디렉토리만, 없으면 파일도.
3. **`**`은 재귀** — `/backend/**/*.py`는 모든 하위 .py.
4. **owner 잘못된 핸들** — 존재하지 않는 사람·team mention하면 매칭 무시.
5. **CODEOWNERS 파일 위치 셋 중 하나** — 루트·.github·docs. 다른 위치면 GitHub이 무시.

---

## 3. conflict 알고리즘 — myers·histogram·patience·minimal

git이 두 branch를 머지할 때 어떻게 conflict를 찾는가. **3-way merge** 알고리즘.

### 3-1. 3-way merge의 핵심

세 점을 비교 — **base** (공통 조상)·**ours** (현재 branch)·**theirs** (들어오는 branch).

```
base:    const cat = "원래";
ours:    const cat = "검정";        # 우리 변경
theirs:  const cat = "노랑";        # 상대 변경

→ 둘 다 base에서 변경 → CONFLICT
```

만약 한쪽만 변경:

```
base:    const cat = "원래";
ours:    const cat = "원래";        # 변경 없음
theirs:  const cat = "노랑";        # 상대만 변경

→ 자동 머지 (theirs 채택)
```

3-way가 2-way보다 우월한 이유 — base를 알면 "둘 다 변경"과 "한쪽만 변경"을 구분.

### 3-2. diff 알고리즘 4종

merge 내부의 diff 계산에 4가지 알고리즘:

| 알고리즘 | 특징 | 자경단 권장 |
|---------|------|-----------|
| **myers** (기본) | O(ND) 시간 — 1986년 표준. 빠르지만 코드 이동 못 잡음 | 작은 파일 OK |
| **histogram** | myers + 자주 등장하는 단어 우선. 큰 코드 이동 잘 잡음 | 자경단 표준 |
| **patience** | 고유한 줄을 anchor로. refactor·indent 변경에 강함 | 큰 refactor 시 |
| **minimal** | 가장 작은 diff 강제. 가독성 ↓ | 거의 안 씀 |

```bash
# 자경단 권장
git config --global diff.algorithm histogram
git config --global merge.directoryRenames true
git config --global merge.algorithm zdiff3       # diff3 + 개선
```

### 3-3. patience 알고리즘 5단계

복잡한 refactor에 강한 patience의 5단계:

1. **공통 prefix·suffix 제거** — 두 파일의 첫·끝 같은 부분 그대로
2. **고유한 줄 찾기** — 양쪽 파일에 정확히 한 번씩 나오는 줄
3. **고유 줄 → 매칭점 (anchor)** — 두 파일 사이의 매칭점
4. **anchor 사이를 재귀적 처리** — 작은 영역 안에서 다시 patience
5. **남은 영역에 myers 적용** — 마지막 fallback

자경단 효과 — App.tsx를 200줄 → 5파일로 쪼갠 PR. patience는 줄 이동(rename·extract function)을 "삭제 + 추가"가 아닌 "이동"으로 인식 → conflict 줄어듦.

### 3-4. zdiff3 — 2022년 새 표준

`merge.conflictstyle=diff3`의 개선판. 2022년 추가. base를 표시하되 더 정확한 알고리즘.

```bash
# .git/config 또는 ~/.gitconfig
[merge]
    conflictstyle = zdiff3
```

차이 — diff3은 base를 "공통 조상"으로 표시. zdiff3은 같은 base여도 더 깔끔한 conflict 마커. 큰 refactor에 강함.

---

## 4. 분산 git의 협업 비밀 — refspec과 fetch protocol

git이 분산이라는 말의 진짜 의미. 5명 노트북이 어떻게 동기화하는가.

### 4-1. refspec의 이해

`git push origin main`의 진짜 의미:

```bash
git push origin refs/heads/main:refs/heads/main
#              local           remote
#              ─────────       ──────────
```

`refs/heads/main` (로컬) → `refs/heads/main` (원격). refspec은 **로컬:원격** 매핑.

### 4-2. fetch refspec

`.git/config`의 origin 설정:

```ini
[remote "origin"]
    url = git@github.com:cat-vigilante/cat-vigilante.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

`+refs/heads/*:refs/remotes/origin/*` — 원격의 모든 branch를 로컬의 `refs/remotes/origin/*`로 매핑. `+`는 force update 허용 (서버가 force push 했으면 로컬도 갈아끼움 — 위험하지만 fetch만 영향).

### 4-3. fetch protocol — smart HTTP / SSH

`git fetch`의 5단계:

1. **클라이언트가 ref 목록 요청** — "원격에 어떤 branch들 있어?"
2. **서버가 ref 응답** — `(branch, sha)` 튜플 목록
3. **클라이언트가 차이 계산** — 원격 sha 중 로컬에 없는 commit
4. **서버가 packfile 생성** — 빠진 commit·tree·blob을 압축한 한 파일
5. **클라이언트가 packfile 받아서 unpack** — `.git/objects/`에 풀어 넣기

이 5단계가 **smart HTTP** 프로토콜. **dumb HTTP**(옛날)은 서버가 packfile 안 만들고 raw object 하나씩 보냄 — 느림.

### 4-4. packfile delta — 협업의 비밀

packfile 안에 commit이 있는데, 같은 파일의 여러 버전을 **delta** (차이)로 저장. 1MB 파일을 100번 변경해도 100MB가 아니라 5MB 정도. **delta가 git의 효율 비밀**.

```bash
# packfile 보기
$ ls .git/objects/pack/
pack-abc123.idx     pack-abc123.pack

# packfile 내용 분석
$ git verify-pack -v .git/objects/pack/pack-abc123.idx | head -5
abc123 commit 234 175 12
def456 tree 123 92 1234 1 abc123    # delta of abc123
ghi789 blob 567 423 5432 2 def456   # delta of def456
```

`delta of abc123` — abc123의 차이로 저장. 5단계 delta chain까지 가능. 압축률 95%+.

### 4-5. shallow clone — 큰 repo의 빠른 clone

자경단 5명 자경단 repo가 5년 후 1GB가 되면, 새 멤버 첫 clone이 30분 걸림. shallow clone으로 1분으로 줄임.

```bash
# 마지막 1 commit만
git clone --depth 1 git@github.com:cat-vigilante/cat-vigilante.git

# 마지막 100 commit
git clone --depth 100 ...

# 단일 branch만
git clone --single-branch --branch main ...

# blobless clone (commit·tree만, blob은 필요시 fetch)
git clone --filter=blob:none ...
```

자경단의 5년 후 새 멤버 합류 시 — `--filter=blob:none` 권장. 5초 clone, blob은 사용 시 자동 fetch.

---

## 5. GitHub Actions 내부 — runner·trigger·secrets

자경단의 CI는 GitHub Actions. 내부 5요소.

### 5-1. runner — 어디서 실행되는가

workflow의 `runs-on`에 따라:
- `ubuntu-latest` (또는 `ubuntu-22.04`) — GitHub의 가상 머신 (무료 tier 2,000분/월)
- `macos-latest` — macOS 가상 머신 (10× 비싸)
- `windows-latest` — Windows VM (2× 비싸)
- `self-hosted` — 자경단의 자체 서버 (무료, 다만 관리 비용)

자경단 표준 — `ubuntu-latest`. 무료 tier 2,000분/월이 5명 자경단에 충분. 50 PR/주 × 1분/PR × 4주 = 200분/월. 충분.

### 5-2. trigger — 언제 실행되는가

workflow가 발동하는 상황 ~10가지:
- `push` — branch에 push 시
- `pull_request` — PR 만들거나 갱신 시
- `pull_request_target` — fork PR도 secret 사용 가능 (위험)
- `schedule` — cron (매일·매시간)
- `workflow_dispatch` — 수동 실행 (`gh workflow run`)
- `workflow_call` — 다른 workflow에서 호출 (reusable)
- `release` — release 만들 때
- `issue_comment` — issue·PR 코멘트
- `repository_dispatch` — webhook으로 외부 트리거
- `workflow_run` — 다른 workflow 끝난 후

자경단 표준 — `push`(main에서 deploy)·`pull_request`(CI)·`schedule`(stale bot)·`workflow_dispatch`(수동 deploy).

### 5-3. secrets 격리 — 비밀의 자리

GitHub Actions의 secret 우선순위:
1. **Organization secrets** — 모든 repo 공유 (자경단 5명 공통)
2. **Repository secrets** — 한 repo만
3. **Environment secrets** — 환경별 (dev·staging·prod)

```yaml
# .github/workflows/deploy.yml
jobs:
  deploy:
    environment: production    # ← 이 줄로 prod secret 사용
    runs-on: ubuntu-latest
    steps:
      - run: deploy.sh
        env:
          DB_PASSWORD: ${{ secrets.DB_PASSWORD }}    # prod secret
```

**왜 environment 셋업** — staging의 가짜 키를 prod로 잘못 쓰는 사고 방지. 환경별 격리.

### 5-4. matrix — 5 환경 동시 테스트

```yaml
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node: [18, 20, 22]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: npm test
```

3 OS × 3 Node 버전 = 9 job 동시. 자경단은 보통 OS 1·Node 1만 (5명 작은 팀이라). 큰 회사는 9~30 matrix.

### 5-5. reusable workflow — 50 workflow → 5 workflow

같은 빌드 흐름을 5 workflow에 복붙하지 말고 1개 reusable로:

```yaml
# .github/workflows/_test.yml
on:
  workflow_call:
    inputs:
      node-version:
        type: string

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ inputs.node-version }}
      - run: npm test

# 다른 workflow에서 호출
# .github/workflows/ci.yml
jobs:
  test:
    uses: ./.github/workflows/_test.yml
    with:
      node-version: '20'
```

자경단 5명이 5년 후 50 workflow가 되면 reusable이 산소.

---

## 6. gh CLI 내부 — REST + GraphQL + OAuth

`gh`(GitHub CLI)가 어떻게 GitHub API와 통신하는가.

### 6-1. gh의 첫 인증 — OAuth flow

`gh auth login` 실행:
1. gh가 GitHub OAuth 앱으로 device code 요청
2. 본인이 브라우저에서 `github.com/login/device` 방문
3. 8자리 코드 입력
4. GitHub이 OAuth token 발급
5. gh가 token을 `~/.config/gh/hosts.yml`에 저장

다음부터 모든 `gh` 명령이 이 token으로 인증.

### 6-2. REST vs GraphQL

`gh`는 두 API 사용:
- **REST** — 90% 명령. URL 기반. `gh api repos/owner/repo/pulls`
- **GraphQL** — 복잡한 쿼리. `gh api graphql -f query='{...}'`

GraphQL 예시 — PR + 리뷰 + CI 상태를 한 번에:

```bash
gh api graphql -f query='
{
  repository(owner: "cat-vigilante", name: "cat-vigilante") {
    pullRequest(number: 42) {
      title
      reviews(first: 5) { nodes { state author { login } } }
      checkSuites(first: 5) { nodes { conclusion } }
    }
  }
}'
```

REST 3 호출이 GraphQL 1 호출. 빠름.

### 6-3. cache — 매번 API 호출 안 함

`gh`는 일부 결과를 1~10초 캐시. `gh pr list` 빠르게 두 번 치면 두 번째는 캐시. 강제 무효화 — `gh cache delete --all`.

### 6-4. extension — 서드파티

`gh extension install <repo>`로 plugin. 자경단 추천 5종:
- `gh-dash` — PR·issue 대시보드
- `gh-poi` — branch 자동 정리
- `gh-copilot` — AI suggest
- `gh-pr-tree` — stack PR 시각화
- `gh-actions-cache` — CI cache 관리

5 extension이 자경단 매일 30분 절약.

---

## 7. 큰 회사가 자경단보다 더 쓰는 5깊이

자경단 5명 → 회사 500명이 되면 추가로 쓰는 5가지:

### 7-1. monorepo 도구 (Nx·Turborepo·Bazel)

50 패키지·1000 파일이 되면 빌드 시간 30분+. Nx의 `affected` 기능 — PR이 건드린 패키지만 빌드. 30분 → 30초.

### 7-2. feature flag 플랫폼 (LaunchDarkly·Split·자체)

flag 5개 → 500개가 되면 자체 관리 불가. LaunchDarkly가 flag 평가·rollout·A/B test·kill switch 통합 관리. 자경단은 6개월~1년 후 검토.

### 7-3. SRE 팀 + on-call rotation

100 incident/년이 되면 본인 한 명이 24/7 불가. SRE팀(5명) + 1주씩 rotation. 새벽 알람 1년에 5번/사람.

### 7-4. observability — 로그·metric·trace

서버 100대가 되면 로그 100GB/일. Datadog·New Relic·Grafana로 시각화·알람. 자경단 1년 후 도입 검토.

### 7-5. governance — RFC·ADR·승인 절차

큰 변경(아키텍처·기술 선택)은 1명이 결정 못 함. RFC(Request for Comments) 또는 ADR(Architecture Decision Record) 문서를 PR로. 5명+ 승인 후 코드 작업. 자경단 5명은 슬랙 한 줄로 충분, 50명+는 RFC 표준.

---

## 8. 흔한 오해 7가지

**오해 1: "GitHub은 git을 그냥 호스팅만 해요."** — pre-receive hook으로 7체크 강제, CODEOWNERS 알고리즘으로 자동 reviewer, packfile 압축, shallow clone 지원 등 자체 깊이 큼. **호스팅 +α**.

**오해 2: "CODEOWNERS는 단순 텍스트 매칭이에요."** — 4규칙 알고리즘 (위에서 아래·마지막 매치·글로브·OR). 잘못 쓰면 의도와 다른 결과.

**오해 3: "merge는 git 알고리즘이 알아서 해요."** — myers·histogram·patience·minimal 4개 중 본인이 선택 가능. 자경단은 histogram 권장. 큰 refactor 시 patience.

**오해 4: "fetch는 그냥 다운로드예요."** — refspec 매핑 + smart HTTP + packfile delta + 5단계 프로토콜. 깊이 있는 분산 동기화.

**오해 5: "GitHub Actions secret은 다 보여요."** — 격리 3단계 (org·repo·environment). environment를 셋업해야 prod secret 보호. 셋업 안 하면 staging에서 prod secret 노출 가능.

**오해 6: "gh CLI는 단순 wrapper예요."** — REST + GraphQL + OAuth + cache + extension. 작은 한 도구지만 깊이.

**오해 7: "큰 회사 도구는 자경단에 안 맞아요."** — 80% 같음. 다른 20%가 인원·인프라에 따라 진화. 자경단의 5년 후가 큰 회사. **본질이 같음**.

---

## 9. FAQ 7가지

**Q1. branch protection의 9 검사 중 가장 자주 거부되는 건?**
A. `require approvals` (1명 승인 필요). 본인 PR을 본인이 승인 못 하기 때문에 항상 동료 1명 필요. 새 멤버가 오면 첫 PR이 이걸로 막힘 — 5명 자경단의 입문 신호.

**Q2. CODEOWNERS의 글로브 `**`과 `*` 차이?**
A. `*`는 한 디렉토리 깊이만, `**`는 재귀. `/backend/*.py`는 `/backend/api.py`만, `/backend/**/*.py`는 `/backend/utils/helper.py`도 매칭. 자경단은 보통 `**` 권장 (모든 하위).

**Q3. histogram vs patience 어느 게 좋나요?**
A. histogram이 일반적. patience는 큰 refactor·indent 변경 시 특히 강함. 자경단 표준 — histogram 기본, conflict 어려울 때만 patience 옵션 (`-X patience`).

**Q4. shallow clone (`--depth 1`)의 한계?**
A. log·blame 일부만. 5년 history 보고 싶을 땐 `git fetch --unshallow`로 전체 받기. 1분 작업. 평소엔 shallow가 빠름.

**Q5. GitHub Actions의 무료 tier 2,000분/월이 부족하면?**
A. self-hosted runner (자경단 자체 서버) 또는 GitHub Team plan ($4/user/월, 3,000분 추가). 자경단 5명은 self-hosted가 더 비쌈 (관리 비용). 1,000~3,000분/월 사용은 무료 tier에 머무는 게 나음.

**Q6. gh CLI의 OAuth token이 노출되면?**
A. `gh auth logout && gh auth login`으로 재발급. GitHub Settings → Developer settings → Personal access tokens에서 revoke. 5분 안에 차단.

**Q7. 본 H의 원리를 다 외워야 시니어인가요?**
A. 80%는 손가락이 알아서 함. 다만 사고 시 원리 알면 5분 진단, 모르면 5시간. **원리는 사고 보험**. 자주 거부되는 5~10가지 (GH006·CODEOWNERS 매칭·conflict 알고리즘 등)만 머리에 박아 두기.

---

## 10. 추신

추신 1. branch protection의 거부 코드 (GH001·GH006·GH013)는 자경단 운영의 지문. 한 번 보면 평생 기억.

추신 2. `pre-receive` hook이 GitHub 내부의 비밀. 7체크가 9 검사로 풀어져요. 본인이 self-hosted Git 서버 운영하면 같은 hook을 쓸 수 있어요.

추신 3. CODEOWNERS의 4규칙 중 "마지막 매치"가 함정. 위에서 아래로, 가장 일반(`*`)이 맨 위. 헷갈리면 `gh api repos/.../codeowners/errors`로 점검.

추신 4. 글로브 `**`은 재귀, `*`는 한 깊이. 차이 한 글자가 자경단의 매칭 결과 5배 차이.

추신 5. histogram diff은 자경단 표준. `git config --global diff.algorithm histogram` 한 줄. 큰 refactor에 강함.

추신 6. zdiff3 conflictstyle은 2022년 새 표준. base 표시 + 정확한 알고리즘. 본인 자경단 conflict 1년 차에 도입 권장.

추신 7. patience 알고리즘의 5단계는 면접 단골. "diff 알고리즘 알아요?" 질문에 4종(myers·histogram·patience·minimal) + patience의 anchor 5단계 답하면 시니어.

추신 8. `git fetch --depth 1`은 큰 자경단 첫 clone의 산소. 1GB repo가 1분 clone. 평소 작업엔 `--unshallow`로 전체 받기.

추신 9. packfile delta가 git의 압축 95%. 5년 자경단의 1GB repo가 50MB packfile로. 보내고 받기 빠름.

추신 10. smart HTTP의 5단계 (ref 목록·차이 계산·packfile·unpack)가 분산 git의 본질. dumb HTTP(옛)와 비교해 깊이 알면 시니어.

추신 11. GitHub Actions의 environment secret은 prod 보호의 마지막 자물쇠. 셋업 안 하면 staging에서 prod 키 노출 위험.

추신 12. matrix는 자경단 작은 팀에 과함. OS 1·Node 1로 충분. 큰 회사의 9~30 matrix는 비용 문제 (CI 분이 9배).

추신 13. reusable workflow는 50 workflow + 5명 + 5년 후의 자산. 처음부터 reusable로 짤 필요 없음. 첫 workflow 단순히 시작, 시간이 지나며 reusable로 진화.

추신 14. gh의 GraphQL은 REST 3 호출을 1로. 면접에서 "REST vs GraphQL 차이?" 단골. 5명 자경단도 GraphQL 한 번 써보면 배우는 게 많음.

추신 15. gh extension 5종(dash·poi·copilot·pr-tree·actions-cache)이 매일 30분 절약. 본인의 첫 extension은 `gh-dash`. 1주일 안에 익히면 매일 PR 흐름이 깔끔.

추신 16. 큰 회사의 5깊이(monorepo·flag·SRE·observability·governance)는 자경단의 5년 후 미래. 미리 알면 진화 시점에 망설임 0.

추신 17. branch protection의 9 검사를 다 외울 필요 없음. 자주 거부되는 3개(approvals·status check·conversation 해결)만 머리에 박기. 나머지는 검색.

추신 18. CODEOWNERS의 "owner 잘못된 핸들" 함정 — 존재하지 않는 사람·team mention하면 매칭 무시. 자경단 처음 셋업 시 `gh api repos/.../codeowners/errors`로 점검.

추신 19. conflict 알고리즘의 4종 중 myers는 1986년, histogram·patience는 2010년대. **30년의 진화가 자경단의 매일 conflict 5분을 사요**.

추신 20. fetch refspec의 `+`(force update)는 양날의 검. 평소엔 안전, 서버가 force push 했을 때 로컬도 갈아끼움. 본인이 force push 안 받았는데 sha 바뀌면 의심.

추신 21. shallow clone + filter blob:none 조합이 5년 자경단의 새 멤버 첫 day 5초 셋업. 큰 회사 표준.

추신 22. GitHub Actions의 self-hosted runner는 자체 서버. 무료 tier 부족 시 또는 사내 데이터 접근 시 도입. 자경단 5명은 거의 안 씀.

추신 23. gh의 cache는 1~10초. 빠르게 두 번 같은 명령 치면 두 번째는 캐시. 강제 무효화는 `gh cache delete --all`.

추신 24. 큰 회사의 RFC·ADR는 큰 결정의 git history. 자경단 5명도 매년 회고 전에 본인이 한 5분짜리 ADR 한 페이지 권장. **결정의 기록**.

추신 25. 본 H의 원리는 강의 한 번 듣고 다 외우려 하지 마세요. **사고 났을 때 다시 와서 처방을 찾는 사전**. 평생 사전.

추신 26. branch protection의 `Include administrators` ON이 본인을 묶는 자물쇠. 새벽 3시에 본인이 main에 직접 push 시도하면 GH006으로 거부. 본인의 자기 보호.

추신 27. `pre-receive` vs `post-receive` — pre는 검사·거부 가능, post는 알람·자동 트리거. GitHub은 pre로 7체크, post로 webhook 발송.

추신 28. CODEOWNERS의 "마지막 매치"가 헷갈리면 한 페이지로 적어 보세요. 자경단 매칭 트레이스 (2-2절)를 손으로 한 번 따라 그리면 평생 직관.

추신 29. 글로브 패턴 `[abc]`(집합)·`?`(한 글자)는 거의 안 씀. 자경단은 `*`·`**`·`/path/`만 쓰면 충분. 단순함이 효율.

추신 30. zdiff3 conflictstyle 2022년 도입 후 자경단의 conflict 마커가 더 깔끔. `merge.conflictstyle=zdiff3` 한 줄 글로벌 설정.

추신 31. patience 알고리즘은 git 1.7.0(2010)부터 표준. histogram은 git 2.2(2014)에 추가. **알고리즘은 진화의 화석**.

추신 32. GitHub Actions의 무료 tier 2,000분/월은 자경단 5명에 충분. 5명 × 100 PR/월 × 1분 = 500분. 4배 여유.

추신 33. matrix의 비용 — 9 job × 1분 = 9 CI 분. 자경단은 1 job × 1분 = 1 CI 분. 작은 팀의 CI 효율.

추신 34. gh CLI의 OAuth token은 `~/.config/gh/hosts.yml`. 본인 노트북에 평문 저장. macOS keychain 통합은 1Password SSH agent 같은 것 필요.

추신 35. gh extension은 npm·brew와 다른 자체 마켓. `gh extension search`로 탐색. `gh extension install`로 설치. 5분 안에 새 도구.

추신 36. 큰 회사의 governance(RFC·ADR)는 5명+ 결정 도구. 자경단도 첫 ADR을 자경단 시작 시 작성 — "왜 React + FastAPI + AWS인가" 한 페이지. 5년 후 회고에서 다시 읽으면 원래 결정의 직관.

추신 37. 본 H의 깊이를 자경단 일상에 적용 — 매일 6 손가락 + 매주 점검 + 매월 통계 + 매년 회고 + **사고 시 원리 회수**. 사고가 본 H의 가장 큰 사용처.

추신 38. 본 H를 다 읽은 본인이 한 가지 실험 — 자경단 repo의 `.git/config`를 직접 열어 refspec 한 줄 (`fetch = +refs/heads/*:refs/remotes/origin/*`)을 보세요. 그 한 줄이 분산 git의 본질이에요.

추신 39. 다음 H8은 적용/회고 — Ch005의 5명 자경단 협업을 한 페이지로 마무리, 5년 후 회수 지도, 자경단 첫 PR의 자신감, Ch006 예고. 본 H의 원리 + H1~H7의 모든 손가락이 H8의 한 페이지로. 🐾

추신 40. 본 H가 본 챕터의 가장 깊은 H. 다 읽은 본인은 자경단 운영의 80%를 알아요. 나머지 20%는 H8 + 자경단 1년 운영의 경험. 🐾🐾

추신 41. branch protection·CODEOWNERS·conflict·refspec·Actions·gh의 6 깊이가 본 H의 핵심. 6 깊이 × 자경단 5년 = 30년의 시니어 자산.

추신 42. 본 H를 두 번 읽으세요. 첫 번째는 큰 그림 (7섹션 흐름). 두 번째는 한 섹션 깊이 (2절 CODEOWNERS 알고리즘). 두 번 읽기가 한 번 따라치기보다 단단.

추신 43. 사고 났을 때 본 H를 다시 와서 그 사고의 원리 부분을 읽기. 사고 한 번이 평생 학습. 본 H는 사전이에요.

추신 44. 본 H의 마지막 한 줄 — 협업 도구는 깊이가 있고, 깊이를 알면 사고 시 시니어. **원리가 시니어의 차이**.

추신 45. CODEOWNERS의 알고리즘은 글로브 매칭 + 마지막 우선. 비슷한 알고리즘이 `.gitignore`·`.dockerignore`에도. 한 알고리즘이 5도구를 가르쳐요.

추신 46. histogram diff은 2014년부터 git 2.2에 들어왔어요. 자경단의 매일 conflict 5분이 30년 알고리즘 진화의 결과. 본인이 지금 누리는 효율이 30년의 누적.

추신 47. branch protection은 GitHub만 강제. 본인이 self-hosted Git 서버 (Gitea·GitLab·Bitbucket)로 옮기면 서버별 비슷한 메커니즘. **서버가 다르면 도구도 다름**.

추신 48. `git fsck --full`로 본인 자경단 repo의 무결성 점검. 1년에 한 번 또는 사고 의심 시. 자경단의 5년 후 1GB repo도 1분 안에 검사.

추신 49. zdiff3 + histogram + patience 셋이 자경단 conflict의 황금 조합. 한 번 셋업, 평생 효과. **3 도구가 5분 conflict를 1분으로**.

추신 50. 본 H를 끝낸 본인은 협업 도구의 80%를 봤어요. 나머지 20%는 큰 회사의 monorepo·flag·SRE·observability·governance. 자경단의 5년 후 자연스레 만남.

추신 51. branch protection의 server-side hook은 본인이 직접 못 봐요 (GitHub 비공개). 다만 동작 흐름 5단계 (push → 인증 → 권한 → 7체크 → ref 갱신)을 머리에 그리면 사고 5분 진단.

추신 52. CODEOWNERS의 OR 기본은 자경단의 단순함. AND가 필요하면 branch protection의 "Require approval from someone in CODEOWNERS" 한 번 더 ON. 두 도구의 합집합.

추신 53. conflict 알고리즘 4종 중 본인이 평소 알 필요 없음. histogram이 자동 적용. 다만 면접 질문에 "diff 알고리즘 알아요?" 답변 4종 = 시니어 신호.

추신 54. shallow clone (`--depth 1`)은 CI에서 표준. GitHub Actions의 `actions/checkout@v4` 기본이 shallow. 빠른 CI의 비밀.

추신 55. GitHub Actions의 reusable workflow는 자경단 5년 후의 산소. 처음 1년은 단순 workflow, 시간이 지나며 reusable로 진화. **진화의 자연스러움**.

추신 56. gh CLI의 GraphQL은 자경단 1년 차에 한 번 실험. REST 3 호출 → GraphQL 1 호출의 차이를 본인이 한 번 보면 신세계.

추신 57. 큰 회사의 5깊이 (monorepo·flag·SRE·observability·governance)는 자경단의 5년 미래. 본 H의 7절을 1년에 한 번씩 다시 읽으세요. **미리 알면 진화 시점에 망설임 0**. 🐾🐾🐾
