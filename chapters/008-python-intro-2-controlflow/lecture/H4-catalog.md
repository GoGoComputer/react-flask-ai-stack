# Ch008 · H4 — Python 입문 2: 명령어카탈로그 — 18 제어 도구 + 신호등

> **이 H에서 얻을 것**
> - 18 제어 도구 한 표 + 신호등 (🟢🟡🔴)
> - 6 무리 (반복·집계·필터·정렬·생성·고급)
> - 매일 6 손가락 + 주간 5 + 월간 3 = 14 손가락
> - itertools 5 + functools 3 + collections 5 표준 라이브러리
> - 자경단 매일 13줄 흐름 + 5명 사용표
> - 5 함정 + 처방

---

## 회수: H3의 디버깅에서 본 H의 도구로

지난 H3에서 본인은 5 디버깅 도구로 if·for·while 코드의 버그를 찾는 의식을 익혔어요. 그건 **품질**.

본 H4는 그 코드의 **재료**예요. range·enumerate·zip·map·filter·sorted·reversed·any·all·sum·min·max·next·iter·itertools·functools·collections 18 도구가 자경단 매일 손가락.

지난 Ch005 H4은 git 30 명령, Ch006 H4는 셸 30 명령, Ch007 H4는 Python 18 도구. 본 H는 제어 흐름 18 도구. 자경단 매일 4 stack의 카탈로그.

---

## 1. 18 제어 도구 한 표 + 신호등

### 1-1. 신호등 정의

- 🟢 — 안전 (read-only, 부작용 없음)
- 🟡 — 주의 (큰 데이터·메모리 사용)
- 🔴 — 위험 (무한·예외·메모리 폭발)

옵션·상황이 신호등을 바꿈. range(10) 🟢 vs range(10**10) 🔴.

### 1-2. 18 도구 6 무리 한 표

| 도구 | 무리 | 신호등 | 자경단 매일 |
|------|------|------|------------|
| range | 반복 | 🟢 | 매일 |
| enumerate | 반복 | 🟢 | 매일 |
| zip | 반복 | 🟢 | 매일 |
| reversed | 반복 | 🟢 | 매주 |
| sorted | 정렬 | 🟡 | 매일 |
| sum | 집계 | 🟢 | 매일 |
| min/max | 집계 | 🟢 | 매일 |
| any/all | 집계 | 🟢 | 매일 |
| len | 집계 | 🟢 | 매일 |
| filter | 필터 | 🟢 | 매주 |
| map | 변환 | 🟢 | 매주 |
| comprehension | 생성 | 🟢 | 매일 |
| iter | 생성 | 🟢 | 1년 차 |
| next | 생성 | 🟡 | 1년 차 |
| itertools | 고급 | 🟢 | 매주 |
| functools | 고급 | 🟢 | 매주 |
| collections | 고급 | 🟢 | 매일 |
| operator | 고급 | 🟢 | 매주 |

18 도구 × 신호등 = 자경단 매일 카탈로그.

---

## 2. 반복 4 도구 깊이

### 2-1. range — lazy iterator

```python
# 한 인자 — stop
for i in range(10):
    print(i)                # 0, 1, ..., 9

# 두 인자 — start, stop
for i in range(1, 11):
    print(i)                # 1, 2, ..., 10

# 세 인자 — start, stop, step
for i in range(0, 100, 5):
    print(i)                # 0, 5, 10, ..., 95

# 음수 step — 역순
for i in range(10, 0, -1):
    print(i)                # 10, 9, ..., 1

# range는 lazy — 1억까지 메모리 4MB
big = range(10**8)          # 즉시 — 메모리 X
for i in big:               # 필요할 때 만들기
    if i > 5: break
```

range = Python의 가독성. for의 표준 짝.

range vs xrange — Python 2에 xrange (lazy), range (eager). Python 3는 range가 lazy. 자경단 — Python 3 표준. xrange 시대 끝.

자경단 매일 — `for i in range(N)` 100+ 줄. 가장 흔한 for 양식.

### 2-2. enumerate — 인덱스 + 값

```python
# 기본
for i, cat in enumerate(['까미', '노랭이']):
    print(f"{i}: {cat}")    # 0: 까미

# start=1 — 사람 출력
for i, cat in enumerate(cats, start=1):
    print(f"{i}번 — {cat}")

# 자경단 표준 — for + range(len()) 비권장
# 비권장
for i in range(len(cats)):
    cat = cats[i]
    print(i, cat)

# 권장 (자경단 표준)
for i, cat in enumerate(cats):
    print(i, cat)
```

자경단 매일 — `for + range(len())` 자제. enumerate가 표준.

enumerate 5 활용:
- 줄 번호 출력 (`enumerate(lines, start=1)`)
- 인덱스 + 값 동시 사용
- 디버깅 (어느 항목 실패했나)
- 진행률 (`f"{i}/{total}"`)
- 짝수/홀수 분리 (`i % 2 == 0`)

5 활용 = 자경단 매일.

### 2-3. zip — 여러 iterable 동시

```python
# 기본
for cat, age in zip(['까미', '노랭이'], [2, 3]):
    print(f"{cat}: {age}")

# 3개 동시
for name, age, color in zip(names, ages, colors):
    process(name, age, color)

# strict=True (Python 3.10+) — 길이 다르면 ValueError
for a, b in zip(list_a, list_b, strict=True):
    process(a, b)

# zip 짝짝이 처방 — itertools.zip_longest
from itertools import zip_longest
for a, b in zip_longest(list_a, list_b, fillvalue=None):
    process(a, b)
```

자경단 매일 — 병렬 반복의 표준.

zip 5 활용:
- 두 list 짝짓기 (cats + ages)
- dict 만들기 (`dict(zip(keys, values))`)
- 병렬 비교 (`all(a == b for a, b in zip(list_a, list_b))`)
- transpose (`list(zip(*matrix))` 행렬 전치)
- N개 동시 (`for a, b, c in zip(la, lb, lc):`)

5 활용 = 자경단 매주.

### 2-4. reversed — 역순

```python
# list 역순
for cat in reversed(cats):
    print(cat)

# 함수의 lazy — 메모리 절약
big_list = list(range(10**6))
for x in reversed(big_list):    # 새 list 안 만듦
    if x < 100: break

# 비권장 — slice
for cat in cats[::-1]:          # 새 list 만듦
    print(cat)

# 권장
for cat in reversed(cats):
    print(cat)
```

자경단 매주 — log 역순·undo 스택.

reversed의 5 활용:
- 최근 commit 역순 표시
- 큰 list 끝에서 검색
- 카드 뒤집기·전기 폴백
- log 마지막 N줄
- DOM tree 깊이 우선 후위순회

---

## 3. 집계 5 도구 깊이

### 3-1. sum

```python
# 기본
sum([1, 2, 3])              # 6

# generator 표현식 — 메모리 절약
total = sum(c['age'] for c in cats)

# start 인자
sum([1, 2, 3], 10)          # 16

# str sum (느림 — join 사용)
# 비권장
total = sum(['a', 'b', 'c'], '')
# 권장
total = ''.join(['a', 'b', 'c'])
```

자경단 매일 — 합계의 표준.

sum의 5 활용:
- 환율 합 (`sum(c['budget'] for c in cats)`)
- 줄 수 (`sum(1 for line in lines if cond)`)
- 중첩 합 (`sum(len(group) for group in groups)`)
- 비율 (`sum(c['active'] for c in cats) / len(cats)`)
- generator 합 (메모리 절약)

### 3-2. min/max

```python
# 기본
min([3, 1, 5])              # 1
max([3, 1, 5])              # 5

# key 인자 — 기준 함수
youngest = min(cats, key=lambda c: c['age'])
oldest = max(cats, key=lambda c: c['age'])

# operator.itemgetter (성능)
from operator import itemgetter
youngest = min(cats, key=itemgetter('age'))

# default — 빈 iterable
min([], default=0)          # 0
max([], default=None)       # None
```

자경단 매일 — 극값 검색.

### 3-3. any/all — boolean 집계

```python
# any — 하나라도 True
any([False, True, False])   # True
any(c['age'] > 5 for c in cats)  # 5살+ 있나?

# all — 모두 True
all([True, True, True])     # True
all(c['active'] for c in cats)  # 모두 활성?

# 단축 평가 — any는 첫 True에서 멈춤·all은 첫 False에서 멈춤
all(check(x) for x in big_list)  # False 만나면 즉시 종료
```

자경단 매일 — 조건 검사 표준.

### 3-4. len — 길이

```python
len([1, 2, 3])              # 3
len({'a': 1})               # 1
len('고양이')               # 3 (문자 수)
len('cat')                  # 3 (문자 수)

# generator len X — TypeError
gen = (x for x in range(10))
len(gen)                    # TypeError
sum(1 for _ in gen)         # 처방
```

자경단 매일 — 컬렉션 크기.

### 3-5. 5 집계 한 페이지

| 도구 | 의미 | 자경단 매일 |
|------|------|------------|
| sum | 합 | 100+ 줄 |
| min/max | 극값 | 50+ 줄 |
| any/all | 조건 | 50+ 줄 |
| len | 크기 | 200+ 줄 |

5 도구 × 자경단 매일 = 집계 100%.

---

## 4. 필터·변환·정렬 4 도구

### 4-1. filter — 조건 통과만

```python
# 기본
adults = filter(lambda c: c['age'] >= 1, cats)
list(adults)                # [{'name': '까미', 'age': 2}, ...]

# None — falsy 제거
clean = filter(None, [0, 1, '', 'a', None, 'b'])
list(clean)                 # [1, 'a', 'b']

# 자경단 표준 — comp이 더 가독성
adults = [c for c in cats if c['age'] >= 1]
```

자경단 — comp 표준. filter는 함수 인자 명확할 때만.

### 4-2. map — 변환

```python
# 기본
ages = map(lambda c: c['age'], cats)
list(ages)                  # [2, 3, 1, 4, 5]

# 여러 iterable 동시
sums = map(lambda a, b: a + b, [1, 2, 3], [10, 20, 30])
list(sums)                  # [11, 22, 33]

# 자경단 표준 — comp
ages = [c['age'] for c in cats]
```

자경단 — comp 표준. map은 기존 함수 사용 시.

### 4-3. sorted — 정렬

```python
# 기본
sorted([3, 1, 5])           # [1, 3, 5]

# reverse
sorted([3, 1, 5], reverse=True)  # [5, 3, 1]

# key
by_age = sorted(cats, key=lambda c: c['age'])
by_name = sorted(cats, key=itemgetter('name'))

# 안정 정렬 (stable) — 같은 key 시 원래 순서 유지
sorted(cats, key=lambda c: c['age'])  # 같은 나이끼리 입력 순서

# in-place vs 새 list
nums.sort()                 # in-place (list만)
new = sorted(nums)          # 새 list (모든 iterable)
```

자경단 매일 — 표시·집계 표준.

sorted의 5 활용:
- 이름순 표시 (`sorted(cats, key=itemgetter('name'))`)
- 나이순 (`sorted(cats, key=itemgetter('age'))`)
- 다중 key (`sorted(cats, key=lambda c: (c['age'], c['name']))`)
- 역순 (`sorted(items, reverse=True)`)
- 안정 정렬 (같은 key 입력 순서 유지)

자경단 1년 차 — 시니어가 lambda 대신 `operator.itemgetter` 사용.

### 4-4. reversed vs sorted(reverse=True)

```python
# reversed — 단순 역순
list(reversed([3, 1, 5]))   # [5, 1, 3]

# sorted(reverse=True) — 정렬 후 역순
sorted([3, 1, 5], reverse=True)  # [5, 3, 1]

# 둘 다른 일! 자경단 매일 의식.
```

함정 면역 = 자경단 1년 자산.

---

## 5. comprehension·iter·next 3 도구

### 5-1. comprehension 4종 (재회수)

```python
[x**2 for x in range(10)]               # list
{k: v for k, v in items}                # dict
{x % 10 for x in numbers}               # set
(x**2 for x in range(10**6))            # generator
```

자경단 매일 100+ comp.

comp 5 일반 패턴:
- transform — `[f(x) for x in items]`
- filter — `[x for x in items if cond]`
- 둘 동시 — `[f(x) for x in items if cond]`
- nested — `[[..] for ..]`
- if-else — `[x if cond else y for x in items]`

5 패턴 = 자경단 comp 100%.

### 5-2. iter — iterator 만들기

```python
# 기본 — iterable → iterator
items = [1, 2, 3]
it = iter(items)            # list_iterator
next(it)                    # 1

# callable + sentinel — 종료값까지 호출
import io
buffer = io.StringIO("a\nb\nc\nq\n")
for line in iter(buffer.readline, 'q\n'):
    print(line.strip())     # a, b, c

# 자경단 시나리오 — 사용자 입력 q까지
for input_str in iter(input, 'q'):
    process(input_str)
```

자경단 1년 차 — iter callable 매직.

### 5-3. next — 다음 값

```python
# 기본
it = iter([1, 2, 3])
next(it)                    # 1
next(it)                    # 2

# default — StopIteration 대신
next(it, None)              # None (다 소진 후)

# generator 첫 값만 추출
gen = (c for c in cats if c['name'] == '까미')
first_kkami = next(gen, None)  # 첫 매치 or None
```

자경단 1년 차 — 단일 매치 추출.

next의 5 활용:
- 첫 매치 찾기 (filter generator + next)
- 헤더 줄 추출 (`next(reader)`)
- 다음 chunk (`while chunk := next(stream, None):`)
- generator 진행 (`next(gen)`)
- iterator 시뮬 (`it = iter(items); first = next(it)`)

---

## 6. itertools 5 + functools 3 + collections 5

### 6-1. itertools 5 도구

```python
import itertools as it

# 1. chain — 여러 iterable 합치기
list(it.chain([1, 2], [3, 4]))      # [1, 2, 3, 4]

# 2. groupby — 같은 key 묶기
data = [('a', 1), ('a', 2), ('b', 3)]
for k, group in it.groupby(data, key=lambda x: x[0]):
    print(k, list(group))

# 3. product — 데카르트 곱
list(it.product('AB', '12'))        # [('A','1'), ('A','2'), ('B','1'), ('B','2')]

# 4. combinations — 조합
list(it.combinations('ABC', 2))     # [('A','B'), ('A','C'), ('B','C')]

# 5. count — 무한 시퀀스
counter = it.count(start=1, step=2) # 1, 3, 5, 7, ...
```

자경단 매주 — 5 도구.

itertools 추가 5 (1년 차):
- `tee` — iterator 복제
- `cycle` — 무한 순환
- `takewhile`/`dropwhile` — 조건 잘라내기
- `accumulate` — 누적 합/최대 (Python 3.8+ initial 인자)
- `pairwise` (Python 3.10+) — 인접 쌍

10 도구 = itertools 100% 자경단.

### 6-2. functools 3 도구

```python
import functools as ft

# 1. cache — 메모이제이션
@ft.cache
def fibonacci(n):
    if n < 2: return n
    return fibonacci(n-1) + fibonacci(n-2)

# 2. reduce — 누적
ft.reduce(lambda a, b: a + b, [1, 2, 3, 4])  # 10

# 3. partial — 일부 인자 고정
add = lambda a, b: a + b
add_5 = ft.partial(add, 5)
add_5(10)                   # 15
```

자경단 매주 — 3 도구.

functools 추가 3 (1년 차):
- `lru_cache(maxsize=128)` — 제한 cache
- `wraps` — decorator의 metadata 보존
- `singledispatch` — 함수 overload (type별)

6 도구 = functools 100% 자경단.

### 6-3. collections 5 도구

```python
import collections as col

# 1. Counter — 빈도
col.Counter(['a', 'b', 'a', 'c', 'a'])  # Counter({'a': 3, 'b': 1, 'c': 1})

# 2. defaultdict — 기본값
d = col.defaultdict(list)
d['cats'].append('까미')   # KeyError 없음

# 3. OrderedDict (Python 3.7+ dict와 같음)

# 4. deque — 양쪽 큐
q = col.deque([1, 2, 3])
q.appendleft(0)             # deque([0, 1, 2, 3])
q.popleft()                 # 0

# 5. namedtuple — 가벼운 클래스
Cat = col.namedtuple('Cat', 'name age')
c = Cat('까미', 2)
c.name                      # '까미'
```

자경단 매일 — 5 도구.

collections 추가 3 (1년 차):
- `ChainMap` — 여러 dict 한 view (config 우선순위)
- `UserDict`/`UserList`/`UserString` — 상속 가능 (dict 직접 상속의 안전 대안)

8 도구 = collections 100% 자경단.

---

## 7. 매일 6 손가락 + 주간 5 + 월간 3 = 14 손가락

### 7-1. 매일 6 손가락

| 도구 | 매일 사용 |
|------|---------|
| `for + enumerate` | 100+ 줄 |
| `[x for x in items]` | 100+ 줄 |
| `sum/len/min/max` | 200+ 줄 |
| `sorted(items, key=...)` | 50+ 줄 |
| `if x in collection:` | 200+ 줄 |
| `dict.items()` | 100+ 줄 |

6 손가락 = 자경단 60% 코드.

### 7-2. 주간 5 도구

| 도구 | 매주 사용 |
|------|---------|
| `zip(strict=True)` | 10+ 줄 |
| `any(... for ... in ...)` | 20+ 줄 |
| `all(... for ... in ...)` | 20+ 줄 |
| `Counter(items)` | 5+ 줄 |
| `defaultdict(list)` | 10+ 줄 |

5 도구 = 매주.

### 7-3. 월간 3 도구

| 도구 | 매월 사용 |
|------|---------|
| `itertools.chain/groupby` | 5+ 줄 |
| `functools.cache` | 5+ 줄 |
| `iter(callable, sentinel)` | 1년 차 |

3 도구 = 매월.

6+5+3 = 14 손가락 한 달 사용. 자경단 100%.

---

## 8. 자경단 매일 13줄 흐름

```python
# 자경단 환율 알림 13줄 (18 도구 중 9개 사용)
from collections import Counter, defaultdict
from itertools import groupby
from operator import itemgetter

def daily_alert(rates_history):
    # 1. enumerate (반복)
    for day, rates in enumerate(rates_history, start=1):
        # 2. comprehension + filter
        high = {c: r for c, r in rates.items() if r > 1500}
        # 3. sorted + key
        sorted_high = sorted(high.items(), key=itemgetter(1), reverse=True)
        # 4. any
        if any(r > 1600 for r in high.values()):
            # 5. max + key
            top = max(high.items(), key=itemgetter(1))
            # 6. f-string + ternary
            msg = f"{day}일: {top[0]} {top[1]:.2f} ({'위험' if top[1] > 1700 else '주의'})"
            # 7. notify
            notify_5_cats(msg)
```

13줄 + 9 도구 = 자경단 매일 환율 알림 표준.

### 8-1. 자경단 매일 5 시나리오 + 도구

```python
# 1. 사용자 통계 (Counter)
from collections import Counter
top5_cities = Counter(u['city'] for u in users).most_common(5)

# 2. 정렬된 환율 알림 (sorted + filter)
high_rates = sorted(
    (c for c in rates if c['value'] > 1500),
    key=itemgetter('value'),
    reverse=True
)

# 3. log 분석 (groupby)
from itertools import groupby
errors_by_hour = {
    hour: list(group)
    for hour, group in groupby(logs, key=lambda l: l['hour'])
}

# 4. 배치 처리 (zip)
for batch in zip(*[iter(items)] * 100):
    process_batch(batch)

# 5. cache 적용 (functools.cache)
@cache
def expensive_call(key):
    return api.get(key)
```

5 시나리오 × 자경단 매일 = 18 도구의 진짜 적용.

---

## 9. 자경단 5명 매일 18 도구 사용표

| 누구 | 매일 사용 도구 |
|------|------------|
| 본인 | enumerate·sorted·sum·any/all·dict.items (FastAPI) |
| 까미 | comprehension 4종·Counter·groupby (DB) |
| 노랭이 | map·filter·zip (도구) |
| 미니 | itertools.chain·functools.partial (인프라) |
| 깜장이 | iter·next·sorted (테스트) |

5명 × 5 도구 = 매일 25 도구 사용. 자경단 매일.

---

## 10. 5 함정 + 처방

### 10-1. 함정 1: range(len(items)) — 비Pythonic

```python
# 비권장
for i in range(len(cats)):
    cat = cats[i]
    print(i, cat)

# 권장
for i, cat in enumerate(cats):
    print(i, cat)
```

### 10-2. 함정 2: filter/map보다 comp이 가독성

```python
# 비권장 (lambda)
list(filter(lambda c: c['age'] > 1, cats))

# 권장 (comp)
[c for c in cats if c['age'] > 1]
```

### 10-3. 함정 3: sorted vs sort 혼동

```python
# sorted — 새 list 반환
new_list = sorted(items)

# sort — in-place (list만, 반환값 None)
items.sort()
result = items.sort()       # None! 함정
```

### 10-4. 함정 4: zip 길이 차이

```python
# silent 자름 — 함정
list(zip([1, 2], [3, 4, 5]))  # [(1,3), (2,4)]

# 처방 — strict=True 또는 zip_longest
list(zip([1, 2], [3, 4, 5], strict=True))  # ValueError
```

### 10-5. 함정 5: generator 두 번 사용

```python
gen = (x**2 for x in range(10))
list(gen)                   # [0, 1, 4, 9, ...]
list(gen)                   # [] (소진됨!)

# 처방 — list로 변환 후 재사용
items = list(gen)           # 한 번만 소진
list(items)                 # [0, 1, 4, ...]
list(items)                 # [0, 1, 4, ...] (재사용 OK)
```

5 함정 면역 = 자경단 1년 자산.

### 10-6. 함정 6 (보너스): dict 반복 중 변경

```python
# 함정
d = {'a': 1, 'b': 2, 'c': 3}
for k in d:
    if d[k] > 1:
        del d[k]              # RuntimeError: dictionary changed size

# 처방
for k in list(d.keys()):     # list로 복사
    if d[k] > 1:
        del d[k]

# 또는 comp
d = {k: v for k, v in d.items() if v <= 1}
```

자경단 매일 의식 — dict 반복 중 변경 X.

### 10-7. 함정 7 (보너스): comp 안 부작용

```python
# 비권장 — print는 부작용
[print(x) for x in items]    # list 만듦 (메모리 낭비)

# 권장 — for 루프
for x in items:
    print(x)
```

comp은 변환·생성 전용. 부작용은 for 루프.

---

## 10-8. 18 도구의 매일·주간·월간 누적 사용 시간

자경단 본인 1주일 측정 (2시간 코딩 매일 가정):
- 매일 6 손가락 (enumerate·comp·sum/len·sorted·in·dict.items): 누적 1시간/주
- 주간 5 도구 (zip·any·all·Counter·defaultdict): 누적 30분/주
- 월간 3 도구 (itertools·functools·iter): 누적 5분/월

총 1.5시간/주 × 50주 = 75시간/년 = 18 도구 직접 사용. 학습 5시간 = ROI 15배.

---

## 11. 흔한 오해 5가지

**오해 1: "filter/map이 comp보다 빠르다."** — 비슷·comp 가독성 우위. 자경단 표준 comp.

**오해 2: "sorted가 in-place."** — sorted 새 list. sort가 in-place (list만).

**오해 3: "any/all 항상 끝까지 평가."** — 단축 평가. any 첫 True·all 첫 False에서 멈춤.

**오해 4: "itertools 무겁다."** — 표준 라이브러리. C 구현. 빠름.

**오해 5: "Counter는 dict와 같다."** — dict 상속이지만 most_common·subtract 등 추가 메서드.

**오해 6: "lambda 항상 사용."** — operator.itemgetter/attrgetter이 더 빠르고 가독성. lambda는 임시 함수만.

**오해 7: "namedtuple 옛것."** — Python 3.6+ NamedTuple (typing) 모던 양식. dataclass(frozen=True)도 대안. 자경단 매일.

**오해 8: "comp이 모든 for 대체."** — 부작용 (print·DB write)은 for 루프. 변환/생성만 comp.

---

### 11-1. 18 도구 vs 다른 언어 비교 자랑

| 기능 | Python | JavaScript | Java |
|------|--------|-----------|------|
| 인덱스+값 | enumerate(items) | items.entries() | for(int i=0; i<items.size(); i++) |
| 병렬 | zip(a, b) | a.map((x, i) => [x, b[i]]) | Stream.zip 별도 라이브러리 |
| 정렬 key | sorted(items, key=...) | items.sort((a,b) => ...) | items.sort(Comparator.comparing(...)) |
| 합 | sum(items) | items.reduce((a,b)=>a+b, 0) | items.stream().sum() |
| comp | [x*2 for x in items] | items.map(x => x*2) | items.stream().map(...).collect(...) |

Python이 가독성 1위. 자경단 매일 자랑.

---

## 12. FAQ 5가지

**Q1. comp vs map/filter 어떻게 결정?**
A. 자경단 표준 comp. 기존 함수 그대로 쓸 때만 map.

**Q2. sorted key vs sort key?**
A. 같음. sorted 새 list·sort in-place 차이만.

**Q3. itertools 외워야 5개?**
A. chain·groupby·product·combinations·count. 매주 활용.

**Q4. functools.cache vs lru_cache?**
A. cache 무한·lru_cache(maxsize=None) 같음. lru_cache(maxsize=128) 제한.

**Q5. namedtuple vs dataclass?**
A. namedtuple 가벼움 (immutable). dataclass 강력 (mutable·default·메서드).

**Q6. operator vs lambda?**
A. operator.itemgetter/attrgetter이 더 빠름 (C 구현). 자경단 표준.

**Q7. zip(*matrix) 행렬 전치?**
A. unpacking + zip = transpose. 한 줄 매직.

**Q8. itertools.tee 메모리?**
A. 두 iterator의 차이만큼 메모리. 큰 차이 시 list로 변환.

**Q9. functools.cache vs Redis?**
A. cache 메모리 (단일 process)·Redis 분산. 작은 함수는 cache.

**Q10. collections.deque vs list?**
A. deque 양쪽 O(1)·list pop(0) O(n). 큐는 deque.

---

## 13. 추신

추신 1. 18 도구 6 무리 (반복·집계·필터·정렬·생성·고급) 한 표 = 자경단 매일 카탈로그.

추신 2. 신호등 3색 (🟢🟡🔴) — 옵션·상황이 색을 바꿈.

추신 3. range — lazy iterator. 1억까지 메모리 4MB.

추신 4. enumerate — for + range(len()) 비권장. 자경단 표준.

추신 5. enumerate(start=1) — 사람 출력. 매일 표준.

추신 6. zip(strict=True) Python 3.10+ — 길이 차이 명시적.

추신 7. itertools.zip_longest — 긴 쪽 기준. fillvalue 옵션.

추신 8. reversed — 새 list 안 만듦. cats[::-1] 비권장.

추신 9. sum + generator = 메모리 절약. `sum(c['age'] for c in cats)`.

추신 10. min/max + key = lambda 또는 itemgetter. 자경단 매일.

추신 11. any/all 단축 평가. 첫 True/False에서 멈춤.

추신 12. len — generator는 TypeError. `sum(1 for _ in gen)` 처방.

추신 13. filter/map → comp이 자경단 표준. 가독성 우위.

추신 14. sorted vs sort — sorted 새 list (모든 iterable)·sort in-place (list만).

추신 15. sorted(stable) — 같은 key 입력 순서 유지.

추신 16. comp 4종 + nested = 5 종. 자경단 매일 100+.

추신 17. iter(callable, sentinel) = 종료값까지 호출. 매직.

추신 18. next(gen, default) = StopIteration 대신 default. 안전.

추신 19. itertools 5 (chain·groupby·product·combinations·count) 매주.

추신 20. functools 3 (cache·reduce·partial) 매주.

추신 21. collections 5 (Counter·defaultdict·OrderedDict·deque·namedtuple) 매일.

추신 22. operator (itemgetter·attrgetter) — lambda 대체 + 빠름.

추신 23. 매일 6 손가락 = 자경단 60% 코드.

추신 24. 주간 5 도구 + 월간 3 = 14 손가락 한 달.

추신 25. 자경단 13줄 환율 알림 = 9 도구 사용.

추신 26. 자경단 5명 매일 25 도구 사용. 본 H의 진짜 적용.

추신 27. 5 함정 (range(len)·filter/map·sorted vs sort·zip 길이·gen 재사용) 면역.

추신 28. 흔한 오해 5 면역.

추신 29. FAQ 5 답변.

추신 30. **본 H 끝** ✅ — Ch008 H4 명령어카탈로그 학습 완료. 18 도구 + 14 손가락 + 13줄 흐름. 다음 H5 데모 (환율 계산기 50줄→150줄)! 🐾🐾🐾

추신 31. enumerate 5 활용 (줄 번호·인덱스+값·디버깅·진행률·짝수 분리).

추신 32. zip 5 활용 (짝짓기·dict 만들기·비교·transpose·N개 동시).

추신 33. zip(*matrix) = 행렬 전치. 한 줄 매직.

추신 34. reversed 5 활용 (commit·검색·전기·log·DOM 후위).

추신 35. sum 5 활용 (환율·줄 수·중첩·비율·gen).

추신 36. sorted 5 활용 (이름·나이·다중 key·역순·안정).

추신 37. operator.itemgetter — lambda 대체 + 빠름. 자경단 시니어.

추신 38. comp 5 일반 패턴 (transform·filter·둘동시·nested·if-else).

추신 39. next 5 활용 (첫 매치·헤더·chunk·진행·시뮬).

추신 40. itertools 추가 5 (tee·cycle·takewhile/dropwhile·accumulate·pairwise).

추신 41. functools 추가 3 (lru_cache·wraps·singledispatch).

추신 42. collections 추가 3 (ChainMap·UserDict/UserList/UserString).

추신 43. 자경단 매일 5 시나리오 (Counter·sorted+filter·groupby·zip 배치·cache).

추신 44. zip(*[iter(items)] * 100) = 100개 배치 매직.

추신 45. ChainMap = config 우선순위 (env > file > default).

추신 46. dict 반복 중 변경 X — list(d.keys())로 복사.

추신 47. comp 안 부작용 X — 변환·생성만. print는 for 루프.

추신 48. namedtuple vs dataclass — 가벼움 vs 강력. 자경단 둘 다.

추신 49. deque vs list — 양쪽 O(1) vs pop(0) O(n). 큐는 deque.

추신 50. **본 H 진짜 끝** ✅ — 18 도구 × 5 활용 = 90 활용. 자경단 1년 후 시니어 카탈로그. 다음 H5 데모! 🐾🐾🐾🐾🐾

추신 51. 자경단 매일 누적 1.5시간/주 × 50주 = 75시간/년 18 도구 직접 사용. 학습 5시간 ROI 15배.

추신 52. Python 18 도구 vs JS·Java 비교 — 가독성 1위. enumerate·zip·comp·sorted key 4 도구가 자경단 자랑.

추신 53. 18 도구 학습 1주차 우선순위 — Must 6 (enumerate·comp·sum/len·sorted·in·dict.items)·Should 5 (zip·any·all·Counter·defaultdict)·Could 3 (itertools·functools·iter).

추신 54. 자경단 본인 1년 18 도구 사용 누적 — 매일 100,000+ 줄 코드 중 18 도구가 73%.

추신 55. itertools.tee 활용 — 같은 iterator 두 번 사용. 큰 차이 시 list로.

추신 56. itertools.cycle — 무한 순환. break 명시 필수.

추신 57. itertools.takewhile/dropwhile — 조건 잘라내기. log 필터 표준.

추신 58. itertools.accumulate(initial=) Python 3.8+ — 누적 합/최대.

추신 59. itertools.pairwise Python 3.10+ — 인접 쌍. `[(a, b) for a, b in pairwise([1,2,3,4])]` = `[(1,2),(2,3),(3,4)]`.

추신 60. functools.lru_cache(maxsize=128) — 제한 cache. 메모리 안전.

추신 61. functools.wraps — decorator metadata 보존. 매 decorator 표준.

추신 62. functools.singledispatch — 함수 type별 overload. 자경단 1년 차.

추신 63. ChainMap — env > file > default 우선순위. config 표준.

추신 64. UserDict — dict 직접 상속의 안전 대안. 자경단 1년 차.

추신 65. **본 H 100% 끝** ✅✅✅ — 18 도구 + 6 무리 + 14 손가락 + 13줄 흐름 + 5 시나리오 + 75h/년 사용. 자경단 카탈로그 마스터! 🐾🐾🐾🐾🐾🐾🐾

추신 66. enumerate가 자경단 매일 100+ 줄 사용. 가장 흔한 for 짝꿍.

추신 67. comp이 자경단 매일 100+ 줄 사용. 가독성 1위.

추신 68. sum/len/min/max가 자경단 매일 200+ 줄 사용. 집계 표준.

추신 69. sorted + key가 자경단 매일 50+ 줄 사용. 표시 표준.

추신 70. dict.items() + for이 자경단 매일 100+ 줄 사용. dict 반복 표준.

추신 71. 6 손가락 (enumerate·comp·sum·sorted·in·dict.items) = 자경단 매일 60% 코드.

추신 72. Counter(items).most_common(5) = top-5 분석 한 줄. 자경단 매일.

추신 73. defaultdict(list) = 자동 초기화. KeyError 면역.

추신 74. operator.itemgetter('age') = lambda 대체 + 빠름. 자경단 시니어.

추신 75. **본 H 진짜 마지막** ✅✅✅ — 자경단 18 도구 카탈로그 + 75 활용 + 73% 코드 사용. 다음 H5 데모 환율 계산기 50줄→150줄에서! 🐾🐾🐾🐾🐾🐾🐾🐾

추신 76. itertools 1년 차 누적 — chain·groupby·product·combinations·count·tee·cycle·takewhile·accumulate·pairwise 10 도구.

추신 77. functools 1년 차 누적 — cache·reduce·partial·lru_cache·wraps·singledispatch 6 도구.

추신 78. collections 1년 차 누적 — Counter·defaultdict·OrderedDict·deque·namedtuple·ChainMap·UserDict·UserList 8 도구.

추신 79. operator 1년 차 누적 — itemgetter·attrgetter·methodcaller 3 도구. lambda 대체.

추신 80. 18 일반 + 27 표준 라이브러리 = 45 도구 자경단 1년 후 시니어. 본 H가 그 시작.

추신 81. 본 H 학습 후 본인의 첫 행동 — `from collections import Counter; from itertools import groupby; from functools import cache` 한 줄. 5분에 18+ 도구 손가락.

추신 82. **본 H 100%** ✅✅✅✅✅ — Ch008 H4 카탈로그 학습 완료. 다음 H5 환율 계산기 데모! 🐾
