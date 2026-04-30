# Ch009 · H7 — 함수 내부 — scope·LEGB·closure·frame

> 고양이 자경단 · Ch 009 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. LEGB scope 규칙
3. global, nonlocal 키워드
4. closure cell 객체
5. function frame과 stack
6. function object의 속성
7. decorator 내부
8. async function 내부
9. 흔한 오해 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요.

지난 H6 회수. pure function, SOLID, DRY, KISS, 합성.

이번 H7은 깊이. scope, closure, frame.

오늘의 약속. **본인이 함수 호출 시 일어나는 메커니즘을 만집니다**.

자, 가요.

---

## 2. LEGB scope 규칙

Python의 변수 검색 순서. **L**ocal → **E**nclosing → **G**lobal → **B**uiltin.

```python
x = "global"   # G

def outer():
    x = "enclosing"   # E
    
    def inner():
        x = "local"   # L
        print(x)   # 'local'
    
    inner()
    print(x)   # 'enclosing'

outer()
print(x)   # 'global'
```

가장 안쪽부터. 못 찾으면 한 단계 위.

builtin은 print, len 같은 기본.

```python
print(__builtins__)
```

자경단 매일 — 이 규칙이 자동.

---

## 3. global, nonlocal 키워드

기본은 읽기 가능, 쓰기는 local.

```python
x = 0

def increment():
    x = x + 1   # UnboundLocalError
```

처방. global.

```python
def increment():
    global x
    x = x + 1
```

closure는 nonlocal.

```python
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment
```

**nonlocal 없으면**.

```python
def make_counter():
    count = 0
    def increment():
        count += 1   # UnboundLocalError
        return count
    return increment
```

자경단 표준 — global 안 씀, nonlocal은 closure에만.

---

## 4. closure cell 객체

closure가 외부 변수를 어떻게 캡처하나.

```python
def outer():
    x = 10
    def inner():
        return x
    return inner

f = outer()
f()   # 10

# 캡처 확인
f.__closure__
# (<cell at 0x..., int object at 0x...>,)

f.__closure__[0].cell_contents
# 10
```

cell이라는 객체에 변수 저장. inner 함수가 cell 참조. outer 함수가 끝나도 cell은 살아 있어요. inner가 cell 참조하니까.

이게 closure의 비밀.

---

## 5. function frame과 stack

함수 호출마다 frame 객체 생성.

```python
import inspect

def outer():
    x = 1
    inner()

def inner():
    frame = inspect.currentframe()
    print("My function:", frame.f_code.co_name)
    print("Caller:", frame.f_back.f_code.co_name)
    print("Caller locals:", frame.f_back.f_locals)

outer()
```

frame은 함수의 모든 상태. local, code, lineno, back (이전 frame).

call stack — frame들이 stack 형태로 쌓임. 깊이 1000 limit.

```python
import sys
sys.getrecursionlimit()   # 1000
sys.setrecursionlimit(2000)
```

stack overflow는 깊은 재귀에서.

---

## 6. function object의 속성

Python 함수는 객체. 속성이 있어요.

```python
def greet(name: str) -> str:
    """Greeting."""
    return f"Hi {name}"

greet.__name__       # 'greet'
greet.__doc__        # 'Greeting.'
greet.__annotations__ # {'name': str, 'return': str}
greet.__defaults__   # None
greet.__code__       # <code object>
greet.__module__     # '__main__'
greet.__qualname__   # 'greet'
greet.__globals__    # 모듈 globals
```

decorator에서 이 속성 다룸. functools.wraps가 이 속성 보존.

---

## 7. decorator 내부

`@decorator`가 사실은.

```python
@timer
def slow():
    ...

# 같음
def slow():
    ...
slow = timer(slow)
```

timer가 함수 받아서 함수 반환. closure 메커니즘.

```python
def timer(func):
    def wrapper(*args, **kwargs):
        # 시간 측정
        return func(*args, **kwargs)
    return wrapper
```

wrapper가 closure. func를 캡처. wrapper의 `__closure__`에 func.

@functools.wraps가 wrapper의 메타데이터를 func로 복사.

---

## 8. async function 내부

```python
async def fetch():
    await something()

# 호출하면 coroutine 객체
coro = fetch()
type(coro)   # <class 'coroutine'>

# 실행은 event loop가
import asyncio
asyncio.run(coro)
```

coroutine은 generator의 진화. yield → await. event loop가 실행.

자경단의 매일 — I/O bound async.

---

## 9. 흔한 오해 다섯 가지

**오해 1: global은 깔끔.**

자경단 안 씀.

**오해 2: closure 비싸다.**

cell 한 개. 가벼움.

**오해 3: stack overflow 자주.**

1000 깊이는 거의 안 만남.

**오해 4: decorator는 마법.**

함수 → 함수.

**오해 5: async = thread.**

coroutine + event loop.

---

## 10. 흔한 실수 다섯 + 안심 — 함수 깊이 학습 편

첫째, 클로저 무지성. 안심 — 명확한 의도.
둘째, 데코레이터 한 번에 다. 안심 — @lru_cache 하나부터.
셋째, generator·iterator 헷갈림. 안심 — yield = generator.
넷째, *args 양쪽 강제. 안심 — 필요할 때만.
다섯째, 가장 큰 — 함수가 클래스 흉내. 안심 — class 더 나음.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 일곱 번째 시간 끝.

LEGB scope, global/nonlocal, closure cell, frame, function 속성, decorator 내부, async.

다음 H8은 적용 + 회고.

```python
def outer():
    x = 1
    def inner():
        return x
    return inner
print(outer().__closure__[0].cell_contents)
```

---

## 👨‍💻 개발자 노트

> - LEGB: PEP 227.
> - cell object: function의 free variable.
> - frame f_locals: 읽기는 OK, 쓰기는 영구 안 됨.
> - PEP 492: async/await.
> - 다음 H8 키워드: 7H 회고 · v3 진화 · Ch010 다리.
