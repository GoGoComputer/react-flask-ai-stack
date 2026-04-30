# Ch008 · H3 — Python 디버깅 5도구 — VS Code·breakpoint·pdb·rich·ipython

> 고양이 자경단 · Ch 008 · 3교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 왜 디버깅이 중요한가 — 자경단의 매일 시간 절약
3. 첫째 도구 — VS Code 디버거 다섯 단계
4. 둘째 도구 — breakpoint() Python 3.7+ 표준
5. 셋째 도구 — pdb 다섯 명령어
6. 넷째 도구 — rich.print로 예쁜 출력
7. 다섯째 도구 — ipython 매직 명령어
8. 자경단 매일 디버깅 의식
9. 다섯 시나리오와 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리 — 다음 H4에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 도구 설치
pip install rich ipython ipdb

# breakpoint
python3 -c "x = 5; breakpoint(); print(x)"

# pdb
python3 -m pdb script.py

# ipython
ipython
```

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H2를 한 줄로 회수할게요. 제어 흐름 8개념. if 5패턴, truthy/falsy, for+iterable, while+walrus, break/continue, match-case, comprehension 4종, nested.

이번 H3은 디버깅 시간이에요. 본인이 짠 코드가 안 돌면 어떻게 고쳐 나가는지 다섯 도구로. VS Code 디버거, breakpoint(), pdb, rich, ipython.

오늘의 약속은 한 가지예요. **본인이 첫 디버거를 켜고, 첫 breakpoint를 걸고, 변수 값을 들여다보는 그 마법을 손에 익힙니다**. 5년 동안 본인이 매일 만날 디버거의 첫 인사예요.

자, 가요.

---

## 2. 왜 디버깅이 중요한가 — 자경단의 매일 시간 절약

본인이 코드를 짜면서 시간을 어떻게 쓰는지 측정한 연구가 있어요. 50% 코드 짜기, 50% 디버깅. 진짜로요.

본인이 50줄 짜는데 30분이면, 그중 15분이 코드, 15분이 디버깅이에요. 5년이면 디버깅 시간만 5,000시간. 좋은 디버거를 쓰면 그 5,000시간이 1,000시간으로 줄어요. 4,000시간 = 2년 노동시간이 살아나요.

자경단 다섯 명이 매일 디버거를 켜는 횟수가 평균 20번. 5명 × 20번 × 365일 = 36,500번/년. 본인이 5년 후엔 18만 번 디버거를 켰을 거예요. 좋은 친구로 만들어야 해요.

---

## 3. 첫째 도구 — VS Code 디버거 다섯 단계

VS Code의 내장 디버거가 자경단의 첫째 도구예요. 다섯 단계로 사용해요.

**1. breakpoint 걸기**. 코드 줄 번호 옆을 클릭. 빨간 점 생김.

**2. F5 누르기**. 디버거 시작. breakpoint에서 멈춤.

**3. 변수 보기**. 화면 좌측의 Variables 패널에 모든 변수 값. Watch에 표현식 추가 가능.

**4. 한 줄씩 진행**. F10 (Step Over), F11 (Step Into), Shift+F11 (Step Out).

**5. 끝까지**. F5로 다음 breakpoint까지 또는 끝까지.

다섯 단계가 본인의 매일 디버거 사이클이에요. 1분 안에 사고 원인 찾기.

VS Code 디버거의 강력 기능 다섯 가지.

**Conditional breakpoint**. 우클릭 → "Add Conditional Breakpoint". 조건 만족 시만 멈춤. `i == 100`처럼.

**Logpoint**. console.log 대신. 실행 로그만 출력하고 멈추지 않음.

**Variable inspection**. 호버하면 값 보임.

**Call stack**. 어떤 함수가 어떤 함수를 호출했는지.

**Debug console**. breakpoint에서 임의 표현식 평가.

다섯 기능. 자경단 매일 사용.

---

## 4. 둘째 도구 — breakpoint() Python 3.7+ 표준

`breakpoint()` 함수는 Python 3.7+의 표준 디버거 진입점이에요.

```python
def calculate(x, y):
    z = x + y
    breakpoint()    # 여기서 멈춤
    return z * 2
```

이 함수를 실행하면 breakpoint() 줄에서 멈추고 pdb 디버거가 떠요.

```bash
$ python3 calc.py
> /path/to/calc.py(4)calculate()
-> return z * 2
(Pdb)
```

VS Code 안 쓸 때 (셸에서 직접 실행할 때) 이게 표준이에요. `import pdb; pdb.set_trace()`보다 짧고 표준.

환경변수 `PYTHONBREAKPOINT`로 디버거 종류 변경 가능.

```bash
export PYTHONBREAKPOINT=ipdb.set_trace   # ipdb 사용
export PYTHONBREAKPOINT=0                 # 비활성화
```

자경단 표준은 ipdb (ipython 기반 더 친절한 pdb).

---

## 5. 셋째 도구 — pdb 다섯 명령어

pdb는 Python 디버거 콘솔이에요. breakpoint()로 진입.

다섯 명령어가 90% 일을 해요.

**`l`** (list). 현재 위치 코드 보기.
**`n`** (next). 다음 줄로.
**`s`** (step). 함수 안으로.
**`c`** (continue). 다음 breakpoint까지.
**`p 변수`** (print). 변수 값 출력.

```
(Pdb) l
   1  def calculate(x, y):
   2      z = x + y
-> 3      breakpoint()
   4      return z * 2

(Pdb) p z
8

(Pdb) p x, y
(3, 5)

(Pdb) n
> /path/to/calc.py(4)calculate()
-> return z * 2

(Pdb) c
```

다섯 명령어. 6주면 박혀요. 매일 만나요.

추가 명령어 다섯 가지.

`b 줄번호` — breakpoint 추가.
`cl` — breakpoint 제거.
`w` — call stack 보기.
`u/d` — stack 위/아래.
`q` — 종료.

---

## 6. 넷째 도구 — rich.print로 예쁜 출력

`rich`는 터미널에 예쁜 출력을 위한 라이브러리예요. 자경단의 매일 디버깅 친구.

```bash
pip install rich
```

기본 사용.

```python
from rich import print

data = {"name": "까미", "age": 3, "colors": ["black", "white"]}
print(data)
```

기본 print보다 색깔과 들여쓰기가 자동으로. dict, list, JSON 같은 게 진짜 보기 좋아요.

다섯 가지 강력 기능.

**1. inspect** — 객체의 모든 속성 보기.

```python
from rich import inspect
inspect(my_object, methods=True)
```

**2. console.log** — 줄 번호와 시간 자동.

```python
from rich.console import Console
console = Console()
console.log("디버그 메시지")
```

**3. Table** — 표 형태 출력.

```python
from rich.table import Table
table = Table()
table.add_column("Cat")
table.add_column("Age")
table.add_row("까미", "3")
console.print(table)
```

**4. progress bar** — 긴 작업의 진행률.

```python
from rich.progress import track
for cat in track(cats, description="처리 중..."):
    process(cat)
```

**5. traceback** — 예쁜 에러 출력.

```python
from rich.traceback import install
install()
```

다섯 기능. 자경단 매일 사용.

---

## 7. 다섯째 도구 — ipython 매직 명령어

ipython의 매직 명령어 다섯 가지가 디버깅에 진짜 강력.

**1. `%timeit`** — 코드 시간 측정.

```python
%timeit sum(range(100))
```

**2. `%run`** — 파일 실행 후 변수가 살아 있음.

```python
%run script.py
print(result)   # script.py의 결과 변수
```

**3. `%debug`** — 마지막 에러를 pdb로.

```python
some_function()   # 에러 발생
%debug             # 에러 위치에서 pdb
```

**4. `?`와 `??`** — 객체 정보.

```python
list?              # docstring
list??             # source code
```

**5. `%load_ext autoreload`** — 코드 변경 시 자동 reload.

```python
%load_ext autoreload
%autoreload 2
```

다섯 매직. 자경단 데이터 분석할 때 매일.

---

## 8. 자경단 매일 디버깅 의식

자경단 다섯 명이 매일 코드 짜다가 사고 났을 때 도구 선택의 우선순위.

**1. 작은 사고 (변수 값 확인)** → `print(f"{x=}")`

Python 3.8+ f-string에 `=`을 붙이면 변수 이름 + 값. 5초 디버깅.

**2. 중간 사고 (한 함수 안)** → `breakpoint()` + pdb

함수 안 한 줄에 breakpoint 걸고 변수 들여다보기. 30초 디버깅.

**3. 큰 사고 (여러 함수 흐름)** → VS Code 디버거

call stack과 변수 변화 시각적으로. 5분 디버깅.

**4. 운영 사고 (production)** → 로그 분석

print/breakpoint 못 씀. 로그를 미리 잘 짜 두고 사후 분석. 30분 디버깅.

**5. 성능 사고 (느림)** → `%timeit` + cProfile

```bash
python3 -m cProfile script.py
```

도구 선택 의식이 3년 차의 디버깅 직관이에요. 본인은 6주 후부터 직관이 생겨요.

---

## 9. 다섯 시나리오와 처방

**시나리오 1: 변수 값이 None이 떴어요.**

처방. `print(f"{x=}")` 한 줄 추가. None인 줄 위에서 추적.

**시나리오 2: for 루프가 한 번도 안 돌았어요.**

처방. iterable이 비었나 확인. `print(f"{len(items)=}")`.

**시나리오 3: 무한 루프**

처방. Ctrl+C로 멈추고 traceback 보기. while 조건 점검.

**시나리오 4: 잘못된 분기**

처방. `breakpoint()` 걸고 if 조건 변수 점검. `print(f"{x > 0=}")`.

**시나리오 5: import 안 됨**

처방. `python3 -c "import 모듈; print(모듈.__file__)"`. 위치 확인.

다섯 시나리오. 자경단 매일 만나요. 6주 면역.

---

## 10. 흔한 오해 다섯 가지

**오해 1: print만으로 충분.**

작은 사고는 OK. 중간 사고부터 breakpoint 필요.

**오해 2: 디버거는 시니어 도구.**

신입 1주차부터 사용. 빨리 박을수록 5년 시간 절약.

**오해 3: rich는 무거워.**

가벼워요. 매일 사용 권장.

**오해 4: ipython 매직은 옵션.**

데이터 분석엔 필수. 5분 시간 절약.

**오해 5: VS Code 디버거 셋업이 복잡.**

기본 셋팅으로 90% 됨. F5 한 번이면.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. pdb와 ipdb 차이?**

ipdb는 ipython 기반. 더 친절한 출력. 자경단 표준.

**Q2. breakpoint 자동 제거?**

`breakpoint()` 호출은 코드에 남음. commit 전에 제거. ruff가 잡아줘요 (T100).

**Q3. rich가 production에 영향?**

rich는 import만 해도 0.1초. production은 stdout 직접.

**Q4. VS Code 디버거 안 떠요.**

launch.json 설정 필요. Run → Add Configuration → Python.

**Q5. 5도구 다 외워야?**

매일 1, 2번이 90%. 나머지는 필요할 때.

---

## 12. 흔한 실수 다섯 + 안심 — Python 환경 학습 편

첫째, REPL과 .py 헷갈림. 안심 — REPL은 실험, .py는 자산.
둘째, debugger 안 씀. 안심 — `breakpoint()` 한 줄.
셋째, IDE 한 번에 다 셋업. 안심 — VS Code + Python 확장 5분.
넷째, type hint 미루기. 안심 — 첫날부터 한 줄씩.
다섯째, 가장 큰 — venv 안 만들기. 안심 — 매 프로젝트 venv.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리 — 다음 H4에서 만나요

자, 세 번째 시간이 끝났어요. 60분 동안 본인은 디버깅 5도구를 만나셨어요. 정리하면 이래요.

VS Code 디버거 5단계. breakpoint() 표준. pdb 5명령어. rich.print 5기능. ipython 매직 5종. 자경단 매일 의식 — 작은 사고는 print, 중간은 breakpoint, 큰 사고는 VS Code, 운영은 로그, 성능은 timeit.

박수 한 번 칠게요.

다음 H4는 18 도구 카탈로그. 반복 4, 집계 5, 필터 4, comprehension 3, itertools/functools/collections.

그 전에 한 가지 부탁.

```python
python3 -c "x = 5; print(f'{x=}')"
```

5초.

---

## 👨‍💻 개발자 노트

> - breakpoint() PEP 553: 3.7+. PYTHONBREAKPOINT 환경변수로 변경.
> - pdb post-mortem: `python3 -m pdb script.py`로 에러 시 pdb 진입.
> - ipdb: pip install ipdb. ipython 기반 디버거. 색깔 + tab 자동완성.
> - rich vs pprint: pprint는 표준 라이브러리, rich는 더 풍부.
> - cProfile: 함수별 시간. `python3 -m cProfile -s cumtime script.py`.
> - py-spy: 실행 중인 Python의 sampling profiler.
> - VS Code launch.json: `"justMyCode": false`로 라이브러리 코드도 디버깅.
> - 다음 H4 키워드: enumerate · zip · map · filter · sorted · sum · itertools.
