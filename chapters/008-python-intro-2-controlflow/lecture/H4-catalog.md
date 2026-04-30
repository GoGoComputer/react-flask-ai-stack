# Ch008 · H4 — 18 제어 도구 카탈로그 — 본인의 매일 흐름 손가락

> 고양이 자경단 · Ch 008 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 18 도구 한 표
3. 첫째 무리 — 반복 네 도구
4. 둘째 무리 — 집계 다섯 도구
5. 셋째 무리 — 필터·변환·정렬 네 도구
6. 넷째 무리 — comprehension·iter·next 세 도구
7. 다섯째 무리 — itertools·functools·collections
8. 매일·주간·월간 손가락 리듬
9. 자경단 매일 13줄 흐름
10. 다섯 함정과 처방
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리 — 다음 H5에서 만나요

---

## 🔧 강사용 명령어 한눈에

```python
# 반복 4
for x in xs: ...
enumerate(xs)
zip(xs, ys)
range(10)

# 집계 5
sum(xs); min(xs); max(xs); len(xs); any(xs); all(xs)

# 필터 4
filter(f, xs); map(f, xs); sorted(xs); reversed(xs)

# comprehension 3
[x for x in xs]
iter(xs); next(it)

# itertools 5
chain, groupby, accumulate, product, combinations
```

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H3을 한 줄로 회수할게요. 디버깅 5도구. VS Code, breakpoint, pdb, rich, ipython.

이번 H4는 흐름 도구 18개를 표 한 장에 누이는 시간. 본인이 매일 흐름 짤 때 만나는 손가락.

오늘의 약속. **18 도구가 한 시간에 본인 머리에 들어옵니다**. 6주 후엔 손가락에 박혀요.

자, 가요.

---

## 2. 18 도구 한 표

| # | 도구 | 무리 | 한 줄 정의 |
|---|------|------|----------|
| 1 | `for` | 반복 | iterable 순회 |
| 2 | `enumerate` | 반복 | 인덱스 + 값 |
| 3 | `zip` | 반복 | 여러 iterable 동시 |
| 4 | `range` | 반복 | 숫자 시퀀스 |
| 5 | `sum` | 집계 | 합 |
| 6 | `min` | 집계 | 최소 |
| 7 | `max` | 집계 | 최대 |
| 8 | `len` | 집계 | 길이 |
| 9 | `any` | 집계 | 하나라도 truthy |
| 10 | `all` | 집계 | 모두 truthy |
| 11 | `filter` | 필터 | 조건 필터 |
| 12 | `map` | 변환 | 변환 |
| 13 | `sorted` | 정렬 | 정렬 |
| 14 | `reversed` | 정렬 | 역순 |
| 15 | `[..]` | comp | list comp |
| 16 | `iter` | iter | iterator 만들기 |
| 17 | `next` | iter | 다음 요소 |
| 18 | `itertools` | 조합 | 함수형 도구 |

18개. 다섯 무리.

---

## 3. 첫째 무리 — 반복 네 도구

**for**. 가장 기본. iterable 순회.

```python
for cat in cats:
    print(cat)
```

**enumerate**. 인덱스와 값을 같이.

```python
for i, cat in enumerate(cats, start=1):
    print(f"{i}번: {cat}")
```

start로 시작 인덱스 변경. 자경단 매일.

**zip**. 두 iterable 동시.

```python
names = ["까미", "노랭이"]
ages = [3, 2]
for n, a in zip(names, ages):
    print(f"{n}는 {a}살")
```

길이 다르면 짧은 쪽에서 멈춤. `itertools.zip_longest`로 채우기.

**range**. 숫자 시퀀스.

```python
range(5)         # 0, 1, 2, 3, 4
range(1, 6)      # 1, 2, 3, 4, 5
range(0, 10, 2)  # 0, 2, 4, 6, 8
```

세 종류. range는 lazy iterable. list 아님.

---

## 4. 둘째 무리 — 집계 다섯 도구

**sum** — 합.
```python
sum([1, 2, 3])         # 6
sum(c.age for c in cats)  # generator
```

**min**, **max** — 최소/최대.
```python
min(ages)
max(cats, key=lambda c: c.age)   # key로 비교 기준
```

**len** — 길이.
```python
len(cats)         # 5
len("hello")      # 5
len({"a": 1})     # 1
```

**any**, **all** — 조건 검증.
```python
any(c.is_active for c in cats)   # 하나라도 활성
all(c.age > 0 for c in cats)     # 모두 양수
```

다섯 도구. 매일 sum, min, max가 가장 자주.

---

## 5. 셋째 무리 — 필터·변환·정렬 네 도구

**filter** — 조건 필터.
```python
adults = filter(lambda c: c.age >= 18, cats)
list(adults)
```

자경단은 보통 list comprehension 선호. `[c for c in cats if c.age >= 18]`.

**map** — 변환.
```python
ages = map(lambda c: c.age, cats)
list(ages)
```

역시 comp 선호. `[c.age for c in cats]`.

**sorted** — 정렬.
```python
sorted(ages)
sorted(cats, key=lambda c: c.age)
sorted(cats, key=lambda c: c.age, reverse=True)
```

key와 reverse 매일.

**reversed** — 역순.
```python
list(reversed([1, 2, 3]))   # [3, 2, 1]
```

reversed는 lazy. list로 감싸야 결과 봄.

---

## 6. 넷째 무리 — comprehension·iter·next 세 도구

**comprehension** 4종은 H2에서 자세히. 한 줄.

```python
[x*2 for x in xs]
{x*2 for x in xs}
{k:v for k,v in pairs}
(x*2 for x in xs)
```

**iter** + **next** — iterator 직접 다루기.

```python
it = iter([1, 2, 3])
next(it)   # 1
next(it)   # 2
next(it)   # 3
next(it)   # StopIteration
```

자경단 가끔. 보통 for가 자동 처리.

---

## 7. 다섯째 무리 — itertools·functools·collections

표준 라이브러리의 함수형 도구 묶음.

**itertools 다섯 가지**

```python
from itertools import chain, groupby, accumulate, product, combinations

# chain — 여러 iterable을 하나로
list(chain([1, 2], [3, 4]))   # [1, 2, 3, 4]

# groupby — 같은 key 그룹화
for key, group in groupby(sorted(cats, key=lambda c: c.color), key=lambda c: c.color):
    print(key, list(group))

# accumulate — 누적합
list(accumulate([1, 2, 3, 4]))   # [1, 3, 6, 10]

# product — 곱 (모든 조합)
list(product([1, 2], ["a", "b"]))   # [(1,'a'), (1,'b'), (2,'a'), (2,'b')]

# combinations — 조합
list(combinations([1, 2, 3], 2))   # [(1,2), (1,3), (2,3)]
```

**functools**

```python
from functools import reduce, lru_cache, partial

# reduce — 누적
reduce(lambda a, b: a + b, [1, 2, 3, 4])   # 10

# lru_cache — 함수 결과 캐싱
@lru_cache(maxsize=128)
def fib(n):
    return n if n < 2 else fib(n-1) + fib(n-2)

# partial — 일부 인자 고정
add5 = partial(lambda a, b: a + b, 5)
add5(3)   # 8
```

**collections**

```python
from collections import Counter, defaultdict, deque, namedtuple

# Counter — 빈도수
Counter("hello")   # {'l': 2, 'h': 1, 'e': 1, 'o': 1}

# defaultdict — 기본값 dict
d = defaultdict(list)
d["cats"].append("까미")   # KeyError 없음

# deque — 양방향 큐
q = deque([1, 2, 3])
q.appendleft(0)

# namedtuple — 이름 있는 tuple
Point = namedtuple("Point", ["x", "y"])
p = Point(1, 2)
```

세 모듈이 자경단의 흐름 곱셈 도구.

---

## 8. 매일·주간·월간 손가락 리듬

**매일 6개** (Ch007 도구 포함). for, enumerate, len, list comp, zip, sorted.

**주간 5개**. sum, min, max, any, all.

**월간 3개**. filter, map, reversed.

**필요 시**. itertools, functools, collections.

매일 6개부터.

---

## 9. 자경단 매일 13줄 흐름

```python
# 자경단 백엔드 까미의 매일
def get_active_users(users):
    return [u for u in users if u.is_active]

def avg_age(users):
    return sum(u.age for u in users) / len(users)

def find_user(users, user_id):
    for u in users:
        if u.id == user_id:
            return u
    return None

def group_by_country(users):
    from collections import defaultdict
    result = defaultdict(list)
    for u in users:
        result[u.country].append(u)
    return result
```

13줄 안에 18 도구 중 8개. 자경단 매일 패턴.

---

## 10. 다섯 함정과 처방

**함정 1: range로 인덱스 직접**

```python
for i in range(len(items)):
    print(i, items[i])
```

처방. enumerate.

**함정 2: list comp 부수 효과**

```python
[print(c) for c in cats]   # 결과 안 씀
```

처방. 일반 for.

**함정 3: lambda 남용**

```python
sorted(cats, key=lambda c: c.age)
```

OK지만 named function이 더 가독성. 자경단은 lambda 한 줄까지.

**함정 4: filter/map vs comp**

```python
list(filter(lambda c: c.age > 3, cats))
```

처방. comp.

```python
[c for c in cats if c.age > 3]
```

**함정 5: dict.keys() iteration**

```python
for k in d.keys():
    print(k, d[k])
```

처방. .items().

```python
for k, v in d.items():
    print(k, v)
```

---

## 11. 흔한 오해 다섯 가지

**오해 1: 18 도구 다 외워야.**

매일 6개. 6주에 18개.

**오해 2: filter/map이 comp보다 빠르다.**

비슷. comp가 가독성 우선.

**오해 3: itertools는 옵션.**

groupby, chain 매일.

**오해 4: lambda는 함수.**

익명 함수. def보다 짧지만 디버깅 어려움.

**오해 5: sorted가 list만.**

iterable 모두. 결과는 list.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. lambda vs def?**

한 줄 표현은 lambda, 복잡한 로직은 def.

**Q2. sorted key?**

`key=lambda c: c.age`. 정렬 기준 함수.

**Q3. itertools 어디서?**

큰 데이터 처리. groupby가 자주.

**Q4. Counter 매일?**

빈도 분석에 강력. 자경단 데이터팀 매일.

**Q5. lru_cache 위험?**

mutable 인자에 사고. immutable만 캐싱.

---

## 13. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, 명령 다 외우기. 안심 — 매일 5개.
둘째, 위험 명령 함부로. 안심 — 0.5초 멈춤.
셋째, 결과 확인 안 함. 안심 — `git status`/`echo $?`.
넷째, 한 줄 욱여넣기. 안심 — 다섯 줄이 명확.
다섯째, 가장 큰 — 검색 명령 그대로. 안심 — explainshell.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 14. 마무리 — 다음 H5에서 만나요

자, 네 번째 시간이 끝났어요. 60분에 18 도구. 정리하면.

반복 4, 집계 5, 필터 4, comp 3, itertools/functools/collections. 매일 6개부터 6주에 18개. 자경단 13줄 흐름.

박수.

다음 H5는 30분 데모. 환율 계산기 v1 50줄을 v2 150줄로 진화. 한 시간 후 만나요.

```python
python3 -c 'cats=[(\"까미\",3),(\"노랭이\",2)]; print(sorted(cats, key=lambda c: c[1]))'
```

---

## 👨‍💻 개발자 노트

> - itertools 게으름: 모두 generator. list로 감싸야 결과.
> - functools.reduce: 우→좌 또는 좌→우 (initial value).
> - collections.Counter.most_common(N): 상위 N개.
> - lru_cache vs cache: cache는 무제한, lru_cache는 N개 제한.
> - namedtuple vs dataclass: namedtuple은 tuple 기반, dataclass는 class 기반. 모던은 dataclass.
> - 다음 H5 키워드: 환율 계산기 v2 · 150줄 · 9 함수 · 18 도구.
