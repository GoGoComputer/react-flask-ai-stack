# Ch007 · H3 — Python 환경 30분 셋업 — pyenv·venv·pip·VSCode

> 고양이 자경단 · Ch 007 · 3교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 본인이 30분 동안 받게 되는 것 — 6도구의 그림
3. 첫 단추 — Python이 본인 노트북에 깔려 있나
4. 둘째 단추 — pyenv로 다중 버전 관리
5. 셋째 단추 — venv로 가상 환경
6. 넷째 단추 — pip와 requirements.txt
7. 다섯째 단추 — VS Code + Pylance + Ruff
8. 여섯째 단추 — REPL 세 종류 (python3·ipython·Jupyter)
9. 자경단 dotfile에 추가하는 다섯 줄
10. macOS·Linux·Windows 변환표
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리 — 다음 H4에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# Python 확인
python3 --version

# pyenv 설치
brew install pyenv
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Python 다중 버전
pyenv install 3.12
pyenv global 3.12

# venv
python3 -m venv .venv
source .venv/bin/activate

# pip
pip install requests
pip freeze > requirements.txt

# VS Code 확장
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension charliermarsh.ruff

# REPL 도구
brew install ipython jupyter
```

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠. 어깨 한 번 돌리시고요.

지난 H2를 한 줄로 회수할게요. Python의 8개념을 만나셨어요. 자료형 다섯, 연산자 열여덟, f-string, mutable vs immutable. 본인의 Python 어휘가 50% 채워졌어요.

이번 H3은 본인 노트북에 Python 표준 환경을 박는 30분이에요. Ch006 H3에서 셸 환경을 박았던 것처럼, 이번엔 Python 환경. pyenv로 다중 버전, venv로 가상 환경, pip로 패키지 관리, VS Code로 IDE. 30분 후엔 본인의 노트북이 자경단 다섯 명 중 한 명의 Python 표준 환경이 돼요.

오늘의 약속은 두 가지예요. 하나, **자경단 표준 6도구가 본인 노트북에 깔립니다**. python3, pyenv, venv, pip, VS Code, ipython. 둘, **본인의 첫 가상 환경이 만들어지고 첫 패키지가 깔립니다**. requests라는 HTTP 라이브러리.

오늘 시간은 H2와 결이 좀 달라요. H2는 머리로 개념을 이해하는 시간이었다면, 오늘은 손으로 환경을 만드는 시간이에요. 본인이 키보드를 많이 두드리게 될 거예요. 그러니까 가능하면 노트북을 켜고 같이 쳐 보세요. 듣기만 하면 30분 후에 절반은 까먹어요. 손으로 한 번 치면 손가락이 기억해요. 그리고 한 가지 안심 멘트. 셋업 중에 에러가 나도 당황하지 마세요. 환경 셋업은 원래 한 번에 안 되는 게 정상이에요. 5년 차도 새 노트북 셋업할 때 에러를 만나요. 에러 메시지를 읽고, 한 줄씩 풀어 가는 게 셋업이에요. 그 과정 자체가 본인을 단단하게 만들어요. 에러 없이 매끈하게 끝나면 오히려 운이 좋은 거예요. 자, 가요.

자, 가요.

---

## 2. 본인이 30분 동안 받게 되는 것 — 6도구의 그림

본격 시작 전에 30분 동안 본인이 받게 되는 6도구의 그림을 펼쳐 드릴게요.

첫째, **python3**. 본인 노트북에 이미 깔려 있을 가능성 99%. macOS Catalina 이후로 기본 깔려요. `python3 --version`으로 확인.

둘째, **pyenv**. Python의 다중 버전 관리 도구. 자경단은 3.10, 3.11, 3.12를 동시에 가지고 있어요. 프로젝트마다 버전이 달라서요. pyenv가 그걸 자동으로 전환해 줘요.

셋째, **venv**. 가상 환경 도구. 프로젝트마다 격리된 Python 환경을 만들어요. A 프로젝트의 패키지가 B 프로젝트에 영향 안 주게.

넷째, **pip**. Python 패키지 매니저. 50만 개 패키지 중 원하는 걸 한 줄로 깔아요. `pip install requests`.

다섯째, **VS Code**. 자경단의 표준 코드 에디터. Python extension과 Pylance, Ruff를 더해서 IDE로 진화.

여섯째, **ipython + Jupyter**. 진화된 REPL. 매일 실험할 때 진짜 유용해요.

여섯 도구. 30분에 다 깔려요. 본인 노트북이 30분 후엔 자경단의 Python 환경이에요.

이 여섯 도구를 한 문장으로 엮어 볼게요. 그러면 왜 이 순서인지가 보여요. **pyenv로 어떤 Python 버전을 쓸지 고르고, venv로 이 프로젝트만의 격리 공간을 만들고, 그 안에서 pip로 패키지를 깔고, VS Code로 코드를 짜고, ipython으로 실험해요.** 여섯 도구가 따로 노는 게 아니라 한 흐름이에요. 버전 고르기(pyenv) → 공간 만들기(venv) → 패키지 깔기(pip) → 코드 짜기(VS Code) → 실험하기(ipython). 본인이 새 Python 프로젝트를 시작할 때마다 이 흐름을 타요. 이게 자경단 다섯 명이 매일 아침 새 작업을 시작하는 의식이에요. 그리고 이건 Ch006 셸 환경 셋업과 똑같은 사상이에요. 거기서 brew→iTerm2→oh-my-zsh→starship 흐름을 탔듯, 여기서는 pyenv→venv→pip→VS Code 흐름을 타요. 도구는 다르지만 "환경을 표준화해서 다섯 명이 똑같이 일한다"는 정신은 같아요. 본인이 셸 챕터에서 이 정신을 한 번 겪었으니, Python 환경도 더 편하게 받아들이실 거예요.

---

## 3. 첫 단추 — Python이 본인 노트북에 깔려 있나

가장 먼저 확인할 것. Python이 깔려 있는지.

> ▶ **같이 쳐보기** — Python 버전 확인
>
> ```bash
> python3 --version
> ```

엔터 누르면 보통 `Python 3.12.x` 또는 `Python 3.11.x` 같은 게 떠요. 떴으면 끝. 이미 깔려 있어요. 3.10 이상이면 본 챕터를 따라오기에 충분해요.

만약 `command not found`가 떠요, 그러면 깔아야 해요. 두 가지 길이 있어요. 첫째, brew로 깔기. `brew install python@3.12`. 둘째, python.org에서 인스톨러 다운. 자경단 표준은 brew. 한 줄로 끝.

```bash
brew install python@3.12
```

10분 정도 걸려요. 그동안 커피 한 잔 하세요. 끝나면 `python3 --version`으로 확인.

이미 macOS에 깔린 시스템 Python을 직접 쓰지 마세요. 시스템 도구가 그걸 사용하니까 사고 가능. 본인이 쓰는 Python은 brew로 깐 것 또는 pyenv로 깐 것이어야 해요.

이 "시스템 Python 건드리지 마라"가 왜 그렇게 중요한지 실제 사고로 보여드릴게요. 어떤 초보 개발자가 macOS에 기본으로 깔린 Python에다 직접 pip로 패키지를 막 깔았어요. 편하니까요. 그런데 어느 날 macOS의 시스템 도구 하나가 갑자기 작동을 멈췄어요. 알고 보니 그 도구가 시스템 Python을 쓰는데, 이 사람이 그 Python에 깐 패키지가 시스템이 기대하는 버전과 충돌한 거예요. macOS 자체가 망가지기 시작한 거죠. 복구하느라 며칠이 걸렸어요. 시스템 Python은 macOS 운영체제가 자기 일을 하려고 쓰는 거예요. 본인이 거기에 손대면 운영체제의 도구를 건드리는 거예요. 그래서 최근 Python은 아예 시스템 Python에 pip install을 하면 "externally-managed-environment"라는 에러로 막아요. 본인을 보호하려는 거예요. 처방은 간단해요. 본인만의 Python을 따로 가져요. brew로 깐 Python이나 pyenv로 깐 Python. 그리고 그 위에서도 프로젝트마다 venv로 또 격리해요. 운영체제의 Python과 본인의 Python을 분리하는 게 첫 번째 안전이에요. 본인 집과 회사 건물을 분리하는 것과 같아요. 회사 건물 배관을 본인 마음대로 고치면 건물 전체가 영향받잖아요. 본인 집(venv)에서 마음껏 하세요.

---

## 4. 둘째 단추 — pyenv로 다중 버전 관리

pyenv는 Python 다중 버전 관리 도구예요. 자경단의 한 명이 3.10을 쓰는 프로젝트와 3.12를 쓰는 프로젝트를 동시에 가지고 있을 때, pyenv가 자동으로 전환해 줘요.

> ▶ **같이 쳐보기** — pyenv 설치
>
> ```bash
> brew install pyenv
> echo 'eval "$(pyenv init -)"' >> ~/.zshrc
> source ~/.zshrc
> ```

설치 후 셸을 새로 켜거나 source. 그 다음 사용법.

```bash
# 깔린 버전 보기
pyenv versions

# 새 버전 깔기
pyenv install 3.12
pyenv install 3.11

# 글로벌 기본 버전
pyenv global 3.12

# 프로젝트별 버전
cd my-project
pyenv local 3.11

# 현재 사용 중인 버전
pyenv version
```

`pyenv local 3.11`을 치면 그 폴더에 `.python-version`이라는 파일이 생겨요. 그 폴더에 들어갈 때마다 자동으로 3.11로 전환. 폴더를 나가면 글로벌(3.12)로 돌아와요. 마법 같죠.

자경단 표준 — 글로벌은 3.12, 프로젝트별로 필요한 버전 명시. 두 해 코스의 모든 챕터는 3.12 기준이에요.

pyenv가 없어도 Python 한 버전만 쓰시면 충분해요. 두 해 코스 끝까지 3.12 한 가지로도 가능. pyenv는 본인이 여러 프로젝트를 동시에 다룰 때 유용한 도구예요.

pyenv가 진짜 필요해지는 순간을 미리 그려 드릴게요. 본인이 두 해 코스 후반에 회사에 들어가면, 회사에는 보통 여러 개의 프로젝트가 있어요. 5년 된 오래된 프로젝트는 Python 3.9로 짜여 있고, 작년에 시작한 프로젝트는 3.11, 올해 새로 만든 건 3.12. 본인이 이 세 프로젝트를 오가며 일해야 해요. pyenv가 없으면 본인은 프로젝트를 옮길 때마다 Python을 깔았다 지웠다 해야 해요. 악몽이에요. pyenv가 있으면, 각 프로젝트 폴더에 `.python-version` 파일만 있으면 그 폴더에 들어가는 순간 자동으로 그 버전으로 바뀌어요. 오래된 프로젝트 폴더에 들어가면 자동으로 3.9, 새 프로젝트에 들어가면 자동으로 3.12. 본인은 아무것도 안 해도 돼요. 폴더만 옮기면 Python 버전이 알아서 따라와요. 이게 pyenv의 마법이에요. 그리고 왜 회사가 버전을 통일 안 하느냐고 물으실 수 있어요. 오래된 프로젝트를 새 버전으로 올리는 건 위험하고 비용이 커요. 잘 돌아가는 걸 굳이 건드려서 깨뜨릴 이유가 없어요. 그래서 현실의 회사는 늘 여러 버전이 공존해요. pyenv는 그 현실을 살아가는 도구예요. 지금은 본인이 3.12 한 가지만 써도 되지만, "여러 버전이 공존하는 게 정상이고, pyenv가 그걸 다룬다"는 그림만 머리에 두세요. 그날이 오면 본인이 안 당황해요.

---

## 5. 셋째 단추 — venv로 가상 환경

venv는 Python의 가상 환경 도구. 프로젝트마다 격리된 Python 환경을 만들어요.

왜 가상 환경이 필요할까요. 본인이 A 프로젝트에서 requests 2.28을 쓰고, B 프로젝트에서 requests 2.31을 쓴다고 해 봐요. 글로벌 Python 한 가지에 둘을 동시에 깔 수 없어요. venv가 두 환경을 분리해 줘요.

> ▶ **같이 쳐보기** — venv 만들기
>
> ```bash
> mkdir my-python-project && cd my-python-project
> python3 -m venv .venv
> source .venv/bin/activate
> ```

세 줄로 가상 환경이 만들어졌어요. `.venv`라는 폴더가 생기고, source로 활성화하면 셸 프롬프트 앞에 `(.venv)`가 떠요. 본인이 가상 환경 안에 들어왔다는 표시예요.

가상 환경 안에서 Python을 쓰면 그 환경의 패키지만 봐요. 글로벌 환경엔 영향 안 줘요.

```bash
# 가상 환경 안에서
pip install requests
python3 -c "import requests; print(requests.__version__)"

# 가상 환경 나가기
deactivate
```

`deactivate` 한 줄로 가상 환경 나가기. 셸 프롬프트의 `(.venv)`가 사라져요.

여기서 "활성화(activate)"가 진짜로 무슨 일을 하는지 한 발 들어가 볼게요. 본인이 Ch006 H2에서 배운 PATH 기억하시죠. 셸이 명령어를 찾을 때 PATH의 폴더들을 위에서부터 훑는다고요. `source .venv/bin/activate`가 하는 일이 바로 그 PATH를 잠깐 바꾸는 거예요. 활성화하면 `.venv/bin` 폴더가 PATH의 맨 앞에 추가돼요. 그래서 본인이 `python3`이나 `pip`를 칠 때, 셸이 그 가상 환경 폴더 안의 python3과 pip를 먼저 찾아요. 글로벌 게 아니라요. 그래서 그 안에서 pip install을 하면 가상 환경 폴더 안에만 깔려요. deactivate하면 PATH가 원래대로 돌아오고요. 보세요, 본인이 Ch006에서 배운 PATH가 Python의 가상 환경을 이해하는 열쇠였어요. 가상 환경은 마법이 아니라 PATH를 잠깐 바꾸는 정직한 기계예요. 본인이 셸의 PATH를 알기 때문에, venv가 어떻게 격리를 만드는지 그 속이 보여요. 이게 챕터를 순서대로 배우는 힘이에요. 셸의 PATH가 Python의 venv를 받쳐 줘요. 그러니까 venv가 작동 안 할 때 — 예를 들어 활성화했는데도 글로벌 python이 잡힐 때 — 본인은 "아, PATH 문제구나" 하고 `which python3`으로 확인할 수 있어요. 셸 지식이 Python 문제를 푸는 도구가 돼요.

자경단 표준 — **모든 Python 프로젝트는 venv 안에서**. 글로벌에 패키지 깔지 말기. 한 프로젝트 = 한 가상 환경. 5년 후에도 안전.

`.venv` 폴더는 git ignore해야 해요. 보통 수십 MB라서. `.gitignore`에 `.venv/` 한 줄 추가.

venv가 없으면 어떤 지옥이 펼쳐지는지 그림을 그려 드릴게요. 이걸 업계에서 "dependency hell(의존성 지옥)"이라고 불러요. 본인이 작년에 만든 A 프로젝트가 requests 2.25 버전으로 잘 돌아가고 있어요. 그런데 올해 새로 시작한 B 프로젝트는 최신 requests 2.31이 필요해요. venv가 없으면 본인은 글로벌 Python 하나에 둘 중 하나만 깔 수 있어요. B를 위해 2.31로 업그레이드하면, 작년의 A가 갑자기 깨져요. A를 살리려고 2.25로 내리면 B가 안 돌아가고요. 이러지도 저러지도 못해요. 프로젝트가 열 개면 이 충돌이 열 배로 얽혀요. 한 패키지를 업그레이드하면 다른 다섯 프로젝트가 깨지는, 진짜 지옥이에요. venv가 이 지옥을 통째로 없애요. 각 프로젝트가 자기만의 .venv 폴더 안에 자기 패키지를 가지니까, A는 2.25를, B는 2.31을 각자 가져요. 서로 전혀 영향을 안 줘요. 프로젝트가 백 개여도 백 개가 다 독립이에요. 이게 venv가 "부담스러운 추가 단계"가 아니라 "본인을 지옥에서 구하는 필수품"인 이유예요. 만드는 데 3초밖에 안 걸려요. 그 3초가 본인의 5년을 지옥에서 구해요. 새 프로젝트를 시작하면 묻지도 따지지도 말고 첫 줄에 `python3 -m venv .venv`. 이게 자경단의 철칙이에요.

---

## 6. 넷째 단추 — pip와 requirements.txt

pip는 Python 패키지 매니저. 노드의 npm, 루비의 gem 같은 도구. PyPI라는 50만 개 패키지 저장소에서 원하는 패키지를 깔아요.

> ▶ **같이 쳐보기** — pip 기본 사용
>
> ```bash
> # 가상 환경 안에서
> pip install requests
> pip install pandas
> pip install fastapi
> 
> # 깔린 패키지 보기
> pip list
> 
> # 깔린 패키지를 파일로 저장
> pip freeze > requirements.txt
> 
> # 그 파일로 다시 깔기
> pip install -r requirements.txt
> 
> # 패키지 정보
> pip show requests
> 
> # 패키지 제거
> pip uninstall requests
> ```

자경단의 매일 패턴은 두 가지. 첫째, 새 프로젝트 시작 시 `pip install <필요한 패키지>` 후 `pip freeze > requirements.txt`. 둘째, 기존 프로젝트 받았을 때 `pip install -r requirements.txt`로 재현. 이 두 패턴이 본인이 매일 만나는 거예요. 만들 때 적고, 받을 때 재현. 깔았으면 적고, 적힌 걸 깐다. 이 두 박자가 환경 협업의 전부예요.

requirements.txt 한 장이 본인의 환경 백업이에요. git에 올려 두면 동료가 5초 만에 같은 환경 복원. 이게 Ch005에서 배운 협업과 직접 이어져요. 본인이 코드를 PR로 올릴 때 requirements.txt도 같이 올리면, 리뷰하는 동료가 그 한 장으로 본인 환경을 그대로 재현해서 본인 코드를 돌려 볼 수 있어요. 환경까지 함께 공유하는 게 진짜 협업이에요.

```
# requirements.txt 예시
requests==2.31.0
pandas==2.1.4
fastapi==0.108.0
```

`==`로 정확한 버전 명시. 자경단의 매일 한 줄. 이게 없으면 1년 후 같은 코드가 다른 버전에서 깨지는 사고가 나요.

requirements.txt가 왜 그렇게 중요한지 "내 컴퓨터에선 되는데요" 사건으로 보여드릴게요. 이건 개발자 사이에서 가장 유명한 변명이에요. 본인이 코드를 짜서 동료에게 보냈어요. 동료가 그 코드를 돌렸는데 에러가 나요. 본인 컴퓨터에선 잘 되는데요. 왜 동료 컴퓨터에선 안 될까요. 십중팔구 패키지 버전이 달라서예요. 본인은 pandas 2.1을 깔아 뒀는데, 동료는 pandas 1.5가 깔려 있어서, 어떤 함수가 동료 버전엔 없는 거예요. 같은 코드인데 환경이 달라서 한쪽만 깨져요. requirements.txt가 이걸 막아요. 본인이 `pip freeze > requirements.txt`로 본인의 정확한 패키지 버전을 파일에 적어서 코드와 함께 보내면, 동료는 `pip install -r requirements.txt`로 본인과 똑같은 버전을 깔아요. 그러면 본인 컴퓨터와 동료 컴퓨터가 똑같은 환경이 돼요. "내 컴퓨터에선 되는데요"가 사라져요. 이게 H6 셸에서 본 dotfile 공유, Ch003에서 본 환경 재현과 똑같은 사상이에요. 환경을 글로 적어서 공유하면, 다섯 명이 똑같은 환경에서 일해요. requirements.txt는 Python 환경의 dotfile이에요. 그리고 이건 동료뿐 아니라 1년 후의 본인도 구해요. 1년 후 본인이 이 프로젝트를 새 노트북에서 다시 열 때, requirements.txt 한 장이면 1년 전 환경이 그대로 복원돼요. 미래의 본인에게 보내는 환경 편지예요.

pip의 발전 도구 한 가지 알려드릴게요. **uv**. Rust로 만든 pip의 100배 빠른 대체. 2024년에 나온 새 도구.

```bash
brew install uv
uv pip install requests
```

자경단 표준은 아직 pip지만 1년 후엔 uv로 갈 가능성 높아요. 미리 알아 두세요.

pip를 쓸 때 초보자가 자주 하는 위험한 실수 하나를 짚을게요. `pip install`을 할 때 가상 환경이 켜져 있는지 꼭 확인하세요. 프롬프트 앞에 `(.venv)`가 있는지요. 이게 없는 상태에서 pip install을 하면, 그 패키지가 글로벌이나 시스템 Python에 깔려요. 앞에서 말한 그 지옥의 시작이에요. 그래서 자경단은 습관을 들여요. pip install을 치기 전에 항상 프롬프트를 한 번 봐요. `(.venv)`가 있으면 안심하고 install, 없으면 먼저 `source .venv/bin/activate`. 이 한 번의 확인이 환경 오염을 막아요. 그리고 또 하나, `pip install` 후에 requirements.txt를 업데이트하는 걸 잊지 마세요. 본인이 새 패키지를 깔았는데 requirements.txt에 안 적으면, 동료는 그 패키지를 모르고, 본인의 코드가 동료 컴퓨터에서 깨져요. 그래서 자경단은 "pip install 했으면 pip freeze도 한다"를 짝으로 묶어요. 깔았으면 적는다. 이 두 습관 — 켜졌나 확인하고, 깔았으면 적는다 — 이 본인을 환경 사고에서 평생 지켜요. 작은 습관이지만 5년의 평화를 사요.

---

## 7. 다섯째 단추 — VS Code + Pylance + Ruff

자경단의 표준 코드 에디터는 VS Code예요. 무료, 가볍고, 확장이 풍부. macOS는 brew cask로 한 줄.

```bash
brew install --cask visual-studio-code
```

깔린 후 VS Code를 열고, 다음 세 확장을 깔아요.

```bash
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension charliermarsh.ruff
```

세 확장이 무엇인지 짧게.

**Python**은 Microsoft 공식 Python 확장. 디버거, 가상 환경 인식, 인터프리터 선택. 모든 시작.

**Pylance**는 Python의 type checker + IntelliSense. 본인이 코드 짤 때 자동완성, type 힌트, 에러 검출. 진짜 빠르고 강력해요.

**Ruff**는 Rust로 짠 Python linter + formatter. 옛날 black + flake8 + isort를 한 도구로 합친 것. 100배 빨라요.

세 확장이 자경단 표준. 본 챕터의 모든 코드를 VS Code에서 짤 수 있어요. 세 확장을 깔면 본인의 VS Code가 단순 텍스트 에디터에서 Python 전용 IDE로 진화해요. 자동완성, 에러 표시, 자동 정리가 다 따라와요.

VS Code 설정 한 가지 알려드릴게요. settings.json에 다음을 추가하면 저장할 때마다 자동 포매팅 + 자동 정리.

```json
{
  "editor.formatOnSave": true,
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.codeActionsOnSave": {
      "source.fixAll": "explicit",
      "source.organizeImports": "explicit"
    }
  }
}
```

저장 한 번이 자동 포매팅 + 자동 import 정리. 자경단 다섯 명이 다 같은 스타일로 짜요. 합의가 자동으로 돼요.

이 "저장하면 자동 포매팅"이 별것 아닌 것 같지만 팀의 평화를 지켜요. 포매팅이 없으면 어떤 일이 벌어지는지 아세요. 까미는 들여쓰기를 4칸으로 하고, 노랭이는 2칸으로 하고, 미니는 탭으로 해요. 따옴표도 까미는 작은따옴표, 노랭이는 큰따옴표. 그러면 다섯 명의 코드가 다섯 가지 모양이에요. 그것만이면 괜찮은데, 진짜 문제는 코드 리뷰에서 터져요. 까미가 노랭이의 코드를 고치면, git이 "이 줄이 바뀌었다"고 표시하는데, 사실은 로직이 바뀐 게 아니라 따옴표만 바뀐 거예요. 진짜 중요한 변경이 스타일 변경에 묻혀서 안 보여요. 리뷰가 엉망이 돼요. 그리고 "들여쓰기를 4칸으로 할까 2칸으로 할까" 같은 걸로 다섯 명이 싸우기까지 해요. 이게 진짜로 팀을 갈라요. Ruff 같은 자동 포매터가 이 모든 걸 끝내요. 다섯 명이 각자 어떻게 짜든, 저장하는 순간 똑같은 표준 모양으로 자동 정리돼요. 그러면 스타일 논쟁이 사라지고, 리뷰에는 진짜 로직 변경만 남아요. 다섯 명이 스타일로 안 싸워요. 이게 H6에서 본 shellcheck, Ch005에서 본 husky와 똑같은 사상이에요. 기계가 정리하니까 사람은 본질에 집중해요. 포매터는 코드를 예쁘게 하는 도구가 아니라, 팀의 평화를 지키는 도구예요. 본인이 오늘 settings.json에 한 줄을 박으면, 앞으로 본인은 스타일을 한 번도 신경 안 쓰고 로직에만 집중할 수 있어요.

---

## 8. 여섯째 단추 — REPL 세 종류

Python REPL이 세 종류 있어요. python3, ipython, Jupyter.

**python3**. 표준 REPL. `python3` 한 줄로 시작. 단순.

**ipython**. 진화된 REPL. tab 자동완성, 매직 커맨드, 색깔 출력. brew로 깔아요.

```bash
brew install ipython
ipython
```

ipython의 매직 커맨드 다섯 개 알려드릴게요.

```python
%timeit sum(range(100))    # 시간 측정
%run script.py              # 파일 실행
%load script.py             # 파일 로드
%pwd                        # 현재 디렉토리
%matplotlib                 # matplotlib 인라인
```

**Jupyter**. 노트북 형태의 REPL. 코드 + 결과 + 마크다운이 한 페이지에. 데이터 분석, 머신러닝에서 표준.

```bash
brew install jupyterlab
jupyter lab
```

Jupyter는 자경단의 깜장이가 데이터 시각화할 때 매일 만나요. 백엔드 까미는 가끔. 본인은 두 해 코스 후반 데이터 분석에서 만나요.

자경단의 매일 사용 — python3 (1차), ipython (2차), Jupyter (3차). 본인은 일단 python3과 ipython만 알아 두세요.

ipython의 매직 커맨드 중에 본인이 가장 사랑하게 될 게 `%timeit`이에요. 이게 왜 마법인지 보여드릴게요. 본인이 두 가지 방법으로 같은 일을 짤 수 있을 때, 어느 게 더 빠른지 궁금하잖아요. 머릿속으로 고민하지 말고 `%timeit`으로 직접 재 보면 돼요. ipython에서 `%timeit sum(range(1000000))`을 치면, ipython이 그 코드를 수천 번 자동으로 돌려서 평균 실행 시간을 정확하게 알려줘요. "이 방법은 5밀리초, 저 방법은 50밀리초"가 숫자로 나와요. 그러면 본인은 추측이 아니라 측정으로 더 빠른 방법을 골라요. 이게 5년 차의 일하는 방식이에요. "이게 더 빠를 것 같은데"가 아니라 "재 봤더니 이게 10배 빠르네". 성능에 대한 모든 논쟁을 `%timeit` 한 줄이 끝내요. 그리고 한 가지 더. ipython은 본인이 친 코드를 `_`(언더스코어)로 기억해요. 직전 결과를 `_`로 다시 쓸 수 있어요. 탭을 누르면 자동완성도 되고, 함수 뒤에 `?`를 붙이면 그 함수의 설명이 바로 떠요. `len?`을 치면 len이 뭔지 설명이 나와요. 검색할 필요가 없어요. ipython은 본인의 손에 착 감기는 실험실이에요. python3 기본 REPL로 시작하시되, 한 달쯤 후에 ipython으로 옮기면 본인의 실험 속도가 두 배가 돼요.

---

## 9. 자경단 dotfile에 추가하는 다섯 줄

본인의 `.zshrc`에 Python 관련 다섯 줄을 추가하면 평생 편해요.

```bash
# pyenv
eval "$(pyenv init -)"

# Python 별명
alias py="python3"
alias ipy="ipython"
alias venv="python3 -m venv .venv && source .venv/bin/activate"
alias act="source .venv/bin/activate"

# pip 캐시 위치
export PIP_CACHE_DIR="$HOME/.cache/pip"
```

다섯 줄 중 가장 자주 쓰는 건 `venv`와 `act`. 새 프로젝트 시작할 때 `venv` 한 줄. 다음에 다시 들어갈 때 `act` 한 줄.

자경단 미니가 매일 쓰는 별명을 보여드릴게요.

```bash
alias pf="pip freeze > requirements.txt"
alias pr="pip install -r requirements.txt"
```

`pf`로 현재 환경 백업, `pr`로 환경 재현. 미니의 매일 두 줄.

본인의 dotfile에 어떤 별명을 추가할지는 본인의 일상에 달려 있어요. 한 달 쓰면서 자주 치는 명령을 별명으로 줄여 가세요.

여기서 본인이 Ch006에서 만든 dotfile이 어떻게 자라는지 보세요. Ch006 H8에서 본인이 .zshrc 100줄을 만들었죠. 지금 이 Python 다섯 줄을 거기에 더하면 본인의 dotfile이 105줄이 돼요. 그리고 Ch008에서 또 몇 줄, Ch020 TypeScript에서 또 몇 줄, 이렇게 챕터를 지날 때마다 본인의 dotfile이 자라요. 이게 H8에서 말한 "정원처럼 키운다"의 실제 모습이에요. 본인이 새 도구를 배울 때마다 그 도구의 별명을 dotfile에 한 줄씩 심어요. 그러면 2년 코스가 끝날 때쯤 본인의 dotfile은 200줄, 300줄로 자라 있어요. 그 dotfile 한 장이 본인이 2년 동안 배운 모든 도구의 손가락 단축어를 담고 있어요. 그러니까 오늘 이 다섯 줄을 그냥 복사하지 마시고, 본인의 Ch006 dotfile을 열어서 거기에 손으로 더하세요. "아, 내 dotfile에 Python 칸이 생겼구나" 하고요. 그게 본인의 손가락이 셸에서 Python으로 확장되는 순간이에요. 그리고 이 dotfile은 GitHub에 백업돼 있으니까, 본인이 오늘 Python 다섯 줄을 더하고 commit하면, 본인의 성장이 또 한 줄 git 히스토리에 기록돼요. 본인의 dotfile git 로그를 1년 후에 보면, 본인이 셸→Python→TypeScript 순으로 자란 여정이 다 보여요. 그게 본인의 성장 일기예요.

---

## 10. macOS·Linux·Windows 변환표

| 항목 | macOS | Linux (Ubuntu) | Windows |
|------|-------|----------------|---------|
| Python 설치 | brew | apt | python.org |
| pyenv | brew | curl 스크립트 | pyenv-win |
| venv | python3 -m venv | python3 -m venv | python -m venv |
| 활성화 | source .venv/bin/activate | 같음 | .venv\Scripts\activate |
| pip | 같음 | 같음 | 같음 |
| VS Code | 같음 | 같음 | 같음 |

macOS와 Linux는 거의 같아요. Windows는 활성화 명령 한 줄만 다르고 나머지는 같아요. 자경단 표준 환경이 세 OS 모두에서 비슷하게 작동해요.

WSL2를 쓰는 Windows 사용자는 macOS와 거의 동일한 경험이에요. 본 챕터를 그대로 따라오실 수 있어요.

이 표에서 한 가지를 느끼셨으면 좋겠어요. 세 OS가 거의 똑같아요. 다른 건 패키지 설치 방법과 활성화 명령 한 줄뿐이에요. 핵심 도구 — venv, pip, VS Code — 는 세 OS에서 완전히 동일해요. 이게 Python의 큰 장점이에요. 본인이 macOS에서 배운 게 Linux 서버에서도, Windows 동료의 컴퓨터에서도 거의 그대로 통해요. 그래서 자경단 미니가 Linux에서 일하고, 나머지 넷이 macOS에서 일해도, 다섯 명이 똑같은 Python 코드를 짜고 똑같은 환경을 공유할 수 있어요. 언어가 OS를 가로질러 통일해 주는 거예요. 본인이 두 해 코스 끝에 자경단 사이트를 AWS의 Linux 서버에 올릴 때, 그 서버에서 다루는 Python이 본인이 지금 macOS에서 배우는 Python과 거의 똑같아요. 활성화 명령 한 줄만 알면 돼요. OS가 달라도 Python은 본인 편이에요. 이 일관성이 본인이 한 번 배운 걸 평생, 어디서든 쓸 수 있게 만들어요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: Python은 한 버전만 쓰면 된다.**

자경단은 보통 2-3개 버전을 동시에. pyenv로 관리.

**오해 2: 가상 환경은 부담스럽다.**

3초면 만들어요. `python3 -m venv .venv`. 매일 새 프로젝트마다 한 번씩.

**오해 3: pip install을 글로벌에 해도 된다.**

안 돼요. 1년 후 system 깨짐. 항상 venv 안에서.

**오해 4: VS Code는 무거운 IDE다.**

가벼워요. 무거운 IDE는 PyCharm. VS Code는 1초 안에 떠요.

**오해 5: REPL은 옛 도구다.**

매일 써요. 작은 실험은 REPL이 가장 빨라요. ipython이 표준. 5년 차도 헷갈리면 책 찾기 전에 REPL을 켜요. 1초 실험이 10분 검색보다 빠르거든요.

**오해 6: 환경 셋업은 한 번에 매끈하게 돼야 한다.**

아니에요. 에러가 나는 게 정상이에요. 5년 차도 새 노트북 셋업에서 에러를 만나요. 에러를 한 줄씩 푸는 게 셋업이에요. 그 과정이 본인을 단단하게 해요.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. python vs python3?**

macOS에서는 `python3` 써야 해요. `python`은 Python 2일 수 있어요. dotfile에 alias로 `py="python3"` 박아 두면 편해요.

**Q2. venv vs conda?**

venv는 표준, conda는 데이터 분야 특화. 자경단은 venv 우선. 데이터 분석할 때만 conda.

**Q3. requirements.txt에 버전 없이 쓰면?**

위험해요. 1년 후 다른 버전이 깔려서 사고. 항상 `==`로 명시.

**Q4. Pylance와 mypy 차이?**

Pylance는 IDE 안에서 실시간. mypy는 CLI에서 명시적 검사. 둘 다 필요.

**Q5. 30분 셋업이 너무 길어요.**

핵심은 첫 4단추 (python3, venv, pip, VS Code). pyenv와 ipython은 나중에 깔아도 돼요.

**Q6. venv 폴더 이름을 꼭 .venv로 해야 하나요?**

자경단 표준이 `.venv`예요. 점으로 시작해서 숨김 폴더가 되고, VS Code가 자동으로 인식하고, .gitignore에 한 줄로 넣기 편하거든요. `venv`나 `env`로 해도 동작은 하지만, 다섯 명이 같은 이름을 쓰는 게 합의에 좋아요. `.venv`로 통일하세요.

**Q7. 가상 환경을 깜빡하고 글로벌에 깔았어요. 어떻게 되돌리나요?**

글로벌에 깐 패키지를 `pip uninstall`로 지우고, 제대로 venv를 활성화한 뒤 다시 깔면 돼요. 큰일은 안 나요. 다만 시스템 Python에 깐 거라면 건드리지 말고 그냥 두세요. 새 venv를 만들어서 거기서 다시 시작하는 게 깔끔해요.

---

## 13. 흔한 실수 다섯 가지 + 안심 멘트 — Python 환경 학습 편

Python 환경 셋업하며 자주 빠지는 함정 다섯.

첫 번째 함정, 시스템 Python에 pip install. 본인이 macOS의 /usr/bin/python3에 직접. 안심하세요. **항상 venv 또는 pyenv.** 시스템 Python 절대 건드리지 않음.

두 번째 함정, pyenv vs conda 둘 다 사용. 안심하세요. **하나만.** 일반 학습은 pyenv, 데이터/AI는 conda.

세 번째 함정, requirements.txt 안 만든다. 안심하세요. **첫날 `pip freeze > requirements.txt`.** 두 해 후 새 컴퓨터 한 줄로.

네 번째 함정, IDE 셋업에 너무 많은 시간. 안심하세요. **VS Code + Python 확장 5분.** 첫달엔 간단하게, 익숙해지면 plugin.

다섯 번째 함정, 가장 큰 함정. **테스트 안 짠다.** 본인이 코드만, 테스트 0. 안심하세요. **첫날부터 pytest 한 줄.** 한 함수에 한 테스트가 본인 안전벨트.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 14. 마무리 — 다음 H4에서 만나요

자, 세 번째 시간이 끝났어요. 60분 동안 본인은 Python 표준 환경을 본인 노트북에 박으셨어요. 정리하면 이래요.

python3 첫 단추. pyenv로 다중 버전. venv로 가상 환경. pip와 requirements.txt. VS Code + Pylance + Ruff. ipython으로 진화된 REPL. dotfile에 다섯 줄 추가. 본인의 노트북이 30분 안에 자경단 Python 환경으로 변했어요.

오늘 배운 것 중에서 딱 하나만 가져가신다면, **venv**를 가져가세요. 새 Python 프로젝트를 시작할 때마다 `python3 -m venv .venv`. 이 한 줄이 본인을 의존성 지옥에서 평생 구해요. pyenv도, ipython도, 다 나중에 천천히 익혀도 돼요. 하지만 venv는 첫날부터 습관으로 만드세요. 그게 오늘 30분에서 가장 값진 한 줄이에요. 그리고 환경 셋업은 한 번 해 두면 평생 쓰는 거라, 오늘 30분이 본인의 5년을 받쳐 줘요. 시간 대비 정말 좋은 투자예요.

박수 한 번 칠게요. 손으로 환경을 만드느라 고생하셨어요.

다음 H4는 도구 카탈로그예요. python3 명령 옵션, pip 명령 10개, ipython 매직, black/ruff/mypy. 매일 6개부터 6주에 30개 도구가 손에 박혀요. 한 시간 후 만나요.

그 전에 한 가지 부탁. 지금 잠깐 멈추시고 다음 한 묶음을 차례로 쳐 보세요.

```bash
mkdir test-py && cd test-py
python3 -m venv .venv
source .venv/bin/activate
pip install requests
python3 -c "import requests; print(requests.__version__)"
deactivate
```

10초예요. 본인의 H3 졸업장이에요. 가상 환경을 처음 만들고, 패키지 깔고, 활성화·해제. 본인의 첫 venv 사이클이에요. 이 다섯 줄이 본인이 두 해 코스 내내, 그리고 그 후 5년 내내 모든 Python 프로젝트를 시작할 때 치는 의식이에요. 새 프로젝트 = 새 폴더 + venv + activate + pip install. 이 의식이 손에 박히면, 본인은 환경 사고 없이 깨끗하게 일하는 개발자가 돼요. 오늘 그 의식의 첫 리허설을 했어요. 내일부터는 진짜 프로젝트에서 이 다섯 줄을 쳐 보세요. 한 달이면 손가락이 외워요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - python3 vs python: PEP 394 권고대로 macOS와 Linux는 python3, Windows는 py. PATH에 따라 다름.
> - pyenv vs asdf: pyenv는 Python만, asdf는 다언어 (Python·Node·Ruby). 다언어 프로젝트면 asdf, Python만이면 pyenv.
> - venv vs virtualenv: 둘 다 가상 환경. venv는 Python 3.3+ 표준 라이브러리, virtualenv는 외부 (더 옛). venv 우선.
> - pip vs pipx: pip은 라이브러리 설치, pipx는 CLI 도구 격리 설치. 자경단 표준 — 라이브러리는 pip, 글로벌 CLI는 pipx.
> - poetry vs pip: poetry는 의존성 관리 + 빌드 + 출판 통합. pip + requirements.txt보다 강력하지만 학습 곡선. 자경단은 pip 시작, 큰 프로젝트는 poetry.
> - uv (2024): Rust로 짠 pip 대체. 100배 빠름. 자경단 1-2년 후 표준 가능성.
> - VS Code Python 인터프리터 선택: Cmd+Shift+P → Python: Select Interpreter. .venv 선택 자동 인식.
> - Pylance 모드: basic vs strict. strict는 type 미명시 경고. 자경단 표준은 strict.
> - Jupyter vs JupyterLab: Lab이 새 버전, 더 풍부. Notebook은 옛 버전. 새 프로젝트는 Lab.
> - 다음 H4 키워드: python3 옵션 6 · pip 명령 10 · venv 4 · ipython 매직 5 · black · ruff · mypy.

---

## 추신

1. 30분 셋업이 본인 노트북을 자경단 Python 환경으로.
2. 6도구 — python3·pyenv·venv·pip·VS Code·ipython.
3. `python3 --version`으로 먼저 확인. 99% 이미 깔려 있어요.
4. 시스템 Python 직접 사용 금지. brew나 pyenv로 깐 것을.
5. pyenv=다중 버전 관리. 자경단은 3.10·3.11·3.12 동시 보유.
6. `pyenv local 3.11`이 `.python-version` 파일 생성. 폴더 진입 시 자동 전환.
7. 자경단 글로벌 3.12. 두 해 코스 전부 3.12 기준.
8. venv=프로젝트별 격리 환경. A의 패키지가 B에 영향 안 줌.
9. `python3 -m venv .venv` + `source .venv/bin/activate`.
10. 활성화하면 프롬프트에 `(.venv)`. `deactivate`로 나가기.
11. 모든 프로젝트는 venv 안에서. 글로벌에 패키지 깔지 말기.
12. `.venv/`는 .gitignore에. 수십 MB라서.
13. pip=패키지 매니저. PyPI 50만 개에서 한 줄로.
14. `pip freeze > requirements.txt`로 백업, `pip install -r`로 재현.
15. requirements.txt에 `==`로 버전 명시. 1년 후 사고 방지.
16. requirements.txt 한 장이 환경 백업. git에 올리면 동료 5초 복원.
17. uv(2024 Rust)=pip 100배. 1~2년 후 표준 가능성.
18. VS Code=자경단 표준 에디터. 무료·가벼움·확장 풍부.
19. 세 확장 — Python·Pylance(타입·자동완성)·Ruff(linter+formatter).
20. settings.json `formatOnSave: true`로 저장 시 자동 정리.
21. 다섯 명이 같은 설정=합의가 자동.
22. REPL 3종 — python3(표준)·ipython(매직)·Jupyter(노트북).
23. ipython 매직 5 — %timeit·%run·%load·%pwd·%matplotlib.
24. dotfile 5줄 — pyenv·py·ipy·venv·act 별명.
25. `venv`로 새 프로젝트 시작, `act`로 재진입.
26. macOS·Linux 거의 동일. Windows는 활성화 한 줄만 다름.
27. python(2일 수도)이 아니라 python3. alias `py="python3"`.
28. venv 표준, conda는 데이터 분야만.
29. H3 졸업장 — mkdir·venv·activate·pip install·deactivate 사이클.
30. 다음 H4는 Python 18 도구 카탈로그. 한 시간 쉬고 만나요. 🐾
