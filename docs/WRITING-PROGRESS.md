# 작성 진행표 (Writing Progress)

> 목표: 모든 H 강의 = **공백 제외 19,000~21,000자** (60분 대본)
> 한 턴 = H 한 개 확장(또는 신규 작성). 한 H가 너무 크면 2턴으로 분할.

## 분량 규칙
- 목표: 19,000~21,000 (no-space chars, 한국어)
- 합격선: ≥ 17,000
- 측정: `python3 scripts/wc-lecture.py <file>` (헬퍼 추가 예정)

## 워크플로
1. 매 턴 시작: 이 파일 읽고 다음 미완료 H 1개 선택
2. 작성/확장 → 분량 측정 → 합격이면 ✅, 미달이면 🟡 (다음 턴에 보강)
3. 커밋 + 푸시
4. 이 파일 갱신

## Ch 001 — 컴퓨터 구조 기본

| H | 슬롯 | 현재 분량 | 상태 | 비고 |
|---|------|----------|------|------|
| H1 | 오리엔 | 17,011 | 🟢 | 합격 |
| H2 | 핵심부품4 | 17,055 | 🟢 | 합격 (광고사양/가격/고양이자경단/FAQ/역사/실패시나리오 추가) |
| H3 | 환경점검 | 17,013 | 🟢 | 합격 (비교표/시리얼/버전사/함정/고양이자경단/FAQ/셔/임터존/디스크+네트/추론/치트시트 추가) |
| H4 | 명령어카탈로그 | 17,005 | 🟢 | 합격 (보너스5/파이프/찾기/위험/서버/FAQ/단축키/해부학/신호등/alias/역사/치트시트/게임) |
| H5 | sysinfo.sh 데모 | 17,003 | 🟢 | 합격 (셔뱅/set가족/변수/awk·sed·tail/ANSI/확장5/서버헬스체크/실패7/FAQ/start-finish/역사/디버깅2자세/러버덕) |
| H6 | 응급처치 | 17,001 | 🟢 | 합격 (swap/find사냥/traceroute·dig·lsof/kill안전/위험명령/일핔5/치트시트/다분야5단/백업3-2-1/단축키/GUI5/두해후장면/FAQ6) |
| H7 | 폰노이만+캐시 | 17,000 | 🟢 | 합격 (파이프라이닝/분기예측/멀티코어/SIMD·GPU/코드비교/Redis/CDN/병목/무효화/폰노이만/추상화×7/광고재해석/실험/FAQ6) |
| H8 | 적용+회고 | 17,015 | 🟢 | 합격 (예산3트랙/신품중고리퍼/리눅스변환표/2028장면/학습곡선/다섯원리/FAQ5/한줄정리/페이스가이드/함정5/큰지도/점검표/Ch002예고) |

Ch001 합계: 153,103 / 목표 ~160,000
**Ch001 완료** ✅

## Ch 002 — 운영체제 기본

| H | 슬롯 | 현재 분량 | 상태 | 비고 |
|---|------|----------|------|------|
| H1 | 오리엔 | 17,008 | 🟢 | 합격 (호텔매니저/운영체제=OS/커널/셰/유닉스가족나무/macOS·Linux·Windows/프로세스·스레드·파일·syscall/kernel-user space/고양이자경단7단계/12회수지도/다섯일/FAQ5/두주약속) |
| H2 | 핵심개녘 4 | 17,008 | 🟢 | 합격 (프로세스·스레드·파일·syscall/PID-PPID-fork-exec/R-S-T-Z-I/동시성vs병렬성/race condition/fd 0·1·2/rwx 9비트/syscall 7단계/4개념짝짓기/고양이자경단7재등장/비용표/PID1/틀한오해 5/8줄비유) |
| H3 | 환경점검 | 17,002 | 🟢 | 합격 (uname 7부분/sw_vers 3줄/sysctl 5네임스페이스/hostname/id-whoami-groups/env-PATH/ulimit/proc-sys참고/system_profiler/dmesg-log/uptime-load avg/OS신분증카드/macOS-Linux변환표/Apple Silicon함정/.zshrc/myinfo alias/getconf/FAQ5) |
| H4 | 명령어카탈로그 | 17,004 | 🟢 | 합격 (ps 11열/ps옵션5형제/top·htop/kill+신호7대표/SIGTERM·SIGKILL·SIGHUP/killall·pkill·pgrep/jobs·bg·fg/nohup·disown·&/wait·$$·$!·$?/pidof/실전7시나리오/5분손풀기/위험5종/macOS-Linux차이표/FAQ5/추신5) |
| H5 | procmon.sh데모 | 17,008 | 🟢 | 합격 (셰뱅/set가솄3종/trap·신호/getopts/OS분기case/함쉘5개(summary·top_cpu·top_mem·zombies·user_procs)/local변수/while루프/main"$@"/bash -x디버깅/cron보너스/shellcheck/sysinfo+procmon짝/FAQ5/추신12) |
| H6~H8 | — | — | ⚫️ | 스캐폴드 스텁 대기 |

Ch002 합계: 85,030 / 목표 ~160,000

## 작성 순서 정책
1. **먼저** Ch001 H1을 20k로 보강 (1회 = 1턴)
2. Ch001 H2 보강 (1턴)
3. ... H8까지 (총 7턴)
4. 그 다음 Ch002 신규 H1~H8 (각 H = 보통 2턴 = 신규 10k + 보강 10k)
5. 한 턴이 종료되면 반드시 이 표 업데이트 + 커밋

## 헬퍼
- `scripts/wc-lecture.py FILE` → no-space char 수 출력
- `scripts/wc-lecture.py --all` → 모든 chapters/*/lecture/H*.md 표

## 다음 턴 즉시 할 일
👉 **Ch 002 H6 신규 작성** (응급처치 — OS 사고 5종)
   - 좋비청소/OOM/디스크풀/네트워크끊김/CPU100%, 한줄소방소
