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
| H6 | 응급처치 | 17,000 | 🟢 | 합격 (좋비·OOM·디스크풀·네트워크·CPU100% 5사고/Jetsam/dmesg/log show/journalctl/7다리진단/lsof·ss/renice·nice/emergency.sh골격/cron알람/7단계절차/위험5/macOS-Linux응급표/새벽3시재현/FAQ5/추신10) |
| H7 | kernel vs user space | 17,017 | 🟢 | 합격 (ring 0/3·EL0~3/syscall 7단계(RAX·MSR_LSTAR·sysret)/trap·interrupt·exception/page fault/context switch/strace·dtruss시연/syscall비용표/보이5층/mmap/eBPF/XNU(Mach+BSD) vs Linux/Tanenbaum-Linus논쟁/Meltdown·KPTI/vDSO·io_uring/FAQ5/추신18) |
| H8 | 적용+회고 | 17,037 | 🟢 | 합격 (8시간 큰그림 회수/emergency.sh 100줄 완성판(set·trap·run·5케이스함수·main)/dry-run·종료코드·plain text/procmon+emergency짝(진단·치료)/Ch002 다섯원리(자원한도·추상화·격리·권한분리·좁은다리)/12회수지도(Ch035·047·062·068·074·087·091·097·108·113·116·119)/macOS-Linux변환표 19행/흔한오해5/FAQ5(root·multipass·통합금지·자신감·예습)/Ch003 다리(TCP/IP·HTTP·DNS·HTTPS)/8시간 약속 회수/추신12) |

Ch002 합계: 136,084 / 목표 ~160,000
**Ch002 완료** ✅

## Ch 003 — 네트워크 기본

| H | 슬롯 | 현재 분량 | 상태 | 비고 |
|---|------|----------|------|------|
| H1 | 오리엔 | 17,075 | 🟢 | 합격 (우편비유/4핵심단어 TCP/IP·HTTP·DNS·HTTPS/한클릭0.3초 7단계 미리보기/ping 1.1.1.1·example.com 두줄/curl -I·-v 6단계 풀이/비유사전(패킷=봉투/포트=객실번호/소켓=통화회선/TLS=봉인도장)/8H 큰그림/고양이자경단 사진업로드 7단계/12회수지도(Ch004·020·031·047·055·062·068·074·091·097·108·113·116)/macOS-Linux 네트워크표 14행/흔한오해5+보너스/FAQ5+보너스/HTTPS=TLS로 감싼 TCP 소켓 위 HTTP 한줄정의/추신12) |
| H2 | 핵심개념4 | 17,035 | 🟢 | 합격 (5층 봉투 IP→TCP→TLS→HTTP+DNS 조언자/IPv4 vs IPv6+CIDR/사설IP 3대역/TCP 3-way·4-way·재전송·흐름·혼잡제어/UDP 5사용처/HTTP 메서드5+멱등성/상태코드5묶음+401vs403+502vs504/헤더 7가족+보안헤더(HSTS·CSP)/DNS 레코드7종(A·AAAA·CNAME·MX·NS·TXT·PTR)+TTL/resolver chain 5단계+dig +trace/TLS 1.3 1-RTT vs 1.2 2-RTT/인증서 체인+openssl x509 -dates/curl -v 9줄 풀이/자경단 4기둥 적용+한페이지 30요청/함정5+보너스/FAQ5+보너스/추신19) |
| H3 | 환경점검 | 17,049 | 🟢 | 합격 (네 숫자 카드 사설IP·게이트웨이·DNS·공인IP/ifconfig vs ip addr/route get default·ip route/scutil --dns·resolv.conf/etc/hosts+mDNSResponder 캐시/인터페이스 5형제 en0·lo0·utun·awdl·bridge/Wi-Fi SSID·RSSI·채널/회사 vs 집 5차이(대역·DNS·방화벽·프록시·TLS인터셉트)/HTTP_PROXY+NO_PROXY+proxy_on/off/VPN full vs split tunnel/방화벽 pf·iptables 위치/netinfo .zshrc 별칭/macOS-Linux 변환표 14행/함정5+추가보너스/FAQ7/회차지도 7곳/추신18) |
| H4 | 명령카탈로그 | 17,000 | 🟢 | 합격 (도구 14개+보너스5 — ping·traceroute/mtr·dig/nslookup/host·curl·wget·nc·openssl s_client·ss/netstat·lsof -i·tcpdump·tshark/wireshark·iperf3·arp/route+telnet·dog·gping·httpie·jq/다섯 도구 카드(ifconfig·dig·ping·nc·curl)/14행 도구 표/함정7+FAQ7/추신22) |
| H5 | — | — | ⚫️ | 스캐폴드 스텁 대기 |
| H6 | — | — | ⚫️ | 스캐폴드 스텁 대기 |
| H7 | — | — | ⚫️ | 스캐폴드 스텁 대기 |
| H8 | — | — | ⚫️ | 스캐폴드 스텁 대기 |

Ch003 합계: 68,159 / 목표 ~160,000

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
👉 **Ch 003 H5 신규 작성** (데모 — 한 페이지 요청 라이프사이클)
   - 클릭 0.0초부터 응답 0.3초까지 30단계 — 캐시/DNS/TCP/TLS/HTTP 요청/응답/렌더링, 4교시 도구·14개가 30단계 어디에 끌어드는지
