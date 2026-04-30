# Ch009 · H5 — 환율 계산기 v3 30분 — decorator·closure·@property 적용

> 고양이 자경단 · Ch 009 · 5교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. v2 → v3 진화 표
3. 0~5분 — @timer 데코레이터
4. 5~10분 — @validate 데코레이터
5. 10~15분 — closure로 RateProvider
6. 15~20분 — @dataclass와 @property
7. 20~25분 — partial과 lru_cache
8. 25~30분 — 실행과 검증
9. v2 vs v3 다섯 차이
10. 다섯 사고와 처방
11. 흔한 오해 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요.

지난 H4 회수. 18 함수 도구.

이번 H5는 환율 계산기 v2 150줄을 v3 200줄로 진화. 데코레이터, closure, @property 적용.

오늘의 약속. **본인의 첫 데코레이터 두 개와 첫 closure가 동작합니다**.

자, 가요.

---

## 2. v2 → v3 진화 표

| 항목 | v2 | v3 |
|------|-----|-----|
| 줄 수 | 150 | 200 |
| 데코레이터 | 0 | 3 (@timer, @validate, @lru_cache) |
| closure | 0 | 1 (RateProvider) |
| @property | 0 | 2 |
| @dataclass | 0 | 1 (Conversion) |
| 18 도구 적용 | 5 | 13 |

---

## 3. 0~5분 — @timer 데코레이터

본인의 첫 데코레이터.

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

@timer 한 줄로 모든 함수에 시간 측정 추가. 자경단 표준.

---

## 4. 5~10분 — @validate 데코레이터

인자 검증 데코레이터.

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

데코레이터를 쌓을 수 있어요.

```python
@timer
@validate
def convert(amount, from_curr, to_curr):
    ...
```

위에서 아래로 적용. validate 먼저, timer 다음.

---

## 5. 10~15분 — closure로 RateProvider

closure로 환율 갱신 시간 관리.

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

closure가 rates와 last_update를 캡처. 외부에서 직접 접근 못 함. 캡슐화.

---

## 6. 15~20분 — @dataclass와 @property

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

@dataclass가 __init__, __repr__ 자동. @property가 메서드를 속성처럼.

---

## 7. 20~25분 — partial과 lru_cache

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

partial이 부분 함수, lru_cache가 결과 캐싱.

---

## 8. 25~30분 — 실행과 검증

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

데코레이터, closure, @property 다 작동. 본인의 첫 v3.

---

## 9. v2 vs v3 다섯 차이

**1. @timer**. 모든 함수 시간 측정.

**2. @validate**. 인자 자동 검증.

**3. closure RateProvider**. 환율 캡슐화.

**4. @dataclass + @property**. 객체로 결과 표현.

**5. partial + lru_cache**. 함수 곱셈.

다섯 차이가 v3를 자경단 표준으로.

---

## 10. 다섯 사고와 처방

**사고 1: @wraps 누락**

처방. 항상 @wraps.

**사고 2: nonlocal 누락**

처방. closure 안 변수 수정 시 nonlocal.

**사고 3: lru_cache mutable 인자**

처방. immutable만.

**사고 4: @dataclass 기본 mutable**

처방. field(default_factory=list).

**사고 5: partial 키워드 인자**

처방. partial(f, **kwargs)도 가능.

---

## 11. 흔한 오해 다섯 가지

**오해 1: 데코레이터는 마법.**

함수 감싸는 함수.

**오해 2: closure는 시니어.**

신입도. 작은 closure.

**오해 3: @dataclass는 무거움.**

가벼움. boilerplate 절감.

**오해 4: @property는 OOP만.**

함수형 코드에도 사용.

**오해 5: lru_cache 항상.**

작은 함수는 손해.

---

## 12. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, 함수 정의 후 호출 안 함. 안심 — 매번 호출.
둘째, return 빠뜨림. 안심 — 끝마다 명시.
셋째, 들여쓰기 한 칸 차이. 안심 — black 자동.
넷째, 변수 충돌. 안심 — local 사용.
다섯째, 가장 큰 — print만 디버깅. 안심 — `breakpoint()`.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 다섯 번째 시간 끝.

v2 → v3. 데코레이터 3, closure 1, @dataclass 1, @property 2, partial, lru_cache.

다음 H6는 운영. SOLID, DRY, 함수 합성.

```bash
black exchange_v3.py
ruff check exchange_v3.py
```

---

## 👨‍💻 개발자 노트

> - @wraps: __name__, __doc__, __wrapped__ 보존.
> - closure 메모리: 캡처 객체는 GC 안 됨.
> - @dataclass(slots=True): __slots__ 자동.
> - @property setter: @prop.setter로.
> - partial.func, partial.args: partial의 metadata.
> - 다음 H6 키워드: SOLID · DRY · KISS · 함수 합성 · pure function.
