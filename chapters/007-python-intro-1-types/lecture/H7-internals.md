# Ch007 · H7 — Python 입문 1: 원리/내부 — CPython VM·GIL·bytecode·PEP·메모리 관리

> **이 H에서 얻을 것**
> - CPython VM 5단계 — 소스코드부터 실행까지
> - GIL (Global Interpreter Lock) — Python 멀티스레드의 진짜
> - bytecode 분석 — `dis` 모듈로 내부 보기
> - PEP 진화 5단계 — Python 30년 역사
> - 메모리 관리 — reference count + GC + 자경단 1년 후 면접 질문
> - 5 함정 + 처방

---

## 회수: H6의 운영에서 본 H의 원리로

지난 H6에서 본인은 PEP 8·black·ruff·docstring·type hint·pre-commit·CI 7 도구로 자경단 매일 운영을 익혔어요. 그건 **운영의 표면**.

이번 H7는 그 운영을 가능하게 하는 **CPython의 내부**예요. VM 5단계·GIL·bytecode·PEP·메모리 관리 5개념이 자경단 1년 후 면접 5질문의 정답.

지난 Ch005 H7은 git 내부 알고리즘, Ch006 H7는 셸 6 syscall. 본 H는 Python VM 내부. 셋이 합쳐 자경단 1년 후 시니어의 3 stack.

---

## 1. CPython VM — 소스코드부터 실행까지 5단계

**CPython** — Python 공식 구현체. C로 작성. 우리가 매일 쓰는 `python3` 명령이 CPython.

다른 구현 — PyPy(JIT, 5배 빠름)·Jython(JVM)·IronPython(.NET)·MicroPython(임베디드). 자경단 표준 — CPython.

### 1-1. CPython 5단계 흐름

```
1. 소스 코드 (.py)
   ↓ tokenizer (어휘 분석)
2. 토큰 (NAME·NUMBER·OP·INDENT 등)
   ↓ parser (구문 분석)
3. AST (Abstract Syntax Tree)
   ↓ compiler
4. bytecode (.pyc)
   ↓ CPython VM (인터프리터)
5. 실행 (CPU)
```

5단계 — `python script.py` 한 번의 실제 흐름. 매번 1~4가 자동.

### 1-2. 단계별 직접 보기

```python
# 1. 소스
code = "x = 5 + 3"

# 2. 토큰 (tokenize 모듈)
import tokenize, io
tokens = list(tokenize.tokenize(io.BytesIO(code.encode()).readline))
# [NAME 'x', OP '=', NUMBER '5', OP '+', NUMBER '3', NEWLINE]

# 3. AST (ast 모듈)
import ast
tree = ast.parse(code)
print(ast.dump(tree))
# Module(body=[Assign(targets=[Name(id='x')], value=BinOp(left=Constant(value=5), op=Add(), right=Constant(value=3)))])

# 4. bytecode (compile + dis)
import dis
dis.dis(code)
#   1           0 LOAD_CONST               0 (5)
#               2 LOAD_CONST               1 (3)
#               4 BINARY_OP                0 (+)
#               6 STORE_NAME               0 (x)
#               8 LOAD_CONST               2 (None)
#              10 RETURN_VALUE

# 5. 실행 — VM이 bytecode 한 줄씩
exec(code)
```

5단계 직접 손가락. 자경단 1년 후 본인의 코드가 어떻게 실행되는지 30초에 설명 가능.

### 1-3. .pyc 파일의 진실

```bash
$ python3 -c "import math"     # math 모듈 사용
$ ls -la __pycache__/
math.cpython-312.pyc           # 자동 생성

# .pyc = bytecode 캐시. 다음 import 빠름
```

자경단 — `__pycache__` .gitignore 표준. 모든 자경단 repo 첫 줄.

### 1-4. CPython의 평가 루프 (eval loop) 실체

CPython VM의 핵심은 `Python/ceval.c`의 `_PyEval_EvalFrameDefault()` 함수. 이 함수가 한 줄짜리 거대한 switch-case로 100+ bytecode opcode를 분기.

```c
// Python/ceval.c 의사 코드
while (1) {
    opcode = NEXTOP();
    switch (opcode) {
        case LOAD_FAST:
            value = fastlocals[oparg];
            PUSH(value);
            break;
        case BINARY_OP:
            // ...
    }
}
```

자경단 1년 차 — CPython 소스 directly 보고 "Python이 결국 거대한 switch-case였구나" 깨달음. 평생 자산.

### 1-5. 5단계 흐름의 실제 시간

| 단계 | 시간 (1000줄 코드) | 자경단 영향 |
|------|------------------|------------|
| tokenize | 5ms | 자동 |
| parse → AST | 10ms | 자동 |
| compile → bytecode | 15ms | .pyc 캐시 |
| VM 실행 | 1초~1분 | 코드 품질 |

5단계 합 — `python script.py` 첫 30ms 셋업 + 실행. .pyc 캐시 후 셋업 5ms.

---

## 2. GIL (Global Interpreter Lock) — Python 멀티스레드의 진짜

### 2-1. GIL 정의

**GIL** — 한 시점에 하나의 thread만 Python bytecode 실행. 1992 Guido van Rossum 도입. 가장 유명한 Python 한계.

```python
import threading

def count(n):
    while n > 0:
        n -= 1

# 4 thread로 4억 카운트
threads = [threading.Thread(target=count, args=(100_000_000,)) for _ in range(4)]
for t in threads: t.start()
for t in threads: t.join()
# 4초 (1 thread도 4초) — GIL 때문에 병렬 X
```

### 2-2. GIL이 막는 것 vs 안 막는 것

| 작업 | GIL 영향 | 자경단 처방 |
|------|---------|------------|
| CPU 집약 (계산) | 막음 (병렬 X) | multiprocessing |
| I/O 집약 (네트워크·디스크) | 안 막음 (해제) | threading or asyncio |
| C 확장 (numpy·pandas) | 안 막음 (해제) | numpy 그대로 |
| asyncio (단일 thread 협력) | 무관 | asyncio |

자경단 — 매일 90% I/O (FastAPI 서버), 10% CPU (데이터 처리). I/O는 asyncio, CPU는 multiprocessing.

### 2-3. GIL 우회 3 방법

```python
# 1. multiprocessing (CPU 집약)
from multiprocessing import Pool
with Pool(4) as p:
    results = p.map(heavy_calc, data)
# 4 process = 진짜 병렬, 4코어 100% 활용

# 2. asyncio (I/O 집약)
import asyncio, aiohttp
async def fetch(url):
    async with aiohttp.ClientSession() as s:
        return await s.get(url)
results = asyncio.run(asyncio.gather(*[fetch(u) for u in urls]))
# 100 URL 동시 = 1초 (순차 100초)

# 3. C 확장 (numpy)
import numpy as np
result = np.sum(np.array(data) ** 2)
# C가 GIL 해제, SIMD 병렬
```

3 우회 = 자경단 매일.

### 2-4. GIL 제거 시도 (PEP 703, 2024)

Python 3.13 (2024.10) — `--disable-gil` 빌드 옵션. PEP 703 by Sam Gross. 5년 후 표준 가능성.

자경단 1년 후 본인이 본 것 — Python 3.13 nogil 빌드로 4코어 4배 속도. 단, C 확장 호환성 5년 마이그레이션.

### 2-5. GIL 면접 질문 (자경단 1년 후)

**Q. Python에서 multithreading이 빠르나요?**
A. CPU 집약 X (GIL 때문에 1코어). I/O 집약 O (GIL 해제). multiprocessing이 CPU 진짜 병렬.

자경단 1년 차 본인이 본 면접 — 3개 회사 동일 질문.

### 2-6. GIL 해제의 100ms 규칙

CPython 3.2+ — 100ms마다 GIL 해제 (이전엔 100 bytecode 마다). I/O 호출이나 명시적 `time.sleep(0)`도 GIL 해제.

```python
# 실험: 4 thread CPU 집약
import threading, time

def worker():
    for _ in range(10**8):  # CPU 집약
        pass

start = time.time()
threads = [threading.Thread(target=worker) for _ in range(4)]
[t.start() for t in threads]
[t.join() for t in threads]
print(f"{time.time() - start:.2f}초")  # 4초 (단일 thread도 4초)
```

자경단 — 이 실험 직접 해보면 GIL 체감. 1년 차 의무.

### 2-7. asyncio 이벤트 루프의 실체

```python
# 자경단 5명 100 URL 동시 fetch (자경단 표준)
import asyncio
import aiohttp

async def fetch(session, url):
    async with session.get(url) as resp:
        return await resp.text()

async def main(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, url) for url in urls]
        return await asyncio.gather(*tasks)

urls = ['https://example.com'] * 100
results = asyncio.run(main(urls))
# 1초 (순차 100초) — 100배 빠름
```

이벤트 루프 — 1 thread + I/O 대기 시 다른 task 실행. GIL 무관.

자경단 — FastAPI 100% async. asyncio가 매일.

---

## 3. bytecode 분석 — dis 모듈로 내부 보기

### 3-1. dis 5 명령어

```python
import dis

# 1. 함수 분석
def add(a, b):
    return a + b

dis.dis(add)
#   2           0 RESUME                   0
#   3           2 LOAD_FAST                0 (a)
#               4 LOAD_FAST                1 (b)
#               6 BINARY_OP                0 (+)
#              10 RETURN_VALUE

# 2. 명령 옵션 보기
dis.show_code(add)

# 3. bytecode 실행 시뮬
dis.Bytecode(add).info()
```

### 3-2. 100+ 명령어 중 자경단 표준 10

| 명령 | 의미 | 사용 빈도 |
|------|------|---------|
| LOAD_FAST | 지역변수 로드 | 매 함수 |
| STORE_FAST | 지역변수 저장 | 매 함수 |
| LOAD_GLOBAL | 전역변수 로드 | 매 함수 |
| LOAD_CONST | 상수 로드 | 매 줄 |
| BINARY_OP | 이항 연산 | 매 줄 |
| CALL | 함수 호출 | 매 줄 |
| RETURN_VALUE | 반환 | 매 함수 |
| JUMP_FORWARD | if/else 점프 | if문 |
| FOR_ITER | for 루프 | for문 |
| LIST_APPEND | list comp | comprehension |

10 명령어 = Python 코드 80%.

### 3-3. 최적화의 힌트 — bytecode가 알려줌

```python
# 코드 1: 일반
def slow():
    result = []
    for i in range(1000):
        result.append(i * 2)
    return result

# 코드 2: list comp
def fast():
    return [i * 2 for i in range(1000)]

# bytecode 비교
# slow: 약 30 명령어
# fast: 약 15 명령어 → 2배 빠름
```

자경단 — list comprehension 표준. bytecode가 절반.

### 3-4. dis로 디버깅 — 1년 차에 한 번

본인이 1년 차에 본 사고 — `if x is 5` (`==` 대신 `is`). bytecode `IS_OP` vs `COMPARE_OP`. dis로 즉시 발견.

자경단 — 의심 코드는 dis. 30초 내부 확인.

### 3-5. bytecode 비교 5 사례 — 자경단 매일 최적화

```python
# 사례 1: f-string vs format vs %
import dis
dis.dis("f'{x}'")           # 3 명령어 (FORMAT_VALUE)
dis.dis("'{}'.format(x)")   # 6 명령어 (LOAD_METHOD + CALL)
dis.dis("'%s' % x")         # 4 명령어 (BINARY_OP %)
# f-string이 가장 빠르고 짧음 → 자경단 표준

# 사례 2: list comp vs map
dis.dis("[x*2 for x in range(10)]")    # 1 LIST_COMP frame
dis.dis("list(map(lambda x: x*2, range(10)))")  # 함수 호출 비용
# list comp 2배 빠름

# 사례 3: dict.get vs try/except
dis.dis("d.get(k, 0)")      # 5 명령어
dis.dis("d[k] if k in d else 0")  # 8 명령어
# dict.get이 깔끔

# 사례 4: + vs join
dis.dis("'a' + 'b' + 'c'")  # 두 BINARY_OP (O(n²))
dis.dis("''.join(['a','b','c'])")  # 한 함수 호출 (O(n))
# 큰 리스트는 join 100배

# 사례 5: is None vs == None
dis.dis("x is None")        # IS_OP
dis.dis("x == None")        # COMPARE_OP (느림)
# is None이 표준
```

5 비교 = 자경단 매일 최적화 5 패턴.

---

## 4. PEP 진화 5단계 — Python 30년 역사

### 4-1. PEP 정의

**PEP** (Python Enhancement Proposal) — Python 변경 제안 문서. 1999 시작. 현재 700+ PEP.

자경단 매일 참고 PEP 10:
- PEP 8 (코드 스타일)
- PEP 257 (docstring)
- PEP 484 (type hint)
- PEP 526 (변수 annotation)
- PEP 585 (내장 generic `list[str]`)
- PEP 604 (Union `int | str`)
- PEP 612 (ParamSpec)
- PEP 695 (type alias syntax)
- PEP 703 (no-GIL)
- PEP 711 (PyBI binary install)

### 4-2. Python 30년 진화 5단계

| 단계 | 시기 | 대표 PEP | 자경단 영향 |
|------|------|---------|------------|
| 1. 탄생 | 1991-2000 | Python 1.0 | 역사 |
| 2. 표준화 | 2000-2008 | PEP 8·257 | 매일 표준 |
| 3. 3.0 전환 | 2008-2015 | PEP 3000 (Python 3) | 5년 마이그 |
| 4. type 시대 | 2015-2020 | PEP 484·526·585 | 매일 type hint |
| 5. 성능 | 2020-현재 | PEP 659·703·711 | 미래 |

5단계 = Python 자경단 1년 후 면접 큰 줄기.

### 4-3. Python 3.0 전환 (PEP 3000) — 자경단 평생 학습

2008년 Python 3.0 발표. 2 → 3 호환성 깨짐. `print` → `print()`·`unicode` 표준·`/` 항상 float·`xrange` 삭제.

5년 마이그레이션 — 2015년까지 Python 2가 80%, 2020년 Python 2 EOL.

자경단 — 모든 코드 Python 3.12+. Python 2 코드 만나면 무조건 마이그.

### 4-4. type 시대 PEP 5 (자경단 매일)

```python
# PEP 484 (2014) — type hint 도입
def add(a: int, b: int) -> int:
    return a + b

# PEP 526 (2016) — 변수 annotation
x: int = 5

# PEP 585 (2019) — 내장 generic
items: list[int] = [1, 2, 3]   # 옛: List[int]

# PEP 604 (2020) — Union | syntax
value: int | str = 5            # 옛: Union[int, str]

# PEP 695 (2022) — type alias syntax
type CatId = int                 # 옛: CatId = int
```

5 PEP × 매일 = 자경단 type hint 90% 진화.

### 4-5. 성능 PEP 3 (자경단 미래)

- **PEP 659** (2021) — Specializing Adaptive Interpreter (3.11+ 25% 빠름)
- **PEP 703** (2024) — no-GIL (3.13 옵션, 3.14+ 표준 가능)
- **PEP 744** (2024) — JIT compiler (3.13 실험, 3.14+ 정식)

자경단 1년 후 — Python 3.13 nogil + JIT = 4코어 5배 속도.

### 4-6. Python 버전 진화 자경단 표준

| Python | 출시 | 주요 PEP | 자경단 채택 |
|--------|------|---------|------------|
| 3.6 | 2016 | f-string·dict 순서 | 스킵 |
| 3.7 | 2018 | dataclass·breakpoint() | 사용 |
| 3.8 | 2019 | walrus `:=`·positional only | 사용 |
| 3.9 | 2020 | dict merge `|`·내장 generic | 사용 |
| 3.10 | 2021 | match-case·Union `|` | 표준 |
| 3.11 | 2022 | 25% 빠름·Self type | 표준 |
| **3.12** | **2023** | **type alias·f-string 자유** | **자경단 표준** |
| 3.13 | 2024 | no-GIL·JIT 실험 | 검토 |

자경단 — Python 3.12 표준. 1년 후 3.13 마이그.

---

## 5. 메모리 관리 — reference count + GC

### 5-1. reference count (참조 카운트)

```python
import sys

x = [1, 2, 3]
sys.getrefcount(x)              # 2 (변수 x + getrefcount 인자)

y = x
sys.getrefcount(x)              # 3

del y
sys.getrefcount(x)              # 2

del x                            # refcount 0 → 즉시 메모리 해제
```

CPython — 모든 객체 reference count. 0 되면 즉시 해제. C++의 shared_ptr 비슷.

### 5-2. circular reference + GC

```python
# 순환 참조 — refcount만으로 해제 X
a = []
b = []
a.append(b)
b.append(a)
del a
del b
# 메모리 누수! refcount 둘 다 1

# Python의 GC가 5초 마다 순환 감지 → 해제
import gc
gc.collect()                    # 강제 GC 실행
```

CPython — refcount 80% + 주기적 mark-and-sweep GC 20%. 자경단 매일 자동.

### 5-3. 메모리 함정 5

```python
# 1. 큰 list 누적
data = []
for _ in range(1000000):
    data.append(load_huge_object())  # 메모리 OOM

# 2. global cache 무한
CACHE = {}
def fetch(key):
    if key not in CACHE:
        CACHE[key] = expensive_call(key)
    return CACHE[key]
# CACHE 무한 증가. functools.lru_cache(maxsize=1000) 사용

# 3. closure가 큰 객체 잡음
def make_handler(big_data):
    def handler():
        return len(big_data)     # big_data 평생 잡음
    return handler

# 4. circular reference (회피)
class Node:
    def __init__(self):
        self.parent = None      # 약한 참조 weakref 권장

# 5. C 확장의 메모리 누수
# numpy·pandas·torch — 큰 array del 후 gc.collect()
```

5 함정 면역 = 자경단 1년 OOM 무사고.

### 5-4. 메모리 측정 도구 5

| 도구 | 사용 | 자경단 활용 |
|------|------|------------|
| sys.getsizeof | 객체 크기 | 매일 |
| tracemalloc | 메모리 누수 추적 | 사고 시 |
| memory_profiler | 함수별 메모리 | 디버깅 |
| pympler | 깊은 측정 | 1년 차 |
| objgraph | 객체 그래프 시각화 | 1년 차 |

5 도구 × 자경단 매일/1년 = 메모리 마스터.

### 5-5. 메모리 누수 면접 질문

**Q. Python에서 메모리 누수가 발생할 수 있나요?**
A. 가능. 1) global cache 무한·2) circular reference (GC 늦음)·3) closure가 큰 객체·4) C 확장 누수. 처방 — lru_cache·weakref·gc.collect·tracemalloc.

자경단 1년 후 면접 단골.

### 5-6. tracemalloc 실전 사용

```python
# 자경단 메모리 누수 추적 표준 패턴
import tracemalloc

tracemalloc.start()

# 의심 코드
for _ in range(1000):
    process_request()

snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 메모리 ]")
for stat in top_stats[:10]:
    print(stat)
# /app/api.py:42: size=512 KiB, count=10240, average=51 B
# /app/cache.py:15: size=200 KiB, count=2000, average=100 B
```

자경단 메모리 사고 — tracemalloc 30분이면 원인 파악. 자경단 1년 차 의무 도구.

### 5-7. 자경단 메모리 5 KPI

| KPI | 목표 | 측정 |
|-----|------|------|
| process RSS | < 500MB | `ps` |
| heap 증가율 | < 1MB/min | tracemalloc |
| GC 빈도 | < 10/sec | `gc.get_stats()` |
| 객체 수 (gc) | 안정 | `len(gc.get_objects())` |
| OOM 사고 | 0 | 모니터링 |

5 KPI × 매주 확인 = 자경단 메모리 마스터.

---

### 5-8. CPython 객체의 실제 크기

```python
import sys

sys.getsizeof(0)            # 28 bytes (PyLong overhead)
sys.getsizeof(1)            # 28
sys.getsizeof(2**62)        # 36 (큰 int은 더 큼)
sys.getsizeof(0.1)          # 24 (float)
sys.getsizeof(True)         # 28 (int subclass)
sys.getsizeof("a")          # 50 (str + 1 char)
sys.getsizeof("")           # 49
sys.getsizeof([])           # 56 (빈 list)
sys.getsizeof([0])          # 64 (1개 추가 = 8 bytes pointer)
sys.getsizeof({})           # 64 (빈 dict)
sys.getsizeof(set())        # 216 (빈 set, 큼)
sys.getsizeof(())           # 40 (빈 tuple, list보다 작음)
```

자경단 — 1억 개 int = 2.8GB. tuple이 list보다 작음. set 크기 큰 함정.

### 5-9. __slots__로 메모리 50% 절약

```python
# 일반 class — __dict__ 사용 (큼)
class Cat:
    def __init__(self, name, age):
        self.name = name
        self.age = age

c = Cat('까미', 2)
sys.getsizeof(c)            # 48
sys.getsizeof(c.__dict__)   # 296 → 합 344 bytes

# __slots__ — __dict__ 없음 (작음)
class CatSlim:
    __slots__ = ('name', 'age')
    def __init__(self, name, age):
        self.name = name
        self.age = age

c2 = CatSlim('까미', 2)
sys.getsizeof(c2)           # 48
# __dict__ 없음 → 50% 절약
```

자경단 — 100만 개+ 객체일 때 `__slots__` 표준. ORM·dataclass도 지원.

---

## 6. CPython 소스코드 5 디렉토리 (1년 차)

CPython GitHub — github.com/python/cpython. 자경단 1년 후 직접 검토.

| 디렉토리 | 내용 | 자경단 흥미 |
|----------|------|------------|
| `Python/` | VM·인터프리터 C 코드 | bytecode 실행 |
| `Objects/` | int·list·dict 등 객체 C | dict 구현 |
| `Lib/` | 표준 라이브러리 Python | os·json 코드 |
| `Modules/` | C 확장 | math·hashlib |
| `Include/` | 헤더 | API |

자경단 1년 차 — `Lib/json/` 보고 json 인코더 이해. 평생 자산.

---

## 7. 자경단 5명 매일 원리/내부 사용표

| 누구 | 매일 사용 |
|------|---------|
| 본인 | dis (병목 분석) + tracemalloc (누수 추적) |
| 까미 | asyncio (FastAPI) + multiprocessing (데이터) |
| 노랭이 | numpy·pandas (C 확장 GIL 해제) |
| 미니 | gc.collect (대용량 ETL) |
| 깜장이 | dis (테스트 디버깅) |

5명 × 5 도구 = 매일 원리 활용.

### 7-1. 자경단 1주일 원리/내부 사용 시나리오

| 요일 | 사고 | 도구 | 시간 |
|------|------|------|------|
| 월 | API 5초 응답 | dis (병목 식별) | 30분 |
| 화 | 메모리 점진 증가 | tracemalloc | 1시간 |
| 수 | 4 thread 1코어 | GIL 학습 → multiprocessing | 2시간 |
| 목 | dict lookup 느림 | dis로 hash 확인 | 30분 |
| 금 | 100만 객체 OOM | __slots__ 도입 | 2시간 |

5 사고 × 6시간 = 자경단 매주 원리 시간. 1년 후 시니어.

---

## 8. 5 함정 + 처방

### 8-1. 함정 1: GIL 모르고 멀티스레드

**증상**: thread 4개 만들었는데 1코어만 사용.

**처방**: CPU 집약 → multiprocessing. I/O 집약 → asyncio·threading.

### 8-2. 함정 2: 작은 int 캐싱

```python
a = 256
b = 256
a is b              # True (캐싱)

a = 257
b = 257
a is b              # False (캐시 안 됨, -5~256만)
```

**처방**: `==` 사용. `is`는 None·True·False만.

### 8-3. 함정 3: mutable default 인자

```python
def add_cat(cats=[]):           # 함정!
    cats.append('까미')
    return cats

add_cat()                       # ['까미']
add_cat()                       # ['까미', '까미']  ← 누적!
```

**처방**: `cats=None` + 함수 안에서 `cats = cats or []`.

### 8-4. 함정 4: list comprehension의 변수 누설 (Python 2)

Python 3에서 해결됨. Python 2 코드 마이그레이션 시 주의.

### 8-5. 함정 5: bytecode 의존 코드

**증상**: bytecode 직접 사용한 코드가 Python 3.11→3.12에서 깨짐.

**처방**: bytecode는 버전별 변동. `dis` 모듈 안정 API만 사용. 직접 `co_code` 다루지 마세요.

### 8-6. 함정 6 (보너스): asyncio + 동기 코드 혼용

**증상**: async 함수 안에서 `time.sleep(5)` → 이벤트 루프 5초 정지.

**처방**:
- 동기 함수는 `asyncio.to_thread(sync_func)`로 thread 실행
- 또는 async 라이브러리 사용 (aiohttp·asyncpg·aiofiles)
- `time.sleep` → `await asyncio.sleep` 절대 규칙

자경단 1년 차 본인이 본 사고 — FastAPI 엔드포인트가 `requests.get()` 사용 → 모든 요청 직렬화. `httpx.AsyncClient`로 교체 → 100배 throughput.

### 8-7. 함정 7 (보너스): GIL 정상 해제 안 되는 C 확장

**증상**: 자작 C 확장이 GIL 안 해제 → 다른 thread 영원 대기.

**처방**:
- C 코드에 `Py_BEGIN_ALLOW_THREADS` / `Py_END_ALLOW_THREADS` 매크로
- 표준 라이브러리 검토 (math·hashlib는 자동 해제)
- 자경단 — Cython·numpy 사용. 자작 C 자제.

---

## 9. 자경단 1년 후 면접 7질문 + 정답

**Q1. CPython이 무엇인가요?**
A. Python 공식 구현. C로 작성. 다른 — PyPy(JIT)·Jython(JVM).

**Q2. GIL이 무엇이고 왜 있나요?**
A. 한 시점 1 thread만 bytecode 실행. C 확장 안전성 + 메모리 관리 단순화. CPU 병렬 X·I/O 병렬 O.

**Q3. multiprocessing vs asyncio vs threading?**
A. CPU 집약 → multiprocessing. I/O 집약 → asyncio (async/await) or threading.

**Q4. Python 메모리 관리?**
A. reference count + 주기적 GC (순환 참조용). 80:20.

**Q5. is vs == 차이?**
A. is — 같은 객체 (메모리 주소). == — 값 비교. None은 `is None`. 일반은 `==`.

**Q6. PEP 8이 무엇인가요?**
A. Python 코드 스타일 표준. 4 공백·snake_case·줄 79자·import 3 그룹.

**Q7. type hint 런타임 영향?**
A. 거의 없음. 정적 검사용 (mypy). pydantic 등 명시적만 런타임.

7 질문 = 자경단 1년 후 본인이 본 면접 7회 누적.

---

## 10. 흔한 오해 5가지

**오해 1: "Python은 무조건 느리다."** — CPython은 느려도 numpy·pandas (C 확장)는 빠름. PyPy 5배. Python 3.13 JIT 1.5배.

**오해 2: "GIL 때문에 Python 못 씀."** — 90% 워크로드 I/O. asyncio로 해결. CPU는 multiprocessing.

**오해 3: "메모리 관리는 알 필요 없다."** — 1년 후 OOM 사고 한 번 = 1주일 디버깅. 5 함정 면역 필수.

**오해 4: "bytecode는 시니어만."** — `dis.dis(func)` 한 줄. 매일 의심 코드 검토.

**오해 5: "PEP는 너무 많다."** — 자경단 매일 5 PEP만 (8·257·484·585·604). 나머지는 필요 시.

**오해 6: "asyncio는 어렵다."** — async/await 1주일 학습 = 평생 자산. FastAPI 자경단 표준이라 무조건 학습.

**오해 7: "GIL이 빨리 없어진다."** — PEP 703 (2024) 옵션 빌드. 5년 후 표준 가능성. 자경단 — 현재 multiprocessing·asyncio·numpy 우회로 충분.

---

## 11. FAQ 7가지

**Q1. CPython vs PyPy 무엇 쓰나요?**
A. 자경단 표준 CPython. 호환성 100%. PyPy는 5배 빠름이지만 C 확장 호환성 90%.

**Q2. GIL 제거되면 코드 안 바꿔도 되나요?**
A. 대부분 OK. C 확장은 마이그 필요. Python 3.13 옵션 빌드.

**Q3. asyncio 학습 곡선 가파른가요?**
A. async/await 1주일. 자경단 표준 — FastAPI 코드 90% async.

**Q4. multiprocessing 비용 큰가요?**
A. process spawn 100ms. 1초+ 작업만 쓰세요. 짧은 작업은 thread.

**Q5. 메모리 누수 어떻게 찾나요?**
A. tracemalloc 표준. `tracemalloc.start()` + `take_snapshot()` 비교.

**Q6. bytecode 최적화 직접 할 수 있나요?**
A. 비권장. `@functools.cache`·list comp 등 표준 패턴 사용. CPython이 자동 최적화.

**Q7. CPython 코드 기여 가능한가요?**
A. 가능. github.com/python/cpython · 한국인 커미터 5명+. 자경단 1년 후 첫 PR 도전.

**Q8. PyPy를 쓸 만 한가요?**
A. 자경단 — CPython 표준. PyPy는 5배 빠르지만 C 확장 호환성 90%·일부 라이브러리 미지원. 순수 Python 코드만 PyPy 검토.

**Q9. C 확장을 직접 작성해야 하나요?**
A. 99% 불필요. Cython·numba·PyO3 (Rust) 같은 도구가 더 안전. 자경단 1년 차에 한 번 검토.

**Q10. Python 3.13 nogil 빌드를 자경단 도입할까요?**
A. 아직 검토 단계. 1년 후 Python 3.14에서 안정화 시 도입. C 확장 호환성 5년 마이그.

---

## 12. 추신

추신 1. CPython 5단계 (소스→토큰→AST→bytecode→VM)가 본인의 매 `python script.py` 흐름.

추신 2. GIL이 Python의 유명 한계. CPU 1코어. I/O는 해제.

추신 3. multiprocessing·asyncio·C 확장 3 우회가 자경단 매일.

추신 4. dis 모듈로 bytecode 직접 보기. 30초 내부 확인.

추신 5. PEP 30년 700+ 중 자경단 매일 5 (8·257·484·585·604).

추신 6. Python 3.0 전환 (2008→2020) 12년. 자경단 — Python 3.12+.

추신 7. type 시대 PEP 5 (484·526·585·604·695)가 자경단 매일.

추신 8. 성능 PEP 3 (659·703·744)가 Python 3.11~3.14 진화.

추신 9. reference count + GC 80:20이 Python 메모리.

추신 10. 메모리 5 함정 면역이 1년 OOM 무사고.

추신 11. 메모리 측정 5 도구 (getsizeof·tracemalloc·memory_profiler·pympler·objgraph).

추신 12. CPython 소스 5 디렉토리 (Python·Objects·Lib·Modules·Include) 1년 후 검토.

추신 13. 자경단 1년 후 면접 7질문 (CPython·GIL·MP/asyncio/thread·메모리·is/==·PEP 8·type) 정답.

추신 14. 5 함정 (GIL·int 캐싱·mutable default·list comp 누설·bytecode 변동) 면역.

추신 15. 흔한 오해 5 면역 = 자경단 평생.

추신 16. 본 H의 5 개념 (VM·GIL·bytecode·PEP·메모리)이 자경단 시니어 5 stack.

추신 17. dis로 if vs elif·list comp vs for·is vs == 차이 30초 확인.

추신 18. asyncio가 자경단 FastAPI 매일. async/await 1주일 학습.

추신 19. multiprocessing이 데이터 처리 4코어. Pool(4) 한 줄.

추신 20. numpy·pandas가 C 확장 GIL 해제. 자경단 데이터 표준.

추신 21. tracemalloc이 누수 추적 표준. start + snapshot.

추신 22. functools.lru_cache(maxsize=1000)이 cache 표준. 무한 cache 함정 면역.

추신 23. weakref가 circular reference 면역. 자경단 1년 차.

추신 24. PEP 703 (no-GIL) Python 3.13+ 옵션. 5년 후 표준 가능.

추신 25. PEP 744 (JIT) Python 3.13+ 실험. 1.5배 속도.

추신 26. PEP 659 (Specializing Adaptive Interpreter) Python 3.11+ 25%.

추신 27. CPython 1.0 (1994) → 3.12 (2023) 30년 진화.

추신 28. Guido van Rossum (BDFL 1991-2018) → Steering Council 5명.

추신 29. Python 4.0 없음. 3.x 영원 (Guido 발표).

추신 30. 본 H의 진짜 결론 — CPython VM 5단계가 매일 흐름이고, GIL은 90% I/O로 우회되며, dis로 30초 내부 확인, PEP 매일 5개, 메모리 5 함정 면역이 자경단 1년 후 시니어. 다음 H8은 적용/회고로 Ch007 마무리. 🐾

추신 31. tokenize 모듈로 토큰 직접 확인. 매년 한 번 호기심.

추신 32. ast 모듈로 AST 직접 확인. 코드 분석 도구의 기본.

추신 33. compile() 함수로 직접 bytecode 만들기. 동적 코드 생성 (eval·exec).

추신 34. exec() vs eval() — exec 문장 (할당 OK)·eval 표현식만. 보안 — 사용 자제.

추신 35. globals() vs locals() — 현재 스코프 dict. 디버깅 활용.

추신 36. __dict__·__slots__ — 객체 attribute. __slots__로 메모리 절약 50%.

추신 37. id(obj) — 객체 메모리 주소. is 비교의 근본.

추신 38. hash(obj) — dict/set 키 해시. immutable만 hash 가능.

추신 39. __hash__·__eq__ — 사용자 클래스 dict 키 사용 시 둘 같이 정의.

추신 40. CPython의 dict — open addressing + Robin Hood (3.6+). PEP 468 순서 보장.

추신 41. CPython의 list — dynamic array. amortized O(1) append.

추신 42. CPython의 set — hash table. O(1) lookup.

추신 43. CPython의 str — immutable + intern (작은 str 캐싱).

추신 44. CPython의 int — 무한대 정밀도. PyLong 구조체 (digit 배열).

추신 45. CPython의 float — IEEE 754 double (64비트).

추신 46. functools.cache (3.9+) — lru_cache의 무한 버전. CPU 집약 함수에.

추신 47. itertools — Python 표준 라이브러리의 보석. 자경단 매일 5 (chain·groupby·product·combinations·count).

추신 48. collections — defaultdict·Counter·OrderedDict·deque·namedtuple. 자경단 매일.

추신 49. dataclasses — 보일러플레이트 제거. Python 3.7+. 자경단 표준.

추신 50. **본 H 끝** ✅ — Python 원리 5 개념 학습 완료. 자경단 1년 후 시니어의 5 stack! 다음 H8 Ch007 마무리! 🐾🐾🐾

추신 51. CPython 평가 루프 `_PyEval_EvalFrameDefault()`가 100+ opcode switch-case. 1년 차 호기심.

추신 52. .pyc 캐시가 import 속도 10배. 자경단 production은 .pyc 미리 생성.

추신 53. asyncio 100 URL 1초 vs 순차 100초. 100배 throughput.

추신 54. multiprocessing Pool(4) 한 줄 = CPU 4코어. 데이터 처리 표준.

추신 55. tracemalloc 30분 = 메모리 누수 원인 파악. 자경단 1년 차 의무.

추신 56. __slots__ 100만 객체 50% 절약. ORM·dataclass 짝.

추신 57. f-string 3 명령어 = format 6 명령어 = % 4 명령어. 자경단 표준 f-string.

추신 58. list comp 2배 빠름. map+lambda 비교 시 표준.

추신 59. + str 연결 O(n²) vs join O(n). 큰 리스트 100배 차이.

추신 60. tuple < list < set 메모리. immutable이 작음.

추신 61. dict open addressing + Robin Hood (3.6+). PEP 468 순서 보장.

추신 62. set hash table O(1). list O(n) 검색과 비교.

추신 63. str intern (작은 str 캐싱). `'abc' is 'abc'` True (CPython 구현).

추신 64. int 무한대 정밀도. JS·Java와 차이.

추신 65. functools.cache vs lru_cache(maxsize=None) — 같은 일.

추신 66. 자경단의 진짜 가르침 — "원리는 1년 후 시니어의 5 stack". 본 H가 그 시작.
