# Ch007 · H6 — Python 입문 1: 운영 — PEP 8 + black + ruff + docstring + type hint 깊이

> **이 H에서 얻을 것**
> - PEP 8 7 규칙 — Python의 코드 스타일 표준
> - black formatter 깊이 — "no configuration"의 가치
> - ruff linter — flake8 + isort + black 일부 통합 100배
> - docstring 3 양식 — Google·NumPy·reST
> - type hint 6 패턴 + mypy strict 5단계
> - pre-commit hook + CI integration — 자경단 매일 운영
> - 5 코드 스타일 함정 + 처방

---

## 회수: H5의 50줄 환율 계산기에서 본 H의 운영으로

지난 H5에서 본인은 자경단 환율 계산기 50줄을 30분에 작성했어요. 그건 **첫 코드**.

이번 H6는 그 50줄이 **자경단 5명 평생 코드 품질 표준**이 되는 운영이에요. PEP 8·black·ruff·docstring·type hint·pre-commit·CI 7 도구가 본인의 매일 코드 의식.

지난 Ch005 H6은 git 운영, Ch006 H6는 셸 스크립트 운영. 본 H는 Python 코드 품질 운영. 셋이 합쳐 자경단 매일 운영의 3 stack.

---

## 1. PEP 8 — Python의 코드 스타일 표준

**PEP 8** (Python Enhancement Proposal #8, 2001)은 Python 코드 스타일의 공식 표준. Guido van Rossum이 작성. 모든 자경단의 첫 합의.

### 1-1. PEP 8 7 규칙

1. **들여쓰기** — 4 공백 (탭 X)
2. **줄 길이** — 79자 (자경단 100자 표준)
3. **빈 줄** — 함수 사이 2줄, 메서드 사이 1줄
4. **import 순서** — 표준 라이브러리·외부·자경단 (3 그룹, 사이 1줄)
5. **이름 규칙** — `snake_case` (변수·함수)·`CamelCase` (클래스)·`SCREAMING_SNAKE_CASE` (상수)
6. **공백** — `=` 양옆 공백 (할당)·`,` 뒤 공백·괄호 안 공백 X
7. **주석** — `#` 한 글자 다음 공백·문장 같은 양식

### 1-2. PEP 8 자경단 표준

자경단 — PEP 8 80% 따름. 다른 20% — 줄 길이 100자 (79자 너무 짧음).

```python
# 자경단 표준 import 순서
import os                          # 1. 표준 라이브러리
import sys
from datetime import datetime

import requests                    # 2. 외부 (1줄 띄움)
from fastapi import FastAPI

from cat_vigilante.api import API  # 3. 자경단 (1줄 띄움)
from cat_vigilante.models import Cat
```

### 1-3. PEP 8의 진짜 가치 — 5명 합의 비용 0

본인이 PEP 8 학습 1주일. 까미·노랭이·미니·깜장이도 1주일. 5명 × 1주일 = 5주의 한 번 투자.

5주 후 자경단 매 PR — 양식 다툼 0. 코드 리뷰 시간 50% 단축. 1년 후 1000 PR 누적이면 500시간 절약. **PEP 8의 진짜 가치는 5명 합의 비용을 0으로 만드는 것**이에요.

본인이 1년 차에 본 — 양식 다툼 PR 한 번도 없음. 코드 리뷰는 로직만 보는 시간. 양식은 black·ruff가 자동.

### 1-4. PEP 8의 옛 양식 vs 현대 양식

```python
# 옛 양식 (PEP 8 권장 X)
def func(a,b,c):           # , 뒤 공백 X
    if a==b:               # = 양옆 공백 X
        return [ a,b,c ]   # 괄호 안 공백
    return None

# 현대 양식 (PEP 8 + black 자동)
def func(a, b, c):
    if a == b:
        return [a, b, c]
    return None
```

자경단 — 옛 양식 코드 리뷰에서 무조건 black 통과. 옛 양식 → 자동 변환.

### 1-5. PEP 8 외 추가 PEP 5선

자경단 매일 참고 PEP 5선:
- **PEP 8** — 코드 스타일
- **PEP 257** — docstring 규칙
- **PEP 484** — type hint
- **PEP 526** — 변수 type annotation
- **PEP 585** — 내장 type generic (`list[str]` 직접 사용)

5 PEP × 5분 학습 = 자경단 평생 자산.

---

## 2. black — "no configuration"의 자동 포맷터

### 2-1. black 5 가치

1. **자동 수정** — 본인이 손으로 안 함
2. **no configuration** — 5명 같은 양식
3. **빠름** — 1초/1000줄
4. **PEP 8 준수** — 표준 따름
5. **diff 줄임** — PR 작아짐

### 2-2. 자경단 표준 설정

`pyproject.toml`:
```toml
[tool.black]
line-length = 100
target-version = ['py312']
include = '\.pyi?$'
extend-exclude = '''
/(
    \.venv
  | \.git
  | build
  | dist
)/
'''
```

### 2-3. 자경단 매일 의식

```bash
$ black .                          # 전체 포맷
$ black src/                       # 특정 디렉토리
$ black --check .                  # 검사만 (CI에서 사용)
$ black --diff .                   # diff 미리보기
```

`--check`이 CI 표준 — 통과 안 하면 PR 머지 거부.

### 2-4. black의 함정

- string의 `'` → `"` 강제 변환. 한 5명 다른 양식 → black 통일.
- f-string·multiline string은 그대로 둠.
- comment·docstring은 안 바꿈.

자경단 1년 차에 한 번 — `'` vs `"` 다툼 1주일. black이 종결.

### 2-5. black의 magic trailing comma 깊이

```python
# magic trailing comma X (한 줄로 합침)
result = func(a, b, c)

# magic trailing comma O (마지막 콤마) — 줄바꿈 보존
result = func(
    a,
    b,
    c,    # ← 마지막 콤마가 신호
)
```

본인이 가독성 위해 줄바꿈 보존하고 싶을 때 — 마지막 콤마. black이 존중.

까미가 1개월 차에 발견 — "왜 가끔 black이 한 줄로 안 합치지?" 본인이 답: "마지막 콤마 봤니?" 까미: "아!"

### 2-6. black의 실제 사용 — 자경단 첫 도입

```bash
# 자경단 1일차
$ pip install black
$ black .
reformatted src/api.py
reformatted src/models.py
reformatted tests/test_api.py
All done! ✨ 🍰 ✨
3 files reformatted, 12 files left unchanged.

# git diff로 변경 확인
$ git diff --stat
src/api.py     | 23 ++++++++++-------
src/models.py  | 15 +++++++-----
tests/test_api.py | 8 ++++----
3 files changed, 28 insertions(+), 18 deletions(-)
```

자경단 첫 도입 PR — 5명 review, 30분 후 머지. 그 후 매 commit black 자동.

---

## 3. ruff — Rust로 100배 빠른 linter

### 3-1. ruff 5 가치

1. **flake8 + isort + pylint 일부 통합** — 1 도구로 3 도구 대체
2. **Rust 작성** — 100배 빠름
3. **600+ 룰셋** — 모든 PEP 8 + best practice
4. **자동 수정** — `--fix` 옵션
5. **자경단 표준** (2024+)

### 3-2. 자경단 표준 설정

`pyproject.toml`:
```toml
[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle
    "F",   # pyflakes
    "I",   # isort
    "B",   # bugbear
    "UP",  # pyupgrade
    "SIM", # simplify
    "RUF", # ruff-specific
]
ignore = ["E501"]  # black이 line length 처리

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["S101"]  # test에서 assert OK
```

### 3-3. 자경단 매일

```bash
$ ruff check .                     # 검사만
$ ruff check . --fix               # 자동 수정
$ ruff format .                    # 포맷터 (black 대체 옵션)
```

ruff format이 2024+ black 대체 옵션. 자경단 — 1년 후 black → ruff format 마이그레이션 검토.

### 3-4. ruff의 매일 5 룰셋 사용

| 룰셋 | 의미 | 자경단 효과 |
|------|------|----------|
| E (pycodestyle) | PEP 8 | 매일 |
| F (pyflakes) | 사용 안 한 import·변수 | 매일 |
| I (isort) | import 정렬 | commit 직전 |
| B (bugbear) | 버그 패턴 | 매일 |
| UP (pyupgrade) | 옛 양식 → 새 (Python 3.12) | 매주 |

5 룰셋 × 매일 = 자경단 코드 품질 80%.

### 3-5. ruff의 실제 출력 + 자동 수정

```bash
$ ruff check src/api.py
src/api.py:5:1: F401 [*] `os` imported but unused
src/api.py:12:5: B007 Loop control variable `i` not used within loop body
src/api.py:23:9: SIM108 Use ternary operator `x = 1 if cond else 2`
src/api.py:34:5: UP032 [*] Use f-string instead of `format` call
Found 4 errors.
[*] 2 fixable with `--fix` option.

$ ruff check src/api.py --fix
src/api.py:12:5: B007 Loop control variable `i` not used within loop body
src/api.py:23:9: SIM108 Use ternary operator `x = 1 if cond else 2`
Found 4 errors (2 fixed, 2 remaining).
```

`[*]` 표시 — 자동 수정 가능. F401 (unused import)·UP032 (옛 양식)이 자경단 매일 자동 수정 1순위.

### 3-6. ruff vs flake8 속도 비교

자경단 1만 줄 코드:
- flake8 — 8초
- pylint — 30초
- **ruff — 0.08초**

100배 빠름. 매 commit hook으로 100배 빠르면 매일 8분 절약. 1년 누적 50시간.

---

## 4. docstring — 함수 문서의 3 양식

### 4-1. 양식 3 비교

```python
# 1. Google 양식 (자경단 표준)
def convert(amount_krw: float, currency: str) -> float:
    """KRW를 다른 통화로 변환.
    
    Args:
        amount_krw: KRW 금액
        currency: 변환 대상 통화 코드 (USD/JPY/EUR)
    
    Returns:
        변환된 금액
    
    Raises:
        ValueError: currency가 RATES에 없을 때
    """
    ...

# 2. NumPy 양식 (데이터과학·라이브러리)
def convert(amount_krw, currency):
    """
    KRW를 다른 통화로 변환.
    
    Parameters
    ----------
    amount_krw : float
        KRW 금액
    currency : str
        변환 대상 통화 코드
    
    Returns
    -------
    float
        변환된 금액
    """
    ...

# 3. reST (Sphinx 표준)
def convert(amount_krw, currency):
    """KRW를 다른 통화로 변환.
    
    :param amount_krw: KRW 금액
    :type amount_krw: float
    :param currency: 변환 대상 통화 코드
    :type currency: str
    :returns: 변환된 금액
    :rtype: float
    :raises ValueError: currency가 RATES에 없을 때
    """
    ...
```

**자경단 표준 — Google 양식**. 가장 가독성, type hint와 짝.

### 4-2. docstring의 5 활용처

1. **`help(func)`** — REPL에서 docstring 표시
2. **VS Code Pylance** — hover 시 docstring 보여줌
3. **Sphinx** — 자동 문서 생성
4. **mkdocs-mkdocstrings** — markdown 문서 자동
5. **doctest** — docstring의 example 실행

### 4-3. 자경단 docstring 첫 줄 규칙

- **명령형 짧게** — "변환한다" (X) vs "Convert" (O) — 한국어로 "변환" (O)
- **마침표** — 첫 문장 끝
- **다음 줄 비움** — 첫 줄 + 빈 줄 + 본문

### 4-4. docstring의 실제 가치 — help() 즉시 확인

```python
>>> from cat_vigilante.api import convert
>>> help(convert)
convert(amount_krw: float, currency: str) -> float
    KRW를 다른 통화로 변환.
    
    Args:
        amount_krw: KRW 금액
        currency: 변환 대상 통화 코드 (USD/JPY/EUR)
    
    Returns:
        변환된 금액
    
    Raises:
        ValueError: currency가 RATES에 없을 때
```

본인이 1년 후 본인의 코드 — `help(func)` 한 번. 30초에 사용법 확인. **docstring이 본인의 평생 사전**.

### 4-5. doctest — docstring으로 테스트 자동

```python
def convert(amount_krw: float, currency: str) -> float:
    """KRW를 다른 통화로 변환.
    
    >>> convert(1380.50, 'USD')
    1.0
    >>> convert(9100, 'JPY')
    1000.0
    >>> convert(0, 'EUR')
    0.0
    """
    return amount_krw / RATES[currency]

# 실행
$ python -m doctest -v module.py
Trying: convert(1380.50, 'USD')
Expecting: 1.0
ok
Trying: convert(9100, 'JPY')
Expecting: 1000.0
ok
3 tests in 1 docstring. All passed.
```

자경단 — 간단 함수는 doctest. 복잡 함수는 pytest. 둘 짝.

---

## 5. type hint 6 패턴 + mypy strict 5단계

### 5-1. type hint 6 패턴

```python
# 1. 기본 type
def greet(name: str) -> str:
    return f"안녕 {name}"

# 2. Optional (None 가능)
from typing import Optional
def find_cat(name: str) -> Optional[dict]:
    return CATS.get(name)  # 없으면 None

# 3. Union (여러 type)
def parse(value: int | str) -> int:  # Python 3.10+
    return int(value)

# 4. Generic (list/dict)
def get_names(cats: list[dict]) -> list[str]:  # Python 3.9+
    return [c["name"] for c in cats]

# 5. TypedDict (dict의 type)
from typing import TypedDict
class Cat(TypedDict):
    name: str
    age: int

# 6. Literal (특정 값만)
from typing import Literal
def set_status(status: Literal["active", "inactive"]) -> None:
    ...
```

### 5-2. mypy strict 5단계

```toml
# pyproject.toml — 자경단 진화 5단계
[tool.mypy]
python_version = "3.12"

# 1단계 (1주차) — 기본
warn_unused_ignores = true

# 2단계 (1개월) — 함수 type hint 강제
disallow_untyped_defs = true

# 3단계 (3개월) — 모든 type hint 강제
disallow_any_unimported = true
disallow_any_expr = false        # 너무 엄격

# 4단계 (6개월) — 더 엄격
warn_return_any = true
no_implicit_optional = true

# 5단계 (1년) — strict
strict = true
```

자경단 — 점진적 활성. 1년 후 strict 도달.

### 5-3. mypy 에러 메시지 읽기 5 패턴

```bash
# 패턴 1: argument 타입 불일치
$ mypy src/api.py
src/api.py:23: error: Argument "currency" to "convert" has incompatible type "int"; expected "str"  [arg-type]

# 패턴 2: return 타입 불일치
src/api.py:34: error: Incompatible return value type (got "str", expected "int")  [return-value]

# 패턴 3: None 가능성 미처리
src/api.py:45: error: Item "None" of "Optional[Cat]" has no attribute "name"  [union-attr]

# 패턴 4: 사용 안 한 type ignore
src/api.py:56: error: Unused "type: ignore" comment  [unused-ignore]

# 패턴 5: 함수에 type hint 없음 (strict)
src/api.py:67: error: Function is missing a type annotation  [no-untyped-def]
```

5 패턴 면역 = mypy 에러 90% 자동 처방.

### 5-4. type hint의 ROI — 1년 후 본인의 코드

본인이 6개월 전 작성한 함수 보고 — 인자 타입을 모름. type hint 없으면 5분 디버깅. type hint 있으면 5초.

자경단 1년 후 1만 줄 코드 — type hint 50% 적용 vs 100% 적용 = 디버깅 시간 차 100시간/년. **type hint이 미래 본인에 대한 친절**이에요.

### 5-5. Generic + Protocol 깊이 (자경단 1년 차)

```python
from typing import TypeVar, Generic, Protocol

# 1. TypeVar — 임의 타입
T = TypeVar('T')

class Stack(Generic[T]):
    def __init__(self) -> None:
        self.items: list[T] = []
    
    def push(self, item: T) -> None:
        self.items.append(item)
    
    def pop(self) -> T:
        return self.items.pop()

# 사용
cat_stack: Stack[Cat] = Stack()
cat_stack.push(Cat(name='까미', age=2))

# 2. Protocol — duck typing의 타입
class Named(Protocol):
    name: str

def greet(obj: Named) -> str:
    return f"안녕 {obj.name}"

# Cat·Dog·Person 모두 name 속성이 있으면 OK
greet(Cat(name='까미', age=2))  # OK
```

자경단 1년 차 — Generic·Protocol로 재사용 컴포넌트. 라이브러리 작성의 표준.

---

## 6. pre-commit hook 자경단 표준

### 6-1. pre-commit 셋업

```bash
$ pip install pre-commit
$ cat > .pre-commit-config.yaml <<'EOF'
repos:
  - repo: https://github.com/psf/black
    rev: 24.3.0
    hooks:
      - id: black
        language_version: python3.12
  
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.3.4
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
  
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.9.0
    hooks:
      - id: mypy
        additional_dependencies: [pydantic, types-requests]

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
EOF
$ pre-commit install
```

매 commit 자동 — black + ruff + mypy + 4 기본 hook. **모든 commit 자동 품질 검사**.

### 6-2. CI integration (.github/workflows/ci.yml)

```yaml
name: CI
on: [pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - run: pip install -r requirements-dev.txt
      - run: black --check .
      - run: ruff check .
      - run: mypy .
      - run: pytest --cov
```

자경단 모든 PR 자동 검사. lint·type·test 통과 필수.

### 6-3. CI matrix — Python 3.11·3.12·3.13 세 버전 동시

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.11', '3.12', '3.13']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: pip install -r requirements-dev.txt
      - run: pytest --cov
```

자경단 — 3 버전 동시 테스트. 3.13에서 새 syntax 사용해도 3.11 호환성 자동 검사.

### 6-4. pre-commit 5초 실제 출력

```bash
$ git commit -m 'feat(api): cat 모델 추가'
black....................................Passed
ruff.....................................Passed
ruff-format..............................Passed
mypy.....................................Passed
trim trailing whitespace.................Passed
fix end of files.........................Passed
check yaml...............................Passed
check for added large files..............Passed
[main abc1234] feat(api): cat 모델 추가
 2 files changed, 25 insertions(+)
```

8 hook 5초. 자경단 매 commit 자동.

### 6-5. pre-commit 실패 시 처방

```bash
$ git commit -m 'feat: 까미 추가'
black....................................Failed
- hook id: black
- files were modified by this hook
reformatted src/api.py

# 자동 수정됨 → 다시 add → commit
$ git add src/api.py
$ git commit -m 'feat: 까미 추가'
black....................................Passed
[main def5678] feat: 까미 추가
```

black이 자동 수정 → 본인이 다시 `git add`. 까미가 1개월 차에 잘 안 외워서 — alias 만듦: `gci='git add . && git commit'`.

---

## 7. 자경단 매일 코드 품질 의식

### 7-1. 매 commit 자동 (pre-commit)

```bash
$ git commit -m 'feat(api): cat 모델 추가'
black....................................Passed
ruff.....................................Passed
mypy.....................................Passed
trailing-whitespace......................Passed
[main abc1234] feat(api): cat 모델 추가
```

매 commit 5 검사 자동. 5초.

### 7-2. PR 만들기 전 (수동)

```bash
$ black . && ruff check . --fix && mypy . && pytest -v
```

한 줄 4 검사. 자경단 매 PR 직전 의식.

### 7-3. 매주 의존성 갱신

```bash
$ pip list --outdated
$ pip install -U package
$ pre-commit autoupdate              # hook 버전 자동 갱신
```

매주 금요일 5분.

### 7-4. 매월 strict 단계 진화

`mypy.ini` 또는 `pyproject.toml`의 strict 옵션 한 칸씩 ON. 매월 한 칸.

### 7-5. 자경단 매일 의식의 시간 분포

| 시점 | 의식 | 시간 |
|------|------|------|
| 매 commit | pre-commit 5 hook | 5초 |
| 매 PR 직전 | black + ruff + mypy + pytest | 30초 |
| 매주 금요일 | pip outdated + autoupdate | 5분 |
| 매월 1일 | mypy strict 한 칸 ON | 10분 |
| 매분기 | 의존성 메이저 업그레이드 | 1시간 |

5 시점 누적 — 매월 5시간 품질 의식. 1년 60시간 = 자경단 평생 코드 품질 자산.

### 7-6. 자경단 코드 품질 KPI

자경단 1년 차 측정 KPI:
- type hint 적용률 — **95%+**
- docstring 적용률 — **80%+** (public 함수)
- test 커버리지 — **80%+**
- mypy strict 통과율 — **100%**
- ruff 0 에러 — **100%**

5 KPI 매월 측정. 80% 미달 시 자경단 회의.

---

## 8. 5 코드 스타일 함정 + 처방

### 8-1. 함정 1: black이 의도 무시

**증상**: 본인이 가독성 위해 줄 정렬했는데 black이 해체.

**처방**:
- magic trailing comma 활용 — `[\n  1,\n  2,\n]`처럼 마지막 콤마 → black이 줄바꿈 보존
- `# fmt: off` / `# fmt: on` 주석으로 일부 무시

### 8-2. 함정 2: ruff가 type hint 룰 안 잡음

**증상**: ruff는 lint·format. mypy가 type 검사. 둘이 다른 일.

**처방**: 둘 다 사용. ruff + mypy 짝.

### 8-3. 함정 3: docstring + type hint 중복

**증상**: docstring에도 type 적고 type hint도 → 중복.

**처방**:
- type hint이 표준
- docstring은 의미만 (Google 양식)
- 자동 동기화 — VS Code의 autoDocstring extension

### 8-4. 함정 4: pre-commit 우회

**증상**: `git commit --no-verify`로 hook 우회.

**처방**:
- 자경단 합의 — `--no-verify` 사용 금지 (응급용만)
- CI에서 한 번 더 검사 (pre-commit 우회해도 CI에서 잡힘)

### 8-5. 함정 5: type hint의 false positive

**증상**: 정확한 type인데 mypy 에러.

**처방**:
- `# type: ignore[error-code]` 특정 에러만
- type stub 갱신 — `pip install -U types-requests`
- mypy plugin (pydantic·django 등)

### 8-6. 함정 6 (보너스): pre-commit hook 캐시 충돌

**증상**: hook 버전 업데이트 후 갑자기 실패.

**처방**:
```bash
$ pre-commit clean              # 캐시 삭제
$ pre-commit install --install-hooks  # hook 재설치
$ pre-commit run --all-files    # 전체 재검사
```

까미가 1개월 차에 본 — `pre-commit autoupdate` 후 갑자기 실패. clean 후 해결.

### 8-7. 함정 7 (보너스): mypy + 동적 코드

**증상**: `getattr(obj, 'field')`처럼 동적 접근에서 mypy가 실패.

**처방**:
- `cast(Type, value)` — 명시적 타입 단언
- `Protocol` — 동적 duck typing의 정적 표현
- 마지막 수단 — `# type: ignore` (특정 줄만)

자경단 1년 차에 한 번. Protocol으로 90% 해결.

---

## 9. 자경단 5명 매일 코드 품질 사용표

| 누구 | 매일 사용 |
|------|---------|
| 본인 | pre-commit + PR 리뷰 |
| 까미 | black + ruff + mypy + pytest 매 commit |
| 노랭이 | prettier (JS) + black (Python 도구) |
| 미니 | terraform fmt + black (Python script) |
| 깜장이 | playwright + ruff |

5명 × 5 도구 = 25 매일 품질 의식.

### 9-1. 자경단 5명의 첫 도입 시나리오

본인이 자경단 1주차 — pre-commit·black·ruff·mypy 4 도구 한 번에 도입. 5명 합의:
- **월요일**: pyproject.toml 작성 + 5명 PR 리뷰
- **화요일**: 첫 black 적용 PR (모든 파일 reformat) — 5명 머지
- **수요일**: ruff 0 에러까지 자동 수정 PR
- **목요일**: mypy 1단계 ON — 함수 type hint 강제
- **금요일**: pre-commit install 5명

5일 누적 = 자경단 매일 운영 표준 확립. 이 5일이 1년 후 평생 자산.

### 9-2. 자경단 5명 코드 품질 비교 (1년 후)

| 멤버 | type hint % | docstring % | mypy strict |
|------|------------|------------|-------------|
| 본인 | 100% | 95% | 통과 |
| 까미 | 95% | 80% | 통과 |
| 노랭이 | 100% (TS·py) | 90% | 통과 |
| 미니 | 90% | 70% | 통과 (점진) |
| 깜장이 | 95% | 85% | 통과 |

5명 평균 96% type hint. 자경단 코드 품질의 평생 표준.

---

## 10. 흔한 오해 5가지

**오해 1: "PEP 8 다 외워야."** — black + ruff가 자동. 외울 필요 X.

**오해 2: "black + ruff format 둘 같이?"** — 같은 일 (포맷). 자경단 — black 표준, 1년 후 ruff format 마이그레이션 검토.

**오해 3: "type hint 첫부터 strict."** — 1주차 기본 → 1년 strict. 점진적.

**오해 4: "pre-commit이 느려."** — 5초/commit. 매일 100 commit이면 8분/일. 적정.

**오해 5: "docstring은 신입 일."** — 자경단 매 함수. 1년 후 본인이 쓴 docstring이 본인의 평생 사전.

**오해 6: "lint·type 검사가 코드 시간 늘림."** — 5초/commit. 디버깅 시간 100배 단축. ROI 계산 — 매일 10 commit × 5초 = 50초. 디버깅 절약 매일 30분. 36배 ROI.

**오해 7: "pre-commit이 선택사항."** — 자경단 합의 — 필수. `--no-verify` 우회 = 5명 회의. 자동 검사 안 한 코드는 자경단 코드 아님.

---

## 11. FAQ 5가지

**Q1. PEP 8 line length 79 vs 100?**
A. PEP 8 표준 79. 자경단 100. 모니터 24인치+ 시대라 100 가능.

**Q2. black vs autopep8 vs yapf?**
A. black이 자경단 표준. autopep8·yapf는 옛.

**Q3. ruff가 black 대체할까?**
A. ruff format이 2024+ 옵션. black 호환. 자경단 1년 후 검토.

**Q4. mypy strict 1년 후?**
A. 1년 차에 strict 모드 점진적. 한 번에 strict ON 하지 마세요. PR 폭발.

**Q5. pre-commit vs CI?**
A. 둘 다. pre-commit이 5초 (commit 직전). CI가 1분 (PR). 둘이 보완.

**Q6. type hint이 런타임 영향 있나요?**
A. 거의 없음. type hint은 정적 검사용이라 런타임에 무시. `pydantic`·`runtime_checkable Protocol` 등 명시적 사용만 런타임 검사.

**Q7. ruff format 안정한가요?**
A. 2024년 v0.3 이후 안정. black 호환. 자경단 1년 후 마이그레이션 검토. 현재 black 표준 유지.

**Q8. mypy vs pyright 무엇 더 좋나요?**
A. mypy — 표준·CLI 친화. pyright — VS Code Pylance 기반·빠름. 자경단 mypy 표준 + VS Code Pylance 동시.

**Q9. type hint이 너무 verbose 합니다. 줄일 방법?**
A. `from typing import TYPE_CHECKING`·type alias·Protocol 활용. Python 3.12의 PEP 695 type alias syntax (`type Alias = ...`)도 유망.

**Q10. 5명 같은 양식 강제하는 법?**
A. pre-commit + CI 두 단계. pre-commit 우회 가능하지만 CI 우회 불가. CI 통과 안 하면 머지 X.

---

## 12. 추신

추신 1. PEP 8 7 규칙이 Python의 첫 합의. 2001년 표준. 자경단 80% 따름.

추신 2. black의 "no configuration"이 5명 합의 비용 0. 자경단 표준.

추신 3. ruff가 flake8 + isort + pylint 일부 통합. Rust 100배.

추신 4. docstring 3 양식 중 Google이 자경단 표준. 가독성 + type hint 짝.

추신 5. type hint 6 패턴 + mypy strict 5단계. 1년 후 strict.

추신 6. pre-commit hook 5 (black·ruff·mypy·trailing·EOF)가 매 commit 자동.

추신 7. CI integration이 모든 PR 자동 검사. lint·type·test.

추신 8. 자경단 매 PR 직전 한 줄 — `black . && ruff check . --fix && mypy . && pytest`.

추신 9. 자경단 5명 매일 25 품질 의식. 본 H의 7 도구가 매일.

추신 10. 다음 H7는 원리/내부 — CPython VM·GIL·bytecode·PEP·메모리 관리. 본 H의 운영이 H7의 원리로. 🐾

추신 11. PEP 8의 4 공백 들여쓰기 — 1주일이면 자동. 탭 X.

추신 12. PEP 8의 79자 — 옛 터미널 기준. 자경단 100자가 현실.

추신 13. PEP 8의 import 3 그룹 — 표준·외부·자경단. ruff isort 자동.

추신 14. PEP 8의 snake_case (변수·함수) vs CamelCase (class) vs SCREAMING_SNAKE_CASE (상수). 3 양식.

추신 15. black의 magic trailing comma — `[1, 2, 3,]`의 마지막 콤마가 줄바꿈 보존 신호.

추신 16. black의 string 통일 — `'` → `"`. 자경단 5명 다툼 종결.

추신 17. ruff의 600+ 룰셋. 자경단 표준 7 룰셋 (E·F·I·B·UP·SIM·RUF).

추신 18. ruff의 `--fix` 자동 수정 — 매일 손가락. flake8엔 없는 기능.

추신 19. mypy의 strict 5단계 진화 — 1주·1개월·3개월·6개월·1년. 점진적.

추신 20. pre-commit autoupdate — hook 버전 자동 갱신. 매주 금요일.

추신 21. CI의 black --check이 통과 필수. PR 머지 거부.

추신 22. 자경단 5명 같은 black + ruff + mypy = 5명 같은 코드 양식. 합의 비용 0.

추신 23. docstring의 5 활용처 — help·VS Code·Sphinx·mkdocs·doctest. 매일 활용.

추신 24. type hint의 6 패턴이 자경단 매일. Optional·Union·Generic·TypedDict·Literal.

추신 25. 자경단 첫 commit 자동 5 검사 = 5초 × 매일 100 commit = 8분/일. 무한 ROI.

추신 26. 자경단의 1년 후 코드 품질 — strict mypy + 100% type hint + 90% docstring + 80% test 커버리지.

추신 27. 본 H의 7 도구 (PEP 8·black·ruff·docstring·type hint·pre-commit·CI)가 자경단 매일 운영.

추신 28. 본 H의 5 함정 면역이 자경단 1년 면역. 사전 학습이 평생.

추신 29. 본 H의 진짜 결론 — Python 운영은 7 도구의 자동화이고, 5 함정 면역이 1년 자산이며, 자경단 5명 같은 양식이 합의 비용 0이에요.

추신 30. **본 H 끝** ✅ — Python 운영 7 도구 학습 완료. 본인의 첫 pre-commit install! 다음 H7 원리/내부 (CPython VM·GIL·bytecode)! 🐾🐾🐾

추신 31. PEP 8 외 5 PEP (257·484·526·585·695)가 자경단 평생 참고. 매월 1 PEP 학습 = 60개월 = 5년 자경단 마스터.

추신 32. black의 magic trailing comma — 가독성 위해 줄바꿈 보존하는 신호. 자경단 매일 활용.

추신 33. ruff의 600+ 룰셋 중 자경단 표준 7개 (E·F·I·B·UP·SIM·RUF). 나머지는 프로젝트별 선택.

추신 34. ruff format이 black 호환 + 100배 빠름. 자경단 1년 후 마이그레이션 후보 1순위.

추신 35. docstring 3 양식 (Google·NumPy·reST) 중 Google이 자경단 표준. type hint와 짝, 가독성 1위.

추신 36. doctest이 docstring 안에 example 검증. 간단 함수의 빠른 테스트.

추신 37. type hint Generic + Protocol이 자경단 1년 차 라이브러리 작성의 표준.

추신 38. mypy strict 1년 점진적 활성. 한 번에 strict ON 하면 PR 폭발.

추신 39. pre-commit 8 hook 5초 — black·ruff·ruff-format·mypy·trailing·EOF·yaml·large-files. 자경단 매 commit.

추신 40. CI matrix Python 3.11·3.12·3.13 동시 — 호환성 자동 검사. 자경단 표준.

추신 41. 매일 의식 5 시점 (commit·PR·금요일·1일·분기) 누적 60시간/년 = 자경단 평생 자산.

추신 42. 자경단 5 KPI (type 95%·docstring 80%·test 80%·strict 100%·ruff 0) 매월 측정. 자경단 코드 품질 표준.

추신 43. 자경단 7 함정 면역 (black 의도 무시·ruff 분리·docstring 중복·--no-verify·mypy fp·캐시·동적 코드) = 1년 자경단 자산.

추신 44. mypy 5 에러 패턴 (arg-type·return-value·union-attr·unused-ignore·no-untyped-def) 면역 = 90% 처방.

추신 45. type hint의 진짜 ROI — 미래 본인이 6개월 후 코드 보고 5초에 이해. type hint 없으면 5분. 60배.

추신 46. docstring help() 한 번 = 30초 사용법 확인. 1년 후 본인의 평생 사전.

추신 47. pre-commit 5초 × 매일 100 commit = 8분/일. 디버깅 절약 30분/일. 36배 ROI.

추신 48. 자경단 1주차 5일 도입 시나리오 (월 pyproject·화 black·수 ruff·목 mypy·금 install) = 평생 표준.

추신 49. 본 H의 7 도구 (PEP 8·black·ruff·docstring·type hint·pre-commit·CI)가 Python 운영의 100%. 더 없음.

추신 50. 본 H의 진짜 결론 — 자경단 5명 같은 양식이 합의 비용 0이고, 7 도구 자동화가 매일 8분이며, 1년 후 평생 코드 품질 자산 60시간. 다음 H7는 본 H의 운영을 가능하게 하는 CPython의 원리/내부. 🐾
