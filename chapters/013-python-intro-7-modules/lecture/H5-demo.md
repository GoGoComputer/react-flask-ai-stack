# Ch013 · H5 — 데모: vigilante 패키지 30분 만들기

> 고양이 자경단 · Ch 013 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 오늘 만들 것 — 자경단 첫 패키지의 설계도
3. 0~5분 — 폴더 구조 세우기
4. 5~10분 — data와 exchange 모듈
5. 10~15분 — validators 모듈
6. 15~20분 — utils 모듈
7. 20~25분 — __init__.py로 현관 만들기
8. 25~30분 — cli와 pyproject.toml, 그리고 설치
9. 작동 확인 — 본인의 첫 패키지가 깔린다
10. 다섯 사고와 처방
11. AI 시대의 패키지 만들기
12. 자주 받는 질문 일곱 가지
13. 흔한 오해 다섯 가지
14. 흔한 실수 다섯 + 안심
15. 마무리

---

## 🔧 강사용 명령어 한눈에

```bash
python3 -m venv .venv && source .venv/bin/activate   # 작업실
mkdir vigilante && touch vigilante/__init__.py        # 패키지 폴더
pip install -e .                                      # editable 설치
vigilante 50 USD KRW                                  # CLI 실행
```

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다섯 번째 시간이에요. 오늘은 특별해요. 드디어 **직접 만드는** 날이거든요. H1에서 큰 그림을, H2에서 개념을, H3에서 도구를, H4에서 카탈로그를 봤죠. 머리로 다 배웠어요. 이제 손으로 옮길 차례예요.

지난 H4를 한 줄로 회수할게요. 표준 라이브러리 30개, PyPI 30개, 합쳐 60개의 지도를 그렸어요. "이 일엔 이 모듈" 하는 감각을 만들었죠. 그리고 그 전에 H2에서 `__init__.py`와 `__name__`을, H3에서 pyproject.toml과 `pip install -e`를 배웠어요. 오늘은 그걸 다 한자리에 모아서, 진짜 패키지를 빚어요.

오늘의 약속은 이거예요. **본인의 첫 패키지 vigilante가, 30분 만에 만들어지고 `pip install`로 깔립니다.** 그냥 코드 파일 몇 개가 아니에요. 진짜 설치 가능한, 명령어로 실행되는 패키지예요. 본인이 H1에서 한 약속 "첫 패키지를 만든다"를 오늘 지키는 거예요.

방식은 시계를 보며 가요. 30분을 5분씩 여섯 토막으로 나눠서, 토막마다 하나씩 쌓아 올려요. 처음엔 빈 폴더였다가, 5분 뒤엔 구조가 서고, 10분 뒤엔 환율 변환이 되고… 그렇게 30분 뒤엔 완성된 패키지가 손에 들려요. 따라오기만 하면 돼요. 자, 먼저 오늘 만들 것의 설계도를 봐요.

---

## 2. 오늘 만들 것 — 자경단 첫 패키지의 설계도

본인이 Python 입문 내내 만들어 온 환율 계산기, 기억하죠? 그걸 오늘 진짜 패키지로 키워요. 이름은 vigilante예요. 구조는 이래요.

```
vigilante/
├── __init__.py       # 현관 — 공개 API를 모음
├── data.py           # 환율 데이터(RATES)
├── exchange.py       # 환율 변환 — 핵심 기능
├── validators.py     # 검증 — 통화·금액이 올바른가
├── utils.py          # 유틸 — 금액 포매팅·파싱
└── cli.py            # CLI 진입점 — 명령어로 실행
pyproject.toml        # 신분증 — 패키지 정보
```

설계의 뜻을 읽어 줄게요. 환율 계산이라는 한 가지 일을, **역할별로 여섯 모듈에 나눴어요.** 데이터는 data.py에, 변환 로직은 exchange.py에, 검증은 validators.py에, 도우미는 utils.py에, 명령어 진입점은 cli.py에요. 그리고 `__init__.py`가 이 다섯을 묶어 현관 노릇을 해요.

왜 이렇게 나눌까요? H1에서 "1,000줄 미로를 200줄짜리 도시 다섯으로 나눈다"고 했죠. 그 실천이에요. 한 파일에 다 넣으면 찾기 힘들지만, 역할별로 나누면 "환율 계산이 이상하다 → exchange.py를 본다", "검증이 문제다 → validators.py를 본다" 하고 바로 찾아가요. 각 파일이 한 가지 일만 하니, 읽기도 고치기도 쉬워요. 이게 H2에서 배운 모듈 분리의 진짜 모습이에요.

한 가지 더. 보면 exchange.py도 validators.py도 둘 다 data.py의 RATES를 가져다 써요. 공통으로 쓰는 데이터를 data.py 한 곳에 두고, 둘이 거기서 가져오는 거죠. 이렇게 하면 H2에서 배운 circular import(서로 물기)도 안 생겨요. 데이터를 맨 밑에 깔고, 그 위에 로직을 얹는 구조거든요.

이 "층층 구조"를 조금 더 설명할게요. 우리 패키지는 세 층으로 쌓여 있어요. 맨 아래가 data.py(데이터), 가운데가 exchange·validators·utils(로직), 맨 위가 cli·`__init__`(진입점·현관)이에요. 그리고 화살표(import 방향)는 항상 위에서 아래로만 흘러요. cli가 exchange를 가져오고, exchange가 data를 가져오죠. 아래층은 위층을 절대 안 가져와요. data.py는 그 누구도 import하지 않고요. 이렇게 한 방향으로만 흐르게 하면, 서로 물고 무는 circular import가 구조적으로 불가능해져요. 마치 물이 위에서 아래로만 흐르듯, import도 한 방향이면 막힐 일이 없는 거죠. 이게 패키지 설계의 핵심 감각이에요. "의존성은 한 방향으로." 오늘 작은 패키지에서 이 감각을 몸에 익히면, 나중에 거대한 프로젝트에서도 똑같이 써먹어요.

자, 설계도를 봤으니 만들러 가요. 시계 준비됐죠? 30분 시작해요.

---

## 3. 0~5분 — 폴더 구조 세우기

첫 5분은 뼈대를 세워요. 작업실부터 만들고, 빈 파일들을 늘어놓는 거예요.

```bash
mkdir -p /tmp/pkg-demo && cd /tmp/pkg-demo   # 작업 폴더
python3 -m venv .venv                         # 격리된 작업실
source .venv/bin/activate                     # 작업실 들어가기

mkdir -p vigilante                            # 패키지 폴더
touch vigilante/__init__.py                   # 패키지 표시
touch vigilante/data.py
touch vigilante/exchange.py
touch vigilante/validators.py
touch vigilante/utils.py
touch vigilante/cli.py
touch pyproject.toml                          # 신분증
```

한 줄씩 짚을게요. 먼저 작업 폴더를 만들고 들어가요. 그다음 H3에서 배운 venv로 격리된 작업실을 만들고 activate로 들어가요. 터미널 앞에 `(.venv)`가 떴죠? 이제 여기서 하는 건 다 이 작업실 안에만 들어가요.

그리고 vigilante라는 폴더를 만들고, 그 안에 `__init__.py`를 비워서 만들어요. H2에서 배웠죠. 이 빈 파일 하나가 "이 폴더는 패키지다"라는 표시예요. 이게 있어야 Python이 vigilante를 패키지로 알아봐요. 그다음 data·exchange·validators·utils·cli 다섯 모듈을 빈 파일로 만들고, 맨 바깥에 pyproject.toml(신분증)도 빈 파일로 만들어요.

지금은 다 비어 있어요. 뼈대만 선 거죠. 5분 동안 한 일은 "집의 방 배치를 정한 것"이에요. 거실·부엌·침실 자리를 잡았어요. 이제 방마다 가구를 들일 차례예요. 다음 5분에 data와 exchange부터 채워요.

여기서 빈 파일부터 다 만들어 두는 게 좋은 습관이에요. 구조를 먼저 눈에 보이게 세워 두면, 어디에 뭘 채울지 길을 잃지 않거든요. 코드를 짜다가 "이건 어느 모듈에 넣지?" 하고 헤맬 때, 이미 만들어 둔 빈 파일들이 답을 줘요. "검증이니까 validators.py에" 하고요. 설계를 먼저, 살은 나중에. 이게 큰 걸 만들 때 안 무너지는 비결이에요.

---

## 4. 5~10분 — data와 exchange 모듈

이제 가장 밑바닥인 data.py부터 채워요. 환율 데이터를 담는 곳이에요.

```python
# vigilante/data.py
"""환율 데이터 — 모든 모듈이 여기서 가져다 씀."""

RATES = {
    "KRW": 1.0,      # 원화 기준
    "USD": 1300.0,   # 1달러 = 1300원
    "JPY": 9.0,      # 1엔 = 9원
    "EUR": 1400.0,   # 1유로 = 1400원
}
```

data.py는 단순해요. RATES라는 딕셔너리에 통화별 환율을 담았어요. KRW(원화)를 1.0 기준으로, 1달러는 1300원, 이런 식이죠. 이게 패키지의 토대 데이터예요. 다른 모듈들이 다 여기서 RATES를 가져다 써요. 그래서 맨 먼저, 맨 밑에 만든 거예요.

이제 핵심 기능인 exchange.py를 채워요.

```python
# vigilante/exchange.py
"""환율 변환 — 패키지의 핵심 기능."""

from vigilante.data import RATES


def convert(amount: float, from_curr: str, to_curr: str) -> float:
    """from_curr 금액을 to_curr로 환산한다."""
    krw = amount * RATES[from_curr]   # 일단 원화로
    return krw / RATES[to_curr]       # 목표 통화로


def convert_all(amount: float, from_curr: str) -> dict[str, float]:
    """한 통화를 나머지 모든 통화로 환산한다."""
    return {
        c: convert(amount, from_curr, c)
        for c in RATES
        if c != from_curr
    }
```

맨 윗줄을 보세요. `from vigilante.data import RATES`. H2에서 배운 absolute import예요. 같은 패키지 안의 data 모듈에서 RATES를 가져오는 거죠. 점으로 패키지 경로를 다 적어서 명확하게요. 자경단 표준이 absolute라고 했죠. 그 실천이에요.

convert 함수는 환율 변환의 핵심이에요. 한 번 원화로 바꿨다가(amount × from 환율), 목표 통화로 나눠요(÷ to 환율). 이게 환율 변환의 기본 공식이에요. 왜 원화를 거치냐면, RATES가 다 "원화 기준"이거든요. USD가 1300이라는 건 "1달러 = 1300원"이라는 뜻이죠. 그러니 어떤 통화든 일단 원화로 환산한 다음, 목표 통화로 나누면 돼요. 원화를 중간 다리로 삼는 거예요. 50달러면 → 65,000원(50×1300) → 그게 다시 KRW면 그대로 65,000원이죠. 단순하지만 모든 통화 쌍에 통하는 공식이에요.

함수에 타입 힌트가 붙은 것도 보세요. `amount: float, from_curr: str, to_curr: str) -> float`. "금액은 실수, 통화는 문자열, 반환은 실수"라고 적었죠. 이건 Ch008에서 배운 타입 힌트예요. 꼭 필요한 건 아니지만, 적어 두면 "이 함수를 어떻게 쓰는지"가 한눈에 보여요. 나중에 mypy로 검사도 받고요. 진짜 패키지다운 친절함이에요.

convert_all은 한 통화를 나머지 전부로 바꿔요. H2에서 본 컴프리헨션으로, RATES의 모든 통화를 돌면서 자기 자신만 빼고 변환하죠. `if c != from_curr`가 "자기 자신은 빼라"는 부분이에요. 50달러를 달러로 또 바꿀 필요는 없으니까요. 보세요, 이전 챕터에서 배운 함수·타입 힌트·컴프리헨션이 다 여기 모였어요. 10분 만에 환율 변환이 되는 모듈이 생겼어요. 입문 내내 쌓은 게 이렇게 한 모듈로 응결되는 거예요.

---

## 5. 10~15분 — validators 모듈

다음 5분은 검증을 맡는 validators.py예요. 사용자가 엉뚱한 값을 넣었을 때 걸러 주는 모듈이죠.

```python
# vigilante/validators.py
"""검증 — 통화 코드와 금액이 올바른지 확인."""

from vigilante.data import RATES


def is_valid_currency(curr: str) -> bool:
    """우리가 아는 통화 코드인가?"""
    return curr.upper() in RATES


def is_valid_amount(amount: float) -> bool:
    """금액이 0보다 큰가?"""
    return amount > 0


class CurrencyError(Exception):
    """통화 관련 사고를 표현하는 예외."""
    pass
```

validators.py도 data.py에서 RATES를 가져와요. 왜냐하면 "이 통화가 유효한가"를 판단하려면 우리가 아는 통화 목록(RATES)이 필요하거든요. is_valid_currency는 입력한 통화가 RATES에 있는지 봐요. `.upper()`로 소문자도 대문자로 바꿔 비교하니, usd라고 써도 USD로 알아듣죠. 친절한 처리예요.

is_valid_amount는 금액이 0보다 큰지 봐요. 마이너스 환율은 말이 안 되니까요. 그리고 CurrencyError라는 예외 클래스도 만들었어요. Ch012에서 예외를 배웠죠. 여기선 "통화 관련 사고"를 표현하는 우리만의 예외를 정의한 거예요. 나중에 잘못된 통화가 들어오면 이 예외를 던질 수 있어요. 검증과 예외가 짝을 이루는 거죠. 검증으로 미리 막고, 못 막으면 예외로 알리고요.

이 모듈이 왜 따로 있어야 할까요? 검증 로직을 exchange.py에 섞어 넣을 수도 있어요. 그런데 그러면 exchange.py가 "변환도 하고 검증도 하는" 잡탕이 돼요. 역할이 흐려지죠. 검증은 검증대로 validators.py에 모아 두면, "검증 규칙을 바꾸고 싶다 → validators.py만 본다"가 돼요. 한 모듈은 한 가지 일. 이게 좋은 분리예요.

---

## 6. 15~20분 — utils 모듈

이제 도우미 함수를 담는 utils.py예요. 자잘하지만 여기저기서 쓰는 편의 함수들이죠.

```python
# vigilante/utils.py
"""유틸 — 금액 표시와 파싱을 돕는 함수."""


def format_amount(amount: float, currency: str) -> str:
    """65000.0 → '65,000.00 KRW' 처럼 보기 좋게."""
    return f"{amount:,.2f} {currency}"


def parse_amount(s: str) -> float:
    """'1,300' 같은 문자열을 1300.0 숫자로."""
    return float(s.replace(",", "").strip())
```

utils.py는 data를 안 가져와요. 다른 모듈에 안 기대는 순수한 도우미라서요. format_amount는 숫자를 사람이 읽기 좋게 바꿔요. `65000.0`을 `65,000.00 KRW`로요. 그 `f"{amount:,.2f}"`가 Ch011에서 배운 f-string 포매팅이에요. 쉼표로 천 단위를 끊고, 소수점 둘째 자리까지요. 사람이 컴퓨터의 숫자를 편히 읽게 해 주는 거죠.

parse_amount는 그 반대예요. `1,300` 같은 문자열에서 쉼표를 떼고 숫자 1300.0으로 바꿔요. 사람이 입력한 걸 컴퓨터가 쓸 수 있게요. format은 컴퓨터→사람, parse는 사람→컴퓨터. 한 쌍이에요. Ch011에서 "문자열은 사람과 컴퓨터가 만나는 자리"라고 했죠. 이 두 함수가 딱 그 통역사 역할이에요.

utils라는 이름을 짚고 갈게요. "유틸리티(utility)"는 "이것저것 도와주는 잡다한 도구"라는 뜻이에요. 어느 프로젝트에나 utils.py가 하나쯤 있어요. 다만 주의할 게, utils에 아무거나 막 넣으면 "잡동사니 서랍"이 돼요. 정말 여러 곳에서 쓰는 순수한 도우미만 넣고, 특정 역할이 뚜렷한 건 제 모듈로 보내세요. 지금처럼 포매팅·파싱 같은 진짜 범용 도우미만요.

여기서 utils.py가 data.py를 안 가져온다는 점도 의미가 있어요. utils는 어디에도 안 기대는 가장 독립적인 모듈이에요. 그래서 §2에서 본 층층 구조에서, utils는 다른 모듈에 거의 의존하지 않는 깔끔한 위치에 있죠. 이렇게 "남에게 안 기대는 순수 함수"는 테스트하기도 제일 쉬워요. 입력을 주면 정해진 출력이 나오니까요. 나중에 Ch022에서 테스트를 배울 때, utils 같은 순수 함수부터 테스트하면 수월해요. 20분이 지났어요. 모듈 다섯 중 넷이 찼어요.

---

## 7. 20~25분 — __init__.py로 현관 만들기

이제 H2에서 배운 그 현관, `__init__.py`를 채울 차례예요. 지금까진 비어 있었죠. 여기에 공개 API를 모아요.

```python
# vigilante/__init__.py
"""고양이 자경단 환율 패키지."""

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

이게 H2에서 말한 "현관에 간판 달기"예요. `__init__.py`가 각 모듈에서 대표 기능들을 가져와서, 패키지의 정문에 모아 놓는 거예요. 그러면 사용자가 안쪽 구조(exchange.py·validators.py가 따로 있다는 것)를 몰라도, 그냥 `from vigilante import convert`라고 바로 쓸 수 있어요.

비교해 볼게요. 현관이 없으면 사용자는 `from vigilante.exchange import convert`라고 안쪽 모듈까지 알아야 해요. 현관이 있으면 `from vigilante import convert`로 끝이죠. 짧고, 안쪽 구조를 숨겨 줘요. 나중에 본인이 exchange.py를 둘로 쪼개도, 현관에서 같은 이름으로 내보내면 사용자는 아무것도 안 바꿔도 돼요. 이게 "공개 API를 `__init__.py`에 모은다"의 힘이에요.

`__version__ = "0.1.0"`은 패키지 버전이에요. 첫 버전이니 0.1.0으로 시작해요. 왜 1.0.0이 아니라 0.1.0일까요? 관습이에요. 0점대는 "아직 개발 중, 바뀔 수 있음"이라는 신호고, 1.0.0은 "안정됐다, 믿고 써도 된다"는 선언이거든요. 처음엔 겸손하게 0.1.0으로 시작해서, 기능이 자리 잡고 검증되면 1.0.0을 올려요. H3에서 본 semver(유의적 버전)의 실천이에요. `__all__`은 "이게 이 패키지의 공식 메뉴"라는 목록이고요. H2에서 배운 그대로죠. 일곱 개 기능을 공개 메뉴로 내놓은 거예요.

그런데 잠깐, `__init__.py`가 각 모듈을 import하는 순서도 의미가 있어요. exchange → validators → utils 순으로 가져오죠. 이건 사실 어느 순서든 되는데, 보통 "중요한 것부터" 또는 "의존성 낮은 것부터" 적어요. 그리고 이 import들이 실행되는 순간, data.py도 따라서 로드돼요(exchange가 data를 가져오니까). 그래서 `import vigilante` 한 번에 패키지 전체가 준비돼요. 현관문을 여니 집 전체에 불이 켜지는 셈이죠. 다만 H2에서 강조했듯, 이 import들은 가볍고 빨라야 해요. 여기서 무거운 작업(파일 읽기·네트워크)을 하면 `import vigilante`가 느려지거든요. 우리 `__init__.py`는 가져오기만 하니 가볍고 빨라요. 좋은 현관이에요.

보세요, H2의 개념이 여기서 진짜 코드가 됐어요. 배운 게 손에서 살아나는 순간이에요. 개념으로 들을 땐 추상적이던 `__init__.py`·`__all__`·`__version__`이, 이렇게 직접 써 보니 "아, 이거였구나" 하고 또렷해지죠. 이게 데모의 힘이에요.

---

## 8. 25~30분 — cli와 pyproject.toml, 그리고 설치

마지막 5분이에요. 명령어 진입점 cli.py와 신분증 pyproject.toml을 채우고, 설치까지 해요.

```python
# vigilante/cli.py
"""CLI 진입점 — 터미널에서 vigilante 명령어로 실행."""

import sys
from vigilante import convert, format_amount, is_valid_currency


def main() -> int:
    if len(sys.argv) != 4:
        print("사용법: vigilante <금액> <원래통화> <바꿀통화>")
        return 1

    amount = float(sys.argv[1])
    from_c = sys.argv[2].upper()
    to_c = sys.argv[3].upper()

    if not is_valid_currency(from_c) or not is_valid_currency(to_c):
        print("잘못된 통화 코드예요.")
        return 1

    result = convert(amount, from_c, to_c)
    print(format_amount(result, to_c))
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

cli.py를 보세요. 맨 위에서 `from vigilante import convert, format_amount, is_valid_currency`라고 현관에서 바로 가져와요. 방금 만든 `__init__.py` 현관 덕분에 짧게 가져오죠. main 함수는 sys.argv로 명령행 인자를 받아요(H4에서 본 sys예요). `vigilante 50 USD KRW`라고 치면, 50·USD·KRW가 argv에 들어오죠. 인자 개수를 확인하고, 통화가 유효한지 검증하고(validators 사용), 변환해서(exchange 사용), 보기 좋게 출력해요(utils 사용). 다섯 모듈이 여기서 한데 어우러져요.

맨 아래 `if __name__ == "__main__": sys.exit(main())`을 보세요. H2에서 깊이 판 그 관용구예요. 이 파일을 직접 실행하면 main이 돌고, import하면 안 돌죠. 그리고 `sys.exit(main())`은 main이 돌려준 값(0=성공, 1=실패)을 프로그램 종료 코드로 내보내요. 성공이면 0, 실패면 1. 이게 제대로 된 CLI 프로그램의 예의예요.

왜 종료 코드가 중요할까요? 터미널 세계의 약속이거든요. 0은 "성공", 0이 아니면 "실패"예요. 본인이 만든 vigilante를 다른 스크립트가 불러 쓸 때, 이 종료 코드를 보고 "성공했나, 실패했나"를 판단해요. 예를 들어 `vigilante 50 USD KRW && echo "성공"`이라고 하면, 성공(종료 코드 0)일 때만 echo가 실행되죠. 그래서 main이 상황에 따라 0이나 1을 정확히 돌려주는 게 중요해요. 인자가 틀리면 1, 통화가 잘못되면 1, 다 잘되면 0. 이 작은 약속을 지키면, 본인 도구가 다른 도구와 잘 어울려요. Ch006에서 배운 "유닉스 도구들이 종료 코드로 대화한다"는 그 정신이에요. 본인 도구도 그 대화에 끼는 거죠.

main 함수의 흐름도 한 번 더 읽을게요. 인자 개수 확인(4개인가?) → 통화 검증(아는 통화인가?) → 변환 → 출력. 각 단계에서 문제가 있으면 바로 메시지를 찍고 1을 돌려줘요. 이게 "방어적으로 짠다"는 거예요. 사용자가 뭘 잘못 넣어도 프로그램이 우아하게 안내하고 멈추죠. Ch012에서 배운 "사고를 내다보는 눈"이 여기 녹아 있어요.

이제 신분증 pyproject.toml이에요.

```toml
# pyproject.toml
[project]
name = "vigilante"
version = "0.1.0"
description = "고양이 자경단 환율 도구"
requires-python = ">=3.10"

[project.scripts]
vigilante = "vigilante.cli:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

H3에서 배운 그대로예요. 이름·버전·설명·Python 버전을 적었어요. 핵심은 `[project.scripts]`예요. `vigilante = "vigilante.cli:main"`은 "vigilante라고 치면 vigilante 패키지 cli 모듈의 main을 실행하라"는 뜻이에요. 이 한 줄이 본인 도구를 진짜 터미널 명령어로 만들어요. H3에서 말한 그 부분이 여기서 실현돼요.

---

## 9. 작동 확인 — 본인의 첫 패키지가 깔린다

자, 다 만들었어요. 이제 설치하고 작동을 봐요. H3에서 배운 editable install이에요.

```bash
pip install -e .
```

`-e`는 editable이라고 했죠. 지금 이 폴더를 그대로 패키지로 설치하는 거예요. 코드를 고치면 바로 반영되고요. 이 한 줄로, 본인이 방금 만든 vigilante가 진짜 설치된 패키지가 돼요. 떨리죠? 이제 테스트해 봐요.

```bash
$ vigilante 50 USD KRW
65,000.00 KRW

$ python3 -c "from vigilante import convert; print(convert(50, 'USD', 'KRW'))"
65000.0
```

첫 줄을 보세요. 터미널에 그냥 `vigilante 50 USD KRW`라고 쳤더니, `65,000.00 KRW`가 나와요. 본인이 만든 패키지가 **진짜 명령어로** 작동하는 거예요! pyproject.toml의 scripts 덕분이죠. 둘째 줄은 Python 안에서 `from vigilante import convert`로 가져다 쓴 거예요. 현관(`__init__.py`)에서 바로 가져왔죠.

이게 오늘의 약속이 지켜진 순간이에요. **본인의 첫 패키지 vigilante가 만들어지고, 설치되고, 작동해요.** 30분 전엔 빈 폴더였는데, 지금은 명령어로 실행되는 진짜 패키지예요. 한 줄짜리 환율 계산기로 시작한 본인이, 여기까지 온 거예요. 잠깐 이 성취를 음미하세요. 정말 큰 한 걸음이에요.

여기서 editable install이 왜 마법인지 한 번 더 느껴 봐요. 지금 exchange.py를 열어서 convert 함수에 print 한 줄을 추가해 보세요. 그리고 다시 설치 안 하고 그냥 `vigilante 50 USD KRW`를 쳐 보면? 바뀐 코드가 바로 반영돼요. `-e`로 깔았기 때문에, 설치된 패키지가 실제로는 이 폴더를 가리키고 있거든요. 그래서 폴더의 코드를 고치면 즉시 반영되죠. 개발 중엔 이게 정말 편해요. 고치고 → 실행하고 → 또 고치고를 설치 과정 없이 반복할 수 있으니까요. 만약 `-e` 없이 그냥 `pip install .`로 깔았다면, 코드를 고칠 때마다 다시 설치해야 했을 거예요. 그래서 개발할 땐 늘 editable로 까는 거예요.

그리고 한 가지 더 확인해 볼 게 있어요. `pip list`를 쳐 보세요. 깔린 패키지 목록에 vigilante가 보일 거예요. 본인이 만든 게 requests나 pandas 같은 유명 패키지들과 나란히 목록에 올라온 거죠. 기분이 어때요? 본인이 이제 "패키지를 쓰는 사람"이자 "패키지를 만드는 사람"이 된 거예요. H1에서 약속한 두 갈래를 다 밟았어요.

---

## 10. 다섯 사고와 처방

만들다 보면 사고가 나요. 흔한 다섯 개와 처방을 알려드릴게요. 미리 알면 당황 안 해요.

**사고 1 — `__init__.py`를 깜빡했다.** vigilante 폴더에 `__init__.py`가 없으면, Python이 패키지로 못 알아봐서 import가 안 돼요. 처방: 빈 파일이라도 꼭 만드세요. 0~5분 단계에서 제일 먼저 한 게 이거였죠.

**사고 2 — circular import가 났다.** exchange가 validators를 가져오고 validators가 다시 exchange를 가져오면 서로 물려요. 처방: 공통 데이터(RATES)를 data.py로 빼서, 둘 다 거기서 가져오게 했죠. 그래서 우리 설계엔 처음부터 이 사고가 없어요. H2의 처방을 설계에 미리 녹인 거예요.

**사고 3 — relative import로 헷갈린다.** `from .data import RATES`처럼 점을 쓰다가 경로가 꼬여요. 처방: 우리는 처음부터 `from vigilante.data import RATES`라고 absolute로 썼죠. 명확하고 안 깨져요.

**사고 4 — 빌드가 실패한다.** pyproject.toml에 `[build-system]`이 없으면 설치가 안 돼요. 처방: hatchling 세 줄을 꼭 넣으세요. H3에서 "정해진 문구라 복사해 쓰라"고 한 그 부분이에요.

**사고 5 — editable install이 안 된다.** `pip install -e .`가 에러나면, 보통 venv에 안 들어가 있거나 pyproject.toml에 오타가 있어요. 처방: `(.venv)` 표시 확인하고, pyproject.toml을 다시 보세요. 대부분 사소한 오타예요.

이 다섯 사고는 첫 패키지를 만들 때 거의 다 한 번씩 겪어요. 그런데 우리 설계는 이미 처방을 품고 있어요(data.py 분리·absolute import·hatchling). 그래서 본인은 설계만 따라가도 사고를 피해요. 좋은 설계가 사고를 미리 막는 거예요.

특히 사고 2(circular import)를 한 번 더 강조할게요. 이건 첫 패키지에서 정말 흔한 사고거든요. 보통 어떻게 나냐면, exchange가 "검증도 필요하니까" validators를 가져오고, validators가 "변환도 참고해야 하니까" exchange를 가져오면서 둘이 물려요. 그럴 때 초보는 당황하죠. 그런데 우리가 §2에서 본 "한 방향 흐름" 원칙을 떠올리면 답이 보여요. 둘이 공통으로 필요로 하는 게 뭐죠? 데이터(RATES)예요. 그걸 data.py로 빼서 맨 아래 깔면, exchange도 validators도 data만 바라보고 서로는 안 봐요. 물림이 풀리죠. 그래서 circular import를 만나면 "둘이 공통으로 뭘 쓰지? 그걸 아래로 빼자"가 공식이에요. 오늘 설계가 그 공식을 처음부터 적용한 거고요.

---

## 11. AI 시대의 패키지 만들기

AI 시대에 패키지 만들기가 어떻게 달라졌는지 짚을게요.

AI한테 "환율 변환 패키지 구조 짜 줘" 하면, 오늘 우리가 만든 것과 비슷한 폴더 구조를 척 제안해 줘요. "cli.py도 추가해 줘" 하면 main 함수까지 써 주고요. 골격을 빠르게 세우는 데 AI가 정말 큰 도움이 돼요. 30분 걸린 걸 더 빨리 할 수도 있죠.

그런데 오늘 본인이 손으로 만들어 본 게 왜 중요할까요? AI가 짜 준 구조가 **좋은지 판단**하려면, 본인이 직접 만들어 본 경험이 있어야 하거든요. "왜 data.py를 따로 뺐지?"를 본인이 이해하고 있어야, AI가 그걸 안 빼고 circular import가 날 구조를 줬을 때 "아, 이건 공통 데이터를 빼야겠다" 하고 고칠 수 있어요. 만들어 본 사람만이 평가할 수 있어요.

그래서 80/20이에요. AI가 80%(골격 생성·반복 코드)를 하고, 본인이 20%(구조가 맞나, 모듈 분리가 적절한가 판단)를 해요. 오늘 30분의 경험이 그 20%의 밑천이에요. 손으로 한 번 만들어 본 사람은, AI를 부려서 열 개를 만들 수 있어요. 안 만들어 본 사람은 AI가 준 걸 그대로 받을 수밖에 없고요. 오늘의 데모가 본인을 "AI를 부리는 사람"으로 만드는 밑돌이에요.

구체적인 장면을 하나 그려 볼게요. 본인이 AI한테 "결제 패키지 만들어 줘" 한다고 해 봐요. AI가 코드를 좍 뱉어내요. 그런데 오늘 데모를 해 본 본인은 그 코드를 받자마자 체크할 수 있어요. "data 같은 공통 부분이 따로 빠져 있나? circular import는 없나? `__init__.py`에 공개 API가 잘 모여 있나? cli에 `if __name__` 관용구가 있나? 종료 코드를 제대로 돌려주나?" 이 체크리스트가 오늘 손으로 만들며 생긴 거예요. 데모를 안 해 본 사람한텐 그냥 글자의 나열이지만, 해 본 본인한텐 평가할 수 있는 구조물로 보여요. 같은 AI 출력을 보고도, 만들어 본 사람과 아닌 사람이 이렇게 갈려요.

---

## 12. 자주 받는 질문 일곱 가지

**Q1. 꼭 여섯 모듈로 나눠야 하나요?**

아니요. 일의 크기에 맞게요. 작으면 한두 모듈로 충분하고, 커지면 더 나눠요. 오늘은 "나누는 법"을 보여주려고 여섯으로 했어요. 중요한 건 개수가 아니라 "역할별로 나눈다"는 원칙이에요.

**Q2. PyPI에 안 올려도 패키지인가요?**

네! 오늘 우리는 `pip install -e .`로 내 컴퓨터에만 설치했어요. PyPI에 안 올려도 완전한 패키지예요. PyPI 공개는 "남들도 쓰게 할 때"만 하는 추가 단계예요. 대부분의 패키지는 회사 안에서만 쓰여요.

**Q3. data.py를 왜 따로 뺐어요?**

공통으로 쓰는 데이터라서요. exchange와 validators가 둘 다 RATES를 쓰는데, 한 곳(data.py)에 두면 circular import도 막고 관리도 쉬워요. "여러 모듈이 함께 쓰는 건 따로 뺀다"가 원칙이에요.

**Q4. `__init__.py`에 꼭 코드를 넣어야 하나요?**

아니요. 빈 파일이어도 패키지는 돼요. 다만 오늘처럼 공개 API를 모아 두면, 사용자가 짧게 import할 수 있어 편해요. 처음엔 비워 두고, 자라면 현관을 채우면 돼요.

**Q5. cli.py 없이 라이브러리만 만들면 안 되나요?**

돼요. 명령어로 실행할 일이 없으면 cli.py를 안 만들어도 돼요. 그냥 import해서 쓰는 라이브러리면 충분하죠. cli.py는 "터미널 명령어로도 쓰고 싶을 때"만 추가해요.

**Q6. 만들고 나서 코드를 고치면 다시 설치해야 하나요?**

아니요! 그게 editable install(`pip install -e .`)의 마법이에요. 폴더를 그대로 가리키니, 코드를 고치면 바로 반영돼요. 개발 중엔 editable로 깔아 두고 마음껏 고치세요.

**Q7. 30분 만에 다 외울 수 있을까요?**

외우는 게 아니에요. 오늘은 흐름을 한 번 따라가 본 거예요. 폴더 만들고 → 모듈 채우고 → 현관 만들고 → 신분증 쓰고 → 설치. 이 순서를 두세 번 직접 해 보면 몸에 배요. 한 번에 외우려 하지 말고, 손으로 반복하세요.

---

## 13. 흔한 오해 다섯 가지

**오해 1: 패키지는 PyPI에 올려야 진짜다.**

아니에요. 내 컴퓨터에 editable로 깐 것도 완전한 패키지예요. PyPI 공개는 선택이에요.

**오해 2: 한 모듈(파일 하나)로도 충분하다.**

작을 땐 맞아요. 하지만 500줄을 넘으면 찾기 힘들어져요. 그때가 나눌 때예요. 오늘 배운 게 그 나누는 법이에요.

**오해 3: `__all__`은 항상 정의해야 한다.**

`import *`를 안 쓰면 옵션이에요. 다만 공개 메뉴를 명시하는 문서 역할로 두면 좋아요.

**오해 4: cli.py는 필수다.**

아니에요. 명령어로 실행할 게 없으면 라이브러리만으로 충분해요. cli는 필요할 때만요.

**오해 5: pyproject.toml은 어렵다.**

오늘 본 건 열 줄 남짓이에요. 기본 틀만 알면 돼요. 어렵게 생각 말고, 한 번 써 보면 구조가 손에 들어와요.

---

## 14. 흔한 실수 다섯 + 안심

첫째, `__init__.py`를 깜빡해서 import가 안 되는 실수예요. 안심하세요 — 빈 파일이라도 제일 먼저 만드는 습관이면 됩니다.

둘째, 공통 데이터를 안 빼서 circular import를 내는 실수예요. 안심하세요 — data.py로 빼는 설계 하나면 평생 안 만나요.

셋째, relative import로 경로를 꼬는 실수예요. 안심하세요 — absolute로 통일하면 깔끔합니다.

넷째, pyproject.toml을 어렵게 여겨 미루는 실수예요. 안심하세요 — 열 줄로 시작하면 됩니다.

다섯째, 가장 흔한 — venv 안 들어가고 `pip install -e .` 하다 꼬이는 실수예요. 안심하세요 — `(.venv)` 표시만 확인하면 됩니다.

이 다섯 함정을 미리 알아 둔 본인은, 앞으로 두 해 동안 한 박자 빠르게 가요. 그리고 오늘 우리 설계가 이미 함정 대부분을 피하게 짜여 있어요. 좋은 설계의 힘이에요.

---

## 15. 마무리

자, 다섯 번째 시간 끝났어요. 오늘 본인은 진짜 패키지를 만들었어요. vigilante — 여섯 모듈(data·exchange·validators·utils·cli·`__init__`)에 pyproject.toml까지, 30분 만에요. 그리고 `pip install -e .`로 설치해서, `vigilante 50 USD KRW`가 터미널에서 작동하는 걸 봤죠.

오늘의 약속을 지켰어요. **본인의 첫 패키지가 만들어지고 깔렸어요.** 이건 단순한 코드 연습이 아니에요. H1~H4에서 배운 모든 게 한자리에 모인 거예요. 모듈 분리(H1), absolute import와 `__init__.py`와 `__name__`(H2), venv와 pyproject와 editable install(H3), 표준 라이브러리 모듈들(H4)이 다 이 하나의 패키지 안에서 살아 움직였어요. 개념이 진짜가 되는 순간을 본인이 직접 만든 거예요.

기억하세요. 이 vigilante는 씨앗이에요. 오늘은 100줄짜리지만, 여기에 기능을 더하고(함수 추가), 테스트를 붙이고(Ch022), 더 나뉘면 진짜 프로젝트가 돼요. H1에서 그린 "file_processor → 모듈 → 패키지 → PyPI"의 길, 오늘 그 패키지 단계를 본인 손으로 밟은 거예요. 다음은 이 패키지를 잘 굴리는 법이에요.

다음 H6에서는 운영으로 가요. 패키지를 만들었으니, 이제 잘 굴려야죠. 의존성을 관리하고, circular import 같은 함정을 진짜로 다루고, 버전을 올리는 법을 배워요. 만드는 것과 굴리는 건 다른 기술이거든요. 오늘 만든 vigilante를, 다음 시간엔 튼튼하게 운영해요.

졸업 과제예요. 오늘 본 흐름을 본인 컴퓨터에서 처음부터 끝까지 한 번 해 보세요.

```bash
pip install -e .
vigilante 50 USD KRW
```

본인이 만든 패키지가 명령어로 작동하는 걸 직접 보면, 오늘 수업은 대성공이에요. 그 짜릿함을 꼭 느껴 보세요. 수고했어요. H6에서 만나요. 🐾

---

## 👨‍💻 개발자 노트

> - **설계 원칙**: 한 일을 역할별 모듈로. data·exchange·validators·utils·cli + `__init__`.
> - **data.py 분리**: 공통 데이터를 맨 밑에. circular import를 설계로 예방.
> - **absolute import**: `from vigilante.data import RATES`. 명확하고 안 깨짐.
> - **`__init__.py` 현관**: 공개 API를 모아 `from vigilante import convert`로 짧게.
> - **`__version__`·`__all__`**: 버전과 공개 메뉴. H2 개념의 실현.
> - **cli.py**: `if __name__ == "__main__": sys.exit(main())` + sys.argv.
> - **pyproject.toml**: `[project.scripts]`로 명령어 등록. hatchling 빌드.
> - **editable install**: `pip install -e .` — 폴더를 그대로 가리켜 고치면 바로 반영.
> - 다음 H6 키워드: 의존성 관리 · circular import 실전 · 버전 올리기 · 측정.

---

## 추신

1. 오늘은 머리로 배운 걸 손으로 옮긴 날이에요. 읽기와 만들기는 완전히 다른 차원의 배움이에요.
2. 30분을 5분씩 여섯 토막으로. 토막마다 하나씩 쌓으면 큰 것도 안 무서워요.
3. 환율 계산이라는 한 가지 일을, 역할별 여섯 모듈로 나눴어요. H1의 실천이죠.
4. data.py를 맨 밑에, 맨 먼저. 공통 데이터를 한곳에 모아요.
5. 그래서 circular import가 처음부터 안 생겨요. 설계로 막은 거예요.
6. exchange.py는 핵심 기능. `from vigilante.data import RATES`로 absolute import.
7. validators.py는 검증 + CurrencyError 예외. Ch012 예외가 여기 살아나요.
8. 한 모듈은 한 가지 일. 검증은 검증대로, 변환은 변환대로 나눠요.
9. utils.py는 순수 도우미. format(컴퓨터→사람)·parse(사람→컴퓨터) 한 쌍.
10. utils에 아무거나 넣지 마세요. 잡동사니 서랍 되면 곤란해요.
11. `__init__.py`는 현관. 공개 API를 모아 짧은 import를 만들어요.
12. 현관 덕에 `from vigilante import convert`. 안쪽 구조를 숨겨 줘요.
13. `__version__ = "0.1.0"` — 첫 버전. `__all__`은 공개 메뉴판.
14. cli.py 맨 아래 `if __name__ == "__main__"` — H2의 그 관용구예요.
15. `sys.exit(main())` — 성공 0, 실패 1을 종료 코드로 내보내요.
16. pyproject.toml `[project.scripts]` 한 줄이 도구를 명령어로 만들어요.
17. `pip install -e .` — editable 설치. 본인의 첫 패키지가 깔리는 순간.
18. `vigilante 50 USD KRW` → `65,000.00 KRW`. 명령어로 작동해요!
19. PyPI에 안 올려도 완전한 패키지예요. local editable도 진짜예요.
20. 사고 1: `__init__.py` 누락. 처방: 빈 파일이라도 먼저.
21. 사고 2: circular import. 처방: 공통 데이터를 data.py로.
22. 사고 3: relative 꼬임. 처방: absolute로 통일.
23. 사고 4: 빌드 실패. 처방: `[build-system]` hatchling 세 줄.
24. 사고 5: editable 안 됨. 처방: `(.venv)` 확인 + pyproject 오타 점검.
25. 좋은 설계는 사고를 미리 막아요. 우리 설계가 그래요.
26. AI는 골격을 빠르게 짜요. 그게 좋은지 판단은 만들어 본 본인 몫이에요.
27. 오늘 30분의 경험이, AI를 부리는 20%의 밑천이에요.
28. vigilante는 씨앗이에요. 기능·테스트를 더하면 진짜 프로젝트로 자라요.
29. 다음 H6은 운영. 만드는 것과 굴리는 건 다른 기술이에요.
30. 오늘도 한 걸음. 빈 폴더에서 시작해 작동하는 패키지까지, 본인의 첫 패키지를 손으로 빚었어요. 정말 잘했어요. 🐾
