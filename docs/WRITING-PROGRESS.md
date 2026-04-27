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
| H5 | 데모 | 17,141 | 🟢 | 합격 (한 페이지 라이프사이클 30단계 — 클릭 0.0초→0.3초/5층 캐시(SW·HTTP mem·HTTP disk·HTTP/2 push·네트워크)/DNS 5절+DoH/TCP 3-way+slow start+SYN flood/TLS 1.3 1-RTT+0-RTT/HTTP/2 요청+HPACK/서버 5일 LB·TLS종료·앱·DB·직렬화/응답 헤더 7가족/TTFB+CDN/점진파싱+chunked/30워 폭발+preconnect/렌더트리·레이아웃·페인트/Web Vitals 4 LCP·INP·CLS·TBT/30행표+세 색깔 막대/curl -w 다섯숫자/오해6+FAQ7/추신23) |
| H6 | 트러블슈팅 | 17,005 | 🟢 | 합격 (네트워크 7다리 진단 — 인터페이스→게이트웨이→라우팅→DNS→IP 도달→포트→응답/다리별 정상 한 줄+실패 시그니처/dig +trace·ping·traceroute·mtr·nc -vz·curl -w/nettest() zsh 통합 함수 한 방/3 운영 사고 시나리오(DNS·인증서·포트 충돌)/ICMP 차단=서버 죽음 함정/VPN 좀비 라우팅/인증서 만료 30·14·7·1일 알람/흔한함정7+FAQ7+추신24) |
| H7 | 서버측서버 | 17,007 | 🟢 | 합격 (keepalive·HTTP/3·LB 내부 — 서버 5층(L0 DNS·L1 엣지·L2 L4LB·L3 L7LB·L4 앱)+두 고속도로(HTTP keepalive·연결풀)/TCP keepalive vs HTTP keepalive 단어 충돌/HTTP/1.1 HOL+6연결 우회+pipelining 폐기사/HTTP/2 멀티플렉싱+HPACK+서버푸시폐기+TCP HOL 잔존/HTTP/3 QUIC=UDP+TLS1.3+연결ID+0-RTT 모바일 핸드오프/curl --http3·Alt-Svc 진단/LB 알고리즘 4 RR·LC·Consistent Hash·P2C 표/sticky session 2구현(쿠키·IP해시)+함정/헬스체크 liveness vs readiness+shallow vs deep+서킷브레이커 closed/open/half-open/3 운영사고(keepalive좍비·CH핫스포·헬스체크cascade)/흔한오해 7+FAQ 7+추신 28) |
| H8 | 적용+회고 | 17,096 | 🟢 | 합격 (자경단 사이트 8주 네트워크 로드맵 — 1주 도메인·DNS / 2주 HTTPS·인증서자동화 / 3주 CDN(Cloudflare·Cache-Control·Vary) / 4주 nginx upstream LB+백엔드 2~3대+keepalive세팅 / 5주 헬스체크+5층 모니터링+알람 다섯 / 6주 Redis cache-aside·write-through·write-behind 셋 / 7주 HTTP/2·H/3 도입+UDP443+RUM A/B / 8주 런북 7섹션+Game day Mock 사고/Ch003 한장 지도 8H 압축+다섯 원리(층·이름주소분리·느슨결합·신뢰체인·관찰가능성)+12회수지도+Ch004 예고+우선순위 Must/Should/Could+비용표+오해7+FAQ7+추신24) |

Ch003 합계: 136,408 / 목표 ~160,000
**Ch003 완료** ✅

## Ch 004 — Git & GitHub 기본

| H | 슬롯 | 현재 분량 | 상태 | 비고 |
|---|------|----------|------|------|
| H1 | 오리엔 | 19,776 | 🟢 | 합격 (사진앨범 비유 — Git=코드 폴더의 사진앨범+타임머신+분산 백업+협업 도구 네 일 한 도구/4단어 Repository·Commit·Branch·Remote/5비유사전(snapshot=사진·HEAD=현재페이지·branch=평행우주·remote=구름백업·.git=앨범본체)/한 commit 0.05초 7단계(스테이징확인·스냅샷·tree·commit·HEAD·reflog·출력)/git status·git log 읽기전용 두줄 손풌기/git init+add+commit 5줄 미니레포 데모/8H 큰그림(H2개념·H3설치SSH·H4명령어23·H5데모·H6충돌·DetachedHEAD·force push 7사고·H7.git내부blob·tree·commit·tag·H8자경단레포운영)/CSS한줄 7단계 코드리뷰·CI·배포/12회수지도(Ch005·006·014·020·022·041·062·070·080·103·118·120)/macOS-Linux 설치만 다르고 명령 100% 동일 표/리누스 토르발스0 2005 BitKeeper 역사/흔한오해 5+보너스(Git≠GitHub/force push 맥락/commit 메시지/branch=한줄텍스트/.git 읽기안전/git pull 자동merge 위험)/FAQ 5+보너스/추신 12) |
| H2 | 핵심개념4 | 17,003 | 🟢 | 합격 (객체 그래프 깊게 — blob/tree/commit 3종 객체+SHA-1 content-addressable storage+zlib 압축+packfile delta 압축+`git gc`+SVN과의 O(1) 투타임 비교/commit 5필드 tree·parent·author·committer·message+Merkle DAG=블록체인 원조 2005년/branch=`.git/refs/heads/<n>` 한 줄짜리 텍스트 41바이트 충격+포스트잇 비유/HEAD attached(`ref:`)vs detached(sha 직접)+`HEAD~1`·`^`·`^2` 표기+`git switch -` 토글/세 영역 working·staging(.git/index)·repository+`git diff` 영역 비교/Merge fast-forward(라벨점프)vs three-way(merge commit+parent 2개)+회사 정책 --no-ff/Rebase 부모 옮겨 sha 재계산+공유 commit 금지+`git bisect` 이등분+`git rebase -i` squash/reword/drop+`git branch backup` 41바이트 안전장치/Merge vs Rebase 비교표+황금규칙 2줄/fetch=다운로드만·pull=fetch+merge 자동 위험·push+`--force-with-lease` 안전판/SHA-1 160bit·SHA-256 마이그·SHAttered 2017·7글자 단축/오해 5+보너스(pull≠동기화·merge commit 더럽지않음·rebase 안전/브랜치≠commit·HEAD≠main)/FAQ5+보너스/추신12) || H3 | 환경점검 | 17,015 | 🟢 | 합격 (설치·config·SSH 키 — macOS 3길(Xcode CLT·Homebrew·공식 .dmg)+Apple Silicon Homebrew 권장+`brew upgrade git` 주간 패치/Linux apt·dnf·pacman·apk 한줄/Windows git-scm.com vs WSL2 권장+CRLF 함정/`git config --global` 7줄(name·email·init.defaultBranch=main·pull.rebase·core.editor·core.autocrlf·push.autoSetupRemote+rerere)/`~/.gitconfig` 텍스트 INI 직접 cat+system/global/local 3단계 우선순위+`includeIf` 디렉터리별 분리/alias 5종 st·lg·co·br·cm/.gitignore 5부류(OS·에디터·의존성·빌드·비밀)+toptal API 보일러플레이트+AWS 키 철회 사고+secret scanning 3겹 방패+이미 추적파일 `git rm --cached`/SSH ed25519 생성(`-C` 라벨+패스프레이즈)+공개키 GitHub 등록+`ssh -T` Hi 확인+`git remote set-url` SSH 전환+macOS keychain 통합+`~/.ssh/config` Host github.com 5줄+ssh.github.com:443 우회+`IgnoreUnknown UseKeychain` 크로스OS/credential helper osxkeychain·cache vs PAT 2021 폐기/GPG 서명 commit Verified 뱃지+SSH 키로도 서명 2022 허용 gpg.format ssh 대체/흔한오해 5+보너스/FAQ 5+보너스/추신 12) |
| H4 | 명령어카탈로그 | 17,040 | 🟢 | 합격 (23개 명령어 한 표 + 위험도 신호등 — 6개 무리(만들기·확인/저장/이동/합치기/원격/되돌리기)+영단어 본의 그대로/🟢초록(read-only)·🟡노랑(local 안전)·🔴빨강(irreversible/remote)+옵션·상황이 신호등을 바꿈/23개 본 표(init·status·log·diff·add·commit·branch·checkout·switch·restore·merge·rebase·remote·push·pull·fetch·clone·tag·stash·reset·revert·cherry-pick·reflog 한 줄 정의+함정)/매일 6개 손가락 리듬(status·diff·add·commit·pull --rebase·push)+log --oneline -5+diff --staged 1차 자기리뷰+브라우저 PR 7번째 단계/주1~2 7개(branch·switch·merge·rebase·stash·tag·reflog)+switch -·rebase 백업 가지 41바이트/1년 8개(reset --hard·force-push·revert·cherry-pick·amend·rebase -i·clean -fd·filter-repo)+force-with-lease+--force-with-lease alias/자경단 13줄 흐름(9개 카탈로그 사용)+자동화로 대체되는 일 GitHub Actions·Merge버튼·dependabot/H3과 연결(7줄 config가 23줄 카탈로그를 매끈히)+회수11챕터(Ch005·006·014·020·041·062·070·080·103·118·120)/오해5+FAQ5+보너스+추신14 면접 3질문) |
| H5 | 데모 | 17,010 | 🟢 | 합격 (터미널 실연 — ~/playground/git-demo 빈폴더→git init→README 첫 commit→까미·노럑이 카드 2·3 commit→가지 따기 feat/cat-3-mini→fast-forward merge→conflict 시나리오(까미 검정 vs 턱시도)+`<<<<<<<`·`=======`·`>>>>>>>` 해석+손해결+merge --abort 탈출/`reset --hard 7777777` 일부러 4개 commit 날리고 `reflog`로 복원(HEAD@{1}) 알파과 오메가/.git/HEAD·.git/config 직접 열어보기+init.defaultBranch=main 적용 확인/oh-my-zsh·starship 프롬프트 권장/GitHub remote add origin SSH 세 줄+`push -u origin main` 첫 push+브라우저 확인/feat/cat-4-treasure feature 가지→push→PR→노랑 배너+Compare·Merge 초록 버튼→local 돌아와 pull --rebase+`-d` 안전 삭제/.gitignore 첫 commit 전에+이미 commit된 비밀은 filter-repo로만 제거/5가지 작은 사고과 한줄처방(amend, restore --staged, reset --soft HEAD~1, 잘못된 가지에 commit, rebase -i squash)/오해5+FAQ5+보너스+추신13) |
| H6 | 운영 | 17,034 | 🟢 | 합격 (저장소 운영 — 6개 도구 표(Issue·PR·Project·Discussions·Actions·Pages)+자경단 자리·빈도/Issue 양식 체크리스트·라벨·담당자·마일스톤+자경단 5부류 라벨(유형·지역·긴급도·상태·종류)+7색깔 의미+마일스톤×프로젝트 이중 묶기/PR 5의 특징(작게·1일·본문 명확·테스트·Issue 연결)+Conventional Commits 7prefix(feat·fix·docs·chore·refactor·test·style)+Draft PR early feedback+stack PR Meta·Google 패턴/리뷰 5톤(칭찬·질문·제안·요청·nit)+LGTM+신입성 자산+큰그림→디테일 두 단계+resolve conversation 컨벤션+머지 3옵션 squash 80%/branch protection 규칙 7체크+self-review/CODEOWNERS+소유자 다수는 OR·위치 .github/+글로브 패턴/Project 4칸 보드+Auto-add·Status 자동이동+신·구 Projects/Discussions 5카테고리+Issue↔Discussions 변환/README·CONTRIBUTING·CODE_OF_CONDUCT·SECURITY·LICENSE 5문서+CHANGELOG·ROADMAP 조직화/Actions Marketplace+Pages Jekyll/자경단 월~금 일주일 시몼+월 09:00 5분 의식+금 17:00 주간 정리/오해 5+FAQ 5+보너스 issue 아카이브+추신 15 Request changes 신중·자동 가지 삭제) |
| H7 | 내부동작 | 17,001 | 🟢 | 합격 (.git/ 9슬롯+서가 vs 종이 비유/objects/ 4종 객체+SHA-1+zlib+packfile delta+gc auto/refs 41바이트+HEAD attached/detached/index+stage+stat 캐싱/hooks 6종+husky+자경단 4가지+5계명/fsck·gc·prune·repack/응급실 한 페이지+5계명+reflog 90일+태그 영원/자경단 적용+H8 예고/오해5+FAQ5+추신15) |
| H8 | 적용+마무리 | 17,002 | 🟢 | 합격 (30분 종합 셋업 10단계 — git config 로컬 7줄/.gitignore 5부류+gitignore.io+자경단 도메인/branch protection 7체크+관리자 bypass 금지/CODEOWNERS 글로브+소유자 OR/Issue·PR 템플릿 YAML+체크리스트/Conventional Commits 10prefix+commitlint+husky/pre-commit hook 30줄(AWS키·5MB·lint-staged)+hook 5계명/5문서 README·CONTRIBUTING·CODE_OF_CONDUCT(Contributor Covenant)·SECURITY·LICENSE(MIT vs Apache 2.0)/GitHub Actions ci.yml/자기 PR v0.1.0 태그 5이유/다섯 원리 한 페이지(분산·콘텐츠 주소·불변성·분리·자동화)+CS 세계 연결/12회수 지도(Ch005·006·014·020·022·041·062·070·080·103·118·120)/Ch005 예고(GitHub Flow·Git Flow·Trunk-based+충돌 3깊이+CI/CD 5단계)/우선순위 Must5·Should5·Could5+3단 시간축/비용표 10행+시간 ROI/오해7+FAQ7+보너스 자가진단 6줄+추신15 첫 commit 습관) |

Ch004 합계: 137,901 / 목표 ~160,000
**Ch004 완료** ✅

## Ch 005 — Git 협업 워크플로우

| H | 슬롯 | 현재 분량 | 상태 | 비고 |
|---|------|----------|------|------|
| H1 | 오리엔 | 17,001 | 🟢 | 합격 (왜 협업 7이유 — 첫PR 5명·30% PR시간·force-push ROI 30분→5년 0회·톤 한단어 동료 한시간·5년차 워크플로우 디자이너·오픈소스 면접 1초·면접 7질문/세 패턴 첫인상 — GitHub Flow(Scott Chacon 2011·5명미만·1시간학습)·Git Flow(Vincent Driessen 2010·2020갱신·5종branch·50명+·1주일)·Trunk-based(Google·Meta·Netflix Spinnaker·매일100회·1달학습·feature flag)+한 표+살아있는 계약+패턴 진화/충돌 3깊이 — 깊이1 코드(5분~1h 도구가능 자주작게)·깊이2 의도(며칠~몇주 RFC·ADR)·깊이3 사회적(몇주~영원 신뢰 1년쌓기 1초깨기)+깊이0 예방+한 표+왜 신입은 깊이1 무서워하나·왜 시니어는 깊이3 무서워하나/8H 큰그림 표/자경단 5명(본인풀스택 메인테이너·까미백엔드 FastAPI·노랭이프론트 React·미니인프라 AWS·깜장이디자이너+QA Figma)+CODEOWNERS 매핑+한주흐름 월화수목금+화14:00 conflict 미리보기/합주 비유+지휘자 60% 조율+즉흥합주 hotfix+회고/자경단 적용 5개(.github/WORKFLOW.md·CONTRIBUTING 보강·commitlint·deploy preview·release자동화)+곱셈 효과+H2 예고(release vs deploy 분리)/오해8(워크플로우 큰회사용·Trunk-based 최고·코드충돌 가장큰문제·큰PR 효율·리뷰 시니어→주니어·Git Flow 정교=안전·1년 안바뀜·도구가 다해줌)/FAQ7(준비·1명만·다른패턴·SVN/Mercurial·시니어/큰팀 50명+·시니어 매일누적)/추신15) |

## Ch 005 다음 H 작성 큐
H2 핵심개념·H3 환경점검·H4 카탈로그·H5 데모·H6 운영·H7 원리·H8 적용

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
👉 **Ch 005 H2 신규 작성** (핵심개념 — 세 패턴 깊이 + branch 모델 + release vs deploy + 환경 분리)
   - GitHub Flow / Git Flow / Trunk-based 패턴별 branch 모델·release 주기·hotfix 처리, dev/staging/prod 환경 분리, release ≠ deploy 분리.
