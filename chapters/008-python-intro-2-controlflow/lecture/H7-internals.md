# Ch008 · H7 — 흐름 내부 — iterator·generator·async

> 고양이 자경단 · Ch 008 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. iterator 프로토콜
3. generator와 yield
4. for 루프 내부
5. comprehension의 bytecode
6. async for와 비동기 흐름
7. itertools 내부
8. 흔한 오해 다섯 가지
9. 마무리

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요.

지난 H6 회수. 운영 — early return, guard, 복잡도, radon.

이번 H7은 깊이. iterator, generator, async.

오늘의 약속. **본인이 for 루프 내부 메커니즘을 손에 잡습니다**.

자, 가요.

---

## 2. iterator 프로토콜

Python의 모든 iterable이 따르는 약속.

```python
class MyList:
    def __init__(self, items):
        self.items = items
    
    def __iter__(self):
        return MyIterator(self.items)

class MyIterator:
    def __init__(self, items):
        self.items = items
        self.idx = 0
    
    def __next__(self):
        if self.idx >= len(self.items):
            raise StopIteration
        val = self.items[self.idx]
        self.idx += 1
        return val
```

`__iter__`가 iterator 반환, `__next__`가 다음 값. StopIteration 예외로 끝 알림.

```python
ml = MyList([1, 2, 3])
for x in ml:
    print(x)
```

for가 자동으로 iter() + next() 반복.

자경단 매일 만나는 list, dict, set이 다 이 프로토콜.

---

## 3. generator와 yield

generator는 가벼운 iterator. yield 키워드로 만들어요.

```python
def count_up_to(n):
    i = 0
    while i < n:
        yield i
        i += 1

for x in count_up_to(5):
    print(x)
# 0, 1, 2, 3, 4
```

yield는 return 비슷하지만 함수 상태를 보존. 다음 호출 시 yield 다음 줄부터.

장점. **lazy**. 1조 개 데이터도 메모리 효율.

```python
def big_generator():
    for i in range(10**12):
        yield i

# 메모리 폭발 없음. 한 번에 한 값만.
for x in big_generator():
    if x > 100:
        break
```

자경단 매일 — 큰 파일 처리, 무한 시퀀스, lazy 변환.

---

## 4. for 루프 내부

`for x in xs:`가 안에서.

```python
# 본인이 짠 코드
for x in [1, 2, 3]:
    print(x)

# 실제 동작
_iter = iter([1, 2, 3])
while True:
    try:
        x = next(_iter)
    except StopIteration:
        break
    print(x)
```

Python이 자동으로 변환. 그래서 모든 iterable이 for 가능.

bytecode 보면.

```python
import dis
dis.dis(compile("for x in [1,2,3]: print(x)", "<>", "exec"))
```

GET_ITER, FOR_ITER 명령이 보여요. 위 변환의 bytecode 버전.

---

## 5. comprehension의 bytecode

```python
[x*2 for x in range(5)]
```

bytecode.

```
LOAD_CONST <code>
MAKE_FUNCTION
LOAD_FAST range
LOAD_CONST 5
CALL_FUNCTION 1
GET_ITER
CALL_FUNCTION 1
```

comprehension은 사실 **익명 함수 + 호출**. 그래서 빠름. 일반 for 루프보다 20-30% 빠른 이유.

dict comp, set comp, generator expression 다 같은 메커니즘.

---

## 6. async for와 비동기 흐름

비동기 iterator.

```python
import asyncio

async def fetch_pages():
    for url in ["url1", "url2", "url3"]:
        page = await fetch(url)
        yield page

async def main():
    async for page in fetch_pages():
        process(page)

asyncio.run(main())
```

`async for`가 비동기 iterable. `__aiter__`, `__anext__` 프로토콜.

자경단 — 큰 API 응답 lazy 처리. WebSocket 메시지 stream.

---

## 7. itertools 내부

itertools의 모든 함수가 generator. lazy.

```python
from itertools import chain, count, takewhile

# 무한 카운터
for i in takewhile(lambda x: x < 10, count()):
    print(i)
```

`count()`는 무한이지만 lazy. takewhile이 조건 멈추면 끝.

자경단의 무한 시퀀스 처리.

---

## 8. 흔한 오해 다섯 가지

**오해 1: generator는 list보다 항상 빠름.**

작은 데이터는 list가 빠름.

**오해 2: yield는 return.**

상태 보존이 차이.

**오해 3: for는 list만.**

iterable 다.

**오해 4: comprehension은 함수 아님.**

bytecode는 익명 함수.

**오해 5: async = 빠름.**

I/O bound만.

---

## 9. 흔한 실수 다섯 + 안심 — Python 깊이 학습 편

첫째, GIL 만능 단정. 안심 — I/O는 무관.
둘째, bytecode 다 읽기. 안심 — dis 한 번.
셋째, ref count + GC 외움. 안심 — 두 메커니즘 동작 한 줄.
넷째, PEP 다 읽기. 안심 — PEP 8만.
다섯째, 가장 큰 — CPython이 유일하다. 안심 — PyPy 등도 있음.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 10. 마무리

자, 일곱 번째 시간 끝.

iterator, generator, for 내부, comprehension bytecode, async for, itertools.

다음 H8은 적용 + 회고.

```python
import dis
dis.dis("for x in [1,2,3]: pass")
```

---

## 👨‍💻 개발자 노트

> - PEP 234: iterator 프로토콜.
> - PEP 255: generator.
> - PEP 525: async generator.
> - generator vs coroutine: yield vs await.
> - 다음 H8 키워드: 7H 회고 · v2 진화 · Ch009 다리.
