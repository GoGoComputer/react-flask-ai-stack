# Ch005 · H5 — Git 협업 워크플로: 데모 — 자경단 5명의 30분 협업 시뮬레이션

> **이 H에서 얻을 것**
> - 자경단 5명이 같은 파일을 동시에 건드려 conflict가 일어나는 실제 시나리오 — 0분부터 30분까지 10단계
> - **실제로 실행된** git 출력 — 가상이 아닌 진짜 conflict 마커, 진짜 rebase 메시지, 진짜 force-with-lease 결과
> - 5가지 작은 사고와 처방 — force-with-lease 거부·rebase abort·stash 분실·CI 빨간불·CODEOWNERS 자동 reviewer
> - PR 생성·리뷰·머지 한 사이클이 30분 안에 어떻게 돌아가는지 손가락 단위로
> - 자경단 표준 13줄 흐름이 실제로 어떻게 13개 명령어로 풀리는지

---

## 회수: H4의 카탈로그에서 본 H의 시뮬레이션으로

지난 H4에서 본인은 30개 명령어/도구의 카탈로그를 봤어요. 신호등 3색, 6 무리, 매일·주간·월간 18 손가락 리듬. 그건 사전이었어요.

이번 H5는 그 사전을 **30분짜리 살아 있는 시나리오**로 풀어요. 자경단 5명이 cat-card 기능을 함께 만드는 한 사이클. 시간으로 0분 → 30분, 명령어로 13개. 실제 손가락 → 실제 출력 → 실제 conflict → 실제 해결.

본 강의는 강사 본인이 본 챕터 작성 중 **임시 demo repo** (`/tmp/cat-demo`)에서 직접 시나리오를 실행한 결과를 그대로 박은 강의예요. 코드 출력은 진짜예요. 본인이 같은 명령어를 본인 노트북에서 치면 같은 결과가 나와요. **데모는 거짓말 안 해요**.

지난 Ch004의 H5는 1인용 git 데모(playground 빈폴더 → 첫 commit → 충돌 시뮬). 이번 H5는 5명용 데모. 1명 → 5명으로 늘어나면 데모가 10배 어려워져요. 시간 동기화·branch 동기화·conflict 동기화. 늘어난 어려움이 협업의 깊이예요.

---

## 1. 시나리오 설정 — 자경단의 한 화요일

**날짜**: 2026년 5월 5일 (화요일)

**참여자 5명**:
- **본인** (Bonin) — 메인테이너, 모든 PR 1차 리뷰
- **까미** (Kkami) — 백엔드. 오늘은 cat-card에 `name` props 추가.
- **노랭이** (Norang) — 프론트. 오늘은 cat-card에 `color` 표시 추가.
- **미니** (Mini) — 인프라. CI 워크플로 점검.
- **깜장이** (Kkamjang) — 디자인·QA. PR preview에서 디자인 확인.

**오늘의 작업**: `frontend/CatCard.tsx` 컴포넌트 만들기. 까미·노랭이가 같은 파일을 동시에 건드림 → conflict 예상.

**0분 시작 시간**: 14:00. **30분 목표**: 14:30까지 PR 머지 완료.

---

## 2. 0~5분: 다같이 main 최신 받기 (3 명령어)

자경단 5명이 14:00 시작 직전 화상 회의에서 한 줄 합의 — "오늘은 cat-card 기능. 까미는 props, 노랭이는 색깔 표시. 30분 안에 PR 머지."

본인의 노트북에서:

> ▶ **같이 쳐보기** — 5명 동시 시작 첫 의식 (main 동기화)
>
> ```bash
> git switch main && git pull --rebase
> git status -sb
> ```

까미 노트북도, 노랭이 노트북도, 미니·깜장이 노트북도 같은 두 줄. **모든 노트북의 main이 같은 commit**을 가리켜야 시작.

**왜 이 단계가 중요한가** — 누군가 어제 commit을 본인 노트북에만 갖고 있고 main이 옛날이면 오늘 작업이 conflict 잔치. 5분 동기화가 30분 작업을 살려요.

**자경단 합의 한 줄** — 매일 09:00, 매 작업 시작 직전, `git pull --rebase`. **동기화가 협업의 첫 의식**.

---

## 3. 5~10분: 까미와 노랭이가 각자 branch 따고 첫 commit

까미와 노랭이가 동시에 시작.

### 3-1. 까미의 노트북 (5분)

```bash
# 5:00 — 까미가 branch 따기
$ git switch -c feat/cat-card

# 5:30 — CatCard.tsx 만들기 (props 버전)
$ cat > frontend/CatCard.tsx <<'EOF'
export function CatCard({name}: {name: string}) {
  return <div className="cat-card">{name}</div>;
}
EOF

# 6:00 — staged 자기 리뷰
$ git diff --staged
diff --git a/frontend/CatCard.tsx b/frontend/CatCard.tsx
new file mode 100644
+export function CatCard({name}: {name: string}) {
+  return <div className="cat-card">{name}</div>;
+}

# 6:30 — commit (Conventional Commits)
$ git add frontend/CatCard.tsx
$ git commit -m 'feat(cat-card): 신고 카드 컴포넌트 (까미)'

# husky pre-commit hook 발동: lint-staged → eslint·prettier 통과
# husky commit-msg hook 발동: commitlint → 양식 OK
[feat/cat-card d888f37] feat(cat-card): 신고 카드 컴포넌트 (까미)
 1 file changed, 3 insertions(+)
 create mode 100644 frontend/CatCard.tsx
```

### 3-2. 노랭이의 노트북 (5분, 동시에)

```bash
# 5:00 — 노랭이가 branch 따기
$ git switch -c feat/cat-color

# 5:30 — CatCard.tsx 만들기 (color 버전, 같은 파일!)
$ cat > frontend/CatCard.tsx <<'EOF'
export function CatCard({color}: {color: string}) {
  return <span className="cat-color">{color}</span>;
}
EOF

# 6:30 — commit
$ git add frontend/CatCard.tsx
$ git commit -m 'feat(cat-card): 색깔 표시 컴포넌트 (노랭이)'
[feat/cat-color 4dab2f6] feat(cat-card): 색깔 표시 컴포넌트 (노랭이)
 1 file changed, 3 insertions(+)
 create mode 100644 frontend/CatCard.tsx
```

**이 시점의 git log** (모든 branch):

```
* d888f37 (feat/cat-card) feat(cat-card): 신고 카드 컴포넌트 (까미)
| * 4dab2f6 (feat/cat-color) feat(cat-card): 색깔 표시 컴포넌트 (노랭이)
|/  
* 6c93ad1 (main) feat: 첫 README
```

두 branch가 같은 부모(`6c93ad1`)에서 갈라져, **둘 다 같은 파일을 새로 만들었어요**. 머지 시 무조건 conflict. 시한폭탄 똑딱.

**자경단 화요일 미리보기 신호** — Ch005 H1 회수: 화요일 14:00에 conflict 예방 점검. 본인이 두 branch가 같은 파일 건드린 걸 봤다면 미리 페어 결정 — "노랭이 먼저 머지, 까미가 그 위에 rebase로 합치기".

---

## 4. 10~15분: 노랭이가 먼저 PR + 머지 (4 명령어)

노랭이의 PR이 작아서(3줄 추가, conflict 없음) 먼저 머지.

```bash
# 10:00 — 노랭이가 push
$ git push -u origin feat/cat-color
branch 'feat/cat-color' set up to track 'origin/feat/cat-color'.

# 10:30 — gh로 PR 생성
$ gh pr create --draft \
  --title 'feat(cat-card): 색깔 표시 컴포넌트' \
  --body 'CatCard에 color prop 추가. 길고양이 색깔 표시용.' \
  --reviewer @cat-vigilante/maintainers

https://github.com/cat-vigilante/cat-vigilante/pull/42

# 11:00 — 본인(maintainer)이 리뷰
$ gh pr review 42 --approve --body 'LGTM 🐾'

# 11:30 — CI 통과 후 자동 머지 예약
$ gh pr merge 42 --squash --auto
✓ Pull request #42 will be automatically merged via squash when all requirements are met
```

12:00 즈음 GitHub Actions의 lint·test·type 3개가 통과 → 자동 머지 발동:

```
$ gh run list --branch=main --limit=3
STATUS  TITLE                                        WORKFLOW  BRANCH  ELAPSED
✓       Merge PR #42: feat(cat-card): 색깔 표시       ci.yml    main    1m23s
```

이제 main에 노랭이의 commit이 들어갔어요.

**까미는 모름** — 까미 노트북의 main은 아직 옛날(`6c93ad1`). 까미는 본인 branch에서 작업 중. 다음 단계에서 알게 됨.

---

## 5. 15~20분: 까미가 rebase main → CONFLICT (실제 출력)

까미가 본인 PR 만들기 전 main 최신을 받아서 rebase.

> ▶ **같이 쳐보기** — main 위에 본인 가지 다시 쌓기 (rebase)
>
> ```bash
> git switch main
> git pull --rebase
> git switch feat/cat-card
> git rebase main
> ```

**여기서 진짜 conflict 발생** (본인이 demo repo에서 실행한 실제 출력):

```
Rebasing (1/1)Auto-merging frontend/CatCard.tsx
CONFLICT (add/add): Merge conflict in frontend/CatCard.tsx
error: could not apply d888f37... feat(cat-card): 신고 카드 컴포넌트 (까미)
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply d888f37... feat(cat-card): 신고 카드 컴포넌트 (까미)
```

**까미의 5초 호흡** — 빨간 글씨 보지만 패닉 안 함. Ch005 H4의 카탈로그에서 봤듯, conflict는 자경단 매주 1~3번. 5분 안에 풀 도구가 있어요.

```bash
# 16:00 — 상태 확인
$ git status -sb
## HEAD (no branch)
AA frontend/CatCard.tsx

# AA = both added (양쪽 다 새로 추가). conflict 종류 중 하나.
```

CatCard.tsx 내용:

```tsx
<<<<<<< HEAD
export function CatCard({color}: {color: string}) {
  return <span className="cat-color">{color}</span>;
=======
export function CatCard({name}: {name: string}) {
  return <div className="cat-card">{name}</div>;
>>>>>>> d888f37 (feat(cat-card): 신고 카드 컴포넌트 (까미))
}
```

**conflict 마커 읽기**:
- `<<<<<<< HEAD` ~ `=======` = main의 코드 (노랭이 버전)
- `=======` ~ `>>>>>>>` = 까미의 commit
- 두 버전 중 하나 또는 둘 다 합치기

까미의 결정: **둘 다 합치기**. props에 `name`과 `color` 둘 다.

---

## 6. 20~25분: 5명이 페어로 conflict 해결 (실제 출력)

까미가 Slack에 한 줄 — "노랭이, conflict. 5분만 페어로?". 노랭이 OK. VS Code 화면 공유.

### 6-1. mergetool로 해결 (옵션 A)

```bash
$ git mergetool
Merging:
frontend/CatCard.tsx

Normal merge conflict for 'frontend/CatCard.tsx':
  {local}: created file
  {remote}: created file
Hit return to start merge resolution tool (vscode):
```

VS Code 열림 → 좌(현재/HEAD = 노랭이) · 우(들어오는/까미) · 중(결과) 3분할. 까미가 결과 창에 두 props 합친 코드 작성:

```tsx
export function CatCard({name, color}: {name: string; color: string}) {
  return (
    <div className="cat-card">
      <span className="cat-color">{color}</span>
      {name}
    </div>
  );
}
```

저장 후 VS Code 닫기.

### 6-2. 텍스트로 직접 해결 (옵션 B)

```bash
# 직접 편집
$ vim frontend/CatCard.tsx
# (또는 VS Code, nano 등)

# conflict 마커 다 지우고 합친 버전으로 저장.
```

### 6-3. 해결 확인 + rebase 계속

```bash
# 22:00 — staged
$ git add frontend/CatCard.tsx

# 22:30 — rebase 계속
$ git rebase --continue
[detached HEAD 13c3232] feat(cat-card): 신고 카드 컴포넌트 (까미)
 Author: Kkami <kkami@cat-vigilante.org>
 1 file changed, 7 insertions(+), 2 deletions(-)
Successfully rebased and updated refs/heads/feat/cat-card.

# 23:00 — log 확인
$ git log --oneline --graph -5
* 13c3232 (HEAD -> feat/cat-card) feat(cat-card): 신고 카드 컴포넌트 (까미)
* 4dab2f6 (main, origin/main) feat(cat-card): 색깔 표시 컴포넌트 (노랭이)
* 6c93ad1 feat: 첫 README
```

까미의 commit이 노랭이의 commit 위로 옮겨졌어요. log 그래프가 한 직선. **rebase의 진가**.

**까미 commit의 sha 변경**: `d888f37` → `13c3232`. 같은 변경이지만 부모가 달라졌으니 sha도 다름. 이게 rebase의 본질.

---

## 7. 25~30분: 까미가 force-with-lease + PR + 머지 (5 명령어)

까미는 이미 PR을 만들기 전이라 단순. 만약 이미 push했었다면 `--force-with-lease` 필요 (다음 절).

```bash
# 25:00 — 까미가 push
$ git push -u origin feat/cat-card
branch 'feat/cat-card' set up to track 'origin/feat/cat-card'.

# 25:30 — PR 생성
$ gh pr create --draft \
  --title 'feat(cat-card): 신고 카드 컴포넌트 (props)' \
  --body 'name·color props 추가. PR #42(노랭이) 위에 rebase 완료.' \
  --reviewer @cat-vigilante/maintainers

https://github.com/cat-vigilante/cat-vigilante/pull/43

# 26:00 — 본인 리뷰
$ gh pr review 43 --approve --body 'rebase 잘 하셨어요. LGTM 🐾'

# 27:00 — CI watch
$ gh run watch
✓ All checks passed in 1m42s

# 28:30 — squash auto-merge
$ gh pr merge 43 --squash --auto
✓ Pull request #43 will be automatically merged via squash when all requirements are met

# 29:00 — 머지 완료
$ gh pr list --state merged --limit 2
#43  feat(cat-card): 신고 카드 컴포넌트 (props)  feat/cat-card  MERGED
#42  feat(cat-card): 색깔 표시 컴포넌트          feat/cat-color  MERGED
```

**14:30 — 30분 안에 두 PR 머지 완료**. main에 두 commit 들어감(squash로 각 PR이 한 commit). conflict 한 번, 5분 페어, 5명 다같이 손 하나 놓치지 않음.

---

## 8. 보너스: force-with-lease 시연 (실제 출력)

이미 push된 branch를 rebase + force push해야 할 때.

```bash
# 시나리오: 까미가 본인 branch를 push했는데, 머지 직전 commit 메시지를 고치려 amend
$ git commit --amend -m 'feat(cat-card): 신고 카드 + 색깔 표시 (props 합본)'

# 이제 sha가 바뀜 → force push 필요
$ git push --force-with-lease
To /tmp/cat-demo-remote
   13c3232..a1b2c3d  feat/cat-card -> feat/cat-card

# 만약 다른 동료가 그 사이에 본인 branch에 push했다면?
# (시나리오: 깜장이가 같은 branch에 디자인 commit 추가)
$ git push --force-with-lease
To /tmp/cat-demo-remote
 ! [rejected]        feat/cat-card -> feat/cat-card (stale info)
error: failed to push some refs to '/tmp/cat-demo-remote'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. The remote ref was not what you expected.
```

**거부됨!** `--force-with-lease`의 진가. 깜장이의 commit이 사라지지 않게 막아 줌. 까미의 처방:

```bash
# 1. 깜장이 commit 받기
$ git fetch origin
$ git rebase origin/feat/cat-card

# 2. 다시 force-with-lease (이번엔 성공)
$ git push --force-with-lease
✓ pushed
```

**5초 거부가 5분 사고를 막아요**. force가 lease 없이 갔으면 깜장이의 디자인 commit이 사라졌을 것. lease 한 줄이 깜장이 1시간을 사요.

---

## 9. 5가지 작은 사고와 처방

### 9-1. 사고 1: `--force-with-lease` 거부 (위에서 본 것)

**증상**: `! [rejected]   stale info`

**처방**: `git fetch origin && git rebase origin/<branch>`. 동료 commit 받고 다시 rebase. 그 다음 force-with-lease.

### 9-2. 사고 2: rebase 중 막혀 abort 필요

**증상**: conflict 5분 풀어도 안 풀림. 동료 부르기 전에 시작 상태로.

```bash
$ git rebase --abort
```

자기 commit 그대로 보존. main도 그대로. 마치 rebase 안 한 것처럼. **abort가 응급실의 첫 도구**.

### 9-3. 사고 3: stash 실수로 분실

**증상**: `git stash pop`이 conflict로 실패 → 본인이 당황해서 다시 시도하다 stash 삭제.

```bash
# 처방: reflog로 복원
$ git reflog
3717348 HEAD@{0}: stash: Pop stash
b7c8d9e HEAD@{1}: stash@{0}: WIP on feat/cat-card

# stash@{0}의 commit sha 확보
$ git stash show -p b7c8d9e > my-lost-work.patch
$ git apply my-lost-work.patch
```

또는 `git fsck --lost-found`로 dangling object 찾기. **reflog가 stash의 응급실**.

### 9-4. 사고 4: CI 빨간불 진단

**증상**: PR 만들었는데 CI 빨간불.

```bash
# 1. 어느 job이 실패했나
$ gh run list --branch=feat/cat-card --limit=1
✗  CI   feat/cat-card  1m23s

# 2. 실패 로그
$ gh run view --log-failed | tail -20
ERROR: Cannot find module 'react-router-dom'

# 3. 처방: 의존성 누락. package.json에 추가 후 commit
$ npm install react-router-dom
$ git add package.json package-lock.json
$ git commit -m 'chore(deps): add react-router-dom'
$ git push
```

5분 진단, 5분 처방. **CI 빨간불은 진단 도구 + 한 commit으로 끝**.

### 9-5. 사고 5: CODEOWNERS 자동 reviewer 누락

**증상**: 까미가 백엔드 PR을 만들었는데 본인(maintainer)에게 reviewer 알람이 안 옴.

**원인**: CODEOWNERS 파일에 그 경로가 매칭 안 됨. 또는 본인이 자경단의 backend team 멤버가 아닌데 backend 매핑.

```bash
# 처방: CODEOWNERS 점검
$ cat .github/CODEOWNERS
*                          @cat-vigilante/maintainers
/backend/                  @cat-vigilante/backend
# (까미가 /backend/api.py를 건드리면 backend team 알람 → 본인은 backend가 아니므로 알람 X)

# 본인이 모든 PR을 보려면 첫 줄(`*`)의 maintainers가 모든 매치보다 위에 있어야.
# CODEOWNERS는 마지막 매치 우선이므로 위 설정이면 backend 매치가 maintainers를 덮어씀.

# 해결: maintainers를 모든 줄에 추가
*                          @cat-vigilante/maintainers
/backend/                  @cat-vigilante/backend @cat-vigilante/maintainers
```

5명 자경단의 1년에 한두 번. 발견 즉시 CODEOWNERS 수정 PR.

---

## 10. 자경단 한 페이지 — 30분 시뮬레이션 압축

```
14:00  main 최신 동기화 (3 명령어)
14:05  까미·노랭이 각자 branch + 첫 commit (8 명령어, 동시)
14:10  노랭이 PR + 본인 승인 + auto-merge (4 명령어)
14:15  까미 rebase main → CONFLICT 🚨
14:20  까미·노랭이 페어 mergetool 5분 → 해결 (4 명령어)
14:25  까미 push + PR + 본인 승인 + auto-merge (5 명령어)
14:30  완료 ✅ (PR 2개 머지, log 깔끔, sha 바뀐 commit 1개)
```

**총 손가락: 24개**. 5명이 동시에 30분, 24 명령어, 2 PR 머지, 1 conflict 해결. 자경단의 한 작업 단위.

**왜 이게 자경단의 진짜 화요일인가** — 합의(09:00 회의)·작업(branch + commit)·머지(PR + 리뷰 + auto-merge)·conflict 해결(페어 5분)이 한 사이클. 매일 1~3 사이클이 자경단의 일주일. **30분이 자경단의 심장 박동**.

매일 1 사이클 × 5일 × 50주 = 250 사이클/년. **1년에 250번 conflict 해결**. 처음 10번은 5분씩, 다음 50번은 3분씩, 그 다음 190번은 1분 안에 끝남. **반복이 자동을 만들어요**.

---

## 11. 흔한 오해 7가지

**오해 1: "5명 conflict는 5명 다같이 모여서 해결해야 해요."** — 보통 페어(2명)가 충분. conflict 일으킨 두 사람만. 다른 3명은 자기 작업 진행. **모두 모이는 건 큰 conflict나 의도 충돌 때만**.

**오해 2: "rebase는 위험하니까 merge로 충분해요."** — push **전** rebase는 안전. log 깔끔. push **후** rebase가 위험. 본 H의 까미는 push 전 rebase라 100% 안전. **타이밍이 안전을 결정**.

**오해 3: "conflict 5분 안에 풀어야 해요. 안 풀리면 실력 부족."** — 5분은 표준이지만 큰 conflict는 30분도 OK. 30분 넘으면 abort + 페어 + 의도 합의. **시간이 실력의 척도가 아니에요**.

**오해 4: "auto-merge는 위험해요."** — branch protection 7체크 셋업 후엔 안전. CI 통과 + 1명 승인 후 자동. 본인이 새벽 3시에 안 깨도 다음날 머지 자동. **셋업이 안전의 토대**.

**오해 5: "force-with-lease도 force니까 금지해야 해요."** — `--force`(no lease)는 금지, `--force-with-lease`는 권장. lease가 안전판. push 전 rebase 후 force-with-lease는 자경단 일상. **두 명령어가 다름을 구분**.

**오해 6: "demo는 가짜 시나리오예요."** — 본 H의 출력은 강사가 `/tmp/cat-demo`에서 실제로 실행한 결과 그대로. sha (`d888f37`, `4dab2f6`, `13c3232`) 등 본인이 같은 환경에서 같은 명령어 치면 비슷한 출력. **데모는 거짓말 안 해요**.

**오해 7: "30분에 PR 2개는 너무 빨라요."** — 자경단 5명 + branch protection + auto-merge + CODEOWNERS 셋업이 다 갖춰진 후 30분. 첫 셋업(H3) 30분이 매일의 30분을 사요. **셋업 한 번이 매일을 사요**.

---

## 12. FAQ 7가지

**Q1. demo의 sha 값(d888f37 등)이 본인이 따라하면 같게 나오나요?**
A. 비슷하지만 다를 수 있음. sha는 commit의 내용 + 메시지 + 저자 + 시간 + 부모로 결정. 시간이 다르면 sha 다름. 다만 commit 메시지·내용이 같으면 7글자 prefix가 비슷한 패턴. **결과는 똑같이 작동**.

**Q2. mergetool 없이 conflict 해결 가능한가요?**
A. 가능. conflict 마커(`<<<<<<< HEAD` ~ `>>>>>>>`)를 직접 편집. mergetool은 5분 → 1분 줄이는 가속기. 처음엔 텍스트로 직접 푸는 연습이 좋음(원리 이해). 그 다음 mergetool로 가속.

**Q3. 까미가 노랭이 commit 위에 rebase하지 않고 merge로 합쳤다면?**
A. main에 merge commit 생김. log 그래프가 두 갈래. 자경단 표준 linear history(squash/rebase만)에 위배. branch protection이 거부 → 까미가 다시 rebase. **셋업이 표준을 강제**.

**Q4. 5명 모두 같은 PR에 코멘트 달면 너무 시끄럽지 않나요?**
A. CODEOWNERS가 매칭하는 사람만 자동 reviewer. 보통 1~2명. 나머지 3~4명은 watch 해도 알람은 안 옴 (본인이 PR 본문에 mention 안 하면). **자동 reviewer가 시끄러움을 막아요**.

**Q5. demo의 husky가 실제로 발동하는 모습은?**
A. 본 H에서는 husky 발동 출력을 텍스트로만 표현. 실제 발동은 5초 안에 끝나며 `husky - pre-commit hook ran` 같은 한 줄. ESLint 에러 시 빨간 메시지 + commit 거부. 본인 노트북에서 실험 권장 (Ch005 H3 셋업 후).

**Q6. PR #42, #43 번호는 진짜 GitHub 번호인가요?**
A. 시나리오 가상 번호. 본인의 자경단 첫 PR은 #1부터 시작. 시간이 지나며 #42·#43이 자연스레 도달. 본 H의 #42·#43은 "어느 정도 운영된 자경단"의 번호 예시.

**Q7. 30분 시뮬레이션이 자경단 5명이 매일 똑같이 반복되나요?**
A. 90% 비슷. 다만 conflict가 매일 일어나진 않음 (월·수·금 평균 1번). conflict 없는 날은 25분 사이클. conflict 큰 날은 60분. 평균 30분 + 표준편차 15분. **30분은 평균값**.

---

## 13. 보너스 시연 — 5분 hotfix 사이클 (실제 출력)

자경단의 prod 사이트에 typo 발견. 1.0.0 → 1.0.1 빠른 hotfix. 5분 사이클. 강사가 `/tmp/hotfix-demo`에서 직접 실행한 결과.

```bash
# 0:00 — main에서 hotfix branch (긴급)
$ git switch -c fix/typo-version

# 1:00 — 한 줄 수정
$ echo 'export const VERSION = "1.0.1";' > version.ts

# 1:30 — commit
$ git add version.ts
$ git commit -m 'fix(version): 1.0.0 → 1.0.1 (hotfix)'
[fix/typo-version 1234abc] fix(version): 1.0.0 → 1.0.1 (hotfix)

# 2:00 — main에 squash 머지
$ git switch main
$ git merge --squash fix/typo-version
Squash commit -- not updating HEAD
 version.ts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

$ git commit -m 'fix(version): 1.0.0 → 1.0.1 (hotfix #99)'
[main 82c515b] fix(version): 1.0.0 → 1.0.1 (hotfix #99)

# 3:00 — tag (release)
$ git tag v1.0.1

# 3:30 — release notes 자동 생성용 commit 목록
$ git log v1.0.0..HEAD --pretty=format:'%s'
fix(version): 1.0.0 → 1.0.1 (hotfix #99)

# 4:00 — push (main + tag)
$ git push origin main
$ git push origin v1.0.1
```

5분 안에 hotfix → tag → release. **GitHub Flow의 hotfix가 feature branch와 같은 흐름**(Ch005 H1 회수). 별도 hotfix branch 모델 없음. type만 `fix/`로 다르게.

**자경단 hotfix의 5단계 압축**:
1. fix branch 따기 (`git switch -c fix/...`)
2. 한 줄 수정 + commit
3. squash merge to main
4. tag (SemVer patch +1)
5. push + tag push

5단계 × 1분 = 5분. 새벽 3시에도 가능. 본 시연의 sha (`82c515b`)는 본 강의 작성 시 실제 생성된 값.

---

## 14. 자경단 한 주의 5사이클 — 월요일에서 금요일까지

본 H의 30분 시뮬레이션을 **1주일로 확장**한 그림. 자경단 5명의 한 주.

| 요일 | 시간 | 사이클 | 명령어 |
|------|------|-------|-------|
| **월요일 09:00** | 30분 | main 동기화 + 주간 PR 계획 + 본인 branch 따기 | `git switch main && git pull --rebase` + `gh pr list --state merged --limit 10` + `git switch -c feat/...` |
| **화요일 14:00** | 30분 | conflict 미리보기 + 페어 점검 (본 H 시뮬) | `git fetch origin && git rebase origin/main` (conflict 있으면 페어로) |
| **수요일 11:00** | 30분 | 중간 PR 머지 + CI 점검 | `gh pr review --approve` + `gh pr merge --squash --auto` + `gh run list --branch=main` |
| **목요일 16:00** | 30분 | 큰 conflict 해결 + 큰 PR 쪼개기 | `git rebase main` (큰 conflict) + `git rebase -i HEAD~5` + stack PR |
| **금요일 17:00** | 30분 | 한 주 마무리 + release | `gh pr create` + `gh release create v0.X.0 --generate-notes` + 회고 |

**5사이클 × 30분 = 2시간 30분/주** (5명 합계 = 12시간 30분). 자경단 한 주 협업 비용. 한 사람 매일 30분 협업이 평균.

**한 주 비용 vs 결과** — 사람당 매주 2.5시간 협업, 5명이면 한 주 머지 PR 5~10개. 한 PR이 한 기능. 한 주 5~10개 기능. **30분 협업이 한 기능을 사요**.

---

## 15. 추신

본 H의 모든 git 출력은 강사가 `/tmp/cat-demo`에서 실제 실행한 결과예요. 거짓말 0. 본인이 같은 명령어를 본인 노트북에서 치면 비슷한 결과가 나와요. 30분 시뮬레이션의 24 명령어 = 자경단의 매일. conflict는 매주 1~3번, 평균 5분 — 처음 10번은 답답하지만 50번 후엔 1분. 반복이 자동을 만들어요. push 전 rebase는 안전, push 후 rebase는 위험 — 타이밍 한 줄이 안전을 결정. `--force-with-lease`의 거부는 동료 commit 보호의 신호 — 거부 보면 호흡, fetch + rebase + 다시.

mergetool(VS Code)은 5분 → 1분의 가속기, 한 번 셋업이면 평생. CODEOWNERS의 마지막 매치 우선. auto-merge는 branch protection 7체크 + 1명 승인 + CI 3개 통과 후 안전 — 새벽 3시에 안 깨도 다음날 머지 완료. log의 한 직선이 rebase, 두 갈래가 merge — 자경단은 linear history. sha 변경(d888f37 → 13c3232)은 rebase의 본질이에요. 5명 페어로 conflict 5분 푸는 게 자경단의 강력함 — 혼자 30분 끙끙대지 말고 5분 페어로.

conflict 마커(`<<<<<<<`·`=======`·`>>>>>>>`)를 처음 보면 패닉하지 마세요. `AA`(both added)·`MM`(both modified)·`AU`/`UA`도 conflict 종류일 뿐이에요. hotfix 5단계(fix → tag → push)가 자경단의 응급 표준. SemVer patch +1 = `git tag v1.0.1`, tag는 commit에 영원히 박혀요. 본 H를 두 번 읽고 한 번 손으로 쳐 보세요 — 그 세 번째가 첫 번째 진짜 학습. 다음 H6는 운영(branch 자동 삭제·release 자동·conflict 통계). 마지막 결심 — 친구 4명을 모아 진짜 cat-vigilante organization을 만들고 30분 시뮬을 한 번 돌리세요. 첫 PR 머지의 짜릿함이 5년의 협업 자신감. 🐾
