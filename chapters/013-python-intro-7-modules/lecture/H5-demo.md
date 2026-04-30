# Ch013 · H5 — vigilante_pkg 30분 — 5 모듈 1 패키지

> 고양이 자경단 · Ch 013 · 5교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 시나리오 — 자경단 첫 패키지
3. 0~5분 — 폴더 구조
4. 5~10분 — exchange 모듈
5. 10~15분 — validators 모듈
6. 15~20분 — utils 모듈
7. 20~25분 — __init__.py와 cli
8. 25~30분 — pyproject.toml과 설치
9. 다섯 사고와 처방
10. 흔한 오해 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요.

지난 H4 회수. stdlib 30 + PyPI 30.

이번 H5는 첫 패키지 만들기.

오늘의 약속. **본인의 첫 패키지 vigilante가 pip install로 깔립니다**.

자, 가요.

---

## 2. 시나리오 — 자경단 첫 패키지

본인의 환율 계산기를 패키지로. 5 모듈.

```
vigilante/
├── __init__.py
├── exchange.py       # 환율 변환
├── validators.py     # 검증
├── utils.py          # 유틸
├── cli.py            # CLI 진입점
└── data.py           # RATES 데이터
```

---

## 3. 0~5분 — 폴더 구조

```bash
mkdir -p /tmp/pkg-demo && cd /tmp/pkg-demo
python3 -m venv .venv
source .venv/bin/activate

mkdir -p vigilante
touch vigilante/__init__.py
touch vigilante/{exchange,validators,utils,cli,data}.py
touch pyproject.toml
```

폴더 구조 만들기.

---

## 4. 5~10분 — exchange 모듈

```python
# vigilante/exchange.py
"""환율 변환."""

from vigilante.data import RATES


def convert(amount: float, from_curr: str, to_curr: str) -> float:
    """from_curr를 to_curr로 환산."""
    krw = amount * RATES[from_curr]
    return krw / RATES[to_curr]


def convert_all(amount: float, from_curr: str) -> dict[str, float]:
    """모든 통화로 환산."""
    return {
        c: convert(amount, from_curr, c)
        for c in RATES
        if c != from_curr
    }
```

---

## 5. 10~15분 — validators 모듈

```python
# vigilante/validators.py
"""검증 함수들."""

from vigilante.data import RATES


def is_valid_currency(curr: str) -> bool:
    """통화 코드 유효성."""
    return curr.upper() in RATES


def is_valid_amount(amount: float) -> bool:
    """금액 유효성."""
    return amount > 0


class CurrencyError(Exception):
    """통화 관련 에러."""
    pass
```

---

## 6. 15~20분 — utils 모듈

```python
# vigilante/utils.py
"""유틸 함수."""


def format_amount(amount: float, currency: str) -> str:
    """금액 포매팅."""
    return f"{amount:,.2f} {currency}"


def parse_amount(s: str) -> float:
    """문자열을 금액으로."""
    return float(s.replace(",", "").strip())
```

---

## 7. 20~25분 — __init__.py와 cli

```python
# vigilante/__init__.py
"""자경단 패키지."""

from vigilante.exchange import convert, convert_all
from vigilante.validators import (
    is_valid_currency,
    is_valid_amount,
    CurrencyError,
)
from vigilante.utils import format_amount, parse_amount

__version__ = "0.1.0"
__all__ = [
    "convert",
    "convert_all",
    "is_valid_currency",
    "is_valid_amount",
    "CurrencyError",
    "format_amount",
    "parse_amount",
]
```

```python
# vigilante/cli.py
"""CLI 진입점."""

import sys
from vigilante import convert, format_amount, is_valid_currency


def main() -> int:
    if len(sys.argv) != 4:
        print("Usage: vigilante <amount> <from> <to>")
        return 1
    
    amount = float(sys.argv[1])
    from_c = sys.argv[2].upper()
    to_c = sys.argv[3].upper()
    
    if not is_valid_currency(from_c) or not is_valid_currency(to_c):
        print(f"잘못된 통화")
        return 1
    
    result = convert(amount, from_c, to_c)
    print(format_amount(result, to_c))
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

---

## 8. 25~30분 — pyproject.toml과 설치

```toml
# pyproject.toml
[project]
name = "vigilante"
version = "0.1.0"
description = "자경단 환율 도구"
requires-python = ">=3.10"

[project.scripts]
vigilante = "vigilante.cli:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

```python
# vigilante/data.py
RATES = {
    "KRW": 1.0,
    "USD": 1300.0,
    "JPY": 9.0,
    "EUR": 1400.0,
}
```

editable install.

```bash
pip install -e .
```

테스트.

```bash
$ vigilante 50 USD KRW
65,000.00 KRW

$ python3 -c "from vigilante import convert; print(convert(50, 'USD', 'KRW'))"
65000.0
```

본인의 첫 패키지 작동.

---

## 9. 다섯 사고와 처방

**사고 1: __init__.py 누락**

처방. 빈 파일이라도.

**사고 2: import 순환**

처방. data.py로 분리.

**사고 3: relative import 사고**

처방. absolute 사용.

**사고 4: 빌드 실패**

처방. pyproject.toml의 build-system.

**사고 5: editable install 안 됨**

처방. pip install -e . 다시.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 패키지는 PyPI 발행만.**

local editable도 가능.

**오해 2: 한 모듈로 충분.**

500줄 넘으면 분리.

**오해 3: __all__ 항상.**

옵션. * import 안 쓰면 불필요.

**오해 4: cli.py 필수.**

아니. 라이브러리만도 OK.

**오해 5: pyproject.toml 어렵다.**

10줄로 시작.

---

## 11. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, __init__.py 누락. 안심 — 빈 파일이라도.
둘째, circular import. 안심 — data.py로 분리.
셋째, relative 사용. 안심 — absolute 표준.
넷째, pyproject 어렵다. 안심 — 10줄로 시작.
다섯째, 가장 큰 — editable install 안 됨. 안심 — `pip install -e .` 표준.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 다섯 번째 시간 끝.

vigilante 패키지 5 모듈, pyproject.toml, editable install.

다음 H6은 운영. 함정, dependency, 측정.

```bash
pip install -e .
vigilante 50 USD KRW
```

---

## 👨‍💻 개발자 노트

> - hatchling: PEP 517 build backend.
> - editable install: site-packages에 link.
> - entry points: pyproject scripts.
> - __init__.py public API: __all__.
> - 다음 H6 키워드: dependency · 측정 · pip-tools · safety.
