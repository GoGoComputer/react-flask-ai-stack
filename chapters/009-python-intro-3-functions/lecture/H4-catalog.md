# Ch009 · H4 — 18 함수 도구 카탈로그 — functools·decorator 패턴

> 고양이 자경단 · Ch 009 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

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
11. 자주 받는 질문 여섯 가지
12. 흔한 실수 다섯 + 안심
13. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
from functools import reduce, partial, lru_cache, wraps, cache

add5 = partial(lambda a, b: a + b, 5)   # 인자 고정

@lru_cache(maxsize=128)                  # 결과 캐싱
def fib(n): return n if n < 2 else fib(n-1) + fib(n-2)

@dataclass                               # boilerplate 자동
class Cat:
    name: str
    age: int
```

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요. 다시 만났어요. 함수 챕터의 네 번째 시간이에요.

지난 H3를 한 줄로 회수할게요. 본인은 함수를 들여다보는 다섯 도구를 익혔어요. VS Code 단축키, inspect, dis, cProfile, py-spy요. 함수가 블랙박스가 아니라 투명한 상자가 됐죠.

이번 H4는 카탈로그 시간이에요. Ch008 H4에서 흐름 18 도구를 카탈로그로 봤죠. 이번엔 함수 18 도구예요. 함수를 더 우아하고 강력하게 만드는 도구들이요. functools 다섯, decorator 패턴 다섯, 함수 검사 네 개, 비동기 네 개. 합쳐서 18개죠. 카탈로그라는 게 뭐냐면, 백화점 상품 목록 같은 거예요. 오늘 다 사라는 게 아니에요. "이런 게 있구나, 필요할 때 여기서 꺼내면 되겠구나"를 구경하는 시간이에요.

오늘의 약속은 이거예요. **본인이 매일 만날 함수 도구 18개가 머리에 들어옵니다**. 다 외우는 게 아니라, "존재를 아는" 거예요. H3에서 말했듯, 도구는 이름과 용도만 알면 사용법은 필요할 때 찾으면 돼요. 18개 중 매일 쓰는 건 사실 6개 정도예요. 나머지는 "아, 그런 게 있었지" 하고 그때 꺼내면 되고요. 마음 편하게 구경하세요. 특히 H2에서 본 decorator와 closure가 여기서 잔뜩 나와요. 그때 심은 씨앗이 자라는 걸 보게 될 거예요.

카탈로그 시간을 왜 따로 두는지 한 가지만 말할게요. 도구의 존재를 아는 것 자체가 실력이거든요. 본인이 lru_cache라는 게 있다는 걸 모르면, 느린 함수를 만나도 그냥 끙끙대며 손으로 최적화해요. 그런데 "아, 이거 lru_cache 붙이면 되겠다"를 떠올릴 수 있으면, 한 줄로 끝나요. 차이는 "그 도구의 존재를 아느냐"예요. 그래서 카탈로그를 한 번 쭉 보는 게 중요해요. 정확한 사용법은 까먹어도 돼요. "함수 결과를 기억해 주는 뭔가가 있었지"만 기억하면, 필요할 때 이름을 검색해서 찾아요. 요리사가 모든 양념의 정확한 양을 외우진 않아도, 주방에 어떤 양념이 있는지는 알잖아요. 그래야 필요할 때 꺼내 쓰죠. 오늘 본인은 함수라는 주방의 양념 18개를 구경하는 거예요. 자, 가요.

---

## 2. 18 도구 한 표

먼저 18개를 한 표로 펼칠게요. 전체 지도를 보고 시작하면 길을 안 잃어요.

| # | 도구 | 무리 | 한 줄 |
|---|------|------|------|
| 1 | functools.reduce | functools | 누적 적용 |
| 2 | functools.partial | functools | 일부 인자 고정 |
| 3 | functools.lru_cache | functools | 결과 캐싱(N개) |
| 4 | functools.wraps | functools | 데코레이터 메타 보존 |
| 5 | functools.cache | functools | 결과 캐싱(무제한) |
| 6 | @decorator | decorator | 함수 감싸기 |
| 7 | @property | decorator | getter를 속성처럼 |
| 8 | @classmethod | decorator | 클래스 메서드 |
| 9 | @staticmethod | decorator | 정적 메서드 |
| 10 | @dataclass | decorator | 클래스 boilerplate 자동 |
| 11 | inspect.signature | 검사 | 시그니처 |
| 12 | inspect.getsource | 검사 | 소스 코드 |
| 13 | inspect.getdoc | 검사 | docstring |
| 14 | callable() | 검사 | 호출 가능 여부 |
| 15 | async def | 비동기 | 비동기 함수 정의 |
| 16 | await | 비동기 | 비동기 결과 대기 |
| 17 | asyncio.run | 비동기 | 비동기 실행 |
| 18 | asyncio.gather | 비동기 | 여러 개 동시 실행 |

네 무리예요. functools(5), decorator(5), 검사(4), 비동기(4). 표만 봐도 벌써 머리에 그림이 그려지죠. 무리로 묶으면 18개가 4덩어리가 되니까 훨씬 외우기 쉬워요. 사람 머리는 18개를 따로 기억 못 해도, 4덩어리는 기억하거든요. 이제 무리별로 하나씩 볼게요.

---

## 3. 첫째 무리 — functools 다섯

functools는 "함수를 다루는 함수들"을 모은 표준 라이브러리예요. 이름 그대로 함수(func) 도구(tools)죠. 다섯 개를 볼게요.

**reduce — 누적 적용.** 리스트를 하나의 값으로 접어요.

```python
from functools import reduce
reduce(lambda a, b: a + b, [1, 2, 3, 4])   # 10
```

`[1,2,3,4]`를 `((1+2)+3)+4`로 차곡차곡 더해 10을 만들어요. 다만 솔직히 말하면, 단순 합은 `sum()`이 더 명확해요. reduce는 sum으로 안 되는 복잡한 누적에만 가끔 써요. 예를 들어 여러 딕셔너리를 하나로 합치거나, 리스트의 곱을 구하거나(math.prod가 없던 시절), 누적해서 접는 특수한 계산에요. 사실 Python을 만든 귀도 반 로섬은 reduce를 별로 안 좋아해서, Python 3에서 내장 함수 자리에서 빼고 functools로 옮겼어요. "대부분의 reduce는 for 루프나 sum이 더 읽기 쉽다"는 게 그의 생각이었죠. 그래서 본인도 reduce는 "이런 게 있다"만 알고, 실제로는 sum·for·comprehension을 먼저 떠올리면 돼요. reduce가 정말 필요한 순간은 1년에 몇 번 안 와요.

**partial — 일부 인자 고정.** 함수의 인자 일부를 미리 채워서 새 함수를 만들어요.

```python
from functools import partial
def add(a, b, c):
    return a + b + c

add5 = partial(add, 5)
add5(10, 20)   # 35 (a=5 고정)
```

`add5`는 a가 5로 고정된 add예요. 같은 함수를 자주 비슷하게 쓸 때 편해요.

**lru_cache — 결과 캐싱.** H2에서 본 그거예요. 한 번 계산한 결과를 기억해서 다시 계산 안 해요.

```python
@lru_cache(maxsize=128)
def fib(n):
    return n if n < 2 else fib(n-1) + fib(n-2)
```

`maxsize=128`은 최근 128개 결과만 기억한다는 뜻이에요. LRU는 Least Recently Used, "가장 오래 안 쓴 것부터 버린다"는 거죠.

**wraps — 데코레이터 메타 보존.** H3 시나리오에서 본 그거예요. 데코레이터를 짤 때 원래 함수의 이름·docstring을 지켜 줘요.

```python
from functools import wraps

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        ...
    return wrapper
```

`@wraps(func)` 없으면 `func.__name__`이 wrapper로 바뀌어 버려요. 그러면 H3에서 배운 inspect나 디버거가 "이 함수는 wrapper입니다"라고 엉뚱하게 알려줘서 헷갈려요. wraps 한 줄이 원래 함수의 정체를 지켜 주는 거죠. 데코레이터 짤 때 거의 필수예요. H5에서 본인이 데코레이터를 짤 때, 이 @wraps를 꼭 붙이세요.

**cache (3.9+) — lru_cache의 단순 버전.** maxsize 없이 무제한 캐싱이에요.

```python
@cache
def factorial(n):
    return 1 if n <= 1 else n * factorial(n-1)
```

다섯 개. 이 중 자경단이 매일 쓰는 건 lru_cache(또는 cache)와 wraps예요. partial은 가끔, reduce는 거의 안 써요.

lru_cache를 조금 더 들여다볼게요. 이게 정말 마법 같은 도구거든요. H2에서 fib(피보나치)에 붙이면 수백만 배 빨라진다고 했죠. 그 원리는 단순해요. 함수가 한 번 계산한 결과를, 입력을 열쇠로 삼아 딕셔너리에 저장해 둬요. 그리고 같은 입력이 또 오면, 계산을 안 하고 저장된 답을 바로 꺼내 줘요. fib(10)을 한 번 계산하면 그 답을 기억해 두니까, 다음에 fib(10)이 필요할 때 즉시 답하는 거죠. 그래서 같은 계산을 반복하는 함수에 붙이면 어마어마하게 빨라져요. 그리고 `fib.cache_info()`를 치면 "몇 번 적중했고(hits) 몇 번 새로 계산했는지(misses)"를 알려 줘요. 캐시가 잘 먹는지 확인하는 거죠. 다만 주의할 게 있어요. lru_cache는 결과를 메모리에 계속 쌓아요. 그래서 입력 가짓수가 무한히 많은 함수에 무제한 cache를 붙이면 메모리가 터질 수 있어요. 그래서 보통 `maxsize`로 한도를 두는 lru_cache가 더 안전해요. "비싼 계산 + 입력 반복 + 같은 입력엔 같은 출력(순수 함수)" 이 세 조건이 맞으면 lru_cache의 자리예요.

partial이 실전에서 빛나는 예도 하나 들게요. 까미가 여러 통화를 변환할 때, `convert(amount, from_curr, to_curr)`라는 함수가 있다고 쳐요. 그런데 "원화로 바꾸는 일"을 자주 한다면, 매번 `convert(x, "USD", "KRW")`라고 쓰는 게 번거롭죠. 이때 `to_krw = partial(convert, to_curr="KRW")`로 만들어 두면, `to_krw(100, "USD")`처럼 짧게 부를 수 있어요. 자주 쓰는 인자 조합을 미리 고정한 "전용 함수"를 만드는 거예요. 이게 partial의 매력이에요. 다만 같은 걸 lambda로도 할 수 있어서, 둘 중 더 읽히는 쪽을 고르면 돼요. 인자 고정의 의도를 분명히 하고 싶으면 partial이에요.

---

## 4. 둘째 무리 — decorator 패턴 다섯

두 번째 무리는 데코레이터 패턴이에요. H2에서 데코레이터가 "함수를 감싸는 함수"라고 했죠. 그 패턴의 대표 다섯 개예요. 7~10번은 사실 Ch011 OOP(클래스)에서 깊이 배우는데, 오늘은 "이런 게 있다"만 구경해요.

**@decorator — 일반 데코레이터.** H2에서 본 `@timer` 같은 거요. 함수에 기능을 덧입혀요.

**@property — getter를 속성처럼.** 메서드를 괄호 없이 속성처럼 부르게 해 줘요.

```python
class Cat:
    def __init__(self, name):
        self._name = name

    @property
    def name(self):
        return self._name.upper()

cat = Cat("까미")
cat.name   # '까미' 대문자로 (메서드인데 () 없이!)
```

`cat.name()`이 아니라 `cat.name`으로 부르죠. 계산이 필요한 값을 속성처럼 깔끔하게 보여줄 때 써요. 왜 이게 좋냐면, 쓰는 사람이 그게 "그냥 저장된 값"인지 "계산되는 값"인지 신경 안 써도 되거든요. `cat.name`이라고만 쓰면, 안에서 대문자로 바꾸든 뭘 하든 알아서 해 줘요. 처음엔 `_name`에 그냥 저장만 하다가, 나중에 "이름을 항상 대문자로 보여주자"가 되면, property 안에만 `.upper()`를 추가하면 돼요. 쓰는 쪽 코드(`cat.name`)는 한 글자도 안 바뀌고요. 이게 H1에서 말한 "추상화"의 한 모습이에요. 복잡함을 property 뒤에 숨기는 거죠.

**@classmethod — 클래스 메서드.** 인스턴스 말고 클래스 자체에 묶인 메서드예요.

```python
class Cat:
    @classmethod
    def create(cls, name):
        return cls(name)

Cat.create("까미")
```

주로 객체를 만드는 다른 방법(팩토리)을 제공할 때 써요. `self` 대신 `cls`를 받죠.

**@staticmethod — 정적 메서드.** 클래스 안에 있지만, 클래스나 인스턴스와 상관없는 그냥 함수예요.

```python
class MathUtils:
    @staticmethod
    def double(x):
        return x * 2

MathUtils.double(5)   # 10
```

**@dataclass — 클래스 boilerplate 자동.** 이게 정말 유용해요. 데이터를 담는 클래스를 한 방에 만들어 줘요.

```python
from dataclasses import dataclass

@dataclass
class Cat:
    name: str
    age: int

cat = Cat("까미", 3)
print(cat)   # Cat(name='까미', age=3)
```

`@dataclass` 한 줄이면, `__init__`이며 `__repr__`이며 귀찮은 코드를 다 자동으로 만들어 줘요. 본인은 name과 age 두 줄만 적었는데, 완전한 클래스가 생기죠. H5에서 본인의 환율 계산기 v3에 이 dataclass를 써요.

다섯 개. 이 중 @dataclass는 본인이 곧 매일 쓰게 돼요. property·classmethod·staticmethod는 Ch011에서 클래스를 배우며 깊이 만나요. 오늘은 "데코레이터가 이렇게 다양하게 쓰이는구나"만 느끼면 돼요.

@dataclass가 얼마나 고마운지, 없을 때와 있을 때를 비교해 볼게요. dataclass 없이 Cat 클래스를 제대로 만들려면, `__init__`에서 self.name = name, self.age = age를 일일이 적고, 출력을 위해 `__repr__`을 또 적고, 두 cat을 비교하려면 `__eq__`도 적어야 해요. 열 줄이 넘어가죠. 그런데 `@dataclass`를 붙이면 name과 age 두 줄만 적으면, 그 모든 게 자동으로 생겨요. `Cat("까미", 3)`로 만들 수 있고, print하면 예쁘게 나오고, 두 cat이 같은지 비교도 돼요. 손으로 적던 boilerplate(판에 박힌 반복 코드)를 데코레이터 한 줄이 다 대신해 주는 거예요. 그래서 자경단은 데이터를 담는 클래스를 거의 다 dataclass로 만들어요. cat, user, 환율 정보, 설정 같은 것들이요. H5에서 본인이 환율 계산기 v3를 만들 때, Cat을 dataclass로 정의해요. 오늘 본 이게 거기서 바로 쓰이는 거예요.

그리고 이 다섯 데코레이터를 보면서 한 가지를 느꼈으면 좋겠어요. 데코레이터는 "반복되는 작업을 한 줄로 자동화하는" 도구라는 거예요. @lru_cache는 캐싱을 자동화하고, @dataclass는 클래스 코드를 자동화하고, @property는 getter를 깔끔하게 만들죠. 공통점은 "본인이 손으로 적을 귀찮은 걸, 골뱅이 한 줄이 대신해 준다"예요. 그래서 데코레이터를 잘 쓰는 사람은 코드가 짧고 깔끔해요. H2에서 closure가 데코레이터의 토대라고 했죠. 그 토대 위에 이런 편리한 도구들이 지어진 거예요. H5에서 본인이 직접 데코레이터를 짜 보면, 이 자동화의 힘을 손으로 느껴요.

---

## 5. 셋째 무리 — 함수 검사 네 도구

세 번째 무리는 함수 검사 도구예요. H3에서 inspect를 봤죠. 그 세 개 — `inspect.signature`(시그니처), `inspect.getsource`(소스), `inspect.getdoc`(docstring) — 가 여기 다시 나와요. H3에서 배운 거라 짧게 넘어갈게요.

새로 하나만 더 볼게요. **callable — 호출 가능 여부 검사.**

```python
callable(print)         # True (함수니까)
callable("hello")       # False (문자열은 못 부름)
callable(lambda: 0)     # True (lambda도 함수)
```

`callable(x)`는 "x를 `x()`처럼 부를 수 있나?"를 알려 줘요. 함수, lambda, 클래스는 True고, 숫자·문자열은 False예요. 어떤 값이 함수인지 데이터인지 확인할 때 써요. H1에서 "함수는 일급 객체"라 변수에 담긴다고 했죠. 그래서 변수에 함수가 들었는지 데이터가 들었는지 헷갈릴 때, callable로 확인하는 거예요.

네 도구. 함수의 정보를 캐고 검사하는 도구들이에요. 매일 직접 쓰진 않지만, 데코레이터나 자동화 도구를 짤 때 든든해요. 함수를 다루는 함수를 짤 때 비로소 빛을 봐요.

callable이 실전에서 쓰이는 자리를 하나 보여 드릴게요. 어떤 함수가 인자로 "값이나 함수 둘 다" 받을 수 있게 만들 때예요. 예를 들어 기본값을 받는데, 그게 그냥 값일 수도 있고 "값을 만드는 함수"일 수도 있다고 쳐요. 이때 `if callable(default): default = default()`처럼 써요. "받은 게 함수면 불러서 값을 얻고, 값이면 그대로 쓴다"는 거죠. 이게 함수가 일급 객체라서 생기는 유연함이에요. 값과 함수를 같은 자리에서 받을 수 있으니, callable로 구분하는 거예요. 지금은 어려우면 넘어가도 돼요. "값인지 함수인지 헷갈릴 때 callable로 확인한다"만 기억하면, 나중에 그런 코드를 만났을 때 안 당황해요.

---

## 6. 넷째 무리 — 비동기 함수 도구

마지막 무리는 비동기 함수예요. Ch008 H7에서 async를 살짝 봤죠. 함수 버전으로 다시 만나요. 비동기는 "기다리는 동안 다른 일을 하는" 방식이에요.

**async def — 비동기 함수 정의.**

```python
async def fetch(url):
    response = await http.get(url)
    return response.text
```

`def` 앞에 `async`를 붙이면 비동기 함수예요. 일반 함수와 달리, 중간에 "기다림"을 둘 수 있어요.

**await — 비동기 결과 기다리기.** `await http.get(url)`은 "응답이 올 때까지 기다리되, 기다리는 동안 다른 일을 해도 돼"라는 뜻이에요. 일반 함수는 기다리는 동안 멍하니 멈춰 있지만, 비동기는 그 시간에 다른 요청을 처리해요.

**asyncio.run — 비동기 함수 실행.** 비동기 함수는 그냥 부르면 안 돌아가요. `asyncio.run`으로 시동을 걸어야 해요.

```python
import asyncio

asyncio.run(fetch("https://api.com"))
```

**asyncio.gather — 여러 비동기 동시 실행.** 이게 비동기의 진짜 힘이에요.

```python
results = await asyncio.gather(
    fetch("url1"),
    fetch("url2"),
    fetch("url3"),
)
```

URL 세 개를 동시에 가져와요. 하나씩 기다리면 3초 걸릴 게, 동시에 하면 1초에 끝나죠. 까미가 외부 API 여러 개를 부를 때 이걸 써요. 자경단 사이트가 cat 정보를 보여줄 때, 사진 서버·DB·외부 평점 API 세 곳에서 데이터를 가져와야 한다면, 이걸 gather로 동시에 부르는 거예요. 사용자는 1초 만에 페이지를 보고, 안 그러면 3초를 기다리죠. 그 2초 차이가 사용자가 "빠르다"고 느끼느냐 "느리다"고 느끼느냐를 가르고, 그게 서비스의 인상을 좌우해요. 비동기 한 줄이 사용자 경험을 바꾸는 거예요. 그래서 백엔드에서 비동기가 중요한 거고요. 본인이 Ch041에서 FastAPI를 배울 때, 이 async가 기본으로 깔려 있어요. FastAPI 자체가 비동기 위에 지어진 프레임워크거든요. 오늘 본 async def·await·gather가 거기서 본인의 매일 도구가 돼요.

비동기는 Ch020에서 깊이 배워요. 오늘은 그림만 그리면 돼요. "기다림이 많은 일(HTTP, DB)에는 비동기가 빠르다" 이 한 문장이면 충분해요. CPU를 빡세게 쓰는 일에는 비동기가 도움이 안 돼요. 거기엔 다른 도구(multiprocessing)가 필요하고요. 그 구분은 오해 코너에서 다시 짚을게요.

비동기가 왜 빠른지 비유로 풀어 볼게요. 본인이 라면을 세 개 끓인다고 쳐요. 일반(동기) 방식은 이래요. 첫 번째 냄비에 물 올리고, 끓을 때까지 멍하니 3분 기다리고, 라면 넣고, 또 기다리고, 다 되면 두 번째 냄비를 시작해요. 세 개면 15분이 걸리죠. 비동기 방식은 달라요. 세 냄비에 다 물을 올려놓고, 끓는 동안 다른 냄비를 챙겨요. "물 끓기를 기다리는 시간"에 다른 일을 하는 거예요. 그러면 세 개가 거의 동시에 5분에 다 돼요. 핵심은 "기다리는 시간을 놀리지 않는다"예요. HTTP 요청은 응답이 올 때까지 기다리는 시간이 대부분이에요. 그 기다림 동안 다른 요청을 처리하면, 여러 개를 거의 동시에 해치울 수 있죠. 그게 `asyncio.gather`가 하는 일이에요. 까미가 외부 API 다섯 개를 부를 때, 하나씩 기다리면 5초, gather로 동시에 하면 1초. 그 차이가 비동기예요.

그런데 라면 비유로 비동기의 한계도 보여요. 만약 일이 "기다림"이 아니라 "본인이 직접 칼질하는 것"이라면? 양파 세 개를 써는 건 비동기로 안 빨라져요. 본인 손은 하나니까, 결국 하나씩 썰어야 해요. CPU 계산이 그래요. 본인(CPU)이 직접 빡세게 계산하는 일은, 비동기로 묶어도 결국 하나씩 해야 해서 안 빨라져요. 그땐 일꾼을 여러 명 부르는 multiprocessing이 필요하죠. 그래서 "기다림 = 비동기, 직접 일 = multiprocessing"이에요. 이 구분만 알면 본인은 이미 비동기의 절반을 이해한 거예요. 나머지 절반은 Ch020에서요.

---

## 7. 매일·주간·월간 리듬

18 도구를 다 똑같이 쓰는 게 아니에요. 빈도가 달라요. 자경단의 리듬으로 묶어 드릴게요.

**매일 쓰는 6개** — def, return, type hints, lambda, sorted+key, list comprehension. 사실 이건 18 도구라기보다 H1~H2에서 배운 기본이에요. 매일 손가락에서 나와요.

**주간에 쓰는 7개** — partial, lru_cache, @property, @dataclass, @classmethod, \*args, \*\*kwargs. 일주일에 몇 번씩 만나요.

**월간에 쓰는 5개** — @staticmethod, reduce, wraps, async def, await. 한 달에 몇 번, 특별한 자리에서요.

이 리듬이 중요한 이유는, 본인이 "뭘 먼저 익힐지"를 정해 주거든요. 매일 쓰는 6개부터 손에 익히세요. 그게 손가락에 박히면, 주간 7개로, 그 다음 월간 5개로 넓혀 가요. 18개를 한 번에 다 익히려 하면 지쳐요. 매일 쓰는 것부터, 자주 쓰는 순서대로. 그러면 자연스럽게 다 익어요. 안 쓰는 도구는 안 익혀도 돼요. 필요해질 때 그때 익히면 되거든요. 도구는 쓰면서 익는 거지, 외워서 익는 게 아니에요.

이걸 누적으로 보면 본인이 얼마나 부자가 됐는지 보여요. Ch006에서 셸 명령어 30개, Ch007에서 Python 기본 18개, Ch008에서 흐름 18개, 그리고 이번 Ch009에서 함수 18개. 합치면 본인 손에 84개의 도구가 있어요. 1년 전 터미널 한 줄도 무서웠던 본인이, 지금은 84개를 손가락에 달고 다녀요. 그런데 이 도구들의 진짜 힘은, 아까 13줄 흐름에서 봤듯이 "서로 엮인다"는 거예요. 셸로 파일을 찾고, Python으로 읽고, 흐름으로 처리하고, 함수로 묶어요. 84개가 따로 노는 게 아니라 한 코드 안에서 손을 잡아요. 본인이 챕터를 지날수록 이 도구들이 점점 더 촘촘하게 엮여요. 그게 본인이 진짜 프로그램을 짤 수 있게 되는 과정이에요. 도구 하나하나는 작지만, 84개가 엮이면 자경단 사이트 같은 큰 걸 만들 수 있어요. 본인은 지금 그 길을 정확히 걷고 있어요.

---

## 8. 자경단 매일 13줄 흐름

자경단이 매일 짜는 코드 한 토막을 보면서, 18 도구가 실제로 어떻게 어울리는지 볼게요.

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

13줄 안에 18 도구 중 여러 개가 어울려 있어요. `@dataclass`로 Cat을 만들고, `@lru_cache`로 비싼 계산을 캐싱하고, `Callable` 타입 힌트로 "함수를 받는 함수"를 표현하고, `partial`로 인자를 고정하고, comprehension으로 거르죠. 이게 자경단의 평범한 하루 코드예요. 화려한 게 아니라, 배운 도구들을 적재적소에 엮은 거예요. 본인이 H1부터 배운 게 다 여기 모여 있죠. 일급 객체(함수를 인자로), comprehension(Ch008), 데코레이터(H2), 그리고 오늘의 도구들이요. 이렇게 도구들이 한 줄 한 줄 손을 잡아 진짜 프로그램이 돼요. H5에서 본인이 이런 코드를 직접 짜요.

특히 `filter_cats` 함수가 `pred: Callable[[Cat], bool]`을 받는 부분을 한 번 더 볼게요. 이게 함수를 인자로 받는 함수예요. H1에서 "함수는 일급 객체"라 인자로 넘길 수 있다고 했죠. 그 실제 모습이에요. `filter_cats`는 "어떤 조건으로 거를지"를 함수로 받아요. 그래서 `is_adult`(성인인지)를 넘기면 성인만, 다른 조건을 넘기면 그 조건대로 걸러요. 함수 자체를 바꿔 끼우면 동작이 바뀌는 거죠. 이게 코드를 유연하게 만드는 강력한 패턴이에요. `sorted`의 key도, `filter`도 다 이 원리예요. "동작의 일부를 함수로 받아서, 바꿔 끼울 수 있게 한다." 본인이 이 패턴을 손에 익히면, 같은 함수를 여러 상황에 재사용할 수 있어요. 한 번 짠 `filter_cats`가 조건만 바꿔서 백 군데에 쓰이는 거죠. 이게 함수가 일급 객체라서 가능한 우아함이에요.

---

## 9. 다섯 함정과 처방

18 도구를 쓰며 자주 빠지는 함정 다섯 개와 처방이에요.

**함정 1: lru_cache에 mutable 인자.** lru_cache는 인자를 키로 기억하는데, 리스트 같은 mutable은 키가 될 수 없어요(unhashable). 처방은 immutable(숫자·문자열·튜플) 인자에만 쓰는 거예요.

**함정 2: 데코레이터에 wraps 누락.** 원래 함수의 이름·docstring이 사라져요. 처방은 wrapper 위에 항상 `@functools.wraps(func)`를 붙이는 거예요.

**함정 3: @property에 setter 누락.** property는 기본이 읽기 전용이에요. 값을 바꾸려 하면 에러가 나요. 처방은 `@이름.setter`를 추가로 정의하는 거예요. Ch011에서 배워요.

**함정 4: @classmethod에 self를 씀.** classmethod는 self가 아니라 cls를 받아요. 처방은 첫 인자를 cls로 쓰는 거예요.

**함정 5: 비동기 함수를 일반 함수처럼 호출.** `fetch(url)`이라고만 하면 코루틴 객체만 나오고 실행이 안 돼요. 처방은 `asyncio.run(fetch(url))`이나 `await fetch(url)`로 부르는 거예요. Ch008 H7에서 본 함정이죠. 초보가 비동기 함수를 처음 만나면 "분명히 함수를 불렀는데 왜 아무 일도 안 일어나지?" 하고 한참 헤매요. `<coroutine object>`라는 이상한 게 출력되면, 아 비동기 함수를 그냥 불렀구나, 하고 알아채세요.

다섯 함정. 미리 알아 두면 그 사고를 만났을 때 당황 안 해요.

이 중에 본인이 가장 자주 만날 건 함정 1(lru_cache mutable 인자)이에요. 조금 더 풀어 볼게요. lru_cache는 "이 입력은 전에 본 적 있나?"를 딕셔너리로 확인해요. 그런데 딕셔너리의 열쇠는 변하지 않는(hashable) 것만 될 수 있어요. Ch010에서 배울 내용인데, 리스트는 변할 수 있어서 열쇠가 못 돼요. 그래서 `@lru_cache`를 붙인 함수에 리스트를 넘기면 `TypeError: unhashable type: 'list'`가 나요. 처방은 리스트 대신 튜플을 넘기는 거예요. 튜플은 안 변하니까 열쇠가 될 수 있거든요. 아니면 그냥 숫자·문자열 인자에만 lru_cache를 쓰면 되고요. 이건 "캐싱은 같은 입력 = 같은 출력일 때만 된다"는 원리와도 연결돼요. 입력을 열쇠로 기억하려면, 그 입력이 안 변해야 하니까요. 이 함정 하나만 알아도 lru_cache를 안전하게 써요.

---

## 10. 흔한 오해 다섯 가지

**오해 1: lru_cache를 붙이면 항상 빨라진다.**

아니에요. 캐싱 자체에도 비용이 있어요. 결과를 저장하고 찾는 시간이요. 아주 가벼운 함수에 붙이면 오히려 손해예요. 비싼 계산을 반복할 때만 효과가 있어요. fib처럼요.

**오해 2: @dataclass는 무겁다.**

아니에요. 가벼워요. 오히려 boilerplate 코드를 줄여서 더 깔끔해져요. 데이터를 담는 클래스라면 거의 항상 dataclass가 정답이에요.

**오해 3: @property는 거의 안 쓴다.**

아니에요. 자경단 OOP 코드에서 매일 써요. 계산이 필요한 값을 속성처럼 깔끔하게 보여줄 때 필수예요. Ch011에서 그 진가를 봐요.

**오해 4: async를 모든 곳에 쓰면 빠르다.**

아니에요. 비동기는 기다림이 많은 일(HTTP, DB, 파일)에만 빨라요. CPU를 빡세게 쓰는 계산엔 도움이 안 돼요. 거긴 multiprocessing이 필요해요. 도구를 일의 성격에 맞춰야 해요.

**오해 5: partial이랑 lambda는 똑같다.**

비슷하지만 partial이 더 명확해요. `partial(add, 5)`는 "add의 첫 인자를 5로 고정"이 분명히 읽히거든요. lambda는 더 짧지만 의도가 덜 보여요. 인자 고정이 목적이면 partial을 권해요.

다섯 오해를 부수고 나니 공통점이 보이죠. 다 "도구를 만능으로 착각하는" 오해예요. lru_cache가 항상 빠른 게 아니고, async가 모든 걸 빠르게 하는 게 아니에요. 모든 도구는 "맞는 자리"가 있어요. lru_cache는 비싼 반복 계산에, async는 기다림 많은 일에, dataclass는 데이터 클래스에. 도구를 배울 때 "이건 언제 쓰면 안 되는가"를 같이 배우는 게 중요해요. 망치가 좋다고 모든 걸 망치로 치면 안 되잖아요. 나사엔 드라이버를 써야죠. 좋은 개발자는 도구를 많이 아는 사람이 아니라, "이 상황엔 이 도구, 저 상황엔 저 도구"를 정확히 고르는 사람이에요. 오늘 18 도구를 배우면서, 각 도구의 "맞는 자리"를 같이 기억하세요. 그게 카탈로그를 제대로 보는 법이에요.

---

## 11. 자주 받는 질문 여섯 가지

**Q1. lru_cache랑 cache 중 뭘 써요?**

`cache`는 무제한으로 다 기억하고, `lru_cache(maxsize=N)`은 최근 N개만 기억해요. 메모리가 걱정되면 lru_cache로 한도를 두고, 입력 가짓수가 적어 무제한 기억해도 괜찮으면 cache를 쓰세요. 보통은 lru_cache가 안전해요.

**Q2. @dataclass랑 그냥 class 중 뭘 써요?**

데이터를 담는 게 주 목적이면 dataclass예요. `__init__`, `__repr__`을 자동으로 만들어 주니까요. 복잡한 동작이 많은 클래스면 일반 class고요. 단순 데이터는 무조건 dataclass가 편해요.

**Q3. 데코레이터를 여러 개 붙일 수 있어요?**

네. 함수 위에 여러 줄로 쌓으면 돼요. 적용 순서는 위에서 아래로 감싸요. `@a` 다음 `@b`면, b가 먼저 감싸고 a가 그 위를 감싸요. 순서가 중요할 때가 있으니 주의하세요.

**Q4. partial이 함수 호출보다 느리지 않아요?**

아주 살짝 느려요. 그런데 무시해도 될 수준이에요. 성능보다 "코드가 명확해지는" 이득이 훨씬 커요. 미세한 속도 차이로 partial을 피할 이유는 없어요. 성능 최적화는 H3에서 배운 대로 측정해서 진짜 병목을 찾는 거지, partial 같은 데서 나노초를 아끼는 게 아니에요.

**Q5. asyncio는 언제 배워요? 지금 다 이해해야 하나요?**

아니에요. 오늘은 그림만요. 비동기는 Ch020에서 깊이 배워요. HTTP나 DB를 많이 다루는 백엔드에서 진가를 발휘하죠. 지금은 "기다림 많은 일엔 비동기"라는 한 문장만 챙기세요.

**Q6. 18개를 다 못 외우겠어요. 괜찮은가요?**

완전히 괜찮아요. 오히려 정상이에요. 18개를 한 번에 외우는 사람은 없어요. 오늘 목표는 외우는 게 아니라 "구경"이에요. 백화점을 한 바퀴 돌면서 "여기 신발 코너, 저기 가방 코너"를 봐 둔 거랑 같아요. 나중에 신발이 필요하면 "아, 신발 코너 있었지" 하고 가면 되잖아요. 도구도 그래요. 느린 함수를 만나면 "캐싱하는 도구 있었지" → 검색 → lru_cache. 데이터 클래스가 필요하면 "그거 자동으로 만들어 주는 거 있었지" → 검색 → dataclass. 이렇게 "존재 → 검색 → 사용"의 흐름이면 충분해요. 외우는 건 매일 쓰다 보면 저절로 돼요. 그러니 오늘 하나도 안 외워졌어도 괜찮아요. 18개가 있다는 것만 알면, 오늘은 대성공이에요.

---

## 12. 흔한 실수 다섯 + 안심 — 함수 명령어 학습 편

함수 도구를 익히며 자주 빠지는 함정 다섯 개예요.

**첫째, 내장 함수를 다 외우려 하기.** 안심하세요. print, len, range 같은 매일 쓰는 것부터요. 나머지는 필요할 때 찾으면 돼요. 18 도구도 마찬가지예요.

**둘째, 함수 이름을 너무 짧게 짓기.** 안심하세요. `calc`보다 `calculate_total`이 나아요. 길어도 명확한 이름이 좋아요. 타이핑은 자동완성이 도와줘요.

**셋째, 한 함수에 여러 책임을 담기.** 안심하세요. "한 함수는 한 가지 일"이 원칙이에요. Single Responsibility요. H6에서 깊이 배워요.

**넷째, 부수 효과가 많은 함수.** 안심하세요. 가능하면 "입력을 받아 결과만 돌려주는" 순수 함수를 우선하세요. 이것도 H6에서요.

**다섯째, 가장 큰 함정 — 함수가 50줄을 넘기.** 안심하세요. 함수가 길어지면 둘로 나눌 신호예요. 보통 20줄 안쪽이 읽기 좋아요. 길면 나누세요. 이건 H6에서 본격적으로 다루는데, 오늘부터 "함수가 화면을 넘으면 둘로"를 마음에 새겨 두세요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 가요.

---

## 13. 마무리

자, 함수의 네 번째 시간이 끝났어요.

오늘 본인은 함수 18 도구를 카탈로그로 구경했어요. functools 다섯(reduce·partial·lru_cache·wraps·cache), decorator 패턴 다섯(@decorator·@property·@classmethod·@staticmethod·@dataclass), 함수 검사 네 개(signature·getsource·getdoc·callable), 비동기 네 개(async def·await·asyncio.run·asyncio.gather)요. 함수를 더 우아하고 강력하게 만드는 도구 상자가 채워졌어요.

오늘의 약속을 지켰어요. 18 도구가 머리에 들어왔죠. 다 외운 게 아니라, "이런 게 있고, 언제 쓰는지"를 아는 거예요. 그거면 충분해요. 매일 쓰는 6개부터 손에 익히고, 나머지는 필요할 때 이 카탈로그로 돌아오세요.

한 가지만 더 짚고 넘어갈게요. 오늘 본 18 도구가 좀 어렵게 느껴졌을 수 있어요. 데코레이터, 비동기, functools… 낯선 단어가 많았죠. 그런데 걱정 마세요. 이건 "구경"이었어요. H1·H2에서 배운 기본(def·return·인자·lambda·closure)이 진짜 토대고, 오늘 본 18개는 그 토대 위에 얹는 "편의 도구"예요. 토대가 단단하면 편의 도구는 필요할 때 하나씩 익히면 돼요. 그러니 오늘 18개 중 단 하나, @dataclass만 기억해도 충분해요. 그게 본인이 가장 빨리, 가장 자주 쓰게 될 도구거든요. 나머지 17개는 "그런 게 있다"만요. 욕심내지 마세요. 카탈로그는 외우는 게 아니라 펼쳐 두고 필요할 때 보는 거예요.

다음 H5는 드디어 데모예요. 본인의 환율 계산기가 v2에서 v3로 자라요. H2에서 본 데코레이터를 직접 짜고, closure를 쓰고, 오늘 본 @dataclass와 @property를 적용해요. 오늘의 약속, H2의 약속이 다 H5에서 만나요. 그 전에 마지막으로 한 줄만 쳐 보세요.

```python
python3 -c "from functools import partial; add5 = partial(lambda a, b: a+b, 5); print(add5(3))"
```

`8`이 나와요. partial로 첫 인자를 5로 고정한 add5에 3을 넘기니 5+3=8이죠. 본인이 이 한 줄을 이해하면, 오늘 partial을 손에 쥔 거예요.

오늘 본인은 함수 챕터의 절반을 지났어요. H1에서 함수가 뭔지 보고, H2에서 짜는 법을 배우고, H3에서 들여다보는 도구를 익히고, 오늘 H4에서 함수를 강력하게 만드는 18 도구를 구경했어요. 이제 본인은 함수에 대해 "이론"은 거의 다 봤어요. 남은 절반(H5~H8)은 그걸 "실전"으로 옮기는 시간이에요. H5에서 직접 만들고, H6에서 잘 다듬고, H7에서 속을 파고, H8에서 묶어요. 가장 재미있는 절반이 남았어요. 본인이 배운 걸 손으로 옮기는 시간이거든요. 머리로 안 것과 손으로 한 것은 천지차이예요. 다음 시간에 봐요. 드디어 본인의 첫 데코레이터를 짜요. 오늘도 끝까지 와 주셔서 고마워요. 도구 상자가 점점 두둑해지고 있어요. 본인이 정말 자랑스러워요. 🐾

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - functools.reduce: `initial` value 옵션(`reduce(f, it, 0)`)으로 빈 iterable 안전. Python 3에서 builtin→functools로 이동.
> - lru_cache 통계: `fib.cache_info()` → hits/misses/maxsize/currsize. `cache_clear()`로 비움. `@cache`는 `lru_cache(maxsize=None)`.
> - @property + setter/deleter: getter(`@x.setter`)·setter·deleter 셋. descriptor protocol(`__get__`/`__set__`)의 적용.
> - @dataclass 옵션: `frozen=True`(immutable·hashable), `order=True`(비교), `slots=True`(메모리), `field(default_factory=list)`.
> - classmethod vs staticmethod: 전자는 `cls` 수신(상속·팩토리), 후자는 수신 없음(네임스페이스 그룹핑).
> - asyncio: `run`(엔트리)·`gather`(동시)·`create_task`(스케줄)·`wait`/`as_completed`·`Semaphore`(동시성 제한). event loop 단일 스레드 협력적 멀티태스킹.
> - 다음 H5 키워드: exchange_v3 · @timer · @validate · closure · @property · @dataclass.

---

## 추신

1. 함수 18 도구 — functools 5·decorator 5·검사 4·비동기 4.
2. 카탈로그=백화점 목록. 다 사는 게 아니라 구경.
3. 매일 쓰는 건 6개. 나머지는 필요할 때.
4. reduce=누적. 단순 합은 sum이 더 명확.
5. partial=인자 고정. add5 = partial(add, 5).
6. lru_cache=결과 캐싱(N개). LRU=오래 안 쓴 것부터 버림.
7. cache=무제한 캐싱. lru_cache의 단순판.
8. wraps=데코레이터 메타 보존. 거의 필수.
9. lru_cache·wraps가 functools 중 매일 쓰는 둘.
10. @property=메서드를 () 없이 속성처럼.
11. @classmethod=cls 받음. 팩토리에.
12. @staticmethod=클래스 안 일반 함수.
13. @dataclass=클래스 boilerplate 자동. 매일 써요.
14. property·classmethod·staticmethod는 Ch011 OOP에서 깊이.
15. callable(x)=x() 가능한지. 함수=True, 문자열=False.
16. 함수가 일급 객체라 변수에 든 게 함수인지 callable로 확인.
17. async def=비동기 함수. await=기다림.
18. asyncio.run=시동. asyncio.gather=동시 실행.
19. 비동기는 기다림 많은 일(HTTP·DB)에만. Ch020에서.
20. CPU 빡센 일은 비동기 X, multiprocessing.
21. 리듬 — 매일 6·주간 7·월간 5. 자주 쓰는 순서로.
22. 13줄 흐름 — dataclass·lru_cache·Callable·partial·comp.
23. lru_cache mutable 인자 함정. immutable만.
24. 데코레이터 wraps 누락 함정. 항상 @wraps.
25. async 일반 호출 함정. asyncio.run/await.
26. lru_cache 항상 빠른 거 아님. 비싼 함수에만.
27. partial > lambda(인자 고정 의도가 명확).
28. 함수 이름 길어도 명확하게. calculate_total>calc.
29. 데코레이터 여러 개 가능. 위에서 아래로 감쌈.
30. 다음 H5는 데모. 첫 데코레이터를 직접 짜요. 🐾
