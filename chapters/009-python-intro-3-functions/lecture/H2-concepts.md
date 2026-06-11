# Ch009 · H2 — 함수 8개념 — def 6 인자부터 closure까지

> 고양이 자경단 · Ch 009 · 2교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

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
13. 흔한 실수 다섯 + 안심
14. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
def f(a, b=10, *args, c=20, **kwargs):
    return a + b + c

def add_cat(cats=None):          # mutable default 처방
    cats = cats or []
    cats.append("새")
    return cats

double = lambda x: x * 2          # lambda

def make_counter():               # closure
    count = 0
    def inc():
        nonlocal count
        count += 1
        return count
    return inc
```

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요. 다시 만났어요. 함수 챕터의 두 번째 시간이에요. 바로 이어서 가요.

지난 H1을 한 줄로 회수할게요. 본인은 함수의 큰 그림을 봤어요. 함수는 코드 재사용의 도구라는 것, 네 친구(def·return·\*args·\*\*kwargs), 다섯 종류(일반·lambda·closure·decorator·generator), 그리고 자경단 다섯 명이 매일 125개씩 짠다는 것까지요. 본인은 첫 함수 `greet`도 손으로 쳐 봤죠. 큰 그림은 다 그렸어요.

이번 H2는 그 큰 그림 안을 깊이 파는 시간이에요. 함수의 8개념을 하나씩 손에 쥐어요. def의 여섯 인자 종류, return의 다섯 패턴, default 인자와 그 유명한 함정, \*args와 \*\*kwargs, type hints, docstring, lambda, 그리고 closure. 이 여덟 개가 함수의 진짜 어휘예요. H1이 함수를 "구경"한 거라면, H2는 함수를 "손에 쥐는" 시간이에요.

오늘의 약속은 이거예요. **이 시간에 본인이 H5에서 만들 데코레이터의 토대가 박힙니다**. 특히 마지막 8번째 개념인 closure가 데코레이터의 핵심 부품이에요. 오늘 closure를 이해하면, H5에서 본인이 데코레이터를 짤 때 "아, 이게 그거였구나" 하게 돼요. 그러니 오늘은 좀 집중해서 들으세요. 8개념이 좀 많아 보이지만, 매일 쓰는 건 그중 절반이에요. 나머지는 "이런 게 있구나" 정도로 구경하면 돼요.

오늘 8개념을 한 그림으로 미리 묶어 드릴게요. 함수를 사람으로 치면, def 인자는 그 사람이 "무엇을 받는지"(입), return은 "무엇을 내놓는지"(손), type hint와 docstring은 "자기소개"(이름표), lambda는 "잠깐 쓰는 작은 일꾼", closure는 "기억을 품은 일꾼"이에요. 그러니까 오늘은 함수가 입력을 받고(인자), 출력을 내고(return), 자기를 설명하고(type hint·docstring), 특별한 변신을 하는(lambda·closure) 그 전부를 보는 거예요. 함수의 모든 면을요. 이걸 다 보고 나면, 본인은 어떤 함수를 봐도 "아, 여기 인자는 이렇고, 이걸 돌려주고, 이런 함수구나"를 한눈에 읽어요. 자, 가요.

---

## 2. 첫째 — def의 여섯 인자 종류

첫 번째 개념. Python 함수는 인자를 받는 방식이 여섯 가지나 돼요. 좀 많죠? 그런데 걱정 마세요. 매일 쓰는 건 두 가지뿐이에요. 나머지 네 개는 "이런 것도 있다" 정도로 보면 돼요.

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

하나씩 볼게요. **1. 위치 전용**은 `/` 앞에 있는 인자예요. 무조건 위치로만 넘겨야 하고, 이름으로는 못 넘겨요. 거의 안 써요. **2. 위치 또는 키워드**가 본인이 매일 쓰는 그거예요. `f(2, 3)`처럼 위치로도, `f(a=2, b=3)`처럼 이름으로도 넘길 수 있죠. **3. 가변 위치**가 `*args`고, **4. 키워드 전용**은 `*` 다음에 오는 인자라서 무조건 이름으로 넘겨야 해요. **5. 가변 키워드**가 `**kwargs`예요.

그리고 여섯 번째는 종류라기보다 성질인데, **default(기본값)**예요. 위의 어떤 인자든 `= 값`으로 기본값을 줄 수 있어요.

```python
def f(a, b=10, *args, c=20, **kwargs):
    ...
```

여기서 b와 c가 기본값을 가졌죠. 자, 정리할게요. 자경단에서 매일 쓰는 건 1, 2번 — 정확히는 "위치 또는 키워드" 인자 — 가 90%예요. 4번 키워드 전용은 가끔, 인자가 많아서 이름을 강제하고 싶을 때 써요. 1번 위치 전용은 거의 안 써요. 그러니 본인은 지금 "보통 인자(위치 또는 키워드)와 기본값" 이 두 개만 확실히 알면 돼요. 나머지는 나중에 코드에서 만나면 "아, H2에서 본 거다" 하면 돼요.

키워드 전용 인자(4번)는 실전에서 의외로 유용해요. 예를 들어 `def save(data, *, overwrite=False)`처럼 `*` 다음에 overwrite를 두면, 누가 `save(data, True)`처럼 헷갈리게 못 쓰고 무조건 `save(data, overwrite=True)`라고 이름을 붙여야 해요. 그러면 코드를 읽는 사람이 "아, True가 overwrite구나"를 바로 알죠. bool 인자에 특히 좋아요. 이건 H6에서 좋은 함수 설계로 다시 나와요.

여기서 자경단의 1년 사용 통계를 보여 드릴게요. 까미가 1년 동안 짠 함수의 인자를 분석했더니 이렇게 나왔어요.

| 인자 종류 | 1년 사용 비율 | 언제 |
|----------|-------------|------|
| 위치 또는 키워드 + default | 90% | 거의 모든 함수 |
| 키워드 전용 (`*` 다음) | 6% | bool·옵션 인자 |
| **kwargs | 4% | 설정 전달·데코레이터 |
| *args | 2% | 개수 가변 합산류 |
| 위치 전용 (`/` 앞) | 0.1% | 거의 안 씀 |

보세요. 90%가 그냥 "보통 인자 + 기본값"이에요. 그러니 본인이 지금 집중할 건 딱 그거예요. 나머지는 "이런 게 있다"만 알면, 코드에서 만났을 때 당황 안 해요. Python이 인자 종류를 여섯 개나 만든 건, 정말 특수한 상황까지 다 표현할 수 있게 하려고예요. 그런데 그 특수한 상황은 본인이 1~2년 코드를 짜다 보면 자연스럽게 만나요. 그때 배워도 안 늦어요. 지금은 "보통 인자와 기본값"만 단단히요.

---

## 3. 둘째 — return의 다섯 패턴

두 번째 개념. return에도 다섯 가지 패턴이 있어요. 함수가 결과를 돌려주는 방식이죠.

**1. 단일 값.** 가장 기본이에요. 값 하나를 돌려줘요.

```python
def add(a, b):
    return a + b
```

**2. 여러 값 (tuple).** Python은 값을 여러 개 한 번에 돌려줄 수 있어요. 사실은 튜플로 묶여서 나가요.

```python
def divmod_pair(a, b):
    return a // b, a % b

q, r = divmod_pair(10, 3)   # 3, 1
```

`return a // b, a % b`가 `(몫, 나머지)` 튜플을 돌려주고, `q, r =`로 받으면서 풀어져요. Ch007에서 배운 튜플 언패킹이 여기서 쓰여요. 자료형이 함수와 만나는 거예요.

**3. 조건부 None.** 찾으면 값을, 못 찾으면 None을 돌려주는 패턴이에요.

```python
def find(items, key):
    for item in items:
        if item == key:
            return item
    return None
```

이게 자경단에서 정말 자주 쓰는 패턴이에요. "있으면 주고, 없으면 None." Ch008에서 배운 early return의 모습이기도 하죠.

**4. 명시적 None.** 돌려줄 게 없는 함수예요. print만 하고 끝나는 것처럼요.

```python
def log(msg):
    print(msg)
    return None  # 또는 그냥 return
```

사실 `return`을 안 써도 자동으로 None이 나와요. 그런데 "나는 일부러 아무것도 안 돌려준다"를 분명히 하고 싶으면 `return None`을 명시하기도 해요.

**5. 예외 발생.** 정상적인 답 대신, "이건 잘못됐어!"를 알리는 패턴이에요.

```python
def divide(a, b):
    if b == 0:
        raise ValueError("0으로 나눔")
    return a / b
```

다섯 패턴. 매일 쓰는 건 1, 3, 5번이 90%예요. 단일 값, 조건부 None, 그리고 잘못된 입력엔 예외. 이 세 가지가 함수가 결과를 다루는 기본 자세예요.

여기서 한 가지 설계 팁을 드릴게요. "한 함수에서 여러 종류의 타입을 돌려주지 마세요." 무슨 말이냐면, 어떤 때는 숫자를 돌려주고 어떤 때는 문자열을 돌려주고 어떤 때는 None을 돌려주는 함수는 쓰기 어려워요. 그걸 받는 쪽이 매번 "이번엔 뭐가 왔지?"를 확인해야 하거든요. 좋은 함수는 "항상 같은 종류"를 돌려줘요. 값이 있으면 그 값, 없으면 None — 이렇게 "값 또는 None" 정도가 한계예요. 그래서 type hint도 `-> str | None`까지가 자연스럽고, `-> str | int | None | bool`처럼 종류가 많아지면 함수 설계를 다시 봐야 한다는 신호예요. 그리고 3번 조건부 None을 쓸 때 주의할 게 있어요. 받는 쪽에서 `result = find(...)` 다음에 꼭 `if result is None:`으로 확인해야 해요. None인데 그냥 `.name`을 부르면 그 유명한 `AttributeError: 'NoneType'`이 터지거든요. 이게 초보자가 가장 많이 만나는 에러 1위예요. 함수가 None을 돌려줄 수 있으면, 받는 쪽은 항상 None 검사를 한다. 이걸 습관으로 만드세요.

---

## 4. 셋째 — default 인자와 mutable 함정

세 번째 개념. 이건 정말 중요해요. Python의 가장 유명한 함정이거든요. 면접에도 단골로 나와요. 한 번 데이면 평생 안 잊어요.

핵심 사실 하나. **default 인자는 함수가 정의될 때 딱 한 번 평가돼요.** 함수를 부를 때마다가 아니라요. 그래서 default가 리스트나 딕셔너리 같은 mutable(변할 수 있는) 값이면 사고가 나요.

**Bad — 절대 이렇게 하지 마세요.**

```python
def add_cat(cats=[]):
    cats.append("새")
    return cats

add_cat()   # ['새']
add_cat()   # ['새', '새']  # 사고!
```

`cats=[]`라는 빈 리스트가 함수 정의 때 딱 한 번 만들어지고, 모든 호출이 그 똑같은 리스트를 공유해요. 그래서 부를 때마다 "새"가 쌓여요. 두 번째 호출에서 `['새', '새']`가 나오죠. 본인은 매번 새 리스트를 기대했는데, 실제론 하나를 계속 쓰는 거예요. 이게 진짜 헷갈리는 버그예요. 코드를 아무리 봐도 멀쩡해 보이거든요.

**Good — 이렇게 하세요.**

```python
def add_cat(cats=None):
    cats = cats or []
    cats.append("새")
    return cats
```

default를 `None`으로 두고, 함수 안에서 `cats = cats or []`로 빈 리스트를 새로 만들어요. 그러면 호출할 때마다 새 리스트가 생겨서 안전해요. 이게 자경단 표준이에요. **"mutable 기본값이 필요하면, None으로 두고 안에서 만들어라."** 이 한 문장만 기억하세요. 리스트, 딕셔너리, set을 기본값으로 쓸 일이 있으면 무조건 이 패턴이에요. ruff 같은 도구가 이걸 자동으로 잡아 주기도 해요(B006 규칙). 그래도 원리를 알아야 도구의 경고를 이해하죠.

왜 이런 일이 일어나는지 한 번 더 깊이 볼게요. Python이 `def add_cat(cats=[]):`를 읽을 때, 그 `[]`를 딱 한 번 만들어서 함수 객체에 붙여 둬요. `add_cat.__defaults__`라는 곳에 그 리스트가 저장돼요. 그리고 본인이 `add_cat()`을 부를 때마다, Python은 그 저장된 리스트를 그대로 가져다 써요. 새로 안 만들어요. 그래서 모든 호출이 같은 리스트를 공유하고, append가 쌓이는 거예요. 반대로 int나 str 같은 immutable(못 바꾸는) 값은 이 문제가 없어요. `def f(x=0)`은 안전해요. x를 바꿔도 새 값이 생기지 깊이 공유되지 않거든요. 그래서 정확히 말하면 함정은 "mutable default"일 때만이에요. 리스트·딕셔너리·set처럼 변할 수 있는 것만요. 숫자·문자열·튜플·None은 default로 써도 안전해요. 이 구분을 알면, 언제 조심하고 언제 편하게 쓸지가 분명해져요. 면접에서 "왜 이런 일이 생기죠?"라고 물으면, "default가 정의 시 한 번 평가되어 호출 간에 공유되기 때문"이라고 답하면 만점이에요.

---

## 5. 넷째 — *args와 **kwargs

네 번째 개념. H1에서 잠깐 만난 \*args와 \*\*kwargs를 좀 더 깊이 볼게요. 둘 다 "개수를 모르는 인자"를 받는 도구예요.

```python
def func(*args, **kwargs):
    print(args, kwargs)

func(1, 2, 3, name="까미")
# (1, 2, 3) {'name': '까미'}
```

`*args`는 이름 없이 위치로 넘어온 것들을 튜플로 묶어요 — `(1, 2, 3)`. `**kwargs`는 이름 붙여 넘어온 것들을 딕셔너리로 묶어요 — `{'name': '까미'}`. 이렇게 인자를 묶는 걸 packing(패킹)이라고 해요.

그런데 `*`과 `**`는 반대 방향으로도 쓸 수 있어요. 함수를 호출할 때 쓰면, 묶인 걸 풀어서 넘겨요. 이걸 unpacking(언패킹)이라고 해요.

```python
def add(a, b, c):
    return a + b + c

nums = [1, 2, 3]
add(*nums)   # add(1, 2, 3)와 같음

params = {"a": 1, "b": 2, "c": 3}
add(**params)   # add(a=1, b=2, c=3)와 같음
```

`add(*nums)`는 리스트 `[1, 2, 3]`을 풀어서 `add(1, 2, 3)`로 넘겨요. `add(**params)`는 딕셔너리를 풀어서 이름 붙은 인자로 넘기죠. 한쪽(함수 정의)에서는 묶고, 다른 쪽(함수 호출)에서는 풀어요. 같은 별표가 방향에 따라 반대 일을 하는 거예요. 자경단에서 이건 매일 써요. 특히 데코레이터를 짤 때 `def wrapper(*args, **kwargs)`로 "어떤 인자가 오든 다 받아서 그대로 넘기는" 패턴이 핵심이에요. 오늘 마지막 closure에서 그 모습을 봐요.

unpacking이 실전에서 빛나는 자리를 하나 더 보여 드릴게요. 딕셔너리를 함수 인자로 펼칠 때예요. 까미가 FastAPI로 사용자를 만들 때, 이런 코드를 자주 써요. `user_data = {"name": "까미", "age": 3}` 이런 딕셔너리가 있으면, `create_user(**user_data)`로 한 번에 넘겨요. 일일이 `create_user(name=user_data["name"], age=user_data["age"])`라고 안 써도 되죠. 딕셔너리가 통째로 풀려서 이름 붙은 인자가 돼요. 데이터를 딕셔너리로 다루다가 함수에 넘길 때, 이 `**`가 다리 역할을 해요. 반대로 `*`는 리스트나 튜플을 펼칠 때 써요. `point = (3, 4)`를 `draw(*point)`로 넘기면 `draw(3, 4)`가 되죠. 이 packing/unpacking 한 쌍이 Python 함수의 유연함을 만드는 핵심이에요. 처음엔 헷갈리지만, 몇 번 써 보면 "아, 묶고 푸는 거구나"가 손에 잡혀요.

---

## 6. 다섯째 — type hints 깊이

다섯 번째 개념. type hints예요. 인자와 반환의 타입을 적는 거죠. 기본 6패턴은 Ch007 H6에서 봤어요. 여기선 함수에 특화된 패턴 다섯 개를 볼게요.

**Optional — 값이 있을 수도, None일 수도.**

```python
def find(name: str) -> str | None:
    ...
```

`str | None`은 "문자열이거나 None"이라는 뜻이에요. 방금 본 조건부 None 패턴의 타입 표시죠.

**Callable — 함수를 인자로 받을 때.**

```python
from typing import Callable

def apply(f: Callable[[int], int], x: int) -> int:
    return f(x)
```

`Callable[[int], int]`은 "int를 받아 int를 돌려주는 함수"라는 뜻이에요. 함수를 인자로 받는다는 게, H1에서 말한 "함수는 일급 객체"의 실제 모습이에요.

**Generic — 어떤 타입이든.**

```python
from typing import TypeVar

T = TypeVar("T")

def first(items: list[T]) -> T:
    return items[0]
```

`T`는 "아무 타입"이라는 변수예요. 리스트에 든 게 뭐든, 그 첫 번째를 같은 타입으로 돌려준다는 뜻이죠. cat 리스트면 cat을, 숫자 리스트면 숫자를요.

**Overload — 인자 타입에 따라 반환이 다를 때.**

```python
from typing import overload

@overload
def add(a: int, b: int) -> int: ...
@overload
def add(a: str, b: str) -> str: ...
def add(a, b):
    return a + b
```

int 둘을 더하면 int, str 둘을 더하면 str. 그걸 타입으로 표현한 거예요.

**Literal — 정해진 값들만.**

```python
from typing import Literal

def log(level: Literal["INFO", "ERROR"]):
    ...
```

level에는 "INFO"나 "ERROR"만 올 수 있다는 뜻이에요. 아무 문자열이 아니라요.

다섯 패턴. 자경단 표준이에요. 다만 type hints는 Python이 자동으로 검사하진 않아요. mypy 같은 도구로 검사해요. 이건 오해 코너에서 다시 짚을게요. 처음부터 다 외우지 말고, Optional(`str | None`)부터 손에 익히세요. 그게 제일 자주 써요.

type hints를 왜 그렇게 강조하냐면, 이게 본인의 미래를 위한 보험이거든요. 6개월 후의 본인은 오늘 짠 함수를 다 까먹어요. 그때 `def convert(amount, from_curr, to_curr)`만 있으면, "amount가 숫자인가 문자열인가? from_curr는 뭘 넣어야 하지?"를 또 코드를 뒤져 봐야 해요. 그런데 `def convert(amount: float, from_curr: str, to_curr: str) -> float`이 있으면, 시그니처만 보고 다 알아요. type hints는 미래의 본인에게 보내는 쪽지예요. 그리고 mypy를 켜면, 본인이 실수로 숫자 자리에 문자열을 넘기는 걸 실행 전에 잡아 줘요. 자경단은 mypy를 단계적으로 켜요. 처음엔 새 코드에만, 점점 엄격하게요. 1주차엔 type hint를 그냥 적기만 하고, 한 달쯤엔 mypy로 검사하고, 익숙해지면 strict 모드로 올려요. 본인은 지금 1주차예요. 그냥 적기만 하세요. 검사는 나중에 도구가 도와줘요. 적는 습관만 들이면, 나중에 그 습관이 큰 자산이 돼요. AI도 type hint가 있는 함수를 훨씬 잘 다뤄요. AI 시대의 함수엔 type hint가 거의 필수예요.

---

## 7. 여섯째 — docstring Google 양식

여섯 번째 개념. docstring이에요. 함수가 뭘 하는지 설명하는 글이죠. 자경단은 Google 양식을 표준으로 써요.

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

Google 양식은 다섯 부분이에요. 첫 줄 한 줄 요약, 그리고 Args(인자 설명), Returns(반환 설명), Raises(언제 예외가 나는지), Examples(예시). 함수 첫 줄에 삼중 따옴표 `"""`로 적어요.

docstring이 왜 중요하냐면, 이게 그냥 주석이 아니거든요. `help(convert)`를 치면 이 docstring이 나와요. VS Code에서 함수에 마우스를 올려도 이게 떠요. AI한테 함수를 물어봐도 이걸 읽어요. 즉 docstring 한 번 잘 적으면, 본인과 동료와 AI가 다 그걸 읽고 함수를 이해해요. 함수 하나에 docstring 적는 데 30초면 돼요. 그 30초가 나중에 그 함수를 쓰는 모든 사람의 시간을 아껴요. 처음엔 한 줄 요약만이라도 적는 습관을 들이세요. Args·Returns는 함수가 복잡해지면 채우면 돼요.

주석과 docstring의 차이도 짚고 갈게요. 주석(`# 이렇게`)은 코드 중간에 "왜 이렇게 짰는지"를 적는 메모예요. docstring(`"""이렇게"""`)은 함수 첫 줄에 "이 함수가 무엇을 하는지"를 적는 공식 설명서예요. 둘은 역할이 달라요. 좋은 함수는 docstring으로 "무엇을"을 밝히고, 정말 헷갈리는 부분에만 주석으로 "왜"를 더해요. 그리고 좋은 함수 이름과 type hint가 있으면, 주석이 별로 필요 없어져요. `def calculate_tax(amount: float) -> float`이라는 시그니처 자체가 이미 많은 걸 말하거든요. 그래서 자경단에선 "주석을 많이 다는 것"보다 "이름과 docstring을 잘 짓는 것"을 더 높이 쳐요. 주석은 코드가 바뀌면 같이 안 바뀌어서 거짓말이 되기 쉽지만, 좋은 이름은 코드와 함께 살아 있거든요. 본인이 함수 하나를 짤 때, "이 함수 이름만 보고도 뭘 하는지 알 수 있나?"를 물으세요. 그게 좋은 함수의 첫 시험이에요.

---

## 8. 일곱째 — lambda 다섯 사용처

일곱 번째 개념. lambda예요. 이름 없는 한 줄 함수죠. 어디에 쓰는지 다섯 군데를 볼게요.

**1. sorted의 정렬 기준(key).** 가장 흔해요.

```python
sorted(cats, key=lambda c: c.age)
```

"나이 기준으로 정렬해"를 한 줄로요.

**2. filter / map.** 거르거나 변환할 때.

```python
list(filter(lambda c: c.is_active, cats))
```

"활성인 cat만 골라"요. 다만 자경단에선 이건 comprehension(`[c for c in cats if c.is_active]`)을 더 선호해요. Ch008에서 배웠죠.

**3. callback.** 버튼을 눌렀을 때 같은 콜백 함수.

```python
button.on_click = lambda: print("clicked")
```

**4. 짧은 변환.** 잠깐 쓸 작은 함수.

```python
double = lambda x: x * 2
```

**5. partial 비슷한 용도.** 인자 하나를 고정한 함수.

```python
add5 = lambda x: x + 5
```

다섯 사용처. 그런데 한 가지 철칙이 있어요. **lambda는 한 줄까지만.** 그 이상 복잡해지면 무조건 def로 이름을 붙이세요. lambda의 장점은 "짧고 일회용"인데, 길어지면 그 장점이 사라지고 읽기만 어려워져요. 실전에서 lambda를 직접 쓰는 건 주로 1번(sorted key)이에요. 나머지는 def가 더 나을 때가 많아요.

lambda와 일반 함수의 관계를 한 문장으로 정리할게요. `double = lambda x: x * 2`는 `def double(x): return x * 2`와 완전히 똑같아요. 다만 lambda는 이름을 안 붙이고 그 자리에서 바로 쓸 수 있다는 것뿐이에요. 사실 `double = lambda x: ...`처럼 lambda에 이름을 붙이는 건 자경단에선 권하지 않아요. 이름을 붙일 거면 그냥 def를 쓰라는 거죠(ruff도 이걸 경고해요, E731). lambda의 진짜 자리는 "이름을 붙일 가치도 없는, 그 자리에서 한 번 쓰고 버릴" 곳이에요. `sorted(cats, key=lambda c: c.age)`가 딱 그래요. 여기서 정렬 기준 함수에 이름을 붙이는 건 과해요. 그냥 그 자리에서 lambda로 끝내는 게 깔끔하죠. 그래서 "lambda를 봤다 = 잠깐 쓰고 버리는 작은 함수구나"로 읽으면 돼요. 본인이 lambda를 쓸지 말지 고민될 때는, "이걸 이름 붙여 재사용할까?"를 물으세요. 재사용할 거면 def, 한 번 쓰고 버릴 거면 lambda예요.

---

## 9. 여덟째 — closure와 nonlocal

여덟 번째 개념. 오늘의 하이라이트, closure예요. 오늘의 약속이 여기 걸려 있어요. closure가 데코레이터의 토대거든요.

closure는 "함수 안의 함수가 바깥 변수를 기억하는 것"이에요.

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

자, 천천히 봐요. `make_counter`는 안에 `count = 0`을 두고, `increment`라는 안쪽 함수를 만들어서 그걸 돌려줘요. 신기한 건, `make_counter`가 끝났는데도 `count`가 안 사라진다는 거예요. `counter()`를 부를 때마다 1, 2, 3 하고 세요. 바깥 함수의 변수 `count`를 안쪽 함수 `increment`가 계속 기억하는 거예요. H1에서 말한 "작업 책상(frame)을 안 치우고 남겨 두는 함수"가 바로 이거예요.

`nonlocal count`가 핵심이에요. 이게 "바깥 함수의 count를 수정하겠다"는 선언이에요. 이걸 안 쓰면 Python은 `count += 1`에서 새 지역 변수를 만들려다 에러를 내요. nonlocal이 "새로 만들지 말고 바깥 거를 고쳐"라고 알려 주는 거예요.

자, 이제 closure가 왜 중요한지. **closure는 decorator의 토대예요.** H1에서 봤던 데코레이터, 그게 closure로 만들어져요.

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

보세요. `timer`는 안에 `wrapper`라는 함수를 만들어서 돌려줘요. 그리고 `wrapper`는 바깥의 `func`를 기억해요. 이게 closure예요. `wrapper`가 `func`를 감싸서, 원래 함수 실행 전후로 시간을 재는 코드를 덧붙이죠. 그리고 `@timer`라는 한 줄은 사실 `slow = timer(slow)`와 똑같아요. 골뱅이는 그냥 예쁜 표기일 뿐이에요. 또 `wrapper(*args, **kwargs)`에서 아까 배운 \*args·\*\*kwargs가 쓰였죠? "원래 함수가 어떤 인자를 받든 다 받아서 그대로 넘기려고"요.

지금 이걸 다 이해 못 해도 괜찮아요. 오늘의 약속은 "closure가 데코레이터의 토대"라는 걸 마음에 심는 거예요. H5에서 본인이 직접 이걸 짤 때, 오늘 본 이 `timer`가 떠오를 거예요. 그때 "아, H2에서 봤던 거다" 하면 돼요. 토대는 지금 박혔어요.

closure를 처음 보면 다들 "이게 왜 되지?" 하고 신기해해요. 그 신기함의 정체를 H1의 책상 비유로 풀어 드릴게요. H1에서 함수가 호출되면 작업 책상(frame)을 받고, 끝나면 치운다고 했죠. 그런데 closure는 예외예요. 안쪽 함수가 바깥 변수를 계속 쓰고 있으면, Python은 그 책상을 안 치워요. 정확히는 안쪽 함수가 그 변수를 cell이라는 작은 상자에 담아서 들고 다녀요. 그래서 바깥 함수가 끝나도 `count`가 안 사라지는 거예요. 안쪽 함수가 그걸 cell에 넣어 들고 갔으니까요. `make_counter`가 만든 `counter`는, 자기만의 `count` cell을 품은 함수예요. 그래서 두 개를 만들면 — `c1 = make_counter()`, `c2 = make_counter()` — 각자 자기 count를 따로 세요. 서로 안 섞여요. 각자 자기 책상을 들고 다니거든요. 이 cell 메커니즘이 H7에서 깊이 파는 내용이에요. 오늘은 "안쪽 함수가 바깥 변수를 상자에 담아 들고 다닌다" 이 그림이면 충분해요. 이 그림이 closure도, decorator도, 그리고 나중에 배울 많은 것의 열쇠예요.

---

## 10. 한 줄 분해

자경단이 매일 짜는 한 줄을 분해하면서 오늘 배운 걸 묶어 볼게요.

```python
@lru_cache(maxsize=128)
def fib(n: int) -> int:
    return n if n < 2 else fib(n-1) + fib(n-2)
```

이 짧은 코드에 오늘 배운 8개념 중 네 개가 들어 있어요. `@lru_cache`는 decorator(closure로 만든)예요. 결과를 기억해서 같은 입력엔 다시 계산 안 하게 해 줘요. `n: int -> int`는 type hints죠. `n if n < 2 else ...`는 삼항 표현식(Ch008 회수)이고, `fib(n-1) + fib(n-2)`는 자기가 자기를 부르는 재귀예요. 데코레이터·타입 힌트·삼항·재귀가 한 줄에 다 있어요. 본인이 오늘 H2를 마치면, 이 한 줄이 술술 읽혀요. 8시간 전엔 외계어였을 한 줄이요.

그리고 이 `@lru_cache`가 왜 대단한지 한 가지만 짚을게요. fib(피보나치)는 재귀로 짜면 같은 값을 수없이 다시 계산해요. fib(30)을 그냥 짜면 백만 번 넘게 호출돼요. 그런데 `@lru_cache` 한 줄을 붙이면, 한 번 계산한 값을 기억해 둬서 fib(30)이 30번 호출로 끝나요. 수백만 배 빨라지는 거예요. 데코레이터 한 줄로요. 본인이 함수 본문은 하나도 안 건드리고, 위에 골뱅이 한 줄만 얹어서 성능을 수백만 배 올린 거예요. 이게 데코레이터의 힘이에요. "원래 함수는 그대로 두고, 기능을 위에서 덧입힌다." 오늘 배운 closure가 이걸 가능하게 해요. H5에서 본인이 이런 데코레이터를 직접 짜요. 기대되죠?

---

## 11. 흔한 오해 다섯 가지

**오해 1: default 인자는 매번 새로 만들어진다.**

아니에요. 함수 정의 때 딱 한 번 만들어져요. 그래서 mutable default 함정이 생기죠. None으로 두고 안에서 만드세요.

**오해 2: \*args와 \*\*kwargs는 항상 함께 써야 한다.**

아니에요. 따로도 써요. `*args`만, `**kwargs`만 쓸 수 있어요. 다만 둘 다 "개수 모를 때"라 같이 보이는 경우가 많을 뿐이에요.

**오해 3: lambda가 def보다 빠르다.**

아니에요. 속도는 거의 같아요. 차이는 가독성과 용도예요. lambda는 짧고 일회용, def는 이름 있고 재사용. 속도 때문에 lambda를 쓰는 게 아니에요.

**오해 4: closure는 너무 어려워서 나중에 배울 거다.**

아니에요. 쓰면서 박혀요. 특히 데코레이터를 만들 때 자연스럽게 closure를 쓰게 돼요. "바깥 변수를 기억하는 안쪽 함수", 이 한 줄이면 충분해요.

**오해 5: type hints를 적으면 Python이 런타임에 검사한다.**

아니에요. Python은 기본적으로 type hints를 무시하고 실행해요. 검사는 mypy 같은 별도 도구가 해요. type hints는 "사람과 도구를 위한 메모"지, 실행을 막는 장치가 아니에요. `def add(a: int)`에 문자열을 넘겨도 그냥 돌아가요(mypy가 경고할 뿐).

---

## 12. 자주 받는 질문 다섯 가지

**Q1. \*args랑 그냥 list를 받는 거랑 뭐가 달라요?**

`*args`는 `func(1, 2, 3)`처럼 흩어서 넘기고, list는 `func([1, 2, 3])`처럼 묶어서 넘겨요. 호출하는 쪽이 더 자연스러운 쪽을 고르면 돼요. 개수가 가변이고 흩어 넘기는 게 자연스러우면 \*args, 이미 리스트가 있으면 그냥 list 인자요.

**Q2. closure가 메모리 누수를 일으킨다던데요?**

closure가 큰 객체를 캡처하면, 그 closure가 살아 있는 동안 객체가 메모리에서 안 치워져요. 보통은 문제없지만, 큰 데이터를 캡처한 closure를 오래 들고 있으면 주의해야 해요. 실무에서 가끔 만나는 함정이에요.

**Q3. 데코레이터를 쓰면 원래 함수의 docstring이 사라지나요?**

네, 그냥 두면 wrapper의 정보로 덮여요. 그래서 `@functools.wraps(func)`를 wrapper 위에 붙여요. 그러면 원래 함수의 이름·docstring이 보존돼요. H4에서 자세히 다뤄요.

**Q4. lambda로 못 하는 게 뭐예요?**

lambda는 표현식 하나만 담을 수 있어요. 문장(statement)은 못 넣어요. 예를 들어 lambda 안에서 변수에 할당하거나(`x = 1`), if 문을 여러 줄 쓰거나, for 루프를 돌릴 수 없어요. 그런 게 필요하면 def예요.

**Q5. TypeVar랑 Generic이 헷갈려요.**

`TypeVar`는 "아무 타입"을 나타내는 타입 변수예요(아까 본 `T`). `Generic`은 그걸 클래스에 쓸 때 상속하는 베이스예요. 함수에선 보통 TypeVar만 쓰면 돼요. Generic 클래스는 Ch011 OOP에서 만나요.

---

## 13. 흔한 실수 다섯 + 안심 — 함수 핵심 학습 편

함수 8개념을 배우며 자주 빠지는 함정 다섯 개예요.

**첫째, \*args와 \*\*kwargs를 헷갈리기.** 안심하세요. 외우기 쉬워요. 별 하나(`*`)는 위치 인자(튜플), 별 둘(`**`)은 키워드 인자(딕셔너리)예요. 별 개수 = 묶이는 방식이에요.

**둘째, lambda 남용.** 안심하세요. 규칙은 하나예요. 한 줄에 안 들어가면 def. 그 한 줄 규칙만 지키면 lambda는 안전해요.

**셋째, closure가 헷갈리기.** 안심하세요. "안쪽 함수 + 바깥 변수를 기억", 이 한 그림이면 돼요. 처음엔 make_counter 하나만 손으로 쳐서 1, 2, 3 나오는 걸 직접 보세요. 그러면 박혀요.

**넷째, scope(변수 범위)가 헷갈리기.** 안심하세요. LEGB 순서만 기억하세요. Local(함수 안) → Enclosing(바깥 함수) → Global(파일 전체) → Built-in(파이썬 기본). Python이 변수를 이 순서로 찾아요. H7에서 깊이 배워요.

**다섯째, 가장 큰 함정 — 재귀 깊이 폭발.** 안심하세요. 재귀(자기가 자기를 부르는 함수)가 너무 깊으면 RecursionError가 나요. Python은 기본 1000번까지만 허용하거든요. 대부분은 반복(for/while)으로 바꾸면 해결돼요. 정 깊은 재귀가 필요하면 `sys.setrecursionlimit`으로 늘리되, 신중하게요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 가요.

---

## 14. 마무리

자, 함수의 두 번째 시간이 끝났어요.

오늘 본인은 함수의 8개념을 손에 쥐었어요. def의 여섯 인자 종류, return의 다섯 패턴, default 인자와 mutable 함정, \*args와 \*\*kwargs, type hints 다섯 패턴, docstring Google 양식, lambda 다섯 사용처, 그리고 closure와 nonlocal까지요. 이게 함수의 진짜 어휘예요. 자경단이 매일 쓰는 것들이죠.

그리고 오늘의 약속을 지켰어요. 마지막 closure가 데코레이터의 토대라는 걸 봤죠. `timer` 데코레이터가 사실 closure였어요. 이 토대가 박혔으니, H5에서 본인이 데코레이터를 짤 때 막히지 않아요. 오늘 심은 씨앗이 H5에서 꽃을 피워요.

다 외우려 하지 마세요. 오늘 매일 쓰는 건 절반이에요. 보통 인자와 기본값, return 단일/None/예외, mutable default 처방, 그리고 closure의 큰 그림. 이 정도만 손에 익히면 충분해요. 나머지는 필요할 때 찾으면 돼요.

특히 오늘 꼭 가져갈 두 가지를 콕 집어 줄게요. 하나, mutable default 함정 — "리스트·딕셔너리를 기본값으로 쓸 거면 None으로 두고 안에서 만들어라." 둘, closure — "안쪽 함수가 바깥 변수를 상자에 담아 기억한다." 이 두 가지가 오늘의 핵심이에요. 첫째는 본인을 버그에서 구하고, 둘째는 본인을 데코레이터로 데려가요. 다른 건 다 까먹어도 이 둘만 남기세요. 두 개면 오늘은 성공이에요. 욕심부리지 말고 딱 두 개만 잘 챙기세요.

다음 H3는 함수를 들여다보는 도구를 배워요. inspect, dis, 그리고 함수 디버깅이요. 함수가 안에서 뭘 하는지 두 눈으로 보는 시간이에요. 그 전에 마지막으로 한 줄만 쳐 보세요.

```python
python3 -c 'def f(*a, **k): print(a, k)
f(1, 2, name="까미")'
```

`(1, 2) {'name': '까미'}`가 나와요. 위치 인자는 튜플로, 키워드 인자는 딕셔너리로 묶이죠. 본인이 이 출력을 이해하면, 오늘 \*args·\*\*kwargs를 손에 쥔 거예요. 다음 시간에 봐요. 함수 속으로 더 깊이 들어가요. 오늘도 끝까지 와 주셔서 고마워요. 한 개념씩 차근차근 본인 것이 되고 있어요. 🐾

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - 위치 전용 인자 PEP 570: Python 3.8+. `/`로 구분. C로 구현된 내장 함수(예: `len`)의 시그니처를 Python으로 표현하려고 도입.
> - 키워드 전용 인자 PEP 3102: `*`나 `*args` 다음의 인자. bool 플래그·옵션에 권장(호출부 가독성).
> - default mutable 함정: default는 `def` 실행 시 한 번 평가되어 `func.__defaults__`에 저장·공유됨. ruff B006·pylint W0102가 자동 탐지.
> - *args/**kwargs: 정의부=packing(tuple/dict), 호출부=unpacking. `def f(*a, **k)` vs `f(*lst, **dct)`.
> - closure: 안쪽 함수가 바깥 스코프 변수를 cell 객체(`__closure__`)로 캡처. `nonlocal`로 재바인딩. H7에서 LEGB와 함께 깊이.
> - functools.wraps: decorator의 wrapper에 원본 `__name__`·`__doc__`·`__wrapped__` 보존. H4에서.
> - typing PEP 484: Python 3.5+. 점진적 타이핑(gradual typing). 런타임 미검증 — mypy/pyright가 정적 검사.
> - 다음 H3 키워드: inspect · dis · profile · pdb 함수 진입 · VS Code 디버거.

---

## 추신

1. 함수 8개념 — def 인자·return·default·*args·**kwargs·type hint·docstring·lambda·closure.
2. def 인자 6종 — 위치전용·위치or키워드·*args·키워드전용·**kwargs·default.
3. 매일 쓰는 건 "위치 또는 키워드" 인자 + 기본값. 90%.
4. 키워드 전용(`*` 다음)은 bool·옵션에. 호출부가 읽혀요.
5. return 5패턴 — 단일·다중tuple·조건부None·명시None·예외.
6. 매일 쓰는 return은 단일·조건부None·예외. 90%.
7. 다중 return은 튜플. q, r = f() 언패킹.
8. default 함정 — 정의 때 한 번 평가. mutable이면 공유 사고.
9. 처방 — `def f(x=None): x = x or []`. None 후 안에서 생성.
10. ruff B006이 mutable default 자동 경고.
11. *args=위치 packing(튜플), **kwargs=키워드 packing(딕셔너리).
12. 별 개수 = 묶이는 방식. 하나=위치, 둘=키워드.
13. 호출부 *lst, **dct = unpacking. 풀어서 넘기기.
14. type hint 5패턴 — Optional·Callable·Generic·Overload·Literal.
15. Optional(`str | None`)부터 손에. 제일 자주.
16. type hint는 런타임 미검증. mypy가 검사.
17. docstring Google 5부분 — 요약·Args·Returns·Raises·Examples.
18. docstring은 help()·VS Code·AI가 다 읽어요. 30초 투자.
19. lambda 5사용처 — sorted key·filter·callback·변환·고정.
20. lambda는 한 줄까지. 그 이상 def.
21. 실전 lambda는 거의 sorted key. 나머지는 def가 나아요.
22. closure = 안쪽 함수 + 바깥 변수 기억.
23. nonlocal = 바깥 변수 수정 선언. 안 쓰면 새 변수.
24. closure가 decorator의 토대. 오늘의 약속.
25. @timer = timer(slow). 골뱅이는 예쁜 표기.
26. wrapper(*args, **kwargs) = 어떤 인자든 받아 넘기기.
27. 한 줄 분해 — @lru_cache + type hint + 삼항 + 재귀.
28. 재귀 깊이 1000 한계. 보통 반복으로 해결.
29. LEGB — Local·Enclosing·Global·Built-in. H7에서.
30. 다음 H3는 함수 들여다보기. inspect·dis. 바로 만나요. 🐾
