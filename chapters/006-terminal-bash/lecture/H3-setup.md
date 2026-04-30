# Ch006 · H3 — 자경단 표준 30분 셋업 — 본인 노트북을 자경단 표준 환경으로

> 고양이 자경단 · Ch 006 · 3교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 30분 동안 본인이 받게 되는 것 — 6종 도구의 그림
3. 첫 단추 — Xcode Command Line Tools
4. 둘째 단추 — Homebrew, macOS의 황금 패키지 매니저
5. 한 줄로 12종 도구 — 자경단 표준 도구 박기
6. iTerm2 — macOS의 진짜 터미널
7. zsh + oh-my-zsh — 셸을 풍부하게
8. starship — Rust로 만든 가벼운 프롬프트
9. tmux — 한 창 안에 여러 창
10. dotfiles GitHub 저장소 — 다섯 명 동기화의 비밀
11. 자경단 첫 .zshrc 50줄 — 본인의 첫 dotfile
12. macOS·Linux·Windows 변환표
13. 흔한 오해 다섯 가지
14. 자주 받는 질문 다섯 가지
15. 마무리 — 다음 H4에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# Xcode CLT
xcode-select --install

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# 자경단 표준 도구 12종 (한 줄)
brew install git gh node@20 python@3.12 ripgrep fd bat eza jq tldr starship tmux
brew install --cask iterm2

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# starship
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# 검증
which brew git gh node python3 rg fd bat eza jq starship tmux
```

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠. 어깨 한 번 돌리시고요. 물 한 잔 드시고요.

지난 H2를 한 줄로 회수할게요. 셸의 8개념을 다 만났어요. 변수·환경변수·PATH·exit code·subshell·glob·redirection·heredoc·pipe. 외계어가 좀 줄으셨길 바라요. H1 마지막에 보여드린 `find ~ -size +100M 2>/dev/null | sort -k5 -hr | head -5` 이 한 줄이 한 단어씩 읽히기 시작했으면 H2의 약속을 지켰어요.

이번 H3은 본인 노트북에 자경단 표준 환경을 박는 30분이에요. 손이 바빠지는 시간이에요. 본인이 노트북을 켜시고, 한 명령씩 같이 쳐 가면서, 30분 후에 본인의 노트북이 자경단 다섯 명 중 한 명의 표준 환경으로 변하는 그림이에요. 30분 후에는 본인이 스스로 손으로 친 환경이 자기 자리에 있어요. 5년 동안 본인이 매일 만나는 환경이 30분 안에 만들어져요.

오늘의 약속은 두 가지예요. 하나, **자경단 표준 6종 도구가 본인 노트북에 깔립니다**. iTerm2·zsh·oh-my-zsh·starship·brew·tmux. 둘, **본인의 첫 dotfile이 GitHub에 올라갑니다**. 50줄짜리 .zshrc 한 장. 그 한 장이 본인의 5년 손가락의 모양이에요.

전제 한 가지. 본 시간은 macOS Apple Silicon 기준이에요. M1, M2, M3 맥북. Intel Mac이거나 Linux나 WSL인 분도 따라오실 수 있어요. 12절에서 변환표 드릴게요. 자, 가요.

---

## 2. 30분 동안 본인이 받게 되는 것 — 6종 도구의 그림

본격 시작 전에 30분 동안 본인이 받게 되는 6종 도구의 그림을 한 번 펼쳐 드릴게요. 그림을 알고 가면 학습이 가벼워져요.

첫째 도구, **Homebrew (brew)**예요. macOS의 패키지 매니저. 본인이 `brew install git`이라고 한 줄 치면 git이 깔리는 그 마법의 도구. 자경단 셋업의 토대예요.

둘째, **iTerm2**. macOS의 진짜 터미널. 기본 Terminal.app보다 100배 친절해요. 분할 창, 검색, 색깔 테마. 자경단 표준이에요.

셋째, **zsh + oh-my-zsh**. macOS가 2019년부터 기본으로 쓰는 셸이 zsh예요. 그 위에 oh-my-zsh라는 framework를 얹으면 자동완성, 색깔, 플러그인이 줄줄이 따라와요. 본인의 셸이 두 배쯤 똑똑해져요.

넷째, **starship**. Rust로 만든 프롬프트. 본인이 셸을 켤 때 보이는 첫 줄을 예쁘게 만들어 주는 도구. 가볍고 빠르고 멋져요.

다섯째, **tmux**. 한 터미널 창 안에 여러 가상 창을 만드는 도구. 원격 서버에서 일할 때 진짜 강력해요.

여섯째, **brew로 깔리는 자경단 표준 도구 12종**. git, gh, node, python, ripgrep, fd, bat, eza, jq, tldr, starship, tmux. 한 줄로 다 깔려요. 한 줄 10분.

여섯 개를 한 시간 안에 본인 노트북에 박아요. 마지막에 GitHub에 본인 dotfile 한 장이 올라가요. 30분이 지나면 본인은 자경단 다섯 명의 한 명이에요. 자, 첫 단추부터.

---

## 3. 첫 단추 — Xcode Command Line Tools

가장 먼저 깔아야 할 게 Xcode Command Line Tools예요. macOS에서 모든 개발 도구의 토대예요. git, make, gcc, 그리고 brew도 이게 있어야 깔려요. 한 줄이에요.

> ▶ **같이 쳐보기** — Xcode Command Line Tools 설치
>
> ```bash
> xcode-select --install
> ```

엔터 누르면 GUI 팝업이 떠요. "Command Line Developer Tools를 설치하시겠습니까?" 같은 메시지. Install 버튼 누르세요. 약관 동의 화면이 나오면 동의하시고. 그 다음 다운로드가 시작돼요. 인터넷 속도에 따라 5분에서 20분. 한 번 깔면 평생 쓰니까 차분히 기다리세요.

이미 깔려 있는 분은 `xcode-select: error: command line tools are already installed` 같은 메시지가 떠요. 그러면 다음 단추로 넘어가세요.

설치가 끝났는지 확인하는 법. 한 줄이에요.

```bash
xcode-select -p
```

`/Library/Developer/CommandLineTools` 같은 경로가 떠요. 그러면 설치 완료. 이제 git이 본인 노트북에 깔린 상태예요. `git --version` 한 번 쳐 보세요. 버전이 떠요.

---

## 4. 둘째 단추 — Homebrew, macOS의 황금 패키지 매니저

Homebrew, 줄여서 brew. macOS 개발자의 가장 친한 친구예요. 본인이 어떤 도구든 `brew install <이름>` 한 줄로 깔 수 있어요. 깐 거 빼고 싶으면 `brew uninstall <이름>`. 업그레이드는 `brew upgrade`. 마법 같은 도구예요.

설치는 한 줄이에요. brew 공식 홈페이지에 가면 첫 화면에 이 한 줄이 떠 있어요. 그대로 복사해서 본인 셸에 붙여 넣으세요.

> ▶ **같이 쳐보기** — Homebrew 설치
>
> ```bash
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```

curl로 설치 스크립트를 다운로드해서 bash로 실행. 5분에서 10분 걸려요. 중간에 비밀번호 한 번 물어봐요. 본인 맥 로그인 비밀번호 치시면 돼요. 끝나면 메시지가 떠요. "Next steps" 라는 제목으로 두 줄이 보일 거예요.

> ▶ **같이 쳐보기** — brew를 PATH에 등록 (Apple Silicon 기준)
>
> ```bash
> echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
> eval "$(/opt/homebrew/bin/brew shellenv)"
> ```

이 두 줄을 그대로 치세요. 첫 줄은 영구 등록(다음 셸 켤 때마다), 둘째 줄은 지금 당장 적용. 첫 줄을 안 치면 셸을 새로 켤 때마다 brew를 못 찾아요. 둘째 줄을 안 치면 지금 셸에서 아직 못 써요. 둘 다 치셔야 해요.

확인 한 번 해 봐요.

```bash
which brew
brew --version
```

`/opt/homebrew/bin/brew`가 떠요. 그리고 버전 한 줄. 이제 본인 맥은 brew를 가졌어요. macOS 개발자의 90%가 가진 그 도구를 본인도 가졌어요.

여기서 짚고 갈 한 가지. **Apple Silicon은 `/opt/homebrew`, Intel Mac은 `/usr/local`**이에요. 본인 맥이 Intel이면 위 두 줄에서 `/opt/homebrew`를 `/usr/local`로 바꾸세요. 본인 맥이 어느 쪽인지는 Apple 메뉴 → 이 Mac에 관하여로 확인. M1/M2/M3가 보이면 Apple Silicon이에요.

---

## 5. 한 줄로 12종 도구 — 자경단 표준 도구 박기

이제 brew가 깔렸으니까 자경단 표준 도구 12종을 한 줄로 깔아요. 진짜 한 줄이에요. 10분 정도 걸리지만 본인은 그동안 커피 한 잔 마실 수 있어요.

> ▶ **같이 쳐보기** — 자경단 표준 도구 12종 한 줄 설치
>
> ```bash
> brew install git gh node@20 python@3.12 ripgrep fd bat eza jq tldr starship tmux
> ```

엔터 누르면 12개가 차례로 다운로드 + 설치돼요. 화면에 줄줄 글자가 흘러내려요. 10분 후 끝나요. 그동안 12개가 무엇인지 한 명씩 짧게 소개해 드릴게요.

**git**. 본인이 이미 알아요. Ch004와 Ch005에서 다 다뤘어요. brew로 깔면 Apple 기본 git보다 더 새 버전이 깔려요.

**gh**. GitHub CLI. Ch005에서 본 그 도구. PR 만들기, 리뷰, 이슈 생성을 셸에서 한 줄로.

**node@20**. JavaScript 런타임. 본인이 React 짤 때 필요해요. Ch008에서 만나요.

**python@3.12**. Python 3.12. Ch007에서 본격 다뤄요.

**ripgrep**. 줄여서 `rg`. grep의 진화 버전. 한 100배쯤 빨라요. 자경단의 표준 검색 도구.

**fd**. find의 진화 버전. 더 직관적이고 더 빨라요.

**bat**. cat의 색깔 강화. 코드 파일을 색깔과 줄번호와 함께 보여줘요.

**eza**. ls의 색깔 강화 + 트리 모드. 옛날 이름이 exa였는데 2023년에 이름이 바뀌었어요.

**jq**. JSON 파서. 자경단이 API 디버깅할 때 매일 만나는 친구.

**tldr**. man의 짧은 버전. `man find`는 1000줄짜리 매뉴얼이지만 `tldr find`는 5줄짜리 예시.

**starship**. 프롬프트 도구. 한 절 후에 따로 깊이 다뤄요.

**tmux**. 터미널 멀티플렉서. 두 절 후에 깊이 다뤄요.

12개 다 깔리면 검증 한 번 해 봐요.

```bash
which git gh node python3 rg fd bat eza jq tldr starship tmux
```

12개 다 path가 떠야 해요. 안 뜨는 게 있으면 `brew install` 다시.

마지막으로 iTerm2도 brew로 깔 수 있어요. cask 옵션으로.

```bash
brew install --cask iterm2
```

iTerm2는 GUI 앱이라 cask로 깔아요. 끝나면 어플리케이션 폴더에 iTerm 앱이 보여요. 다음 절에서 iTerm을 자세히 봐요.

---

## 6. iTerm2 — macOS의 진짜 터미널

방금 깐 iTerm을 한 번 켜 봐요. 어플리케이션 폴더에서 iTerm 더블클릭. 검은 창이 떠요. 기본 Terminal.app과 비슷해 보이지만 사실 안에 진짜 풍부한 기능이 들어 있어요.

자경단 다섯 명이 매일 쓰는 단축키 다섯 개를 알려 드릴게요.

`Cmd+T`. 새 탭. 한 창에 여러 탭을 열 수 있어요.

`Cmd+D`. 수직 분할. 한 탭을 좌우로 나눠요.

`Cmd+Shift+D`. 수평 분할. 한 탭을 위아래로 나눠요.

`Cmd+W`. 현재 탭 또는 분할 창 닫기.

`Cmd+F`. 검색. 화면에 떠 있는 글자에서 찾기.

이 다섯 개가 자경단의 매일 쓰는 단축키예요. 외우려 마세요. 한 번 보고 가세요. 한 달 쓰시면 손가락에 박혀요.

iTerm의 기본 설정 두 가지만 바꿔 드릴게요. iTerm 메뉴 → Preferences (또는 `Cmd+,`)를 열어요.

첫째, **Profiles → Default → Text → Font**. 폰트를 Nerd Font로 바꿔요. starship에 아이콘이 뜨려면 Nerd Font가 필요해요. brew로 한 번 깔아 두면 좋아요.

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

깔린 후 iTerm Preferences → Profiles → Default → Text → Font를 JetBrainsMono Nerd Font로. 글씨 크기는 14가 자경단 표준.

둘째, **Profiles → Default → Window → Transparency**. 약간 투명하게 하면 멋있어요. 5%~10% 정도. 호기심에 한 번 만지작거려 보세요.

이 두 가지만 바꾸시면 본인 iTerm이 자경단 표준 외관이에요. 색깔 테마 같은 건 H8에서 dotfile에 박아 둬요.

---

## 7. zsh + oh-my-zsh — 셸을 풍부하게

zsh는 본인 맥에 이미 깔려 있어요. macOS Catalina(2019) 이후 기본 셸이에요. 한 번 확인해 봐요.

```bash
echo $SHELL
```

`/bin/zsh`가 뜨면 본인은 이미 zsh를 쓰고 있어요. 99%의 분이 zsh예요. 안 뜨면 `chsh -s /bin/zsh`로 바꾸세요.

그 위에 oh-my-zsh라는 framework를 얹어요. oh-my-zsh가 뭐냐면, zsh를 200배쯤 풍부하게 만들어 주는 도구예요. 자동완성 강화, 풍부한 테마, 플러그인 시스템, 깃 상태 표시. 자경단의 표준이에요.

> ▶ **같이 쳐보기** — oh-my-zsh 설치
>
> ```bash
> sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
> ```

curl로 설치 스크립트 다운, sh로 실행. 1분이면 끝나요. 끝나면 본인의 .zshrc 파일이 자동으로 만들어져요. `~/.zshrc`예요. 그 파일이 본인의 셸 설정 파일이고, 본인이 평생 키워 갈 dotfile이에요.

설치 후 셸을 한 번 닫고 다시 켜세요. 본인 셸의 외관이 살짝 달라졌을 거예요. 색깔이 풍부해지고, 디렉토리 이름이 살짝 다른 색깔이고. 이게 oh-my-zsh의 첫 인상이에요.

자경단이 매일 쓰는 oh-my-zsh 플러그인 다섯 개를 알려 드릴게요.

**git**. git 명령어의 짧은 별명. `gst`(git status), `gco`(git checkout), `gcm`(git commit -m). 본인의 git 손가락이 절반으로 줄어요.

**docker**. docker 명령어의 자동완성. `docker run` 다음에 탭을 누르면 옵션이 줄줄 떠요.

**npm**. npm 명령어의 자동완성과 별명.

**z**. 디렉토리 이동 도구. 본인이 자주 가는 폴더를 학습해서 `z proj`만 쳐도 그 폴더로 이동.

**zsh-autosuggestions**. 본인이 친 명령어를 학습해서 회색 글자로 다음에 칠 명령을 미리 보여줘요. → 키 누르면 채택.

이 다섯 개를 .zshrc의 plugins 줄에 추가하면 돼요. H8 dotfile 시간에 자세히.

---

## 8. starship — Rust로 만든 가벼운 프롬프트

본인이 셸을 켜면 가장 먼저 보이는 게 프롬프트예요. 보통 `$` 한 글자 또는 `mo@MacBook ~ $` 같은 한 줄. 그 한 줄을 더 예쁘게, 더 정보가 많이 담기게 만드는 도구가 starship이에요. Rust로 만들어서 빠르고 가벼워요.

방금 brew로 깔았으니까 활성화만 하면 돼요. 한 줄로 끝나요.

> ▶ **같이 쳐보기** — starship 활성화
>
> ```bash
> echo 'eval "$(starship init zsh)"' >> ~/.zshrc
> ```

이 한 줄을 본인의 .zshrc 끝에 추가. 그 다음 셸을 한 번 닫고 다시 켜세요. 본인의 프롬프트가 완전히 바뀌어 있어요. 디렉토리 이름이 색깔로, 옆에 git 브랜치 이름이 자동으로, 그 옆에 git 상태가 ✓나 ✗로. starship의 첫 인상이에요.

starship의 진짜 강점은 git 통합이에요. 본인이 git repo 폴더에 있으면 자동으로 브랜치 이름이 떠요. 변경된 파일이 있으면 ✗가 뜨고, 깨끗하면 ✓가 떠요. push 안 한 commit이 있으면 ⇡가 떠요. 본인이 `git status`를 안 쳐도 매번 보여줘요.

그 외에도 본인이 어느 폴더에 들어가면 그 폴더의 언어를 자동으로 감지해서 알려줘요. node 폴더면 🟢 node 버전, python 폴더면 🐍 python 버전, rust 폴더면 🦀 rust 버전. 본인이 자기 환경을 한 줄로 봐요.

설정 파일은 `~/.config/starship.toml`이에요. 본인이 원하면 색깔, 아이콘, 표시 항목을 다 커스터마이즈할 수 있어요. H8 dotfile 시간에 자경단 표준 starship.toml을 드릴게요.

---

## 9. tmux — 한 창 안에 여러 창

tmux는 터미널 멀티플렉서예요. 한 터미널 창 안에 여러 가상 창을 만들어 주는 도구. iTerm의 분할과 비슷하지만 한 가지 큰 차이가 있어요. **세션이 살아 있어요**.

본인이 SSH로 원격 서버에 들어가서 일하다가 인터넷이 끊기면, 보통의 셸 세션은 거기서 죽어요. 본인이 일하던 게 다 사라져요. tmux를 쓰면 살아 있어요. 본인이 다시 SSH로 들어가서 `tmux attach`만 치면 끊긴 그 자리에서 다시 시작해요. 마법 같은 기능이에요.

tmux의 기본 단축키는 prefix가 `Ctrl+b`예요. 모든 명령이 `Ctrl+b` 다음에 한 글자.

> ▶ **같이 쳐보기** — tmux 첫 세션
>
> ```bash
> tmux new -s work
> ```

새 세션이 만들어져요. 화면 아래에 초록색 바가 떠요. 그 안에서 명령을 치고, `Ctrl+b` 다음 `d`를 누르면 detach. 세션은 백그라운드에서 살아 있어요. 다시 들어가려면 `tmux attach -t work`.

자경단 다섯 명이 매일 쓰는 tmux 단축키 다섯 개를 알려드릴게요.

`Ctrl+b c`. 새 창 (window). 한 세션 안에 여러 창.

`Ctrl+b n`. 다음 창.

`Ctrl+b p`. 이전 창.

`Ctrl+b "`. 수평 분할.

`Ctrl+b %`. 수직 분할.

다섯 개가 손가락에 박히면 본인이 한 SSH 세션 안에 4개 창을 띄우고 일할 수 있어요. 한 창에서 서버 로그 보고, 한 창에서 코드 짜고, 한 창에서 테스트 돌리고, 한 창에서 git. 자경단 미니가 매일 이렇게 일해요.

tmux 설정 파일은 `~/.tmux.conf`예요. 자경단 표준은 prefix를 `Ctrl+b`에서 `Ctrl+a`로 바꿔요. `Ctrl+b`가 vim이랑 충돌이 잦거든요. H8에서 자세히.

---

## 10. dotfiles GitHub 저장소 — 다섯 명 동기화의 비밀

자, 여기까지 본인은 6종 도구를 다 깔았어요. 30분의 마지막 절이에요. 가장 중요한 한 가지를 알려 드릴게요. **dotfiles GitHub 저장소**.

dotfile이 뭔지 짧게 정의할게요. 본인의 셸 설정, vim 설정, git 설정, tmux 설정 같은 게 다 점(.)으로 시작하는 파일에 저장돼요. `.zshrc`, `.vimrc`, `.gitconfig`, `.tmux.conf`. 합쳐서 dotfile이라고 해요. 본인의 손가락의 모양 그 자체예요.

그 dotfile을 GitHub에 올려 두면 본인이 새 노트북을 사도 5분 만에 같은 환경을 복원할 수 있어요. `git clone`만 하면 되거든요. 그리고 자경단 다섯 명이 같은 dotfile repo를 공유하면 다섯 명 환경이 동기화돼요. 합의가 자동으로 되는 거예요.

자경단의 dotfile repo 구조 한 번 보여드릴게요.

```
dotfiles/
├── README.md
├── install.sh           # 새 맥에서 한 번 실행
├── zsh/
│   └── .zshrc
├── git/
│   └── .gitconfig
├── tmux/
│   └── .tmux.conf
├── vim/
│   └── .vimrc
└── starship/
    └── starship.toml
```

`install.sh` 한 줄에 모든 dotfile이 본인 홈 폴더에 심볼릭 링크로 연결돼요. 본인이 .zshrc를 수정하면 repo의 .zshrc도 같이 수정. git push 한 번이면 다섯 명이 다 받아요.

GitHub에 본인 dotfiles repo를 만드는 건 H8에서 자세히 다뤄요. 오늘은 그림만 머리에 두세요. **본인의 손가락이 GitHub에 백업되어 있다.** 5년 후에도 본인의 손가락은 살아있어요.

자경단의 시연용 dotfiles repo를 보여드릴게요. `https://github.com/cat-vigilante/dotfiles` 같은 식이에요. 본인이 두 해 코스 끝에 자기 dotfiles를 만들고 GitHub에 올리면, 본인도 자기만의 손가락 백업을 갖게 돼요.

---

## 11. 자경단 첫 .zshrc 50줄 — 본인의 첫 dotfile

마지막으로 본인의 첫 .zshrc 50줄을 같이 봐요. 본인이 H8에서 더 키울 거지만 오늘 시범으로 한 번 같이 짜 봐요.

> ▶ **같이 쳐보기** — 자경단 첫 .zshrc 시범 50줄
>
> ```zsh
> # ===== 자경단 첫 .zshrc =====
> 
> # PATH 추가
> export PATH="$HOME/.local/bin:$PATH"
> export PATH="/opt/homebrew/bin:$PATH"
> 
> # 환경변수 5종
> export EDITOR="code --wait"
> export LANG="en_US.UTF-8"
> export NODE_OPTIONS="--max-old-space-size=4096"
> 
> # oh-my-zsh
> export ZSH="$HOME/.oh-my-zsh"
> ZSH_THEME=""   # starship이 대체
> plugins=(git docker npm z zsh-autosuggestions)
> source $ZSH/oh-my-zsh.sh
> 
> # alias 13종 — 자경단 표준
> alias ll="eza -alh --git"
> alias la="eza -a"
> alias l="eza"
> alias cat="bat"
> alias find="fd"
> alias grep="rg"
> alias g="git"
> alias gs="git status"
> alias gp="git pull --rebase"
> alias gc="git commit -m"
> alias glog="git log --oneline --all --graph"
> alias d="docker"
> alias k="kubectl"
> 
> # function 한 개 — git 빠른 commit + push
> gcp() {
>   git add . && git commit -m "$1" && git push
> }
> 
> # starship 프롬프트 (마지막에)
> eval "$(starship init zsh)"
> ```

50줄짜리 첫 dotfile이에요. 위에서부터 한 줄씩 풀면 — PATH 추가, 환경변수, oh-my-zsh 로드, alias 13개, function 1개, starship 마지막. 본인이 평생 키울 dotfile의 토대예요.

13개 alias 중 자경단이 매일 가장 자주 쓰는 다섯 개는 `gs`, `gp`, `gc`, `ll`, `g`. 다섯 개가 본인 손가락의 90%를 차지해요. 외우려 마세요. 매일 쓰면 박혀요.

이 50줄을 본인의 .zshrc에 그대로 붙여 넣고 싶으시면 가능해요. 단, oh-my-zsh가 이미 깔려 있어야 해요. 그리고 starship도 `brew install starship`으로 깔려 있어야 해요. 셸을 닫고 다시 켜시면 본인 환경이 자경단 표준으로 변해요.

본인이 추가할 수 있는 다섯 줄을 미리 알려 드릴게요. H8에서 다시 만나요.

```zsh
# 본인 색깔
alias todo="vim ~/todo.md"
alias notes="cd ~/Documents/notes"
alias serv="python3 -m http.server 8000"
alias myip="curl ifconfig.me"
alias weather="curl wttr.in/seoul"
```

본인의 일상에 맞는 별명을 다섯 개 더 추가하면 본인의 dotfile이 진짜 본인 거예요.

---

## 12. macOS·Linux·Windows 변환표

본 시간이 macOS 기준이지만 Linux·Windows 분도 따라오실 수 있게 변환표 한 줄 드릴게요.

| 항목 | macOS | Linux (Ubuntu) | Windows WSL2 |
|------|-------|----------------|--------------|
| 패키지 매니저 | brew | apt | apt (WSL 안에서) |
| 터미널 | iTerm2 | gnome-terminal | Windows Terminal |
| 셸 | zsh | bash 또는 zsh | zsh (선택) |
| brew 경로 | /opt/homebrew | (없음, apt 사용) | (없음, apt 사용) |
| oh-my-zsh | 같음 | 같음 | 같음 |
| starship | brew | curl 스크립트 | curl 스크립트 |
| tmux | brew | apt | apt |

핵심은 oh-my-zsh, starship, tmux는 세 OS에서 거의 같다는 거예요. 패키지 매니저만 다르고, 그 위에 얹는 도구는 다 동일. Linux나 WSL 분은 brew 절을 apt로 바꿔서 따라오시면 돼요. `apt install git gh nodejs python3 ripgrep fd-find bat eza jq tldr tmux`.

자경단 다섯 명 중 미니가 사실 Linux에서 일해요. 미니의 셋업이 까미·노랭이·본인·깜장이의 macOS 셋업과 90% 같아요. 5년 전엔 OS가 다르면 환경이 다 달랐어요. 지금은 거의 동일해요. 좋은 시대예요.

---

## 13. 흔한 오해 다섯 가지

**오해 1: brew는 Apple Silicon에서만 된다.**

아니에요. Intel Mac도 됩니다. 경로만 달라요. Apple Silicon은 `/opt/homebrew`, Intel은 `/usr/local`. 둘 다 brew를 같은 식으로 써요.

**오해 2: oh-my-zsh가 셸을 느리게 한다.**

플러그인 50개 깔면 느려요. 하지만 자경단 표준 5개 정도는 충분히 빨라요. 느리면 starship과 z 같은 가벼운 도구로 줄이세요.

**오해 3: starship과 oh-my-zsh 테마는 동시에 못 쓴다.**

쓸 수 있지만 충돌해요. `ZSH_THEME=""`로 oh-my-zsh 테마를 끄고 starship만 쓰는 게 자경단 표준이에요.

**오해 4: tmux는 너무 어려워서 배울 필요 없다.**

처음만 어렵고 다섯 단축키만 박으면 평생 갑니다. SSH 끊김 방지 하나만으로도 배울 가치 있어요.

**오해 5: dotfile은 시니어 되어서 만들면 된다.**

신입 1년 차에 만드세요. 1년 차의 dotfile이 5년 차에 200줄로 자라요. 시니어가 되어서 만들면 1년 차의 무지가 dotfile에 안 박혀서 학습이 빠져요. 일찍 만드세요.

---

## 14. 자주 받는 질문 다섯 가지

**Q1. 30분 안에 다 못 끝낼 것 같아요.**

괜찮아요. 두 번에 나눠서 하셔도 돼요. 1차로 brew + 12종 도구 + iTerm2까지. 2차로 oh-my-zsh + starship + tmux + dotfile. 한 번에 안 되시면 두 번에 나눠 가세요.

**Q2. brew 설치가 자꾸 실패해요.**

대부분 인터넷이 느린 경우예요. VPN 켜져 있으면 끄세요. 그래도 안 되면 `xcode-select --install`이 안 끝났을 가능성. xcode-select -p 한 번 확인.

**Q3. zsh로 안 바뀌고 bash가 떠요.**

`chsh -s /bin/zsh` 한 줄로 기본 셸 변경. 그 다음 셸을 닫고 새로 켜세요. macOS 10.14 이하라면 zsh가 기본이 아니라서 그래요.

**Q4. iTerm2와 Warp 중 뭘 쓸까요?**

자경단 표준은 iTerm2예요. 5년 검증된 도구. Warp는 새 도구라 AI 통합이 멋지지만 아직 진화 중. 본인이 원하면 둘 다 쓰셔도 돼요. 자경단 다섯 명 중 두 명이 Warp, 세 명이 iTerm2.

**Q5. dotfile을 GitHub public으로 올려도 안전해요?**

비밀번호나 토큰만 안 적으면 안전해요. 자경단의 dotfile에는 토큰을 직접 안 적고, `$(cat ~/.config/gh/token)` 같이 별도 파일에서 읽어와요. dotfile은 public, 토큰 파일은 local only. 이 패턴이 자경단 표준이에요.

---

## 15. 흔한 실수 다섯 가지 + 안심 멘트 — 터미널 환경 학습 편

터미널 환경 셋업하며 자주 빠지는 함정 다섯.

첫 번째 함정, .zshrc 안 만든다. 본인이 매번 alias 안 깔림. 안심하세요. **첫날 .zshrc 5줄.** export PATH·alias·history 설정.

두 번째 함정, dotfiles 안 만든다. 안심하세요. **GitHub dotfiles 레포 첫날.** 두 해 후 새 컴퓨터 5분 셋업.

세 번째 함정, oh-my-zsh 무거움. 안심하세요. **starship 또는 powerlevel10k가 가벼움.** oh-my-zsh는 옛날 표준.

네 번째 함정, brew를 sudo로 깔려고. 안심하세요. **Homebrew는 사용자 권한.** sudo 절대 금지.

다섯 번째 함정, 가장 큰 함정. **PATH 직접 편집해서 망침.** 본인이 PATH 잘못 박아서 셸 명령 안 듦. 안심하세요. **항상 `export PATH="새경로:$PATH"`.** $PATH 보존이 안전벨트.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 16. 마무리 — 다음 H4에서 만나요

자, 세 번째 시간이 끝났어요. 60분 동안 본인은 자경단 표준 환경을 본인 노트북에 박으셨어요. 정리하면 이래요.

Xcode CLT 첫 단추, Homebrew 둘째 단추, brew로 12종 도구를 한 줄. iTerm2, oh-my-zsh, starship, tmux를 차례로 깔았어요. dotfile GitHub repo의 그림을 봤고, 첫 .zshrc 50줄을 같이 짜 봤어요. 본인의 노트북이 30분 안에 자경단 다섯 명 중 한 명의 표준 환경으로 변했어요.

박수 한 번 칠게요. 진짜로요. 본인이 새 셋업 한 번 한 게 5년 환경의 토대예요. 박수 치세요. 작은 일 같지만 큰 일이에요.

다음 H4는 명령어 카탈로그예요. 30개 명령어를 표 한 장에 누이고, 위험도를 신호등으로 표시해요. 매일 쓰는 6개, 주간 7개, 월간 5개, 응급 6개. 6주면 30개가 본인 손가락에 박혀요. 한 시간 후 만나요.

그 전에 한 가지 부탁. 지금 잠깐 멈추시고 본인 셸을 한 번 닫고 새로 켜 보세요. 그 다음 다섯 줄을 차례로 쳐 보세요.

```bash
which brew git starship tmux   # 다 깔렸나
echo $SHELL                     # zsh 인가
ls -la ~/.zshrc                 # dotfile 있나
brew list | head -5             # brew로 깐 거
starship --version              # starship 살아있나
```

5초예요. 5줄이 본인의 H3 졸업장이에요. 본인이 30분 동안 한 일을 본인 손가락이 다섯 줄로 확인해요. 잘 따라오셨어요. 진짜로요. 한 시간 후 H4에서 만나요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - Apple Silicon Homebrew 경로 `/opt/homebrew` 이유: Intel과 ARM64 바이너리 분리. Rosetta 모드는 `/usr/local` 사용. Apple Silicon은 두 brew를 동시에 운용 가능.
> - oh-my-zsh 성능 이슈: 플러그인 로드 시간 합계가 셸 시작 시간 결정. `time zsh -i -c exit`로 측정. 1초 넘으면 lazy loading 또는 zinit 같은 더 빠른 plugin manager 고려.
> - starship vs powerlevel10k: starship은 Rust, 모든 셸 호환, 단순. p10k는 zsh 전용, 더 빠른 첫 렌더, 더 풍부. 자경단은 단순함 우선해 starship.
> - tmux vs screen: screen은 옛 도구, tmux는 새 도구. tmux는 vertical split, copy mode, plugin 시스템. screen은 BSD 기본, tmux는 GNU. SSH 환경에선 둘 다 쓰지만 자경단은 tmux.
> - dotfile 관리 전략 3종: (1) 직접 git repo, (2) GNU stow + repo, (3) chezmoi. 자경단은 (1) 단순 repo + symlink. 100줄 이하에선 (1)이 충분.
> - Nerd Font 종류: JetBrainsMono, FiraCode, Hack, Meslo. 자경단 표준은 JetBrainsMono. 폰트는 brew cask로 설치.
> - alias vs function vs script 위계: 한 줄 → alias, 여러 줄 + 인자 → function (.zshrc), 여러 줄 + 재사용 → script (~/bin/*.sh). 위계로 dotfile 정리.
> - PATH 우선순위 디버그: `which -a git`으로 모든 git 위치 확인. `type git`으로 zsh가 인식한 git 종류 확인 (alias·builtin·function·external).
> - brew 업그레이드 정책: 자경단은 매주 월요일 `brew update && brew upgrade`. 자동화는 weekly cron으로. 보안 패치는 즉시.
> - 다음 H4 키워드: 30개 명령어 카탈로그·위험도 신호등·매일 6·주간 7·월간 5·응급 6.
