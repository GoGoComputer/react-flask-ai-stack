# Ch004 · H5 — 데모: 터미널 한 호흡으로 git init부터 첫 push까지, 그리고 사고와 복원

> **이 H에서 얻을 것**
> - 빈 폴더 → `git init` → 5개 commit → GitHub remote 연결 → 첫 push까지 **한 호흡**으로 두드리기.
> - 일부러 **`git reset --hard`로 commit을 날리고 `git reflog`로 살리기** — 무서운 명령어를 안전한 데모에서 한 번 만나기.
> - **Branch + Merge + Conflict + 해결** 미니 시나리오 한 번.
> - H4의 23개 카탈로그 중 13개 명령어를 손가락에 박는 30분 실연.

---

## 회수: H4의 카탈로그를 손가락으로 옮기기

지난 H4는 머리의 시간이었어요. 23개 명령어를 6개 무리로 묶고, 위험도 신호등을 칠하고, 매일 쓰는 6개와 일주일에 쓰는 7개와 1년에 쓰는 8개로 분류했어요. 표 한 장이 머리에 박혔습니다. 그런데 표는 한 번 보고 잊으면 끝이에요. **표를 손가락으로 옮겨야** 본인의 무의식에 박혀요. 이번 H5는 그 옮기는 시간입니다. 빈 폴더 하나 만들고, 그 폴더에서 git init부터 첫 push까지를 한 호흡으로 두드려 봐요.

이 데모는 **본인이 실제로 따라 쳐야** 의미가 있어요. 글로 읽기만 하면 손가락에 안 박혀요. 본인 노트북 어딘가에 `~/playground/git-demo`라는 빈 폴더를 만드세요. 그리고 이 H5를 한 줄씩 따라 두드립니다. 한 번 두드리면 30분 걸려요. 두 번째 두드리면 15분. 세 번째 두드리면 7분. 본인이 회사 첫날 git init을 두드릴 때 이미 손가락이 알고 있어요.

또 하나 — **이 데모는 안전한 환경**이에요. 본인이 실수해도 아무것도 잃지 않습니다. 빈 폴더에서 일부러 `git reset --hard`를 두드려 보고, 일부러 conflict을 만들어 보고, 일부러 force-push를 두드려 봐요. 회사에서 만나면 무서운 명령어들을 안전한 환경에서 한 번 만나면, 다음에 진짜로 만났을 때 손가락이 침착해져요. **두려움은 무지에서 와요.** 한 번 만나면 두려움이 줄어들고, 신중함만 남아요. 본인의 5년 차 신중함이 이 30분에서 시작합니다.

---

## 1. 환경 준비 — 빈 폴더 한 개

> ▶ **같이 쳐보기** — 빈 놀이터 폴더 한 개 만들기 (0번 상태)
>
> ```bash
> mkdir -p ~/playground/git-demo
> cd ~/playground/git-demo
> ls -la
> ```

`ls -la`의 결과는 `.`과 `..` 두 개뿐. 깨끗한 빈 폴더예요. 본인의 git 인생이 시작되는 0번 상태. 이 폴더 안에서 H3에서 셋업한 `git config --global` 7줄(name·email·init.defaultBranch=main·pull.rebase·core.editor·core.autocrlf·push.autoSetupRemote)이 자동으로 적용돼요. **본인이 한 번 깔아 두면 모든 새 폴더에서 자동.** H3의 가치가 여기서 처음으로 와 닿아요.

한 가지 더 — **터미널에서 git 관련 정보를 프롬프트에 띄우는 도구**를 추천해요. `oh-my-zsh`(macOS·Linux)나 `starship`(크로스 OS) 같은 도구를 깔면 본인 프롬프트에 현재 가지 이름과 변경 여부가 자동으로 떠요. `~/playground/git-demo (main ✓)` 같은 식. 본인이 `git status`를 두드리지 않아도 프롬프트만 보면 지금 상태를 알 수 있어요. 손가락이 한 줄 줄어드는 평생 효과. Ch037(터미널 환경 심화)에서 본격적으로 다룰 예정이지만, 지금부터 미리 깔아 두면 H5의 데모가 더 부드러워요. 본인이 안 깔았다면 일단 `git status`를 자주 두드려서 같은 정보를 얻어요. 둘 중 하나는 꼭.

---

## 2. `git init` — 0번에서 1번으로

> ▶ **같이 쳐보기** — 0번에서 1번으로: 빈 폴더에 사진앨범 골격 깔기
>
> ```bash
> git init
> ```

출력:
```
Initialized empty Git repository in /Users/<you>/playground/git-demo/.git/
```

`ls -la`를 다시 두드려 보세요. 새로 생긴 폴더가 하나 보여요 — `.git/`. 이 폴더 안에 본인 저장소의 모든 것이 들어가요. **`.git`을 지우면 git이 사라져요.** working tree의 파일은 남지만 history·branch·config 모두 초기화. 한 가지 안전 — `.git`을 직접 만지지 마세요. 본인이 git 명령어를 두드리는 게 `.git`을 안전하게 만지는 유일한 방법입니다.

```bash
ls .git/
```

`HEAD`, `config`, `description`, `hooks/`, `info/`, `objects/`, `refs/` 등이 보여요. H7(내부 동작)에서 본격적으로 까볼 거예요. 지금은 한 줄만 — `cat .git/HEAD`. 출력은 `ref: refs/heads/main`. **HEAD가 main 가지를 가리키고 있다**는 뜻. H3에서 깐 `init.defaultBranch=main` 설정이 여기 적용된 거예요. 옛날 git은 master였지만 본인이 처음부터 main으로 시작합니다.

또 하나 — `cat .git/config`. 출력에 `[core]`·`[remote]`·`[branch]` 같은 섹션이 보여요. 이게 H3에서 본 `~/.gitconfig`(global)와 다른 **로컬(저장소별)** 설정. 같은 이름의 옵션이 양쪽에 있으면 로컬이 글로벌을 덮어써요. 회사에서 가끔 한 저장소만 다른 이메일로 commit해야 할 때(개인 이메일·회사 이메일 섞임 방지) 이 로컬 config에 한 줄 박아 두는 패턴이 표준이에요.

---

## 3. 첫 파일 — README와 첫 commit

> ▶ **같이 쳐보기** — 첫 파일 만들고 git status 한 번
>
> ```bash
> echo "# 자경단 데모 저장소" > README.md
> git status
> ```

`git status` 출력:
```
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README.md

nothing added to commit but untracked files present
```

**Untracked files** 줄에 README.md가 빨갛게(터미널 색 설정에 따라) 떠요. 아직 git이 관리하는 파일이 아니에요. working tree(작업 폴더)엔 있지만 staging·repository엔 없어요. H2에서 본 세 영역 그림이 떠오르나요? 지금 README.md는 working tree만에 있어요.

> ▶ **같이 쳐보기** — staging 으로 올리기: 빨강 → 초록
>
> ```bash
> git add README.md
> git status
> ```

`git status` 출력:
```
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README.md
```

**Changes to be committed** — staging으로 올라갔어요. 초록색(터미널 색)으로 표시. 아직 commit은 안 됐어요. staging은 "다음 commit에 들어갈 짐"이에요.

> ▶ **같이 쳐보기** — 본인의 첫 commit (root-commit)
>
> ```bash
> git commit -m "feat: 첫 README 추가"
> ```

출력:
```
[main (root-commit) abc1234] feat: 첫 README 추가
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

**root-commit** — 본인 저장소의 첫 commit이에요. parent가 없는 commit. 모든 git 저장소의 시작점. abc1234는 SHA-1 첫 7자(본인 환경에선 다른 값). `git log`로 확인해 보세요.

```bash
git log
```

출력:
```
commit abc1234... (HEAD -> main)
Author: GoGoComputer <gogo@local>
Date:   Mon Apr 27 10:00:00 2026 +0900

    feat: 첫 README 추가
```

**HEAD가 main을 가리키고 main이 abc1234를 가리킨다.** H2에서 본 attached HEAD 상태. 본인이 commit을 만들 때마다 이 그림이 한 칸씩 늘어나요.

---

## 4. 두 번째·세 번째 commit — 손가락 리듬 만들기

H4의 매일 6개 손가락 리듬을 두드려 봐요.

```bash
echo "## 길고양이 카드 1" >> README.md
echo "- 이름: 까미" >> README.md

# 리듬 시작
git status                      # 🟢 어떤 파일 바뀌었나
git diff                        # 🟢 줄 단위 확인
git add README.md               # 🟡 staging
git diff --staged               # 🟢 staging에 정확히 무엇이 올라가 있나(자기 리뷰)
git commit -m "feat: 까미 카드 추가"
```

`git diff` 출력에 `+## 길고양이 카드 1`·`+- 이름: 까미` 두 줄이 초록색 +로 떠요. 빨간색 -는 없어요(추가만 했으니까). 이 색깔이 H4의 신호등과 별개인 **diff 색깔** — 추가는 초록 +, 삭제는 빨강 -. git이 본인에게 보여 주는 일종의 변경 일기예요.

같은 리듬을 한 번 더.

```bash
echo "## 길고양이 카드 2" >> README.md
echo "- 이름: 노랭이" >> README.md
git status
git diff
git add .
git commit -m "feat: 노랭이 카드 추가"

git log --oneline
```

`git log --oneline` 출력:
```
def5678 (HEAD -> main) feat: 노랭이 카드 추가
9abcdef feat: 까미 카드 추가
abc1234 feat: 첫 README 추가
```

**3개 commit이 한 줄씩 쌓였어요.** main이 가장 위(가장 최신)를 가리키고, HEAD가 main을 가리켜요. 본인의 첫 history.

여기서 한 가지 멋진 옵션 — **`git log --oneline --graph --all`**. 줄을 그래프로 그려 줘요. 지금은 한 줄짜리 직선이지만 가지가 생기면 나뭇가지처럼 펼쳐져요. 회사 코드베이스의 1000개 commit을 이 한 줄로 한눈에 봐요. **본인의 alias로 만들어 두는 게 표준** — H3에서 깐 `lg` alias가 정확히 이거였어요.

```bash
git lg
```

H3의 5개 alias가 여기서 손가락에 닿아요. 셋업의 가치가 또 한 번 와 닿는 순간. **한 번 깔아 두면 평생.**

---

## 5. 가지 따기 — feature 가지에서 작업

```bash
git switch -c feat/cat-3-mini
```

출력:
```
Switched to a new branch 'feat/cat-3-mini'
```

`-c`는 create. 새 가지를 만들고 즉시 갈아탔어요. `git status`로 확인:
```
On branch feat/cat-3-mini
```

가지가 바뀌었어요. **하지만 파일은 그대로**예요. README.md 안의 두 카드가 그대로. 가지를 갈아탄다고 working tree가 매번 갈리는 게 아니에요 — 두 가지가 같은 commit에서 시작한 직후엔 working tree가 똑같아요. 가지가 갈라진 후 commit이 쌓이면 그때부터 갈라져요.

```bash
echo "## 길고양이 카드 3" >> README.md
echo "- 이름: 미니" >> README.md
git add .
git commit -m "feat: 미니 카드 추가"

git log --oneline --graph --all
```

`--all`이 모든 가지의 commit을 다 보여 줘요. 출력:
```
* 7777777 (HEAD -> feat/cat-3-mini) feat: 미니 카드 추가
* def5678 (main) feat: 노랭이 카드 추가
* 9abcdef feat: 까미 카드 추가
* abc1234 feat: 첫 README 추가
```

**main은 def5678에서 멈춰 있고, feat/cat-3-mini가 한 칸 더 앞으로 갔어요.** 두 가지가 같은 시작점에서 갈라진 직후의 상태. 이게 가지의 의미예요. 한 줄짜리 텍스트 파일(`.git/refs/heads/feat-cat-3-mini`)이 7777777을 가리키고 있을 뿐. **41바이트 안에 본인의 새 기능이 들어 있는** 거예요.

이제 main으로 돌아갑시다.

```bash
git switch main
cat README.md
```

`cat README.md`의 출력에 **카드 1·2만** 보여요. 카드 3(미니)은 없어요. **가지가 바뀌면 working tree의 파일도 바뀌어요.** main에는 미니 commit이 없으니까. 한 번 더 feat/cat-3-mini로 갈아타 보세요 — 카드 3이 다시 나타나요. 본인의 머리가 평행 우주 두 개를 오가는 거예요. 신기하면서도 무서운 감각. 그 감각이 익숙해지면 본인은 git을 진짜로 이해한 거예요.

---

## 6. 합치기 — fast-forward merge

```bash
git switch main
git merge feat/cat-3-mini
```

출력:
```
Updating def5678..7777777
Fast-forward
 README.md | 2 ++
 1 file changed, 2 insertions(+)
```

**Fast-forward** — main이 feat/cat-3-mini의 위치로 그냥 점프해요. main과 feat 사이에 다른 commit이 없으니까 새 merge commit이 안 생기고 main 라벨만 옮아가요. H2에서 본 fast-forward의 본질. 라벨 점프.

```bash
git log --oneline --graph --all
```

출력:
```
* 7777777 (HEAD -> main, feat/cat-3-mini) feat: 미니 카드 추가
* def5678 feat: 노랭이 카드 추가
* 9abcdef feat: 까미 카드 추가
* abc1234 feat: 첫 README 추가
```

**main과 feat/cat-3-mini가 같은 commit을 가리켜요.** 라벨 두 개가 한 자리에. 이게 fast-forward의 결과. 본인이 매번 만나는 가장 흔한 merge예요.

이제 끝난 가지를 정리.

```bash
git branch -d feat/cat-3-mini
git branch
```

출력:
```
* main
```

가지 한 개만 남았어요. **`-d`는 안전 삭제** — 가지의 commit이 다른 가지에 머지된 경우에만 삭제. 안 머지됐으면 git이 막아 줘요. 강제 삭제는 `-D`(빨강).

---

## 7. Conflict 만들기 — 일부러 한 번

이번엔 일부러 conflict을 만들어 봐요. 두 가지가 **같은 줄을 다르게** 고치면 git이 자동으로 못 합쳐요.

```bash
git switch -c feat/edit-line-1
sed -i.bak 's/이름: 까미/이름: 까미 (검정)/' README.md
rm README.md.bak
git add . && git commit -m "feat: 까미 색깔 검정 추가"

git switch main
git switch -c feat/edit-line-2
sed -i.bak 's/이름: 까미/이름: 까미 (턱시도)/' README.md
rm README.md.bak
git add . && git commit -m "feat: 까미 색깔 턱시도 추가"
```

(macOS의 `sed -i`는 `-i.bak`로 백업 파일을 강제로 만들고, 그걸 즉시 삭제. Linux/WSL에선 `sed -i ...` 한 줄로 충분.)

이제 두 가지를 합쳐 봐요.

```bash
git switch main
git merge feat/edit-line-1
```

이건 fast-forward로 머지돼요(main이 안 움직였으니까). 이제 main에 feat/edit-line-2를 합쳐요.

```bash
git merge feat/edit-line-2
```

출력:
```
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

**Conflict 발생.** `git status`로 확인:
```
On branch main
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
        both modified:   README.md
```

`cat README.md`로 보면:
```
- 이름: 까미 (검정)
<<<<<<< HEAD
=======
- 이름: 까미 (턱시도)
>>>>>>> feat/edit-line-2
```

**충돌 표시**가 박혀 있어요. `<<<<<<< HEAD`부터 `=======`까지가 main(현재) 쪽 변경, `=======`부터 `>>>>>>> feat/edit-line-2`까지가 합쳐 들어오는 가지의 변경. **본인이 손으로 결정**해야 해요. git이 자동으론 못 합쳐요.

해결 방법 — **에디터로 README.md 열어서** 충돌 표시 줄을 지우고 본인이 원하는 줄만 남깁니다. 예를 들어 두 색깔을 다 살리고 싶다면:
```
- 이름: 까미 (검정·턱시도 믹스)
```
한 줄로 합쳐서 박아요. `<<<<<<<`·`=======`·`>>>>>>>` 세 줄도 모두 지웁니다. 그 다음:

```bash
git add README.md
git commit -m "merge: 까미 색깔 표기 통일"
```

**`-m`을 안 써도 git이 기본 merge 메시지를 띄워 줘요.** 그냥 `git commit`만 두드리면 vim(또는 H3에서 깐 본인의 에디터)이 열리고 기본 메시지가 떠요. 그대로 :wq 하면 끝.

```bash
git log --oneline --graph --all
```

merge commit이 한 개 생겼어요. parent 두 개. **3-way merge의 결과** — H2에서 본 그림이에요. **conflict이 무서운 게 아니라 conflict 표시를 못 읽는 게 무서운 거예요.** 한 번 만나면 평생 안 무서워요. 본인은 방금 한 번 만났어요. 이미 무섭지 않습니다.

merge 도중 후회하면 — `git merge --abort` 한 줄. 모든 게 merge 시작 전 상태로 돌아가요. **빨강 명령어가 아니에요.** 안전한 취소. 본인이 conflict이 너무 많아 무서워졌을 때 abort 한 번 두드리고 잠시 숨 쉬고 다시 시도하세요.

---

## 8. 사고 내고 reflog로 살리기 — 무서운 명령어 한 번 만나기

이제 H4의 빨강 명령어를 일부러 두드려 봐요. 안전한 데모니까 잃을 게 없어요.

```bash
git log --oneline
```

출력(예):
```
8888888 (HEAD -> main) merge: 까미 색깔 표기 통일
777aaaa feat: 까미 색깔 턱시도 추가
77baaaa feat: 까미 색깔 검정 추가
7777777 feat: 미니 카드 추가
def5678 feat: 노랭이 카드 추가
9abcdef feat: 까미 까드 추가
abc1234 feat: 첫 README 추가
```

7개 commit. 이제 **`reset --hard`로 4개를 한 번에 날려 봅시다.**

```bash
git reset --hard 7777777
git log --oneline
```

출력:
```
7777777 (HEAD -> main) feat: 미니 카드 추가
def5678 feat: 노랭이 카드 추가
9abcdef feat: 까미 카드 추가
abc1234 feat: 첫 README 추가
```

**4개 commit이 사라졌어요.** main이 7777777로 돌아갔고, 그 위 4개는 history에서 안 보여요. `cat README.md`도 미니까지만 있어요. 까미 색깔도 사라짐. **한 줄로 4개 commit을 날린 거예요.** 회사에서 야근에 두드리면 등에서 식은땀이 나는 명령어. 본인이 지금 그걸 안전하게 두드렸어요.

이제 살려 봐요.

```bash
git reflog
```

출력:
```
7777777 HEAD@{0}: reset: moving to 7777777
8888888 HEAD@{1}: commit (merge): merge: 까미 색깔 표기 통일
777aaaa HEAD@{2}: commit: feat: 까미 색깔 턱시도 추가
...
```

**HEAD@{1}에 reset 직전의 위치(8888888)가 남아 있어요.** reflog는 HEAD가 지나간 모든 자취. 90일 보관. 본인의 사고 직전 위치를 1초 만에 찾을 수 있어요.

```bash
git reset --hard 8888888
git log --oneline
```

출력:
```
8888888 (HEAD -> main) merge: 까미 색깔 표기 통일
777aaaa feat: 까미 색깔 턱시도 추가
77baaaa feat: 까미 색깔 검정 추가
7777777 feat: 미니 카드 추가
def5678 feat: 노랭이 카드 추가
9abcdef feat: 까미 카드 추가
abc1234 feat: 첫 README 추가
```

**4개 commit이 다시 살아났어요.** 한 줄짜리 응급실. 본인이 한 번 두드려 봤으니 회사에서 사고 났을 때 손가락이 자동으로 reflog를 칠 거예요. **이게 H5의 가장 비싼 30초**예요. 본인의 5년 차 사고 한 건을 미리 막은 거예요.

**잠깐 — 사고 친 후 commit하지 않은 working tree 변경은 어떻게 되나요?** 그건 **reflog로 못 살려요.** reflog는 commit 단위로만 자취를 남깁니다. commit 안 한 변경은 reset --hard 한 순간 사라져요. 그래서 reset --hard 두드리기 전에 `git status`로 commit 안 된 변경이 없는지 확인하는 습관이 필요해요. 또는 `git stash` 한 줄로 미리 숨겨 두기. 본인이 신중한 사람이라면 reset --hard 직전에 항상 `git stash push -m "before-reset"`을 두드려 두세요. 이 한 줄이 본인의 진짜 안전장치.

---

## 9. GitHub 원격 연결 — `git remote add` + 첫 push

지금까진 본인 노트북 안에서만. 이제 GitHub에 첫 push.

먼저 GitHub에서 빈 저장소 한 개 만들기. github.com/new에서 이름만 `git-demo`로 적고 README 체크박스는 **끄고**(이미 있으니까) "Create repository". **빈 저장소**가 만들어져요.

GitHub이 화면에 적어 주는 안내문 중 "...or push an existing repository from the command line" 섹션을 봅니다. 정확히 세 줄이에요:

```bash
git remote add origin git@github.com:GoGoComputer/git-demo.git
git branch -M main
git push -u origin main
```

한 줄씩 — `git remote add origin <URL>`은 본인 local 저장소에 "origin"이라는 별명으로 GitHub URL을 등록. **별명만 등록**하지 통신은 아직 안 해요. `git branch -M main`은 현재 가지를 main으로 강제 이름변경(이미 main이면 아무 일도 안 함). `git push -u origin main`이 진짜 통신 — local main을 origin의 main으로 보내요. `-u`(`--set-upstream`)가 본인 가지의 추적 대상을 origin/main으로 설정. 한 번만 해 두면 다음부턴 `git push` 한 줄로 충분.

H3에서 깐 SSH 키가 여기서 검증돼요. 비밀번호 안 묻고 Hi 한 줄과 함께 push가 됩니다. 셋업의 가치가 다시 한 번. **첫 push 한 줄이 본인의 첫 GitHub 흔적**이에요. 본인의 history.

```bash
git remote -v
```

출력:
```
origin  git@github.com:GoGoComputer/git-demo.git (fetch)
origin  git@github.com:GoGoComputer/git-demo.git (push)
```

원격 두 줄 — fetch와 push가 같은 URL이지만 분리될 수 있어요(예: 회사에선 다른 mirror로 push, 같은 URL에서 fetch). 지금은 같아요.

브라우저로 github.com/<you>/git-demo 열어 보세요. **본인이 두드린 7개 commit이 GitHub에 다 올라가 있어요.** README.md도 Markdown으로 예쁘게 렌더링돼요. **본인의 첫 자경단 데모**가 인터넷에 떠 있어요. 1995년 인터넷에 첫 페이지를 올린 사람의 감각과 같아요. 작은 한 걸음, 하지만 본인 평생의 GitHub 활동의 시작점.

---

## 10. 일상 협업 리듬 — feature 가지 → push → PR → merge

GitHub에 올라간 후 본인이 매일 두드릴 리듬을 한 번 시연.

```bash
git switch -c feat/cat-4-treasure
echo "## 길고양이 카드 4" >> README.md
echo "- 이름: 보물이" >> README.md
git add .
git commit -m "feat: 보물이 카드 추가"

git push -u origin feat/cat-4-treasure
```

H3에서 깐 `push.autoSetupRemote=true` 덕에 `-u`도 사실 생략 가능해요. 한 줄로 끝. `git push`만 두드려도 자동으로 origin에 같은 이름의 가지를 만들어 줘요. **본인의 손가락이 한 줄 줄어드는 평생 효과.** 셋업의 가치 또 한 번.

브라우저에서 github.com/<you>/git-demo로 가면 **노랑 배너로 "feat/cat-4-treasure had recent pushes"** + "Compare & pull request" 초록 버튼. 한 번 누르면 PR 페이지. PR 제목·본문·리뷰어를 정하고 "Create pull request". 본인의 첫 PR. 평생 회사에서 두드릴 그 동작이에요. **자경단 데모가 회사 첫 PR과 같은 화면**이에요.

PR이 만들어지면 GitHub Actions가 자동으로 CI를 돌려요(아직 .github/workflows/가 없으니 아무것도 안 도는 게 정상이지만, 한 번 .yml 파일을 추가하면 push마다 자동). Ch014에서 본격적으로. 지금은 PR 페이지의 "Merge pull request" 초록 버튼만 눌러요. **본인이 직접 `git merge`를 두드리지 않아도 GitHub이 대신해 줘요.** H4에서 본 자동화의 한 단면.

merge 후 local로 돌아와서:
```bash
git switch main
git pull
git branch -d feat/cat-4-treasure
```

`git pull`이 GitHub에서 방금 머지된 commit을 가져와요(`pull.rebase=true` 덕에 깔끔히 rebase). 끝난 가지는 안전 삭제. **자경단의 한 카드가 main에 안전히 흡수**됐어요. 회사 첫 PR도 똑같은 호흡.

---

## 11. .gitignore 한 장 — 비밀과 쓰레기 막기

데모 폴더에 일부러 비밀 파일을 만들어 봅시다.

```bash
echo "AWS_KEY=AKIA1234567890ABCD" > .env
git status
```

`git status`에 `.env`가 untracked로 떠요. **이 상태에서 `git add .`을 두드리면 비밀이 commit에 들어가요.** H3에서 본 가장 비싼 사고. 막아 봐요.

```bash
echo ".env" >> .gitignore
echo "*.bak" >> .gitignore
echo "node_modules/" >> .gitignore
echo ".DS_Store" >> .gitignore
git status
```

`.env`가 untracked 목록에서 사라졌어요! `.gitignore`만 한 개 떠 있어요. **git이 .env를 안 봐요.** 이 한 줄이 본인의 카드 청구서를 지킨 거예요.

```bash
git add .gitignore
git commit -m "chore: .gitignore 추가 (비밀·쓰레기 차단)"
git push
```

이제 .env가 실수로 commit될 일이 없어요. **하지만 한 가지 더 — 이미 commit된 비밀은 .gitignore가 못 막아요.** 비밀이 한 번 commit되면 history에 영원히 남아요(빨간 명령어 `git filter-repo`로만 지움 가능). **그래서 first commit 전에 .gitignore를 먼저 만드는 습관**이 필요해요. 이상적으론 `git init` 직후에 `.gitignore` 한 장을 만든 다음 첫 commit. 본인의 모든 새 저장소에서 첫 다섯 줄이 이 패턴.

자경단의 진짜 사이트엔 어떤 .gitignore가 들어가나요? — Python(`__pycache__/`·`*.pyc`·`venv/`), Node.js(`node_modules/`·`*.log`), 빌드 산출물(`dist/`·`build/`), OS(`.DS_Store`·`Thumbs.db`), 에디터(`.vscode/settings.json` 일부·`.idea/`), 비밀(`.env`·`*.pem`·`secrets/`). 5부류. H3에서 본 5부류 — 이제 손가락에 닿았어요.

---

## 12. 자주 만나는 5가지 작은 사고와 한 줄 처방

**사고 1: "방금 commit했는데 메시지를 잘못 적었어요."**
처방: `git commit --amend -m "고친 메시지"`. 단, **이미 push했다면** force-push가 필요한데 공유 가지엔 위험. push 전에만 amend.

**사고 2: "잘못된 파일을 staging에 올렸어요."**
처방: `git restore --staged <파일>`. 또는 옛 명령어 `git reset HEAD <파일>`. working tree의 파일은 그대로, staging에서만 빠짐.

**사고 3: "방금 만든 commit을 한 개 빼고 싶어요(살리되 commit만 취소)."**
처방: `git reset --soft HEAD~1`. **--soft**가 핵심 — 변경은 staging에 그대로, commit만 취소. 메시지를 고쳐 다시 commit하면 됨. **--hard와 --soft를 절대 헷갈리지 마세요.** --hard는 빨강.

**사고 4: "잘못된 가지에 commit해 버렸어요."**
처방: `git switch -c new-branch && git switch - && git reset --hard HEAD~1 && git switch new-branch`. 한 호흡. (1) 새 가지 만들고 (2) 잘못된 가지로 돌아와서 (3) 한 칸 reset (4) 다시 새 가지로. 본인의 commit은 새 가지에 살아있어요. 빨강이지만 잘못된 가지에서 1칸 reset이라 비교적 안전.

**사고 5: "PR 만들기 전에 commit 5개를 1개로 합치고 싶어요."**
처방: `git rebase -i HEAD~5`. 인터랙티브 rebase. 표 편집기처럼 5개 commit 옆에 `pick`을 `squash`로 바꾸면 한 개로 합쳐져요. 본인 가지에서만, 공유 후엔 금지. 그리고 합친 후 `git push --force-with-lease`로 PR을 깔끔히 갱신.

이 5가지가 본인의 1년치 사고의 80%예요. 한 줄짜리 처방을 손가락에 두면 사고가 사고처럼 안 느껴져요. **사고가 일상의 한 줄**이 되는 게 5년 차의 평정심입니다.

---

## 13. 자경단 적용 — 데모를 진짜 사이트로 옮기기

본인이 자경단 사이트의 실제 폴더에서 같은 호흡을 두드리면 끝나요. `~/dev/cat-vigilante` 같은 진짜 폴더에서 — `git init`(또는 이미 했다면 생략) → 첫 페이지 5개 commit → GitHub에 빈 저장소 만들고 `remote add` → `push -u origin main`. 30분이면 본인의 자경단 사이트가 GitHub에 떠요. **본 코스 18챕터분 코드 진화의 첫 한 걸음**입니다.

다음 H6(저장소 운영)에선 GitHub의 Issue·PR·Project·Discussions를 본격적으로 다뤄요. H5에서 본인이 만든 git-demo 저장소가 거기서 자경단의 Issue 보드로 진화해요. 본인이 길고양이 한 마리 신고를 Issue로 받고, 가지를 따고, PR로 합치고, Project 보드의 "Done" 칸으로 옮기는 그 흐름. **모든 게 H5의 30분 위에 쌓여요.**

또 한 가지 — H5의 git-demo 폴더는 본인의 평생 학습 저장소로 남겨 두세요. 새 git 명령어를 배울 때마다 이 폴더에서 한 번 두드려 보세요. 안전한 실험실. 본인이 5년 차가 돼서도 가끔 새 명령어를 만나면 이 폴더로 돌아와 한 번 두드려 보는 습관. **본인의 git 일기장이에요.**

---

## 14. H5와 H6의 연결 — 손가락에서 운영으로

H5는 본인의 손가락. H6는 운영. **본인이 두드린 commit이 인터넷에 떠 있다는 사실이 운영의 시작**이에요. H6에선 GitHub의 협업 도구(Issue·PR·Review·Project·Actions·Pages)를 깊게 봐요. H5의 한 호흡이 그 도구의 토양. 본인이 H5를 30분 두드려 봐야 H6가 손에 닿아요. 안 두드리고 H6를 읽으면 안 돼요. **이 H5는 읽는 시간이 아니라 두드리는 시간**이에요. 본인이 지금 따라 두드리지 않았다면 잠깐 멈추고 빈 폴더 만들고 한 번 두드린 후에 H6로 넘어가세요. 5년 차의 모든 git 감각이 여기서 시작합니다.

---

## 15. 흔한 오해 5가지

**오해 1: "데모는 따라치지 않고 읽기만 해도 돼요."** — 절대 안 돼요. 손가락에 박힐 때까지는 본인의 무의식이 git을 안 알아요. 한 번이라도 따라치세요. 30분 투자가 5년 차로 가는 가장 빠른 길.

**오해 2: "reset --hard는 절대 두드리면 안 돼요."** — 위에서 본 데모처럼 안전한 환경에선 한 번 두드려 봐야 두려움이 줄어요. 본인 가지에서 본인 commit만 reset하는 건 일상이에요. 빨강 신호등은 "두드리지 말라"가 아니라 "두 번 보고 두드리라"입니다.

**오해 3: "conflict이 나면 일이 망한 거예요."** — 아니에요. conflict은 git이 정상적으로 본인에게 결정을 넘겨주는 거예요. 무서운 게 아니라 **두 사람의 의도가 다를 때 자동으로 강제 합치지 않고 본인에게 묻는** 안전 장치. 한 번 만나면 평생 안 무서워요.

**오해 4: "PR은 회사에서나 쓰는 거고 개인 프로젝트엔 필요 없어요."** — 본인 혼자라도 PR을 쓰는 게 좋아요. **본인이 본인 코드를 한 번 더 보는 1차 자기 리뷰**예요. main에 직접 commit하는 것보다 feature 가지 → PR → 본인 셀프 머지가 5년 차로 가는 패턴. 자경단도 그렇게.

**오해 5: "GitHub은 백업이에요."** — 절반 맞아요. GitHub이 사라질 일은 거의 없지만, GitHub이 본인 계정을 정지시키면 본인의 모든 저장소가 안 보여요(드물지만 일어나요 — 약관 위반·결제 실패). **`git clone`은 사실 풀 백업이에요.** 본인 노트북에 클론해 둔 폴더 자체가 모든 history를 가져요. GitHub + 노트북 + 외장 디스크 백업이 진짜 안전 — 분산 저장소(distributed)가 git의 본질이라는 게 여기서 진가를 발휘해요.

---

## 16. FAQ 5가지

**Q1. `git init` 대신 `git clone`을 써야 할 때는요?**
A. 빈 폴더에서 새로 시작하면 `git init`. 누군가가 만든 저장소를 받아오면 `git clone <URL>`. **clone은 init + remote add + fetch + checkout이 한 줄**에 들어 있어요. 본인이 자경단 회사에 입사하면 첫 일은 회사 저장소를 clone하는 거예요. init은 본인이 새 사이드 프로젝트를 시작할 때.

**Q2. 데모를 따라치다가 망쳤어요. 다시 시작하고 싶어요.**
A. `cd ~/playground && rm -rf git-demo && mkdir git-demo && cd git-demo && git init`. 한 줄로 0번 상태로. .git 폴더를 통째로 지우면 git이 사라지고, 그 후 init으로 다시 시작. 본인의 학습 폴더라서 자유롭게 망치고 다시 시작하세요. **여러 번 시작하는 게 학습**입니다.

**Q3. SSH 대신 HTTPS로 push하고 싶어요. 어떻게요?**
A. `git remote set-url origin https://github.com/<you>/git-demo.git`. URL을 HTTPS로 바꾸기. 그 다음 push할 때 GitHub username과 PAT(Personal Access Token, 비밀번호 아님)를 묻습니다. credential helper를 깔아 두면 한 번만 묻고 다음부터 자동(H3 참조). 단, **2026년 현재 SSH가 권장**이에요. 회사 방화벽 등 특수 상황에선 HTTPS.

**Q4. push 했는데 GitHub에서 안 보여요.**
A. (1) `git status`로 commit이 정말 됐는지 확인. (2) `git remote -v`로 origin URL이 맞는지 확인. (3) `git log origin/main..main`으로 push 안 된 commit이 있는지 확인. (4) 브라우저 캐시. 5초 새로고침. 90% 이 네 가지 중 하나. 그래도 안 되면 force-push가 막혔거나 권한 문제일 가능성 — `git push origin main`의 출력 줄을 다시 읽어 보세요. 에러 메시지에 답이 있어요.

**Q5. 데모 폴더를 지워도 되나요?**
A. 학습 끝났으면 지워도 돼요. **GitHub의 git-demo 저장소도 지워도 돼요(github.com 저장소 Settings → Delete repository 빨강 버튼).** 본인의 진짜 자경단 저장소는 다른 폴더·다른 이름으로 따로 만드세요. 하지만 위에서 권장한 대로 **학습 실험실로 git-demo를 평생 남겨 두는 패턴**이 더 좋아요. 빈 폴더 만드는 게 30초이지만 한 번 만들어 둔 폴더에서 30번 실험하는 게 30번 새 폴더 만드는 것보다 효율적이에요.

**보너스 Q: `git pull`이 자꾸 conflict을 만들어요. 어떻게 막나요?**
A. 본인이 push 전에 `git pull --rebase`(또는 H3에서 깐 `pull.rebase=true` 덕에 그냥 `git pull`)를 두드려서 동료 변경을 미리 받아오세요. push 직전에 한 번 더 pull. **push와 pull의 간격이 짧을수록 conflict이 적어요.** 일주일에 한 번 push하면 conflict 폭발, 하루에 한 번 push하면 거의 없음. 자주 push하는 게 안전.

---

## 17. 흔한 실수 다섯 가지 + 안심 멘트 — Git 데모 학습 편

Git 데모 따라하며 자주 빠지는 함정 다섯.

첫 번째 함정, finish 폴더 먼저 본다. 안심하세요. **start에서 30분 시도 후 막힐 때만.** 정답 통째로 보면 학습 0%.

두 번째 함정, 명령 한 줄 치고 결과 확인 안 함. 안심하세요. **매번 git status 한 번씩.** 본인 작업 상태가 한 화면.

세 번째 함정, commit 후 push 잊는다. 안심하세요. **commit은 로컬, push가 원격.** 두 단계 분리.

네 번째 함정, conflict에 좌절. 안심하세요. **conflict는 정상.** Git이 결정 도와달라는 신호. <<<<<<< 사이를 본인이 고치고 add → commit.

다섯 번째 함정, 가장 큰 함정. **첫 PR을 부끄러워한다.** 본인이 완벽하게 만들려고. 안심하세요. **PR은 대화의 시작.** 30% 완성도 → 리뷰 → 고침 → 머지. OSS 표준 워크플로.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 18. 추신

데모는 한 번이 아니라 세 번 두드리세요. 첫 번은 30분, 두 번째는 15분, 세 번째는 7분. 세 번째에 본인 손가락이 무의식으로 들어가요. `git status`를 두드리고 또 두드리세요 — 본인이 두드린 명령어의 두 배만큼 status를 두드려도 시간 낭비 아니에요. 모든 사고의 90%를 막아 줍니다. 사고가 났을 때 첫 단어는 `reflog`, commit 전 마지막 검문소는 `git diff`, force-push는 본인 가지에 한정 + 매번 `--force-with-lease`. `.gitignore`는 첫 commit 전에 박아야지 첫 commit 후엔 늦어요.

가지는 자유롭게 만들고 자유롭게 지우세요. 본인 가지는 본인의 사적 공간. main만 안 망치면 됩니다. PR 본문에 한 줄 그림(스크린샷·diff·테스트 결과)이 있으면 리뷰 시간이 절반으로 줄어요. commit 메시지는 한 팀 안에선 한 가지로 통일하시고, Conventional Commits(`feat:`·`fix:`·`chore:`·`docs:`·`refactor:`·`test:`·`style:`)를 표준으로 두면 자동화·릴리스 노트 생성에 유리해요.

본인의 git-demo 폴더를 평생 학습 실험실로 두세요. 한 폴더가 본 코스의 18챕터분 코드 진화의 모태예요. 회사 첫 PR을 만드는 날, 이 H5의 13줄 흐름이 손가락에 자동으로 떠올라요. 자경단에서 30번 두드린 손가락이 회사 첫 날에도 침착해요. 그리고 데모를 친구·동료에게 가르쳐 보세요 — 가르침이 학습의 가장 깊은 형태입니다. 다음 H6에서 운영의 시간으로. 🐾
