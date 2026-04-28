# Ch010 · H2 — Python 입문 4: collections 핵심개념 — list·tuple·dict·set 깊이

> **이 H에서 얻을 것**
> - list 10+ 메서드 + 시간 복잡도
> - tuple 3 메서드 + NamedTuple
> - dict 12+ 메서드 + comprehension
> - set 10+ 메서드 + 4 연산
> - comprehension 4종 깊이
> - 자경단 매일 시나리오

---

## 회수: H1의 4 단어에서 본 H의 깊이로

지난 H1에서 본인은 list·tuple·dict·set 4 단어를 학습했어요. 그건 **첫 만남**이었습니다. list는 순서 있는 mutable, tuple은 순서 있는 immutable, dict은 key-value, set은 중복 없는 collection — 이 4가지를 한 페이지로 봤어요.

본 H2는 그 4 단어의 **모든 메서드와 활용 깊이**예요. 4 collections × 평균 10 메서드 = 40+ 메서드 자경단 매일. 단순히 메서드 이름을 외우는 게 아니라 **시간 복잡도**까지 함께 봅니다. 왜냐하면 자경단 코드가 1만 마리 고양이 데이터를 다룰 때 list `in` 검사 O(n) vs set `in` O(1)의 차이가 1초 vs 0.01초로 100배가 되거든요.

까미가 묻습니다. "이 H 어렵지 않아요?" 본인이 답해요. "각 collection 10 메서드씩, 손가락 마디로 외우면 끝. 한 H로 자료구조 100% 정복." 노랭이가 끄덕이고, 미니가 메서드 표를 사진으로 찍고, 깜장이가 시간 복잡도 표를 메모합니다.

본 H의 약속 — 끝나면 자경단이 list·tuple·dict·set 어떤 상황에서든 **올바른 메서드를 시간 복잡도와 함께** 떠올릴 수 있게 됩니다. set 합집합? `|` 한 글자. dict 안전 lookup? `get(k, default)`. list 끝 추가? `append` O(1). tuple 다중 return? 그냥 콤마. 4 collections가 손가락 끝에 붙어요.

---

## 1. list 10+ 메서드

### 1-1. 추가/삭제

```python
cats = ['까미', '노랭이']

# append — O(1)
cats.append('미니')              # ['까미', '노랭이', '미니']

# insert — O(n)
cats.insert(0, '본인')           # ['본인', '까미', '노랭이', '미니']

# extend — O(k)
cats.extend(['깜장이', '루나'])   # ['본인', '까미', '노랭이', '미니', '깜장이', '루나']

# remove — O(n) 첫 일치
cats.remove('까미')              # ['본인', '노랭이', '미니', '깜장이', '루나']

# pop — O(1) 끝·O(n) 중간
last = cats.pop()                # '루나'
first = cats.pop(0)              # '본인'

# clear — O(n)
cats.clear()                     # []
```

자경단 매일 — 6 메서드.

### 1-2. 검색/정렬

```python
cats = ['까미', '노랭이', '미니']

# index — O(n) 첫 일치
cats.index('노랭이')              # 1

# count — O(n)
cats.count('까미')               # 1

# sort — O(n log n) in-place
cats.sort()                      # ['까미', '노랭이', '미니']
cats.sort(reverse=True)
cats.sort(key=len)

# reverse — O(n) in-place
cats.reverse()

# copy — O(n)
new_cats = cats.copy()           # shallow
import copy
deep = copy.deepcopy(cats)       # deep
```

5 메서드 = 자경단 매주.

### 1-3. list 연산

```python
a = [1, 2, 3]
b = [4, 5, 6]

# 연결 (새 list)
a + b                            # [1, 2, 3, 4, 5, 6]

# 반복
a * 3                            # [1, 2, 3, 1, 2, 3, 1, 2, 3]

# 슬라이싱
a[1:]                            # [2, 3]
a[::-1]                          # [3, 2, 1] reverse
a[::2]                           # [1, 3] step

# in (멤버십)
2 in a                           # True
```

자경단 매일 — 슬라이싱·in.

### 1-4. list 11 메서드 한 페이지

| 메서드 | 의미 | 시간 복잡도 |
|--------|------|----------|
| append(x) | 끝 추가 | O(1) |
| insert(i, x) | 위치 추가 | O(n) |
| extend(iter) | 합치기 | O(k) |
| remove(x) | 값 삭제 | O(n) |
| pop([i]) | 인덱스 삭제 | O(1)/O(n) |
| clear() | 모두 삭제 | O(n) |
| index(x) | 위치 검색 | O(n) |
| count(x) | 개수 | O(n) |
| sort() | 정렬 | O(n log n) |
| reverse() | 역순 | O(n) |
| copy() | 복사 | O(n) |

11 메서드 = list 100%.

### 1-5. list 3 함정과 처방

```python
# 함정 1: 반복 중 수정
cats = ['까미', '노랭이', '미니']
for c in cats:
    if c == '까미':
        cats.remove(c)              # 위험! index 흔들림

# 처방: 새 list로
cats = [c for c in cats if c != '까미']

# 함정 2: 가변 default 인자
def add_cat(name, cats=[]):         # 위험!
    cats.append(name)
    return cats

# 처방: None sentinel
def add_cat(name, cats=None):
    if cats is None:
        cats = []
    cats.append(name)
    return cats

# 함정 3: shallow copy
nested = [[1, 2], [3, 4]]
copy1 = nested.copy()
copy1[0].append(99)                 # nested[0]도 변화!

# 처방: deepcopy
import copy
copy2 = copy.deepcopy(nested)
copy2[0].append(99)                 # nested 안전
```

3 함정 = 자경단 면역 매일.

### 1-6. list 실전 패턴 5

```python
# 패턴 1: 평탄화 (flatten)
nested = [[1, 2], [3, 4], [5]]
flat = [x for sub in nested for x in sub]    # [1, 2, 3, 4, 5]

# 패턴 2: 중복 제거 (순서 유지)
seen = set()
unique = [x for x in items if not (x in seen or seen.add(x))]

# 패턴 3: chunk 분할
def chunks(lst, n):
    return [lst[i:i+n] for i in range(0, len(lst), n)]

chunks([1,2,3,4,5,6,7], 3)         # [[1,2,3], [4,5,6], [7]]

# 패턴 4: zip + enumerate
for i, (name, age) in enumerate(zip(names, ages), start=1):
    print(f'{i}. {name} {age}살')

# 패턴 5: 정렬 + key
cats.sort(key=lambda c: (c.priority, -c.age))    # tuple 키 정렬
```

5 패턴 = 자경단 매일.

---

## 2. tuple 3 메서드 + NamedTuple

### 2-1. tuple 메서드 (3개만)

```python
t = (1, 2, 3, 2, 1)

# count — O(n)
t.count(2)                       # 2

# index — O(n)
t.index(3)                       # 2

# len — built-in
len(t)                           # 5
```

immutable — 메서드 적음.

### 2-2. NamedTuple

```python
from typing import NamedTuple

class Cat(NamedTuple):
    name: str
    age: int
    color: str = 'black'

cat = Cat('까미', 2)
cat.name                         # '까미'
cat[0]                           # '까미' (tuple 그대로)

# unpacking
name, age, color = cat

# immutable
# cat.name = '노랭이'             # AttributeError
```

자경단 매일 — type hint + tuple = NamedTuple.

### 2-3. tuple 5 활용

1. 좌표/RGB
2. function 다중 return
3. dict 키
4. NamedTuple
5. 상수 collection

5 활용 = tuple 매일.

### 2-4. NamedTuple vs dataclass vs TypedDict

```python
# NamedTuple — immutable, 가벼움
from typing import NamedTuple
class CatNT(NamedTuple):
    name: str
    age: int

# dataclass — mutable, 풍부 (메서드·default·post_init)
from dataclasses import dataclass, field
@dataclass
class CatDC:
    name: str
    age: int
    tags: list = field(default_factory=list)
    
    def is_adult(self) -> bool:
        return self.age >= 1

# TypedDict — dict + type hint (mypy)
from typing import TypedDict
class CatTD(TypedDict):
    name: str
    age: int

# 사용 비교
nt = CatNT('까미', 2)               # immutable, hashable
dc = CatDC('까미', 2)               # mutable, 메서드 가능
td: CatTD = {'name': '까미', 'age': 2}    # 그냥 dict + type 검사
```

3 종 비교 — 자경단 선택.

### 2-5. tuple unpacking 5 패턴

```python
# 패턴 1: 다중 할당
x, y = 1, 2

# 패턴 2: swap
a, b = b, a

# 패턴 3: function 다중 return
def get_min_max(nums):
    return min(nums), max(nums)
mn, mx = get_min_max([3, 1, 4, 1, 5])

# 패턴 4: * (rest)
first, *rest = [1, 2, 3, 4]         # first=1, rest=[2,3,4]
*head, last = [1, 2, 3, 4]          # head=[1,2,3], last=4

# 패턴 5: nested
((a, b), c) = ((1, 2), 3)           # a=1, b=2, c=3
```

5 unpacking = 자경단 매일.

---

## 3. dict 12+ 메서드

### 3-1. 기본 메서드

```python
d = {'name': '까미', 'age': 2}

# get — KeyError 면역
d.get('name')                    # '까미'
d.get('color', 'black')          # 'black' (default)

# setdefault — 없으면 추가
d.setdefault('color', 'gray')    # 'gray' 추가

# update
d.update({'age': 3, 'tags': []})

# pop — O(1)
d.pop('age')                     # 3
d.pop('missing', None)           # None (default)

# popitem — Python 3.7+ LIFO
d.popitem()                      # ('tags', [])

# clear
d.clear()                        # {}
```

6 메서드 = 자경단 매일.

### 3-2. 검색/iteration

```python
d = {'a': 1, 'b': 2, 'c': 3}

# in (key 검사) — O(1)
'a' in d                         # True

# keys/values/items
list(d.keys())                   # ['a', 'b', 'c']
list(d.values())                 # [1, 2, 3]
list(d.items())                  # [('a', 1), ('b', 2), ('c', 3)]

# iteration (key 기본)
for k in d:
    print(k)

for k, v in d.items():
    print(k, v)
```

자경단 매일 — items() 표준.

### 3-3. dict 합치기 (Python 3.9+)

```python
a = {'x': 1, 'y': 2}
b = {'y': 3, 'z': 4}

# union (Python 3.9+)
c = a | b                        # {'x': 1, 'y': 3, 'z': 4} (b 우선)

# in-place
a |= b                           # a = {'x': 1, 'y': 3, 'z': 4}

# 옛 양식
c = {**a, **b}                   # 같음
c = dict(a, **b)                 # 같음
```

자경단 — Python 3.9+ `|` 표준.

### 3-4. dict comprehension

```python
# 기본
ages = {c.name: c.age for c in cats}

# filter
adults = {k: v for k, v in ages.items() if v >= 1}

# swap
inverted = {v: k for k, v in ages.items()}

# nested
matrix = {(i, j): i * j for i in range(3) for j in range(3)}
```

자경단 매일 30+ dict comp.

### 3-5. dict 12 메서드 한 페이지

| 메서드 | 의미 | 시간 복잡도 |
|--------|------|----------|
| get(k, default) | 안전 lookup | O(1) avg |
| setdefault(k, v) | 없으면 추가 | O(1) avg |
| update(other) | 합치기 | O(k) |
| pop(k, default) | 삭제 | O(1) avg |
| popitem() | LIFO 삭제 | O(1) |
| clear() | 모두 삭제 | O(n) |
| keys() | key view | O(1) |
| values() | value view | O(1) |
| items() | k,v view | O(1) |
| copy() | shallow copy | O(n) |
| fromkeys(iter, v) | factory | O(n) |
| `\|` (union) | 합치기 | O(n+k) |

12 메서드 = dict 100%.

### 3-6. dict 3 함정과 처방

```python
# 함정 1: KeyError
d = {'name': '까미'}
d['age']                            # KeyError!

# 처방: get
d.get('age', 0)                     # 0

# 함정 2: 반복 중 수정
for k in d:
    if d[k] is None:
        del d[k]                    # RuntimeError!

# 처방: list(d) 복사
for k in list(d):
    if d[k] is None:
        del d[k]

# 함정 3: 가변 default
d = {}
d.setdefault('tags', []).append('a')    # 안전, 같은 list 재사용
```

### 3-7. dict 실전 패턴 5

```python
# 패턴 1: count (Counter 대신 한 줄)
counts = {}
for c in cats:
    counts[c.color] = counts.get(c.color, 0) + 1

# 패턴 2: group by
groups = {}
for c in cats:
    groups.setdefault(c.color, []).append(c)

# 패턴 3: invert
inverted = {v: k for k, v in d.items()}

# 패턴 4: merge with priority
config = {**defaults, **user_config}    # user 우선

# 패턴 5: nested get
data.get('user', {}).get('profile', {}).get('name', 'Unknown')
```

5 패턴 = dict 자경단 매일.

---

## 4. set 10+ 메서드 + 4 연산

### 4-1. 기본 메서드

```python
s = {1, 2, 3}

# add — O(1)
s.add(4)                         # {1, 2, 3, 4}

# remove — KeyError if 없음
s.remove(2)                      # {1, 3, 4}

# discard — 안전 삭제 (없어도 OK)
s.discard(99)                    # 변화 X

# pop — 임의 삭제
s.pop()                          # 임의 element

# clear
s.clear()                        # set()

# in — O(1)
3 in {1, 2, 3}                   # True
```

6 메서드 = 자경단 매주.

### 4-2. 4 연산 (집합)

```python
a = {1, 2, 3}
b = {2, 3, 4}

# union — O(n+m)
a | b                            # {1, 2, 3, 4}
a.union(b)

# intersection — O(min(n, m))
a & b                            # {2, 3}
a.intersection(b)

# difference — O(n)
a - b                            # {1}
a.difference(b)

# symmetric difference — O(n+m)
a ^ b                            # {1, 4}
a.symmetric_difference(b)

# subset/superset
{1, 2} <= a                      # True (subset)
a >= {1, 2}                      # True (superset)
```

4 연산 + subset/superset = 자경단 매주.

### 4-3. set 10 메서드 한 페이지

| 메서드 | 의미 | 시간 복잡도 |
|--------|------|----------|
| add(x) | 추가 | O(1) avg |
| remove(x) | 삭제 (KeyError) | O(1) avg |
| discard(x) | 안전 삭제 | O(1) avg |
| pop() | 임의 삭제 | O(1) |
| clear() | 모두 | O(n) |
| union(\|) | 합집합 | O(n+m) |
| intersection(&) | 교집합 | O(min) |
| difference(-) | 차집합 | O(n) |
| symmetric_diff(^) | 대칭차 | O(n+m) |
| issubset(<=) | 부분집합 | O(n) |

10 메서드 = set 100%.

### 4-4. set 실전 패턴 5

```python
# 패턴 1: 중복 제거
unique = list(set(items))           # 순서 잃음

# 패턴 2: 권한 검사
required = {'read', 'write'}
if required <= user_perms:          # subset
    allow()

# 패턴 3: 차집합 (없는 것 찾기)
missing = required - user_perms     # set 차집합

# 패턴 4: tag 합치기
all_tags = set()
for cat in cats:
    all_tags |= set(cat.tags)       # in-place union

# 패턴 5: frozenset (dict 키)
config_key = frozenset({'gpu': True, 'fast': False}.items())
cache[config_key] = result
```

5 패턴 = set 자경단 매주.

### 4-5. set 3 함정과 처방

```python
# 함정 1: list/dict element 불가 (unhashable)
s = {[1, 2]}                        # TypeError!

# 처방: tuple/frozenset
s = {(1, 2)}                        # OK

# 함정 2: 빈 set
s = {}                              # 빈 dict!

# 처방: set()
s = set()

# 함정 3: 순서 가정
s = {3, 1, 2}                       # 출력 순서 보장 X

# 처방: sorted()
sorted(s)                           # [1, 2, 3]
```

3 함정 = 자경단 면역.

---

## 5. comprehension 4종 깊이

### 5-1. list comp

```python
# 단순
[x**2 for x in range(10)]

# filter
[x for x in range(10) if x % 2 == 0]

# nested
[[i*j for j in range(5)] for i in range(5)]

# 함수 호출
[transform(x) for x in items]
```

자경단 매일 100+ list comp.

### 5-2. dict comp

```python
# 기본
{c.name: c.age for c in cats}

# filter
{k: v for k, v in d.items() if v > 0}

# transform
{k: v * 2 for k, v in d.items()}

# swap
{v: k for k, v in d.items()}
```

자경단 매일 30+.

### 5-3. set comp

```python
# 중복 제거
{x % 10 for x in numbers}

# unique attribute
{c.color for c in cats}
```

자경단 매주 5+.

### 5-4. generator expression

```python
# 메모리 절약
sum(c.age for c in cats)         # 1억 데이터 OK

# 함수 인자 (괄호 생략)
total = sum(x**2 for x in range(1_000_000))
```

자경단 매일 — 큰 데이터.

### 5-5. 4 종 비교

| 양식 | 결과 type | 메모리 | 사용 |
|------|---------|------|------|
| `[x for x in items]` | list | O(n) | 매일 100+ |
| `{k: v for k, v in items}` | dict | O(n) | 매일 30+ |
| `{x for x in items}` | set | O(n) | 매주 5+ |
| `(x for x in items)` | generator | O(1) | 큰 데이터 |

4 종 = comprehension 100%.

### 5-6. comprehension 가독성 한계

```python
# OK — 1 중첩
[x**2 for x in range(10)]

# OK — 2 중첩 (한 줄 줄이기)
[x*y for x in range(5) for y in range(5)]

# 위험 — 3 중첩 (가독성 ↓)
[[[i*j*k for k in range(3)] for j in range(3)] for i in range(3)]

# 처방: 일반 for 분리
result = []
for i in range(3):
    plane = []
    for j in range(3):
        row = [i*j*k for k in range(3)]
        plane.append(row)
    result.append(plane)
```

자경단 규칙 — 2 중첩까지·이상은 for 분리.

### 5-7. comp vs map/filter

```python
# 자경단 표준: comprehension
squared = [x**2 for x in nums if x > 0]

# 옛 양식 (가독성 ↓)
squared = list(map(lambda x: x**2, filter(lambda x: x > 0, nums)))
```

자경단 — comp 100%, map/filter 0%.

---

## 5-bonus. comprehension 5 실전 패턴

```python
# 패턴 1: dict로 row 변환
rows = [(1, '까미'), (2, '노랭이'), (3, '미니')]
by_id = {id: name for id, name in rows}    # {1: '까미', ...}

# 패턴 2: 조건부 transform
result = [x * 2 if x > 0 else 0 for x in items]

# 패턴 3: enumerate + comp
indexed = {i: x for i, x in enumerate(items)}

# 패턴 4: zip + comp
pairs = {k: v for k, v in zip(keys, values)}

# 패턴 5: filter + transform
active_names = [c.name.upper() for c in cats if c.active]
```

5 실전 = 자경단 매일 comp.

### 5-bonus2. generator vs list comp 메모리

```python
import sys

# list comp — 모든 element 메모리
lst = [x**2 for x in range(1_000_000)]
sys.getsizeof(lst)                  # ~8.5MB

# generator — 1 element씩 lazy
gen = (x**2 for x in range(1_000_000))
sys.getsizeof(gen)                  # ~200 bytes

# 1억 데이터?
total = sum(x**2 for x in range(100_000_000))    # generator OK!
total = sum([x**2 for x in range(100_000_000)])  # MemoryError!
```

자경단 규칙 — 1만 이하 list, 1만+ generator.

---

## 6. 자경단 매일 시나리오

### 6-1. 본인 — FastAPI

```python
@app.get('/cats')
async def list_cats() -> list[dict]:
    rows = await db.fetch_all(...)
    return [dict(r) for r in rows]    # list comp
```

### 6-2. 까미 — DB

```python
async def get_active_count() -> dict:
    cats = await fetch_cats()
    return {
        'active': sum(1 for c in cats if c.active),
        'total': len(cats),
        'unique_ages': set(c.age for c in cats),
    }
```

### 6-3. 노랭이 — 도구

```python
def transform(items: list[dict]) -> dict:
    return {item['id']: item for item in items}    # dict comp
```

### 6-4. 미니 — 인프라

```python
required = {'read', 'write'}
user_perms = set(user.permissions)

if required <= user_perms:    # subset 검사
    allow()
```

### 6-5. 깜장이 — 테스트

```python
@pytest.mark.parametrize("cats,expected", [
    (['까미'], 1),
    (['까미', '노랭이'], 2),
])
def test_count(cats, expected):
    assert len(cats) == expected
```

5 시나리오 × 매일 = collections 100% 활용.

### 6-6. 자경단 1주 collections 통계 (예시)

| 자경단 | list | tuple | dict | set | comp |
|------|----|-----|----|---|----|
| 본인 (FastAPI) | 200 | 50 | 300 | 30 | 100 |
| 까미 (DB) | 100 | 80 | 400 | 50 | 80 |
| 노랭이 (도구) | 150 | 30 | 200 | 20 | 60 |
| 미니 (인프라) | 50 | 100 | 100 | 80 | 30 |
| 깜장이 (테스트) | 80 | 200 | 150 | 40 | 50 |

총 1주 — list 580·tuple 460·dict 1150·set 220·comp 320.

dict이 1위 — 자경단의 진짜 데이터 형식. 4 collections 모두 100+ 매주 사용.

---

## 6-7. 자경단 collections 선택 결정 트리

```
질문 1: 순서 필요?
  - YES → list/tuple
  - NO → dict/set
질문 2: 변경 필요? (list/tuple 분기)
  - YES → list
  - NO → tuple (또는 NamedTuple)
질문 3: key-value? (dict/set 분기)
  - YES → dict
  - NO → set
질문 4: 중복 허용?
  - YES → list
  - NO → set
질문 5: 빠른 lookup 필요? (1만+)
  - YES → dict/set (O(1))
  - NO → list OK (O(n))
```

5 질문 결정 트리 = 자경단 자료구조 선택 100%.

### 6-8. 자경단 안티패턴 5

```python
# 안티 1: list로 lookup 1만 회
if x in big_list:                   # O(n) × 1만 = O(n²)
    ...

# 패턴: set
big_set = set(big_list)
if x in big_set:                    # O(1)
    ...

# 안티 2: list += [x]
nums = []
for x in items:
    nums += [x]                     # 매번 새 list

# 패턴: append
for x in items:
    nums.append(x)                  # in-place O(1)

# 안티 3: dict.keys()를 list로
keys = list(d.keys())
for k in keys: ...                  # 메모리 낭비

# 패턴: 직접 iter
for k in d: ...                     # view 그대로

# 안티 4: 중첩 list comp 3+
[[[i*j*k for k in r] for j in r] for i in r]

# 패턴: for 분리

# 안티 5: tuple로 mutable 흉내
t = ([], [])
t[0].append(1)                      # tuple 자체는 immutable, 안의 list는 mutable
                                    # 의도 불명확

# 패턴: list of list 또는 dataclass
```

5 안티패턴 = 자경단 면역.

---

## 7. 흔한 오해 5가지

**오해 1: "list 항상 좋다."** — set이 lookup 100배·dict이 key-value.

**오해 2: "tuple 작은 것만."** — function 다중 return 매일.

**오해 3: "dict 순서 모름."** — Python 3.7+ 보장.

**오해 4: "set 정렬."** — 보장 X. sorted() 명시.

**오해 5: "comp 시니어."** — 1주차 학습. 매일 100+.

**오해 6: "set 빠르니 항상 set."** — set은 unhashable element 불가·순서 잃음. list가 순서 필요할 때 정답.

**오해 7: "dict.keys() list로 변환 필요."** — `for k in d:` 충분. list 변환은 메모리 낭비.

**오해 8: "tuple 메서드 적어 약함."** — immutable이 강점. 함수 다중 return·dict 키·NamedTuple 매일.

**오해 9: "comp가 항상 for보다 빠름."** — 보통 그렇지만, side effect 있는 함수 호출은 일반 for가 더 명확.

**오해 10: "list * 3 = 깊은 복사."** — `[[0]*3]*3` 함정! 같은 inner list 3개 참조. `[[0]*3 for _ in range(3)]` 안전.

---

## 8. FAQ 5가지

**Q1. list pop(0) vs deque popleft?**
A. list pop(0) O(n)·deque popleft O(1). 큐는 deque.

**Q2. dict get vs []?**
A. get() 안전·[] KeyError. 자경단 표준 get.

**Q3. set vs frozenset?**
A. set mutable·frozenset immutable + hashable.

**Q4. NamedTuple vs dataclass?**
A. NamedTuple immutable·가벼움·dataclass mutable·강력.

**Q5. comp 가독성 한계?**
A. 2 중첩까지. 3+은 for 분리.

**Q6. dict 정렬?**
A. `sorted(d.items(), key=lambda x: x[1])`. 결과는 list of tuple — dict로 다시 변환 가능 (Python 3.7+ 순서 보장).

**Q7. list extend vs +?**
A. `extend(iter)` in-place O(k). `a + b` 새 list 생성 O(n+k). 매일 extend 우선, 새 list 필요 시만 +.

**Q8. set element 추가 시 중복?**
A. set은 hash로 중복 검사. 같은 hash·같은 값이면 무시. 자경단 안전 dedup.

**Q9. dict 100만 항목 메모리?**
A. dict overhead ~232 bytes + element. 100만 항목 ~80MB. 메모리 걱정 시 namedtuple list 또는 dataclass + slots.

**Q10. comp에서 if-else?**
A. `[x if x > 0 else 0 for x in items]` (값 변환 if-else 앞쪽). filter `if`는 뒤쪽. 순서 다름 주의.

---

## 8-bonus. 자경단 collections 시간 복잡도 마스터 표

| 작업 | list | tuple | dict | set |
|------|------|-------|------|-----|
| 끝 추가 | O(1) | — (immutable) | O(1) | O(1) |
| 중간 추가 | O(n) | — | — | — |
| 끝 삭제 | O(1) | — | O(1) | O(1) |
| 중간 삭제 | O(n) | — | O(1) | O(1) |
| `in` 검사 | O(n) | O(n) | O(1) | O(1) |
| index 접근 | O(1) | O(1) | — | — |
| 길이 (len) | O(1) | O(1) | O(1) | O(1) |
| 정렬 | O(n log n) | sorted() | sorted() | sorted() |
| copy | O(n) | O(1) ref | O(n) | O(n) |
| 합치기 | + O(n+k) | + O(n+k) | \| O(n+k) | \| O(n+k) |

핵심 — `in` 검사 list O(n) vs dict/set O(1). 1만 데이터 100배 차이. 자경단 매일 떠올림.

### 8-bonus2. 자경단 메모리 비교 (10000 element)

| 자료구조 | 메모리 (대략) |
|---------|------------|
| list[int] | ~85KB |
| tuple[int] | ~80KB (slightly less) |
| dict[int, int] | ~290KB |
| set[int] | ~290KB |

dict/set이 list 3배 — hash 테이블 overhead. 메모리 vs 속도 tradeoff. 자경단 1만+ lookup 빈번하면 dict/set, 메모리 빠듯하면 list + sorted + bisect.

---

## 9. 추신

추신 1. list 11 메서드 (append·insert·extend·remove·pop·clear·index·count·sort·reverse·copy).

추신 2. list append O(1)·insert O(n)·remove O(n)·sort O(n log n).

추신 3. tuple 3 메서드 (count·index·len). immutable이라 적음.

추신 4. NamedTuple = tuple + type hint + 가독성.

추신 5. tuple 5 활용 (좌표·function return·dict 키·NamedTuple·상수).

추신 6. dict 12 메서드 (get·setdefault·update·pop·popitem·clear·keys·values·items·copy·fromkeys·|).

추신 7. dict get/setdefault — KeyError 면역.

추신 8. dict | (Python 3.9+) — union 한 줄.

추신 9. dict comprehension 매일 30+.

추신 10. set 10 메서드 (add·remove·discard·pop·clear·union·intersection·difference·symmetric_diff·issubset).

추신 11. set 4 연산 (|·&·-·^).

추신 12. set <= subset·>= superset 매주.

추신 13. comprehension 4종 (list·dict·set·gen) 비교 표.

추신 14. generator expression — 큰 데이터 메모리 O(1).

추신 15. 자경단 5 시나리오 (FastAPI list·DB dict·도구 transform·인프라 set·테스트 parametrize).

추신 16. 흔한 오해 5 면역 (list 항상·tuple 작은 것·dict 순서·set 정렬·comp 시니어).

추신 17. FAQ 5 (pop(0) vs popleft·get vs []·frozenset·NamedTuple vs dataclass·comp 한계).

추신 18. 4 collections × 평균 9 메서드 = 36 메서드 자경단 매일.

추신 19. **본 H 끝** ✅ — Ch010 H2 collections 깊이 학습 완료. 다음 H3! 🐾🐾🐾

추신 20. 본 H 학습 후 본인의 첫 5 행동 — 1) list 11 메서드 5분 손가락, 2) dict get/setdefault, 3) set 4 연산, 4) NamedTuple 첫 작성, 5) 자경단 wiki 한 줄.

추신 21. 본 H의 진짜 결론 — 4 collections × 36 메서드 = 자경단 매일 데이터 100% 활용.

추신 22. **본 H 진짜 끝** ✅✅ — Ch010 H2 학습 완료. 자경단 매일 36 메서드! 🐾🐾🐾🐾🐾

추신 23. list 3 함정 (반복 중 수정·가변 default·shallow copy) — 자경단 면역.

추신 24. list 5 패턴 (flatten·중복 제거·chunk·zip+enumerate·key 정렬) — 자경단 매일.

추신 25. tuple unpacking 5 패턴 (다중 할당·swap·return·*rest·nested) — 자경단 매일.

추신 26. NamedTuple vs dataclass vs TypedDict — immutable·풍부·dict+type 3 종 선택.

추신 27. dict 3 함정 (KeyError·반복 중 수정·가변 default) — 자경단 면역.

추신 28. dict 5 패턴 (count·group by·invert·merge·nested get) — 자경단 매일.

추신 29. set 5 패턴 (중복 제거·권한 검사·차집합·tag union·frozenset 키) — 자경단 매주.

추신 30. set 3 함정 (unhashable·{} 빈 dict·순서 가정) — 자경단 면역.

추신 31. comp 가독성 — 2 중첩까지·3+은 for 분리. map/filter는 0%, comp 100%.

추신 32. 자경단 1주 collections 통계 — dict 1150·list 580·tuple 460·comp 320·set 220.

추신 33. dict이 자경단 1위 (1150/주) — 진짜 데이터 형식.

추신 34. 흔한 오해 10 면역 (set 항상·keys() 변환·tuple 약함·comp 빠름·list*3 함정 등).

추신 35. FAQ 10 (pop(0)·get·frozenset·NamedTuple·comp 한계·dict 정렬·extend·set 중복·dict 메모리·if-else).

추신 36. **list 11 + tuple 3 + dict 12 + set 10 = 36 메서드** + comp 4종 = collections 100%.

추신 37. 시간 복잡도 — list `in` O(n) vs set `in` O(1) = 100배 차이. 1만 데이터 자경단 알아야 함.

추신 38. dict get/setdefault — KeyError 면역의 자경단 표준. 신입 코드에 꼭 가르칠 것.

추신 39. comprehension은 1주차 학습 — 시니어 도구 아님. 매일 100+ 작성.

추신 40. **본 H 학습 후** 자경단의 새로운 능력 — 4 collections 어떤 상황에서도 올바른 메서드 + 시간 복잡도 함께 떠올림.

추신 41. 다음 H3는 환경점검 — `rich.print` (예쁜 출력)·`json` (직렬화)·`pprint` (예쁜 dict)·`collections.abc` (ABC 검사) 4 도구.

추신 42. **본 H 정말 진짜 끝** ✅✅✅ — Ch010 H2 collections 깊이 36 메서드 학습 완료! 다음 H3 환경점검! 🐾🐾🐾🐾🐾🐾

추신 43. 자경단 결정 트리 5 질문 (순서·변경·key-value·중복·lookup) — 자료구조 선택 100%.

추신 44. 자경단 5 안티패턴 (list lookup·list +=·keys() list·중첩 comp·tuple mutable 흉내) — 면역.

추신 45. 시간 복잡도 마스터 표 — list `in` O(n) vs dict/set O(1) = 100배. 1만 데이터 자경단 매일.

추신 46. 메모리 비교 — list 85KB vs dict/set 290KB (10000 int). 3배 차이. 메모리 빠듯하면 list + bisect.

추신 47. comprehension vs generator 메모리 — list 8.5MB vs gen 200 bytes. 1만 이상 generator.

추신 48. comp 5 실전 패턴 (dict row 변환·조건부 transform·enumerate·zip·filter+transform) — 자경단 매일.

추신 49. 자경단 collections 학습 곡선 — H1 4 단어 (만남) → H2 36 메서드 (깊이) → H3 4 환경 도구 (rich/json/pprint/abc) → H4 30+ 패턴 (운영) → H5 exchange 데모 → H6 선택 5 패턴 → H7 hash·resizing 원리 → H8 회고.

추신 50. **본 H 진짜 진짜 끝** ✅✅✅✅ — Ch010 H2 collections 깊이 36 메서드 + 시간 복잡도 + 메모리 + 결정 트리 + 5 안티패턴 모두 학습! 다음 H3 환경점검! 자경단의 데이터가 빨라집니다! 🐾🐾🐾🐾🐾🐾🐾

추신 51. 본 H의 진짜 가치 — 자경단 신입에게 "이 4 collections 36 메서드만 손가락에 붙이면 Python 자료구조 끝" 한 마디로 정리됨. 이제 본인은 list/tuple/dict/set 어떤 상황도 두렵지 않음.

추신 52. dict 1순위 — 자경단 1주 1150 사용 (1위). 본인이 가장 많이 쓰는 자료구조. get/setdefault/items/comp 4개만 매일 100% 활용.

추신 53. set의 진짜 강점 — 1만 데이터 lookup이 list 100배 빠름. 권한 검사·중복 제거·차집합 매주 10+ 회.

추신 54. tuple의 진짜 강점 — function 다중 return + dict 키 + NamedTuple. 매일 50+ 사용 (자주 안 보이지만 항상 거기 있음).

추신 55. list의 진짜 강점 — 순서 + 매일 200+ 사용 (FastAPI response). 11 메서드 모두 자경단 매일.

추신 56. comprehension의 진짜 강점 — 한 줄 가독성 + map/filter 대체. 자경단 매일 100+ 작성, 시니어 도구 아님.

추신 57. 본 H 학습 후 본인이 자경단 단톡에 올릴 한 줄 — "list/tuple/dict/set 36 메서드 + comp 4종 + 시간 복잡도 + 결정 트리 모두 손가락에 붙음. 데이터 자료구조 100% 자신감."

추신 58. **Ch010 H2 정말 진짜 진짜 끝** ✅✅✅✅✅ — 다음은 H3 환경점검 (rich.print·json·pprint·collections.abc 4 도구)! 🐾🐾🐾🐾🐾🐾🐾🐾
