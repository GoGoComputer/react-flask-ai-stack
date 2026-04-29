# Ch006 · H6 — 터미널·셸·Bash: 운영/스크립트 — 자경단 매일 운영 5스크립트

> **이 H에서 얻을 것**
> - `set -euo pipefail` 깊이 — 안전 5플래그가 자경단 스크립트의 첫 줄
> - function·signal trap·getopts·color 로그 — 100줄 스크립트의 5요소
> - shellcheck linter + bats 테스트 — 자경단 스크립트의 품질 도구
> - 자경단 5명 매일 운영 스크립트 5종 — deploy·rollback·monitor·migrate·backup
> - 5사고 방지 + 사고 시 진단·복구 — 운영 1년 면역

---

## 회수: H5의 30분 시뮬에서 본 H의 운영 1년으로

지난 H5에서 본인은 자경단 30분 셸 시뮬레이션 — cleanup.sh 30줄을 봤어요. 그건 **하루**의 그림.

이번 H6는 그 cleanup.sh가 **100줄 운영 스크립트로 진화**하는 그림이에요. 5명 자경단의 매일 운영 5종 스크립트가 1년의 자경단 사이트 운영을 사요.

지난 Ch005 H6은 git 자동화 1년 운영. 이번 H6는 셸 스크립트 1년 운영. 같은 운영 슬롯, 다른 도구. 둘이 합쳐 자경단의 평생 자동화.

---

## 1. `set -euo pipefail` — 자경단 스크립트의 첫 줄

자경단의 모든 스크립트 첫 줄.

### 1-1. 5플래그 깊이

> ▶ **같이 쳐보기** — 모든 스크립트의 첫 4줄
>
> ```bash
> #!/bin/bash
> set -euo pipefail
> IFS=$'\n\t'
> ```

- `-e` (errexit) — 에러 시 즉시 exit. 0 아닌 exit code면 멈춤.
- `-u` (nounset) — 정의 안 된 변수 사용 시 에러. `$undefined` 사고 방지.
- `-o pipefail` — 파이프 한 부분이라도 실패면 전체 실패. 기본은 마지막 명령만.
- `IFS=$'\n\t'` — Internal Field Separator를 줄바꿈·탭만. 공백 단어 분리 안 함.

### 1-2. 5플래그가 막는 사고

**`-e` 없는 사고**:
```bash
#!/bin/bash
make build      # 빌드 실패
deploy.sh       # 그래도 실행됨 (사고!)
```

**`-u` 없는 사고**:
```bash
rm -rf $TARGET_DIR/*    # TARGET_DIR이 비어 있으면 rm -rf /*
```

**`-o pipefail` 없는 사고**:
```bash
curl https://api/data | jq '.cats'   # curl 실패해도 jq가 0 반환 → 성공처럼 보임
```

5플래그가 자경단 1년에 5사고 방지. **5플래그가 5년의 안전벨트**.

### 1-3. 자경단 표준 스크립트 헤더

```bash
#!/usr/bin/env bash
#
# script-name.sh — 한 줄 설명
# Usage: script-name.sh [options] <args>
# Author: cat-vigilante
# Date: 2026-04-28
#
set -euo pipefail
IFS=$'\n\t'

# 글로벌 변수
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/script.log"
```

자경단 모든 스크립트 첫 12줄.

---

## 2. Function — 스크립트의 단위

50줄 넘으면 function으로 분리. 자경단 표준.

### 2-1. function 양식

```bash
# 함수 정의 (자경단 표준)
function log_info() {
  local message="$1"                       # local로 지역 변수
  echo "[INFO] $(date +%H:%M:%S) ${message}" >&2
}

function log_error() {
  local message="$1"
  echo -e "\033[31m[ERROR] $(date +%H:%M:%S) ${message}\033[0m" >&2
}

# 호출
log_info "자경단 deploy 시작"
log_error "DB 연결 실패"
```

`local`이 자경단 표준 — 외부 영향 없음. 안전.

### 2-2. function 5계명

1. **한 일만** — 한 함수 50줄 미만
2. **`local` 사용** — 지역 변수
3. **stderr로 로그** — `>&2`
4. **return 0/1** — 성공·실패 명시
5. **인자 검증** — `[[ -z "$1" ]] && return 1`

### 2-3. 자경단 자주 쓰는 function 5종

```bash
# 1. 색깔 로그
function log() {
  local level="$1"; shift
  local color
  case "$level" in
    INFO)  color="\033[32m" ;;   # 초록
    WARN)  color="\033[33m" ;;   # 노랑
    ERROR) color="\033[31m" ;;   # 빨강
    *)     color="\033[0m"  ;;
  esac
  echo -e "${color}[${level}] $(date +%H:%M:%S) $*\033[0m" >&2
}

# 2. 명령 존재 검증
function require() {
  local cmd="$1"
  command -v "$cmd" >/dev/null || {
    log ERROR "$cmd 명령 없음"
    exit 127
  }
}

# 3. 환경변수 검증
function require_env() {
  local var="$1"
  [[ -z "${!var:-}" ]] && {
    log ERROR "환경변수 $var 비어있음"
    exit 1
  }
}

# 4. 사용자 확인
function confirm() {
  local prompt="$1"
  read -rp "${prompt} [y/N] " ans
  [[ "$ans" == "y" || "$ans" == "Y" ]]
}

# 5. 디렉토리 진입
function cd_safe() {
  cd "$1" || {
    log ERROR "디렉토리 진입 실패: $1"
    exit 1
  }
}
```

5 function이 자경단 매일 스크립트 80%.

---

## 3. Signal Trap — 정리 자동

스크립트가 끝날 때(정상·에러·Ctrl+C) 자동으로 임시 파일 정리·리소스 해제.

### 3-1. trap 5종

```bash
# 5 신호 트랩
trap cleanup EXIT      # 정상·비정상 종료 모두
trap 'log ERROR "에러 발생"' ERR   # 에러 시
trap 'log WARN "Ctrl+C"; exit 130' INT   # Ctrl+C
trap 'log WARN "터미네이트"; exit 143' TERM   # kill
trap 'log INFO "재시작 신호"' HUP   # 재시작
```

### 3-2. cleanup function 표준

```bash
function cleanup() {
  local exit_code=$?
  log INFO "정리 시작 (exit=${exit_code})"
  
  # 임시 파일 삭제
  [[ -d "${TMP_DIR:-}" ]] && rm -rf "$TMP_DIR"
  
  # 잠금 해제
  [[ -f "${LOCK_FILE:-}" ]] && rm -f "$LOCK_FILE"
  
  # background process 종료
  jobs -p | xargs -r kill 2>/dev/null
  
  log INFO "정리 완료"
  exit "$exit_code"
}

trap cleanup EXIT
```

자경단의 모든 100줄+ 스크립트가 cleanup. **정리가 안전의 마지막 자물쇠**.

### 3-3. trap 사고 사례

```bash
# trap 없으면 — 임시 파일 영구 남음
mkdir /tmp/work-XXX
# (스크립트 중간 에러 → /tmp/work-XXX 영원히)

# trap 있으면 — 자동 정리
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
# (어떤 종료든 정리)
```

자경단 1년 운영의 50% 절약 — `/tmp` 청소.

---

## 4. getopts — 옵션 파싱

스크립트에 `--verbose`·`--dry-run` 같은 옵션 처리.

### 4-1. getopts 양식

```bash
function usage() {
  cat <<EOF
Usage: $0 [OPTIONS] <target>

Options:
  -v, --verbose    상세 출력
  -d, --dry-run    실제 실행 없음
  -h, --help       도움말

Examples:
  $0 deploy production
  $0 -v rollback v1.0.0
EOF
  exit 0
}

# 기본값
VERBOSE=0
DRY_RUN=0

# 옵션 파싱 (getopts — 한 글자만)
while getopts "vdh-:" opt; do
  case "$opt" in
    v) VERBOSE=1 ;;
    d) DRY_RUN=1 ;;
    h) usage ;;
    -)  # --long 옵션
        case "$OPTARG" in
          verbose) VERBOSE=1 ;;
          dry-run) DRY_RUN=1 ;;
          help)    usage ;;
          *) log ERROR "알 수 없는 옵션: --$OPTARG"; exit 2 ;;
        esac ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

# 위치 인자
TARGET="${1:-}"
[[ -z "$TARGET" ]] && { log ERROR "target 필수"; usage; }
```

### 4-2. 사용 예

```bash
$ ./script.sh -v deploy
# VERBOSE=1, TARGET=deploy

$ ./script.sh --dry-run rollback v1.0
# DRY_RUN=1, TARGET=rollback

$ ./script.sh --help
# usage 출력
```

### 4-3. getopts 한계

- 한 글자 옵션만 (`-v`)
- 긴 옵션 (`--verbose`)은 `-`을 따로 처리 (위 예)
- 더 복잡하면 `getopt` (다른 명령) 또는 자체 파싱

자경단 — 작은 스크립트는 getopts, 큰 거는 자체 파싱.

---

## 5. Color 로그 함수 — 스크립트 가독성

자경단 표준 로그 함수.

### 5-1. 5색 로그 함수 (위 2-3 회수)

```bash
function log() {
  local level="$1"; shift
  local color reset="\033[0m"
  case "$level" in
    DEBUG) color="\033[37m" ;;   # 회색
    INFO)  color="\033[32m" ;;   # 초록
    WARN)  color="\033[33m" ;;   # 노랑
    ERROR) color="\033[31m" ;;   # 빨강
    FATAL) color="\033[35m" ;;   # 보라
    *)     color="" ;;
  esac
  echo -e "${color}[${level}] $(date +%Y-%m-%d\ %H:%M:%S) $*${reset}" >&2
}
```

### 5-2. 사용

```bash
log INFO "deploy 시작"
log WARN "메모리 80% 도달"
log ERROR "DB 연결 실패"
log FATAL "리소스 고갈, 종료"
```

색깔 + timestamp + 5 레벨 구분. 자경단 매일 5명이 같은 양식.

### 5-3. 파일·터미널 동시 — `tee`

```bash
function log_to_file() {
  log "$@" 2>&1 | tee -a "$LOG_FILE"
}
```

화면 + 파일 동시 기록.

---

## 6. shellcheck Linter — 스크립트 품질 검사

자경단 스크립트의 lint 도구.

### 6-1. 설치 + 사용

> ▶ **같이 쳐보기** — 셸 스크립트 lint 30초 도입
>
> ```bash
> brew install shellcheck
> shellcheck script.sh
> ```

### 6-2. 자주 잡히는 5문제

```bash
# SC2086 — 변수 unquoted
rm $file              # 위험!
rm "$file"            # 안전 ✓

# SC2046 — command substitution unquoted
ls $(date +%Y%m%d)    # 위험
ls "$(date +%Y%m%d)"  # 안전

# SC2155 — 선언 + 명령 합치면 exit code 잃음
local result=$(some_command)         # exit code 잃음
local result; result=$(some_command) # 분리 ✓

# SC2034 — 사용 안 한 변수
unused="something"

# SC2154 — 정의 안 한 변수
echo "$undefined"
```

### 6-3. CI에 shellcheck

```yaml
# .github/workflows/lint-shell.yml
name: Lint shell scripts
on: [pull_request]
jobs:
  shellcheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: shellcheck scripts/*.sh
```

자경단 표준 — pre-commit hook 또는 CI에 shellcheck. 매 PR마다 lint.

---

## 7. bats — 셸 스크립트 테스트

자경단 1년 차에 도입.

### 7-1. 설치 + 첫 테스트

```bash
$ brew install bats-core
$ cat > test/deploy.bats <<'EOF'
#!/usr/bin/env bats

@test "deploy.sh --help 출력" {
  run ./deploy.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "deploy.sh 인자 없으면 에러" {
  run ./deploy.sh
  [ "$status" -ne 0 ]
}
EOF
$ bats test/deploy.bats
```

### 7-2. bats 5요소

1. `@test "이름"`
2. `run command`로 실행
3. `$status`로 exit code 확인
4. `$output`로 출력 확인
5. `[ ... ]`·`[[ ... ]]`로 assert

### 7-3. 자경단 표준

작은 스크립트(~50줄)는 bats 안 씀. 큰 스크립트(100줄+)는 bats 5~10 테스트. 1년 후 도입 권장.

---

## 8. 자경단 매일 운영 스크립트 5종

자경단 5명의 매일 운영 5스크립트.

### 8-1. deploy.sh — 본인이 매주 금요일

```bash
#!/usr/bin/env bash
set -euo pipefail
trap cleanup EXIT

ENV="${1:-staging}"
log INFO "deploy 시작: ${ENV}"

# 1. main 최신
git checkout main && git pull --rebase

# 2. test
npm test || { log ERROR "test 실패"; exit 1; }

# 3. build
npm run build

# 4. tag
VERSION=$(jq -r '.version' package.json)
git tag "v${VERSION}"
git push origin "v${VERSION}"

# 5. deploy
ssh deploy@server "cd /var/www && git pull && systemctl restart cat-vigilante"

log INFO "deploy 완료: v${VERSION} → ${ENV}"
```

### 8-2. rollback.sh — 미니가 사고 시

```bash
#!/usr/bin/env bash
set -euo pipefail

PREVIOUS_TAG="${1:-}"
[[ -z "$PREVIOUS_TAG" ]] && { echo "Usage: $0 <previous-tag>"; exit 1; }

confirm "rollback to ${PREVIOUS_TAG}?" || exit 0

ssh deploy@server "cd /var/www && git checkout ${PREVIOUS_TAG} && systemctl restart cat-vigilante"
log INFO "rollback 완료: ${PREVIOUS_TAG}"
```

### 8-3. monitor.sh — 미니가 매일 09:00

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. 사이트 health check
curl -f https://cat-vigilante.org/health || alert "사이트 다운!"

# 2. ERROR log 카운트
errors=$(grep -c ERROR /var/log/app.log)
[[ "$errors" -gt 100 ]] && alert "ERROR ${errors}건"

# 3. 디스크 사용
disk=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
[[ "$disk" -gt 80 ]] && alert "디스크 ${disk}%"

log INFO "monitor 완료: errors=${errors}, disk=${disk}%"
```

### 8-4. migrate.sh — 까미가 DB 변경 시

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. backup 먼저
./backup.sh

# 2. migration 실행
alembic upgrade head

# 3. test
pytest tests/db_test.py || {
  log ERROR "migration 후 test 실패, rollback"
  alembic downgrade -1
  exit 1
}

log INFO "migration 완료"
```

### 8-5. backup.sh — 매일 02:00 cron

```bash
#!/usr/bin/env bash
set -euo pipefail

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/${DATE}"
mkdir -p "$BACKUP_DIR"

# 1. DB
pg_dump cat_vigilante > "${BACKUP_DIR}/db.sql"

# 2. uploaded files
tar -czf "${BACKUP_DIR}/uploads.tar.gz" /var/www/uploads

# 3. config
cp /etc/cat-vigilante.conf "${BACKUP_DIR}/"

# 4. S3 업로드
aws s3 sync "$BACKUP_DIR" "s3://cat-vigilante-backup/${DATE}"

# 5. 30일 이상 로컬 백업 삭제
find /backup -mtime +30 -type d -exec rm -rf {} \; 2>/dev/null

log INFO "backup 완료: ${BACKUP_DIR}"
```

5 스크립트 × 평균 30줄 = 150줄. 자경단 매일 운영 자동화.

---

## 9. 자경단 스크립트 5계명

1. **set -euo pipefail** 첫 줄 (안전)
2. **trap cleanup EXIT** (정리)
3. **function 분리** (50줄 단위)
4. **shellcheck** lint (CI)
5. **5 색깔 로그** + LOG_FILE (가독성)

5계명이 자경단 모든 스크립트의 표준.

---

## 10. 흔한 오해 7가지

**오해 1: "set -e만 있으면 안전."** — `-u` (unset)·`-o pipefail`도 필수. 셋이 5플래그.

**오해 2: "trap은 큰 스크립트만."** — 50줄+ 모두. 임시 파일 정리는 자동.

**오해 3: "getopts는 어려워."** — 5줄 양식 외우면 끝. 자경단 표준 패턴.

**오해 4: "shellcheck는 까칠해."** — 까칠한 게 안전. 1년 후 본인의 매일 친구.

**오해 5: "bats는 5명 자경단에 과해."** — 1년 차에 도입. 100줄+ 스크립트만.

**오해 6: "스크립트도 git에 안 박음."** — 박음. dotfiles repo의 한 디렉토리. 5년 자산.

**오해 7: "운영 스크립트는 시니어 일."** — 신입도 5분 스크립트. 본 H가 그 시작.

---

## 11. FAQ 7가지

**Q1. set -euo pipefail이 너무 엄격하지 않나요?**
A. 처음엔 답답하지만 1주일 후 익숙. 사고 5건 → 0건의 차이.

**Q2. trap의 cleanup function 위치?**
A. 스크립트 위쪽에 정의 (사용 전). trap도 일찍 등록.

**Q3. getopts vs getopt 차이?**
A. getopts는 bash built-in (POSIX, 한 글자만). getopt는 외부 (긴 옵션 가능). 자경단 — getopts가 단순.

**Q4. shellcheck disable comment?**
A. `# shellcheck disable=SC2086`로 특정 줄 무시. 가끔 필요.

**Q5. bats의 한계?**
A. 외부 명령 mocking 어려움. function-level 단위 테스트 적합.

**Q6. 5스크립트 외에 더?**
A. status·log-rotate·user-add 등 운영 따라. 처음 5개로 시작 → 1년 후 10~20개.

**Q7. cron vs systemd timer?**
A. 자경단 표준 cron (단순). systemd timer는 1년 후 검토 (의존성·복구 강력).

---

## 추신

set -euo pipefail이 자경단 스크립트의 첫 줄. 5플래그가 5사고 방지. trap cleanup EXIT가 임시 파일 정리의 자동. 50줄+ 모두. function의 5계명 — 한 일만·local·stderr 로그·return·인자 검증. 5계명이 모든 function.

