# H4 · 네트워크 기본 — 명령어 카탈로그 — 도구 14개 한 번씩

> 고양이 자경단 · Ch 003 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 3교시 회수와 4교시 약속 — 도구 14개를 한 번씩
2. ping — "살아 있냐"의 가장 짧은 질문
3. traceroute / mtr — 봉투의 여정 그리기
4. dig / nslookup / host — 이름을 IP로
5. curl — HTTP 만능 칼
6. wget — 파일 받아오기 전용
7. nc(netcat) — 손으로 TCP 연결 만들기
8. openssl s_client — TLS 손으로 깎기
9. ss / netstat — 내 노트북의 열린 포트
10. lsof -i — 어느 프로세스가 그 포트를?
11. tcpdump — 와이어 위의 봉투 직접 보기
12. tshark / wireshark — tcpdump의 그래픽 친구
13. iperf3 — 회선 속도 진짜 측정
14. arp / route — 같은 동네 친구들과 갈림길
15. 도구 14개 한 표 정리 + 14개 묶음 카드
16. 흔한 함정 다섯 개 + FAQ 다섯 개
17. 다음 시간 예고 + 한 줄 정리

---

## 🔧 강사용 명령어 한눈에

```bash
# 4교시 시연 — 도구 14개를 위에서 아래로 한 번씩
ping -c 3 1.1.1.1
ping -c 3 example.com
traceroute -n example.com               # macOS/Linux
mtr -rwc 30 example.com                 # 살아 있는 traceroute(설치 필요)
dig +short example.com
dig @1.1.1.1 example.com A +noall +answer
nslookup example.com 8.8.8.8
host example.com
curl -I https://example.com
curl -sv https://example.com -o /dev/null 2>&1 | head -25
wget -qO- https://example.com | head -5
nc -vz example.com 443
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -dates -subject -issuer
ss -tunap 2>/dev/null || netstat -an | head -20    # Linux면 ss
lsof -nP -iTCP -sTCP:LISTEN | head
sudo tcpdump -i any -nn -c 10 'port 53'
iperf3 -c iperf.he.net -p 5201 -t 5
arp -a | head
netstat -rn | head
```

---

## 1. 3교시 회수와 4교시 약속 — 도구 14개를 한 번씩

자, 4교시예요. 3교시에선 본인이 어디 있는지를 봤어요. 사설 IP, 게이트웨이, DNS 서버, 공인 IP. 네 숫자 카드 한 장. 그리고 netinfo 별칭이 .zshrc에 박혔어요. 4교시는 그 카드를 들고 본격적인 도구 가방을 여는 시간이에요. 한 시간에 도구 14개를 한 번씩 쥡니다. ping부터 tcpdump까지. 외우라는 게 아니에요. "이런 도구가 있더라"가 머리에 박히면 충분해요. 다음에 사고가 났을 때 "어떤 도구를 꺼낼지" 한 번에 떠오르는 게 4교시의 결과물입니다. 한 가지 — 도구마다 깊이는 다르게 갑니다. ping·curl·dig 셋은 평생 가는 친구라 손에 쥐어 보고, traceroute·nc·openssl은 응급 도구라 한 번씩 만져 보고, tcpdump·tshark는 인사 정도. 깊은 사용은 H6(트러블슈팅)에서 7다리 진단으로 다시 등장합니다. 그리고 약속 — 4교시 끝에 "도구 14개 카탈로그 한 페이지"가 본인 손에 들립니다. 책상 옆에 붙여 두시고, 사고 날 때마다 "어 이거 4교시에서 본 그 도구"라고 손이 가게 만드시면 돼요. 자, 한 가지 더 강조하면 — 도구는 칼이 아니라 거울이에요. 무엇을 베는 게 아니라 시스템 어느 부위가 어떤 모양인지 비춰 주는 게 도구의 본업이에요. ping은 도착 가능성을, dig는 이름 풀이를, curl은 응답을, tcpdump는 와이어 위 모든 흐름을 거울처럼 비춥니다. 그래서 "어느 거울로 어디를 비추느냐"가 디버깅의 절반이에요. 나머지 절반은 그 거울에 비친 모양을 머리 속 5층 봉투 그림에 맞춰 보는 일이고요. 자, 시작합니다.

## 2. ping — "살아 있냐"의 가장 짧은 질문

ping은 가장 작은 도구예요. ICMP echo request를 한 발 보내고 echo reply가 돌아오는 걸 기다리는 도구. 한 줄로 — "살아 있냐"라는 가장 짧은 질문이에요. 한 가지 풀어 두면, ICMP는 1교시 봉투 비유에서 "우체국 자체의 행정 명령"이에요. TCP·UDP가 일반 편지와 소포라면 ICMP는 다른 편지와 함께 가는 행정 메모예요. "이 주소에 당신이 살고 있느냐"라는 메모에 "예, 살고 있습니다"라는 메모가 돌아오는 게 ping의 사이클. 다른 편지와 함께 가는 메모라 일부 라우터는 이 메모를 무시해도 아무개 안 해요. 그래서 ping이 안 가는 경우가 세 가지가 될 수 있어요. (1) 서버가 진짜로 죽음. (2) 서버는 살아 있는데 방화벽이 ICMP만 차단. (3) 서버가 설정에서 ICMP를 무시 설정. 둘째·셋째가 이탈공구, AWS 같은 클라우드에서 흔해요. 그래서 ping은 첫 단서로만 쓰세요. "가면 살아 있음 확실, 안 가면 손다€." 자, 이제 한 줄을 쳐 봅시다.

```bash
ping -c 3 1.1.1.1
```

세 발만 보내고 끝나요. macOS는 -c, Linux도 -c. Windows는 -n. 출력 한 줄 — `64 bytes from 1.1.1.1: icmp_seq=0 ttl=57 time=4.32 ms`. 풀어 보면 (1) 64바이트 — 페이로드 크기. (2) icmp_seq=0 — 첫 번째 발. (3) ttl=57 — Time To Live. 봉투가 라우터 한 대 넘을 때마다 1씩 줄어드는 카운터. 시작할 때 64였다면 7개 라우터를 거친 거예요. (4) time=4.32 ms — 왕복 시간. 5밀리초 안쪽이면 동네 안 또는 같은 ISP. 30밀리초면 같은 대륙, 200밀리초면 지구 반대편. 이게 RTT(round trip time)이에요. ping의 사용처 세 가지. (1) **인터넷 살아 있나 빠른 확인** — `ping -c 3 1.1.1.1`. 안 가면 게이트웨이 또는 그 너머 죽음. (2) **DNS 살아 있나** — `ping -c 3 example.com`. IP는 가는데 도메인 안 가면 DNS 문제. (3) **회선 품질 측정** — `ping -c 100 1.1.1.1` 100발 보내고 손실율(packet loss)과 표준편차 측정. 손실 5% 넘으면 회선 불량. 한 가지 함정 — 회사·일부 라우터·일부 클라우드 서버는 ICMP를 차단해요. ping 안 간다고 죽은 게 아닐 수 있어요. ping이 막힐 때는 nc(다음에 봅니다)로 TCP 한 발 보내는 게 답입니다. ping의 가장 짧은 한 줄 정의 — **"살아 있냐 ICMP 한 발 + 왕복시간"**.

## 3. traceroute / mtr — 봉투의 여정 그리기

ping이 한 발이라면 traceroute는 봉투가 거치는 라우터 모두를 한 줄씩 그려 줍니다. 조금 더 풀어 두면 — 본인이 서울에서 부산 친구에게 편지를 보내면 그 편지는 본인 동네 우체국 → 서울 중앙우체국 → 전국 분류소 → 부산 중앙우체국 → 부산 동네 우체국 → 친구 집, 이렇게 5~6고개 우체국을 거쳐요. 네트워크도 똑같아요. 본인 노트북 → 공유기 → ISP 동네 국 → ISP 중앙 국 → 국제 구간 → 콘텐츠 회사 CDN → 서버. 한 편지가 보통 8~15hop을 거쳐요. 그 모든 hop을 이름과 IP와 소요 시간으로 그려 주는 게 traceroute예요. 어떻게? TTL을 1로 두고 한 발 보내면 첫 라우터에서 TTL 0이 되면서 ICMP "time exceeded"가 돌아와요. 그게 첫 라우터의 정체. TTL을 2로 두면 두 번째. 30까지 올리면 30hop이 줄줄이 그려져요.

```bash
traceroute -n example.com
```

-n은 "이름 풀지 마"(DNS 안 함). 더 빨라요. 출력 한 줄 한 줄 — `1  192.168.0.1  1.234 ms  1.123 ms  1.054 ms`. 같은 hop을 3번 보내고 세 RTT를 보여 줘요. 그리고 hop마다 IP 한 개. 별표(*)가 뜨면 그 라우터가 ICMP 응답 안 한 거. 일부 라우터는 정책상 응답 안 해요. 끝까지 별표면 끊긴 게 아니라 그냥 익명 라우터를 거친 것일 수 있어요. mtr는 traceroute의 살아 있는 버전이에요. 한 번에 한 줄 그리는 게 아니라 계속 갱신하면서 hop마다 손실율과 평균 RTT를 표로 보여 줘요.

```bash
mtr -rwc 30 example.com
```

-r 보고서 모드, -w 와이드, -c 30 30초 측정. 회선이 어디서 손실 나는지 30초 안에 그림이 잡혀요. ISP 백본 어딘가에서 5% 손실 — 이런 게 깔끔하게 보여요. 사용처 — (1) **느린 사이트 어디가 병목인지**. 6번째 hop에서 RTT가 갑자기 200ms로 튀면 거기가 병목. (2) **회선 사고 위치 추정**. 우리 동네까지는 잘 가는데 다음 hop에서 끊기면 ISP 책임. mtr는 macOS·Linux 둘 다 brew/apt로 설치. 평생 가는 도구예요.

## 4. dig / nslookup / host — 이름을 IP로

dig는 2교시에서 한 번 쥐었어요. 4교시에선 옵션 세 개를 추가합니다. (1) `+short` — 답만. (2) `+noall +answer` — 자세하지만 핵심만. (3) `@서버` — 특정 DNS 서버에 직접 묻기.

```bash
dig +short example.com
dig @1.1.1.1 example.com A +noall +answer
dig @8.8.8.8 example.com MX +short
```

세 줄. 첫 줄은 IP만. 두 번째는 답 섹션만 보여요(질문 섹션·서버 정보 생략). 세 번째는 메일 서버 조회. dig는 +trace로 루트 DNS부터 직접 따라가는 모드도 있는데, 2교시에서 한 번 봤어요. nslookup은 dig의 옛날 친구예요. 윈도우와 일부 회사에선 dig가 막혀 있고 nslookup만 동작합니다.

```bash
nslookup example.com 8.8.8.8
```

마지막 인자가 DNS 서버. 출력은 dig보다 깔끔하지만 옵션이 적어요. host는 dig·nslookup 사이의 짧은 친구.

```bash
host example.com
host -t MX example.com
host -t TXT example.com
```

세 줄로 답이 줄줄. 일상 빠른 조회용. 한 가지 — DNS 도구는 셋 다 같은 일을 다른 모양으로 합니다. 본인 환경에서 막힌 게 있으면 다른 걸 쓰세요. 회사에서 dig가 막혀 있으면 host나 nslookup으로 우회. 그리고 — **resolver 캐시 우회 트릭**. `dig @8.8.8.8 example.com`은 본인 노트북의 stub resolver를 안 거치고 곧장 8.8.8.8에 묻는 거라 캐시 회피용으로 좋아요. /etc/hosts에 적어 둔 임시 매핑이 dig 결과에 안 보이는 게 그래서예요. dig는 hosts 파일 안 봐요. ping은 봅니다. 도구마다 hosts 파일을 보냐 안 보냐가 달라서 같은 도메인이 도구마다 다른 IP로 풀리는 사고가 가끔 납니다.

## 5. curl — HTTP 만능 칼

curl은 4교시에서 가장 많이 만질 도구예요. 조금 더 풀어 두면 curl은 1996년에 스웨덴의 Daniel Stenberg가 만들어서 30년 넘게 시장에서 괴롭혀온 도구예요. 세상 모든 macOS, Linux, Windows 10+, BSD에 기본 탑재. 테슬라 로켓에도, 화성 탐사선에도 curl이 돌아가고 있어요(진짜 이야기). HTTP만의 도구가 아니라 거의 모든 프로토콜(HTTP, HTTPS, FTP, SMTP, IMAP, MQTT 등 25개+)에서 써요. HTTP만의 도구가 아니라 거의 모든 프로토콜(HTTP, HTTPS, FTP, SMTP, IMAP, MQTT 등 25개+)에서 써요. 일상은 HTTP/HTTPS만 알면 됩니다. 옵션 일곱 개를 손에 쥡시다. (1) `-I` 헤더만. (2) `-v` 자세히. (3) `-s` 진행 표시 끔. (4) `-o 파일` 결과를 파일로. (5) `-L` 리다이렉트 따라감. (6) `-H "헤더: 값"` 헤더 추가. (7) `-d "데이터"` POST 본문.

```bash
curl -I https://example.com
curl -sv https://example.com -o /dev/null 2>&1 | head -25
curl -sL https://example.com -o page.html
curl -H "Authorization: Bearer abc" https://api.example.com/me
curl -d '{"name":"Cat"}' -H "Content-Type: application/json" https://api.example.com/cats
curl -X DELETE https://api.example.com/cats/42
curl --resolve example.com:443:1.2.3.4 https://example.com  # /etc/hosts 임시 우회
```

일곱 줄. 마지막 한 줄(`--resolve`)이 디버깅의 비밀병기예요. /etc/hosts 안 건드리고 단 한 번만 IP를 강제로 박을 수 있어요. 새 서버 배포 검증할 때 가장 자주 씁니다. 그리고 한 가지 — `curl -v`의 출력을 H1·H2에서 한 번씩 손에 쥐었죠. 점차 손에 익을 거예요. SSL handshake 봉투 본 그 출력이에요. curl은 평생 가는 도구라 매일 한 번은 칠 거예요.

## 6. wget — 파일 받아오기 전용

wget은 curl의 사촌이에요. 다만 더 단순. "URL 한 줄 주면 그 파일 받아라"가 본업이에요. 조금 더 풀어 두면 — wget은 1996년 GNU 프로젝트에서 시작했고 "재귀 다운로드"가 강점이에요. 사이트 한 개를 통째로 디스크에 미러링할 때 거의 표준이고, 큰 파일을 받다 끊겨도 자동으로 이어받기를 시도해요. 그래서 데이터셋 다운로드(수 GB), 운영체제 ISO, 백업 같은 작업에 wget이 자주 쓰여요. 

```bash
wget https://example.com/big-file.zip
wget -qO- https://example.com | head -5
wget -r -np -k https://example.com/docs/
```

세 줄. 첫 줄은 그냥 다운로드. 두 번째는 quiet + 표준출력으로(curl처럼). 세 번째는 사이트 미러링(-r 재귀, -np 부모 디렉터리 안 감, -k 링크 로컬화). curl과 wget의 차이를 한 줄로 — **curl은 만능 칼, wget은 다운로드 전용 톱**. macOS는 기본 미설치(brew install wget), Linux는 보통 기본. 둘 다 알아 두시되 일상은 curl로 충분합니다. 한 가지 — wget은 재시도와 이어받기가 강해서, 큰 파일 다운로드(수 GB)에는 wget이 더 적합해요. curl로 큰 파일 받다가 끊기면 -C - 옵션으로 이어받지만 wget은 자동.

## 7. nc(netcat) — 손으로 TCP 연결 만들기

nc는 진짜 손으로 TCP 연결을 만들어 보는 도구예요. ping은 ICMP만, curl은 HTTP만. nc는 그 어떤 TCP 또는 UDP 포트라도 직접 두드려요. 한 줄로 — "TCP의 스위스 군용 칼"이라고 불립니다. 1995년부터 있던 오래된 도구로, 그동안 fork·재구현이 많아 OpenBSD nc·GNU netcat·ncat(nmap) 셋이 시장에 같이 살아 있어요. 사용처 세 가지. (1) **포트 살아 있나 확인**.

```bash
nc -vz example.com 443
nc -vz example.com 80
nc -vz 192.168.0.1 22
```

-v 자세히, -z 데이터 안 보내고 연결만. 출력은 `Connection to example.com 443 port [tcp/https] succeeded!` 또는 실패. ping이 막혀 있어도 nc는 거의 항상 동작해요. (2) **TCP로 손으로 HTTP 보내기**.

```bash
echo -e "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n" | nc example.com 80
```

손으로 HTTP 봉투를 적는 거예요. 응답이 줄줄 옵니다. 1교시에서 봉투 비유가 진짜 봉투가 되는 순간이에요. (3) **간단한 서버 띄우기**.

```bash
nc -l 8080
```

8080 포트에 리스닝. 다른 터미널에서 `nc localhost 8080`로 접속하면 채팅처럼 양방향 텍스트 송수신. 디버깅 서버로 자주 씁니다. 한 가지 — nc는 두 종류가 있어요. **OpenBSD nc**(macOS·일부 Linux)와 **GNU netcat**(다른 Linux). 옵션이 살짝 달라요. macOS의 nc는 `-l 8080`으로 되는데 일부 Linux는 `-l -p 8080`이라 -p가 필요. 둘 다 핵심 -v -z는 같습니다.

## 8. openssl s_client — TLS 손으로 깎기

openssl은 명령어 한 다발이에요(s_client, x509, genrsa, req 등). 4교시에선 TLS 디버깅용 두 가지만 손에. (1) 인증서 정보 한 줄 — 2교시에서 봤던 것.

```bash
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null \
  | openssl x509 -noout -dates -subject -issuer
```

세 줄. -dates 만료일, -subject 인증서 주인, -issuer 발급자. (2) TLS 핸드셰이크 자세히.

```bash
openssl s_client -connect example.com:443 -servername example.com -showcerts 2>&1 | head -50
```

`-showcerts`는 체인의 모든 인증서를 PEM으로 다 뽑아요. 인증서 체인이 깨진 사고에서 쓰는 도구. 보통 출력의 첫 30줄에 (1) 핸드셰이크 진행, (2) 협상된 cipher suite, (3) 인증서 체인 깊이. 이 세 가지가 보입니다. 한 가지 — `-servername`을 빼면 SNI(Server Name Indication) 없이 연결돼요. 같은 IP에 여러 도메인이 호스팅된 환경에서 SNI 빠지면 잘못된 인증서가 떠요. 그래서 항상 `-servername` 넣는 습관. openssl은 한 시간 강의 한 번 더 필요한 도구라 4교시에선 인사 정도. Ch062(인증·보안 챕터)에서 인증서 발급, CSR 작성, 자체 서명 인증서까지 깊게 봅니다.

## 9. ss / netstat — 내 노트북의 열린 포트

이 두 도구는 본인 노트북에 어떤 포트가 열려 있고 어떤 연결이 살아 있는지 보여 줘요. 시점이 달라요. ss는 현대 Linux, netstat은 오래된 도구(macOS는 여전히 netstat, Linux는 deprecated). 한 가지 풀어 두면 ss는 "Socket Statistics"의 줄임으로 2000년대 후반 Linux에 등장한 새 도구고, netstat을 대체할 목적으로 만들어졌어요. 더 빠르고 더 많은 정보를 보여 줍니다. macOS는 BSD 계열이라 ss가 없고 여전히 netstat이 표준이에요.

```bash
# Linux
ss -tunap                # TCP+UDP+숫자+all+process
ss -tnlp                 # TCP만, listen만, process 표시
ss -tn state established # 살아 있는 TCP만

# macOS
netstat -an | head -20
netstat -an | grep LISTEN
netstat -anv | grep ESTABLISHED
```

여섯 줄. 출력 한 줄 풀어 보면 — `tcp 0 0 192.168.0.42:54321 142.250.196.110:443 ESTABLISHED`. (1) 프로토콜 tcp. (2) recv-q 0(수신 큐 비어 있음). (3) send-q 0(송신 큐 비어 있음). (4) 본인 IP:포트 192.168.0.42:54321. (5) 상대 IP:포트 142.250.196.110:443. (6) 상태 ESTABLISHED. 상태에는 LISTEN(서버가 기다림), ESTABLISHED(연결 살아 있음), TIME_WAIT(끊은 후 잔여 정리), CLOSE_WAIT(상대가 끊었는데 본인이 안 끊음 = 버그 신호) 등이 있어요. CLOSE_WAIT가 쌓이면 거의 항상 본인 코드 버그입니다(소켓 close 누락). 한 가지 — `ss -s`는 소켓 통계 한 줄 요약. `netstat -s`는 프로토콜 통계. 둘 다 시스템 전체 네트워크 건강 점검용.

## 10. lsof -i — 어느 프로세스가 그 포트를?

ss/netstat은 "포트가 열려 있다"까진 보여 주는데 "누가 열었는지"는 -p 옵션이 필요해요. lsof는 그 자리를 채우는 도구예요. "list open files"의 줄임이지만 네트워크 소켓도 파일이라(2교시에서 fd가 생각나시나요) 다 보여 줍니다. 한 가지 더 — Ch002에서 fd가 짐 번호표라고 비유했죠. 소켓도 fd 한 개를 차지해요. 그래서 lsof의 -i 옵션은 "fd 중에 인터넷 소켓인 것만 골라 보여 줘"라는 의미예요. ps와 형제이면서도 네트워크 관점에서 한 단계 더 친절한 도구입니다.

```bash
lsof -nP -iTCP -sTCP:LISTEN
lsof -nP -iTCP:443
lsof -nP -i :8080
```

세 줄. -n 이름 풀지 마, -P 포트 번호 그대로, -iTCP TCP만, -sTCP:LISTEN 리스닝만. 두 번째는 443에 연결된 모든 프로세스, 세 번째는 8080(TCP+UDP 다). 출력 — `node 12345 mo 22u IPv4 0x123 0t0 TCP *:8080 (LISTEN)`. (1) 프로세스 이름 node. (2) PID 12345. (3) 사용자 mo. (4) fd 22. (5) IPv4. (6) TCP. (7) *:8080(모든 인터페이스의 8080). (8) LISTEN. 사용처 — "8080 포트가 이미 쓰이고 있다"는 에러가 떴을 때 `lsof -i :8080` 한 줄로 누가 잡고 있는지가 보여요. 그리고 PID로 kill. macOS·Linux 둘 다 동일 명령. 본인의 네 번째 손가락 같은 도구입니다.

## 11. tcpdump — 와이어 위의 봉투 직접 보기

tcpdump는 가장 강력한 도구예요. 조금 경외하고 봅시다 — 상상해보세요. 1교시에서 그렸던 봉투가 진짜 우체통 위를 흐르고 있고, 본인이 그 우체통 옆에 서서 지나가는 봉투의 겹마릞을 그대로 적어 둔다고 생각하세요. 그게 tcpdump의 본질이에요. 와이어 위를 흐르는 진짜 봉투를 그대로 캐프처해서 보여 줍니다. 다만 권한이 필요해요(sudo 또는 setcap). 일반 사용자가 아무나 다른 소수의 봉투를 엿볼 수 있으면 보안 사고이니까요.

```bash
sudo tcpdump -i any -nn -c 10 'port 53'
sudo tcpdump -i en0 -nn 'host 1.1.1.1'
sudo tcpdump -i any -nn -A 'port 80'              # ASCII 풀어서
sudo tcpdump -i any -nn -w /tmp/cap.pcap 'port 443'  # 파일 저장
```

네 줄. -i 인터페이스(any 모든), -nn 이름 풀지 마(IP·포트 그대로), -c 10 10개만, -A ASCII 표시, -w 파일 저장. BPF 필터(`port 53`, `host 1.1.1.1`, `tcp and port 443`)가 핵심이에요. 잘 쓰면 트래픽의 단 1%만 캡처해서 분석 가능. 사용처 — (1) **DNS 조회 실시간 보기**. `port 53` 필터로 본인 노트북이 보내는 DNS 질문이 줄줄. 어떤 도메인을 풀고 있는지 한눈에. (2) **TCP 핸드셰이크 보기**. `tcp and port 443` 필터에 SYN, SYN-ACK, ACK 세 줄이 진짜로 보여요. 2교시 그림이 살아 있는 트래픽이 됩니다. (3) **사고 증거 캡처**. -w로 pcap 파일에 저장 후 wireshark로 열어 분석. 한 가지 — tcpdump를 돌리면 캡처량이 크니 -c로 개수 제한 또는 필터로 줄이세요. 무필터로 사무실 회선에 5분 돌리면 GB 단위 파일이 만들어집니다. 그리고 평문 HTTP는 -A로 본문이 보이지만 HTTPS는 암호화돼서 -A로 안 보여요. TLS 캡처는 키 있어야 풀려요. tcpdump는 H6에서 한 번 더 꺼냅니다.

## 12. tshark / wireshark — tcpdump의 그래픽 친구

wireshark는 tcpdump를 그래픽으로 보여 주는 도구예요. tshark는 wireshark의 명령어 버전(tcpdump와 비슷하지만 풀이가 더 친절). brew install --cask wireshark / apt install wireshark. 조금 더 풀어 두면 wireshark는 1998년 Ethereal이라는 이름으로 시작해서 2006년 wireshark로 개명한 오픈소스의 큰 자산이에요. 지구상 거의 모든 네트워크 엔지니어가 한 번 이상 이 도구를 띄워 봤을 정도. tcpdump가 캡처 + 한 줄 출력에 강하다면 wireshark는 캡처 + 5층 봉투의 트리 시각화에 강해요. 본인 학습 목적에선 wireshark로 캡처 5분 떠 보고 한 패킷을 클릭해서 5층이 트리로 펼쳐지는 걸 한 번 보시는 게 1교시 그림을 가장 빠르게 살아 있는 그림으로 바꾸는 방법이에요.

```bash
sudo tshark -i any -f 'port 53' -c 10
sudo tshark -i any -f 'port 80' -Y 'http' -T fields -e http.host -e http.request.uri
```

두 줄. -f 캡처 필터(BPF), -Y 표시 필터(wireshark 식), -T fields 컬럼 모드. 두 번째는 HTTP 요청만 골라서 host와 URI 두 컬럼만 뽑는 거. 와이어 위를 흐르는 모든 HTTP 요청이 두 컬럼으로 한눈에. wireshark 그래픽 버전을 띄우면 (1) 패킷 한 줄 한 줄, (2) 클릭하면 5층 봉투의 각 층(이더넷·IP·TCP·TLS·HTTP)이 트리로 펼쳐져요. 1교시에서 그렸던 5층이 실제 캡처에서 그대로 나타나요. 2교시 핸드셰이크가 살아 있는 그림으로 보입니다. 학습용으로 한 번 wireshark에 캡처 5분 떠 보시는 걸 추천. 본인이 무심코 켜 둔 앱들이 얼마나 많은 곳에 트래픽을 보내는지 보고 놀랄 거예요.

## 13. iperf3 — 회선 속도 진짜 측정

ping의 RTT는 회선 속도가 아니에요. 회선 속도는 단위 시간당 보낼 수 있는 바이트(Mbps, Gbps). 이걸 측정하는 도구가 iperf3예요. brew/apt로 설치. 한 가지 풀어 두면, ping이 "한 번 다녀오는 데 걸리는 시간"이라면 iperf3은 "1초 동안 얼마나 많이 보낼 수 있느냐"예요. 같은 회선이라도 RTT는 낮은데(반응이 빠른데) 대역폭은 좁을 수 있고, 그 반대도 가능해요. 위성 인터넷이 대표적 — RTT 600ms로 느리지만 대역폭은 100Mbps. 5G는 둘 다 빠릅니다. 본인 회선의 둘을 따로 알면 디버깅이 정확해져요.

```bash
iperf3 -c iperf.he.net -p 5201 -t 5
iperf3 -c speedtest.tele2.net -t 10 -R     # 다운로드 측정
iperf3 -s                                   # 서버 모드(다른 터미널에서)
```

세 줄. -c 클라이언트 모드 + 서버, -p 포트, -t 시간, -R 역방향(다운로드). 출력은 `[ 5]   0.00-5.00   sec  500 MBytes  838 Mbits/sec`. 5초간 500MB 받았고 838Mbps. 가정용 인터넷이 1Gbps라면 800~900Mbps 정도가 정상. 200Mbps 이하면 회선 또는 와이파이 문제. 사용처 — 본인이 ISP에 항의하기 전에 iperf3로 객관적 숫자를 잡아 두세요. "speedtest.net에서 100Mbps인데 광고는 1Gbps"가 ISP 콜센터에서 가장 강한 카드입니다. iperf3 공개 서버 목록은 iperf.fr/iperf-servers.php에 있어요. 회사·서버 환경에선 본인이 iperf3 -s로 서버 띄우고 다른 노트북에서 클라이언트로 붙는 식으로 내부망 속도를 측정합니다.

## 14. arp / route — 같은 동네 친구들과 갈림길

마지막 두 도구. 작지만 동네 안 디버깅에 결정적이에요. 조금 더 풀어 두면, 본인이 같은 LAN(192.168.0/24)의 다른 기기와 대화할 때는 IP만으로는 부족해요. 이더넷 레벨에서는 MAC 주소(48비트 하드웨어 주소)로 이야기해요. 그 둘의 다리가 ARP. "192.168.0.1의 MAC이 뭐야?"라고 브로드캐스트하면 공유기가 "나야, MAC은 aa:bb:cc:dd:ee:ff"라고 답해요. 그 답을 캐시한 게 arp 테이블.

```bash
arp -a
arp -n
```

출력 — `? (192.168.0.1) at aa:bb:cc:dd:ee:ff on en0 ifscope [ethernet]`. 본인 같은 LAN의 IP들 + 그 MAC 주소. 새 기기가 와이파이에 붙은 걸 발견할 때, 또는 같은 IP가 두 MAC에 잡히는 ARP 충돌을 잡을 때 씁니다. 회사 네트워크에서 누가 본인 IP를 훔치면 arp -a가 첫 단서예요. route는 본인 노트북의 라우팅 테이블 — 어느 목적지면 어느 게이트웨이로 — 를 보여 줘요.

```bash
netstat -rn         # macOS·Linux 둘 다
ip route            # Linux 권장
```

첫 줄에 `default 192.168.0.1 UG 0 0 en0` 같은 게 있으면 그게 기본 게이트웨이. 그 외 줄들은 특정 대역에 대한 정적 경로. VPN이 켜지면 0.0.0.0/0이 utun으로 적힌 줄이 추가돼요. 라우팅 테이블이 꼬였다 싶으면 이 한 줄로 진단. arp/route는 Ch003 H6 7다리 진단의 두 번째·세 번째 다리예요.

## 14.5 보너스 — telnet, dog, gping, httpie, jq

위 14 도구 외에 한 번씩 들으셔도 좋은 보조 도구 다섯 개. (1) **telnet** — nc의 옛 친구. nc 없는 환경에서 `telnet host port`로 TCP 연결 확인. 보안상 막혀 있는 회사가 많지만 진단 도구로는 여전히 유용. (2) **dog** — Rust로 새로 쓴 dig. 컬러 출력에 더 친절. brew install dog. dig 사용법과 거의 같아요. (3) **gping** — ping을 그래프로. 실시간 RTT 그래프가 터미널에 그려져서 회선 흔들림이 한눈에 보입니다. (4) **httpie** — curl의 사람 친화적 사촌. `http POST api.example.com name=Cat`처럼 자연어 같은 문법. JSON 자동. brew install httpie. 일상 API 디버깅에 curl보다 빠른 분이 많아요. (5) **jq** — 네트워크 도구는 아니지만 curl과 항상 같이 다녀요. JSON을 읽고 잘라내는 도구. `curl -s api.github.com/users/octocat | jq .name`. API 응답을 사람이 읽을 수 있는 모양으로. 본인 PATH에 이 다섯이 깔려 있으면 일상이 한층 가벼워져요. 다만 표준은 위 14 도구 — 어느 환경에서도 다 있어야 해요. 보너스는 본인 노트북 사치품으로 두세요.

## 15. 도구 14개 한 표 정리 + 14개 묶음 카드

자, 한 표로 모읍시다. 책상 옆에 인쇄해 두세요.

| 도구 | 한 줄 정의 | 가장 자주 쓰는 옵션 | 평생/응급/인사 |
|---|---|---|---|
| ping | ICMP 한 발+RTT | -c 3 | 평생 |
| traceroute | hop별 라우터 추적 | -n | 응급 |
| mtr | 살아 있는 traceroute | -rwc 30 | 응급 |
| dig | DNS 조회 풀 정보 | +short, @서버, +trace | 평생 |
| nslookup | dig의 옛 친구 | (서버 인자) | 응급 |
| host | dig의 짧은 친구 | -t MX | 평생 |
| curl | HTTP 만능 칼 | -I -v -L -H -d --resolve | 평생 |
| wget | 다운로드 전용 톱 | -qO- -r | 평생 |
| nc | 손으로 TCP 연결 | -vz, -l | 평생 |
| openssl s_client | TLS 손깎기 | -connect, -servername, -showcerts | 응급 |
| ss/netstat | 내 노트북 포트 | -tunap, -an | 평생 |
| lsof -i | 어느 프로세스가 그 포트? | -nP -i :포트 | 평생 |
| tcpdump | 와이어 위 봉투 캡처 | -i any -nn -c, BPF 필터 | 응급 |
| tshark/wireshark | tcpdump 그래픽 | -Y, GUI | 인사 |
| iperf3 | 회선 속도 측정 | -c -t -R | 인사 |
| arp | LAN의 IP↔MAC | -a | 응급 |

16개 항목인데 사실상 14개(traceroute/mtr 한 묶음, ss/netstat 한 묶음). 그리고 한 묶음 카드를 만들어 드립니다. **"내 노트북 → 도메인 → IP → 포트 → 응답"** 다섯 단계마다 한 도구씩. (1) 내 노트북 살아 있나 — `ifconfig`/`ip addr`. (2) 도메인 풀리나 — `dig +short`. (3) IP 살아 있나 — `ping -c 3` 또는 `nc -vz`. (4) 포트 열렸나 — `nc -vz IP 포트`. (5) 응답 정상인가 — `curl -I` 또는 `curl -v`. 다섯 도구 — ifconfig, dig, ping, nc, curl. 90%의 사고가 이 다섯으로 풀려요. H6에서 7다리 진단으로 늘어나지만 핵심은 이 다섯입니다. 본인 머리에 박아 두세요.

## 16. 흔한 함정 다섯 개 + FAQ 다섯 개

함정 풀이 전에 한 가지 — 함정의 90%는 "도구마다 보는 시점이 달라서" 생겨요. 같은 도메인이 dig에선 A IP, ping에선 hosts IP, curl에선 또 다른 IP가 나올 수 있어요. 도구가 거짓말하는 게 아니라 각자 다른 길로 답을 찾아서예요. 그 차이를 머리에 두시면 함정 대부분이 피해집니다.

**함정 1: "ping 안 가니까 죽은 서버다."** 아니에요. 회사·일부 클라우드는 ICMP 차단. ping 안 가도 nc -vz 443은 갈 수 있어요. ping은 첫 단서일 뿐, 최종 판정은 TCP 연결로. 본인 노트북에서 AWS EC2에 ping이 안 가도 SSH(22)나 HTTP(80) 연결은 잘 가는 게 흔해요. AWS 기본 보안 그룹이 ICMP를 막는 게 디폴트입니다.

**함정 2: "dig는 hosts 파일을 본다."** 안 봐요. dig는 DNS 직행, hosts 우회. ping과 curl은 hosts 봅니다. 도구마다 hosts 보냐 안 보냐가 달라서 같은 도메인이 도구마다 다른 IP로 풀리는 사고가 가끔. 이걸 모르고 "dig는 1.2.3.4 주는데 curl은 자꾸 다른 IP로 가요"라고 한 시간 헤매는 게 흔해요.

**함정 3: "tcpdump는 모든 트래픽을 본다."** 인터페이스 따라 달라요. -i en0이면 en0만, -i any면 다지만 lo는 일부 OS에서 누락. 본인 ↔ 본인(lo) 트래픽이 안 보이면 -i lo0 별도로.

**함정 4: "lsof -i :8080이 비면 8080 비어 있다."** 권한 문제일 수 있어요. 다른 사용자나 root 프로세스의 소켓은 sudo 없이는 안 보여요. `sudo lsof -nP -i :8080`이 정확. 그리고 Docker 컨테이너 안에서 잡고 있는 포트는 호스트의 lsof로는 못 보고 docker ps와 docker inspect로 확인해야 해요. 이게 컨테이너 시대의 새 함정입니다.

**함정 5: "iperf3 결과가 광고 속도보다 낮다 = ISP 사기."** 와이파이 손실, 노트북 NIC 한계, 측정 서버까지 거리 — 변수가 많아요. 케이블 직결로 한 번, 가까운 서버로 한 번 측정 후 비교. 그리고 iperf3 서버가 본인 측정 시점에 부하를 받고 있을 수도 있어 같은 서버로 다른 시간대에 두세 번 더 측정하시는 게 객관적입니다.

**함정 6: "curl이 잘 가니까 브라우저도 잘 갈 거다."** curl은 헤더와 쿠키와 JS 실행이 거의 없어요. 브라우저는 그 셋이 다 끼어요. 본인 사이트가 curl엔 200 OK인데 브라우저에선 깨지면 거의 항상 JS·CORS·쿠키 문제예요. curl로 1차 점검 + 브라우저 DevTools로 2차 점검이 정답.

**함정 7: "tshark/wireshark가 없으면 디버깅 불가."** 사실은 ping·dig·nc·curl·lsof 다섯으로 90%는 풀려요. wireshark는 그 다섯이 답을 못 줄 때의 마지막 거울. 처음부터 wireshark 띄우려고 하시면 더 느려져요.

**Q1. nc와 curl 중 어느 걸 쓰나요?** 포트 연결만 확인할 때 nc(가벼움), HTTP 응답까지 볼 땐 curl. 둘 다 막히면 telnet도 비상용으로 가능합니다.

**Q2. wireshark에서 HTTPS 본문이 안 보여요.** TLS 암호화. SSLKEYLOGFILE 환경변수와 키 파일을 wireshark에 등록하면 풀려요. Ch062에서 다룹니다.

**Q3. dig +trace가 회사에선 안 돼요.** 회사 방화벽이 외부 DNS(53)를 사내 DNS만 통과시켜요. dig +trace는 루트 직행이라 막힘. 집에서 학습.

**Q4. tcpdump가 너무 빨라서 못 따라 봅니다.** -w로 파일 저장 후 wireshark에서 열어 천천히 보세요. 또는 grep · awk로 후처리.

**Q5. lsof와 ss의 출력이 다른데?** 같은 정보의 다른 모양. lsof는 프로세스 중심, ss는 소켓 중심. 정보는 같습니다. ss -p가 lsof 비슷한 모양. 그리고 한 가지 더 — macOS의 lsof가 SIP 정책으로 시스템 일부 프로세스 정보를 안 보여 주는 경우가 있어요. 그럴 땐 sudo로 한 번 더 시도. Linux는 그런 제한이 거의 없습니다.

**Q6. 도구를 다 외워야 하나요?** 아니에요. ping·dig·nc·curl·lsof 다섯이 90%고, 나머지는 "이런 도구가 있더라"가 머리에 박히면 충분해요. 사고 났을 때 "어 이거 4교시에서 봤다"라고 손이 움직이는 게 4교시의 결과입니다.

**Q7. macOS에 dig가 없어요.** Ventura 이후 dig가 기본 패키지에서 빠졌어요. brew install bind 또는 brew install bind-tools로 추가. 회사 노트북이면 IT팀에 요청하셔도 됩니다.

## 17. 다음 시간 예고 + 한 줄 정리

제가 4교시 끝에 한 가지 더 드릴 게 있어요. 도구는 도구일 뿐, 도구를 쓰는 운영자가 되는 건 다른 일이에요. 도구는 손에 쥐고 "이거 첨 꿀을 경우"가 머리에 자동으로 올라와야 운영자예요. 그 자동화는 한 번 더 치어 볼 때 만들어져요. 그래서 4교시 끝에 본인의 소속감이 "도구를 쓰는 운영자"로 한 번 옮겨가세요. 터미널 열고 면접관이 "DNS 디버그 어떻게 하세요"라고 물으면 dig +short, dig @8.8.8.8, dig +trace 세 줄이 손에 올라와야요. "포트 충돌 난 거 어떻게 해결하세요"에 lsof -i :8080이 손에. 이게 4교시의 진짜 결과입니다.

**한 줄 정리. 네트워크 디버깅의 다섯 도구는 ifconfig·dig·ping·nc·curl이고, 응급 도구는 traceroute·tcpdump·openssl·lsof다.** 다음 H5는 한 페이지 요청의 라이프사이클을 처음부터 끝까지 — 클릭 0.0초부터 응답 0.3초까지 — 한 번 그려 봅니다. 1교시 7단계 미리보기를 30단계로 깊게 푸는 시간이에요. 캐시 단계, DNS 단계, TCP·TLS 단계, HTTP 요청·응답·렌더링까지. 4교시 도구 14개가 그 30단계 어디에 끼어드는지가 같이 잡혀요. 다음 시간 전에 한 가지만 — 본인 노트북에서 `dig +short google.com`과 `nc -vz google.com 443`과 `curl -I https://google.com` 세 줄을 한 번 쳐 보세요. 세 도구 다 답이 1초 안에 와야 H4 졸업입니다. 두 해 코스 우리 위치는 20/960 = 2.08%. 2%를 넘었어요. 다음 시간에 만나요. 수고 많으셨습니다.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - macOS의 nc는 OpenBSD nc. Linux는 GNU netcat 또는 ncat(nmap). 옵션 차이.
> - tcpdump는 권한 필요. setcap cap_net_raw,cap_net_admin=eip로 sudo 없이 가능.
> - wireshark의 dumpcap만 setcap 주는 게 보안적으로 안전.
> - iperf3 -R은 서버→클라이언트(다운로드), 기본은 클라이언트→서버(업로드).
> - tshark의 -Y는 wireshark display filter, -f는 BPF capture filter. 둘 다 다른 문법.
> - lsof는 macOS의 SIP 정책으로 시스템 일부가 안 보일 수 있어요(2024+).

## 추신

1. 도구 14개 외우지 마시고 다섯 도구(ifconfig·dig·ping·nc·curl)만 손에 박으세요.
2. ping이 안 가도 죽은 게 아닐 수 있어요. nc로 TCP 한 발이 진짜 판정.
3. dig는 hosts 안 봅니다. ping은 봅니다. 차이를 머리에 두세요.
4. curl --resolve 한 옵션이 새 서버 검증의 마법입니다.
5. nc -l 8080은 즉석 디버깅 서버. 한 줄로 양방향 채팅 가능.
6. openssl s_client는 항상 -servername과 같이. SNI 빠지면 잘못된 인증서.
7. ss/netstat의 CLOSE_WAIT 쌓이면 본인 코드 close 누락.
8. lsof -i :8080은 "포트 충돌 났다"의 첫 한 줄.
9. tcpdump는 -c와 BPF 필터 없이 돌리면 GB 단위 캡처. 항상 제한.
10. wireshark에서 HTTPS는 안 풀려요. SSLKEYLOGFILE 필요.
11. iperf3 결과는 측정 변수가 많아요. 광고 속도와 직접 비교 금지.
12. arp -a는 본인 LAN의 친구 명단. 회사에서 IP 도둑 잡을 때 첫 단서.
13. mtr 30초가 traceroute 한 번보다 백 배 정보를 줍니다.
14. nslookup·host는 dig 막힌 환경의 우회로.
15. wget은 큰 파일, curl은 일상. 둘 다 알되 일상은 curl.
16. 도구 카탈로그 한 표를 책상 옆에 인쇄해 두는 게 H4 졸업장입니다.
17. 다음 H5는 한 페이지 = 30요청을 30단계로 풉니다. 4교시 도구가 거기서 다시 등장.
18. "도구는 외우는 게 아니라 한 번 쥐어 본 적 있다"가 답입니다.
19. ping·dig·nc·curl·lsof 다섯 도구가 90% 사고를 풀어요. 나머지는 서프트.
20. 도구도 터미널과 마찬가지로 손에 익는 데 시간이 걸려요. 사고 난 다음 날·다다음 날 계속 쓰시면 3개월이면 어느 새 몸에 뱰어요.
21. 사고 주자점을 마뎨다고 생각하시면 도구가 그 주자장 그려주는 도구입니다.
22. tcpdump·tshark는 "다른 도구로 풀리지 않을 때"의 최후의 보돈. 먼저 꿀 도구는 아니에요.
