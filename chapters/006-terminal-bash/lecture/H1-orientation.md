# Ch006 · H1 — 터미널·셸·Bash: 오리엔테이션 — 검은 화면이 다섯 손가락이 되는 길

> **이 H에서 얻을 것**
> - 터미널·셸·Bash 셋의 정의 차이 — 비슷한 말 같지만 셋이 다른 층
> - 4핵심 단어 — 터미널·셸·프로세스·파일시스템. 8H 큰그림의 토대
> - 한 명령어 0.30초 흐름 — 키보드 → 터미널 → 셸 → 커널 → 실행 → 출력 7단계
> - 8H 큰그림 — H2 핵심개념·H3 셋업·H4 명령어 카탈로그·H5 데모 한 줄·H6 운영 스크립트·H7 내부 동작·H8 적용
> - 자경단 5명에 본 챕터가 어떻게 박히는가 — 까미·노랭이·미니·깜장이·본인 각자의 alias

---

## 회수: Ch005의 도구에서 본 챕터의 손가락으로

지난 Ch005에서 본인은 5명 자경단의 협업 도구 30개를 봤어요. branch protection·CODEOWNERS·husky·30개 git/gh 명령어. 그건 **도구의 그림**.

이번 Ch006는 그 도구를 **본인이 직접 만드는 alias·script**로. 손가락이 도구가 되고, 도구가 손가락이 되는 양방향. 자경단의 30개 명령어를 본인이 매번 치는 건 비효율 — 자주 쓰는 13개를 alias로, 5단계 의식을 script로 박으면 손가락이 5분 작업을 5초로.

지난 Ch004 H1은 사진앨범 비유로 git을 소개했고, Ch005 H1은 5명 합의로 협업을 소개했어요. 이번 H1은 **검은 화면**의 비밀이에요. 터미널이 어떻게 본인의 키보드 입력을 0.3초에 컴퓨터의 작업으로 바꾸는가.

---

## 1. 검은 화면 — 왜 이걸 배우나, 7이유

본인의 자경단 노트북 화면 어딘가엔 검은 배경 + 흰 글씨 + 깜박이는 커서. 그 화면이 본인의 5년 개발 도구. **왜 GUI(아이콘 클릭)보다 터미널을 배우나** — 7이유.

### 1-1. 7이유

1. **자동화 가능** — 한 줄로 100파일 처리. GUI는 100번 클릭. 본인의 자경단 강의 챕터 120개 처리 같은 작업이 한 줄.
2. **원격 서버 표준** — AWS·GCP·prod 서버는 GUI 없음. SSH로 터미널만. **서버 만질 수 있어야 인프라**.
3. **복사·자동화** — 한 명령어를 5명이 같이 사용. GUI는 5번 시연. **복사가 협업의 곱셈**.
4. **속도** — 손가락이 마우스보다 5배 빠름. 5년 동안 5만 번 작업하면 차이 무한.
5. **AI 시대의 손가락** — Claude·ChatGPT가 본인에게 명령어 추천. 받아서 한 번에 실행. **AI 친구가 터미널만 보내요**.
6. **gits·docker·k8s 모두 CLI** — 모든 개발 도구가 터미널 우선. GUI는 그 위의 wrapper.
7. **면접 단골** — "터미널에서 가장 큰 파일 찾는 법?" 면접 한 줄 질문. 답이 1초면 시니어, 1분이면 신입.

본인이 검은 화면을 5년 후엔 IDE·브라우저보다 더 자주 봐요. **검은 화면이 본인의 평생 도구**.

### 1-2. 한 줄 데모 — "내 맥에서 가장 큰 파일 5개"

> ▶ **같이 쳐보기** — 한 줄로 5초: 100MB 이상 파일 상위 5개
>
> ```bash
> find ~ -type f -size +100M -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -5
> ```

한 줄로 5초. GUI라면 Finder 5번 + 정렬 + 5분. **한 줄이 5분의 차이**. 본 H가 끝날 때 본인은 이 한 줄을 읽을 수 있어요.

---

## 2. 터미널·셸·Bash 셋의 정의

비슷한 말 같지만 셋이 다른 층.

### 2-1. 터미널 (Terminal)

**검은 창** 자체. 키보드 입력을 받아 글자를 화면에 그리는 GUI 앱. macOS의 `Terminal.app`·`iTerm2`·`Warp`, Windows의 `Windows Terminal`·`ConEmu`, Linux의 `gnome-terminal`.

옛날엔 진짜 하드웨어 — 1970년대 IBM의 검은 박스 + 키보드 + CRT 화면. 컴퓨터 본체와 케이블로 연결. 그 박스가 "terminal" (끝점). 1980년대부터 소프트웨어로 시뮬레이션 (`xterm`). 지금 본인이 macOS Terminal.app 켜면 옛날 하드웨어를 흉내내는 소프트웨어.

### 2-2. 셸 (Shell)

터미널 안에서 실행되는 **프로그램**. 본인 입력을 받아 명령어로 해석하고 실행. 옛날 — `sh` (1971·Bourne shell). 지금 — `bash`·`zsh`·`fish`·`pwsh`.

**자경단 표준 — zsh** (macOS Catalina 2019부터 기본). bash는 Linux 표준. 둘 거의 호환.

### 2-3. Bash (Bourne-Again SHell)

특정 셸의 한 종류. 1989년 Brian Fox 작성. GNU 프로젝트의 표준. Linux의 기본. macOS도 Catalina 전엔 기본.

**자경단 표준 — Bash 호환**. zsh도 거의 호환이라 같은 스크립트 작동.

### 2-4. 한 표

| 층 | 무엇 | 예 | 자경단 표준 |
|----|------|-----|-----------|
| 1. 터미널 (앱) | 키보드·글자 그림 | Terminal.app·iTerm2·Warp | iTerm2 |
| 2. 셸 (프로그램) | 명령어 해석 | bash·zsh·fish·pwsh | zsh (macOS 기본) |
| 3. Bash (셸 종류) | GNU 표준 | bash 5.x | bash 호환 |

**관계** — 터미널이 컨테이너, 셸이 그 안의 프로그램, Bash는 셸 한 종류.

비유 — 터미널 = 텍스트 에디터 창, 셸 = 사용 중인 언어(영어·한국어), Bash = 영어의 한 방언(미국식·영국식).

---

## 3. 4핵심 단어 — 터미널·셸·프로세스·파일시스템

본 챕터 8H의 토대 4개.

### 3-1. 터미널

위에서 봤듯 검은 창. **TTY** (TeleTYpe) 라는 옛날 이름이 그대로. `tty` 명령어로 본인의 터미널 ID 확인:

> ▶ **같이 쳐보기** — 본인이 켜고 있는 터미널의 진짜 ID
>
> ```bash
> tty
> # /dev/ttys003
> ```

### 3-2. 셸

명령어 해석. 본인이 어느 셸 쓰고 있는지:

> ▶ **같이 쳐보기** — 지금 사용 중인 셸 + 기본 셸 두 줄
>
> ```bash
> echo $0          # 현재 사용 셸 (예: zsh)
> echo $SHELL      # 기본 셸 (예: /bin/zsh)
> ```

### 3-3. 프로세스

실행 중인 프로그램. 본인이 한 명령어를 치면 셸이 새 프로세스를 fork·exec. `ps` 명령어로 본인 프로세스 목록:

> ▶ **같이 쳐보기** — 본인 터미널의 프로세스 둘 (zsh + ps 자체)
>
> ```bash
> ps
> ```

PID 12345 = 본인의 zsh 셸. 67890 = `ps` 명령 자체.

### 3-4. 파일시스템

`/` (루트)부터 시작하는 디렉토리·파일 트리. 모든 명령어가 파일에서 시작·파일에 쓰기. **모든 것이 파일**이라는 Unix 철학.

```bash
$ pwd
/Users/mo
$ ls /
Applications  Library  System  Users  bin  etc  tmp  ...
```

### 3-5. 4단어의 관계

```
[터미널 창]
   └── [셸 프로세스 (zsh)]
          └── [실행한 명령어 프로세스 (ls·grep·등)]
                 └── [파일시스템 접근]
```

본인이 `ls /`를 친 한 줄:
1. **터미널**이 키보드 입력 받음
2. **셸**(zsh)이 "ls /"를 해석
3. **셸**이 자식 **프로세스** fork
4. 자식이 `/usr/bin/ls`를 exec
5. ls가 **파일시스템** `/`를 read
6. 결과 출력 → 터미널이 그림

**4 단어가 한 줄 명령어의 흐름**.

---

## 4. 한 명령어 0.30초 — 7단계 흐름

본인이 `ls -la` 친 그 0.30초 안에 7단계.

```
0.000초  [본인 키보드] l-s-space-Enter
0.005초  [터미널] 글자를 셸에 stdin으로 전달
0.010초  [셸] "ls" 파싱 + 옵션 -la 인식
0.015초  [셸] $PATH 검색 → /usr/bin/ls 찾음
0.020초  [셸] fork() → 자식 프로세스 생성
0.025초  [자식] exec("/usr/bin/ls", ["-la"]) → ls 코드 로드
0.100초  [ls] 현재 디렉토리 read + 파일 5~50개 stat
0.250초  [ls] stdout으로 출력 → 터미널이 그림
0.300초  [셸] 자식 종료 wait + 프롬프트 다시
```

**0.30초 안에 7단계**. 본인이 1초 동안 3번 명령어 가능. 5명 자경단이 5분 동안 1,000번 명령어 가능. **속도가 자경단의 비밀**.

---

## 5. 자경단 5명 적용 — 각자의 alias 풍경

자경단 5명이 본 챕터를 어떻게 적용하는가.

### 5-1. 5명 alias 풍경

| 누구 | 자주 쓰는 명령어 | 자경단 alias |
|------|---------------|------------|
| **본인** (메인테이너) | git status·log·gh pr list | `s`·`lg`·`mypr` |
| **까미** (백엔드) | curl·jq·grep·docker | `cj`·`g`·`d` |
| **노랭이** (프론트) | npm run·node·prettier | `nr`·`np`·`pf` |
| **미니** (인프라) | ssh·scp·terraform·aws | `vps`·`tf`·`aw` |
| **깜장이** (디자인·QA) | playwright·screenshot | `pw`·`ss` |

5명이 각자 5~10개 alias. 매일 100번 사용. 1년 36,500번. alias 한 줄이 매일 30초 절약 = 5명 × 1년 = 600시간.

### 5-2. 자경단 공통 alias 5종

`~/.zshrc` 또는 `~/.bashrc`에 5명 모두 박는 공통 5종:

```bash
# 5명 공통 (.zshrc)
alias s='git status -sb'
alias lg='git log --oneline --graph --all -20'
alias ll='ls -lah'
alias cd..='cd ..'
alias mypr='gh pr list --search "review-requested:@me"'
```

5종 × 5명 = 25개 일일 손가락 절약. 5년이면 125시간. **5줄이 평생**.

### 5-3. 자경단 시뮬레이션 — 첫 alias 설정 5분

본인이 자경단 합류 첫 날 5분:

```bash
# 1. ~/.zshrc 열기
$ open ~/.zshrc                  # macOS — VS Code 또는 Finder
# 또는
$ vim ~/.zshrc                   # 터미널 에디터

# 2. 위 5종 alias 추가
# 3. 저장 + 셸 재시작
$ source ~/.zshrc                # 또는 새 터미널 창

# 4. 검증
$ s                              # git status -sb 발동
$ ll                             # ls -lah 발동
```

5분 셋업이 매일 1분 절약 = 1년 6시간 + 5년 30시간.

---

## 6. 8H 큰그림

| H | 슬롯 | 무엇을 다루나 |
|---|------|------------|
| H1 | 오리엔 | 본 H — 검은 화면의 7이유, 4핵심 단어, 0.30초 흐름, 자경단 alias |
| H2 | 핵심개념 | 셸 변수·환경변수·PATH·exit code·subshell·glob·redirection·heredoc 등 8개념 깊이 |
| H3 | 환경점검 | iTerm2·zsh·oh-my-zsh·starship·brew 셋업 + dotfiles 5분 |
| H4 | 명령카탈로그 | 일상 명령어 30개 + 위험도 신호등 — ls·cd·mkdir·cp·mv·rm·find·grep·sed·awk·sort·uniq·wc·head·tail·xargs 등 |
| H5 | 데모 | "내 맥에서 가장 큰 파일 5개" 한 줄 + 자경단 일일 30개 명령어 시연 |
| H6 | 운영/스크립트 | bash 스크립트 작성 — `set -euo pipefail`·function·트랩·옵션 파싱·로그 |
| H7 | 원리/내부 | fork-exec·process group·세션·signal·redirection 내부·환경변수 inheritance |
| H8 | 적용+회고 | Ch006 마무리·자경단 dotfiles·Ch007(Python 입문) 예고 |

---

## 7. 12회수 지도 — 본 챕터가 다른 챕터에서 다시 만나는 곳

| 챕터 | 만나는 주제 |
|------|----------|
| Ch007 Python 입문 1 | `python script.py` 셸에서 실행 |
| Ch008 Python 입문 2 | 셸 if·for vs Python if·for |
| Ch013 모듈·패키지 | `python -m`·sys.argv·환경변수 |
| Ch014 venv·pip | `python -m venv`·activate 스크립트 |
| Ch020 typing | mypy CLI 사용 |
| Ch022 pytest | pytest CLI·conftest·markers |
| Ch041 백엔드 시작 | uvicorn·gunicorn 서버 실행 |
| Ch062 풀스택 통합 | docker-compose CLI |
| Ch091 AWS 배포 | aws CLI·SSH·rsync |
| Ch103 CI/CD | GitHub Actions의 bash steps |
| Ch118 면접 | "터미널 한 줄로 X 하기" 단골 |
| Ch120 회고 | 5년 dotfiles의 진화 |

본 챕터를 깊이 보면 12 챕터의 셸 부분이 매끈히.

---

## 8. 흔한 오해 5가지

**오해 1: "터미널 = 셸 = Bash."** — 셋이 다른 층. 터미널(앱)·셸(프로그램)·Bash(셸 한 종류). H2에서 깊이.

**오해 2: "GUI 시대에 터미널은 옛날 도구."** — AI 시대일수록 터미널 더 중요. Claude·ChatGPT가 본인에게 명령어 추천. AI 친구가 터미널을 통해 일함.

**오해 3: "맥북 사용자는 터미널 안 배워도 돼요."** — 자경단의 5명은 모두 터미널. 맥북 + iTerm2가 자경단 표준. macOS도 Unix 기반.

**오해 4: "셸 명령어는 외우기 어려워."** — 30개 핵심만 매일 반복. 1주일이면 손가락 자동. 5년 후엔 100개도 쉽게.

**오해 5: "터미널 사고는 무서워."** — 위험도 신호등(H4)으로 분류. 빨강 5개만 1초 호흡, 나머지 25개는 안전. 사고 가능성 1%.

---

## 9. FAQ 5가지

**Q1. zsh vs bash 어느 걸 써야?**
A. 자경단 표준 zsh (macOS 기본 + oh-my-zsh 풍부). bash는 Linux 서버 표준이라 둘 다 알면 좋음. 90% 호환.

**Q2. PowerShell도 비슷한가요?**
A. PowerShell은 Windows 표준 + 객체 기반 (Bash는 텍스트 기반). 차이 큼. 자경단 macOS 표준은 zsh.

**Q3. 터미널 멀티 창은 어떻게?**
A. iTerm2의 Cmd+T (탭) + Cmd+D (수직 분할) + Cmd+Shift+D (수평 분할). 한 화면에 4개 창 가능. tmux도 권장 (H3에서).

**Q4. 본인이 zsh 함정을 만나면?**
A. zsh의 글로브·alias 함정은 H2·H4에서 깊이. `setopt nomatch` 같은 옵션으로 우회.

**Q5. 본 챕터의 분량 8H가 너무 많지 않나요?**
A. 셸은 5년 도구라 깊이 있게. 처음 1주일 H1·H2 + 1주일 H3·H4 + 1주일 H5·H6 + 1주일 H7·H8 = 4주. 8주 슬랙 갖고 충분.

---

## 10. 셸의 진화 50년 — Thompson sh부터 AI 시대 Warp까지

본인이 지금 쓰는 zsh의 조상.

| 연도 | 셸 | 누가 | 무엇이 새로 |
|------|-----|------|----------|
| 1971 | **Thompson sh** | Ken Thompson (Bell Labs) | 첫 Unix 셸. 단순한 명령 실행 |
| 1977 | **Bourne sh** | Stephen Bourne (Bell Labs) | sh의 새 버전. 변수·제어 흐름 추가 |
| 1978 | **C shell** (csh) | Bill Joy (Berkeley) | C 문법. history·alias 도입 |
| 1989 | **Bash** | Brian Fox (FSF) | Bourne-Again. GNU 표준. csh + Bourne 통합 |
| 1990 | **zsh** | Paul Falstad (Princeton) | bash + 인터랙티브 강화. tab 자동완성·테마 |
| 2005 | **fish** | Axel Liljencrantz | 사용자 친화 문법. 색깔·문법 검사 |
| 2019 | **macOS Catalina** | Apple | 기본 셸 bash → zsh 변경. 라이선스 이유(GPL) |
| 2022 | **Warp** | Warp Inc | AI 통합 터미널. 명령어 추천·블록 단위 |
| 2024 | **Cursor·Claude Code** | Anthropic 등 | AI가 직접 명령어 생성·실행 |

**50년 진화의 한 줄** — sh(1971) → bash(1989) → zsh(1990) → AI 시대 Warp(2022). 본인이 쓰는 zsh가 50년 진화의 정점이에요. **50년이 본인의 매일 1만 번 손가락**.

자경단 표준 — 2025년 시점 zsh + iTerm2. 1년 후 Warp 또는 Claude Code 도입 검토. **시대가 도구를 만들고, 도구가 협업을 만들어요**.

---

## 11. 자경단 5년 dotfiles — 한 페이지 .zshrc 50줄

본인의 자경단 5년 후 `.zshrc`가 어떻게 진화하나. 50줄 한 페이지.

```bash
# ~/.zshrc — 자경단 본인 (메인테이너)
# 5년 누적 200줄 중 핵심 50줄

# 1. PATH (5줄)
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"           # Apple Silicon brew
export PATH="$HOME/.cargo/bin:$PATH"            # Rust
export PATH="$HOME/.bun/bin:$PATH"              # Bun
export PATH="$HOME/go/bin:$PATH"                # Go

# 2. 환경변수 (5줄)
export EDITOR="code --wait"
export LANG="en_US.UTF-8"
export HOMEBREW_NO_ANALYTICS=1
export NODE_OPTIONS="--max-old-space-size=4096"
export GH_TOKEN="$(cat ~/.config/gh/token)"

# 3. 자경단 alias 5종 (5줄)
alias s='git status -sb'
alias lg='git log --oneline --graph --all -20'
alias ll='ls -lah'
alias mypr='gh pr list --search "review-requested:@me"'
alias fpush='git push --force-with-lease'

# 4. 자경단 function (10줄)
gco() { git switch "$1"; }                     # gco main
gcb() { git switch -c "$1"; }                  # gcb feat/cat-card
catlog() { git log --grep="$1" --oneline; }    # catlog cat-card
prurl() { gh pr view --web; }
ll-size() { du -sh * | sort -hr | head -10; }   # 큰 파일 순

# 5. 셸 옵션 (5줄)
setopt nomatch                                  # 글로브 매치 없으면 에러
setopt no_share_history                         # 셸 간 history 분리
setopt prompt_subst
HISTSIZE=10000
SAVEHIST=10000

# 6. plugin (oh-my-zsh) (10줄)
ZSH=$HOME/.oh-my-zsh
plugins=(git docker kubectl npm rust gh)
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# 7. starship 프롬프트 (5줄)
eval "$(starship init zsh)"

# 8. 자경단 함수 (5줄)
quickfix() {
  git switch main && git pull --rebase && git switch -c "fix/$1"
}
```

**50줄이 5년의 손가락**. 본인이 첫 1주일에 5줄 시작 → 1개월 20줄 → 6개월 50줄 → 5년 200줄. **줄 한 줄이 매일 30초**.

자경단 5명의 dotfiles를 GitHub repo (`cat-vigilante/dotfiles`)에 공유. 5명의 한 페이지가 1,000줄. **dotfiles가 협업의 보너스**.

---

## 12. AI 시대의 셸 — Claude·Cursor·Warp의 새 패러다임

2024년부터 셸이 AI와 통합. 본인의 자경단 5년 후엔 셸이 어떻게 바뀌나.

### 12-1. 옛 패러다임 (2023년까지)

본인이 명령어를 모르면 → Google 검색 → Stack Overflow → 복사 → 셸에 붙여 넣기 → 한 번 더 물어 → 결국 한 줄. **5분의 검색 + 1분 적용**.

### 12-2. 새 패러다임 (2024년 이후)

본인이 명령어를 모르면 → Claude·ChatGPT에 한 줄 질문 → AI가 한 줄 답 → 본인이 셸에 한 번 실행 → 1초. **5분 → 1초**.

### 12-3. AI가 셸을 직접 — Claude Code·Warp

더 깊은 진화 — AI가 본인 노트북의 셸에 직접 명령어를 실행. 본인은 결과만 보고 OK·NO. Claude Code의 Bash 도구·Warp의 AI 명령. **본인의 손가락이 AI에 위임**.

### 12-4. 자경단의 AI 시대 손가락

자경단 5명이 2026년에 사용하는 AI 셸 도구:
- 본인 — Claude Code (전체 자경단 강의 작성·코드 리뷰)
- 까미 — Cursor (백엔드 자동완성)
- 노랭이 — Warp (프론트 작업 + AI 명령)
- 미니 — gh-copilot (GitHub Actions 디버깅)
- 깜장이 — ChatGPT (디자인 ↔ 코드 변환)

5명이 AI 5도구. **AI가 자경단의 6번째 멤버**. 본인이 평생 셸을 알아야 AI도 더 잘 활용. **AI가 셸을 대체하지 않고, 셸을 가속**.

### 12-5. AI 시대 셸 학습 황금 규칙

1. 셸 80% 이해 + AI 20% 보조 = 5년 후 시니어
2. 셸 0% + AI 100% 의존 = 5년 후 답답함
3. 셸 100% + AI 0% = 시간 낭비

자경단 표준 — **80/20 비율**. 본 챕터의 8H가 80% 학습. AI는 20% 가속.

---

## 추신

검은 화면은 본인의 평생 도구이고 4핵심 단어(터미널·셸·프로세스·파일시스템)가 토대예요. 0.30초 7단계가 본인 매일 1만 번이고, 본인 첫 alias를 오늘 박으세요. 터미널은 1970년대 IBM 검은 박스의 후예 — 옛 하드웨어가 소프트웨어로 환생. 셸은 Thompson sh(1971) → Bash(1989) → zsh(1990) 진화. macOS Catalina(2019)부터 zsh 기본인 이유는 라이선스(bash GPL v3 회피).

AI 시대의 손가락 — Claude가 명령어를 추천하면 본인이 받아 한 번에 실행. **AI + 터미널 = 시니어**. 자경단 5명이 각자 dotfiles를 GitHub repo로 공유 — PR로 alias 추가, 5명 리뷰. 본인 1년 후 dotfiles 200~500줄, 5명 합집합 1,000줄이 자경단 wiki. 셋업 비율 — 셸 80% + AI 20%가 자경단 표준이고, 0/100 의존이나 100/0 비효율 둘 다 위험해요.

본 H를 끝낸 본인이 한 가지 행동 — `tty`·`echo $0`·`ps`·`pwd` 4 명령어를 차례로 쳐 보세요. 4초의 실험이 평생 직관이에요. 다음 H2는 핵심개념 — 셸 변수·환경변수·PATH·exit code·subshell·glob·redirection·heredoc 8개념 깊이. 본 H의 4단어가 H2의 8개념으로 풀려요. 🐾

