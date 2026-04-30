# H3 · 운영체제 기본 — 환경 점검 (OS 정보 캐기)

> 고양이 자경단 · Ch 002 · 3교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. H1·H2 회수 — 매니저 + 4가지 손길
2. 오늘의 약속 — 본인 OS의 신분증 한 장
3. uname — 한 줄 OS 신분증
4. sw_vers — macOS 의 자기소개
5. /etc/os-release — Linux 의 자기소개 (참고)
6. sysctl — 커널 설정의 보물 창고
7. hostname — 본인 컴퓨터의 이름
8. id·whoami·groups — 본인은 누구
9. env·printenv — 환경 변수의 세계
10. PATH 변수의 비밀
11. ulimit — 한 프로세스가 받을 수 있는 한도
12. /proc 와 /sys (Linux 참고)
13. system_profiler — macOS 의 진짜 큰 신분증
14. dmesg·log show — 커널의 일기장
15. uptime·w — 컴퓨터의 현재 안부
16. 본인 OS 신분증 카드 한 장 만들기
17. 자주 묻는 질문 5
18. 두 주 습관 — 매주 한 번 신분증 갱신
19. 명령 vs 명령 — macOS Linux 변환표 확장판
20. 셸 vs 환경 변수 — 한 번 더 정리
21. 한 가지 함정 — Apple Silicon 의 미묘한 차이
22. 본인 셸 설정 파일 한 번 보기 — .zshrc
23. 7개 명령 한 번에 — myinfo alias 미리보기
24. 두 해 후 본인이 만날 풍경 — OS 정보가 진단의 첫 한 페이지
25. 한 가지 더 — `getconf` 와 한도들의 진짜 이름
26. 흔한 실수 다섯 가지 + 안심 멘트 — 환경 점검 학습 편
27. 마무리 — H4로
👨‍💻 개발자 노트

---

## 🔧 강사용 명령어 한눈에

```bash
# OS 한 줄
uname -a
sw_vers

# 커널 설정
sysctl -a 2>/dev/null | wc -l
sysctl kern.hostname
sysctl kern.ostype kern.osrelease kern.version
sysctl kern.maxproc kern.maxfiles

# 호스트 / 사용자
hostname
hostname -f
whoami
id
groups

# 환경 변수
env | head -20
echo $PATH
echo $HOME

# 한도
ulimit -a
ulimit -n
ulimit -u

# 시스템 프로파일러 (macOS, 비싸요)
system_profiler SPSoftwareDataType
system_profiler SPHardwareDataType

# 가동 시간
uptime
w
```

---

## 1. H1·H2 회수 — 매니저 + 4가지 손길

3교시 시작. 다시 만나서 반가워요. 두 시간 끝났어요. 본인 머리에 9개 단어가 자리 잡으셨길 바라요. 부품 4명(CPU·RAM·디스크·네트워크) + 매니저 1명(OS) + 4가지 손길(프로세스·스레드·파일·syscall). 9개. 두 해 코스의 첫 9개 단단한 마디.

H2 끝의 작은 부탁이 있었죠. "ps aux | head -20 한 번 쳐서 STAT 컬럼 보세요." 보셨어요. 어떻든가요. 보통 S(Sleeping) 가 압도적이에요. 매니저 손님의 99%가 자고 있어요. 그 한 사실이 본인 머리에 들어 와 있으면 오늘 H3가 더 잘 들려요. 본인 컴퓨터는 진짜 조용한 호텔이에요. 200~400명의 손님 중 5명만 깨어 있고 나머지는 잠. 매니저가 깨우면 일하고 다시 잠. 진짜 평화로운 그림이에요.

H1·H2의 한 줄 다시. **OS = 호텔 매니저, 4가지 손길 = 프로세스·스레드·파일·시스템 콜.** 이 두 줄이 오늘 H3에서도 척추예요. 오늘 우리는 이 매니저의 신분증을 캐는 시간이에요. 매니저 본인이 누구인지, 어디서 왔는지, 어떤 설정으로 일하는지를 보는 시간.

## 2. 오늘의 약속 — 본인 OS의 신분증 한 장

오늘 한 줄.

> **본인 맥의 OS 신분증을 한 장 만든다. uname·sw_vers·sysctl·hostname·whoami·env·ulimit, 7개 명령으로.**

Ch001 H3 에서 본인이 본인 맥의 하드웨어 신분증을 한 장 만드셨어요. CPU 모델, RAM 크기, 디스크 크기, 네트워크 IP. 그게 부품 4명의 신분증이었어요. 오늘은 매니저(OS)의 신분증이에요. 같은 패턴, 다른 대상.

오늘 끝나면 본인의 사양 카드에 한 페이지가 더 추가돼요. "OS 페이지." macOS 버전, 커널 버전, 빌드 번호, 호스트 이름, 본인 사용자 ID, PATH, 한도 정보 등. 이 한 페이지가 두 해 코스에서 진짜 자주 회수돼요. 본인이 클라우드 서버 EC2 켜는 그 순간, 본인이 했던 그 우리 맥의 신분증을 그 EC2에서 똑같이 만들어요. 같은 명령으로요. macOS 와 Linux 는 70%가 같은 명령. 첫 번째 신분증을 잘 만들면 그 후 100번이 자동.

## 3. uname — 한 줄 OS 신분증

가장 빠른 한 줄. **uname.** 한 줄 정의. **"이 컴퓨터의 OS 한 줄 신분증."**

`uname` 만 치면 OS 종류 한 단어 (Darwin = macOS, Linux = Linux). `-a` 옵션을 붙이면 모든 정보 한 줄.

> ▶ **같이 쳐보기** — 내 맥의 OS 한 줄 신분증
>
> ```bash
> uname -a
> ```

본인 맥에서 결과는 이런 모양이에요:

```
Darwin mo-MacBook.local 24.1.0 Darwin Kernel Version 24.1.0: ... arm64
```

7개 부분으로 분해.

| 위치 | 옵션 | 내용 | 예 |
|------|------|------|----|
| 1 | `-s` | OS 종류 | Darwin |
| 2 | `-n` | 컴퓨터 이름 (hostname) | mo-MacBook.local |
| 3 | `-r` | 커널 버전 | 24.1.0 |
| 4 | `-v` | 커널 빌드 정보 | Darwin Kernel Version ... |
| 5 | `-m` | CPU 아키텍처 | arm64 (또는 x86_64) |
| 6 | `-p` | 프로세서 종류 | arm |
| 7 | `-i` | 하드웨어 플랫폼 | (빈 칸 일 수 있음) |

이 한 줄이 본인 OS 의 진짜 짧은 신분증이에요. 두 해 후 본인이 EC2 서버에서 `uname -a` 한 번 칠 거예요. 그러면 `Linux ip-10-0-1-23 5.15.0-1051-aws #56-Ubuntu SMP x86_64 GNU/Linux` 같은 게 나와요. 같은 명령, 다른 OS, 같은 7개 정보. 명령이 살아 있어요.

**Darwin** 이라는 단어 한 번 들어두세요. macOS 의 진짜 OS 이름이에요. 애플이 1999년에 만든 오픈소스 운영체제. macOS 는 Darwin 위에 애플의 그래픽 인터페이스(Aqua)와 앱 생태계가 얹힌 거예요. Darwin 의 커널 이름이 H1 에서 본 XNU. 두 해 후 면접에서 "macOS 의 커널이 뭔가요" 라는 질문 받으면 한 줄로 답할 수 있어요. **"Darwin OS의 XNU 커널이에요."**

## 4. sw_vers — macOS 의 자기소개

uname 이 7개 정보를 한 줄로 던졌다면, sw_vers 는 macOS 만의 깔끔한 3줄 자기소개. macOS 전용 명령. Linux 에는 없어요.

> ▶ **같이 쳐보기** — macOS 의 깔끔한 자기소개 3줄
>
> ```bash
> sw_vers
> ```

결과:

```
ProductName:		macOS
ProductVersion:		14.4
BuildVersion:		23E214
```

세 줄. **ProductName** = OS 이름. **ProductVersion** = 사용자가 보는 버전 (14.4 = macOS Sonoma). **BuildVersion** = 애플 내부 빌드 번호.

각 줄을 따로 받고 싶을 때.

```bash
sw_vers -productName        # macOS
sw_vers -productVersion     # 14.4
sw_vers -buildVersion       # 23E214
```

본인이 두 해 후 운영 서버 진단 도구 만들 때 이런 명령 한 줄씩 쓸 거예요. "이 서버는 macOS 14.4 빌드 23E214 야" 라는 한 줄이 진단의 출발점이에요.

macOS 버전 표 한 번. 본인 버전이 어디 있는지 보세요.

| 버전 | 이름 | 출시 |
|------|------|------|
| 10.15 | Catalina | 2019 |
| 11 | Big Sur | 2020 |
| 12 | Monterey | 2021 |
| 13 | Ventura | 2022 |
| 14 | Sonoma | 2023 |
| 15 | Sequoia | 2024 |

대부분 본인이 14 또는 15. 두 해 후 본인이 16, 17 쓰고 있을 거예요. macOS는 1년에 한 번 큰 버전 업. 9월쯤 새 버전 발표.

**Linux 의 같은 명령은 `cat /etc/os-release` 예요.** Ubuntu 면 `Ubuntu 22.04.3 LTS`, Amazon Linux 면 `Amazon Linux 2023`. 두 해 후 본인이 자주 만나는 명령. 오늘 한 번 들어두세요.

## 5. /etc/os-release — Linux 의 자기소개 (참고)

본인은 macOS 라서 `/etc/os-release` 가 없어요(시도해보면 "No such file"). 다만 두 해 후 본인이 EC2 띄우는 그 순간 가장 먼저 칠 명령이 이거예요. 미리 한 번 보고 가요.

```bash
# Linux 에서 (본인은 EC2 ssh 접속 후)
cat /etc/os-release
```

결과 예:

```
NAME="Ubuntu"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 22.04.3 LTS"
VERSION_ID="22.04"
```

7~10줄. 같은 정보가 다른 형식으로 들어 있어요. 본인이 두 해 후 클라우드 서버 운영할 때 자동화 스크립트 안에서 이 파일을 한 번씩 읽어요. "이 서버가 Ubuntu 면 apt 명령으로 설치, RHEL 면 yum/dnf 으로 설치" 같은 분기.

**ID 값이 가장 자주 쓰여요.** 한 단어. ubuntu·debian·rhel·amzn·alpine·rocky 등. 자동화 스크립트의 분기 키.

```bash
# 가상의 분기 (Linux 에서)
. /etc/os-release
case "$ID" in
  ubuntu|debian) sudo apt install -y nginx ;;
  rhel|amzn|rocky) sudo dnf install -y nginx ;;
  alpine) sudo apk add nginx ;;
esac
```

이 5줄이 두 해 코스 후반에서 본인이 매일 만나는 패턴. 오늘 한 번 미리.

본인 맥에서 이 명령은 Linux 변환표(Ch001 H8 §12)에서 우리가 봤던 그 표의 한 항. 첫 챕터 H8에서 본 그 표가 진짜로 살아 있어요. 회수가 빨라요.

## 6. sysctl — 커널 설정의 보물 창고

이번 시간의 진짜 보물. **sysctl.** 한 줄 정의. **"커널의 모든 설정과 상태를 읽고 쓰는 만능 명령."**

본인 맥의 커널이 가지고 있는 설정 변수가 몇 개일까요. 한 번 세 봐요.

> ▶ **같이 쳐보기** — 내 커널이 들고 있는 설정 변수 개수
>
> ```bash
> sysctl -a 2>/dev/null | wc -l
> ```

본인 맥에서 약 1,500~2,000 개. 두 해 코스 동안 본인이 직접 쓰는 건 그 중 30~50개. 나머지는 평생 안 만져요. 다만 한 번 세어 두면 "어 커널이 진짜 큰 시스템이구나" 한 번 느껴요.

대표적인 sysctl 변수 10개. 외워두시면 좋아요.

```bash
sysctl kern.ostype           # OS 종류 (Darwin)
sysctl kern.osrelease        # 커널 버전 (24.1.0)
sysctl kern.version          # 커널 빌드 한 줄
sysctl kern.hostname         # 컴퓨터 이름
sysctl kern.maxproc          # 최대 프로세스 수
sysctl kern.maxfiles         # 최대 열린 파일 수
sysctl hw.ncpu               # CPU 코어 수
sysctl hw.memsize            # RAM 바이트
sysctl hw.cpubrand_string    # CPU 모델 문자열 (구버전)
sysctl machdep.cpu.brand_string  # CPU 모델 (Apple Silicon)
```

| 변수 | 한 줄 의미 |
|------|------------|
| `kern.*` | 커널의 정보와 한도 |
| `hw.*` | 하드웨어 정보 |
| `vm.*` | 가상 메모리 (스왑 등) |
| `net.*` | 네트워크 설정 |
| `machdep.*` | 머신 종속 (CPU 등) |

이 5개의 네임스페이스를 알아두면 sysctl 의 큰 그림이 잡혀요. 본인이 Ch001 H3 에서 `sysctl hw.memsize` 한 번 친 적 있죠. 그게 hw 네임스페이스의 한 변수. 오늘은 kern 쪽 변수를 더 봐요. 매니저(커널)의 설정.

특히 **kern.maxproc** 와 **kern.maxfiles** 두 변수가 진짜 중요해요. 본인 맥에서 한 번 보세요.

```bash
sysctl kern.maxproc kern.maxfiles
```

보통 `kern.maxproc: 2048`, `kern.maxfiles: 491520`. 본인 컴퓨터 전체에서 동시에 도는 프로세스 최대 2048개, 동시에 열린 파일 최대 49만 개. **이 두 숫자가 OS 의 한도예요.** 이 한도를 넘으면 "Resource temporarily unavailable" 같은 에러. 두 해 후 운영 서버에서 자주 만나는 에러.

## 7. hostname — 본인 컴퓨터의 이름

```bash
hostname        # 짧은 이름
hostname -f     # 전체 도메인 이름 (FQDN)
```

본인 맥의 이름이 한 줄로 나와요. 보통 `mo-MacBook.local` 같은 이름. 본인이 시스템 환경설정 > 일반 > 이름·정보 에서 정한 그 이름. 또는 기본값. 본인 맥의 신분.

이 이름이 왜 중요하냐. **네트워크에서 본인 컴퓨터를 찾는 이름**이에요. 본인이 같은 와이파이의 다른 컴퓨터에서 본인 맥에 접속할 때 이 이름으로 찾아요. ssh mo-MacBook.local 같은 식.

또한 **로그·진단 도구가 이 이름을 출력**해요. 본인이 두 해 후 클라우드 서버 100대 운영할 때, 각 서버의 로그를 한 곳에 모아요. 그 로그에 hostname 이 찍혀 있어요. "어 이 에러는 web-server-03 에서 났네" 같은 식. hostname 이 본인 서버의 신분증.

```bash
# 호스트 이름 바꾸기 (조심!)
sudo scutil --set HostName "내가-원하는-이름"
sudo scutil --set LocalHostName "내가-원하는-이름"
```

이 두 줄이 호스트 이름을 바꾸는 진짜 macOS 방식. 다만 오늘은 이름 바꾸지 마세요. 첫 챕터부터 본인 환경 흔들면 헷갈려요. 두 해 후 클라우드 서버 띄울 때 자주 써요.

## 8. id·whoami·groups — 본인은 누구

본인이 누구인지 OS 가 어떻게 알까요. **사용자 ID(UID) 와 그룹 ID(GID).**

> ▶ **같이 쳐보기** — OS 가 본인을 부르는 진짜 이름·번호·소속
>
> ```bash
> whoami          # 본인 사용자 이름
> id              # 본인 UID, GID, 그룹들
> groups          # 본인이 속한 그룹들
> ```

본인 맥의 결과 예:

```
$ whoami
mo

$ id
uid=501(mo) gid=20(staff) groups=20(staff),12(everyone),61(localaccounts),...

$ groups
staff everyone localaccounts _appserverusr admin _appserveradm
```

분해.

- **uid=501(mo).** 본인의 UID. macOS 기본 일반 사용자 UID 가 501부터. 두 번째 사용자는 502. (Linux는 보통 1000부터.)
- **gid=20(staff).** 본인의 기본 그룹 GID.
- **groups=20,12,61,...** 본인이 속한 모든 그룹.

UID 0 은 특별해요. **root.** 모든 권한 가진 슈퍼 유저. 본인이 `sudo` 명령 칠 때 잠깐 root 로 변신해서 명령 실행. 그 후 다시 본인(501)으로 돌아옴.

```bash
sudo whoami     # root  (잠깐 root로)
whoami          # mo    (다시 본인으로)
```

이 한 명령이 sudo 의 진짜 의미를 보여줘요. **"잠깐 root 가 되어 한 명령만 실행."** 두 해 동안 본인이 sudo 만 번 쳐요. 그때마다 잠깐 root 로 변신하는 거예요. 0.1초 동안 슈퍼 유저.

**파일 권한 9비트(H2 §14)와 짝을 맞춰 보세요.** 파일에는 owner·group·other 의 rwx 9비트. 사용자에게는 UID·GID·groups. 매니저가 본인 UID/GID 와 파일의 owner/group 을 비교해서 r/w/x 자격을 판단. 두 정보가 한 짝으로 OS 의 가장 기본 보안.

## 9. env·printenv — 환경 변수의 세계

**환경 변수(environment variable).** 한 줄 정의. **"프로세스가 태어날 때 부모로부터 받는 짧은 메모들."**

본인 셸이 켜질 때 부모(터미널 앱)로부터 수십 개의 짧은 메모를 받아요. 그 메모가 환경 변수. PATH, HOME, USER, SHELL, LANG 같은 이름으로요.

> ▶ **같이 쳐보기** — 내 셸이 부모로부터 받은 메모 첫 20개
>
> ```bash
> env | head -20
> ```

결과 예 (앞부분):

```
SHELL=/bin/zsh
HOME=/Users/mo
USER=mo
LANG=ko_KR.UTF-8
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
TERM=xterm-256color
PWD=/Users/mo
LOGNAME=mo
...
```

각 줄이 `이름=값` 형태. 보통 30~80개. 가장 중요한 5개를 한 번 봐요.

| 변수 | 한 줄 의미 |
|------|------------|
| **PATH** | 명령을 찾는 폴더 목록 (다음 절 자세히) |
| **HOME** | 본인 홈 디렉터리 (`~`와 같은 경로) |
| **USER** | 본인 사용자 이름 (whoami 와 같은 값) |
| **SHELL** | 기본 셸 경로 (/bin/zsh) |
| **LANG** | 언어·로케일 (ko_KR.UTF-8) |

특정 변수만 보려면 `echo $변수이름`.

```bash
echo $HOME       # /Users/mo
echo $PATH       # /usr/local/bin:/usr/bin:...
echo $LANG       # ko_KR.UTF-8
```

새 변수 만들려면 `export 이름=값`.

```bash
export MY_NAME="고양이"
echo $MY_NAME    # 고양이
```

이 export 한 줄이 두 해 코스 동안 본인이 만 번 쳐요. 비밀 키, API 토큰, 데이터베이스 비밀번호를 환경 변수로 두는 패턴이 진짜 중요해요. 코드 안에 비밀번호 하드코딩하면 GitHub 에 올리는 순간 해킹돼요. 환경 변수에 두면 코드는 깨끗하고 비밀은 본인 컴퓨터에만. 두 해 후 보안 챕터에서 자세히.

## 10. PATH 변수의 비밀

PATH 가 워낙 중요해서 한 절을 따로. PATH 의 한 줄 정의. **"본인이 명령을 칠 때 셸이 그 명령의 진짜 파일을 찾으러 다니는 폴더 목록."**

본인이 `ls` 라고 칠 때, 셸은 ls 라는 파일이 어디 있는지 몰라요. PATH 변수에 적힌 폴더들을 위에서 아래로 차례로 뒤져서 첫 번째로 찾는 ls 를 실행해요.

```bash
echo $PATH
# /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

which ls
# /bin/ls    ← 첫 번째로 찾은 ls

type ls
# ls is /bin/ls
```

`:` 로 구분된 폴더 5개. 셸이 위 → 아래로 뒤져요. /usr/local/bin → /usr/bin → /bin → ... 첫 번째로 ls 가 있는 폴더가 /bin 이라서 /bin/ls 를 실행.

이 순서가 진짜 중요해요. **앞쪽 폴더가 우선.** 본인이 /usr/local/bin 에 자기만의 ls 를 만들어 두면, 시스템 ls 보다 자기 ls 가 먼저 찾아져요. 좋게도 쓸 수 있고 나쁘게도 쓸 수 있어요. 두 해 후 본인이 brew 같은 패키지 매니저 깔면 /usr/local/bin 에 새 명령들이 쌓여요. 그러면 PATH 를 잘 설정해 두지 않으면 brew 로 깐 새 버전이 안 보이고 시스템의 옛 버전이 먼저 보이는 함정에 빠져요.

PATH 에 폴더 추가하기.

```bash
export PATH="$HOME/bin:$PATH"
# 본인의 ~/bin 을 PATH 맨 앞에. 그러면 ~/bin 의 명령이 우선.
```

이 한 줄이 본인 두 해 코스 동안 ~/.zshrc 안에 들어 있어요. 셸 켜질 때마다 한 번씩 실행. 본인이 만든 sysinfo.sh 같은 도구를 ~/bin 에 넣어 두면 어느 폴더에서나 `sysinfo.sh` 만 쳐서 실행 가능. 두 해 후 진짜 자주 만나는 패턴.

## 11. ulimit — 한 프로세스가 받을 수 있는 한도

**ulimit.** 한 줄 정의. **"한 프로세스가 받을 수 있는 자원의 한도."**

매니저(OS) 가 모든 프로세스에게 무한 자원을 주면 한 프로세스가 폭주할 때 시스템 전체가 죽어요. 그래서 매니저가 한 명당 한도를 정해 둬요. 그게 ulimit.

```bash
ulimit -a
```

결과 (보통 10~15줄):

```
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
file size               (blocks, -f) unlimited
max locked memory       (kbytes, -l) unlimited
max memory size         (kbytes, -m) unlimited
open files                      (-n) 256
pipe size            (512 bytes, -p) 1
stack size              (kbytes, -s) 8176
cpu time               (seconds, -t) unlimited
max user processes              (-u) 2784
virtual memory          (kbytes, -v) unlimited
```

5개만 외워두세요.

| 한도 | 옵션 | 의미 | 기본 |
|------|------|------|------|
| **open files** | `-n` | 한 프로세스가 동시에 열 수 있는 파일 수 | 256 (macOS) |
| **max user processes** | `-u` | 본인 사용자가 만들 수 있는 프로세스 수 | 2784 |
| **stack size** | `-s` | 함수 호출 깊이 한도 (KB) | 8176 |
| **core file size** | `-c` | 크래시 덤프 파일 크기 | 0 (꺼져 있음) |
| **cpu time** | `-t` | 한 프로세스의 CPU 시간 (초) | unlimited |

**`open files` 가 가장 자주 사고 나는 한도예요.** macOS 기본 256, Linux 기본 1024. 웹 서버 nginx 같은 게 동시에 만 명 받으려면 fd 가 만 개 필요. 256 으로는 부족. 그래서 운영 서버에서 가장 먼저 늘리는 한도. 늘리려면.

```bash
ulimit -n 65536
# 또는 영구적으로 ~/.zshrc 에 한 줄 추가
```

두 해 후 본인이 클라우드 서버 운영할 때 매번 만나는 한도. 첫 시간에 한 번 봐 두세요.

## 12. /proc 와 /sys (Linux 참고)

본인은 macOS 라 이 두 폴더가 없어요. 다만 Linux 의 진짜 큰 발명품이라 한 번 들어두세요.

**/proc.** 한 줄 정의. **"커널이 프로세스 정보를 파일처럼 보여주는 가짜 폴더."** 디스크의 진짜 폴더가 아니에요. 커널이 메모리 안의 정보를 파일처럼 만들어 보여줘요. 유닉스 철학 "모든 게 파일" 의 진짜 구현.

```bash
# Linux 에서 (참고)
ls /proc | head    # 0,1,2,... 가 프로세스 PID
cat /proc/cpuinfo  # CPU 정보
cat /proc/meminfo  # 메모리 정보
cat /proc/1/status # PID 1 (init) 의 상태
```

각 PID 마다 폴더 한 개. 그 안에 그 프로세스의 모든 정보가 파일들로. cat 한 번이면 다 읽혀요. 진짜 우아한 디자인.

**/sys.** 한 줄 정의. **"커널이 하드웨어 정보를 파일처럼 보여주는 가짜 폴더."** 하드웨어·드라이버 정보. /proc 와 형제.

macOS 에는 이 두 폴더가 없어서 sysctl 한 명령에 다 들어 있어요. 같은 정보, 다른 방식. **Linux = 파일 트리, macOS = sysctl 명령.** 두 해 후 본인이 Linux 서버에 ssh 로 들어가는 그 순간 /proc 가 본인의 새로운 도구가 돼요. 미리 한 번 들어두세요.

## 13. system_profiler — macOS 의 진짜 큰 신분증

macOS 의 진짜 큰 진단 도구. **system_profiler.** 본인 맥의 모든 정보를 다 출력해요. 그 양이 진짜 커서 보통은 카테고리 한 개씩.

```bash
system_profiler SPSoftwareDataType
# 소프트웨어: OS 버전, 부팅 시간, 사용자 이름, 등

system_profiler SPHardwareDataType
# 하드웨어: 모델, 칩, RAM, 시리얼

system_profiler SPMemoryDataType
# 메모리 슬롯들

system_profiler SPNetworkDataType
# 네트워크 인터페이스들

system_profiler -listDataTypes
# 카테고리 전체 목록 (40~50개)
```

이 명령은 좀 무거워요. 한 번 실행에 1~3초. 정보가 진짜 많아서. 본인이 자주 쓰는 건 SPSoftwareDataType 와 SPHardwareDataType 두 개 정도. 나머지는 가끔 디버깅할 때.

본인이 Ch001 H3 에서 사양 카드 만들 때 system_profiler 쓰셨을 수도 있어요. 그게 macOS 의 진짜 큰 신분증 출력 도구. 시스템 정보 앱(Apple 메뉴 > 이 Mac에 관하여 > 시스템 보고서)이 사실 이 명령의 GUI 래퍼예요. 같은 정보, 다른 인터페이스.

## 14. dmesg·log show — 커널의 일기장

**커널의 일기장.** OS 가 부팅된 순간부터 지금까지의 모든 사건이 기록돼 있어요. 하드웨어 인식, 드라이버 로딩, 에러, 경고, 등등.

Linux 에서는 `dmesg`. macOS 에는 dmesg 가 있긴 한데 권한 필요(sudo). 대신 더 좋은 도구가 `log` 명령.

```bash
# Linux
sudo dmesg | tail -20

# macOS (이게 더 좋아요)
log show --last 1m --predicate 'eventMessage contains "error"' 2>/dev/null | head -20
```

이 명령이 두 해 후 본인이 진짜로 쓰는 도구예요. 서버가 이상하게 동작할 때 가장 먼저 보는 게 커널 로그. "어 이 USB 가 인식 안 됐네", "어 이 디스크에 에러 있네", "어 메모리 부족으로 OOM 발생했네." 다 여기에 기록.

오늘은 명령 한 번 들어두세요. H6 응급 처치에서 다시 만나요.

## 15. uptime·w — 컴퓨터의 현재 안부

마지막. 컴퓨터의 가장 빠른 건강 체크 한 줄. **uptime.**

```bash
uptime
```

결과:

```
14:30  up 3 days, 5:42, 4 users, load averages: 1.23 0.95 0.72
```

5개 정보를 한 줄에.

| 부분 | 의미 |
|------|------|
| `14:30` | 현재 시각 |
| `up 3 days, 5:42` | 부팅 후 가동 시간 |
| `4 users` | 로그인한 사용자 수 |
| `load averages: 1.23 0.95 0.72` | 1·5·15분 평균 부하 |

**load average** 가 진짜 중요해요. CPU 부하의 평균. 본인 맥이 8코어면 load average 8 정도가 100% 사용 중. 그 이상이면 과부하(다른 프로세스가 줄 서고 있음). 1.23 정도면 8코어 중 1코어 정도가 바쁘다는 뜻. 한가한 상태.

3개 숫자가 1·5·15분 평균. 이 셋의 트렌드가 진단의 시작. **첫 숫자 > 셋째 숫자** = 점점 바빠지는 중. **첫 숫자 < 셋째 숫자** = 점점 한가해지는 중. 본인이 두 해 후 운영 서버에서 가장 먼저 보는 한 줄.

`w` 는 uptime 에 로그인한 사용자 정보를 더 자세히 추가.

```bash
w
```

이 두 명령은 5초 안에 컴퓨터의 안부를 묻는 도구. 첫 챕터에서 약속한 매일 1분 안부 묻기 의 진짜 도구.

## 16. 본인 OS 신분증 카드 한 장 만들기

오늘 본 명령들을 한 장의 카드로 묶어요. 본인 노트에 옮겨 적으세요. 두 해 후 EC2 서버에 ssh 로 들어가서도 똑같이 만들 수 있어요.

```
================================================
  본인 맥 OS 신분증 (2026-04-26 기준)
================================================
[OS]
- 이름:        Darwin (macOS)
- 버전:        14.4 (Sonoma)
- 빌드:        23E214
- 커널:        Darwin 24.1.0
- 아키텍처:    arm64

[호스트]
- 이름:        mo-MacBook.local
- IP:          (Ch001 H3 에서 캤음)

[사용자]
- 이름:        mo
- UID:         501
- 그룹:        staff (gid 20)

[환경]
- 셸:          /bin/zsh
- 홈:          /Users/mo
- 언어:        ko_KR.UTF-8
- PATH 폴더:   5개 (/usr/local/bin, /usr/bin, ...)

[한도]
- 최대 파일:   256 (ulimit -n)
- 최대 프로세스: 2784 (ulimit -u)
- 스택 크기:    8176 KB

[현재 안부]
- 가동 시간:   3일 5시간
- 사용자:      4명
- 부하:        1.23 / 0.95 / 0.72
================================================
```

이 카드가 본인의 두 번째 카드예요. 첫 번째는 Ch001 H3 의 하드웨어 카드, 오늘은 OS 카드. 두 카드 합치면 본인 맥의 전체 신분증이에요. 본인 노트에 두 카드를 한 페이지에 나란히 두세요. 두 해 후 본인이 그 페이지를 다시 펴 볼 거예요.

H5 에서 우리는 이 정보를 자동으로 수집하는 셸 스크립트(osinfo.sh) 를 짜요. Ch001 H5 의 sysinfo.sh 가 부품 4명의 신분증을 출력했다면, osinfo.sh 는 매니저(OS) 의 신분증을 출력. 같은 패턴, 다른 대상. H5 까지 두 시간 후예요. 미리 그림 그려두세요.

## 17. 자주 묻는 질문 5

**Q1. "uname 과 sw_vers 둘 다 OS 이름을 보여주는데, 왜 결과가 다른가요? Darwin vs macOS?"**
A. uname 은 진짜 OS 이름(Darwin)을 보여주고, sw_vers 는 사용자가 보는 마케팅 이름(macOS)을 보여줘요. 진짜 OS 이름은 Darwin 이에요. 애플이 사용자에게 친근한 이름으로 macOS 라고 부를 뿐. iOS·iPadOS·tvOS·watchOS 도 다 Darwin 위에 다른 인터페이스를 얹은 거예요. 진짜 한 가족.

**Q2. "sysctl 변수 1500개 다 외워야 해요?"**
A. 절대 아니에요. 30~50개만 자주 만나요. kern.* 와 hw.* 두 네임스페이스의 대표 변수 10개만. 나머지는 필요할 때 검색해서 찾으면 돼요. 평생 안 쓰는 변수가 90%.

**Q3. "환경 변수와 셸 변수의 차이?"**
A. 환경 변수는 자식 프로세스에 상속, 셸 변수는 안 됨. `MY_VAR=값` 만 하면 셸 변수, `export MY_VAR=값` 하면 환경 변수. export 가 자식에게 전달의 마법. 본인 셸에서 만든 변수가 그 셸에서 띄운 프로그램에 보이려면 반드시 export.

**Q4. "ulimit 을 함부로 늘려도 되나요?"**
A. 너무 크게 늘리면 한 프로세스가 시스템 전체를 잡아먹을 수 있어요. open files 65536 까지는 안전. 그 이상은 신중. 운영 서버에서는 모니터링 도구로 실시간 보면서 조정.

**Q5. "오늘 명령 너무 많아요. 다 외워야 해요?"**
A. 7개만요. uname, sw_vers, sysctl, hostname, whoami, env, ulimit. 이 7개가 척추. 나머지 dmesg, log, system_profiler 는 본인이 디버깅 할 때 한 번씩 만나면 자연스럽게 익숙해져요. 외우려 마시고 자주 쳐 보세요. 손이 외워요.

## 18. 두 주 습관 — 매주 한 번 신분증 갱신

H1 에서 약속한 매일 1분 × 3 의 한 가지에 한 줄 더 추가. **매주 한 번, 본인 OS 신분증 갱신.**

```bash
# 일요일 저녁 1분 의식
sw_vers
uname -a
uptime
ulimit -n
```

이 4줄만 매주 한 번. 본인 OS 가 한 주 동안 어떻게 변했는지 보세요. 평소엔 거의 안 변해요. 다만 macOS 업데이트(매월~매분기) 가 있으면 버전 숫자가 바뀌어요. 그 변화를 본인이 직접 보면 OS 업데이트의 의미를 진짜로 느껴요.

본인 노션에 한 페이지 만들어 두고 매주 일요일 저녁 위 4줄 출력 결과를 옮겨 적어 두세요. 두 해 후 그 페이지를 펴 보면 100주의 OS 변화 history 가 한 장으로 보여요. 본인의 첫 long-term 데이터셋. 작은 습관이지만 진짜 큰 자산.

이 습관이 두 해 후 본인이 클라우드 서버 100대 운영할 때 똑같은 모양으로 자라요. 매주 자동으로 100대의 신분증을 모아서 한 장으로 비교. 작은 일요일 1분 의식이 두 해 후 운영 시스템의 척추가 돼요. 작게 시작해서 크게 자라는 본인 두 해 코스의 진짜 모양.

## 19. 명령 vs 명령 — macOS Linux 변환표 확장판

Ch001 H8 §12 에서 우리가 본 변환표를 OS 정보 명령으로 확장. 두 해 후 본인이 매일 쓸 표.

| 정보 | macOS | Linux |
|------|-------|-------|
| OS 이름·버전 | `sw_vers` | `cat /etc/os-release` |
| 커널 정보 | `uname -a` | `uname -a` (같음) |
| 호스트 이름 | `hostname` | `hostname` (같음) |
| 사용자 정보 | `id`, `whoami` | `id`, `whoami` (같음) |
| 환경 변수 | `env` | `env` (같음) |
| 한도 | `ulimit -a` | `ulimit -a` (같음) |
| 가동 시간 | `uptime` | `uptime` (같음) |
| 부하 | `uptime` 마지막 줄 | `uptime` 또는 `cat /proc/loadavg` |
| 커널 변수 | `sysctl -a` | `sysctl -a` 또는 `/proc/sys/` |
| 메모리 정보 | `vm_stat`, `sysctl hw.memsize` | `free -h` 또는 `cat /proc/meminfo` |
| CPU 정보 | `sysctl machdep.cpu.brand_string` | `lscpu` 또는 `cat /proc/cpuinfo` |
| 디스크 정보 | `diskutil list` | `lsblk` 또는 `fdisk -l` |
| 부팅 로그 | `log show` | `dmesg` 또는 `journalctl -k` |
| 시스템 정보 종합 | `system_profiler` | `inxi` 또는 `hostnamectl` |

**겹치는 명령이 절반 이상.** uname·hostname·id·whoami·env·ulimit·uptime·sysctl. 8개가 정확히 같은 명령. 옵션도 거의 같아요. 유닉스 가족의 진짜 큰 선물. 본인이 macOS 에서 손에 익힌 게 두 해 후 Linux 서버에서 그대로 동작.

다른 명령(sw_vers ↔ /etc/os-release, vm_stat ↔ free 등)은 한 표만 외워두면 돼요. 두 해 후 한 번 헷갈리면 이 표 다시 펴 보면 돼요. 첫 챕터의 변환표가 두 해 코스의 진짜 큰 자산.

## 20. 셸 vs 환경 변수 — 한 번 더 정리

Q3 에서 잠깐 봤던 셸 변수 vs 환경 변수를 한 번 더. 헷갈리는 분이 많아서.

**셸 변수.** 본인 셸 안에서만 살아요. 자식 프로세스에 안 보여요.

```bash
MY_VAR="안녕"
echo $MY_VAR        # 안녕  (보임)
zsh -c 'echo $MY_VAR'   # (빈 줄)  안 보임
```

**환경 변수.** 자식 프로세스에 상속.

```bash
export MY_VAR="안녕"
echo $MY_VAR        # 안녕
zsh -c 'echo $MY_VAR'   # 안녕  (자식도 봄)
```

`export` 한 글자 차이. 진짜 큰 차이. 두 해 후 본인이 코드에서 환경 변수를 읽으려면 그 변수가 export 돼 있어야 해요. 본인 .zshrc 안에 export 한 줄씩 쌓이는 게 그 이유.

**비밀 변수의 진짜 비밀.** 본인이 데이터베이스 비밀번호를 환경 변수로 둘 때 패턴.

```bash
# ~/.zshrc 에 (또는 별도 파일에)
export DB_PASSWORD="secret123"
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
```

코드에서는.

```python
import os
db_pwd = os.environ["DB_PASSWORD"]
```

이 패턴이 두 해 후 본인이 만 번 쓰는 패턴. 코드는 깨끗하고, 비밀은 본인 환경에만. .gitignore 에 .env 추가는 필수.

## 21. 한 가지 함정 — Apple Silicon 의 미묘한 차이

본인이 Apple Silicon 맥(M1·M2·M3)을 쓰신다면 한 가지 함정이 있어요. **같은 명령이 다르게 동작할 수 있어요.**

```bash
uname -m         # arm64
arch             # arm64
```

Apple Silicon 의 진짜 아키텍처는 arm64. 다만 Rosetta 2 모드(인텔 에뮬레이션)에서 셸을 띄우면 결과가 x86_64 로 나와요.

```bash
arch -x86_64 zsh    # Rosetta 모드 zsh
uname -m            # x86_64  ← 같은 컴퓨터, 다른 결과
exit
uname -m            # arm64  ← 원래로
```

왜 중요하냐. **Docker 이미지 호환성** 때문이에요. 본인이 도커로 어떤 이미지를 받을 때, 본인 셸의 모드에 따라 받는 이미지가 달라요. 한 이미지가 한 아키텍처로만 빌드된 경우, 본인 셸의 모드가 안 맞으면 동작 안 해요. Ch047 Docker 챕터에서 자세히.

진단 한 줄.

```bash
echo "uname -m: $(uname -m), arch: $(arch)"
```

두 해 후 도커 이슈 디버깅 시 첫 한 줄. 미리 손에 두세요.

그리고 Apple Silicon 에서 `sysctl machdep.cpu.brand_string` 이 비어 있을 수 있어요. 새 가족이라 일부 sysctl 변수가 다르게 위치. `sysctl -a | grep brand` 로 다른 변수를 봐야 해요. Intel 맥은 정상. 이런 작은 차이들이 두 해 후 진짜 사고들의 원인. 미리 한 번 들어두세요.

## 22. 본인 셸 설정 파일 한 번 보기 — .zshrc

오늘 본 환경 변수의 진짜 집은 **.zshrc** 파일. 본인 홈에 숨겨진 파일.

```bash
ls -la ~ | grep zsh
# .zshrc, .zsh_history, .zprofile 등
```

**.zshrc 의 역할.** zsh 가 켜질 때 자동 실행되는 스크립트. 매번 export 한 줄씩 치는 대신 .zshrc 에 적어 두면 영구.

```bash
# .zshrc 예
export PATH="$HOME/bin:/opt/homebrew/bin:$PATH"
export EDITOR=vim
export LANG=ko_KR.UTF-8

alias ll='ls -la'
alias gs='git status'

sysinfo() {
  uname -a
  uptime
  ulimit -n
}
```

이 파일이 본인 셸의 영혼이에요. 두 해 동안 본인이 .zshrc 에 한 줄씩 쌓아요. 끝날 때쯤 100~300줄. 본인 손에 익은 모든 alias·함수의 집. 두 해 후 새 컴퓨터 사도 .zshrc 한 파일만 옮기면 손이 그대로.

오늘 작은 실험. 본인 .zshrc 가 있는지 확인.

```bash
[ -f ~/.zshrc ] && echo "있음" || echo "없음"
```

없으면 빈 파일 만드세요.

```bash
touch ~/.zshrc
echo "# 본인 .zshrc 시작 ($(date))" >> ~/.zshrc
```

이 한 줄이 본인 두 해 .zshrc 의 첫 줄. 두 해 후에 그 파일이 100~300줄로 자라요. 첫 줄이 진짜 큰 의미. 본인 셸의 영혼이 태어나는 순간.

## 23. 7개 명령 한 번에 — myinfo alias 미리보기

H5 에서 만들 osinfo.sh 의 진짜 미니 버전을 한 줄짜리 alias 로 미리.

```bash
alias myinfo='echo "=== OS ==="; uname -a; sw_vers; echo "=== HOST ==="; hostname; echo "=== USER ==="; id; echo "=== UPTIME ==="; uptime; echo "=== LIMITS ==="; ulimit -n -u'
```

이 한 줄을 본인 .zshrc 에 추가. 그 후 어느 폴더에서나 `myinfo` 한 번 치면 OS 신분증 한 장이 출력. 6개 명령을 한 줄로 묶었어요.

이게 유닉스 철학의 진짜 모습. **작은 도구들을 묶어서 큰 일.** 본인 손에 myinfo 하나가 늘어났어요. Ch001 H4 의 alias 가족(ll·la·gs)에 myinfo 한 명 추가. 두 해 동안 본인 alias 가족이 5명 → 50명 → 200명으로 자라요. 본인 손에 익은 도구가 200개. 그게 본인이 진짜 개발자라는 증거.

H5 에서 이 alias 를 진짜 셸 스크립트(osinfo.sh) 로 발전시켜요. alias 가 한 줄짜리 도구라면, 스크립트는 100줄짜리 도구. 같은 일을 더 정교하게. 두 시간 후예요. 그 전에 이 alias 를 한 번 손에 익히세요. **myinfo.** 본인 OS 신분증 명령. 머리에 두세요.

## 24. 두 해 후 본인이 만날 풍경 — OS 정보가 진단의 첫 한 페이지

두 해 후 본인이 AWS 에 배포한 서비스가 새벽 세 시에 알람. 본인이 ssh 로 EC2 에 접속. 첫 다섯 한 줄.

```bash
uname -a            # 어떤 커널? (Amazon Linux 2 의 5.10 커널?)
uptime              # 얼마나 켜져 있나? load average 는?
df -h               # 디스크 풀 났나?
free -h             # 메모리 부족?
top -b -n 1 | head  # 어떤 프로세스가 CPU 먹나?
```

이 다섯 줄이 두 해 후 본인 아침의 첫 다섯 줄이에요. **오늘 H3 가 그 다섯 줄의 절반.** uname·uptime 두 명령은 정확히 오늘 손에 넣은 명령. 두 해 후 새벽 세 시의 본인을 위해 오늘 한 번 더 쳐 보세요. 손이 잠결에도 그 명령들을 기억하게 만드는 거예요.

본인의 두 해 후 모습이 오늘 한 시간에 달려 있어요. 거창한 게 아니에요. 그저 한 명령씩 손에 익히는 일. 그 한 명령이 두 해 후 새벽 본인을 구해요. 작은 일이 큰 일을 막아요.

## 25. 한 가지 더 — `getconf` 와 한도들의 진짜 이름

ulimit 외에 한 가지 더 손에 둘 명령. **getconf**. POSIX 표준이 정해 둔 한도 변수들을 보는 명령.

```bash
getconf -a | head -20      # 변수 200~300개
getconf PAGE_SIZE          # 페이지 크기 (보통 4096 바이트)
getconf OPEN_MAX            # 한 프로세스 최대 fd (보통 256~10240)
getconf ARG_MAX             # 명령 인자 최대 길이
getconf LONG_BIT            # 64 (64-bit OS)
```

PAGE_SIZE 4096. 본인 컴퓨터의 메모리가 4096 바이트짜리 페이지로 잘려 있다는 뜻. ulimit 와 다른 차원의 한도들. ulimit 가 OS 가 본인에게 정해 준 한도라면, getconf 는 OS 자체의 구조적 한도. 두 해 후 본인이 만 번 들을 단어 "페이지" 의 그 페이지가 여기서 처음 나옴. 4 KB 단위.

두 해 후 본인이 진짜 깊이 디버깅할 때(예: 메모리 매핑 이슈, mmap 단위 정렬 등) 만나는 명령. 오늘은 이름만. **getconf.** 머리에 한 글자. 두 해 후 한 번은 만나요. 그 한 번을 위해 한 줄.

## 26. 흔한 실수 다섯 가지 + 안심 멘트 — 환경 점검 학습 편

오늘 OS 정보를 캐는 명령을 진짜 많이 만났어요. uname·sw_vers·sysctl·hostname·id·env·ulimit·system_profiler·dmesg·uptime·getconf까지. 단어가 많아요. 본인이 자주 빠지는 함정 다섯을 짚고 가요.

첫 번째 학습 함정, 명령 10개를 다 외우려고 한다. 한 시간에 명령 10개 이상 등장. 본인이 "이걸 다 외워야 하나" 끙끙대세요. 안심하세요. **외우는 게 아니라 자주 만나는 거예요.** myinfo alias 한 줄 (§23) 손에 익히세요. 그 한 줄이 6개 명령을 한 묶음으로 자동 실행. 본인이 myinfo 한 단어만 치면 OS 신분증이 나와요. 나머지 4개 명령은 평생 검색이에요. 첫 챕터 H4의 약속 기억하시죠. "외우지 말고 찾는 사람이 되라." 이 약속이 H3에서 또 시험에 들어요. 외우려는 마음이 들면 myinfo 한 줄로 도망가세요. alias가 본인의 진짜 무기예요.

두 번째 학습 함정, sysctl 키 다 외우려고 한다. sysctl이 5,000개 이상의 키를 보여준다(§6의 `sysctl -a | wc -l` 결과). 본인이 그 중 자주 쓰는 5개라도 외우려고 노력하세요. 안심하세요. **sysctl 키는 의미 단위로 묶여요.** kern.* (커널), hw.* (하드웨어), net.* (네트워크), vm.* (가상 메모리). 첫 단어만 외우면 그 묶음 안의 키는 `sysctl kern. | grep XXX` 으로 검색해요. 본인이 정확한 키 이름 모르셔도 묶음 이름만 알면 한 줄로 찾아요. 검색이 외움보다 100배 빨라요. 두 해 후 본인이 새 sysctl 키 만나도 묶음 이름 한 글자에서 시작하시면 풀려요.

세 번째 학습 함정, macOS 명령이 Linux에서 안 된다고 좌절한다. 본인이 두 해 후 EC2 (Linux)에 ssh 들어가서 `sw_vers` 쳤더니 command not found. 좌절감에 빠져요. 안심하세요. **§19의 변환표 한 번 보세요.** sw_vers의 Linux 짝꿍은 `cat /etc/os-release`. sysctl의 짝꿍은 `cat /proc/sys/...`. 짝꿍 한 번씩 보고 가시면 두 OS가 한 손에 들어와요. 그리고 `getconf`·`uname`·`hostname`·`id`·`whoami`·`uptime`은 macOS·Linux 둘 다 똑같이 돌아요. 100% 호환 명령이 절반. 짝꿍 명령이 절반. 외울 게 적어요. 본인이 좌절감 들면 변환표 한 줄 보세요. 30초면 답이 나와요.

네 번째 학습 함정, 환경 변수를 코드에 직접 박아넣는다. 본인이 sysinfo.sh 안에 `USER="mo"` 직접 적어요. 그러면 다른 사람이 본인 스크립트 못 써요. 안심하세요. **셸이 자동으로 채워주는 환경 변수를 쓰세요.** `$USER`, `$HOME`, `$HOSTNAME`. 본인 스크립트가 자동으로 다른 사용자에게서도 동작해요. 그리고 두 해 후 본인이 클라우드 서버에 코드 배포할 때 환경 변수 패턴이 진짜 핵심. **개발/스테이징/프로덕션이 다른 환경 변수로 분기.** Twelve-Factor App의 세 번째 원칙(Config in Environment). 첫 챕터에서 한 번 머리에 두시면 두 해 후 자연스러워요. 환경 변수가 본인 코드의 진짜 인터페이스예요.

다섯 번째 학습 함정, 가장 큰 함정이에요. **신분증을 한 번만 보고 잊는다.** 본인이 오늘 myinfo 한 번 쳐 보고 끝. 두 주 동안 안 다시 봐요. 안심하세요, 함정의 정체부터 풀어드릴게요. **OS 정보는 변해요.** macOS 업데이트, 도구 새로 깔기, ulimit 변경. 6개월 후 본인 환경이 오늘과 달라져요. 그래서 매주 한 번씩 myinfo 돌리세요. 변화를 관찰하세요. "아, 이번 주에 메모리 최대 한도가 늘었네", "아, 어제 OS 업데이트 됐네". 작은 관찰이 큰 사고를 막아요. 두 해 후 본인이 새벽 3시에 ssh로 ec2에 들어가는 그 순간, "이 환경이 어제와 다른가" 확인이 첫 진단이에요. 그 진단 능력이 매주 myinfo 1분에서 자라요. 첫 챕터의 약속 기억하시죠. 매일 컴퓨터의 안부 묻기. 매주 OS 신분증 갱신은 그 약속의 한 단계 깊은 버전이에요.

다섯 가지 환경 점검 학습 함정, 다 들으셨어요. 외우진 마세요. 그저 본인이 빠졌을 때 한 번씩 떠오르시면 돼요. 명령 다 외우기, sysctl 키 다 외우기, macOS·Linux 좌절, 환경 변수 코드 박기, 한 번 보고 잊기. 다섯 함정을 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요. 미리 알면 미리 풀어요.

## 27. 마무리 — H4로

자, 3교시 끝났어요. 본인 손에 OS 신분증 카드 한 장이 들어왔어요. uname·sw_vers·sysctl 세 명령으로 본인 맥의 OS 가 어떤 가족(유닉스), 어떤 버전(macOS 14.5), 어떤 칩(arm64), 어떤 한도들(ulimit)을 가진 사람인지 알게 됐어요. 그리고 myinfo alias 한 줄로 그 모든 걸 한 번에 부를 수 있는 본인만의 도구도 손에 잡았어요.

다음 시간 H4 에서는 OS 명령어 카탈로그를 봐요. ps·top·htop·kill·killall·jobs·bg·fg·nohup. 9개의 일상 명령. 본인이 두 해 동안 매일 만나는 손길들. 그 다음 H5 에서 osinfo.sh 라는 작은 스크립트 한 개를 본인 손으로 직접 짜요. Ch001 H5 의 sysinfo.sh 의 OS 버전. 같은 패턴, 다른 깊이.

그 전에 한 번 멈추시고 본인 .zshrc 에 myinfo alias 한 줄 추가하세요. `source ~/.zshrc` 로 다시 읽어 들이고, 새 터미널에서 `myinfo` 한 번 쳐 보세요. 본인의 OS 신분증이 한 화면에 떠요. 그 한 화면이 본인이 두 해 동안 가장 자주 보게 될 화면 중 하나예요. 첫 화면을 오늘 본인 손으로 만든 거예요. 작은 일이지만 큰 의미. **본인 셸이 본인 도구로 자라나기 시작한 진짜 첫 점.**

3시간이 끝났어요. 8시간 중 3시간, 진행률 37.5%. 본인 잘 따라오셨어요. 박수 한 번 본인에게. 짝짝짝. 잠시 쉬셨다가 H4에서 만나요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - "uname/sw_vers/sysctl/hostname" 4개념은 OS 정보 캐기의 표준 4축. macOS·Linux·BSD 가족 공통. Windows는 PowerShell의 `Get-ComputerInfo`/`$env:OS` 등으로 우회. WSL2 사용 시 자동으로 4축 동작.
> - sysctl 키 네임스페이스(`kern.*`/`hw.*`/`net.*`/`vm.*`)는 BSD 표준. Linux의 `/proc/sys/{kernel,...}` 와 1:1 대응.
> - `/etc/os-release` (systemd 표준)은 2012년경 Linux 주요 배포판이 채택한 통일 형식. 그 이전엔 배포판마다 달랐음.
> - `id` 명령의 UID·GID는 POSIX 표준. uid 0 = root. macOS 일반 사용자는 501부터, Linux는 1000부터. Ch 047 Docker 보안에서 회수.
> - `env`·`printenv`는 같은 일. POSIX는 `env`를 표준화. 환경 변수가 자식 프로세스로 자동 상속되는 메커니즘은 Ch 002 H7에서 다룸.
> - `ulimit`의 soft vs hard limit 분리는 POSIX 표준. soft는 사용자가, hard는 root만 변경 가능. Ch 068 nginx 시간에 정식 학습.
> - `/proc`는 Linux/BSD에 있지만 macOS만 없음. macOS는 `sysctl`·`vm_stat`·`netstat` 등으로 우회.
> - `system_profiler`는 macOS Apple System Profiler 앱의 CLI 버전. 자산 인벤토리 자동화의 표준 도구.
> - `dmesg`는 macOS에서 `sudo dmesg` 또는 `log show` 가 동등. macOS unified logging(2016~)은 dmesg의 진화형.
> - §17 Q4 답변의 "PATH 첫 항목 우선" 은 셸 명령 검색의 기본 동작. `which -a python3` 로 PATH 에 있는 모든 python3 위치 확인. pyenv·rbenv·nvm 같은 버전 매니저는 PATH 의 맨 앞에 자기 shim 폴더를 끼워 넣는 방식으로 동작. Ch 014 venv·pyenv 시간에 정식 학습.
> - §21 Apple Silicon Rosetta 2 분기는 `arch -x86_64 ./binary` 로 명시 강제 가능. `file ./binary` 로 바이너리 아키텍처 확인. Ch 047 Docker 의 `--platform linux/amd64` 옵션과 같은 사상.
> - `getconf PAGE_SIZE` 의 4096 (=4KB) 은 x86 표준. ARM(Apple Silicon)은 16KB 페이지로 동작 가능 (대용량 페이지). Ch 091 성능 튜닝의 TLB(Translation Lookaside Buffer) 시간에 다룸.
> - 분량: 이 H3은 약 19,500자(공백 제외). 음독 시뮬레이션 기준 60~63분. 디벨롭 이력: 2026-04-30 §26 "흔한 실수 환경 점검 학습 편" 신설 +2,200자 / §26 마무리 → §27로 시프트 (마무리 본문도 신설) / 개발자 노트 섹션 신설 (이전엔 부재) / 목차 27항목으로 갱신.
