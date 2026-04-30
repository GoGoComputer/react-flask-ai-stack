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
8. 자경단 운영 1년 체크리스트
9. 다섯 함정과 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리 — 다음 H7에서 만나요

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요. 마지막 큰 시간이에요.

지난 H5 회수. 30분 시뮬. 두 PR, conflict 해결, force-with-lease.

이번 H6은 1년 운영. 자동화, release, 통계, 진화.

오늘의 약속. **본인의 자경단 저장소가 5년 운영 가능한 표준이 됩니다**.

자, 가요.

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

---

## 7. 5년 운영 시뮬레이션 — 1년·3년·5년

**1년차** (현재). 5명, 750 PR/년, GitHub Flow, 수동 일부.

**3년차**. 10명. 1500 PR/년. branch protection 확장. dependabot 자동.

**5년차**. 30명. 5000 PR/년. trunk-based + feature flag. 자동화 95%.

진화 한 줄. **사람 늘어날수록 도구가 사람 일을 대신**.

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

---

## 9. 다섯 함정과 처방

**함정 1: 자동화 안 해서 매번 수동**

처방. GitHub Actions.

**함정 2: 사고 후 회고 없음**

처방. postmortem 문서.

**함정 3: hot file 방치**

처방. 매월 통계.

**함정 4: dependabot PR 무시**

처방. 매주 처리.

**함정 5: CI 느림**

처방. cache + matrix.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 자동화 시니어 도구.**

신입 1년 차부터.

**오해 2: SemVer 어려움.**

Conventional Commits이면 자동.

**오해 3: 통계 옵션.**

매월 점검.

**오해 4: 회고는 큰 회사만.**

작은 팀도.

**오해 5: 5년 후엔 다른 도구.**

GitHub Flow는 5년 +.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. semantic-release 셋업?**

10분.

**Q2. dependabot vs renovate?**

dependabot GitHub. renovate 더 강력.

**Q3. hot file 기준?**

월 5회 이상.

**Q4. 회고 양식?**

지표 + 진화 + 다음 1년.

**Q5. 자동화 한계?**

사람의 판단은 자동화 안 됨.

---

## 12. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 운영 학습 편

협업 운영하며 자주 빠지는 함정 다섯.

첫 번째 함정, branch 너무 오래 살림. 안심하세요. **1주 룰.** feature branch는 1주 안에 머지 또는 종료.

두 번째 함정, code review 안 한다. 본인이 본인 코드만 commit. 안심하세요. **매주 동료 PR 한 건 review.** 본인 학습 + 팀 안전.

세 번째 함정, conflict 큰 거 만나면 회피. 본인이 어렵다고 다른 일. 안심하세요. **conflict는 정상.** 자주 만나면 친구. 두 해 후 conflict resolution이 본인 진짜 실력.

네 번째 함정, GitHub Actions CI 실패 무시. 안심하세요. **빨간 X는 머지 금지.** branch protection으로 자동.

다섯 번째 함정, 가장 큰 함정. **CHANGELOG 안 쓴다.** 본인 레포에 변경 이력 없음. 안심하세요. **매 PR에 한 줄 CHANGELOG.** 6개월 후 본인 + 동료 모두 도움.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 13. 마무리 — 다음 H7에서 만나요

자, 여섯 번째 시간이 끝났어요.

PR 자동 정리, release 자동화, CHANGELOG, conflict 통계, 매년 회고, 5년 진화. 자경단 운영 표준 완성.

박수 한 번 칠게요. 진짜 큰 박수예요. 본인이 자경단의 1년 운영 표준을 완성했어요. 다섯 명이 5년 동안 사고 없이 일할 수 있는 환경.

다음 H7은 깊이. CI/CD 내부, GitHub Actions runner.

```bash
gh workflow list
gh run list --limit 10
```

---

## 👨‍💻 개발자 노트

> - semantic-release: Conventional Commits → SemVer 자동.
> - dependabot: GitHub 무료. 의존성 자동 PR.
> - GitHub Actions runner: ubuntu/macos/windows 무료 매월 2000분.
> - postmortem: blameless. 시스템 개선 우선.
> - hot file 분리: SOLID의 SRP.
> - 다음 H7 키워드: GitHub Actions runner · CI 내부 · cache · workflow.
