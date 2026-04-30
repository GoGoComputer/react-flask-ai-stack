# Ch013 · H7 — 모듈/패키지 내부 — sys.modules·import 시스템

> 고양이 자경단 · Ch 013 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. import 5단계
3. sys.modules 캐싱
4. PathFinder와 MetaPathFinder
5. ModuleSpec
6. .pyc 캐싱
7. import lazy
8. 흔한 오해 다섯 가지
9. 마무리

---

## 1. 다시 만나서 반가워요

자, 안녕하세요.

지난 H6 회수. 의존성 관리, 보안 측정.

이번 H7은 import 시스템 깊이.

오늘의 약속. **본인이 import 한 줄이 안에서 무엇을 하는지 만집니다**.

자, 가요.

---

## 2. import 5단계

`import requests`가 안에서.

**1. sys.modules 확인**. 이미 import 됐으면 그거 반환.

**2. finder 검색**. sys.meta_path의 finder들. 첫 매치.

**3. loader 호출**. 모듈 spec → 모듈 객체.

**4. 코드 실행**. 모듈 top level 코드 실행.

**5. sys.modules에 저장**. 다음 import 시 1단계에서 cache hit.

5단계. 첫 import는 100ms, 두 번째부터 0.001s.

---

## 3. sys.modules 캐싱

```python
import sys
import requests

print('requests' in sys.modules)   # True
print(sys.modules['requests'])     # 모듈 객체
```

import 한 모든 모듈이 dict.

reload하려면.

```python
import importlib
importlib.reload(requests)
```

자경단 거의 안 함. 셸 다시 켜기.

---

## 4. PathFinder와 MetaPathFinder

`sys.meta_path`가 finder의 list.

```python
import sys
print(sys.meta_path)
# [<class '_frozen_importlib.BuiltinImporter'>,
#  <class '_frozen_importlib.FrozenImporter'>,
#  <class '_frozen_importlib_external.PathFinder'>]
```

세 finder.

**BuiltinImporter** — sys, math 같은 C 내장.
**FrozenImporter** — 부팅용.
**PathFinder** — 일반 .py 파일. sys.path 검색.

PathFinder가 본인 모듈 99%를 찾아요.

```python
import sys
print(sys.path)
# ['', '/path/to/site-packages', ...]
```

자경단 매일 — venv 활성화하면 sys.path가 .venv로.

---

## 5. ModuleSpec

PEP 451의 결과. 모듈의 metadata.

```python
import importlib.util
spec = importlib.util.find_spec('requests')

print(spec.name)        # 'requests'
print(spec.origin)      # 파일 경로
print(spec.submodule_search_locations)
```

자경단 거의 안 만짐. 디버깅 시 가끔.

---

## 6. .pyc 캐싱

본인이 .py를 import하면 Python이 .pyc로 컴파일.

```
mymodule.py
__pycache__/
  mymodule.cpython-312.pyc
```

다음 import 시 .py 변경 없으면 .pyc 직접 로드. 컴파일 시간 절감.

```bash
find . -name "__pycache__" -type d
```

CI 캐시에 __pycache__ 포함하면 빠름.

자경단 매일 자동.

---

## 7. import lazy

큰 모듈을 함수 안에서 import.

```python
def process():
    import heavy_module   # 함수 호출 시만
    heavy_module.do()
```

장점.

1. 시작 시간 빠름.
2. 순환 import 회피.
3. 옵션 의존성.

```python
try:
    import optional_lib
except ImportError:
    optional_lib = None

def use():
    if optional_lib:
        ...
```

자경단 매주 — 무거운 모듈은 lazy.

---

## 8. 흔한 오해 다섯 가지

**오해 1: import 비싸다.**

첫 번만. 이후 cache.

**오해 2: reload 자주.**

거의 안 씀.

**오해 3: __pycache__ 삭제.**

자동 재생성.

**오해 4: lazy import 시니어.**

큰 프로젝트 매일.

**오해 5: sys.path 만짐.**

venv가 자동.

---

## 9. 흔한 실수 다섯 + 안심 — 깊이 학습 편

첫째, import 매번 비쌈. 안심 — sys.modules 캐싱.
둘째, reload 자주. 안심 — 셸 재시작.
셋째, __pycache__ 삭제. 안심 — 자동 재생성.
넷째, sys.path 직접. 안심 — venv 자동.
다섯째, 가장 큰 — lazy import 시니어. 안심 — 무거운 모듈 매주.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 10. 마무리

자, 일곱 번째 시간 끝.

import 5단계, sys.modules, finder, ModuleSpec, .pyc, lazy.

다음 H8은 적용 + 회고.

```python
import sys
print(len(sys.modules))
```

---

## 👨‍💻 개발자 노트

> - PEP 451: ModuleSpec.
> - PEP 328: relative import.
> - PEP 420: namespace package.
> - importlib.util: 동적 import.
> - 다음 H8 키워드: 7H 회고 · vigilante 패키지 · Ch014 다리.
