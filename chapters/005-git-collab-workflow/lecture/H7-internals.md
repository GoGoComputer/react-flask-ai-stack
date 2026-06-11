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
10-보충. FAQ — 협업 내부 일곱 질문
11. 흔한 실수 다섯 가지 + 안심 멘트
12. 마무리 — 다음 H8에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 협업 도구의 안쪽을 눈으로 — 강사 시연용
git merge-base main feature/x                 # rebase가 찾는 공통 조상
git rebase main                                # 내부: cherry-pick 연쇄
git log --oneline --graph --all               # merge 전략별 모양 비교
git cherry-pick abc1234                        # 특정 commit만 (새 hash)
gh run view <id> --log                         # Actions runner 로그
gh run watch                                   # CI 실시간 모니터
gh api repos/:owner/:repo/hooks                # webhook 목록
git bisect start                               # 버그 이등분 탐색
```

이 한 화면이 오늘 60분의 지도예요. H6에서 "자동화를 쓰는 법"을 봤다면, H7은 그 자동화가 "안에서 어떻게 도는지"예요. rebase·merge·Actions runner·cache가 다 정직한 알고리즘의 연쇄라는 걸 눈으로 봐요. 강사는 위에서 아래로 한 번 훑고 시작하면 돼요. 오늘의 한 줄 — **마법은 없다, 정직한 단계만 있다(Ch004 H7과 같은 정신).**

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H6 회수. 1년 운영 — 자동화, release, CHANGELOG, conflict 통계.

H6에서 본인은 자동화를 "쓰는 법"을 배웠어요 — semantic-release를 깔고, cleanup 워크플로우를 두고. 오늘 H7은 그 자동화가 "도는 원리"예요. GitHub Actions runner가 어떻게 본인 코드를 받아 검사하는지, rebase가 안에서 무슨 알고리즘을 도는지. Ch004에서 git을 "쓰다가"(H1~H6) "이해한"(H7) 것과 똑같은 흐름이에요. 쓰는 것과 이해하는 것의 차이는 사고가 났을 때 드러나요 — 쓸 줄만 알면 사고에 막막하고, 이해하면 침착해요.

이번 H7은 깊이의 시간. 협업 도구가 안에서 어떻게 일하는지.

오늘의 약속. **본인이 매일 누르는 git rebase, GitHub Actions, PR merge가 안에서 어떤 알고리즘으로 도는지 그림이 그려집니다**.

왜 내부를 배우냐고요? Ch004 H7에서 본 것과 같아요 — 내부를 알면 마법이 정직한 일로 바뀌고, 마법이 아니면 안 무서워요. 본인이 매일 rebase·merge·CI를 쓰지만, 안에서 뭘 하는지 모르면 사고가 났을 때 "망했다"만 떠올라요. 안을 알면 "아, rebase가 commit을 새로 심는 중인데 4단계에서 충돌했구나, continue하면 되겠다"가 떠올라요. 내부를 아는 사람이 사고에 침착한 사람이에요. 오늘은 그 침착함을 손에 넣는 시간이에요. 그리고 H6에서 "쓴" 자동화를 H7에서 "이해"하면, 본인이 직접 워크플로우를 만들 수 있게 돼요.

한 가지 미리 안심을. 오늘은 알고리즘과 YAML이 나와요. 그 디테일을 다 외우려 마세요 — "아, rebase는 commit을 새로 심는구나", "CI는 깨끗한 VM에서 도는구나" 같은 "그림"만 머리에 그리면 충분해요. 깊은 디테일은 두 해 후 실제로 그 사고를 만났을 때 친구가 돼요. 오늘은 큰 그림의 시간이에요. 자, 가요.

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

runner의 일곱 단계를 한 장면으로 그려 볼게요. 본인이 PR을 올린 그 순간, GitHub의 거대한 서버 풀에서 깨끗한 ubuntu VM 한 대가 깨어나요(3. 할당). 그 VM이 본인 코드를 clone하고(4. checkout), `.github/workflows`의 steps를 위에서 아래로 실행하고(5. job), 끝나면 VM은 흔적도 없이 폐기돼요(7. 정리). 매번 깨끗한 VM이라 "내 노트북에선 됐는데 CI에선 안 돼"를 잡아요 — CI는 본인 환경 오염이 없는 순수한 무대거든요. 그리고 이 VM이 "본인 코드를 받아 빌드·테스트하는" 게 CI(Continuous Integration)의 본질이에요. 사람이 잠든 새벽에도, 다섯 명의 모든 PR마다, 이 VM이 떠서 검사해요. CI는 다섯 명의 지치지 않는 여섯 번째 동료예요.

runner를 여러 대 동시에 띄우는 게 **matrix**예요. 예를 들어 Python 3.10·3.11·3.12에서 다 테스트하려면, matrix로 3개의 runner를 동시에 띄워 병렬로 돌려요 — 순차면 3배 시간이 matrix면 1배. OS도 ubuntu·macos·windows 매트릭스로 곱하면 3×3=9개 조합을 한 번에. 자경단은 작아서 ubuntu × Python 3.12 하나지만, 라이브러리를 만들면 여러 버전 매트릭스가 필요해요(Ch014 회수). matrix는 "CI를 넓게(여러 환경) 그러나 빠르게(병렬)" 만드는 도구예요. 병렬은 시간을 일꾼 수만큼 나눠 갖는 거예요.

self-hosted runner를 한 줄 더. GitHub이 주는 VM 대신 본인 서버에 runner를 깔면 — 시간 무제한, 사내망 자원 접근 가능, 특수 하드웨어(GPU) 사용 가능. 대신 그 서버가 본인 코드를 실행하니 보안을 챙겨야 하고, 서버 관리 부담이 생겨요. 그래서 self-hosted는 "무료 한도로 부족하거나 특수 환경이 필요한" 큰 회사의 선택이에요. 자경단은 GitHub VM으로 충분하고요. 둘의 선택은 "편함(관리형) vs 통제(self-hosted)"의 트레이드오프예요 — 대부분은 편함이 답이에요.

runner의 2단계 "queue"를 한 줄 더. 동시에 PR이 여러 개 올라오면? 각 PR마다 별도 runner가 떠서 병렬로 돌아요(무료 플랜은 동시 20개까지). 그래서 다섯 명이 동시에 PR을 올려도 서로 안 기다려요. 다만 같은 워크플로우가 너무 자주 트리거되면 concurrency 설정으로 "옛 실행을 취소하고 최신만"으로 묶을 수 있어요 — 예: 같은 PR에 연속 push하면 옛 CI는 취소하고 최신 코드만 검사. 자원을 아끼는 거예요. 이런 세밀한 제어가 CI를 효율적으로 만들어요. 자동화도 잘 쓰면 살림이에요.

runner의 6단계 "artifact 업로드"도 짚어 둘게요. 테스트 결과·빌드 산출물·커버리지 리포트를 artifact로 저장하면, runner가 폐기된 뒤에도 GitHub에서 다운로드해 볼 수 있어요. 예: 테스트가 실패하면 스크린샷을 artifact로 남겨 "뭐가 깨졌나"를 봐요. VM은 사라져도 결과는 남는 거예요. 그리고 job 사이에 데이터를 넘길 때도 artifact를 써요(빌드 job → 배포 job). artifact는 "휘발되는 VM에서 남길 건 남기는" 도구예요.

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

이 여섯 단계를 H5의 까미 사례로 보면 또렷해져요. 까미가 `git rebase origin/main`을 쳤을 때 — git이 까미 branch와 main의 공통 조상(merge base)을 찾고(1), 그 이후 까미의 5 commit을 빼내고(2), HEAD를 main 최신으로 옮기고(3), 5 commit을 하나씩 다시 적용하다가(4) package.json에서 충돌해 멈췄어요(5). 충돌을 풀고 continue하니 나머지가 적용되고, 5 commit이 새 hash로 다시 태어났어요(6). 그래서 push가 force여야 했고요. **rebase는 "commit을 복사해 새 자리에 다시 심는" 거예요** — 원본을 옮기는 게 아니라 새로 만드는 거라 hash가 바뀌는 거예요. 이 그림이 머리에 있으면 rebase가 안 무서워요. 그리고 merge와의 차이도 또렷해져요 — merge는 두 줄기를 한 점(merge commit)에서 합치고, rebase는 한 줄기를 다른 줄기 끝으로 옮겨 붙여요. 합치기 vs 옮기기, 그게 둘의 본질이에요.

충돌이 어떻게 감지되는지 한 겹 더. git의 머지는 **3-way merge**예요 — 공통 조상(base), 내 버전(ours), 들어오는 버전(theirs) 셋을 비교해요. 한쪽만 바뀐 줄은 자동으로 그쪽을 따르고, 양쪽 다 바뀐 줄만 CONFLICT로 표시해요. 그래서 같은 파일을 건드려도 다른 줄이면 충돌이 안 나요(자동 머지). 충돌 알고리즘에도 종류가 있어요 — recursive(옛 기본), patience(이동 감지에 강함), ort(현 기본, 2021). 본인이 이걸 깊이 알 필요는 없지만, "충돌은 양쪽이 같은 줄을 바꿨을 때만"이라는 원리는 알아 두면 충돌이 왜 났는지 이해돼요. 충돌은 무작위가 아니라 규칙이 있어요 — 그 규칙을 알면 hot file(자주 충돌하는 파일)을 왜 쪼개야 하는지도 보여요(H6).

rebase의 친척 `rebase -i`(interactive)도 짚어 둘게요. 일반 rebase가 "main 위로 옮기기"라면, `rebase -i HEAD~5`는 "내 최근 5 commit을 편집"이에요 — squash(합치기), reword(메시지 수정), drop(삭제), reorder(순서 바꾸기). 머지 전 지저분한 commit을 깔끔하게 다듬는 도구예요(H4). 그리고 `--autosquash`는 `git commit --fixup`으로 만든 "OO 수정" commit을 자동으로 원래 commit에 합쳐줘요(H4 리뷰 받는 쪽). rebase가 "history를 다시 쓰는" 강력한 도구인 만큼, push 전 본인 브랜치에서만 써요(push 후는 공유된 history 변경 = 위험). 강력한 도구일수록 쓰는 자리를 가려야 해요.

rebase가 무서우면 한 가지만 기억하세요 — reflog가 안전망이에요(Ch004 H7). rebase가 꼬여도 `git reflog`로 rebase 전 상태를 찾아 `git reset --hard`로 돌아가요. 그래서 rebase는 "망쳐도 되돌릴 수 있는" 실험이에요. 안전망을 믿고 시도하세요. 내부를 알고(commit이 새로 심긴다) 안전망을 믿으면(reflog), rebase는 무서운 도구가 아니라 강력한 친구가 돼요.

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

세 전략을 언제 쓰는지 정리해 둘게요. **fast-forward**는 main이 안 움직였을 때 자동으로 일어나요 — 가장 깔끔하지만 main이 다섯 명으로 바쁘면 거의 안 생겨요. **three-way**는 두 줄기가 각자 진행했을 때 merge commit으로 합쳐요 — 모든 기록이 남지만 history가 가지치기로 복잡해져요. **squash**는 PR을 한 commit으로 눌러 main에 넣어요 — 30 commit짜리 PR도 main엔 한 줄. 자경단이 squash를 고른 이유는 "main을 PR 단위 변경 이력서로 읽으려고"예요(H2). 다섯 명의 지저분한 중간 commit이 main에 안 섞이니, 1년 후 `git log`가 깨끗해요. main은 결과만, 과정은 PR에 — 이게 squash의 철학이에요.

위 세 다이어그램을 읽는 법을 한 번 짚을게요. fast-forward는 `A→B→C→D` 한 줄(가장 깔끔), three-way는 `M`이라는 merge commit이 두 부모(E와 D)를 잇는 Y자 모양(기록 보존이지만 복잡), squash는 `C+D`가 `S` 하나로 눌린 한 줄. `git log --graph`로 본인 저장소의 이 모양을 직접 볼 수 있어요. main이 일직선이면 squash/rebase 팀, Y자 가지가 많으면 merge commit 팀이에요. history 모양만 봐도 그 팀의 머지 철학이 보여요. 본인 저장소의 그래프를 한 번 그려 보면, 추상적인 세 전략이 눈에 보이는 그림이 돼요.

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

cherry-pick이 왜 hash가 바뀌는지 알면 한 가지 함정을 피해요. cherry-pick은 "commit의 변경(diff)만 떼서 새 자리에 새 commit으로 적용"이라, 원본과 내용은 같아도 hash는 달라요(rebase와 같은 원리). 그래서 hotfix를 main과 release에 cherry-pick하면, 같은 수정이 두 개의 다른 hash로 존재해요. 나중에 두 브랜치를 머지하면 git이 "같은 내용"을 알아채 충돌 없이 합치거나, 가끔 충돌이 나요. 그래서 cherry-pick은 "꼭 필요할 때만" 써요 — 남발하면 같은 변경의 복제본이 여기저기 생겨 history가 헷갈려요. "한 commit만 딱 옮긴다"는 명확한 목적이 있을 때의 도구예요.

cherry-pick의 또 다른 쓸모 — "잘못된 브랜치에 commit했을 때"예요. main에 직접 commit해야 할 게 실수로 feature 브랜치에 들어갔다면? feature에서 그 commit을 cherry-pick으로 옳은 브랜치에 복사하고, 원래 건 reset으로 지워요. 또는 긴 작업 중 "이 한 부분만 먼저 main에 넣고 싶을 때"도 cherry-pick. 한 commit을 외과 수술처럼 정확히 옮기는 도구라, 정밀함이 필요한 순간에 빛나요. 다만 정밀 도구는 일상이 아니라 특수 상황용이라는 걸 기억하세요 — 일상의 머지는 merge/rebase가 맞아요.

cherry-pick·rebase·squash가 다 "commit을 복사하거나 옮기는" 도구라는 공통점이 보이세요? 셋 다 hash가 바뀌어요(내용은 같아도 새 자리). 이걸 알면 "rebase·cherry-pick 후엔 force-push"라는 규칙이 왜 그런지 이해돼요 — 원격엔 옛 hash, 로컬엔 새 hash니까요. 내부의 한 원리(commit은 복사되면 새 hash)가 여러 명령의 동작을 설명해요. 원리 하나가 여러 도구를 꿰어요. 이게 내부를 배우는 진짜 이득이에요 — 명령을 하나씩 외우는 게 아니라, 원리 하나로 여럿을 이해하는 것.

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

왜 rebase merge를 피하냐면, 여러 명이 동시에 머지할 때 문제가 생기기 때문이에요. rebase merge는 PR의 commit들을 main 끝에 일렬로 붙이는데, 그 사이 다른 사람이 머지하면 충돌이 나거나 history가 꼬여요. squash는 PR을 한 commit으로 만들어 이 문제가 적어요. 그래서 다섯 명이 바쁘게 머지하는 자경단엔 squash가 가장 안전해요. 회사마다 표준이 다르니, 본인은 그 팀의 머지 버튼이 뭘로 설정됐는지 첫날 확인하면 돼요 — 설정은 메인테이너가 정하고, 멤버는 따르는 거예요. 머지 버튼 하나에도 팀의 history 철학이 담겨 있어요.

한 가지 편리한 기능 — `gh pr merge --auto`예요. "CI가 초록불이 되고 리뷰가 통과하면 자동으로 머지"를 예약하는 거예요(H4). 그러면 본인이 CI를 지켜보다 머지 버튼을 누를 필요 없이, 조건이 충족되는 순간 자동으로 머지돼요. 다섯 명이 바쁠 때 이 한 줄이 "머지 대기"의 수고를 없애요. branch protection(승인·CI 필수)과 auto-merge가 만나면, 안전하면서도 손이 덜 가는 머지가 돼요. 도구가 안전과 편함을 동시에 주는 거예요.

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

cache의 비밀은 "key"예요. `key: pip-${{ hashFiles('requirements.txt') }}`는 "requirements.txt의 내용을 해시로 만들어 key로 쓴다"는 뜻이에요. 그래서 의존성이 안 바뀌면 같은 key → cache hit(5초에 복원), 바뀌면 다른 key → cache miss(새로 빌드 + 새 cache 저장). 이게 영리한 이유는 "바뀐 것만 새로 한다"는 거예요 — 코드만 바꾼 PR은 의존성 cache를 그대로 쓰니 CI가 빨라요. content-addressable의 정신이 여기도 있어요(Ch004 H7 — 내용이 주소). cache는 "CI 시간 = 다섯 명의 대기 시간"을 줄이는 가장 큰 레버예요. 5분이 1분이 되면, 다섯 명이 하루에 아끼는 시간이 쌓여 한 사람 몫이 돼요.

cache 말고 CI를 빠르게 하는 방법이 더 있어요. **matrix 병렬**(§2, 여러 작업 동시), **변경 감지**(바뀐 파일이 있는 부분만 테스트 — 백엔드만 바뀌면 프런트 테스트 skip), **무거운 건 main에서만**(PR엔 빠른 테스트, main 머지 때 전체 테스트). 자경단은 cache + 변경 감지로 PR CI를 1분 안에 유지해요. 왜 이렇게 CI 속도에 집착하냐면, 느린 CI는 다섯 명을 매 PR마다 기다리게 하고, 기다림은 흐름을 끊거든요. "빠른 피드백"이 협업의 생명이에요 — 1분 안에 빨간불/초록불을 알면 바로 고치지만, 20분이면 다른 일 하다 잊어버려요.

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

webhook과 Actions trigger의 관계를 정리해 둘게요. 둘 다 "사건에 반응"이지만 방향이 달라요. **Actions trigger**는 "GitHub 안에서 사건이 나면 GitHub이 워크플로우를 돌림"(안쪽). **webhook**은 "GitHub에서 사건이 나면 외부 서비스에 알림을 보냄"(바깥쪽). 그래서 PR이 머지되면 — Actions는 cleanup·release를 돌리고(H6), webhook은 Slack에 "머지됐어요"를 보내고 Vercel에 "배포해"를 보내요. 같은 사건, 두 방향의 반응. 이 둘이 GitHub을 "닫힌 도구"가 아니라 "전체 개발 생태계의 허브"로 만들어요. 본인 저장소가 Slack·Vercel·PagerDuty와 대화하는 거예요. 그래서 현대 개발은 GitHub을 중심으로 수십 개 도구가 webhook으로 엮인 하나의 신경망이에요.

webhook secret 검증을 한 줄 더. GitHub은 webhook을 보낼 때 본문을 본인이 정한 secret으로 HMAC-SHA256 서명해 헤더에 넣어요. 받는 쪽은 같은 secret으로 본문을 다시 서명해, GitHub이 보낸 서명과 같은지 비교해요 — 같으면 "진짜 GitHub", 다르면 "위조". 이게 H3에서 본 signed commit과 같은 원리예요(서명으로 진위 증명). 검증 없이 webhook을 받으면, 누구나 본인 URL을 알아내 가짜 "배포해" 신호를 보낼 수 있어요. 그래서 webhook을 받는 코드의 첫 줄은 늘 서명 검증이에요. 자동화의 입구일수록 보안이 중요해요.

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

이 15단계가 H1~H6의 모든 것이 하나로 합쳐진 모습이에요. PR(H1), 워크플로우(H2), 환경 dev/staging/prod(H2·H3), 도구 gh(H4), 충돌 없는 흐름(H5), 자동화(H6), 그리고 그 안의 알고리즘(H7). 한 PR이 까미의 손에서 사용자 화면까지 5분에 흐르는 이 길이, 협업의 완성형이에요. 그리고 핵심 — 사람이 손대는 건 단 두 곳이에요(10. 리뷰, 14. prod 트리거). 나머지 13단계는 다 자동. 사람은 "판단"(이 코드 괜찮나, 지금 배포해도 되나)만 하고, 기계가 "실행"을 다 해요. 이게 H6의 "사람은 판단, 기계는 반복"이 파이프라인으로 구현된 거예요. 두 해 후 본인이 만들 사이트도 이 15단계 위에서 돌아요.

이 파이프라인에서 "안전장치"가 어디 있는지 보세요. 6단계(lint·type)와 7단계(test)가 "깨진 코드를 막는 문", 10단계(리뷰)가 "사람의 눈", 13단계(staging smoke test)가 "진짜 배포 전 예행연습"(H2 staging), 14단계(수동 prod 트리거)가 "마지막 사람의 확인". 자동화가 빠르게 흐르되, 중요한 길목마다 안전장치가 있어요. 그래서 "빠르면서도 안전한" 배포가 돼요. 속도와 안전은 트레이드오프가 아니라, 좋은 파이프라인에선 둘 다 얻어요 — 자동화로 빠르게, 안전장치로 든든하게. 이게 현대 DevOps의 핵심이에요(Ch091에서 깊이). 빠른 팀이 사고도 적다는 게 DORA 연구의 결론이고요(H6).

이 파이프라인의 ROI를 한 줄로 — 한 번 만들면 매주 15번, 1년 750번 자동으로 돌아요. 만드는 데 하루, 1년에 750번 사용. 그리고 이게 다섯 명을 다 거치니, 사람 시간으로 환산하면 어마어마해요. 수동으로 매 PR마다 테스트 돌리고 배포하면 PR당 30분, 750번이면 375시간 — 거의 두 달치 풀타임이에요. 파이프라인 하나가 그 두 달을 자동으로 가져가요. 이게 H6에서 본 "자동화 ROI = 인원 × 기간"의 극적인 예예요. 그래서 좋은 개발자는 파이프라인을 만드는 데 하루를 아끼지 않아요.

---

## 10. 흔한 오해 다섯 가지

**오해 1: "rebase는 hash를 바꾸니 위험하다."** 본인 브랜치를 rebase하는 건 안전해요. hash가 바뀌는 건 정상이고(새 부모 위에 다시 쌓으니까), force-with-lease로 안전하게 올리면 동료 작업도 안 날려요. 위험한 건 공유된 main을 rebase하는 거고요. "본인 것은 자유, 공유된 것은 금지" — 이 규칙만 지키면 rebase는 강력한 친구예요(Ch004 H7 회수).

**오해 2: "squash merge하면 commit history가 사라진다."** main에선 한 commit으로 합쳐지지만, PR 페이지에 모든 중간 commit과 변경 과정이 그대로 남아요. 그리고 CHANGELOG의 링크로 추적도 돼요(H6). 즉 main은 깨끗하게, 자세한 기록은 PR에 — 잃는 게 없어요. 다만 정말 의미 있는 큰 PR은 commit을 보존(merge commit)하는 게 나을 때도 있어요(§11 함정).

**오해 3: "GitHub Actions는 완전 무료다."** 무료 2,000분/월까지예요(public 저장소는 무제한). 그 이상은 유료고, macos runner는 분당 10배로 차감돼요. 그래서 자경단은 ubuntu를 표준으로 쓰고, cache로 시간을 줄여 무료 한도 안에 머물러요. "무료지만 한도가 있다"가 정확해요. 한도를 의식하면 효율적으로 쓰게 돼요.

**오해 4: "cache는 항상 적중(hit)한다."** cache key(보통 의존성 파일의 hash)가 맞아야 hit이에요. requirements.txt가 바뀌면 key가 달라져 miss가 나고, 새로 빌드해 새 cache를 만들어요. 이건 사고가 아니라 정상 — "의존성이 바뀌었으니 새로 받는다"는 올바른 동작이에요. cache miss가 가끔 나는 건 건강한 신호예요.

**오해 5: "webhook은 GitHub이 보내니 안전하다."** 누구나 본인 webhook URL로 가짜 POST를 보낼 수 있어요. 그래서 webhook엔 secret 검증(HMAC-SHA256 서명 확인)이 필수예요 — "이 요청이 진짜 GitHub에서 왔나"를 암호로 확인하는 거예요. 검증 없는 webhook은 누구나 본인 배포를 트리거할 수 있는 구멍이에요. 받는 쪽이 늘 검증해야 해요.

다섯 오해를 한 줄로 — 내부 도구는 "안전한데 무서워 보이는" 것들이에요. rebase·squash·cache·webhook 다 안을 알면 안전하고 강력한데, 모르면 위험해 보여요. 그래서 오늘 안을 본 거예요. 안을 보면 무서움이 사라지고, 무서움이 사라지면 도구를 마음껏 써요. 이해가 자유를 줘요. 무서워서 안 쓰던 rebase를 알고 나면 마음껏 쓰게 되고, 그게 본인을 더 빠르고 깔끔한 개발자로 만들어요. 두려움은 무지에서, 자신감은 이해에서 와요.

---

## 10-보충. FAQ — 협업 내부 일곱 질문

**Q1. CI랑 CD가 정확히 뭐예요?** CI(Continuous Integration, 지속적 통합)는 "코드를 자주 합치고 자동으로 검사"예요 — PR마다 테스트·lint를 돌려 깨진 코드를 막는 것. CD(Continuous Delivery/Deployment, 지속적 배포)는 "검증된 코드를 자동으로 배포"고요. 자경단 파이프라인(§9)에서 1~9단계가 CI, 12~15단계가 CD예요. 합쳐서 "코드가 PR에서 사용자까지 자동으로 흐르는 길"이 CI/CD예요.

**Q2. 회사는 rebase랑 merge 중 뭘 써요?** 회사마다 달라요. main history를 깨끗한 일직선으로 두려는 곳은 rebase·squash, 모든 merge 기록을 보존하려는 곳은 merge commit. 자경단은 squash가 표준이에요(PR 단위 깔끔). 첫날 그 팀의 표준을 확인하고 따르면 돼요. 중요한 건 "다섯 명이 같은 방식"이지 어느 게 절대 옳은 건 아니에요.

**Q3. PR 머지 셋(squash·merge·rebase) 중 뭘 골라요?** squash(PR을 한 commit으로, main 깔끔), merge commit(모든 commit + merge 기록 보존), rebase merge(commit을 일렬로 붙임)예요. 자경단은 squash 80%(대부분 PR), merge commit(의미 있는 큰 기능)을 섞어 써요. rebase merge는 동료가 동시에 머지할 때 충돌 위험이 있어 잘 안 써요. "기본은 squash, 큰 건 merge"가 안전한 규칙이에요.

**Q4. CI가 점점 느려져요. 어떻게 빠르게 해요?** 두 가지 — cache(§7, 의존성을 저장해 재사용, 5분→1분)와 matrix(여러 작업을 병렬로). 그리고 무거운 테스트는 PR마다 말고 main 머지 때만 돌리는 분리도 방법이에요. CI가 느리면 다섯 명이 매 PR마다 기다리니, 1분 단축이 다섯 명 × 하루 여러 번의 시간을 아껴요. CI 속도는 팀 속도예요.

**Q5. self-hosted runner는 언제 써요?** GitHub 무료 runner(2,000분/월)로 부족하거나, 사내망에서만 접근 가능한 자원(내부 DB·특수 하드웨어)이 필요할 때예요. 본인 서버에 runner를 두면 시간 무제한이지만, 보안(그 서버가 본인 코드를 실행)과 관리 부담이 생겨요. 자경단 규모엔 무료 runner로 충분하고, self-hosted는 큰 회사의 선택이에요.

**Q6. cherry-pick은 언제 써요?** "한 commit만 다른 브랜치로 옮길 때"예요. 대표 사례 — hotfix를 main과 release 브랜치 둘 다에 보내기(Git Flow). 또는 실수로 잘못된 브랜치에 한 commit을 했을 때 옳은 브랜치로 옮기기. 일상적인 머지는 merge/rebase로 하고, cherry-pick은 "딱 이 commit 하나"가 필요한 특수 상황용이에요. 남발하면 같은 변경이 여러 hash로 복제돼 헷갈려요.

**Q7. git bisect가 뭐예요?** "버그가 언제 들어왔나"를 이등분 탐색으로 찾는 도구예요. "좋았던 commit"과 "버그 있는 commit"을 알려주면, git이 중간 commit을 체크아웃해 "여기 버그 있어/없어?"를 물어요. 절반씩 좁혀서 100개 commit 중 7번 만에 범인을 찾아요(log₂100 ≈ 7). 깨끗한 commit(squash)일수록 정확해요. 버그가 어디서 왔는지 막막할 때 꺼내는 비밀 무기예요.

---

## 11. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 깊이 학습 편

협업 깊이 학습하며 자주 빠지는 함정 다섯.

첫 번째 함정, rebase vs merge 한 번에 다 이해하려고. 안심하세요. **첫 한 달은 merge만.** rebase는 두 번째 달. 둘을 동시에 깊이 파면 헷갈려요. merge("합치기")부터 손에 익히고, 익숙해지면 rebase("옮기기")를 더하세요. 대부분의 일상은 merge나 squash로 되고, rebase는 history를 깔끔히 하고 싶을 때예요. 한 번에 하나씩.

두 번째 함정, --rebase 무서워함. 안심하세요. **자기 브랜치 rebase는 안전.** 공유 브랜치만 금지.

세 번째 함정, cherry-pick 무지성 사용. 안심하세요. **cherry-pick은 핫픽스용 한정.** 일반 머지는 merge/rebase.

네 번째 함정, bisect 안 쓴다. 본인이 어느 commit이 버그인지 추측. 안심하세요. **git bisect로 binary search.** 100 commit 중 7번 안에 찾아내요. 버그가 "언제부터 났는지" 막막할 때, 좋았던 commit과 깨진 commit만 알려주면 git이 중간을 체크아웃해 절반씩 좁혀요. 추측 대신 과학적으로 범인을 찾는 거예요. 한 번 써 보면 평생 무기예요.

다섯 번째 함정, 가장 큰 함정. **squash merge를 무조건 사용.** 본인 PR 100 commit이 1 commit으로. 안심하세요. **squash는 작은 PR에만.** 큰 PR은 commit 보존이 history 가치. 리뷰어가 큰 기능의 각 단계를 따라가야 할 땐, commit을 보존(merge)하는 게 한 덩어리(squash)보다 나아요. "PR 크기에 맞는 머지 전략"을 고르는 게 깊이예요. 자경단도 일상 PR은 squash, 큰 기능은 merge로 — 도구를 상황에 맞게 쓰는 게 핵심이에요.

다섯 함정을 한 줄로 — 내부 도구(rebase·cherry-pick·squash·bisect)는 "한 번에 다 익히기"가 아니라 "필요할 때 하나씩"이에요. merge로 시작해 rebase로, squash 기본에 큰 PR은 merge로, 버그 막막하면 bisect로. 도구를 상황에 맞게 꺼내는 게 깊이예요. 다 외우려 말고, "이런 게 있다"만 알아 두고 필요할 때 깊이 파세요. 다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 12. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요.

GitHub Actions runner 내부, rebase 알고리즘, 머지 세 전략, cherry-pick, PR 머지 방식, CI 캐시, webhook, 자경단 파이프라인.

오늘 한 줄 정리. **협업 도구(rebase·merge·Actions·cache)는 마법이 아니라 정직한 알고리즘의 연쇄이고, 내부를 알면 사고에 침착해진다.** 본인이 이 한 줄을 손에 쥐면, 어떤 git/CI 사고를 만나도 "안에서 뭘 하는 중이지?"로 침착하게 접근해요.

본인 페이스. 7/8 시간. 87.5%. 한 시간만 남았어요! H1~H6에서 협업을 배우고, H7에서 그 안쪽을 봤어요. 이제 마지막 H8 — 배운 모든 걸 자경단에 박고, 첫 PR부터 5년까지의 여정을 그리며 Ch005를 마무리해요. 박수.

다음 H8은 적용 + 회고. 자경단 첫 PR부터 5년까지.

```bash
gh workflow list
gh run list --limit 5
```

이 두 줄을 치면 본인 저장소의 워크플로우와 최근 실행이 보여요 — H6에서 만든 것들이 H7에서 배운 원리로 돌고 있어요. 오늘로 본인은 협업 도구를 "쓰는 사람"에서 "아는 사람"으로 넘어왔어요. 매일 쓰던 도구의 "엔진룸"을 봤어요 — rebase가 commit을 새로 심고, CI가 깨끗한 VM에서 돌고, webhook이 생태계를 잇는. 이제 본인에게 협업 도구는 블랙박스가 아니라 유리 상자예요(Ch004 H7과 같은 졸업). 유리 상자는 안 무서워요. 사고가 나도 "안에서 뭘 하는 중이지?"로 침착하게 접근하는 사람 — 그게 오늘의 본인이에요. 다음 H8은 Ch005의 마지막 — H1~H7의 모든 걸 자경단 저장소에 박고, 첫 PR부터 5년까지의 여정을 그리며 마무리해요. 그리고 Ch006(터미널)로 다리를 놓고요. 잘 따라오셨어요. 5분 쉬고 마지막 H8에서 만나요.

---

## 👨‍💻 개발자 노트

> - GitHub Actions runner: actions/runner 오픈소스.
> - rebase autosquash: fixup commit 자동 통합.
> - 3-way merge 알고리즘: recursive (default), patience, ort.
> - cache scope: per branch + main.
> - webhook 보안: HMAC-SHA256 signature.
> - 다음 H8 키워드: 자경단 첫 PR · 1년 · 3년 · 5년 진화.

---

## 추신

1. 협업 도구는 마법이 아니라 정직한 알고리즘. 안을 보면 안 무서워요.
2. rebase = merge base 찾기 → commit 추출 → main 끝에 차례로 적용.
3. rebase 후 hash가 바뀌어요. 그래서 force-with-lease가 짝.
4. merge 세 전략 — fast-forward·three-way·squash.
5. fast-forward는 새 commit 0, 그냥 포인터 점프.
6. three-way는 merge commit(부모 둘) 생성.
7. squash는 PR 전체를 한 commit으로. 자경단 표준.
8. cherry-pick은 한 commit의 변경만 떼서 새 hash로 적용.
9. cherry-pick은 hotfix를 두 브랜치에 보낼 때.
10. GitHub Actions runner — VM이 떠서 steps 돌고 폐기.
11. ubuntu 1배·macos 10배·windows 2배. 자경단은 ubuntu.
12. 무료 2,000분/월. self-hosted runner는 무한.
13. cache로 CI 5분 → 1분. key는 requirements.txt hash.
14. cache miss는 key 안 맞을 때(파일 바뀜). 정상이에요.
15. webhook은 GitHub이 외부에 POST. Slack·Vercel·PagerDuty.
16. webhook secret 검증(HMAC) 필수 — 위조 막기.
17. trigger 종류 — push·pull_request·schedule·dispatch·release.
18. CI/CD 파이프라인 15단계 — PR→checkout→test→리뷰→머지→배포.
19. 3-way merge 알고리즘 — recursive·patience·ort(현 기본).
20. git bisect로 버그 commit을 이등분 탐색. 100개 중 7번에.
21. bisect는 깨끗한 commit이라야 정확. squash가 도와요.
22. squash는 작은 PR에. 큰 PR은 commit 보존이 가치.
23. rebase merge는 피해요 — 동료 머지 시 충돌 가능.
24. 내부를 알면 사고에 침착 — "refs만 옮기면 되겠다"(Ch004 H7).
25. self-hosted runner는 보안·비용 트레이드오프. 큰 회사용.
26. CI 느리면 cache + matrix(병렬). 다섯 명 시간을 아껴요.
27. webhook이 deploy를 트리거 — git push가 배포 방아쇠(Ch003 H8).
28. 면접 — "rebase 내부?", "merge 세 전략?", "CI cache 원리?".
29. 자동화는 정직한 단계의 연쇄. H6에서 쓴 걸 H7에서 이해.
30. matrix로 여러 환경을 병렬 검사. 넓게 그러나 빠르게.
31. 3-way merge — base·ours·theirs 셋 비교. 같은 줄만 충돌.
32. rebase -i로 commit 편집 — squash·reword·drop. push 전에만.
33. CI 빠른 피드백이 협업의 생명. 1분이면 고치고 20분이면 잊어요.
34. webhook secret 검증(HMAC)은 필수. 자동화 입구의 보안.
35. 파이프라인 15단계 중 사람은 둘(리뷰·prod). 나머지는 자동.
36. artifact로 휘발되는 VM에서 결과를 남겨요(테스트 리포트·스크린샷).
37. cherry-pick·rebase·squash 다 commit 복사 → 새 hash. 한 원리.
38. 파이프라인 하나가 1년 두 달치 사람 시간을 자동으로 가져가요.
39. rebase가 꼬여도 reflog가 안전망(Ch004 H7). 안심하고 실험하세요.
40. 다음 H8은 적용+회고 — 자경단 첫 PR부터 5년. Ch005의 마지막이에요. 협업 도구의 엔진룸까지 본 본인, 마지막 한 시간만 남았어요. 5분 쉬고 H8에서 만나요. 🐾
