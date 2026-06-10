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

여기서 "동작하는 코드"와 "좋은 코드"의 차이를 분명히 해 둘게요. H5에서 본인이 짠 환율 계산기는 동작했어요. 결과가 떴어요. 그러면 다 된 거 아니냐고요. 아니에요. 동작하는 코드는 시작일 뿐이에요. 동작하는 코드는 본인 혼자, 지금 당장만 쓸 수 있어요. 그런데 진짜 소프트웨어는 다섯 명이 같이, 5년 동안 고쳐 가며 써요. 그러려면 코드가 읽기 쉽고(docstring), 깨지지 않고(테스트), 일관된 모양이어야(포매터) 해요. 그게 "좋은 코드"예요. 비유하자면, H5는 요리를 한 거고 H6은 그 요리를 식당에서 팔 수 있게 위생과 레시피를 갖추는 거예요. 집에서 혼자 먹을 거면 위생 기준이 느슨해도 돼요. 그런데 손님에게 팔려면 기준이 필요해요. 자경단 사이트는 손님(사용자)에게 파는 음식이에요. 그래서 좋은 코드여야 해요. 오늘 본인이 배우는 여섯 도구가 다 "동작하는 코드를 좋은 코드로 바꾸는" 도구예요. 그리고 이건 H6 셸에서 본인이 deploy.sh에 set -euo pipefail과 shellcheck와 bats를 더한 것과 똑같은 사상이에요. 거기서도 동작하는 스크립트를 안전한 스크립트로 바꿨죠. Python도 똑같아요. 동작에서 품질로. 그게 진짜 개발자의 일이에요.

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

이 한 문장을 좀 더 풀어 볼게요. 초보자는 "코드를 빨리 짜는 게 실력"이라고 생각해요. 그런데 5년 차는 알아요. 코드를 짜는 데 드는 시간은 전체의 20%고, 80%는 그 코드를 읽고 이해하고 고치는 데 써요. 본인이 짠 코드를 동료가 읽고, 6개월 후 본인이 다시 읽고, 1년 후 새 멤버가 읽어요. 그래서 코드는 "컴퓨터가 실행할 수 있게"가 아니라 "사람이 읽기 쉽게" 짜야 해요. 컴퓨터는 못생긴 코드든 예쁜 코드든 똑같이 실행해요. 차이를 느끼는 건 사람이에요. PEP 8은 "사람이 읽기 쉬운 코드"의 약속이에요. 들여쓰기를 4칸으로, 이름을 snake_case로, 이런 약속을 전 세계 Python 개발자가 공유하니까, 본인이 처음 보는 코드도 익숙하게 읽혀요. 그리고 본인이 외울 필요는 없어요. black이 다 해 주거든요. 본인은 그냥 PEP 8의 정신 — "읽기 쉽게" — 만 마음에 두면 돼요. 변수 이름을 a, b, c가 아니라 amount, rate, result로 짓고, 함수를 작게 나누고, 한 함수가 한 가지 일만 하게. 이런 건 black도 못 해 줘요. 이건 본인의 취향이에요. PEP 8의 자동 규칙은 black이 챙기고, 그 정신(읽기 쉬운 이름과 구조)은 본인이 챙기세요. 그 정신이 본인을 좋은 개발자로 만들어요.

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

black을 처음 쓰면 "내 코드를 마음대로 바꾸네?" 하고 거부감이 들 수 있어요. 그런데 며칠 쓰면 그게 해방이라는 걸 알아요. 본인이 코드를 짜다가 들여쓰기가 좀 어긋나도, 따옴표를 섞어 써도, 신경 안 써도 돼요. 저장하면 black이 다 정리하니까요. 본인은 "어떻게 보이게 할까"를 한 번도 고민 안 하고, "무엇을 하게 할까"에만 집중해요. 그게 black의 선물이에요. 스타일에 쓰던 머리를 로직에 쓰는 거죠. 그리고 black은 결정론적이에요. 같은 코드를 누가 black으로 돌리든 똑같은 결과가 나와요. 그래서 본인과 까미가 같은 함수를 짜면, black 돌린 후엔 글자 하나까지 똑같아요. 이게 코드 리뷰를 깨끗하게 만들어요. git diff에 스타일 변경이 안 섞이고 로직 변경만 보이거든요. black은 작은 도구 같지만, 팀 전체의 일하는 방식을 바꿔요.

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

ruff가 다 잡아 줘요. 본인은 코드 짜고, ruff check로 한 번. 통과하면 자경단 표준. ruff와 black의 역할을 한 번 더 정리하면, black은 "모양을 고치는" 도구고 ruff는 "문제를 찾는" 도구예요. black은 군말 없이 자동으로 다듬고, ruff는 "여기 이상해요"라고 알려줘요. ruff가 `--fix`로 자동 수정도 해 주지만, 어떤 문제는 본인이 직접 판단해서 고쳐야 해요. "이 변수 안 쓰는데 정말 지워도 돼요?" 같은 건 본인이 결정해요. 그래서 black은 100% 자동, ruff는 90% 자동 + 10% 본인 판단이에요.

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

docstring을 쓰는 진짜 이유를 짚을게요. 본인이 코드를 짤 때는 그 코드가 뭘 하는지 완벽하게 알아요. 그래서 "굳이 설명을 적어야 하나?" 싶어요. 그런데 6개월 후의 본인은 그 코드를 까먹어요. 완전히 남이 짠 것처럼 낯설어요. 그때 docstring이 6개월 전의 본인이 6개월 후의 본인에게 보내는 쪽지가 돼요. "이 함수는 이런 일을 하고, 이런 인자를 받고, 이런 걸 돌려줘"라고요. 그 쪽지 덕에 본인은 코드를 다시 읽고 해독하는 시간을 아껴요. 그리고 동료에게는 더 중요해요. 까미가 본인의 convert 함수를 쓰려고 할 때, docstring이 있으면 함수 안을 안 읽고도 "아, 이렇게 쓰는 거구나"를 알아요. VS Code에서 함수 위에 마우스를 올리면 docstring이 툭 떠요. 까미는 그것만 보고 바로 써요. docstring이 없으면 까미는 본인 함수 안을 다 읽어야 해요. docstring 세 줄이 까미의 10분을 아껴요. 그래서 자경단은 "public 함수에는 무조건 docstring"을 규칙으로 해요. 다섯 명이 서로의 함수를 빠르게 쓰려면 docstring이 필요하거든요. 다만 모든 줄에 주석을 달라는 건 아니에요. 코드 자체가 좋은 이름을 가지면(convert, format_result) 그 자체로 읽혀요. docstring은 "이 함수가 전체적으로 뭘 하는지"를 함수 머리에 한 번 적는 거예요. 코드 안의 시시콜콜한 주석보다, 함수 머리의 좋은 docstring 하나가 훨씬 가치 있어요.

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

여섯 패턴이 자경단의 매일 type hints. 외우려 마세요. 매일 짜면 박혀요. 처음엔 1번(기본)과 2번(Optional)만 써도 충분해요. Generic이나 Literal은 본인이 큰 코드를 짜다가 필요해지는 날 자연스럽게 만나요.

mypy --strict 옵션의 다섯 단계.

```bash
mypy file.py                    # 기본
mypy --check-untyped-defs file.py  # 미명시 함수도 검사
mypy --strict-optional file.py  # None 명시 강제
mypy --strict file.py           # 모든 strict 옵션
```

자경단 표준 — `mypy --strict`. 모든 함수에 type hints 강제. 첫 1주일은 빡세지만 한 달 후엔 본인 코드 품질이 50% 향상돼요.

type hints가 진짜로 본인을 구하는 장면을 보여드릴게요. H1에서 Python은 타입을 자동 추론해서 편하다고 했죠. 그게 장점인데, 동시에 함정이기도 해요. 본인이 실수로 함수에 글자를 숫자 대신 넘겨도, Python은 일단 받아들이고 돌려요. 그러다 한참 후에 그 글자로 계산을 하려는 순간에야 에러가 터져요. 에러가 원인에서 멀리 떨어진 곳에서 터지는 거예요. 그러면 "이 에러가 왜 났지?" 하고 거슬러 올라가느라 한참 헤매요. type hints + mypy가 이걸 막아요. 본인이 "이 함수는 float을 받는다"고 type hint를 적으면, mypy가 코드를 돌리기도 전에 "여기서 글자를 넘기고 있어요"라고 잡아줘요. 에러가 터지기 전에, 원인 바로 그 자리에서 잡는 거예요. 이게 큰 코드에서 정말 강력해요. 자경단 백엔드가 1만 줄로 자라면, 함수가 수백 개예요. 본인이 한 함수의 반환값을 바꿨을 때, 그걸 쓰는 다른 50군데가 다 영향받아요. type hints가 없으면 그 50군데를 일일이 확인해야 해요. type hints가 있으면 mypy가 "이 50군데 중 3군데가 안 맞아요"라고 정확히 짚어줘요. 본인이 안심하고 큰 코드를 고칠 수 있게 해 주는 안전망이에요. 처음엔 type을 적는 게 귀찮아요. "그냥 돌아가는데 왜 적어?" 싶어요. 그런데 코드가 커질수록 이 안전망이 본인을 구해요. 작은 스크립트는 생략해도 되지만, 다섯 명이 5년 쓸 코드는 type hints가 필수예요. 미래의 본인과 동료를 위한 보험이에요.

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

다섯 테스트. 함수마다 한 케이스 + 에러 케이스. 이게 pytest의 기본 패턴이에요.

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

이 테스트들을 보면서 "테스트 짜는 게 생각보다 단순하네"를 느끼셨으면 좋겠어요. 테스트 한 개는 사실 세 줄이에요. 함수를 부르고, 결과를 받고, `assert`로 "이게 맞아야 한다"를 적어요. `assert convert(50, "USD", "KRW") == 65000.0` 이게 전부예요. "convert(50, USD, KRW)는 65000이어야 한다"는 본인의 기대를 코드로 적은 거예요. 이게 테스트의 본질이에요. 본인의 기대를 코드로 적어 두는 것. 그러면 나중에 코드를 고쳤을 때, 그 기대가 여전히 맞는지 pytest가 자동으로 확인해 줘요. 그리고 테스트를 짤 때 좋은 습관 하나. 정상 케이스만 짜지 말고, 에러 케이스와 경계 케이스도 짜세요. 위에서 본인이 짠 다섯 개를 보면, 정상(USD→KRW), 왕복(USD→KRW→USD), 출력 포맷, 에러(없는 통화), 경계(0원)까지 있어요. 특히 "없는 통화를 넣으면 에러가 나야 한다"는 테스트가 중요해요. 프로그램이 잘못된 입력에 제대로 반응하는지 확인하는 거니까요. 초보자는 "잘 되는 경우"만 테스트하고, 5년 차는 "안 되는 경우"도 테스트해요. 진짜 버그는 항상 예상 못 한 입력에서 나오거든요. 본인이 오늘 짠 다섯 테스트가 정상·왕복·포맷·에러·경계를 다 덮은 게, 좋은 테스트의 모범이에요.

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

테스트가 진짜로 본인을 구하는 순간은 "리팩토링"할 때예요. 리팩토링이 뭐냐면, 동작은 그대로 두고 코드를 더 깔끔하게 다시 짜는 거예요. 본인이 6개월 후 환율 계산기를 보면 "이 convert 함수를 더 좋게 짤 수 있겠는데" 싶을 거예요. 그래서 고치고 싶어요. 그런데 무서워요. "이거 고쳤다가 어디 깨지면 어쩌지?" 테스트가 없으면 이 무서움 때문에 본인은 코드를 안 고쳐요. 그러면 코드가 점점 낡고 지저분해져요. 테스트가 있으면 정반대예요. 본인이 convert를 완전히 다시 짜고 `pytest`를 돌려요. 다섯 테스트가 다 통과하면, "아, 동작은 그대로구나" 하고 안심해요. 빨간불이 뜨면 "아, 여기 깨뜨렸구나" 하고 바로 알아요. 테스트가 본인의 등을 받쳐 주니까, 본인은 두려움 없이 코드를 개선해요. 이게 H4에서 말한 "겁쟁이에서 용감한 사람으로"의 진짜 의미예요. 테스트는 코드를 검증하는 도구일 뿐 아니라, 본인이 코드를 계속 개선할 수 있게 해 주는 자유예요. 좋은 개발자는 코드를 한 번 짜고 끝내지 않아요. 계속 다듬어요. 그 다듬기를 가능하게 하는 게 테스트예요. 그리고 자경단 같은 팀에서는 더 중요해요. 까미가 본인 코드를 고칠 때, 본인이 짜 둔 테스트가 까미를 지켜요. "이 테스트 통과하면 까미가 내 코드를 안 깨뜨린 거구나." 테스트는 다섯 명이 서로의 코드를 안심하고 만질 수 있게 해 주는 신뢰의 그물이에요. 본인이 오늘 짠 다섯 테스트가, 그 신뢰의 첫 매듭이에요.

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

이제 git commit 할 때마다 자동으로 black + ruff + mypy 돌아요. 통과 못 하면 commit 안 됨. 사고가 main에 닿기 전에 막혀요.

> ▶ **같이 쳐보기** — pre-commit 첫 실행
>
> ```bash
> pre-commit run --all-files
> ```

전체 파일 검사. 첫 실행은 5분 정도(도구 설치 때문에). 그 다음 commit은 5초.

자경단 표준 — 모든 Python 프로젝트에 pre-commit. 다섯 명이 다 통과한 코드만 main 진입.

pre-commit이 왜 그렇게 중요한지 사람의 심리로 설명할게요. 본인이 "commit 전에 black이랑 ruff랑 mypy 돌려야지"라고 머리로 기억하려고 하면, 바쁘거나 급할 때 까먹어요. 사람의 의지는 믿을 게 못 돼요. 5년 차도 급하면 까먹어요. 그래서 자경단은 사람의 의지에 안 맡겨요. pre-commit이 git commit을 가로채서 자동으로 검사를 돌리거든요. 본인이 까먹어도, 게을러도, 급해도, commit하는 순간 pre-commit이 알아서 black·ruff·mypy를 돌려요. 통과 못 하면 commit 자체가 안 돼요. 그러니까 본인은 신경 쓸 필요가 없어요. 그냥 commit하면 검사는 자동이에요. 이게 "사람의 규율을 기계의 자동화로 바꾸는" 사상이에요. Ch005에서 본 husky, Ch006에서 본 trap과 똑같아요. 사람이 매번 기억해서 하는 건 언젠가 빠뜨려요. 기계가 자동으로 하면 절대 안 빠뜨려요. 그래서 좋은 팀은 중요한 검사를 다 자동화해요. 사람은 본질적인 일(로직 짜기)에 집중하고, 반복적인 검사는 기계가 해요. 본인이 pre-commit을 한 번 셋업하면, 그 다음부터 본인의 모든 commit이 자동으로 자경단 표준을 통과해요. 5분 셋업이 5년의 규율을 사 줘요. 그리고 이건 본인 혼자만의 일이 아니에요. 다섯 명이 다 pre-commit을 쓰면, 다섯 명의 모든 commit이 같은 기준을 통과해요. 그래서 자경단 코드는 누가 짰든 같은 품질이에요. pre-commit이 다섯 명의 품질을 자동으로 통일하는 거예요.

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

왜 두 겹이 필요한지 짚을게요. pre-commit은 본인 노트북에서 도는 거예요. 그런데 누군가 pre-commit을 안 깔았거나, `git commit --no-verify`로 일부러 건너뛸 수도 있어요. 사람의 노트북은 못 믿어요. CI는 GitHub 서버에서 도는 거라 아무도 못 건너뛰어요. 본인이 PR을 올리면 GitHub Actions가 깨끗한 새 환경에서 검사를 다시 돌려요. 그래서 "내 노트북에선 통과했는데" 같은 변명이 안 통해요. CI가 최종 심판이에요. CI가 초록불이면 그 코드는 진짜로 모든 검사를 통과한 거예요. 이게 Ch005에서 배운 branch protection과 합쳐져요. CI가 실패하면 머지 버튼이 잠겨요. 그래서 깨진 코드가 main에 못 들어가요. 다섯 명이 각자 노트북에서 무슨 짓을 하든, main에 들어가는 코드는 항상 CI를 통과한 깨끗한 코드예요. 이 두 겹 — 노트북의 pre-commit(빠른 1차 검사)과 서버의 CI(못 건너뛰는 최종 검사) — 이 자경단 코드의 품질을 지켜요. 그리고 본인이 두 해 코스에서 배운 게 여기서 다 만나요. Ch005의 branch protection, Ch006의 자동화 정신, Ch007의 품질 도구. 셋이 합쳐져서 "다섯 명이 사고 없이 같이 일하는 시스템"이 돼요. 본인이 오늘 .github/workflows/python.yml 한 파일을 만들면, 그게 본인 프로젝트의 자동 품질 관문이 돼요.

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

이 일곱 단계가 많아 보이지만, 본인이 실제로 신경 쓰는 건 첫 단계(코드 짜기)와 마지막(push)뿐이에요. 나머지 다섯 단계는 다 자동이에요. black은 저장할 때 자동, ruff·mypy·pytest는 pre-commit이 자동, CI는 push하면 자동. 본인은 코드를 짜고 push만 하면, 그 사이의 모든 품질 검사가 알아서 돌아요. 이게 자동화의 아름다움이에요. 본인은 본질(코드 짜기)에만 집중하고, 품질은 기계가 챙겨요. 본인이 H5에서 짠 50줄짜리 환율 계산기가, 이 일곱 단계를 거치면 "다섯 명이 5년 쓸 수 있는 제품 코드"가 돼요. 그리고 이 흐름은 한 번 셋업하면 평생 가요. 새 프로젝트를 시작할 때 pre-commit 설정 파일 하나, CI 파일 하나만 복사하면, 그 프로젝트도 같은 품질 관문을 가져요. 자경단은 이 두 파일을 템플릿으로 가지고 있어서, 새 프로젝트마다 5분이면 같은 품질 시스템을 깔아요. 본인도 두 해 코스에서 이 두 파일을 본인 템플릿으로 만들어 두세요. 그게 본인이 짜는 모든 코드의 품질을 자동으로 보장하는 거예요.

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

처음 5분 셋업 후 평생 자동. 사고 비용 절감 100배. 한 번 깔면 본인이 까먹어도 기계가 챙겨요. 의지가 아니라 자동화에 맡기는 게 부담이 아니라 해방이에요.

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

박수 한 번 칠게요. 정말 큰 박수예요. 본인의 환율 계산기 50줄이 자경단 표준 코드로 변했어요. 다섯 명이 같이 봐도 부끄럽지 않은 코드. GitHub에 올라가도 자랑스러운 코드. 본인은 오늘 "혼자 돌아가는 코드"에서 "다섯 명이 5년 쓸 코드"로 넘어가는 다리를 건넜어요. 이 다리가 취미 코더와 프로 개발자를 가르는 경계선이에요. 본인은 이제 그 경계선을 넘었어요.

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

---

## 추신

1. 동작하는 코드(H5) → 좋은 코드(H6). 둘은 달라요.
2. PEP 8 = Python 스타일 공식 표준. black이 자동으로.
3. 들여쓰기 4공백·snake_case·상수 UPPER·import 위에 모음.
4. "코드는 짜는 시간보다 읽는 시간이 길다"가 PEP 8의 철학.
5. black = no-config 포매터. 합의 비용 0. 자유보다 합의.
6. black은 모양만, 동작은 안 건드림. 저장마다 돌려도 안전.
7. ruff = Rust 100배 linter. 700룰 중 자경단 50개.
8. ruff가 잡는 것 — 안 쓰는 import·변수·긴 줄·빈 except·mutable default.
9. docstring 세 양식 — Google(자경단)·NumPy·reST.
10. docstring 5부분 — 요약·Args·Returns·Raises·Examples.
11. docstring은 help()·IDE·Sphinx로 살아나요. 미래의 본인에게.
12. type hint 6 — 기본·Optional(`| None`)·list/dict·Callable·Generic·Literal.
13. mypy --strict가 자경단 표준. 첫 1주 빡세고 한 달 후 50% 향상.
14. pytest = 표준 테스트. `test_`함수 + `assert`.
15. 함수마다 1테스트 + 에러 케이스. coverage 80%+.
16. pytest 5 — fixture·parametrize·mark·conftest·--cov.
17. `pytest.raises(KeyError)`로 에러도 테스트.
18. pre-commit = commit마다 자동 black·ruff·mypy.
19. `.pre-commit-config.yaml` + `pre-commit install`.
20. 통과 못 하면 commit 안 됨. 사고 면역.
21. CI = GitHub Actions로 PR마다 4단계 검사.
22. local pre-commit + CI = 두 겹 안전.
23. 함정 5 — 들여쓰기 혼합·긴 줄·import 순서·mutable default·== None.
24. 다 black·ruff가 자동으로 잡아요. 본인이 외울 필요 없음.
25. 매일 의식 — `black . && ruff check . --fix && mypy --strict . && pytest`.
26. dotfile에 `alias check="..."`. 5초 의식.
27. 흐름 — 짜기→black→ruff→mypy→pytest→commit→push→CI.
28. type hint·docstring·pre-commit은 미래의 본인과 동료를 위한 선물.
29. H6 졸업장 — exchange.py가 black·ruff·mypy·pytest 다 통과.
30. 다음 H7은 CPython·GIL 깊이. 한 시간 쉬고 만나요. 🐾
