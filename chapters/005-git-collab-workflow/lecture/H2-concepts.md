# Ch005 · H2 — 협업 워크플로우 8개념 — 세 패턴부터 환경 분리까지

> 고양이 자경단 · Ch 005 · 2교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. 첫째 — GitHub Flow 깊이
3. 둘째 — Git Flow 깊이
4. 셋째 — Trunk-based 깊이
5. 넷째 — 셋 패턴 한 표 비교
6. 다섯째 — branch 모델
7. 여섯째 — release vs deploy
8. 일곱째 — dev/staging/prod 환경 분리
9. 여덟째 — 자경단 적용 결정
10. 한 줄 분해
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리 — 다음 H3에서 만나요

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠. 물 한 잔 드시고 오셨길 바라요.

지난 H1을 한 줄로 회수할게요. 협업 워크플로우는 다섯 명의 합의된 절차. 일곱 이유로 본인이 깊이 배워야 해요. 세 표준 패턴을 첫인상으로 봤어요. 충돌의 세 깊이도 봤고요.

이번 H2는 그 세 패턴을 깊이 들여다보고, 각 패턴의 장단을 비교하는 시간이에요. 그리고 release vs deploy의 결정적 차이, dev/staging/prod 환경 분리까지. 한 시간 후엔 본인이 자경단의 워크플로우를 결정할 수 있게 됩니다.

오늘의 약속. **본인이 어느 회사를 가도 그 워크플로우를 한 줄로 분류할 수 있게 됩니다**. 자, 가요.

---

## 2. 첫째 — GitHub Flow 깊이

GitHub Flow는 가장 단순한 패턴이에요. 2011년 GitHub의 공식 블로그에서 소개. 스타트업과 오픈소스의 표준.

규칙은 다섯 줄.

1. main이 항상 deployable.
2. 새 작업은 feature branch.
3. PR 만들어서 리뷰.
4. 리뷰 통과하면 머지.
5. 머지 후 즉시 배포.

이 다섯 줄에 모든 게 들어 있어요. 가장 단순. 가장 빠름. 그래서 자경단 표준이에요.

장점 — 단순해서 신입도 1주일에 익숙. release branch 없음. 짧은 사이클 (1~2일 작업).

단점 — release 시점 통제 어려움. 머지 즉시 prod. feature flag 없으면 미완성 코드 노출 위험.

자경단의 활용. 까미가 새 endpoint 짤 때 — 1) `git checkout -b feature/api-cats`, 2) commit 3~5건, 3) PR 만들기, 4) 본인이 리뷰, 5) 머지 + 자동 deploy. 1~2일 사이클.

자경단의 매주 PR이 약 15건. GitHub Flow의 효율이 자경단의 합주를 가능하게 해요.

---

## 3. 둘째 — Git Flow 깊이

Git Flow는 가장 무거운 패턴. 2010년 Vincent Driessen의 블로그 글에서 발표. 분기별 release가 있는 큰 회사의 표준.

다섯 종류의 브랜치.

1. **main** — production 배포된 코드.
2. **develop** — 개발 중인 코드.
3. **feature/** — 새 기능 개발.
4. **release/** — release 준비.
5. **hotfix/** — production 긴급 수정.

흐름. feature → develop → release → main. 각 단계에서 PR + 리뷰.

장점 — release 시점 정확. 큰 변경의 통제. 분기별 release 자연.

단점 — 다섯 브랜치 종류 학습 비용. PR 사이클 길음 (1~2주). 변경 통합 느림.

자경단은 Git Flow를 안 써요. 큰 회사라면 만나요. Adobe, Microsoft, 큰 금융권.

---

## 4. 셋째 — Trunk-based 깊이

Trunk-based는 main 하나에 모든 게 모이는 패턴. Meta, Google, Netflix의 표준.

규칙. 모두가 main에 직접 (또는 짧은 branch). 매일 머지. feature flag로 미완성 코드를 production에서 가림.

장점 — 통합 빠름. branch 격리 비용 0. 충돌 적음 (자주 머지).

단점 — feature flag 인프라 필요. 강력한 CI 필요. 신입엔 빠름.

핵심은 **feature flag**. 미완성 코드를 main에 머지하되, flag로 사용자에게 안 보이게. 점진적 배포 가능.

자경단은 GitHub Flow가 기본이지만, 큰 변경엔 trunk-based 일부 차용. 매일 머지 정신.

---

## 5. 넷째 — 셋 패턴 한 표 비교

| 항목 | GitHub Flow | Git Flow | Trunk-based |
|------|-------------|----------|-------------|
| branch 종류 | 2 (main + feature) | 5 | 1 (main 또는 짧은 branch) |
| 사이클 | 1~2일 | 1~2주 | 매일 |
| 학습 비용 | 낮음 | 높음 | 중간 |
| 적용 회사 | 스타트업, 오픈소스 | 큰 회사 | 빅테크 |
| feature flag | 옵션 | 옵션 | 필수 |
| 자경단 평가 | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

자경단 — GitHub Flow + Trunk-based 일부.

선택의 황금 규칙. 작은 팀 (10명 이하)은 GitHub Flow. 분기별 release 있는 큰 회사는 Git Flow. 빅테크 + feature flag 인프라는 Trunk-based.

---

## 6. 다섯째 — branch 모델

브랜치 종류와 작명 규칙.

**main** (또는 master). production 배포된 코드. 자경단은 main 표준.

**feature/이름**. 새 기능. 예: `feature/cat-photo-upload`. 1~2일 라이프.

**fix/이름**. 버그 수정. 예: `fix/login-redirect-loop`.

**hotfix/이름**. production 긴급. 예: `hotfix/critical-data-loss`.

**chore/이름**. 잡일. 예: `chore/update-deps`.

자경단의 작명 규칙. **prefix/짧은-설명** (kebab-case). 5단어 이내. 영어 또는 한글-영어 혼합.

```bash
git checkout -b feature/cat-photo-upload
git checkout -b fix/login-redirect
git checkout -b chore/upgrade-fastapi
```

자경단 매일.

---

## 7. 여섯째 — release vs deploy

이 두 단어가 자주 같은 뜻처럼 쓰여요. 사실 다른 거예요.

**Release**. 코드를 사용자에게 노출. 새 버전 발표. v1.0.0 → v1.1.0.

**Deploy**. 코드를 서버에 올리기. 사용자 노출과 무관.

같은 코드를 deploy 했는데 release 안 할 수 있어요. 어떻게? feature flag로 가려서. 사용자는 옛 버전을 보지만, 코드는 새 버전이 prod에 올라가 있음. 점진적으로 flag를 켜서 5%, 10%, 50%, 100% 노출.

자경단의 적용. 매주 deploy는 5번. release는 2주에 한 번. 다섯 deploy 중 두 번만 사용자에게 노출.

이 분리가 안전 배포의 비결이에요.

---

## 8. 일곱째 — dev/staging/prod 환경 분리

자경단의 세 환경.

**dev**. 본인 노트북 또는 dev 서버. 매일 코드 짜는 곳. 사고 자유. 데이터 가짜.

**staging**. prod 비슷한 환경. 머지 직후 자동 deploy. 통합 테스트. 데이터 일부 진짜.

**prod**. 진짜 사용자가 쓰는 곳. 수동 또는 검증된 자동 deploy. 데이터 진짜.

자경단의 흐름. dev에서 짜고 → PR → staging 자동 deploy + 자동 테스트 → 검증 후 prod 머지 → prod 자동 deploy.

세 환경 분리가 사고 면역의 90%.

---

## 9. 여덟째 — 자경단 적용 결정

자경단의 한 페이지 결정.

**워크플로우** — GitHub Flow.
**branch 명명** — feature/fix/hotfix/chore prefix.
**커밋 메시지** — Conventional Commits.
**PR 사이즈** — 평균 200줄, 최대 500줄.
**리뷰** — 1명 이상, 본인이 메인.
**머지 방식** — Squash and merge.
**release** — 2주에 한 번 SemVer.
**deploy** — staging 자동, prod 수동 트리거.
**feature flag** — 큰 변경에 사용.

이 한 페이지가 자경단의 헌법.

---

## 10. 한 줄 분해

```bash
git checkout -b feature/cat-photo && git push -u origin feature/cat-photo && gh pr create --draft
```

GitHub Flow의 한 줄. branch 만들고 push하고 draft PR.

---

## 11. 흔한 오해 다섯 가지

**오해 1: GitHub Flow가 항상 답.**

상황별 다름.

**오해 2: Git Flow는 옛 도구.**

큰 회사에 여전히.

**오해 3: trunk-based 위험.**

feature flag 있으면 안전.

**오해 4: release = deploy.**

다른 거예요.

**오해 5: 환경 분리 부담.**

자경단의 사고 면역.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. 회사가 Git Flow면?**

따라가요. 1년 후 의견.

**Q2. feature flag 어떻게?**

LaunchDarkly, Unleash 등. 무료 옵션도.

**Q3. SemVer 자동?**

Conventional Commits + semantic-release.

**Q4. staging 비용?**

작은 팀 옵션. 무료 plan으로 시작.

**Q5. 8시간 길어요.**

협업이 시간 30%.

---

## 13. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 핵심 학습 편

협업 핵심 개념 만나며 자주 빠지는 함정 다섯.

첫 번째 함정, GitHub Flow와 Git Flow를 둘 다 채택. 안심하세요. **한 가지만.** 작은 팀은 GitHub Flow, 큰 팀은 Trunk-based. Git Flow는 무거워서 deprecated 추세.

두 번째 함정, branch 이름을 일관되지 않게. 본인이 fix-bug, feature/login, bugfix-2 식으로. 안심하세요. **type/scope 패턴.** feat/login, fix/cache, docs/api. 첫날부터 일관.

세 번째 함정, PR description 비어 있음. 안심하세요. **What·Why·How 세 줄 최소.** 6개월 후 본인이 본인 PR 다시 볼 때 그 세 줄이 본인 살림.

네 번째 함정, code review를 꼼꼼히 안 함. 본인이 LGTM만 한 줄로. 안심하세요. **5분 투자가 5시간 사고 막아요.** 수정 제안 한 줄도 OK.

다섯 번째 함정, 가장 큰 함정. **conflict 무서워서 long-running branch.** 본인 feature branch 한 달. main 멀어짐. conflict 폭탄. 안심하세요. **매일 main rebase.** 작은 conflict 매일이 큰 conflict 한 달보다 100배 좋음.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 14. 마무리 — 다음 H3에서 만나요

자, 두 번째 시간이 끝났어요.

세 패턴 깊이 (GitHub Flow, Git Flow, Trunk-based), 셋 비교, branch 모델, release vs deploy, 환경 분리, 자경단 적용.

박수.

다음 H3는 환경점검. team GitHub 셋업, branch protection, CODEOWNERS, husky.

```bash
gh repo view --web
```

---

## 👨‍💻 개발자 노트

> - GitHub Flow vs GitLab Flow: GitLab은 staging branch 추가.
> - feature flag 도구: LaunchDarkly, Unleash, Flipt.
> - SemVer: major.minor.patch. major=breaking, minor=feature, patch=fix.
> - Conventional Commits: feat:, fix:, chore:, docs:, refactor:, test:.
> - 환경 변수 관리: dotenv, AWS Secrets Manager.
> - 다음 H3 키워드: GitHub team · branch protection · CODEOWNERS · husky · SSH key.
