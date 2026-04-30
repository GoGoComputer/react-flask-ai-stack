# Ch013 · H2 — 모듈/패키지 4 단어 깊이

> 고양이 자경단 · Ch 013 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. import 5 패턴
3. from 5 패턴
4. __init__.py 깊이
5. __name__ 깊이
6. sys.path와 모듈 검색
7. relative vs absolute import
8. circular import 함정
9. 한 줄 분해
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요.

지난 H1 회수. 네 친구 — import, from, __init__.py, __name__.

이번 H2는 깊이.

오늘의 약속. **본인이 import 시스템의 모든 패턴을 다룹니다**.

자, 가요.

---

## 2. import 5 패턴

```python
# 1. 모듈 통째
import math
math.sqrt(16)

# 2. 별명
import numpy as np
np.array([1, 2, 3])

# 3. 패키지 안 모듈
import os.path
os.path.join("a", "b")

# 4. 여러 모듈
import os, sys, json   # 한 줄에 여러 (PEP 8은 별 줄 권장)

# 5. 조건부 import
try:
    import ujson as json
except ImportError:
    import json
```

5 패턴.

---

## 3. from 5 패턴

```python
# 1. 단일 import
from math import sqrt
sqrt(16)

# 2. 여러
from math import sqrt, pi, sin

# 3. 별명
from numpy import array as a

# 4. 모두 (안 씀)
from math import *

# 5. 패키지 안 모듈
from os.path import join, exists
```

자경단 표준 — 1, 2번이 90%. *는 절대 안 씀.

---

## 4. __init__.py 깊이

빈 __init__.py.

```python
# vigilante/__init__.py
# 비어 있음
```

`import vigilante`로 패키지 import 가능.

조금 채운 __init__.py.

```python
# vigilante/__init__.py
from .exchange import convert
from .validators import validate_currency

__version__ = "1.0.0"
__all__ = ["convert", "validate_currency"]
```

`__all__`은 `from vigilante import *` 때 노출 목록.

자경단 표준 — public API를 __init__.py에.

```python
# 사용
import vigilante
vigilante.convert(50, "USD", "KRW")
```

내부 구조 (exchange.py, validators.py)를 사용자가 몰라도 됨.

---

## 5. __name__ 깊이

```python
# script.py
print(__name__)

# 직접 실행
$ python3 script.py
__main__

# import 시
$ python3 -c "import script"
script
```

표준 패턴.

```python
def main():
    ...

if __name__ == "__main__":
    main()
```

직접 실행 시만 main(). import 시 안 실행.

자경단 표준 — 모든 실행 가능 모듈에.

---

## 6. sys.path와 모듈 검색

```python
import sys
print(sys.path)
```

Python이 import 시 검색하는 폴더 목록. 위에서 아래로.

기본값.

1. 현재 디렉토리
2. PYTHONPATH 환경변수
3. 표준 라이브러리
4. site-packages (pip 설치)

```python
# 동적 추가
sys.path.append("/path/to/my/modules")
```

자경단 거의 안 만짐. 보통 venv가 자동.

---

## 7. relative vs absolute import

**absolute import** (자경단 표준)

```python
# vigilante/exchange.py
from vigilante.validators import validate_currency
```

**relative import**

```python
# vigilante/exchange.py
from .validators import validate_currency      # 같은 패키지
from ..parent_package import x                 # 상위 패키지
```

자경단 표준 — absolute. 명확하고 도구 친화.

---

## 8. circular import 함정

```python
# a.py
from b import f1

def f2():
    return f1() + 1

# b.py
from a import f2  # 사고!

def f1():
    return f2() + 1
```

처방.

```python
# Lazy import (함수 안)
# a.py
def f2():
    from b import f1
    return f1() + 1
```

또는 구조 재설계. 공통 모듈에 분리.

자경단 매주 한 번 사고.

---

## 9. 한 줄 분해

```python
from collections import Counter, defaultdict
from functools import partial, lru_cache
from pathlib import Path
```

자경단 매일 첫 5줄.

---

## 10. 흔한 오해 다섯 가지

**오해 1: __init__.py 필수.**

3.3+ namespace package 가능. 하지만 자경단 표준 사용.

**오해 2: import * 편함.**

namespace 오염. 절대 안 씀.

**오해 3: relative가 좋다.**

자경단 표준 absolute.

**오해 4: 한 줄 여러 import OK.**

PEP 8 별 줄 권장.

**오해 5: circular import 못 풀어.**

lazy import 또는 재설계.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. import 순서?**

PEP 8: stdlib → 외부 → 본인. ruff isort 자동.

**Q2. __all__ 필수?**

`from x import *` 안 쓰면 옵션.

**Q3. 모듈 reload?**

`importlib.reload(module)`. 자경단 거의 안 씀.

**Q4. 모듈 캐싱?**

sys.modules. 한 번 import 후 재사용.

**Q5. lazy import 언제?**

circular 또는 무거운 모듈.

---

## 12. 흔한 실수 다섯 + 안심 — 핵심 학습 편

첫째, import * 편함. 안심 — namespace 오염, 안 씀.
둘째, relative가 좋다. 안심 — absolute 표준.
셋째, circular import 못 풀어. 안심 — lazy import 또는 재설계.
넷째, __init__.py 어렵다. 안심 — 빈 파일도 OK.
다섯째, 가장 큰 — sys.path 직접 만짐. 안심 — venv가 자동.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 두 번째 시간 끝.

import 5 패턴, from 5, __init__.py, __name__, sys.path, relative/absolute, circular.

다음 H3는 5 도구.

```python
python3 -c "import sys; print(len(sys.path))"
```

---

## 👨‍💻 개발자 노트

> - sys.modules: import cache.
> - importlib.reload: dev에서 코드 변경 적용.
> - __init__.py vs PEP 420: 표준은 __init__.py.
> - PYTHONPATH: 환경변수로 추가.
> - .pyc 캐싱: __pycache__/.
> - 다음 H3 키워드: venv · pip · pyproject · twine · pipx.
