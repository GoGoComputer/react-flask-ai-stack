# Ch005 · H5 — 자경단 30분 협업 시뮬레이션 — PR·rebase·conflict·force-with-lease

> 고양이 자경단 · Ch 005 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 시나리오 — 자경단의 한 화요일
3. 0~5분 — 다같이 main 받기
4. 5~10분 — 까미와 노랭이 각자 branch
5. 10~15분 — 노랭이 PR 머지
6. 15~20분 — 까미 rebase + CONFLICT
7. 20~25분 — 페어로 conflict 해결
8. 25~30분 — force-with-lease로 안전 push
9. 30분 한 페이지 압축
10. 다섯 사고와 처방
11. 흔한 오해 다섯 가지
12. 마무리 — 다음 H6에서 만나요

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H4 회수. 30 도구 6무리. 매일 13줄.

이번 H5는 30분 시뮬레이션. 자경단 다섯 명이 한 저장소에서 동시에 일하는 30분.

오늘의 약속. **본인이 PR + rebase + conflict + force-with-lease 한 사이클을 손에 익힙니다**.

자, 가요.

---

## 2. 시나리오 — 자경단의 한 화요일

날짜. 2026년 5월 5일 화요일 오후 2시. 자경단 다섯 명이 각자 자리에서 일을 시작.

상황. main에 어제 까미가 머지한 commit이 5건. 노랭이가 짧은 PR 하나, 까미가 큰 PR 하나 만들기로.

30분 후 — 두 PR 다 머지. 한 conflict 해결. 모두 main 최신.

---

## 3. 0~5분 — 다같이 main 받기

다섯 명이 동시에 같은 명령.

```bash
cd ~/cat-vigilante
git switch main
git pull --rebase
```

세 명령. 다섯 명 다 main 최신. 첫 5분 동기화.

진짜 출력.

```
$ git pull --rebase
remote: Enumerating objects: 23, done.
Receiving objects: 100% (23/23), 4.2 KiB | 1.4 MiB/s, done.
First, rewinding head to replay your work on top of it...
Fast-forwarded main to abc123.
```

---

## 4. 5~10분 — 까미와 노랭이 각자 branch

까미는 큰 작업. 노랭이는 짧은 작업.

```bash
# 까미 (백엔드)
git switch -c feature/api-cat-list

# 노랭이 (프론트)
git switch -c fix/header-padding
```

각자 다른 branch. 충돌 가능성 0.

10분간 코드 짜기. 까미 5 commit, 노랭이 1 commit.

```bash
# 까미
git add backend/api/cats.py
git commit -m "feat(api): GET /cats endpoint"
# ... 4번 더

# 노랭이
git add frontend/Header.css
git commit -m "fix(ui): header padding 16px"
```

---

## 5. 10~15분 — 노랭이 PR 머지

노랭이가 먼저 끝.

```bash
# 노랭이
git push -u origin fix/header-padding

gh pr create --title "fix(ui): header padding" --body "..."
# PR #100 생성

# 본인이 리뷰
gh pr review 100 --approve

# 노랭이가 머지
gh pr merge 100 --squash --delete-branch
```

5분 사이클. main에 노랭이 commit이 추가됨. 까미는 아직 모름.

---

## 6. 15~20분 — 까미 rebase + CONFLICT

까미가 작업 끝나서 push 시도.

```bash
# 까미
git push origin feature/api-cat-list
# ! [rejected] feature/api-cat-list (non-fast-forward)
```

reject. main이 노랭이 commit 때문에 앞으로 갔어요. 까미가 rebase 시도.

```bash
git fetch origin main
git rebase origin/main

# CONFLICT (content): Merge conflict in package.json
```

`package.json`에서 충돌. 진짜 출력.

```
Auto-merging package.json
CONFLICT (content): Merge conflict in package.json
error: could not apply abc123... feat(api): cat list

When you have resolved this problem, run "git rebase --continue".
```

까미가 한 시간 작업이 conflict로 멈춤. 1대1 본인에게 도움 요청.

---

## 7. 20~25분 — 페어로 conflict 해결

까미와 본인이 페어 작업.

```bash
# 충돌 보기
git status
# both modified: package.json

cat package.json
```

```json
<<<<<<< HEAD
  "version": "1.2.0",
=======
  "version": "1.1.5",
>>>>>>> abc123 feat(api): cat list
```

본인 — "1.2.0이 맞아요. 새 버전이니까."

```bash
# 직접 수정
# package.json에서 1.2.0만 남기기

# 충돌 해결 표시
git add package.json

# rebase 계속
git rebase --continue

# 다음 commit도 같은 충돌이면
git rebase --skip
```

5분에 해결. main 최신 상태로 따라잡음.

---

## 8. 25~30분 — force-with-lease로 안전 push

rebase 후 push 시도.

```bash
# 위험한 force push (절대 안 씀)
# git push --force

# 안전한 force-with-lease
git push --force-with-lease origin feature/api-cat-list
```

`--force-with-lease`는 본인이 마지막 fetch 후 다른 사람이 push 안 했을 때만 force. 다섯 명 동료의 작업 보호.

```bash
# PR 만들기
gh pr create --title "feat(api): cat list" --body "..."
# PR #101

# 본인 리뷰
gh pr review 101 --approve

# 까미 머지
gh pr merge 101 --squash --delete-branch
```

30분 끝. 두 PR 다 머지. 자경단 main 최신. 동료 작업 손실 0.

---

## 9. 30분 한 페이지 압축

```
14:00  다같이 main 받기 (3 명령) — 5분
14:05  까미·노랭이 각자 branch (2 명령) — 5분
14:10  노랭이 PR + 머지 (4 명령) — 5분
14:15  까미 rebase → CONFLICT — 5분
14:20  페어로 충돌 해결 — 5분
14:25  force-with-lease + PR + 머지 — 5분
14:30  완료 ✅ — 두 PR 머지, conflict 해결, 손실 0
```

30분에 30 명령어 중 약 20개 사용. 자경단 한 사이클.

---

## 10. 다섯 사고와 처방

**사고 1: force-push로 동료 작업 날림**

처방. 항상 `--force-with-lease`.

**사고 2: rebase 중 잘못된 충돌 해결**

처방. `git rebase --abort`로 처음부터.

**사고 3: PR 만들기 전 너무 많은 commit**

처방. `git rebase -i`로 정리.

**사고 4: 머지 후 local branch 안 지움**

처방. `--delete-branch` 옵션 + `git fetch --prune`.

**사고 5: CI fail 후 머지**

처방. branch protection의 status check.

---

## 11. 흔한 오해 다섯 가지

**오해 1: rebase 위험.**

`--force-with-lease`로 안전.

**오해 2: 충돌은 사고.**

자연스러운 협업 신호.

**오해 3: 다섯 명이 너무 많다.**

오히려 적은 편.

**오해 4: PR 항상 작게.**

너무 작으면 비효율. 평균 200줄.

**오해 5: gh CLI 옵션.**

자경단 표준.

---

## 12. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 데모 학습 편

협업 데모 따라하며 자주 빠지는 함정 다섯.

첫 번째 함정, 시뮬레이션이 본인 노트북 한 대로. 본인이 다섯 명 시뮬을 한 명만. 안심하세요. **다섯 폴더에 다섯 clone.** 진짜 다섯 명처럼 동작.

두 번째 함정, conflict 시 한쪽만 살림. 안심하세요. **양쪽 의도 다 살리기.** 코드 디자인 결정.

세 번째 함정, PR description 비어 있음. 안심하세요. **3줄 최소.** What·Why·How.

네 번째 함정, review 코멘트에 즉시 방어. 안심하세요. **24시간 두고 다시 보기.** 그 사이 본인이 코멘트의 의도 더 잘 이해.

다섯 번째 함정, 가장 큰 함정. **머지 후 branch 안 지움.** 본인 GitHub에 dead branch 100개. 안심하세요. **머지 즉시 delete branch.** 자동 설정 가능.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 13. 마무리 — 다음 H6에서 만나요

자, 다섯 번째 시간이 끝났어요.

자경단 30분 시뮬. 두 PR 머지, 한 conflict 해결, force-with-lease로 안전. 다섯 사고 처방.

박수.

다음 H6은 운영. 1년 자동화, 통계, 진화.

```bash
gh pr list --state merged --limit 10
git log --oneline --all --graph -20
```

---

## 👨‍💻 개발자 노트

> - rebase vs merge: rebase는 깔끔, merge는 보존.
> - --force-with-lease vs --force: lease가 안전.
> - rerere: 같은 충돌 자동 해결.
> - PR 사이즈 vs 머지 시간: 100~300줄 최적.
> - branch 머지 후 자동 삭제: GitHub 설정.
> - 다음 H6 키워드: 자동화 · release · CHANGELOG · stale PR · 진화.
