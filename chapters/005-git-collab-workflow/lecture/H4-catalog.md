# Ch005 · H4 — Git 협업 워크플로: 명령어/도구 카탈로그 — 30개의 손가락과 위험도 신호등

> **이 H에서 얻을 것**
> - 협업 흐름의 핵심 명령어/도구 30개 한 표 — git 본체 + GitHub CLI(`gh`) + husky·commitlint·lint-staged까지
> - 위험도 신호등 (🟢🟡🔴) — 어느 명령이 read-only고 어느 명령이 되돌릴 수 없는가
> - 6 무리 깊이 — 일상 흐름·PR 흐름·리뷰 도구·conflict 도구·commit 정리·CI/Actions 보너스
> - 매일·주간·월간 손가락 리듬 — 월요일 09:00부터 금요일 17:00까지 5명 자경단의 하루
> - 자경단 13줄 흐름이 30개 명령어 중 어느 9개를 매일 쓰는가

---

## 회수: H3의 셋업에서 본 H의 손가락으로

지난 H3에서 본인은 자경단 GitHub organization·team·branch protection·CODEOWNERS·commitlint·husky를 셋업했어요. 30분 셋업 10단계가 끝났어요. 합의가 도구로 박혔어요. 이제 셋업한 도구들을 **매일 손가락**으로 써야 해요.

이번 H4는 그 손가락의 카탈로그예요. **어느 명령어를 매일·주간·월간 쓰는가**. 그리고 각 명령어의 **위험도**(🟢🟡🔴) — 어느 게 안전하고 어느 게 사고 직행인가.

지난 Ch004의 H4은 git 23개 명령어 카탈로그였죠. 그건 **혼자** 쓰는 git의 손가락. 이번 H4는 **5명** 쓰는 git+GitHub의 손가락이에요. 23개 + GitHub CLI(`gh`) 10개 + 협업 도구 5개 = 30개+로 늘어나요. 늘어난 명령어 한 줄씩이 5명 협업의 매일 30초씩 절약. 30초 × 5명 × 365일 = 25시간/년. 한 명령어가 1년에 25시간을 사요.

---

## 1. 위험도 신호등 — 한 줄 정의

본 H의 모든 명령어에 신호등 색깔을 붙여요.

- 🟢 **초록 (read-only / 안전)** — 정보를 읽기만, 아무것도 안 바꿔요. 100번 쳐도 사고 0. 예: `git status`, `git log`, `gh pr view`.
- 🟡 **노랑 (local / 복구 가능)** — 본인 노트북만 바꿔요. 잘못해도 본인만 영향. 보통 reflog로 복구. 예: `git commit`, `git reset --soft`, `git stash`.
- 🔴 **빨강 (irreversible / remote 영향)** — 되돌리기 어렵거나, 원격(GitHub)·5명 모두에게 영향. 사고 직행 가능. 예: `git push --force`, `git reset --hard`, `gh pr merge --admin`.

**옵션과 상황이 신호등을 바꿔요**. 같은 명령어도 옵션에 따라 색이 달라져요. `git push`는 🟡 (안전한 push), `git push --force`는 🔴 (히스토리 갈아끼움), `git push --force-with-lease`는 🟡 (안전판 force).

이 단순한 3색 분류가 본인의 5년 손가락 안전을 결정해요. **빨강은 1초 멈춤**. 빨간 명령어는 치기 전 한 번 더 호흡. 그 한 호흡이 사고 한 시간을 막아요.

---

## 2. 30개 명령어/도구 한 표

### 2-1. 표 (6 무리 × 평균 5개)

| # | 명령어 | 무리 | 신호등 | 한 줄 정의 |
|---|--------|------|-------|----------|
| 1 | `git status -sb` | 일상 | 🟢 | 짧은 형식으로 변경 + 추적 상태 확인 |
| 2 | `git diff` | 일상 | 🟢 | 변경 내용 보기 (working vs staged) |
| 3 | `git diff --staged` | 일상 | 🟢 | staged된 변경 보기 (commit 직전 자기 리뷰) |
| 4 | `git log --oneline --graph -20` | 일상 | 🟢 | 최근 20개 commit 그래프 |
| 5 | `git pull --rebase` | 일상 | 🟡 | 원격 변경 가져와 본인 commit 위에 다시 쌓기 |
| 6 | `git switch -c feat/...` | PR 흐름 | 🟡 | 새 branch 만들고 이동 |
| 7 | `git add -p` | PR 흐름 | 🟡 | hunk 단위로 staged 선택 (정밀) |
| 8 | `git commit -m "feat: ..."` | PR 흐름 | 🟡 | Conventional Commits 메시지로 commit |
| 9 | `git push -u origin HEAD` | PR 흐름 | 🟡 | 현재 branch 원격에 처음 push (upstream 설정) |
| 10 | `gh pr create --draft` | PR 흐름 | 🟡 | Draft PR 생성 (GitHub CLI) |
| 11 | `gh pr view --web` | 리뷰 | 🟢 | PR을 브라우저로 열기 |
| 12 | `gh pr checkout 42` | 리뷰 | 🟡 | PR #42를 본인 노트북에 체크아웃 |
| 13 | `gh pr diff 42` | 리뷰 | 🟢 | PR diff를 터미널에서 보기 |
| 14 | `gh pr review --approve` | 리뷰 | 🟡 | PR 승인 |
| 15 | `gh pr review --request-changes` | 리뷰 | 🟡 | PR 변경 요청 |
| 16 | `gh pr review --comment` | 리뷰 | 🟢 | PR에 코멘트 (승인/거부 없이) |
| 17 | `git merge --no-ff` | 합치기 | 🟡 | merge commit 강제로 만들며 합치기 |
| 18 | `git rebase main` | 합치기 | 🟡 | 본인 branch를 main 위로 옮기기 |
| 19 | `git rebase -i HEAD~5` | 합치기 | 🟡 | 최근 5 commit 인터랙티브 정리 (squash·reword) |
| 20 | `git mergetool` | conflict | 🟡 | 외부 도구(VS Code·Beyond Compare)로 conflict 해결 |
| 21 | `git rerere` | conflict | 🟡 | 한 번 푼 conflict 자동 기억·재적용 |
| 22 | `git diff --diff-algorithm=histogram` | conflict | 🟢 | 더 똑똑한 diff 알고리즘 |
| 23 | `git push --force-with-lease` | 정리 | 🟡 | 안전판 force push (서버가 본인이 본 것과 같을 때만) |
| 24 | `git commit --amend` | 정리 | 🟡 | 직전 commit 메시지·내용 수정 |
| 25 | `gh pr merge --squash --auto` | 정리 | 🔴 | CI 통과 시 자동 squash 머지 |
| 26 | `gh run list` | CI | 🟢 | 최근 GitHub Actions 실행 목록 |
| 27 | `gh run watch` | CI | 🟢 | 실행 중인 workflow 실시간 watch |
| 28 | `gh run rerun --failed` | CI | 🟡 | 실패한 job만 재실행 |
| 29 | `npx commitlint --edit "$1"` | 도구 | 🟢 | commit 메시지 양식 검사 (husky가 자동 호출) |
| 30 | `npx lint-staged` | 도구 | 🟡 | staged 파일에 lint·format 자동 (husky가 자동 호출) |

### 2-2. 빨강 명령어 6개 따로 모음

🔴 빨강은 1초 호흡. 자경단 표준으로 빨강은 다음 6개:

| 빨강 명령어 | 왜 빨강 | 안전판 |
|------------|--------|-------|
| `git push --force` | 원격 히스토리 갈아끼움. 5명 commit 사라짐. | `--force-with-lease` 대체 |
| `git reset --hard <commit>` | 본인 working dir + staging 다 날림. | `git stash` 먼저, 또는 `git revert` |
| `git clean -fd` | 추적 안 된 파일·디렉토리 영구 삭제. | `git clean -nd` 미리 보기 |
| `git rebase main` (이미 push된 branch에) | 공유된 commit의 sha 변경 = 동료 혼란. | 새 branch에 cherry-pick |
| `gh pr merge --admin` | branch protection bypass 머지. | 절대 평소 사용 금지, 응급용 |
| `gh pr close` | PR 닫음 (재오픈 가능하지만 알람 자동) | 코멘트로 의도 먼저 |

자경단 1년 동안 본인이 빨강 6개를 쓸 일 — 평균 5번 미만. 평소엔 노랑 24개로 충분. 빨강은 응급실 도구.

---

## 3. 무리 1: 일상 흐름 5개 — 매일 손가락

자경단의 **매일** 5명이 다같이 쓰는 5개. 1년 365일 × 5명 × 5개 = 9,125번/년. 가장 많이 치는 손가락.

### 3-1. `git status -sb` 🟢

`-s` short, `-b` branch. 출력이 5줄 이내. 매일 30번씩.

> ▶ **같이 쳐보기** — short + branch 한 줄 진단
>
> ```bash
> git status -sb
> # ## feat/cat-card...origin/feat/cat-card [ahead 2]
> #  M src/components/CatCard.tsx
> # ?? src/styles/CatCard.module.css
> ```

읽기 — `M`(modified, working), 첫 칸은 staged·둘째 칸은 working. `??`는 untracked. 위 2줄 = "feat/cat-card 브랜치, 원격보다 2 commit 앞섬, CatCard.tsx 수정됨, CatCard.module.css 새 파일".

**alias 권장** — `git config --global alias.s "status -sb"`. `git s` 한 줄. 손목 보호.

### 3-2. `git diff` / `git diff --staged` 🟢

`git diff` — working vs staged 차이. `git diff --staged` — staged vs HEAD 차이.

**commit 직전 자기 리뷰 황금 규칙** — `git diff --staged`로 한 번 더 보고 commit. 5초 손목 절약 vs 5분 PR 코멘트 절약. **자기 리뷰가 시니어 신호**.

### 3-3. `git log --oneline --graph -20` 🟢

최근 20 commit + branch 그래프 한 줄씩.

> ▶ **같이 쳐보기** — 최근 20 commit 의 그림 한 화면
>
> ```bash
> git log --oneline --graph -20
> # * 3717348 (HEAD -> main) Ch005 H3 ...
> # *   5ce93d4 Merge pull request #12 from cat-vigilante/feat/cat-card
> # |\
> # | * a1b2c3d feat(cat-card): 신고 카드 컴포넌트
> # |/
> ```

**alias 권장** — `git config --global alias.lg "log --oneline --graph --all -20"`. `git lg` 한 줄.

### 3-4. `git pull --rebase` 🟡

원격 변경 가져와 본인 commit 위에 다시 쌓기. **merge commit 안 만듦**. log 그래프 깔끔.

기본 `git pull`은 merge. 자경단 표준 — `pull.rebase=true`로 설정해서 모든 pull을 자동 rebase. (Ch004 H3에서 셋업.)

```bash
git pull --rebase   # 또는 그냥 git pull (rebase 자동)
```

**conflict 시** — 자동 멈춤, 본인이 conflict 해결, `git rebase --continue`. 또는 `git rebase --abort`로 취소.

### 3-5. `git push -u origin HEAD` 🟡

처음 push 시 `-u`로 upstream 설정. 다음부턴 그냥 `git push`.

`origin HEAD` — origin 원격에, 현재 branch 그대로의 이름으로. 자경단 표준 — `push.autoSetupRemote=true` 설정 (Ch004 H3) → `-u origin HEAD` 안 써도 자동.

```bash
# 첫 push
git push -u origin HEAD
# 또는 (push.autoSetupRemote=true 설정 시)
git push
```

---

## 4. 무리 2: PR 흐름 5개 — 한 사이클의 5단계

본인의 한 PR이 처음 만들어져서 머지되기까지 5명령. 보통 30분 ~ 1일에 한 번.

### 4-1. `git switch -c feat/cat-card` 🟡

새 branch 만들고 이동. branch 이름은 자경단 표준 `<type>/<short-desc>` (Ch005 H2 회수).

`-c` create. 옛 명령 `git checkout -b`도 같음. **`switch`가 2.23 (2019)부터 새 표준**. 더 명확. branch 이동 전용.

```bash
git switch -c feat/cat-card    # main에서 새 branch 따고 이동
git switch -                   # 직전 branch로 토글 (- 한 글자)
git switch main                # main으로 이동
```

### 4-2. `git add -p` 🟡

`-p` patch. hunk 단위로 staged 선택. 한 파일 안의 변경을 일부만 commit 가능.

```bash
$ git add -p src/CatCard.tsx
@@ -10,3 +10,8 @@
 export function CatCard() {
+  const [loading, setLoading] = useState(false);   # hunk 1
   ...
+  const handleClick = () => { ... };                # hunk 2
 }
Stage this hunk [y,n,q,a,d,s,e,?]?
```

`y` stage·`n` skip·`s` split·`e` edit·`q` quit. 5명 PR이 작아져요. **큰 commit을 작은 commit 셋으로 쪼개는 가장 빠른 방법**.

### 4-3. `git commit -m "feat(cat-card): ..."` 🟡

Conventional Commits 양식 (Ch005 H3 회수). type·scope·subject. husky의 commit-msg hook이 검사.

```bash
git commit -m 'feat(cat-card): 신고 카드 컴포넌트 추가'
git commit -m 'fix(api): photo upload 500 에러 수정'
git commit -m 'docs: CONTRIBUTING.md 첫 PR 가이드 추가'
```

zsh 함정 — 단일 인용 `'...'`. 이중 인용은 `!`·`$` 해석.

**`-m` 없이** — `git commit`만 치면 에디터 열림 (Ch004 H3에서 `core.editor` 설정). 본문·footer 길게 쓸 때 유용.

### 4-4. `gh pr create --draft` 🟡

GitHub CLI로 PR 생성. 브라우저 안 열고 터미널에서 한 줄.

```bash
gh pr create --draft \
  --title 'feat(cat-card): 신고 카드 컴포넌트 추가' \
  --body 'Closes #42. CatCard 컴포넌트 + 사진 lazy load.' \
  --reviewer @cat-vigilante/maintainers \
  --label feat,frontend
```

**`--draft` early feedback** — 완성 전에 5명에게 보여주고 코멘트 받기. 큰 PR을 일찍 갈래로 쪼개는 신호.

`--web` 옵션으로 브라우저에서 마무리도 가능. `gh pr create --web`.

### 4-5. `gh pr merge --squash --auto` 🔴 → 🟡 (셋업 후)

CI 통과 시 자동 squash 머지. 본인이 브라우저 안 열어도 머지됨.

```bash
gh pr merge 42 --squash --auto
```

🔴 → 🟡 — branch protection 7체크 + 1명 승인이 셋업되어 있으면 자동 머지가 안전. 셋업 없으면 빨강.

자경단 표준 — `--squash` 80% (PR 1개 = 1 commit), `--rebase` 20% (의미 보존), `--merge` 0% (linear history 정책).

---

## 5. 무리 3: 리뷰 도구 5개 — 동료 PR 1분 안에 파악

본인이 동료 PR에 리뷰 다는 5개. 5명 자경단이면 매일 1~5번씩.

### 5-1. `gh pr view 42 --web` 🟢

PR을 브라우저로 열기. URL 복붙 안 해도 됨.

```bash
gh pr view 42 --web        # 브라우저
gh pr view 42              # 터미널에서 PR 정보 (제목·body·코멘트·CI 상태)
```

### 5-2. `gh pr checkout 42` 🟡

PR #42를 본인 노트북에 체크아웃. `git fetch + git switch` 한 번에.

```bash
gh pr checkout 42
# 자동으로 PR의 branch로 switch. 본인 노트북에서 직접 동작 확인 가능.
```

**왜 중요** — 코드를 브라우저로만 보면 한계. 본인 노트북에서 실제로 돌려 봐야 진짜 리뷰. 까미가 백엔드 변경한 PR에 대해, 본인이 frontend에서 실제 호출 잘 되는지 확인 가능.

### 5-3. `gh pr diff 42` 🟢

PR diff를 터미널에서 색깔로. less 페이저로 자동.

```bash
gh pr diff 42 | less       # 터미널에서 PR 보기
gh pr diff 42 --color always | bat   # bat으로 더 예쁘게
```

큰 PR(500줄+)은 브라우저보다 터미널이 빠를 수 있음. 단축키로 빠른 검색.

### 5-4. `gh pr review --approve` / `--request-changes` / `--comment` 🟡

PR 리뷰 셋 — 승인·거부·코멘트.

```bash
gh pr review 42 --approve --body 'LGTM, 잘 만드셨어요!'
gh pr review 42 --request-changes --body '5번 줄 한 가지 수정 부탁드려요.'
gh pr review 42 --comment --body '이 부분이 흥미롭네요. 다른 패턴 비교해 보면...'
```

**자경단 5톤** (Ch004 H6 회수): 칭찬·질문·제안·요청·nit. 셋 명령으로 5톤 다 가능.

**황금 규칙** — `request-changes`는 1년에 5번 미만. 까칠한 인상. 보통 `comment`(질문·제안)로 충분. 진짜 깰 코드만 `request-changes`.

### 5-5. `gh pr list --search 'review-requested:@me'` 🟢

본인이 리뷰어로 지정된 PR 목록. 매일 아침 한 번.

```bash
gh pr list --search 'review-requested:@me'
gh pr list --search 'is:open author:@me'         # 본인이 만든 PR
gh pr list --search 'is:open label:bug'          # bug 라벨 PR
```

**alias 권장** — `~/.zshrc`에 `alias mypr='gh pr list --search "review-requested:@me"'`. 매일 아침 `mypr` 한 줄.

---

## 6. 무리 4: conflict 도구 5개 — 충돌 한 시간을 5분으로

자경단 5명이 같은 파일 건드리면 conflict. 일주일에 1~3번. 5분 안에 풀어야.

### 6-1. `git mergetool` 🟡

VS Code·Beyond Compare 같은 외부 도구로 conflict 해결. 텍스트 `<<<<<<<` 직접 편집 안 해도 됨.

```bash
# 셋업 (한 번만)
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# 사용
git mergetool             # conflict 있는 파일마다 VS Code 자동 열림
```

VS Code의 conflict 화면 — current·incoming·base 셋 보이고 버튼으로 선택. 손가락 5번에 conflict 5개 해결. **GUI가 텍스트보다 1/10 시간**.

### 6-2. `git rerere` 🟡

"Reuse Recorded Resolution" — 한 번 푼 conflict를 자동 기억·재적용.

```bash
git config --global rerere.enabled true
```

**언제 효과** — 같은 branch를 여러 번 rebase하거나 merge할 때, 또는 같은 파일에 같은 conflict가 자주 일어날 때. 기억된 해결법이 자동 적용 → 본인이 같은 conflict를 두 번째 풀 필요 없음.

자경단 효과 — 큰 PR을 main에 rebase할 때 conflict가 여러 번 일어나면 한 번만 풀고 나머지는 자동.

### 6-3. `git diff --diff-algorithm=histogram` 🟢

기본 diff 알고리즘 (myers)보다 똑똑한 histogram. 큰 코드 변경의 의도를 더 잘 잡아냄.

```bash
git config --global diff.algorithm histogram
# 이제 모든 diff·merge가 histogram 사용
```

**효과** — 코드 이동(refactor)을 "삭제 + 추가"가 아닌 "이동"으로 인식. conflict 줄어듦. merge commit이 깔끔.

### 6-4. `git checkout --conflict=diff3` 🟡

conflict 마커에 base(공통 조상) 추가. `<<<<<<<`·`=======`·`>>>>>>>` 외에 `|||||||`로 base 표시.

```bash
git config --global merge.conflictstyle diff3
```

```
<<<<<<< HEAD
const cat = "검정";
||||||| base
const cat = "원래";
=======
const cat = "노랑";
>>>>>>> incoming
```

**왜 유용** — base가 보이면 "두 사람이 어디서 시작했는지" 알 수 있어 의도 파악이 빠름. `검정` vs `노랑` 단독으론 헷갈려도, base가 `원래`면 둘 다 변경했다는 게 명확.

### 6-5. `git merge --abort` / `git rebase --abort` 🟡

conflict 풀다가 막히면 탈출. 시작 전 상태로 복원.

> ▶ **같이 쳐보기** — 비상 탈출 3종 (merge / rebase / cherry-pick)
>
> ```bash
> git merge --abort         # merge 중 취소
> git rebase --abort        # rebase 중 취소
> git cherry-pick --abort   # cherry-pick 중 취소
> ```

**황금 규칙** — 5분 안에 안 풀리면 abort, 동료에게 페어 요청. 30분 혼자 끙끙대지 말 것. 페어 conflict 해결이 5분이면 끝나는 일이 많음.

---

## 7. 무리 5: commit 정리 5개 — 머지 직전의 5분 정리

PR 머지 직전 commit history를 깔끔히 만드는 5개.

### 7-1. `git rebase -i HEAD~5` 🟡

최근 5 commit 인터랙티브 정리. squash·reword·drop·edit 가능.

```bash
git rebase -i HEAD~5
```

에디터 열림:
```
pick a1b2c3d feat: 신고 카드 컴포넌트
pick d4e5f6g fix: 사진 lazy load 버그
squash 7h8i9jk wip
pick lmn0pqr feat: 신고 버튼 추가
reword stuvwxy chore: 임시 정리

# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# s, squash = use commit, but meld into previous commit
# d, drop = remove commit
```

**자경단 표준 squash 예** — wip commit을 직전 feat commit에 합치기. PR 본문에 깨끗한 commit 5개만 보임.

### 7-2. `git commit --amend` 🟡

직전 commit의 메시지·내용 수정. 새 commit 안 만들고 기존 것 갈아끼움.

```bash
# 메시지만 수정
git commit --amend -m 'feat(cat-card): 신고 카드 + 사진 lazy load'

# 내용도 추가 (staged 파일을 직전 commit에 합치기)
git add forgotten-file.tsx
git commit --amend --no-edit
```

**황금 규칙** — push **전에만** amend. push **후에** amend = sha 변경 = 동료 혼란. push 후엔 새 commit + revert.

### 7-3. `git push --force-with-lease` 🟡

`--force`의 안전판. 원격이 본인이 마지막으로 본 상태와 같을 때만 force push 성공.

```bash
git push --force-with-lease     # 안전판 force
git push --force                # 위험한 force (자경단 금지)
```

**시나리오** — 본인이 rebase 후 force push해야 함. 그런데 그 사이에 까미가 같은 branch에 push했으면? `--force`는 까미 commit 사라짐. `--force-with-lease`는 거부 → 본인이 까미 commit 받고 다시 rebase.

**alias 권장** — `git config --global alias.fpush "push --force-with-lease"`. `git fpush`가 본인의 표준.

### 7-4. `git stash push -m "wip"` / `git stash pop` 🟡

작업 중인 변경을 임시 저장. 다른 branch로 가서 급한 일 처리 후 복귀.

```bash
git stash push -m "cat-card 작업 중"   # 임시 저장
git switch main
git pull --rebase
# 급한 hotfix 처리
git switch feat/cat-card
git stash pop                         # 복원
git stash list                        # 저장된 stash 목록
```

**자경단 hotfix 시나리오** — 노랭이가 cat-card 작업 중에 prod에 버그 발견. stash → main switch → fix branch → push → PR → 머지 → cat-card 복귀. 5분 안에. **stash가 컨텍스트 스위치 비용을 1/5로**.

### 7-5. `git revert <commit>` 🟡

특정 commit의 효과를 반대로 적용한 새 commit. 히스토리 안 지워요.

```bash
git revert 3717348            # 3717348의 변경을 되돌리는 새 commit
git revert HEAD               # 직전 commit 되돌리기
git revert --no-commit HEAD~3..HEAD   # 최근 3 commit을 한 commit으로 되돌리기
```

**vs `reset`** — `reset`은 히스토리 지움 (위험), `revert`는 새 commit 만들어 추가 (안전). main에 머지된 commit은 무조건 `revert`. **revert가 main의 자물쇠**.

---

## 8. 무리 6: CI/Actions 보너스 5개 — GitHub 위에서

GitHub Actions(자경단의 CI)을 터미널에서.

### 8-1. `gh run list` 🟢

최근 GitHub Actions 실행 목록.

```bash
gh run list                       # 최근 20개
gh run list --workflow=ci.yml     # 특정 workflow만
gh run list --branch=main         # main에 대한 실행만
```

### 8-2. `gh run watch` 🟢

실행 중인 workflow를 실시간 watch. 끝날 때까지 터미널에서 진행 상황 보기.

```bash
gh run watch                      # 진행 중인 latest 자동 선택
gh run watch <run-id>             # 특정 run
```

### 8-3. `gh run rerun --failed` 🟡

실패한 job만 재실행. flaky test에 유용.

```bash
gh run rerun <run-id> --failed    # 실패한 job만
gh run rerun <run-id>             # 전체 재실행
```

### 8-4. `gh run view --log-failed` 🟢

실패한 job의 로그만 보기.

```bash
gh run view <run-id> --log-failed | less
gh run view <run-id> --log | grep ERROR
```

### 8-5. `gh workflow list` / `gh workflow run` 🟢🟡

workflow 목록·수동 실행.

```bash
gh workflow list                          # 모든 workflow
gh workflow run deploy.yml -f env=staging # 수동 실행 (workflow_dispatch)
```

**자경단 활용** — 매일 아침 `gh run list --branch=main`으로 main의 CI 상태 점검. 빨간불이면 5분 안에 처방.

---

## 9. 매일·주간·월간 손가락 리듬

자경단 5명의 한 주.

### 9-1. 매일 6 손가락 (5분 × 5명 = 25분/일)

```bash
# 아침 09:00
git status -sb                                       # 1. 어제 어디까지 했나
git pull --rebase                                    # 2. 어제 동료 변경 받기
gh pr list --search 'review-requested:@me'           # 3. 본인 리뷰 대기 PR

# 오후 작업 사이
git diff --staged                                    # 4. commit 직전 자기 리뷰
git commit -m '...'                                  # 5. Conventional Commits
git push                                             # 6. 원격에 올림 (push.autoSetupRemote=true)
```

**합계 6 명령어, 30초씩 = 3분/일/사람**. 5명이면 15분/일. 1년 91시간.

### 9-2. 주간 7 손가락 (월요일 + 금요일 30분씩)

월요일 09:00 — 한 주 시작:
```bash
git switch main && git pull --rebase                 # 1. main 최신
gh pr list --state merged --limit 10                 # 2. 지난주 머지 회고
git switch -c feat/this-week                         # 3. 이번주 branch
```

금요일 17:00 — 한 주 마무리:
```bash
git push -u origin HEAD                              # 4. 원격에 올림
gh pr create --draft                                 # 5. PR 생성 (월요일 머지 예정)
gh run list --workflow=ci.yml --branch=main          # 6. main CI 상태
gh release list                                      # 7. release 목록
```

화요일 14:00 — 자경단 conflict 미리보기 (Ch005 H1 회수):
```bash
git fetch origin
git rebase origin/main                               # 본인 branch에 main 미리 적용
# conflict 있으면 5분 안에 해결, 없으면 진짜 충돌 없음 확인
```

### 9-3. 월간 5 손가락 (월말 1시간)

```bash
git log --since='1 month ago' --pretty=format:'%h %s' | wc -l  # 1. 한 달 commit 수
gh pr list --state merged --search 'merged:>2026-04-01'         # 2. 한 달 머지 PR
gh release create v0.5.0 --generate-notes                       # 3. release (자동 노트)
git tag -l --sort=-creatordate | head -5                        # 4. 최근 5 tag
git remote prune origin                                         # 5. 삭제된 원격 branch 정리
```

**합계 매일 6 + 주간 7 + 월간 5 = 18 명령어**. 자경단 30개 카탈로그 중 18개를 매일·주간·월간 리듬에 박음. 나머지 12개는 conflict·정리·CI 응급용.

---

## 10. 자경단 13줄 흐름 — 30개 명령어가 한 PR에

본인이 자경단의 cat-card 기능을 한 PR로 만드는 13줄. 30개 카탈로그 중 9개 사용 (✦ 표시).

```bash
# 1. main 최신 받기
git switch main && git pull --rebase                   # ✦ git pull --rebase

# 2. 새 branch
git switch -c feat/cat-card                            # ✦ git switch -c

# 3~5. 작업 + commit (3번 정도)
# (코드 작업)
git add -p src/                                        # ✦ git add -p
git diff --staged                                      # ✦ git diff --staged
git commit -m 'feat(cat-card): 신고 카드 컴포넌트'      # ✦ git commit (Conventional)

# 6. 원격에 올림 + PR
git push -u origin HEAD                                # ✦ git push -u origin HEAD
gh pr create --draft --reviewer @cat-vigilante/maintainers  # ✦ gh pr create

# 7. CI 모니터
gh run watch                                           # ✦ gh run watch

# 8. 리뷰 코멘트 받고 수정
# (코드 수정)
git commit --amend                                     # ✦ git commit --amend
git push --force-with-lease                            # ✦ git push --force-with-lease

# 9. 머지 자동 예약
gh pr merge --squash --auto                            # ✦ gh pr merge --squash --auto
```

**13줄로 9개 명령어**. 나머지 21개는 conflict·정리·응급용. 평소 PR 1개 = 9 손가락. 한 주 PR 5개 = 45 손가락. 1년 = 2,340 손가락. 손가락 한 줄이 자경단의 매일.

---

## 11. 흔한 오해 7가지

**오해 1: "명령어를 다 외워야 협업 가능."** — 매일 6개 + 주간 7개로 충분. 30개 다 외울 필요 없음. 자주 쓰는 13개를 손가락에 박고 나머지는 검색 가능. **양보다 깊이**.

**오해 2: "GitHub CLI(`gh`)는 옵션이에요."** — 자경단 표준 필수. 브라우저보다 5배 빠름. PR 만들기 5초 vs 1분. 1년 시간 가치 50시간. `brew install gh` 한 줄 설치.

**오해 3: "git checkout으로 충분, switch는 새 거라 안 써도 돼요."** — 2.23(2019)부터 권장. checkout은 두 일(branch 이동 + 파일 복원)을 한 명령에 묶어 헷갈림. switch + restore 분리가 더 명확. **시니어가 새 표준 쓰는 신호**.

**오해 4: "merge가 깔끔, rebase는 위험."** — 거꾸로. rebase가 log 깔끔, merge는 graph 복잡. 다만 push 후 rebase는 위험 (sha 변경). **push 전 rebase, push 후 revert**의 황금 규칙.

**오해 5: "force push는 절대 금지."** — `--force-with-lease`는 OK. 본인 branch의 rebase 후 push 시 필요. 자경단 표준. 다만 `--force`(no lease)는 금지, `--force-with-lease`는 일상.

**오해 6: "conflict는 시니어 일."** — 신입도 푸는 일. 매주 1~3번. mergetool + rerere 셋업하면 5분 안에. **conflict가 시니어 신호가 아니라, 5분 안에 푸는 게 시니어 신호**.

**오해 7: "GitHub Actions 보면 너무 복잡해요."** — `gh run list` 한 줄로 충분. 빨간불 보면 `gh run view --log-failed`. 두 명령으로 90% 진단. **CI 진단이 5초로 줄어요**.

---

## 12. FAQ 7가지

**Q1. 자경단 13줄 흐름이 매번 똑같이 적용되나요?**
A. 90% 같음. 특수한 경우(hotfix·release·실험)만 변형. hotfix는 main에서 직접 fix branch + 빠른 머지. release는 tag + GitHub Release. 실험은 long-lived branch + draft PR. 셋의 변형도 13줄 흐름의 일부 갈래일 뿐. **표준이 90%, 변형이 10%**.

**Q2. `gh` 명령어와 `git` 명령어의 경계는?**
A. `git`은 본인 노트북 위주, `gh`는 GitHub 원격 위주. PR·issue·release·CI는 `gh`. branch·commit·rebase·diff는 `git`. 둘이 만나는 곳은 push/pull. **로컬은 git, 원격은 gh**.

**Q3. mergetool로 VS Code 말고 다른 도구는?**
A. Beyond Compare(유료, macOS·Windows·Linux), Meld(무료), Kaleidoscope(macOS, 유료), GitKraken(GUI 전체). 자경단 표준 — VS Code(이미 깔린 거). 다른 도구는 1년 후 취향 따라.

**Q4. `--force-with-lease`도 사고 가능한가요?**
A. 드물게. 본인이 force push 직전에 본 원격 상태 + 실제 원격 상태가 같아도, 다른 동료가 그 사이에 같은 위치에 push했다면 사고 가능. 다만 자경단 5명 규모에선 거의 안 일어남. **lease가 100% 안전은 아니지만 99%**.

**Q5. commit history를 깔끔히 정리하는 비용·이득?**
A. 비용 — 본인 5분/PR. 이득 — 5명 리뷰 시간 1분/PR × 4명 = 4분, 1년 후 history 검색 시 가독성 무한대. 합계 +시간. **5분 투자, 4분 즉시 회수, 평생 추가 가치**.

**Q6. CODEOWNERS 자동 reviewer는 `gh pr create --reviewer`보다 우선하나요?**
A. 둘 다 적용 (합집합). `--reviewer`로 명시한 사람 + CODEOWNERS 매핑 사람 둘 다 알람. 자경단 표준 — `--reviewer`는 명시 안 하고 CODEOWNERS에 맡김. 깔끔.

**Q7. GitHub Actions의 `gh run rerun --failed`가 사고 위험은?**
A. 거의 없음. 새 commit 안 만들고 같은 commit·workflow를 재실행. flaky test 자주 일어나면 `--failed`만으로 충분. 다만 환경 변수·secret이 바뀌면 재실행 결과가 달라질 수 있음. **재실행 ≠ 재현 보장**, 다만 90%는 같음.

---

## 13. 추신

30개 명령어 = 자경단 5년의 손가락. 매일 6개, 주간 7개, 월간 5개의 리듬이 쌓여요. 위험도 신호등 3색이 손가락의 안전벨트 — 빨강 6개 앞에서 1초 호흡, 1초가 1년의 안전. `gh`(GitHub CLI)를 1주일 안에 익혀 두세요 — 브라우저보다 5배 빠른 PR 흐름. `git switch`는 2.23(2019)부터 새 표준 — checkout 대신 switch + restore. `git pull --rebase`를 자경단 표준으로(`pull.rebase=true` 한 줄 config), 머지 직전 `git rebase -i HEAD~5`로 commit 정리.

`git push --force-with-lease`는 alias `fpush`로, mergetool + rerere + diff3 conflictstyle 셋이 conflict 한 시간을 5분으로. `git stash`는 컨텍스트 스위치의 친구, `git revert`는 main의 자물쇠(머지된 commit은 무조건 revert), `gh run watch`로 CI 실시간 모니터. 자경단 13줄 흐름 = 30개 카탈로그 중 9개라 90% PR이 같은 9개. 매일 6 + 주간 7 + 월간 5 = 18개 손가락이 자경단의 한 달로 충분.

다음 H5는 데모 — 자경단의 30분 협업 시뮬레이션. 본 H의 30개 명령어가 H5의 30분 손가락으로 살아 움직여요. alias 7개(s·lg·co·br·cm·fpush·amend)를 `~/.gitconfig`에 박아 두세요 — 매일 1000번 치는 손가락이 1년 후 손목 통증을 1/10로. 30개 카탈로그를 한 페이지로 GitHub Wiki·Notion에 박아 두면 자경단 5명의 합의 비용이 0. **공유가 협업의 곱셈**. 🐾
