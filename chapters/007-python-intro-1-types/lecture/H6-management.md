# Ch007 · H6 — Python 코드 품질 운영 — PEP 8 + black + ruff + mypy + pytest + pre-commit

> 고양이 자경단 · Ch 007 · 6교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. PEP 8 — Python 코드 스타일의 공식 표준
3. black — "no configuration"의 자동 포매터
4. ruff — Rust로 100배 빠른 linter
5. docstring — 함수 문서의 세 양식
6. type hints — 여섯 패턴과 mypy strict
7. pytest — 본인의 첫 테스트 다섯 줄
8. pre-commit hook — 매번 자동 검사
9. CI 통합 — GitHub Actions와 자경단 표준
10. 다섯 가지 코드 스타일 함정과 처방
11. 자경단 매일 코드 품질 의식
12. 흔한 오해 다섯 가지
13. 자주 받는 질문 다섯 가지
14. 마무리 — 다음 H7에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 도구 설치
pip install black ruff mypy pytest pre-commit

# 검사
black .
ruff check .
mypy --strict .
pytest -v

# pre-commit
pre-commit install
pre-commit run --all-files

# 한 줄 자경단 표준 검증
black . && ruff check . && mypy --strict . && pytest
```

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 이제 여섯 번째 시간이에요. 본 챕터의 마지막 큰 시간이에요. 잘 따라오시고 계세요.

지난 H5를 한 줄로 회수할게요. 본인은 자경단 환율 계산기 50줄을 30분 안에 짜셨어요. RATES dict, convert, format_result, cat_budget_demo, main. 본인의 첫 진짜 Python 스크립트가 동작했어요.

이번 H6는 그 50줄이 자경단 다섯 명 평생 코드 품질 표준이 되는 운영 시간이에요. PEP 8 스타일 가이드, black 포매터, ruff linter, mypy type checker, pytest 테스트, pre-commit hook. 여섯 도구가 본인의 매일 코드 의식이 돼요.

오늘의 약속은 한 가지예요. **본인의 환율 계산기 50줄이 한 시간 끝에 GitHub에 자경단 표준 코드로 올라갑니다**. 다섯 명이 같이 봐도 부끄럽지 않은 코드. 5년 후에도 본인이 다시 봐도 깔끔한 코드.

자, 가요.

---

## 2. PEP 8 — Python 코드 스타일의 공식 표준

PEP 8은 2001년에 Guido van Rossum이 직접 작성한 Python 코드 스타일의 공식 표준이에요. 모든 자경단의 첫 합의예요. 외울 필요 없어요. black이 자동으로 다 해 주거든요.

PEP 8의 핵심 규칙 일곱 가지만 짚어 갈게요.

**1. 들여쓰기는 4 공백**. 탭은 안 써요.

**2. 줄 길이는 79자 (또는 black의 88자)**. 너무 길면 줄바꿈.

**3. 함수와 클래스 사이는 빈 줄 두 개**.

**4. import는 파일 위에 모음**. 표준 라이브러리, 외부 패키지, 본인 모듈 순서.

**5. 변수와 함수 이름은 snake_case**. `cat_count`, `convert_currency`. 클래스는 CamelCase. `CatProfile`.

**6. 상수는 UPPER_SNAKE_CASE**. `MAX_CATS = 5`, `RATES = {...}`.

**7. 한 줄에 한 명령**. 세미콜론으로 여러 줄 쓰지 말기.

일곱 규칙. 본인이 외우려 마세요. black이 다 해 줘요. 본인은 코드 짜고, 저장하면 black이 자동으로 PEP 8로 변환. 자경단 표준이에요.

PEP 8의 철학 한 줄. **"Code is read more often than it is written"**. 코드는 짜는 시간보다 읽는 시간이 길어요. 그래서 가독성이 우선. 자경단의 모든 합의가 이 한 줄에서 나와요.

---

## 3. black — "no configuration"의 자동 포매터

black은 Python 자동 포매터예요. "uncompromising code formatter"라는 별명. 설정이 거의 없어요. 본인 코드를 받아서 자경단 표준으로 자동 변환.

```bash
pip install black
black exchange.py        # 한 파일
black .                  # 폴더 전체
black --check .          # 변경 안 하고 검사만
```

black의 철학은 "no configuration". 옵션이 거의 없어요. 그래서 자경단 다섯 명이 다 같은 스타일로 짜요. 합의 비용 0.

black이 하는 일. 들여쓰기 정리, 따옴표 통일 (큰따옴표 표준), 줄바꿈 정리, 공백 정리. 본인이 짠 못생긴 코드를 깔끔하게 다듬어 줘요.

> ▶ **같이 쳐보기** — 본인 코드를 black으로 정리
>
> ```bash
> black exchange.py
> ```

엔터 누르면 한 줄 떠요. `reformatted exchange.py`. 본인 코드가 자경단 표준으로 변환됐어요. 변경 사항을 git diff로 한 번 봐 보세요.

자경단 표준 — 모든 commit 전에 black 한 번. VS Code의 자동 저장 시 black 실행 설정으로 평생 자동.

---

## 4. ruff — Rust로 100배 빠른 linter

ruff는 Rust로 짠 Python linter + formatter. 옛날 flake8 + isort + black 일부를 한 도구로 통합. 100배 빠르고 더 강력해요.

```bash
pip install ruff
ruff check .             # linter
ruff check . --fix       # 자동 수정
ruff format .            # formatter (black 호환)
```

ruff가 검사하는 700가지 룰 중 자경단 표준은 약 50개. pyproject.toml에 다음을 적어요.

```toml
[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "C4"]
ignore = []
```

각 코드의 의미. E=pycodestyle errors, F=pyflakes, W=pycodestyle warnings, I=isort, N=naming, UP=pyupgrade, B=bugbear, C4=comprehensions. 자경단 매일 검사.

ruff가 자주 잡는 버그 다섯 가지.

**1. 사용 안 하는 import** (F401). 파일 위에 import만 있고 안 쓰는 것.

**2. 사용 안 하는 변수** (F841). 정의만 하고 안 쓰는 변수.

**3. 줄 너무 김** (E501). 88자 넘는 줄.

**4. 비어 있는 except** (B901). except: 그냥 pass는 위험.

**5. mutable default 인자** (B006). `def f(x=[])` 같은 함정.

ruff가 다 잡아 줘요. 본인은 코드 짜고, ruff check로 한 번. 통과하면 자경단 표준.

---

## 5. docstring — 함수 문서의 세 양식

docstring은 함수의 문서화 문자열. 함수 첫 줄에 `"""..."""`. Python의 표준이에요.

세 가지 양식이 있어요. Google, NumPy, reST. 자경단 표준은 Google.

**Google 양식**

```python
def convert(amount: float, from_curr: str, to_curr: str) -> float:
    """Convert amount from one currency to another.
    
    Args:
        amount: 환산할 금액.
        from_curr: 출발 통화 코드 (예: "USD").
        to_curr: 도착 통화 코드 (예: "KRW").
    
    Returns:
        환산된 금액.
    
    Raises:
        KeyError: 통화 코드가 RATES에 없을 때.
    
    Examples:
        >>> convert(50.0, "USD", "KRW")
        65000.0
    """
    krw = amount * RATES[from_curr]
    return krw / RATES[to_curr]
```

다섯 부분 — 한 줄 요약, Args, Returns, Raises, Examples. Google 양식이 가장 가독성 좋아요. 자경단 표준이에요.

docstring을 적으면 좋은 점 세 가지. 첫째, `help(convert)`로 본인이 다시 볼 수 있어요. 둘째, IDE가 자동완성으로 보여줘요. 셋째, Sphinx 같은 도구로 자동 문서 생성.

자경단 표준 — 모든 public 함수에 docstring. private (`_function`)은 한 줄로 충분.

---

## 6. type hints — 여섯 패턴과 mypy strict

type hints는 Python 3.5+의 표준이에요. 함수의 인자와 반환값에 type을 명시. mypy가 검증.

기본 여섯 패턴.

**1. 기본 자료형**

```python
def add(a: int, b: int) -> int:
    return a + b
```

**2. Optional (None 가능)**

```python
def find_cat(name: str) -> str | None:
    cats = ["까미", "노랭이"]
    if name in cats:
        return name
    return None
```

`str | None`은 Python 3.10+ 문법. 옛 버전은 `Optional[str]`.

**3. List와 dict**

```python
def process(items: list[str]) -> dict[str, int]:
    return {item: len(item) for item in items}
```

**4. Callable (함수 타입)**

```python
from typing import Callable

def apply(f: Callable[[int], int], x: int) -> int:
    return f(x)
```

**5. Generic (TypeVar)**

```python
from typing import TypeVar

T = TypeVar("T")

def first(items: list[T]) -> T:
    return items[0]
```

**6. Literal과 Union**

```python
from typing import Literal

def log(level: Literal["INFO", "WARN", "ERROR"], msg: str) -> None:
    print(f"[{level}] {msg}")
```

여섯 패턴이 자경단의 매일 type hints. 외우려 마세요. 매일 짜면 박혀요.

mypy --strict 옵션의 다섯 단계.

```bash
mypy file.py                    # 기본
mypy --check-untyped-defs file.py  # 미명시 함수도 검사
mypy --strict-optional file.py  # None 명시 강제
mypy --strict file.py           # 모든 strict 옵션
```

자경단 표준 — `mypy --strict`. 모든 함수에 type hints 강제. 첫 1주일은 빡세지만 한 달 후엔 본인 코드 품질이 50% 향상돼요.

---

## 7. pytest — 본인의 첫 테스트 다섯 줄

pytest는 Python의 표준 테스트 framework. 본인의 환율 계산기에 테스트를 짜요.

```python
# test_exchange.py
from exchange import convert, format_result


def test_convert_usd_to_krw():
    assert convert(50.0, "USD", "KRW") == 65000.0


def test_convert_round_trip():
    """USD → KRW → USD가 같은 값."""
    krw = convert(50.0, "USD", "KRW")
    usd = convert(krw, "KRW", "USD")
    assert usd == 50.0


def test_format_result():
    assert format_result(65000.0, "KRW") == "65,000.00 KRW"


def test_unknown_currency():
    import pytest
    with pytest.raises(KeyError):
        convert(50.0, "USD", "XXX")


def test_zero_amount():
    assert convert(0, "USD", "KRW") == 0
```

다섯 테스트. 함수마다 한 케이스 + 에러 케이스. pytest의 기본 패턴이에요.

```bash
pytest -v
```

진짜 출력.

```
test_exchange.py::test_convert_usd_to_krw PASSED
test_exchange.py::test_convert_round_trip PASSED
test_exchange.py::test_format_result PASSED
test_exchange.py::test_unknown_currency PASSED
test_exchange.py::test_zero_amount PASSED

5 passed in 0.05s
```

5초에 다섯 테스트가 다 통과. 본인의 첫 pytest 케이스가 작동했어요. 박수.

자경단 표준 — 모든 함수에 최소 1개 테스트. coverage 80% 이상. CI에서 자동 실행.

pytest의 강력 기능 다섯 가지 짧게.

```python
@pytest.fixture
def sample_rates():
    return {"USD": 1300.0}

@pytest.mark.parametrize("amt,expected", [(1, 1300), (10, 13000)])
def test_multiply(amt, expected):
    assert amt * 1300 == expected
```

fixture (재사용 setup), parametrize (여러 값 테스트), mark (분류), conftest.py (공유 fixture), pytest --cov (coverage 측정). 다섯이 본인의 5년 pytest 도구.

---

## 8. pre-commit hook — 매번 자동 검사

본인이 git commit 할 때마다 자동으로 black, ruff, mypy, pytest를 돌리는 도구가 pre-commit이에요.

```bash
pip install pre-commit
```

`.pre-commit-config.yaml` 파일을 만들어요.

```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 24.0.0
    hooks:
      - id: black

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.0
    hooks:
      - id: ruff
        args: [--fix]

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        args: [--strict]
```

설치.

```bash
pre-commit install
```

이제 git commit 할 때마다 자동으로 black + ruff + mypy 돌아요. 통과 못 하면 commit 안 됨. 사고 면역.

> ▶ **같이 쳐보기** — pre-commit 첫 실행
>
> ```bash
> pre-commit run --all-files
> ```

전체 파일 검사. 첫 실행은 5분 정도. 그 다음 commit은 5초.

자경단 표준 — 모든 Python 프로젝트에 pre-commit. 다섯 명이 다 통과한 코드만 main 진입.

---

## 9. CI 통합 — GitHub Actions와 자경단 표준

pre-commit을 CI에서도 돌려요. GitHub Actions로.

`.github/workflows/python.yml`.

```yaml
name: Python CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install -r requirements.txt
      - run: pip install black ruff mypy pytest
      - run: black --check .
      - run: ruff check .
      - run: mypy --strict .
      - run: pytest -v
```

PR 만들면 자동으로 4단계 검사. 한 단계라도 실패하면 PR 머지 못 함. 자경단의 매일 안전벨트.

`local pre-commit + CI = 두 겹 안전`. local에서 빠른 검사, CI에서 최종 검증. 자경단 표준이에요.

---

## 10. 다섯 가지 코드 스타일 함정과 처방

**함정 1: 들여쓰기 혼합**

```python
def f():
    x = 1
	y = 2    # 탭 (보이지 않음)
```

처방. VS Code 설정에서 "Insert Spaces" 강제. tab을 4 spaces로 자동 변환.

**함정 2: 줄 너무 김**

```python
result = some_long_function_name(argument_one, argument_two, argument_three)
```

처방. black이 자동 줄바꿈.

```python
result = some_long_function_name(
    argument_one,
    argument_two,
    argument_three,
)
```

**함정 3: import 순서**

```python
import os
from .my_module import f
import sys
```

처방. ruff isort가 자동 정리.

```python
import os
import sys

from .my_module import f
```

**함정 4: mutable default**

```python
def add_cat(cats=[]):
    cats.append("새")
    return cats
```

처방. None default 후 안에서 [] 만들기.

```python
def add_cat(cats=None):
    cats = cats or []
    cats.append("새")
    return cats
```

**함정 5: == None**

```python
if result == None:
    ...
```

처방. is None.

```python
if result is None:
    ...
```

다섯 함정과 처방을 한 페이지로. 자경단 1년 면역.

---

## 11. 자경단 매일 코드 품질 의식

자경단 다섯 명이 매일 commit 전에 치는 한 줄.

```bash
black . && ruff check . --fix && mypy --strict . && pytest -v
```

네 도구를 한 줄로 묶어서. 통과하면 commit 가능. pre-commit이 자동으로 해 주지만 명시적으로도 한 번.

자경단 미니의 dotfile 별명을 알려드릴게요.

```bash
alias check="black . && ruff check . --fix && mypy --strict . && pytest -v"
```

`check` 한 단어로 본인의 매일 검사. 5초 의식.

자경단 표준 흐름. 코드 짜기 → black 자동 (저장 시) → ruff check → mypy → pytest → git commit (pre-commit 자동) → git push → CI 자동. 일곱 단계 다 통과하면 자경단 표준 코드.

---

## 12. 흔한 오해 다섯 가지

**오해 1: 코드 품질 도구가 너무 많다.**

매일 4개. 6주 쓰면 자동.

**오해 2: black은 강제적이다.**

자경단의 합의가 자유보다 강력. 자유 포기 = 합의 비용 0.

**오해 3: type hints는 옵션이다.**

자경단 표준은 strict. 큰 코드에서 type 사고 면역.

**오해 4: pytest는 큰 프로젝트만.**

50줄 환율 계산기도 5개 테스트. 작은 코드에 작은 테스트.

**오해 5: pre-commit은 부담스럽다.**

처음 5분 셋업 후 평생 자동. 사고 비용 절감 100배.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. black과 ruff format 충돌하나요?**

거의 호환. ruff format이 black 호환 모드. 자경단은 둘 중 하나.

**Q2. mypy --strict가 너무 빡세요.**

처음엔 그래요. 6주 후엔 본인 코드 50% 향상.

**Q3. pytest fixture 어떻게 짜요?**

```python
@pytest.fixture
def sample_data():
    return {"name": "까미"}

def test_use_data(sample_data):
    assert sample_data["name"] == "까미"
```

**Q4. pre-commit이 commit을 막아요.**

좋은 거예요. 사고 막은 거니까. 통과될 때까지 고치세요.

**Q5. CI 시간이 너무 길어요.**

self-hosted runner 또는 cache 사용. 자경단은 GitHub Actions cache로 5분 → 1분.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — Python 운영 학습 편

Python 코드 운영하며 자주 빠지는 함정 다섯.

첫 번째 함정, PEP 8 무시. 안심하세요. **black 한 줄로 자동.** 본인이 외울 필요 없음.

두 번째 함정, type hint 점진 도입 안 함. 안심하세요. **공개 함수부터.** 한 함수씩 늘리기.

세 번째 함정, docstring 안 씀. 안심하세요. **모든 공개 함수 한 줄 docstring.** 6개월 후 본인 살림.

네 번째 함정, pre-commit 안 씀. 안심하세요. **첫날 pre-commit 설치.** black + ruff + mypy 자동.

다섯 번째 함정, 가장 큰 함정. **CI 설정 미루기.** 본인 첫 PR에 GitHub Actions 없음. 안심하세요. **첫날 .github/workflows/test.yml 한 파일.** 두 해 후 모든 PR이 자동 검증.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H7에서 만나요

자, 여섯 번째 시간이 끝났어요. 60분 동안 본인은 Python 코드 품질의 모든 무기를 만나셨어요. 정리하면 이래요.

PEP 8 일곱 규칙. black 자동 포매터. ruff 100배 빠른 linter. docstring Google 양식. type hints 여섯 패턴 + mypy strict. pytest 다섯 케이스. pre-commit 자동 검사. GitHub Actions CI. 자경단 매일 한 줄 의식 — `black . && ruff check . && mypy --strict . && pytest`.

박수 한 번 칠게요. 정말 큰 박수예요. 본인의 환율 계산기 50줄이 자경단 표준 코드로 변했어요. 다섯 명이 같이 봐도 부끄럽지 않은 코드. GitHub에 올라가도 자랑스러운 코드.

다음 H7은 깊이의 시간이에요. CPython 내부, GIL, 가비지 컬렉터, 모듈 로딩, bytecode. 0.1초 6단계가 0.001초 단위로 풀려요. 한 시간 후 만나요.

그 전에 한 가지 부탁. 본인의 exchange.py에 다음 두 줄을 추가하고 검사 한 번 돌려 보세요.

```bash
black exchange.py
ruff check exchange.py --fix
mypy --strict exchange.py
pytest test_exchange.py -v
```

10초예요. 본인의 H6 졸업장이에요. 본인의 첫 자경단 표준 Python 코드가 GitHub 준비 완료.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - PEP 8 vs PEP 257 vs PEP 484: 8=스타일, 257=docstring 양식, 484=type hints. 자경단은 셋 다.
> - black의 88자: PEP 8의 79자보다 살짝 늘림. 가독성 vs 라인 줄임의 균형.
> - ruff vs flake8: ruff가 100배 빠르고 더 통합. 자경단은 ruff.
> - docstring 양식 비교: Google (한 줄 요약 + 섹션), NumPy (섹션 강조), reST (Sphinx 표준). Google이 가장 읽기 쉬움.
> - type hints 런타임: 기본은 검사 안 함. Pydantic이나 typeguard로 가능.
> - mypy 옵션 다섯: --strict, --check-untyped-defs, --disallow-untyped-defs, --strict-optional, --no-implicit-reexport. strict가 다 포함.
> - pytest -k 패턴: 테스트 이름 매치. `pytest -k "convert"`로 convert 포함 테스트만.
> - pre-commit 체인: hooks 순서 중요. black → ruff → mypy 순. ruff가 black 충돌 방지.
> - CI cache: actions/cache로 venv 또는 pip cache 캐싱. 5분 → 1분.
> - 다음 H7 키워드: CPython · GIL · 가비지 컬렉터 · bytecode · sys.path · 모듈 로딩.
