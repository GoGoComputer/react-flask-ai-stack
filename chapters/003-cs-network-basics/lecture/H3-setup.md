# H3 · 네트워크 기본 — 환경 점검 — 내 노트북은 어디 있나

> 고양이 자경단 · Ch 003 · 3교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 2교시 회수와 3교시 약속
2. 본인 노트북의 IP 알아내기 — 사설 IP와 공인 IP
3. 게이트웨이 — 우리 동네의 우체통
4. DNS 서버 설정 보기 — scutil, /etc/resolv.conf
5. /etc/hosts — DNS보다 먼저 보는 작은 책
6. 인터페이스 다섯 형제 — en0, lo0, utun, awdl, bridge
7. Wi-Fi 정보 — SSID, 신호 강도, 채널
8. 회사 와이파이 vs 집 와이파이 — 무엇이 다른가
9. 회사 프록시 — HTTP_PROXY, NO_PROXY
10. VPN — 한 통화 회선을 다른 곳에서 빌리기
11. 방화벽 첫 만남 — pfctl과 iptables의 자리
12. 본인 환경 카드 만들기 — netinfo 별칭
13. macOS ↔ Linux 변환표(환경 명령)
14. 흔한 함정 다섯 개
15. FAQ 다섯 개
16. 다음 시간 예고 + 한 줄 정리

---

## 🔧 강사용 명령어 한눈에

```bash
# 3교시 시연 — 본인 노트북에서 다 따라치셔도 됩니다
ifconfig | grep -E '^[a-z]|inet '         # macOS: 인터페이스+IP
ip -br addr                                # Linux: 한 줄 요약
route -n get default                       # macOS: 기본 게이트웨이
ip route show default                      # Linux: 기본 게이트웨이
scutil --dns | grep nameserver | head -5   # macOS: DNS 서버 목록
cat /etc/resolv.conf                       # Linux: DNS 서버 목록
cat /etc/hosts                             # 양쪽 공통: 로컬 hosts
networksetup -getairportnetwork en0        # macOS: 현재 Wi-Fi 이름
nmcli -t -f NAME,SSID con show --active    # Linux: 현재 Wi-Fi 이름
curl -s ifconfig.me; echo                  # 본인 공인 IP 한 줄
echo "$HTTP_PROXY $HTTPS_PROXY $NO_PROXY"  # 프록시 환경변수
ping -c 1 $(route -n get default | awk '/gateway/{print $2}')   # 게이트웨이 핑(macOS)
```

---

## 1. 2교시 회수와 3교시 약속

자, 3교시입니다. 시작 전에 한 가지만 — 3교시 60분이 끝나면 본인 노트북 환경에 한 가지가 남아야 해요. .zshrc에 netinfo 함수가 박혀 있고, 새 터미널 열어 한 줄 치면 본인의 IP 카드가 떠야 합니다. 그게 H3의 졸업증입니다. 졸업증이 손에 들어와야 H4·H5·H6의 도구들이 의미 있게 동작해요. 환경을 모르고 도구만 외우면 운영에서 미끄러집니다. 자, 회수부터. 2교시는 단어 사전이 가장 많이 펼쳐진 시간이었어요. 5층 봉투, 메서드 5종, 상태 코드 5묶음, 헤더 7가족, DNS 레코드 7종, TLS 1.3. 머리가 좀 무거우셨을 거예요. 괜찮습니다. 사전은 외우는 게 아니라 "한 번 펼친 적 있다"가 중요해요. 다음에 같은 단어를 만났을 때 "어디서 봤지"가 되시면 충분합니다. 그리고 손에 두 도구가 추가됐죠. dig와 openssl. ping·curl·dig·openssl 네 도구가 4기둥에 짝지어졌어요. 자, 3교시 약속은 세 가지예요. 하나, **본인 노트북이 인터넷 어디에 있는지**를 한 페이지로 그릴 수 있게 만들어 드립니다. 사설 IP, 게이트웨이, DNS 서버, 공인 IP — 이 네 숫자가 본인의 인터넷 주민등록증이에요. 둘, **회사 와이파이와 집 와이파이가 왜 다르게 동작하는지**를 풀어 드립니다. 회사에서는 dig가 막힐 수 있고, 집에서는 안 막히는 이유. 셋, **netinfo라는 본인 환경 카드 함수**를 .zshrc에 박아 드립니다. Ch001 H3에서 myinfo를 박았던 것처럼, Ch003에서는 netinfo. 한 줄만 치면 본인의 IP·게이트웨이·DNS·공인IP·SSID가 한 화면에 떠요. 응급 사고에서 가장 먼저 치는 한 줄이에요. 한 가지 덧붙이면, 3교시는 정답이 사람마다 다른 시간이에요. 회사 노트북, 집 노트북, 카페 노트북. 같은 명령어를 쳐도 출력이 다릅니다. 그게 정상이에요. "왜 내 출력은 강의와 다르지"라고 걱정하지 마시고, "내 환경은 이렇게 생겼구나"라는 사실 확인용으로 받아 주시면 됩니다. 모두가 같은 답이 나오는 건 사전식 강의이고, 3교시는 본인 환경 탐험 시간이에요.

## 2. 본인 노트북의 IP 알아내기 — 사설 IP와 공인 IP

조금 더 풀어 두면 — IP 주소는 인터넷의 우편번호이자 호수예요. 1교시에서 봉투 5층 모델을 이야기했죠. 그 봉투의 두 번째 층(네트워크 층)에 적히는 출발지·목적지가 IP 주소예요. 본인 노트북이 패킷을 띄울 때 출발지 IP에 자기 사설 IP를 적습니다. 그러면 공유기가 NAT 단계에서 그 출발지 IP를 자기 공인 IP로 다시 적어 인터넷에 내보내요. 응답이 돌아올 때는 공유기가 다시 사설 IP로 풀어 본인 노트북에 전달합니다. 이 한 사이클을 머리에 두시고 본격적으로 명령을 쳐 봅시다. 가장 먼저 칠 명령은 한 줄입니다. macOS는 `ifconfig | grep -E '^[a-z]|inet '`, Linux는 `ip -br addr`. 둘 다 같은 정보를 다른 모양으로 보여 줘요. 쳐 보세요. 출력에 줄이 여러 개 떠요. 본인이 봐야 할 줄은 inet으로 시작하는 줄 중에 192.168.x.x 또는 10.x.x.x 또는 172.16~31.x.x로 시작하는 줄. 그게 본인의 **사설 IP**예요. 보통 한두 개 떠요. 와이파이가 en0(macOS) 또는 wlan0(Linux), 이더넷이 en1 또는 eth0. 그리고 lo0의 127.0.0.1은 무시하세요. 그건 자기 자신이에요. 나중에 다룹니다. 자, 사설 IP가 192.168.0.42라고 칩시다. 이게 본인의 인터넷 주민번호 첫 자리예요. 다음으로 — **공인 IP**를 봅시다. 사설 IP는 동네 안에서만 유효한 번호고, 인터넷에서 본인을 식별하는 건 공유기가 갖고 있는 공인 IP예요. 한 줄로 보세요.

```bash
curl -s ifconfig.me; echo
```

또는 `curl -s ipinfo.io/ip` 또는 `curl -s ipv4.icanhazip.com`. 셋 다 같은 결과를 주는 공개 서비스예요. 한 줄 IP가 떠요. 이게 통신사가 본인에게 부여한 공인 IP예요. 같은 와이파이에 연결된 다른 노트북이 같은 명령을 치면 같은 공인 IP가 나옵니다. 왜냐하면 공유기 한 대 뒤의 모든 기기가 같은 공인 IP로 인터넷에 나가니까요. 이게 NAT(Network Address Translation)예요. 한 공인 IP 뒤에 수십~수백 개의 사설 IP가 숨어 있는 구조. 회사 와이파이면 수백~수천 개가 한 공인 IP를 공유할 수도 있어요. 그래서 한 회사 직원 누군가가 이상한 짓을 하면 회사 전체 IP가 차단되는 일이 가끔 생깁니다. **두 IP의 차이를 한 줄로 정리하면** — 사설 IP는 우리 집 호수, 공인 IP는 우리 빌딩 주소. 옆 빌딩에도 같은 호수가 있을 수 있지만(사설 IP 충돌 OK), 빌딩 주소는 지구적으로 유일해요(공인 IP 유일). 본인 사설 IP는 한 200원짜리 정보고, 공인 IP는 보안에 민감한 정보입니다. 공인 IP를 노출하면 누군가 그 IP에 직접 접속을 시도할 수 있어요. 보통 공유기 방화벽이 막아 주지만요.

## 3. 게이트웨이 — 우리 동네의 우체통

본인 노트북이 인터넷에 봉투를 보낼 때, 첫 번째로 던지는 곳이 어디일까요. 직접 지구 반대편 서버에 봉투를 던지는 게 아닙니다. 본인 동네의 우체통 — 게이트웨이 — 에 던져요. 그러면 게이트웨이가 다음 우체국으로, 그 우체국이 또 다음 우체국으로 봉투를 넘깁니다. 본인의 게이트웨이가 누구냐. macOS는 `route -n get default`, Linux는 `ip route show default`. 둘 다 IP 한 줄을 줍니다. 보통 192.168.0.1 또는 192.168.1.1 같은. 그게 본인 공유기의 사설 IP예요. 본인의 노트북은 IP 192.168.0.42고, 공유기의 IP는 192.168.0.1이고, 둘은 같은 /24 네트워크 안에 있어요. 노트북이 보낸 모든 외부 봉투는 일단 192.168.0.1로 갔다가, 공유기가 NAT해서 공인 IP로 바꾼 다음 ISP로 던집니다. 한 가지 손풀기 — 게이트웨이에 ping을 쳐 보세요.

```bash
GATEWAY=$(route -n get default | awk '/gateway/{print $2}')   # macOS
GATEWAY=$(ip route show default | awk '/default/{print $3}')  # Linux
ping -c 3 "$GATEWAY"
```

3밀리초 정도 떠요. 1밀리초 미만일 수도 있고요. 우리 집 안의 거리니까 빛이 케이블 타고 가는 시간 + 공유기 처리 시간이에요. 거의 즉시. 만약 게이트웨이 ping이 안 가면 네트워크가 통째로 끊긴 거예요. 게이트웨이가 죽으면 와이파이 신호가 떠 있어도 인터넷은 다 안 됩니다. 그래서 H6의 7다리 진단에서 게이트웨이 ping이 두 번째 다리예요(첫 번째는 인터페이스 살아 있나). 그리고 한 가지 덧붙이면 — 게이트웨이 IP가 사설 대역에 있다는 건 본인이 NAT 뒤에 있다는 확실한 신호예요. 공인 IP가 게이트웨이로 적혀 있으면 본인은 직접 인터넷에 노출된 겁니다. 보통 클라우드 서버(EC2)가 그렇고, 가정 노트북은 거의 없어요. 게이트웨이 IP만 봐도 본인이 어떤 네트워크 토폴로지에 있는지가 한 줄로 보입니다.

## 4. DNS 서버 설정 보기 — scutil, /etc/resolv.conf

다음으로 DNS. 2교시에서 DNS resolver chain을 5단계로 봤죠. 그중 두 번째 단계 — 로컬 recursive resolver — 가 본인 노트북에 어떤 IP로 적혀 있는지 봅시다. macOS는 `scutil --dns | grep nameserver | head -5`, Linux는 `cat /etc/resolv.conf`. 둘 다 nameserver IP를 줍니다. 보통 두 줄 떠요. 첫 번째가 1차, 두 번째가 1차 죽으면 쓰는 2차예요. 출력 예시는 (1) 통신사 DNS — 168.126.63.1(KT), 210.220.163.82(SK), 164.124.101.2(LG U+) 등. (2) 게이트웨이 IP — 공유기가 자체 DNS 캐시 가진 경우. 192.168.0.1로 적혀 있으면 공유기 캐시. (3) 공개 DNS — 1.1.1.1(Cloudflare), 8.8.8.8(Google), 9.9.9.9(Quad9). 본인이 명시적으로 설정한 경우. 회사 와이파이면 사내 DNS — 10.x.x.x 같은 사설 IP — 가 강제로 적혀 있을 가능성이 큽니다. 사내 도메인(intranet.company.com)을 풀어야 하니까요. 한 가지 — DNS 서버를 바꾸면 어떻게 되나. 통신사 DNS는 가끔 광고 페이지로 리다이렉트하거나 일부 사이트를 차단해요. 1.1.1.1로 바꾸면 그게 풀려요. 다만 회사에선 사내 DNS만 허용하니 함부로 바꾸면 사내 사이트가 안 풀립니다. macOS에서 바꾸려면 시스템 환경설정 → 네트워크 → 고급 → DNS, 또는 `networksetup -setdnsservers Wi-Fi 1.1.1.1 8.8.8.8`. Linux는 보통 NetworkManager 통해서, 또는 /etc/resolv.conf 직접 편집(다만 자동 갱신될 수 있음). 학습용으로 한 번 시도해 보시는 건 추천입니다. 실험은 집에서, 회사에서는 IT팀과 합의 후에. **그리고 한 가지 — DNS 캐시 비우는 명령은 OS마다 달라요.** macOS는 `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`, Linux의 systemd-resolved는 `sudo systemd-resolve --flush-caches`. 도메인 변경 후 안 풀릴 때 이 한 줄이 답입니다.

## 5. /etc/hosts — DNS보다 먼저 보는 작은 책

DNS 조회의 가장 첫 단계가 어디라고 했죠. 본인 노트북의 stub resolver. 그 stub resolver가 DNS 서버를 부르기 전에 먼저 보는 파일이 있어요. /etc/hosts. macOS와 Linux 둘 다 같은 파일이에요. `cat /etc/hosts` 쳐 보세요. 기본은 이 정도입니다.

```
127.0.0.1       localhost
::1             localhost
255.255.255.255 broadcasthost
```

세 줄이에요. 127.0.0.1이 localhost로 풀리는 게 이 파일 덕분이에요. 그리고 이 파일에 한 줄 추가하면 — 그 도메인이 DNS를 안 거치고 그 IP로 곧장 풀려요. 예를 들어 `1.2.3.4 cat-vigilante.com`을 추가하면 `ping cat-vigilante.com`이 1.2.3.4로 갑니다. 진짜 cat-vigilante.com은 어딘가 다른 IP인데, 본인 노트북에서만 1.2.3.4로 보여요. 이게 개발자에겐 큰 무기입니다. (1) **로컬 개발용**. 개발 중인 사이트를 cat-vigilante.local로 부르고 싶으면 `127.0.0.1 cat-vigilante.local`을 추가하면 됩니다. (2) **DNS 변경 미리 테스트**. 도메인을 새 서버로 옮기기 전에, 본인만 새 IP로 풀리게 해서 테스트. (3) **광고/추적 차단**. `0.0.0.0 ads.example.com`을 100줄 추가하면 그 도메인이 다 차단돼요. 다만 위험도 있어요. (1) 악성 소프트웨어가 이 파일을 건드리면 본인이 진짜 사이트 대신 가짜 사이트로 갈 수 있어요. (2) 회사에서 임시 추가한 줄을 까먹고 두면 동료에게 "왜 내 컴퓨터만 이상하지"가 됩니다. 그래서 hosts 파일 편집은 항상 주석 한 줄을 같이 적어 두세요. `# 2026-04-27 임시, 5/15 제거 예정` 같은. 작은 의식이지만 큰 사고를 막습니다. /etc/hosts는 root 권한으로만 편집 가능해요. `sudo vim /etc/hosts` 또는 `sudo nano /etc/hosts`. macOS는 한 가지 추가로 — /etc/hosts 변경 후 `sudo killall -HUP mDNSResponder`로 캐시를 비워야 즉시 반영돼요.

## 6. 인터페이스 다섯 형제 — en0, lo0, utun, awdl, bridge

`ifconfig` 또는 `ip addr`을 치면 인터페이스가 여러 개 떠요. 다섯 형제를 알아 두세요. (1) **en0/en1/eth0/wlan0** — 진짜 네트워크 인터페이스. 본인 노트북의 와이파이 또는 이더넷 카드. 여기에 사설 IP가 박혀 있어요. (2) **lo0/lo** — loopback. 자기 자신을 가리키는 가짜 인터페이스. 항상 127.0.0.1이에요. localhost가 여기로 풀려요. 외부와 통신 안 함. 로컬 서버 테스트할 때 가장 많이 씁니다. (3) **utun0/utun1/...** — VPN 또는 IPsec 터널. macOS에서 VPN 켜면 utun이 새로 생기고 거기에 VPN IP가 박혀요. Linux는 보통 tun0 또는 wg0(WireGuard). (4) **awdl0** — Apple Wireless Direct Link. macOS 전용. AirDrop, AirPlay 등이 쓰는 P2P 무선. 일반 인터넷과 별개. (5) **bridge0/bridge100** — Docker, Parallels, VMware 같은 가상화가 만드는 가상 다리. Docker 켜시면 bridge나 docker0가 보일 거예요. 컨테이너 내부 네트워크의 게이트웨이예요(Ch047). 본인 노트북에 인터페이스가 8~12개 떠 있는 게 정상이에요. 그중 두 개 — en0와 lo0 — 가 일상 99%고, 나머지는 특수 용도입니다. 한 가지 트릭 — 인터페이스를 끄면 그쪽 통신이 차단돼요. macOS는 `sudo ifconfig en0 down`. 와이파이가 통째로 끊깁니다. 다시 켜려면 `sudo ifconfig en0 up`. Linux는 `sudo ip link set wlan0 down/up`. 디버깅 중 "이 인터페이스 통해 가는 트래픽 잠깐 차단" 같은 일에 씁니다. 일상에선 잘 안 써요.

## 7. Wi-Fi 정보 — SSID, 신호 강도, 채널

Wi-Fi 자체에 대해 한 시간을 쓰진 않을 거예요. 다만 진단할 때 알아 두면 좋은 정보 세 가지가 있어요. (1) **SSID** — 와이파이 이름. macOS는 `networksetup -getairportnetwork en0`, Linux는 `nmcli -t -f NAME,SSID con show --active`. 본인이 지금 어느 와이파이에 붙어 있는지가 한 줄로 보여요. (2) **신호 강도(RSSI)** — 보통 dBm으로 표시되고 0에 가까울수록 강해요. -50dBm은 강한 신호, -70dBm은 보통, -85dBm 이하면 끊김 직전. macOS는 시스템 정보 → Wi-Fi에서 보거나 `system_profiler SPAirPortDataType | grep -A 2 "Current Network"`. Linux는 `iw dev wlan0 link` 또는 `nmcli -f IN-USE,SSID,SIGNAL dev wifi`. 와이파이가 갑자기 느려지면 신호 강도부터 봐야 해요. 사람이 옆방으로 갔는지, 라우터를 가구가 가렸는지. (3) **채널** — Wi-Fi는 채널이 1~13(2.4GHz), 36~165(5GHz)가 있어요. 같은 채널에 와이파이가 너무 많으면 충돌해서 느려져요. 카페 와이파이가 느린 흔한 이유예요. 옆 가게 와이파이가 같은 채널을 쓰고 있을 가능성이 큽니다. 본인 공유기를 5GHz로 바꾸거나, 채널을 자동에서 수동(11번처럼 분리된 채널)으로 바꾸면 개선돼요. 한 가지 덧붙이면 — Wi-Fi 6(802.11ax)와 Wi-Fi 6E(6GHz)가 2024~2026년에 흔해졌어요. 지원하는 노트북이면 6GHz 대역이 거의 비어 있어서 빠릅니다. 본인 노트북이 어느 표준을 지원하는지는 `system_profiler SPAirPortDataType | grep "PHY Mode"` 또는 `iw phy phy0 info | head -30`. 본인이 802.11ac까지만 되는 노트북이면 Wi-Fi 6 공유기를 사도 ac까지만 써요. 노트북과 공유기 둘 다 같은 표준을 지원해야 그 속도가 나옵니다. 일상 인터넷이 느린 흔한 이유 중 하나예요.

## 8. 회사 와이파이 vs 집 와이파이 — 무엇이 다른가

자, 3교시의 핵심 비교입니다. 같은 노트북으로 회사 와이파이에 연결할 때와 집 와이파이에 연결할 때 무엇이 달라지냐. 다섯 가지가 달라져요. (1) **사설 IP 대역** — 집은 보통 192.168.0/24 또는 192.168.1/24, 회사는 10.x.x.x/16 같은 큰 대역. 회사가 직원 1000명이면 192.168 같은 작은 대역으론 안 돼서 10.x.x.x 큰 대역을 씁니다. (2) **DNS 서버** — 집은 통신사 DNS, 회사는 사내 DNS. 사내 도메인(jira.company.com, gitlab.company.com)을 풀려면 사내 DNS만이 답을 가지고 있거든요. 그래서 회사 노트북에서 `dig @1.1.1.1 jira.company.com`을 치면 답이 안 나와요. 사내 DNS가 답을 독점합니다. (3) **방화벽** — 집은 보통 외부 → 내부만 막고 내부 → 외부는 다 허용. 회사는 양방향 다 막아요. 특정 포트(SMTP 25, FTP 21, IRC 6667)는 차단되고, 일부 도메인(소셜 미디어, 게임)도 차단되며, ICMP(ping)가 막힌 회사도 많습니다. (4) **프록시** — 회사는 모든 외부 HTTP/HTTPS 트래픽을 사내 프록시(squid, blue coat 등)를 거쳐 보내요. 그래야 검사가 가능하니까요. 집은 프록시 없음. (5) **TLS 인터셉트** — 일부 회사는 사내 CA 인증서를 본인 노트북에 깔고, 모든 HTTPS 트래픽을 한 번 풀어서 검사한 후 다시 암호화해요. 보안 관점에선 위험해 보이지만 사내 정책상 합법이에요. 본인 브라우저의 인증서 발급자에 회사 이름이 적혀 있으면 인터셉트되는 환경입니다. 한 가지 도구 — `echo | openssl s_client -connect google.com:443 2>/dev/null | openssl x509 -noout -issuer`로 google.com 인증서 발급자를 확인해 보세요. 집에서는 GTS CA 1C3 같은 게 뜨고, TLS 인터셉트 회사에선 회사 사내 CA 이름이 떠요. 이 차이를 모른 채 회사 코드에 인증서 검증을 강하게 박으면 회사 안에서 동작 안 하는 사고가 납니다. 흔한 운영 사고예요.

## 9. 회사 프록시 — HTTP_PROXY, NO_PROXY

회사에서 일하시면 한 번쯤 만나는 단어가 HTTP_PROXY예요. 환경변수로 설정하면 curl, wget, git, npm, pip 등 거의 모든 도구가 그 프록시를 거칩니다.

```bash
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1,*.company.com,10.0.0.0/8
```

세 줄이에요. NO_PROXY는 "이 도메인/IP는 프록시 안 거치고 직접 연결"이라는 예외 목록. 사내 도메인은 프록시 안 거쳐야 사내 DNS로 풀리니까 NO_PROXY에 넣어 둡니다. 한 가지 함정 — HTTP_PROXY와 http_proxy(소문자)를 둘 다 설정해야 도구마다 다 인식하는 경우가 있어요. 도구마다 어느 변수를 보는지가 달라요. 안전하게는 두 가지 형태 다 설정. 그리고 .zshrc나 .bashrc에 박아 두면 새 셸 열 때마다 자동 적용. 회사용 .zshrc와 집용 .zshrc를 다르게 두는 분도 많아요. 한 가지 트릭 — 환경에 따라 동적으로 프록시를 켜고 끄는 함수를 만드시면 편해요.

```bash
proxy_on() {
  export HTTP_PROXY=http://proxy.company.com:8080
  export HTTPS_PROXY=$HTTP_PROXY
  export NO_PROXY=localhost,127.0.0.1,*.company.com
  echo "proxy ON: $HTTP_PROXY"
}
proxy_off() {
  unset HTTP_PROXY HTTPS_PROXY NO_PROXY
  echo "proxy OFF"
}
```

회사 와이파이에 붙으면 proxy_on, 집 와이파이로 가면 proxy_off. 두 글자 별칭이에요. 운영의 작은 자산입니다.

## 10. VPN — 한 통화 회선을 다른 곳에서 빌리기

VPN(Virtual Private Network)은 한 줄로 요약하면 "다른 네트워크의 일원처럼 가장하기"예요. 본인 노트북에서 VPN 클라이언트(WireGuard, OpenVPN, Tailscale 등)를 켜면 새 인터페이스(utun이나 tun0이나 wg0)가 생기고 거기에 VPN 네트워크의 사설 IP가 박힙니다. 그 다음부터 본인의 모든 트래픽 — 또는 일부 — 이 그 VPN 인터페이스를 거쳐 가요. 사용처는 (1) **재택근무용 사내망 접근** — 회사 사내 도메인이 외부에서 안 풀리니, VPN으로 사내 네트워크에 들어가서 풀어요. (2) **지역 우회** — 한국에서만 되는 서비스를 외국에서 쓰거나 반대. (3) **공용 와이파이 보안** — 카페 와이파이를 쓸 때 ISP가 누가 어디 가는지 못 보게. 본인 노트북에 VPN이 켜져 있는지 보려면 `ifconfig | grep utun` 또는 `ip addr | grep tun`. 인터페이스가 보이면 VPN. 그리고 라우팅 테이블에 0.0.0.0/0이 VPN 인터페이스로 적혀 있으면 모든 트래픽이 VPN을 거치는 "full tunnel" 모드, 일부만 적혀 있으면 "split tunnel" 모드예요. `route -n get default` 한 번 더 쳐 보시면 게이트웨이가 VPN 켜기 전과 다를 거예요. 이게 VPN의 실체입니다. 한 가지 — VPN을 쓰면 인터넷이 보통 느려져요. 한 단계 우회하니까요. 그리고 VPN 회사가 본인 트래픽을 다 볼 수 있어요. 무료 VPN은 거의 다 사용자 데이터를 팔거나 광고를 끼워넣는 비즈니스 모델입니다. 보안 강화 목적이면 유료 또는 자체 호스팅(WireGuard + 본인 EC2)이 답입니다. Ch108 EC2에서 본인 VPN 띄우는 법을 배웁니다.

## 11. 방화벽 첫 만남 — pfctl과 iptables의 자리

방화벽은 H6에서 깊게 다루는데, 3교시에선 첫 만남으로 위치만 알아 두세요. 방화벽은 "이 패킷은 통과, 이 패킷은 차단"이라는 규칙을 OS 커널 안에 박아 두는 도구예요. macOS는 **pf**(packet filter), 설정은 `/etc/pf.conf`, 명령은 `sudo pfctl -s rules`. Linux는 **iptables** 또는 더 새로운 **nftables**, 설정은 명령어로, 명령은 `sudo iptables -L -n` 또는 `sudo nft list ruleset`. 본인 노트북에 방화벽 규칙이 박혀 있는지 보려면 위 명령들을 한 번씩만 쳐 보세요. 보통 기본 macOS는 거의 비어 있고(시스템 환경설정에서 켜야 작동), Linux 데스크톱도 비어 있는 경우가 많습니다. ufw(Ubuntu)나 firewalld(Fedora) 같은 상위 도구가 깔려 있으면 그게 iptables/nftables를 대신 관리해요. `sudo ufw status` 또는 `sudo firewall-cmd --list-all`. 한 가지 — 방화벽 규칙을 잘못 짜면 본인 자신이 ssh를 못 들어가는 사태가 옵니다. 클라우드 서버에서 흔한 사고예요. 그래서 변경 후 일정 시간 뒤 자동 롤백하는 트릭이 있습니다. `sudo iptables-restore < /tmp/old.rules` 같은 백업을 cron에 5분 후 등록해 두는 식. Ch003 H6에서 다룹니다. 지금은 "방화벽이라는 도구가 OS 안에 있다"는 위치만 머리에 두세요.

## 12. 본인 환경 카드 만들기 — netinfo 별칭

자, 3교시의 진짜 결과물입니다. 본인 .zshrc에 박을 함수 한 개. Ch001에서는 myinfo, Ch003에서는 netinfo예요.

```bash
netinfo() {
  echo "== Network Info =="
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "Hostname     : $(hostname)"
    echo "Wi-Fi SSID   : $(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}')"
    echo "Private IP   : $(ipconfig getifaddr en0 2>/dev/null)"
    echo "Gateway      : $(route -n get default 2>/dev/null | awk '/gateway/{print $2}')"
    echo "DNS Servers  : $(scutil --dns | awk '/nameserver\[/{print $3}' | sort -u | tr '\n' ' ')"
  else
    echo "Hostname     : $(hostname)"
    echo "Wi-Fi SSID   : $(nmcli -t -f NAME,TYPE con show --active 2>/dev/null | awk -F: '$2=="wifi"{print $1}')"
    echo "Private IP   : $(hostname -I | awk '{print $1}')"
    echo "Gateway      : $(ip route show default 2>/dev/null | awk '/default/{print $3}')"
    echo "DNS Servers  : $(awk '/^nameserver/{print $2}' /etc/resolv.conf 2>/dev/null | tr '\n' ' ')"
  fi
  echo "Public IP    : $(curl -s --max-time 3 ifconfig.me 2>/dev/null)"
  echo "Proxy        : ${HTTP_PROXY:-(none)}"
  echo "VPN iface    : $(ifconfig 2>/dev/null | grep -E '^utun|^tun|^wg' | awk -F: '{print $1}' | tr '\n' ' ' || true)"
}
```

22줄 정도. 본인 .zshrc에 추가하시고 `source ~/.zshrc`. 그 다음 `netinfo` 한 줄을 치면 6~7줄짜리 환경 카드가 떠요. Hostname, Wi-Fi SSID, Private IP, Gateway, DNS Servers, Public IP, Proxy, VPN 인터페이스. 응급 사고나 환경 점검 때 가장 먼저 칠 한 줄이 됩니다. 한 가지 권유 — 매일 아침 한 번 netinfo를 치는 의식을 만드세요. .zshrc 마지막에 `[ "$INTERACTIVE_LOGIN" = "1" ] && netinfo` 같은 조건을 박거나, 아니면 새 터미널 열 때마다 손으로 한 번. 일주일이면 본인이 어디 있는지가 머리에 박힙니다. 회사 IP 대역, 집 IP 대역, 카페 IP 대역이 손에 들어와요. 그러면 운영 사고에서 "지금 회사 망에서 보고 있는지 집에서 보고 있는지"가 한 줄로 풀려요. 운영의 작은 의식이지만 큰 자산입니다.

## 13. macOS ↔ Linux 변환표(환경 명령)

3교시 전체를 한 표로 정리합니다. 본인이 양 OS를 오갈 일이 있으시면 한 페이지 인쇄해 두세요.

| 일 | macOS | Linux |
|---|---|---|
| 전체 인터페이스 | ifconfig | ip addr / ifconfig |
| 특정 인터페이스 IP | ipconfig getifaddr en0 | ip -br addr show wlan0 |
| 한 줄 요약 | ifconfig en0 \| grep inet | ip -br addr |
| 기본 게이트웨이 | route -n get default | ip route show default |
| 라우팅 테이블 전체 | netstat -rn | ip route |
| DNS 서버 | scutil --dns | cat /etc/resolv.conf |
| DNS 캐시 비우기 | sudo dscacheutil -flushcache | sudo systemd-resolve --flush-caches |
| /etc/hosts | /etc/hosts | /etc/hosts |
| Wi-Fi SSID | networksetup -getairportnetwork en0 | nmcli -t -f NAME,SSID con show --active |
| Wi-Fi 신호 | system_profiler SPAirPortDataType | iw dev wlan0 link / nmcli -f IN-USE,SSID,SIGNAL dev wifi |
| 인터페이스 끄기 | sudo ifconfig en0 down | sudo ip link set wlan0 down |
| 방화벽 규칙 | sudo pfctl -s rules | sudo iptables -L -n / sudo nft list ruleset |
| 공인 IP | curl -s ifconfig.me | curl -s ifconfig.me |
| 프록시 환경변수 | $HTTP_PROXY | $HTTP_PROXY |

14행이지만 일상에선 윗줄 5개가 90%예요. ifconfig/ip addr, route get default/ip route, scutil/resolv.conf, /etc/hosts, networksetup/nmcli. 이 다섯이면 환경 점검의 80%가 끝나요.

## 14. 흔한 함정 다섯 개

**함정 1: "와이파이 잘 떠 있으니 인터넷 된다."** 아니에요. 와이파이는 본인 노트북과 공유기 사이의 연결일 뿐. 공유기와 ISP 사이가 끊기면 와이파이는 떠 있어도 인터넷 안 돼요. ping 게이트웨이 vs ping 1.1.1.1을 둘 다 쳐서 어디가 끊겼는지 가르세요.

**함정 2: "내 IP가 192.168이라서 인터넷에 노출됐다."** 거꾸로예요. 192.168/10/172.16~31은 사설이라 인터넷에 노출 안 됩니다. 노출된 건 공유기의 공인 IP. 본인 노트북은 NAT 뒤에 있어요.

**함정 3: "DNS만 1.1.1.1로 바꾸면 어디든 다 풀린다."** 회사에선 안 돼요. 사내 도메인은 사내 DNS만 답을 가지고 있어요. 회사 노트북은 사내 DNS를 1차로 두는 게 정답입니다. 그리고 가정에서도 통신사 DNS가 IPTV·VoIP 같은 부가 서비스의 일부 트래픽을 다른 IP로 우회시키는 경우가 있어, 1.1.1.1로 바꾼 뒤 IPTV가 끊기는 사례가 가끔 있어요. 이런 분리는 일반 인터넷에는 영향 없으니 학습 목적으론 신경 쓸 게 없지만 한 번쯤 들어두시면 좋습니다.

**함정 4: "VPN 켜면 자동으로 안전하다."** VPN 회사가 본인 트래픽을 다 볼 수 있어요. 무료 VPN은 그걸 비즈니스 모델로 합니다. VPN은 ISP에서 VPN 회사로 신뢰의 대상을 옮길 뿐이에요. 더해 — VPN이 켜진 상태에서도 DNS 누수(WebRTC, 쿼드 설정 미흡수)로 실제 공인 IP가 새나갈 수 있어요. 주기적으로 ifconfig.me로 IP가 VPN IP인지 확인하는 가치가 있습니다.

**함정 5: "/etc/hosts 한 줄 추가했는데 바로 반영 안 됨."** macOS는 mDNSResponder가 캐시해서, `sudo killall -HUP mDNSResponder` 해야 즉시 반영. 또는 5~10분 기다리세요. 이거 모르고 1시간 헤매는 분이 많아요.

**함정 6: "회사에서 VPN 켜고 회사 도메인이 안 풀린다."** VPN이 다른 네트워크의 일원이 되게 해주는 도구라, 회사 다음에 집 VPN을 켜면 DNS가 집 VPN의 DNS로 갈아서 회사 도메인이 안 풀려요. VPN 하나씩만.

## 15. FAQ 다섯 개

**Q1. 사설 IP가 자꾸 바뀌어요.** DHCP가 임대 만료될 때마다 새 IP를 줄 수 있어요. 보통 24시간 임대인데 같은 IP를 다시 받는 경우가 대부분. 정 바뀌는 게 싫으면 공유기 설정에서 MAC 주소 기반 정적 IP 할당. Ch108 EC2에선 Elastic IP로 푸는 단어예요. 한 가지 더 — 본인 노트북이 슬립에 들어갔다 나오면 IP가 바뀌는 경우도 흔합니다. 그래서 공유기에 노트북을 항상 같은 IP로 잡아 두는 "DHCP reservation"이 작은 사치예요. 본인 SSH 서버나 미디어 서버를 집에 띄우실 때 거의 필수입니다.

**Q2. /etc/hosts와 DNS 중 어느 게 우선인가요?** /etc/hosts가 우선이에요. nsswitch.conf의 hosts 줄에 `files dns`라고 적혀 있어서 files(=hosts)를 먼저 봐요. files를 dns 뒤로 옮기는 회사도 있긴 하지만 거의 없어요. 한 가지 — macOS는 nsswitch.conf 대신 /etc/host.conf와 mDNS resolver chain이 결정해요. 결과는 같습니다(hosts 우선). 그리고 mDNS의 .local 도메인은 별도 경로 — Bonjour — 가 처리하니, .local로 끝나는 hosts 항목은 동작이 어색할 수 있어요. 학습용 로컬 도메인은 .test나 .localhost를 쓰는 게 안전합니다.

**Q3. 회사 와이파이에서 git push가 안 돼요.** 회사 프록시 설정이 안 됐거나, git이 사용하는 22번 포트(SSH)가 차단된 경우. 첫 번째는 `git config --global http.proxy http://proxy.company.com:8080`. 두 번째는 SSH 대신 HTTPS 원격을 쓰거나, ssh -p 443 접근. Ch004에서 다룹니다.

**Q4. 노트북을 회사에서 집으로 옮겼는데 인터넷 안 돼요.** 회사 DNS·프록시가 환경변수에 박혀 있고, 그게 집에선 못 닿아요. proxy_off 별칭 한 줄과 DNS 캐시 비우기 한 줄로 풀립니다. 종종 맥에서는 Wi-Fi 자동 연결이 회사와 비슷한 SSID를 잡아서 떨골이 안 되거나, hosts 파일에 임시로 박아둔 회사 도메인 항목이 집 IP와 충돌하는 경우도 있어요. 첫 수단은 언제나 netinfo와 ping 1.1.1.1.

**Q5. 호스트네임을 바꾸려면?** macOS는 `sudo scutil --set HostName 새이름`(또한 ComputerName, LocalHostName도 같이). Linux는 `sudo hostnamectl set-hostname 새이름`. 단 회사 자산 노트북은 사내 정책으로 막혀 있을 수 있으니 IT팀과 합의.

**Q6. ipconfig와 ifconfig와 ip addr 세 개의 차이?** ipconfig는 Windows. ifconfig는 macOS·BSD·올드 Linux. ip addr는 현대 Linux. macOS에도 ipconfig가 있지만 Windows의 ipconfig와 완전히 다른 도구예요. 이름만 같아요. macOS의 ipconfig는 `ipconfig getifaddr en0` 같은 한줄용 조회 도구입니다.

**Q7. /etc/hosts에 국가 도메인 차단 목록을 넣어도 되나요?** 특정 광고·추적 도메인을 0.0.0.0으로 보내는 습관은 널리 쓰입니다(StevenBlack/hosts 레포). 다만 /etc/hosts가 너무 커지면(수만 줄) 파싱이 느려져 그냥 DNS 레벨 차단(Pi-hole 같은 도구)이 더 깔끔해요.

## 15.5 회차 지도 — 환경 점검이 다시 찾아올 시간

환경 점검은 H3 한 번으로 끝나지 않아요. 두 해 코스에서 본인이 똑같은 명령들을 다시 손에 쥐는 순간이 있어요. 일곱 군데 메모 — (1) **Ch003 H6**(이번 챕터 6교시) 7다리 진단에서 netinfo가 첫 줄로 등장합니다. 환경부터 봐야 무엇이 망가졌는지 추정 가능. (2) **Ch004**(Git&GitHub) 시작 전 git config의 http.proxy를 회사 환경에 맞춰 박는 절차. 3교시 proxy_on이 거기서 빛납니다. (3) **Ch020**(Docker 첫만남)에서 컨테이너에 본인의 사설 IP가 안 보이고 가상 다리(bridge0)만 보이는 이유 — 3교시의 인터페이스 다섯 형제가 답입니다. (4) **Ch047**(Kubernetes 네트워크) — 클러스터 내부 IP, 서비스 IP, 노드 IP 셋이 한 노트북 안에 공존해요. 같은 도구로 풉니다. (5) **Ch074**(GCP/AWS VPC 첫만남) — 클라우드의 사설 대역(10.0.0.0/16)이 본인 회사 네트워크의 그 대역과 똑같이 생겼어요. 같은 단어. (6) **Ch091**(SRE 사고 대응)에서 응급 사고의 첫 한 줄이 netinfo. (7) **Ch113**(개인 인프라 정리) — 본인 집 네트워크에 진짜 서비스 한 개 띄울 때 다시 만납니다. 이 일곱 군데를 일곱 개의 마일스톤처럼 두고 가시면, 3교시의 손풀기들이 어디서 익어가는지 그림이 잡힙니다.

## 16. 다음 시간 예고 + 한 줄 정리

**한 줄 정리. 본인 노트북의 네트워크 주민등록증은 네 숫자 — 사설 IP·게이트웨이·DNS 서버·공인 IP — 로 구성되고, netinfo 한 줄로 그 카드를 뽑을 수 있다.** 다음 H4는 명령어 카탈로그입니다. ping·curl·dig·traceroute·nc·openssl·ss·lsof·tcpdump·tshark — 12개 도구를 한 시간 안에 한 번씩 손에 쥡니다. Ch002 H4에서 ps와 친구들을 한 번에 본 그 시간 같은 모양이에요. 다음 시간 전에 한 가지만 — 본인 .zshrc에 netinfo 함수를 박아 두시고, 한 번 쳐 보세요. 본인의 사설 IP, 게이트웨이, DNS, 공인 IP가 한 화면에 떠야 H3 졸업입니다. 두 해 코스 우리 위치는 19/960 = 1.98%. 거의 2%에 다다랐어요. 다음 시간에 만나요. 수고 많으셨습니다.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - macOS Ventura 이후 ifconfig는 deprecation 경고. 학습용으론 충분, 신규 코드는 networksetup/scutil 권장.
> - Linux의 /etc/resolv.conf는 systemd-resolved에 의해 동적으로 관리. 직접 편집은 권장 X.
> - HTTP_PROXY는 대소문자 양쪽 다 설정. curl은 둘 다 인식, 일부 도구는 한쪽만.
> - VPN full tunnel vs split tunnel 차이는 라우팅 테이블의 0.0.0.0/0 엔트리로 판별.
> - 회사 TLS 인터셉트는 인증서 issuer로 확인. CN에 회사 이름이 박혀 있으면 인터셉트.
> - netinfo 별칭은 dotfiles 레포에 두면 여러 노트북에서 동기화.

## 추신

0. 3교시의 졸업증은 .zshrc에 박힌 netinfo 한 줄입니다. 잊지 마세요.
1. 네 숫자 카드 — 사설 IP·게이트웨이·DNS·공인 IP. 외울 게 아니라 netinfo로 뽑으세요.
2. 회사 와이파이와 집 와이파이는 다섯 가지가 다릅니다. 그 차이가 운영 디버깅의 첫 단서.
3. /etc/hosts는 작지만 큰 무기. 수정 후 mDNSResponder 재시작 한 줄을 외우세요.
4. proxy_on / proxy_off 두 글자 별칭이 회사-집 이동의 위생입니다.
5. VPN은 신뢰의 대상을 바꾸는 도구. 안전을 만드는 게 아니에요.
6. 와이파이 신호 -85dBm 이하는 끊김 직전. 자리를 옮기시는 게 답.
7. /etc/hosts와 DNS의 순서는 nsswitch.conf의 hosts 줄. files 우선.
8. 게이트웨이 ping이 첫 진단. 안 가면 인터페이스부터 의심.
9. macOS의 awdl0, utun, bridge100은 무시해도 됩니다. 일상은 en0와 lo0.
10. 다음 H4는 도구 12개 카탈로그. ping부터 tcpdump까지 한 시간에.
11. netinfo를 .zshrc에 박는 게 H3 졸업장입니다.
12. 본인 환경을 모르고 인터넷을 디버깅하는 건 본인 주소 모르고 우체국에 항의하는 일입니다.
13. 회사 노트북·집 노트북·카페 노트북. 같은 명령에 다른 답이 나오는 게 정상입니다. 그게 환경의 정의예요.
14. 회사 TLS 인터셉트는 보안의 도움이자 어떤 코드의 적입니다. 본인 코드의 TLS 검증 강도를 결정할 때 늘 두 환경을 같이 떠올리세요.
15. NAT 뒤에 있다는 사실이 본인을 안전하게도 만들고 무력하게도 만듭니다. 외부에서 본인에게 직접 들어오기 어려워 안전하지만, 본인이 외부에 서버를 띄우려면 포트포워딩이 필요해요.
16. dig가 회사에서 막혔다면 nslookup을 시도해 보세요. 어떤 회사는 dig만 막고 nslookup은 풀어 둡니다. 둘 다 막히면 사내 DNS 정책.
17. 본인 노트북에 인터페이스 12개 보이는 건 두려운 게 아니라 풍요로운 거예요. 도커 한 개, VPN 한 개, AirDrop 한 개. 다 본인이 활성화한 결과.
18. 마지막 한 줄 — 환경은 외우는 게 아니라 뽑는 겁니다. netinfo 한 줄.
