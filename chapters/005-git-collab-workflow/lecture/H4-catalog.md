# Ch005 · H4 — 협업 30 도구 카탈로그 — 일상·PR·리뷰·conflict·정리·CI

> 고양이 자경단 · Ch 005 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 위험도 신호등
3. 30 도구 한 표
4. 무리 1 — 일상 흐름 5
5. 무리 2 — PR 흐름 5
6. 무리 3 — 리뷰 도구 5
7. 무리 4 — conflict 도구 5
8. 무리 5 — commit 정리 5
9. 무리 6 — CI/Actions 5
9-보충. git과 gh — 두 도구의 분업
10. 매일·주간·월간 손가락 리듬
11. 자경단 매일 13줄 흐름
12. 다섯 함정과 처방
13. 흔한 오해 다섯 가지
13-보충. FAQ — 협업 도구 일곱 질문
14. 마무리 — 다음 H5에서 만나요

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H3 회수. 8단추 셋업. Organization, Team, Protection, CODEOWNERS, husky.

이번 H4는 협업의 30 도구. 본인의 매일 PR 사이클의 손가락.

H1·H2·H3·H4가 하나의 이야기예요 — 왜(H1), 개념(H2), 환경(H3), 도구(H4). 오늘 도구를 손에 쥐면 H1~H3이 다 실전으로 연결돼요. 환경(branch protection·CODEOWNERS)이 도구(gh pr merge·review)와 만나 매일의 협업이 돌아가요. 개념을 알고 환경을 깔았으면, 이제 그 위에서 빠르게 움직이는 손가락이 필요하잖아요. 그게 오늘이에요.

오늘의 약속. **본인이 매일 만나는 30 협업 도구를 6무리로 손에 박습니다**.

H3에서 환경을 깔았다면, H4는 그 환경에서 매일 쓰는 손가락이에요. 셋업은 한 번이지만, 도구는 매일이에요. 그래서 오늘은 외우는 시간이 아니라 손에 익히는 시간이에요 — 가능하면 본인 저장소에서 같이 쳐 보세요. 그리고 미리 안심 — 30개가 많아 보여도 매일 쓰는 건 여섯 개예요. 나머지는 필요할 때 만나며 익어요. 30이라는 숫자에 겁먹지 마세요. 자, 가요.

---

## 2. 위험도 신호등

**🟢 초록**. read-only. git status, git log, gh pr view. 사고 0.

**🟡 노랑**. local 변경. git add, git commit, git push. 보통 안전.

**🔴 빨강**. 되돌리기 어려움. force-push, branch -D, rebase. 1초 호흡.

30개 중 빨강은 5개뿐. 25개는 마음 편히.

빨강 다섯을 콕 짚어 둘게요 — `git push --force`, `git branch -D`(강제 삭제), `git reset --hard`, `git rebase`(공유 브랜치), `git clean -fd`(추적 안 된 파일 삭제). 이 다섯 앞에선 1초 호흡하고, 가능하면 더 안전한 버전을 써요(`--force` 대신 `--force-with-lease`). 나머지 25개는 🟢/🟡라 사고가 거의 안 나거나 reflog로 복구돼요(Ch004 H7). 그래서 신호등의 진짜 메시지는 "겁먹지 말고, 다섯 개만 조심하라"예요. 신입이 git 전체를 무서워하는 건 이 다섯과 나머지 스물다섯을 구별 못 해서예요. 색을 칠해 두면 손가락이 빨강 앞에서만 멈춰요. 그리고 같은 명령도 옵션이 색을 바꿔요 — `git push`는 🟢, `git push --force`는 🔴. 명령이 아니라 "명령+옵션+맥락"이 위험도를 정해요.

빨강이 무섭게 느껴져도 한 가지 안심 — git엔 reflog라는 30~90일 안전망이 있어요(Ch004 H7). `reset --hard`로 commit을 날려도, `branch -D`로 브랜치를 지워도, reflog로 5분에 복구돼요. 그래서 빨강도 "절대 못 되돌림"이 아니라 "한 박자 조심"이에요. 진짜 못 되돌리는 건 단 하나 — 아직 commit 안 한 변경뿐. 그래서 "일단 commit"이 안전의 첫 규칙이에요. 안전망을 믿고 과감히, 다만 빨강 앞에선 1초. 이 균형이 git을 무서워하지 않으면서도 신중하게 쓰는 비결이에요. 신입은 둘 중 하나로 치우쳐요 — 다 무서워해서 아무것도 못 하거나, 다 막 쳐서 사고를 내거나. 빨강 다섯만 조심하는 균형이 답이에요.

---

## 3. 30 도구 한 표

| 무리 | 도구 |
|------|------|
| 일상 | git status, git pull, git fetch, git checkout, git switch |
| PR | gh pr create, gh pr list, gh pr view, gh pr checkout, gh pr merge |
| 리뷰 | gh pr diff, gh pr review, gh pr checks, gh pr ready, gh pr comment |
| conflict | git rebase, git merge, git cherry-pick, git rerere, git mergetool |
| commit 정리 | git commit --amend, git rebase -i, git reset --soft, git stash, git restore |
| CI | gh run list, gh run view, gh run watch, gh workflow run, gh secret set |

30. 6무리.

이 표를 외우려 하지 마세요. 대신 "무리"로 묶어서 기억하세요 — 협업의 하루가 이 여섯 무리를 순서대로 도는 거예요. 아침에 일상(무리1)으로 동기화하고, 작업 후 PR(무리2)을 만들고, 동료와 리뷰(무리3)를 주고받고, 충돌(무리4)을 풀고, 머지 전 정리(무리5)하고, CI(무리6)로 검증해요. 30개가 흩어진 명령이 아니라 "하루의 흐름"이에요. 무리로 묶으면 30개가 여섯 덩어리가 되고, 여섯은 손가락으로 셀 수 있어요. 그리고 git과 gh의 경계도 보여요 — 일상·conflict·정리는 `git`(로컬), PR·리뷰·CI는 `gh`(GitHub). git은 내 노트북 안의 일, gh는 GitHub과의 대화예요. 이 경계를 알면 "이건 git이지 gh가 아니다"가 헷갈리지 않아요.

그리고 30개가 많아 보이지만, 실은 Ch004에서 배운 23개 git 명령어에 gh 명령 몇 개를 더한 거예요. 본인은 이미 절반 이상을 알고 있어요. 새로 익힐 건 gh(PR·리뷰·CI)와 협업 특화 도구(rerere·cherry-pick) 정도예요. 그래서 "30개 새로 외우기"가 아니라 "Ch004 위에 협업 도구 얹기"예요. 기초가 있으니 새 도구가 쉽게 얹혀요. 혼자 git(Ch004)을 안 사람이 함께 git(Ch005)으로 자연스럽게 넘어가는 거예요.

---

## 4. 무리 1 — 일상 흐름 5

매일 아침 자경단의 첫 5명령어.

```bash
# 1. 상태
git status

# 2. 최신 받기
git pull --rebase

# 3. 원격 정보만 (working tree 영향 없음)
git fetch --all --prune

# 4. branch 이동 (옛 명령)
git checkout main

# 5. branch 이동 (새 명령, 권장)
git switch main
```

자경단의 매일 아침 다섯. 자동.

이 다섯이 왜 매일 아침이냐면, "내 상태를 알고, 남의 변경을 받고, 일할 자리로 옮긴다"가 협업의 시작이기 때문이에요. `git status`로 내가 어디 있는지 보고, `git pull --rebase`로 동료들의 어젯밤 작업을 받고(rebase라 history 깨끗), `git switch`로 작업할 브랜치로 옮겨요. 특히 `git fetch`와 `git pull`의 차이를 기억하세요 — fetch는 "받기만"(read-only, 100% 안전), pull은 "받아서 합치기"(충돌 가능). 신중할 땐 fetch로 먼저 보고 pull해요. 이 다섯은 다 🟢/🟡라 마음 편히 매일 쳐요. 손가락이 무의식으로 이 다섯을 치는 게 협업 1주차의 목표예요.

`git pull --rebase`를 조금 더. 그냥 `git pull`은 동료 작업을 받을 때 merge commit("Merge branch main")을 남겨요 — 이게 쌓이면 history가 "Merge…" 투성이로 지저분해져요. `--rebase`는 내 작업을 잠깐 떼고, 동료 작업을 먼저 얹고, 내 작업을 그 위에 다시 올려요 — merge commit 없이 일직선. 그래서 자경단은 `git config --global pull.rebase true`로 기본을 rebase로 박아 둬요. 한 번 설정하면 매일 깔끔한 history가 공짜로 따라와요. 작은 설정 하나가 1년의 history를 바꿔요.

---

## 5. 무리 2 — PR 흐름 5

매일 한 번의 PR 사이클.

```bash
# 1. PR 만들기
gh pr create --draft --title "feat: cat photo" --body "..."

# 2. 모든 PR 보기
gh pr list

# 3. 특정 PR 자세히
gh pr view 42

# 4. PR을 local로 가져오기
gh pr checkout 42

# 5. 머지
gh pr merge --squash --delete-branch
```

다섯 명령. 자경단 매일 1~2회.

PR 흐름의 핵심은 `gh pr create --draft`예요 — draft로 일찍 올려 동료가 방향을 봐 주면, 다 만든 뒤 "이거 아닌데"를 듣는 비극을 막아요(H2 early feedback). 완성되면 `gh pr ready`로 정식 리뷰 요청. 머지는 `gh pr merge --squash --delete-branch` 한 줄 — squash로 history 깨끗하게, delete-branch로 머지된 브랜치 자동 청소. 이 한 줄에 H2·H3에서 배운 squash·정리가 다 들어 있어요. 그리고 `gh pr checkout 42`로 동료의 PR을 내 노트북으로 가져와 직접 돌려볼 수 있어요 — 리뷰는 코드를 읽는 것만이 아니라 실제로 돌려보는 것까지예요.

PR을 만들 때 `--title`과 `--body`를 잘 쓰는 게 첫인상이에요. 제목은 Conventional Commits 형식(`feat: 고양이 좋아요 버튼`), 본문은 "무엇을·왜·어떻게 테스트". `gh pr create --fill`을 쓰면 commit 메시지로 본문을 자동 채워 주니, commit을 잘 써 두면 PR도 공짜로 좋아져요. 작은 PR + 명확한 제목 + 채워진 본문 — 이 셋이 본인을 "일 잘하는 사람"으로 보이게 해요(Ch004 H8 회수). PR은 코드를 보내는 게 아니라 본인의 일하는 방식을 보내는 거예요.

---

## 6. 무리 3 — 리뷰 도구 5

리뷰의 다섯 도구.

```bash
# 1. PR diff
gh pr diff 42

# 2. PR 리뷰 (approve/request changes/comment)
gh pr review 42 --approve
gh pr review 42 --request-changes -b "..."
gh pr review 42 --comment -b "..."

# 3. CI 상태
gh pr checks 42

# 4. draft → ready
gh pr ready 42

# 5. 코멘트
gh pr comment 42 -b "..."
```

자경단 매일.

리뷰 도구의 심장은 `gh pr review`의 세 모드예요 — `--approve`(승인), `--request-changes`(수정 요청), `--comment`(의견만). 이 셋이 H1에서 본 리뷰 톤과 연결돼요. `--request-changes`는 강한 신호("이건 고쳐야 머지")라 신중히 쓰고, 대부분은 `--comment`로 부드럽게 제안해요. `gh pr checks`로 CI 초록불을 확인하고, `gh pr diff`로 터미널에서 변경을 읽어요. 리뷰는 "코드를 막는 일"이 아니라 "코드를 함께 빚는 일"이라(H1), 도구도 그 정신을 담아요. 승인 버튼 하나에도 본인의 책임이 담겨요 — approve는 "나도 이 코드에 동의한다"는 서명이에요.

리뷰를 받는 쪽도 도구가 있어요. 코멘트가 오면 고치고 `git commit --fixup`으로 "OO 코멘트 반영" commit을 만든 뒤, 머지 전 `rebase -i --autosquash`로 원래 commit에 합쳐요 — history가 깨끗해져요. 또는 코멘트에 동의 안 하면 정중히 이유를 답글로 — 리뷰는 일방 명령이 아니라 대화니까요(H1). 받는 쪽이 빠르게 반응하면 리뷰 사이클이 짧아지고, 짧은 사이클이 빠른 머지예요. 리뷰는 주는 쪽과 받는 쪽의 합주예요.

리뷰는 얼마나 자주 하냐고요? 자경단은 매일 오전·오후 두 번, 동료 PR을 몰아서 봐요. 리뷰가 막히면 동료가 멈추니, 리뷰는 본인 작업만큼 중요한 일이에요. "내 코드 짜느라 바빠서 리뷰 못 했어"는 협업에서 가장 미안한 말이에요 — 본인이 안 봐 주면 동료의 PR이 하루 종일 멈춰 있거든요. 그래서 좋은 협업자는 자기 코드만큼 남의 리뷰를 챙겨요. 리뷰는 시간을 쓰는 게 아니라 팀의 속도를 만드는 거예요. 본인이 빨리 리뷰하면 다섯 명 전체가 빨라지고, 본인이 미루면 다섯 명이 같이 느려져요. 리뷰는 본인의 친절이자 팀의 엔진이에요.

---

## 7. 무리 4 — conflict 도구 5

충돌의 다섯 도구.

```bash
# 1. rebase (자경단 표준)
git rebase main

# 2. merge (rebase 안 가능 시)
git merge main

# 3. 특정 commit만 (cherry-pick)
git cherry-pick abc123

# 4. 같은 충돌 자동 해결 학습
git rerere
git config rerere.enabled true

# 5. GUI mergetool
git mergetool
```

자경단 매주.

충돌 도구의 자경단 표준은 `git rebase main`이에요 — 내 브랜치를 최신 main 위로 옮겨, history를 일직선으로 만들어요. 충돌이 나면 한 commit씩 풀고 `--continue`, 안 되면 `--abort`로 안전하게 후퇴. `git rerere`를 켜 두면 같은 충돌을 두 번 안 풀어요. 텍스트 마커(`<<<<<<<`)가 무서우면 `git mergetool`로 VS Code 같은 GUI를 띄워 양쪽을 나란히 보며 풀어요 — GUI가 텍스트보다 훨씬 편해요. `git cherry-pick`은 특정 commit 하나만 골라 다른 브랜치로 옮길 때(예: hotfix를 main과 develop 둘 다에). 충돌은 사고가 아니라 git이 "결정 도와달라"는 신호예요(H1). 도구가 자동으로 못 푸는 건 사람의 판단이 필요하다는 뜻이고요.

충돌이 무서운 신입에게 한마디. 충돌 마커(`<<<<<<< HEAD` … `=======` … `>>>>>>>`)는 git이 "여기 두 버전이 있는데 뭘 고를래?"라고 묻는 거예요. 위는 내 버전(HEAD), 아래는 들어오는 버전. 둘 중 하나를 고르거나, 둘을 합쳐서 손으로 정리하고, 마커 세 줄을 지운 뒤 `git add`. 그게 전부예요. 충돌은 git이 똑똑해서 "내가 함부로 못 정하겠으니 사람이 정해줘"라고 정직하게 멈춘 거예요 — 오히려 고마운 거예요. 말없이 한쪽을 날리는 도구가 더 무섭잖아요. 충돌을 한 번 손으로 풀어 보면, 그 뒤론 안 무서워요.

---

## 8. 무리 5 — commit 정리 5

머지 직전 5분 정리.

```bash
# 1. 마지막 commit 수정
git commit --amend

# 2. 인터랙티브 rebase (commit 정리)
git rebase -i HEAD~5

# 3. 마지막 commit 취소 (변경 유지)
git reset --soft HEAD~1

# 4. 일시 보관
git stash
git stash pop

# 5. 변경 취소 (옛 checkout 대체)
git restore file.txt
```

자경단 매일.

commit 정리 도구는 "push 전"에 쓰는 게 핵심이에요. `git commit --amend`(마지막 commit 수정), `git rebase -i`(여러 commit을 squash·reword·정리), `git reset --soft HEAD~1`(마지막 commit만 취소, 변경은 유지) — 다 history를 다듬는 도구라 push 후엔 위험해요(공유된 history 변경). push 전에 본인 브랜치에서 마음껏 다듬고, 깨끗해지면 push해요. `git stash`는 "잠깐 다른 일" 임시 보관(1일), `git restore`는 "이 파일 되돌리기"(옛 checkout의 헷갈림을 푼 새 도구). 정리는 "깨끗한 PR"을 만드는 마지막 5분이에요 — 리뷰어에게 다듬어진 코드를 주는 예의예요. 지저분한 commit 열 개보다 깔끔한 commit 세 개가 리뷰를 빠르게 해요.

한 가지 주의 — `commit --amend`와 `rebase -i`는 history를 바꾸는 도구라, 이미 push한 commit엔 쓰면 안 돼요(공유된 history 변경 = 빨강). push 전 본인 브랜치에서만 자유롭게. 만약 push 후 정리가 꼭 필요하면 `--force-with-lease`로 조심스럽게, 그것도 본인 브랜치에서만. main은 절대. 정리는 "리뷰어에게 보이기 전"에 끝내는 게 깔끔해요 — 리뷰 중에 history를 바꾸면 리뷰어가 헷갈리거든요.

왜 이렇게 history를 깨끗하게 신경 쓰냐고요? main의 `git log`가 곧 프로젝트의 역사책이기 때문이에요. 1년 후 "이 기능 왜 이렇게 됐지?"를 추적할 때, 깨끗한 history는 한 줄로 답을 주고 지저분한 history는 미궁이에요. `git bisect`로 버그가 언제 들어왔는지 이등분 탐색할 때도, 깨끗한 commit이라야 범인을 정확히 짚어요. 정리 5분이 1년 후 디버깅 5시간을 아껴요. 깨끗한 history는 미래의 나와 동료에게 주는 선물이에요.

stash 하나만 더. 긴급 상황이 좋은 예예요 — 본인이 feature를 작업 중인데 갑자기 prod 버그 hotfix를 해야 해요. 작업이 어중간해서 commit하긴 그렇고. 그때 `git stash`로 잠깐 치워 두고, hotfix 브랜치로 가서 고치고, 돌아와 `git stash pop`으로 작업을 되살려요. "잠깐 다른 일"의 완벽한 도구예요. 다만 pop을 잊고 또 stash하면 쌓이니, stash는 "치웠으면 곧 되살리기"가 규칙이에요. 이름이 없는 임시 보관이라, 오래 두면 본인도 뭐였는지 잊어요.

---

## 9. 무리 6 — CI/Actions 5

```bash
# 1. CI 실행 목록
gh run list

# 2. CI 상세
gh run view 12345

# 3. 실시간 모니터
gh run watch

# 4. 수동 실행
gh workflow run deploy.yml

# 5. secret 추가
gh secret set DEPLOY_KEY < deploy.key
```

자경단 매주.

CI 도구로 본인이 GitHub Actions를 터미널에서 다뤄요. `gh run list`(최근 실행), `gh run view`(상세 로그), `gh run watch`(실시간 모니터 — 배포가 도는 걸 눈으로). `gh workflow run`으로 수동 트리거(예: prod 배포 버튼), `gh secret set`으로 비밀을 코드 밖 안전한 곳에. CI가 빨간불이면 `gh run view`로 로그를 봐서 어디서 실패했는지 1분에 찾아요. CI는 다섯 명의 "24시간 자동 동료"예요(H7 예고) — 사람이 잠든 새벽에도 테스트를 돌리고, 깨진 코드를 막아요. 이 도구로 그 자동 동료와 대화하는 거예요. 터미널을 안 떠나고 배포까지 보는 게 흐름이 안 끊기는 비결이에요.

---

## 9-보충. git과 gh — 두 도구의 분업

30 도구가 사실 두 도구예요 — `git`과 `gh`. 둘의 분업을 알면 30개가 더 또렷해져요. **git**은 본인 노트북 안의 일 — commit·branch·rebase·stash·reset. 인터넷 없이도 돼요(분산, Ch004). **gh**는 GitHub과의 대화 — PR·리뷰·CI·secret. 인터넷이 필요해요. 그래서 비행기에서도 git은 되고, gh는 안 돼요.

왜 둘로 나뉘냐면, git은 2005년 리누스가 만든 분산 버전 관리 도구이고, gh는 2020년 GitHub이 만든 GitHub 전용 CLI거든요. git은 어느 호스팅(GitLab·Bitbucket)에서도 똑같고, gh는 GitHub 특화예요. 그래서 회사가 GitLab을 쓰면 git은 그대로, gh 대신 glab을 써요. 본인이 배운 git 절반은 어디서나 통하고, gh 절반은 GitHub에서 통해요.

실무 팁 — 둘을 한 줄로 엮으면 강력해요. `git push && gh pr create`(올리고 바로 PR), `gh pr checkout 42 && git rebase main`(가져와서 rebase). git의 로컬 작업과 gh의 GitHub 작업이 한 흐름으로 이어지는 거예요. 이 분업을 머리에 두면 "이건 로컬 일이니 git, 이건 GitHub 일이니 gh"가 자동으로 떠올라요.

한 가지 더 — gh는 GitHub 전용이지만, 같은 철학의 도구가 다른 호스팅에도 있어요. GitLab엔 `glab`, Bitbucket엔 자체 CLI. 그래서 본인이 gh를 익혀 두면, 다른 호스팅으로 옮겨도 "CLI로 PR을 다룬다"는 개념은 그대로 가져가요. 도구 이름은 바뀌어도 패턴은 같아요. git처럼 gh도 "특정 도구"가 아니라 "일하는 방식"을 배우는 거예요. 방식을 배우면 도구가 바뀌어도 흔들리지 않아요.

---

## 10. 매일·주간·월간 손가락 리듬

**매일 6**. status, pull, switch, add, commit, push.

**주간 8**. pr create/list/view, rebase, push --force-with-lease, stash, restore, log graph.

**월간 7**. rebase -i, cherry-pick, reset, reflog, gh run, gh secret, mergetool.

매일 6개부터.

이 리듬이 학습의 지도예요. 1~2주차엔 매일 6개만 — 이게 손에 붙으면 협업의 90%가 돼요. 3~4주차에 주간 8개(PR·rebase·stash 등)를 더하고, 한 달 후 월간 7개(rebase -i·cherry-pick·reflog 등)를 만나며 익혀요. 한 번에 30개를 외우려 하면 체하고, 매일 6 → 주간 8 → 월간 7로 나눠 쌓으면 한 달이면 다 손에 들어와요. 그리고 월간 도구(빨강이 많은)는 "필요할 때 그 자리에서" 배우는 게 가장 잘 남아요 — 충돌이 났을 때 배운 rebase -i는 평생 안 잊거든요. 외워서 쌓는 게 아니라 써서 쌓는 거예요. 그래서 30개를 다 못 외워도 전혀 부끄럽지 않아요. 5년 차도 월간 도구는 가끔 검색해요.

두 해 후 본인을 그려 볼게요. 회사 첫날, 본인이 터미널을 열고 `git status`·`git pull --rebase`·`git switch -c feature/...`를 생각 없이 쳐요. 옆자리 동기는 아직 GitHub 웹을 클릭하며 헤매요. 같은 신입인데 본인 손이 두 배 빨라요 — 그 차이가 한 달이면 눈에 띄어요. 도구를 손에 익힌다는 건 "생각하지 않고도 손이 가는" 상태예요. 운전을 배울 때 처음엔 기어·핸들을 의식하지만 익으면 무의식으로 가듯, git/gh도 그래요. 오늘 30개를 만난 게, 두 해 후 무의식의 손가락이 되는 첫걸음이에요.

---

## 11. 자경단 매일 13줄 흐름

```bash
# 자경단 까미의 매일

# 아침
cd ~/cat-vigilante && git status
git pull --rebase

# 작업
git switch -c feature/api-cats
# ... 코드 짜기
git add -p
git commit -m "feat(api): cat list endpoint"

# push
git push -u origin feature/api-cats

# PR
gh pr create --draft

# 리뷰 받기 후
gh pr ready

# 머지
gh pr merge --squash

# 정리
git switch main
git pull --rebase
git branch -d feature/api-cats
```

13줄. 자경단의 매일.

이 13줄이 까미의 하루 전체예요 — 아침 동기화 2줄, 작업·commit 4줄, push 1줄, PR 2줄, 머지 1줄, 정리 3줄. 이 13줄을 손가락이 무의식으로 칠 수 있으면, 본인은 협업 개발자예요. 처음엔 한 줄씩 보며 치지만, 한 달 후엔 생각보다 손이 먼저 가요. 그리고 이 흐름에서 30 도구 중 9개가 등장해요(status·pull·switch·add·commit·push·gh pr create·ready·merge) — 매일 쓰는 건 정말 한 줌이에요. 나머지 21개는 특별한 상황(충돌·정리·CI 사고)에서만 꺼내요. 그래서 "매일 13줄"을 손에 박는 게 30개 외우기보다 백 배 효율적이에요. 이 13줄이 H5 데모에서 다섯 명의 실제 시뮬레이션으로 살아나요. 오늘은 도구를 손에 쥐고, 다음 시간엔 그 손으로 다섯 명이 합주하는 걸 봐요.

흐름에서 `git add -p` 한 줄을 짚어 둘게요(까미의 작업 부분). `-p`는 patch 모드 — 바뀐 것 전체를 add하지 않고, 한 조각(hunk)씩 보며 "이건 담고, 저건 빼고"를 골라요. 그래서 "한 commit = 한 의도"(H2)를 지킬 수 있어요. 로그인 버그 수정과 색깔 변경을 같이 작업했어도, `add -p`로 버그 수정만 골라 한 commit, 색깔만 골라 다른 commit. 무엇을 함께 묶을지 본인이 정하는 자유예요(Ch004 H7 index 회수). 작은 습관이지만, 이게 깨끗한 history의 시작이에요. 리뷰어가 본인 PR을 열었을 때 "아, 이 사람 commit이 깔끔하네" 하는 첫인상이 여기서 나와요.

이 13줄을 매일 반복하면 한 달 후엔 안 보고도 손이 가요. 그리고 이게 까미만의 흐름이 아니에요 — 노랭이·미니·깜장이도 각자 같은 13줄을 돌려요. 다섯 명이 같은 리듬으로 일하니, 누구의 코드를 봐도 흐름이 익숙해요. 일관된 흐름이 협업의 보이지 않는 윤활유예요. 각자 다른 방식으로 일하면 매번 "이 사람은 어떻게 하지?"를 물어야 하지만, 같은 13줄이면 다섯이 한 몸처럼 움직여요.

---

## 12. 다섯 함정과 처방

**함정 1: force-push로 동료 작업을 날림.** rebase 후 push할 때 `--force`를 쓰다가 동료가 그 사이 올린 commit을 덮어요. 처방 — 항상 `--force-with-lease`. 동료가 push한 게 있으면 거부해서 남의 작업을 안 날려요. main엔 아예 force 금지(branch protection, H3). 이 한 옵션이 H1에서 본 force-push 사고를 원천 차단해요.

**함정 2: rebase 충돌 폭발.** 브랜치를 오래 묵혀 두면 main이 멀어져, rebase할 때 충돌이 수십 개 터져요. 처방 — 매일 main을 rebase하고 작은 commit으로. 작은 conflict 매일이 큰 conflict 한 달보다 100배 쉬워요(H2 회수). 충돌이 폭발하는 건 도구 탓이 아니라 묵힌 탓이에요.

**함정 3: PR이 너무 큼.** 500줄 PR은 리뷰어가 한숨을 쉬고 리뷰가 한 시간 걸려요. 처방 — 평균 200줄, 최대 500줄. 큰 작업은 작은 PR 여러 개로 쪼개요(stack PR). 작은 PR이 빠르게 머지되고 사고도 작아요. PR 크기가 리뷰 속도를 정해요.

**함정 4: 머지 후 branch 안 지움.** 머지된 브랜치가 쌓이면 `git branch`가 수십 줄 정글이 돼요. 처방 — `gh pr merge --delete-branch`로 머지와 동시에 자동 삭제, 또는 Settings에서 "자동 삭제" 켜기(Ch004 H8). 깨끗한 브랜치 목록이 깨끗한 머리예요.

**함정 5: CI 빨간불 무시.** "내 로컬에선 됐으니까" 하며 CI 실패를 무시하고 머지하면, 그게 main을 깨요. 처방 — 머지 전 항상 CI 초록불(`gh pr checks`). branch protection의 status check를 켜면 아예 못 머지하게 강제돼요(H3). CI 빨간불은 머지하지 말라는 신호지 무시할 잡음이 아니에요.

---

## 13. 흔한 오해 다섯 가지

**오해 1: "30개를 다 외워야 협업할 수 있다."** 아니에요. 매일 쓰는 건 여섯 개(status·pull·switch·add·commit·push)예요. 이 여섯이 손에 붙으면 협업의 일상이 끝나요. 나머지 24개는 PR·conflict·정리 때 한 달에 몇 번 만나며 천천히 익어요. 카탈로그는 외우는 종이가 아니라 찾는 종이예요 — 기억 안 나면 `gh --help`나 `git help`로 찾으면 돼요.

**오해 2: "rebase는 위험하니 안 쓰는 게 낫다."** 본인 브랜치를 main 위로 rebase하는 건 안전하고 권장돼요(history가 깔끔해져요). 위험한 건 "공유된 브랜치(main)"를 rebase하는 거예요 — 그건 금지. "본인 것은 자유, 공유된 것은 금지"라는 황금 규칙만 지키면 rebase는 강력한 친구예요(Ch004 H7 회수).

**오해 3: "gh CLI는 있으면 좋은 옵션일 뿐이다."** 자경단은 매일 써요. `gh pr create` 한 줄이 웹에서 클릭 다섯 번을 대신하고, `gh pr checks`로 CI를 터미널에서 확인하고, `gh run watch`로 배포를 실시간으로 봐요. 터미널에서 손을 안 떼고 GitHub을 다루니 흐름이 안 끊겨요. 손이 빠른 사람이 결국 일이 빠른 사람이에요.

**오해 4: "PR diff는 GitHub 웹에서만 봐야 한다."** `gh pr diff 42`로 터미널에서 바로 봐요. 리뷰도 `gh pr review`로 터미널에서 해요. 웹과 CLI는 같은 일을 다른 입구로 하는 거예요 — 본인 손이 편한 쪽을 쓰되, CLI를 익혀 두면 스크립트·자동화로 이어져요. 웹은 보기 편하고, CLI는 빠르고 자동화돼요.

**오해 5: "stash를 자주 쓰면 편하다."** stash는 "잠깐 다른 일 하러 갈 때 1일 임시 보관"용이에요. 자주 쓰면 stash가 쌓여서 뭐가 뭔지 잃어버려요. 며칠 보관할 거면 stash가 아니라 branch + commit이 안전해요(이름이 있으니까). stash는 임시, commit은 영구 — 용도를 구별하세요.

다섯 오해를 한 줄로 — 도구는 "다 외우는 무기고"가 아니라 "필요할 때 꺼내는 연장통"이에요. 매일 여섯 개를 손에, 나머지는 연장통에. 그리고 rebase·gh·CLI를 무서워 말고 친구로 삼으세요. 도구를 친구로 두는 사람이 협업이 빨라요. 무서워하면 피하고, 피하면 영영 안 익어요.

---

## 13-보충. FAQ — 협업 도구 일곱 질문

**Q1. git checkout이랑 switch·restore는 뭐가 달라요?** 옛날 `checkout`이 너무 많은 일(브랜치 이동 + 파일 되돌리기)을 해서 헷갈렸어요. 그래서 git 2.23에서 둘로 나눴어요 — `switch`(브랜치 이동)와 `restore`(파일 되돌리기). 의미가 또렷해졌죠. checkout도 여전히 되지만, 새 코드는 switch·restore를 권장해요. 이름이 일을 정확히 말해 주거든요.

**Q2. git pull과 git fetch는 뭐가 달라요?** `fetch`는 원격의 변경을 받기만 해요(working tree는 그대로). `pull`은 fetch + merge(또는 rebase)를 한 번에 — 받아서 내 브랜치에 합쳐요. 그래서 fetch는 100% 안전(read-only)하고, pull은 합치는 과정에서 충돌이 날 수 있어요. "먼저 fetch로 보고, 안전하면 pull"이 신중한 방식이에요. 자경단은 `pull --rebase`를 매일 아침 써요.

**Q3. gh pr merge의 --squash·--merge·--rebase 중 뭘 써요?** 자경단 표준은 `--squash`(PR의 여러 commit을 하나로 합쳐 main에)예요 — main history가 "한 PR = 한 commit"으로 깨끗해져요(H2 회수). `--merge`는 모든 commit + merge commit을 남기고, `--rebase`는 commit을 일렬로 붙여요. 회사마다 다르니 첫날 확인하세요. `--delete-branch`를 같이 주면 머지 후 브랜치도 자동 삭제돼요.

**Q4. rebase 중에 충돌이 나면 어떡해요?** 당황하지 마세요. git이 멈추고 충돌 파일을 알려줘요. 손으로 고치고 `git add`, 그다음 `git rebase --continue`. 도저히 안 되면 `git rebase --abort`로 rebase 전으로 완전히 돌아가요(안전망). rebase는 한 commit씩 다시 적용하는 거라, 충돌도 commit 단위로 하나씩 풀어요. 작은 PR이면 충돌도 작아요.

**Q5. rerere가 뭐예요?** "reuse recorded resolution" — 본인이 한 번 푼 충돌 해결을 git이 기억했다가, 같은 충돌이 또 나면 자동으로 적용해 줘요. `git config --global rerere.enabled true`로 켜요. 긴 브랜치를 여러 번 rebase할 때 같은 충돌을 반복해 풀지 않아도 돼서 시간을 아껴요. 자주 안 쓰지만 켜 두면 조용히 본인을 도와요.

**Q6. CI가 빨간불이면 머지를 못 하나요?** branch protection의 "require status checks"를 켰으면 못 해요(H3 회수) — 그게 핵심이에요. `gh pr checks 42`로 어떤 검사가 실패했는지 보고, `gh run view`로 로그를 봐서 고쳐요. CI 빨간불은 "아직 머지하면 안 된다"는 신호지 사고가 아니에요. 빨간불을 무시하고 머지하는 게 진짜 사고예요.

**Q7. 30개를 어떤 순서로 익혀야 효율적이에요?** 매일 6개(일상)를 1~2주에 손에 붙이고, 그다음 PR 흐름 5개, 그다음 리뷰 5개. conflict·정리·CI 도구는 실제로 그 상황을 만났을 때 하나씩 익혀요. "필요할 때 그 도구"가 가장 잘 기억에 남아요 — 충돌이 났을 때 배운 rebase는 안 잊거든요. 외워서 쌓는 게 아니라 써서 쌓는 거예요.

**Q8. PR 본문은 뭘 써야 해요?** 네 줄이면 충분해요 — 무엇을(이 PR이 하는 일), 왜(이 변경이 필요한 이유), 어떻게 테스트했나, 관련 이슈 번호. PR 템플릿(H3)을 만들어 두면 이 네 칸이 자동으로 떠요. 좋은 본문 하나가 리뷰 시간을 절반으로 줄여요 — 리뷰어가 코드를 보기 전에 맥락을 잡으니까요. "수정함" 한 줄짜리 PR은 리뷰어에게 "알아서 파악해"라는 뜻이에요.

**Q9. 내 PR에 'request changes'가 오면 기분 나빠해야 하나요?** 절대요. request changes는 본인 인격이 아니라 코드에 대한 거예요(H1, 코드 ≠ 본인). 5년 차의 PR도 매번 코멘트를 받아요. 오히려 꼼꼼한 리뷰는 본인을 위한 선물이에요 — 버그를 미리 잡아 주고, 더 나은 방법을 알려 주거든요. 코멘트를 학습 기회로 받는 사람이 6개월 후 가장 빨리 성장해요. 리뷰는 시비가 아니라 협력이에요.

**Q10. git·gh 말고 GUI 도구(SourceTree·GitHub Desktop)를 써도 돼요?** 돼요. GUI는 충돌 해결·history 보기엔 오히려 편해요. 다만 CLI를 익혀 두면 스크립트·자동화·서버 작업으로 이어지고, 어느 환경(SSH로 접속한 서버엔 GUI가 없어요)에서도 통해요. 그래서 "GUI로 편하게, CLI로 강하게" 둘 다 익히는 게 좋아요. 자경단은 충돌은 mergetool(GUI), 일상은 CLI로 섞어 써요. 도구는 하나만 고집할 필요 없어요 — 상황에 맞는 걸 쓰세요.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 명령어 학습 편

협업 명령어 만나며 자주 빠지는 함정 다섯.

첫 번째 함정, gh CLI 안 쓰고 웹만 쓰기. 안심하세요. **`gh pr create` 한 줄이 웹 클릭 다섯 번을 대신해요.** 웹은 보기 좋지만 느려요 — 매일 수십 번 하는 일은 한 줄 명령이 훨씬 빨라요. 손이 빠르면 일도 빨라요. 그리고 CLI는 스크립트로 자동화되니, 같은 일을 두 번째부턴 한 줄로 묶을 수 있어요.

두 번째 함정, `git pull`을 그냥 쓰기(rebase 없이). 안심하세요. **`git config --global pull.rebase true`로 기본을 rebase로.** 그냥 pull은 merge commit을 남겨 history가 지저분해져요. rebase pull은 내 작업을 동료 작업 위에 깔끔히 얹어요. 한 번 설정하면 평생 깔끔한 history예요.

세 번째 함정, `git stash`를 영구 보관용으로 쓰기. 안심하세요. **stash는 1일 임시 보관.** 며칠 둘 거면 branch + commit이에요(이름이 있으니 안 잃어버려요). stash가 쌓이면 `stash@{7}`이 뭐였는지 아무도 몰라요. 임시는 stash, 영구는 commit — 용도를 구별하세요.

네 번째 함정, 사설 저장소에서 HTTPS로 clone하기. 안심하세요. **사설 저장소는 SSH 우선.** HTTPS는 매번 토큰을 묻거나 캐시가 꼬여요. SSH 키(H3)를 한 번 등록하면 그 뒤론 인증을 안 물어요. `git remote set-url`로 HTTPS를 SSH로 바꿀 수 있어요.

다섯 번째 함정, 가장 큰 함정. **PR review에 "LGTM" 한 줄만.** 본인이 5분도 안 보고 approve. 안심하세요. **각 파일에 한 줄 코멘트라도 남기세요.** 5분 투자가 본인의 학습(남의 코드를 읽으며 배움)이자 팀의 안전(버그를 미리 잡음)이에요. LGTM만 찍는 리뷰는 안 한 거나 마찬가지예요. 리뷰는 "통과시키기"가 아니라 "함께 더 좋게 만들기"예요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H5에서 만나요

자, 네 번째 시간이 끝났어요.

30 도구 6무리. 일상·PR·리뷰·conflict·정리·CI. 매일 13줄.

오늘 한 줄 정리. **협업의 30 도구는 여섯 무리(일상·PR·리뷰·conflict·정리·CI)로 묶이고, 매일 쓰는 건 13줄 흐름의 한 줌이며, 빨강 다섯만 조심하면 된다.** 본인이 이 한 줄을 손에 쥐면, git/gh 명령이 무서운 30개가 아니라 친근한 여섯 무리가 돼요.

본인 페이스. 4/8 시간. 50%. 절반이에요! H1 큰그림, H2 개념, H3 환경, H4 도구. 이제 머리(개념)와 손(도구)을 다 갖췄어요. H5부터는 그걸 실전으로 — 다섯 명이 30분에 협업하는 시뮬레이션을 봐요. 개념과 도구가 진짜 합주가 되는 순간이에요. 박수.

다음 H5는 30분 시뮬. 자경단 다섯 명의 협업 30분.

```bash
gh pr list
git log --oneline --all --graph -10
```

이 두 줄을 치면 본인 저장소의 협업 상태가 한 화면에 떠요 — 열린 PR과 브랜치 그래프. H1에서 이 두 줄을 "졸업장"으로 쳤는데, 이제 그게 다섯 명의 일주일을 읽는 대시보드로 보여요. 같은 명령, 깊어진 눈. 오늘 30 도구를 손에 쥔 본인이, H5에서 다섯 명의 30분 합주를 봐요. 도구가 합주가 되는 순간이에요. 오늘 손에 쥔 30 도구가, 다음 시간 다섯 명의 손에서 하나의 음악이 돼요. 그 합주를 직접 보면, 흩어진 도구들이 왜 하나의 흐름인지 단번에 이해돼요. 도구는 외울 때가 아니라 쓰일 때 살아나거든요. 잘 따라오셨어요. 5분 쉬고 H5에서 만나요.

---

## 👨‍💻 개발자 노트

> - git switch (2.23+): checkout 분리.
> - git restore: checkout/reset 일부 대체.
> - rebase --autosquash: fixup commit 자동.
> - rerere: same conflict 학습.
> - gh CLI vs git CLI: gh는 GitHub 특화.
> - 다음 H5 키워드: 자경단 5명 · 30분 시뮬 · conflict · rebase · PR.

---

## 추신

1. 30 도구 6무리 — 일상·PR·리뷰·conflict·정리·CI.
2. 신호등 — 🟢read-only·🟡local·🔴되돌리기 어려움. 빨강 5개만 조심.
3. 매일 6개부터 — status·pull·switch·add·commit·push.
4. 다 외우지 마세요. 매일 6 + 필요할 때 검색.
5. git switch가 checkout보다 명확. 2.23+ 새 표준.
6. git restore가 "파일 되돌리기". checkout의 헷갈림을 풀어요.
7. git pull --rebase로 merge commit 없는 깔끔한 history.
8. git fetch는 read-only — 받기만 하고 working tree는 안 건드려요.
9. gh pr create --draft로 early feedback.
10. gh pr merge --squash --delete-branch — 머지+정리 한 줄.
11. gh CLI 한 줄이 웹 클릭 다섯 번. 손이 빠르면 일도 빨라요.
12. gh pr review 셋 — approve·request-changes·comment. 리뷰 3톤.
13. gh pr checks로 CI 초록불 확인 후 머지.
14. rebase가 자경단 표준 — history 일직선. 충돌은 작게 자주.
15. cherry-pick으로 특정 commit만 골라 옮겨요.
16. rerere로 같은 충돌을 두 번 안 풀어요(자동 학습).
17. mergetool은 GUI. 텍스트 마커가 무서우면 VS Code로.
18. commit --amend로 마지막 commit 수정(push 전만).
19. rebase -i로 commit 정리 — squash·reword·drop.
20. reset --soft HEAD~1 — 마지막 commit만 취소, 변경은 유지.
21. stash는 임시 1일. 길어지면 branch + commit.
22. force-push는 본인 브랜치에 --force-with-lease만.
23. gh run watch로 CI를 실시간 모니터.
24. gh secret set으로 비밀을 코드 밖에.
25. 매일 13줄 흐름 — 아침 동기화 → 작업 → PR → 머지 → 정리.
26. 손가락 리듬 — 매일 6·주간 8·월간 7. 한 달이면 다 손에.
27. PR review LGTM 한 줄 금지. 5분 투자가 학습 + 안전.
28. 면접 — "rebase vs merge?", "force-push 언제?", "stash는?".
29. 30 도구는 외움이 아니라 매일 써서 손에 박는 것.
30. git은 로컬(내 노트북), gh는 GitHub과의 대화. 비행기에선 git만 돼요.
31. 빨강도 reflog로 복구돼요. 진짜 못 되돌리는 건 commit 안 한 변경뿐.
32. git add -p로 한 commit 한 의도. 무엇을 묶을지 본인이 골라요.
33. PR 본문 네 줄(무엇·왜·테스트·이슈)이 리뷰 시간을 절반으로.
34. request changes는 인격이 아니라 코드. 학습 기회로 받으세요.
35. 도구를 손에 익히면 생각 없이 손이 가요 — 운전처럼.
36. 깨끗한 history는 미래의 나와 동료에게 주는 선물. 정리 5분이 디버깅 5시간을.
37. 리뷰는 시간 쓰는 게 아니라 팀 속도를 만드는 일. 자기 코드만큼 챙겨요.
38. GUI로 편하게, CLI로 강하게. 도구는 하나만 고집할 필요 없어요.
39. 30개는 Ch004 23개 위에 gh 얹기. 본인은 이미 절반 이상 알아요.
40. 다음 H5는 자경단 5명 30분 협업 시뮬. 30 도구를 손에 쥔 본인이 이제 그 손으로 다섯 명의 음악을 들을 차례예요. 5분 쉬고 H5에서 만나요. 🐾
