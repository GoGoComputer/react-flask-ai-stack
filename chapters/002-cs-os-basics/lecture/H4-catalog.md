# H4 · 운영체제 기본 — 명령어 카탈로그 (프로세스 도구)

> 고양이 자경단 · Ch 002 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 두 시간(H3) 회수 + 4교시 약속
2. 호텔 매니저(OS)의 손에 잡히는 도구 13개
3. 카탈로그 한 장 — 13개 명령 한 표
4. ps — 프로세스 명함 보기
5. ps 옵션 5형제 — `-e` `-f` `-u` `-x` `aux`
6. top — 호텔 로비의 실시간 전광판
7. htop — top 의 컬러 형제 (선택)
8. kill — 호텔 매니저의 종료 신호
9. 신호(signal) 7대표 — TERM·KILL·HUP·INT·STOP·CONT·USR1
10. killall · pkill — 이름으로 한꺼번에
11. jobs · bg · fg — 본인 셸의 일감 관리
12. nohup · disown · `&` — 셸을 닫아도 살아남기
13. wait · `$!` `$$` `$?` — 부모 프로세스의 손
14. pgrep · pidof — PID 찾는 두 명령
15. 실전 시나리오 7개 (멈춘 vim / 좀비 / CPU 100% / 메모리 새는 노드 / 백그라운드 빌드 / nohup 서버 / 자식 wait)
16. 5분 손풀기 — 본인 맥에서 한 번씩
17. 위험 명령 5종 — kill -9 1 등 절대 금지
18. macOS vs Linux 명령 차이표
19. FAQ 5
20. 흔한 실수 다섯 가지 + 안심 멘트 — 명령어 학습 편
21. 마무리 — H5 osinfo.sh로
👨‍💻 개발자 노트

---

## 🔧 강사용 명령어 한눈에

```bash
# 4. ps — 명함 보기
ps                                  # 본인 셸 자식만 (3~5줄)
ps -e | head                        # 전체 PID·TTY·TIME·CMD
ps -ef | head                       # +UID +PPID +시작시각

# 5. ps 옵션 5형제
ps aux | head                       # BSD 스타일 (USER·%CPU·%MEM·VSZ·RSS·TTY·STAT·START·TIME·COMMAND)
ps -u $USER                         # 특정 사용자
ps -x                               # 터미널 없는 것까지
ps -p 1                             # 특정 PID
ps -o pid,ppid,user,%cpu,%mem,comm  # 원하는 열만

# 6. top
top                                 # 인터랙티브 (q 종료)
top -l 1 | head -20                 # 한 번만 캡처

# 7. htop (brew install htop)
htop                                # F10/q 종료

# 8~9. kill + signals
kill PID                            # SIGTERM (15) 정중히
kill -9 PID                         # SIGKILL 강제
kill -1 PID                         # SIGHUP 설정 다시 읽기
kill -l                             # 신호 목록
kill -STOP PID; kill -CONT PID      # 일시정지·재개

# 10. killall / pkill
killall Safari                      # 이름 정확히
pkill -f "node server.js"           # 명령 부분 일치
pgrep -fl python                    # 찾기만

# 11. jobs / bg / fg
sleep 100 &                         # 백그라운드
jobs                                # [1]+ Running
fg %1                               # 전경으로
Ctrl+Z                              # 일시정지(SIGTSTP)
bg %1                               # 다시 백그라운드

# 12. nohup / disown / &
nohup python server.py > out.log 2>&1 &   # 셸 닫아도 살아남기
disown %1                           # 현재 작업을 셸 작업표에서 떼기

# 13. 부모 프로세스 변수
echo $$                             # 현재 셸 PID
echo $!                             # 마지막 백그라운드 PID
echo $?                             # 마지막 종료 코드
wait                                # 모든 자식 끝날 때까지

# 14. pgrep / pidof (Linux)
pgrep -l zsh
pgrep -u $USER -f node
```

> ⚠️ 절대 금지: `kill -9 1`(PID 1), `killall -9 kernel_task`, `pkill -9 -1` (모든 프로세스). 본인 맥 죽어요.

---

## 1. 들어가며 — 두 시간 회수 + 4교시 약속

자, 두 분이 잘 견뎌 주셨어요. 4교시예요. 본인의 8시간 약속의 절반이 이제 끝나가요. 정확히 50%. 본인 진짜 잘 오고 계세요. 잠깐 박수. 짝짝짝.

지난 한 시간(H3)에 우리가 뭘 했냐면. 본인 호텔 매니저(OS) 의 신분증을 한 장 받았어요. uname·sw_vers·sysctl·hostname·id·env·ulimit. 일곱 명령. 본인 맥 한 명의 매니저가 누군지 알게 됐어요. Darwin 24.1.0 / arm64 / 본인 사용자 이름 / 본인 그룹 / 본인 PATH. 한 시간 만에 그 매니저의 명함이 본인 손에 들어왔어요.

이제 4교시. **그 매니저가 손에 든 도구들을 본인이 빌려 보는 시간.** 지금까지 우리가 매니저(OS)·호텔 방(프로세스)·방 안의 사람(스레드) 비유로만 얘기했죠. 이제 진짜로 그 호텔 방들을 본인이 직접 들여다보는 시간이에요. 어떤 방이 켜져 있나, 누가 거기 있나, CPU·메모리를 얼마나 쓰나, 한 방을 닫으려면 어떤 신호를 보내야 하나. 그리고 본인 셸에서 일감 한 개를 백그라운드로 돌리고, 셸을 닫아도 그 일감이 살아남게 하려면 뭘 쳐야 하나. 60분 동안 명령 13개. 한 명령씩 한 시간 손에 익혀요.

오늘 약속 한 줄. **"4교시 끝나면 본인이 한 시간 후 호텔 방 13개 도구를 손에 들고 있다."** 그게 약속이에요. 다음 한 시간(H5) 에서 우리는 이 13개를 묶어서 한 개의 셸 스크립트(procmon.sh) 로 만들어요. 그러니까 오늘 한 시간이 다음 시간의 재료에요. 한 명령도 빼먹지 마시고 같이 가요.

한 가지 더. 본인이 두 시간 전(H2) 에 본 4가지 손길 — 프로세스·스레드·파일·시스템 콜. 그 중에 오늘은 **프로세스** 하나에 집중해요. 스레드는 너무 깊은 주제라 두 해 후 다시. 파일은 H6 에서. 시스템 콜은 H7 에서. 오늘은 호텔 방(프로세스) 하나만. 한 개념을 한 시간 손에 익히는 게 두 해 코스 페이스의 핵심이에요. 욕심 안 부려요. 한 개념, 13개 명령. 그게 다예요.

그럼 가요. 본인 손이 키보드 위에 있으면 좋아요. 한 명령 한 명령 같이 쳐 보면서 가요.

## 2. 호텔 매니저의 손에 잡히는 도구 13개

자, 큰 그림 한 번. 본인 OS 매니저(macOS Darwin) 가 손에 든 도구가 진짜 많아요. 1500~2000 개의 명령이 본인 맥에 깔려 있어요. 그 중에 **프로세스 다루는 명령** 만 모은 거예요 오늘. 13개. 진짜 자주 쓰는 거. 두 해 후 본인이 매일 100번씩 치는 거. 그 13개.

13개를 4가지 손길로 묶어볼게요.

**손길 1 — 보기(관찰).** ps · top · htop · pgrep · pidof. 어떤 방이 켜져 있나, 누가 무엇을 하고 있나. 5개.

**손길 2 — 닫기(종료).** kill · killall · pkill. 한 방의 손님에게 "나가 주세요" 신호 보내기. 3개.

**손길 3 — 일감 관리.** jobs · bg · fg. 본인 셸 안의 일감들을 앞·뒤로 옮기기. 3개.

**손길 4 — 셸 너머 살리기.** nohup · disown · `&` · wait. 본인이 셸을 닫아도 살아남게 하기. 4개. (`&` 도 한 명령으로 셀게요. 13개 셈에서)

세어 봐요. 5 + 3 + 3 + 4 = 15. 어 15네. 13이라 했는데. 솔직하게 정정. 손에 익힐 게 13~15개. 숫자보다 중요한 건 **4가지 손길**. 13~15개 명령이 4가지 손길 안에 다 들어가요. 4가지 손길만 머리에 두면 명령은 그 가족 안에서 자연스럽게 외워져요.

그리고 한 가지 보너스 — 부모 프로세스의 손. `$$` `$!` `$?` 세 변수. 명령이 아니라 본인 셸의 비밀 변수에요. 그것까지 합치면 18개. 60분 동안 18개. 한 개당 3.3분. 그게 오늘 페이스에요. 한 명령씩 천천히. 가요.

## 3. 카탈로그 한 장 — 18개 명령 한 표

본인이 머리에 한 장의 표로 두면 좋아요. 두 해 후 까먹어도 이 표 하나만 펴 보면 90% 다시 살아나요.

| 손길 | 명령 | 한 줄 의미 | 첫 옵션 |
|------|------|-----------|--------|
| 보기 | `ps` | 프로세스 명함 | `-ef`, `aux` |
| 보기 | `top` | 실시간 전광판 | `-l 1` (1회 캡처) |
| 보기 | `htop` | 컬러 top | `-u` (사용자 필터) |
| 보기 | `pgrep` | PID 찾기 (이름) | `-fl` |
| 보기 | `pidof` | PID 찾기 (Linux) | (옵션 거의 없음) |
| 닫기 | `kill` | 신호 보내기 | `-9`, `-1`, `-l` |
| 닫기 | `killall` | 이름으로 한꺼번에 | `-9` |
| 닫기 | `pkill` | 패턴으로 한꺼번에 | `-f`, `-u` |
| 일감 | `jobs` | 본인 셸 작업 목록 | `-l` |
| 일감 | `bg` | 백그라운드로 | `%1` |
| 일감 | `fg` | 전경으로 | `%1` |
| 살리기 | `&` | 즉시 백그라운드 | (명령 끝에) |
| 살리기 | `nohup` | HUP 무시 | `> out.log 2>&1 &` |
| 살리기 | `disown` | 셸에서 떼기 | `%1`, `-h` |
| 살리기 | `wait` | 자식 끝나길 기다림 | `wait $!` |
| 변수 | `$$` | 현재 셸 PID | — |
| 변수 | `$!` | 마지막 백그라운드 PID | — |
| 변수 | `$?` | 마지막 종료 코드 | — |

이 표 한 장. 이게 4교시 전체에요. 본인이 한 시간 후 이 표를 보고 "아 이거 다 한 번씩 쳐 봤지" 하시면 4교시 합격이에요.

자 한 명령씩 들어가요.

## 4. ps — 프로세스 명함 보기

**ps.** Process Status 의 줄임말. 1979년 V7 Unix 에서 처음 등장. 47년 된 명령. 본인이 오늘 치는 한 글자 한 글자가 47년의 역사예요.

기본 ps 한 줄.

> ▶ **같이 쳐보기** — 가장 단순한 ps 한 줄
>
> ```bash
> ps
> #   PID TTY           TIME CMD
> # 12345 ttys001    0:00.05 -zsh
> # 67890 ttys001    0:00.01 ps
> ```

뭐가 보이냐. 본인 현재 셸(zsh) 과 본인이 방금 친 ps 명령 자체. 두 줄. 본인 현재 터미널의 자식들만. 진짜 좁은 시야.

본인이 진짜 보고 싶은 건 호텔 전체 방. 그러려면 옵션 가족.

> ▶ **같이 쳐보기** — 호텔 전체 방 보기 (3가지 표기)
>
> ```bash
> ps -e | head        # -e: 전체 (every)
> ps -ef | head       # -ef: 전체 + full format
> ps aux | head       # BSD 스타일 (대시 없음) ← 매일 만 번 칠 줄
> ```

세 가지 표기가 있어요. `-e` 와 `-ef` 는 System V 스타일. `aux` 는 BSD 스타일. macOS 는 BSD 출신이라 `aux` 가 가장 자연. Linux 는 둘 다 됨. 본인이 오늘 머리에 둘 한 줄. **`ps aux | head`.** 이 한 줄이 본인이 두 해 동안 만 번 칠 줄.

`ps aux` 의 출력 11개 열을 한 번씩 짚어 볼게요.

```
USER  PID  %CPU  %MEM  VSZ  RSS  TTY  STAT  START  TIME  COMMAND
mo    501  0.5   0.2   1.5G 50M  ?    Ss    9:00am 0:01  /usr/bin/python
```

1. **USER** — 누구의 프로세스. 본인 사용자 이름.
2. **PID** — 호텔 방 번호. H2 에서 본 그 번호.
3. **%CPU** — CPU 점유율. 0~100% (멀티코어면 100% 넘을 수도).
4. **%MEM** — 메모리 점유율 (전체 RAM 대비).
5. **VSZ** — 가상 메모리 크기 (Virtual Size). 약속된 양.
6. **RSS** — 진짜 메모리 크기 (Resident Set Size). 실제 RAM 차지.
7. **TTY** — 어느 터미널에서 시작됐나. `?` 면 백그라운드.
8. **STAT** — 상태 문자. H2 에서 본 R·S·T·Z·I 가 여기 나와요!
9. **START** — 시작 시각.
10. **TIME** — 누적 CPU 사용 시간.
11. **COMMAND** — 어떤 명령으로 시작됐나.

11개 중에 본인이 매일 보는 건 **PID·%CPU·%MEM·STAT·COMMAND** 다섯 개. 다른 6개는 가끔. 다섯 개만 머리에 두세요.

특히 STAT 가 진짜 중요해요. H2 에서 외운 5상태가 정확히 여기 한 글자로 나옴.

- **R** Running 또는 Runnable. 일하는 중.
- **S** Sleeping. 자는 중. 인터럽트 가능.
- **T** STopped. 일시정지(Ctrl+Z 같은 걸로).
- **Z** Zombie. 죽었는데 부모가 아직 안 거둠.
- **I** Idle. 오래 자는 중.

그리고 STAT 뒤에 한 글자가 더 붙을 수 있어요. `Ss` 의 두 번째 `s` 는 세션 리더, `R+` 의 `+` 는 전경 그룹, `S<` 의 `<` 는 우선순위 높음. 부가 표시. 첫 글자만 외우세요. 둘째 글자는 두 해 후 만나도 돼요.

**한 번 본인 맥에서 한 줄.**

```bash
ps aux | grep python | grep -v grep
```

본인 맥에 파이썬이 떠 있나. 떠 있으면 한 줄, 없으면 빈 줄. 본인 시스템의 진짜 모습.

ps 의 진짜 가치 — **PID 한 개를 알면 그 다음 모든 명령이 가능해요.** kill 도 PID 가 필요. top -p 도 PID. 이 PID 찾는 첫 단계가 ps. 그래서 ps 가 카탈로그의 1번이에요.

## 5. ps 옵션 5형제 — 매일 치는 다섯 변형

ps 옵션이 진짜 많아요. 30~40 개. 그 중 본인이 매일 쓰는 다섯 가지만.

### 5.1 `ps aux` — 전체 보기

```bash
ps aux | head
ps aux | wc -l       # 본인 맥의 전체 프로세스 수
```

본인 맥은 보통 400~800 개. Linux 서버는 100~300 개. 본인 맥이 많은 이유는 GUI 데스크탑 앱들 때문.

### 5.2 `ps -u $USER` — 본인 것만

```bash
ps -u $USER | wc -l   # 본인이 띄운 프로세스 수
ps -u $USER | head
```

본인이 띄운 것만. 보통 50~150 개. (브라우저·VS Code·터미널 등)

### 5.3 `ps -p PID` — 특정 PID

```bash
ps -p 1                          # PID 1 (launchd)
ps -p $$                          # 현재 셸 자체
ps -p $$,1                        # 둘 다
```

`$$` 는 현재 셸의 PID. 매직 변수. 곧 13번 절에서 다시.

### 5.4 `ps -ef --forest` (Linux) / `pstree` — 가족 나무

macOS 에선 기본 `pstree` 가 없어요. `brew install pstree` 로 받거나, ps 에 `-O ppid` 추가해서 부모 자식을 같이 봐요.

```bash
brew install pstree
pstree -p 1            # 호텔 전체 가족 나무
pstree -u $USER        # 본인 가족 나무
```

본인 맥에서 PID 1 부터 가지가 뻗어 나가는 그림. H2 에서 본 호텔 방 가족 나무가 진짜로 한 그림으로 보여요. 시각적으로 한 번 보면 평생 안 잊혀요. 한 번 깔아 보세요. 5분.

### 5.5 `ps -o ...` — 원하는 열만 골라보기

```bash
ps -o pid,ppid,user,%cpu,%mem,comm -u $USER | sort -k4 -nr | head
```

이 한 줄. 본인 사용자의 프로세스를 CPU 순으로 정렬해서 상위 10개. 두 해 후 본인이 진짜 자주 칠 줄.

ps 옵션 5형제 끝. 일곱 분의 한 시간 중 7분 썼어요. 한 시간 페이스 잘 가고 있어요.

## 6. top — 호텔 로비의 실시간 전광판

ps 가 한 번의 스냅샷이면, **top** 은 실시간 영상이에요. 1984년 BSD 에서 처음 등장. 42년 된 명령. ps 뒤에 5년 늦게 태어난 동생.

> ▶ **같이 쳐보기** — 호텔 로비 실시간 전광판 (q 로 나오기)
>
> ```bash
> top
> ```

한 번 쳐 보세요. 화면이 가득 차요. 위에 5~7줄의 요약, 아래에 프로세스 목록이 1초마다 갱신. q 누르면 나가요.

상단 요약을 한 줄씩 풀어 봐요 (macOS top 기준).

```
Processes: 412 total, 3 running, 409 sleeping, 1893 threads
2026/04/26 14:00:00
Load Avg: 1.20, 1.50, 1.80
CPU usage: 5.0% user, 2.5% sys, 92.5% idle
SharedLibs: 300M resident, 50M data
MemRegions: 50000 total, 5G resident
PhysMem: 16G used (1G wired), 256M unused
VM: 1500G vsize, 1500M framework vsize
Networks: packets: 1M/100M in, 500K/50M out
Disks: 100K/2G read, 50K/1G written
```

엄청 많죠. 본인이 매일 보는 건 두 줄.

1. **Processes:** — 호텔 방 수. 412 total / 3 running. 412개 방 중 진짜 일하는 건 3개. 나머지는 자고 있어요. 대부분 시간이 자는 거예요. CPU 가 한가한 게 정상.

2. **Load Avg: 1.20, 1.50, 1.80** — 세 숫자. 1분/5분/15분 평균 부하. 본인 CPU 코어 수랑 비교해요. 본인 맥이 8코어면 8 이상이 위험. 본인 맥이 8코어면 1.20 은 평소.

이 두 줄만 매일 봐요. 다른 8 줄은 가끔.

하단 프로세스 목록도 ps 와 비슷한 11개 열. 본인이 보는 건 **PID·CPU%·MEM·COMMAND**. 그리고 1초마다 갱신.

**top 의 인터랙티브 키 5개.**

- `q` 종료
- `?` 도움말
- `o cpu` CPU 순 정렬
- `o rsize` 메모리 순 정렬
- `Ctrl+C` 도 q 와 같음

본인이 한 줄로 한 번 캡처할 수도 있어요.

```bash
top -l 1 | head -20    # macOS: -l 1 은 1회 캡처
```

이게 본인 셸 스크립트에 넣을 수 있는 형태. H5 에서 다시 봐요.

## 7. htop — top 의 컬러 형제 (선택사항)

**htop.** 2004년에 어떤 학생이 만든 도구. top 이 답답해서 만든 거예요. 컬러도 있고, 화살표로 프로세스 선택할 수 있고, F-키로 정렬·필터·종료. 더 친절.

```bash
brew install htop
htop
```

기본은 안 깔려 있어서 본인이 brew 로 받아야 돼요. 5분.

화면 위에 8개 코어의 막대 그래프 (CPU 마다 한 줄), 메모리·스왑 막대, 그리고 아래에 프로세스 목록. F1~F10 단축키.

- F3 검색
- F4 필터
- F5 트리(가족 나무) 모드
- F6 정렬
- F9 종료(kill)
- F10 나가기

본인이 한 번 깔아 보고 마음에 들면 매일 쓰세요. macOS top 보다 훨씬 보기 좋아요. 두 해 후 본인이 서버 진단할 때도 진짜 자주 쓸 도구. 그래도 모든 서버에 깔려 있는 건 아니라서 top 도 알아야 해요. 두 명령 다 손에.

## 8. kill — 호텔 매니저의 종료 신호

자, 보기는 5명령 끝. 이제 **닫기.** kill·killall·pkill 세 명령. 본인 인생에서 진짜 자주 칠 명령이에요. "이 앱이 안 죽어!" 하는 순간이 두 해 동안 100번은 와요. 그때마다 kill.

먼저 한 가지 명확하게. **kill 은 "죽인다"는 뜻이 아니에요.** kill 은 **신호(signal) 를 보낸다** 는 뜻이에요. 신호를 받은 프로세스가 어떻게 행동할지는 그 프로세스가 결정해요. 대부분의 신호는 "정중히 끝내 주세요" 의미. 강제로 죽이는 건 SIGKILL (-9) 한 가지.

> ▶ **같이 쳐보기** — kill 4가지 패턴 (PID 자리는 본인의 PID로)
>
> ```bash
> kill PID         # 기본은 SIGTERM (신호 15) — 정중히 종료
> kill -9 PID      # SIGKILL — 강제 (안 죽으면)
> kill -1 PID      # SIGHUP — 설정 다시 읽기
> kill -l          # 신호 목록 (30~64 개)
> ```

본인이 매일 치는 건 첫 두 줄. **kill PID 먼저, 5초 후에도 살아 있으면 kill -9 PID.** 이게 매너에요. 처음부터 -9 보내면 그 프로세스가 정리(파일 닫기, 임시 파일 지우기, 데이터 저장 등) 할 시간을 뺏어요. 데이터 손실의 원인. -9 는 진짜 마지막 수단.

신호 14개를 다 외울 필요 없어요. 7개만.

## 9. 신호 7대표 — TERM·KILL·HUP·INT·STOP·CONT·USR1

이 표 한 번 머리에.

| 번호 | 이름 | 한 줄 | 본인이 칠 때 |
|------|------|------|------------|
| 1 | SIGHUP | 끊김 (HangUP) | 설정 reload |
| 2 | SIGINT | 인터럽트 (Ctrl+C) | 터미널 |
| 9 | SIGKILL | 강제 종료 (catchable 안 됨) | 마지막 수단 |
| 15 | SIGTERM | 정중한 종료 (기본) | 보통 |
| 17/19 | SIGSTOP | 일시정지 (Ctrl+Z 의 친척) | 거의 안 침 |
| 18/20 | SIGCONT | 재개 | 거의 안 침 |
| 30 | SIGUSR1 | 사용자 신호 1 | 앱별로 정의 |

번호가 OS 별로 조금 달라요 (macOS BSD vs Linux). 본인이 외우기 좋은 건 이름. `kill -TERM PID` 처럼 이름으로 보내면 OS 가 알아서 번호 변환.

**Ctrl+C 와 SIGINT 의 비밀.** 본인이 터미널에서 Ctrl+C 누르는 거. 그게 정확히 `kill -INT $$` (현재 전경 프로세스에 SIGINT) 와 같아요. Ctrl+Z 는 SIGTSTP. Ctrl+\ 는 SIGQUIT. 단축키 세 개가 사실 신호 세 개. 본인이 매일 치는 단축키의 진짜 정체.

**SIGKILL 의 진짜 무서운 점.** 9번 신호는 프로세스가 거부하지 못 해요. 다른 신호들은 프로세스가 "신호 핸들러" 라는 함수를 등록해서 가로챌 수 있어요. SIGTERM 받으면 "잠깐, 데이터 저장하고 갈게요" 하면서 정리. 그런데 SIGKILL 은 OS 커널이 프로세스를 즉사시켜요. 정리할 시간 0초. 그래서 데이터 손실 위험. 진짜 마지막 수단.

**예외 — SIGKILL 을 막을 수 있는 한 가지.** 좀비(Z) 와 D 상태(Disk wait, uninterruptible sleep) 의 프로세스는 SIGKILL 도 안 통해요. 그땐 부모를 처리하거나 (좀비) 디스크 I/O 가 끝날 때까지 기다려요 (D). 두 해 후 만나는 진짜 어려운 사례. 오늘은 이름만.

## 10. killall · pkill — 이름으로 한꺼번에

PID 모르고 이름만 알면.

```bash
killall Safari               # macOS: 정확한 이름 매치
killall -9 Safari            # 강제

pkill -f "node server.js"    # 명령 부분 일치
pkill -u $USER node          # 본인 사용자의 node 만
```

`killall` 은 정확한 매치. macOS Safari, Linux firefox 같은 짧은 이름.

`pkill` 은 더 유연. `-f` 옵션은 전체 명령줄을 검사해요. `node server.js` 처럼 인자 포함해서. 두 해 후 본인이 진짜 자주 쓰는 건 pkill `-f` 패턴. 한 번 외워두세요.

**찾기만 (kill 안 함):** `pgrep`.

```bash
pgrep -fl "node server.js"   # 매치되는 PID + 명령 보여주기
pgrep -u $USER -fl python    # 본인 사용자의 python 들
```

`pkill` 치기 전에 항상 `pgrep` 으로 한 번 확인하는 습관. **잘못된 패턴으로 pkill 치면 본인 셸까지 죽어요.** 예를 들어 `pkill -f sh` 하면 본인의 zsh 도 sh 로 끝나는 패턴이라 죽을 수 있음. 항상 pgrep 으로 먼저 확인. 안전 패턴.

## 11. jobs · bg · fg — 본인 셸의 일감 관리

**일감(job).** 본인 셸이 시작한 자식 프로세스 중에 본인 셸이 추적하고 있는 것. 셸의 작업표(job table) 라는 작은 표에 들어 있어요.

세 가지 상태.

1. **전경(foreground).** 본인이 키보드를 받음. 한 셸에 한 개만.
2. **백그라운드(background).** 동작은 하는데 본인 키보드는 셸로 돌아와 있음. 여러 개 가능.
3. **정지(stopped).** Ctrl+Z 로 멈춰 둔 상태.

명령 흐름.

```bash
sleep 100              # 전경: 100초 동안 본인 키보드 잠김
                       # Ctrl+C 누르면 죽음
                       # Ctrl+Z 누르면 멈춤(정지)

sleep 100 &            # 백그라운드: 즉시 셸 돌아옴
                       # [1] 12345  ← job 번호 1, PID 12345
jobs                   # [1]+ Running    sleep 100
fg %1                  # 전경으로 가져옴 (이제 Ctrl+C 로 죽일 수 있음)
Ctrl+Z                 # 정지: [1]+ Stopped
bg %1                  # 정지된 걸 다시 백그라운드로
fg %1                  # 다시 전경으로
```

`%1` 은 job 번호 1번. PID 가 아니에요. 같은 셸 안에서만 의미 있는 번호.

**한 번 따라해 보세요.** 본인 터미널에서.

> ▶ **같이 쳐보기** — 일감 3개 띄우고 2번만 죽이기
>
> ```bash
> sleep 1000 &
> sleep 2000 &
> sleep 3000 &
> jobs
> # [1]   Running    sleep 1000
> # [2]-  Running    sleep 2000
> # [3]+  Running    sleep 3000
> fg %2          # 2번을 전경으로
> Ctrl+C         # 죽이기
> jobs
> # [1]   Running    sleep 1000
> # [3]+  Running    sleep 3000

# 정리
kill %1
kill %3
jobs
# (빈 줄)
```

이걸 한 번 손에 익히면 본인의 셸 안의 일감들이 호텔 방처럼 보여요. 본인이 호텔 매니저예요. 방 1번·2번·3번. 한 방씩 들여다보고 닫고.

`+` 표시는 **현재 작업** (fg/bg 가 인자 없으면 이걸 가리킴), `-` 는 **다음 작업**. 알아두세요.

## 12. nohup · disown · `&` — 셸을 닫아도 살아남기

자 한 가지 큰 문제. 본인이 `sleep 1000 &` 로 백그라운드에 일감 띄웠어요. 본인이 터미널을 닫으면 어떻게 될까요?

**기본은 죽어요.** 본인 셸이 죽을 때 자식들에게 SIGHUP (1번) 신호를 보내요. SIGHUP 의 기본 동작은 종료. 그래서 자식들이 죽음.

근데 본인이 진짜 오래 도는 일감(빌드, 학습, 서버 등)을 띄우고 본인은 노트북을 가지고 카페로 가고 싶어요. 어떻게?

세 가지 방법.

### 12.1 `nohup` — HUP 무시하기

```bash
nohup python long_train.py > train.log 2>&1 &
```

`nohup` (no hangup) 은 자식이 SIGHUP 을 무시하도록 설정. 표준 출력/에러를 파일로 보내야 해요 (`> train.log 2>&1`). 안 그러면 셸이 죽으면 출력할 곳이 없어 에러.

본인 셸 닫혀도 long_train.py 는 살아남아요. 두 해 후 SSH 로 EC2 접속해서 모델 학습 돌릴 때 매일 쓸 패턴.

### 12.2 `disown` — 셸 작업표에서 떼기

```bash
python long_train.py &
disown                  # 또는 disown %1
```

`disown` 은 본인 셸의 작업표(jobs) 에서 그 일감을 빼요. 셸이 죽을 때 SIGHUP 을 보낼 대상 명단에서 제외. 결과는 nohup 과 비슷. 차이는 — disown 은 명령 띄우고 나서 사후에. nohup 은 명령 띄울 때 미리.

```bash
disown -h %1            # -h 는 명단에 두되 HUP 만 안 보냄
```

### 12.3 `tmux` / `screen` — 진짜 정석 (보너스)

진짜 정석은 tmux 나 screen 이라는 터미널 멀티플렉서. 본인 SSH 가 끊겨도 세션이 살아 있어요.

```bash
brew install tmux
tmux new -s training
# (안에서 학습 명령 실행)
# Ctrl+B  D  ← detach (분리)
# 이제 SSH 끊어도 OK

tmux attach -t training  # 다시 붙기
```

오늘은 이름만. 두 해 후 chap 50번대(DevOps) 에서 자세히. 본인이 매일 쓰게 될 도구.

오늘 머리에 둘 한 줄. **"긴 일감은 nohup ... &, 또는 tmux 안에서."** 이 두 패턴이 본인의 두 해 후 일상.

## 13. wait · `$!` `$$` `$?` — 부모 프로세스의 손

본인 셸도 한 개의 프로세스예요. 자식들을 띄우는 부모. 부모로서 손에 둘 변수 세 개 + 명령 한 개.

```bash
echo $$        # 현재 셸 PID
# 12345

sleep 100 &
echo $!        # 마지막 백그라운드 자식 PID
# 67890

ls /존재하지않는폴더
echo $?        # 마지막 명령 종료 코드 (0=성공, 0아님=실패)
# 1
```

**`$$`** — 본인 셸 자체의 PID. ps -p $$ 로 본인 셸 확인할 때 매일.

**`$!`** — 방금 백그라운드로 띄운 자식의 PID. 셸 스크립트에서 자식을 추적할 때 핵심.

**`$?`** — 마지막 명령의 종료 코드. 0 이면 성공, 1~255 면 실패. 두 해 후 본인이 만 번 검사할 변수.

```bash
make build
if [ $? -ne 0 ]; then
  echo "빌드 실패"; exit 1
fi
```

또는 더 짧게.

```bash
make build || { echo "빌드 실패"; exit 1; }
```

**wait — 자식 끝나길 기다리기.**

```bash
long_task1 &     # 자식 1
PID1=$!
long_task2 &     # 자식 2
PID2=$!

wait $PID1       # 자식 1 끝나길 기다림
echo "1 끝, 종료코드 $?"

wait             # 모든 자식 끝나길
echo "모두 끝"
```

H5 에서 만들 procmon.sh 의 핵심 패턴. 두 자식을 병렬로 띄우고 둘 다 끝날 때까지 기다리는 거. 두 해 후 본인이 셸 스크립트 짤 때 매일 쓰는 패턴.

`$$` `$!` `$?` 와 wait. 이 네 가지가 본인 셸의 부모로서의 손이에요. ps·top 이 매니저의 손이라면, 이 넷은 본인 셸의 손. 본인 셸도 매니저(부모) 역할을 해요.

## 14. pgrep · pidof — PID 찾는 두 명령

이미 10번 절에서 잠깐 본 pgrep 한 번 더 정리.

```bash
pgrep -l zsh                 # zsh 프로세스의 PID + 이름
pgrep -fl python             # 패턴 + full 명령줄
pgrep -u $USER -fl node      # 본인 사용자의 node
pgrep -P 12345               # PID 12345 의 자식들 (P 부모)
```

`pidof` 는 Linux 전용. macOS 엔 기본 없음. brew 로도 안 받아져요. macOS 에선 pgrep 만.

```bash
# Linux 에서
pidof nginx                  # nginx 의 모든 PID
```

본인 맥에선 pgrep 한 가지. 두 해 후 EC2 (Linux) 에서 pidof 도 만나요.

PID 찾기 → kill 보내기 패턴. 한 줄로 묶을 수도.

```bash
kill $(pgrep -fl python)     # 모든 python PID 한꺼번에 kill
```

이 패턴 — `$(...)` 로 명령 결과를 다른 명령의 인자로. 유닉스 철학의 진짜 모습. 작은 도구를 묶어서 큰 일.

## 15. 실전 시나리오 7개

이론은 끝. 진짜 본인이 만날 7가지 상황 + 한 줄 처방.

### 15.1 vim 이 멈췄어요 (응답 없음)

```bash
ps aux | grep vim                    # PID 찾기 (예: 12345)
kill 12345                           # 정중히
# (5초 기다리기)
ps -p 12345                          # 아직 살아 있나
kill -9 12345                        # 강제
```

본인 인생에 한 100번은 와요.

### 15.2 좀비 프로세스 발견 (STAT=Z)

```bash
ps aux | awk '$8 ~ /^Z/'             # 좀비만 필터
```

좀비는 SIGKILL 도 안 통해요. **부모를 찾아서 부모를 처리.**

```bash
ps -o pid,ppid,stat,comm -e | grep ' Z'
# PID 12345 PPID 11111 Z
kill -CHLD 11111                     # 부모에게 자식 거두라고 신호
# 안 되면 부모를 죽임 (그러면 좀비도 init 이 거둠)
kill 11111
```

H6 에서 자세히 다시.

### 15.3 어떤 프로세스가 CPU 100% 먹어요

```bash
top -o cpu                           # CPU 순 정렬 (인터랙티브)
# 또는
ps -o pid,user,%cpu,comm -e | sort -k3 -nr | head
```

상위 5개 보고 그 중에 죽여도 되는 거 골라서 kill.

### 15.4 메모리 새는 노드 서버

```bash
ps -o pid,user,%mem,rss,comm -e | sort -k3 -nr | head
# 본인 node server.js 가 RSS 5G 잡고 있다 보면
pkill -f "node server.js"
# 다시 띄우기 (이번엔 nohup 으로)
nohup node server.js > server.log 2>&1 &
```

### 15.5 백그라운드 빌드 진행 확인

```bash
make build > build.log 2>&1 &
JOB=$!                               # PID 저장
# 잠깐 다른 일 하다가
ps -p $JOB                           # 아직 살아 있나
tail -f build.log                    # 진행 상황 보기 (Ctrl+C 로 나옴)
wait $JOB                            # 끝날 때까지
echo "빌드 종료코드: $?"
```

### 15.6 nohup 으로 서버 띄우고 나갔다가 돌아옴

```bash
nohup python server.py > server.log 2>&1 &
echo "서버 PID: $!"
# (셸 닫고 카페로)
# (돌아옴)
pgrep -fl "python server.py"
# PID 12345 / python server.py
tail -f server.log
```

### 15.7 자식이 실패하면 부모도 실패하기 (셸 스크립트)

```bash
#!/usr/bin/env bash
set -e                               # 어느 명령이든 실패하면 즉시 종료
make build
make test
make deploy
echo "전부 성공"
```

`set -e` 는 본인 셸 스크립트의 첫 줄이에요. 거의 무조건. 두 해 후 본인이 만들 모든 .sh 파일의 두 번째 줄.

7가지 시나리오. 하나하나가 본인이 두 해 동안 만 번 만날 상황. 오늘 머리에 한 번씩 들어왔어요. 그게 4교시의 진짜 결과.

## 16. 5분 손풀기 — 본인 맥에서 한 번씩

자, 이론 끝. 5분만 본인 손이 키보드에서 직접. 한 줄씩 같이 쳐 봐요.

```bash
# 1. 본인 셸 PID 알기
echo $$

# 2. 본인 사용자의 프로세스 수
ps -u $USER | wc -l

# 3. CPU 상위 5개
ps -o pid,user,%cpu,comm -e | sort -k3 -nr | head -6

# 4. 메모리 상위 5개
ps -o pid,user,%mem,comm -e | sort -k3 -nr | head -6

# 5. sleep 백그라운드 → jobs → fg → Ctrl+C
sleep 100 &
jobs
fg %1
# Ctrl+C

# 6. nohup 한 번
nohup sleep 200 > /tmp/sleep.log 2>&1 &
echo "sleep PID: $!"
disown -h %1
ps -p $!

# 7. top 한 번 (q 로 나오기)
top -l 1 | head -10
```

이 7개 명령을 본인이 진짜 손에 쳐 보면 4교시 합격이에요. 5분이에요. 잠깐 멈추시고 한 번씩.

(본인이 진짜 쳐 보셨다 가정하고 계속)

## 17. 위험 명령 5종 — 절대 금지 (또는 진짜 신중)

호텔 매니저의 도구는 강력한 만큼 위험해요. 한 줄에 본인 맥이 죽을 수 있어요. 5가지 절대 금지/신중.

### 17.1 `kill -9 1` — 절대 금지

PID 1 은 launchd (macOS) 또는 init/systemd (Linux). H2 에서 본 호텔 가족 나무의 뿌리. 이거 죽이면 호텔 전체가 무너져요. macOS 는 보통 권한 거부, Linux 는 root 면 진짜 죽음. **절대 치지 마세요.**

### 17.2 `pkill -9 -1` (Linux) — 모든 프로세스 죽이기

`-1` 은 PID 1 이상 모든 프로세스. 본인 셸까지 포함. 본인 시스템이 즉시 멈춰요. 절대 금지.

### 17.3 `killall -9 kernel_task` (macOS) — kernel 프로세스

kernel_task 는 가짜 프로세스 (사실 커널 자체). macOS 가 막아 주긴 하는데 절대 시도 마세요.

### 17.4 `kill -9 PID` 를 첫 시도로

데이터 손실 위험. 항상 `kill PID` 먼저, 5~10초 기다린 후에 -9.

### 17.5 `pkill -f "흔한 패턴"` — 본인 셸까지 죽일 수도

예: `pkill -f sh` 하면 본인 zsh 도 sh 로 끝나서 매치. 본인 터미널이 즉사. 항상 `pgrep -fl "패턴"` 으로 먼저 확인.

이 5종을 머리에 두고 안 하면 본인 맥은 안전해요.

## 18. macOS vs Linux 명령 차이표

| 일 | macOS | Linux | 비고 |
|----|-------|-------|------|
| 프로세스 보기 | `ps aux` | `ps aux` | 같음 (BSD 호환) |
| 프로세스 보기 | `ps -ef` | `ps -ef` | 같음 |
| 실시간 | `top` (BSD) | `top` (procps) | 옵션 약간 다름 |
| 컬러 top | `htop` (brew) | `htop` (apt) | 같음 |
| 한 번 캡처 | `top -l 1` | `top -b -n 1` | **다름** |
| 가족 나무 | `pstree` (brew) | `pstree` (기본) | 같음 |
| PID 찾기 | `pgrep` | `pgrep`, `pidof` | pidof 는 Linux 만 |
| 신호 | `kill -TERM` | `kill -TERM` | 번호 일부 다름 |
| 사용자별 | `ps -u user` | `ps -u user` | 같음 |
| 우선순위 | `nice` `renice` | `nice` `renice` | 같음 |
| 한도 | `ulimit` | `ulimit`, `prlimit` | prlimit 는 Linux |

겹치는 게 80%. macOS 에서 손에 익으면 Linux 에서 거의 그대로. 두 해 후 EC2(Linux) 가도 처음부터 손이 익어 있어요. macOS 가 BSD 출신이라 받은 큰 선물.

특히 `top -l 1` (macOS) vs `top -b -n 1` (Linux). 이 한 줄이 셸 스크립트 짤 때 OS 분기를 만드는 자리. H5 에서 만들 procmon.sh 가 정확히 이 분기를 가져요. 미리 머리에.

## 19. FAQ 5

**Q1. ps 와 top 의 차이는?**
A. ps 는 한 번의 사진. top 은 영상. 진단 빠르게 = ps. 추세 보기 = top. 보통 ps 로 의심 PID 찾고, top 으로 그 PID 만 추적 (`top -p PID`).

**Q2. kill 했는데 안 죽어요.**
A. 세 가지 가능성. (1) 권한 부족 (sudo 필요). (2) 좀비(Z) — 부모 처리. (3) D 상태(디스크 wait) — 디스크 I/O 끝나길 기다림. (1) 만 sudo kill -9 PID. (2)(3) 은 H6 에서.

**Q3. nohup 과 disown 차이?**
A. nohup 은 사전(命令 띄울 때). disown 은 사후(이미 띄운 일감). 결과는 비슷 (셸 닫혀도 살아남음). 본인이 까먹고 그냥 `&` 로 띄웠으면 disown, 미리 안 까먹었으면 nohup.

**Q4. PID 가 매번 달라요.**
A. 맞아요. PID 는 한 번 쓰고 버려요. 같은 프로그램을 두 번 띄우면 PID 두 개. 같은 프로그램을 죽였다 다시 띄우면 또 다른 PID. 그래서 셸 스크립트에서 PID 를 변수에 저장 (`PID=$!`) 한 후에 그 변수 사용. PID 를 코드에 하드코딩 절대 금지.

**Q5. top 의 load average 가 본인 코어 수보다 크면?**
A. CPU 가 일을 다 못 따라잡고 있다는 뜻. 본인 8코어 맥의 load avg 가 12 면 4 만큼 일이 밀려 있는 거예요. 가끔 1~2 분 정도 그러는 건 OK (피크). 5~15분 평균이 코어 수보다 계속 크면 본인 시스템이 진짜 부하 받는 중. 두 해 후 서버 운영할 때 매일 보는 숫자.

## 20. 흔한 실수 다섯 가지 + 안심 멘트 — 명령어 학습 편

오늘 명령 18개 만났어요. 본인이 자주 빠지는 함정 다섯을 짚고 가요.

첫 번째 함정, 18개를 다 외우려고 한다. 너무 많아요. 안심하세요. **매일 치는 건 5개예요.** ps·top·kill·&·$?. 이 다섯이 80%. 나머지 13개는 평생 검색이에요. myinfo·mytop alias로 묶어서 손에 익히세요. 외우는 게 아니라 자주 만나는 거.

두 번째 함정, kill -9 부터 친다. 본인이 짜증나서 첫 카드로 -9. 안심하세요. **TERM 먼저, 5초 후 -9.** Ch001 H6에서 약속한 그 사슬. 데이터 손상 막아요. -9는 마지막 카드. 본인 데이터가 본인 짜증보다 비싸요.

세 번째 함정, pkill 패턴을 너무 넓게 한다. `pkill -f node` 하면 모든 node 프로세스 다 죽어요. 본인 백엔드만 죽이려 했는데 시스템 데몬도 함께. 안심하세요, 함정 풀이부터. **pgrep으로 먼저 확인.** `pgrep -fl node` 한 번 보고 패턴 좁히기. mykill 함수 (§20 추신 셋)가 그 안전장치. 한 단계 더 가는 게 큰 사고 막아요.

네 번째 함정, 백그라운드 명령에 nohup 안 붙임. 본인이 `node server.js &`만 치고 셸 닫음. 셸 닫는 순간 SIGHUP이 자식 프로세스에. server 죽음. 안심하세요. **셸 닫을 거면 nohup + & 두 단어.** `nohup node server.js > /var/log/app.log 2>&1 &`. 셸 닫아도 살아남음. 두 해 후 본인이 SSH로 EC2 들어가서 백그라운드 명령 칠 때 매번 만나는 패턴.

다섯 번째 함정, 가장 큰 함정. **명령 결과를 안 확인하고 다음 명령으로 넘어간다.** 본인이 `kill 12345` 친 후에 진짜 죽었는지 확인 안 함. 안심하세요, 진실 풀이부터. **항상 ps·pgrep으로 결과 확인.** 또는 `$?` 변수로 종료 코드 보기. 0 = 성공, 0 아님 = 실패. 명령 한 줄 친 후 한 번씩 자문. "이게 진짜 됐나?" 그 자문이 두 해 후 운영 챕터의 모든 응급 처치의 핵심 자세. 명령 친 사람과 명령 결과 확인한 사람의 차이가 운영자의 진짜 차이.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요. 본인의 진짜 보험.

## 21. 마무리 — H5 osinfo.sh 로

자 4교시 끝이에요. 본인이 한 시간 동안 명령 18개를 손에 익혔어요. ps · top · htop · pgrep · pidof · kill · killall · pkill · jobs · bg · fg · `&` · nohup · disown · wait · `$$` · `$!` · `$?`. 본인 호텔 매니저(OS) 의 도구가 본인 손에. 진짜 큰 진전이에요.

다음 시간 H5. 우리는 이 18개를 묶어서 한 개의 셸 스크립트 — **procmon.sh** — 으로 만들어요. Ch001 H5 에서 만든 sysinfo.sh 의 동생이에요. sysinfo.sh 가 시스템 정보 한 장이라면, procmon.sh 는 프로세스 모니터 한 장. 본인 도구 가족이 한 명 더 늘어요.

오늘 한 줄 정리. **"호텔 매니저의 도구 18개. 4가지 손길(보기·닫기·일감·살리기) + 부모 변수 3."** 이 한 줄을 외워두세요. 18개 명령이 다 이 한 줄 안에 있어요.

본인 페이스. 4시간 끝. 8시간의 50%. 정확히 절반. 본인이 진짜 잘 견뎌 주셨어요. 짝짝짝. 박수. 진심으로요. 이쯤이면 보통 사람들 졸려서 못 듣는 시간이에요. 본인은 여기까지 왔어요. 본인 자신을 칭찬해 주세요.

추신. 오늘 명령 18개 중에 본인이 두 해 후 진짜 매일 치는 건 사실 5개에요. **ps · top · kill · &(백그라운드) · $?**. 이 다섯이 진짜 본인의 손에 박힌 다섯. 나머지 13개는 한 달에 한 번, 6개월에 한 번. 그래도 18개 다 한 번씩 들어 보는 게 의미 있어요. 두 해 후 어느 날 nohup 이나 disown 이 필요한 순간이 오면 "아 이거 4교시에 들었지" 하고 본인 머리가 살아나요. 한 번 들은 명령은 두 번째 만남부터 가까운 친구.

추신 둘. 본인이 오늘 만난 명령들의 나이. ps 1979, kill 1979, top 1984, jobs/fg/bg 1979 (Bourne shell), nohup 1979, pgrep 2000, htop 2004. 평균 35년 정도. 50년 전 사람들이 만든 도구가 본인 손에 그대로. 그 무게를 한 번씩 느껴 주세요. 본인이 만지는 도구 하나가 50년의 역사에요.

추신 셋. 본인 .zshrc 에 한 가지 추가하면 좋은 함수.

```bash
# 본인 사용자의 CPU 상위 5개
mytop() {
  ps -o pid,user,%cpu,%mem,comm -u $USER | sort -k3 -nr | head -6
}

# 패턴으로 죽이기 (확인 후)
mykill() {
  pgrep -fl "$1"
  read "?정말 죽일까요? (y/N) " yn
  [[ $yn == "y" ]] && pkill -f "$1"
}
```

이 두 함수를 .zshrc 에 추가. 두 해 동안 본인의 작은 도구 가족이 한 명 한 명 늘어요. 본인의 .zshrc 가 본인의 손이에요.

자, 5분 쉬고 5교시(H5) 에서 만나요. procmon.sh 만들 거예요. 한 시간 후. 본인 잘 따라오셨어요. 진심으로 고마워요.

추신 넷. 본인이 두 해 후 만나는 진짜 시나리오 한 가지를 미리 한 번 들어 두세요. 새벽 세 시 알람. 본인 EC2 에 SSH. `top` 한 번 — load avg 가 25.0. 본인 8코어 인스턴스에서 25 면 진짜 빨갛게 위험. `top` 의 상위 5개를 보면 — node 프로세스 8개가 다 CPU 90% 이상. 본인이 친 한 줄. `pkill -f "node server.js"`. 8개 한꺼번에 죽음. `pgrep -fl node` — 빈 줄. 그리고 `nohup node server.js > /var/log/server.log 2>&1 &`. 본인 시스템이 다시 살아나요. load avg 가 30분 후 1.5 로 떨어짐.

이 한 시나리오에 본인이 오늘 배운 명령 5개가 들어 있어요. top · pkill · pgrep · nohup · &. 정확히 본인이 매일 만나게 될 풍경. 4교시 한 시간이 본인의 두 해 후 새벽 세 시를 위한 거예요. 작은 한 시간이 큰 사고를 막아요. 본인이 그 시간을 지금 들였어요. 진심으로 박수. 이제 5교시에서 procmon.sh 로 만나요.

추신 다섯. 한 가지 큰 그림 한 번 더. 오늘 배운 18개 명령이 두 해 후 본인의 어디에 쓰일까. 한 줄씩.

- ps · top · htop → Ch068 nginx 모니터링, Ch091 성능 진단
- kill · killall · pkill → Ch062 Redis 서비스 재시작, Ch108 EC2 운영
- pgrep · pidof → Ch113 CloudFront 캐시 워머 스크립트
- jobs · bg · fg → Ch005 GUI vs CLI 의 백그라운드 작업
- nohup · disown · & → Ch097 RAG 인덱싱 백그라운드, Ch119 Bedrock 학습
- wait · $$ · $! · $? → Ch035 DB 마이그레이션 셸 스크립트, Ch116 X-Ray 통합

본인이 오늘 배운 한 명령씩이 두 해 코스 어딘가에 다시 등장해요. 한 번 들었으니 두 번째 만남부터 친구. 4교시가 그래서 진짜 의미 있어요. 잠깐 쉬고 H5 에서 만나요. 한 시간 후 procmon.sh 의 첫 줄에서 만나요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - ps 옵션 BSD 스타일(`aux`)와 SysV 스타일(`-ef`) 분리는 1980년대 두 유닉스 가족 분기의 흔적. macOS는 BSD 우선, Linux는 둘 다 지원. POSIX는 후자 표준화. 본 챕터는 두 스타일 모두 노출.
> - 신호(signal) 31개의 표준은 POSIX.1-1990 + RT signals. SIGTERM(15)/SIGKILL(9) 외에 SIGSTOP(17)/SIGCONT(19)/SIGUSR1(30)/SIGUSR2(31)도 자주 쓰임. Ch 050 Flask 의 graceful shutdown 패턴은 SIGTERM 핸들러로 구현.
> - top 의 macOS BSD 버전(`-l 1` 한 번 출력)과 Linux 의 GNU 버전(`-b -n 1` batch 모드) 옵션 차이는 자동화 스크립트 작성 시 함정. `htop` 은 두 OS 동일.
> - pkill `-f` 옵션의 위험성은 패턴이 너무 넓을 때 sudo 데몬까지 죽일 수 있음. 안전한 패턴은 (1) pgrep 으로 먼저 확인, (2) PID 명시적 kill, (3) systemd/launchd 의 service 단위 사용.
> - nohup vs disown vs `&` 차이 — `&`는 백그라운드, disown 은 셸 잡 테이블에서 제거(SIGHUP 안 받음), nohup 은 시작 시 SIGHUP 무시 + 출력 nohup.out 으로. 두 해 후 운영 환경에서는 systemd unit 이 더 표준.
> - `$$`/`$!`/`$?` 변수는 POSIX 표준. zsh·bash 동일. fish 셸은 `$status` 등 다른 이름. 본 챕터는 zsh/bash 표준에 집중.
> - pgrep/pidof 의 라이센스 차이 — pgrep 은 BSD/Linux 모두, pidof 는 Linux 전용 (procps 패키지). macOS 는 pidof 없음. `pgrep -x` 가 pidof 동등.
> - jobs/bg/fg 는 1979년 Bourne shell 부터의 전통. 백그라운드 작업 관리는 컨테이너/오케스트레이션 시대에 systemd·k8s 로 대체되는 추세. 두 해 후 본인이 만나는 production 운영은 jobs 가 아니라 service.
> - 신호 9 (SIGKILL) 와 19 (SIGSTOP) 는 잡거나 무시할 수 없는 두 신호. 이 두 신호의 동작은 커널이 직접 보장. 다른 모든 신호는 프로세스가 자체 핸들러로 처리 가능.
> - §17 위험 명령(`kill -9 1` 등)은 macOS 에서 보호되어 거부됨. Linux 는 root 권한이면 가능 — 시스템 즉시 정지. Ch 047 Docker 의 init 프로세스(PID 1)와 같은 보호 메커니즘.
> - 분량: 이 H4는 약 19,500자(공백 제외). 음독 60~63분. 디벨롭 이력: 2026-04-30 §20 "흔한 실수 명령어 학습 편" 신설 +1,500자 / 개발자 노트 신설 (이전엔 부재) / 목차 21항목 갱신.
