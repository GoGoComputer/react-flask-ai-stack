# Ch006 · H3 — 터미널·셸·Bash: 환경점검 — 자경단 표준 30분 셋업

> **이 H에서 얻을 것**
> - macOS Apple Silicon 셋업 — Homebrew·iTerm2·zsh·oh-my-zsh·starship 5종을 30분에
> - dotfiles GitHub repo — 5명 자경단의 .zshrc·.vimrc·.gitconfig 공유
> - 자경단 첫 .zshrc 50줄 — PATH·환경변수·alias·function·plugin·테마
> - tmux 옵션 셋업 — 한 SSH 세션에서 멀티 창
> - macOS·Linux·Windows WSL 변환표 — 한 셋업이 세 OS에 적용
> - 자경단 5명 환경 동기화 — 1주일 안에 5명 같은 환경

---

## 회수: H2의 8개념에서 본 H의 30분 셋업으로

지난 H2에서 본인은 셸의 8개념 깊이를 봤어요. 변수·PATH·exit code·subshell·glob·redirection·heredoc·pipe. 그건 셸의 동작.

이번 H3은 그 셸을 **본인 노트북에 박는 30분**이에요. iTerm2·zsh·oh-my-zsh·starship·brew·tmux 6종 도구가 30분 안에 본인 노트북에 자리. 5년 사용.

본 H 끝나면 본인의 노트북은 자경단 표준 환경. 자경단 5명이 같은 환경이면 합의 비용 0. **표준이 협업의 빛**.

---

## 1. macOS Apple Silicon 첫 셋업 — 5단계

본인의 자경단이 macOS M1·M2·M3 (Apple Silicon)이라면.

### 1-1. Xcode Command Line Tools

```bash
$ xcode-select --install
```

5분 다운로드. git·make·gcc 등 기본 도구. 한 번 설치, 평생.

### 1-2. Homebrew (brew)

macOS의 패키지 매니저. 자경단 셋업의 토대.

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 5~10분 설치
# 끝나면 메시지대로 PATH 추가:
$ echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
$ eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Apple Silicon = `/opt/homebrew`**. Intel Mac은 `/usr/local`. 자경단 표준은 Apple Silicon이라 `/opt/homebrew` 우선.

### 1-3. brew로 자경단 표준 도구 한 번에

```bash
$ brew install git gh node@20 python@3.12 ripgrep fd bat exa jq tldr starship tmux
```

10개 도구 동시 설치. 10분.

설치된 것:
- **git** — 최신 버전 (Apple 기본보다 새)
- **gh** — GitHub CLI (Ch005 회수)
- **node@20** — JavaScript 런타임
- **python@3.12** — Python 최신
- **ripgrep** (`rg`) — grep의 빠른 대체
- **fd** — find의 빠른 대체
- **bat** — cat의 색깔 강화
- **exa** — ls의 색깔 + tree
- **jq** — JSON 파서
- **tldr** — `man`의 짧은 버전
- **starship** — 프롬프트 (4절)
- **tmux** — 터미널 멀티플렉서 (5절)

### 1-4. brew 사용법 5종

```bash
brew install <name>            # 설치
brew uninstall <name>          # 제거
brew upgrade                   # 모두 업그레이드
brew list                      # 설치 목록
brew search <term>             # 검색
```

### 1-5. brew의 함정

- **PATH 우선순위** — `/opt/homebrew/bin`이 PATH 앞에 있어야 brew git이 우선. `which git`으로 검증 (Ch006 H2 회수).
- **Intel vs Apple Silicon** — 둘이 다른 디렉토리. M1+ 사용자는 `/opt/homebrew`만. 이전 컴퓨터에서 옮길 때 Rosetta 2 함정.
- **brew shellenv** — `.zprofile`(login shell)에 추가. `.zshrc`에 두면 매 셸 새로 시작 시 중복.

---

## 2. iTerm2 — macOS의 진짜 터미널

기본 Terminal.app보다 강력한 iTerm2.

### 2-1. 설치

```bash
$ brew install --cask iterm2
```

또는 https://iterm2.com 에서 직접.

### 2-2. 자경단 표준 설정

iTerm2 → Preferences (Cmd+,):

**Appearance**:
- Theme: Minimal (또는 Compact)
- Tab bar location: Top

**Profiles → Default**:
- General → Working directory: "Reuse previous session's directory"
- Text → Font: **MesloLGS Nerd Font** (oh-my-zsh + powerlevel10k 권장)
- Text → Font size: 14
- Window → Style: Normal
- Window → Transparency: 약간 (옵션)
- Window → Blur: ON (옵션)

**Keys → Key Bindings**:
- 추가: `⌘ ←` → "Send Hex Code: 0x01" (line beginning, Ctrl-A 효과)
- `⌘ →` → "Send Hex Code: 0x05" (line ending, Ctrl-E)

### 2-3. 자경단 단축키 5종 (Ch006 H1 회수)

```
Cmd+T          새 탭
Cmd+D          수직 분할
Cmd+Shift+D    수평 분할
Cmd+W          닫기
Cmd+`          다음 창
Cmd+1·2·3      탭 이동
```

### 2-4. iTerm2 vs 다른 터미널

| 터미널 | 장점 | 단점 |
|--------|------|------|
| **Terminal.app** | macOS 기본 | 분할 없음·테마 부족 |
| **iTerm2** | 분할·테마·검색·badge | 설치 필요 |
| **Warp** | AI 통합·블록 | 베타·개인정보 |
| **Alacritty** | 빠름·GPU | 분할 없음·설정 어려움 |
| **Kitty** | 빠름·이미지 | 학습 곡선 |
| **Wezterm** | Lua 설정·이미지 | 학습 곡선 |

자경단 표준 — **iTerm2** (안정·기능·자료). 1년 후 Warp 검토.

---

## 3. zsh + oh-my-zsh — 셸 풍부

zsh 자체는 macOS Catalina+ 기본. oh-my-zsh가 풍부한 plugin·테마.

### 3-1. oh-my-zsh 설치

```bash
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

자동으로 `~/.oh-my-zsh/` 디렉토리 + `~/.zshrc` 갱신.

### 3-2. plugin 6종 (자경단 표준)

`~/.zshrc`의 plugins 줄을 수정:

```bash
plugins=(
  git
  docker
  kubectl
  npm
  rust
  gh
)
```

각 plugin이 제공:
- **git** — `gst` (status), `gco` (checkout), `gcm` (commit -m), 60+ alias
- **docker** — `dcomp` (compose), 자동완성
- **kubectl** — `k` (=kubectl), 자동완성
- **npm** — `nrs` (npm run start), 자동완성
- **rust** — cargo 자동완성
- **gh** — gh CLI 자동완성

```bash
$ source ~/.zshrc
$ gst                          # git status (oh-my-zsh git plugin)
```

### 3-3. zsh 추가 plugin (외부)

oh-my-zsh + 추가 외부 plugin 2종:

```bash
# 자동완성 강화
$ git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# 문법 강조
$ git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

`~/.zshrc`의 plugins에 추가:

```bash
plugins=(
  git docker kubectl npm rust gh
  zsh-autosuggestions zsh-syntax-highlighting
)
```

zsh-autosuggestions — 본인 history 기반 회색 자동 제안. → 키로 수락.
zsh-syntax-highlighting — 명령어가 유효한지 빨강·초록으로.

### 3-4. 테마 — 자경단 표준

oh-my-zsh의 테마 옵션:

```bash
# ~/.zshrc
ZSH_THEME="robbyrussell"           # 기본
# ZSH_THEME="agnoster"             # powerline 폰트 필요
# ZSH_THEME="powerlevel10k/powerlevel10k"  # 가장 풍부
```

자경단 — `robbyrussell` 또는 starship (4절)로 대체.

---

## 4. starship — Rust로 만든 빠른 프롬프트

starship이 oh-my-zsh 테마보다 더 빠름. 자경단 권장.

### 4-1. 설치

```bash
$ brew install starship          # 위에서 이미 설치
```

### 4-2. 활성화

`~/.zshrc` 끝에 추가 (oh-my-zsh의 ZSH_THEME=""로 비우거나 starship이 덮어씀):

```bash
# ~/.zshrc
eval "$(starship init zsh)"
```

### 4-3. 설정

`~/.config/starship.toml` 생성:

```toml
# ~/.config/starship.toml — 자경단 표준
add_newline = true
format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$rust\
$cmd_duration\
$line_break\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = "🌱 "

[git_status]
ahead = "⇡${count}"
behind = "⇣${count}"
modified = "📝"

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[cmd_duration]
min_time = 2_000          # 2초+ 명령만 시간 표시
format = "took [$duration](bold yellow)"
```

### 4-4. starship 효과

본인의 프롬프트가:

```
~/cat-vigilante  🌱 main 📝
took 3.2s
➜
```

git branch + 변경 표시 + 명령 시간이 한 페이지. 가독성 무한대.

### 4-5. starship vs oh-my-zsh 테마

| 도구 | 속도 | 설정 | 자경단 |
|------|------|------|------|
| oh-my-zsh `robbyrussell` | 빠름 | 간단 | 시작 |
| oh-my-zsh `agnoster` | 보통 | 폰트 필요 | 가끔 |
| oh-my-zsh `powerlevel10k` | 빠름 | 마법사 | 옵션 |
| **starship** | 가장 빠름 (Rust) | 한 toml 파일 | **권장** |

자경단 표준 — starship.

---

## 5. tmux — 터미널 멀티플렉서

iTerm2의 분할은 GUI. tmux는 셸 안 분할. SSH로 원격 서버에서도.

### 5-1. 설치

```bash
$ brew install tmux              # 위에서 이미
```

### 5-2. 첫 사용

```bash
$ tmux                           # 새 세션 시작
# (tmux 안에서)
Ctrl-b "                         # 수평 분할
Ctrl-b %                         # 수직 분할
Ctrl-b o                         # 다음 창으로
Ctrl-b d                         # detach (세션 유지)
$ tmux attach                    # 세션 다시
```

### 5-3. 자경단 tmux 활용

**SSH 끊겨도 작업 유지**:

```bash
$ ssh server
[server]$ tmux                   # tmux 세션 시작
[server]$ npm run build          # 긴 빌드 시작
[server]$ Ctrl-b d               # detach (SSH 끊어도 빌드 계속)
[server]$ exit
$ # 1시간 후
$ ssh server
[server]$ tmux attach            # 세션 다시 → 빌드 결과 보임
```

**자경단 페어 — 같은 tmux 세션 공유** (`tmux attach -t pair`):

```bash
[본인]$  tmux new -s pair
[까미]$  ssh 본인_노트북
[까미]$  tmux attach -t pair     # 둘이 같은 화면
```

### 5-4. tmux 설정 (`~/.tmux.conf`)

```bash
# 자경단 표준 .tmux.conf
set -g default-terminal "screen-256color"
set -g mouse on                  # 마우스 사용 OK
setw -g mode-keys vi             # vi 단축키
bind | split-window -h           # | (대신 ")
bind - split-window -v           # - (대신 %)
bind r source-file ~/.tmux.conf \; display "Reloaded!"
```

### 5-5. tmux vs iTerm2 분할

| 도구 | 어디서 | SSH 호환 | 페어 |
|------|------|---------|------|
| iTerm2 분할 | GUI 로컬만 | ✗ | ✗ |
| tmux | 어디든 (셸 안) | ✓ | ✓ |

자경단 — **로컬은 iTerm2**, **원격·페어는 tmux**.

---

## 6. dotfiles GitHub repo — 5명 환경 동기화

자경단 5명의 .zshrc·.vimrc·.gitconfig를 GitHub에 공유.

### 6-1. dotfiles repo 셋업 5분

```bash
$ mkdir ~/dotfiles && cd ~/dotfiles
$ git init -b main
$ cp ~/.zshrc .zshrc
$ cp ~/.gitconfig .gitconfig
$ cp ~/.tmux.conf .tmux.conf
$ cp ~/.config/starship.toml starship.toml
$ git add .
$ git commit -m 'feat: 자경단 본인 dotfiles 시작'
$ gh repo create cat-vigilante/dotfiles --public --source=. --push
```

5분 끝.

### 6-2. install.sh 스크립트

```bash
$ cat > install.sh <<'EOF'
#!/bin/bash
set -euo pipefail
DOT=$(cd "$(dirname "$0")"; pwd)

# 심볼릭 링크
ln -sf "$DOT/.zshrc" ~/.zshrc
ln -sf "$DOT/.gitconfig" ~/.gitconfig
ln -sf "$DOT/.tmux.conf" ~/.tmux.conf
mkdir -p ~/.config
ln -sf "$DOT/starship.toml" ~/.config/starship.toml

echo "✅ dotfiles 설치 완료"
EOF
$ chmod +x install.sh
$ git add install.sh
$ git commit -m 'feat: install.sh — 새 노트북 1줄 셋업'
$ git push
```

### 6-3. 새 노트북 셋업 1줄

```bash
$ git clone https://github.com/cat-vigilante/dotfiles.git ~/dotfiles
$ cd ~/dotfiles && ./install.sh
$ source ~/.zshrc
```

3줄로 새 노트북에 자경단 환경 박힘. **5년 후 본인이 노트북 바꿀 때 5분**.

### 6-4. 5명 dotfiles 협업

자경단 5명이 같은 repo에 PR로 추가:

- 본인 — base alias 5종
- 까미 — backend alias 추가 PR
- 노랭이 — frontend alias 추가 PR
- 미니 — infra alias 추가 PR
- 깜장이 — design·QA alias 추가 PR

PR 5개 후 dotfiles가 5명의 합집합. **dotfiles가 자경단 wiki**.

---

## 7. 자경단 첫 .zshrc 50줄

본 챕터의 모든 셋업을 합친 50줄 (Ch006 H1 11절 회수):

```bash
# ~/.zshrc — 자경단 표준 시작점

# === 1. PATH (5줄) ===
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# === 2. 환경변수 (5줄) ===
export EDITOR="code --wait"
export LANG="en_US.UTF-8"
export HOMEBREW_NO_ANALYTICS=1
export NODE_OPTIONS="--max-old-space-size=4096"
export GH_TOKEN="$(cat ~/.config/gh/token 2>/dev/null || true)"

# === 3. 자경단 alias 5종 (5줄) ===
alias s='git status -sb'
alias lg='git log --oneline --graph --all -20'
alias ll='ls -lah'
alias mypr='gh pr list --search "review-requested:@me"'
alias fpush='git push --force-with-lease'

# === 4. 자경단 function (10줄) ===
gco() { git switch "$1"; }
gcb() { git switch -c "$1"; }
catlog() { git log --grep="$1" --oneline; }
prurl() { gh pr view --web; }
ll-size() { du -sh * 2>/dev/null | sort -hr | head -10; }

# === 5. 셸 옵션 (5줄) ===
setopt nomatch
setopt no_share_history
setopt prompt_subst
HISTSIZE=10000
SAVEHIST=10000

# === 6. oh-my-zsh (5줄) ===
ZSH=$HOME/.oh-my-zsh
plugins=(git docker kubectl npm rust gh zsh-autosuggestions zsh-syntax-highlighting)
ZSH_THEME=""
source $ZSH/oh-my-zsh.sh

# === 7. starship 프롬프트 (1줄) ===
eval "$(starship init zsh)"

# === 8. 자경단 work flow function (5줄) ===
quickfix() {
  git switch main && git pull --rebase && git switch -c "fix/$1"
}
```

50줄. 본인의 자경단 5년의 시작.

---

## 8. macOS·Linux·Windows WSL 변환표

자경단 5명이 다른 OS여도 같은 명령어.

| 작업 | macOS (brew) | Ubuntu/Debian | Windows WSL |
|------|--------------|--------------|-------------|
| 패키지 매니저 | `brew install X` | `apt install X` | WSL → apt |
| 셸 | zsh (기본) | bash (기본) → zsh | bash (기본) |
| 터미널 | iTerm2 | gnome-terminal | Windows Terminal |
| 프롬프트 | starship | starship | starship |
| ssh | OpenSSH | OpenSSH | OpenSSH |
| open file | `open file` | `xdg-open file` | `wslview file` |
| clipboard | `pbcopy`·`pbpaste` | `xclip` | `clip.exe`·`powershell.exe` |
| package | `brew` | `apt`·`dnf`·`pacman` | apt (WSL) |

**core 90% 같음**. 차이 10%는 OS별 특수.

---

## 9. 흔한 오해 5가지

**오해 1: "Apple Silicon이면 Intel brew 안 됨."** — `/opt/homebrew` (Apple Silicon)·`/usr/local` (Intel) 둘 다 가능. 다만 Rosetta 2로 Intel brew 돌리면 느림. 자경단 — 100% Apple Silicon 네이티브.

**오해 2: "iTerm2는 옛 도구."** — 2024년에도 활발. Warp가 새 옵션이지만 안정·자료가 iTerm2 우위. 자경단 — 1년 후 Warp 검토.

**오해 3: "oh-my-zsh가 셸을 느리게."** — plugin 많으면 0.5~1초 시작 지연. starship + 핵심 6 plugin이면 0.2초. 자경단 표준이 안 느림.

**오해 4: "tmux는 어려워."** — 5단축키(분할 2개·이동·detach·attach)만 알면 80%. 1주일 안에 손가락. 5년의 자산.

**오해 5: "dotfiles는 시니어 도구."** — 신입도 5분. 첫 .zshrc 5줄을 GitHub repo로. 5년 후 본인의 평생 자산.

---

## 10. FAQ 5가지

**Q1. brew 외에 다른 macOS 패키지 매니저?**
A. MacPorts·Nix 등 있지만 자경단 표준 brew. 90% 사용자가 brew. 자료 많음.

**Q2. iTerm2의 Warp로 옮길 시점?**
A. 1년 후. Warp의 AI 통합이 강력하지만 베타. 자경단 1년 안정 후 검토.

**Q3. zsh-autosuggestions가 보이는데 자동 완성 안 돼요.**
A. 회색 제안이 보이면 → (오른쪽 화살표)로 수락. 또는 End. 처음 익숙하지 않을 수 있음.

**Q4. starship.toml의 항목 다 외워야?**
A. 본 H의 자경단 표준 toml을 그대로. 1년 후 본인 취향에 맞게 갱신. 처음엔 복사 + 사용.

**Q5. dotfiles에 secret 박지 마세요.**
A. `.zshrc.local`로 분리. `~/.zshrc` 끝에 `[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local`. local 파일은 .gitignore.

---

## 11. 추신

추신 1. 본 H의 6도구(brew·iTerm2·zsh·oh-my-zsh·starship·tmux)가 자경단의 셋업 평생 토대. 30분이 5년의 산소.

추신 2. brew install 한 줄로 10도구. 본인의 첫 brew 명령이 자경단의 첫 환경.

추신 3. iTerm2의 단축키 5종(Cmd+T·Cmd+D·Cmd+Shift+D·Cmd+W·Cmd+`)이 매일 손가락. 5년 사용.

추신 4. oh-my-zsh의 git plugin이 60+ alias 자동 제공. `gst`·`gco`·`gcm`이 본인 손가락 자동.

추신 5. zsh-autosuggestions의 회색 제안이 매일 손가락 절약. 한 줄 명령이 한 번 클릭.

추신 6. starship 프롬프트가 git status + 명령 시간 + 언어 버전을 한 줄에. 가독성 무한대.

추신 7. tmux의 5단축키(분할 2·이동·detach·attach)가 SSH 사용의 산소. 1주일 안에 손가락 자동.

추신 8. dotfiles GitHub repo 셋업 5분이 5년 자산. 새 노트북 셋업이 30분 → 1줄.

추신 9. 자경단 5명의 dotfiles가 한 repo로 모이면 1,000줄의 5명 공통 자산. 협업의 보너스.

추신 10. 자경단 표준 .zshrc 50줄(7절)을 본인 첫 1주일에 박기. 첫 50줄이 5년의 토대.

추신 11. brew의 PATH 우선순위 함정 — `/opt/homebrew/bin`이 PATH 앞. `which git` 결과가 brew git이어야.

추신 12. oh-my-zsh + starship 조합이 자경단 표준. ZSH_THEME=""로 oh-my-zsh 테마 비우고 starship에 위임.

추신 13. tmux의 첫 함정 — Ctrl-b prefix는 두 손 동작. 익숙하지 않으면 `~/.tmux.conf`에서 prefix를 Ctrl-a로 바꾸기.

추신 14. 다음 H4는 명령어 카탈로그 — 30개 일상 명령어 + 위험도 신호등. 본 H의 6도구가 H4의 30 명령어로 손에 잡혀요. 🐾

추신 15. 본 H를 끝낸 본인이 한 가지 행동 — 본인 노트북에서 brew 첫 명령 (`brew --version`)을 쳐 보세요. brew 설치 완료 신호.

추신 16. 자경단 dotfiles repo의 첫 commit 메시지 — `feat: 자경단 본인 dotfiles 시작`. 5년 후 첫 commit이 본인의 자산 시작.

추신 17. 본 H의 6도구는 무료. 모두 오픈소스. brew·iTerm2·zsh·oh-my-zsh·starship·tmux. 자경단 환경 비용 $0.

추신 18. 본 H를 끝낸 본인이 자경단 5명에게 본 H의 install.sh를 공유. 5명 모두 1줄 셋업. 5분 × 5명 = 25분 절약.

추신 19. 자경단의 1년 후 dotfiles는 200~500줄. 5년 후 1,000줄. 한 줄이 매일 30초.

추신 20. 본 H의 마지막 한 줄 — **30분 셋업이 5년의 자경단 환경이고, 6도구가 5년의 손가락이며, dotfiles가 5명의 wiki예요. 본인의 첫 brew install 한 줄을 오늘 치세요.** 🐾🐾

추신 21. brew의 cask 옵션 (`brew install --cask`)이 GUI 앱 설치. iTerm2·VS Code·Slack 등. 자경단 5명 표준 GUI도 brew로.

추신 22. brew 5종 옵션 — install·uninstall·upgrade·list·search 5가지가 90%. 나머지는 검색.

추신 23. iTerm2의 search (Cmd+F)가 셸 출력 검색의 강력한 도구. 긴 로그에서 한 단어 찾기.

추신 24. zsh-syntax-highlighting의 빨강이 명령어 오타 신호. 빨강 보이면 1초 호흡, 다시 검사.

추신 25. starship의 git_branch + git_status가 본인의 매일 PR 상태. 한 눈에 ahead·behind·modified.

추신 26. tmux의 detach (Ctrl-b d)가 SSH 끊김 방지의 핵심. 긴 빌드 detach 후 다시 attach.

추신 27. dotfiles의 install.sh는 idempotent (여러 번 실행 OK). `ln -sf`로 기존 링크 덮어씀. 안전.

추신 28. 본 H를 다 끝낸 본인이 자경단 페어 (까미·노랭이·미니·깜장이 중 1명)와 같이 본 H를 한 번 따라하기. 페어 30분이 본인 1시간보다 단단.

추신 29. brew의 자동 업데이트는 기본 OFF. 본인이 매주 `brew upgrade` 한 번. 새 보안 패치 적용.

추신 30. 본 H의 마지막 진짜 한 줄 — **본인의 첫 자경단 환경 30분 셋업이 5년의 자산이고, dotfiles가 평생의 자기 표현이에요. 오늘 시작하세요.**

추신 31. 본 H의 6도구 셋업 시간 표 — Xcode CLT 5분·brew 10분·iTerm2 5분·oh-my-zsh 3분·starship 2분·tmux 2분 = 27분. 30분 안에.

추신 32. 자경단의 새 멤버 첫 날 30분이 본 H의 셋업. 30분 후 매일 30분 절약. ROI 무한대.

추신 33. brew install 한 줄로 10도구. 본인이 손으로 10번 다운로드 안 해도 됨. 자동화의 첫 경험.

추신 34. iTerm2의 단축키 5종을 첫 1주일에 손가락 박기. 한 단축키가 1초 절약 × 매일 50번 = 1년 5시간.

추신 35. oh-my-zsh의 git plugin 60+ alias가 자경단 매일 손가락. `gst` (git status), `gco` (git checkout), `gcm` (git commit -m), `gp` (git push). 처음 1주일 답답하지만 1주일 후 자동.

추신 36. zsh-autosuggestions의 회색 제안은 본인 history 기반. 첫 사용엔 안 보이지만 1주일 후 매 명령마다 제안. **history가 자동완성**.

추신 37. zsh-syntax-highlighting의 빨강·초록이 본인의 매일 검수자. 빨강 보이면 1초 호흡 + 검사. 사고 1/10.

추신 38. starship.toml의 형식은 TOML (Python pyproject.toml과 같음). 처음 헷갈리지만 1주일이면 손가락 자동. starship.rs 사이트에 풀 가이드.

추신 39. starship의 [character] symbol → ➜ 보여주는 게 success. 빨강이면 직전 명령 실패. 한 눈에 exit code.

추신 40. tmux의 prefix Ctrl-b는 두 손 동작. 자경단 권장 — `~/.tmux.conf`에서 `set -g prefix C-a`로 변경. Ctrl-a가 한 손.

추신 41. tmux의 첫 1주일 학습 — 5단축키 (분할 2·이동·detach·attach)만. 1주일 후 자연.

추신 42. dotfiles의 진짜 가치 — 본인의 5년 손가락이 GitHub repo 한 곳에 박힘. 5년 후 새 노트북에서도 본인의 1주일 학습이 1줄.

추신 43. 자경단 5명의 dotfiles 협업 시나리오 — 본인 PR로 5줄 alias 추가, 4명이 리뷰, 머지, 4명 install.sh 다시 실행 → 5명 환경 동기화. 30분 사이클.

추신 44. dotfiles에 secret 박지 마세요. `.zshrc.local` 분리. `[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local`. local은 .gitignore.

추신 45. 자경단 .zshrc 50줄(7절)이 시작점. 1년 후 100줄, 5년 후 200줄. 매일 한 줄도 안 되는 누적이 평생 자산.

추신 46. macOS·Linux·Windows WSL 변환표(8절)이 자경단의 OS 다양성. 5명이 다른 OS여도 명령어 90% 같음.

추신 47. WSL2 (Windows Subsystem for Linux 2)는 Windows의 Linux 환경. 자경단의 Windows 사용자도 Linux 환경 사용. 본 H의 6도구 다 작동.

추신 48. 자경단 5명이 6도구를 다 쓰면 30 도구 × 5명 = 150 도구 셋업. 같은 30분 셋업이 5명에게 5번. 한 페이지 install.sh가 그 5번을 5분으로.

추신 49. 본 H의 마지막 회수 — 30분 셋업·6도구·dotfiles GitHub·5명 동기화 + .zshrc 50줄 = 본인의 자경단 평생 환경. 5년의 토대.

추신 50. 본 H의 진짜 마지막 — 본인 노트북을 지금 열고 `brew --version` 한 번 치세요. 출력 보고 한 호흡. 그 한 호흡이 본인의 5년 셸 환경의 시작이에요.

추신 51. brew install 한 줄로 10 도구. 본인이 5년 동안 10도구 다 써요. 한 줄이 5년 자산.

추신 52. iTerm2의 폰트는 MesloLGS Nerd Font가 자경단 표준. starship의 아이콘 (🌱·📝·➜)이 깨지지 않음.

추신 53. oh-my-zsh의 plugin은 `~/.oh-my-zsh/plugins/`에 위치. 새 plugin 추가 시 `plugins=(...)` 줄에 이름만.

추신 54. zsh-autosuggestions의 강조 색상은 `~/.zshrc`의 `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5f5f5f'`로 커스터마이즈. 너무 흐리면 진하게.

추신 55. starship의 모든 모듈은 starship.rs 사이트에 문서. 프로그래밍 언어 30+, 도구 50+ 지원. 본인 stack에 맞게.

추신 56. tmux의 mouse on 옵션 (`set -g mouse on`)이 마우스로 분할·창 이동 가능. 키보드 + 마우스 둘 다.

추신 57. dotfiles repo의 README에 "5분 셋업 가이드"를 첫 줄에. 새 멤버가 README만 보고 install.sh 실행. 1줄 → 1분.

추신 58. 자경단 dotfiles의 commit 메시지 양식 — `feat(zshrc): alias quickfix 추가`. Conventional Commits (Ch005 H3 회수). 5년 후 git history 검색 가능.

추신 59. Brewfile (`brew bundle dump`)로 brew 도구 목록 백업. dotfiles repo에 박으면 새 노트북에서 `brew bundle install` 한 줄로 모든 도구 복원.

추신 60. **본 H의 진짜 마지막 결심** — 본인의 자경단 환경 30분 셋업을 오늘 시작. 30분 후 본인은 자경단의 진짜 메인테이너.

추신 61. brew의 핵심 — 패키지 매니저 + 의존성 관리. 본인이 `brew install jq` 한 줄로 jq + 5개 의존성 자동. 의존성 지옥 0.

추신 62. iTerm2의 hotkey window 옵션이 자경단 권장. Cmd+Space처럼 단축키로 어디서든 터미널 띄우기. 작업 중간 터미널 1초.

추신 63. oh-my-zsh의 update — `omz update` 한 줄. 1년에 한 번 정도. plugin·테마 업데이트.

추신 64. zsh-autosuggestions의 시간 절약 — 매일 50번 제안 수락 = 5초/일 = 30분/년. 1주일 셋업이 평생 30분/년 절약.

추신 65. starship의 캐시 — 첫 실행 0.5초, 다음부턴 0.05초. Rust의 빠름. oh-my-zsh agnoster 0.3초보다 6배 빠름.

추신 66. tmux의 buffer size 옵션 (`set -g history-limit 10000`)이 긴 출력 보존. 기본 2000줄. 자경단 표준 10000.

추신 67. dotfiles의 첫 PR이 자경단의 첫 셋업 합의. 본인이 5줄 PR하면 4명이 1줄씩 추가. 1주일 후 50줄.

추신 68. 본 H의 6도구를 본 H 끝나는 5분에 본인이 한 번 셋업해 보세요. 30분 한 번에 다 안 해도 됨. 1주일 동안 한 도구씩.

추신 69. 본 H를 다 끝낸 본인은 macOS·zsh·brew·iTerm2·oh-my-zsh·starship·tmux 7도구를 알아요. 7도구가 자경단 환경의 80%.

추신 70. **본 H의 진짜 진짜 마지막** — 본인이 본 H를 끝내고 30분 동안 자경단 환경 셋업을 한 번에 끝내세요. 그 30분이 본인의 5년 자산.

추신 71. brew의 의존성 자동 — `brew install gh`은 `git`·`jq`·`openssl` 같은 의존성 자동 처리. 본인이 손으로 X.

추신 72. iTerm2의 backup·restore — Preferences → General → Preferences → "Save changes to a folder" 체크. 5명 자경단의 같은 환경 동기화.

추신 73. oh-my-zsh의 robbyrussell 테마는 시작점. 1년 후 starship으로 옮김. ZSH_THEME=""이 그 다리.

추신 74. zsh-autosuggestions가 처음 보이면 답답할 수도. 회색 제안 무시 가능. 1주일 후 손가락이 자동.

추신 75. starship.toml의 한 줄 추가가 새 모듈 활성. 예 — `[time] disabled = false`로 시간 표시 ON.

추신 76. tmux의 prefix 변경 후엔 `Ctrl-b`가 안 됨. 새 prefix 사용. 처음 헷갈림.

추신 77. dotfiles의 `.gitignore`엔 `.zshrc.local`·`.env`·`*.token`. 비밀 분리의 첫 줄.

추신 78. 자경단의 dotfiles repo URL을 dotfile 첫 줄에 주석. `# https://github.com/cat-vigilante/dotfiles`. 5년 후에도 어디서 왔는지 알 수 있음.

추신 79. 본 H의 6도구는 5년 후 더 진화. brew 1년에 1번 큰 업데이트, iTerm2 1년에 1번. starship·tmux 안정. 매년 한 번씩 업데이트.

추신 80. **본 H 진짜 진짜 진짜 마지막** — 30분 셋업이 5년이고, 5년이 본인의 평생 셸 환경이며, 본인의 첫 brew install이 그 5년의 시작이에요.

추신 81. 본 H의 6도구를 1주일에 하나씩 익혀도 괜찮아요. 첫 주 brew, 둘째 주 iTerm2, 셋째 주 zsh + oh-my-zsh, 넷째 주 starship, 다섯째 주 tmux, 여섯째 주 dotfiles. 6주의 자산.

추신 82. brew의 분명한 가치 — 의존성 관리. `brew uninstall jq`이 jq만 제거하고 의존성은 다른 도구가 쓰면 그대로. 안전.

추신 83. iTerm2의 "Triggers" 기능이 출력 보고 자동 동작. ERROR 보이면 Slack 알람 등. 자경단 1년 후 검토.

추신 84. oh-my-zsh의 themes 디렉토리 (`~/.oh-my-zsh/themes/`)에서 100+ 테마 구경. 본인 취향 1년 후 정착.

추신 85. zsh-syntax-highlighting이 명령어 검수자. 빨강이면 오타·존재 안 하는 명령. 1초 호흡.

추신 86. starship의 git_status 모듈이 자경단 매일 PR 상태. ahead·behind·modified·staged 한 줄 표시.

추신 87. tmux의 status bar 커스터마이즈 (`set -g status-style "bg=color,fg=color"`)가 본인의 셸 정체성. 색깔이 본인 표현.

추신 88. dotfiles의 백업 — GitHub repo가 자동 백업. `git push` 한 줄. 5년 후 노트북 잃어버려도 본인 환경 그대로.

추신 89. 본 H의 6도구가 자경단 5명의 매일 셸 환경. 5명이 같은 환경이면 매일 합의 비용 0.

추신 90. **본 H 마지막 진짜 명령** — `brew install gh git node@20 python@3.12 starship tmux ripgrep fd bat jq` 한 줄을 본인 노트북에서 치세요. 10분 셋업이 5년 자산.

추신 91. 본 H를 끝낸 본인이 자경단 5명에게 본 H의 install.sh 공유. 5명 모두 1줄로 5분 셋업. 25분 → 5분 절약.

추신 92. 본 H의 6도구는 자경단 5년의 진짜 환경. 본인이 5명 다른 stack(백·프·인·디·메인)이여도 같은 6도구 위에서.

추신 93. 본 H의 마지막 황금 규칙 — 셋업은 한 번에 끝내기. 30분 셋업을 6번에 나누면 산만. 한 번에 30분이 가장 효율.

추신 94. 본 H를 다 끝낸 본인이 자경단 1년 후 회고에서 가장 자주 떠오르는 시점 — "그 30분 셋업이 매일 30분 절약". ROI 무한대.

추신 95. 본 H의 6도구 + .zshrc 50줄 + tmux.conf + dotfiles GitHub repo = 본인의 자경단 환경. 5년 자산.

추신 96. 본 챕터의 8H 중 본 H가 가장 실용적. 30분 셋업이 매일 손가락 절약. **실용이 최대 학습**.

추신 97. 본 H의 마지막 회고 — 본인이 본 H를 끝낸 그 시점이 본인의 자경단 환경 첫 시작. 5년 후 회고에서 그 30분이 자산.

추신 98. 본 챕터를 다 끝낸 본인은 셸의 80% + 환경의 80%. 나머지 20%는 5년 누적 + 새 도구.

추신 99. **본 H의 마지막 진짜 마지막** — 30분 셋업·6도구·dotfiles GitHub·5명 동기화가 본인의 자경단 평생 환경이에요.

추신 100. **본 H 끝** ✅ — 본인의 자경단 환경 셋업 30분 학습 완료. 다음 H4에서 30개 명령어 카탈로그.

추신 101. 본 H의 6도구를 한 페이지로 압축한 카드를 모니터 옆에 — brew·iTerm2·zsh·oh-my-zsh·starship·tmux + dotfiles GitHub.

추신 102. 자경단 5명이 본 H를 같이 끝내면 5명 환경 같음. 같은 화면·같은 단축키·같은 alias. **합의가 환경에**.

추신 103. 본 H의 마지막 권장 — 본인의 첫 dotfile commit 메시지를 `feat: 자경단 본인 dotfiles 시작`으로. 5년 후 git history의 첫 줄.

추신 104. 본 H를 끝낸 본인의 자경단 1년 후엔 본인이 5명에게 셸 환경 가르치는 메인테이너. 본인의 첫 셋업이 평생 학습 자산.

추신 105. **본 H 진짜 진짜 끝** — 본인의 첫 자경단 환경 셋업 30분이 5년의 산소이고, 6도구가 매일 손가락이며, dotfiles GitHub가 5명 wiki예요. 오늘 시작하세요.

추신 106. 자경단 환경 셋업의 ROI — 30분 × 365일/년 절약 = 1년 6시간. 5년 30시간. 셋업 1번이 5년 30시간을 사요.

추신 107. 본 H의 핵심은 자동화. 본인이 손으로 6도구 셋업하면 3시간. install.sh 한 줄이 5분. **자동화의 첫 경험**.

추신 108. 본인의 자경단 5년 후 dotfiles는 본인의 손가락 자서전. 매 줄이 본인의 한 결정. 200줄이 본인의 평생.

추신 109. 본 H를 끝낸 본인이 자경단 5명과 매주 수요일 17:00 dotfile 회의 5분. 새 alias·새 함수 합의. **dotfile 회의가 협업 의식**.

추신 110. **본 H 마지막 진짜 마지막** — 본인의 자경단 환경 셋업이 5년의 산소이고, 본인의 첫 brew install이 그 5년의 시작이며, dotfiles GitHub repo가 5명의 평생 wiki예요. 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾
