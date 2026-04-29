# H6 · 운영체제 기본 — 응급처치 (OS 사고 5종)

> 고양이 자경단 · Ch 002 · 6교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 5교시 회수 + 6교시 약속 (진단·치료의 짝)
2. 응급실의 5가지 비상등 — 사고 카탈로그
3. 사고 1 — 좀비(Z) 폭발 → 부모 처리
4. 사고 2 — OOM (Out of Memory) → 메모리 사냥
5. 사고 3 — 디스크 풀 (No space left) → 큰 파일 사냥
6. 사고 4 — 네트워크 끊김 → ping·traceroute·dig·curl
7. 사고 5 — CPU 100% 폭주 → top·renice·kill
8. 한 줄 응급키트 — emergency.sh 미리보기
9. /var/log 로그 5대표 — system.log·wifi.log·install.log·crash·daily.out
10. log show / journalctl — 두 OS 의 로그 도구
11. 좀비 사례 시연 — 본인 맥에서 진짜로 만들기
12. OOM Killer — 누가 죽였는지 찾는 한 줄
13. 디스크 풀 사전 경보 — df + 알람
14. 응급처치 7단계 표준 절차
15. 위험 명령 5종 (응급실 버전)
16. macOS vs Linux 응급명령 차이표
17. 두 해 후 새벽 세 시 시나리오 (재현)
18. FAQ 5
19. 두 시간 약속 — 매일 procmon + 주 1회 emergency 점검
20. 마무리 — H7 kernel vs user space 로

---

## 🔧 강사용 명령어 한눈에

```bash
# 좀비 사냥
ps -eo pid,ppid,stat,comm | awk '$3 ~ /^Z/'
ps -eo pid,ppid,stat,comm | awk '$3 ~ /^Z/ {print $2}' | sort -u   # 부모 PPID
kill -CHLD <PPID>                  # 부모에게 자식 거두라고
kill <PPID>                        # 부모를 죽임 → 좀비도 init 이 거둠

# 메모리 (OOM)
ps -eo pid,user,%mem,rss,comm | sort -k4 -nr | head           # macOS RSS 바이트
free -h                                                       # Linux
vm_stat                                                       # macOS
sudo dmesg | grep -i "killed process"                        # Linux OOM Killer 로그
log show --last 1h --predicate 'eventMessage CONTAINS "low memory"'  # macOS

# 디스크 풀
df -h                              # 마운트별 사용량
du -sh /* 2>/dev/null | sort -h    # 루트 폴더별
du -sh ~/Library/* 2>/dev/null | sort -h | tail -10   # macOS 의심 폴더
du -ah ~/Downloads | sort -h | tail -20               # 큰 파일
find ~ -type f -size +1G 2>/dev/null                  # 1GB 이상

# 네트워크
ping -c 4 8.8.8.8                  # IP 도달
ping -c 4 google.com               # DNS+IP 도달
dig google.com +short              # DNS 만
traceroute -n -m 15 google.com     # 경로
curl -I -s https://google.com      # HTTP 헤더만
nc -vz google.com 443              # 포트 열림 확인
lsof -nP -iTCP:8080 -sTCP:LISTEN   # 포트 누가 듣고 있나

# CPU 100%
top -o cpu                         # CPU 순 (인터랙티브)
top -l 1 -o cpu | head -20         # 1회 캡처
ps -eo pid,user,%cpu,comm | sort -k3 -nr | head
renice +10 -p <PID>                # 우선순위 낮춤(덜 받음)
renice -5 -p <PID>                 # 더 받음 (sudo 필요)

# 로그
log show --last 30m | head -50     # macOS 통합 로그
log show --last 30m --predicate 'subsystem == "com.apple.network"'
sudo dmesg | tail -50              # 커널 메시지
ls -lah /var/log/                  # 로그 파일들
tail -f /var/log/system.log        # macOS (구버전)

# 응급키트
~/myscripts/emergency.sh           # H8 에서 만들 도구 미리
```

> ⚠️ 응급실 금지: `kill -9 1`, `sudo rm -rf /`, `dd if=/dev/zero of=/dev/디스크`, `:(){ :|:& };:` (포크 폭탄), `chmod -R 777 /`. 본인 시스템 즉사.

---

## 1. 5교시 회수 + 6교시 약속 — 진단·치료의 짝

자, 여섯 번째 시간이에요. 본인 8시간 약속의 6/8. 75%. 진짜 마지막 한 발 남았어요. 본인 진심으로 잘 견뎌 주셨어요. 짝짝짝.

지난 5교시(H5) 에 본인이 procmon.sh 한 개 만들었어요. 본인 호텔의 진단 도구. 본인이 손으로 만든 두 번째 .sh. 본인 ~/myscripts 에 sysinfo + procmon 두 명. 본인 도구 가족.

오늘 6교시. **진단했으면 치료해야죠.** procmon.sh 가 의사의 청진기라면 오늘은 처방전. 본인 시스템에 사고 났을 때 한 줄로 응급조치 하는 법. 다섯 가지 사고와 다섯 가지 처방. 좀비·OOM·디스크 풀·네트워크 끊김·CPU 100%. 이 다섯이 본인이 두 해 동안 만 번 만나는 사고에요.

오늘 약속 한 줄. **"6교시 끝나면 본인이 다섯 가지 OS 사고에 대해 한 줄씩 응급명령을 손에 들고 있다."** 그게 약속. 다섯 가지를 머리에 두면 새벽 세 시에 본인이 잠결에도 손이 그 명령을 칠 수 있어요. 두 해 후 본인을 구하는 손이 오늘 한 시간에 만들어져요.

비유 한 번. 본인이 의대생이라고 생각해 보세요. 5교시까지는 해부학·생리학 — 호텔(OS) 의 구조와 동작을 배웠어요. 6교시는 응급의학. 환자가 들어왔을 때 5분 안에 뭘 해야 하나. 진단·치료의 짝. 의사의 손이에요. 본인이 두 해 후 진짜 시스템 운영자가 되면 매일 의사가 돼요.

가요. 한 사고씩 한 처방씩.

## 2. 응급실의 5가지 비상등 — 사고 카탈로그

먼저 큰 표 한 장. 다섯 사고와 다섯 증상.

| 사고 | 증상 | 진단 한 줄 | 처방 한 줄 |
|------|------|-----------|-----------|
| 1. 좀비 폭발 | ps STAT=Z 가 100개+ | `ps -eo pid,ppid,stat\|awk '$3~/^Z/'` | 부모 PPID kill |
| 2. OOM | 시스템 멈춤·앱 강제종료 | `ps ...sort -k4 -nr\|head` | 메모리 먹는 PID kill |
| 3. 디스크 풀 | "No space left", 앱 못 저장 | `df -h` `du -sh /*` | 큰 파일 삭제 또는 압축 |
| 4. 네트워크 | "연결 안 됨", curl timeout | `ping`·`dig`·`traceroute` | DNS 변경, 라우팅 확인 |
| 5. CPU 100% | 시스템 느림, 팬 굉음 | `top -o cpu` | renice 또는 kill |

다섯 사고. 다섯 증상. 다섯 진단. 다섯 처방. 한 시간 동안 한 사고씩 12분.

이 표 외에도 본인이 두 해 후 만나는 사고가 더 있어요. 인증서 만료·SSH 안 됨·Permission denied·DNS resolver 깨짐·시계 어긋남(NTP)·파일 디스크립터 고갈·inode 고갈·스왑 풀·커널 패닉. 30가지가 더 있어요. 그 중에 90% 가 본인 두 해 동안 만나는 건 위 다섯. 다섯에 집중. 나머지는 두 해 후 chap 50번대(DevOps) 에서 자세히.

한 가지 응급실의 진짜 원칙. **"진단부터, 처방은 그 다음."** 본인이 사고 났을 때 가장 흔한 실수가 진단 안 하고 바로 reboot. 그러면 사고 원인이 안 잡혀서 또 일어나요. 5분만 진단에 써요. 그 5분이 본인을 다음 사고에서도 구해요. procmon.sh 가 그래서 진짜 가치 있는 거예요. 사고 났을 때 5분 진단의 첫 한 줄.

## 3. 사고 1 — 좀비(Z) 폭발 → 부모 처리

**증상.** ps 에 STAT=Z 인 프로세스가 한 두 개가 아니라 수십, 수백 개. 시스템은 멀쩡한데 PID 가 자꾸 차요. 새 프로세스 못 띄움.

**왜 생기냐.** H2 회수. 자식이 죽으면 종료 코드를 부모에게 알려야 하는데, 부모가 wait 안 해 줌. 자식은 PID 만 차지하고 좀비로 남음. 부모가 쓰레기 같은 코드.

**진단.**

> ▶ **같이 쳐보기** — 좀비 사냥: 본인 맥의 Z 상태 프로세스 목록
>
> ```bash
> ps -eo pid,ppid,stat,comm | awk '$3 ~ /^Z/'
> # 12345 11111 Z   <defunct>
> # 12346 11111 Z   <defunct>
> # ... 한 부모(11111) 가 좀비 100개를 만들고 있음
> ```

`<defunct>` 는 "이미 죽었음" 의 표시. 좀비의 진짜 모습.

**처방 1 — 부모에게 알리기.**
```bash
kill -CHLD <PPID>
```
SIGCHLD 신호. "야, 자식 죽었으니 거둬!" 신호. 부모가 정상이면 wait 호출해서 좀비 청소.

**처방 2 — 부모 죽이기.**
```bash
kill <PPID>
```
부모가 죽으면 좀비들의 새 부모는 PID 1 (init/launchd). PID 1 은 정기적으로 wait 호출해서 좀비 청소. 그러면 자동으로 사라져요. 본인 시스템에 PID 1 이 있는 가장 큰 이유 중 하나가 이 좀비 청소.

**처방 3 — kill -9 안 통함 기억.**
좀비는 이미 죽었어요. SIGKILL 한 번 더 보내도 안 죽어요. 부모를 처리해야 해요. 본인이 진짜 자주 까먹는 함정.

**비유.** 호텔 방의 손님이 체크아웃했는데 매니저(부모) 가 방 키를 안 받음. 방은 비어 있는데 시스템상 "체크인 중" 으로 표시. 100개 방이 그렇게 되면 새 손님 못 받아요. 매니저(부모) 한테 "키 받아!" 하든가, 매니저를 바꿔야 해요. 좀비 = 빈 방, 부모 = 키 안 받는 매니저.

오늘 한 줄. **"좀비는 부모 문제."** 머리에.

## 4. 사고 2 — OOM (Out of Memory) → 메모리 사냥

**증상.** 시스템이 갑자기 느려져요. 한 번 멈추고. 어떤 앱이 갑자기 사라져요 (강제 종료). 본인이 안 죽였는데. macOS 면 "메모리 부족" 알림. Linux 면 dmesg 에 "killed process" 로그.

**왜 생기냐.** 본인 맥에 16GB RAM 인데 어떤 앱이 14GB 잡아 먹음. 다른 앱들 + OS 자체가 2GB 더 필요. OS 가 한 명 죽여서 메모리 회수. 그게 **OOM Killer**.

**진단 — macOS.**

> ▶ **같이 쳐보기** — 메모리 사냥: 누가 RAM 을 가장 많이 먹나
>
> ```bash
> ps -eo pid,user,%mem,rss,comm | sort -k4 -nr | head
> #   PID USER  %MEM    RSS COMMAND
> # 12345 mo    25.0  4.2G  Google Chrome Helper (Renderer)
> # 12346 mo    18.0  3.0G  com.docker.hyperkit
> # ... 의심 PID 발견
> ```

`rss` 는 진짜 RAM 차지 (Resident Set Size). %mem 은 비율. 둘 다 높은 게 진짜 범인.

**진단 — Linux.**
```bash
free -h
#                total   used   free  shared  buff/cache  available
# Mem:           15Gi   13Gi  500Mi   100Mi       1.5Gi       1Gi
```
`available` 이 진짜 사용 가능. 1Gi 면 위험.

**OOM Killer 가 누구를 죽였나.**
```bash
# Linux
sudo dmesg | grep -i "killed process"
# [12345.6] Out of memory: Killed process 6789 (chrome) total-vm:5G
# [23456.7] Out of memory: Killed process 9876 (node) total-vm:3G

# macOS
log show --last 1h --predicate 'eventMessage CONTAINS "low memory" OR eventMessage CONTAINS "jetsam"' --info
```

macOS 의 OOM Killer 는 **Jetsam** 이라는 다른 이름. 같은 일.

**처방 1 — 의심 PID kill.**
```bash
kill <PID>
# 정중히. 5초 후
kill -9 <PID>
```

**처방 2 — 스왑 확인.**
```bash
sysctl vm.swapusage          # macOS
free -h | grep -i swap       # Linux
```
스왑이 거의 다 차 있으면 RAM 도 거의 다 찬 거예요.

**처방 3 — 근본 해결.**
- 메모리 더 사기 (가장 확실)
- 메모리 누수 앱 다시 띄우기 (재시작)
- 가벼운 앱으로 교체 (Chrome → Safari)

**비유.** 호텔 방이 16개. 한 손님(앱) 이 14개 방을 다 차지. 다른 손님 못 들어옴. 매니저(OS) 가 그 욕심쟁이를 강제 퇴실시킴. 그게 OOM Killer. 매니저 입장에선 호텔 전체를 위해 한 명 희생. 본인 입장에선 "왜 내 앱이 갑자기 죽어?". 둘의 입장이 달라요. 두 해 후 본인이 매니저 입장이 돼요.

## 5. 사고 3 — 디스크 풀 (No space left) → 큰 파일 사냥

**증상.** 어떤 명령이 "No space left on device" 에러. 앱이 저장 못 함. Docker 이미지 못 받음. git pull 못 함.

**진단 1 — 어느 마운트가 찼나.**

> ▶ **같이 쳐보기** — 디스크 한 줄 진단
>
> ```bash
> df -h
> # Filesystem      Size  Used Avail Use% Mounted on
> # /dev/disk3s5   500G  495G  5G   99%  /
> ```
99% 가 위험. 95% 도 위험. 90% 부터 청소 시작.

**진단 2 — 어느 폴더가 큰가.**
```bash
sudo du -sh /* 2>/dev/null | sort -h
# 4K   /bin
# 8K   /etc
# 50G  /Users
# 20G  /Library
# 30G  /private
# ... 가장 큰 폴더 위치
```

`-h` 는 human-readable (G, M, K). `sort -h` 는 그 단위 알아서 정렬. macOS 의 `sort` 는 `-h` 안 되면 brew coreutils 로 gsort 받기.

**진단 3 — 의심 폴더 깊이 파기.**
```bash
du -sh ~/Library/* 2>/dev/null | sort -h | tail -10
# 2G   ~/Library/Caches/com.google.Chrome
# 5G   ~/Library/Containers
# 8G   ~/Library/Developer    ← Xcode 큼
# ...
```

본인 맥에서 가장 흔한 큰 폴더 5명.

1. **~/Library/Developer/Xcode/DerivedData** — Xcode 의 빌드 캐시. 10~50GB. 다 지워도 OK.
2. **~/Library/Caches** — 앱 캐시. 5~20GB. 다 지워도 OK.
3. **~/Library/Containers** — 앱 데이터. 5~30GB. 신중.
4. **~/Downloads** — 본인 다운로드. 5~50GB. 본인이 정리.
5. **/Library/Logs** — 시스템 로그. 1~5GB. sudo 로 정리.

**진단 4 — 큰 파일 직접.**
```bash
find ~ -type f -size +1G 2>/dev/null
# 1GB 이상 파일 목록
```

**처방 1 — 안전한 청소 (Xcode 캐시).**
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Caches/*    # 신중. 일부 앱은 첫 실행 느려짐
```

**처방 2 — Docker 청소.**
```bash
docker system prune -a       # 모든 안 쓰는 이미지·볼륨
```
이 한 줄로 50~100GB 회복하는 경우 종종.

**처방 3 — 휴지통 비우기.**
```bash
rm -rf ~/.Trash/*
```

**처방 4 — inode 풀.**
```bash
df -i        # 파일 개수 한도. 100% 면 inode 풀.
```
용량 안 찼는데 "No space left" 면 inode 풀. 작은 파일이 너무 많아서. 흔치 않은 사고. 두 해 후 한 번 만남.

**비유.** 호텔의 창고가 다 참. 새 짐(파일) 못 받아. 매니저가 창고를 비워야 해요. 다섯 의심 코너부터. 그게 본인의 청소 루틴.

## 6. 사고 4 — 네트워크 끊김 → ping·traceroute·dig·curl

**증상.** 브라우저 "연결 안 됨". curl timeout. git clone 안 됨.

**진단의 7단계 사다리.** 본인 맥에서 인터넷까지 7개 다리. 한 다리씩 검사.

**다리 1 — 본인 인터페이스 확인.**
```bash
ifconfig en0    # macOS
ip addr show eth0    # Linux
# inet 192.168.1.10 ...  ← IP 받아져 있나?
```
IP 가 빈 줄이면 본인 Wi-Fi/이더넷 자체가 안 붙음.

**다리 2 — 본인 게이트웨이.**
```bash
netstat -rn | grep default
# default 192.168.1.1 ...
ping -c 3 192.168.1.1    # 본인 공유기
```
공유기가 응답 안 하면 본인 집 Wi-Fi 문제.

**다리 3 — 외부 IP (DNS 안 거치고).**

> ▶ **같이 쳐보기** — 인터넷 첫 핑 (DNS 안 거치는 진단)
>
> ```bash
> ping -c 3 8.8.8.8        # 구글 DNS, 항상 살아있음
> ```
8.8.8.8 응답 OK 면 본인 → 인터넷 OK. 안 되면 ISP 또는 라우팅 문제.

**다리 4 — DNS.**
```bash
dig google.com +short
# 142.250.207.110
```
빈 줄이면 DNS 깨짐. `/etc/resolv.conf` 또는 시스템 환경설정 확인. 빠른 우회: DNS 를 8.8.8.8 또는 1.1.1.1 로 변경.

**다리 5 — DNS+IP.**
```bash
ping -c 3 google.com
```
다리 3 OK 인데 다리 5 안 되면 DNS 문제.

**다리 6 — 경로.**
```bash
traceroute -n -m 15 google.com
```
어디서 끊기는지. 본인 라우터 다음 홉 (보통 ISP 게이트웨이) 에서 끊기면 ISP 문제.

**다리 7 — HTTP.**
```bash
curl -I -s https://google.com | head
# HTTP/2 200
```
TCP+TLS+HTTP 다 OK. 인터넷 정상.

**일곱 다리를 한 단계씩.** 어느 다리에서 끊기는지 알면 처방이 자동으로 정해져요.

| 끊긴 다리 | 처방 |
|----------|------|
| 1. 인터페이스 | Wi-Fi 다시 연결, 케이블 확인 |
| 2. 게이트웨이 | 공유기 재부팅 |
| 3. 8.8.8.8 | ISP 또는 본인 라우팅 |
| 4. DNS | DNS 서버 변경 (8.8.8.8) |
| 5. DNS+IP | 다리 3·4 둘 다 확인 |
| 6. 경로 | ISP 에 연락 |
| 7. HTTP | 방화벽·인증서·프록시 |

**보너스 — 포트 누가 듣고 있나.**
```bash
lsof -nP -iTCP:8080 -sTCP:LISTEN
# python 12345 mo    3u  IPv4 ...  TCP *:8080 (LISTEN)
```
본인이 8080 포트로 서버 띄우려는데 "Address already in use" 면 이 한 줄로 누가 차지하고 있는지.

**비유.** 호텔에서 옆 호텔로 손님 보내는데 7개 문을 거쳐야 해요. 어느 문이 잠겼는지 한 문씩 두드림. 잠긴 문이 본인이 처방해야 할 자리. 일곱 다리 한 단계씩. 두 해 후 본인이 매일 쓰는 진단 사다리.

## 7. 사고 5 — CPU 100% 폭주 → top·renice·kill

**증상.** 본인 맥의 팬이 굉음. 시스템 답답. macOS 의 활성 상태 보기 빨간색.

**진단.**

> ▶ **같이 쳐보기** — CPU 1위 사냥
>
> ```bash
> top -l 1 -o cpu | head -20       # 1회 캡처 — 가장 빠른 진단
> ```
상위 5명 보고 의심 PID 식별.

**처방 1 — 죽이기.**
```bash
kill <PID>
# 5초 후
kill -9 <PID>
```

**처방 2 — 우선순위 낮추기 (안 죽이고).**
```bash
renice +10 -p <PID>      # nice 값 +10 → 덜 받음 (1~19)
```

**nice 값 의 진짜 의미.** -20 ~ +19. 음수는 "덜 양보" (CPU 더 받음, sudo 필요). 양수는 "더 양보" (CPU 덜 받음). 0 이 기본.

```bash
nice -n 10 long_task.sh    # 처음부터 nice +10 으로 시작
nice -n -5 priority_task   # CPU 더 받기 (sudo 필요)
```

본인이 큰 빌드 돌릴 때 `nice -n 10 make build` 하면 본인 다른 작업이 답답하지 않아요. 두 해 후 본인이 만 번 쓸 패턴.

**처방 3 — 진짜 원인 찾기.**
CPU 100% 가 본인이 띄운 거면 코드 버그. 무한 루프. 본인이 안 띄운 거면 어떤 백그라운드 프로세스. macOS 면 보통 kernel_task 가 100% 가까이 — 시스템이 열관리 중. 잠깐 식히면 가라앉음.

**비유.** 호텔 방의 한 손님이 너무 시끄러워서 옆방 손님이 답답. 매니저가 "조용히 해 주세요" (renice +10) 또는 "나가 주세요" (kill). 두 가지 손길. 본인이 둘 다 손에.

오늘까지 다섯 사고 다섯 처방. 한 사고당 약 10분. 합계 50분. 남은 10분은 표준 절차 + FAQ + 마무리.

## 8. 한 줄 응급키트 — emergency.sh 미리보기

H8 (적용+회고) 에서 본인이 만들 emergency.sh 의 첫 골격을 미리.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== 응급 진단 시작 ($(date)) ==="

echo ""
echo "--- 1. 좀비 ---"
ps -eo pid,ppid,stat,comm | awk '$3 ~ /^Z/' | head -10 || echo "(없음 ✅)"

echo ""
echo "--- 2. 메모리 상위 5 ---"
ps -eo pid,user,%mem,rss,comm | sort -k4 -nr | head -6

echo ""
echo "--- 3. 디스크 ---"
df -h | grep -v tmpfs

echo ""
echo "--- 4. 네트워크 (8.8.8.8) ---"
ping -c 2 -W 2 8.8.8.8 > /dev/null && echo "OK ✅" || echo "끊김 ⚠️"

echo ""
echo "--- 5. CPU 상위 5 ---"
ps -eo pid,user,%cpu,comm | sort -k3 -nr | head -6

echo ""
echo "=== 응급 진단 끝 ==="
```

50줄짜리. 한 명령으로 다섯 사고를 한 번에 진단. 본인이 두 해 후 새벽 세 시에 SSH 접속 후 첫 한 줄. **`./emergency.sh`**. 5초 안에 본인 시스템 전체 건강 보고서.

procmon.sh 가 일상 진단이라면 emergency.sh 는 응급 진단. 두 도구의 짝.

## 9. /var/log 로그 5대표

본인 맥의 진실은 /var/log 폴더 안에 있어요. 시스템이 모든 사고를 기록하는 자리.

```bash
ls -lah /var/log/
```

다섯 대표.

1. **system.log** (구버전 macOS) — 시스템 전반. 사고가 가장 먼저 쌓이는 자리.
2. **wifi.log** — Wi-Fi 연결·해제·에러.
3. **install.log** — 앱 설치·업데이트.
4. **DiagnosticReports/*.crash** — 앱 충돌 보고서.
5. **daily.out·weekly.out·monthly.out** — 시스템 정기 작업 결과.

근데 macOS Big Sur (2020) 이후 대부분 **통합 로그** 로 옮겨갔어요. /var/log/system.log 에는 일부만. 진짜 로그는 `log show` 명령으로 봐요.

## 10. log show / journalctl — 두 OS 의 로그 도구

**macOS — log show.**
```bash
log show --last 30m | head -100              # 최근 30분
log show --last 1h --predicate 'eventMessage CONTAINS "error"' | head
log show --last 1h --predicate 'subsystem == "com.apple.network"'
log show --last 6h --predicate 'eventMessage CONTAINS "low memory"'
```

`--predicate` 는 SQL 같은 필터. 처음엔 헷갈리는데 한 두 번 쓰면 익숙. 본인이 자주 쓸 한 줄 미리 .zshrc 에 alias.

```bash
alias logerr='log show --last 1h --predicate '\''eventMessage CONTAINS "error"'\'' | head -50'
```

**Linux — journalctl.**
```bash
journalctl -xe              # 최근 + 설명
journalctl --since "1 hour ago"
journalctl -u nginx         # nginx 서비스 로그만
journalctl -p err           # error 이상만
journalctl -f               # 실시간 (tail -f 같음)
```

systemd 의 표준. 두 해 후 EC2 에서 본인이 매일 칠 명령. 본인이 macOS 에서 익힌 log show 와 패턴 비슷. 두 OS 다 손에.

추가 — **dmesg.** 커널 메시지.
```bash
sudo dmesg | tail -50
sudo dmesg | grep -i "killed process"
sudo dmesg | grep -i "out of memory"
```
OOM Killer 가 누굴 죽였는지 가장 먼저 보는 자리. Linux 에서 진짜 자주.

## 11. 좀비 사례 시연 — 본인 맥에서 진짜로 만들기

이론만 들으면 안 와닿아요. 본인 맥에서 진짜 좀비 한 마리 만들어 봐요. 1분.

```bash
# 좀비를 일부러 만드는 한 줄
( sleep 5 ) &
# 5초 안에 부모(본인 셸) 가 wait 안 하면 자식이 좀비
sleep 6
ps -eo pid,ppid,stat,comm | grep $(jobs -p) || echo "이미 거둬짐"
```

본인 셸은 잘 만들어진 부모라서 자동으로 wait 호출 → 좀비 안 됨. 일부러 wait 안 하는 부모를 만들려면 더 복잡한 코드. Python 으로.

```python
# zombie_demo.py
import os, time
pid = os.fork()
if pid == 0:
    print(f"자식 PID {os.getpid()} 즉시 종료")
    os._exit(0)
else:
    print(f"부모 PID {os.getpid()}, 자식 PID {pid}")
    print("부모는 wait 안 하고 30초 자요...")
    time.sleep(30)
```

```bash
python3 zombie_demo.py &
# 다른 터미널에서
ps -eo pid,ppid,stat,comm | grep -E "(python|defunct)" | head
# 자식이 Z 상태로 보임
```

30초 후 부모 죽으면 좀비도 init 이 거둠. 본인이 진짜 한 번 봐 보면 평생 안 잊혀요. 5분만 시간 내서 한 번.

## 12. OOM Killer — 누가 죽였는지 찾는 한 줄

본인 앱이 갑자기 사라졌어요. 본인이 안 죽였는데. 누가?

**Linux.**
```bash
sudo dmesg | grep -E "(killed|oom|out of memory)" -i
# Out of memory: Killed process 6789 (chrome) total-vm:5G
```

`total-vm` 이 진짜 큰 거. 그 앱이 메모리를 너무 먹어서 OOM Killer 의 표적. 두 해 후 본인 EC2 에서 노드 서버가 자꾸 죽으면 가장 먼저 칠 한 줄.

**macOS.**
```bash
log show --last 6h --predicate 'eventMessage CONTAINS "jetsam" OR eventMessage CONTAINS "low memory"' --info | head -50
```

macOS 의 OOM Killer 이름이 **Jetsam**. 같은 일. 다른 이름.

**처방.**
- 그 앱의 메모리 누수 고치기 (코드 수정)
- 그 앱에 메모리 한도 두기 (ulimit -v)
- 시스템 메모리 늘리기

두 해 후 본인 회사 EC2 가 자꾸 죽으면 첫 진단이 OOM Killer 인지 확인. 그 한 줄.

## 13. 디스크 풀 사전 경보 — df + 알람

사고 나기 전에 알면 좋아요. cron 으로 매시간 df 체크.

```bash
#!/usr/bin/env bash
# disk_alert.sh
THRESHOLD=85
df -h | awk -v t=$THRESHOLD '
  NR > 1 && $5+0 > t {
    print "⚠️  " $6 " 사용률 " $5 " (한도 " t "%)"
  }
'
```

```bash
# crontab -e
0 * * * * /Users/mo/myscripts/disk_alert.sh | mail -s "디스크 경보" you@example.com
```

매시간 한 번 체크. 85% 넘으면 메일. 두 해 후 본인이 안 까먹는 비결.

추가 — 본인 ~/Downloads 가 30G 넘으면 알림.
```bash
THRESHOLD_GB=30
SIZE=$(du -sg ~/Downloads | cut -f1)
[ $SIZE -gt $THRESHOLD_GB ] && echo "Downloads $SIZE G 정리하세요"
```

작은 알람들이 본인 시스템을 지켜요. cron 의 진짜 힘.

## 14. 응급처치 7단계 표준 절차

본인이 사고 만났을 때 표준 절차. 외워 두세요.

1. **숨 한 번.** 5초. 당황 안 함. 진단부터.
2. **로그 시간 기록.** `date` 한 번. 사고 난 시각 메모.
3. **영향 범위 확인.** 본인 한 명? 팀 전체? 사용자 전체?
4. **긴급 조치.** 서비스 재시작, 트래픽 분산. 5분 내.
5. **진단.** procmon·emergency.sh + log show. 10~30분.
6. **근본 처방.** 코드·설정·인프라 수정. 1시간~며칠.
7. **사후 보고서.** 무슨 사고였나, 왜 났나, 어떻게 막을까. 1쪽.

이 7단계가 두 해 후 본인이 회사에서 따르는 절차. 사후 보고서는 영어로 **post-mortem** 또는 **RCA** (Root Cause Analysis). 본인이 두 해 후 매월 한 두 번씩 쓰게 될 문서.

오늘 머리에 한 줄. **"숨 → 시각 → 범위 → 긴급조치 → 진단 → 처방 → 보고."** 일곱 글자.

## 15. 위험 명령 5종 (응급실 버전)

응급실에서 본인이 절대 안 치는 5가지.

1. **`sudo rm -rf /`** — 시스템 통째로 날림. macOS 는 막아 주는데 Linux 는 진짜 죽어요.
2. **`:(){ :|:& };:`** — 포크 폭탄(fork bomb). 함수가 자기를 두 번 호출. 1초 안에 본인 시스템 다운. 응급실 절대 금지.
3. **`dd if=/dev/zero of=/dev/disk0`** — 본인 디스크를 0 으로 덮어씀. 데이터 영원히 사라짐.
4. **`chmod -R 777 /`** — 모든 파일 권한 777. 보안 끝장. 시스템 망가짐.
5. **`> /etc/passwd`** — 본인 사용자 정보 파일 비움. 로그인 못 함.

응급실에서 당황하면 본인이 위 다섯 중 하나를 칠 수도 있어요. **무조건 멈춰요.** 5분 후 다시. 한 번 친 명령은 되돌릴 수 없어요. 응급실의 첫 원칙. **"의심되면 안 친다."**

## 16. macOS vs Linux 응급명령 차이표

| 사고 | macOS | Linux | 차이 |
|------|-------|-------|------|
| 좀비 | `ps -eo` | `ps -eo` | 같음 |
| OOM | `log show --predicate jetsam` | `dmesg \| grep killed` | 도구 이름 다름 |
| 메모리 | `vm_stat`, `sysctl hw.memsize` | `free -h`, `/proc/meminfo` | 다름 |
| 디스크 | `df -h`, `du -sh` | `df -h`, `du -sh` | 같음 |
| 네트워크 | `ifconfig`, `traceroute` | `ip addr`, `traceroute` | 일부 다름 |
| 포트 | `lsof -nP -iTCP:N` | `ss -tlnp \| grep :N` | 다름 |
| 로그 | `log show` | `journalctl` | 도구 다름, 패턴 비슷 |
| 커널 메시지 | `log show --predicate kernel` | `dmesg` | 다름 |
| 우선순위 | `nice`, `renice` | `nice`, `renice` | 같음 |

겹치는 게 60%. 다른 40% 의 핵심은 로그 도구 (log show vs journalctl) 와 포트 확인 (lsof vs ss). 두 명령씩만 더 외우면 두 OS 다 손에. 두 해 후 EC2 가도 기죽지 않아요.

특히 **lsof vs ss.** lsof 는 macOS 에 기본, Linux 에도 있음. ss 는 Linux 표준. 두 도구 다 손에.

## 17. 두 해 후 새벽 세 시 시나리오 — 재현

본인이 두 해 후 EC2 에 배포한 노드 서버. 새벽 3:14 슬랙 알람.

```
🚨 PRD-WEB-01: 응답시간 5초 초과
```

본인 핸드폰이 울려요. 잠결에 노트북. SSH.

```bash
ssh ec2-user@prd-web-01.example.com
```

첫 한 줄.

```bash
~/myscripts/emergency.sh
# === 응급 진단 시작 (2028-04-26 03:15:23) ===
# --- 1. 좀비 ---
# (없음 ✅)
# --- 2. 메모리 상위 5 ---
#   PID USER %MEM    RSS COMMAND
# 12345 ec2-  82.0  6.5G  node
# ...
# --- 3. 디스크 ---
# /dev/xvda1   100G   95G  4.5G  96% /
# --- 4. 네트워크 (8.8.8.8) ---
# OK ✅
# --- 5. CPU 상위 5 ---
# 12345 ec2-  98.0  node
```

5초. 본인이 즉시 알아요. **노드 PID 12345 가 메모리 6.5G + CPU 98%.** 메모리 누수.

```bash
sudo dmesg | grep -i killed | tail -5
# (좀비 없고 OOM Killer 도 안 동작)
```

OOM 직전. 곧 죽어요. 응급조치.

```bash
sudo systemctl restart node-app
~/myscripts/emergency.sh    # 다시 확인
# 메모리 1.2G, CPU 25%. 정상.
```

3:18. 4분 만에 응급 처치 끝. 사용자 영향 4분.

다음 날 본인이 사후 보고서. "노드 서버 메모리 누수, restart 로 응급처치, 코드 수정 PR #1234."

**오늘 60분이 정확히 그 4분을 만들어요.** 본인이 오늘 다섯 사고 다섯 처방을 머리에 두면 두 해 후 새벽 4분이 진짜 가능해져요. 오늘 한 시간이 두 해 후 본인 + 본인 사용자를 구해요. 작은 시간이 큰 사고를 막아요.

## 18. FAQ 5

**Q1. 좀비를 미리 막는 코딩 패턴?**
A. 부모가 자식 띄울 때마다 wait. Python 이면 subprocess.Popen + .wait(). C 면 fork() 후 waitpid(). Node 면 child_process.spawn().on('exit'). 어떤 언어든 자식 띄웠으면 wait 가 짝꿍. 짝 잃은 자식이 좀비.

**Q2. OOM Killer 가 본인 중요 앱을 죽이지 않게 하려면?**
A. Linux 에선 `/proc/PID/oom_score_adj` 에 -17~-1000 (작을수록 보호). Docker 에선 `--oom-score-adj=-500`. 본인 데이터베이스 같은 중요 앱은 보호. 일반 앱은 기본. 두 해 후 chap 47 Docker 에서 자세히.

**Q3. 디스크 풀 났는데 rm 도 안 돼요.**
A. inode 풀이거나, 파일이 열려 있으면. `lsof | grep deleted` 로 "지웠는데 어떤 프로세스가 잡고 있어 진짜 안 지워진" 파일 찾기. 그 프로세스 재시작하면 회수. 진짜 흔한 함정.

**Q4. ping 8.8.8.8 은 되는데 google.com 은 안 돼요.**
A. DNS 깨짐. `dig google.com @8.8.8.8` 로 8.8.8.8 DNS 서버에 직접 물어보기. 응답 OK 면 본인 시스템 DNS 설정 문제. macOS 면 시스템 환경설정 → 네트워크 → DNS → 8.8.8.8 추가. Linux 면 /etc/resolv.conf.

**Q5. CPU 100% 인데 top 에 안 보여요.**
A. 두 가지. 첫째, kernel_task (커널 자체) 가 잡고 있음 — top 에 보임. macOS 가 열관리 중. 둘째, 스레드 단위 CPU. `ps -L` (Linux) 또는 `top -H` 로 스레드 보기. ps 의 CPU% 는 프로세스 전체. 한 스레드만 100% 일 수도 있어요.

## 19. 두 시간 약속 — 매일 procmon + 주 1회 emergency

오늘부터 두 해 동안 본인이 지킬 약속 두 가지.

**매일 1분 — procmon.sh 한 번.**
```bash
~/myscripts/procmon.sh > ~/logs/proc_$(date +%Y%m%d).log
```
하루 한 번. 본인 시스템 일상 진단. 본인 ~/logs 에 매일 한 파일. 두 해 후 730 파일. 본인 시스템의 두 해 추세가 그 폴더에.

**주 1회 — emergency.sh 한 번 (일요일).**
```bash
~/myscripts/emergency.sh > ~/logs/emergency_$(date +%Y%m%d).log
```
일요일 아침. 본인 시스템의 비상등 5개 점검. 한 번이라도 빨간색이면 그 주에 처방.

이 두 약속을 두 해 동안. 730 + 104 = 834 번. 본인이 두 해 후 시스템 의사가 돼 있어요. 이론만 안 돼요. 매일·주간 손에 익히는 습관이 본인을 의사로 만들어요.

## 20. 마무리 — H7 kernel vs user space 로

자 6교시 끝이에요. 본인이 한 시간 동안 다섯 사고 다섯 처방을 손에 넣었어요. 좀비·OOM·디스크 풀·네트워크·CPU 100%. 두 해 후 본인이 새벽 세 시에 만나는 사고들. 오늘 한 줄씩의 처방.

다음 시간 H7. **kernel vs user space.** H1 에서 잠깐 언급한 두 공간의 진짜 깊은 이야기. 왜 OS 가 두 공간으로 나뉘어 있는지, 왜 본인 코드는 user space 에서만 살아야 하는지, kernel space 에 들어가는 유일한 길이 syscall 인지. H2 의 syscall 이 진짜 깊이 들어가요. 그리고 그 두 공간의 경계 — **trap·context switch·CPU 모드(ring 0 vs ring 3)** 까지.

오늘 한 줄 정리. **"다섯 사고 다섯 처방. 진단·치료의 짝. 본인 의사의 손."** 이 한 줄.

본인 페이스. 6시간 끝. 8시간의 75%. 진짜 마지막 두 시간 남았어요. 잠깐 박수. 짝짝짝. 본인 진심으로 잘 견뎌 주셨어요. 5분 쉬고 H7 에서 만나요.

오늘 다섯 사고는 사실 한 가지 큰 원리의 다섯 얼굴이에요. **자원 한도.** 좀비는 PID 한도, OOM 은 메모리 한도, 디스크 풀은 저장 한도, 네트워크 끊김은 대역폭과 연결 한도, CPU 100% 는 처리 한도. 본인 호텔에 다섯 가지 자원이 있고, 어느 자원이든 한도를 넘으면 사고. 다섯 처방이 다섯 자원을 회수하는 일이에요. 한 가지 원리, 다섯 얼굴. 두 해 후 본인이 새 사고를 만나도 "어느 자원이 한도 넘었나?" 한 줄로 진단 시작. 그게 진짜 의사의 손이에요. H3 에서 친 ulimit -a 의 숫자들이 정확히 오늘 다섯 사고의 한도였어요. 한 챕터의 회수가 다음 챕터에서 빛나요.

본인이 두 해 후 회사에서 가장 가치 있는 사람이 되는 비결 한 줄. **"본인이 사고 났을 때 침착한 사람."** 다른 사람들이 당황할 때 본인이 한 줄로 진단하고 한 줄로 처방하면 본인 가치가 다섯 배. 그 침착함은 타고나는 게 아니에요. 오늘처럼 한 번씩 들어 둔 다섯 사고가 본인을 침착하게 만들어요. 좋은 엔지니어와 위대한 엔지니어의 차이도 한 줄. **"사고 났을 때 가장 먼저 손이 가는 명령이 뭐냐."** 서툰 사람은 reboot 부터. 좋은 사람은 진단부터. 위대한 사람은 사후 보고서까지. 본인은 오늘 가운데 자리에 들어왔어요.

오늘 들은 다섯 사고 다섯 처방을 본인 일기장에 한 페이지 적어 두세요. 좀비 → 부모 처리, OOM → 메모리 사냥, 디스크 풀 → du -sh /*, 네트워크 → 7 다리, CPU → renice 또는 kill. 다섯 줄. 그 한 페이지가 두 해 후 책상 위에 붙어 있으면 새벽 사고 만났을 때 가장 먼저 보는 자리. 본인 ~/myscripts 에는 오늘 emergency.sh 의 첫 30줄도 같이 적어 두세요(8번 절 그대로). chmod +x 한 번. 본인 도구 가족이 sysinfo + procmon + emergency 셋. 챕터 하나에 도구 셋씩이면 두 해 후 ~360 명의 도구 가족. 본인의 진짜 자산.

5분 쉬고 H7(kernel) + H8(적용+회고) 마지막 두 발 같이 가요. 진심으로 박수. 본인 자신에게.
