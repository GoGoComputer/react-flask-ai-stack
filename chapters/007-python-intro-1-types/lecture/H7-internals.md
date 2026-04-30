# Ch007 · H7 — Python 내부 — CPython·GIL·bytecode·메모리

> 고양이 자경단 · Ch 007 · 7교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. CPython 인터프리터 깊이
3. bytecode와 dis 모듈
4. GIL — Global Interpreter Lock
5. 메모리 관리 — reference count + GC
6. 작은 int 캐싱
7. PEP — 표준의 진화
8. C 확장 모듈
9. 자경단의 매일 0.1초 안
10. 흔한 오해 다섯 가지
11. 마무리 — 다음 H8에서 만나요

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H6 회수. 코드 품질 운영. PEP 8, black, ruff, mypy, pytest, pre-commit.

이번 H7은 깊이의 시간. CPython 안에서 무엇이 일어나는지.

오늘의 약속. **본인이 print() 한 줄 칠 때 0.1초 안에 일어나는 일을 손에 잡습니다**.

자, 가요.

---

## 2. CPython 인터프리터 깊이

Python에는 여러 구현체가 있어요.

**CPython**. 표준. C로 짠 인터프리터. 99%가 사용.

**PyPy**. JIT 컴파일러. 더 빠름.

**Jython**. JVM 위 Python.

**MicroPython**. IoT.

자경단 표준은 CPython. 본 H에서는 CPython.

CPython의 단계.

1. 본인 .py 파일을 lexer가 token으로.
2. parser가 token을 AST (추상 구문 트리)로.
3. compiler가 AST를 bytecode로.
4. PVM (Python Virtual Machine)이 bytecode를 한 줄씩 실행.

5단계. 0.1초 안.

---

## 3. bytecode와 dis 모듈

```python
def add(a, b):
    return a + b
```

bytecode를 보면.

```python
import dis
dis.dis(add)
```

진짜 출력.

```
  2           0 LOAD_FAST                0 (a)
              2 LOAD_FAST                1 (b)
              4 BINARY_ADD
              6 RETURN_VALUE
```

네 명령. PVM이 stack-based machine. 

1. LOAD_FAST a — a를 stack에 push.
2. LOAD_FAST b — b를 push.
3. BINARY_ADD — stack 위 두 개를 더해서 결과 push.
4. RETURN_VALUE — stack 위를 반환.

자경단 매주 한 번 dis로 함수 내부 점검.

---

## 4. GIL — Global Interpreter Lock

CPython의 가장 유명한 특징. GIL.

**GIL이 뭐냐**. 한 시점에 한 thread만 Python bytecode 실행. 즉 multi-thread여도 진짜 병렬 아님.

```python
import threading

def task():
    for _ in range(10_000_000):
        pass

# 두 thread
t1 = threading.Thread(target=task)
t2 = threading.Thread(target=task)
t1.start(); t2.start()
t1.join(); t2.join()
# 한 thread보다 살짝 빠를 뿐 (2배 안 됨)
```

GIL의 이유. CPython의 메모리 관리(refcount)가 thread-safe 아님. GIL이 동시 접근 막아요.

**해결 방법 셋**.

1. **multiprocessing**. 여러 프로세스. GIL은 프로세스마다라 진짜 병렬.
2. **asyncio**. 비동기. I/O bound에 강력.
3. **C 확장**. NumPy 같은 도구는 C 안에서 GIL 풀어요.

자경단의 결정. CPU bound는 multiprocessing, I/O bound는 asyncio.

GIL을 없애는 PEP 703 진행 중. Python 3.13부터 옵션. 자경단 1-2년 후 검토.

---

## 5. 메모리 관리 — reference count + GC

Python의 메모리 관리는 두 메커니즘.

**1. Reference Count**. 모든 객체에 참조 카운트. 0이 되면 즉시 해제.

```python
import sys

x = [1, 2, 3]
sys.getrefcount(x)   # 2 (x + getrefcount의 인자)

y = x
sys.getrefcount(x)   # 3
del y
sys.getrefcount(x)   # 2
```

빠르고 결정적. 99% 메모리 관리.

**2. Garbage Collector**. 순환 참조 처리.

```python
a = []
b = []
a.append(b)
b.append(a)
# a→b→a→b... 순환 참조
del a, b
# refcount는 0이 안 됨. GC가 정리.
```

GC는 주기적 실행. `gc.collect()`로 수동.

자경단의 매일 — `del` 명시적 해제 거의 안 함. CPython이 알아서.

---

## 6. 작은 int 캐싱

신기한 디테일 하나.

```python
a = 5
b = 5
a is b   # True (같은 객체)

a = 1000
b = 1000
a is b   # False (다른 객체)
```

CPython은 -5 ~ 256 정수를 미리 만들어 둠. 매번 같은 객체 재사용. 메모리 절감.

256 넘으면 매번 새 객체.

```python
import sys
sys.getsizeof(5)     # 28 bytes
sys.getsizeof(1000)  # 28 bytes (같은 크기)
```

작은 int 캐싱은 구현 디테일. 본인 코드에서 의존하지 마세요. is 비교는 None만.

---

## 7. PEP — 표준의 진화

PEP은 Python Enhancement Proposal. Python 표준의 진화 문서.

자경단이 알아야 할 PEP 일곱.

**PEP 8** — 코드 스타일.
**PEP 20** — Python의 Zen (`import this`).
**PEP 257** — docstring 양식.
**PEP 484** — type hints.
**PEP 526** — 변수 annotation.
**PEP 572** — walrus operator.
**PEP 634** — match-case.

자경단 표준 — 3.10+ 모든 PEP.

```python
import this   # Zen of Python 출력
```

처음 보면 감동.

```
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
...
```

자경단의 코드 철학.

---

## 8. C 확장 모듈

NumPy, pandas, lxml 같은 빠른 라이브러리는 C로 짜져 있음.

```python
import numpy as np

arr = np.array([1, 2, 3, 4, 5] * 1_000_000)
arr.sum()   # 100배 빠름 (Python 루프 대비)
```

C 확장이 GIL 풀고 진짜 병렬 가능. NumPy의 비결.

본인이 직접 C 확장 짜는 경우 — 거의 없어요. 1만 명 중 1명. 자경단도 안 짬.

대신 PyPI에서 검증된 C 확장 라이브러리 사용.

---

## 9. 자경단의 매일 0.1초 안

본인이 `print("hello")` 칠 때 0.1초.

```
0.000s  키 입력
0.005s  bytecode 컴파일 (cache miss)
       또는 cache hit이면 0.001s
0.010s  PVM이 LOAD_GLOBAL "print"
0.015s  CALL_FUNCTION 1
0.020s  print 함수 진입
0.030s  sys.stdout.write 호출
0.050s  C로 fwrite syscall
0.080s  터미널이 글자 그리기
0.100s  본인 화면에 보임
```

10단계. 0.1초.

캐싱된 .pyc 파일 덕분에 두 번째부터 0.05초. 자경단 표준.

---

## 10. 흔한 오해 다섯 가지

**오해 1: GIL = Python 느림.**

I/O bound는 GIL 영향 0.

**오해 2: bytecode 외워야.**

가끔 dis 한 번.

**오해 3: 메모리 직접 관리.**

GC가 알아서.

**오해 4: PEP 다 외워.**

PEP 8 필수, 나머지는 검색.

**오해 5: PyPy 항상 빠름.**

CPU bound만. C 확장 호환 일부.

---

## 11. 흔한 실수 다섯 가지 + 안심 멘트 — Python 깊이 학습 편

Python 깊이 학습하며 자주 빠지는 함정 다섯.

첫 번째 함정, GIL을 항상 문제로. 안심하세요. **I/O bound는 GIL 무관.** CPU bound만 multiprocessing 검토.

두 번째 함정, bytecode 다 읽으려고. 안심하세요. **dis 한 번 보고 끝.** 깊이 들어가지 말기.

세 번째 함정, ref counting + GC 다 외우려고. 안심하세요. **두 메커니즘 같이 동작 한 줄.** 깊이는 두 해 후.

네 번째 함정, PEP 한 번에 다 읽기. 안심하세요. **PEP 8 한 번만.** 나머지는 만났을 때.

다섯 번째 함정, 가장 큰 함정. **CPython이 유일한 Python이라고 생각.** 안심하세요. **PyPy·MicroPython·Jython도 있음.** 일반 학습은 CPython.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 12. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요.

CPython 5단계, bytecode + dis, GIL, refcount + GC, 작은 int 캐싱, PEP 일곱, C 확장.

박수.

다음 H8은 적용 + 회고. 환율 계산기 진화 + Ch008 다리.

```python
import dis, sys
dis.dis(lambda x: x + 1)
print(sys.version)
```

---

## 👨‍💻 개발자 노트

> - PEP 703: GIL-free Python 3.13+ 옵션.
> - bytecode 캐시: __pycache__/*.pyc.
> - sys.intern(): 문자열 인터닝 강제.
> - GC threshold: gc.get_threshold() 700, 10, 10.
> - PyPy 호환성: pure Python 100%, C 확장 일부.
> - 다음 H8 키워드: 환율 계산기 진화 · 7H 회고 · Ch008 다리.
