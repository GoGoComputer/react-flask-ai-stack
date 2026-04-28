# Ch008 · H3 — Python 입문 2: 환경점검 — VS Code 디버거·breakpoint·pdb·rich·ipython 5도구

> **이 H에서 얻을 것**
> - VS Code Python 디버거 5단계 (breakpoint·step·watch·call stack·repl)
> - breakpoint() Python 3.7+ 표준 (PEP 553)
> - pdb 5 명령어 (h·n·s·c·q + p·l·b·u·d)
> - rich.print 깊이 — 터미널 색상 + 표 + tree
> - ipython 5 매직 (?·??·%timeit·%debug·%history)
> - 자경단 5명 매일 디버깅 의식

---

## 회수: H2의 25 패턴에서 본 H의 디버깅으로

지난 H2에서 본인은 if·for·while·match·comp 5 도구의 25 패턴을 학습했어요. 그건 **코드 작성**.

본 H3는 그 코드의 **디버깅**이에요. 패턴 25개를 학습해도 첫 코드 80%가 버그. 디버거 5 도구가 자경단 1년 후 평생 시간 절약.

지난 Ch005 H3은 git 셋업, Ch006 H3는 터미널 셋업, Ch007 H3는 Python 환경. 본 H는 디버깅 환경. 자경단 매일 의식 4 stack.

---

## 1. VS Code Python 디버거 5단계

### 1-1. 디버거 설치 (1회)

```bash
# VS Code 확장 (extensions)
1. Python (Microsoft 공식)
2. Pylance (type 검사)
3. Python Debugger (debugpy 기반)

# 셋업 한 줄
$ code --install-extension ms-python.python ms-python.vscode-pylance ms-python.debugpy
```

자경단 1주차 셋업. 평생 디버거.

### 1-2. breakpoint 5 양식

| 양식 | 사용 | 자경단 매일 |
|------|------|------------|
| 빨간 점 클릭 | 줄 옆 클릭 | 가장 흔함 |
| F9 키 | 커서 줄에 토글 | 키보드 표준 |
| `breakpoint()` 코드 | Python 3.7+ | 동적 |
| Logpoint | 우클릭 → Add Logpoint | print 대체 |
| Conditional | 우클릭 → Edit Breakpoint | 조건부 정지 |

5 양식 = 자경단 매일 디버깅의 첫 단계.

### 1-3. 디버그 5 단계 키

| 키 | 명령 | 의미 |
|----|------|------|
| F5 | Continue | 다음 breakpoint까지 |
| F10 | Step Over | 다음 줄 (함수 안 안 들어감) |
| F11 | Step Into | 함수 안으로 |
| Shift+F11 | Step Out | 함수 밖으로 |
| Ctrl+Shift+F5 | Restart | 재시작 |

5 키 = 자경단 매일 디버그의 손가락. 1주일 외움.

### 1-4. Watch 변수

```python
# Watch 패널에 변수 추가
cats             # 5명 list 즉시 보기
cats[0]['age']   # 까미 나이
len(cats)        # 5명 수
sum(c['age'] for c in cats)  # 표현식도 OK
```

Watch = 디버깅 중 변수 실시간 추적. 자경단 매일.

### 1-5. Call Stack + Variables 패널

```
Call Stack:
- convert (api.py:42)
- handle_request (server.py:120)
- main (main.py:5)

Variables:
- Local: amount_krw=10000, currency='USD'
- Global: RATES={...}, CATS=[...]
```

Call Stack = 함수 호출 추적 (어떻게 여기까지 왔나). 자경단 1년 차 시니어.

### 1-6. Debug Console (REPL)

```
> cats
[{'name': '까미', 'age': 2}, ...]

> RATES['USD']
1380.50

> [c for c in cats if c['age'] > 5]
[]
```

디버그 중 임의 표현식 실행. REPL의 디버깅 버전. 자경단 매일.

### 1-7. launch.json 자경단 표준

```json
// .vscode/launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "FastAPI",
            "type": "debugpy",
            "request": "launch",
            "module": "uvicorn",
            "args": ["main:app", "--reload"],
            "jinja": true,
            "justMyCode": true
        },
        {
            "name": "pytest 현재 파일",
            "type": "debugpy",
            "request": "launch",
            "module": "pytest",
            "args": ["${file}", "-v"]
        },
        {
            "name": "Python 현재 파일",
            "type": "debugpy",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal"
        }
    ]
}
```

3 설정 = 자경단 매일 디버깅 90%.

### 1-8. justMyCode vs 라이브러리 디버깅

```json
"justMyCode": true     // 자경단 코드만 step (표준)
"justMyCode": false    // 라이브러리도 step (1년 차 시니어)
```

자경단 — 평소 true. 라이브러리 버그 의심 시 false.

---

## 2. breakpoint() Python 3.7+ 표준 (PEP 553)

### 2-1. breakpoint() 한 줄 매직

```python
def convert(amount_krw, currency):
    rate = RATES.get(currency)
    breakpoint()                # 여기 정지 + REPL 시작
    return amount_krw / rate
```

`breakpoint()` 한 줄 = pdb·VS Code·ipython 등 자동 통합. PEP 553 (2017).

### 2-2. 환경변수로 디버거 선택

```bash
# 기본 — pdb
$ python script.py

# ipdb (ipython 디버거 — 색상)
$ pip install ipdb
$ PYTHONBREAKPOINT=ipdb.set_trace python script.py

# Web 디버거 (web-pdb)
$ PYTHONBREAKPOINT=web_pdb.set_trace python script.py

# 비활성화 (production)
$ PYTHONBREAKPOINT=0 python script.py    # breakpoint() 무시
```

자경단 — 개발 ipdb·production 비활성화.

### 2-3. breakpoint()의 5 활용

```python
# 1. 일시 정지
breakpoint()

# 2. 조건부 정지
if rate is None:
    breakpoint()             # rate가 None일 때만 정지

# 3. 예외 직전
try:
    risky()
except ValueError:
    breakpoint()             # 예외 시점 검토

# 4. 루프 디버깅
for i, cat in enumerate(cats):
    if i == 3:
        breakpoint()         # 4번째에서 정지

# 5. 함수 진입
def handle():
    breakpoint()             # 함수 진입 즉시
    ...
```

5 활용 = 자경단 매일 breakpoint 표준.

### 2-4. breakpoint() vs print() 비교

| 기준 | print | breakpoint |
|------|-------|-----------|
| 정보량 | 1 변수 | 모든 변수 + REPL |
| commit 위험 | 높음 (지우기 잊음) | PYTHONBREAKPOINT=0 |
| 동적 분석 | X | O (REPL 표현식) |
| call stack | X | O |
| 자경단 표준 | 비권장 | 표준 |

자경단 — print 디버깅 자제. breakpoint 표준.

### 2-5. breakpoint()의 commit 함정 면역

```python
# 함정 — print 남김
def convert(amount, currency):
    print(f"DEBUG: {amount} {currency}")  # commit 함정
    return amount / RATES[currency]

# 처방 — breakpoint + ruff 검사
def convert(amount, currency):
    breakpoint()                          # ruff T100 lint 잡음
    return amount / RATES[currency]
```

자경단 — `pre-commit + ruff T100`이 breakpoint commit 막음. 자동 안전.

---

## 3. pdb 5 명령어

### 3-1. pdb 진입 양식

```python
# 1. breakpoint() — 현대 표준
breakpoint()

# 2. import pdb (옛 양식)
import pdb; pdb.set_trace()

# 3. CLI 진입
$ python -m pdb script.py    # 첫 줄부터 디버그
```

자경단 표준 — `breakpoint()`.

### 3-2. pdb 5 핵심 명령어

| 명령 | 의미 | 자경단 매일 |
|------|------|------------|
| h (help) | 도움말 | 첫 학습 |
| n (next) | 다음 줄 | 매번 |
| s (step) | 함수 안 | 매번 |
| c (continue) | 다음 breakpoint까지 | 매번 |
| q (quit) | 종료 | 매번 |

5 명령 = pdb 80%.

### 3-3. pdb 추가 5 명령어 (1년 차)

| 명령 | 의미 | 시나리오 |
|------|------|---------|
| p (print) | 변수 출력 `p cats` | 매번 |
| l (list) | 코드 보기 (현재 ±5줄) | 디버깅 |
| b (break) | breakpoint 추가 `b 50` | 동적 |
| u (up) | 호출 stack 위 | 1년 차 |
| d (down) | 호출 stack 아래 | 1년 차 |

5 명령 = 자경단 1년 차 시니어.

### 3-4. pdb 매직 — 표현식 평가

```
(Pdb) p cats
[{'name': '까미', 'age': 2}, ...]

(Pdb) p [c['name'] for c in cats]
['까미', '노랭이', '미니', '깜장이', '본인']

(Pdb) p sum(c['age'] for c in cats)
12
```

pdb에서 임의 Python 표현식 OK. REPL 그대로.

### 3-5. pdb 종료 양식

```
(Pdb) c                      # 다음 breakpoint까지 + 자동 종료 (없으면)
(Pdb) q                      # 즉시 중단 (BdbQuit 예외)
Ctrl+D                       # EOF (q와 동일)
```

자경단 — c (정상)·q (중단) 둘 다.

### 3-6. pdb 실전 시나리오 — 까미의 첫 디버깅

```bash
$ python -m pdb api.py
> /app/api.py(1)<module>()
-> from fastapi import FastAPI

(Pdb) b 42                       # 42줄에 breakpoint
Breakpoint 1 at /app/api.py:42

(Pdb) c                          # 실행 → 42줄 도달
> /app/api.py(42)convert()
-> return amount_krw / RATES[currency]

(Pdb) p amount_krw, currency
(10000, 'XYZ')                   # 'XYZ' 통화 없음 — 버그 발견

(Pdb) p RATES.keys()
dict_keys(['USD', 'JPY', 'EUR'])

(Pdb) c                          # 계속 → KeyError
KeyError: 'XYZ'

# 처방 — convert() 함수에 검증 추가
```

까미가 1주차에 본 첫 pdb. 5분에 버그 원인 파악.

### 3-7. pdb on the fly — 실행 중 진입

```bash
# Ctrl+\ 또는 SIGUSR1 보냄 — 실행 중 pdb 진입
$ kill -SIGUSR1 $(pgrep python)

# 코드 안 — signal handler
import signal, pdb

def handler(signum, frame):
    pdb.Pdb().set_trace(frame=frame)

signal.signal(signal.SIGUSR1, handler)
```

자경단 1년 차 — production 실행 중 pdb 진입. 매직.

---

## 4. rich.print 깊이

### 4-1. rich 설치

```bash
$ pip install rich
```

자경단 매일 import. .zshrc에 alias `pyrich='python -c "from rich import print"'`.

### 4-2. rich.print 5 가치

1. **자동 색상** — dict·list·tuple 다른 색
2. **자동 들여쓰기** — 깊은 dict 가독성
3. **표 (Table)** — 자경단 매일
4. **tree (Tree)** — 디렉토리·JSON 구조
5. **markdown** — README 터미널 표시

### 4-3. 자경단 매일 5 사용

```python
from rich import print
from rich.table import Table

# 1. dict 가독성
print(cats)                  # 자동 색상·들여쓰기

# 2. 표
table = Table(title="자경단 5명")
table.add_column("이름")
table.add_column("나이")
for cat in cats:
    table.add_row(cat['name'], str(cat['age']))
print(table)

# 3. 진행률 bar
from rich.progress import track
for cat in track(cats, description="처리 중..."):
    process(cat)

# 4. 트리 구조
from rich.tree import Tree
tree = Tree("자경단")
for cat in cats:
    tree.add(cat['name'])
print(tree)

# 5. markdown
from rich.markdown import Markdown
print(Markdown("# 자경단 5명\n- 까미\n- 노랭이"))
```

5 사용 = 자경단 매일 터미널 가독성.

### 4-4. print vs rich.print

```python
# 표준 print
print(cats)
# [{'name': '까미', 'age': 2}, {'name': '노랭이', 'age': 3}]

# rich.print (자동 색상·들여쓰기)
print(cats)
# [
#     {
#         'name': '까미',     ← 빨강
#         'age': 2            ← 파랑
#     },
#     ...
# ]
```

rich.print = 디버깅 가독성 10배. 자경단 매일.

### 4-5. rich Console + Logging 통합

```python
from rich.console import Console
from rich.logging import RichHandler
import logging

# 표준 logging + rich
logging.basicConfig(
    level=logging.INFO,
    format="%(message)s",
    handlers=[RichHandler(rich_tracebacks=True)]
)
log = logging.getLogger("자경단")

log.info("정상")
log.warning("경고")
log.error("에러")              # 색상 + traceback 자동 포맷
```

자경단 production logging 표준. Datadog·Sentry보다 먼저 검토.

### 4-6. rich Traceback — 에러 가독성 10배

```python
from rich.traceback import install
install(show_locals=True)        # 한 번만 호출

# 이제 모든 traceback이 색상 + locals
def buggy():
    cats = [{'name': '까미'}]
    return cats[5]['name']        # IndexError

buggy()
# rich가 색상으로 traceback 표시 + 지역 변수 cats 값까지
```

자경단 — 모든 script 첫 줄에 `install()`. 에러 가독성 10배.

---

## 5. ipython 5 매직 명령어

### 5-1. ipython 설치

```bash
$ pip install ipython
$ alias py='ipython'         # .zshrc에 추가
```

자경단 매일 REPL.

### 5-2. ipython 5 매직

```python
# 1. ? — 함수 도움말
In [1]: convert?
Signature: convert(amount_krw, currency)
Docstring: KRW를 다른 통화로 변환.

# 2. ?? — 소스 코드
In [2]: convert??
Source:
def convert(amount_krw, currency):
    return amount_krw / RATES[currency]

# 3. %timeit — 성능 측정
In [3]: %timeit [c**2 for c in range(1000)]
50.2 µs ± 1.2 µs per loop

# 4. %debug — 마지막 예외 디버깅
In [4]: convert(100, 'XYZ')
KeyError: 'XYZ'
In [5]: %debug
> /path/api.py(42)convert()
   > return amount_krw / RATES[currency]
(ipdb) p RATES
{'USD': 1380.50, ...}

# 5. %history — 명령 이력
In [6]: %history -n
1: convert?
2: convert??
3: %timeit [...]
```

5 매직 = 자경단 매일 REPL의 진짜 가치.

### 5-3. ipython 추가 매직 5

| 매직 | 의미 |
|------|------|
| %paste | 복사한 코드 붙여 (들여쓰기 보존) |
| %run script.py | 스크립트 실행 (변수 유지) |
| %who | 현재 변수 목록 |
| %reset | 모든 변수 삭제 |
| %save filename.py 1-10 | history 저장 |

5 추가 = 자경단 매주.

### 5-4. ipython 자경단 표준 ~/.ipython/profile_default/startup/00-imports.py

```python
# 매 ipython 시작 시 자동 import
from rich import print
import sys
import os
import json
from datetime import datetime, timedelta
from pathlib import Path
import requests

print("[bold green]자경단 ipython 시작[/bold green]")
```

자경단 — 매 ipython 시작 시 6 import 자동. 손가락 절약.

### 5-5. ipython %autoreload 매직

```python
# 매 코드 변경 시 자동 reload
%load_ext autoreload
%autoreload 2

# 이제 import한 모듈 수정해도 자동 반영
from cat_vigilante import api
api.convert(100, 'USD')          # api.py 수정해도 ipython 재시작 X
```

자경단 매일 — autoreload 표준. 개발 속도 5배.

### 5-6. ipython의 5 Tab 자동완성

```python
In [1]: cat = {'name': '까미', 'age': 2}
In [2]: cat.<Tab>               # 모든 method 표시
        cat.clear()  cat.copy()  cat.fromkeys() ...

In [3]: cat['<Tab>             # key 자동완성
        cat['name']  cat['age']

In [4]: import os.<Tab>        # 모듈 attribute 자동완성

In [5]: %ti<Tab>               # 매직 자동완성 → %timeit

In [6]: convert?               # ? — docstring
```

5 Tab = 자경단 매일 손가락 절약.

---

### 5-7. ipython jupyter 차이 — 자경단 사용 시점

| 차이점 | ipython | jupyter |
|--------|---------|---------|
| UI | CLI (터미널) | 브라우저 노트북 |
| 매직 | %timeit·%debug 등 | 동일 |
| 자경단 사용 | 매일 디버깅 | 데이터 분석 |
| 시작 | 200ms | 2초 |
| 영속화 | %save | .ipynb 자동 |
| markdown | 옵션 | 표준 |
| 시각화 | matplotlib 인라인 X | 인라인 O |

자경단 — 디버깅 ipython·시각화 jupyter. 둘 짝.

---

## 6. 디버깅 5 도구 통합 표

| 도구 | 용도 | 자경단 매일 |
|------|------|------------|
| VS Code 디버거 | GUI·시각적 디버깅 | 가장 흔함 |
| breakpoint() | 코드 안 진입점 | 매일 |
| pdb | CLI·서버 디버깅 | 매주 |
| rich.print | 터미널 가독성 | 매일 |
| ipython | REPL·실험 | 매일 |

5 도구 = 자경단 디버깅 100%.

---

## 7. 자경단 매일 디버깅 의식

### 7-1. 매 코드 작성 시 (5분)

```python
# 1. 작성 → 즉시 ipython 실험
def convert(amount, currency):
    return amount / RATES[currency]

# In [1]: convert(1380.50, 'USD')
# Out[1]: 1.0

# 2. 실패 → breakpoint()
def convert(amount, currency):
    if currency not in RATES:
        breakpoint()         # 디버그 진입
    return amount / RATES[currency]
```

자경단 표준 — 작성 → 실험 → breakpoint 3단계.

### 7-2. 매 PR 직전 (10분)

```bash
# 1. pytest --pdb (실패 시 즉시 pdb 진입)
$ pytest --pdb

# 2. python -m pytest --tb=short -v
# 짧은 traceback + verbose

# 3. mypy --pretty
# 색상 type 에러
```

자경단 표준 PR 직전 의식.

### 7-3. 매 사고 (1시간)

```bash
# 1. log 분석 — rich.print
# 2. 재현 — pytest case 작성
# 3. 디버그 — breakpoint() + step
# 4. 처방 — 코드 수정 + test
# 5. 회고 — 5 why 분석
```

자경단 사고 5 단계. 1년 후 자산.

### 7-4. 디버깅 5 도구의 시간 분포

| 시간 | 도구 | 자경단 매일 |
|------|------|------------|
| 5초 | print → rich.print | 매번 |
| 30초 | breakpoint() + REPL | 매시간 |
| 5분 | VS Code 디버거 + Watch | 매일 |
| 30분 | pdb + step + stack | 매주 |
| 1시간 | %timeit·tracemalloc | 매월 |

5 시간대 = 자경단 디버깅 의식의 진짜.

### 7-5. 자경단의 1주차 디버깅 학습 시간표

| 일 | 학습 |
|----|------|
| 월 | VS Code 디버거 5 단계 키 |
| 화 | breakpoint() + 5 양식 |
| 수 | pdb 5 명령 (h·n·s·c·q) |
| 목 | rich.print + Table |
| 금 | ipython + 5 매직 |

5일 × 1시간 = 자경단 첫 주 디버깅 마스터. 평생 자산.

### 7-6. 자경단 디버깅의 5 황금 규칙

1. **재현 먼저** — 사고는 항상 재현 가능한 test case부터
2. **변수 검증** — 의심 변수는 print/breakpoint으로 즉시 확인
3. **이등분 검색** — 큰 함수는 중간에 breakpoint으로 절반 좁힘
4. **단순화** — 입력 데이터를 최소로 줄여 재현
5. **회고 작성** — 사고 후 5 why 분석 + wiki

5 규칙 = 자경단 1년 후 시니어 디버깅 표준.

---

### 7-7. 자경단 매일 디버깅 명령 카탈로그

```bash
# 자경단 매일 alias (.zshrc)
alias py='ipython'
alias pyt='python -m pytest -v'
alias pytp='python -m pytest --pdb'
alias pyd='python -m pdb'

# 매일 사용
$ py                           # ipython 시작
$ pyt                          # 테스트 실행
$ pytp                         # 테스트 + pdb 진입
$ pyd script.py                # pdb로 script 디버깅

# rich 한 줄
$ python -c "from rich import print; print({'cats': ['까미', '노랭이']})"

# breakpoint 모드 변경
$ PYTHONBREAKPOINT=ipdb.set_trace python script.py
$ PYTHONBREAKPOINT=0 python script.py    # production
```

자경단 4 alias = 매일 손가락 절약. 평생 누적 100시간.

### 7-8. 디버깅 패턴 5종 자경단 표준

```python
# 1. 함수 진입 즉시
def convert(amount, currency):
    breakpoint()                        # 함수 진입 디버그

# 2. 조건부 (특정 입력만)
def convert(amount, currency):
    if amount > 10_000_000:
        breakpoint()                    # 큰 금액만 디버그

# 3. 예외 직전
try:
    risky_call()
except Exception:
    breakpoint()                        # 예외 시점 검토

# 4. 루프 N번째
for i, cat in enumerate(cats):
    if i == 100:
        breakpoint()                    # 100번째에서 디버그

# 5. assert + breakpoint
def process(data):
    assert data is not None
    if not data:
        breakpoint()                    # 빈 데이터 디버그
```

5 패턴 = 자경단 매일 breakpoint 100% 사용.

---

## 8. 자경단 5명 매일 디버깅 사용표

| 누구 | 매일 디버깅 |
|------|----------|
| 본인 | VS Code 디버거 + breakpoint (FastAPI) |
| 까미 | pdb (서버) + ipython (실험) |
| 노랭이 | rich.print (터미널) + ipython |
| 미니 | breakpoint + pdb (Lambda) |
| 깜장이 | pytest --pdb + ipython (테스트) |

5명 × 5 도구 = 매일 디버깅 의식.

---

### 8-1. 자경단 5명 1주일 디버깅 시간 분포

| 멤버 | 매일 디버깅 시간 | 주요 도구 |
|------|---------------|----------|
| 본인 | 60분 (FastAPI) | VS Code + breakpoint |
| 까미 | 90분 (DB·async) | pdb + ipython |
| 노랭이 | 30분 (도구) | rich.print + ipython |
| 미니 | 45분 (Lambda·infra) | breakpoint + pdb |
| 깜장이 | 120분 (테스트) | pytest --pdb + ipython |

5명 합 매일 345분 = 5.75시간 디버깅. 자경단 매주 28시간. 1년 1,400시간.

본 H의 5 도구가 1년 1,400시간 절약. ROI 무한대.

### 8-2. 자경단 디버깅 진화 5단계

| 단계 | 시기 | 도구 | 특징 |
|------|------|------|------|
| 1단계 | 1주차 | print | 첫 디버깅 |
| 2단계 | 1개월 | breakpoint() | 표준 도구 |
| 3단계 | 3개월 | VS Code 디버거 | GUI 효율 |
| 4단계 | 6개월 | pdb + ipython | CLI 마스터 |
| 5단계 | 1년 | rich + Logging + py-spy | 시니어 |

5 단계 진화 = 자경단 1년 후 시니어 디버깅.

---

## 9. 흔한 오해 5가지

**오해 1: "print 디버깅이 충분."** — 첫 50줄 OK. 100+ 줄·5+ 함수면 디버거 필수.

**오해 2: "디버거는 시니어 도구."** — 1주차부터. VS Code F9·F10 5분 학습.

**오해 3: "pdb는 옛 도구."** — 서버·Docker·CI에서 GUI 없을 때 표준.

**오해 4: "rich는 화려할 뿐."** — dict 100+ 키 디버깅 시 가독성 10배.

**오해 5: "ipython 무겁다."** — startup 200ms. python REPL 50ms. 차이 의미 X.

**오해 6: "디버거가 코드 이해 방해."** — 정반대. step + Watch가 코드 흐름 시각화.

**오해 7: "rich 라이브러리 의존성 추가."** — pip 한 번. 가독성 10배. ROI 무한.

**오해 8: "production에서 디버거 위험."** — pdb on demand·web-pdb·py-spy 도구 안전. 자경단 1년 차.

---

## 10. FAQ 5가지

**Q1. breakpoint vs print?**
A. breakpoint이 권장. print은 코드 dirty (commit 함정). breakpoint은 PYTHONBREAKPOINT=0으로 비활성.

**Q2. VS Code 디버거 vs PyCharm?**
A. 자경단 표준 VS Code (무료·확장성). PyCharm 더 강력 (유료).

**Q3. pdb 명령 외워야 할 5개?**
A. h·n·s·c·q. 1년 차에 p·l·b·u·d 추가 5개.

**Q4. rich.print 항상 사용?**
A. 디버깅·CLI 표준. logging은 별도.

**Q5. ipython vs jupyter?**
A. ipython CLI·jupyter 노트북. 자경단 둘 다.

**Q6. PyCharm Debugger 차이?**
A. PyCharm 더 강력 (조건부 watch·remote attach 자동). VS Code 충분 + 무료.

**Q7. py-spy 같은 sampling 프로파일러?**
A. production 표준. CPU/메모리 sampling. pdb 대체 아님 (다른 용도).

**Q8. logging vs print?**
A. logging이 표준 (level·format·handler). print는 디버그 빠른 확인.

**Q9. pdb post-mortem 디버깅?**
A. `pdb.pm()` — 마지막 예외 시점 진입. ipython의 %debug과 같음.

**Q10. VS Code remote 디버거?**
A. debugpy + 원격 SSH/Docker. 자경단 1년 차 표준.

---

## 10-1. 디버깅 5 시나리오 + 처방

### 시나리오 1: KeyError 'XYZ'

```python
# 사고
def convert(amount, currency):
    return amount / RATES[currency]

convert(100, 'XYZ')              # KeyError: 'XYZ'

# 처방 — breakpoint으로 검토
def convert(amount, currency):
    if currency not in RATES:
        breakpoint()              # 디버그 진입
    return amount / RATES[currency]

# REPL: p RATES.keys() → dict_keys(['USD', 'JPY', 'EUR'])
# 처방: ValueError raise + 사용자 메시지
```

### 시나리오 2: TypeError 'int + str'

```python
# 사고
total = sum_ages(cats)           # TypeError: int + str
# 원인: cats[2]['age']가 '5' (str) — JSON 로드 시

# 처방 — pdb로 변수 검토
import pdb; pdb.set_trace()      # for 루프 안
# (Pdb) p [type(c['age']) for c in cats]
# [int, int, str, int, int]      # 발견
# 처방: int(cat['age']) 변환
```

### 시나리오 3: 무한 루프

```python
# 사고
while attempts < 5:
    if try_fetch():
        return                   # break 빠뜨림 → attempts 증가 X
    # attempts += 1 빠뜨림

# 처방 — VS Code 디버거 + Watch attempts
# attempts가 0에서 안 변함 발견 → attempts += 1 추가
```

### 시나리오 4: dict 순서 다름

```python
# 사고 — Python 3.6 미만에서 dict 순서 보장 X
result = {c['name']: c['age'] for c in cats}
# JSON 출력 시 매번 다른 순서

# 처방 — Python 3.7+ 강제 + sorted
result = dict(sorted(result.items()))
```

### 시나리오 5: async 함수 동기 호출

```python
# 사고
async def fetch():
    return await get('https://...')

result = fetch()                 # coroutine object — 실행 X

# 처방
result = await fetch()           # async 함수 안
# 또는
import asyncio
result = asyncio.run(fetch())    # sync 함수에서
```

5 시나리오 × 자경단 1년 차 누적 = 디버깅 5 함정 면역.

---

## 11. 추신

추신 1. VS Code 디버거 5 단계 (F5/F10/F11/Shift+F11/Ctrl+Shift+F5) 1주일 외움.

추신 2. breakpoint 5 양식 (빨간점·F9·코드·Logpoint·Conditional).

추신 3. Watch + Call Stack + Variables + Debug Console 4 패널이 디버거 GUI.

추신 4. breakpoint() Python 3.7+ PEP 553 표준. 1줄 매직.

추신 5. PYTHONBREAKPOINT 환경변수로 디버거 선택. ipdb·web-pdb·0 (비활성).

추신 6. breakpoint 5 활용 (일시·조건부·예외 직전·루프·함수 진입).

추신 7. pdb 5 명령 (h·n·s·c·q) = 80% 학습.

추신 8. pdb 추가 5 (p·l·b·u·d) = 1년 차 시니어.

추신 9. pdb 표현식 평가 — REPL 그대로. comp도 OK.

추신 10. rich.print 5 가치 (색상·들여쓰기·표·tree·markdown).

추신 11. rich.Table·rich.Tree·rich.Progress·rich.Markdown 4 도구.

추신 12. print vs rich.print = 가독성 10배. 자경단 매일.

추신 13. ipython 5 매직 (?·??·%timeit·%debug·%history).

추신 14. ipython 추가 5 (%paste·%run·%who·%reset·%save).

추신 15. 자경단 5 도구 디버깅 통합표 — VS Code·breakpoint·pdb·rich·ipython.

추신 16. 매 코드 작성 5분 — ipython 실험 → breakpoint 디버그.

추신 17. 매 PR 직전 10분 — pytest --pdb + tb=short + mypy --pretty.

추신 18. 매 사고 1시간 5단계 — 로그·재현·디버그·처방·회고.

추신 19. 자경단 5명 매일 디버깅 25 도구 = 본 H의 진짜 적용.

추신 20. 흔한 오해 5 면역 (print 충분·디버거 시니어·pdb 옛것·rich 화려·ipython 무거움).

추신 21. FAQ 5 (breakpoint vs print·VS Code vs PyCharm·pdb 5명령·rich 항상·ipython vs jupyter).

추신 22. PEP 553 breakpoint 2017. 자경단 매일 표준.

추신 23. PEP 657 fine-grained traceback (Python 3.11+) — 더 정확한 에러 위치.

추신 24. logpoint VS Code 2018 — print 대체. commit 함정 면역.

추신 25. conditional breakpoint = 함수 1만 회 호출 중 100번째에서만 정지. 자경단 매일 매직.

추신 26. ipdb = ipython + pdb. 색상 + tab 자동완성.

추신 27. web-pdb = 브라우저에서 pdb. 원격 서버 디버깅.

추신 28. pytest --pdb = 테스트 실패 시 즉시 pdb 진입. 자경단 표준.

추신 29. pytest --pdbcls=IPython.terminal.debugger:TerminalPdb = ipdb 사용.

추신 30. **본 H 끝** ✅ — Ch008 H3 환경점검 학습 완료. 5 디버깅 도구 마스터. 다음 H4 명령어카탈로그 (range·enumerate·zip·map·filter 18 도구)! 🐾🐾🐾

추신 31. launch.json 3 설정 (FastAPI·pytest·Python) = 자경단 매일 디버깅 90%.

추신 32. justMyCode true (자경단)·false (라이브러리 의심).

추신 33. breakpoint vs print 5 비교 — 정보량·commit·동적·stack·표준. breakpoint이 자경단 표준.

추신 34. ruff T100 lint이 breakpoint commit 자동 막음. 사전 면역.

추신 35. pdb 실전 — 까미의 1주차 첫 KeyError 5분 해결.

추신 36. SIGUSR1 + signal handler = production pdb 진입. 매직.

추신 37. rich Console + Logging = production 표준. Datadog·Sentry 대안.

추신 38. rich Traceback + show_locals = 에러 가독성 10배.

추신 39. ipython startup 자동 import 6개 (rich.print·sys·os·json·datetime·Path·requests).

추신 40. ipython %autoreload 2 = 매 코드 변경 자동 반영. 개발 5배.

추신 41. ipython 5 Tab (method·key·attribute·magic·docstring) = 매일 손가락 절약.

추신 42. 디버깅 5 도구 시간 분포 — 5초 print·30초 breakpoint·5분 VS Code·30분 pdb·1시간 profiler.

추신 43. 자경단 1주차 디버깅 학습 시간표 (월 VS Code·화 breakpoint·수 pdb·목 rich·금 ipython) = 5시간 마스터.

추신 44. 디버깅 5 황금 규칙 (재현·검증·이등분·단순화·회고) = 1년 후 시니어.

추신 45. 흔한 오해 8 면역.

추신 46. FAQ 10 답변.

추신 47. PEP 553 breakpoint 2017·PEP 657 fine-grained traceback 2022.

추신 48. py-spy production 프로파일러. 자경단 1년 차.

추신 49. logging vs print — logging이 표준 (level·format·handler).

추신 50. **본 H 진짜 끝** ✅ — Ch008 H3 디버깅 환경 학습 완료. 5 도구 + 5 황금 규칙 = 자경단 1년 후 평생 시간 절약. 다음 H4 명령어카탈로그! 🐾🐾🐾🐾🐾

추신 51. 자경단 4 alias (py·pyt·pytp·pyd) = 매일 손가락 절약 평생 100시간.

추신 52. 디버깅 패턴 5종 (함수 진입·조건부·예외 직전·루프 N번째·assert) 자경단 표준.

추신 53. 자경단 5명 매일 345분 디버깅 = 매주 28시간 = 1년 1,400시간 절약 ROI.

추신 54. 디버깅 진화 5단계 (print·breakpoint·VS Code·pdb+ipython·rich+Logging+py-spy).

추신 55. 1년 차에 5단계 도달 = 자경단 시니어 디버깅 양식.

추신 56. PYTHONBREAKPOINT 환경변수 — 개발 ipdb·production 0 비활성.

추신 57. ipython startup 자동 import이 매일 손가락 절약. 자경단 표준.

추신 58. autoreload 2 = 매 코드 변경 자동 반영. 개발 5배 속도.

추신 59. rich.print의 자동 색상·들여쓰기 = 디버깅 가독성 10배.

추신 60. **본 H 100% 끝** ✅✅✅ — 5 디버깅 도구 + 8 패턴 + 5 황금 규칙 + 5 진화 단계. 자경단 1년 후 시니어! 다음 H4 명령어카탈로그 (range·enumerate·zip·map·filter·comprehension 18 도구). 🐾🐾🐾🐾🐾🐾🐾

추신 61. ipython vs jupyter — 디버깅 ipython·시각화 jupyter. 자경단 둘 짝.

추신 62. jupyter 시작 2초·ipython 200ms — 디버깅 빠른 ipython.

추신 63. matplotlib 인라인 — jupyter 표준. ipython은 별도 창.

추신 64. .ipynb 자동 영속화 — jupyter의 자랑. 데이터 분석 표준.

추신 65. 자경단 매일 — ipython 디버깅 + jupyter 시각화. 합쳐서 100% 활용.

추신 66. 본 H의 진짜 결론 — 5 디버깅 도구 1주차 학습 = 1년 1,400시간 절약. ROI 무한대.

추신 67. 본인의 첫 디버깅 — `breakpoint()` 한 줄 + ipython 진입 + REPL 표현식. 5분에 첫 버그 해결.

추신 68. 자경단 5명 같은 5 도구 = 합의 비용 0. 디버깅 양식 통일.

추신 69. 1년 후 본인이 본 디버깅 사고 회고 — print 디버깅 1주일 vs breakpoint+REPL 1시간. 168배 차이.

추신 70. **본 H 진짜 마지막** ✅ — Ch008 H3 디버깅 환경 학습 완료. 5 도구 + 5 패턴 + 5 황금 규칙 + 5 진화 단계 = 자경단 1년 시니어 디버깅 자산. 다음 H4 명령어카탈로그에서! 🐾🐾🐾🐾🐾🐾🐾🐾

추신 71. 디버깅 5 시나리오 (KeyError·TypeError·무한 루프·dict 순서·async 동기) 면역 = 자경단 1년 자산.

추신 72. 본 H 학습 후 본인의 첫 한 행동 — `pip install rich ipython ipdb` 한 줄. 5 도구 셋업 30초.

추신 73. 본인의 첫 .vscode/launch.json 작성 = 자경단 매일 디버깅 자동화. 평생 자산.

추신 74. 본 H의 진짜 메시지 — "디버깅 도구가 시간을 절약한다." 자경단 매주 28시간 절약. 1년 1,400시간 = 평생.

추신 75. **Ch008 H3 100% 끝** ✅✅✅✅✅ — 다음 H4 명령어카탈로그 (range·enumerate·zip·map·filter 18 도구). 🐾
