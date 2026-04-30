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

---

## 3. 첫 단추 — Python이 본인 노트북에 깔려 있나

가장 먼저 확인할 것. Python이 깔려 있는지.

> ▶ **같이 쳐보기** — Python 버전 확인
>
> ```bash
> python3 --version
> ```

엔터 누르면 보통 `Python 3.12.x` 또는 `Python 3.11.x` 같은 게 떠요. 떴으면 끝. 이미 깔려 있어요.

만약 `command not found`가 떠요, 그러면 깔아야 해요. 두 가지 길이 있어요. 첫째, brew로 깔기. `brew install python@3.12`. 둘째, python.org에서 인스톨러 다운. 자경단 표준은 brew. 한 줄로 끝.

```bash
brew install python@3.12
```

10분 정도 걸려요. 끝나면 `python3 --version`으로 확인.

이미 macOS에 깔린 시스템 Python을 직접 쓰지 마세요. 시스템 도구가 그걸 사용하니까 사고 가능. 본인이 쓰는 Python은 brew로 깐 것 또는 pyenv로 깐 것이어야 해요.

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

자경단 표준 — **모든 Python 프로젝트는 venv 안에서**. 글로벌에 패키지 깔지 말기. 한 프로젝트 = 한 가상 환경. 5년 후에도 안전.

`.venv` 폴더는 git ignore해야 해요. 보통 수십 MB라서. `.gitignore`에 `.venv/` 한 줄 추가.

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

자경단의 매일 패턴은 두 가지. 첫째, 새 프로젝트 시작 시 `pip install <필요한 패키지>` 후 `pip freeze > requirements.txt`. 둘째, 기존 프로젝트 받았을 때 `pip install -r requirements.txt`로 재현.

requirements.txt 한 장이 본인의 환경 백업이에요. git에 올려 두면 동료가 5초 만에 같은 환경 복원.

```
# requirements.txt 예시
requests==2.31.0
pandas==2.1.4
fastapi==0.108.0
```

`==`로 정확한 버전 명시. 자경단의 매일 한 줄. 이게 없으면 1년 후 같은 코드가 다른 버전에서 깨지는 사고가 나요.

pip의 발전 도구 한 가지 알려드릴게요. **uv**. Rust로 만든 pip의 100배 빠른 대체. 2024년에 나온 새 도구.

```bash
brew install uv
uv pip install requests
```

자경단 표준은 아직 pip지만 1년 후엔 uv로 갈 가능성 높아요. 미리 알아 두세요.

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

세 확장이 자경단 표준. 본 챕터의 모든 코드를 VS Code에서 짤 수 있어요.

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

매일 써요. 작은 실험은 REPL이 가장 빨라요. ipython이 표준.

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

박수 한 번 칠게요.

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

10초예요. 본인의 H3 졸업장이에요. 가상 환경을 처음 만들고, 패키지 깔고, 활성화·해제. 본인의 첫 venv 사이클이에요.

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
