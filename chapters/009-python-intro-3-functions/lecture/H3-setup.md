# Ch009 · H3 — VS Code 함수 navigation 5 단축키 + inspect·dis·profile

> 고양이 자경단 · Ch 009 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. VS Code 함수 navigation 다섯 단축키
3. inspect 모듈 — 함수의 모든 정보
4. dis 모듈 — bytecode 보기
5. cProfile — 함수별 시간 측정
6. py-spy — 실행 중 sampling
7. 자경단 매일 디버깅 의식
8. 다섯 시나리오와 처방
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요.

지난 H2 회수. 함수 8개념 — def 6 인자, return 5패턴, default, *args, type hints, docstring, lambda, closure.

이번 H3는 함수 디버깅 도구. VS Code 단축키와 표준 라이브러리.

오늘의 약속. **본인이 함수의 내부를 들여다보는 다섯 도구를 손에 익힙니다**.

자, 가요.

---

## 2. VS Code 함수 navigation 다섯 단축키

함수가 많아지면 navigation이 일의 절반.

**1. F12** — Go to Definition. 함수 호출에서 정의로.

**2. Shift+F12** — Find All References. 함수가 어디서 호출되는지.

**3. Cmd+T** — Go to Symbol in Workspace. 프로젝트 전체에서 함수 검색.

**4. Cmd+Shift+O** — Go to Symbol in File. 현재 파일의 함수 목록.

**5. Cmd+Click** — F12와 같은 기능, 마우스로.

다섯 단축키. 자경단 매일 100번 사용. 6주면 손가락에 박혀요.

---

## 3. inspect 모듈 — 함수의 모든 정보

`inspect`는 Python 객체의 metadata를 얻는 표준 라이브러리.

```python
import inspect

def greet(name: str, age: int = 0) -> str:
    """인사."""
    return f"안녕 {name}!"

# 함수 시그니처
inspect.signature(greet)
# <Signature (name: str, age: int = 0) -> str>

# 인자 정보
sig = inspect.signature(greet)
for param_name, param in sig.parameters.items():
    print(param_name, param.default, param.annotation)

# source code
inspect.getsource(greet)

# docstring
inspect.getdoc(greet)

# 함수 여부
inspect.isfunction(greet)
```

자경단 매일. 자동 문서 생성, decorator 짤 때.

---

## 4. dis 모듈 — bytecode 보기

`dis`는 함수의 bytecode를 사람이 읽을 수 있게 보여줘요.

```python
import dis

def add(a, b):
    return a + b

dis.dis(add)
```

진짜 출력.

```
  2           0 LOAD_FAST                0 (a)
              2 LOAD_FAST                1 (b)
              4 BINARY_ADD
              6 RETURN_VALUE
```

LOAD_FAST가 인자 로드, BINARY_ADD가 더하기, RETURN_VALUE가 반환. CPython의 4단계.

자경단 가끔. 성능 최적화 또는 함수 내부 이해.

---

## 5. cProfile — 함수별 시간 측정

성능 측정의 표준 도구.

```bash
python3 -m cProfile -s cumtime script.py
```

진짜 출력.

```
ncalls  tottime  cumtime  function
1000    0.523    1.234    fib
2000    0.234    0.456    main
```

ncalls 호출 횟수, tottime 자기 시간, cumtime 자식 포함. 가장 느린 함수 찾기.

함수 한 개만 측정.

```python
import cProfile

cProfile.run("fib(30)")
```

자경단 매주 한 번 성능 점검.

---

## 6. py-spy — 실행 중 sampling

py-spy는 이미 실행 중인 Python 프로세스를 sampling으로 측정.

```bash
brew install py-spy
py-spy top --pid 12345
```

실시간으로 가장 시간 많이 쓰는 함수 보여줌. production에서 도움.

자경단 미니가 production 성능 사고 시 쓰는 도구.

---

## 7. 자경단 매일 디버깅 의식

자경단 다섯 명의 함수 디버깅 우선순위.

**1. 작은 사고 (한 함수)** → `print(f"{var=}")` + breakpoint

**2. 중간 사고 (함수 chain)** → VS Code F12 + breakpoint

**3. 성능 사고** → cProfile

**4. production 성능** → py-spy

**5. 함수 동작 이해** → inspect + dis

다섯 우선순위. 자경단 매일.

---

## 8. 다섯 시나리오와 처방

**시나리오 1: 함수 호출이 안 됨**

처방. inspect.signature로 시그니처 확인. 인자 일치 여부.

**시나리오 2: closure가 이상함**

처방. inspect.getclosurevars로 캡처된 변수 보기.

**시나리오 3: decorator 동작 안 함**

처방. @functools.wraps 누락 확인.

**시나리오 4: 함수가 너무 느림**

처방. cProfile로 가장 느린 부분 찾기.

**시나리오 5: 재귀 깊이 초과**

처방. sys.setrecursionlimit 또는 iterative로 변환.

---

## 9. 흔한 오해 다섯 가지

**오해 1: print만 충분.**

5줄 함수는 OK. 그 이상은 inspect.

**오해 2: cProfile은 production.**

local development에도 가치.

**오해 3: dis는 시니어 도구.**

신입도 한 번 봐 두면 함수 이해 깊어짐.

**오해 4: py-spy는 비싼 도구.**

오픈소스 무료.

**오해 5: VS Code 단축키 5개는 많음.**

매일 100번. 6주면 자동.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. inspect와 dir 차이?**

dir는 단순 속성 목록, inspect는 풍부한 metadata.

**Q2. cProfile vs profile?**

cProfile이 C로 짠 빠른 버전. 표준.

**Q3. py-spy 권한?**

macOS는 sudo 필요. Linux도.

**Q4. dis로 무엇을 배우나?**

함수 내부 메커니즘. CPython 이해.

**Q5. VS Code Cmd+T 안 됨.**

설정에서 단축키 확인. 한국 키보드는 다를 수 있음.

---

## 11. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, IDE 셋업 너무 길게. 안심 — VS Code 5분.
둘째, formatter·linter 안 씀. 안심 — black + ruff.
셋째, tests/ 분리 안 함. 안심 — 첫날.
넷째, requirements 안 만듦. 안심 — pip freeze.
다섯째, 가장 큰 — debugger 안 씀. 안심 — `breakpoint()`.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 세 번째 시간 끝.

VS Code 5 단축키, inspect, dis, cProfile, py-spy.

다음 H4는 18 함수 도구.

```bash
python3 -c "import inspect; print(inspect.signature(print))"
```

---

## 👨‍💻 개발자 노트

> - inspect 모듈: getsource, getdoc, signature, isfunction.
> - dis bytecode: CPython의 stack-based VM 명령.
> - cProfile -s 옵션: cumtime, tottime, calls.
> - py-spy alternatives: pyinstrument, scalene.
> - VS Code Pylance: 함수 navigation 강화.
> - 다음 H4 키워드: functools · partial · reduce · lru_cache · wraps · decorator 패턴.
