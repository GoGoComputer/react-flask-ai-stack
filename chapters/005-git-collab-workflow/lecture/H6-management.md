# Ch005 · H6 — 1년 자경단 운영 — 자동화·release·통계·진화

> 고양이 자경단 · Ch 005 · 6교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. PR 자동 정리 — 머지 후 5초의 청소
3. release 자동화 — Conventional Commits + SemVer
4. CHANGELOG 자동 생성
5. conflict 통계 — hot file 발견
6. workflow 매년 회고
7. 5년 운영 시뮬레이션 — 1년·3년·5년
7-보충. 의존성·보안 자동화 — 봇이 지키는 저장소
8. 자경단 운영 1년 체크리스트
9. 다섯 함정과 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리 — 다음 H7에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 자경단 1년 운영을 자동으로 — 강사 시연용
git push origin --delete <branch>                   # 머지 후 청소(자동화 대상)
npx semantic-release                                 # Conventional Commits → SemVer 자동
gh run list --workflow=release.yml                   # release 워크플로우 실행 확인
git log --since="1 month" --diff-filter=U --name-only | sort | uniq -c | sort -rn  # hot file
gh pr list --search "created:<2026-01-01 is:open"    # stale PR 찾기
gh api repos/:owner/:repo/dependabot/alerts          # 보안 알림
gh run list --json conclusion,startedAt              # CI 통계
```

이 한 화면이 오늘 60분의 지도예요. H5에서 본 30분 한 사이클이 1년 동안 수백 번 반복되면, 사람이 일일이 손으로 못 하니 자동화가 필요해져요 — 청소·release·CHANGELOG·통계가 다 기계의 일이 돼요. 강사는 위에서 아래로 한 번 훑고 시작하면 돼요. 오늘의 한 줄 — **사람은 판단, 기계는 반복.**

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요. 마지막 큰 시간이에요.

지난 H5 회수. 30분 시뮬. 두 PR, conflict 해결, force-with-lease.

이번 H6은 1년 운영. 자동화, release, 통계, 진화.

H5가 "하루(30분 한 사이클)"였다면, H6은 "1년"이에요. 같은 사이클이 1년 동안 750번 반복되면, 사람이 일일이 못 해요 — 그래서 자동화가 등장해요. 오늘은 협업이 "매일의 손"에서 "1년의 시스템"으로 자라는 걸 봐요. 그리고 좋은 소식 — 자동화 셋업은 대부분 한 번 10분이에요. 그 10분이 1년의 수작업을 없애요. 오늘은 그 마법 같은 ROI의 시간이에요.

오늘의 약속. **본인의 자경단 저장소가 5년 운영 가능한 표준이 됩니다**.

한 가지 미리 안심을. 오늘 YAML 파일이 몇 개 나와요(cleanup·release). 그 문법을 다 외우려 마세요 — 표준 파일을 복사해 쓰면 되고, 핵심은 "무엇이 자동화되나"(청소·release·CHANGELOG·통계)예요. 그리고 좋은 소식 — 이 자동화는 한 번 깔면 1년 내내 작동해요. 오늘은 "한 번의 셋업이 1년을 일한다"는 자동화의 마법을 보는 시간이에요. 외울 건 적고, 얻을 건 많아요. 자, 가요.

---

## 2. PR 자동 정리 — 머지 후 5초의 청소

머지 직후 자동 청소. GitHub Actions.

`.github/workflows/cleanup.yml`.

```yaml
name: PR Cleanup

on:
  pull_request:
    types: [closed]

jobs:
  cleanup:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Delete branch
        run: |
          git push origin --delete ${{ github.event.pull_request.head.ref }} || true
      
      - name: Comment thanks
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '🐱 머지 완료! branch 자동 삭제 했어요.'
            })
```

머지 직후 자동. 자경단 매주 15 PR이 자동 정리.

이 워크플로우를 한 줄씩 읽어 볼게요. `on: pull_request: types: [closed]`는 "PR이 닫힐 때 실행", `if: merged == true`는 "머지된 경우만"(그냥 닫힌 건 제외). 그러면 머지된 PR의 branch를 자동 삭제하고, "🐱 머지 완료!" 감사 코멘트를 남겨요. 사람이 매번 `--delete-branch`를 안 쳐도 되고, 동료에게 따뜻한 인사도 자동이에요. GitHub Actions는 이렇게 "PR 닫힘" 같은 사건(event)에 반응해 자동으로 일해요. 이게 자동화의 첫 모양 — "어떤 일이 일어나면 → 이걸 해라"예요. 머지 후 5초의 청소가 1년이면 750번, 그게 다 자동이에요. 사람이 750번 손으로 할 일을 기계가 가져가는 거예요.

GitHub Actions를 처음 보는 본인을 위해 한 줄 — Actions는 "저장소에서 일어나는 사건에 반응해 자동으로 스크립트를 돌리는" 도구예요. `.github/workflows/`에 YAML 파일을 두면, push·PR·schedule 같은 사건마다 ubuntu 가상 머신이 떠서 본인이 적은 단계(steps)를 실행해요. 무료로 매월 2,000분을 줘요. 이게 모든 자동화의 엔진이에요 — 청소도, release도, CI도 다 Actions 위에서 돌아요. H7에서 이 엔진의 내부를 깊이 봐요. 오늘은 "이걸로 뭘 할 수 있나"(청소·release·통계)를 보는 거예요.

Actions의 trigger(사건)는 여럿이에요 — push(올릴 때), pull_request(PR 열거나 닫을 때), schedule(정해진 시각마다, 예: 매주 월요일 9시), workflow_dispatch(수동 버튼), release(release 만들 때). 자경단의 cleanup은 pull_request closed, release는 push main, dependabot은 schedule을 써요. "X가 일어나면 Y를 해라"의 X 자리에 이 trigger들이 들어가요. 매주 월요일 통계를 자동으로 모아 슬랙에 보내는 것도 schedule trigger 한 줄이면 돼요. 자동화의 상상력은 trigger에서 시작해요 — "언제 무엇을"만 정하면 기계가 그걸 영원히 반복해요.

자경단의 첫 자동화가 바로 이 cleanup이에요 — 가장 단순하고, 효과가 즉각 보이거든요. 머지하면 branch가 사라지고 고양이 인사가 뜨는 걸 보면 "아, 자동화 좋네" 싶어요. 그 작은 성공이 다음 자동화(release·통계)로 이어져요. 자동화는 큰 걸 한 번에가 아니라, 작은 걸 하나씩 늘려 가는 거예요. 본인의 첫 워크플로우도 이렇게 단순한 것부터 시작하세요 — 거창한 CI/CD 파이프라인이 아니라, 머지 후 branch 삭제 한 줄부터.

---

## 3. release 자동화 — Conventional Commits + SemVer

`.github/workflows/release.yml`.

```yaml
name: Release

on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      
      - run: npm install -g semantic-release @semantic-release/changelog @semantic-release/git
      
      - run: semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

`.releaserc.json`.

```json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/github",
    "@semantic-release/git"
  ]
}
```

Conventional Commits을 보고 SemVer 자동 결정. `feat:` → minor, `fix:` → patch, `BREAKING CHANGE:` → major.

자경단 2주에 한 번 자동 release.

release 자동화가 왜 강력하냐면, 사람이 하던 "귀찮고 실수 잦은 일"을 다 가져가기 때문이에요. 수동 release는 — 버전 정하기(이게 minor야 major야?), 태그 찍기, CHANGELOG 쓰기, GitHub Release 만들기, 다 손으로. 한 단계만 빠뜨려도 사고예요. semantic-release는 main에 머지될 때마다 commit들을 읽어 이 다섯 단계를 1초에 다 해요. 사람은 그냥 `feat:`·`fix:`만 잘 쓰면 돼요(H3 회수). "좋은 commit 메시지"라는 작은 규율이 "release 자동화"라는 큰 보상으로 돌아오는 거예요. 첫 commit부터 접두사를 지킨 본인이 여기서 공짜 선물을 받아요. 규율이 자유를 주는 역설 — 형식을 지키니 수작업에서 해방되는 거예요.

`.releaserc.json`의 다섯 plugin을 한 줄씩 — commit-analyzer(접두사 읽어 버전 결정), release-notes-generator(release 노트 작성), changelog(CHANGELOG.md 갱신), github(GitHub Release 생성), git(태그·버전 commit). 이 다섯이 줄줄이 이어져 "commit → 버전 → 노트 → CHANGELOG → Release → 태그"를 한 번에 해요. 본인이 이 plugin들을 깊이 알 필요는 없어요 — 표준 설정 그대로 쓰면 되고, 필요할 때 하나씩 커스터마이즈해요. 자동화의 좋은 점은 "안을 다 몰라도 표준대로 쓰면 작동한다"는 거예요. 다만 H7에서 그 안이 어떻게 도는지 한 번 들여다보면, 자동화가 마법이 아니라 정직한 단계의 연쇄라는 걸 알게 돼요.

한 가지 셋업 팁 — release.yml의 `GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}`은 GitHub이 자동으로 주는 토큰이에요(별도 발급 불필요). 이걸로 Actions가 본인 대신 태그를 찍고 Release를 만들어요. 비밀은 코드가 아니라 secrets에(H3). 그래서 release 자동화는 토큰 발급 없이 거의 복사-붙여넣기로 돼요. 자동화의 진입장벽이 생각보다 낮은 이유예요 — 표준 파일 두 개면 1년의 release가 자동이 돼요.

`.releaserc.json`의 `branches: ["main"]`은 "main에 머지될 때만 release"라는 뜻이에요. 큰 회사는 여기에 `next`·`beta` 같은 브랜치를 더해 "베타 release"를 따로 내기도 해요(Git Flow의 release 브랜치 회수). 자경단은 main 하나라 단순하고요. 설정 한 줄로 release 정책이 정해지는 거예요 — 코드가 곧 정책이에요. 이렇게 "정책을 코드로 적는 것"(Infrastructure as Code의 정신)이 현대 운영의 핵심이에요. 클릭으로 한 설정은 휘발되지만, 파일로 적은 정책은 git에 기록되고 재사용돼요.

---

## 4. CHANGELOG 자동 생성

위 semantic-release가 CHANGELOG.md 자동 생성.

```markdown
# Changelog

## [1.1.0](https://github.com/cat-vigilante/site/compare/v1.0.0...v1.1.0) (2026-05-12)

### Features

* **api:** GET /cats endpoint ([abc1234](https://github.com/...))
* **ui:** cat photo gallery ([def5678](https://github.com/...))

### Bug Fixes

* **api:** missing CORS header ([ghi9012](https://github.com/...))
```

수동 0. 자동 100%. 자경단 매 release.

CHANGELOG가 왜 중요하냐면, 이게 "사용자와 동료에게 보내는 편지"이기 때문이에요. "Features"에 새 기능, "Bug Fixes"에 고친 것, 각 항목에 commit 링크까지. 사용자는 이걸 보고 "아, 이번 버전에 이게 추가됐구나"를 알아요. 동료는 "지난 2주에 뭐가 바뀌었지?"를 한눈에 보고요. 옛날엔 이걸 사람이 손으로 썼어요 — 빠뜨리고, 틀리고, 안 쓰고. semantic-release는 commit 접두사를 읽어 완벽하게 자동 생성해요. `feat`은 Features로, `fix`는 Bug Fixes로 자동 분류. 본인이 commit을 잘 쓰면 CHANGELOG가 저절로 좋아져요. 변경 이력이 곧 팀의 기억이고, 그 기억이 자동으로 쌓이는 거예요.

CHANGELOG의 한 줄을 보세요 — `## [1.1.0](compare/v1.0.0...v1.1.0)`. 이 링크는 "v1.0.0과 v1.1.0 사이의 모든 변경"을 GitHub에서 한 번에 보여줘요. 그리고 각 항목의 commit 링크로 "이 기능이 어떤 commit에서 왔나"를 추적해요. 그래서 CHANGELOG는 단순 목록이 아니라 "클릭하면 깊이 파고드는 변경 지도"예요. 사용자가 "이 버그가 정말 고쳐졌나?"를 의심하면, CHANGELOG의 링크를 따라 실제 commit을 확인할 수 있어요. 투명성이 신뢰를 만들어요. 오픈소스가 신뢰받는 이유 중 하나가 이 추적 가능한 변경 이력이에요.

CHANGELOG에도 표준이 있어요 — "Keep a Changelog"라는 형식(Added·Changed·Fixed·Removed 섹션). semantic-release가 이 표준을 따라 자동 생성하니, 본인 CHANGELOG가 전 세계 오픈소스와 같은 모양이 돼요. 사용자가 어느 프로젝트의 CHANGELOG를 봐도 익숙하게 읽을 수 있고요. 표준을 따르는 작은 선택이 사용자 경험을 좋게 해요. 본인만의 형식을 발명하지 말고 표준을 쓰는 것 — 이게 협업과 운영 내내 반복되는 지혜예요(H3 commitlint 회수). 모두가 아는 표준이 본인만의 창의보다 강해요.

---

## 5. conflict 통계 — hot file 발견

같은 파일이 자주 충돌하면 그 파일이 hot file. 분리 신호.

```bash
# 최근 한 달 conflict 파일
git log --since="1 month ago" --diff-filter=U --name-only --pretty=format: | sort | uniq -c | sort -rn | head -10
```

진짜 출력.

```
   12 backend/api/routes.py
    8 frontend/components/Header.tsx
    5 package.json
    3 ...
```

routes.py가 12번 충돌. 너무 많음. 작은 파일들로 분리 신호.

자경단 매월 점검.

이 한 줄 명령이 운영의 보석이에요. `git log --diff-filter=U`는 "충돌(Unmerged)이 났던 commit", `--name-only`로 파일명만, `sort | uniq -c | sort -rn`으로 "많이 충돌한 순". 그러면 routes.py가 12번으로 1위. 이건 단순한 통계가 아니라 "이 파일을 쪼개라"는 데이터 기반 조언이에요(SOLID의 SRP — 한 파일은 한 책임). routes.py를 cats.py·users.py·photos.py로 나누면, 다섯 명이 각자 다른 파일을 건드려 충돌이 12번에서 2번으로 줄어요. 충돌을 "참는" 게 아니라 "구조로 없애는" 거예요. 데이터가 리팩터링을 가리켜요. H5에서 "충돌은 1분에 푼다"였다면, H6은 "충돌이 안 나게 구조를 바꾼다"예요 — 한 단계 위의 운영이에요.

hot file 말고도 운영자가 보는 통계가 더 있어요. **PR 사이즈** — 평균 PR이 200줄에서 400줄로 커지면 "리뷰가 느려지는 중"이라는 신호(쪼개라). **머지 시간** — PR이 올라와 머지되기까지 8시간에서 2일로 늘면 "리뷰가 막히는 중"(리뷰어를 늘려라). **CI 시간** — 빌드가 5분에서 20분으로 늘면 "느려지는 중"(cache·matrix로 단축, H7). 이 숫자들이 팀 건강의 체온계예요. 매월 한 번 재 두면, 문제가 곪기 전에 잡아요. 통계 없는 운영은 증상이 터질 때까지 모르는 운영이에요. 측정이 운영의 눈이에요.

이 통계들을 어떻게 모으냐고요? 일부는 명령 한 줄(`gh pr list --json`으로 PR 데이터, `gh run list --json`으로 CI 시간), 일부는 GitHub Insights 탭(저장소의 통계 대시보드)에서 봐요. 더 깊이 가면 별도 도구(LinearB·Swarmia)가 "DORA 지표"(배포 빈도·변경 실패율·복구 시간·리드타임 네 가지)를 자동으로 그려줘요 — 이 네 지표가 팀 성과의 업계 표준이에요(Ch103). 처음엔 명령 한 줄로 충분하고, 팀이 크면 도구를 더해요. 핵심은 "숫자를 정기적으로 본다"는 습관이지 도구가 아니에요.

---

## 6. workflow 매년 회고

매년 한 번 자경단 회고.

```
2026년 자경단 회고

지표:
- 총 PR: 750건
- 평균 머지 시간: 8시간
- conflict: 45건 (6%)
- production 사고: 3건
- hot file Top 3: routes.py, Header.tsx, package.json

진화:
- GitHub Flow → 일부 trunk-based 차용
- feature flag 도입
- CODEOWNERS 6개 → 12개

다음 1년:
- conflict 6% → 3%
- 사고 3건 → 0건
- 자동화 80% → 95%
```

자경단의 회사화.

회고의 핵심은 "숫자로 보기"예요. "PR 750건, 머지 8시간, conflict 6%, 사고 3건" — 이 숫자가 있어야 "내년엔 conflict 3%, 사고 0건"이라는 목표가 의미 있어요. 막연히 "잘하자"가 아니라 측정 가능한 목표 셋. 그리고 회고는 blameless(§9 함정) — "누가 사고 쳤나"가 아니라 "시스템의 어디가 약했나"를 봐요. 사고 3건이 났으면 "왜 막는 장치가 없었나"를 묻지 "누구 탓"을 안 물어요. 사람을 탓하면 다들 사고를 숨기고, 시스템을 고치면 다음 사고가 줄어요. 회고는 팀이 1년에 한 번 더 똑똑해지는 의식이에요. 자경단이 "주먹구구 다섯 명"에서 "성장하는 팀"으로 자라는 비결이고요.

postmortem(사후 분석)을 한 번 더. 사고가 나면 자경단은 한 페이지 문서를 써요 — 무슨 일이(타임라인), 왜(근본 원인), 어떻게 막을지(액션). 핵심은 "blameless" — "까미가 실수했다"가 아니라 "실수가 main에 들어가게 한 시스템의 구멍"을 봐요. 왜냐면 사람을 탓하면 다들 사고를 숨기고, 숨기면 배울 수 없거든요. Google·Netflix의 SRE 문화가 이거예요. 사고는 "누구의 잘못"이 아니라 "시스템의 학습 기회". 자경단도 사고 3건마다 3개의 postmortem을 쓰고, 그게 다음 해 사고를 0으로 만드는 약이 돼요. 실수를 벌하는 팀은 안 자라고, 실수에서 배우는 팀은 자라요.

§6의 회고 양식을 한 번 더 읽어 볼게요 — 지표(숫자), 진화(바뀐 것), 다음 1년(목표 3개). "총 PR 750, conflict 6%, 사고 3"이 지표, "GitHub Flow에 trunk-based 차용, feature flag 도입"이 진화, "conflict 3%, 사고 0, 자동화 95%"가 다음 목표. 한 페이지면 끝이에요. 이 한 페이지를 매년 쓰면, 5년 후 다섯 장이 자경단의 성장 일기가 돼요. 5년 전 "PR 750"이 "5000"이 된 걸 보면 뿌듯하고, "conflict 6%"가 "2%"가 된 걸 보면 노력이 보여요. 회고는 과거를 정리하는 게 아니라 미래를 겨누는 거예요.

---

## 7. 5년 운영 시뮬레이션 — 1년·3년·5년

**1년차** (현재). 5명, 750 PR/년, GitHub Flow, 수동 일부.

**3년차**. 10명. 1500 PR/년. branch protection 확장. dependabot 자동.

**5년차**. 30명. 5000 PR/년. trunk-based + feature flag. 자동화 95%.

진화 한 줄. **사람 늘어날수록 도구가 사람 일을 대신**.

이 진화를 자세히 보면 한 가지 원리가 보여요 — "사람이 늘면 합의 비용이 폭발한다"예요. 5명일 땐 말로 합의가 되지만, 30명일 땐 말로 안 돼요. 그래서 30명 팀은 더 많은 자동화(feature flag·CI·자동 배포)와 더 명시적인 규칙(RFC·ADR 문서)이 필요해요. 도구가 "사람 사이의 합의"를 대신하는 거예요. 재미있는 건, 기본 워크플로우(GitHub Flow)는 5년 내내 그대로라는 점이에요 — 위에 자동화와 규칙을 얹을 뿐, 토대는 안 바뀌어요. 그래서 오늘 배운 게 5년 후에도 쓸모 있어요. 진화는 갈아엎기가 아니라 층층이 쌓기예요. 본인이 첫해에 깐 토대가 5년 빌딩의 1층이에요.

30명 팀의 "명시적 규칙" 두 가지를 미리 봐 둘게요 — RFC(Request for Comments)와 ADR(Architecture Decision Record). RFC는 "큰 변경을 하기 전 글로 제안하고 모두가 의견을 다는" 문서예요(깊이2 의도 충돌을 글로 푸는 H1). ADR은 "왜 이 기술을 골랐나"를 기록하는 짧은 문서고요. 5명일 땐 말로 하던 걸, 30명일 땐 글로 남겨요 — 사람이 많으면 "말"은 휘발되고 "글"만 남거든요. 이게 팀이 커질 때 자동화와 함께 늘어나는 "문서화"예요. Ch103·Ch120에서 깊이 만나요. 오늘은 "아, 팀이 크면 글이 늘어나는구나"만 머리에 담아 두세요.

본인이 1년차 자경단에서 어떤 자리인지 그려 볼게요. 5명 팀, 매주 15 PR, 본인은 메인테이너로 모든 PR의 1차 리뷰어이자 머저. 자동화(청소·release)는 이미 돌고 있고, 본인은 매월 통계를 보고 hot file을 찾고, 매년 회고를 주재해요. 이게 신입 개발자가 아니라 "팀을 운영하는 사람"의 자리예요. 두 해 코스를 마치면 본인이 실제로 이 자리에 서요 — 작은 오픈소스나 사이드 프로젝트의 메인테이너로. 오늘 배운 1년 운영이 그날의 본인을 미리 준비시켜요.

---

## 7-보충. 의존성·보안 자동화 — 봇이 지키는 저장소

운영의 큰 부분이 "의존성 관리"예요. 본인 코드는 깨끗해도, 쓰는 라이브러리(npm·pip 패키지)에 보안 구멍이 생기면 본인 사이트가 위험해져요. 이걸 사람이 일일이 챙길 순 없어요 — 패키지가 수백 개니까요. 그래서 봇이 대신 챙겨요.

**dependabot**(GitHub 무료)이 매주 의존성을 검사해, 보안 패치나 새 버전이 나오면 자동으로 PR을 만들어요. 본인은 그 PR의 CI가 초록불인지 보고 머지만 하면 돼요. **security alert**는 더 급한 것 — 알려진 취약점(CVE)이 본인 의존성에 있으면 즉시 알려줘요. 매일 봐야 하는 한 가지예요.

그리고 H3에서 본 secret scanning이 "실수로 올린 API 키"를 자동으로 잡고, husky의 pre-commit이 "비밀이 commit에 섞이는 걸" 막아요. 이 셋(dependabot·secret scanning·pre-commit)이 저장소의 24시간 보안 경비예요. 사람이 잠든 새벽에도 봇이 지켜요. 운영에서 "보안"은 거창한 게 아니라, 이 봇들을 켜 두고 그들의 알림을 존중하는 습관이에요. 봇이 만든 PR을 무시하면 봇이 없는 거나 마찬가지예요(§9 함정 4).

봇이 지키는 저장소의 핵심 철학 — "사람은 잊고 기계는 기억한다"(Ch004 H7). 사람은 보안 패치를 깜빡하고, 비밀을 실수로 올리고, 의존성 업데이트를 미뤄요. 봇은 안 잊어요. 그래서 운영의 보안은 "본인이 완벽해지는 것"이 아니라 "봇을 켜 두는 것"이에요. 완벽한 사람은 없지만, 지치지 않는 봇은 있거든요. 그 봇들에게 잡일을 맡기고, 본인은 봇이 못 하는 판단에 집중해요. 이게 사람과 기계가 각자 잘하는 일을 나눠 갖는 현대 운영의 모습이에요.

---

## 8. 자경단 운영 1년 체크리스트

```
[1]  PR cleanup workflow ✓
[2]  release 자동화 (semantic-release) ✓
[3]  CHANGELOG 자동 ✓
[4]  conflict 통계 매월 ✓
[5]  hot file 분리 매분기 ✓
[6]  dependabot 매주 ✓
[7]  security alert 매일 ✓
[8]  CI 시간 측정 매월 ✓
[9]  PR 사이즈 통계 매분기 ✓
[10] 회고 매년 ✓
```

10단계 자경단 운영.

이 열 단계를 리듬으로 묶어 두면 운영이 안 빠뜨려져요 — 매일(보안 알림), 매주(dependabot·PR cleanup은 자동), 매월(conflict 통계·CI 시간), 매분기(hot file 분리·PR 사이즈), 매년(회고). 그리고 [1]~[3](cleanup·release·CHANGELOG)은 한 번 셋업하면 영원히 자동이라, 실제로 본인이 "챙길" 건 매월·매분기·매년 몇 개뿐이에요. 자동화가 일을 다 가져가서, 운영이 "매일 바쁜 일"이 아니라 "가끔 점검하는 일"이 돼요. 운영을 잘한다는 건 바쁘게 일하는 게 아니라, 시스템을 잘 깔아 한가해지는 거예요. 좋은 운영자의 책상은 의외로 조용해요 — 시스템이 대신 일하고 있으니까요.

이 열 단계 + 7-보충(보안 봇)이 자경단의 1년 운영 전체예요. 거창해 보여도, 절반은 자동(셋업 후 안 만짐)이고 나머지는 매월·매년의 짧은 점검이에요. 본인이 이걸 첫해에 깔면, 5년 차에 30명이 되어도 이 토대 위에 자동화와 규칙을 얹기만 하면 돼요. 5년 운영의 1층을 오늘 짓는 거예요. 그래서 첫해의 운영 셋업이 가장 중요해요 — 뼈대를 잘 세우면 살은 나중에 붙여도 돼요.

---

## 9. 다섯 함정과 처방

**함정 1: 자동화를 안 해서 매번 수동으로.** branch 삭제·release·CHANGELOG를 매번 손으로 하다 빠뜨리고 틀려요. 처방 — GitHub Actions로 자동화. 한 번 10분이 1년의 수작업을 없애요. "두 번 할 일은 자동화한다"가 운영의 첫 규칙이에요.

**함정 2: 사고가 나도 회고(postmortem)를 안 함.** 그냥 고치고 넘어가니 같은 사고가 또 나요. 처방 — blameless postmortem 문서. "누구 탓"이 아니라 "시스템의 어디가 약했나"를 적어요. 회고가 같은 사고에 대한 면역이에요.

**함정 3: hot file을 방치.** routes.py가 매월 충돌해도 그냥 참아요. 처방 — 매월 conflict 통계로 hot file을 찾아 쪼개요. 충돌을 참는 게 아니라 구조로 없애요(SRP). 데이터가 리팩터링을 가리켜요.

**함정 4: dependabot PR을 무시.** 의존성 보안 업데이트 PR이 쌓이는데 안 봐요. 처방 — 매주 처리. 보안 구멍을 막는 일이라 미루면 위험해요. dependabot은 본인 대신 보안을 챙기는 봇이니, 그 PR을 존중하세요.

**함정 5: CI가 점점 느려지는 걸 방치.** 빌드가 10분, 20분으로 늘어도 참아요. 처방 — cache(의존성 캐싱)와 matrix(병렬 실행)로 단축. CI 시간을 매월 측정해 "느려지는 추세"를 일찍 잡아요. 느린 CI는 다섯 명의 시간을 매일 갉아먹어요(H7에서 깊이).

---

## 10. 흔한 오해 다섯 가지

**오해 1: "자동화는 시니어나 하는 고급 작업이다."** 신입 1년 차부터 해요. semantic-release·dependabot 셋업은 각각 10분이고, 그 10분이 1년의 수동 작업을 없애요. 오히려 신입일수록 자동화로 잡일을 덜고 학습에 집중하는 게 좋아요. 자동화는 실력이 아니라 습관이에요 — "이걸 두 번 할 것 같으면 자동화한다"는 습관.

**오해 2: "SemVer 버전 매기기가 어렵다."** Conventional Commits만 지키면 자동이에요. feat→minor, fix→patch, BREAKING→major를 semantic-release가 알아서 정해줘요. 본인이 버전 숫자를 고민할 필요가 없어요 — 그냥 `feat:`·`fix:`만 잘 붙이면, 도구가 1.2.0이냐 1.1.3이냐를 정해요. 어려운 건 사람이 손으로 할 때고, 자동이면 쉬워요.

**오해 3: "통계는 있으면 좋은 옵션이다."** 통계가 운영의 눈이에요. conflict 통계로 hot file을 찾고, PR 사이즈 통계로 "PR이 커지는 추세"를 잡고, CI 시간 통계로 "빌드가 느려지는 걸" 알아채요. 숫자가 없으면 문제가 곪을 때까지 모르고, 숫자가 있으면 일찍 잡아요. "측정할 수 없으면 개선할 수 없다"는 운영의 첫 계명이에요(Ch003 H8 회수).

**오해 4: "회고는 큰 회사나 하는 거다."** 다섯 명도 해요. 오히려 작을 때 회고 습관을 들여야 커져도 자연스러워요. 1년에 한 번, 한 페이지, 한 시간이면 충분해요. 지난 1년의 숫자를 보고 다음 1년 목표 셋을 정하는 것 — 그게 "주먹구구 팀"과 "성장하는 팀"을 가르는 차이예요. 회고는 팀이 배우는 방식이에요.

**오해 5: "5년 후엔 지금 배운 게 다 쓸모없어질 거다."** GitHub Flow·Conventional Commits·자동화는 5년 후에도 그대로예요. 진화는 "갈아엎기"가 아니라 "더하기"예요 — 팀이 커지면 feature flag를 더하고, release 브랜치를 더할 뿐, 기본은 유지돼요. 오늘 잘 깐 1년 운영 표준이 5년 운영의 토대가 돼요. 기초는 오래가요.

다섯 오해를 한 줄로 — 운영은 "큰 회사의 사치"가 아니라 "작은 팀의 필수"예요. 자동화도, 통계도, 회고도 다섯 명부터 해요. 작을 때 들인 습관이 커져도 자연스럽고, 작을 때 안 들이면 커져서 고생해요. 운영은 미루는 게 아니라 처음부터 작게 시작하는 거예요.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. semantic-release 셋업이 복잡하지 않아요?** 10분이면 돼요. `.github/workflows/release.yml`과 `.releaserc.json` 두 파일만 만들면 끝이에요(§3). 그 뒤론 main에 머지될 때마다 자동으로 commit 접두사를 읽어 버전을 정하고, 태그를 찍고, CHANGELOG를 쓰고, GitHub Release를 만들어요. 한 번 셋업하면 1년 내내 손 댈 일이 없어요. 처음 10분이 1년의 수동 release 작업을 없애요.

**Q2. dependabot이랑 Renovate 중 뭘 써요?** dependabot은 GitHub 기본 제공(무료, 설정 간단), Renovate는 더 강력하고 세밀(grouping·schedule 등). 자경단은 dependabot으로 시작해서 의존성이 많아지면 Renovate로 옮겨요. 둘 다 "의존성 업데이트 PR을 자동 생성"이라는 같은 일을 해요. 핵심은 도구가 아니라 "의존성을 사람이 일일이 안 챙겨도 되게" 자동화하는 거예요.

**Q3. hot file은 몇 번 충돌하면 hot file이에요?** 정해진 숫자는 없지만, 자경단은 "월 5회 이상 충돌"을 기준으로 봐요. 한 파일이 자꾸 충돌한다는 건 너무 많은 책임이 한 파일에 몰려 있다는 신호예요(SRP 위반). routes.py가 월 12번 충돌하면, 그건 "이 파일을 cats.py·users.py로 쪼개라"는 git의 데이터 기반 조언이에요. 충돌 통계가 리팩터링 우선순위를 알려줘요.

**Q4. 회고는 어떤 양식으로 써요?** 세 부분이면 충분해요 — 지표(PR 수·머지 시간·conflict·사고), 진화(올해 바뀐 것), 다음 1년 목표(측정 가능한 3개). 거창할 필요 없어요. 한 페이지면 돼요. 중요한 건 "숫자로 보기"예요 — "올해 사고 3건"이라는 숫자가 있어야 "내년 0건"이라는 목표가 의미 있어요. 회고 없는 운영은 같은 실수를 반복해요.

**Q5. 자동화의 한계는 어디예요?** 사람의 판단은 자동화 안 돼요. "이 PR이 우리 제품 방향에 맞나"(의도), "이 리뷰 코멘트를 어떤 톤으로"(사회), "이 사고를 어떻게 수습하나"(위기 대응)는 사람만 해요. 자동화는 잡일(청소·버전·CHANGELOG·통계)을 가져가서, 사람이 판단에 집중하게 해 주는 거예요. 80/20 — 기계 80%, 사람 20%. 다만 그 20%가 가장 중요한 20%예요.

다섯 질문을 관통하는 한 줄 — 운영 도구(semantic-release·dependabot)는 다 "한 번 셋업, 1년 작동"이에요. 셋업 비용은 분 단위, 절약은 시간 단위. 그래서 자동화는 늘 남는 장사예요. 다만 자동화가 못 하는 "판단"은 사람의 몫이고, 그게 본인의 진짜 가치예요.

---

## 12. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 운영 학습 편

협업 운영하며 자주 빠지는 함정 다섯.

첫 번째 함정, branch를 너무 오래 살리기. 본인이 feature branch를 한 달 묵혀요. 안심하세요. **1주 룰 — feature branch는 1주 안에 머지 또는 종료.** 오래 묵힌 branch는 main과 멀어져 conflict 폭탄이 돼요(H5). 작게 자주 머지가 운영의 기본이에요.

두 번째 함정, code review를 안 하기. 본인이 본인 코드만 commit하고 동료 PR은 안 봐요. 안심하세요. **매주 동료 PR을 챙겨 review.** 본인 학습(남의 코드 읽기)이자 팀 안전(버그 잡기)이에요. 리뷰가 막히면 동료가 멈춰요(H4).

세 번째 함정, conflict 큰 걸 만나면 회피하기. 어렵다고 다른 일로 도망가요. 안심하세요. **conflict는 정상, 자주 만나면 친구.** 두 해 후 conflict 해결 실력이 본인의 진짜 경쟁력이에요. 피하면 영영 안 늘어요. 한 번 정면으로 풀어 보세요(H5 9-보충).

네 번째 함정, GitHub Actions CI 실패를 무시하기. 빨간 X를 보고도 머지해요. 안심하세요. **빨간 X는 머지 금지 — branch protection으로 자동 강제**(H3). CI는 다섯 명의 24시간 자동 동료예요. 그 경고를 무시하면 main이 깨져요.

다섯 번째 함정, 가장 큰 함정. **운영 자동화를 "나중에"로 미루기.** 본인이 "바쁘니까 자동화는 나중에" 하다 1년 내내 수동으로 고생해요. 안심하세요. **자동화는 미룰수록 손해.** 첫날 10분 셋업이 1년의 수작업을 없애요. "바빠서 자동화 못 한다"는 "바빠서 시간을 못 아낀다"는 모순이에요. 바쁠수록 자동화하세요.

다섯 함정을 한 줄로 — 운영의 실수는 대부분 "미루기"에서 와요. 자동화 미루기, 회고 미루기, hot file 방치, dependabot 무시, CI 방치. 운영은 "나중에"가 쌓여 사고가 되는 분야예요. 그래서 운영의 황금률은 "작게 자주, 미루지 않기"예요. 매일·매주·매월의 작은 점검이 1년의 큰 사고를 막아요. 다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 13. 마무리 — 다음 H7에서 만나요

자, 여섯 번째 시간이 끝났어요.

PR 자동 정리, release 자동화, CHANGELOG, conflict 통계, 매년 회고, 5년 진화. 자경단 운영 표준 완성.

오늘 한 줄 정리. **1년 운영은 자동화(청소·release·CHANGELOG)로 잡일을 기계에 맡기고, 통계(conflict·hot file)로 문제를 일찍 잡고, 회고로 매년 더 똑똑해지는 것이다.** 본인이 이 한 줄을 손에 쥐면, 협업이 "매일의 손"을 넘어 "자라는 시스템"이 돼요.

본인 페이스. 6/8 시간. 75%. 거의 다 왔어요! H1 큰그림, H2 개념, H3 환경, H4 도구, H5 실전, H6 운영. 이제 협업의 "하루"(H5)와 "1년"(H6)을 다 봤어요. H7은 그 자동화의 안쪽 — GitHub Actions가 어떻게 도는지, CI/CD 내부로 한 번 깊이 들어가요. 그리고 H8에서 자경단에 다 박고 마무리해요.

박수 한 번 칠게요. 진짜 큰 박수예요. 본인이 자경단의 1년 운영 표준을 완성했어요. 다섯 명이 5년 동안 사고 없이 일할 수 있는 환경.

여기서 잠깐, 본인이 H1부터 H6까지 온 길을 돌아볼게요. H1에서 "왜 협업"을 묻고, H2에서 개념을, H3에서 환경을, H4에서 도구를, H5에서 하루를, H6에서 1년을 봤어요. 혼자 git(Ch004)에서 시작한 본인이, 이제 다섯 명이 5년 동안 사고 없이 일하는 시스템을 머리에 그릴 수 있어요. 이게 신입과 시니어를 가르는 그 역량이에요 — 코드를 짜는 게 아니라 팀이 일하는 시스템을 설계하는 것. 본인은 지금 그 문턱을 넘고 있어요. 혼자 코드를 짜던 사람이 다섯 명을 1년 굴리는 시스템을 설계하는 사람으로 — 그 큰 변화가 Ch005 여섯 시간에 본인 안에서 일어났어요. 작아 보이는 한 시간 한 시간이 쌓여 그 변화를 만든 거예요.

다음 H7은 깊이. CI/CD 내부, GitHub Actions runner.

```bash
gh workflow list
gh run list --limit 10
```

이 두 줄을 치면 본인 저장소의 자동화 워크플로우와 최근 실행이 보여요 — 오늘 만든 cleanup·release가 거기 있어요. H7에서 이 워크플로우의 "안쪽"으로 들어가요 — GitHub Actions runner가 어떻게 본인 코드를 받아 빌드하고 테스트하는지. 오늘 자동화를 "쓰는 법"을 봤다면, H7은 자동화가 "도는 원리"예요. 운영을 본 뒤의 내부는 다른 색깔로 보일 거예요(Ch004 H6→H7과 같은 흐름). 오늘 본인은 협업을 "시스템"으로 보는 눈을 얻었어요 — 매일의 손이 아니라, 1년을 굴리는 자동화·통계·회고의 시스템. 이게 메인테이너의 눈이에요. 코드를 짜는 사람에서 시스템을 설계하는 사람으로, 본인이 한 걸음 더 갔어요. 잘 따라오셨어요. 5분 쉬고 H7에서 만나요.

---

## 👨‍💻 개발자 노트

> - semantic-release: Conventional Commits → SemVer 자동.
> - dependabot: GitHub 무료. 의존성 자동 PR.
> - GitHub Actions runner: ubuntu/macos/windows 무료 매월 2000분.
> - postmortem: blameless. 시스템 개선 우선.
> - hot file 분리: SOLID의 SRP.
> - 다음 H7 키워드: GitHub Actions runner · CI 내부 · cache · workflow.

---

## 추신

1. 1년 운영 = 자동화·release·통계·진화. 사람은 판단, 기계는 반복.
2. 머지 후 5초 청소도 자동화 — branch 삭제·감사 인사.
3. release 자동화 — Conventional Commits → SemVer → CHANGELOG.
4. feat→minor, fix→patch, BREAKING→major. 접두사가 버전을 정해요.
5. CHANGELOG 수동 0, 자동 100%. semantic-release가 다 해요.
6. hot file은 자주 충돌하는 파일. 분리 신호(SRP).
7. routes.py가 월 12번 충돌이면 작은 파일로 쪼개요.
8. 매년 회고 — 지표·진화·다음 1년 목표. 자경단의 회사화.
9. 5년 진화 — 5명→30명, 750→5000 PR, GitHub Flow→일부 Trunk-based.
10. 사람 늘수록 도구가 사람 일을 대신해요.
11. dependabot이 의존성 보안 PR을 매주 자동 생성.
12. stale PR(오래 멈춘 PR)은 자동으로 알림·정리.
13. 자동화 80→95%가 1년 목표. 나머지 5%는 사람 판단.
14. postmortem은 blameless — 사람이 아니라 시스템을 고쳐요.
15. CI 느리면 cache + matrix로 단축.
16. 운영 체크리스트 10단계를 매주·매월·매분기·매년 리듬으로.
17. 통계 없는 운영은 운영이 아니에요 — 측정이 먼저.
18. PR 사이즈 통계로 "PR이 커지고 있다"를 일찍 잡아요.
19. 보안 알림은 매일, dependabot은 매주, 회고는 매년.
20. 자동화는 "두 번 할 일을 한 번 적기"의 1년 버전.
21. release 노트가 자동이면 사용자 소통이 공짜로 좋아져요.
22. hot file은 SOLID의 SRP(단일 책임) 위반 신호.
23. 회고의 핵심은 "다음 1년 목표 3개". 측정 가능하게.
24. 5년 후에도 GitHub Flow가 기본 — 진화는 더하기지 갈아엎기 아니에요.
25. 자동화 ROI — 한 번 셋업, 1년 내내 작동. 곱셈.
26. 사고 후 회고 없으면 같은 사고 반복. 회고가 면역.
27. 면접 — "release 자동화 어떻게?", "hot file이 뭐예요?".
28. 운영은 시스템 90%, 사람 10%. 시스템을 잘 깔면 사람이 편해요.
29. 1년 운영 표준이 5년 운영의 토대. 첫해에 잘 깔아요.
30. GitHub Actions가 자동화 엔진. push·PR·schedule 사건에 반응해요.
31. dependabot·secret scanning·pre-commit이 24시간 보안 경비.
32. 운영자가 보는 통계 — PR 사이즈·머지 시간·CI 시간. 팀의 체온계.
33. blameless postmortem — 사람 말고 시스템을 고쳐요.
34. 운영 실수는 "미루기"에서. 바쁠수록 자동화하세요.
35. 좋은 운영자의 책상은 조용해요. 시스템이 대신 일하니까.
36. Actions trigger — push·pull_request·schedule·dispatch. "언제 무엇을"만 정해요.
37. RFC·ADR — 팀이 크면 말 대신 글로 합의해요(휘발 방지).
38. CHANGELOG의 compare 링크로 두 버전 사이를 한눈에. 투명성이 신뢰.
39. 1년 운영 표준이 본인을 메인테이너 자리로 준비시켜요.
40. 사람은 잊고 기계는 기억해요. 보안은 봇을 켜 두는 것.
41. 자동화는 작은 것부터 — cleanup 한 줄로 시작해 release로 자라요.
42. DORA 지표 — 배포 빈도·변경 실패율·복구 시간·리드타임. 팀 성과의 표준.
43. 운영을 본 본인은 이제 코드를 짜는 사람에서 시스템을 설계하는 사람으로. 그게 시니어의 첫걸음이에요.
44. 다음 H7은 CI/CD 내부 — GitHub Actions runner. 자동화의 안쪽을 봐요. 협업의 1년까지 본 본인, 이제 마지막 두 시간만 남았어요. 5분 쉬고 H7에서 만나요. 🐾
