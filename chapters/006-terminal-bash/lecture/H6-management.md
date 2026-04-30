# Ch006 · H6 — 자경단 매일 운영 5스크립트 — 본인의 첫 셸 스크립트가 GitHub에 올라가는 시간

> 고양이 자경단 · Ch 006 · 6교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 자경단 스크립트의 첫 두 줄 — 안전 옵션
3. function — 스크립트를 작은 조각으로
4. signal trap — 정리는 자동으로
5. getopts — 옵션 파싱의 표준
6. 컬러 로그 — 스크립트가 친절해지는 한 줄
7. shellcheck — 스크립트의 안전벨트
8. bats — 셸 스크립트도 테스트해요
9. 자경단의 매일 운영 5스크립트 그림
10. 본인의 첫 스크립트 — 50줄 deploy.sh
11. 자경단 스크립트 다섯 계명
12. 흔한 오해 다섯 가지
13. 자주 받는 질문 다섯 가지
14. 마무리 — 다음 H7에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 안전 옵션
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# function
deploy() { local env="$1"; echo "Deploying to $env"; }
deploy production

# trap
trap 'rm -rf "$TMPDIR"' EXIT

# getopts
while getopts ":e:vh" opt; do
  case $opt in
    e) ENV="$OPTARG" ;;
    v) VERBOSE=1 ;;
    h) usage; exit 0 ;;
  esac
done

# 컬러 로그
log_info() { echo -e "\033[36m[INFO]\033[0m $1"; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $1" >&2; }

# 도구 설치
brew install shellcheck bats-core
shellcheck deploy.sh
bats tests/
```

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 이제 여섯 번째 시간이에요. 본 챕터의 마지막 큰 시간이에요. 잘 따라오시고 계세요. 박수.

지난 H5를 한 줄로 회수할게요. 본인은 자경단 다섯 명의 30분 시뮬레이션을 옆에서 구경하셨어요. 본인 셋업, 까미 ERROR 진단, 노랭이 CSV, 깜장이 JSON, 미니 자동화, 본인 통합. 30분에 30개 명령어 중 20개가 사용됐어요. 그게 하루의 그림이었어요.

이번 H6는 그 30분이 1년 운영으로 진화하는 시간이에요. H5에서 미니가 짠 cleanup.sh 30줄 기억하시죠. 그게 본인의 첫 스크립트의 토대예요. 그 30줄을 100줄짜리 운영 스크립트로 진화시키는 그림이에요. function, trap, getopts, 컬러 로그, shellcheck, bats. 여섯 가지 무기가 30줄을 100줄로 키워 줘요.

오늘의 약속은 한 가지예요. **본인의 첫 셸 스크립트가 한 시간 끝에 GitHub에 올라갑니다**. 50줄짜리 deploy.sh. 본인이 자기 손으로 짜고, shellcheck로 검사하고, bats로 테스트하고, git push로 GitHub에 올라가요. 5년 후엔 본인이 100개 스크립트를 가진 사람이에요. 오늘 한 줄이 그 100개의 첫 줄이에요.

자, 가요. 첫 두 줄부터.

---

## 2. 자경단 스크립트의 첫 두 줄 — 안전 옵션

자경단의 모든 셸 스크립트가 같은 두 줄로 시작해요. 본인이 5년 동안 만들 100개 스크립트가 다 이 두 줄로 시작해요.

> ▶ **같이 쳐보기** — 자경단 스크립트 표준 첫 4줄
>
> ```bash
> #!/usr/bin/env bash
> set -euo pipefail
> IFS=$'\n\t'
> ```

한 줄씩 풀어 드릴게요.

첫 줄 `#!/usr/bin/env bash`. shebang이라고 불러요. 이 파일이 bash 스크립트라고 알려 주는 줄이에요. `/usr/bin/env bash`는 `/bin/bash`보다 이식성이 좋아요. macOS도, Linux도, Docker도 다 됩니다.

둘째 줄 `set -euo pipefail`. 안전 옵션 세 개. 이게 정말 중요해요. 한 글자씩 풀어 드릴게요.

`-e`는 errexit. 명령어 하나가 실패하면 즉시 스크립트 멈춤. 0 아닌 exit code 만나면 끝. `-e` 없으면 build 실패해도 deploy까지 진행돼요. 사고예요.

`-u`는 nounset. 정의 안 된 변수 사용하면 에러. `$undefined`로 빈 값 받아서 사고 나는 걸 막아요. 가장 무서운 사고가 `rm -rf $UNDEFINED/*`이 `rm -rf /*`로 풀리는 거예요. `-u`가 그걸 막아요.

`-o pipefail`은 pipe 안 어느 명령이든 실패하면 전체 실패. 기본은 마지막 명령의 exit code만 봐요. 그래서 `curl 실패 | jq`가 jq 성공으로 보여요. pipefail이 그걸 잡아 줘요.

세 글자가 5년 안전벨트예요. 본인이 5년 동안 이 세 글자를 안 박은 스크립트로 사고 한 번씩 만나요. 박으면 사고 안 나요.

셋째 줄 `IFS=$'\n\t'`. Internal Field Separator라는 셸 변수예요. 기본값이 공백·탭·줄바꿈이에요. 본인이 변수를 사용할 때 셸이 이 글자들로 단어를 분리해요. 공백 포함 파일명에서 사고가 나요. `IFS=$'\n\t'`로 줄바꿈·탭만 분리자로 만들면 공백 사고 면역.

세 줄이 자경단의 안전벨트 한 세트예요. 본인 스크립트의 첫 세 줄에 박으세요. 평생.

---

## 3. function — 스크립트를 작은 조각으로

스크립트가 길어지면 function으로 잘라요. 한 일을 한 function에. 100줄짜리 스크립트가 10개 function으로 나뉘어요.

문법은 단순해요.

```bash
deploy() {
  local env="$1"
  echo "Deploying to $env"
}

# 호출
deploy production
```

`함수이름() { ... }` 한 묶음. 함수 안에 코드. 호출할 땐 함수 이름 + 인자.

여기서 짚고 갈 한 가지. **`local` 키워드**. function 안에서 변수 선언할 때 항상 `local`을 붙이세요. 안 붙이면 그 변수가 글로벌이 되어서 다른 function에 누수돼요.

자경단의 매일 쓰는 function 다섯 종류를 보여드릴게요.

**1. 검증 function**

```bash
require_var() {
  local var_name="$1"
  if [[ -z "${!var_name:-}" ]]; then
    echo "ERROR: $var_name is required" >&2
    exit 1
  fi
}

require_var "ENV"
require_var "DEPLOY_KEY"
```

환경변수가 비어 있으면 에러로 멈추기. 자경단 스크립트의 첫 검증 단계.

**2. 로그 function**

```bash
log() {
  local level="$1"; shift
  local msg="$*"
  local ts="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$ts] [$level] $msg"
}

log INFO "deployment started"
log ERROR "build failed"
```

타임스탬프 + 레벨 + 메시지. 모든 자경단 스크립트가 이 한 함수를 가져요.

**3. 종료 function**

```bash
die() {
  log ERROR "$@"
  exit 1
}

[[ -f config.yml ]] || die "config.yml not found"
```

에러 로그 + exit. 한 줄로 끝.

**4. 명령 실행 function**

```bash
run() {
  log INFO "Running: $*"
  "$@"
}

run npm install
run npm test
```

명령 실행 전에 로그를 남기는 wrapper. 디버깅이 쉬워져요.

**5. 진행률 function**

```bash
step() {
  local n="$1"; shift
  echo ""
  echo "===== Step $n: $* ====="
}

step 1 "Install dependencies"
step 2 "Run tests"
step 3 "Build"
```

스크립트 실행 중 단계를 시각적으로 표시.

다섯 function이 자경단의 매일 운영 스크립트의 토대예요. 본인이 dotfile 비슷하게 lib.sh 같은 공유 파일에 박아 두고, 모든 스크립트가 source로 읽어 쓰는 게 자경단 표준이에요.

---

## 4. signal trap — 정리는 자동으로

본인이 스크립트 중간에 임시 파일을 만들었는데 스크립트가 도중에 죽으면 그 임시 파일이 남아요. 그게 쌓이면 디스크가 가득 차요. trap이 그걸 자동으로 정리해 줘요.

```bash
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "데이터" > "$TMPDIR/data.txt"
process "$TMPDIR/data.txt"
# 스크립트 끝나면 trap이 자동으로 TMPDIR 삭제
```

`trap '명령' EXIT`이 스크립트가 끝날 때 (정상이든 에러든 Ctrl+C든) 그 명령을 실행해요. 정리는 무조건 일어나요.

자경단 표준 trap 패턴이에요.

```bash
cleanup() {
  local exit_code=$?
  rm -rf "$TMPDIR"
  if [[ $exit_code -ne 0 ]]; then
    log ERROR "Script failed with exit code $exit_code"
  fi
  exit $exit_code
}
trap cleanup EXIT
```

cleanup function을 만들고 trap에 등록. 정리 + 에러 알림 + 정확한 exit code 보존. 한 묶음으로 자경단 스크립트의 표준이에요.

trap의 다른 신호도 짚고 갈게요. `EXIT` 외에 `INT` (Ctrl+C), `TERM` (kill), `HUP` (셸 종료)에도 trap을 걸 수 있어요. 보통은 EXIT 한 개로 충분.

---

## 5. getopts — 옵션 파싱의 표준

스크립트가 옵션을 받기 시작하면 getopts를 써요. `--help`, `-v`, `--env production` 같은 옵션을 파싱하는 표준 도구.

```bash
usage() {
  cat <<EOF
Usage: deploy.sh [-e env] [-v] [-h]
  -e env    Target environment (default: dev)
  -v        Verbose output
  -h        Show help
EOF
}

ENV="dev"
VERBOSE=0

while getopts ":e:vh" opt; do
  case $opt in
    e) ENV="$OPTARG" ;;
    v) VERBOSE=1 ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

echo "ENV=$ENV VERBOSE=$VERBOSE"
```

`getopts ":e:vh"`의 문법을 풀어 드릴게요. 첫 글자 `:`은 에러 메시지 직접 처리. 그 다음 `e:`은 -e 옵션이 인자를 받는다는 뜻. `v`는 인자 없는 플래그. `h`도 인자 없는 플래그. 이 한 줄이 옵션 종류와 인자 유무를 다 정의해요.

자경단의 deploy.sh 호출 예시.

```bash
./deploy.sh -e production -v   # production 환경에 verbose
./deploy.sh -h                 # 도움말
./deploy.sh                    # default (dev)
```

getopts의 한계 한 가지. 긴 옵션 (`--env`, `--verbose`)은 지원 안 해요. 긴 옵션 필요하면 GNU `getopt` (단수)를 쓰거나 직접 파싱. 자경단은 단순함 위해 getopts 짧은 옵션만.

---

## 6. 컬러 로그 — 스크립트가 친절해지는 한 줄

스크립트 출력에 색깔을 넣으면 사용자가 한눈에 INFO/WARN/ERROR를 구분해요. 한 줄짜리 함수예요.

```bash
log_info()  { echo -e "\033[36m[INFO]\033[0m  $1"; }
log_warn()  { echo -e "\033[33m[WARN]\033[0m  $1" >&2; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $1" >&2; }
log_ok()    { echo -e "\033[32m[ OK ]\033[0m  $1"; }
```

`\033[`로 시작하는 게 ANSI 이스케이프 시퀀스. 31=빨강, 32=초록, 33=노랑, 36=청록. `\033[0m`이 색깔 reset. 외우려 마세요. dotfile이나 lib.sh에 박아 두고 평생 쓰세요.

ERROR와 WARN은 `>&2`로 stderr에 보내요. 스크립트의 정상 출력과 분리하기 위해서. 그래야 `./deploy.sh 2>errors.log`로 에러만 따로 캡처할 수 있어요.

자경단의 진행률 표시 한 줄도 보여드릴게요.

```bash
log_step() {
  local n="$1"; shift
  echo ""
  echo -e "\033[1;34m===== Step $n: $* =====\033[0m"
}

log_step 1 "Install"
log_step 2 "Test"
log_step 3 "Deploy"
```

\033[1;34m이 굵은 파랑. 단계가 시각적으로 도드라져요. 사용자가 어디까지 갔는지 한눈에 봐요.

---

## 7. shellcheck — 스크립트의 안전벨트

shellcheck는 셸 스크립트 전용 linter예요. 본인이 스크립트를 짜고 `shellcheck deploy.sh`라고 한 줄 치면 잠재 버그를 다 찾아 줘요. brew로 깔아요.

```bash
brew install shellcheck
```

자경단의 모든 스크립트가 shellcheck를 통과해야 해요. CI에 박아 두고 PR마다 자동 검사. 다섯 명이 사고 안 치는 비결이에요.

shellcheck가 잡는 흔한 버그 다섯 가지 보여드릴게요.

**버그 1: 따옴표 빠진 변수**
```bash
rm $file        # SC2086: 따옴표 누락
# 수정
rm "$file"
```

**버그 2: backtick 사용**
```bash
result=`date`   # SC2006: backtick 권장 안 함
# 수정
result=$(date)
```

**버그 3: 잘못된 정수 비교**
```bash
[ $a == $b ]    # SC2086: 따옴표 + SC2046: == bash만
# 수정
[[ "$a" -eq "$b" ]]
```

**버그 4: 쓰지 않는 변수**
```bash
unused="value"  # SC2034: unused variable
```

**버그 5: 셸 명령 비효율**
```bash
cat file | grep pattern   # SC2002: 불필요한 cat
# 수정
grep pattern file
```

shellcheck는 이런 걸 다 잡아 줘요. 본인이 짠 스크립트에 한 번씩 돌려 보세요. 첫 스크립트는 보통 5~10개 경고가 떠요. 다 고치면서 본인이 셸 표준을 배워요. 학습 도구이기도 해요.

---

## 8. bats — 셸 스크립트도 테스트해요

bats는 셸 스크립트 테스트 framework예요. Python의 pytest, JS의 jest 같은 도구. 셸 스크립트도 테스트할 수 있어요.

```bash
brew install bats-core
```

기본 사용법. tests/deploy.bats 파일에 테스트 케이스 작성.

```bash
#!/usr/bin/env bats

@test "deploy.sh -h shows usage" {
  run ./deploy.sh -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "deploy.sh requires -e" {
  run ./deploy.sh
  [ "$status" -eq 1 ]
}

@test "deploy.sh -e production succeeds" {
  run ./deploy.sh -e production
  [ "$status" -eq 0 ]
  [[ "$output" =~ "production" ]]
}
```

`@test "이름"` 안에 테스트 케이스. `run` 명령으로 스크립트 실행. `$status`는 exit code, `$output`은 stdout. 검증은 `[ ... ]`이나 `[[ ... ]]`로.

실행은 한 줄.

```bash
$ bats tests/deploy.bats
✓ deploy.sh -h shows usage
✓ deploy.sh requires -e
✓ deploy.sh -e production succeeds

3 tests, 0 failures
```

자경단의 표준은 모든 운영 스크립트에 bats 테스트 5개 이상. CI에서 자동 실행. 사고 방지의 마지막 안전벨트.

---

## 9. 자경단의 매일 운영 5스크립트 그림

자경단 다섯 명이 매일 사용하는 운영 스크립트 다섯 개를 알려드릴게요.

**1. deploy.sh — 배포**

```bash
./deploy.sh -e production
```

prod 환경에 코드 배포. 빌드 → 테스트 → 업로드 → health check.

**2. rollback.sh — 롤백**

```bash
./rollback.sh -e production -v v1.2.3
```

prod에서 사고 나면 직전 버전으로 롤백. 5분 안에.

**3. monitor.sh — 모니터링**

```bash
./monitor.sh
```

자경단 사이트의 health, ERROR 로그, 응답 시간을 매일 한 번 체크.

**4. migrate.sh — DB 마이그레이션**

```bash
./migrate.sh up
```

DB 스키마 변경. up은 적용, down은 롤백.

**5. backup.sh — 백업**

```bash
./backup.sh
```

DB와 파일 시스템을 매일 한 번 S3에 백업.

다섯 스크립트가 자경단 사이트의 1년 운영을 사 줘요. 다섯 개를 합치면 약 500줄. 본인이 이 다섯 개를 5년에 걸쳐 키우게 돼요. 첫 50줄 deploy.sh가 시작이에요.

---

## 10. 본인의 첫 스크립트 — 50줄 deploy.sh

자, 이제 본인의 첫 스크립트를 같이 짜요. 50줄짜리 deploy.sh. 위에서 배운 모든 무기가 다 들어가요.

> ▶ **같이 쳐보기** — 본인의 첫 deploy.sh
>
> ```bash
> #!/usr/bin/env bash
> #
> # deploy.sh — 자경단 사이트 배포 스크립트
> # Usage: ./deploy.sh -e <env> [-v]
> #
> set -euo pipefail
> IFS=$'\n\t'
> 
> # ===== 컬러 로그 =====
> log_info()  { echo -e "\033[36m[INFO]\033[0m  $1"; }
> log_error() { echo -e "\033[31m[ERROR]\033[0m $1" >&2; }
> log_ok()    { echo -e "\033[32m[ OK ]\033[0m  $1"; }
> die()       { log_error "$1"; exit 1; }
> 
> # ===== 글로벌 =====
> readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
> ENV=""
> VERBOSE=0
> 
> # ===== usage =====
> usage() {
>   cat <<EOF
> Usage: $0 -e <env> [-v]
>   -e env    Target (dev|staging|production)
>   -v        Verbose
>   -h        Help
> EOF
> }
> 
> # ===== 옵션 파싱 =====
> while getopts ":e:vh" opt; do
>   case $opt in
>     e) ENV="$OPTARG" ;;
>     v) VERBOSE=1 ;;
>     h) usage; exit 0 ;;
>     *) usage; exit 1 ;;
>   esac
> done
> 
> # ===== 검증 =====
> [[ -z "$ENV" ]] && die "환경(-e)이 필요해요"
> [[ "$ENV" =~ ^(dev|staging|production)$ ]] || die "잘못된 환경: $ENV"
> 
> # ===== trap =====
> TMPDIR=$(mktemp -d)
> trap 'rm -rf "$TMPDIR"' EXIT
> 
> # ===== 배포 =====
> log_info "환경: $ENV"
> log_info "빌드 시작..."
> npm install --silent
> npm run build
> log_ok "빌드 완료"
> 
> log_info "배포 중..."
> # rsync, scp, kubectl 같은 실제 배포 명령
> sleep 1   # 시연용
> log_ok "배포 완료: $ENV"
> ```

50줄. 위에서 배운 모든 무기가 다 들어 있어요. shebang, set -euo pipefail, IFS, 컬러 로그 함수, die 함수, getopts, 검증, trap, 단계별 로그, exit code. 본인의 첫 스크립트가 자경단 표준이에요.

이제 검사 + 테스트 + GitHub.

```bash
# 검사
shellcheck deploy.sh

# 권한
chmod +x deploy.sh

# 테스트
./deploy.sh -e production

# bats 테스트 (선택)
bats tests/deploy.bats

# GitHub
git add deploy.sh
git commit -m "feat: 자경단 첫 deploy.sh"
git push
```

git push 끝나면 본인의 첫 스크립트가 GitHub에 올라가요. 약속 지켰어요. 박수.

---

## 11. 자경단 스크립트 다섯 계명

마지막으로 자경단이 5년 동안 깎아 만든 스크립트 다섯 계명을 알려드릴게요.

**1. set -euo pipefail은 첫 줄.**

안전벨트 없이 운전하지 마세요.

**2. 변수는 항상 따옴표 안에.**

`"$var"`. 공백 사고 면역.

**3. function 한 일에 한 function.**

50줄 넘으면 잘라요. 한 function이 20줄 넘으면 또 잘라요.

**4. shellcheck 통과 못 하면 commit 안 함.**

CI에 박아 두세요. 다섯 명 다 통과한 코드만 main 진입.

**5. 위험한 명령 (rm, kill, dd) 앞엔 1초 호흡.**

스크립트 안에서도 마찬가지예요. `rm -rf "$DIR"`에 빈 변수 사고 방지를 위해 `${DIR:?}`로 검증.

다섯 계명을 .zshrc 옆에 박아 두면 5년 면역이에요.

---

## 12. 흔한 오해 다섯 가지

**오해 1: 셸 스크립트는 짧은 게 답이다.**

짧으면서 안전한 게 답이에요. 안전 옵션이 빠진 짧은 스크립트는 사고의 토대.

**오해 2: function은 너무 무거운 도구다.**

20줄 넘는 스크립트면 function 쪼개세요. 가독성과 재사용이 곱셈으로 좋아져요.

**오해 3: shellcheck 경고는 무시해도 된다.**

50%만 무시 가능, 50%는 진짜 버그. 모르면 다 고치는 게 안전해요.

**오해 4: bats 테스트는 셸 스크립트엔 과하다.**

운영 스크립트는 사고 한 번이 1만 명에게 영향. 테스트가 사고를 막아요. 5분 투자가 5시간 야근을 살려요.

**오해 5: 셸 스크립트는 Python으로 다 바꿀 수 있다.**

90%는 가능. 그러나 Python보다 셸이 짧고 빠른 경우가 많아요. 50줄 미만은 셸, 그 이상은 Python이 자경단 표준.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. zsh로 짠 스크립트도 .sh 확장자?**

확장자는 자유지만 자경단 표준은 .sh. shebang으로 셸 종류를 정확히 명시하세요. `#!/usr/bin/env bash` 또는 `#!/usr/bin/env zsh`.

**Q2. 스크립트 실행 권한이 안 떠요.**

`chmod +x deploy.sh` 한 번 치세요. 한 번이면 평생.

**Q3. shellcheck 경고가 너무 많이 떠요.**

첫 스크립트는 5~10개 정상. 한 개씩 검색해서 고치면서 셸 표준을 배워요. shellcheck.net에서 코드 붙여 넣으면 웹에서 검사 가능.

**Q4. function의 인자 개수 제한 있나요?**

없어요. `$1, $2, ...` 이런 식이고 `$#`이 인자 개수, `$*`가 모든 인자, `$@`가 인자 배열. 9개 넘으면 `${10}` 처럼 중괄호.

**Q5. 스크립트를 cron으로 돌리려면?**

`crontab -e`로 편집기 열고 한 줄.
```
0 9 * * * /path/to/deploy.sh -e production
```
매일 오전 9시 실행. 자경단의 매일 운영 표준.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — Bash 운영 학습 편

Bash 스크립트 운영하며 자주 빠지는 함정 다섯.

첫 번째 함정, cron job에 stdout/stderr 안 넘김. 본인이 cron 실패 알 수 없음. 안심하세요. **`>> /var/log/cron-app.log 2>&1` 항상.** 5초 더 적어 5시간 디버깅 막음.

두 번째 함정, 임시 파일 정리 안 함. 안심하세요. **trap 'cleanup' EXIT INT TERM.** 모든 진지한 .sh 첫 5줄.

세 번째 함정, 동시 실행 lock 안 검. 본인 cron이 두 번 동시 실행. 안심하세요. **flock 또는 lockfile.** 한 번에 하나만.

네 번째 함정, 종료 코드 안 검사. 안심하세요. **`if ! cmd; then` 또는 `cmd || die`.** 실패는 명시적 처리.

다섯 번째 함정, 가장 큰 함정. **숨김 비밀번호를 .sh에 직접.** 본인이 API key 코드에. 안심하세요. **환경 변수 또는 secret manager.** 코드에 비밀 절대 금지.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H7에서 만나요

자, 여섯 번째 시간이 끝났어요. 60분 동안 본인은 셸 스크립트의 모든 무기를 만나셨어요. 정리하면 이래요.

자경단 스크립트의 첫 두 줄은 안전 옵션. set -euo pipefail + IFS=$'\n\t'. 그 위에 function으로 작은 조각, trap으로 자동 정리, getopts로 옵션 파싱, 컬러 로그로 친절함. 그리고 shellcheck로 검사, bats로 테스트. 자경단의 매일 운영 5스크립트 — deploy·rollback·monitor·migrate·backup이 1년 운영을 사 줘요. 본인의 첫 50줄 deploy.sh가 GitHub에 올라갔어요.

박수 한 번 칠게요. 정말 큰 박수예요. 본인이 자기 손으로 첫 스크립트를 짠 거예요. 5년 후엔 100개 스크립트를 가진 사람이에요. 첫 줄이 가장 어려워요. 그 첫 줄을 오늘 끝냈어요.

다음 H7은 깊이의 시간이에요. fork와 exec의 진짜 메커니즘, 프로세스 그룹, 세션, signal, 리다이렉션의 내부, 환경변수 상속. 한 명령어 0.3초 7단계가 0.001초 단위로 풀려요. 한 시간 후 만나요.

그 전에 한 가지 부탁. 지금 잠깐 멈추시고 본인 노트북에서 hello.sh 한 장을 만들어 보세요.

```bash
cat > hello.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log() { echo "[$(date +%H:%M)] $1"; }

log "Hello, 자경단!"
log "Today is $(date +%A)"
log "Done."
EOF

chmod +x hello.sh
./hello.sh
```

10초예요. 이 한 장이 본인의 H6 졸업장이에요. 본인이 자기 손으로 스크립트 한 장을 만들어서 실행한 그림이에요. 잘 따라오셨어요. 진짜로요. 한 시간 후 H7에서 만나요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - shebang `#!/usr/bin/env bash` vs `#!/bin/bash`: env 버전은 PATH에서 bash 검색 (이식성), 직접 경로는 정확하지만 macOS 기본 bash 3.2로 묶임. 자경단은 env 우선.
> - set -e의 함정: pipe 안의 명령은 -e가 안 잡음 → -o pipefail 필요. function 안의 -e도 다른 셸과 동작 차이. bash 4.4+ 권장.
> - IFS의 깊이: 기본값은 공백·탭·줄바꿈. `IFS=$'\n\t'`는 공백 분리 끄기. for 루프 변수 분리 동작 변경.
> - local vs declare vs typeset: function 안 변수는 local 권장. declare/typeset은 글로벌. local로 누수 방지.
> - trap 신호 정리: EXIT (스크립트 종료), ERR (-e와 같이 에러 시), DEBUG (각 명령 전), RETURN (function 종료), SIGINT/SIGTERM/SIGHUP. 보통 EXIT 한 개.
> - getopts vs getopt: getopts는 셸 builtin, 짧은 옵션만. getopt는 외부 명령, 긴 옵션 지원. GNU getopt vs BSD getopt 호환 차이 주의.
> - ANSI 컬러 코드: 30-37 (전경), 40-47 (배경), 1=굵게, 4=밑줄. 256색은 `\033[38;5;Nm` (N=0-255). truecolor는 `\033[38;2;R;G;Bm`.
> - shellcheck 무시: `# shellcheck disable=SC2086` (한 줄), `# shellcheck disable=SC2086,SC2034` (여러). 무시는 진짜 false positive에만.
> - bats 외 셸 테스트: shunit2, bash_unit, bashunit. bats가 가장 활성. CI에서 docker로 격리 실행.
> - 스크립트 디버깅: `bash -x script.sh` (모든 명령 출력), `set -x` 줄 안에서 켜기. PS4 변수로 디버그 prefix 변경 (`PS4='+ $LINENO: '`).
> - 다음 H7 키워드: fork() · exec() · waitpid() · 프로세스 그룹 · 세션 · signal · 환경변수 상속 · 리다이렉션 내부.
