# Ch003 · H6 — 네트워크 7다리 진단 — "안 돼요" 한 마디를 1분 진단으로

> 고양이 자경단 · Ch 003 · 6교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 7다리 한 표
3. 다리 1 — 인터페이스 (NIC 살아 있나)
4. 다리 2 — 게이트웨이 (공유기까지 닿나)
5. 다리 3 — 라우팅 (인터넷 출구 열렸나)
6. 다리 4 — DNS (도메인이 IP로 풀리나)
7. 다리 5 — IP 도달 (그 IP까지 가나)
8. 다리 6 — 포트 (그 포트가 열려 있나)
9. 다리 7 — 응답 (정상 응답이 오나)
10. 통합 진단 함수 nettest()
11. 운영 사고 시나리오 세 가지
12. 흔한 함정 다섯 가지
13. 흔한 실수 다섯 가지 + 안심 멘트 — 진단 학습 편
14. 마무리 — 다음 H7에서 만나요

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H5를 한 줄로 회수할게요. 본인이 클릭 한 번이 0초에서 0.3초 사이 30단계를 거치는 그 흐름을 봤어요. 평소엔 매끄럽게 흘러가요. 그런데 어느 한 단계라도 막히면 사용자는 똑같은 한 마디만 외쳐요. **"안 돼요."**

이번 H6은 그 한 마디를 위치 좌표가 있는 진단 보고서로 바꾸는 시간이에요. 우리가 만들 무기는 단 하나, **7다리 체크리스트**예요. 다리 1부터 다리 7까지 순서대로 건너가면, 어느 다리가 끊어졌는지 1분 안에 답이 나와요.

오늘의 약속. **본인이 "인터넷 안 돼요" 비명 앞에서 1분 안에 어느 다리가 끊어졌는지 짚어내는 사람이 됩니다**.

자, 가요.

---

## 2. 7다리 한 표

H5의 30단계를 진단의 관점에서 7관문으로 접어요. 30개를 매번 외우려고 하면 사고 한가운데서 머리가 하얘져요. 7개로 접으면 손가락 일곱 개로 셀 수 있고, 셀 수 있는 건 빠뜨리지 않아요.

| 다리 | 이름 | 한 줄 질문 | 한 줄 도구 |
|------|------|-----------|-----------|
| 1 | 인터페이스 | 내 컴퓨터 랜선·와이파이 살아 있나? | `ifconfig` / `ip a` |
| 2 | 게이트웨이 | 우리 집 공유기까지 닿나? | `ping <gateway>` |
| 3 | 라우팅 | 인터넷 출구가 열렸나? | `route -n get default` |
| 4 | DNS | 도메인이 IP로 풀리나? | `dig` / `nslookup` |
| 5 | IP 도달 | 그 IP까지 패킷이 가나? | `ping <ip>` / `traceroute` |
| 6 | 포트 | 그 포트가 열려 있나? | `nc -vz` / `telnet` |
| 7 | 응답 | 정상 응답이 돌아오나? | `curl -I` / `curl -w` |

핵심 원칙 세 가지를 짚고 갈게요.

첫째, **순서대로 건너세요**. 다리 1이 죽었는데 다리 7부터 보면 다리 7의 실패는 거짓 단서예요. 항상 1→2→3→...→7 순서로 의심하세요.

둘째, **한 다리당 1분**. 7다리 × 1분 = 7분 안에 위치를 못 짚으면 도구가 부족한 게 아니라 가설이 잘못된 거예요. 가설을 다시 세우세요.

셋째, **정상 출력을 외워두세요**. 정상이 무엇인지 모르면 비정상도 못 봐요. 각 다리의 "정상 한 줄"을 눈에 익혀 두세요.

여기서 한 가지 더. **다리 7에서 사고가 보인다고 다리 7만 의심하지 마세요**. 사용자에게 보이는 증상은 늘 마지막 다리(응답)에서 터지지만, 진짜 원인은 거의 항상 더 앞쪽 다리에 숨어 있어요. 502를 보고 "백엔드 앱이 죽었나?" 곧장 점프하는 건 베테랑이 가장 자주 빠지는 함정이에요. 베테랑일수록 처음 1분은 무조건 다리 1부터 차례로 두드려요.

---

## 3. 다리 1 — 인터페이스 (NIC 살아 있나)

비유로 가요. 다리 1은 집 현관문이에요.

집을 나가려면 일단 현관문이 열려야 해요. 현관문이 잠겨 있거나 떨어져 있다면 게이트웨이도 라우팅도 DNS도 다 무의미해요. 인터페이스(NIC, Network Interface Card)가 OS에 인식돼 있고 IP가 박혀 있어야 비로소 "네트워크가 시작됐다"고 말할 수 있어요.

> ▶ **같이 쳐보기** — 다리 1: NIC 살아 있고 IP 박혀 있나
>
> ```bash
> # macOS
> ifconfig en0
> 
> # Linux
> ip a show wlan0
> 
> # 한 줄 요약
> ifconfig en0 | awk '/inet /{print "IP:", $2}'
> ```

정상 출력 한 줄.

```
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST>
        inet 192.168.0.42 netmask 0xffffff00
        status: active
```

`UP`, `RUNNING`, `inet 192.168.x.x`, `status: active`. 이 네 가지가 다 보이면 다리 1 통과.

실패 시그니처. `status: inactive` 또는 `inet`이 안 보이거나 IP가 169.254.x.x (DHCP 실패 자동 할당). 처방 — 와이파이/랜선 다시 꽂기, DHCP 갱신 (`sudo ipconfig set en0 BOOTP; sudo ipconfig set en0 DHCP`).

베테랑일수록 "내 노트북 와이파이는 멀쩡할 게 뻔하다"며 다리 1을 생략하다가 30분을 잃어요. 1분만 투자하면 그 30분이 절약돼요.

---

## 4. 다리 2 — 게이트웨이 (공유기까지 닿나)

비유 — 동네 정류장.

집을 나왔으면 동네 정류장까지 걸어가야 해요. 정류장이 우리 집 공유기예요. 보통 192.168.0.1 또는 192.168.1.1.

> ▶ **같이 쳐보기** — 다리 2: 게이트웨이까지 ping
>
> ```bash
> # 게이트웨이 IP 찾기
> route -n get default | grep gateway
> # gateway: 192.168.0.1
> 
> # ping
> ping -c 4 192.168.0.1
> ```

정상 출력.

```
PING 192.168.0.1 (192.168.0.1): 56 data bytes
64 bytes from 192.168.0.1: icmp_seq=0 ttl=64 time=1.234 ms
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=1.456 ms
4 packets transmitted, 4 packets received, 0.0% packet loss
```

0% 패킷 손실에 1ms 안. 다리 2 통과.

실패 시그니처. `100% packet loss` 또는 `Destination Host Unreachable`. 처방 — 공유기 재부팅, 와이파이 다시 연결.

자경단의 노하우 — `ping -c 4`로 4번만. 무한 ping은 의미 없어요.

---

## 5. 다리 3 — 라우팅 (인터넷 출구 열렸나)

비유 — 동네에서 시내 가는 버스.

정류장(공유기)에서 시내(인터넷)로 가는 버스가 다녀야 해요. 라우팅 테이블이 그 노선표.

> ▶ **같이 쳐보기** — 다리 3: 라우팅 테이블 확인
>
> ```bash
> # macOS
> route -n get default
> 
> # Linux
> ip r
> 
> # 외부 ping (8.8.8.8 = Google DNS)
> ping -c 4 8.8.8.8
> ```

정상 출력 — `default: 192.168.0.1`이 라우팅 테이블에 있고, 8.8.8.8 ping이 0% loss.

실패 — `default` 라우트가 없거나, 8.8.8.8이 100% loss. 처방 — DHCP 갱신, ISP 점검.

여기서 짚고 갈 게 있어요. **8.8.8.8은 ping은 되는데 google.com은 안 되면?** 다리 3은 OK, 다리 4 (DNS)가 사고예요. 다음 다리.

---

## 6. 다리 4 — DNS (도메인이 IP로 풀리나)

비유 — 친구 집 주소를 전화번호부에서 찾기.

본인이 google.com이라는 이름을 쳐도, 컴퓨터는 IP가 필요해요. DNS가 그 변환을 해 줘요. 8.8.8.8 같은 DNS 서버에 "google.com 어디예요?" 묻고 IP를 받아 와요.

> ▶ **같이 쳐보기** — 다리 4: DNS 조회
>
> ```bash
> # 빠른 조회
> dig google.com +short
> # 142.250.207.78
> 
> # 자세히
> dig google.com
> 
> # 옛 도구
> nslookup google.com
> ```

정상 — IP 한 개 이상 떠요.

실패 — `;; connection timed out` 또는 `NXDOMAIN`. 처방 — DNS 서버 변경 (8.8.8.8 또는 1.1.1.1).

자경단의 노하우. macOS DNS 캐시 비우기.

```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

이상한 DNS 사고는 80% 캐시. 두 줄로 해결.

---

## 7. 다리 5 — IP 도달 (그 IP까지 가나)

비유 — 친구 집까지 차로.

DNS로 IP를 알았어요. 그 IP까지 패킷이 도달하는지 확인.

> ▶ **같이 쳐보기** — 다리 5: IP 도달
>
> ```bash
> # 직접 ping
> ping -c 4 142.250.207.78
> 
> # 경로 추적
> traceroute 142.250.207.78
> 
> # 더 빠른 도구
> mtr 142.250.207.78    # brew install mtr
> ```

정상 — ping 0% loss, traceroute가 30 hop 안에 도착.

실패 — 중간 hop에서 `* * *` 반복. 처방 — ISP 또는 대상 서버 점검.

traceroute가 진짜 강력해요. 어느 hop에서 막히는지 정확히 보여줘요.

---

## 8. 다리 6 — 포트 (그 포트가 열려 있나)

비유 — 친구 집 도착했는데 어느 방의 문을 두드려야 하나.

서버에 도착했어요. 그런데 서버는 80번 (HTTP), 443번 (HTTPS), 22번 (SSH) 같은 여러 포트를 가지고 있어요. 본인이 원하는 포트가 열려 있는지 확인.

> ▶ **같이 쳐보기** — 다리 6: 포트 열려 있나
>
> ```bash
> # nc (netcat)으로 빠르게
> nc -vz google.com 443
> # Connection to google.com port 443 [tcp/https] succeeded!
> 
> # telnet (옛 도구)
> telnet google.com 443
> 
> # 여러 포트 한 번에
> nmap -p 80,443,22 google.com   # brew install nmap
> ```

정상 — `succeeded!` 메시지.

실패 — `Connection refused` (포트 닫힘) 또는 `Operation timed out` (방화벽). 처방 — 방화벽 점검, 서버 포트 활성 확인.

자경단의 매일 — local 개발 서버가 안 뜰 때 `nc -vz localhost 3000`. 1초 진단.

---

## 9. 다리 7 — 응답 (정상 응답이 오나)

비유 — 친구 집 문 두드리니 친구가 답하나.

포트가 열려 있는데 응답이 안 오면? HTTP 응답 자체가 사고예요.

> ▶ **같이 쳐보기** — 다리 7: HTTP 응답
>
> ```bash
> # 응답 헤더만
> curl -I https://google.com
> # HTTP/2 200
> 
> # 시간 측정
> curl -w "@curl-format.txt" -o /dev/null -s https://google.com
> 
> # 자세히 (verbose)
> curl -v https://google.com
> ```

정상 — `HTTP/2 200` (또는 301, 302 redirect).

실패 — `HTTP/2 502` (Bad Gateway), `503` (Service Unavailable), `504` (Gateway Timeout). 처방 — 백엔드 서버 점검, 재시작.

여기서 베테랑의 함정 한 가지. **502 보면 곧장 백엔드 의심하지 마세요**. 다리 1~6을 다 통과한 다음에 의심해도 늦지 않아요. 1분의 자제가 30분 진단을 살려요.

---

## 10. 통합 진단 함수 nettest()

7다리를 한 번에 도는 본인의 dotfile 함수.

```bash
# ~/.zshrc 또는 ~/.bashrc
nettest() {
  local target="${1:-google.com}"
  echo "🔍 7다리 진단: $target"
  
  echo "[1] 인터페이스"
  ifconfig en0 | grep -E "inet |status:"
  
  echo "[2] 게이트웨이"
  local gw=$(route -n get default | awk '/gateway/{print $2}')
  ping -c 1 -t 1 "$gw" > /dev/null && echo "✅ $gw" || echo "❌ $gw"
  
  echo "[3] 외부 ping"
  ping -c 1 -t 2 8.8.8.8 > /dev/null && echo "✅ 8.8.8.8" || echo "❌"
  
  echo "[4] DNS"
  local ip=$(dig +short "$target" | head -1)
  [[ -n "$ip" ]] && echo "✅ $target → $ip" || echo "❌"
  
  echo "[5] IP 도달"
  ping -c 1 -t 3 "$ip" > /dev/null && echo "✅" || echo "❌"
  
  echo "[6] 포트 443"
  nc -vz -w 3 "$target" 443 2>&1 | grep -q succeeded && echo "✅" || echo "❌"
  
  echo "[7] HTTP 응답"
  curl -sI "https://$target" | head -1
}
```

자경단의 매일 — 사고 시 `nettest google.com` 한 줄. 7초에 7다리 진단.

---

## 11. 운영 사고 시나리오 세 가지

자경단 다섯 명이 매년 만나는 사고 세 가지.

**시나리오 1 — "사이트가 안 떠요"**

진단. nettest로. 다리 1~6 통과, 다리 7에서 502.

처방. 백엔드 로그 확인. `gh run list`로 최근 deploy 확인.

**시나리오 2 — "DNS가 이상해요"**

진단. 다리 1~3 통과, 다리 4에서 NXDOMAIN.

처방. DNS 캐시 비우기. `dscacheutil -flushcache`.

**시나리오 3 — "특정 사용자만 안 돼요"**

진단. 본인 nettest는 OK. 사용자 nettest는 다리 4에서 사고.

처방. 사용자 ISP의 DNS 문제. 1.1.1.1 권장.

---

## 12. 흔한 함정 다섯 가지

**함정 1: 다리 7부터 의심**

처방. 항상 다리 1부터.

**함정 2: ping만 쓰기**

처방. ping은 다리 2, 3, 5만. 다리 4는 dig.

**함정 3: 다리 통과인데 사고**

처방. 응용 layer 사고. 백엔드 로그.

**함정 4: 같은 사고 반복**

처방. nettest 함수에 패턴 추가.

**함정 5: 도구 외워야 함**

처방. dotfile에 함수로.

---

## 13. 흔한 실수 다섯 가지 + 안심 멘트 — 진단 학습 편

§12에서 7다리 진단 함정 5개를 봤어요. 이번엔 진단을 배우는 본인의 학습 자세 함정 다섯을 짚고 가요. 미리 보시면 본인이 빠질 때 빨리 알아챌 수 있어요.

첫 번째 함정, 7다리를 다 외우려고 한다. 본인이 다리 1~7을 머리에 박으려고 끙끙대세요. 안심하세요. **nettest 함수 한 줄로 묶어 손에 익히세요.** 외울 게 아니라 매일 한 번씩 nettest 치는 습관. 한 달이면 다리 7개의 순서가 손가락에 박혀요. 외움 → 검색 → 자동 손가락 — 이 3단계가 학습의 진짜 모양.

두 번째 함정, 진단 결과를 안 기록한다. 본인이 nettest로 사고 풀고 그 자리에서 잊어버려요. 안심하세요. **nettest 출력을 항상 파일로.** `nettest google.com > /tmp/diag-$(date +%F-%H%M).log`. 6개월 쌓이면 본인 환경의 평소 분량이 한눈에. 같은 사고 두 번 만나면 첫 번째 로그가 두 번째 진단을 살려요. 진단도 자산이에요. 기록해야 자산.

세 번째 함정, ping만 쓰고 다른 도구 안 쓴다. 본인이 ping이 가면 모든 게 OK라 단정. 안심하세요, 함정 풀이부터. **ping은 ICMP, HTTP는 TCP. 다른 채널.** ping 통과해도 80/443 포트 막혀 있을 수 있어요. nc·curl을 항상 같이. 7다리 7도구의 짝짓기를 기억하세요. 한 도구로는 한 다리만.

네 번째 함정, 가설 없이 도구 마구 친다. 본인이 사고 났을 때 ping → traceroute → dig → curl → tcpdump 마구 쳐요. 안심하세요. **가설 먼저, 도구 나중.** "다리 4 (DNS) 의심된다" 가설 → dig 한 번. "다리 6 (포트) 의심" → nc 한 번. 가설 없는 도구 시도는 운영 챕터에서 가장 비효율. Sherlock Holmes — "It is a capital mistake to theorize before one has data, but it is also a capital mistake to act before one has a hypothesis." 가설 → 도구 → 데이터.

다섯 번째 함정, 가장 큰 함정. **혼자 새벽에 진단하려고 한다.** 본인이 새벽 3시 알람 받고 30분 동안 혼자 끙끙대세요. 안심하세요. **5분 시도 후 페어 콜.** Ch002 H6에서도 본 약속. 잠 안 깬 머리는 50% 진단력. 두 명 머리가 100%. 같은 7다리를 두 명이 같이 두드리면 5분이면 풀려요. 두 해 후 본인 회사의 on-call 채널 첫 규칙 — "혼자 풀지 마세요." 동료의 5분이 본인의 30분을 살려요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 14. 마무리 — 다음 H7에서 만나요

자, 여섯 번째 시간이 끝났어요. 본인 손에 7다리 진단 도구 한 묶음이 들어왔어요. NIC·게이트웨이·라우팅·DNS·IP 도달·포트·응답. 그리고 nettest 함수 한 줄로 7개를 한 번에 묶었어요. 본인의 진단 키트가 한 명 더 늘어났어요.

다음 H7은 깊이의 시간이에요. TCP 내부 — 3-way handshake와 4-way teardown의 진짜 메커니즘. Congestion control — 네트워크가 막혔을 때 TCP가 어떻게 알아채고 어떻게 양보하는지. TLS handshake — 1.3의 1-RTT가 1.2의 2-RTT를 어떻게 절반으로. QUIC — UDP 위의 TLS+HTTP 통합. 7다리의 다섯 번째 다리(IP 도달) 안에서 일어나는 일을 한 번 깊게 봐요.

오늘 한 줄 정리. **"안 돼요" 한 마디를 7다리 1분 진단으로 바꾸는 도구를 손에 들었다.** 이 한 줄이 두 해 후 본인이 운영자로 자라는 첫 발걸음.

본인 페이스. 6/8 시간. 75%. 마지막 두 시간만 남았어요. 잠깐 박수. 본인 자신에게. 짝짝짝. 5분 쉬고 H7에서 만나요.

> ▶ **같이 쳐보기** — 본인의 첫 nettest 졸업 시연
>
> ```bash
> nettest google.com
> ```

7초 안에 7다리 결과가 화면에. 본인이 오늘 손에 익힌 진단 도구의 진짜 모습. 두 해 후 새벽 3시에 자동으로 손이 가는 명령 첫 줄.

오늘 마지막 한 마디. 본인이 두 해 후 회사에서 첫 신입 진단 사고를 만나면 — 옆 시니어가 "어, 본인이 이거 풀 수 있어?" 묻는 그 순간. 본인 답: "nettest 한 줄. 1분 안에 어느 다리에서 막혔는지 알 수 있어요." 시니어가 본인 얼굴을 다르게 봐요. 그 한순간이 본인 신입 합격의 진짜 신호. 두 해 후 본인을 위해 오늘 한 시간을 들였어요. 진심으로 박수. 본인 자신에게. H7에서 만나요.

---

## 👨‍💻 개발자 노트

> - traceroute vs mtr: mtr이 실시간 + 통계.
> - nc vs telnet vs nmap: nmap이 가장 풍부.
> - DNS 캐시: macOS는 mDNSResponder.
> - curl -w format: 시간 측정 표준.
> - ICMP vs TCP: ping은 ICMP. 일부 방화벽 ICMP 차단.
> - 다음 H7 키워드: TCP 내부 · congestion control · TLS handshake · QUIC.
> - §13 첫째 함정 nettest 함수 패턴 — Ch001 H4 alias 학습의 OSI 모델 적용. 두 해 후 dotfiles의 핵심 함수.
> - §13 둘째 함정 진단 로그 패턴 — Sherlock Holmes 인용, 데이터 없는 가설 vs 가설 없는 행동의 두 함정.
> - §13 셋째 함정 ICMP vs TCP — Ch003 H1·H4·H6 세 번 회수. 세 번째 만남에 손에 박혀야.
> - §13 다섯째 함정 페어 운영 — SRE의 표준 on-call 첫 규칙. 한 명이 30분 끙끙 vs 두 명이 5분.
> - 7다리 모델은 OSI 7층의 진단 버전. 정확한 매핑 — 다리 1=L1/2 (Physical/DataLink), 2-3=L3 (Network), 4=L7 (Application/DNS), 5=L3 (IP routing), 6=L4 (Transport ports), 7=L7 (HTTP). 첫날엔 다리 모델로, 두 해 후엔 OSI로 매핑.
