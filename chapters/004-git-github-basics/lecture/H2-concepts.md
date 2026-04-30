# H2 · Git & GitHub 기본 — 핵심 개념 4 깊게

> 고양이 자경단 · Ch 004 · 2교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 들어가며 — H1 회수와 H2 약속
2. Snapshot 깊게 — Git이 진짜로 저장하는 것 (blob·tree·commit 3종 객체)
3. Commit 객체의 다섯 필드 — `git cat-file -p` 첫 시연
4. Branch는 한 줄짜리 텍스트 파일이다 — `.git/refs/heads/main`을 직접 cat
5. HEAD의 두 모드 — attached와 detached
6. Working tree · Staging area · Repository — 세 영역의 정체
7. Merge 깊게 — fast-forward vs three-way
8. Rebase 깊게 — 사진을 다시 줄 세우기
9. Merge vs Rebase — 언제 무엇을
10. Fetch · Pull · Push 깊게 — origin과 local의 동기화
11. SHA-1 해시 — 왜 40글자인가, 충돌 가능한가
12. 흔한 오해 다섯 개
13. FAQ 다섯 개
14. 자경단 적용 + 다음 시간 예고
15. 흔한 실수 다섯 가지 + 안심 멘트 — Git 핵심 학습 편
16. 한 줄 정리 + 추신

---

## 🔧 강사용 명령어 한눈에

```bash
# 2교시 시연 — 이전 시간에 만든 cat-hello 폴더에서 그대로
cd cat-hello
cat .git/HEAD                              # ref: refs/heads/main
cat .git/refs/heads/main                   # sha 한 줄
ls .git/objects/                           # 처음 두 글자 폴더들
git cat-file -t <sha>                      # 객체 종류 (commit/tree/blob)
git cat-file -p <sha>                      # 객체 내용 풀어 보기
git log --oneline --graph --all
git branch feature-x                       # 0.001초
git switch feature-x                       # HEAD 옮김
echo "v2" >> README.md && git commit -am "v2"
git switch main
git merge feature-x                        # fast-forward
git switch -c feature-y
echo "y" > y.txt && git add y.txt && git commit -m "y"
git switch main
echo "main" >> README.md && git commit -am "main change"
git merge feature-y                        # three-way merge
git log --oneline --graph --all
# rebase 시연
git switch -c feature-z
echo "z" > z.txt && git add z.txt && git commit -m "z"
git rebase main                            # 부모를 main 끝으로 옮김
```

---

## 1. 들어가며 — H1 회수와 H2 약속

자, H2에 오신 걸 환영해요. 지난 H1에 사진앨범 비유 한 장과 5단어 비유 사전(snapshot·HEAD·branch·remote·.git)을 깔아 드렸죠. 그리고 5줄 미니 commit을 본인 손으로 쳐 보셨고요. `mkdir cat-hello && cd cat-hello && git init && echo > README.md && git add . && git commit -m "first"`. 이 5줄 끝에 본인 손에 미니 사진앨범 한 권이 만들어졌어요. 오늘 H2는 그 앨범의 **속**을 들여다봅니다. 비유 한 장 위에 진짜 데이터 구조 하나씩 올려요. 약속은 세 가지입니다. 하나, **`.git/` 폴더를 직접 열어 보면서 Git이 무엇을 어디에 저장하는지를 한 화면으로 그릴 수 있게** 만들어 드립니다. 마법이 정직한 파일 시스템으로 변해요. 둘, **branch가 사실 한 줄짜리 텍스트 파일이라는 사실을 본인 눈으로 확인하게** 만들어 드립니다. 이 한 줄이 충격이고, 그 충격 한 번에 Git의 절반이 풀려요. 셋, **merge와 rebase의 차이를 한 그림으로 설명할 수 있게** 만들어 드립니다. 이 둘이 Git에서 가장 자주 헷갈리는 짝인데, H2 끝에 둘이 갈라집니다. H2는 H1보다 빡빡한 한 시간이에요. 모델이 한꺼번에 들어가요. 처음 만나면 머리가 무거워질 수 있어요. 정상입니다. 한 번에 70% 들어오면 본전이고, 나머지 30%는 H4·H5에서 손에 박히면서 따라옵니다. 한 가지만 약속드릴게요. 오늘 시간 이후 본인이 `git log --graph`를 봤을 때 그 그림이 외계어가 아니라 "아, 이 commit이 이 branch의 끝이고, 저 commit이 저 branch에서 갈라져 나왔구나"가 읽혀야 해요. 그게 H2의 진짜 결과물입니다. 자, 시작합시다.

## 2. Snapshot 깊게 — Git이 진짜로 저장하는 것 (blob·tree·commit 3종 객체)

H1에서 "Git은 매 commit마다 폴더 전체의 사진을 찍는다"고 말했어요. 그 사진이 어떻게 디스크에 누워 있는지를 봅시다. Git은 모든 것을 **객체(object)**로 저장해요. 객체에는 네 종류가 있어요. 이 시간엔 그중 셋만 봅니다. 넷째인 tag는 H8에서 다뤄요. **첫째 — blob.** "Binary Large OBject"의 줄임. 파일 한 개의 내용이에요. README.md의 내용 그 자체. 디렉터리 구조나 파일명은 안 들어 있고, 오직 **내용 바이트**만. 같은 내용의 파일은 두 번 저장되지 않아요. 본인이 같은 README.md를 100번 commit해도 blob은 1개만 저장됩니다. 영리해요. **둘째 — tree.** 폴더 한 개의 목록이에요. "이 폴더 안에 README.md라는 이름이 abc1234 blob을 가리키고, src라는 이름이 def5678 tree를 가리킨다"는 한 줄짜리 표. tree가 tree를 가리킬 수 있어요(폴더 안의 폴더). 그래서 폴더 구조 전체가 tree들의 그래프로 표현됩니다. **셋째 — commit.** 다섯 필드(다음 절에서 봐요)로 구성된 메타데이터인데, 핵심은 **루트 tree 한 개를 가리킨다**는 거예요. 그러니까 commit이 가리키는 root tree를 따라가면 그 commit 시점의 폴더 전체가 풀려나옵니다. 자, 이 셋이 어떻게 디스크에 누워 있냐. 본인 cat-hello 폴더에서 다음 한 줄을 쳐 보세요.

> ▶ **같이 쳐보기** — Git 의 객체 창고 안 한 번 들여다보기
>
> ```bash
> ls .git/objects/
> ```

처음 두 글자가 폴더 이름인 디렉터리들이 줄줄이 보일 거예요. `ab/`, `cd/`, `ef/` 같은 식. 그 안에 들어가면 38글자짜리 파일이 있어요. **합치면 40글자 SHA-1 해시.** 이게 Git의 천재성이에요. 모든 객체가 자기 내용의 SHA-1 해시로 식별되고, 그 해시의 처음 두 글자가 폴더, 나머지 38글자가 파일명. 디렉터리당 파일 수가 폭발하지 않게 256개 폴더(00~ff)로 자동 분산되는 거예요. **content-addressable storage**라고 부릅니다. 같은 내용이면 같은 해시, 다른 내용이면 다른 해시. 같은 파일을 두 군데 두면 디스크엔 한 번만 저장됩니다. Linux 커널의 5만 파일짜리 repo가 디스크 1GB로 끝나는 비결이 이거예요. 한 가지 더 비교를 드리면, SVN 같은 옛 VCS는 "이 파일의 1년 전 버전을 보여 줘"가 디스크 한 번이 아니라 1년 치 변경 사항을 거꾸로 적용하는 작업이라서 느려요. Git은 그 시점의 tree sha 한 개만 따라가면 폴더 전체가 그대로 풀려요. O(1)에 가까운 시간복잡도. Git이 빠른 진짜 이유가 이거예요. 그리고 한 가지 더 — 객체 파일 내용은 zlib으로 압축돼 있어요. 그래서 그냥 `cat`으로 열면 깨진 글자가 보입니다. `git cat-file -p <sha>`를 써야 사람이 읽는 형태로 풀려요. 객체가 너무 많이 쌓이면 Git이 자동으로 `git gc`를 돌려서 객체들을 packfile 한 개로 묶어요. `.git/objects/pack/` 안에 `pack-*.pack`과 `pack-*.idx`가 그거예요. 풀어진 객체(loose object)가 압축률이 낮은데, packfile은 비슷한 객체끼리 delta 압축으로 묶어서 디스크를 더 줄여요. H7에서 packfile을 직접 열어 봅니다. 다음 한 줄을 쳐 보세요.

> ▶ **같이 쳐보기** — commit 객체의 진짜 내부 한 번 풀어 보기
>
> ```bash
> git log --oneline | head -1
> # 첫 sha (예: abc1234) 를 복사
> git cat-file -p abc1234
> ```

출력이 다섯 줄쯤 떠요. tree 한 줄, parent 한 줄(있으면), author 한 줄, committer 한 줄, 빈 줄, 메시지. 그게 commit 객체의 진짜 모양입니다. 다음 절에서 한 필드씩 풀어 봅시다.

## 3. Commit 객체의 다섯 필드 — `git cat-file -p` 첫 시연

`git cat-file -p <commit-sha>`의 출력은 보통 이렇게 생겼어요.

```
tree 9d1f2c3a8b7e4f5d6e3c2b1a0f9e8d7c6b5a4938
parent f81d70c0e1d2c3b4a5968778695a4b3c2d1e0f9a
author GoGoComputer <gogo@local> 1714200000 +0900
committer GoGoComputer <gogo@local> 1714200000 +0900

Ch003 H8: new 17k chars + Ch003 완료
```

다섯 필드 한 줄씩. **tree.** 이 commit 시점의 루트 폴더를 표현하는 tree 객체의 sha예요. 이 sha를 다시 `git cat-file -p`하면 그 시점 루트 폴더의 목록이 풀려요. blob과 sub-tree가 줄줄이. **parent.** 부모 commit의 sha. 첫 commit(root commit)은 parent가 없고, 일반 commit은 parent 한 개, **merge commit은 parent 두 개**예요. parent가 두 개라는 게 merge의 결정적 시그니처입니다. 나중에 보면 "어, parent가 두 줄이네 = 머지구나"가 한눈에 들어와요. **author.** 누가 이 변경을 **저자**로 만들었는지. 이름·이메일·유닉스 시각·타임존. 1714200000은 epoch 시간이고, +0900은 한국 시간대(UTC+9)예요. **committer.** 누가 이 commit을 **기록**했는지. 보통 author와 같지만, rebase나 cherry-pick을 하면 committer는 본인이고 author는 원래 사람으로 갈라져요. 그래서 두 필드를 따로 둔 거예요. **메시지.** 빈 줄 다음 줄부터가 메시지. 첫 줄이 제목, 빈 줄, 본문. Git의 모든 표시(`git log`, `git show`)가 이 다섯 필드를 다양하게 펴서 보여 주는 거예요. 한 가지 충격 포인트 — **commit의 sha는 이 다섯 필드의 내용으로 계산돼요.** 그래서 같은 변경을 같은 시간에 같은 사람이 두 번 commit해도, 시각이 1초만 달라도 sha가 완전히 달라집니다. 이게 Git이 변조 불가능한 이유예요. 누가 history 중간 commit의 글자 한 개만 몰래 바꾸면, 그 commit의 sha가 변하고, 그러면 그 commit을 부모로 가리키는 다음 commit의 parent 줄이 안 맞고, 그 다음 commit의 sha도 다 흔들리고, history 끝까지 도미노가 무너져요. **블록체인이 Git의 이 모델을 빌려간 거예요.** 사실 Git이 먼저였습니다. 2005년. 비트코인이 2008년이니까 3년 빨라요. 한 commit이 부모 sha를 포함하고, 부모 commit이 또 그 부모 sha를 포함하는 사슬 — 이걸 Merkle DAG(Merkle 방향성 비순환 그래프)라고 불러요. Git의 history 전체가 하나의 거대한 Merkle DAG입니다. 그래서 본인이 `git pull`로 받은 commit이 GitHub에 있는 그 commit과 같은 내용인지를 sha 한 개 비교로 즉시 확인할 수 있어요. 위변조 검증이 sha 한 글자로 끝납니다. 자, 이 다섯 필드만 머리에 박히면 Git의 절반이 풀린 겁니다. tree·parent·author·committer·message. 노트에 적어 두세요. 그리고 한 가지 실용 — 본인 자경단 repo에서 가장 최근 commit의 다섯 필드를 한 번 보고 가시는 게 좋아요. `git cat-file -p HEAD`. 출력에서 tree sha 한 개를 복사해서 다시 `git cat-file -p <tree-sha>`를 치면, 그 시점 루트 폴더의 목록이 풀려나옵니다. blob과 sub-tree가 줄줄이 나와요. 한 번 더 sub-tree sha로 들어가면 그 폴더 안의 목록. 객체 그래프를 본인 손으로 따라 내려가는 경험이에요. 5분 걸려요. 그 5분이 H7의 한 시간을 미리 절반 끝내 줍니다.

## 4. Branch는 한 줄짜리 텍스트 파일이다 — `.git/refs/heads/main`을 직접 cat

이제 H2의 가장 충격적인 한 절이에요. 본인이 main 브랜치, develop 브랜치, feature/cat-card 브랜치 — 이름만 들어도 무거운 단어들. 이 브랜치들이 디스크에 어떻게 누워 있을까요. 다음 한 줄을 쳐 보세요.

> ▶ **같이 쳐보기** — main 브랜치의 진짜 정체: 한 줄짜리 텍스트 파일
>
> ```bash
> cat .git/refs/heads/main
> ```

출력은 한 줄. **40글자 sha 한 개.** 그게 다예요. 다른 줄이 없어요. **브랜치 = `.git/refs/heads/<이름>` 안에 적힌 sha 한 개.** 그러니까 main 브랜치는 "이 저장소의 main이라는 이름은 9e89ce6 commit을 가리킨다"는 한 줄짜리 정보예요. 디스크 사용량 41바이트(40글자 + 줄바꿈). 이게 충격이에요. 회사에서 "브랜치 너무 많이 따지 마라, 무거우니까"라고 말하는 사람이 있다면 그 사람은 다른 VCS의 잔재예요. Git의 브랜치는 **0.001초에 만들고 41바이트 차지하고 0.001초에 지웁니다.** 그래서 부담 없이 자주 따라는 황금률이 있는 거예요. 한 가지 더 — 본인이 새 브랜치를 만들면 어떤 일이 일어나냐. `git branch feature-x`. 이 한 줄이 하는 일은 단 하나, `.git/refs/heads/feature-x`라는 새 파일을 만들고 그 안에 현재 HEAD가 가리키는 commit의 sha를 적어 넣는 거예요. 끝. 객체는 안 만들어집니다. blob도 tree도 commit도 새로 안 생겨요. 이미 있던 commit 한 개를 가리키는 라벨이 한 개 더 붙는 것뿐이에요. **브랜치는 commit에 붙은 포스트잇이다.** 노트에 적어 두세요. 사진앨범의 어떤 사진에 "main"이라는 노란 포스트잇과 "develop"이라는 파란 포스트잇이 동시에 붙어 있을 수 있어요. 같은 commit. 그러다가 본인이 main에서 새 commit을 하면 main 포스트잇이 새 사진으로 옮겨 가고, develop 포스트잇은 그대로 있어요. 두 라벨이 갈라집니다. 그게 분기예요. `git branch -d feature-x`로 브랜치를 지우면? `.git/refs/heads/feature-x` 파일 한 개가 삭제되는 것뿐이에요. commit 객체는 그대로 살아 있어요(reflog 30일이 지나야 garbage collection 대상). 그래서 실수로 브랜치를 지워도 reflog에서 sha만 알면 살릴 수 있습니다. H6에서 깊게 봐요. 자, 이 한 절이 H2의 핵입니다. **브랜치 = 한 줄짜리 포스트잇.** 이 그림이 박히면 `git branch`, `git switch`, `git merge`, `git rebase`가 다 작은 일로 보입니다. 무서울 일이 사라져요.

## 5. HEAD의 두 모드 — attached와 detached

브랜치가 commit을 가리키는 포스트잇이라면, **HEAD는 본인이 지금 어디를 보고 있는지를 가리키는 손가락**이에요. `cat .git/HEAD`를 쳐 보세요. 보통 한 줄이 떠요.

```
ref: refs/heads/main
```

이게 **attached HEAD** 상태예요. HEAD가 main 브랜치를 "가리키고", main 브랜치가 commit을 "가리키는" 두 단 구조. 두 단을 거쳐서 HEAD는 결국 commit에 도달해요. 본인이 새 commit을 하면 어떤 일이 일어나냐. (1) 새 commit 객체가 만들어져요. (2) main 브랜치(`.git/refs/heads/main` 파일)의 sha가 새 commit으로 갱신돼요. (3) HEAD는 여전히 `ref: refs/heads/main`이에요. HEAD 자체는 안 바뀌어요. main이 바뀐 거예요. 그래서 HEAD가 자동으로 새 commit을 따라가요. 두 단 구조의 묘미예요. 그럼 **detached HEAD**는 뭐냐. `git checkout <과거-sha>`처럼 특정 commit을 직접 가리키게 하면, `.git/HEAD` 파일의 내용이 바뀌어요.

```
9d1f2c3a8b7e4f5d6e3c2b1a0f9e8d7c6b5a4938
```

`ref: refs/heads/...`가 아니라 sha 한 개. 이게 detached HEAD예요. "어떤 브랜치도 거치지 않고 직접 commit을 가리키는" 상태. 위험한 건 아니에요. 그냥 "지금 보고 있는 사진은 어떤 브랜치 끝이 아닌, 과거의 한 사진일 뿐"이라는 표시예요. 다만 이 상태에서 새 commit을 하면 그 commit은 **어떤 브랜치도 가리키지 않는** 고아 commit이 됩니다. 본인이 다른 브랜치로 switch하면 그 고아 commit은 reflog에만 남고 30일 뒤 garbage collection 대상이 돼요. 그래서 detached HEAD에서 작업한 결과를 살리려면 `git switch -c new-branch`로 그 commit에 새 브랜치 라벨(포스트잇)을 붙여야 해요. 그러면 그 라벨이 commit을 보호합니다. H1에서 "처음 만나면 무서운 메시지지만 알면 별것 아니에요"라고 했던 게 이거예요. 무서움의 정체는 "내 작업이 사라질지도 몰라"인데, 사실은 reflog 30일이 있고 brach 한 줄이면 살릴 수 있어요. **HEAD = `.git/HEAD` 안의 한 줄. attached면 ref:로 시작, detached면 sha 직접.** 노트에 적어 두세요. 한 가지 헷갈리지 않게 정리해 드리면 — `HEAD~1`은 HEAD의 부모 commit을 가리키고, `HEAD~2`는 할아버지, `HEAD^`은 HEAD~1의 다른 표기, `HEAD^2`는 merge commit의 두 번째 부모예요. `~`는 첫째 부모 사슬, `^`은 부모 선택. 처음엔 둘이 헷갈리는데, 한 줄 history에선 `HEAD~3 == HEAD^^^`이고, merge가 끼면 `^2`로 다른 갈래를 골라요. H4에서 표로 봅니다. 또 한 가지 — `git switch -`(하이픈 한 개)는 직전 브랜치로 돌아가는 단축이에요. cd의 `-`처럼 토글 동작. 본인이 main과 feature 사이를 오가는 작업에서 한 줄이 줄어요. 손에 익혀 두시면 평생 씁니다.

## 6. Working tree · Staging area · Repository — 세 영역의 정체

이번 절은 명령어 흐름의 핵심이에요. Git은 본인 폴더를 세 영역으로 나눠요. **Working tree(작업 트리).** 본인이 에디터로 열어서 글자를 치는 그 파일들. 디스크 위의 평범한 파일이에요. Git은 여기를 매번 보고 "어, 이 파일 바뀌었네"를 감지해요. **Staging area(스테이징, 또는 index).** "다음 commit에 무엇을 넣을 것인가"의 임시 칸. 디스크에는 `.git/index`라는 한 파일에 들어 있어요. `git add`가 working tree에서 staging area로 옮기는 동작이에요. **Repository(저장소).** `.git/objects/` 안의 모든 객체와 `.git/refs/` 안의 모든 라벨. 영구 저장소예요. `git commit`이 staging area의 내용을 묶어서 새 commit 객체를 만들고 repository에 넣는 동작이에요. 그래서 한 변경의 흐름은 이래요. **편집(working tree) → `git add`(staging) → `git commit`(repository) → `git push`(원격).** 네 단계. 각 단계가 분리돼 있는 이유는 (1) 한 번에 너무 많은 걸 commit하지 않게 골라서 add할 수 있게 하고, (2) 잘못 add한 걸 commit 전에 되돌릴 수 있게 하고(`git restore --staged <file>`), (3) 잘못 commit한 걸 push 전에 되돌릴 수 있게 하기(`git reset --soft HEAD~1`) 위해서예요. 각 영역 사이에 안전장치가 있어요. 그리고 한 가지 핵심 — `git diff`도 영역 사이를 비교하는 명령어예요. `git diff`(working ↔ staging), `git diff --staged`(staging ↔ repository), `git diff main..feature`(두 commit 사이). 같은 명령어가 어느 두 영역을 비교할지에 따라 다른 그림을 보여 줘요. H4에서 표로 봐요. 지금은 "세 영역 + 명령어가 영역 사이를 옮긴다"는 그림만 가져가세요.

## 7. Merge 깊게 — fast-forward vs three-way

이제 두 브랜치를 합치는 일을 봅시다. `git merge`. 두 종류의 merge가 있어요. **Fast-forward merge.** 가장 단순한 경우. 본인이 main에서 시작해서 feature 브랜치를 따고, feature에서 commit 두 개를 쌓고, 그 사이 main에는 새 commit이 없었어요. 그러면 main의 포스트잇을 그냥 feature 끝으로 옮기기만 하면 끝나요. 새 commit이 만들어지지 않아요. main이 feature를 따라잡는 거예요. 그래서 "fast-forward". history가 한 줄로 깔끔하게 이어집니다.

```
[fast-forward 전]
main: A
       \
       feature: A → B → C

[fast-forward 후]
main: A → B → C
       feature: A → B → C  (둘 다 C)
```

**Three-way merge.** main에 새 commit이 있고 feature에도 새 commit이 있는 경우. 둘이 갈라졌어요. 그러면 fast-forward로는 못 합쳐요. 새 merge commit 한 개를 만들어서 두 부모를 가리키게 해야 해요.

```
       A
      / \
   main: B   feature: C
      \ /
       M  (merge commit, parent = B와 C)
```

M이 merge commit이고, M의 commit 객체에는 parent 줄이 두 개예요(`parent B`, `parent C`). 그래서 `git log --graph`에서 두 줄이 합쳐지는 그림이 그려져요. Three-way라는 이름은 "공통 조상 A + B + C — 세 commit"을 보고 합친다는 뜻이에요. Git이 A의 내용을 기준으로 B의 변경과 C의 변경을 둘 다 적용해서 M의 내용을 만들어요. 두 변경이 같은 줄을 건드리면 **충돌(merge conflict)**이 나요. H6에서 깊게 봅니다. 자, 두 종류 차이를 한 그림으로 가져가세요. **Fast-forward = 한 줄 history, three-way = 두 줄이 합쳐지는 history.** 회사 컨벤션에 따라 "main에는 항상 merge commit을 만들어라(fast-forward 금지)"라는 정책이 있을 수 있어요. `git merge --no-ff`가 그걸 강제해요. 이유는 "한 PR이 main에 merge된 시점이 항상 한 commit으로 표시되어 추적이 쉽다"는 운영상의 이점이에요. 반대로 trunk-based 개발에서는 "fast-forward만 허용해서 history를 한 줄로 깔끔하게"라는 정책도 있어요. Ch005에서 두 정책을 비교합니다.

## 8. Rebase 깊게 — 사진을 다시 줄 세우기

`git rebase`는 처음 만나면 무서운 단어죠. 본질을 한 줄로 줄이면 — **"내 brunch의 commit들을 다른 base 위로 다시 옮겨 그린다."** 사진을 떼서 새 자리에 붙이는 거예요. 시나리오. main에서 갈라진 feature 브랜치에서 commit 세 개(X·Y·Z)를 쌓았어요. 그 사이 main에는 새 commit 두 개(B·C)가 들어왔어요.

```
main: A → B → C
       \
       feature: A → X → Y → Z
```

이때 `git rebase main`(feature 브랜치에 있을 때)을 치면 어떻게 되냐. Git이 X·Y·Z를 임시로 떼어 두고, feature를 main의 끝(C)으로 옮기고, X·Y·Z를 다시 차례로 적용해요. 결과:

```
main: A → B → C
                \
                feature: A → B → C → X' → Y' → Z'
```

X'·Y'·Z'는 X·Y·Z와 **같은 변경 내용**이지만 **다른 sha**예요. 부모가 바뀌었으니까(부모 sha가 commit 객체의 다섯 필드 중 하나니까 sha가 새로 계산돼요). 그래서 rebase는 **history를 다시 쓰는 작업**이에요. 위험한 이유가 이거예요. 만약 X·Y·Z가 이미 GitHub에 push돼 있고 동료가 그걸 받아서 작업 중이었다면, rebase 후 새 sha로 force push하면 동료의 history가 깨져요. 그래서 황금률 — **"이미 push해서 다른 사람과 공유 중인 commit은 절대 rebase 금지."** 본인 개인 브랜치에서만 rebase하세요. Rebase의 장점은 history가 한 줄로 깔끔해진다는 거예요. merge commit이 안 만들어지니까 `git log --graph`가 직선이에요. 책 한 권의 목차처럼 깨끗해요. 1년 뒤 본인이 또는 동료가 history를 위에서 아래로 내려 읽을 때 한 줄짜리 목차가 갈래로 갈라진 트리보다 훨씬 빨리 읽혀요. 운영 사고 시 "어느 commit부터 문제가 시작됐나"를 `git bisect`로 이등분 검색할 때도 직선 history가 절반의 시간으로 끝나요. 단점은 위에 말한 history 재작성 위험. 그래서 Git 커뮤니티엔 두 학파가 있어요. **"rebase 학파"**는 "main을 한 줄 history로 유지, 모든 PR을 squash + rebase로 합친다." **"merge 학파"**는 "history는 진실이다, 갈라졌으면 갈라진 대로 merge commit으로 기록한다." 둘 다 맞아요. 회사마다 다릅니다.

`git rebase -i HEAD~3`라는 인터랙티브 rebase는 더 강력해요. 최근 세 commit을 한 텍스트 에디터에 펴서 "이 commit은 squash로 합쳐, 이건 reword로 메시지만 바꿔, 이건 drop으로 빼"를 골라요. 본인 history를 출판 직전의 책처럼 다듬는 도구예요. 처음엔 무서워 보이지만 H6에서 한 번 같이 해 봅니다. 한 가지 안전 팁 — **rebase 들어가기 전에 항상 `git branch backup`으로 백업 라벨 한 개 붙이세요.** 그러면 망쳐도 그 라벨로 돌아갈 수 있어요. 41바이트짜리 안전장치예요.

## 9. Merge vs Rebase — 언제 무엇을

자, 둘이 갈라집니다. 한 표로 정리해 봐요.

| | Merge | Rebase |
|---|---|---|
| 결과 history | 갈라졌다가 합쳐지는 그림 | 한 줄로 직선 |
| 새 commit | merge commit 한 개 (three-way 시) | 0개 (commit이 옮겨질 뿐) |
| 기존 sha | 그대로 보존 | 다시 계산 (위험) |
| 공유 브랜치에서 안전한가 | ✅ 안전 | ❌ 절대 금물 |
| 개인 브랜치에서 | OK | ✅ 깔끔 |
| 충돌 해결 | 한 번 (merge commit 만들 때) | 매 commit마다 한 번씩 |
| `git log --graph` | 갈래 보임 | 직선 |

**황금 규칙 두 줄로 줄이면:** (1) **이미 push해서 공유한 commit은 항상 merge.** (2) **내 개인 브랜치를 main의 최신에 맞춰 깔끔히 하려면 rebase.** 이 두 줄이 90% 커버해요. 회사 정책 따라 더 세밀해지지만 처음엔 이 두 줄이면 충분합니다. 한 가지 흔한 패턴 — **"feature 브랜치에서 작업 중에 main에 새 commit이 들어오면, feature에서 `git rebase main`으로 부모를 갱신, 그다음 feature를 main에 merge할 때는 squash merge."** 이게 trunk-based 개발의 일반 흐름이에요. Rebase로 깔끔히 만들고, merge로 한 commit으로 합친다. Ch005에서 깊게.

## 10. Fetch · Pull · Push 깊게 — origin과 local의 동기화

이제 원격과의 동기화를 봅시다. 세 명령어 — `git fetch`, `git pull`, `git push`. **Fetch.** 가장 안전한 동기화. GitHub의 변경을 본인 노트북으로 **다운로드만** 해 와요. 본인 working tree나 main 브랜치에는 손대지 않아요. 받은 정보는 `origin/main`이라는 **원격 추적 브랜치**에 저장돼요. `.git/refs/remotes/origin/main` 파일이 갱신될 뿐이에요. 본인은 `git log origin/main`으로 "GitHub에 뭐가 새로 왔나"를 안전하게 볼 수 있어요. **Pull.** 사실 `fetch + merge`(또는 `fetch + rebase`)의 합쳐진 명령어예요. 다운로드 + 자동 합치기. 자동이라서 편하지만 자동이라서 사고가 나요. 본인이 아침에 출근해서 바로 `git pull`부터 치는 습관이 있다면 그건 적당히 위험한 습관이에요. 어제 본인이 퇴근 직전에 commit을 쌓아 놨고 그 사이 동료가 같은 파일을 수정해서 push했다면, 아침의 `git pull` 한 줄로 자동 merge가 시도되고 충돌 마커가 working tree에 박힙니다. 차라리 `git fetch`로 변경만 가져온 뒤 `git log HEAD..origin/main`으로 "동료가 뭘 했나"를 한 줄씩 읽고, 그 다음에 의식적으로 merge나 rebase를 고르는 게 안전해요. 본인 로컬에 commit이 쌓여 있고 원격에도 새 commit이 들어왔으면 자동 merge가 시도되고, 충돌이 나면 working tree가 충돌 마커로 어중간한 상태가 됩니다. 그래서 안전 패턴은 — **`git fetch` 먼저 → `git log origin/main`으로 확인 → `git merge origin/main` 또는 `git rebase origin/main`.** 또는 한 줄로 `git pull --rebase`로 rebase 모드를 명시. **Push.** 본인 commit을 원격으로 올림. `git push origin main`은 "내 main을 origin의 main으로 올려라". 이게 거절되는 경우는 (1) 원격에 본인이 모르는 commit이 있을 때(non-fast-forward rejected). 그러면 fetch + rebase + push 순서로 풀어야 해요. (2) 원격이 protected branch라서 직접 push가 막혀 있을 때. PR을 통해서만 올라가게 만들어요. 회사 main이 보통 protected예요. **Force push.** `git push --force` 또는 더 안전한 `--force-with-lease`. 강제로 원격을 본인 로컬로 덮어써요. 공유 브랜치에서는 사고, 개인 브랜치에서는 일상. `--force-with-lease`는 "마지막으로 본 원격 sha와 지금 sha가 같을 때만 force"라서 동료가 그 사이에 push했으면 자동으로 거절돼요. 안전판이 한 겹 더 있는 거예요. **항상 `--force` 대신 `--force-with-lease`를 쓰세요.** 노트에 적어 두세요. 자, 세 명령어가 갈라졌어요. fetch=다운로드만, pull=다운로드+합치기, push=업로드. 이 세 동작이 본인 로컬 repository와 origin 사이의 모든 동기화를 다 합니다. H4에서 옵션 표로 깊게 봐요.

## 11. SHA-1 해시 — 왜 40글자인가, 충돌 가능한가

마지막으로 한 절. SHA-1 해시 이야기. Git이 모든 객체를 40글자 16진수 sha로 식별한다고 했어요. 이게 무슨 숫자냐면 — 16진수 40글자 = 160비트 = 2^160 가지 = 약 1.46 × 10^48가지예요. 우주의 별 개수(약 10^24)보다 10^24배 많아요. 본인이 평생 commit을 1초에 1억 개씩 해도 충돌 확률이 0에 가깝습니다. 그래도 SHA-1은 2017년 Google이 의도적 충돌(SHAttered 공격)을 발표하면서 암호학적으로 깨졌어요. 그래서 Git은 2018년부터 SHA-256으로 마이그레이션을 진행 중이에요. 다만 호환성 때문에 아직 기본은 SHA-1입니다. `git init --object-format=sha256`으로 새 repo는 256으로 시작할 수 있어요. 일상 사용엔 SHA-1으로도 충분히 안전합니다. 한 가지 실용 팁 — **40글자 다 칠 필요 없어요.** 처음 7글자만 쳐도 됩니다. `git show abc1234`. Git이 그 7글자로 시작하는 객체가 한 개뿐이면 자동으로 풀어 줘요. 두 개 이상이면 "ambiguous"라고 더 길게 쳐 달라고 해요. 보통 5,000 commit 미만의 레포는 7글자로 충분하고, 큰 레포는 8~10글자가 필요해질 수 있어요. `git config core.abbrev 8`로 표시 길이를 조정할 수 있습니다.

## 12. 흔한 오해 다섯 개

**오해 1 — "git pull은 그냥 동기화다."** 거짓. **fetch + 자동 merge(또는 rebase)**의 합. 자동이라 사고 가능. 안전 패턴은 fetch 먼저.

**오해 2 — "merge commit은 더럽다, 항상 rebase로 직선 만들자."** 학파에 따라 달라요. 작은 회사·trunk-based는 직선, 큰 회사·릴리스 단위는 merge commit이 진실. 둘 다 정답.

**오해 3 — "rebase는 위험하니 절대 쓰지 말자."** 거짓. 본인 개인 브랜치에서는 매일 써요. 위험한 건 **공유된** commit을 rebase하는 거예요. 위험한 건 force push지 rebase 자체가 아닙니다.

**오해 4 — "브랜치를 지우면 commit이 사라진다."** 거짓. 브랜치는 라벨일 뿐. commit은 reflog 30일 동안 살아 있어요. `git reflog`로 sha 찾고 `git branch new <sha>`로 라벨 다시 붙이면 살아납니다. H6 생명줄.

**오해 5 — "HEAD는 main과 같은 거다."** 다릅니다. **HEAD는 본인이 지금 보는 위치를 가리키는 손가락**, **main은 commit을 가리키는 포스트잇**. attached HEAD일 때 HEAD가 main을 통해 commit에 도달하는 두 단 구조예요. detached HEAD에서는 HEAD가 commit을 직접 가리켜요. 두 단어가 같은 것 아닙니다.

**오해 보너스 — "git status가 빨간 글씨면 망가진 거다."** 정상이에요. 빨강 = working tree에 변경이 있음. 초록 = staging에 변경이 있음. 정상 흐름의 단계 표시. 빨강을 무서워하지 마세요. 매일 100번 봅니다.

## 13. FAQ 다섯 개

**Q1. `git log --graph --all --oneline`이 너무 복잡해요.** 처음엔 다 그래요. 한 줄씩 읽으세요. 첫 글자가 `*`면 commit, `|`은 그 줄에 다른 브랜치가 지나간다는 표시, `\`나 `/`는 갈라짐 또는 합쳐짐. 5분 째려보면 그림이 풀립니다. `gitk` GUI를 보조로 쓰셔도 좋아요. macOS 기본 설치는 아니지만 `brew install git-gui` 하시면 깔립니다.

**Q2. squash merge·merge commit·rebase merge 셋 중 뭐가 좋아요?** 회사마다. 작은 자경단 같은 사이드 프로젝트는 **squash merge**가 가장 깨끗해요. 한 PR = 한 commit이 main에. 큰 회사는 merge commit으로 history 진실 보존. 어느 쪽도 정답이고 컨벤션이에요.

**Q3. 매번 fetch 먼저 치라는데 귀찮아요.** `git config --global pull.rebase true`로 pull을 자동 rebase 모드로 만들면 충돌 시에도 작업이 깔끔해져요. 또는 `git config --global pull.ff only`로 fast-forward 가능할 때만 자동 합치게 만들면 사고가 줄어요.

**Q4. `git cat-file -p`가 무슨 마법인가요?** Git의 객체 한 개의 내용을 사람이 읽는 형태로 풀어 보여 주는 명령어예요. blob이면 파일 내용, tree면 폴더 목록, commit이면 다섯 필드. H7에서 한 시간 동안 이 명령어로 `.git/`을 해부해요. 마법이 아니라 진단기입니다.

**Q5. force-with-lease가 정확히 뭐가 다른가요?** `--force`는 무조건 덮어쓰기. `--force-with-lease`는 "마지막으로 본 원격 sha == 현재 원격 sha"일 때만 덮어쓰기. 그 사이에 동료가 push했으면 거절돼요. 동료의 작업을 실수로 날리는 사고를 막아 줍니다. 키보드 매크로로 `gpfl`을 `git push --force-with-lease`로 묶어 두세요. 평생 안전해집니다.

**Q보너스. H1보다 어렵게 느껴져요.** 정상. H2는 모델 한꺼번에 들어가는 빡빡한 한 시간이에요. 70% 들어오면 본전이고, H4·H5에서 손에 박히면서 30%가 따라옵니다. 한 번에 다 가져가실 필요 없어요. 다섯 단어 — blob·tree·commit·branch=한줄·HEAD=손가락 — 만 가져가셔도 충분합니다.

## 14. 자경단 적용 + 다음 시간 예고

자, H2 모델을 자경단 사이트에 붙여 봅시다. 본인이 지금 작업 중인 `react-flask-ai-stack` repo에서 다음 한 줄을 쳐 보세요.

```bash
cat .git/HEAD
cat .git/refs/heads/main
git cat-file -p $(cat .git/refs/heads/main) | head -10
```

지금 본인의 main이 어떤 sha를 가리키는지, 그 commit의 다섯 필드가 어떻게 생겼는지가 한 화면에 펼쳐져요. **본인이 만든 commit 한 개가 객체 그래프의 한 점이고, main이라는 포스트잇이 그 점에 붙어 있고, HEAD라는 손가락이 main을 통해 그 점을 가리키고 있다.** 이게 본인 자경단 repo의 진짜 모양이에요. 한 번 본 다음에는 `git log --graph`가 외계어가 아닌 그림으로 보입니다. 다음 H3 — 환경 점검 — 에서는 본인 노트북에 Git이 어떻게 설치되어 있는지를 점검하고 SSH 키를 GitHub에 등록해서 비밀번호 없이 push할 수 있게 만들어요. H3 끝에 본인 노트북이 GitHub과 정식으로 악수한 상태가 됩니다. 한 가지 약속 — H2와 H3 사이에 본인 자경단 repo에서 `cat .git/HEAD`와 `cat .git/refs/heads/main`을 한 번씩만 더 쳐 보세요. 한 번 더 칠 때 보이는 풍경이 다릅니다.

## 15. 흔한 실수 다섯 가지 + 안심 멘트 — Git 핵심 학습 편

Git 핵심 4개를 만나며 자주 빠지는 학습 함정 다섯을 짚고 가요.

첫 번째 함정, .git 객체 4종을 다 외우려고. 본인이 blob·tree·commit·tag를 머리에 박으려고. 안심하세요. **첫날엔 commit 한 개만.** 나머지는 H7 깊이 시간에.

두 번째 함정, branch를 무거운 것으로 본다. 본인이 branch가 비싸다고 생각해서 한두 개만. 안심하세요. **branch는 한 줄 텍스트 파일.** 비싸지 않아요. 작업마다 새 branch.

세 번째 함정, merge vs rebase를 한 번에 다 이해하려고. 안심하세요. **첫달엔 merge만.** rebase는 두 번째 달. Ch005 협업에서 깊이.

네 번째 함정, HEAD 두 모드를 헷갈린다. branch에 붙은 HEAD vs detached. 안심하세요. **branch에 붙어 있어야 정상.** detached는 시간 여행, 평소엔 안 씀.

다섯 번째 함정, 가장 큰 함정. **첫날부터 force push.** 본인이 reset --hard 후 force push. 동료 작업 날아감. 안심하세요. **본인 브랜치에만, main/master 금지.** Ch005 branch protection.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 16. 한 줄 정리 + 추신

한 줄 정리. **Git의 모든 것은 객체 그래프(blob·tree·commit) 위에 라벨(branch=한 줄짜리 파일)과 손가락(HEAD)이 붙은 구조이고, merge는 갈래를 합치고 rebase는 갈래를 다시 줄 세운다.** 두 해 코스 우리 위치는 26/960 = 2.71%입니다. H1 끝에서 2.60%였고, 한 시간을 더 했으니 2.71%. 매주 1%씩 자라는 복리예요. 자, Ch004 H2는 여기서 닫습니다. 다음 H3에서 만나요. 수고 많으셨습니다.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - 4종 객체: blob/tree/commit/tag. tag는 H8에서.
> - commit 5필드: tree·parent(0~2개)·author·committer·message. sha는 이 5필드의 SHA-1.
> - branch = `.git/refs/heads/<name>` 한 줄 텍스트(40글자 sha).
> - HEAD = `.git/HEAD` 한 줄. attached(`ref: refs/heads/x`) vs detached(sha 직접).
> - 세 영역: working tree / staging(`.git/index`) / repository(`.git/objects` + `.git/refs`).
> - merge: fast-forward(라벨만 옮김) vs three-way(merge commit + parent 2개).
> - rebase: 부모 옮겨서 commit 재작성, sha 새로 계산. 공유 commit엔 금지.
> - fetch=다운로드만, pull=fetch+merge/rebase, push=업로드. force는 `--force-with-lease`로.
> - SHA-1 160bit. SHA-256 마이그레이션 진행 중. 7글자 단축 표기 보통 충분.
> - rebase 전 `git branch backup`으로 41바이트 안전장치.

## 추신

1. blob·tree·commit 세 객체. 이 셋이 Git의 알파벳입니다.
2. commit 5필드 — tree·parent·author·committer·message. 외워 두세요.
3. branch = 한 줄짜리 텍스트 파일. 41바이트. 무겁지 않아요.
4. HEAD = 손가락. attached와 detached 두 모드.
5. 세 영역 — working·staging·repository. add/commit/push가 영역 사이를 옮겨요.
6. fast-forward는 라벨 점프. three-way는 merge commit + parent 2개.
7. rebase는 history 재작성. 공유 commit엔 절대 금물.
8. fetch=안전, pull=자동(편하지만 위험), push=올리기.
9. `--force` 대신 `--force-with-lease`. 평생 습관으로 만드세요.
10. SHA-1 7글자면 보통 충분. 40글자 다 칠 필요 없어요.
11. `git cat-file -p <sha>`가 H7의 핵심 도구. 미리 손에 익혀 두세요. 본인 자경단 repo에서 한 번만 쳐 보고 가시는 게 좋아요.
12. 다음 시간 H3은 환경 점검 — Git 설치 확인, `git config --global` 세 줄, .gitignore, SSH 키 등록까지. 본인 노트북이 GitHub과 정식으로 악수합니다. 한 가지만 미리 알려 드리면, H3 끝에는 본인이 비밀번호 한 번도 안 치고 `git push`가 되는 상태가 됩니다. SSH 키 한 번 등록하면 평생 갑니다. 처음 설정이 30분 걸리고, 그 30분이 평생 비밀번호 입력 0번을 만들어 줘요. 코딩 인생의 가장 가성비 높은 30분 중 하나입니다.
