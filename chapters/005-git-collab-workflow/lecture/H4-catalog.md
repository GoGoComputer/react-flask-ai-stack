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
10. 매일·주간·월간 손가락 리듬
11. 자경단 매일 13줄 흐름
12. 다섯 함정과 처방
13. 흔한 오해 다섯 가지
14. 마무리 — 다음 H5에서 만나요

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H3 회수. 8단추 셋업. Organization, Team, Protection, CODEOWNERS, husky.

이번 H4는 협업의 30 도구. 본인의 매일 PR 사이클의 손가락.

오늘의 약속. **본인이 매일 만나는 30 협업 도구를 6무리로 손에 박습니다**.

자, 가요.

---

## 2. 위험도 신호등

**🟢 초록**. read-only. git status, git log, gh pr view. 사고 0.

**🟡 노랑**. local 변경. git add, git commit, git push. 보통 안전.

**🔴 빨강**. 되돌리기 어려움. force-push, branch -D, rebase. 1초 호흡.

30개 중 빨강은 5개뿐. 25개는 마음 편히.

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

---

## 10. 매일·주간·월간 손가락 리듬

**매일 6**. status, pull, switch, add, commit, push.

**주간 8**. pr create/list/view, rebase, push --force-with-lease, stash, restore, log graph.

**월간 7**. rebase -i, cherry-pick, reset, reflog, gh run, gh secret, mergetool.

매일 6개부터.

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

---

## 12. 다섯 함정과 처방

**함정 1: force-push 사고**

처방. `--force-with-lease`만.

**함정 2: rebase 충돌 폭발**

처방. 자주 rebase. 작은 commit.

**함정 3: PR 너무 큼**

처방. 200줄 평균, 500줄 최대.

**함정 4: 머지 후 branch 안 지움**

처방. `--delete-branch` 옵션.

**함정 5: CI fail 무시**

처방. 머지 전 항상 통과.

---

## 13. 흔한 오해 다섯 가지

**오해 1: 30 다 외움.**

매일 6개부터.

**오해 2: rebase는 위험.**

작게 자주.

**오해 3: gh CLI는 옵션.**

자경단 매일.

**오해 4: PR diff GUI만.**

`gh pr diff`로 CLI.

**오해 5: stash 자주.**

가끔. branch 만드는 게 안전.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 명령어 학습 편

협업 명령어 만나며 자주 빠지는 함정 다섯.

첫 번째 함정, gh CLI 안 쓰고 웹만. 안심하세요. **gh pr create 한 줄이 웹 클릭 5번 대신.** 손이 빠르면 일도 빨라요.

두 번째 함정, git pull --rebase 없이 쓴다. 안심하세요. **`git config --global pull.rebase true`.** merge commit 없는 깔끔한 history.

세 번째 함정, git stash를 영구 보관용으로. 안심하세요. **stash는 임시 보관 1일.** 길어지면 commit + branch 만들기.

네 번째 함정, gh repo clone 사설 레포에서 SSH 안 씀. 안심하세요. **사설 레포는 SSH 우선.** HTTPS는 매번 인증 토큰.

다섯 번째 함정, 가장 큰 함정. **PR review에 LGTM만 한 줄.** 본인이 5분도 안 보고 approve. 안심하세요. **각 파일에 한 줄 코멘트라도.** 5분 투자가 본인 학습 + 팀 안전.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H5에서 만나요

자, 네 번째 시간이 끝났어요.

30 도구 6무리. 일상·PR·리뷰·conflict·정리·CI. 매일 13줄.

박수.

다음 H5는 30분 시뮬. 자경단 다섯 명의 협업 30분.

```bash
gh pr list
git log --oneline --all --graph -10
```

---

## 👨‍💻 개발자 노트

> - git switch (2.23+): checkout 분리.
> - git restore: checkout/reset 일부 대체.
> - rebase --autosquash: fixup commit 자동.
> - rerere: same conflict 학습.
> - gh CLI vs git CLI: gh는 GitHub 특화.
> - 다음 H5 키워드: 자경단 5명 · 30분 시뮬 · conflict · rebase · PR.
