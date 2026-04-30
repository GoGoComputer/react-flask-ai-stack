# H3 · Git & GitHub 기본 — 환경 점검 — 설치·config·SSH 키

> 고양이 자경단 · Ch 004 · 3교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 들어가며 — H2 회수와 H3 약속
2. Git이 깔려 있나 — `git --version` 한 줄 점검
3. macOS 설치 3가지 길 — Xcode CLT·Homebrew·공식 설치 파일
4. Linux 설치 — apt·yum·dnf 한 줄
5. Windows 보너스 — git-scm.com·WSL 두 갈래
6. `git config --global` 세 줄 — 본인 신분증 박기
7. `~/.gitconfig` 직접 cat — 사람이 읽는 설정 파일
8. 핵심 alias 5개 — 손목 보호 단축
9. .gitignore 깊게 — 무엇을 빼고 무엇을 넣는가
10. SSH 키 ed25519 — 비밀번호 없는 push의 기초
11. GitHub에 SSH 키 등록 — 5분 데모
12. credential helper — HTTPS 비밀번호 캐시
13. GPG 서명 commit — Verified 뱃지(선택)
14. 흔한 오해 다섯 개
15. FAQ 다섯 개
16. 자경단 적용 + 다음 시간 예고
17. 흔한 실수 다섯 가지 + 안심 멘트 — Git 환경 학습 편
18. 한 줄 정리 + 추신

---

## 🔧 강사용 명령어 한눈에

```bash
# 0. 설치 확인
git --version                              # git version 2.43.x

# 1. 본인 신분증
git config --global user.name "본인이름"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false      # 또는 true (선호)
git config --global core.editor "code --wait"  # VS Code

# 2. 설정 확인
git config --global --list
cat ~/.gitconfig

# 3. alias 5종
git config --global alias.st "status -sb"
git config --global alias.lg "log --oneline --graph --all -20"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.cm "commit -m"

# 4. SSH 키 생성 + GitHub 등록
ssh-keygen -t ed25519 -C "you@example.com"
# Enter 3번 (위치 default, 패스프레이즈 둘)
cat ~/.ssh/id_ed25519.pub                  # 이 한 줄을 GitHub에 복붙
ssh -T git@github.com                      # Hi <username>!

# 5. SSH agent (macOS)
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# 6. .gitignore 시작
curl -L https://www.toptal.com/developers/gitignore/api/macos,python,node,visualstudiocode > .gitignore

# 7. credential helper (HTTPS 쓸 때)
git config --global credential.helper osxkeychain    # macOS
git config --global credential.helper "cache --timeout=3600"  # Linux

# 8. GPG 서명 (선택)
gpg --full-generate-key                    # ed25519 또는 RSA 4096
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey <KEY-ID>
git config --global commit.gpgsign true
```

---

## 1. 들어가며 — H2 회수와 H3 약속

자, H3에 오신 걸 환영해요. 지난 H2에 객체 그래프(blob·tree·commit) 위에 라벨(branch=한 줄짜리 텍스트)과 손가락(HEAD)이 붙은 구조를 깔아 드렸죠. Merge fast-forward vs three-way, Rebase 깊게, fetch·pull·push 차이, `--force-with-lease`까지. 모델이 한꺼번에 들어온 빡빡한 한 시간이었어요. 70% 들어오셨다면 본전이고, 나머지는 H4·H5에서 손에 박힙니다. 오늘 H3는 한 발 물러서서 본인 노트북을 점검합니다. **"본인 컴퓨터가 Git을 칠 준비가 됐는가."** 이 질문에 답하는 한 시간이에요. 약속은 세 가지입니다. 하나, **`git --version`이 한 줄로 떠야 하고, `git config --global --list`가 본인 이름·이메일·기본 브랜치를 보여 줘야 한다.** 본인의 모든 commit에 본인 신분증이 박힙니다. 둘, **본인 노트북이 GitHub과 SSH로 악수해서 비밀번호 없이 push가 되어야 한다.** 한 번 등록하면 평생 가요. 셋, **`.gitignore` 한 장이 본인 폴더에 깔려 있어야 한다.** 비밀번호·캐시·node_modules가 실수로 commit되는 사고 예방의 첫 번째 장벽이에요. H3 끝에 본인 노트북이 GitHub과 정식으로 악수하고, 본인 commit에 본인 이름이 박히고, 비밀 파일이 history에 안 들어가는 상태가 됩니다. 이건 **평생 가는 30분 셋업**이에요. 처음 한 번 시간이 들지만, 그 한 번이 평생 비밀번호 입력 0번을 만들어 줘요. 시작합시다.

## 2. Git이 깔려 있나 — `git --version` 한 줄 점검

가장 먼저. 본인 노트북에 Git이 이미 깔려 있는지 봅시다. 터미널을 여세요.

> ▶ **같이 쳐보기** — Git 깔려 있는지 한 줄로 확인
>
> ```bash
> git --version
> ```

세 가지 답이 나올 수 있어요. **(A) "git version 2.x.x"가 한 줄로 떠요.** 깔려 있어요. 이 절을 건너뛰고 3번으로 가셔도 됩니다. **(B) "command not found: git"이 떠요.** 안 깔려 있어요. 다음 절(3번)에서 깔아요. **(C) macOS에서 "xcode-select: note: no developer tools installed" 같은 메시지가 떠요.** macOS는 Git이 Xcode Command Line Tools에 묶여 있어서 그게 안 깔려 있으면 이 메시지가 떠요. 이때는 화면에 뜨는 안내대로 "Install" 버튼을 누르면 5~10분 뒤에 깔립니다. 한 가지 알아 두실 점 — Git의 안정 버전은 보통 2.40 이상이면 충분하고 2.43+가 권장이에요. 너무 낮은 버전(예 2.20대)이면 일부 명령(`git switch`, `git restore` 같은 새 명령)이 없을 수 있어요. 그럴 땐 다음 절에서 최신으로 업데이트하세요. **버전 확인이 첫 단추예요.**

## 3. macOS 설치 3가지 길 — Xcode CLT·Homebrew·공식 설치 파일

macOS에서 Git을 까는 길은 셋. **(1) Xcode Command Line Tools.** 가장 가벼운 길. 터미널에 `xcode-select --install`을 치면 시스템 GUI가 뜨고 "Install" 버튼을 누르면 끝나요. Git만이 아니라 clang·make·git 같은 개발 기본 도구 세트가 한꺼번에 깔려요. 5~10분. 이게 본인이 첫 노트북이라면 가장 추천이에요. **(2) Homebrew.** Mac 개발자의 표준. `brew install git`. CLT보다 보통 더 최신 버전이 깔려요. brew가 안 깔려 있으면 brew.sh의 한 줄 설치 명령부터 치셔야 해요. brew를 한 번 깔아 두면 Git만이 아니라 거의 모든 개발 도구를 `brew install ...` 한 줄로 받을 수 있어서 노트북이 가벼워져요. **(3) 공식 설치 파일.** git-scm.com에서 .dmg 받아서 더블클릭. GUI 설치 마법사가 따라옵니다. 한 가지 함정 — 셋을 동시에 깔면 `which git`이 어느 git을 가리키는지 헷갈릴 수 있어요. `which git`을 쳐 보세요. `/usr/bin/git`은 CLT, `/opt/homebrew/bin/git`(Apple Silicon)이나 `/usr/local/bin/git`(Intel)은 Homebrew, `/usr/local/git/bin/git`은 공식 설치. 셋 중 하나만 PATH 앞에 두면 됩니다. 본인이 새로 깐 것이 PATH에 안 잡히면 `.zshrc`에 `export PATH="/opt/homebrew/bin:$PATH"`(Apple Silicon) 한 줄을 추가하고 `source ~/.zshrc`. 한 가지 권장 — **Apple Silicon(M1/M2/M3) 맥은 Homebrew**가 가장 깔끔합니다. CLT git이 약간 구버전인 경향이 있어요. 그리고 한 가지 더 알아 두실 점 — macOS의 시스템 git은 보안 업데이트가 OS 업데이트와 묶여서 늦게 와요. macOS Sonoma의 시스템 git이 2.39대인데 그 사이 git 본체는 2.43까지 갔어요. 큰 차이는 아니지만, 새 명령(`git switch`·`git restore`는 2.23+)·새 보안 패치를 빨리 받고 싶다면 Homebrew 쪽으로 PATH를 두세요. brew의 `git` formula는 거의 매주 패치가 나와서 본인 노트북이 항상 최신이 됩니다. 한 번 brew로 깔아 두면 `brew upgrade git` 한 줄로 업데이트가 끝나요.

## 4. Linux 설치 — apt·yum·dnf 한 줄

Linux는 더 단순합니다. 배포판마다 패키지 매니저가 다른 게 전부예요. **Ubuntu·Debian.** `sudo apt update && sudo apt install -y git`. **RHEL·CentOS·Fedora.** `sudo dnf install -y git`(또는 옛 yum). **Arch.** `sudo pacman -S git`. **Alpine.** `apk add git`(컨테이너에서 자주 만나요). 보통 5~30초면 깔려요. 끝난 다음 `git --version`으로 확인. Linux 패키지 매니저가 가져오는 Git은 보통 약간 옛 버전이에요. 최신 기능이 필요하면 git-core PPA(Ubuntu) 같은 추가 저장소를 쓰거나 소스 컴파일을 하시면 됩니다. 일상 학습엔 패키지 매니저 버전이면 충분해요. 그리고 한 가지 주의 — 회사 Linux 서버에는 종종 root가 아닌 본인 계정으로만 접근 가능해서 sudo가 안 될 수 있어요. 그럴 땐 본인 홈 디렉터리에 conda나 pyenv 비슷하게 git을 빌드해서 깔거나, 이미 깔린 시스템 git으로 만족해야 해요. 보통 시스템 git이 2.30+이면 일상 작업엔 부족함이 없어요.

## 5. Windows 보너스 — git-scm.com·WSL 두 갈래

이 코스는 macOS·Linux 위주지만 Windows 사용자가 있을 수 있으니 한 절. **(1) git-scm.com 공식 설치 파일.** Git for Windows를 받아서 더블클릭. Git Bash라는 작은 zsh 비슷한 셸이 같이 깔립니다. Windows의 cmd나 PowerShell이 아니라 Git Bash에서 git을 치세요. 명령어가 macOS·Linux와 같아요. **(2) WSL 2 (Windows Subsystem for Linux).** 진심 추천. Windows 안에 Ubuntu가 깔리는 거예요. PowerShell에서 `wsl --install`을 한 줄. 재부팅 후 Ubuntu가 깔리고, 그 안에서 `sudo apt install git`. 학습 환경이 Linux와 100% 같아져서 강의의 모든 명령어가 그대로 돌아요. 이 코스 학습자가 Windows를 쓰신다면 WSL을 강력히 추천합니다. 한 가지 — Windows의 줄바꿈은 CRLF, Linux·macOS는 LF예요. Git이 자동으로 변환하게 설정하시려면 `git config --global core.autocrlf input`(WSL/Git Bash)이 가장 깔끔해요. CRLF로 망가진 파일이 PR에 끼는 사고가 회사에서 흔합니다. 한 줄 설정으로 사고 막아 두세요.

## 6. `git config --global` 세 줄 — 본인 신분증 박기

Git을 깔았으면 본인 신분증을 박아야 해요. 본인이 만드는 모든 commit의 author 필드에 들어갈 정보예요. 다음 두 줄이 필수.

> ▶ **같이 쳐보기** — 모든 commit 의 author 에 박힐 본인 신분증 두 줄
>
> ```bash
> git config --global user.name "본인이름"
> git config --global user.email "you@example.com"
> ```

본인 이름은 한글이어도 영어여도 됩니다. 영어가 무난해요. 이메일은 GitHub 계정에 등록한 이메일과 같게 하세요. 다르면 GitHub의 contribution graph(녹색 점)에 본인 commit이 안 잡혀요. 회사 작업과 사이드 프로젝트 이메일을 분리하고 싶으면 repo별로 따로 설정할 수 있어요(`git config user.email work@company.com`을 그 repo 안에서). 셋째 줄은 권장 — `git config --global init.defaultBranch main`. Git 2.28부터 `git init`의 기본 브랜치 이름을 main으로 명시할 수 있게 됐어요(이전엔 master). 회사·오픈소스 컨벤션이 main으로 굳어졌으니 미리 깔아 두세요. 추가 권장 두 줄.

```bash
git config --global pull.rebase false       # 또는 true 본인 선호
git config --global core.editor "code --wait"   # VS Code 사용자
```

`pull.rebase false`면 `git pull`이 fetch + merge, `true`면 fetch + rebase. 작은 팀은 false(merge), trunk-based는 true(rebase)가 일반. 둘 다 정답이고 본인 선호. `core.editor`는 commit 메시지 길게 적을 때 어느 에디터가 열릴지. 기본은 vi인데 처음 쓰시는 분은 무서워요. VS Code 사용하면 위 한 줄로 바꾸세요. nano나 nvim도 좋고요. 이 다섯 줄이 본인 신분증의 첫 페이지예요. 5분 걸려요. 한 가지 더 권장 — `git config --global core.autocrlf input`(macOS·Linux) 또는 `core.autocrlf true`(Windows). 줄바꿈 처리 자동화. CRLF/LF가 섞인 파일이 PR에 끼면 diff가 만 줄로 폭발하는 사고가 회사에서 흔합니다. 이 한 줄로 막아 두세요. 또 하나 — `git config --global push.autoSetupRemote true`. 새 브랜치를 처음 push할 때 `git push -u origin <branch>`라고 길게 안 적어도 자동으로 upstream을 잡아 줘요. 본인이 매일 새 feature 브랜치를 만들고 push하는 사람이라면 이 한 줄이 평생 손가락 움직임을 절약해 줍니다. 이 두 줄까지 합치면 7줄. `git config --global rerere.enabled true`도 권장. rerere = "reuse recorded resolution". 같은 충돌을 두 번 만나면 첫 번째 해결을 자동 적용해 줘요. rebase·cherry-pick 자주 쓰는 분에겐 평생 시간 절약. 이 정도가 본인 글로벌 설정의 표준 페이지예요.

## 7. `~/.gitconfig` 직접 cat — 사람이 읽는 설정 파일

위에서 친 다섯 줄이 어디로 갔을까. 다음 한 줄을 쳐 보세요.

> ▶ **같이 쳐보기** — Git 의 모든 설정이 사람이 읽는 텍스트 한 파일
>
> ```bash
> cat ~/.gitconfig
> ```

이런 게 떠요.

```ini
[user]
	name = 본인이름
	email = you@example.com
[init]
	defaultBranch = main
[pull]
	rebase = false
[core]
	editor = code --wait
```

INI 형식의 평범한 텍스트 파일이에요. `git config --global` 한 줄이 결국 이 파일에 한 줄을 쓰는 동작이에요. 그래서 본인이 직접 이 파일을 에디터로 열어서 수정해도 같은 효과가 나요. `code ~/.gitconfig`. 이게 충격 포인트입니다. **Git은 모든 설정이 사람이 읽는 텍스트 파일.** 마법이 없어요. 이걸 알면 다른 노트북으로 옮길 때도 쉬워요. `~/.gitconfig` 한 파일만 dotfiles 레포로 백업해 두면 새 노트북 첫날 한 줄(`cp ~/dotfiles/.gitconfig ~/`)로 5분 셋업이 5초가 돼요. 한 가지 더 — `git config`는 세 단계 우선순위가 있어요. **system**(`/etc/gitconfig`, 모든 사용자) → **global**(`~/.gitconfig`, 본인) → **local**(`<repo>/.git/config`, 그 레포만). 아래쪽이 위쪽을 덮어써요. 그래서 회사 repo 안에서 `git config user.email work@company.com`을 치면 그 repo만 회사 이메일을 쓰고, 다른 repo는 글로벌 이메일을 써요. 이게 멀티 인격 관리의 비결이에요.

## 8. 핵심 alias 5개 — 손목 보호 단축

명령어를 짧게 줄일 수 있어요. `git status`를 매일 100번 친다면 `git st`로 줄이면 손목이 산다는 일과예요. 다음 다섯 줄을 한 번 쳐 두세요.

> ▶ **같이 쳐보기** — 손목 보호용 alias 5개 한 번에 박기
>
> ```bash
> git config --global alias.st "status -sb"
> git config --global alias.lg "log --oneline --graph --all -20"
> git config --global alias.co "checkout"
> git config --global alias.br "branch"
> git config --global alias.cm "commit -m"
> ```

이제 본인은 `git st`, `git lg`, `git co main`, `git br`, `git cm "메시지"`를 칠 수 있어요. `git st`는 짧은 형식 + 브랜치 정보. `git lg`는 최근 20개 commit을 그래프로. 두 줄이면 본인 repo의 현재 상태가 머리에 들어와요. 더 좋은 alias가 많아요. `dft = diff --stat`, `last = log -1 HEAD`, `unstage = reset HEAD --` 같은. 처음엔 위 다섯 개로 시작하시고, H4 명령어 카탈로그 끝에 본인 손에 맞는 alias를 한 페이지 추가하세요. 한 가지 — alias는 `~/.gitconfig`의 `[alias]` 섹션에 텍스트로도 직접 쓸 수 있어요. CLI보다 vim/code로 한꺼번에 쓰는 게 빠를 수 있습니다.

## 9. .gitignore 깊게 — 무엇을 빼고 무엇을 넣는가

이번 절이 H3에서 가장 사고 예방 효과가 큰 한 절이에요. **`.gitignore`는 "Git이 절대 추적하지 말아야 할 파일들의 목록"입니다.** 한 줄에 한 패턴씩 적어요.

```gitignore
# OS
.DS_Store
Thumbs.db

# 에디터
.vscode/
.idea/
*.swp

# Python
__pycache__/
*.pyc
.venv/
venv/
.env

# Node
node_modules/
dist/
build/
.cache/

# 빌드 산출물
*.log
*.tmp
coverage/

# 비밀
.env
.env.local
*.pem
*.key
secrets/
config/local.json
```

핵심은 다섯 부류예요. **(1) OS 자동 생성 파일** — macOS의 `.DS_Store`, Windows의 `Thumbs.db`. 코드와 무관. **(2) 에디터 설정** — `.vscode/`, `.idea/`. 본인 개인 설정이라 동료에게 안 가야 해요(예외: 팀이 합의한 공유 설정은 commit). **(3) 가상환경·의존성 캐시** — `.venv/`, `node_modules/`. 보통 GB 단위로 큼. `requirements.txt`나 `package-lock.json`만 commit하면 다른 사람이 같은 명령으로 재생성 가능. **(4) 빌드 산출물** — `dist/`, `build/`, `*.log`. 소스에서 만들어지는 파생물이라 history에 둘 필요 없음. **(5) 비밀** — `.env`, `*.key`, `*.pem`. 절대 commit 금지. 한 번 commit되면 history에서 지워도 GitHub Search에서 발견됩니다. 사고 났으면 바로 그 키를 폐기·재발급해야 해요. **이 한 줄이 가장 비싼 사고를 예방해요.** 한 줄짜리 사고 — 본인이 AWS 키를 commit해서 push하면, 1시간 안에 봇이 그 키로 비트코인 마이너를 띄워서 본인 카드에 수천 달러가 청구되는 사고가 매년 수백 건 일어납니다. 무서운 일이에요. 실제로 GitHub은 매일 수십만 개의 노출된 비밀을 secret scanning으로 잡아내고, 이미 노출된 AWS 키는 AWS와 자동 연동되어 그 자리에서 비활성화되도록 파트너십이 깔려 있어요. 다행히 안전망이 있다는 거지만, 자동 폐기되기 전에 봇이 먼저 발견하면 수천 달러는 그새 청구돼요. 회사 카드라면 본인이 변상 안 해도 되지만 본인 개인 카드라면 그 돈은 본인 부담입니다. 사이드 프로젝트에서 쉽게 일어나는 사고예요. `.gitignore` 한 장이 그 사고의 첫 방패. 두 번째 방패는 다음 절에서 볼 git-secrets·gitleaks 같은 pre-commit 훅이고, 세 번째는 GitHub의 secret scanning이에요. 세 겹 방패 중 첫 번째가 .gitignore고, 가장 싸고 가장 강합니다.

```bash
curl -L https://www.toptal.com/developers/gitignore/api/macos,python,node,visualstudiocode > .gitignore
```

300줄짜리 .gitignore가 5초 만에 깔려요. 거기서 본인 프로젝트만의 패턴 몇 줄을 추가. 그리고 `.gitignore`는 **이미 추적되고 있는 파일에는 효과가 없어요.** `.gitignore`에 추가했는데 여전히 status에 빨갛게 뜨면, 이미 한번 add됐던 거예요. `git rm --cached <file>`로 추적에서 빼고 다시 commit해야 해요. 자주 만나는 함정입니다.

## 10. SSH 키 ed25519 — 비밀번호 없는 push의 기초

이제 H3의 가장 중요한 한 절. **SSH 키.** GitHub에 push할 때마다 비밀번호를 치지 않게 만드는 마법이에요. 한 번 셋업하면 평생 갑니다. 원리는 두 키 짝(공개 키 + 개인 키). 본인이 만든 키 두 개 중 공개 키(public)는 GitHub에 올리고, 개인 키(private)는 본인 노트북에만 둬요. push할 때 GitHub이 "본인 맞아요?"를 묻고 본인 노트북이 개인 키로 서명을 해서 답하면, GitHub이 공개 키로 그 서명을 검증해요. 비밀번호 없이 본인 확인이 끝나요. **한 노트북에 한 키 짝.** 다른 노트북에서는 또 다른 키 짝을 만들어서 등록하면 됩니다. 첫 번째 키를 만듭시다.

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

`-t ed25519`는 키 알고리즘이에요. 옛날엔 RSA 4096이 표준이었는데 지금은 ed25519가 더 짧고 더 안전해요. GitHub도 권장합니다. `-C` 뒤의 이메일은 키에 붙는 코멘트(라벨). 본인 GitHub 이메일을 적으면 좋아요. 엔터를 누르면 세 가지를 물어봐요. **(1) 키 저장 위치.** 그냥 엔터(default `~/.ssh/id_ed25519`). **(2) 패스프레이즈.** 키 파일이 디스크에서 누군가에게 복사돼도 그 패스프레이즈 없이는 못 쓰게 하는 추가 보안. 빈 칸으로 둘 수도 있고(편하지만 노트북 도난 시 위험), 짧은 한 줄을 적을 수도 있어요. macOS는 keychain에 저장해 두면 매번 안 묻습니다. **(3) 패스프레이즈 재입력.** 위와 같은 줄. 끝나면 두 파일이 만들어져요.

```bash
ls -la ~/.ssh/
# id_ed25519           ← 개인 키 (절대 공유 금지!)
# id_ed25519.pub       ← 공개 키 (GitHub에 올릴 거)
```

**개인 키는 절대 다른 사람에게 보내지 마세요.** 비밀번호와 같은 무게예요. Slack이나 이메일로 동료에게 디버깅 도와 달라고 보내는 사고가 생각보다 자주 있어요. "잠깐 ssh config 좀 봐줘"라고 보낸 .ssh 폴더 통째에 개인 키가 끼어 있으면 그 순간 본인 GitHub 전권을 동료(또는 그 동료의 노트북을 노린 누군가)에게 넘긴 거예요. 안 보내면 됩니다. 디버깅이 필요하면 화면 공유로. 공개 키만 봅시다.

```bash
cat ~/.ssh/id_ed25519.pub
```

한 줄이 떠요. `ssh-ed25519 AAAAC3Nza... you@example.com`. 이 한 줄이 다음 절에서 GitHub에 올라갑니다.

## 11. GitHub에 SSH 키 등록 — 5분 데모

브라우저로 GitHub.com에 로그인. 오른쪽 위 본인 아바타 → **Settings** → 왼쪽 사이드바 **SSH and GPG keys** → 초록색 **New SSH key** 버튼. 폼이 떠요. **Title.** 본인이 알아볼 이름. "MacBook Pro 2024 mo"처럼. **Key type.** Authentication Key(기본). **Key.** 위에서 본 `cat ~/.ssh/id_ed25519.pub`의 한 줄을 통째로 복붙. **Add SSH key** 클릭. 끝. 이제 본인 노트북이 GitHub과 악수했어요. 다음 한 줄로 확인.

```bash
ssh -T git@github.com
```

처음엔 "The authenticity of host 'github.com'..."가 떠서 yes를 답하라고 해요. yes. 그 다음.

```
Hi GoGoComputer! You've successfully authenticated, but GitHub does not provide shell access.
```

이 한 줄이 떴으면 성공. 본인 username이 보여요. 이제 본인 repo의 remote URL을 SSH 형식으로 바꿔야 해요. HTTPS(`https://github.com/...`)는 비밀번호 인증, SSH(`git@github.com:...`)가 키 인증. 본인 자경단 repo로 가서.

```bash
git remote -v
# origin  https://github.com/GoGoComputer/react-flask-ai-stack.git (fetch)
# origin  https://github.com/GoGoComputer/react-flask-ai-stack.git (push)

git remote set-url origin git@github.com:GoGoComputer/react-flask-ai-stack.git
git remote -v
# origin  git@github.com:GoGoComputer/react-flask-ai-stack.git (fetch)
# origin  git@github.com:GoGoComputer/react-flask-ai-stack.git (push)
```

이제 `git push`가 비밀번호 없이 됩니다. macOS는 한 가지 더 — keychain에 키를 등록해 두면 패스프레이즈도 안 물어봐요.

```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

`~/.ssh/config`에 다음 5줄을 추가하면 매번 안 적어도 됩니다.

```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  UseKeychain yes
  AddKeysToAgent yes
```

이 5줄이 평생 갑니다. 새 노트북 첫날에 한 번만 셋업하면 끝이에요. 한 가지 더 팁 — `~/.ssh/config`에 `Host *` 블록 위쪽에 `IgnoreUnknown UseKeychain` 한 줄을 추가하면 macOS·Linux 양쪽에서 같은 config를 공유할 때 Linux가 UseKeychain을 모르고 에러 내는 일을 막을 수 있어요. dotfiles로 두 OS를 오가는 분에겐 평생 유용. 또 한 가지 — GitHub은 SSH로 접근할 때 22번 포트가 막힌 환경(회사 방화벽)을 위해 443번 포트의 ssh.github.com을 제공해요. `~/.ssh/config`에 `Host github.com / HostName ssh.github.com / Port 443 / User git` 블록 한 개를 추가하면 카페 와이파이·회사 방화벽을 우회해서 SSH push가 됩니다. 작은 트릭이지만 한 번 만나면 평생 잊지 않아요.

## 12. credential helper — HTTPS 비밀번호 캐시

SSH가 안 되는 환경(예: 회사 방화벽이 22번 포트를 막은 경우)에서는 HTTPS를 써야 해요. HTTPS는 매번 username + Personal Access Token(PAT) 입력이 필요한데, 매번 치면 손목이 죽어요. credential helper가 그걸 캐시해 줍니다. macOS는 keychain에 저장하면 평생 가요.

```bash
git config --global credential.helper osxkeychain
```

Linux는 메모리 캐시(타임아웃 1시간).

```bash
git config --global credential.helper "cache --timeout=3600"
```

또는 더 안전한 디스크 저장(암호화).

```bash
git config --global credential.helper store    # 평문 저장 — 비추천
```

GitHub은 2021년부터 비밀번호 인증을 폐기하고 PAT(Personal Access Token)으로 옮겼어요. Settings → Developer settings → Personal access tokens에서 토큰 만들고, push할 때 비밀번호 자리에 그 토큰을 넣어요. 그러면 helper가 캐시해서 다음부터 안 묻습니다. 그래도 SSH가 더 깔끔해요. 가능하면 SSH를 쓰세요.

## 13. GPG 서명 commit — Verified 뱃지(선택)

마지막으로 한 절. 선택입니다. GitHub의 commit 옆에 가끔 초록색 **Verified** 뱃지가 보일 거예요. 이건 GPG로 서명된 commit이라는 뜻. SSH는 "본인이 push했다"를 증명하지만, GPG 서명은 "이 commit의 글자가 본인 손에서 만들어졌고 중간에 변조되지 않았다"를 증명해요. 한 단계 더 강한 보안. **언제 필요한가.** 회사 정책이 강요할 때, 오픈소스 메인테이너로서 신뢰가 필요할 때, 본인 GitHub 프로필이 이력서일 때. 일상 학습자엔 선택입니다. **셋업.** GPG 키 만들기.

```bash
gpg --full-generate-key       # ed25519 또는 RSA 4096 선택
gpg --list-secret-keys --keyid-format=long
# /Users/mo/.gnupg/pubring.kbx
# sec   ed25519/ABCDEF1234567890 2024-04-15 [SC]
```

ABCDEF1234567890이 키 ID. 이걸 git에 등록.

```bash
git config --global user.signingkey ABCDEF1234567890
git config --global commit.gpgsign true
```

공개 키를 export해서 GitHub Settings → SSH and GPG keys → New GPG key에 붙여요.

```bash
gpg --armor --export ABCDEF1234567890
```

긴 블록을 통째로 복붙. 이제 본인 commit에 Verified 뱃지가 붙어요. 한 가지 함정 — 패스프레이즈를 매번 물어요. `gpg-agent`를 셋업해서 캐시. macOS는 `pinentry-mac` brew install로 GUI 입력이 가능. Linux는 `~/.gnupg/gpg-agent.conf`에 `default-cache-ttl 28800` 한 줄로 8시간 캐시. 셋업이 SSH보다 약간 복잡해요. 처음엔 건너뛰고 회사가 요구하면 그때 깔아도 됩니다. 한 가지 보너스 — 2022년부터 GitHub은 **SSH 키로도 commit 서명**을 허용해요. GPG 없이 본인 ed25519 SSH 키로 서명할 수 있어요. `git config --global gpg.format ssh / git config --global user.signingkey ~/.ssh/id_ed25519.pub / git config --global commit.gpgsign true`. GitHub Settings → SSH and GPG keys에서 그 키를 "Signing Key" 용도로도 등록하면 끝. GPG보다 셋업이 한참 짧아요. 새 셋업이라면 SSH 서명을 먼저 시도해 보세요. 그래도 회사 정책이 GPG를 요구한다면 GPG로.

## 14. 흔한 오해 다섯 개

**오해 1 — "git config는 명령어로만 설정해야 한다."** 거짓. `~/.gitconfig`는 사람이 읽는 INI 텍스트. vim/code로 직접 수정해도 같은 효과. 새 노트북 셋업은 dotfile 복사가 가장 빨라요.

**오해 2 — "SSH 키는 매번 새로 만들어야 한다."** 한 노트북에 한 짝이면 충분. 여러 노트북이면 노트북당 한 짝. 한 짝을 여러 노트북에 복사해서 쓰는 건 비추(노트북 한 대 잃어버리면 모든 키 폐기 필요).

**오해 3 — ".gitignore에 추가하면 이미 commit된 파일도 빠진다."** 거짓. 이미 추적되는 파일에는 효과 없음. `git rm --cached <file>` 후 commit해야 추적에서 빠져요. 비밀번호 사고의 흔한 함정.

**오해 4 — "패스프레이즈는 빈칸이 편하다."** 짧게라도 쓰세요. 노트북 도난·디스크 복제 시 빈칸은 즉시 본인 GitHub 전권을 줍니다. macOS keychain·Linux gpg-agent로 매번 묻지 않게 만들면 편함과 안전 둘 다 잡혀요.

**오해 5 — "user.email은 진짜 이메일이어야 한다."** GitHub은 noreply 이메일도 허용해요. Settings → Emails → "Keep my email addresses private" 체크 시 `12345+username@users.noreply.github.com` 형식의 가짜 이메일을 줘요. 그걸 `user.email`에 넣으면 본인 진짜 이메일이 commit history에 안 박힙니다. 오픈소스 기여자가 자주 씁니다.

**오해 보너스 — "Git 한 번 깔면 평생 안 만져도 된다."** 보안 패치가 정기적으로 나와요. 1년에 한두 번 `brew upgrade git`이나 패키지 매니저 업데이트로 갱신하시는 게 좋아요. 큰 보안 사고(2018 CVE-2018-11235, 2022 CVE-2022-39253 등)도 있었어요.

## 15. FAQ 다섯 개

**Q1. 회사 노트북과 사이드 프로젝트 이메일을 분리하고 싶어요.** repo별 `git config user.email`로. 또는 `~/.gitconfig`의 `[includeIf "gitdir:~/work/"]` 조건부 include로 디렉터리별 자동 분리. 검색해 보시면 한 페이지 가이드가 많이 나와요.

**Q2. SSH 키 패스프레이즈를 잊어버렸어요.** 복구 불가. 새 키 짝 만들어서 GitHub에 올리고 옛 키는 삭제하세요. 5분이에요. 데이터 손실 아닙니다.

**Q3. `git push`가 "Permission denied (publickey)"로 거절돼요.** 체크리스트. (1) `ssh -T git@github.com`이 "Hi <name>"이 뜨는가. (2) `git remote -v`가 `git@github.com:...` SSH 형식인가(HTTPS면 안 됨). (3) `~/.ssh/config`의 IdentityFile 경로가 맞는가. (4) `ssh-add -l`로 agent에 키가 로드돼 있는가. 보통 (2) 또는 (4)가 원인.

**Q4. .gitignore가 안 먹어요.** 위에 말한 함정. 이미 추적되던 파일이라 그래요. `git rm --cached <file>` 한 다음 commit. 또는 폴더 통째면 `git rm -r --cached <dir>`. 그 다음 push하면 GitHub에서도 빠져요.

**Q5. dotfiles 관리가 처음인데 어떻게 시작하나요?** `~/dotfiles/` 폴더 만들고 `.gitconfig`, `.zshrc`, `.ssh/config`(키는 빼고) 같은 설정 파일을 거기로 옮긴 다음 심볼릭 링크. GNU stow나 chezmoi 같은 도구가 자동화해 줘요. Ch006 터미널·bash에서 한 번 더 만나요.

**Q보너스. SSH 키와 GPG 키 둘 다 ed25519로 같은 알고리즘이면 한 키를 둘 다 쓸 수 있나요?** 가능은 한데 비추. 분리해서 쓰는 게 보안 사고 격리 면에서 좋아요. 한 키가 노출돼도 다른 일은 멀쩡하니까요. 키 한 종류당 하나씩 만드세요.

## 16. 자경단 적용 + 다음 시간 예고

자, H3에서 셋업한 걸 본인 자경단 repo에 붙여 봅시다.

```bash
cd ~/DEV/devStudy/react-flask-ai-stack
git config user.name           # 보이지 않으면 글로벌 가져옴
git config user.email
cat .gitignore | head -20      # 자경단 .gitignore 첫 20줄
git remote -v                  # SSH 형식이어야 평생 편안
ssh -T git@github.com          # Hi GoGoComputer!
```

다섯 줄이 다 정상으로 떴으면 본인 노트북이 자경단 repo와 정식으로 악수한 상태예요. 다음 H4 — 명령어 카탈로그 — 에서는 23개 git 명령어를 한 표에 펴고 위험도(읽기/안전 쓰기/위험 쓰기)를 색깔로 구분합니다. H4 끝에 본인이 명령어 23개의 의미와 위험도를 한 페이지로 머리에 박을 수 있게 만들어 드려요. 한 가지 약속 — H3와 H4 사이에 `ssh -T git@github.com`을 한 번만 더 쳐 보세요. "Hi <username>!"이 떠야 H4를 들으실 자격이 있어요. 안 뜨면 위 11번으로 돌아가서 점검하세요. 셋업 사고는 빨리 잡을수록 싸요.

## 17. 흔한 실수 다섯 가지 + 안심 멘트 — Git 환경 학습 편

Git 환경 셋업하며 자주 빠지는 함정 다섯.

첫 번째 함정, user.email을 회사 메일로 박아놓고 개인 레포에. 본인이 한 .gitconfig로 다 처리. 안심하세요. **레포별 user.email 분리.** `git config user.email` 로컬에 회사·개인 분리. 회사 commit이 개인 GitHub에 떠서 사고 나는 표준 패턴.

두 번째 함정, ssh 키를 한 키로 모든 곳. 안심하세요. **회사·개인 키 분리.** ~/.ssh/config 호스트별 IdentityFile 분리. 보안의 첫 단계.

세 번째 함정, .gitignore를 매번 처음부터. 안심하세요. **github.com/github/gitignore 템플릿.** Python·Node·macOS·VSCode 다섯 묶음 합치면 끝. 외울 게 없어요.

네 번째 함정, GPG 서명을 첫날부터 강제. 안심하세요, 함정 풀이부터. **GPG는 두 해 후 회사에서 보안팀이 요구하면 그때.** 첫달엔 commit 메시지 명확함이 더 큰 가치.

다섯 번째 함정, 가장 큰 함정. **dotfiles를 GitHub에 안 올린다.** 본인이 .gitconfig·.zshrc 본인 노트북에만. 안심하세요. **dotfiles 레포 첫날 신설.** 두 해 후 새 컴퓨터에서 한 줄로 끌어와요. 본인의 진짜 자산.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 18. 한 줄 정리 + 추신

한 줄 정리. **H3 끝에 본인 노트북엔 (1) `git --version`이 2.43+, (2) `git config --global` 5줄로 신분증, (3) `~/.ssh/id_ed25519` 키 짝과 GitHub에 등록된 공개 키, (4) `.gitignore` 한 장의 4종 패턴, (5) `ssh -T git@github.com`이 "Hi <name>!"으로 답하는 상태가 깔린다.** 두 해 코스 우리 위치는 27/960 = 2.81%입니다. H2 끝에서 2.71%였고, 한 시간을 더 했으니 2.81%. 매주 1%씩 자라는 복리예요. 자, Ch004 H3은 여기서 닫습니다. 다음 H4에서 만나요. 수고 많으셨습니다.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - macOS git: CLT vs Homebrew vs official. Apple Silicon은 Homebrew 권장 (`/opt/homebrew/bin/git`).
> - `git config` 우선순위: system → global → local. 아래가 위를 덮어씀.
> - `~/.gitconfig`는 INI 텍스트. dotfiles 레포로 백업.
> - SSH 키 알고리즘: ed25519 권장(짧고 안전), RSA 4096은 호환성용.
> - `~/.ssh/config`에 Host github.com 블록으로 자동 키 선택.
> - macOS keychain 통합: `ssh-add --apple-use-keychain` + `UseKeychain yes`.
> - `.gitignore` 5부류: OS / 에디터 / 의존성 / 빌드 / 비밀.
> - 이미 추적된 파일은 `.gitignore` 추가 후 `git rm --cached`로 빼야 함.
> - GPG 서명: ed25519 또는 RSA 4096. `commit.gpgsign true`로 자동.
> - GitHub 비밀번호 인증 폐기됨(2021). PAT 또는 SSH만.
> - `includeIf "gitdir:..."`로 디렉터리별 user 분리(work/personal).
> - CRLF 함정: Windows는 `core.autocrlf input` 권장.

## 추신

1. `git --version`이 2.43+이면 충분. 더 낮으면 업데이트.
2. `git config --global` 5줄이 본인 신분증의 첫 페이지.
3. `~/.gitconfig`는 사람이 읽는 INI. dotfiles 백업이 새 노트북 5초 셋업.
4. alias 5종(st·lg·co·br·cm)으로 손목 보호. 한 번 깔면 평생.
5. `.gitignore` 5부류(OS·에디터·의존성·빌드·비밀)을 노트에 적어 두세요.
6. SSH 키는 ed25519. `-C`로 라벨, 패스프레이즈 짧게라도. 노트북당 한 짝.
7. `~/.ssh/config`의 Host github.com 5줄이 평생 갑니다.
8. `git remote set-url origin git@github.com:...`로 SSH로 옮겨야 비밀번호 없음.
9. `ssh -T git@github.com`이 "Hi <name>"이면 합격. 안 뜨면 11번 다시.
10. credential helper는 SSH가 안 될 때만. 가능하면 SSH 우선.
11. GPG 서명은 선택. 회사가 요구하면 그때.
12. 다음 시간 H4 명령어 카탈로그 — 23개 명령어를 한 표에 위험도 색깔로. 한 페이지가 평생 치트시트가 됩니다.
