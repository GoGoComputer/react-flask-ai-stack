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

> ▶ **같이 쳐보기** — 5분 한 줄: 개발 도구 토대 깔기
>
> ```bash
> xcode-select --install
> ```

5분 다운로드. git·make·gcc 등 기본 도구. 한 번 설치, 평생.

### 1-2. Homebrew (brew)

macOS의 패키지 매니저. 자경단 셋업의 토대.

> ▶ **같이 쳐보기** — Homebrew 설치 + PATH 등록 (Apple Silicon)
>
> ```bash
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> # 끝나면 메시지대로 PATH 추가:
> echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
> eval "$(/opt/homebrew/bin/brew shellenv)"
> ```

**Apple Silicon = `/opt/homebrew`**. Intel Mac은 `/usr/local`. 자경단 표준은 Apple Silicon이라 `/opt/homebrew` 우선.

### 1-3. brew로 자경단 표준 도구 한 번에

> ▶ **같이 쳐보기** — 자경단 표준 도구 12종 한 번에 (10분)
>
> ```bash
> brew install git gh node@20 python@3.12 ripgrep fd bat exa jq tldr starship tmux
> ```

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

## 추신

본 H의 6도구(brew·iTerm2·zsh·oh-my-zsh·starship·tmux)가 자경단의 셋업 평생 토대. 30분이 5년의 산소. brew install 한 줄로 10도구. 본인의 첫 brew 명령이 자경단의 첫 환경. iTerm2의 단축키 5종(Cmd+T·Cmd+D·Cmd+Shift+D·Cmd+W·Cmd+`)이 매일 손가락. 5년 사용.

