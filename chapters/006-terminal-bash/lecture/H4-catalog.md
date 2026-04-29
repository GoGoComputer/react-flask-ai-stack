# Ch006 · H4 — 터미널·셸·Bash: 명령어 카탈로그 — 30개 셸 명령어와 위험도 신호등

> **이 H에서 얻을 것**
> - 자경단 매일 셸 명령어 30개 한 표 + 위험도 신호등 (🟢🟡🔴)
> - 6 무리(파일·검색·텍스트·프로세스·네트워크·아카이브) × 평균 5개 깊이
> - 매일·주간·월간 손가락 리듬 — 셸 13줄 흐름
> - 모던 대체 도구 5종 — `rg` (ripgrep)·`fd`·`bat`·`exa`·`delta`
> - 면접 단골 질문 — "터미널 한 줄로 X 하기" 5종

---

## 회수: H3의 셋업에서 본 H의 손가락으로

지난 H3에서 본인은 자경단 표준 환경(brew·iTerm2·zsh·oh-my-zsh·starship·tmux + dotfiles)을 30분에 셋업했어요. 그건 환경의 토대.

이번 H4는 그 환경에서 **본인이 매일 치는 30개 명령어**예요. 손가락 30개가 1년 100만 번. 한 명령어가 평생 자산.

H1의 4단어, H2의 8개념, H3의 6도구가 본 H의 30 명령어로 풀려요. 30개 + 모던 대체 5종 = 자경단의 매일 셸.

---

## 1. 위험도 신호등 — 한 줄 정의 (Ch005 H4 회수)

- 🟢 **초록 (read-only)** — 정보 읽기, 사고 0
- 🟡 **노랑 (local 변경)** — 본인 노트북만, 보통 복구 가능
- 🔴 **빨강 (irreversible)** — 되돌리기 어려움, 1초 호흡

본 H의 30 명령어 중 빨강 5개만 1초 호흡. 나머지 25개는 안전.

---

## 2. 30개 명령어 한 표

| # | 명령어 | 무리 | 신호등 | 한 줄 정의 |
|---|--------|------|-------|----------|
| 1 | `ls` | 파일 | 🟢 | 디렉토리 내용 |
| 2 | `cd` | 파일 | 🟢 | 디렉토리 이동 |
| 3 | `pwd` | 파일 | 🟢 | 현재 디렉토리 |
| 4 | `mkdir` | 파일 | 🟡 | 디렉토리 생성 |
| 5 | `cp` | 파일 | 🟡 | 파일 복사 |
| 6 | `mv` | 파일 | 🟡 | 이동/이름 변경 |
| 7 | `rm` | 파일 | 🔴 | 삭제 (`-rf` 위험) |
| 8 | `touch` | 파일 | 🟡 | 빈 파일 생성·timestamp |
| 9 | `find` | 검색 | 🟢 | 파일 찾기 (재귀) |
| 10 | `grep` | 검색 | 🟢 | 텍스트 패턴 검색 |
| 11 | `rg` (ripgrep) | 검색 | 🟢 | grep 빠른 대체 |
| 12 | `fd` | 검색 | 🟢 | find 빠른 대체 |
| 13 | `which`/`type` | 검색 | 🟢 | 명령어 위치 |
| 14 | `cat` | 텍스트 | 🟢 | 파일 출력 |
| 15 | `bat` | 텍스트 | 🟢 | cat 색깔 강화 |
| 16 | `head`/`tail` | 텍스트 | 🟢 | 첫·마지막 N줄 |
| 17 | `less` | 텍스트 | 🟢 | 페이지 단위 보기 |
| 18 | `wc` | 텍스트 | 🟢 | 줄·단어·글자 수 |
| 19 | `sort` | 텍스트 | 🟢 | 정렬 |
| 20 | `uniq` | 텍스트 | 🟢 | 중복 제거 |
| 21 | `sed` | 텍스트 | 🟡 | stream editor (치환) |
| 22 | `awk` | 텍스트 | 🟢 | 컬럼 처리 |
| 23 | `jq` | 텍스트 | 🟢 | JSON 처리 |
| 24 | `ps` | 프로세스 | 🟢 | 프로세스 목록 |
| 25 | `top`/`htop` | 프로세스 | 🟢 | 실시간 모니터 |
| 26 | `kill` | 프로세스 | 🔴 | 프로세스 종료 (`-9` 위험) |
| 27 | `curl`/`wget` | 네트워크 | 🟡 | HTTP 요청·다운로드 |
| 28 | `ssh`/`scp` | 네트워크 | 🟡 | 원격 접속·복사 |
| 29 | `tar`/`zip` | 아카이브 | 🟡 | 압축·해제 |
| 30 | `xargs` | 조합 | 🟡 | stdin → 인자 |

---

## 3. 무리 1: 파일 8개 — 매일 손가락

### 3-1. `ls` 🟢

디렉토리 내용. 자주 쓰는 옵션:

> ▶ **같이 쳐보기** — ls 6 변주: long·hidden·human·time·size
>
> ```bash
> ls               # 단순
> ls -l            # long format
> ls -la           # 숨은 파일 포함
> ls -lah          # human readable size
> ls -lt           # 시간순 정렬
> ls -lS           # 크기순 정렬
> ```

**자경단 alias** — `alias ll='ls -lah'`. 매일 50번.

### 3-2. `cd` 🟢

```bash
cd /path/to/dir   # 절대 경로
cd ./relative     # 상대
cd ..             # 부모
cd                # home (~)
cd -              # 직전 디렉토리 (토글)
cd ~/projects     # ~ = home
```

**`cd -` 토글이 자경단 황금 손가락**.

### 3-3. `pwd` 🟢

현재 디렉토리. 스크립트에서 자주.

```bash
$ pwd
/Users/mo/cat-vigilante

# repo root로 이동
$ cd "$(git rev-parse --show-toplevel)"
```

### 3-4. `mkdir` 🟡

```bash
mkdir new-dir
mkdir -p path/to/nested/dir   # 중간 경로 자동 (자경단 표준)
mkdir -p {dir1,dir2,dir3}     # 여러 개 동시
```

`-p`이 자경단 매일. 중간 경로 자동.

### 3-5. `cp` 🟡

```bash
cp src.txt dst.txt           # 파일 복사
cp -r src/ dst/              # 디렉토리 재귀
cp -p src.txt dst.txt        # 권한·시간 보존
cp -i src.txt dst.txt        # 덮어쓰기 전 확인 (안전)
```

`-i`이 사고 방지. `cp -ri src/ dst/`이 안전 표준.

### 3-6. `mv` 🟡

```bash
mv old.txt new.txt           # 이름 변경
mv file.txt /other/dir/      # 이동
mv -i file.txt dest.txt      # 확인
```

mv는 작은 사고 위험. `-i`으로 확인.

### 3-7. `rm` 🔴

빨강. 자경단 5계명:

1. `rm -rf` 사용 전 1초 호흡
2. `rm -i`로 확인 (alias 권장)
3. `rm -rf /` 절대 금지 (시스템 삭제)
4. `rm *` 전 `ls *` 미리 보기
5. trash CLI 권장 (`brew install trash` → `trash file` 휴지통으로)

```bash
rm file.txt                  # 단일 파일
rm -r dir/                   # 디렉토리 재귀
rm -rf dir/                  # 강제 + 재귀 (위험)
```

**자경단 alias** — `alias rm='rm -i'` 또는 `alias rm='trash'` 권장.

### 3-8. `touch` 🟡

```bash
touch new-file               # 빈 파일 생성
touch -t 202604281200 file   # timestamp 변경
touch -d 'yesterday' file    # 어제로
```

빈 파일 생성에 자주.

---

## 4. 무리 2: 검색 5개 — 자경단 매일

### 4-1. `find` 🟢

가장 강력한 검색. 옛 표준.

> ▶ **같이 쳐보기** — find 5 변주: 이름·크기·시간·삭제·명령 실행
>
> ```bash
> find . -name '*.py'                       # 이름
> find . -type f -size +100M                # 100MB 이상
> find . -mtime -1                          # 24시간 안 변경
> find . -name '*.tmp' -delete              # 찾고 삭제
> find . -name '*.txt' -exec ls -lh {} \;   # 명령 실행
> ```

자경단 매일. 5년 자산.

### 4-2. `grep` 🟢

```bash
grep "ERROR" log.txt                      # 한 파일
grep -r "TODO" .                          # 재귀
grep -i "error" log.txt                   # 대소문자 무시
grep -v "DEBUG" log.txt                   # 매치 안 되는 것 (반전)
grep -n "ERROR" log.txt                   # 줄 번호
grep -A 5 "ERROR" log.txt                 # 매치 + 5줄 후
grep -B 5 "ERROR" log.txt                 # 매치 + 5줄 전
```

자경단의 매일 검색. 5년의 친구.

### 4-3. `rg` (ripgrep) 🟢 — 모던 대체

```bash
rg "ERROR"                                # 현재 dir 재귀 (기본)
rg "ERROR" --type py                      # py 파일만
rg -i "error"                             # 대소문자 무시
rg "ERROR" -A 5 -B 5                      # 컨텍스트
```

**grep보다 5~10배 빠름**. .gitignore 자동 무시. 자경단 권장.

### 4-4. `fd` 🟢 — find 모던 대체

```bash
fd '\.py$'                                # 정규식
fd -e py                                  # 확장자
fd -t f                                   # 파일만
fd -t d                                   # 디렉토리만
fd 'pattern' -x ls -lh {}                 # 실행
```

find보다 빠름. 직관적 양식. 자경단 권장.

### 4-5. `which`/`type` (Ch006 H2 회수) 🟢

```bash
which git                                 # 외부 명령 위치
type git                                  # 종류 (built-in·alias·function·외부)
command -v git                            # POSIX 표준 (자경단 권장)
```

---

## 5. 무리 3: 텍스트 처리 9개 — 자경단의 무기

### 5-1. `cat` / `bat` 🟢

```bash
cat file.txt                              # 단순 출력
cat file1 file2 > merged.txt              # 파일 합치기
bat file.py                               # 색깔 + 줄 번호 (모던)
bat -p file.py                            # plain (color만)
```

bat은 cat의 모던 대체. 자경단 alias 가능.

### 5-2. `head` / `tail` 🟢

```bash
head -10 file                             # 첫 10줄
tail -10 file                             # 마지막 10줄
tail -f log.txt                           # 실시간 follow
tail -F log.txt                           # 파일 회전(rotate)도 follow
```

`tail -f`가 로그 모니터의 표준.

### 5-3. `less` 🟢

페이지 단위 보기.

```bash
less file.txt                             # 열기
# 안에서:
/pattern                                  # 검색
n                                         # 다음 매치
N                                         # 이전 매치
g                                         # 첫 줄
G                                         # 마지막 줄
q                                         # 나가기
```

`man` 명령도 less로. 본인 손가락 박힘.

### 5-4. `wc` 🟢

```bash
wc -l file.txt                            # 줄 수
wc -w file.txt                            # 단어 수
wc -c file.txt                            # 글자 수
ls *.md | wc -l                           # md 파일 개수
```

자경단의 빠른 카운트.

### 5-5. `sort` 🟢

> ▶ **같이 쳐보기** — sort 5 변주 + 황금 패턴 sort | uniq -c | sort -rn
>
> ```bash
> sort file.txt
> sort -r file.txt                          # 역순
> sort -n file.txt                          # 숫자 순
> sort -k 2 file.txt                        # 둘째 컬럼 기준
> sort -u file.txt                          # 정렬 + 중복 제거
> # 통계 황금 패턴
> cat access.log | sort | uniq -c | sort -rn | head
> ```

### 5-6. `uniq` 🟢

```bash
sort file.txt | uniq                      # 중복 제거 (sort 필수!)
sort file.txt | uniq -c                   # 카운트
sort file.txt | uniq -d                   # 중복만
```

sort + uniq 짝.

### 5-7. `sed` 🟡

stream editor — 치환의 강력한 도구.

```bash
sed 's/old/new/' file.txt                 # 첫 매치 치환
sed 's/old/new/g' file.txt                # 모두 치환 (global)
sed -i '' 's/old/new/g' file.txt          # 파일 직접 수정 (macOS)
sed -i 's/old/new/g' file.txt             # Linux
sed -n '5,10p' file.txt                   # 5~10 줄만 출력
sed '/pattern/d' file.txt                 # 매치 줄 삭제
```

자경단의 매일 치환. macOS·Linux의 `-i` 양식이 다른 함정.

### 5-8. `awk` 🟢

컬럼 처리.

```bash
awk '{print $1}' file.txt                 # 첫 컬럼
awk -F: '{print $1}' /etc/passwd          # 구분자 :
awk '{sum += $3} END {print sum}' data    # 셋째 컬럼 합
awk 'NR > 1 {print}' csv.txt              # 첫 줄(헤더) 제외
```

자경단의 데이터 처리. 면접 단골.

### 5-9. `jq` 🟢

JSON 처리. 자경단 표준.

```bash
echo '{"name":"cat"}' | jq '.name'                # "cat"
curl api.example.com/cats | jq '.cats[0].name'    # 배열 첫 요소
jq '.cats[] | select(.color=="black")' data.json  # 필터
jq '[.cats[] | .name]' data.json                  # 배열로
```

매일 API 응답 파싱.

---

## 6. 무리 4: 프로세스 3개

### 6-1. `ps` 🟢

```bash
ps                                        # 본인 프로세스
ps aux                                    # 모든 프로세스
ps aux | grep node                        # node 프로세스만
ps -ef                                    # 다른 양식
```

### 6-2. `top` / `htop` 🟢

실시간 모니터.

```bash
top                                       # 기본
htop                                      # 모던 (brew install)
```

htop이 자경단 권장 — 색깔·검색·키 단축.

### 6-3. `kill` 🔴

```bash
kill PID                                  # SIGTERM (정상 종료 요청)
kill -9 PID                               # SIGKILL (강제, 마지막 수단)
killall node                              # 이름으로 모두
pkill -f 'pattern'                        # 패턴 매치 모두
```

`-9`는 강제 — 데이터 손실 가능. 1초 호흡.

---

## 7. 무리 5: 네트워크 2개

### 7-1. `curl` / `wget` 🟡

```bash
curl https://api.github.com/users/me      # GET
curl -X POST -d '{"x":1}' url             # POST
curl -H "Authorization: Bearer xxx" url   # 헤더
curl -O url                               # 파일 다운
curl -L url                               # redirect 따라가기
wget url                                  # 단순 다운로드
```

자경단 — `curl`이 표준. wget은 백업.

### 7-2. `ssh` / `scp` 🟡

```bash
ssh user@server                           # 원격 접속
ssh -p 2222 user@server                   # 포트
scp local.txt user@server:/path/          # 로컬 → 원격
scp user@server:/path/file.txt .          # 원격 → 로컬
ssh user@server 'ls /var/log'             # 원격 한 줄 명령
```

자경단의 미니 매일.

---

## 8. 무리 6: 아카이브·조합 2개

### 8-1. `tar` / `zip` 🟡

```bash
tar -czf backup.tar.gz dir/               # 압축 (gz)
tar -xzf backup.tar.gz                    # 해제
tar -tzf backup.tar.gz                    # 목록 보기
zip -r backup.zip dir/                    # zip
unzip backup.zip                          # 해제
```

`tar -czf`이 자경단 표준. `c=create·z=gzip·f=file`.

### 8-2. `xargs` 🟡

stdin → 인자 변환.

```bash
find . -name '*.tmp' | xargs rm           # 찾고 삭제
find . -name '*.tmp' | xargs -I {} mv {} /trash/   # placeholder
echo "a b c" | xargs -n 1                 # 한 줄에 한 개
ls *.md | xargs wc -l                     # 모든 md 줄 수
```

자경단 매일. pipe + xargs가 강력.

---

## 9. 매일·주간·월간 손가락 리듬 (셸 버전)

### 9-1. 매일 6 손가락

```bash
ls -la                                    # 1. 현재 디렉토리
cd ~/cat-vigilante                        # 2. 자경단 repo
git status -sb                            # 3. git 상태
rg "TODO" .                               # 4. TODO 검색
tail -f log/server.log                    # 5. 로그 모니터
gh pr list                                # 6. PR 목록
```

### 9-2. 주간 5 손가락

```bash
brew upgrade                              # 1. 도구 업데이트 (월요일)
du -sh */ | sort -hr | head               # 2. 큰 디렉토리 (수요일)
git log --since='1 week ago' | wc -l      # 3. 한 주 commit 수
find . -name '*.tmp' -delete              # 4. 청소 (금요일)
docker system prune -a                    # 5. docker 청소
```

### 9-3. 월간 3 손가락

```bash
ls -la ~/.zshrc.d                         # 1. dotfile 회고
brew leaves                               # 2. 직접 설치한 도구
df -h                                     # 3. 디스크 상태
```

---

## 10. 자경단 한 줄 자동화 5종 (셸 버전)

```bash
# 1. 가장 큰 파일 5개
find ~ -type f -size +100M 2>/dev/null | sort -k5 -hr | head -5

# 2. 한 달 commit 수
git log --since='1 month ago' --pretty=format:'%h' | wc -l

# 3. ERROR 모음
rg ERROR --type log --type py | sort | uniq -c | sort -rn | head

# 4. JSON API → 이름 5개
curl -s api.example.com/cats | jq '.cats[].name' | head -5

# 5. 모든 PR 요약
gh pr list --json number,title | jq '.[] | "\(.number): \(.title)"'
```

5 자동화 × 자경단 매일 = 5명의 매일 30분 절약.

---

## 11. 모던 대체 도구 5종

| 옛 | 모던 | 차이 |
|-----|------|------|
| `grep` | `rg` (ripgrep) | 5~10배 빠름·.gitignore 자동 |
| `find` | `fd` | 직관적·빠름 |
| `cat` | `bat` | 색깔·줄 번호 |
| `ls` | `exa` (또는 `eza`) | 색깔·tree·git status |
| `diff` | `delta` (git용) | side-by-side 컬러 |

자경단 — 옛것 알고, 모던으로. 면접에선 옛것 답하기.

---

## 12. 면접 단골 질문 5종

**Q1. "터미널 한 줄로 가장 큰 파일 5개?"**
A. `find ~ -type f -size +100M 2>/dev/null | sort -k5 -hr | head -5`

**Q2. "log에서 ERROR 카운트?"**
A. `grep -c ERROR log.txt` 또는 `rg -c ERROR log.txt`

**Q3. "두 파일의 다른 줄?"**
A. `diff file1 file2` 또는 `comm -23 <(sort f1) <(sort f2)`

**Q4. "프로세스 메모리 사용 Top 5?"**
A. `ps aux | sort -k 4 -rn | head -5`

**Q5. "JSON에서 특정 키만?"**
A. `jq '.key' data.json`

---

## 13. macOS·Linux 명령어 차이 5종

| 작업 | macOS | Linux |
|------|-------|-------|
| `sed -i` | `sed -i ''` (빈 문자열 필요) | `sed -i` (그대로) |
| `date -d` | 안 됨 | `date -d '1 day ago'` |
| `xargs -r` | 옵션 없음 | `xargs -r` (빈 입력 처리) |
| `readlink -f` | 안 됨 | `readlink -f path` |
| `tac` | 없음 (`tail -r` 또는 brew) | `tac` (cat 역순) |

자경단 — macOS 기본 사용 + Linux 호환 검토. 차이 5가지 외우기.

---

## 14. 흔한 오해 7가지

**오해 1: "find와 grep 중 하나로 충분."** — find은 파일, grep은 내용. 둘 다 매일.

**오해 2: "모던 도구 (rg·fd) 쓰면 옛것 잊어요."** — 면접·서버에선 옛것이 표준. 둘 다 알기.

**오해 3: "sed의 macOS·Linux 차이는 작아요."** — `-i` 양식이 다름. 스크립트 호환성 큰 함정.

**오해 4: "kill -9가 안전."** — 강제. 데이터 손실. 첫 시도 `kill PID` (SIGTERM)이 정중.

**오해 5: "xargs는 어려워."** — pipe + xargs가 자경단 매일. 1주일 사용하면 손가락.

**오해 6: "30개 다 외우면 시니어."** — 매일 6개 + 주간 5개 + 월간 3개로 충분. 30개 다 외우면 시간 낭비.

**오해 7: "셸 명령어가 옛 시대."** — AI 시대일수록 더 중요. AI가 한 줄 추천 → 본인이 검증.

---

## 15. FAQ 7가지

**Q1. `rg` 알아도 `grep` 배워야 하나요?**
A. 네. 서버·CI 환경엔 grep만 있을 수도. 둘 다 알기 권장.

**Q2. `tail -f` vs `tail -F` 차이?**
A. `-f`은 단순 follow, `-F`은 파일 회전(rotate)도 follow. 로그 회전되는 환경엔 `-F`.

**Q3. `awk` vs `python script` 어느 쓸까?**
A. 한 줄이면 `awk`, 복잡하면 Python. 양쪽 알기.

**Q4. `htop`이 안 보이면?**
A. `brew install htop`. macOS 기본은 `top`만. htop은 추가 설치.

**Q5. SSH key 패스프레이즈 매번 입력 피하려면?**
A. `ssh-add --apple-use-keychain` (macOS) 또는 1Password SSH agent.

**Q6. `tar`의 옵션 외우기 어려워요.**
A. `czf` (생성) / `xzf` (해제) 둘만. **c**reate / e**x**tract.

**Q7. `xargs -I {}`의 placeholder 다른 것?**
A. `-I @`나 `-I X` 다 가능. {} 표준이지만 다른 글자도. 자경단은 {} 사용.

---

## 추신

30 명령어 중 매일 13개·주간 8개·월간 5개·응급 4개. 매일 13개를 1주일 안에 손가락. 빨강 5개 (`rm -rf`·`kill -9`·`> file` 덮어쓰기·`mv` 덮어쓰기·`tar` 덮어쓰기) 앞에 1초 호흡. 모던 5종 (`rg`·`fd`·`bat`·`exa`·`delta`) brew 한 번 설치. 매일 30% 빠름.

