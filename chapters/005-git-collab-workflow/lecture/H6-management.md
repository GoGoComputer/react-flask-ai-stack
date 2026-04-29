# Ch005 · H6 — Git 협업 워크플로: 운영 — 1년 자경단의 자동화·통계·진화

> **이 H에서 얻을 것**
> - PR 자동 정리 — branch 머지 후 자동 삭제·dependabot·stale bot·docs Pages 자동 배포
> - release 자동화 — release-please·semantic-release·CHANGELOG 자동·SemVer 자동 결정
> - conflict 통계 — 어느 파일이 hot file인가, monorepo 협업의 hotspot 분석
> - workflow 매년 회고·갱신 — 5명 → 10명 → 50명 진화의 5단계 변화점
> - 자경단 1년 후·5년 후 운영 시나리오 — 셋업 30분이 1년·5년에 어떻게 변하는가

---

## 회수: H5의 시뮬레이션에서 본 H의 운영으로

지난 H5에서 본인은 자경단 5명의 30분 협업 시뮬레이션을 봤어요. 까미와 노랭이가 conflict 일으키고 5명이 다같이 풀고 PR 2개를 머지하는 한 사이클. 그건 **하루**의 그림이었어요.

이번 H6는 그 하루가 **1년·5년**으로 펼쳐질 때 무엇이 바뀌는가에요. 매일 30분 사이클이 1년 250 사이클이 되면, 손가락만으론 한계예요. 자동화가 들어와요. 통계가 들어와요. 회고가 들어와요. 본 H의 주제 — **운영**.

지난 Ch004의 H6는 1인 git 운영(개인 alias·gitignore 관리·hook 5계명). 이번 H6는 5명·1년 운영. 1인 → 5명 → 1년이 되면 손가락이 자동화에 자리를 내줘요. 자동화는 사람의 적이 아니라 친구 — **합의를 도구가 평생 기억해 주는 것**.

---

## 1. PR 자동 정리 — 머지 후 5초의 청소

PR이 머지되면 자경단은 5초 안에 다음 4가지를 자동화해요. 5명이 손으로 하면 5분 × 5명 = 25분. 자동화 셋업 5분이 매주 25분 × 50주 = 1,250분/년 = 20시간 절약.

### 1-1. branch 자동 삭제

PR 머지 후 feature branch가 origin에 영원히 남으면 1년 후 100개 브랜치 쓰레기. 자동 삭제 셋업.

```yaml
# .github/settings.yml (또는 organization Settings → General)
delete_branch_on_merge: true
```

또는 GitHub UI에서: Settings → General → Pull Requests → "Automatically delete head branches" ON.

머지 즉시 origin의 feature branch 삭제. 본인 노트북의 local branch는 그대로 — 본인이 `git branch -d feat/cat-card`로 직접 삭제. 또는 `git fetch --prune`로 한 번에 정리.

```bash
$ git fetch --prune
From github.com/cat-vigilante/cat-vigilante
 - [deleted]         (none)     -> origin/feat/cat-card     # 자동 삭제됨
 - [deleted]         (none)     -> origin/feat/cat-color
```

자경단 표준 — `fetch.prune=true` 글로벌 설정으로 매 fetch 시 자동 prune.

```bash
git config --global fetch.prune true
```

### 1-2. dependabot — 의존성 자동 업데이트 PR

`react`·`fastapi`·`@types/node` 등 의존성에 보안 취약점·새 버전이 나오면 dependabot이 자동 PR 생성.

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: npm
    directory: /frontend
    schedule:
      interval: weekly
    reviewers:
      - cat-vigilante/frontend
  - package-ecosystem: pip
    directory: /backend
    schedule:
      interval: weekly
    reviewers:
      - cat-vigilante/backend
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
```

매주 월요일 09:00 — dependabot이 5~10개 PR을 자동으로 만들어 둠. 본인이 일주일 동안 차례대로 머지. **보안 취약점 노출 시간을 1주일 → 0일로**.

### 1-3. stale bot — 죽은 PR·issue 자동 닫기

3개월 이상 활동 없는 PR·issue를 자동 닫음. 자경단의 issue 트래커가 깨끗.

```yaml
# .github/workflows/stale.yml
name: Mark stale issues and PRs
on:
  schedule:
    - cron: '0 0 * * 1'  # 매주 월요일 00:00 UTC
jobs:
  stale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v9
        with:
          days-before-stale: 60
          days-before-close: 90
          stale-issue-message: '60일 동안 활동이 없어 stale 라벨이 붙었어요. 30일 더 안 하면 자동 닫힘.'
          stale-pr-message: 'stale 라벨. 작성자가 한 코멘트 달면 다시 활성.'
```

stale → 60일 후 라벨 → 90일 후 닫힘. 부활은 한 코멘트로. **죽은 issue가 살아 있는 issue를 가려요**.

### 1-4. GitHub Pages — docs 자동 배포

`docs/` 디렉토리 또는 `gh-pages` branch의 마크다운을 자동 사이트로. main에 머지 시 자동 빌드·배포.

```yaml
# .github/workflows/docs.yml
name: Deploy docs
on:
  push:
    branches: [main]
    paths: ['docs/**']
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci && npm run docs:build
      - uses: actions/deploy-pages@v4
        with:
          path: ./docs/.vitepress/dist
```

`docs.cat-vigilante.org` 같은 도메인에 자동 배포. **본인이 docs 한 줄 고치면 5분 안에 사이트 갱신**.

---

## 2. release 자동화 — Conventional Commits가 SemVer를 결정

release-please 또는 semantic-release를 셋업하면 release가 자동.

### 2-1. release-please (Google) — 자경단 표준

main에 commit이 쌓이면 release-please가 PR을 자동 생성 — "v0.5.0 release". 본인이 이 PR을 머지하면 tag·release·CHANGELOG 자동.

```yaml
# .github/workflows/release-please.yml
name: release-please
on:
  push:
    branches: [main]
jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: googleapis/release-please-action@v4
        with:
          release-type: node    # 또는 python·go·simple
          package-name: cat-vigilante
```

머지된 commit의 type별 (Conventional Commits) SemVer 자동 결정:
- `feat:` → minor (1.0.0 → 1.1.0)
- `fix:` → patch (1.0.0 → 1.0.1)
- `feat!:` 또는 `BREAKING CHANGE:` → major (1.0.0 → 2.0.0)
- `docs:`·`chore:`·`refactor:` → release 안 만듦

본인의 매주 release 결정이 자동. **commit 양식이 release를 결정**.

### 2-2. CHANGELOG 자동

release-please가 CHANGELOG.md를 자동 생성·갱신. 머지된 PR의 commit 메시지를 type별로 정리.

```markdown
# Changelog

## [1.1.0](https://github.com/cat-vigilante/cat-vigilante/compare/v1.0.0...v1.1.0) (2026-05-12)

### Features
- **cat-card:** 신고 카드 컴포넌트 ([#42](https://github.com/cat-vigilante/cat-vigilante/issues/42)) ([d888f37](...))
- **cat-card:** 색깔 표시 ([#43](https://github.com/cat-vigilante/cat-vigilante/issues/43))

### Bug Fixes
- **api:** photo upload 500 에러 ([#45](https://github.com/cat-vigilante/cat-vigilante/issues/45))

### Documentation
- **CONTRIBUTING:** 첫 PR 가이드 추가 ([#46](https://github.com/cat-vigilante/cat-vigilante/issues/46))
```

**본인이 손으로 쓸 일 0**. PR 본문이 commit 메시지가 되고, commit 메시지가 CHANGELOG가 됨. 5단계 자동 흐름.

### 2-3. release 노트 5섹션 (Ch005 H1·H2 회수)

자동 노트 + 본인 30분 손 검수의 5섹션:
1. **한 줄 요약** — 사용자가 받는 가치 (예: "고양이 신고 시 사진 lazy load로 페이지 속도 50% 개선")
2. **Highlights** — 큰 기능 3개 (Features 중 골라서)
3. **Bug Fixes** — 자동 생성 그대로
4. **Migration** — Breaking changes 있으면 마이그레이션 가이드
5. **Contributors** — `@user1, @user2` 자동 mention

`gh release create v1.1.0 --generate-notes`가 1·3·5를 자동. 본인이 2·4를 30분 손 검수. **자동 80% + 손 20%**.

---

## 3. conflict 통계 — 어느 파일이 hot file인가

monorepo 자경단의 conflict가 한 달에 30번이면, 어느 파일이 가장 자주 충돌하는지 통계. hot file을 찾으면 그 파일의 구조를 개선·분리.

### 3-1. git log로 hot file 분석

```bash
# 최근 1년 동안 가장 많이 변경된 파일 Top 10
$ git log --since='1 year ago' --pretty=format: --name-only | \
  grep -v '^$' | sort | uniq -c | sort -rn | head -10

  127 frontend/src/App.tsx
   89 backend/api/main.py
   78 frontend/src/components/CatCard.tsx
   54 .github/workflows/ci.yml
   47 README.md
```

상위 5개가 자경단의 **hot file**. App.tsx가 127번 변경 = 매주 2~3번. 다섯 명이 다같이 건드림 = conflict 자주.

### 3-2. 처방 — hot file 쪼개기

App.tsx가 hot이면:
```
src/App.tsx (1000줄, 127번 변경)
↓
src/App.tsx (10줄, layout만)
src/routes.tsx (분리)
src/providers.tsx (분리)
src/Header.tsx (분리)
```

5개로 쪼개면 한 사람이 한 파일만 건드림 → conflict 1/5로. **hot file 분리가 conflict 예방**.

### 3-3. monorepo 협업의 hotspot

monorepo(`/frontend`·`/backend`·`/infra`·`/design` 한 repo)는 hot file 패턴이 명확:
- `package.json` (의존성 변경 시 자주 충돌)
- `lock file` (npm·yarn·pnpm·poetry)
- 공통 유틸 (`utils/index.ts`)

처방 — 의존성은 dependabot이 PR로 분리, lock file은 squash merge로 한 commit, 공통 유틸은 owner 분리(CODEOWNERS).

### 3-4. conflict 통계 대시보드 (보너스)

큰 자경단(20명+)은 GitHub Insights + 자체 대시보드:
- 주간 conflict 수
- hot file Top 10
- 평균 conflict 해결 시간
- 가장 많이 페어 리뷰한 두 사람

매월 회고에서 통계를 보고 hot file을 쪼개기. **데이터가 합의를 도와요**.

---

## 4. workflow 매년 회고 — 5명 → 10명 → 50명 진화

자경단이 1년 후 7명, 3년 후 15명, 5년 후 30명이 되면 workflow가 어떻게 바뀌는가. **매년 회고가 진화의 의식**.

### 4-1. 5단계 진화점 표

| 인원 | 단계 | 패턴 | 추가 셋업 |
|------|------|-------|---------|
| 1~5명 | 초기 | GitHub Flow | branch protection 7체크·CODEOWNERS 5팀·husky |
| 6~10명 | 성장 | GitHub Flow + 정식 staging | staging 환경·deploy preview·PR 1일 SLA |
| 11~25명 | 중간 | GitHub Flow + Git Flow 일부 | release branch·QA 단계·changelog v2 |
| 26~50명 | 큰 팀 | Trunk-based 전환 시작 | feature flag·CI 90%·deploy 자동·on-call rotation |
| 50명+ | 큰 회사 | Trunk-based 완성 | LaunchDarkly·monorepo 도구(Nx·Turborepo)·SRE팀 |

### 4-2. 자경단 1년 후 (인원 7명)

**바뀌는 것**:
- 팀 1개 추가 — `@cat-vigilante/devops` (미니가 외로워서 보충)
- branch protection의 required approvals — 1 → 2
- staging 환경 도입 — `staging.cat-vigilante.org`
- PR SLA — "1일 안에 첫 리뷰"

**그대로**:
- GitHub Flow 패턴
- husky·commitlint·CODEOWNERS

**회고 한 줄** — "5명 → 7명, GitHub Flow 유지, staging 추가, 머지 속도 절반".

### 4-3. 자경단 5년 후 (인원 30명)

**바뀌는 것**:
- Trunk-based 전환 — branch 1주일 → 1일
- feature flag 도입 — LaunchDarkly 또는 자체
- CI 90% 자동화 — flaky test 제거·병렬 실행
- on-call rotation — 5명이 1주씩
- SRE 팀 분리 — `@cat-vigilante/sre`

**5년 후 회고** — "5명 자경단이 30명 회사로. GitHub Flow → Trunk-based. release 매주 → 매일. deploy 1대 → 100대".

### 4-4. 회고 의식 5단계

매년 12월 마지막 주 자경단 5명(시간 흐른 후엔 N명)이 모여 1시간:

1. **숫자 회고** — 머지 PR 수·conflict 수·release 수·incident 수
2. **사람 회고** — 누가 가장 많이 리뷰? 누가 가장 많이 conflict? 페어 자주 한 두 사람?
3. **도구 회고** — branch protection 7체크 중 안 쓰는 것? CODEOWNERS 갱신?
4. **다음 해 결심** — 패턴 유지 vs 진화? 새 도구 도입?
5. **한 페이지 갱신** — `docs/WORKFLOW.md`를 한 페이지 갱신

**5단계 × 12분 = 60분**. 1년의 진화가 1시간에. **회고가 진화의 신호**.

---

## 5. 5년 운영 시뮬레이션 — 1년·3년·5년의 변화점

### 5-1. 1년 후 (2027년 5월)

- 인원 5 → 7명
- 머지 PR 누적 800
- release 누적 v0.5.0 → v1.2.0 (52 minor + 35 patch)
- conflict 누적 250 (평균 5분)
- 자경단 사이트 사용자 5,000명
- **새 도구**: signed commit ON·dependabot·release-please

### 5-2. 3년 후 (2029년 5월)

- 인원 7 → 15명
- 머지 PR 누적 5,000
- release 누적 v3.5.0
- conflict 누적 800 (평균 3분 — 도구 + 경험)
- 자경단 사이트 사용자 50,000명
- **새 도구**: feature flag (kill switch 5개)·monorepo Nx·CI 80% 자동

### 5-3. 5년 후 (2031년 5월)

- 인원 15 → 30명
- 머지 PR 누적 20,000
- release 누적 v8.0.0 (매주 minor + 매일 patch)
- conflict 누적 1,500 (평균 1분 — Trunk-based + 도구 자동)
- 자경단 사이트 사용자 500,000명
- **새 도구**: Trunk-based 완성·LaunchDarkly·SRE 팀·on-call rotation

**5년 곡선** — 인원 6배, PR 25배, release 30배, conflict 6배, 사용자 100배. **사용자 곡선이 가장 가파름**. 협업은 잘 운영되면 사용자 성장의 연료.

---

## 6. 자경단 한 페이지 — 운영 1년 체크리스트

```
[ ] 매주 월요일 09:00 — dependabot PR 5개 머지
[ ] 매주 금요일 17:00 — release-please PR 머지 (release tag 자동)
[ ] 매월 마지막 금요일 — workflow 미니 회고 30분
[ ] 매분기 마지막 주 — branch protection 7체크 점검·CODEOWNERS 갱신
[ ] 매년 12월 마지막 주 — 1시간 회고 5단계 (숫자·사람·도구·결심·한페이지)
[ ] 매년 6개월마다 — fine-grained PAT 마이그·signed commit ON 검토
[ ] 매년 — patterns 회고 (GitHub Flow 유지 vs Git Flow 일부 vs Trunk-based 전환)
```

7개 의식이 자경단 1년의 운영. **의식이 진화의 시계**.

---

## 7. 흔한 오해 7가지

**오해 1: "자동화는 큰 회사 도구예요."** — 5명도 효과적. branch 자동 삭제·dependabot·release-please는 5분 셋업, 매주 25분 절약. 작은 팀일수록 자동화 ROI 큼.

**오해 2: "release-please는 Conventional Commits 강박이에요."** — 강박이 아니라 자동화. type 7개 외우면 release 자동. **양식이 자동화의 입력**.

**오해 3: "stale bot은 사람을 차갑게 대해요."** — 60일 + 90일 = 5개월의 시간. 충분한 알람. 그래도 답 없으면 정말 죽은 issue. **죽은 issue가 살아 있는 issue를 가려요**.

**오해 4: "monorepo는 conflict 지옥이에요."** — hot file 분석 + 쪼개기 + CODEOWNERS로 conflict 1/5. monorepo의 친구가 분석. **데이터가 합의의 친구**.

**오해 5: "5명 자경단은 운영 의식 안 필요해요."** — 매년 1시간 회고는 5명도 필수. 진화 안 하는 자경단은 죽음. **회고가 산소**.

**오해 6: "Trunk-based는 50명+만 가능해요."** — 5명도 가능, 다만 인프라 필요(CI 90%·feature flag). 본 H의 5단계 진화표는 **인원 + 인프라**의 합. 인프라 단단하면 5명도 Trunk-based.

**오해 7: "자동화 셋업이 한 달 걸려요."** — 자경단 표준은 30분. branch 자동 삭제(1분)·dependabot(5분)·release-please(10분)·stale bot(5분)·docs Pages(10분). 5개 합 = 31분.

---

## 8. FAQ 7가지

**Q1. dependabot의 PR이 너무 많이 와요. 어떻게?**
A. `dependabot.yml`에서 schedule을 weekly → monthly로. 또는 grouping (관련 패키지 묶음 PR). 자경단 표준 — weekly + grouping(`react`·`@types/react`·`react-dom` 한 묶음).

**Q2. release-please가 만든 PR을 항상 머지해야 하나요?**
A. 아니. PR 본문 검수 후 머지 시점 본인 결정. 자경단은 매주 금요일 17:00 머지 표준. 급하면 더 자주.

**Q3. CHANGELOG가 너무 자세해요. 사용자에게 줄이려면?**
A. release-please 설정 `extra-files`로 별도 사용자 친화 파일 생성. 또는 GitHub Release 본문에 본인이 30분 손 검수로 5섹션 양식.

**Q4. monorepo 도구(Nx·Turborepo)는 언제 도입?**
A. 인원 15명 + repo가 monorepo + 빌드 5분+ 시점. 그 전엔 npm workspaces 정도로 충분. **도구는 필요 시점에**.

**Q5. workflow 매년 회고가 형식적이 되지 않으려면?**
A. 숫자 + 사람 + 도구 + 결심 + 한 페이지의 5단계 표준. 형식이 형식을 깨요. 매년 같은 5단계라도 답이 다름. **반복이 진화의 도구**.

**Q6. signed commit ON으로 바꾸면 5명 자경단 부담?**
A. 6개월 후 검토 권장. 셋업 비용 1시간 × 5명 = 5시간. 그 이후 매 commit signed (자동). 큰 회사로 갈 때 필수 도구. 6개월쯤 익숙해지면 자연스러움.

**Q7. on-call rotation은 자경단 5명에 필요한가요?**
A. 처음 1년은 메인테이너(본인) 1명이 24/7. 1년 후 7명 + prod 사용자 1만 명+면 도입 검토. 5명이 1주씩 = 5주 사이클. 새벽 3시 알람을 1년에 한 번씩만. **rotation이 새벽을 사요**.

**Q8. monorepo와 polyrepo 중 자경단은?**
A. 5명 자경단은 **monorepo** 권장 (frontend·backend·infra·design 한 repo). 이유 — 한 PR로 frontend·backend 양쪽 변경 가능, 한 곳에서 모든 issue·PR 관리, CODEOWNERS 한 파일에 5팀 매핑. 단점 — 빌드 시간 증가(Nx·Turborepo로 우회). 큰 회사(50명+)는 polyrepo로 분리하기도 하지만 자경단은 monorepo가 유리.

**Q9. 자경단의 첫 release v0.1.0은 언제?**
A. organization 셋업 후 1주일~1개월. README + CONTRIBUTING + LICENSE + 첫 기능 1개가 있으면 v0.1.0. SemVer는 0.x.y가 "초기 개발 단계"라 break 자유. 1.0.0은 "공식 stable" — 자경단의 첫 기능 5개 + 문서 + CI 안정 후 1.0.0 결정. 보통 6개월~1년 후.

**Q10. 큰 회사(facebook/react·fastapi/fastapi·vercel/next.js)는 자경단과 무엇이 다른가요?**
A. 도구 80% 같음 (branch protection·CODEOWNERS·CI·release 자동화). 다른 20% — 인원(50~500명), 패턴(Trunk-based 또는 release branch), 추가 도구(LaunchDarkly·Nx·SRE 팀·on-call). 본질은 같음. **자경단의 5년 후가 큰 회사**.

**Q11. workflow 회고 1시간이 너무 짧지 않나요?**
A. 5단계 × 12분이 정밀. 1시간 넘기면 효율 저하. 부족하면 1주일 후 보충 회고. 자경단 5명의 1년 회고 1시간이 표준. 작은 모듈(도구 점검)은 매분기 30분.

**Q12. 자동화 셋업 후에도 사고가 나면 본인 책임?**
A. 90% 본인 (메인테이너). 다만 5사고 표(9절)를 사전 알면 90% → 30%로 줄음. **사전 학습이 책임을 줄여요**. 회고에서 새 사고를 발견하면 해당 처방을 README·CONTRIBUTING에 박기. **사고 한 번이 평생 처방**.

---

## 9. 운영 사고 일지 — 자경단 1년의 5가지 사고

자경단 5명이 1년 운영하면 평균 5번 정도 큰 사고. 사고가 자경단의 진짜 학습. 5사고를 미리 알고 있으면 처방이 5분.

### 9-1. 사고 1: dependabot PR 100개 쌓임 (3월)

**증상**: 자경단 1년 차 3월. 본인이 dependabot 셋업 후 한 달 동안 PR 안 봤더니 100개 쌓임. 보안 취약점 알람 5개. 본인이 일주일 동안 차례대로 머지하기 부담.

**처방**: 
1. `dependabot.yml`에 grouping 추가 (`react`·`@types/react`·`react-dom` 한 묶음)
2. `schedule.interval`을 `weekly` → `monthly`로
3. 라벨 `dependencies` 자동 추가 → 본인이 라벨 필터로 한 번에 보기

5분 셋업 후 PR 수 100 → 20. 본인이 30분 안에 모두 검수·머지.

**회수** — dependabot은 친구지만, 무관심하면 적. **자동화도 매주 점검**.

### 9-2. 사고 2: release-please가 v2.0.0 자동 release (8월)

**증상**: 까미가 PR 본문에 `BREAKING CHANGE: API 변경`이라고 써서 머지. release-please가 즉시 v1.5.0 → v2.0.0 PR 자동 생성. 본인이 모름. 사용자가 갑자기 v2.0.0 release 알람 받음. 사용자 5명 마이그레이션 대혼란.

**처방**:
1. release-please PR 머지 전에 항상 본인 검수
2. `BREAKING CHANGE`를 PR 머지 전에 의도 확인 (까미가 진짜 break인가? 아니면 소소한 변경?)
3. release 노트 5섹션의 4번(Migration) 본인 손 검수 30분

**회수** — Conventional Commits의 `BREAKING CHANGE` 한 줄이 사용자 5명의 마이그레이션. **한 줄이 5명의 하루**.

### 9-3. 사고 3: hot file 폭발 — App.tsx 한 달 conflict 50번 (5월)

**증상**: 자경단 5명이 모두 `App.tsx`를 매일 건드림. 한 달 conflict 50번. 평균 conflict 해결 시간 5분 → 15분. 5명이 매일 30분씩 손해.

**처방**:
1. hot file 분석 (`git log --since='1 month ago' --pretty=format: --name-only | sort | uniq -c | sort -rn | head`)
2. App.tsx (1000줄) → 5개 파일로 쪼개기 (`App.tsx` 10줄·`routes.tsx`·`providers.tsx`·`Header.tsx`·`Footer.tsx`)
3. CODEOWNERS에 각 파일별 owner 분리
4. 한 달 후 재측정 — conflict 50 → 8

**회수** — hot file은 자동 진단되지 않아요. 매월 본인이 `git log` 한 줄로 진단. **데이터가 합의의 친구**.

### 9-4. 사고 4: stale bot이 살아 있는 issue 닫음 (10월)

**증상**: 노랭이가 6개월 전 만든 issue (디자인 개편)가 60일 후 stale 라벨, 90일 후 자동 닫힘. 노랭이가 알람 못 받음. 깜장이가 11월에 디자인 작업 시작하려는데 issue 사라짐.

**처방**:
1. stale bot 설정에 `exempt-labels: ['design', 'roadmap', 'q4-2026']` 추가
2. 중요 issue엔 `roadmap` 라벨 미리
3. 노랭이가 60일 stale 라벨 받았을 때 한 코멘트로 부활
4. monthly review에서 stale 라벨 자동 점검

**회수** — stale bot은 청소부. 청소부가 보물을 버리지 않게 라벨로 보호. **라벨이 보물의 표시**.

### 9-5. 사고 5: signed commit ON 후 자경단 push 거부 (11월)

**증상**: 본인이 signed commit을 main branch에 ON. 5명 중 깜장이가 GPG 키 셋업 안 됨. 깜장이 PR이 머지 거부. 깜장이가 1주일 동안 push 못 함.

**처방**:
1. signed commit ON 전에 5명 모두 GPG·SSH signing 셋업 1주일
2. ON 시점은 동시에 (한 사람이라도 안 되어 있으면 미루기)
3. GPG보다 SSH signing(2022년 추가)이 더 쉬움 — 기존 SSH 키 재사용
4. CONTRIBUTING.md에 "signing 셋업 5분 가이드" 추가

**회수** — signed commit ON은 5명 동시 준비 필수. 한 사람이라도 안 되면 1주일 손해. **변화는 5명이 동시에**.

### 9-6. 5사고 한 페이지 회수

| 사고 | 시점 | 처방 | 회수 |
|------|------|-----|------|
| dependabot 100개 | 3월 | grouping·monthly·라벨 | 자동화도 매주 점검 |
| release v2.0.0 자동 | 8월 | BREAKING CHANGE 본인 검수 | 한 줄이 5명의 하루 |
| App.tsx hot file | 5월 | 쪼개기 + CODEOWNERS | 데이터가 합의 친구 |
| stale 살아있는 issue | 10월 | exempt-labels | 라벨이 보물 표시 |
| signed commit 거부 | 11월 | 5명 동시 셋업 | 변화는 동시에 |

5사고를 미리 알고 있으면 본인의 자경단 1년이 5사고 → 0~1사고로. **알면 처방 5분, 모르면 사고 5시간**.

---

## 10. 추신

자동화는 5명에도 효과적이에요. branch 자동 삭제·dependabot·release-please 5분 셋업이 매주 25분 절약 — ROI 100배. dependabot의 weekly + grouping이 자경단 표준 — 한 주 5~10 PR을 차례로 머지, 보안 노출 1주일 → 0일. release-please는 Google 도구(semantic-release도 있음), 자경단은 release-please. CHANGELOG.md는 사용자의 일기장 — 매 release마다 한 줄, 5년 후 250줄. stale bot은 60일 + 90일 알람·청소부.

hot file 분석은 매월 첫 주 월요일 — `git log --since='1 month ago' --pretty=format: --name-only | sort | uniq -c | sort -rn | head` 30초 진단. 상위 5개 파일이 conflict 80%, 쪼개기가 가장 빠른 처방. App.tsx 1000줄 → 5파일 200줄 + CODEOWNERS owner 분리하면 conflict 50번 → 8번. monorepo는 자경단 5명에도 OK(npm·pnpm workspaces), 빌드 5분+ 되면 Nx·Turborepo 도입. signed commit ON은 6개월 후, on-call rotation은 1년 후 + 1만 명+.

5단계 진화표(5·10·25·50·50+)가 자경단의 미래예요. 매년 12월 마지막 금요일 1시간 회고 5단계(숫자·사람·도구·결심·한페이지). 운영의 세 척도 — 속도(release/주)·안정성(incident/월)·행복(개발자 만족도). 셋이 균형, 황금 비율 1:1:1. 자경단 표준 자동화 5종(branch 삭제·dependabot·stale·release-please·docs Pages) 셋업 30분 × 5년 = 400시간 절약.

본 H의 마지막 비밀 — **잘 운영되는 협업은 보이지 않아요**. 매일 30분 PR·매주 자동화 점검·매년 회고가 자연스럽게 흐르면 5명이 다른 일에 집중해요. 보이지 않는 운영이 진짜 운영. 운영은 손가락이 아닌 의식, 의식이 자동화의 곱셈. 30분 셋업·1주 점검·1년 회고가 자경단의 호흡이에요. 다음 H7은 원리/내부 — branch protection이 GitHub 내부에서 어떻게 강제되는지, CODEOWNERS 매칭 알고리즘, conflict 알고리즘 깊이. 본 H의 운영이 H7의 원리로 깊어져요. 🐾

