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

`set -e` 없는 스크립트가 얼마나 위험한지 진짜 사고로 보여드릴게요. 어떤 회사의 배포 스크립트가 이렇게 생겼어요. 첫째 줄 빌드, 둘째 줄 테스트, 셋째 줄 prod 서버에 업로드. set -e가 없었어요. 어느 날 둘째 줄의 테스트가 실패했어요. 코드에 버그가 있었던 거예요. 정상이라면 거기서 멈춰야 해요. 그런데 set -e가 없으니까 스크립트가 멈추지 않고 셋째 줄로 넘어갔어요. 테스트가 실패한 그 깨진 코드를 prod 서버에 그대로 올린 거예요. 사용자 만 명이 깨진 사이트를 봤어요. 원인을 추적해 보니 set -e 한 줄이 없었던 거예요. 두 글자가 빠져서 만 명이 영향받은 거예요. 이게 set -e가 왜 첫 줄이어야 하는지의 이유예요. set -e는 "어느 한 단계라도 실패하면 즉시 멈춰라"는 명령이에요. 빌드가 실패하면 테스트로 안 넘어가고, 테스트가 실패하면 배포로 안 넘어가요. 실패가 다음 단계를 오염시키지 못하게 막는 둑이에요. 본인이 5년 동안 짤 모든 스크립트에 이 둑을 쌓으세요. 두 글자가 본인의 회사를 지켜요. 그리고 이건 그냥 "좋은 습관" 수준이 아니에요. set -euo pipefail 없는 운영 스크립트는 자경단에서는 리뷰를 통과 못 해요. 안전벨트 없는 차는 출고 금지인 것처럼.

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

이 lib.sh 공유가 왜 강력한지 한 장면으로 보여드릴게요. 자경단 다섯 명이 각자 스크립트를 짜잖아요. 까미도 deploy 짜고, 미니도 backup 짜고, 노랭이도 build 짜요. 만약 다섯 명이 각자 로그 함수를 따로 만들면, 다섯 가지 다른 로그 모양이 생겨요. 까미 스크립트는 `[INFO]`, 미니 스크립트는 `>> INFO:`, 노랭이 스크립트는 `### info ###`. 로그 모양이 제각각이면 나중에 다섯 스크립트의 로그를 한자리에 모아서 볼 때 엉망이 돼요. 그런데 자경단은 lib.sh 한 파일에 log·die·run·step 다섯 함수를 박아 두고, 다섯 명이 다 그걸 source로 가져다 써요. 그러면 다섯 명의 스크립트가 다 똑같은 로그 모양을 가져요. 한 사람이 lib.sh의 로그 함수를 개선하면, 다섯 명의 스크립트가 동시에 좋아져요. 이게 H3에서 본 dotfile 공유와 똑같은 원리예요. 손가락을 공유하듯 함수를 공유하는 거죠. 그리고 이 lib.sh도 GitHub에 있어요. 새 멤버가 들어오면 lib.sh를 source 한 줄로 가져가서, 첫날부터 자경단 표준 함수 다섯 개를 써요. 5년치 운영 노하우가 lib.sh 한 파일에 응축돼 있어요. 책 한 권보다 자경단 lib.sh 한 번 읽는 게 더 깊은 학습이에요.

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

trap이 없으면 어떤 일이 벌어지는지 미니의 실제 사고로 보여드릴게요. 미니가 백업 스크립트를 짰어요. 그 스크립트는 백업할 때 임시 폴더를 만들어서 거기에 데이터베이스를 통째로 덤프해요. 데이터베이스가 50GB였어요. 그래서 임시 폴더도 50GB가 됐어요. 정상이라면 백업이 끝나고 그 임시 폴더를 지워요. 그런데 trap이 없었어요. 어느 날 백업 도중에 스크립트가 에러로 죽었어요. 죽으면서 50GB 임시 폴더를 못 지우고 갔어요. 다음 날 또 백업이 돌고 또 죽고 또 50GB가 남고. 일주일 후 서버 디스크가 가득 찼어요. 350GB의 임시 폴더가 쌓인 거예요. 디스크가 가득 차니까 자경단 사이트 전체가 멈췄어요. 임시 폴더 하나 안 지운 게 사이트를 멈춘 거예요. 미니가 원인을 찾고 trap 한 줄을 추가했어요. `trap 'rm -rf "$TMPDIR"' EXIT`. 이 한 줄이 있으면 스크립트가 어떻게 죽든, 정상이든 에러든 Ctrl+C든, 죽기 직전에 무조건 임시 폴더를 지워요. trap은 "내가 어떻게 죽든 이것만은 꼭 하고 죽어라"는 유언 같은 거예요. 청소는 무조건 일어나야 해요. 그래서 자경단은 임시 파일을 만드는 모든 스크립트에 trap을 의무로 박아요. 한 줄의 유언이 350GB 사고를 막아요.

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

getopts의 한계 한 가지. 긴 옵션 (`--env`, `--verbose`)은 지원 안 해요. 긴 옵션 필요하면 GNU `getopt` (단수)를 쓰거나 직접 파싱. 자경단은 단순함 위해 getopts 짧은 옵션만. 옵션을 받기 시작하면 본인 스크립트는 도구가 돼요. 본인뿐 아니라 동료도 `-h`로 사용법을 보고 쓸 수 있는 진짜 도구.

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

컬러 로그가 사소해 보이지만 실전에서 진짜 중요해요. 본인이 deploy.sh를 돌렸는데 화면에 글자가 50줄 쭉 흘러내려요. 다 흰색이면 어디서 문제가 났는지 눈으로 찾기 어려워요. 그런데 INFO는 청록, OK는 초록, ERROR는 빨강으로 색이 다르면, 빨간 줄 하나가 50줄 속에서 눈에 확 띄어요. 본인이 새벽에 졸린 눈으로 배포 로그를 볼 때, 빨간 줄 하나가 본인을 깨워요. 색깔이 본인의 주의를 정확히 문제가 난 곳으로 끌고 가요. 그리고 한 가지 실전 팁. 색깔은 사람이 볼 때만 켜야 해요. 로그를 파일로 저장하거나 다른 프로그램에 넘길 때는 `\033[` 같은 색깔 코드가 글자 쓰레기로 끼어들어요. 그래서 잘 만든 스크립트는 출력이 터미널인지 파일인지 확인해서, 터미널일 때만 색을 켜요. `[[ -t 1 ]]`라는 검사가 "출력 1번이 터미널이냐"를 물어봐요. 이런 작은 배려가 5년 차의 스크립트를 1년 차와 구별해요. 오늘은 색을 켜는 법만, 끄는 배려는 H7 이후에 자연스럽게 익혀요.

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

shellcheck를 본인이 꼭 써야 하는 진짜 이유를 짚을게요. 셸은 함정이 유난히 많은 언어예요. 다른 언어는 문법이 틀리면 실행 자체가 안 돼서 바로 알아요. 그런데 셸은 문법이 "틀린 듯 맞은 듯"한 코드가 그냥 돌아가 버려요. 그러다가 특정 조건에서만 사고가 나요. 예를 들어 `rm $file`은 평소엔 잘 돌아가요. 그런데 $file에 공백이 든 날 갑자기 엉뚱한 걸 지워요. 본인은 그 코드를 백 번 잘 쓰다가 백한 번째에 당해요. 사람의 눈으로는 이걸 미리 못 봐요. 너무 미묘하거든요. shellcheck는 이 미묘한 함정을 기계의 눈으로 다 잡아 줘요. 사람이 놓치는 걸 기계가 잡는 거예요. 그래서 자경단은 shellcheck를 사람의 리뷰보다 먼저 돌려요. 사람은 로직을 보고, 기계는 함정을 봐요. 둘이 역할이 달라요. 그리고 shellcheck는 본인에게 그냥 "틀렸다"가 아니라 "왜 틀렸고 어떻게 고치는지"를 SC 번호와 함께 알려줘요. 본인이 그 SC 번호를 검색하면 자세한 설명이 나와요. 그러니까 shellcheck는 잔소리하는 도구가 아니라, 옆에서 셸을 가르쳐 주는 무료 선생님이에요. 본인이 첫 1년 동안 shellcheck의 경고를 하나씩 고치면서 배우면, 5년 차의 셸 감각이 1년에 압축돼요. 경고를 귀찮아하지 말고 선생님으로 대하세요.

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

"셸 스크립트에 테스트까지 필요해?"라고 생각하실 수 있어요. 평범한 스크립트라면 과해요. 그런데 운영 스크립트는 달라요. deploy.sh가 잘못 동작하면 만 명이 영향받아요. 그렇게 영향이 큰 코드는 사람이 매번 손으로 확인할 수 없어요. 본인이 deploy.sh를 한 줄 고칠 때마다, 그 수정이 다른 걸 안 깨뜨렸는지 어떻게 확인해요. 손으로 production 배포를 해 볼 수는 없잖아요. bats 테스트가 그걸 해 줘요. 본인이 deploy.sh를 고치고 `bats tests/`를 한 줄 치면, "도움말이 잘 뜨나", "환경 없이 부르면 에러 나나", "잘못된 환경을 거부하나" 같은 걸 5초에 다 확인해 줘요. 본인이 안심하고 코드를 고칠 수 있게 만드는 안전망이에요. 테스트가 없으면 본인은 운영 스크립트를 고칠 때마다 떨어요. "이거 고쳤다가 배포가 깨지면 어쩌지." 테스트가 있으면 고치고 `bats` 한 번 돌려서 초록불 보고 안심해요. 테스트는 본인을 겁쟁이에서 용감한 사람으로 만들어요. 5분 들여 테스트를 짜 두면, 그 스크립트를 5년 동안 두려움 없이 고칠 수 있어요. 그게 bats 5개의 가치예요.

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

이 다섯 스크립트 중에서 본인이 가장 과소평가하기 쉬운 게 rollback.sh예요. 한 장면으로 그 가치를 보여드릴게요. 어느 날 본인이 deploy.sh로 새 버전을 prod에 올렸어요. 그런데 5분 후에 사이트가 이상해요. 새 버전에 버그가 있었던 거예요. 사용자들이 에러를 보고 있어요. 이 순간 본인의 머릿속은 하얘져요. 식은땀이 나요. rollback.sh가 없는 사람은 이 순간에 당황해서 새벽에 손으로 옛날 코드를 찾아서 다시 배포하려고 해요. 손이 떨려서 또 실수해요. 사고가 사고를 불러요. rollback.sh가 있는 사람은 다르게 움직여요. `./rollback.sh -e production -v v1.2.3` 한 줄. 5분 전 버전으로 즉시 복귀. 사이트가 다시 정상. 그러고 나서 차분히 버그를 고쳐요. rollback.sh의 진짜 가치는 "되돌릴 수 있다는 안도감"이에요. 되돌릴 수 있다는 걸 알면, 본인은 배포를 두려워하지 않게 돼요. 두려움 없이 자주 배포하는 팀이 빠르게 성장해요. 되돌릴 수 없는 팀은 배포를 무서워해서 한 달에 한 번 떨면서 배포해요. rollback.sh 한 장이 팀의 속도를 결정해요. 그래서 자경단은 deploy.sh를 짜는 날 rollback.sh를 같이 짜요. 앞으로 가는 길과 돌아오는 길을 항상 같이 만들어요. 본인도 두 해 코스에서 deploy를 배울 때 rollback을 같이 기억하세요.

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

이 50줄을 짠 본인에게 한 가지를 꼭 말하고 싶어요. 본인은 방금 단순한 스크립트 한 장을 짠 게 아니에요. 본인은 "컴퓨터에게 절차를 가르치는 일"을 처음 한 거예요. 이 deploy.sh는 본인이 머릿속으로 알고 있던 "배포하는 법"을 컴퓨터가 읽을 수 있는 글로 적은 거예요. 그러니까 이제 본인이 없어도 이 절차가 실행돼요. 본인이 휴가를 가도, 본인이 회사를 옮겨도, 이 스크립트는 남아서 같은 절차를 정확히 반복해요. 이게 코드의 본질이에요. 코드는 본인의 지식을 본인 밖으로 꺼내서 영원히 살게 만드는 일이에요. 본인이 5년 차에 짠 스크립트를, 10년 차 후배가 읽고 배워요. 본인의 손가락이 글이 되어 남는 거예요. 그리고 한 가지 더. 첫 스크립트는 누구나 떨려요. 5년 차도 새 종류의 스크립트를 짤 때는 떨어요. 그 떨림은 본인이 모자라서가 아니라, 새로운 걸 만들고 있다는 증거예요. 본인이 오늘 50줄을 짜면서 "이게 맞나" 하고 떨렸다면, 그건 본인이 제대로 가고 있다는 신호예요. 떨림 없이 짠 코드는 보통 생각 없이 짠 코드거든요. 오늘의 떨림을 기억하세요. 5년 후 본인이 100개 스크립트를 짤 때, 첫 한 장을 떨면서 짠 오늘이 그 모든 것의 출발점이었어요.

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

박수 한 번 칠게요. 정말 큰 박수예요. 본인이 자기 손으로 첫 스크립트를 짠 거예요. 5년 후엔 100개 스크립트를 가진 사람이에요. 첫 줄이 가장 어려워요. 그 첫 줄을 오늘 끝냈어요. 이제부터 본인은 명령어를 치는 사람을 넘어, 명령어를 엮어 절차를 만드는 사람이에요. 그게 진짜 개발자의 손가락이에요.

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

---

## 추신

1. 본인의 첫 셸 스크립트가 오늘 GitHub에 올라갔어요. 100개의 첫 줄.
2. 자경단 스크립트 첫 세 줄 — shebang·set -euo pipefail·IFS.
3. shebang `#!/usr/bin/env bash`가 `/bin/bash`보다 이식성 좋아요.
4. `-e`=에러 시 멈춤, `-u`=빈 변수 금지, pipefail=pipe 실패 잡기.
5. 세 글자가 5년 안전벨트. 안 박으면 5년에 사고 한 번씩.
6. `IFS=$'\n\t'`=공백 분리 끄기. 공백 든 파일명 사고 면역.
7. function 한 일에 한 function. 20줄 넘으면 잘라요.
8. function 변수는 항상 `local`. 안 붙이면 글로벌 누수.
9. 매일 function 5 — require_var·log·die·run·step.
10. lib.sh에 공통 function 모아 두고 source로 공유. 자경단 표준.
11. trap EXIT=정상이든 에러든 Ctrl+C든 무조건 정리 실행.
12. `TMPDIR=$(mktemp -d); trap 'rm -rf "$TMPDIR"' EXIT` 표준 패턴.
13. getopts `:e:vh` — `:`에러직접·`e:`인자받음·`v`/`h`플래그.
14. getopts는 짧은 옵션만. 긴 옵션은 getopt 또는 직접 파싱.
15. 컬러 로그 — `\033[`+31빨강·32초록·33노랑·36청록+`\033[0m`reset.
16. ERROR·WARN은 `>&2`로 stderr. 정상 출력과 분리.
17. shellcheck=셸 전용 linter. `shellcheck deploy.sh` 한 줄.
18. shellcheck 첫 스크립트 5~10 경고 정상. 고치며 표준 배움.
19. SC2086(따옴표)·SC2006(backtick)·SC2002(불필요 cat) 단골.
20. bats=셸 테스트. `@test`·`run`·`$status`·`$output`.
21. 운영 스크립트는 bats 5개 이상. CI 자동 실행.
22. 매일 운영 5 — deploy·rollback·monitor·migrate·backup ≈ 500줄.
23. 다섯 계명 — set 첫줄·변수 따옴표·function 분할·shellcheck 통과·위험명령 1초.
24. `rm -rf "$DIR"`엔 `${DIR:?}`로 빈 변수 검증.
25. `bash -x script.sh`=모든 명령 출력 디버깅. set -x로 부분.
26. 비밀번호·토큰 절대 .sh에 직접 금지. env 또는 secret manager.
27. cron엔 `>> log 2>&1` 항상. 안 그러면 실패를 못 봐요.
28. 50줄 미만은 셸, 그 이상은 Python. 자경단 경계선.
29. H6 졸업장 — hello.sh 한 장 직접 만들어 실행.
30. 다음 H7은 fork·exec·signal 0.001초 깊이. 한 시간 쉬고 만나요. 🐾
