# Ch004 · H7 — Git 내부 — .git 폴더 안의 네 친구

> 고양이 자경단 · Ch 004 · 7교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. .git 폴더 한 번 열어 보기
3. 첫 친구 — objects (사진들)
4. 둘째 친구 — refs (브랜치 포인터)
5. 셋째 친구 — HEAD (현재 위치)
6. 넷째 친구 — config (설정)
6-보충. 숨은 친구 — index (staging area)
7. SHA-1 해시 — 객체의 신분증
8. packfile — 영리한 압축
9. hooks — git 안의 자동화
10. reflog — 30일 안전망
11. 흔한 오해 다섯 가지
12. 흔한 실수 다섯 가지 + 안심 멘트 — Git 내부 학습 편
13. FAQ — .git 내부 일곱 질문
13-보충. .git 다섯 친구 한 표
14. 마무리 — 다음 H8에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# .git 내부를 눈으로 — 강사가 시연하며 그대로 칠 수 있는 한 묶음
ls -la .git/                               # 여덟 식구 한눈에
git cat-file -p HEAD                        # 최근 commit 객체(5줄 텍스트)
git cat-file -t <hash>                      # 객체 종류(blob/tree/commit)
git cat-file -p HEAD^{tree}                 # 루트 tree 펼치기
cat .git/refs/heads/main                    # branch = 41바이트 한 줄
cat .git/HEAD                               # 현재 위치(ref: refs/heads/main)
git hash-object file.txt                    # git이 매번 하는 SHA-1 계산
echo -n "hello" | git hash-object --stdin   # 내용 → 해시 직접
git reflog                                  # 30일 안전망
git count-objects -vH                       # 객체 수·packfile 크기
```

이 한 화면이 오늘 60분의 지도예요. git의 모든 명령이 사실 이 .git 폴더 안의 텍스트 파일과 객체를 만지는 일이에요. 강사는 이 블록을 위에서 아래로 한 번 훑으며 "오늘 git이 마법에서 정직한 일로 바뀝니다"라고 말하고 시작하면 돼요.

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H6 회수. GitHub의 6 도구. Issue, PR, Project, Discussions, branch protection, CODEOWNERS.

H6은 GitHub이라는 "협업의 무대"를 봤어요. 그런데 그 모든 PR·머지·브랜치 보호의 밑바닥엔 git이 있어요. GitHub은 git 위에 협업 기능을 입힌 서비스예요. 오늘 H7은 그 밑바닥, git 자체의 엔진룸으로 내려가요. H6이 무대 위였다면 H7은 무대 뒤예요. 무대 뒤를 본 배우가 무대 위에서 더 침착하듯, git 내부를 본 본인이 GitHub에서 더 침착해져요.

이번 H7은 깊이의 시간이에요. .git 폴더를 직접 열어 봐요. Git이 본인의 저장소를 어떻게 디스크에 누이는지.

오늘의 약속. **본인이 .git 폴더 안의 네 친구를 만나면, git의 모든 명령이 마법에서 정직한 일로 변합니다**.

왜 내부를 배우냐고요? 본인이 H4·H5에서 `merge`·`rebase`·`reset`을 손으로 쳤어요. 잘 됐지만, 가끔 무서웠죠 — "이거 잘못 치면 다 날아가나?" 그 공포의 정체는 "안 보임"이에요. 안 보이니 마법 같고, 마법 같으니 무서워요. 오늘 .git을 열어 보면 그 안이 그냥 텍스트 파일 몇 개와 객체 그래프라는 걸 알게 돼요. 보이면 안 무서워요. 그리고 사고가 났을 때 "objects·refs·HEAD 중 뭐가 잘못됐지?"라고 위치를 짚을 수 있어요. 내부를 아는 사람이 사고에 침착한 사람이에요. 오늘 한 시간이 본인을 그 침착한 사람으로 만들어요.

자, 가요.

---

## 2. .git 폴더 한 번 열어 보기

본인의 자경단 저장소에서.

```bash
cd ~/cat-vigilante
ls -la .git/
```

진짜 출력.

```
HEAD
config
description
hooks/
info/
logs/
objects/
refs/
```

여덟 개. 그중 매일 만나는 네 친구가 — **objects, refs, HEAD, config**. 한 명씩.

나머지 식구도 한 줄씩 인사해 둘게요. `description`은 옛 GitWeb이 쓰던 저장소 설명 파일(거의 안 씀). `info/`엔 `exclude`(개인용 .gitignore, 공유 안 됨)가 있고요. `logs/`엔 reflog가 살아요(§10). `hooks/`엔 자동화 스크립트(§9). 그리고 눈에 안 보이지만 중요한 `index` 파일 하나가 더 있어요 — 이게 staging area(스테이징)예요(§6-보충에서). 여덟 식구 중 본인이 매일 의식하는 건 네 친구지만, 나머지도 다 제 역할이 있어요. 한 폴더 안에 git의 전부가 들어 있다는 게 핵심이에요 — **git 저장소를 통째로 백업하려면 이 .git 폴더 하나만 복사하면 돼요.** 거꾸로 .git을 지우면 그 저장소의 git 역사가 사라지고요.

---

## 3. 첫 친구 — objects (사진들)

`.git/objects/`가 git의 사진앨범. 본인의 모든 commit, 모든 파일 내용이 다 여기에.

```bash
ls .git/objects/
# 00/  01/  02/ ... ff/  pack/
```

256 폴더 (00~ff). hash의 첫 두 글자.

```bash
ls .git/objects/a1/
# b2c3d4e5f6...
```

`a1b2c3d4e5f6...`라는 sha-1 해시. 40 글자.

각 객체는 세 종류.

**1. blob**. 파일 내용. 한 .py 파일 = 한 blob.

**2. tree**. 폴더 구조. "이 폴더에 이 파일이 이런 hash로".

**3. commit**. 커밋 객체. tree + 부모 + 메시지 + 작성자.

본인이 객체를 직접 봐요.

> ▶ **같이 쳐보기** — git 객체 들여다보기
>
> ```bash
> # 최근 commit hash
> git log -1 --format=%H
> 
> # 그 commit 객체 보기
> git cat-file -p <hash>
> 
> # 객체 종류
> git cat-file -t <hash>
> ```

진짜 출력.

```
$ git cat-file -p abc1234
tree def5678...
parent ghi9012...
author Bonin <bonin@example.com> 1714510800 +0900
committer Bonin <bonin@example.com> 1714510800 +0900

feat: cat photo upload
```

5 줄 — tree 참조, 부모 참조, 작성자, 커미터, 메시지.

신기하죠. 본인의 모든 커밋이 이 5 줄짜리 텍스트 객체 + 다른 객체들에 대한 참조.

이 세 객체가 어떻게 엮이는지 그림을 그려 볼게요. commit은 tree 하나를 가리키고(루트 폴더), tree는 다시 blob들(파일)과 하위 tree들(하위 폴더)을 가리켜요. 그래서 한 commit에서 시작해 화살표를 따라가면 그 순간의 프로젝트 전체가 펼쳐져요. `git cat-file -p HEAD^{tree}`를 쳐 보면 루트 tree가, 거기서 또 하위 tree를 까면 폴더 안 폴더가 나와요. 이게 git의 진짜 모양 — 파일 더미가 아니라 **객체들의 그래프**예요.

여기서 git의 가장 깊은 비밀 하나. git은 **내용으로 주소를 매기는 저장소(content-addressable storage)**예요. 파일을 "이름"으로 찾는 게 아니라 "내용의 해시"로 찾아요. 같은 내용이면 우주의 어느 컴퓨터에서 만들어도 같은 hash, 같은 주소. 그래서 두 사람이 똑같은 파일을 따로 commit해도 blob은 하나만 저장돼요(중복 제거). 그리고 commit이 부모 commit의 hash를 품고, 그 부모가 또 조부모의 hash를 품으니, 한 글자만 바뀌어도 그 위 모든 commit의 hash가 바뀌어요. 이 구조를 **Merkle DAG**라고 불러요 — 블록체인의 원조가 사실 2005년 git이에요. 본인이 매일 치는 `git commit`이 블록체인보다 먼저 나온 분산 신뢰 구조예요. 그래서 누가 과거 commit을 몰래 바꾸면 그 위 모든 hash가 어긋나 들통나요. git의 변조 방지는 암호가 아니라 이 사슬 구조에서 와요.

본인이 `git add file.py`를 치면 무슨 일이 일어날까요? git이 그 파일 내용을 zlib으로 압축하고, SHA-1 해시를 계산해서 `.git/objects/앞2자/나머지38자`에 blob으로 저장해요. 그리고 index(대기실)에 "이 경로 = 이 blob hash"를 적어요. `git commit` 때는 index를 보고 tree 객체(폴더 구조)를 만들고, 그 tree와 부모 commit을 가리키는 commit 객체를 만들어요. 그래서 commit 한 번이 보통 객체 여러 개(blob들 + tree들 + commit 1개)를 새로 만들거나 재사용해요. 안 바뀐 파일의 blob은 그대로 재사용(같은 내용=같은 hash)하고요. `git hash-object`와 `git cat-file`로 이 과정을 한 단계씩 손으로 따라가 보면, git이 진짜 단순한 규칙 몇 개로 돌아간다는 걸 알게 돼요. 마법처럼 보이던 게 "압축하고, 해시 내고, 가리키기" 세 동작의 반복이었어요.

---

## 4. 둘째 친구 — refs (브랜치 포인터)

`.git/refs/`가 브랜치들의 위치.

```bash
ls .git/refs/
# heads/  remotes/  tags/

ls .git/refs/heads/
# main  feature/cat-photo  fix/header

cat .git/refs/heads/main
# abc1234567890abcdef...
```

`main`이라는 브랜치는 단 한 줄짜리 텍스트 파일. 그 안에 적힌 hash가 main이 가리키는 commit.

본인이 commit하면 그 한 줄이 새 hash로 갱신. 그게 git이 "main이 진행됐다"고 표현하는 방식.

브랜치는 진짜 가벼워요. 한 줄 텍스트 파일. 그래서 `git branch new-feature`가 0.001초.

이게 H1에서 본 "브랜치 = 평행우주" 비유의 진짜 정체예요. 평행우주가 통째로 복사되는 게 아니라, 그냥 한 commit을 가리키는 41바이트 포스트잇 한 장이에요(40자 hash + 줄바꿈). 그래서 회사에서 브랜치를 100개 만들어도 디스크가 안 늘어나요. SVN 시절엔 브랜치가 폴더 통째 복사라 무거웠는데, git은 포인터 하나라 공짜죠. 본인이 `git branch backup` 한 줄로 41바이트짜리 안전장치를 만드는 습관 — rebase 전에 이거 하나면 사고가 나도 backup 가지로 돌아오면 돼요. 41바이트가 본인의 보험이에요.

---

## 5. 셋째 친구 — HEAD (현재 위치)

`.git/HEAD`는 본인이 지금 어느 브랜치에 있는지.

```bash
cat .git/HEAD
# ref: refs/heads/main
```

지금 main 브랜치에 있어요. `git switch feature/x`로 옮기면.

```bash
cat .git/HEAD
# ref: refs/heads/feature/x
```

HEAD가 가리키는 곳을 바꾼 거예요.

특수한 경우. detached HEAD.

```bash
git checkout abc1234   # 특정 commit으로
cat .git/HEAD
# abc1234567890abcdef...
```

브랜치 참조가 아니라 직접 hash. 이게 detached HEAD. 여기서 commit하면 잃어버려요. 새 브랜치 따고 작업하세요.

detached HEAD가 무섭게 들리지만 정체는 단순해요. 평소 HEAD는 `ref: refs/heads/main`처럼 "브랜치를 가리키는 화살표"인데, detached일 땐 브랜치를 건너뛰고 commit hash를 직접 가리켜요. 포스트잇(브랜치) 없이 맨손으로 한 commit을 잡고 있는 상태예요. 여기서 새 commit을 만들면 그걸 가리키는 포스트잇이 없어서, 다른 데로 옮기는 순간 길을 잃어요(하지만 reflog엔 남아요, §10). 그래서 `git switch -c new-branch`로 포스트잇을 붙이고 작업하면 안전해요. detached HEAD는 사고가 아니라 "잠깐 과거를 구경하는 모드"예요. 옛 commit을 `git checkout`으로 구경하고, 구경만 하고 나오면 돼요. CI 시스템은 일부러 이 모드로 특정 commit을 체크아웃해서 빌드해요 — 브랜치가 필요 없으니까요.

HEAD를 기준으로 과거를 가리키는 표기도 알아 두면 편해요. `HEAD~1`(또는 `HEAD~`)은 한 단계 부모, `HEAD~3`은 세 단계 위, `HEAD^`은 첫 번째 부모(merge commit은 부모가 둘이라 `HEAD^2`가 두 번째 부모). 그래서 `git reset --hard HEAD~1`은 "한 commit 뒤로", `git show HEAD~2`는 "두 단계 전 commit 보기"예요. 이 표기가 손에 붙으면 commit을 일일이 hash로 안 부르고도 "여기서 몇 칸 뒤"로 가리킬 수 있어요. reflog의 `HEAD@{2}`(시간 기준)와 `HEAD~2`(부모 기준)를 구별하세요 — 전자는 "두 번 전에 내가 있던 곳", 후자는 "두 부모 위 commit"이에요. 같은 숫자라도 의미가 달라요.

---

## 6. 넷째 친구 — config (설정)

`.git/config`가 저장소 설정.

```bash
cat .git/config
```

진짜 출력.

```
[core]
    repositoryformatversion = 0
    filemode = true
[remote "origin"]
    url = git@github.com:cat-vigilante/site.git
    fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
    remote = origin
    merge = refs/heads/main
```

remote 정보, branch tracking 정보. 본인이 `git config user.email` 같은 명령으로 만진 게 다 여기에.

세 단계 config. system → global → local. 우선순위 local이 최고.

세 단계를 조금 더. `--system`은 컴퓨터 전체(거의 안 만짐), `--global`은 본인 계정 전체(`~/.gitconfig` — 이름·이메일·에디터가 여기), `--local`은 이 저장소만(`.git/config` — remote·브랜치 tracking). 같은 키가 여러 단계에 있으면 local이 이겨요. 그래서 회사 저장소엔 회사 이메일, 개인 저장소엔 개인 이메일을 `--local`로 따로 둘 수 있어요. `git config --list --show-origin`으로 어느 값이 어느 파일에서 왔는지 다 보여요 — 설정이 꼬였을 때 첫 진단 명령이에요. H3에서 본 `includeIf`로 디렉터리별 자동 전환도 가능하고요.

---

## 6-보충. 숨은 친구 — index (staging area)

본인이 H1~H5에서 `git add`를 수없이 쳤죠. 그 add가 만지는 게 바로 `.git/index`예요. working directory(본인이 편집하는 파일)와 repository(commit된 객체) 사이의 **대기실**이에요. `git add`는 "이 파일을 다음 commit 후보에 올려라", `git commit`은 "대기실에 있는 것들로 스냅샷을 찍어라"예요.

```bash
git status            # 빨강=working, 초록=staged(index)
git diff              # working vs index (아직 add 안 한 변경)
git diff --staged     # index vs repository (add했지만 commit 안 한 변경)
git ls-files --stage  # index 내용 직접 보기
```

이 세 영역(working·index·repository)을 머리에 그려 두면, `git add`·`git restore`·`git restore --staged`·`git commit`이 "어느 영역에서 어느 영역으로 옮기나"로 딱 정리돼요. `git reset --soft`는 repository만 뒤로(index·working 유지), `--mixed`(기본)는 repository+index 뒤로, `--hard`는 셋 다 뒤로. **reset의 세 옵션이 세 영역에 정확히 대응해요.** index는 안 보여서 어렵게 느껴지지만, 한 번 "대기실"로 그리면 평생 안 헷갈려요. git이 "add 따로, commit 따로" 두 단계인 이유도 이 대기실 덕이에요 — 한 변경 중 일부만 골라 담아(`git add -p`) 의미 있는 commit을 만들 수 있거든요.

본인이 H5 데모에서 `git add -p`로 한 파일의 일부만 골라 담았던 게 기억나세요? 그게 index라는 대기실이 있어서 가능한 거예요. 변경 전체를 한 commit에 쏟지 않고, 관련된 것끼리 골라 담아 "한 commit = 한 의도"(H4 함정 다섯)를 지키는 도구가 index예요. 그래서 git의 "add 따로, commit 따로"는 불편이 아니라 자유예요 — 무엇을 함께 묶을지 본인이 정하는 자유. 다른 버전 관리 도구엔 없는 git만의 선물이에요.

---

## 7. SHA-1 해시 — 객체의 신분증

git의 모든 객체는 SHA-1 hash로 식별. 40 글자. 보통 7 글자만 표시.

같은 내용이면 같은 hash. 다른 내용이면 다른 hash. 그래서 두 사람이 같은 코드를 따로 commit해도, 시간이 같으면 같은 hash. 다른 시간이면 다른 hash.

장점.

1. **변조 방지**. hash가 다르면 누가 바꿨다는 신호.
2. **중복 제거**. 같은 파일 두 commit에 들어가면 한 blob만.
3. **분산 가능**. 어느 컴퓨터에서 만든 hash든 같음.

```bash
# 한 파일의 hash 직접 계산
git hash-object file.txt
```

git이 내부에서 매번 하는 일을 본인이 직접.

한 가지 자주 헷갈리는 걸 풀어 둘게요. SHA-1 hash는 "파일 이름"이나 "시간"으로 만드는 게 아니라 **내용 + 약간의 헤더**로 만들어요. `echo -n "hello" | git hash-object --stdin`을 쳐 보면 누가 치든 같은 값(`b6fc4c62...`)이 나와요. 그래서 §3의 content-addressable이 가능한 거예요. 그리고 위에서 말한 "같은 시간이면 같은 hash"는 commit 객체 한정 이야기예요 — commit은 시간·작성자를 포함하니 시간이 다르면 hash가 달라지지만, blob(파일 내용)은 시간과 무관하게 내용만으로 hash가 정해져요. SHA-1은 40자(160비트)라 충돌 확률이 사실상 0이고(Linux 커널 27년에 0건), 그래도 만일을 대비해 git은 SHA-256으로 천천히 옮겨 가는 중이에요(2017년 SHAttered 충돌 시연 이후). 본인이 매일 보는 7자리 짧은 hash는 그냥 40자의 앞 7자만 보여 주는 거예요 — 7자만으로도 충돌이 거의 없거든요.

SHA-1의 또 다른 선물은 분산이에요. 본인 노트북에서 만든 commit hash와, 동료가 자기 노트북에서 같은 내용으로 만든 hash가 똑같아요. 중앙 서버가 번호를 매겨 주지 않아도 모두가 같은 주소 체계를 써요. 그래서 git은 인터넷 없이도 동작하고(오프라인 commit), 나중에 push로 합쳐도 hash가 안 충돌해요. H1에서 본 "분산"의 비밀이 바로 이 content-addressable hash예요. 중앙이 없어도 모두가 같은 진실을 가리키는 거예요 — 이게 git이 SVN을 이긴 결정적 한 수였어요. 번호표를 나눠 주는 중앙 직원이 없어도, 내용 자체가 자기 주소를 들고 다니니까요.

---

## 8. packfile — 영리한 압축

본인의 저장소가 1만 commit이 있으면? .git/objects/에 1만 폴더? 아니에요.

git이 일정 시간 후 객체들을 모아서 packfile로 압축.

```bash
ls .git/objects/pack/
# pack-abc123.pack  pack-abc123.idx
```

10MB 객체들이 1MB packfile로. 90% 압축. delta 압축으로 비슷한 객체 차이만 저장.

객체엔 두 상태가 있어요. 갓 만든 객체는 `.git/objects/앞2자/` 폴더에 하나씩 흩어진 **loose object**(느슨한 객체)예요. 그게 쌓이면 git이 gc 때 모아서 하나의 packfile로 묶어요. §3에서 본 256개 폴더(00~ff)는 hash 앞 2자로 나눈 서랍이에요 — 한 폴더에 객체가 너무 많이 쌓이지 않게 분산하는 거죠. 그래서 본인 저장소가 오래되면 loose object는 줄고 packfile이 늘어요. `git count-objects -vH`로 "loose 몇 개, packed 몇 개"를 보면 본인 저장소의 건강 상태가 한눈에 보여요.

```bash
git gc                  # 수동 packing
git gc --aggressive     # 더 강력
```

자경단 표준 — git이 자동 gc. 본인은 안 만짐.

packfile의 영리함을 한 줄 더. git은 비슷한 객체들(예: 한 파일의 100개 버전)을 통째로 저장하지 않고, 하나를 기준으로 "나머지는 이만큼만 다르다"는 **delta(차이)**만 저장해요. 그래서 1만 commit의 저장소도 놀랍도록 작아요. `git count-objects -vH`로 본인 저장소의 객체 수와 packfile 크기를 볼 수 있어요. clone이 빠른 것도 packfile 덕이에요 — 객체를 하나씩이 아니라 압축된 묶음 하나로 받으니까요. 큰 저장소를 받을 땐 `git clone --depth 1`(shallow clone, 최근 한 겹만)이나 `--filter=blob:none`(파일은 필요할 때만)으로 더 빨리 받아요. H7의 네트워크 챕터에서 본 "압축은 양을 줄인다"가 git에서도 똑같이 일어나는 거예요.

---

## 9. hooks — git 안의 자동화

`.git/hooks/`가 git 명령 전후 자동 실행 스크립트.

```bash
ls .git/hooks/
# applypatch-msg.sample
# commit-msg.sample
# pre-commit.sample
# pre-push.sample
# ...
```

`.sample` 빼고 이름 바꾸면 활성. 자경단의 표준.

```bash
# .git/hooks/pre-commit
#!/bin/bash
# commit 전 자동 검사

ruff check .
mypy --strict .
```

commit하면 자동 실행. 통과 못 하면 commit 안 됨.

문제. .git/hooks/는 git에 안 올라가요. 동료들이 같은 hook 못 써요. 그래서 husky를 써요. (Ch005 H3에서)

hook의 종류를 몇 개만 알아 두면 충분해요. **pre-commit**(commit 직전 — lint·테스트), **commit-msg**(메시지 검사 — Conventional Commits), **pre-push**(push 직전 — 무거운 테스트), **post-merge**(merge 후 — 의존성 재설치). 자경단은 pre-commit에 ruff·mypy를 걸어 "깨진 코드는 commit조차 안 되게" 해요. 다만 `.git/hooks/`는 git에 안 올라가니 동료와 공유가 안 돼요. 그래서 Ch005에서 husky로 hook을 코드 저장소 안에 넣고 `npm install` 한 번에 모두가 같은 hook을 쓰게 만들어요. hook은 "본인 손이 잊어도 기계가 기억하는 약속"이에요. 그리고 hook은 `--no-verify`로 건너뛸 수 있는데, 이건 비상구지 일상 문이 아니에요 — 자주 건너뛰면 hook이 없는 거나 마찬가지예요.

자경단의 표준 pre-commit hook을 한 번 그려 볼게요 — AWS 키 같은 비밀이 commit에 섞였는지 검사하고, 5MB 넘는 큰 파일을 막고, lint-staged로 바뀐 파일만 ruff·prettier로 검사. 세 줄 검사가 사고 셋을 막아요(비밀 유출·저장소 비대·스타일 깨짐). 한 번 깔아 두면 본인이 깜빡해도 hook이 대신 지켜요. "사람은 잊고 기계는 기억한다" — 자동화의 첫 계명이에요. husky로 이걸 팀에 배포하면 다섯 명이 같은 방패를 들어요(Ch005 H3). hook 하나가 다섯 명의 실수를 막는 거예요.

---

## 10. reflog — 30일 안전망

`.git/logs/HEAD`가 본인의 모든 HEAD 이동 기록.

```bash
git reflog
```

진짜 출력.

```
abc1234 HEAD@{0}: commit: feat: cat photo
def5678 HEAD@{1}: commit: feat: cat list
ghi9012 HEAD@{2}: rebase: onto main
...
```

30일 보관. 본인이 force-push로 commit을 잃어도 여기엔 남아 있어요.

복구.

```bash
git reflog
# def5678 HEAD@{1}: ...
git reset --hard def5678   # 그 시점으로 복구
```

reflog가 본인의 30일 안전망. force-push 사고 후 5분에 복구.

reflog의 진짜 가치는 "안심"이에요. 본인이 `reset --hard`로 commit 네 개를 날려도, rebase로 히스토리를 헝클어도, reflog엔 모든 HEAD 이동이 시간순으로 남아 있어요. `git reflog`로 사고 직전의 `HEAD@{1}`을 찾아 `git reset --hard HEAD@{1}` 하면 그 순간으로 돌아가요. 이걸 한 번 일부러 연습해 두면 git이 평생 안 무서워져요 — 빈 폴더에서 commit 다섯 개 만들고, `reset --hard HEAD~3`로 날리고, `reflog`로 되살리기. 그 5분이 본인을 force-push 공포에서 해방시켜요. **git에선 "진짜 삭제"가 거의 없어요.** commit은 reflog가 90일(기본 `gc.reflogExpire`), 도달 불가 객체도 30일은 버텨요. 그 안전망이 본인 뒤를 받쳐요. 단 하나 예외 — 아직 한 번도 commit 안 한 working 변경은 reflog에도 없어요. 그래서 "일단 commit, 정리는 나중에"가 안전의 첫 규칙이에요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: ".git 폴더는 절대 만지면 안 되는 블랙박스다."** 읽기는 안전해요. `cat .git/HEAD`, `ls .git/refs/heads/`, `git cat-file -p`는 마음껏 들여다보세요 — 오히려 git을 이해하는 가장 빠른 길이에요. 다만 텍스트 에디터로 직접 고치는 쓰기는 금지. 쓰기는 항상 git 명령으로. 읽기로 친해지고, 쓰기는 명령에 맡기세요.

**오해 2: "브랜치를 만들면 코드가 통째로 복사돼 무겁다."** 아니에요. 브랜치는 41바이트 텍스트 파일 한 장(40자 hash + 줄바꿈)이에요. 그래서 100개 만들어도 디스크가 안 늘어요. SVN의 무거운 브랜치 기억 때문에 다들 오해하는데, git 브랜치는 포스트잇 한 장이에요. 마음껏 만들고 지우세요.

**오해 3: "SHA-1은 안전하니 영원히 쓸 거다."** SHA-1은 2017년 SHAttered에서 의도적 충돌이 시연됐어요. 일상에선 충돌 확률이 사실상 0이지만(Linux 27년 0건), 보안상 git은 SHA-256으로 천천히 옮겨 가는 중이에요. 본인이 당장 걱정할 일은 아니지만, "왜 SHA-256으로 바꾸나요?"는 면접 단골이에요.

**오해 4: "hook을 만들면 팀 전체에 자동 적용된다."** `.git/hooks/`는 git에 안 올라가요(.git은 추적 대상이 아니니까). 그래서 본인이 만든 pre-commit hook을 동료는 못 써요. 팀 공유는 husky·pre-commit framework로 hook을 코드 저장소 안에 넣어야 돼요(Ch005 H3). 이걸 모르면 "나는 되는데 동료는 안 되는" 사고가 나요.

**오해 5: "reflog가 있으니 백업은 필요 없다."** reflog는 로컬 안전망이지 백업이 아니에요. commit은 90일, 도달 불가 객체는 30일 후 gc로 사라지고, 무엇보다 **본인 노트북이 고장 나면 reflog도 같이 사라져요.** 진짜 백업은 `git push`로 원격(GitHub)에 올리는 거예요. reflog는 "어제 실수 복구", push는 "노트북이 죽어도 안전"이에요.

---

## 12. 흔한 실수 다섯 가지 + 안심 멘트 — Git 내부 학습 편

§11에서 지식 오해 5개. 이번엔 학습 자세 함정 다섯.

첫 번째 함정, .git 안을 직접 수정하려는 것. 본인이 호기심에 `.git/HEAD`나 refs 파일을 텍스트 에디터로 고치려 해요. 안심하세요. **읽기는 OK, 쓰기는 금지.** `cat`으로 들여다보는 건 학습에 최고지만, 고치는 건 항상 git 명령으로. 직접 고치면 객체 정합성이 깨져 저장소가 망가질 수 있어요. 보는 건 마음껏, 만지는 건 명령으로.

두 번째 함정, SHA 충돌을 걱정하는 것. 본인이 "내 hash가 누구와 겹치면?" 밤잠을 설쳐요. 안심하세요. **40자 SHA-1은 우주가 끝날 때까지도 우연히 안 겹쳐요.** Linux 커널이 27년간 0건. 본인이 그걸 걱정할 확률보다 로또를 연속 당첨될 확률이 높아요. 그 에너지를 commit 메시지 잘 쓰는 데 쓰세요.

세 번째 함정, packfile을 직접 풀려는 것. 본인이 `.git/objects/pack/`을 열어 압축을 풀어 보려 해요. 안심하세요. **git이 자동으로 처리해요.** `git gc`는 보통 자동이고, 본인이 packfile을 손으로 만질 일은 평생 거의 없어요. 내부는 이해하되, 운영은 git에 맡기세요.

네 번째 함정, hook을 너무 복잡하게 만드는 것. 본인이 pre-commit 하나에 50줄을 욱여넣어 commit이 10초씩 걸려요. 안심하세요. **hook은 짧고 빠르게.** 무거운 검사는 CI(GitHub Actions)로 미루고, hook엔 빠른 lint만. 그리고 husky로 묶어 팀이 공유하게. 느린 hook은 다들 `--no-verify`로 건너뛰어 결국 죽은 hook이 돼요.

다섯 번째 함정, 가장 큰 함정. **reflog를 모르고 reset --hard 후 패닉하는 것.** 본인이 실수로 commit을 날리고 "다 끝났다" 좌절해요. 안심하세요. **reflog가 30~90일 안전망이에요.** `git reflog` → 사고 직전 `HEAD@{1}` 찾기 → `git reset --hard HEAD@{1}`. 5분이면 복구. 이 한 가지를 알면 git이 평생 안 무서워요. git에선 진짜 삭제가 거의 없다는 걸 기억하세요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

---

## 13. FAQ — .git 내부 일곱 질문

**Q1. .git 폴더를 실수로 지우면 어떻게 돼요?** 그 저장소의 모든 히스토리(commit·브랜치·reflog)가 사라져요. 작업 파일(working copy)은 남지만 git 추적은 0이 돼요. 다행히 `git push`로 GitHub에 올려 뒀다면 `git clone`으로 통째 복구돼요. 그래서 §오해 5 — 진짜 백업은 원격이에요. .git을 지우는 건 거의 없는 일이지만, 원격에 올려 두면 그마저도 무섭지 않아요.

**Q2. `git cat-file` 같은 명령을 실무에서 진짜 쓰나요?** 매일은 아니에요. 하지만 "이 commit이 진짜 뭘 담고 있지?", "이 tree에 무슨 파일이 있었지?" 같은 깊은 디버깅 때 꺼내요. 더 중요한 건, 이 명령으로 한 번 내부를 보고 나면 `merge`·`rebase`·`reset`이 마법이 아니라 "포인터를 옮기는 정직한 일"로 보인다는 거예요. 이해를 위한 명령이에요.

**Q3. SHA-1이 충돌하면 제 저장소가 깨지나요?** 현실에서 걱정할 일은 아니에요. 우연한 충돌은 40자 hash에서 사실상 불가능하고(우주 나이로도 안 일어남), 의도적 충돌(SHAttered)도 git은 충돌 탐지 코드로 막고 있어요. SHA-256 마이그레이션은 "만일의 만일"을 위한 장기 작업이에요. 본인은 그냥 쓰면 돼요.

**Q4. detached HEAD에서 작업한 commit이 사라졌어요.** 안 사라졌어요, reflog에 있어요. `git reflog`로 그 commit hash를 찾아 `git branch 복구브랜치 <hash>`로 포스트잇을 붙이면 돌아와요. detached HEAD에서 만든 commit은 "가리키는 브랜치가 없을 뿐" 객체는 살아 있어요(30일). 이게 reflog가 안전망인 이유예요.

**Q5. .git 폴더가 너무 커요. 줄일 수 있어요?** `git gc`로 packfile 정리(보통 자동), `git count-objects -vH`로 크기 확인. 진짜 큰 원인은 보통 "큰 바이너리 파일을 commit한 역사"예요(예: 실수로 올린 100MB 동영상). 그건 `git filter-repo`로 히스토리에서 제거해야 줄어요 — 단, 히스토리를 바꾸니 팀과 합의 후. 애초에 큰 파일은 Git LFS나 .gitignore로 막는 게 정답이에요.

**Q6. hook이 동료에게 적용 안 돼요.** 정상이에요. `.git/hooks/`는 git에 안 올라가니까요(§오해 4). 팀 공유는 husky(JS)나 pre-commit(Python) 같은 도구로 hook을 코드 저장소에 넣고, `npm install`이나 `pre-commit install` 한 번으로 모두가 같은 hook을 설치해요. Ch005 H3에서 husky를 깊이 다뤄요.

**Q7. reflog는 영원히 남아요?** 아니에요. 도달 가능한 commit의 reflog는 기본 90일(`gc.reflogExpire`), 도달 불가 객체의 reflog는 30일(`gc.reflogExpireUnreachable`) 후 gc 때 정리돼요. 그래서 "지난주 실수"는 복구되지만 "석 달 전 실수"는 어려울 수 있어요. 중요한 건 늘 원격에 push해 두는 거예요.

---

## 13-보충. .git 다섯 친구 한 표

| 친구 | 위치 | 정체 | 한 줄 |
|------|------|------|-------|
| objects | `.git/objects/` | blob·tree·commit 그래프 | 모든 내용의 사진앨범 |
| refs | `.git/refs/heads/` | 41바이트 포인터 | 브랜치 = 포스트잇 |
| HEAD | `.git/HEAD` | 현재 위치 | "나 지금 여기" |
| config | `.git/config` | INI 설정 | remote·branch tracking |
| logs(reflog) | `.git/logs/HEAD` | HEAD 이동 기록 | 30~90일 안전망 |

다섯 친구만 알면 git의 모든 명령이 "이 다섯 중 무엇을 만지나"로 풀려요. `commit`은 objects+refs+HEAD를 한 번에 갱신, `branch`는 refs 한 줄 추가, `switch`는 HEAD 한 줄 변경, `reset`은 refs를 옮기고 reflog에 기록. 마법이 아니라 텍스트 파일 몇 개의 갱신이에요.

마지막으로 git의 출생 이야기 하나. git은 2005년 리누스 토르발스가 단 열흘 만에 만들었어요. 리눅스 커널 팀이 쓰던 BitKeeper가 유료로 바뀌자, 화가 난 리누스가 "그럼 내가 만든다"며 2주 만에 git의 핵심을 짰어요. 그가 세운 원칙이 오늘 본 그대로예요 — 분산(누구나 전체 history를 가짐), 내용 주소(hash로 저장), 불변(과거를 못 바꿈), 빠름(C로 작성). 한 사람이 열흘에 만든 도구가 20년째 전 세계 코드를 지키고 있어요. 본인이 오늘 그 설계의 안쪽을 봤어요. 좋은 설계는 단순하고, 단순하니 오래가요. 그리고 그 단순함이 본인 같은 학습자가 한 시간에 내부를 이해할 수 있는 이유예요.

---

## 14. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요.

.git 안의 네 친구 — objects (사진), refs (포인터), HEAD (현재), config (설정). 더해서 숨은 친구 index(대기실), SHA-1, packfile, hooks, reflog.

본인이 오늘 한 일을 한 번 돌아볼게요. 매일 치던 `git commit`·`git add`·`git branch`·`git switch`·`git reset`이 .git 폴더 안에서 무슨 텍스트 파일을 만지는지 눈으로 봤어요. 이제 git은 본인에게 블랙박스가 아니라 유리 상자예요. 안이 보이는 도구는 무섭지 않아요. 사고가 나도 "아, objects는 살아 있고 refs만 옮기면 되겠다"라고 침착하게 생각할 수 있어요. 그게 오늘 한 시간의 진짜 선물이에요. 박수.

다음 H8은 적용 + 회고. 자경단 30분 종합 셋업.

```bash
ls -la .git/
git cat-file -p HEAD
```

오늘 한 줄 정리. **"git의 모든 명령은 .git 폴더 안의 텍스트 파일과 객체 그래프를 만지는 정직한 일이다 — 마법은 없다."** 본인이 이 한 줄을 손에 쥐면, 앞으로 어떤 git 사고를 만나도 "그래서 지금 objects·refs·HEAD 중 뭐가 잘못된 거지?"라고 물을 수 있어요. 이해는 공포를 이겨요.

본인이 오늘 배운 내부가 두 해 후 어떻게 돌아오는지 한 장면. 회사에서 동료가 "rebase 했더니 commit이 사라졌어!" 패닉할 때, 본인이 옆에서 "reflog 봐, `HEAD@{1}`에 있을 거야"라고 한마디 해요. 동료가 복구하고 본인을 다르게 봐요. **내부를 아는 한 사람이 팀의 안전망이 돼요.** .git 다섯 친구를 만난 오늘 한 시간이, 두 해 후 팀 전체의 commit을 지켜요. 깊이는 그렇게 돌아와요.

본인 페이스. 7/8 시간. 87.5%. 마지막 한 시간만 남았어요. .git을 한 번 열어 본 본인은 이제 git을 "쓰는 사람"에서 "아는 사람"으로 넘어왔어요. 짝짝짝. 본인 자신에게 박수. 5분 쉬고 마지막 H8에서 만나요.

---

## 추신

1. git의 모든 명령은 .git 안의 텍스트 파일과 객체를 만지는 정직한 일. 마법은 없어요.
2. 다섯 친구 — objects·refs·HEAD·config·reflog. 이것만 알면 git이 투명해져요.
3. .git은 읽기로 친해지세요. `cat .git/HEAD`, `ls .git/refs/heads/`는 안전해요.
4. 쓰기는 항상 git 명령으로. .git을 에디터로 직접 고치지 마세요.
5. 객체 세 종류 — blob(파일)·tree(폴더)·commit(스냅샷+부모+메시지).
6. git은 content-addressable storage — 이름이 아니라 내용의 해시로 저장.
7. 같은 내용 = 같은 hash = 한 번만 저장(중복 제거).
8. commit이 부모를 품는 사슬 = Merkle DAG. 블록체인 원조가 2005년 git.
9. 브랜치 = 41바이트 포스트잇. 100개 만들어도 디스크 안 늘어요.
10. rebase 전에 `git branch backup` 한 줄. 41바이트가 보험이에요.
11. HEAD = "나 지금 여기". `ref: refs/heads/main`이 평소 모습.
12. detached HEAD는 사고 아니라 "과거 구경 모드". 구경만 하고 나오세요.
13. SHA-1 40자, 평소 7자만 표시. 7자로도 충돌 거의 없어요.
14. SHA-256 마이그레이션은 SHAttered(2017) 이후의 장기 보험.
15. packfile은 delta 압축 — 비슷한 객체의 차이만 저장. 90% 압축.
16. 큰 저장소는 `git clone --depth 1`(shallow)로 빨리 받기.
17. hook 종류 — pre-commit·commit-msg·pre-push·post-merge.
18. `.git/hooks/`는 공유 안 돼요. 팀 공유는 husky(Ch005).
19. `--no-verify`는 hook 비상구지 일상 문이 아니에요.
20. reflog는 30~90일 안전망. reset --hard 후에도 `HEAD@{1}`로 복구.
21. 빈 폴더에서 reset→reflog 복구를 한 번 연습하면 git이 평생 안 무서워요.
22. reflog는 로컬 안전망, push는 진짜 백업. 둘은 달라요.
23. "일단 commit, 정리는 나중에" — commit 안 한 변경은 reflog에도 없어요.
24. index(대기실)를 그려 두면 add·commit·reset 세 영역이 한눈에. working→index→repository.
25. reset 세 옵션이 세 영역에 대응 — soft(repo만)·mixed(repo+index)·hard(셋 다).
26. config 세 단계 — system·global·local. local이 이겨요. `--show-origin`으로 진단.
27. `git add`는 압축+해시+저장. 매일 치는 그 한 줄이 객체를 만들어요.
28. git은 2005년 리누스가 열흘에 만든 도구. 단순해서 20년을 가요.
29. 좋은 설계는 단순하고, 단순하니 오래가요. git이 그 증거예요.
30. `HEAD~1`은 부모, `HEAD^2`는 merge의 두 번째 부모. `HEAD@{1}`은 시간 기준(reflog).
31. GitHub은 git 위에 협업을 입힌 서비스. 밑바닥은 늘 git이에요.
32. 내부를 아는 한 사람이 팀의 안전망. "reflog 봐"라는 한마디가 동료를 구해요.
33. loose object는 흩어진 객체, packfile은 묶인 객체. gc가 묶어요.
34. index는 불편이 아니라 자유. 무엇을 함께 묶을지 본인이 정하는 자유예요.
35. hook 하나가 다섯 명의 실수를 막아요. 사람은 잊고 기계는 기억해요.
36. content-addressable — 내용이 자기 주소를 들고 다녀요. 그래서 인터넷 없이도 commit하고, 중앙 서버 없이도 모두가 같은 주소를 써요. git이 SVN을 이긴 결정적 한 수예요.
37. 면접 단골 — "branch가 왜 가벼워요?"(41바이트), "merge와 rebase 차이?"(포인터 이동 방식).
31. 다음 H8은 마지막 — 자경단 30분 종합 셋업 + Ch004 다섯 원리 + 회고. 7/8 끝, 한 시간 남았어요. 5분 쉬고 H8에서 만나요. 🐾

> - SHA-1 → SHA-256 마이그레이션: PEP 진행 중.
> - delta 압축: zlib + custom delta.
> - object 종류 4: blob, tree, commit, tag.
> - hooks 위치: .git/hooks/ vs core.hooksPath.
> - reflog 만료: gc.reflogExpire (90일 default).
> - 다음 H8 키워드: 30분 종합 셋업 · 다섯 원리 · 자경단 적용.
