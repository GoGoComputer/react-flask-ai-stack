# Ch013 · H1 — 모듈·패키지·import 오리엔테이션

> 고양이 자경단 · Ch 013 · 1교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — Ch012 회수와 오늘의 약속
2. 모듈이 무엇인가 — 코드의 단위
3. 옛날 이야기 — 첫 import를 만난 그 날
4. 왜 모듈인가 — 일곱 가지 이유
5. 같이 쳐 보기 — 5줄로 모듈 사용
6. 네 친구 — import·from·`__init__.py`·`__name__`
7. 모듈 vs 패키지 차이
8. 자경단 다섯 명의 매일 모듈
9. 8교시 미리보기
10. import 50년 — C #include부터 PEP 328까지
11. AI 시대의 모듈
12. 자주 받는 질문 다섯 가지
13. 흔한 오해 다섯 가지
14. 마무리

---

## 1. 다시 만나서 반가워요 — Ch012 회수와 오늘의 약속

자, 안녕하세요. 13번째 챕터예요.

지난 Ch012 회수. 파일 I/O와 예외 처리. atomic write, chunking.

이번 Ch013은 모듈과 패키지. 본인의 코드를 단위로 묶는 시간.

오늘의 약속. **본인이 첫 패키지를 만들고 PyPI 패키지를 사용합니다**.

자, 가요.

---

## 2. 모듈이 무엇인가 — 코드의 단위

모듈은 .py 파일 하나. 패키지는 .py 파일 묶음 + __init__.py.

```
# 모듈
exchange.py

# 패키지
vigilante/
├── __init__.py
├── exchange.py
├── validators.py
└── utils.py
```

본인이 처음엔 한 .py 파일에 다 짜요. 50줄, 100줄, 200줄. 그러다 500줄 넘으면 모듈로 쪼개야 해요. 1,000줄 넘으면 패키지로.

자경단의 매일 — 한 모듈 평균 200줄. 한 패키지 평균 5-10 모듈.

---

## 3. 옛날 이야기 — 첫 import를 만난 그 날

옛날 이야기. 12년 전.

회사에서 한 .py 파일에 1,000줄 코드를 짰어요. 사수 형이 보고 "import 좀 해" 한 줄. 저는 처음 from a import b를 쳤어요. 1,000줄을 5개 파일로 쪼갰어요. 각 200줄. 한 모듈씩.

그날 저는 코드의 구조를 깨달았어요. 1,000줄은 미로지만 5x200줄은 도시. 본인도 8시간 후 같아요.

---

## 4. 왜 모듈인가 — 일곱 가지 이유

**1. 재사용**. 다른 프로젝트에서 import.

**2. 가독성**. 작은 파일이 읽기 쉬움.

**3. 협업**. 다섯 명이 다른 모듈 작업.

**4. 테스트**. 모듈마다 pytest.

**5. PyPI 50만 패키지**. import로 사용.

**6. 자경단 매일**. 50번 import.

**7. 면접 단골**.

일곱.

---

## 5. 같이 쳐 보기 — 5줄로 모듈 사용

```python
python3
>>> import math
>>> math.sqrt(16)
>>> from math import pi
>>> import json as j
>>> from collections import Counter
```

5줄에 import 다섯 패턴.

---

## 6. 네 친구 — import·from·`__init__.py`·`__name__`

**import**. 모듈 통째.

```python
import math
math.sqrt(16)
```

**from**. 일부만.

```python
from math import sqrt, pi
sqrt(16)
```

**__init__.py**. 패키지의 진입점.

```
vigilante/
├── __init__.py     # 비어 있어도 OK
└── exchange.py
```

**__name__**. 모듈 이름. 직접 실행 vs import 구분.

```python
if __name__ == "__main__":
    main()
```

자경단 표준.

---

## 7. 모듈 vs 패키지 차이

| 항목 | 모듈 | 패키지 |
|------|------|--------|
| 형태 | .py 파일 | 폴더 + __init__.py |
| 사용 | `import file` | `import package` |
| 크기 | ~500줄 | ~5,000줄 |
| 자경단 | 매일 | 주간 |

작은 코드는 모듈, 큰 코드는 패키지.

---

## 8. 자경단 다섯 명의 매일 모듈

**까미**. import 매일 30번. 표준 + 외부.

**노랭이**. import 매일 50번. React 비슷.

**미니**. 매일 40번. AWS SDK.

**깜장이**. 매일 20번. pytest.

**본인**. 매일 30번.

---

## 9. 8교시 미리보기

H2 — 4 단어 깊이. import, from, __init__.py, __name__.

H3 — venv, pip, pyproject, twine, pipx.

H4 — stdlib 30+ + PyPI 30+.

H5 — vigilante_pkg 30분.

H6 — 함정, dependency 관리.

H7 — import 시스템 내부.

H8 — Ch014 venv와 다리.

---

## 10. import 50년

1972년. C의 #include.

1991년. Python 0.9. import.

2003년. PEP 328. relative import.

2008년. Python 3.0. namespace package.

2017년. PEP 561. type stub.

2024년. AI가 import 자동 추천.

---

## 11. AI 시대의 모듈

AI한테 "이 코드를 모듈로 쪼개" 한 줄. 즉시 파일 분리 추천.

자경단 80/20.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. import vs from?**

import는 namespace, from은 직접.

**Q2. 모듈 vs 패키지?**

크기 차이.

**Q3. __init__.py 비어도?**

OK. namespace package.

**Q4. circular import?**

A → B → A 사고. lazy import.

**Q5. 8시간 길어요.**

코드 구조의 토대.

---

## 13. 흔한 오해 다섯 가지

**오해 1: 한 파일이 좋다.**

500줄 넘으면 분리.

**오해 2: from x import * 편함.**

namespace 오염. 안 씀.

**오해 3: 패키지 어렵다.**

폴더 + __init__.py.

**오해 4: relative vs absolute.**

자경단 표준 absolute.

**오해 5: PyPI 위험.**

검증된 패키지만.

---

## 14. 흔한 실수 다섯 + 안심 — 모듈 첫 학습 편

첫째, 한 파일에 다 모음. 안심 — 500줄 넘으면 모듈로.
둘째, from x import * 편함. 안심 — namespace 오염, 안 씀.
셋째, 패키지 어렵다. 안심 — 폴더 + __init__.py.
넷째, circular import 사고 자주. 안심 — lazy import 또는 구조 재정리.
다섯째, 가장 큰 — PyPI 50만 패키지 두려움. 안심 — 검증된 것만 import.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 15. 마무리

자, 첫 시간 끝.

네 친구 — import, from, __init__.py, __name__.

다음 H2는 4 단어 깊이.

```python
python3 -c "import math; print(math.pi)"
```

---

## 👨‍💻 개발자 노트

> - import 메커니즘: sys.modules cache.
> - __init__.py PEP 328: 패키지 표시.
> - namespace package PEP 420: __init__.py 없이.
> - sys.path: 모듈 검색 경로.
> - importlib: 동적 import.
> - 다음 H2 키워드: import · from · __init__.py · __name__ · sys.path.
