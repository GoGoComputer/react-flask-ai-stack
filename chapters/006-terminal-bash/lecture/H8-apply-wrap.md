# Ch006 · H8 — 검은 화면이 평생 친구 + dotfile + Ch007 다리

> 고양이 자경단 · Ch 006 · 8교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속
2. Ch006 7시간 회고
3. 본인의 dotfile 100줄 만들기
4. dotfile을 GitHub에
5. 자경단 5년 셸 자산
6. 검은 화면 첫날과 5년 후
7. Ch007로 가는 다리
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속

자, 안녕하세요. 본 챕터의 마지막 시간이에요.

지난 H7 회수. fork, exec, wait, signal, job control. 0.3초의 진짜 단계.

이번 H8은 적용 + 회고. 본인의 dotfile 한 장 만들기 + GitHub에 올리기.

오늘의 약속. **본인의 손가락 모양이 GitHub에 백업됩니다**.

자, 가요.

---

## 2. Ch006 7시간 회고

**H1** — 검은 화면 큰 그림. 일곱 이유. 네 친구 (터미널, 셸, 프로세스, 파일시스템).

**H2** — 8개념. 변수, PATH, exit code, subshell, glob, redirection, heredoc, pipe.

**H3** — 30분 셋업. Homebrew, iTerm2, oh-my-zsh, starship, tmux.

**H4** — 30 명령어. 6 무리. 위험도 신호등.

**H5** — 30분 시뮬. 자경단 다섯 명의 협업.

**H6** — 운영. 본인의 첫 deploy.sh 50줄.

**H7** — 깊이. fork, exec, signal.

**H8** — 지금. dotfile + 회고.

7시간이 본인의 평생 손가락의 토대.

---

## 3. 본인의 dotfile 100줄 만들기

자, 본인의 첫 dotfile을 같이 짜요.

> ▶ **같이 쳐보기** — 본인의 .zshrc 100줄
>
> ```zsh
> # ~/.zshrc — 자경단 본인 dotfile
> 
> # ===== PATH =====
> export PATH="$HOME/.local/bin:$PATH"
> export PATH="/opt/homebrew/bin:$PATH"
> 
> # ===== 환경변수 =====
> export EDITOR="code --wait"
> export LANG="en_US.UTF-8"
> export NODE_OPTIONS="--max-old-space-size=4096"
> export PIP_CACHE_DIR="$HOME/.cache/pip"
> 
> # ===== oh-my-zsh =====
> export ZSH="$HOME/.oh-my-zsh"
> ZSH_THEME=""   # starship이 대체
> plugins=(git docker npm z zsh-autosuggestions)
> source $ZSH/oh-my-zsh.sh
> 
> # ===== Aliases (자경단 표준 13개) =====
> alias ll="eza -alh --git"
> alias la="eza -a"
> alias l="eza"
> alias cat="bat"
> alias find="fd"
> alias grep="rg"
> 
> alias g="git"
> alias gs="git status"
> alias gp="git pull --rebase"
> alias gc="git commit -m"
> alias glog="git log --oneline --all --graph"
> 
> alias d="docker"
> alias k="kubectl"
> 
> # ===== Python venv =====
> alias py="python3"
> alias ipy="ipython"
> alias venv="python3 -m venv .venv && source .venv/bin/activate"
> alias act="source .venv/bin/activate"
> alias pf="pip freeze > requirements.txt"
> alias pr="pip install -r requirements.txt"
> 
> # ===== Functions =====
> # git 빠른 commit + push
> gcp() {
>   git add . && git commit -m "$1" && git push
> }
> 
> # 빈 변수 검증 sed_inplace (macOS/Linux 호환)
> sed_inplace() {
>   if [[ "$OSTYPE" == "darwin"* ]]; then
>     sed -i '' "$@"
>   else
>     sed -i "$@"
>   fi
> }
> 
> # 포트 점유한 프로세스 죽이기
> kill-port() {
>   lsof -i ":$1" | tail -1 | awk '{print $2}' | xargs -r kill -9
> }
> 
> # 7다리 네트워크 진단 (Ch003 회수)
> nettest() {
>   local target="${1:-google.com}"
>   echo "🔍 7다리 진단: $target"
>   ifconfig en0 | grep "inet "
>   ping -c 1 -t 2 "$(route -n get default | awk '/gateway/{print $2}')" > /dev/null && echo "✅ gateway"
>   ping -c 1 -t 2 8.8.8.8 > /dev/null && echo "✅ 8.8.8.8"
>   dig +short "$target" | head -1
>   curl -sI "https://$target" | head -1
> }
> 
> # 가장 큰 파일 5개
> biggest5() {
>   find "${1:-$HOME}" -type f -size +100M 2>/dev/null | head -5
> }
> 
> # ===== History =====
> HISTSIZE=10000
> SAVEHIST=10000
> setopt SHARE_HISTORY
> setopt HIST_IGNORE_DUPS
> setopt HIST_IGNORE_SPACE
> 
> # ===== starship 프롬프트 =====
> eval "$(starship init zsh)"
> 
> # ===== pyenv =====
> eval "$(pyenv init -)" 2>/dev/null
> 
> # ===== 자경단 dotfile 끝 =====
> ```

100줄. 본인의 5년 손가락 모양. PATH 5줄, 환경변수 5줄, oh-my-zsh 5줄, alias 21줄, function 5개, history 5줄, starship 1줄.

---

## 4. dotfile을 GitHub에

본인의 dotfile을 GitHub에 백업.

> ▶ **같이 쳐보기** — dotfile GitHub repo
>
> ```bash
> # 1. 폴더 만들기
> mkdir ~/dotfiles && cd ~/dotfiles
> 
> # 2. 기존 dotfile 복사
> cp ~/.zshrc ./zshrc
> cp ~/.gitconfig ./gitconfig
> cp ~/.tmux.conf ./tmux.conf 2>/dev/null
> 
> # 3. README
> cat > README.md <<'EOF'
> # 자경단 본인의 dotfiles
> 
> 5년 손가락 백업.
> 
> ## 설치
> ```bash
> git clone https://github.com/bonin/dotfiles.git ~/dotfiles
> cd ~/dotfiles
> ./install.sh
> ```
> EOF
> 
> # 4. install.sh
> cat > install.sh <<'EOF'
> #!/bin/bash
> set -euo pipefail
> 
> DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
> 
> ln -sf "$DIR/zshrc" ~/.zshrc
> ln -sf "$DIR/gitconfig" ~/.gitconfig
> ln -sf "$DIR/tmux.conf" ~/.tmux.conf
> 
> echo "✅ dotfiles installed"
> EOF
> chmod +x install.sh
> 
> # 5. git + push
> git init
> git add .
> git commit -m "chore: initial dotfiles"
> gh repo create dotfiles --public --source=. --push
> ```

본인의 dotfile이 GitHub에 백업. 5년 후 새 노트북 사도 5분에 복원.

---

## 5. 자경단 5년 셸 자산

7시간 + 100줄 dotfile 후 본인이 가진 것.

**환경** — iTerm2 + oh-my-zsh + starship + tmux. 자경단 표준.

**도구** — 30 명령어 + 12 brew 도구.

**스크립트** — deploy.sh 50줄. cleanup.sh. nettest.sh.

**dotfile** — 100줄 .zshrc. GitHub 백업.

**원리** — fork, exec, signal. 0.3초의 진짜.

**자신감** — 어느 머신 가도 5분에 본인 환경 복원.

5년 자산.

---

## 6. 검은 화면 첫날과 5년 후

본인의 첫날.

```
$ tty
/dev/ttys003
```

한 줄에 멘붕. 검은 화면이 무서움.

본인의 5년 후.

```bash
$ check && nettest && deploy.sh -e prod -v
[INFO] black + ruff + mypy + pytest 다 통과
[INFO] 7다리 진단 OK
[INFO] prod deploy 시작...
[OK] deploy 완료
```

한 줄에 30 명령어가 자동. 셸이 본인의 평생 친구.

5년이 빠르게 지나가요. 매일 30분만 셸에서 보내면.

---

## 7. Ch007로 가는 다리

다음 챕터 Ch007은 Python 입문. 셸의 다음.

자경단 까미가 매일 Python으로 백엔드 짜요. 그 Python을 어디서? 셸에서. python3 명령. pip install. venv 활성화.

Ch006의 30 셸 명령어 + Ch007의 Python 18 도구 = 본인의 매일 백엔드 stack.

Ch005 git + Ch006 셸 + Ch007 Python = 본인의 1년차 stack 세 기둥.

---

## 8. 흔한 오해 다섯 가지

**오해 1: 셸은 옛 도구.**

매일 사용. AI 시대 더 중요.

**오해 2: dotfile은 시니어.**

신입 1주차부터.

**오해 3: 30 명령어 외워야.**

매일 6개. 6주.

**오해 4: 사고 무서움.**

reflog로 30일 복구.

**오해 5: 5년 멀어 보임.**

매일 30분이면 5년에 마스터.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. iTerm2 vs Warp?**

자경단 iTerm2. Warp는 AI 통합.

**Q2. zsh vs bash?**

자경단 zsh. 서버는 bash 알아두기.

**Q3. dotfile 공개 vs 비공개?**

자경단 public. 토큰만 별도.

**Q4. 8시간 길어요.**

평생 손가락. 깊이 한 번.

**Q5. 두 해 후 자경단 사이트?**

5년 차에 진짜 출시.

---

## 10. 흔한 실수 다섯 가지 + 안심 멘트 — Ch006 회고 학습 편

Ch006 마무리 학습 함정 다섯.

첫 번째 함정, dotfiles GitHub에 안 올림. 안심하세요. **두 해 후 새 컴퓨터 한 줄로.**

두 번째 함정, alias 5개로 만족. 본인이 ll·la·gs만. 안심하세요. **매주 한 개씩.** 한 달 4개, 1년 50개.

세 번째 함정, 셸 스크립트 GitHub에 안 올림. 안심하세요. **본인 .sh를 dotfiles 또는 별도 레포.** 두 해 후 포트폴리오.

네 번째 함정, 두 OS(macOS·Linux) 차이 무시. 안심하세요. **두 환경 다 쳐 보기.** Ch003 약속과 같은 사상.

다섯 번째 함정, 가장 큰 함정. **터미널 안 켜고 다음 챕터로.** 본인이 매일 안 만남. 안심하세요. **매일 5분 터미널.** 한 달이면 친구.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 11. 마무리

자, 여덟 번째 시간이 끝났어요. 본 챕터 끝.

7시간 회고, dotfile 100줄, GitHub 백업, 5년 자산, 첫날과 5년 후, Ch007 다리.

박수 한 번 칠게요. 진짜 큰 박수예요. 본인이 셸 8시간 끝까지 따라오셨어요. 검은 화면이 본인의 평생 친구가 됐어요. 본인의 손가락 모양이 GitHub에 백업됐어요.

본 챕터 끝. 다음 만남 — Ch007 H1. 두 주 후. Python 입문.

```bash
cat ~/.zshrc | wc -l
git -C ~/dotfiles log --oneline
```

본인의 첫 dotfile이 몇 줄인지. 1년 후엔 200줄, 5년 후엔 500줄로 자라요.

---

## 👨‍💻 개발자 노트

> - dotfile 관리: chezmoi, GNU stow, 또는 직접 symlink.
> - dotfile 도메인: dotfiles.github.io 사이트.
> - 1년 후 200줄, 5년 후 500줄: 자경단 평균.
> - 검증 도구: shellcheck로 .zshrc 검사.
> - 다음 챕터 Ch007: Python, FastAPI, 백엔드.
