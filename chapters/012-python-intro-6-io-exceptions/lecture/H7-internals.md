# Ch012 · H7 — file/exception 내부 — fd·context manager·buffered

> 고양이 자경단 · Ch 012 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. file descriptor (OS 레벨)
3. open() 시스템콜
4. context manager 프로토콜
5. BufferedReader/Writer
6. exception 처리 내부
7. exception group (3.11+)
8. 흔한 오해 다섯 가지
9. 마무리

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요.

지난 H6 회수. chunking, generator, 성능, async I/O.

이번 H7은 깊이.

오늘의 약속. **본인이 open()이 OS 레벨에서 무엇을 하는지 만집니다**.

자, 가요.

---

## 2. file descriptor (OS 레벨)

OS는 모든 파일을 정수 (file descriptor, fd)로 식별.

기본 fd 셋.

- 0 — stdin
- 1 — stdout  
- 2 — stderr

본인이 `open("file.txt")` 하면 OS가 새 fd를 할당. 보통 3부터.

```python
f = open("file.txt")
f.fileno()   # 3 (또는 다음 빈 정수)
```

OS의 limit. 한 프로세스당 보통 1024 fd.

```bash
ulimit -n   # macOS/Linux
```

너무 많이 열면 `Too many open files` 에러. with로 자동 close가 중요한 이유.

---

## 3. open() 시스템콜

`open("file.txt", "r")`이 안에서.

```c
int fd = open("file.txt", O_RDONLY);
```

OS가 파일을 찾고 권한 검사. fd 반환.

Python의 file 객체는 fd + buffer + encoding 래퍼.

```python
import os

# 저수준 OS 호출
fd = os.open("file.txt", os.O_RDONLY)
data = os.read(fd, 100)   # 100 bytes
os.close(fd)

# 고수준 (자경단 표준)
with open("file.txt") as f:
    data = f.read(100)
```

자경단 99% 고수준. os 모듈 직접은 특수.

---

## 4. context manager 프로토콜

`with` 문의 동작.

```python
with open("file.txt") as f:
    content = f.read()
# 자동 close
```

내부.

```python
mgr = open("file.txt")
mgr.__enter__()   # f 반환
try:
    f = mgr
    content = f.read()
finally:
    mgr.__exit__(exc_type, exc_value, traceback)
```

`__enter__`와 `__exit__` 두 메서드. 본인이 직접 만들 수 있어요.

```python
class MyContext:
    def __enter__(self):
        print("진입")
        return self
    
    def __exit__(self, *args):
        print("종료")

with MyContext() as ctx:
    print("내부")
```

contextlib.contextmanager로 더 간단.

```python
from contextlib import contextmanager

@contextmanager
def my_context():
    print("진입")
    try:
        yield "value"
    finally:
        print("종료")
```

자경단 매일 with.

---

## 5. BufferedReader/Writer

본인이 `open()` 하면 사실 buffered I/O.

```
파일 (디스크) ↔ buffer (메모리, 8KB 기본) ↔ Python
```

read 시 8KB씩 읽음. 매 byte syscall 안 함. 빠름.

write도 마찬가지. flush 또는 close 시 디스크에.

```python
f = open("file.txt", "w")
f.write("hello")   # buffer에만
f.flush()           # 디스크에
f.close()           # 자동 flush + close
```

unbuffered 옵션.

```python
open("file.txt", "w", buffering=0)   # binary만
```

자경단 매일 — buffered. 빠름.

---

## 6. exception 처리 내부

`try/except`가 안에서.

bytecode.

```python
try:
    risky()
except ValueError:
    handle()
```

```
SETUP_FINALLY    # try 시작 마크
LOAD_GLOBAL risky
CALL_FUNCTION
POP_BLOCK
JUMP_FORWARD     # 정상 흐름

# except 블록
DUP_TOP
LOAD_GLOBAL ValueError
COMPARE_OP exception match
POP_JUMP_IF_FALSE  # match 안 되면
POP_TOP
LOAD_GLOBAL handle
CALL_FUNCTION
```

exception 발생 시 stack을 unwind. SETUP_FINALLY 위치까지.

성능. exception 발생 안 하면 거의 0 비용. 발생 시 비싸짐.

자경단의 EAFP. "Easier to Ask for Forgiveness than Permission".

```python
# Pythonic
try:
    value = d[key]
except KeyError:
    value = default

# 또는 더 간단
value = d.get(key, default)
```

---

## 7. exception group (3.11+)

여러 동시 예외.

```python
# Python 3.11+
try:
    raise ExceptionGroup("multiple", [ValueError("a"), TypeError("b")])
except* ValueError as eg:
    print("ValueError 처리:", eg)
except* TypeError as eg:
    print("TypeError 처리:", eg)
```

asyncio.gather에서 여러 task가 동시 실패 시 유용.

자경단 3.11+ 표준 가정.

---

## 8. 흔한 오해 다섯 가지

**오해 1: with는 옵션.**

자경단 표준 항상.

**오해 2: try/except 비싸다.**

발생 안 하면 0.

**오해 3: fd 무한.**

1024 limit.

**오해 4: 작은 파일은 unbuffered.**

자동 buffered가 빠름.

**오해 5: exception 상속 자유.**

Exception 상속 권장.

---

## 9. 흔한 실수 다섯 + 안심 — 깊이 학습 편

첫째, fd 무한 가정. 안심 — 1024 limit, with 항상.
둘째, try/except 비쌈 가정. 안심 — 발생 안 하면 0.
셋째, context manager 어렵다. 안심 — `__enter__`·`__exit__` 두 메서드.
넷째, buffered 옵션. 안심 — 자동, 매일.
다섯째, 가장 큰 — LBYL 매번. 안심 — EAFP가 Pythonic.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 10. 마무리

자, 일곱 번째 시간 끝.

fd, open syscall, context manager, buffered, exception 내부, exception group.

다음 H8은 적용 + 회고.

```python
with open(__file__) as f:
    print(f.fileno())
```

---

## 👨‍💻 개발자 노트

> - PEP 343: with 문.
> - PEP 654: exception group 3.11+.
> - contextlib.suppress: silent ignore.
> - asyncio context: async with.
> - 다음 H8 키워드: 7H 회고 · file_processor · Ch013 다리.
