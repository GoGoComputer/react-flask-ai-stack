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

> ▶ **같이 쳐보기** — 변수 한 개 만들고 읽기
>
> ```bash
> name="고양이 자경단"
> echo $name
> ```

**자식 프로세스에 전달 안 됨**. 이 변수는 본인의 zsh 셸 안에서만.

```bash
$ name="자경단"
$ bash -c 'echo $name'      # 자식 bash에선 빈 문자열
                            # (자식이 못 봄)
```

### 1-2. 환경변수

`export`로 마킹한 변수. **자식 프로세스에 전달**.

> ▶ **같이 쳐보기** — export 한 변수가 자식 프로세스에 전달되는지
>
> ```bash
> export NAME="자경단"
> bash -c 'echo $NAME'      # 자식이 받음
> ```

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

> ▶ **같이 쳐보기** — 본인 PATH 의 검색 순서 한 줄씩
>
> ```bash
> echo $PATH | tr ':' '\n'
> ```

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

## 추신

본 H의 8개념이 본인의 매일 셸 손가락 90%. 8개를 손가락에 박으면 한 줄 명령어가 살아 움직여요. 셸 변수와 환경변수의 차이를 면접에서 1분 답할 수 있게. "var=foo는 셸 변수, export VAR=foo는 환경변수, 차이는 자식 프로세스 전달". PATH의 우선순위는 본인 dotfiles의 첫 결정. 우선순위가 잘못되면 매일 사고. 자경단 표준 — `~/.local/bin`·brew·언어별 bin 차례.

