# Ch007 · H4 — Python 입문 1: 명령어/도구 카탈로그 — 18 도구 + 위험도 신호등

> **이 H에서 얻을 것**
> - Python CLI 도구 18개 한 표 + 위험도 신호등 (🟢🟡🔴)
> - 6 무리(인터프리터·패키지·실행·가상환경·품질·테스트) × 평균 3개 깊이
> - 매일·주간·월간 손가락 리듬 + 자경단 13줄 흐름 (Python 버전)
> - 자경단 5명 매일 사용표 + 5 사고 처방
> - 모던 도구 5종 (uv·poetry·pdm·hatch·rye) 비교 + 면접 단골 5질문
> - AI 시대의 18 도구 — Claude Code·Cursor·Copilot이 어떻게 사용하는가

---

## 회수: H3의 9 환경 도구에서 본 H의 18 매일 손가락으로

지난 H3에서 본인은 자경단 표준 환경 9 도구(brew·python3.12·pyenv·VS Code·black·ruff·mypy·ipython·venv)를 30분에 박았어요. 그건 **환경의 토대**.

이번 H4는 그 환경 위에서 **본인이 매일 치는 18 명령어**예요. 매일 1만 번 발동. 한 명령어가 매일 555번. 본인의 평생 손가락이 본 H에 다 있어요.

지난 Ch005 H4는 git 30 명령어, Ch006 H4는 셸 30 명령어. 본 H는 Python 18 명령어. 셋이 합쳐 **자경단 3 stack 78 명령어**가 본인의 매일.

본 H의 18은 git·셸의 30보다 적어 보이지만, Python의 18은 각각 깊이가 큼. `python3 -m`만 100가지 모듈 호출. `pip install`도 5가지 옵션. 18이 깊어지면 100+로 펼쳐져요.

---

## 1. 위험도 신호등 (Ch005·006 회수)

매 명령어에 3색 신호등.

- 🟢 **read-only** — 사고 0. 100번 쳐도 안전. 예: `python3 -V`, `pip list`, `mypy .`.
- 🟡 **local 변경** — 본인 노트북만. 보통 reflog·git·venv 재생성으로 복구. 예: `pip install`, `python3 script.py`, `venv 생성`.
- 🔴 **irreversible** — 되돌리기 어려움. 1초 호흡. 예: `pip install --user --break-system-packages`, `rm -rf .venv` (실수 시 setup 다시), `pytest --pdb` (debugger 진입).

본 H의 18 도구 중 **빨강은 거의 없음**. Python 18 도구는 셸 30보다 안전. 다만 옵션에 따라 색이 바뀜. `pip install -U package`가 의존성을 한번에 갱신하면서 다른 패키지 깨뜨릴 수 있음 — 🟡로 분류.

---

## 2. 18 도구 한 표

| # | 도구 | 무리 | 신호등 | 한 줄 정의 |
|---|------|------|-------|----------|
| 1 | `python3` | 인터프리터 | 🟢 | REPL 또는 스크립트 실행 |
| 2 | `python3 -V` | 인터프리터 | 🟢 | 버전 확인 |
| 3 | `python3 -c 'code'` | 인터프리터 | 🟡 | 한 줄 실행 |
| 4 | `python3 -m module` | 인터프리터 | 🟡 | 모듈 CLI 실행 |
| 5 | `python3 -i script.py` | 인터프리터 | 🟡 | 실행 후 REPL 진입 |
| 6 | `python3 -O script.py` | 인터프리터 | 🟢 | optimized 모드 (assert 제거) |
| 7 | `pip install pkg` | 패키지 | 🟡 | 패키지 설치 |
| 8 | `pip install -r req.txt` | 패키지 | 🟡 | 일괄 설치 |
| 9 | `pip uninstall pkg` | 패키지 | 🟡 | 제거 |
| 10 | `pip freeze > req.txt` | 패키지 | 🟡 | 의존성 백업 |
| 11 | `pip list` | 패키지 | 🟢 | 설치 목록 |
| 12 | `python3 -m venv .venv` | 가상환경 | 🟡 | venv 생성 |
| 13 | `source .venv/bin/activate` | 가상환경 | 🟡 | venv 진입 |
| 14 | `deactivate` | 가상환경 | 🟢 | venv 나감 |
| 15 | `black .` | 품질 | 🟡 | 포맷터 (자동 수정) |
| 16 | `ruff check .` | 품질 | 🟢 | linter |
| 17 | `mypy .` | 품질 | 🟢 | type checker |
| 18 | `pytest` | 테스트 | 🟡 | 테스트 실행 |

---

## 3. 무리 1: 인터프리터 6개 깊이

### 3-1. `python3` — REPL의 매일 5분

```bash
$ python3
Python 3.12.0 (main, Oct  2 2023, 13:45:54)
>>> 2 + 3
5
>>> name = "까미"
>>> f"안녕 {name}"
'안녕 까미'
>>> import datetime; datetime.datetime.now()
datetime.datetime(2026, 4, 28, 15, 30, 0)
>>> exit()  # 또는 Ctrl-D
```

**자경단 매일 5분 REPL 의식** — 새로운 라이브러리 한 줄 시도, 표현식 검증, datetime 계산. 1년 1,825 표현식.

**자경단 함정 1**: macOS의 `python` 단독은 시스템 또는 다른 버전 가능성. 무조건 `python3`. dotfile에 `alias py=python3`로 단축.

**자경단 함정 2**: REPL 내 들여쓰기는 `... ` 프롬프트. `if x:` 다음 줄을 들여쓰지 않으면 IndentationError.

**ipython 차이**: `ipython`이 자동완성·color·magic 명령(`%timeit`·`%pwd`)·`?`·`??` 강력. 자경단 1년 차에 ipython 표준 권장. 하지만 `python3` 표준 REPL을 먼저 익히기.

### 3-2. `python3 -V` — 환경 검증의 첫 명령

```bash
$ python3 -V
Python 3.12.0
$ python3 --version    # 같음
Python 3.12.0
```

자경단 매일 시작 시 검증. CI에서도. `Python 3.12`가 자경단 표준 — 다르면 환경 불일치 신호.

**자경단 사용처**:
- 새 노트북 셋업 직후 → 3.12 확인
- venv 생성 전 → base Python 버전 확인
- CI 첫 step → `runs-on: ubuntu-latest`가 어느 Python인지

### 3-3. `python3 -c 'code'` — 한 줄 실행의 매일

```bash
$ python3 -c 'print(2 + 3)'
5
$ python3 -c 'import sys; print(sys.path)'
['', '/usr/lib/python312.zip', '/usr/lib/python3.12', ...]
$ python3 -c 'import json; print(json.dumps({"name": "까미"}))'
{"name": "까미"}
```

자경단 자주 — 셸 스크립트 안에서 한 줄 Python. 셸 스크립트가 못 하는 일을 한 줄 Python으로.

**자경단 시나리오**:
```bash
# log에서 timestamp 추출 (셸로 어려움)
$ python3 -c 'import sys, re; [print(re.search(r"\d{4}-\d{2}-\d{2}", l).group()) for l in sys.stdin]' < app.log

# JSON에서 cat 이름 추출
$ curl api/cats | python3 -c 'import sys, json; [print(c["name"]) for c in json.load(sys.stdin)]'
```

**자경단 함정**: 셸의 single quote vs double quote. Python 코드에 따옴표 있으면 escape 필요. `python3 -c "print(\"안녕\")"` 양식. 자경단 — 가능한 single quote (`'...'`).

### 3-4. `python3 -m module` — 모듈 CLI 실행

`-m` 옵션은 자경단 매일 가장 강력한 손가락. 모든 Python 모듈을 CLI로.

```bash
# 가상환경 생성
$ python3 -m venv .venv

# pytest 실행 (pytest 명령어 대신)
$ python3 -m pytest tests/

# pip 실행
$ python3 -m pip install requests

# HTTP 서버 (즉석)
$ python3 -m http.server 8000

# JSON 포맷
$ cat data.json | python3 -m json.tool

# 모듈 위치 확인
$ python3 -m site

# 모듈 디버거
$ python3 -m pdb script.py
```

**왜 `-m`이 표준인가** — `pip` 단독과 `python3 -m pip`의 차이는 **어느 Python의 pip인가**. 다중 Python 환경에서 `pip`은 첫 발견된 것 (위험), `python3 -m pip`은 명시한 Python의 pip (안전).

**자경단 표준** — `python3 -m pip` (단순 pip 아님), `python3 -m pytest`, `python3 -m black`. 모든 도구를 `-m`으로.

### 3-5. `python3 -i script.py` — 디버깅 친구

```bash
$ python3 -i script.py
# script.py 실행 후 REPL 진입
>>> cats             # script가 정의한 변수 검사 가능
['까미', '노랭이']
>>> type(cats[0])
<class 'str'>
>>> exit()
```

자경단 디버깅의 5분 도구. `print()` 디버깅 + `-i` REPL이 면접 단골 디버깅.

**자경단 시나리오**:
```python
# script.py — 의심 가는 함수
def calculate_score(cat):
    return cat['age'] * 10 + cat['friends']

cats = [{'name': '까미', 'age': 3, 'friends': 5}]
result = calculate_score(cats[0])
```

```bash
$ python3 -i script.py
>>> calculate_score({'age': 5, 'friends': 0})    # 직접 호출 검사
50
>>> result
35
```

### 3-6. `python3 -O script.py` — prod 최적화

```bash
$ python3 -O script.py
# 효과:
# 1. assert 문 제거
# 2. __debug__가 False
# 3. .pyo 파일 생성 (옛 버전)
```

자경단 prod 실행 시. assert으로 디버깅한 코드가 prod에서 무효화 → 빠름.

**자경단 함정** — `-O`로 assert가 빠져서 안전 검사 안 되면 사고. assert 대신 `if not condition: raise ...` 권장. assert는 디버깅 전용.

### 3-7. 인터프리터 6 한 줄 요약

| # | 명령어 | 자경단 매일 사용 횟수 |
|---|--------|------------------|
| 1 | `python3` (REPL) | 5분 의식 + 실험 |
| 2 | `python3 -V` | 환경 검증 매일 1번 |
| 3 | `python3 -c 'code'` | 셸 안 한 줄 매일 5번 |
| 4 | `python3 -m module` | 매일 30번 (pip·pytest·venv) |
| 5 | `python3 -i script.py` | 디버깅 시 매주 5번 |
| 6 | `python3 -O script.py` | prod 실행 시 매주 1번 |

6 도구 × 매일 사용 = 자경단 매일 인터프리터 의식.

---

## 4. 무리 2: 패키지 5개 깊이

### 4-1. `pip install pkg` — 매일 5번

```bash
$ pip install requests              # 최신 안정
$ pip install requests==2.31.0      # 정확한 버전 (자경단 표준 prod)
$ pip install 'requests>=2.30,<3'   # 범위
$ pip install -e .                  # editable install (개발)
$ pip install -U requests           # upgrade
$ pip install --user requests       # 사용자만 (venv 안 쓸 때)
$ pip install -i https://...        # 다른 index
```

**자경단 표준 5가지 양식**:
1. **개발 시작** — `pip install requests` (최신 안정)
2. **prod 잠금** — `pip install requests==2.31.0` (정확한 버전 → requirements.txt에 박힘)
3. **업그레이드 검토** — `pip install -U requests` (1년에 한 번씩 검토)
4. **자기 패키지 개발** — `pip install -e .` (코드 변경 즉시 반영)
5. **CI** — `pip install -r requirements.txt` (잠금 파일 일괄)

**자경단 함정 1**: `pip install package`가 의존성도 같이 설치. 다른 패키지의 의존성과 충돌 가능. venv가 그래서 필수.

**자경단 함정 2**: `pip install -U package`이 의존성도 갱신. 다른 패키지 깨뜨릴 수 있음. `pip install -U package --upgrade-strategy only-if-needed`로 최소 갱신.

**자경단 함정 3**: macOS의 `pip install --user`이 brew Python과 충돌. 자경단 표준 — venv만, `--user` X.

### 4-2. `pip install -r requirements.txt` — 매 프로젝트 첫 명령

```bash
$ cat requirements.txt
requests==2.31.0
fastapi==0.110.0
pydantic==2.6.0
uvicorn[standard]==0.29.0

$ pip install -r requirements.txt
Collecting requests==2.31.0
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
...
Successfully installed requests-2.31.0 fastapi-0.110.0 ...
```

자경단 모든 프로젝트의 첫 셋업 명령.

**자경단 표준 양식**:
- `requirements.txt` — prod 의존성
- `requirements-dev.txt` — 개발 도구 (pytest·black·ruff·mypy)
- `requirements-test.txt` — 테스트 의존성

```bash
$ pip install -r requirements.txt -r requirements-dev.txt
```

**자경단 함정** — `requirements.txt`에 정확한 버전 없이 `requests`만 쓰면 매번 다른 버전 설치. CI 깨질 수도. **`==` 정확한 버전** 또는 lockfile 표준.

### 4-3. `pip uninstall pkg` — 가끔

```bash
$ pip uninstall requests
Found existing installation: requests 2.31.0
Uninstalling requests-2.31.0:
  Would remove:
    /path/to/.venv/lib/python3.12/site-packages/requests/*
Proceed (Y/n)?

$ pip uninstall -y requests          # 확인 없이
```

**자경단 함정** — uninstall이 의존성은 안 지움. `pip install requests`이 `urllib3`·`certifi`도 설치하지만 uninstall은 requests만. 자경단 — 의존성 청소는 venv 재생성 권장.

### 4-4. `pip freeze > requirements.txt` — 의존성 백업

```bash
$ pip freeze > requirements.txt
$ cat requirements.txt
certifi==2024.2.2
charset-normalizer==3.3.2
fastapi==0.110.0
idna==3.6
pydantic==2.6.0
requests==2.31.0
...
```

자경단 매주 또는 의존성 추가 후.

**자경단 함정** — `pip freeze`이 의존성의 의존성도 다 출력. 직접 install한 것 vs 자동 install된 것 구분 어려움. **pip-tools의 pip-compile이 직접 install만** — 자경단 1년 후.

### 4-5. `pip list` — 매일 검증

```bash
$ pip list
Package      Version
------------ -------
fastapi      0.110.0
pydantic     2.6.0
requests     2.31.0
...

$ pip list --outdated         # 갱신 가능
$ pip list --user             # 사용자 install만
```

자경단 매일 환경 검증. 새 패키지 install 후 검증.

### 4-6. 패키지 5 한 줄 요약

| # | 명령어 | 매일 사용 |
|---|--------|---------|
| 7 | `pip install pkg` | 매일 5번 |
| 8 | `pip install -r req.txt` | 새 프로젝트 진입 시 |
| 9 | `pip uninstall pkg` | 매주 1번 |
| 10 | `pip freeze > req.txt` | 매주 의존성 추가 후 |
| 11 | `pip list` | 매일 검증 |

---

## 5. 무리 3: 가상환경 3개 깊이

### 5-1. `python3 -m venv .venv` — 새 프로젝트 첫 명령

```bash
$ python3 -m venv .venv
$ ls .venv/
bin     include  lib    pyvenv.cfg
$ ls .venv/bin/
activate         activate.csh     activate.fish    activate.ps1
pip              pip3             python           python3
```

`.venv`은 격리된 Python 환경. 그 안의 `python`·`pip`이 시스템과 분리.

**자경단 표준** — `.venv` 이름. 점 시작 (숨은 디렉토리). 자경단 모든 repo의 .gitignore에 `.venv`.

**자경단 함정 1**: venv 생성 시 system Python 버전을 상속. `python3.11`로 venv 만들면 venv도 3.11. pyenv로 다른 버전 가능.

**자경단 함정 2**: `.venv` 위치 — repo 루트가 표준. 다른 위치(예: `~/.envs/myproject`)도 가능하지만 repo 루트가 단순.

### 5-2. `source .venv/bin/activate` — 매 작업 시작

```bash
$ source .venv/bin/activate
(.venv) $ which python
/path/to/repo/.venv/bin/python
(.venv) $ which pip
/path/to/repo/.venv/bin/pip
(.venv) $ python --version
Python 3.12.0
```

진입 후 프롬프트에 `(.venv)` 표시. starship의 python 모듈도 표시.

**자경단 매일 의식** — 새 셸 진입 → repo 진입 → `source .venv/bin/activate`. 자동화는 direnv (1년 후).

**셸별 차이**:
- bash·zsh — `source .venv/bin/activate`
- fish — `source .venv/bin/activate.fish`
- PowerShell — `.venv\Scripts\Activate.ps1`

### 5-3. `deactivate` — 나감

```bash
(.venv) $ deactivate
$
```

한 단어. 셸 종료해도 자동 deactivate.

**자경단 시나리오** — venv 안에서 다른 프로젝트로 이동 시 `deactivate` → `cd ../other` → `source .venv/bin/activate`. 또는 `deactivate` 없이 새 venv activate (덮어쓰기).

### 5-4. 가상환경 3 한 줄 요약

| # | 명령어 | 사용 시점 |
|---|--------|---------|
| 12 | `python3 -m venv .venv` | 새 프로젝트 진입 1번 |
| 13 | `source .venv/bin/activate` | 매 작업 시작 |
| 14 | `deactivate` | 다른 프로젝트로 이동 시 |

### 5-5. venv vs virtualenv vs conda vs uv

| 도구 | 특징 | 자경단 |
|------|------|------|
| `venv` (Python 3.3+ 표준) | Python 표준, 단순 | **표준** |
| `virtualenv` (외부) | 옛 표준, Python 2 호환 | X |
| `conda` (Anaconda) | 데이터과학 + 비-Python 패키지 | 옵션 |
| `uv` (Astral, 2024) | 100배 빠름, venv + pip 통합 | 1년 후 |
| `pyenv-virtualenv` | pyenv plugin | 가끔 |

**자경단 표준 = venv**. 단순. 1년 후 uv 검토.

---

## 6. 무리 4: 품질 3개 깊이

### 6-1. `black .` — 포맷터의 매일 자동

```bash
$ black .
reformatted /path/to/file.py
All done! ✨ 🍰 ✨
1 file reformatted, 5 files left unchanged.
```

자동 포맷. 자경단 모든 PR에서 CI lint.

**자경단 표준 설정** (`pyproject.toml`):
```toml
[tool.black]
line-length = 100
target-version = ['py312']
```

**black의 강점** — "no configuration"이 표준. 5명이 같은 양식. 자경단 합의 비용 0.

**black의 함정** — black이 자동으로 ' → " 변환. 자경단 5명이 다른 따옴표 쓰면 매 PR 큰 diff. black이 강제 통일.

### 6-2. `ruff check .` — Linter의 빠름

```bash
$ ruff check .
file.py:5:1: F401 'os' imported but unused
file.py:10:5: E501 line too long (101 > 100)
file.py:15:5: B008 Do not perform function call in argument defaults
Found 3 errors.

$ ruff check . --fix             # 자동 수정 가능한 것만
file.py:5:1: F401 [*] 'os' imported but unused
Found 3 errors (1 fixed, 2 remaining).
```

자경단 표준 linter. flake8 (느림) 대체. 600+ 룰셋. Rust 작성 → 100배 빠름.

**자경단 표준 설정** (`pyproject.toml`):
```toml
[tool.ruff]
line-length = 100
target-version = "py312"
select = ["E", "F", "I", "B", "UP"]   # 5 룰셋
```

**ruff의 가치** — flake8 + isort + black 일부 기능 통합. 자경단 1 도구로 3 도구 대체.

### 6-3. `mypy .` — Type Checker의 안전

```bash
$ mypy .
file.py:5: error: Incompatible types in assignment (expression has type "int", variable has type "str")
file.py:10: error: Argument 1 to "greet" has incompatible type "int"; expected "str"
Found 2 errors.
```

**type hint** + mypy의 정적 검사. 자경단 표준.

```python
# type hint 예
def greet(name: str) -> str:
    return f"안녕 {name}"

def add_cat(cats: list[dict], name: str) -> None:
    cats.append({"name": name})
```

**자경단 표준 설정** (`pyproject.toml`):
```toml
[tool.mypy]
python_version = "3.12"
strict = false                   # 1년 후 true
warn_unused_ignores = true
```

**mypy의 가치** — 런타임 전에 type 에러 발견. 자경단 PR마다 검사.

### 6-4. 품질 3 한 줄 요약

| # | 명령어 | 매일 사용 |
|---|--------|---------|
| 15 | `black .` | 매일 commit 전 |
| 16 | `ruff check .` | 매일 commit 전 |
| 17 | `mypy .` | 매일 commit 전 또는 매주 |

**자경단 의식** — `black . && ruff check . --fix && mypy . && pytest` 한 줄이 자경단 매 commit.

---

## 7. 무리 5: 테스트 1개 (Ch022 깊이)

### 7-1. `pytest` — 자경단 매일 의식

```bash
$ pytest
======== test session starts ========
platform darwin -- Python 3.12.0
collected 5 items
tests/test_cats.py .....   [100%]
======== 5 passed in 0.12s ========

$ pytest -v                    # verbose
$ pytest -x                    # 첫 실패에 멈춤
$ pytest -k 'cat'              # 'cat' 매치 테스트만
$ pytest --cov=src             # 커버리지
$ pytest --pdb                 # 실패 시 debugger
```

**자경단 표준 5 옵션** — `-v`·`-x`·`-k`·`--cov`·`--pdb`. 5 옵션이 매일 90%.

**자경단 테스트 양식** (`tests/test_cats.py`):
```python
def test_cat_creation():
    cat = {"name": "까미", "age": 3}
    assert cat["name"] == "까미"

def test_cat_invalid_age():
    with pytest.raises(ValueError):
        validate_cat({"name": "까미", "age": -1})
```

자경단 모든 PR에서 `pytest` 통과 필수 (CI).

---

## 8. 매일·주간·월간 손가락 리듬

### 8-1. 매일 6 손가락 (5분 × 5명 = 25분/일)

```bash
# 09:00 — 환경 진입
python3 -V                                    # 1. 환경 검증
source .venv/bin/activate                     # 2. venv 진입

# 작업 중
python3 script.py                             # 3. 실행
python3 -i script.py                          # 4. 디버깅 (필요 시)

# 17:00 — commit 전
black . && ruff check . --fix && mypy .       # 5. 품질
pytest                                        # 6. 테스트
```

매일 6 × 30초 = 3분/사람. 5명 합 15분/일.

### 8-2. 주간 4 손가락 (월요일 + 금요일 5분씩)

```bash
# 월요일
pip list --outdated                           # 1. 갱신 가능 검토

# 금요일
pip freeze > requirements.txt                 # 2. 의존성 잠금
git diff requirements.txt                     # 3. 변경 검토
git commit -m 'chore(deps): weekly lock'      # 4. commit
```

### 8-3. 월간 2 손가락 (월말 30분)

```bash
# 월말
python3 -m venv --upgrade .venv               # 1. venv 갱신
brew upgrade python@3.12                      # 2. Python 패치 갱신
```

매일 6 + 주간 4 + 월간 2 = 12 손가락이 자경단 매일·주간·월간 Python 의식.

---

## 9. 자경단 13줄 흐름 (Python 버전)

본인이 자경단 cat-card API 한 PR을 만드는 13줄. 18 도구 중 9개 사용.

```bash
# 1. main 최신 (Ch005 회수)
git switch main && git pull --rebase

# 2. 새 branch
git switch -c feat/cat-api

# 3. venv 진입
source .venv/bin/activate                     # ✦ activate

# 4. 의존성 (필요 시)
pip install -r requirements.txt               # ✦ pip install -r

# 5. 코드 작성 (VS Code)
# ...

# 6. 디버깅
python3 -i tests/scratch.py                   # ✦ python3 -i

# 7. 품질 검사
black . && ruff check . --fix && mypy .       # ✦ black + ruff + mypy

# 8. 테스트
pytest -v                                     # ✦ pytest

# 9. commit + push
git add . && git commit -m 'feat(cat-api): ...'
git push -u origin HEAD

# 10. PR (gh CLI)
gh pr create --draft

# 11. CI watch
gh run watch                                  # ✦ Ch005 회수

# 12. 머지 자동 예약
gh pr merge --squash --auto

# 13. main 돌아가기
git switch main && git pull --rebase
```

13줄로 9 도구 사용. 본 H의 18 도구 중 매일 9개. 나머지 9개는 가끔.

---

## 10. 자경단 5명 매일 사용표

| 누구 | 매일 사용 도구 (Top 5) |
|------|--------------------|
| **본인** (메인테이너) | `python3 -V`·`pytest`·`mypy`·`ruff`·`gh pr` |
| **까미** (백엔드) | `uvicorn`·`pytest`·`alembic`·`pip`·`python3 -m` |
| **노랭이** (프론트 도구) | `python3 -m http.server`·`black` |
| **미니** (인프라) | `boto3 script`·`terraform-cdk`·`awscli` |
| **깜장이** (QA) | `pytest`·`playwright`·`visual-diff` |

5명 × 5 도구 = 25 매일 사용. 본 H 18 도구가 자경단 매일 80%.

---

## 11. 5 사고 + 처방

### 11-1. 사고 1: pip install이 시스템 Python 오염

**증상**: venv 없이 `pip install requests` → 시스템 Python에 설치 → 다른 프로젝트와 충돌.

**처방**:
1. 매 프로젝트 venv 표준
2. `python3 -m venv .venv && source .venv/bin/activate` 자동화 (`alias venv-init='python3 -m venv .venv && source .venv/bin/activate'`)
3. macOS 시스템 Python 보호 — Python 3.11+의 PEP 668 (`externally-managed-environment` 에러)

### 11-2. 사고 2: requirements.txt 버전 잠금 안 함

**증상**: `requirements.txt`에 `requests` (버전 없이). 매번 다른 버전 → CI 가끔 깨짐.

**처방**:
1. `==` 정확한 버전 표준
2. `pip freeze` 후 lockfile 검토
3. 1년 후 `pip-compile` (pip-tools) 또는 `uv lock`

### 11-3. 사고 3: black이 too long line 안 잡음

**증상**: `black`이 100자 줄을 처리 못 함 (string·comment).

**처방**:
1. `# noqa: E501` 주석으로 무시 (가끔)
2. string은 multiline 양식 (`"..." f"..."`)
3. ruff의 E501이 black 못 잡는 거 잡음

### 11-4. 사고 4: pytest의 conftest.py 충돌

**증상**: 두 디렉토리의 `conftest.py`가 같은 fixture 이름 → 충돌.

**처방**:
1. fixture 이름 명확히 (`cat_fixture` vs `cat_data`)
2. `conftest.py`는 부모 → 자식 자동 상속
3. `pytest --collect-only`로 fixture 트리 검사

### 11-5. 사고 5: mypy의 false positive

**증상**: type hint 정확한데 mypy가 에러.

**처방**:
1. `# type: ignore` 주석 (마지막 수단)
2. `# type: ignore[error-code]`로 특정 에러만
3. type stub 갱신 — `pip install -U types-requests`
4. 1년 후 mypy strict 모드 검토

---

## 12. 모던 도구 5종 비교

| 도구 | 출시 | 특징 | 자경단 |
|------|------|------|------|
| **uv** (Astral) | 2024 | Rust 작성, pip + venv 통합, 100배 빠름 | 1년 후 표준 |
| **poetry** | 2018 | pyproject.toml + lockfile + publish | 옵션 |
| **pdm** | 2020 | PEP 582 (pkgs 디렉토리) | 거의 안 씀 |
| **hatch** | 2017 (재출시 2022) | PEP 517 빌드 + env | 거의 안 씀 |
| **rye** (Astral) | 2023 | Rust, all-in-one | 1년 후 검토 |

**자경단 표준 = pip + venv** (단순). 1년 후 uv 마이그레이션 권장 (Astral의 다음 표준 도구).

**uv 첫 사용**:
```bash
$ brew install uv
$ uv venv                         # venv 생성 (밀리초)
$ uv pip install requests         # pip 100배 빠름
$ uv pip install -r req.txt       # 일괄
```

---

## 13. AI 시대의 18 도구

Claude Code·Cursor·Copilot이 어떻게 본 H의 18 도구를 사용하는가.

### 13-1. Claude Code의 Bash 도구

Claude Code가 본 H의 모든 도구를 직접 실행:
```bash
# 본인의 자경단에 Claude Code가
$ python3 -m pytest tests/cat_test.py
$ pip install fastapi
$ black src/
```

본 H 학습이 Claude의 추천을 검증·이해할 수 있게 함. **AI + 본인 = 시너지**.

### 13-2. Cursor의 Python 자동완성

Cursor가 type hint·docstring을 보고 코드 자동 작성. 본 H의 도구 (mypy·ruff)가 Cursor의 추천 검증.

### 13-3. GitHub Copilot의 Python

Copilot이 함수 시그니처 + docstring을 보고 코드 추천. 본 H의 ruff·mypy로 검증.

### 13-4. AI 시대의 80/20 비율

- 본인 80% 코딩 (본 H 18 도구 매일)
- AI 20% 보조 (제안·완성·검증)

본 H 학습이 80%의 토대. AI는 20% 가속.

---

## 14. 흔한 오해 5가지

**오해 1: "pip만 있으면 돼."** — venv 없으면 시스템 오염. PEP 668 (Python 3.11+)부터 시스템에 직접 install 거부 (macOS·Linux).

**오해 2: "venv vs virtualenv?"** — venv가 표준 (Python 3.3+). virtualenv는 옛 외부 도구 (Python 2 호환 시).

**오해 3: "black이 너무 까칠."** — 일관성 + 빠름. 1주일 후 본인의 친구.

**오해 4: "ruff가 새거라 불안."** — 2022년 출시, 2년 안정. flake8 100배 빠름. PSF (Python Software Foundation) 공인.

**오해 5: "mypy strict가 첫부터."** — 1년 후. 처음은 `strict = false`로 시작, 점진적 활성.

---

## 15. FAQ 7가지

**Q1. pip 외 다른 패키지 매니저?**
A. uv·poetry·pdm·hatch 4종. 자경단 — pip + venv 단순. 1년 후 uv.

**Q2. venv 안 쓰면?**
A. 시스템 Python 오염. PEP 668로 막아 둠 (Python 3.11+). 무조건 venv.

**Q3. black + ruff 같이 쓸 수 있나?**
A. 네. black 포맷, ruff lint. 둘이 다른 일. 자경단 표준.

**Q4. mypy strict 모드는 언제?**
A. 1년 후. 처음 1년은 점진적. type hint 익숙해진 후 strict.

**Q5. pytest의 5 옵션?**
A. `-v` verbose · `-x` 첫 실패 멈춤 · `-k pattern` 필터 · `--cov` 커버리지 · `--pdb` debugger.

**Q6. python -m vs python 직접?**
A. `-m`이 안전 (어느 Python의 모듈인지 명시). 자경단 표준 `python3 -m`.

**Q7. uv가 pip 대체할까?**
A. 1년 후 검토. uv가 빠르지만 pip 호환 + 안정성. 자경단 1년 후 마이그레이션 권장.

---

## 16. 추신

추신 1. 18 도구가 자경단 매일 80%. 6 무리(인터프리터 6·패키지 5·가상환경 3·품질 3·테스트 1).

추신 2. 매일 6 + 주간 4 + 월간 2 = 12 손가락 한 달.

추신 3. 자경단 13줄 흐름이 18 도구 중 9개 사용. 90% PR이 같은 9 도구.

추신 4. `python3 -m`이 자경단 매일 가장 강력한 손가락. 모든 모듈 CLI.

추신 5. `python3 -i script.py`가 디버깅 친구. 변수 검사 가능.

추신 6. `pip install -e .`이 자기 패키지 개발. 코드 변경 즉시 반영.

추신 7. `requirements.txt`의 `==` 정확한 버전이 자경단 표준. CI 안정.

추신 8. `pip freeze`이 의존성의 의존성도 출력. 직접 install 구분 어려움 → pip-tools.

추신 9. venv는 Python 3.3+ 표준. virtualenv는 옛 외부.

추신 10. `.venv` 이름이 자경단 표준. 점 시작 (숨은). .gitignore 필수.

추신 11. `source .venv/bin/activate`가 자경단 매 작업 시작 의식. 셸별 다른 양식.

추신 12. `deactivate` 한 단어로 나감. 셸 종료 시 자동.

추신 13. black의 "no configuration"이 5명 합의 비용 0. 자경단 표준.

추신 14. ruff가 flake8 + isort + black 일부 통합. Rust 100배 빠름.

추신 15. mypy의 type hint가 자경단 1년 후 strict. 처음은 점진적.

추신 16. pytest의 5 옵션 (-v·-x·-k·--cov·--pdb)이 자경단 매일.

추신 17. 자경단 매일 의식 — `black . && ruff check . --fix && mypy . && pytest` 한 줄. commit 전.

추신 18. 5 사고 면역 — pip 시스템 오염·버전 잠금·black 못 잡음·conftest 충돌·mypy false positive. 자경단 1년 면역.

추신 19. AI 시대의 80/20 — 본인 80% (본 H 학습) + AI 20% (가속). 본 H가 80%의 토대.

추신 20. uv (2024 Astral)가 1년 후 자경단 표준 후보. pip 100배.

추신 21. 자경단 5명 매일 25 도구 사용 (각자 5). 5명 합 매일 25.

추신 22. 본 H의 18 도구가 자경단 평생 Python 손가락의 80%. 나머지 20%는 5년 누적.

추신 23. 다음 H5는 환율 계산기 데모 — 본 H의 도구가 진짜 코드에서 살아 움직여요. 자경단 첫 진짜 Python 스크립트. 🐾

추신 24. 본 H를 끝낸 본인이 자경단 5명에게 본 H 한 페이지 PDF 공유. 5명 같은 18 도구 직관.

추신 25. 본 H의 자경단 13줄 흐름을 본인이 직접 따라치면 9 도구가 손가락에 박힘. 1주일.

추신 26. 본 H의 모던 도구 5종을 1년에 한 번씩 검토. uv가 가장 유망.

추신 27. AI 시대의 본 H — Claude·Cursor·Copilot이 본 H의 18 도구를 직접 실행. 본인이 학습 안 하면 AI 추천 검증 불가.

추신 28. 본 H의 5 사고 면역 표를 자경단 wiki 또는 README에 박기. 새 멤버 1주일 면역.

추신 29. 본 H의 면접 5질문 — `python3 -m vs python`·`venv vs virtualenv`·`black vs ruff`·`mypy strict`·`pytest 옵션`. 답 1분이면 시니어.

추신 30. **본 H 끝** ✅ — Python 18 도구 카탈로그 학습 완료. 본인의 첫 `pytest`를 오늘. 다음 H5에서 환율 계산기 — 18 도구가 진짜 코드에서 살아 움직여요.

추신 31. 자경단 새 멤버 첫 주의 18 도구 학습 순서 — 1일차 `python3 -V`·`-c`·REPL → 2일차 venv·activate → 3일차 pip install·-r → 4일차 black·ruff → 5일차 mypy → 주말 pytest. 1주일이면 18 도구 손가락 박힘.

추신 32. `python3 -m`의 진짜 가치 — 다중 Python 환경에서 어느 Python의 모듈인지 명시. `pip` 단독은 `which pip`이 첫 발견된 거 사용 (위험). `python3 -m pip`이 명시한 `python3`의 pip (안전).

추신 33. `pip install -e .`의 editable mode — 본인 패키지를 venv에 link. 코드 수정 즉시 반영. 자경단 자기 라이브러리 개발 시. `pyproject.toml`에 `[project]` 섹션 필요.

추신 34. requirements.txt의 잠금 양식 — `==` 정확한 버전이 자경단 prod 표준. dev는 `>=` 범위 가끔. 1년 후 `pip-compile`로 lockfile 분리 (requirements.in → requirements.txt 자동 생성).

추신 35. **본 H 마지막** ✅ — Python 18 도구 + 6 무리 + 12 손가락 + 13줄 흐름 + 5 사고 면역 + AI 시대 80/20 = 자경단 평생 Python 사전이에요. 본인의 첫 `pytest -v`를 오늘 노트북에서. 🐾🐾🐾
