# Ch009 · H4 — 18 함수 도구 카탈로그 — functools·decorator 패턴

> 고양이 자경단 · Ch 009 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 18 도구 한 표
3. 첫째 무리 — functools 다섯
4. 둘째 무리 — decorator 패턴 다섯
5. 셋째 무리 — 함수 검사 네 도구
6. 넷째 무리 — 비동기 함수 도구
7. 매일·주간·월간 리듬
8. 자경단 매일 13줄 흐름
9. 다섯 함정과 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요.

지난 H3 회수. 함수 디버깅 5도구 — VS Code, inspect, dis, cProfile, py-spy.

이번 H4는 함수 18 도구.

오늘의 약속. **본인이 매일 만날 함수 도구 18개가 머리에 들어옵니다**.

자, 가요.

---

## 2. 18 도구 한 표

| # | 도구 | 무리 |
|---|------|------|
| 1 | functools.reduce | functools |
| 2 | functools.partial | functools |
| 3 | functools.lru_cache | functools |
| 4 | functools.wraps | functools |
| 5 | functools.cache | functools |
| 6 | @decorator | decorator |
| 7 | @property | decorator |
| 8 | @classmethod | decorator |
| 9 | @staticmethod | decorator |
| 10 | @dataclass | decorator |
| 11 | inspect.signature | 검사 |
| 12 | inspect.getsource | 검사 |
| 13 | inspect.getdoc | 검사 |
| 14 | callable() | 검사 |
| 15 | async def | 비동기 |
| 16 | await | 비동기 |
| 17 | asyncio.run | 비동기 |
| 18 | asyncio.gather | 비동기 |

---

## 3. 첫째 무리 — functools 다섯

**reduce**. 누적 적용.

```python
from functools import reduce
reduce(lambda a, b: a + b, [1, 2, 3, 4])   # 10
```

**partial**. 일부 인자 고정.

```python
from functools import partial
def add(a, b, c):
    return a + b + c

add5 = partial(add, 5)
add5(10, 20)   # 35
```

**lru_cache**. 함수 결과 캐싱.

```python
@lru_cache(maxsize=128)
def fib(n):
    return n if n < 2 else fib(n-1) + fib(n-2)
```

**wraps**. decorator의 메타데이터 보존.

```python
from functools import wraps

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        ...
    return wrapper
```

**cache** (3.9+). lru_cache의 단순 버전.

```python
@cache
def factorial(n):
    return 1 if n <= 1 else n * factorial(n-1)
```

다섯. 자경단 매일.

---

## 4. 둘째 무리 — decorator 패턴 다섯

**@decorator** — 일반 데코레이터. H2에서.

**@property** — getter를 속성처럼.

```python
class Cat:
    def __init__(self, name):
        self._name = name
    
    @property
    def name(self):
        return self._name.upper()

cat = Cat("까미")
cat.name   # '까미' (메서드 호출 () 없이)
```

**@classmethod** — 클래스 메서드.

```python
class Cat:
    @classmethod
    def create(cls, name):
        return cls(name)

Cat.create("까미")
```

**@staticmethod** — 정적 메서드.

```python
class MathUtils:
    @staticmethod
    def double(x):
        return x * 2

MathUtils.double(5)
```

**@dataclass** — class boilerplate 자동.

```python
from dataclasses import dataclass

@dataclass
class Cat:
    name: str
    age: int

cat = Cat("까미", 3)
print(cat)   # Cat(name='까미', age=3)
```

다섯. 자경단 매일.

---

## 5. 셋째 무리 — 함수 검사 네 도구

H3에서 봤어요. inspect.signature, getsource, getdoc, callable.

**callable**

```python
callable(print)         # True
callable("hello")       # False
callable(lambda: 0)     # True
```

객체가 호출 가능한지 검사.

---

## 6. 넷째 무리 — 비동기 함수 도구

**async def** — 비동기 함수 정의.

```python
async def fetch(url):
    response = await http.get(url)
    return response.text
```

**await** — 비동기 결과 기다리기.

**asyncio.run** — 비동기 함수 실행.

```python
import asyncio

asyncio.run(fetch("https://api.com"))
```

**asyncio.gather** — 여러 비동기 동시 실행.

```python
results = await asyncio.gather(
    fetch("url1"),
    fetch("url2"),
    fetch("url3"),
)
```

비동기는 Ch020에서 깊이. 오늘은 그림.

---

## 7. 매일·주간·월간 리듬

**매일 6** — def, return, type hints, lambda, sorted+key, list comp.

**주간 7** — partial, lru_cache, @property, @dataclass, @classmethod, *args, **kwargs.

**월간 5** — @staticmethod, reduce, wraps, async def, await.

매일 6개부터.

---

## 8. 자경단 매일 13줄 흐름

```python
from functools import lru_cache, partial
from dataclasses import dataclass
from typing import Callable

@dataclass
class Cat:
    name: str
    age: int

@lru_cache(maxsize=128)
def expensive_calc(n: int) -> int:
    ...

def filter_cats(cats: list[Cat], pred: Callable[[Cat], bool]) -> list[Cat]:
    return [c for c in cats if pred(c)]

is_adult = partial(lambda age, c: c.age >= age, 3)
adults = filter_cats(cats, is_adult)
```

13줄에 18 도구 중 6개.

---

## 9. 다섯 함정과 처방

**함정 1: lru_cache mutable 인자**

처방. immutable만.

**함정 2: decorator wraps 누락**

처방. @functools.wraps 항상.

**함정 3: @property setter 누락**

처방. @prop.setter 추가.

**함정 4: @classmethod에 self**

처방. cls 사용.

**함정 5: async 함수 일반 호출**

처방. asyncio.run 또는 await.

---

## 10. 흔한 오해 다섯 가지

**오해 1: lru_cache 항상 빠르다.**

캐싱 비용. 작은 함수는 손해.

**오해 2: @dataclass는 무거움.**

가벼움. boilerplate 절감.

**오해 3: @property 자주 안 씀.**

자경단 OOP에서 매일.

**오해 4: async 모든 곳.**

I/O bound만. CPU는 multiprocessing.

**오해 5: partial vs lambda.**

partial이 더 명확. lambda는 짧음.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. lru_cache vs cache?**

cache는 무제한, lru_cache는 N개 제한.

**Q2. @dataclass vs class?**

dataclass가 __init__, __repr__ 자동. 단순 데이터는 dataclass.

**Q3. decorator 여러 개?**

가능. 위에서 아래로 적용.

**Q4. partial 성능?**

함수 호출보다 살짝 느림. 무시.

**Q5. asyncio 어디서?**

I/O 많은 곳 (HTTP, DB). Ch020.

---

## 12. 흔한 실수 다섯 + 안심 — 함수 명령어 학습 편

첫째, built-in 다 외움. 안심 — print/len/range만.
둘째, 함수 이름 너무 짧게. 안심 — calculate_total > calc.
셋째, 한 함수에 여러 책임. 안심 — Single Responsibility.
넷째, 부수 효과 함수. 안심 — pure 우선.
다섯째, 가장 큰 — 함수 50줄+. 안심 — 20줄.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 네 번째 시간 끝.

functools 5, decorator 5, 검사 4, 비동기 4. 18 도구.

다음 H5는 30분 데모. v2 → v3 with decorator + closure.

```python
python3 -c "from functools import partial; add5 = partial(lambda a, b: a+b, 5); print(add5(3))"
```

---

## 👨‍💻 개발자 노트

> - functools.reduce: initial value 옵션. 빈 iterable 안전.
> - lru_cache 통계: cache_info() 메서드.
> - @property + setter: getter, setter, deleter 셋.
> - @dataclass(frozen=True): immutable.
> - asyncio event loop: run, gather, wait, create_task.
> - 다음 H5 키워드: exchange v3 · @timer · @validate · closure · @property.
