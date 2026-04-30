# Ch005 · H7 — 협업 도구의 내부 — GitHub Actions·rebase 알고리즘·머지 전략

> 고양이 자경단 · Ch 005 · 7교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. GitHub Actions runner 내부
3. rebase 알고리즘의 비밀
4. merge 세 전략 — fast-forward·three-way·squash
5. cherry-pick 내부
6. PR 머지 방식 셋
7. CI 캐시 메커니즘
8. webhook과 trigger
9. 자경단 사이트의 CI/CD 파이프라인
10. 흔한 오해 다섯 가지
11. 마무리 — 다음 H8에서 만나요

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H6 회수. 1년 운영 — 자동화, release, CHANGELOG, conflict 통계.

이번 H7은 깊이의 시간. 협업 도구가 안에서 어떻게 일하는지.

오늘의 약속. **본인이 매일 누르는 git rebase, GitHub Actions, PR merge가 안에서 어떤 알고리즘으로 도는지 그림이 그려집니다**.

자, 가요.

---

## 2. GitHub Actions runner 내부

본인이 PR 만들면 자동으로 ubuntu-latest VM 한 대가 어딘가에서 떠요. 그게 GitHub Actions runner.

작동 원리 일곱 단계.

**1. trigger**. push, PR, schedule 등이 이벤트.

**2. queue**. 큐에 작업 등록.

**3. runner 할당**. 빈 VM 한 대 잡기.

**4. checkout**. 본인 코드 복제.

**5. job 실행**. yml의 steps 차례로.

**6. artifact 업로드** (선택).

**7. runner 정리**. VM 폐기.

GitHub은 매월 2,000분 무료. ubuntu가 1배, macos가 10배, windows가 2배. 자경단 표준 — ubuntu.

self-hosted runner 옵션. 본인 서버에 runner 두면 무한 시간. 자경단 큰 회사 가능.

---

## 3. rebase 알고리즘의 비밀

`git rebase main`이 안에서 무엇을 하나.

**1. 공통 조상 찾기**. main과 본인 branch의 갈라진 commit (merge base).

**2. 본인 branch의 commit 추출**. merge base 이후 commit들.

**3. main의 끝으로 이동**. main의 최신 commit으로 HEAD 옮기기.

**4. 추출한 commit 차례로 적용**. 한 commit씩 cherry-pick.

**5. 충돌 시 멈춤**. `git rebase --continue`까지 대기.

**6. 새 hash 생성**. rebase된 commit은 hash가 바뀜.

핵심. **rebase 후 commit hash가 바뀐다**. 그래서 force-push 필요. 그래서 force-with-lease로 안전하게.

---

## 4. merge 세 전략 — fast-forward·three-way·squash

git merge가 세 종류.

**fast-forward**. main이 본인 branch보다 안 진행했을 때. 그냥 main 포인터를 본인 branch 끝으로 이동. 새 commit 0.

```
Before:
main:    A → B
feature:      → C → D

After (fast-forward):
main:    A → B → C → D
```

**three-way merge**. main이 본인 branch와 별도로 진행했을 때. 새 merge commit 만들기.

```
Before:
main:    A → B → E
feature:      → C → D

After:
main:    A → B → E → M (merge commit, 부모 둘)
                 ↘   ↗
                  C→D
```

**squash merge**. 본인 branch의 모든 commit을 한 commit으로 압축해서 main에 추가.

```
Before:
main:    A → B
feature:      → C → D

After (squash):
main:    A → B → S (C+D 합쳐서)
```

자경단 표준 — squash merge. main의 history가 깔끔.

---

## 5. cherry-pick 내부

다른 branch의 특정 commit만 가져오기.

```bash
git cherry-pick abc1234
```

내부 동작.

1. abc1234 commit의 변경사항만 추출 (diff).
2. 현재 HEAD 위에 그 변경 적용.
3. 새 commit 생성 (hash 바뀜).

원본 commit과 같은 내용이지만 다른 hash. 같은 내용이라 cherry-pick 두 번 적용 시도하면 충돌 또는 무시.

자경단 사용처 — hotfix를 main과 release branch 둘 다에. 한 commit을 양쪽으로.

---

## 6. PR 머지 방식 셋

GitHub PR 머지에 셋 옵션.

**Merge commit**. three-way merge. 머지 commit 새로 생김. history가 가지치는 모양.

**Squash and merge**. squash. 한 commit으로. main이 깔끔.

**Rebase and merge**. rebase 후 fast-forward. main이 일직선.

자경단 표준 — Squash and merge. 매 PR이 main에 한 commit. 30 commit짜리 PR도 1 commit으로 main에. history 가독성 최고.

GitHub Settings → General → Pull Requests에서 옵션 켜기/끄기.

```
✅ Allow squash merging (자경단 표준)
✅ Allow merge commits (옵션)
❌ Allow rebase merging (피하기 — main 일직선이지만 동료 머지 시 충돌 가능)
```

---

## 7. CI 캐시 메커니즘

CI 시간을 5분 → 1분으로 줄이는 비결.

**actions/cache** 어떻게 동작.

1. 첫 실행. 의존성 설치 후 ~/.cache/pip을 GitHub 서버에 업로드.
2. 두 번째 실행. cache key (requirements.txt hash) 매칭되면 다운로드. 5초.
3. requirements.txt 변경 시. 새 cache key. 새로 빌드 + 새로 업로드.

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: pip-${{ hashFiles('**/requirements.txt') }}
```

자경단 표준 — pip, npm, cargo 다 cache.

---

## 8. webhook과 trigger

GitHub이 외부 서비스에 이벤트 알림. webhook.

```
이벤트 발생 → GitHub이 본인이 등록한 URL에 POST → 외부 서비스가 수신
```

자경단 사용 — Slack 알림, Vercel 자동 deploy, PagerDuty 사고 알림.

GitHub Actions의 `on:` trigger 종류.

```yaml
on:
  push:                  # commit push 시
  pull_request:          # PR 생성/업데이트 시
  schedule:              # 시간 기반 (cron)
    - cron: '0 9 * * *'
  workflow_dispatch:     # 수동 trigger
  release:
    types: [published]
```

자경단 매주 한 번 schedule로 보안 검사.

---

## 9. 자경단 사이트의 CI/CD 파이프라인

매 PR이 거치는 자경단 파이프라인.

```
1. PR 생성 (까미)
   ↓
2. GitHub Actions trigger
   ↓
3. ubuntu runner 1대 떠오름
   ↓
4. checkout + cache 복원 (10s)
   ↓
5. 의존성 설치 (5s with cache)
   ↓
6. ruff check + mypy (3s)
   ↓
7. pytest (30s)
   ↓
8. coverage 측정 (5s)
   ↓
9. PR comment with 결과
   ↓
10. 본인 + Codeowner 리뷰
   ↓
11. squash merge to main
   ↓
12. main 자동 deploy to staging
   ↓
13. smoke test on staging (1 min)
   ↓
14. 수동 prod deploy (본인이 트리거)
   ↓
15. 사용자에게 노출
```

15단계. 평균 5분. 자경단의 매주 15 PR이 다 이 파이프라인.

---

## 10. 흔한 오해 다섯 가지

**오해 1: rebase는 위험.**

force-with-lease로 안전.

**오해 2: squash로 history 손실.**

PR 본문 + 링크에 모두 보존.

**오해 3: GitHub Actions는 무료.**

매월 2000분만. 그 이상 유료.

**오해 4: cache 항상 hit.**

key 매칭 안 되면 miss.

**오해 5: webhook 안전.**

secret 검증 필수.

---

## 11. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 깊이 학습 편

협업 깊이 학습하며 자주 빠지는 함정 다섯.

첫 번째 함정, rebase vs merge 한 번에 다 이해하려고. 안심하세요. **첫 한 달은 merge만.** rebase는 두 번째 달.

두 번째 함정, --rebase 무서워함. 안심하세요. **자기 브랜치 rebase는 안전.** 공유 브랜치만 금지.

세 번째 함정, cherry-pick 무지성 사용. 안심하세요. **cherry-pick은 핫픽스용 한정.** 일반 머지는 merge/rebase.

네 번째 함정, bisect 안 쓴다. 본인이 어느 commit이 버그인지 추측. 안심하세요. **git bisect로 binary search.** 100 commit 중 7번 안에 찾아내요.

다섯 번째 함정, 가장 큰 함정. **squash merge를 무조건 사용.** 본인 PR 100 commit이 1 commit으로. 안심하세요. **squash는 작은 PR에만.** 큰 PR은 commit 보존이 history 가치.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 12. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요.

GitHub Actions runner 내부, rebase 알고리즘, 머지 세 전략, cherry-pick, PR 머지 방식, CI 캐시, webhook, 자경단 파이프라인.

박수.

다음 H8은 적용 + 회고. 자경단 첫 PR부터 5년까지.

```bash
gh workflow list
gh run list --limit 5
```

---

## 👨‍💻 개발자 노트

> - GitHub Actions runner: actions/runner 오픈소스.
> - rebase autosquash: fixup commit 자동 통합.
> - 3-way merge 알고리즘: recursive (default), patience, ort.
> - cache scope: per branch + main.
> - webhook 보안: HMAC-SHA256 signature.
> - 다음 H8 키워드: 자경단 첫 PR · 1년 · 3년 · 5년 진화.
