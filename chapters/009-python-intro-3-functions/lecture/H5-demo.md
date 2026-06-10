# Ch009 · H5 — 환율 계산기 v3 30분 — decorator·closure·@property 적용

> 고양이 자경단 · Ch 009 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. v2 → v3 진화 표
3. 0~5분 — @timer 데코레이터 (본인의 첫 데코레이터)
4. 5~10분 — @validate 데코레이터
5. 10~15분 — closure로 RateProvider
6. 15~20분 — @dataclass와 @property
7. 20~25분 — partial과 lru_cache
8. 25~30분 — 실행과 검증
9. v2 vs v3 다섯 차이
10. 다섯 사고와 처방
11. 흔한 오해 다섯 가지
12. 흔한 실수 다섯 + 안심
13. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
from functools import wraps, lru_cache, partial
from dataclasses import dataclass, field
from datetime import datetime

def timer(func):                  # 본인의 첫 데코레이터
    @wraps(func)
    def wrapper(*args, **kwargs):
        ...
    return wrapper
```

```bash
python3 exchange_v3.py
black exchange_v3.py && ruff check exchange_v3.py
```

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다시 만났어요. 함수 챕터의 다섯 번째 시간, 드디어 데모예요. 오늘은 강의를 듣기만 하는 게 아니라, 본인이 손으로 따라 치는 시간이에요. 키보드 앞에 앉으세요.

지난 H4를 한 줄로 회수할게요. 본인은 함수 18 도구를 카탈로그로 구경했어요. functools, decorator 패턴, 검사, 비동기 네 무리요. @dataclass, @property, lru_cache, partial 같은 이름들을 만났죠. 그런데 카탈로그는 구경이었어요. 오늘은 그걸 손으로 써요.

이번 H5는 본인의 환율 계산기를 또 키우는 시간이에요. Ch007 H5에서 v1 50줄, Ch008 H5에서 v2 150줄을 만들었죠. 오늘은 v3예요. 200줄로 자라요. 그런데 단순히 길어지는 게 아니라, 오늘 챕터에서 배운 함수 도구들을 다 적용해요. 데코레이터를 직접 짜고, closure를 쓰고, @dataclass와 @property로 결과를 객체로 만들어요.

오늘의 약속은 이거예요. **본인의 첫 데코레이터 두 개와 첫 closure가 동작합니다**. 이게 H1부터 걸어온 약속이에요. H1에서 "이 챕터 끝에 데코레이터를 짠다"고 했고, H2에서 "closure가 데코레이터의 토대"라고 했죠. 오늘 그 약속이 본인 손에서 이뤄져요. 30분 동안 한 줄씩 같이 쳐요. 다 치고 나면, 본인은 "데코레이터를 짜 본 사람"이 돼요. 그건 큰 일이에요. 많은 사람이 데코레이터를 무서워하거든요. 본인은 오늘 그 벽을 넘어요.

데모 시간을 어떻게 들으면 좋은지 한 가지만 말할게요. 절대 눈으로만 따라오지 마세요. 진짜로 키보드를 두드리세요. 강의를 멈추고, exchange_v3.py라는 빈 파일을 열고, 제가 치는 걸 한 줄씩 따라 치세요. 오타가 나도 좋아요. 오히려 오타가 나면 에러를 보고, 그걸 고치면서 더 배워요. 데모의 가치는 "보는 것"이 아니라 "손가락이 기억하는 것"이에요. 데코레이터를 눈으로 백 번 본 사람보다, 손으로 한 번 친 사람이 데코레이터를 짤 줄 알아요. 손가락에는 별도의 기억이 있거든요. 자전거 타는 법을 머리로 외우는 게 아니라 몸이 기억하듯이요. 그러니 오늘 30분은 본인 손가락에 데코레이터를 새기는 시간이에요. 천천히 가도 좋으니, 꼭 직접 치세요. 다 치고 나서 본인 화면에 [TIMER]가 찍히는 순간의 그 기쁨이, 오늘의 진짜 선물이에요. 자, 가요.

---

## 2. v2 → v3 진화 표

먼저 v2에서 v3로 뭐가 달라지는지 표로 볼게요.

| 항목 | v2 (Ch008) | v3 (Ch009) |
|------|-----------|-----------|
| 줄 수 | 150 | 200 |
| 데코레이터 | 0 | 3 (@timer·@validate·@lru_cache) |
| closure | 0 | 1 (RateProvider) |
| @property | 0 | 2 |
| @dataclass | 0 | 1 (Conversion) |
| 18 도구 적용 | 5 | 13 |

보세요. 줄 수는 50줄밖에 안 늘었는데, 안에 들어간 함수 기술이 확 늘었죠. 데코레이터 셋, closure 하나, property 둘, dataclass 하나. 이게 v2와 v3의 진짜 차이예요. v2가 "흐름으로 동작하는 프로그램"이었다면, v3는 "함수 기술로 우아해진 프로그램"이에요. 같은 일을 하는데 더 깔끔하고, 더 재사용 가능하고, 더 측정 가능해요.

오늘 30분의 흐름을 미리 한눈에 보여 줄게요. 0~5분에 @timer 데코레이터를 짜고, 5~10분에 @validate 데코레이터를 더하고, 10~15분에 RateProvider closure를 만들고, 15~20분에 @dataclass와 @property로 결과 객체를 빚고, 20~25분에 partial과 lru_cache를 적용하고, 25~30분에 다 합쳐 실행해요. 데코레이터로 시작해서 closure를 거쳐 객체와 캐싱으로 끝나는 거죠. 오늘 챕터에서 배운 함수 기술이 이 30분에 다 모여요. H2의 개념, H4의 도구가 여기서 실전이 되는 거예요. 그러니 이 30분은 함수 챕터의 클라이맥스예요. 자, 5분씩 끊어서 하나씩 만들어요.

---

## 3. 0~5분 — @timer 데코레이터 (본인의 첫 데코레이터)

첫 5분. 본인의 첫 데코레이터를 짜요. 이름은 `@timer`, 함수의 실행 시간을 자동으로 재 주는 데코레이터예요. H2에서 봤던 그거예요. 이번엔 본인 손으로 쳐요. 긴장하지 마세요. 데코레이터는 정해진 모양이 있어서, 그 틀만 외우면 누구나 짜요. "func를 받아서, 안에 wrapper를 만들고, wrapper를 돌려준다." 이 세 줄 골격이 모든 데코레이터의 뼈대예요. 그 안만 상황에 맞게 채우면 되죠. @timer는 그 안에 시간 재는 코드를, @validate는 검증 코드를 넣는 거예요. 골격은 똑같고 속만 달라요. 그러니 첫 데코레이터를 짜는 게 두 번째, 세 번째보다 어려운 거지, 한 번 골격을 손에 익히면 그 다음은 술술이에요.

```python
import time
from functools import wraps

def timer(func):
    """함수 실행 시간 측정."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        elapsed = time.time() - start
        print(f"[TIMER] {func.__name__}: {elapsed*1000:.2f}ms")
        return result
    return wrapper

@timer
def slow_calc(n):
    time.sleep(0.1)
    return n * 2

slow_calc(5)
# [TIMER] slow_calc: 100.23ms
```

한 줄씩 읽을게요. `timer`는 함수(func)를 받아요. 안에서 `wrapper`라는 함수를 만들어 돌려주죠. 이게 H2에서 본 closure예요. wrapper가 바깥의 func를 기억하잖아요. wrapper 안에서는 시작 시간을 재고(`start`), 원래 함수를 실행하고(`result = func(...)`), 끝나고 걸린 시간을 계산해서(`elapsed`) 출력해요. 그리고 결과를 그대로 돌려주죠. 핵심은 "원래 함수는 하나도 안 건드리고, 그 앞뒤로 시간 재는 코드만 덧붙인다"예요.

`@wraps(func)` 이 한 줄, H4에서 강조한 거예요. 안 붙이면 `func.__name__`이 wrapper로 바뀌어 버려요. 그러면 출력에 "slow_calc" 대신 "wrapper"가 나오죠. 꼭 붙이세요.

그리고 `@timer`를 `slow_calc` 위에 붙이는 순간, 본인의 첫 데코레이터가 동작해요. `slow_calc(5)`를 부르면, 결과(10)와 함께 "[TIMER] slow_calc: 100.23ms"가 찍혀요. 본인이 slow_calc 안에는 시간 재는 코드를 한 줄도 안 넣었는데, @timer 한 줄이 그걸 다 해 준 거예요. 이게 데코레이터의 힘이에요. 자, 축하해요. 본인의 첫 데코레이터가 동작했어요. 오늘의 약속 절반을 벌써 지켰어요.

여기서 데코레이터의 진짜 가치를 한 번 짚을게요. 만약 데코레이터가 없다면, 본인이 시간을 재고 싶은 함수마다 안에 start = time.time() 어쩌고를 일일이 넣어야 해요. 함수 100개의 시간을 재고 싶으면 100곳에 같은 코드를 복붙해야 하죠. H2에서 본 복붙 지옥이에요. 그런데 데코레이터는 그 "시간 재는 일"을 한 곳(timer 함수)에 모아 두고, `@timer` 한 줄만 붙이면 어느 함수든 시간이 재져요. 100개 함수면 @timer 100줄만 붙이면 돼요. 그리고 시간 재는 방식을 바꾸고 싶으면? timer 함수 한 곳만 고치면 100개 함수가 다 바뀌어요. 이게 H1에서 배운 "재사용"의 데코레이터 버전이에요. 데코레이터는 "여러 함수에 공통으로 덧붙일 기능"을 한 곳에 모으는 도구예요. 로깅, 시간 측정, 인증, 캐싱 같은 게 다 그런 공통 기능이죠. 그래서 자경단의 모든 API 함수 위에는 보통 데코레이터가 두세 개씩 얹혀 있어요. 본인이 오늘 그 첫 발을 뗀 거예요.

그리고 `*args, **kwargs`가 왜 wrapper에 꼭 필요한지도 보여요. @timer는 어떤 함수에든 붙을 수 있어야 하잖아요. 인자가 하나인 함수, 셋인 함수, 키워드 인자를 받는 함수… 그 모든 경우를 다 받아 넘기려면 `wrapper(*args, **kwargs)`여야 해요. "어떤 인자가 오든 다 받아서 원래 함수에 그대로 전달"하는 거죠. H2에서 \*args·\*\*kwargs를 배울 때 "데코레이터에서 핵심"이라고 한 게 이거예요. 만약 wrapper를 `wrapper(n)`처럼 인자 하나로 고정하면, 인자 둘인 함수엔 못 붙여요. 그래서 데코레이터의 wrapper는 거의 항상 `*args, **kwargs`예요. 이 패턴을 통째로 외워 두세요. 데코레이터 짤 때 항상 나와요.

---

## 4. 5~10분 — @validate 데코레이터

다음 5분. 두 번째 데코레이터, `@validate`예요. 함수에 넘어온 통화가 진짜 아는 통화인지 자동으로 검증해 줘요.

```python
def validate(func):
    """인자가 valid 통화인지 검증."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        for arg in args:
            if isinstance(arg, str) and arg.upper() not in RATES:
                raise ValueError(f"모르는 통화: {arg}")
        return func(*args, **kwargs)
    return wrapper

@validate
def convert(amount, from_curr, to_curr):
    ...
```

구조는 @timer와 똑같죠? func를 받고, wrapper를 만들어 돌려줘요. 다른 건 wrapper 안의 내용이에요. 넘어온 인자 중에 문자열이 있으면, 그게 RATES(환율 딕셔너리)에 있는 통화인지 확인해요. 없으면 `raise ValueError`로 막아요. 있으면 통과시켜서 원래 함수를 실행하고요. 이게 H2에서 배운 guard clause의 데코레이터 버전이에요. "잘못된 입력을 입구에서 막는다"를 데코레이터로 자동화한 거죠.

그리고 데코레이터의 진짜 멋진 점. 쌓을 수 있어요.

```python
@timer
@validate
def convert(amount, from_curr, to_curr):
    ...
```

`@timer`와 `@validate`를 둘 다 붙였어요. 그러면 convert는 시간도 재지고, 검증도 돼요. 적용 순서는 아래에서 위로 감싸요. validate가 먼저 convert를 감싸고, 그 위를 timer가 감싸죠. 그래서 실행될 땐 timer가 시작 시간 재고 → validate가 검증하고 → convert가 실행돼요. 데코레이터를 레고처럼 쌓아서 기능을 조립하는 거예요. H4 FAQ에서 본 "데코레이터 여러 개"가 이거예요. 본인은 이제 두 번째 데코레이터까지 짰어요. 오늘의 약속, 데코레이터 두 개가 동작했어요. @timer는 첫 데코의 골격을 봤고, @validate에서 같은 골격에 속만 바꿔 봤죠. 골격이 손에 익는 게 본인도 느껴지죠.

이 "기능을 조립한다"는 게 데코레이터의 가장 우아한 점이에요. 생각해 보세요. convert라는 함수 본문은 "환율 계산"이라는 한 가지 일만 해요. 깨끗하죠. 그런데 실전에선 그 함수에 시간 측정도, 입력 검증도, 캐싱도, 로깅도 필요해요. 만약 이걸 다 convert 안에 넣으면, convert는 환율 계산보다 그 부수적인 일로 더 지저분해져요. 본 일이 뭔지 안 보이죠. 데코레이터는 그 부수적인 일들을 함수 본문 밖으로 빼서, 골뱅이로 얹어요. `@timer @validate @cache def convert`처럼요. 그러면 convert 본문은 환율 계산만 깨끗하게 하고, 부수 기능들은 위에 레고처럼 쌓이죠. 본 일과 부수 일이 분리되는 거예요. 이게 H6에서 배울 "관심사의 분리"라는 중요한 원칙이에요. 데코레이터가 그걸 우아하게 해 줘요. 본인이 자경단 백엔드 코드를 보면, 함수 위에 데코레이터가 탑처럼 쌓여 있는 걸 자주 봐요. 그게 지저분한 게 아니라, 오히려 본 일과 부수 일을 깔끔하게 나눈 거예요.

---

## 5. 10~15분 — closure로 RateProvider

이제 closure예요. 환율을 관리하는 RateProvider를 closure로 만들어요. 오늘의 약속 나머지 절반, 첫 closure예요.

```python
def make_rate_provider(initial_rates):
    """환율 제공자. 시간 기반 캐시."""
    rates = dict(initial_rates)
    last_update = time.time()

    def get_rate(currency):
        nonlocal last_update
        # 1시간 지나면 갱신
        if time.time() - last_update > 3600:
            print("[갱신] 환율 다시 fetch")
            last_update = time.time()
        return rates.get(currency)

    def update_rate(currency, rate):
        nonlocal last_update
        rates[currency] = rate
        last_update = time.time()

    return get_rate, update_rate

get_rate, update_rate = make_rate_provider(RATES)
print(get_rate("USD"))   # 1300.0
update_rate("USD", 1350.0)
print(get_rate("USD"))   # 1350.0
```

이게 H2에서 본 make_counter의 진짜 활용 버전이에요. `make_rate_provider`는 안에 `rates`(환율 딕셔너리)와 `last_update`(마지막 갱신 시간)를 두고, 그걸 다루는 함수 두 개(`get_rate`, `update_rate`)를 만들어 돌려줘요. 그 두 함수가 바깥의 rates와 last_update를 기억해요. 이게 closure죠. H2에서 말한 "cell 상자에 담아 들고 다니는" 그거예요.

핵심은 마지막 줄의 주석이에요. "캡슐화." rates는 closure 안에 갇혀 있어서, 밖에서 `rates["USD"] = 9999`처럼 함부로 못 건드려요. 오직 `update_rate`라는 정해진 문으로만 바꿀 수 있죠. 이게 좋은 거예요. 데이터를 아무나 못 건드리게 하고, 정해진 함수로만 다루게 하는 것. 환율 같은 중요한 데이터일수록 이렇게 보호해야 해요. 누가 실수로 환율을 0으로 만들면 큰일이잖아요. closure가 그 보호막이 돼요. 본인의 첫 closure가 동작했어요. 자, 오늘의 약속 다 지켰어요. 데코레이터 둘, closure 하나. 박수.

그리고 이 RateProvider는 closure의 진짜 실전 패턴을 보여줘요. "상태를 가진 함수"를 만드는 거예요. 보통 함수는 부를 때마다 백지에서 시작해요. 기억이 없죠. 그런데 이 get_rate는 rates와 last_update를 기억해요. 마지막으로 언제 갱신했는지를 알고, 1시간이 지나면 알아서 새로 가져와요. 함수인데 기억을 가진 거예요. 이게 closure만 할 수 있는 일이에요. H2의 make_counter가 count를 기억해서 1, 2, 3 셌던 것처럼, RateProvider는 환율과 시간을 기억하죠. 나중에 본인이 "호출 횟수를 세는 함수", "마지막 결과를 기억하는 함수", "설정을 품은 함수" 같은 걸 만들 때 다 이 closure 패턴이에요. 사실 이건 Ch011에서 배울 "객체(클래스)"와 사촌이에요. 객체도 "데이터를 품은 것"이거든요. closure는 작고 가벼운 객체라고 볼 수 있어요. 그래서 closure를 이해하면 Ch011 클래스도 쉬워져요. 오늘 본인이 그 다리를 하나 놓은 거예요.

---

## 6. 15~20분 — @dataclass와 @property

이제 H4에서 본 @dataclass와 @property를 써요. 환산 결과를 예쁜 객체로 만들어요.

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class Conversion:
    """환산 결과 객체."""
    amount: float
    from_curr: str
    to_curr: str
    result: float
    timestamp: datetime = field(default_factory=datetime.now)

    @property
    def rate(self) -> float:
        """환율 = 결과 / 원금."""
        return self.result / self.amount

    @property
    def formatted(self) -> str:
        """예쁜 출력."""
        return f"{self.amount} {self.from_curr} = {self.result:.2f} {self.to_curr}"

c = Conversion(50.0, "USD", "KRW", 65000.0)
print(c.formatted)
print(c.rate)   # 1300.0
```

`@dataclass` 한 줄이 amount·from_curr·to_curr·result를 받는 `__init__`을 자동으로 만들어 줘요. 본인은 필드 이름만 적었는데 완전한 클래스가 생겼죠. 만약 dataclass 없이 이걸 손으로 짠다면, `def __init__(self, amount, from_curr, to_curr, result):` 하고 그 안에 `self.amount = amount` 같은 줄을 네 번 적고, 또 출력용 `__repr__`을 적고… 열다섯 줄은 됐을 거예요. 그걸 `@dataclass` 한 줄이 다 대신해 준 거죠. 손가락이 편한 만큼, 실수할 자리도 줄어요. `timestamp`는 H5에서 처음 보는 `field(default_factory=datetime.now)`인데, 이게 H2에서 배운 mutable default 함정의 처방이에요. 매번 새 시간을 만들려고 default_factory를 쓰는 거예요. 그냥 `= datetime.now()`로 하면 클래스 정의 때의 시간이 고정돼 버리거든요. H2의 함정이 여기서 살아 있죠.

그리고 `@property` 두 개. `rate`는 환율을 계산해서 속성처럼 보여주고, `formatted`는 예쁜 문자열을 만들어요. `c.rate()`가 아니라 `c.rate`로 부르죠. 괄호가 없어요. 계산이 필요한 값인데도 그냥 속성처럼 깔끔하게 꺼내요. H4에서 본 property의 진짜 활용이에요. 환산 결과가 이제 그냥 숫자가 아니라, 자기 환율도 알고 예쁘게 출력도 할 줄 아는 똑똑한 객체가 됐어요.

여기서 v2와 비교하면 진화가 확 보여요. v2에서는 환산 결과가 그냥 숫자 65000.0이었어요. 그 숫자만 봐서는 "이게 뭘 뭘로 바꾼 거지? 환율은 얼마였지? 언제 한 거지?"를 알 수가 없죠. 결과를 함수에서 함수로 넘길 때마다 amount, from_curr, result를 따로따로 들고 다녀야 했어요. 그런데 v3의 Conversion 객체는 그 모든 걸 하나로 묶어요. amount도, 통화도, 결과도, 시간도, 환율 계산도, 예쁜 출력도 다 한 객체 안에 들어 있죠. 이제 `c` 하나만 넘기면 그 안에 다 있어요. 데이터를 흩어진 변수가 아니라 "의미 있는 한 덩어리"로 다루는 거예요. 이게 프로그램이 커질 때 정말 중요해져요. 변수 다섯 개를 따로 들고 다니는 코드와, 객체 하나로 묶어 다니는 코드는 복잡도가 천지차이거든요. 본인은 오늘 그 "묶는" 기술을 배운 거예요. 이게 Ch011 객체지향으로 가는 다리이기도 해요. dataclass는 사실 가벼운 클래스니까요.

---

## 7. 20~25분 — partial과 lru_cache

이제 partial과 lru_cache를 써요. H4에서 본 functools 도구들이에요.

```python
from functools import partial, lru_cache

# partial — 자경단 다섯 명 환산을 부분 함수로
to_krw = partial(convert, from_curr="USD", to_curr="KRW")
to_jpy = partial(convert, from_curr="USD", to_curr="JPY")

print(to_krw(50))   # 65000.0
print(to_jpy(50))   # 7222.22

# lru_cache — 같은 인자 결과 캐싱
@lru_cache(maxsize=128)
def expensive_convert(amount: float, from_curr: str, to_curr: str) -> float:
    print(f"[CALC] {amount} {from_curr}→{to_curr}")
    return convert(amount, from_curr, to_curr)

expensive_convert(50, "USD", "KRW")  # [CALC] 50 USD→KRW
expensive_convert(50, "USD", "KRW")  # 캐시에서, [CALC] 안 뜸
```

`partial`로 `to_krw`와 `to_jpy`라는 전용 함수를 만들었어요. convert에서 from_curr·to_curr를 미리 고정한 거죠. 이제 `to_krw(50)`처럼 금액만 넘기면 돼요. 자경단 다섯 명이 매번 USD→KRW를 환산한다면, to_krw 하나 만들어 두고 다 같이 쓰는 거예요. H4에서 본 partial의 실전이죠. 매번 `convert(50, "USD", "KRW")`라고 길게 쓰는 것보다 `to_krw(50)`이 훨씬 짧고 읽기 좋잖아요. 자주 쓰는 조합일수록 이렇게 전용 함수로 만들어 두면 코드가 깔끔해져요.

`lru_cache`는 결과를 기억해요. `expensive_convert(50, "USD", "KRW")`를 처음 부르면 "[CALC]"가 찍히며 계산해요. 그런데 같은 인자로 또 부르면? "[CALC]"가 안 떠요. 캐시에서 바로 답을 꺼내거든요. 같은 환산을 백 번 해도 계산은 한 번이에요. H2·H4에서 본 lru_cache의 마법이 본인 코드에서 동작하는 거예요.

여기서 partial과 lru_cache가 둘 다 "함수를 곱하는" 도구라는 걸 짚고 싶어요. 무슨 말이냐면, 둘 다 기존 함수에서 새로운, 더 편한 함수를 만들어내거든요. partial은 convert에서 to_krw라는 더 짧은 함수를 만들고, lru_cache는 convert에서 "기억하는 convert"를 만들어요. 원래 함수는 그대로 두고, 거기에서 변형된 함수를 뽑아내는 거죠. 이게 H1에서 배운 "함수는 일급 객체"의 힘이에요. 함수가 값이니까, 함수를 받아서 새 함수를 만들 수 있는 거예요. partial(convert, ...)는 함수를 받아 함수를 돌려주고, lru_cache도 함수를 받아 함수를 돌려줘요. 사실 데코레이터도 그래요. timer(func)가 wrapper라는 새 함수를 돌려주죠. 오늘 본인이 쓴 도구들 — 데코레이터, partial, lru_cache — 이 다 "함수에서 함수를 만드는" 같은 가족이에요. 이 관점으로 보면, 오늘 배운 게 흩어진 도구가 아니라 한 원리의 여러 모습이라는 게 보여요. "함수를 값처럼 다뤄서, 함수에서 새 함수를 빚는다." 이게 함수형 프로그래밍의 핵심 정신이에요. 본인은 오늘 그 정신을 손으로 체험한 거예요.

---

## 8. 25~30분 — 실행과 검증

마지막 5분. 다 합쳐서 실행해요.

```bash
$ python3 exchange_v3.py

=== 환율 계산기 v3 ===

[TIMER] convert: 0.05ms
50 USD = 65,000.00 KRW

[CALC] 50 USD→KRW
[TIMER] expensive_convert: 0.12ms
50 USD = 65,000.00 KRW

[TIMER] expensive_convert: 0.01ms   # 캐시 사용
50 USD = 65,000.00 KRW
```

보세요. 다 동작해요. `[TIMER]`가 찍히는 건 @timer 데코레이터가 일하는 거고, `[CALC]`가 처음엔 뜨고 두 번째엔 안 뜨는 건 lru_cache가 일하는 거예요. 첫 expensive_convert는 0.12ms 걸렸는데, 캐시를 쓴 두 번째는 0.01ms예요. 열 배 넘게 빨라졌죠. 이 출력 한 화면에 본인이 오늘 배운 모든 게 동시에 일하는 모습이 담겨 있어요. 데코레이터도, 캐시도, 그게 다 본인이 짠 거예요. 본인이 오늘 짠 데코레이터, closure, dataclass, property, partial, lru_cache가 한 프로그램에서 다 같이 일하는 거예요. 이게 본인의 첫 v3예요.

여기서 잠깐 멈춰서 느껴 보세요. 30분 전 본인은 "데코레이터? 그게 뭔데?" 였어요. 지금 본인은 데코레이터 두 개를 짰고, 그게 본인 화면에서 동작해요. 30분 만에요. 이게 손으로 하는 것의 힘이에요. 강의 열 시간보다 직접 친 30분이 강해요. 본인 손가락이 이제 데코레이터를 기억하거든요.

만약 본인이 따라 치다가 에러가 났다면, 그것도 축하해요. 진심이에요. 에러는 본인이 진짜로 코드를 짰다는 증거거든요. 눈으로만 보는 사람은 에러를 안 만나요. 손으로 치는 사람만 에러를 만나고, 그 에러를 고치면서 진짜 실력이 늘어요. 가장 흔한 에러는 @wraps를 빠뜨려서 이름이 이상하게 나오거나, wrapper에서 return을 빼먹어서 결과가 None이 나오는 거예요. H3에서 배운 대로 에러 메시지의 마지막 줄을 읽고, 차근차근 고치세요. 그 고치는 과정이 오늘 데모의 진짜 알맹이예요. 본인이 에러를 한 번 만나고 고쳤다면, 본인은 그 에러를 평생 기억해요. 다음엔 안 틀리죠. 그렇게 한 땀 한 땀 본인 실력이 쌓여요. 그러니 에러가 났다고 좌절하지 마세요. 오히려 "오, 내가 진짜 짜고 있구나" 하고 반가워하세요.

---

## 9. v2 vs v3 다섯 차이

v2와 v3의 다섯 차이를 정리할게요.

**1. @timer.** 모든 함수의 실행 시간을 자동 측정. v2엔 없던 거예요. 골뱅이 한 줄이면 어느 함수든 시간이 재져요.

**2. @validate.** 인자를 자동 검증. guard clause를 데코레이터로. 잘못된 통화를 입구에서 막아요.

**3. closure RateProvider.** 환율을 캡슐화해서 보호. 정해진 문으로만 바꾸게.

**4. @dataclass + @property.** 결과를 똑똑한 객체로 표현. 흩어진 변수가 아니라 의미 있는 한 덩어리로.

**5. partial + lru_cache.** 함수를 곱해서 전용 함수를 만들고, 결과를 캐싱. 자주 쓰는 조합은 짧은 전용 함수로, 비싼 계산은 캐시로 처리해요.

이 다섯이 v3를 자경단 표준으로 끌어올려요. 그런데 중요한 건, 이게 "기능 추가"가 아니라 "같은 기능을 더 우아하게"라는 거예요. v3가 v2보다 새로운 일을 더 하는 건 아니에요. 똑같이 환율을 계산해요. 다만 더 깔끔하고, 더 측정 가능하고, 더 안전하게 하죠. 이게 성장이에요. 처음엔 "동작하게" 만들고, 그 다음엔 "우아하게" 다듬는 것. 본인은 지금 그 두 번째 단계를 배우고 있어요. H6에서 이 "우아하게"를 더 깊이 파요.

본인의 환율 계산기 진화 일지를 한 번 펼쳐 볼게요. Ch007 H5에서 v1 50줄 — 함수와 딕셔너리로 처음 만든 계산. Ch008 H5에서 v2 150줄 — 흐름(while·match·comprehension)으로 메뉴와 검증을 더한 진짜 프로그램. 그리고 오늘 Ch009 H5에서 v3 200줄 — 함수 기술(데코레이터·closure·dataclass)로 우아해진 버전. 세 챕터에 걸쳐 본인의 한 프로그램이 자란 거예요. 그리고 이게 끝이 아니에요. Ch041에서 v4로 자라요. 웹 API가 되어, 브라우저에서 환율을 계산할 수 있게 돼요. Ch091에서는 v5로, AWS에 올라가 진짜 서비스가 되고요. 본인의 환율 계산기 하나가 두 해 코스 내내 본인과 함께 자라는 동반자예요. 5년 후 본인이 이 git 히스토리를 보면, v1의 그 어설픈 50줄부터 v5의 5,000줄까지, 본인의 성장이 고스란히 남아 있을 거예요. 그게 어떤 졸업장보다 본인을 잘 증명해요. 오늘 v3 한 줄이 그 성장 일지의 한 페이지예요.

---

## 10. 다섯 사고와 처방

v3를 짜며 자주 만나는 다섯 사고와 처방이에요.

**사고 1: @wraps 누락.** 데코레이터 안 wrapper 위에 @wraps를 빼먹으면 함수 이름이 wrapper로 바뀌어요. 처방은 항상 @wraps(func)를 붙이는 거예요.

**사고 2: nonlocal 누락.** closure 안에서 바깥 변수를 수정하려는데 nonlocal을 안 쓰면 에러나 엉뚱한 동작이 나요. 처방은 수정할 바깥 변수에 nonlocal을 선언하는 거예요. H2에서 본 거죠.

**사고 3: lru_cache mutable 인자.** 리스트를 인자로 넘기면 unhashable 에러예요. 처방은 immutable(숫자·문자열·튜플)만 넘기는 거예요. H4에서 본 함정이죠.

**사고 4: @dataclass 기본값 mutable.** 필드 기본값에 리스트를 그냥 쓰면 공유 사고가 나요. 처방은 `field(default_factory=list)`를 쓰는 거예요. H2 함정의 dataclass 버전이에요.

**사고 5: partial 키워드 인자.** partial로 키워드 인자를 고정할 때 헷갈릴 수 있어요. 처방은 `partial(f, **kwargs)`처럼 키워드도 고정할 수 있다는 걸 기억하는 거예요. 위에서 `partial(convert, from_curr="USD")`처럼 했죠.

다섯 사고. 다 H2·H4에서 미리 본 함정들이에요. 그래서 본인은 오늘 안 당황했죠. 미리 배운 게 데모에서 빛나는 거예요.

이게 강의를 순서대로 듣는 이유예요. H2에서 mutable default 함정을 안 배웠다면, 오늘 `field(default_factory=datetime.now)`를 보고 "이게 왜 필요하지?" 했을 거예요. H4에서 lru_cache의 unhashable 함정을 안 봤다면, 리스트를 넘기다 에러나서 한참 헤맸을 거고요. 그런데 본인은 그 함정들을 미리 봤어요. 그래서 오늘 데모에서 그게 나와도 "아, 그거"하고 넘어가죠. 개념(H2)과 도구(H4)를 먼저 쌓고, 데모(H5)에서 적용하는 이 순서가 그래서 중요해요. 만약 본인이 데모만 보고 따라 쳤다면, 동작은 하겠지만 "왜 그런지"는 몰랐을 거예요. 본인은 왜 그런지 알고 짜요. 그게 복붙하는 사람과 이해하는 사람의 차이예요. 오늘 본인이 안 당황한 건, 본인이 H1부터 차근히 쌓아 왔기 때문이에요. 그 노력이 오늘 보상받은 거예요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: 데코레이터는 마법이다.**

오늘 직접 짜 봤죠? 마법이 아니라 "함수를 감싸는 함수"예요. closure로 만든 거고요. 본인이 오늘 그 마법을 풀었어요.

**오해 2: closure는 시니어만 쓴다.**

아니에요. 본인이 오늘 신입으로서 closure를 짰잖아요. RateProvider요. "바깥 변수를 기억하는 함수", 그게 전부예요.

**오해 3: @dataclass는 무겁다.**

아니에요. 가벼워요. 오히려 __init__을 손으로 적는 것보다 코드가 확 줄었죠. Conversion 클래스가 그 증거예요.

**오해 4: @property는 OOP 전문가만 쓴다.**

아니에요. 본인이 오늘 rate와 formatted를 property로 만들었잖아요. 계산이 필요한 값을 속성처럼 보여줄 때 쓰는, 누구나 쓰는 도구예요.

**오해 5: lru_cache는 항상 붙이면 좋다.**

아니에요. 가벼운 함수엔 캐싱 비용이 오히려 손해예요. expensive_convert처럼 비싼 함수에만요. 이름에 expensive를 붙인 이유가 그거예요.

다섯 오해를 보면, 오늘 데모의 가장 큰 수확이 보여요. 본인이 "마법"이라고 무서워하던 것들을 다 손으로 풀어 본 거예요. 데코레이터, closure, dataclass, property — 이름만 들으면 고급 기술 같죠. 그런데 본인이 오늘 30분 만에 다 짰어요. 무서운 게 아니라, 그냥 도구였던 거예요. 프로그래밍에서 "어려워 보이는 것"의 대부분이 이래요. 이름이 낯설어서 무섭지, 직접 해 보면 별거 아닌 경우가 많아요. 본인이 오늘 그걸 몸으로 배웠어요. 앞으로 낯선 기술 이름을 만나도, "한번 직접 해 보면 별거 아닐 거야"라는 배짱이 생겼을 거예요. 그 배짱이 오늘 데모의 진짜 선물이에요. 데코레이터를 짰다는 사실보다, "나도 하면 되는구나"라는 자신감이 더 값져요.

---

## 12. 흔한 실수 다섯 + 안심 — 데모 학습 편

v3를 따라 치며 자주 빠지는 함정 다섯 개예요.

**첫째, 함수를 정의만 하고 호출을 안 하기.** 안심하세요. `def`로 함수를 만들었으면, 아래에서 꼭 불러 봐야 동작을 확인해요. 정의는 요리법을 적은 거고, 호출이 실제로 요리하는 거예요.

**둘째, return을 빠뜨리기.** 안심하세요. 특히 데코레이터의 wrapper에서 `return result`를 빠뜨리면 결과가 None이 돼요. 끝마다 return을 확인하세요.

**셋째, 들여쓰기 한 칸 차이.** 안심하세요. Python은 들여쓰기가 중요한데, black을 깔면 저장할 때 자동으로 맞춰 줘요. 손으로 맞추느라 고생 마세요.

**넷째, 변수 이름 충돌.** 안심하세요. closure 안과 밖에서 같은 이름을 쓰면 헷갈려요. local 변수 이름을 분명히 다르게 짓거나, nonlocal을 의식하세요.

**다섯째, 가장 큰 함정 — print만으로 디버깅.** 안심하세요. 데코레이터나 closure가 이상하면 `breakpoint()`로 멈춰서 안을 보세요. H3에서 배운 거죠. wrapper 안이 어떻게 도는지 직접 보면 이해가 빨라요. 특히 데코레이터는 wrapper 안에서 무슨 일이 일어나는지 눈에 안 보여서 헷갈리는데, breakpoint를 wrapper 안에 찍으면 "아, 여기서 원래 함수가 불리는구나"가 똑똑히 보여요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 가요. 오늘 데모를 따라 치다 막히면, 이 다섯을 먼저 의심하세요. 십중팔구 여기 답이 있어요.

---

## 13. 마무리

자, 함수의 다섯 번째 시간이 끝났어요. 데모였죠.

오늘 본인은 환율 계산기를 v2에서 v3로 키웠어요. 데코레이터 세 개(@timer·@validate·@lru_cache), closure 하나(RateProvider), @dataclass 하나(Conversion), @property 둘(rate·formatted), 그리고 partial과 lru_cache를 다 적용했어요. 30분 만에 200줄짜리 우아한 프로그램을 만들었죠. 이 챕터에서 H2의 개념과 H4의 도구가, 오늘 H5에서 본인 손끝에 다 모였어요. 배운 걸 손으로 옮기는, 가장 보람찬 시간이었어요.

그리고 오늘의 약속을 지켰어요. **본인의 첫 데코레이터 두 개와 첫 closure가 동작했어요.** 이건 H1부터 걸어온 약속이에요. H1에서 "데코레이터를 짠다"고 했고, H2에서 "closure가 토대"라고 했고, H4에서 "도구"를 봤죠. 오늘 그게 다 본인 손에서 만났어요. 본인은 이제 "데코레이터를 짜 본 사람"이에요. 많은 사람이 못 넘는 벽을 넘은 거예요. 정말 큰 일이에요.

한 가지 부탁할게요. 오늘 친 exchange_v3.py를 GitHub에 올리세요. v1, v2 옆에 v3를요. 본인의 git 히스토리에 v1→v2→v3의 성장이 남아요. 그게 본인의 포트폴리오예요. 두 해 후 누가 본인의 GitHub를 보면, "이 사람은 코드를 키우고 다듬는 사람이구나"를 한눈에 알아요. Ch004에서 배운 git이 여기서 빛나죠. 커밋 메시지는 "v3: 데코레이터·closure·dataclass 적용" 정도로 적으면 돼요. 그 한 줄이 오늘 본인이 한 일의 기록이에요. 코드를 짜는 것만큼, 그 성장을 git에 남기는 게 중요해요. 안 남기면 사라지거든요. 오늘 한 일을 꼭 커밋하세요.

다음 H6은 운영이에요. 오늘 만든 v3를 더 우아하게 다듬어요. SOLID, DRY, 함수 합성 같은, "좋은 함수란 무엇인가"를 배워요. 그 전에 마지막으로 두 줄만 쳐 보세요.

```bash
black exchange_v3.py
ruff check exchange_v3.py
```

본인이 짠 v3를 black으로 예쁘게 다듬고, ruff로 검사하는 거예요. 통과하면 본인 코드가 자경단 표준이에요.

마지막으로 오늘을 한 문장으로 남길게요. "어려워 보이는 것도, 한 줄씩 손으로 치면 결국 된다." 본인은 오늘 그걸 증명했어요. H1에서 멀게만 느껴지던 데코레이터를, 오늘 본인 손으로 짰어요. 이게 본인이 이 코스를 끝까지 갈 수 있다는 증거예요. 아무리 어려운 챕터가 와도, 본인은 한 줄씩 손으로 치며 넘을 거예요. 오늘처럼요. 다음 시간에 봐요. 좋은 함수의 비밀을 배워요. 오늘 정말 큰 일을 해냈어요. 본인의 첫 데코레이터, 진심으로 축하해요. 본인이 정말로 자랑스러워요. 다음 시간에 또 반갑게 꼭 만나요. 🐾

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - @wraps: `__name__`·`__doc__`·`__wrapped__`·`__dict__` 보존. 없으면 introspection·디버깅이 wrapper를 가리킴.
> - 데코레이터 적용 순서: `@a` `@b` `def f` → `f = a(b(f))`. 안쪽(b)부터 감싸고 바깥(a)이 마지막. 실행은 바깥부터.
> - closure 캡슐화: `rates`는 `make_rate_provider`의 로컬 → 외부 직접 접근 불가. `get_rate.__closure__`로만 간접 확인. 사실상 private.
> - closure 메모리: 캡처된 객체는 closure가 살아 있는 동안 GC 안 됨. 큰 객체 캡처 주의.
> - @dataclass(slots=True, frozen=True): `__slots__` 자동(메모리↓)·immutable(hashable). `field(default_factory=...)`로 mutable default 회피.
> - @property + setter: `@rate.setter`로 쓰기 허용. descriptor protocol(`__get__`/`__set__`).
> - partial.func·partial.args·partial.keywords: partial 객체의 introspection 속성.
> - 다음 H6 키워드: SOLID · DRY · KISS · 함수 합성 · pure function · Functional Core/Imperative Shell.

---

## 추신

1. v2 150줄 → v3 200줄. 함수 기술로 우아하게.
2. 오늘의 약속 — 첫 데코레이터 둘 + 첫 closure 동작.
3. @timer = 함수 실행 시간 자동 측정. 첫 데코레이터.
4. 데코레이터 = func 받아 wrapper 돌려주기. closure로.
5. @wraps(func) 꼭. 안 붙이면 이름이 wrapper로.
6. wrapper(*args, **kwargs) = 어떤 인자든 받아 넘기기.
7. @validate = 인자 자동 검증. guard clause의 데코 버전.
8. 데코레이터는 쌓을 수 있어요. @timer @validate.
9. 적용 순서 아래→위 감쌈. 실행은 바깥→안.
10. closure RateProvider = rates·last_update 캡처.
11. nonlocal = closure 안 바깥 변수 수정.
12. 캡슐화 = rates를 closure에 가둬 보호.
13. 환율 같은 중요 데이터는 정해진 문으로만.
14. @dataclass = __init__·__repr__ 자동. 필드만 적기.
15. field(default_factory=datetime.now) = mutable default 처방.
16. @property = 계산 값을 () 없이 속성처럼.
17. c.rate·c.formatted = 결과 객체가 똑똑해져요.
18. partial = 인자 고정 전용 함수. to_krw·to_jpy.
19. lru_cache = 결과 캐싱. 두 번째 호출 10배 빠름.
20. [TIMER]는 데코, [CALC] 한 번만은 캐시 증거.
21. v3 = 같은 기능을 더 우아하게(동작→우아).
22. 사고 — @wraps·nonlocal·lru mutable·field·partial kw.
23. 다 H2·H4에서 미리 본 함정. 그래서 안 당황.
24. 데코레이터는 마법 아님. 오늘 본인이 풀었어요.
25. closure는 신입도. 본인이 오늘 짰어요.
26. 손으로 친 30분 > 강의 열 시간. 손가락이 기억해요.
27. exchange_v3.py를 GitHub에. v1→v2→v3 성장.
28. v3는 Ch041에서 v4(웹 API)로 또 자라요.
29. black·ruff 통과하면 자경단 표준.
30. 다음 H6은 좋은 함수의 비밀. SOLID·DRY. 🐾
