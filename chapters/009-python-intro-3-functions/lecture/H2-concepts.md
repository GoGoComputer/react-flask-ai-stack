# Ch009 · H2 — 함수 8개념 — def 6 인자부터 closure까지

> 고양이 자경단 · Ch 009 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. 첫째 — def의 여섯 인자 종류
3. 둘째 — return의 다섯 패턴
4. 셋째 — default 인자와 mutable 함정
5. 넷째 — *args와 **kwargs
6. 다섯째 — type hints 깊이
7. 여섯째 — docstring Google 양식
8. 일곱째 — lambda 다섯 사용처
9. 여덟째 — closure와 nonlocal
10. 한 줄 분해
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요.

지난 H1 회수. 함수의 네 친구, 다섯 종류. 자경단 매일 125개.

이번 H2는 8개념 깊이. def의 여섯 인자, return 5패턴, default, *args, type hints, docstring, lambda, closure.

오늘의 약속. **본인이 H5에서 만들 데코레이터의 토대가 박힙니다**.

자, 가요.

---

## 2. 첫째 — def의 여섯 인자 종류

Python 함수는 인자 종류가 6가지예요.

```python
def f(
    pos_only,           # 1. 위치 전용 (Python 3.8+)
    /,
    pos_or_kw,          # 2. 위치 또는 키워드
    *args,              # 3. 가변 위치
    kw_only,            # 4. 키워드 전용
    **kwargs,           # 5. 가변 키워드
):
    ...
```

여섯째는 **default**. 위에 다 default 가능.

```python
def f(a, b=10, *args, c=20, **kwargs):
    ...
```

자경단 매일 1, 2번이 90%. 4번 (키워드 전용)은 가끔. 1번 (위치 전용)은 거의.

---

## 3. 둘째 — return의 다섯 패턴

**1. 단일 값**

```python
def add(a, b):
    return a + b
```

**2. 여러 값 (tuple)**

```python
def divmod_pair(a, b):
    return a // b, a % b

q, r = divmod_pair(10, 3)   # 3, 1
```

**3. 조건부 None**

```python
def find(items, key):
    for item in items:
        if item == key:
            return item
    return None
```

**4. 명시적 None**

```python
def log(msg):
    print(msg)
    return None  # 또는 그냥 return
```

**5. 예외 발생**

```python
def divide(a, b):
    if b == 0:
        raise ValueError("0으로 나눔")
    return a / b
```

다섯 패턴. 매일 1, 3, 5번이 90%.

---

## 4. 셋째 — default 인자와 mutable 함정

default 인자는 함수 정의 시 한 번 평가. mutable이면 사고.

**Bad**

```python
def add_cat(cats=[]):
    cats.append("새")
    return cats

add_cat()   # ['새']
add_cat()   # ['새', '새']  # 사고!
```

**Good**

```python
def add_cat(cats=None):
    cats = cats or []
    cats.append("새")
    return cats
```

자경단 매일 함정. None default 후 안에서 [] 만들기.

---

## 5. 넷째 — *args와 **kwargs

가변 인자 두 종류.

```python
def func(*args, **kwargs):
    print(args, kwargs)

func(1, 2, 3, name="까미")
# (1, 2, 3) {'name': '까미'}
```

`*`과 `**`는 호출에서도 사용.

```python
def add(a, b, c):
    return a + b + c

nums = [1, 2, 3]
add(*nums)   # add(1, 2, 3)

params = {"a": 1, "b": 2, "c": 3}
add(**params)
```

unpacking이라고 불러요. 자경단 매일.

---

## 6. 다섯째 — type hints 깊이

기본 6 패턴은 Ch007 H6에서 봤어요. 함수 특화 패턴.

**Optional**

```python
def find(name: str) -> str | None:
    ...
```

**Callable**

```python
from typing import Callable

def apply(f: Callable[[int], int], x: int) -> int:
    return f(x)
```

**Generic**

```python
from typing import TypeVar

T = TypeVar("T")

def first(items: list[T]) -> T:
    return items[0]
```

**Overload**

```python
from typing import overload

@overload
def add(a: int, b: int) -> int: ...
@overload
def add(a: str, b: str) -> str: ...
def add(a, b):
    return a + b
```

**Literal**

```python
from typing import Literal

def log(level: Literal["INFO", "ERROR"]):
    ...
```

다섯 패턴. 자경단 표준.

---

## 7. 여섯째 — docstring Google 양식

```python
def convert(amount: float, from_curr: str, to_curr: str) -> float:
    """Convert amount between currencies.
    
    Args:
        amount: 환산할 금액.
        from_curr: 출발 통화.
        to_curr: 도착 통화.
    
    Returns:
        환산된 금액.
    
    Raises:
        KeyError: 통화 코드가 없을 때.
    
    Examples:
        >>> convert(50, "USD", "KRW")
        65000.0
    """
```

Google 양식 다섯 부분. 한 줄 요약, Args, Returns, Raises, Examples. 자경단 표준.

---

## 8. 일곱째 — lambda 다섯 사용처

**1. sorted key**

```python
sorted(cats, key=lambda c: c.age)
```

**2. filter/map**

```python
list(filter(lambda c: c.is_active, cats))
```

**3. callback**

```python
button.on_click = lambda: print("clicked")
```

**4. 짧은 변환**

```python
double = lambda x: x * 2
```

**5. partial 비슷**

```python
add5 = lambda x: x + 5
```

다섯 사용처. 한 줄까지만. 그 이상 def.

---

## 9. 여덟째 — closure와 nonlocal

closure는 함수 안의 함수가 외부 변수를 기억.

```python
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment

counter = make_counter()
counter()  # 1
counter()  # 2
```

`nonlocal`이 외부 변수 수정 키워드. 안 쓰면 새 변수.

closure는 decorator의 토대예요.

```python
def timer(func):
    def wrapper(*args, **kwargs):
        import time
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{func.__name__}: {time.time() - start:.3f}초")
        return result
    return wrapper

@timer
def slow():
    import time; time.sleep(1)
```

`@timer`가 `slow = timer(slow)`와 같음. wrapper가 closure.

---

## 10. 한 줄 분해

자경단 매일 한 줄.

```python
@lru_cache(maxsize=128)
def fib(n: int) -> int:
    return n if n < 2 else fib(n-1) + fib(n-2)
```

decorator + type hints + 삼항 + 재귀. 한 줄에 8개념 중 4개.

---

## 11. 흔한 오해 다섯 가지

**오해 1: default는 매번 새로 만들어진다.**

함수 정의 시 한 번. mutable 함정.

**오해 2: *args, **kwargs 항상 함께.**

따로도 가능. 보통 같이.

**오해 3: lambda는 def보다 빠르다.**

비슷. 가독성 차이.

**오해 4: closure는 어렵다.**

쓰면서 박혀요. decorator 만들 때.

**오해 5: type hints가 런타임 검증한다.**

기본 안 함. mypy로 검사.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. *args와 list 차이?**

*args는 unpack, list는 명시. *args가 더 자연.

**Q2. closure 메모리 누수?**

closure가 큰 객체 캡처하면 가비지 수집 안 됨. 주의.

**Q3. decorator 자동 docstring 보존?**

@functools.wraps로.

**Q4. lambda 한계?**

표현식만. 문장 (assignment 등) 안 됨.

**Q5. typing.Generic vs TypeVar?**

TypeVar는 타입 변수, Generic은 generic class.

---

## 13. 흔한 실수 다섯 + 안심 — 함수 핵심 학습 편

첫째, *args/**kwargs 헷갈림. 안심 — *는 위치, **는 키워드.
둘째, lambda 남용. 안심 — 한 줄에만.
셋째, 클로저 헷갈림. 안심 — 안쪽 함수 + 바깥 변수.
넷째, scope LEGB 헷갈림. 안심 — Local·Enclosing·Global·Built-in.
다섯째, 가장 큰 — 재귀 깊이 폭발. 안심 — 반복으로 또는 setrecursionlimit.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 14. 마무리

자, 두 번째 시간 끝.

def 6 인자, return 5 패턴, default 함정, *args **kwargs, type hints, docstring, lambda, closure. 자경단 매일.

다음 H3는 디버깅. inspect, dis, profile.

```python
python3 -c 'def f(*a, **k): print(a, k)
f(1, 2, name="까미")'
```

---

## 👨‍💻 개발자 노트

> - 위치 전용 인자 PEP 570: 3.8+. /로 구분.
> - 키워드 전용: *나 *args 다음.
> - default mutable 함정: 함수 정의 시 한 번 평가.
> - functools.wraps: decorator의 메타데이터 보존.
> - typing PEP 484: 3.5+. 점진적 타이핑.
> - 다음 H3 키워드: inspect · dis · profile · pdb 함수 진입.
