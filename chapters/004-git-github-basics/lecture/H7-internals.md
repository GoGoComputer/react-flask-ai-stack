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
7. SHA-1 해시 — 객체의 신분증
8. packfile — 영리한 압축
9. hooks — git 안의 자동화
10. reflog — 30일 안전망
11. 흔한 오해 다섯 가지
12. 흔한 실수 다섯 가지 + 안심 멘트 — Git 내부 학습 편
13. 마무리 — 다음 H8에서 만나요

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H6 회수. GitHub의 6 도구. Issue, PR, Project, Discussions, branch protection, CODEOWNERS.

이번 H7은 깊이의 시간이에요. .git 폴더를 직접 열어 봐요. Git이 본인의 저장소를 어떻게 디스크에 누이는지.

오늘의 약속. **본인이 .git 폴더 안의 네 친구를 만나면, git의 모든 명령이 마법에서 정직한 일로 변합니다**.

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

---

## 8. packfile — 영리한 압축

본인의 저장소가 1만 commit이 있으면? .git/objects/에 1만 폴더? 아니에요.

git이 일정 시간 후 객체들을 모아서 packfile로 압축.

```bash
ls .git/objects/pack/
# pack-abc123.pack  pack-abc123.idx
```

10MB 객체들이 1MB packfile로. 90% 압축. delta 압축으로 비슷한 객체 차이만 저장.

```bash
git gc                  # 수동 packing
git gc --aggressive     # 더 강력
```

자경단 표준 — git이 자동 gc. 본인은 안 만짐.

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

---

## 11. 흔한 오해 다섯 가지

**오해 1: .git 만지면 안 됨.**

읽기만은 OK. 쓰기는 git 명령으로.

**오해 2: 브랜치는 무거움.**

한 줄 텍스트 파일. 가벼움.

**오해 3: SHA-1 안전.**

이론적 충돌 가능. git은 SHA-256 마이그레이션 중.

**오해 4: hooks는 동기화.**

local만. 동료 공유는 husky.

**오해 5: reflog 자동 백업.**

30일만. 그 후 사라짐.

---

## 12. 흔한 실수 다섯 가지 + 안심 멘트 — Git 내부 학습 편

§11에서 지식 오해 5개. 이번엔 학습 자세 함정 다섯.

첫 번째 함정, .git 안을 직접 수정. 본인이 .git/HEAD를 텍스트 에디터로. 안심하세요. **읽기는 OK, 쓰기는 금지.** 항상 git 명령으로.

두 번째 함정, SHA 충돌 걱정. 안심하세요. **40자 SHA-1은 우주에서 충돌 거의 불가능.** Linux 커널 27년에 0건.

세 번째 함정, packfile 직접 풀려고. 안심하세요. **git이 자동 처리.** gc는 자동.

네 번째 함정, hooks 너무 복잡하게. 본인이 한 hook에 50줄. 안심하세요. **hook은 짧게, husky·pre-commit으로 묶기.**

다섯 번째 함정, reflog 무시. 본인이 reset --hard 후 패닉. 안심하세요. **reflog 30일 안전망.** 거의 모든 사고 복구 가능.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 13. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요.

.git 안의 네 친구 — objects (사진), refs (포인터), HEAD (현재), config (설정). SHA-1, packfile, hooks, reflog.

박수.

다음 H8은 적용 + 회고. 자경단 30분 종합 셋업.

```bash
ls -la .git/
git cat-file -p HEAD
```

---

## 👨‍💻 개발자 노트

> - SHA-1 → SHA-256 마이그레이션: PEP 진행 중.
> - delta 압축: zlib + custom delta.
> - object 종류 4: blob, tree, commit, tag.
> - hooks 위치: .git/hooks/ vs core.hooksPath.
> - reflog 만료: gc.reflogExpire (90일 default).
> - 다음 H8 키워드: 30분 종합 셋업 · 다섯 원리 · 자경단 적용.
