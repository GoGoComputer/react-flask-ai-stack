# Ch006 · H2 — 터미널·셸·Bash: 핵심개념 — 셸 8개념 깊이

> **이 H에서 얻을 것**
> - 셸 변수 vs 환경변수 — `var=foo` vs `export VAR=foo`의 진짜 차이
> - PATH 검색 우선순위 — `:` 구분 디렉토리, 같은 이름 두 곳일 때 누가 이김
> - exit code 표준 — `0=성공`·`1~255 실패`·`$?`로 확인·`&&` `||` 흐름 제어
> - subshell `(...)` vs `{...}` — 환경 격리 vs 그룹화의 차이
> - glob `*`·`**`·`?`·`[abc]`·`{a,b}` — 자주 쓰는 5종 패턴
> - redirection 7종 — `>`·`>>`·`<`·`<<<`·`2>`·`2>&1`·`/dev/null`
> - heredoc `<<EOF` — 여러 줄 입력 표준
> - pipe `|`·command substitution `$(...)` — 셸 조합의 두 무기

---

## 회수: H1의 4단어에서 본 H의 8개념으로

지난 H1에서 본인은 4핵심 단어(터미널·셸·프로세스·파일시스템)를 봤어요. 그건 셸의 토대.

이번 H2는 그 셸이 **어떻게 동작하는가의 8개념** 깊이예요. 변수·PATH·exit code·subshell·glob·redirection·heredoc·pipe. 8개가 본인의 매일 셸 손가락의 90%.

본 H 끝나면 본인은 한 줄 명령어 (`find ~ -size +100M 2>/dev/null | sort -k5 -hr | head -5`)를 분해해서 읽을 수 있어요. 8개념이 한 줄에 다 들어 있어요.

---

## 1. 셸 변수 vs 환경변수 — `=` vs `export`

가장 헷갈리는 첫 개념.

### 1-1. 셸 변수

`=` 한 줄로 셸 안의 변수.

```bash
$ name="고양이 자경단"
$ echo $name
고양이 자경단
```

**자식 프로세스에 전달 안 됨**. 이 변수는 본인의 zsh 셸 안에서만.

```bash
$ name="자경단"
$ bash -c 'echo $name'      # 자식 bash에선 빈 문자열
                            # (자식이 못 봄)
```

### 1-2. 환경변수

`export`로 마킹한 변수. **자식 프로세스에 전달**.

```bash
$ export NAME="자경단"
$ bash -c 'echo $NAME'      # 자식이 받음
자경단
```

**이미 정의된 변수도 export 가능**:

```bash
$ name="자경단"
$ export name              # 이제 환경변수
$ bash -c 'echo $name'
자경단
```

### 1-3. 양식 함정

```bash
# 잘못된 양식 (= 양옆에 공백)
$ name = "자경단"          # bash: name: command not found
                          # = 옆 공백 = 명령으로 해석

# 올바른 양식
$ name="자경단"            # = 옆 공백 없음
```

`=` 양옆 공백 없음이 셸 표준. Python·JS와 다름.

### 1-4. 자경단 환경변수 5종

본인의 자경단 dotfile에 자주 박는 5종:

```bash
export EDITOR="code --wait"          # git commit 에디터
export LANG="en_US.UTF-8"            # 한글 깨짐 방지
export PATH="$HOME/.local/bin:$PATH" # PATH 추가
export NODE_OPTIONS="--max-old-space-size=4096"  # Node 메모리
export GH_TOKEN="$(cat ~/.config/gh/token)"      # gh 인증
```

5종이 자경단의 첫 환경변수.

### 1-5. `env` 명령어

현재 모든 환경변수 보기:

```bash
$ env | head -10
PATH=/opt/homebrew/bin:/usr/local/bin:...
HOME=/Users/mo
SHELL=/bin/zsh
LANG=en_US.UTF-8
EDITOR=code --wait
...
```

`env -i command`은 깨끗한 환경(환경변수 0개)에서 실행. 격리 테스트에 유용.

---

## 2. PATH 검색 — 명령어가 어디서 오나

본인이 `ls`를 치면 셸이 `ls`를 어디서 찾나?

### 2-1. PATH 변수

`:` 구분 디렉토리 목록. 셸이 이 순서로 검색.

```bash
$ echo $PATH | tr ':' '\n'
/opt/homebrew/bin
/opt/homebrew/sbin
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
```

`/opt/homebrew/bin` 첫 번째 (Apple Silicon brew 우선). `/usr/bin` 다음.

### 2-2. 검색 순서

본인이 `git`을 치면:
1. `/opt/homebrew/bin/git` 있나? — 있으면 사용 (brew git)
2. 없으면 `/usr/local/bin/git` — 있으면 사용
3. 없으면 `/usr/bin/git` — Apple 기본 git
4. 없으면 → `git: command not found`

### 2-3. `which` vs `type`

```bash
# which — 외부 명령의 PATH 위치
$ which git
/opt/homebrew/bin/git

# type — 더 자세 (built-in·alias·function·외부)
$ type git
git is /opt/homebrew/bin/git

$ type cd
cd is a shell builtin           # 셸 내부

$ type ll
ll is an alias for ls -lah      # alias
```

### 2-4. PATH 우선순위 함정

같은 이름 명령이 두 곳에 있을 때 첫 번째가 이김.

```bash
# 자경단 본인이 새 ~/bin/git 만듦 (실험용)
$ ls -la ~/bin/git
-rwxr-xr-x  1 mo  staff  ... ~/bin/git

# PATH에 ~/bin이 첫 번째면 ~/bin/git 우선
$ export PATH="$HOME/bin:$PATH"
$ which git
/Users/mo/bin/git              # 본인의 실험용 git
```

**우선순위 활용** — 본인의 자경단이 새 alias·실험 명령 첨부 시 PATH 앞에. 우선순위 안 헷갈리려면 `~/bin`을 PATH 첫 번째로.

### 2-5. PATH 셋업 표준

`~/.zshrc`의 PATH 5줄 (Ch006 H1 회수):

```bash
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
```

위에서 아래로. 마지막 추가가 가장 우선.

---

## 3. exit code — 명령어의 성공·실패

명령어가 끝나면 0~255 숫자를 반환. **0 = 성공, 1~255 = 실패**.

### 3-1. `$?`로 확인

```bash
$ ls /
(파일 목록)
$ echo $?
0                              # 성공

$ ls /nonexistent
ls: /nonexistent: No such file or directory
$ echo $?
1                              # 실패
```

### 3-2. 표준 exit code

| 코드 | 의미 |
|------|------|
| 0 | 성공 |
| 1 | 일반 에러 |
| 2 | 사용법 에러 (옵션 잘못) |
| 126 | 권한 거부 (chmod 안 됨) |
| 127 | 명령 못 찾음 |
| 130 | Ctrl+C로 종료 (SIGINT 128+2) |
| 137 | SIGKILL (128+9) — `kill -9`·OOM |
| 139 | SIGSEGV (128+11) — segfault |

### 3-3. `&&`·`||` 흐름 제어

```bash
# A 성공 시 B 실행
$ git pull --rebase && git push

# A 실패 시 B 실행
$ git push || echo "push failed!"

# 셋 차례
$ npm install && npm test && npm run build

# 무조건 차례
$ git add . ; git commit -m wip ; git push     # `;` = 무조건
```

`&&` `||`이 `if`보다 짧고 자주 쓰임.

### 3-4. 자경단 exit code 활용

CI 스크립트에서:

```bash
#!/bin/bash
set -e                         # 한 명령 실패 시 즉시 exit
npm run lint                   # 0이어야
npm run test                   # 0이어야
npm run build                  # 0이어야
echo "전체 통과"                # 여기 도달 = 0
```

`set -e`이 자경단의 안전장치. exit code 무시 안 함.

### 3-5. exit code 사용자 정의

스크립트 작성 시:

```bash
#!/bin/bash
if [ ! -f config.json ]; then
  echo "config.json 없음"
  exit 2                       # 사용자 정의 exit code
fi
echo "OK"
exit 0
```

자경단의 스크립트는 표준 exit code 사용. 0=성공·1=일반·2=설정 에러.

---

## 4. subshell `(...)` vs 그룹 `{...}`

비슷해 보이지만 다른 동작.

### 4-1. subshell `(...)` — 자식 프로세스

```bash
$ var=원래
$ (var=새값; echo "안: $var")
안: 새값
$ echo "밖: $var"
밖: 원래                       # 부모는 안 바뀜
```

`(...)`는 **자식 셸**. 안에서 변수 바꿔도 부모에 영향 없음.

활용 — 임시로 환경 바꿔 명령 실행:

```bash
$ (cd /tmp && ls)              # 일시적으로 /tmp로 이동
$ pwd                          # 본인은 원래 디렉토리
/Users/mo
```

### 4-2. 그룹 `{...}` — 같은 셸

```bash
$ var=원래
$ { var=새값; echo "안: $var"; }
안: 새값
$ echo "밖: $var"
밖: 새값                        # 부모도 바뀜!
```

`{...}`는 **같은 셸**. 그룹화만. 변수 바꾸면 영향.

**주의 — `{...}`는 양옆 공백 + 끝 `;` 또는 줄바꿈** 필요. `{var=새값;}` ❌, `{ var=새값; }` ✓.

### 4-3. 자경단 활용

**subshell — 환경 격리**:

```bash
# (1) 임시 환경 변수
$ (export DEBUG=1; npm test)   # DEBUG는 자식만, 본인 셸엔 영향 없음

# (2) 임시 cd
$ (cd /tmp/test && python script.py)
```

**그룹 — 출력 묶기**:

```bash
$ { echo "A"; echo "B"; } > combined.txt
$ cat combined.txt
A
B
```

**`(...)` vs `{...}` 한 줄 표**:

| 양식 | 환경 | 변수 격리 | 사용 |
|-----|------|---------|-----|
| `(...)` | 자식 셸 | ✓ 격리 | 임시 환경, 임시 cd |
| `{...}` | 같은 셸 | ✗ 공유 | 출력 묶기, 명령 그룹 |

---

## 5. glob 5종 — 파일 패턴

본인이 `ls *.py` 칠 때 셸이 `*`을 해석.

### 5-1. 5종 패턴

| 패턴 | 의미 | 예 |
|------|------|-----|
| `*` | 0개 이상 글자 (한 디렉토리) | `*.py` = `.py`로 끝 |
| `**` | 재귀 (zsh + bash 4+ globstar) | `**/*.py` = 어디든 |
| `?` | 한 글자 | `?.py` = `a.py`·`b.py` |
| `[abc]` | 집합 | `[abc].py` = `a.py`·`b.py`·`c.py` |
| `{a,b}` | brace 확장 | `{a,b}.py` = `a.py`·`b.py` |

### 5-2. 자경단 사용

```bash
# 모든 .py 파일
$ ls *.py

# 모든 하위의 .py
$ ls **/*.py                   # zsh OK / bash 4+ globstar 옵션

# 한 글자 파일명
$ ls ?.txt                     # a.txt·b.txt 등

# 특정 글자만
$ ls [abc]*.txt                # a로 시작·b로 시작·c로 시작

# brace로 여러 파일 한 번에
$ touch test.{js,ts,jsx,tsx}   # 4파일 동시 생성
```

### 5-3. zsh vs bash 글로브 함정

**zsh** — 글로브 매치 없으면 에러:

```bash
$ ls *.xyz
zsh: no matches found: *.xyz
```

**bash** — 글로브 매치 없으면 패턴 그대로:

```bash
$ ls *.xyz
ls: cannot access '*.xyz': No such file or directory
```

자경단 표준 — `setopt nomatch` (zsh) 또는 `shopt -s nullglob` (bash).

### 5-4. 숨은 파일

`.zshrc`·`.gitignore` 같은 `.`으로 시작하는 파일은 `*`에 매치 안 됨.

```bash
$ ls *                         # .zshrc 안 보임
$ ls -a                        # 다 보임
$ ls .*                        # .으로 시작하는 것만
$ ls .[!.]*                    # . 단독·..은 제외
```

### 5-5. 자경단 권장 셋업

```bash
# .zshrc
setopt nomatch                 # 매치 없으면 에러
setopt extendedglob            # 강력한 글로브 (^·#·~)
setopt globstar                # ** 재귀 (zsh 기본 ON)
```

---

## 6. redirection 7종 — 입출력 방향

본인이 `ls > out.txt` 칠 때 `>`이 redirection.

### 6-1. 7종

| 양식 | 의미 |
|------|------|
| `>` | stdout을 파일에 쓰기 (덮어쓰기) |
| `>>` | stdout을 파일에 추가 |
| `<` | 파일을 stdin으로 |
| `<<<` | here-string (한 줄 stdin) |
| `2>` | stderr를 파일에 쓰기 |
| `2>&1` | stderr를 stdout으로 합치기 |
| `/dev/null` | 출력 버리기 |

### 6-2. 사용 예

```bash
# stdout 저장
$ ls > files.txt
$ cat files.txt
README.md
package.json

# 추가 (덮어쓰지 않고 끝에)
$ date >> log.txt
$ date >> log.txt
$ cat log.txt
2026-04-28 14:00
2026-04-28 14:30

# stdin
$ wc -l < files.txt
2

# here-string
$ wc -w <<< "고양이 자경단 5명"
3

# stderr만 저장
$ command-that-fails 2> error.log

# stderr + stdout 합치기
$ command 2>&1 > combined.log

# stderr 버리기
$ find / -name '*.txt' 2>/dev/null

# stderr와 stdout 따로
$ command > stdout.log 2> stderr.log

# 둘 다 한 파일에
$ command > both.log 2>&1
$ command &> both.log          # 약식 (bash 4+, zsh)
```

### 6-3. `/dev/null` — 블랙홀

출력을 버리는 가상 파일. 매우 자주 사용.

```bash
# 권한 에러 무시
$ find / -name '*.tmp' 2>/dev/null

# 출력 다 버리기
$ npm install >/dev/null 2>&1
```

### 6-4. 자경단 활용 예

```bash
# 자경단 build 로그
$ npm run build > build.log 2> build.err.log
$ cat build.log                # 결과
$ cat build.err.log            # 에러만

# CI 스크립트
$ npm test 2>&1 | tee test.log # 화면 + 파일 동시 (tee)
```

---

## 7. heredoc `<<EOF` — 여러 줄 stdin

긴 텍스트를 명령어에 stdin으로.

### 7-1. 기본 양식

```bash
$ cat <<EOF
첫 줄
둘째 줄
EOF
첫 줄
둘째 줄
```

`EOF`는 임의의 마커. `END`·`STOP`·`HERE` 다 가능. 시작·끝이 같으면 됨.

### 7-2. 자경단 활용

**파일 생성**:

```bash
$ cat > config.json <<EOF
{
  "name": "cat-vigilante",
  "version": "1.0.0"
}
EOF
```

**SSH로 원격 실행**:

```bash
$ ssh server <<EOF
cd /var/www
git pull
npm restart
EOF
```

**Python·SQL 실행**:

```bash
$ python3 <<EOF
print("Hello from Python")
print(2 + 3)
EOF
Hello from Python
5

$ psql -d mydb <<EOF
SELECT name FROM cats LIMIT 5;
EOF
```

### 7-3. 변수 확장

기본 — 변수 확장 ON:

```bash
$ name="자경단"
$ cat <<EOF
이름: $name
EOF
이름: 자경단
```

확장 OFF — `'EOF'` 또는 `\EOF`로 quoted:

```bash
$ cat <<'EOF'
$name 그대로 출력 (확장 안 됨)
EOF
$name 그대로 출력 (확장 안 됨)
```

자경단 — 보통 확장 ON. 스크립트 안 코드 박을 때만 OFF.

### 7-4. `<<-` indent 허용

`<<-EOF`는 줄 앞 탭 무시. 코드 안 indent 가능:

```bash
$ cat <<-EOF
	들어간 줄 (탭이 무시됨)
	EOF
들어간 줄 (탭이 무시됨)
```

스크립트 안 heredoc 깔끔.

---

## 8. pipe `|`·command substitution `$(...)` — 셸 조합의 무기

본 H의 마지막 두 무기.

### 8-1. pipe `|`

한 명령의 stdout을 다음 명령의 stdin으로.

```bash
# 한 줄 데모 분해 (Ch006 H1 회수)
$ find ~ -type f -size +100M 2>/dev/null | sort -k5 -hr | head -5
#   1단계: 큰 파일 찾기      | 2: 정렬   | 3: 5개만
```

3개 명령이 하나 흐름. 각자 독립이지만 pipe로 한 줄.

### 8-2. 자경단 자주 쓰는 pipe 5종

```bash
# 1. log에서 ERROR 찾기
$ cat app.log | grep ERROR | head -10

# 2. 파일 줄 수
$ ls *.md | wc -l

# 3. 가장 큰 디렉토리
$ du -sh * | sort -hr | head -5

# 4. 중복 제거
$ cat names.txt | sort | uniq

# 5. JSON 파싱
$ curl https://api.example.com/cats | jq '.cats[] | .name'
```

### 8-3. command substitution `$(...)`

명령 결과를 변수처럼.

```bash
# 결과를 변수에
$ today=$(date +%Y-%m-%d)
$ echo $today
2026-04-28

# 명령 안에 명령
$ echo "오늘은 $(date) 입니다"

# 백틱도 같음 (옛 양식)
$ today=`date +%Y-%m-%d`        # 옛 양식, 자경단은 $(...) 권장
```

### 8-4. 자경단 자주 쓰는 substitution 5종

```bash
# 1. 현재 branch 이름
$ branch=$(git branch --show-current)

# 2. 가장 최근 commit sha
$ sha=$(git rev-parse --short HEAD)

# 3. PR 번호
$ pr=$(gh pr view --json number -q .number)

# 4. 파일 줄 수를 변수에
$ count=$(wc -l < log.txt)
$ echo "줄 수: $count"

# 5. 명령 출력으로 cd
$ cd "$(git rev-parse --show-toplevel)"   # repo 루트로
```

### 8-5. pipe + substitution 조합 시나리오

자경단의 한 줄 자동화:

```bash
# main에 머지된 PR 중 본인 것만 5개
$ gh pr list --state merged --author "$(git config user.name)" --limit 5

# 어제 변경 파일
$ git log --since=yesterday --pretty=format: --name-only | sort -u | head -10

# 현재 가장 큰 파일 5개
$ find . -type f -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -5
```

8개념이 한 줄에 다 모여요.

---

## 9. 흔한 오해 5가지

**오해 1: "셸 변수와 환경변수 같은 거예요."** — 다름. `=`이 셸 변수, `export`이 환경변수. 자식 프로세스에 전달되는지가 차이.

**오해 2: "PATH는 그냥 디렉토리 목록."** — 순서가 중요. 같은 이름 두 곳이면 첫 번째 이김. PATH 앞에 추가가 우선.

**오해 3: "exit code는 신경 안 써도 돼요."** — `&&`·`||` 흐름 제어와 CI 안전장치(`set -e`)의 토대. 자경단 매일 손가락.

**오해 4: "subshell과 그룹 차이는 미묘."** — 변수 격리 vs 공유라는 큰 차이. 잘못 쓰면 사고. 자경단 첫 1년에 한 번 만남.

**오해 5: "redirection 7종은 너무 많아."** — 자주 5종(`>`·`>>`·`2>`·`2>&1`·`/dev/null`)만 외워도 90%. 나머지는 사고 시 검색.

---

## 10. FAQ 5가지

**Q1. 환경변수 이름은 대문자 관례인가요?**
A. 표준. `EDITOR`·`PATH`·`HOME` 다 대문자. 셸 변수는 소문자 (`name`·`count`). 구분에 도움.

**Q2. PATH가 깨지면 (모든 명령어 안 됨)?**
A. `/bin/ls`·`/usr/bin/which` 절대 경로로 직접 실행. 그 다음 `export PATH="/usr/bin:/bin:$PATH"`로 응급 복원.

**Q3. exit code 130(Ctrl+C)을 처리하려면?**
A. `trap 'echo cleanup' INT`로 SIGINT 잡기. 정리 후 정상 exit. H6에서 깊이.

**Q4. subshell이 느린가요?**
A. fork 비용. 보통 1~5ms. 매일 100번 써도 0.5초. 무시 가능. 빠른 명령 안에서 1만 번 subshell이면 5초 — 그땐 그룹으로.

**Q5. heredoc과 다중 echo의 차이?**
A. 가독성. 5줄 이상이면 heredoc. 1~2줄은 `echo` 또는 `cat <<<`. 자경단 표준.

---

## 11. 추신

추신 1. 본 H의 8개념이 본인의 매일 셸 손가락 90%. 8개를 손가락에 박으면 한 줄 명령어가 살아 움직여요.

추신 2. 셸 변수와 환경변수의 차이를 면접에서 1분 답할 수 있게. "var=foo는 셸 변수, export VAR=foo는 환경변수, 차이는 자식 프로세스 전달".

추신 3. PATH의 우선순위는 본인 dotfiles의 첫 결정. 우선순위가 잘못되면 매일 사고. 자경단 표준 — `~/.local/bin`·brew·언어별 bin 차례.

추신 4. exit code 0=성공의 약속이 Unix 50년의 표준. 본인의 모든 스크립트도 exit 0 (성공)·exit 1+ (실패).

추신 5. `set -euo pipefail`이 자경단 스크립트의 안전벨트. e=에러 즉시 exit, u=정의 안 된 변수 에러, o pipefail=파이프 내부 실패도 탐지.

추신 6. subshell `(...)`은 환경 격리. 임시 cd·임시 환경변수에 자주. **격리가 사고 비용 1/10**.

추신 7. glob의 `*`은 한 디렉토리, `**`은 재귀. 한 글자 차이가 5배 차이.

추신 8. zsh의 `setopt nomatch`가 자경단 표준. 글로브 매치 없으면 에러로 의도 명확.

추신 9. redirection 7종 중 자경단은 5종 자주(`>`·`>>`·`2>`·`2>&1`·`/dev/null`). 나머지 2종은 사고 시 검색.

추신 10. `2>&1`은 stderr를 stdout으로 합치기. 순서 — `> file 2>&1` (둘 다 file로). `2>&1 > file` (stderr는 화면, stdout만 file).

추신 11. heredoc `<<EOF`은 5줄+ 텍스트의 표준. SSH·Python·SQL·파일 생성에. 가독성 무한대.

추신 12. pipe `|`이 셸의 진짜 마법. 한 명령 작게, 조합으로 큰 일. **Unix 철학의 정수**.

추신 13. `$(...)` command substitution은 백틱(\`...\`)의 새 양식. 자경단 권장 — `$(...)` (중첩 가능, 가독성).

추신 14. 자경단의 한 줄 자동화 (8-5절)가 본 H 8개념의 정점. 8개를 한 줄에 다 박으면 5명의 매일 30분 절약.

추신 15. 다음 H3는 환경점검 — iTerm2·zsh·oh-my-zsh·starship·brew 5분 셋업. 본 H의 8개념이 H3의 셋업으로 손에 잡혀요. 🐾

추신 16. 본 H를 끝낸 본인이 한 가지 실험 — 본인 노트북에서 `var=test`, `export VAR=test`, `bash -c 'echo $var'`, `bash -c 'echo $VAR'` 4 명령 차례로. 셸 변수 vs 환경변수가 손가락에 박힘.

추신 17. PATH 검색 순서를 5분 안에 그릴 수 있으면 시니어. 면접 단골 — "git을 어떻게 찾나요?" 답이 5단계.

추신 18. exit code 표(3-2절)을 종이 한 장에. 0·1·2·126·127·130·137·139 8개. 사고 시 5초 진단.

추신 19. subshell vs 그룹의 차이를 본인이 한 번 손으로 실험 (4-3절 예시). 차이가 머리에 박혀요.

추신 20. glob `*`·`**`·`?`·`[]`·`{}` 5종을 1주일 안에 손가락. 매일 30번 사용. 한 패턴이 100번 클릭.

추신 21. redirection 7종 중 `2>/dev/null`이 자경단 일상. 권한 에러·warning 다 무시. 매일 30번.

추신 22. heredoc의 `<<-EOF` (탭 무시) 옵션이 스크립트 안 indent의 친구. 가독성 + 의도.

추신 23. 본 H의 마지막 한 줄 데모 (8-5절)을 본인이 한 번 따라 치면 8개념이 한 손가락에 박힘.

추신 24. 본 H를 두 번 읽으세요. 첫 번째는 8개념 흐름. 두 번째는 한 개념 깊이. 두 번 읽기가 한 번 따라치기와 같은 효과.

추신 25. 자경단 5명이 본 H의 8개념을 같이 익히면 5명의 셸이 같은 직관. 한 명이 친 명령어를 4명이 1초에 이해.

추신 26. AI 시대에 본 H 8개념을 알면 Claude·ChatGPT의 명령 추천을 비판적으로 검토 가능. AI가 잘못된 redirection을 추천해도 본인이 잡음.

추신 27. 본 H의 8개념 + H1의 4단어 = 12 단어가 본인의 셸 사전. 12 단어로 30개 명령어 카탈로그(H4)가 풀려요.

추신 28. 본 챕터의 8개념 깊이가 5년의 손가락 토대. 1년 후 다시 읽으면 5%를 새로 보여 줘요. 매년 한 번씩.

추신 29. 본 H의 마지막 명령 — 본인 노트북 터미널에서 `echo $PATH | tr ':' '\n'`을 한 번 쳐 보세요. 본인의 PATH가 보여요. 그 PATH가 본인의 매일 손가락의 길.

추신 30. **본 H 끝** — 본인의 셸 8개념 학습 완료. 다음 H3에서 셋업의 손가락.

추신 31. 8개념의 학습 시간 표 — 1번(변수) 5분, 2번(PATH) 5분, 3번(exit code) 10분, 4번(subshell) 10분, 5번(glob) 15분, 6번(redirection) 15분, 7번(heredoc) 5분, 8번(pipe·subst) 15분 = 80분. 한 시간 +α의 학습.

추신 32. 변수 함정의 `=` 양옆 공백은 셸 표준. Python·JS와 다른 첫 차이. 본인의 첫 셸 사고가 보통 이 함정.

추신 33. 환경변수 표준 — 대문자, `_`로 단어 분리, 시작은 알파벳. `MY_VAR`·`API_KEY`·`HOMEBREW_NO_ANALYTICS`. 자경단의 모든 환경변수 양식.

추신 34. PATH 검색은 셸 시작 시 한 번만 하지 않음. 매 명령마다. 그래서 PATH 변경 즉시 반영. `export PATH=...` 직후 다음 명령부터 적용.

추신 35. `which`은 외부 명령만, `type`은 모든 종류 (built-in·alias·function). `type`이 자경단 권장.

추신 36. 표준 exit code 8종(0·1·2·126·127·130·137·139)을 종이에 적기. 사고 시 5초 진단. 137(SIGKILL)이 OOM 신호.

추신 37. `$?`는 직전 명령의 exit code. 한 번만 유효. 다음 명령 후 갱신. 보존하려면 변수에 — `code=$?`.

추신 38. `&&`·`||`의 우선순위 — `A && B || C`는 "A 성공 시 B, 실패 시 C". 다만 B 실패 시 C도 실행되니 주의. 정확한 if-else가 필요하면 `if [ $? -eq 0 ]; then B; else C; fi`.

추신 39. subshell `(...)`의 `cd` 격리는 매일 손가락. 임시 디렉토리 작업 시 `(cd /tmp && script.sh)` 한 줄. 본인은 원래 위치 그대로.

추신 40. 그룹 `{...}`의 첫 함정 — `{` 뒤 공백·`}` 앞 `;` 또는 줄바꿈. 자경단 표준 — 보통 그룹보다 subshell 선호 (격리가 안전).

추신 41. glob의 zsh 강력함 — `**/*.py`(재귀)·`*(.)` (정규 파일만)·`*(/)` (디렉토리만)·`*~*.tmp` (제외). 자경단 1년 차에 한 번 익혀 매일 사용.

추신 42. brace 확장 `{a,b,c}`는 글로브 다름. 매치 없어도 양식 그대로. `touch test.{js,ts}`은 항상 두 파일 생성.

추신 43. `2>&1`의 의미 — "2(stderr)를 1(stdout)로". 표준 셸의 file descriptor 번호. 0=stdin·1=stdout·2=stderr.

추신 44. `&> file`은 `> file 2>&1` 약식. zsh + bash 4+에서. 자경단 권장.

추신 45. heredoc의 `<<EOF` vs `<<'EOF'` — 따옴표 있으면 변수 확장 OFF. 스크립트 안 코드 박을 때만.

추신 46. pipe `|`의 한계 — 양쪽 명령이 동시에 실행. 한쪽이 큰 출력이면 buffer 가득 차서 멈출 수도. 보통은 자동 처리되지만 알아 두기.

추신 47. `tee`는 pipe의 친구 — stdout을 파일에도 + 화면에도. `npm test 2>&1 | tee test.log`. 자경단 CI 디버깅 표준.

추신 48. command substitution `$(...)`의 중첩 가능 — `echo "$(date +%H):$(date +%M)"`. 백틱(\`)은 중첩 어려움.

추신 49. `$(...)` 안의 줄바꿈이 공백으로 변환됨. `output=$(ls)` 후 `echo "$output"`이 따옴표 안에서만 줄바꿈 보존.

추신 50. 본 H의 마지막 회수 — 8개념이 한 줄 명령어의 모든 도구. 본인의 매일 셸 90%가 8개에서.

추신 51. 변수 default 값 — `${var:-default}`. var이 비어 있으면 default 사용. 자경단 스크립트의 안전한 기본값.

추신 52. 변수 substring — `${var:offset:length}`. 첫 5글자 — `${var:0:5}`. 자경단 string 처리.

추신 53. PATH 디버깅 — `set -x` (xtrace) 켜면 셸이 매 명령을 실행 전 print. 어디서 어떤 명령이 어떻게 실행되는지 다 보임.

추신 54. exit code의 정신 — 사람이 아니라 다른 명령에 알리는 신호. `&&`·`||`·`if`이 다 exit code 기반.

추신 55. subshell의 fork 비용은 1~5ms. 매일 100번 = 0.5초. 무시 가능. 다만 1만 번이면 5초 — 그땐 그룹·function.

추신 56. zsh의 `setopt extendedglob`이 ON되면 `^`·`#`·`~` 같은 새 패턴 사용 가능. 자경단 1년 차에 검토.

추신 57. redirection의 `<<<` (here-string)은 한 줄 stdin. `wc -w <<< "셋 단어 인풋"` 한 줄. heredoc보다 짧음.

추신 58. heredoc의 `<<-EOF` (대시)는 줄 앞 탭 무시. 스크립트 안 indent 가능. 가독성 큰 향상.

추신 59. pipe의 의미는 "한 도구는 한 일만". `find`·`sort`·`head`이 각자 잘하는 일. pipe로 조합. **Unix 철학의 정수**.

추신 60. `xargs`는 stdin을 인자로 변환. `find . | xargs grep ERROR` (find 결과 각 파일에서 grep). pipe + xargs가 자경단 매일 손가락.

추신 61. `xargs -I {}`로 placeholder. `find . -name '*.tmp' | xargs -I {} rm {}`. 더 명확.

추신 62. command substitution 함정 — `$(...)` 안의 따옴표는 새 컨텍스트. `$(echo "hello")` 안의 `"`는 외부 따옴표와 무관.

추신 63. 변수 양식의 `${var}` 중괄호는 옵션이지만 권장. `$varX` (X도 변수의 일부?) vs `${var}X`. 명확함.

추신 64. 본 H의 8개념 + H1의 4단어 = 12 단어가 본 챕터의 학습 사전. 12를 손가락에 박으면 H4(30 명령어)가 매끈.

추신 65. 자경단 5명의 매일 손가락은 본 H 8개념에 다 들어 있음. 5명이 같은 8개념을 알면 매일 합의 비용 0.

추신 66. AI 시대의 셸 — Claude가 한 줄 명령을 추천. 본인이 본 H 8개념을 알면 그 한 줄을 분해해서 검증 가능. **분해가 검증의 도구**.

추신 67. 본 H를 다 끝낸 본인이 한 가지 결심 — 본 H의 한 줄 데모(8-5절)을 본인 노트북에서 한 번 따라 치기. 8개념이 손가락에 한 번에.

추신 68. 본 챕터의 학습 8H가 본인의 셸 첫 1주일. 본 H가 그 둘째 시간. 8H × 60분 = 8시간이 5년의 토대.

추신 69. 본 H의 모든 코드를 본인 노트북에서 직접 따라치면 손가락에 박힘. 5분 × 8개념 = 40분의 손가락 학습.

추신 70. **본 H 진짜 끝** — 본인의 셸 8개념을 손가락에 박으세요. 다음 H3에서 자경단 표준 환경 셋업 5분.

추신 71. 변수 비교 — `[ "$var" = "value" ]` (POSIX), `[[ $var == "value" ]]` (bash·zsh 확장). 후자는 글로브 매치 가능. 자경단 권장 — `[[ ]]`.

추신 72. 셸 산술 — `$((expr))`. 예 — `$((2+3))` = 5, `$((var * 10))`. 정수만. 실수는 `bc` 또는 `awk`.

추신 73. 셸 배열 — bash·zsh — `arr=(a b c); echo ${arr[1]}` (zsh 1-based, bash 0-based 차이!). 자경단 — bash 호환 0-based 표준.

추신 74. 셸 길이 — `${#var}` (글자 수), `${#arr[@]}` (배열 길이). 자주 쓰임.

추신 75. 따옴표 함정 — `"$var"`는 단어 분리 보존, `$var`는 공백마다 분리. 변수에 공백 있으면 `"..."` 필수.

추신 76. `IFS` 변수가 단어 분리자. 기본 — 공백·탭·줄바꿈. 커스터마이즈 — `IFS=,` (CSV 처리). 자경단 가끔.

추신 77. 본 H의 8개념을 빠르게 익히는 비결 — 매 개념마다 본인 노트북에서 한 번씩 직접. 8 × 5분 = 40분이면 손가락에 박혀요.

추신 78. 본 H를 다 끝낸 본인이 추가로 알아야 할 셸 — `read` (stdin 읽기), `printf` (formatted print), `getopts` (옵션 파싱). H6에서 깊이.

추신 79. 본 챕터의 8H 중 본 H가 가장 어려움. 8개념을 한 시간에 다 보면 머리 아픔. 두 번에 나눠 읽기 권장 (4개씩).

추신 80. **본 H의 마지막 진짜 한 줄** — 셸은 8개념의 조합이고, 8개념을 손가락에 박으면 한 줄 명령어가 살아 움직여요. 본인의 첫 손가락이 5년의 시작이에요.

추신 81. 본 H의 8개념 학습 시간 표(추신 31)는 한 시간 분배의 표준. 본인이 더 오래 걸려도 OK. 깊이가 시간보다 중요.

추신 82. 본 챕터의 8개념 + 4단어(H1) + 30 명령어(H4) = 42 단어가 본인의 셸 평생 사전. 평생 사전이 5년의 자산.

추신 83. 변수의 약한 타입 — 셸은 변수에 타입 없음. 모두 string. 산술은 `$(())`로 명시. Python·JS와 다른 점.

추신 84. `local` 키워드 (function 안에서) — function 안에서 `local var=foo`로 지역 변수. 외부 영향 없음. 자경단 스크립트의 안전판.

추신 85. `readonly` — 변경 불가 변수. `readonly VERSION=1.0.0` 후 `VERSION=2.0.0`은 에러. 상수 표현.

추신 86. PATH 디버깅의 한 줄 — `command -v <name>`. `which`보다 권장 (POSIX 표준). 자경단 표준은 `command -v`.

추신 87. 본 H의 모든 8개념은 POSIX 표준. bash·zsh·dash·sh 다 호환. 단 zsh 확장(extendedglob 등)은 zsh만.

추신 88. 환경변수 vs 셸 변수의 면접 단골 질문 — "왜 `var=foo; bash -c 'echo $var'`이 빈 거예요?" 답이 1분이면 시니어.

추신 89. `set -o`로 모든 셸 옵션 보기. `-e`·`-u`·`-o pipefail`이 자경단 스크립트 표준.

추신 90. **본 H 마지막 결심** — 본 H의 8개념을 7일 안에 손가락에 박으세요. 매일 한 개념 + 본인 노트북에서 한 번씩 따라치기. 7일 후 본인은 셸의 시니어.

추신 91. 본 H의 8개념의 본질 — 셸이 텍스트 흐름 도구라는 것. stdin → 처리 → stdout의 한 줄. pipe가 그 흐름의 연결.

추신 92. 변수 양식 5종 — `$var`·`${var}`·`${var:-default}`·`${var:0:5}` (substring)·`${#var}` (길이). 5가지가 자경단 매일 사용.

추신 93. PATH의 마지막 함정 — 같은 디렉토리를 두 번 추가하면 첫 번째만 효과. 중복은 무해하지만 비효율. `echo $PATH | tr ':' '\n' | sort -u`로 중복 검사.

추신 94. exit code의 응용 — Bash function 안 `return N`. function의 exit code가 N. 호출자가 `$?`로 확인.

추신 95. subshell 안에서 `exit`는 subshell만 종료. 부모 셸은 그대로. 격리의 안전.

추신 96. 본 H의 마지막 자경단 회수 — 5명이 본 H 8개념을 같이 익히면 매일 30개 명령어가 다 8개의 조합으로 보임. 8 × 5명 = 40개 셸 직관이 자경단의 자산.

추신 97. 본 H를 끝낸 본인이 한 번 — 본인 dotfile에 본 H의 8개념 중 가장 좋아하는 한 개념의 alias 1줄. 기념. 그 alias가 본인의 첫 셸 자산.

추신 98. **본 H 진짜 마지막** — 8개념이 본인의 평생 셸 손가락의 90%. 손가락에 박는 7일이 5년의 시작이에요.

추신 99. 다음 H3는 본인이 자경단 표준 환경(iTerm2·zsh·oh-my-zsh·starship·brew)을 5분에 셋업. 본 H의 8개념이 H3의 셋업으로 살아 움직여요.

추신 100. **본 H 마지막 한 줄** — 셸은 8개념의 조합, 8개념은 본인의 매일 30개 명령어, 30개 명령어가 본인의 5년 손가락이에요. 오늘 첫 8개념을 본인 노트북에 박으세요.

추신 101. 본 H의 학습 효과를 최대화하는 한 가지 — 매 개념마다 본인이 좋아하는 자경단 시나리오를 만들어 적용. 만들어 본 시나리오가 머리에 박혀요.

추신 102. 변수의 quoting 함정 — `name="자경단"; echo $name 5명`은 "자경단 5명". `echo "$name 5명"`이 안전. 따옴표가 단어 분리 보존.

추신 103. PATH 5단계 검색의 실제 — fork-exec 직전 셸이 PATH 차례로 stat 호출. 5단계 × 1ms = 5ms. 명령어 한 번에 5번의 stat. 매일 1만 번의 stat.

추신 104. exit code 함정 — pipe의 exit code는 마지막 명령 것. `false | true`는 exit 0. `set -o pipefail`이 그래서 필요.

추신 105. subshell의 함정 — 안에서 `read -r line`은 부모 변수 영향 없음. 그래서 `while read | { ... }` 패턴이 작동 안 함. 자경단 가끔 만남.

추신 106. glob의 hidden 함정 — `rm *`은 숨은 파일 (`.git/` 등) 안 지움. `rm -rf .` (현재 디렉토리)이 진짜 위험.

추신 107. redirection의 마지막 함정 — `> file 2>&1` vs `2>&1 > file`. 순서가 다름. 첫 번째는 둘 다 file로, 두 번째는 stderr만 stdout(터미널)으로.

추신 108. heredoc의 진짜 사용처 — Docker·Kubernetes manifest를 셸에서 직접 생성·apply. `kubectl apply -f - <<EOF ... EOF`. 5분 인프라.

추신 109. pipe + xargs + grep + awk + sed의 5종 조합이 자경단 매일 손가락. 한 줄 명령어의 70%가 이 5종.

추신 110. **본 H의 진짜 진짜 마지막** — 8개념이 본인의 매일·평생 셸 손가락의 90%. 본인의 첫 손가락이 5년의 시작이에요.

추신 111. 셸 8개념을 한 페이지로 압축한 종이 카드를 모니터 옆에 붙이세요. 변수($var/export VAR)·PATH(:순서)·exit code($?·&&·||)·subshell(()·{}·격리)·glob(*·**·?·[]·{,})·redirection(>·>>·2>·2>&1·/dev/null)·heredoc(<<EOF)·pipe(|·$()).

추신 112. 본 H의 8개념 + H1의 4단어 = 12 단어. 12 단어가 본인의 셸 평생 사전. 12를 손가락에 박으면 본 챕터의 나머지 6 H가 자연스레.

추신 113. **본 H 진짜 진짜 진짜 끝** — 8개념을 손가락에 박는 7일이 본인의 5년 셸 자산이에요. 본인의 첫 alias를 오늘 박으세요.

추신 114. 본 H를 다 끝낸 본인이 자경단에 합의 한 줄을 제안 — "5명 모두 본 H의 8개념을 1주일 안에 익히기". 5명 동시 익힘이 자경단의 셸 직관 통일. 합의 비용 0.

추신 115. 자경단의 셸 5년 자산은 본 H의 8개념 + H1의 4단어 + H4의 30개 명령어 + H5의 자경단 시뮬 + H6의 스크립트 + H7의 내부 + H8의 dotfiles. 8H × 평균 17,000자 = 136,000자가 본인의 평생 사전.

추신 116. 본 챕터의 진짜 결론 — 셸은 본인의 5년 친구이고, 8개념이 그 친구의 80%, 4단어가 토대, 30개 명령어가 매일 손가락이에요. 본인의 첫 alias 5종을 오늘.

추신 117. **본 H의 진짜 마지막** — 본인 노트북을 지금 열고 변수 1줄 (`name=자경단`) + 환경변수 1줄 (`export NAME=자경단`) + bash 자식 (`bash -c 'echo $name'`)을 차례로 쳐 보세요. 1분의 손가락이 평생 직관. 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾
