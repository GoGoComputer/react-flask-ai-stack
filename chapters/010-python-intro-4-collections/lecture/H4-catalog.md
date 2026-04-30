# Ch010 · H4 — collections 30+ 도구 카탈로그 — heapq·bisect·deque·Counter

> 고양이 자경단 · Ch 010 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 도구 한 표
3. 첫째 무리 — built-in 메서드
4. 둘째 무리 — collections 모듈
5. 셋째 무리 — heapq
6. 넷째 무리 — bisect
7. 다섯째 무리 — itertools
8. 매일·주간·월간 리듬
9. 자경단 매일 13줄 흐름
10. 다섯 함정과 처방
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요.

지난 H3 회수. 4 디버깅 도구.

이번 H4는 30+ 도구.

오늘의 약속. **본인이 자료구조 도구 30개를 만나고, 매일 10개를 손가락에 박습니다**.

자, 가요.

---

## 2. 도구 한 표

| 무리 | 도구 |
|------|------|
| list | append, pop, sort, reverse, index, count, remove, insert |
| dict | get, setdefault, update, pop, items, keys, values |
| set | add, discard, union(\|), intersection(&) |
| collections | Counter, defaultdict, deque, namedtuple, OrderedDict |
| heapq | heappush, heappop, heapify, nlargest, nsmallest |
| bisect | bisect_left, bisect_right, insort |
| itertools | chain, groupby, accumulate, product, combinations |

30+. 다섯 무리.

---

## 3. 첫째 무리 — built-in 메서드

H2에서 다 봤어요. list 10, dict 7, set 5.

```python
cats.append("미니")
ages.get("까미", 0)
colors.add("white")
```

매일 30번 사용.

---

## 4. 둘째 무리 — collections 모듈

H2에서 5개 봤어요. 자경단 매일.

```python
from collections import Counter, defaultdict, deque, namedtuple

Counter("hello")              # 빈도
defaultdict(list)             # 기본값
deque([1,2,3])                # 양방향 큐
Point = namedtuple("Point", ["x","y"])
```

---

## 5. 셋째 무리 — heapq

heap (우선순위 큐).

```python
import heapq

nums = [3, 1, 4, 1, 5, 9, 2, 6]
heapq.heapify(nums)           # 제자리 heap

heapq.heappush(nums, 0)
smallest = heapq.heappop(nums)   # 가장 작은 값

# 상위/하위 N개
heapq.nlargest(3, nums)
heapq.nsmallest(3, nums)
```

자경단 — 우선순위 작업, top-N.

---

## 6. 넷째 무리 — bisect

이진 탐색. 정렬된 list에서.

```python
import bisect

sorted_nums = [1, 3, 5, 7, 9]

# 위치 찾기 (O(log n))
pos = bisect.bisect_left(sorted_nums, 4)   # 2

# 삽입하면서 정렬 유지
bisect.insort(sorted_nums, 4)
# [1, 3, 4, 5, 7, 9]
```

자경단 — 정렬된 데이터에서 빠른 위치.

---

## 7. 다섯째 무리 — itertools

함수형 흐름.

```python
from itertools import chain, groupby, accumulate, product, combinations

# chain — 합치기
list(chain([1, 2], [3, 4]))      # [1, 2, 3, 4]

# groupby — 같은 key 그룹
data = sorted(cats, key=lambda c: c.color)
for color, group in groupby(data, key=lambda c: c.color):
    print(color, list(group))

# accumulate — 누적
list(accumulate([1, 2, 3, 4]))   # [1, 3, 6, 10]

# product — 모든 조합
list(product([1, 2], ["a", "b"]))

# combinations
list(combinations([1, 2, 3], 2))   # [(1,2), (1,3), (2,3)]
```

자경단 매주.

---

## 8. 매일·주간·월간 리듬

**매일 10**. list/dict/set 메서드 + Counter + defaultdict.

**주간 10**. namedtuple, deque, heapq, bisect 일부.

**월간 10**. itertools.groupby, product, combinations, OrderedDict, abc.

매일 10개부터.

---

## 9. 자경단 매일 13줄 흐름

```python
from collections import Counter, defaultdict
from itertools import groupby

# 빈도 분석
freq = Counter(words)
top10 = freq.most_common(10)

# 그룹화
by_color = defaultdict(list)
for cat in cats:
    by_color[cat.color].append(cat)

# itertools groupby
for color, group in groupby(sorted(cats, key=lambda c: c.color), key=lambda c: c.color):
    print(color, list(group))

# heap top-N
import heapq
top5 = heapq.nlargest(5, cats, key=lambda c: c.age)

# dict comp
ages_map = {c.name: c.age for c in cats}
```

13줄. 자경단 매일.

---

## 10. 다섯 함정과 처방

**함정 1: list.remove() 못 찾음**

처방. `if x in list` 먼저.

**함정 2: dict.pop() 없는 key**

처방. default 인자.

**함정 3: set 정렬 기대**

처방. sorted(set).

**함정 4: heapq는 min-heap**

처방. max-heap은 부호 반전.

**함정 5: itertools.groupby 정렬 필요**

처방. sorted 먼저.

---

## 11. 흔한 오해 다섯 가지

**오해 1: list가 만능.**

dict와 set이 더 빠른 경우 많음.

**오해 2: heapq는 큰 데이터.**

작은 데이터도 top-N 빠름.

**오해 3: bisect 매일.**

정렬된 데이터에만. 가끔.

**오해 4: itertools 어렵다.**

5개만 익히면 충분.

**오해 5: collections는 옵션.**

Counter, defaultdict 매일.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. heapq vs sorted?**

heap은 부분 정렬 (top-N), sorted는 전체.

**Q2. bisect 어디서?**

이미 정렬된 list. 매일은 아님.

**Q3. itertools chain vs +?**

chain은 lazy, +는 eager.

**Q4. groupby 정렬 안 하면?**

연속된 같은 key만 그룹.

**Q5. 30 도구 다 외움?**

매일 10개부터. 6주.

---

## 13. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, list 메서드 다 외움. 안심 — append·pop·extend 셋.
둘째, dict 순회 헷갈림. 안심 — `for k, v in d.items()`.
셋째, comprehension 무지성. 안심 — 단순한 것만.
넷째, sorted vs sort. 안심 — sorted = 새 list, sort = in-place.
다섯째, 가장 큰 — built-in 안 사용. 안심 — sum/min/max/sorted.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 14. 마무리

자, 네 번째 시간 끝.

built-in, collections, heapq, bisect, itertools.

다음 H5는 30분 데모. exchange v4.

```python
python3 -c "from collections import Counter; print(Counter('자경단고양이').most_common(5))"
```

---

## 👨‍💻 개발자 노트

> - heapq: binary heap. C로 구현.
> - bisect: 이진 탐색. O(log n).
> - itertools.groupby vs Counter: groupby는 연속, Counter는 전체.
> - deque vs list: deque는 양 끝 O(1), list는 끝만 O(1).
> - namedtuple vs dataclass: namedtuple은 immutable + tuple 기반.
> - 다음 H5 키워드: exchange v4 · Counter · defaultdict · groupby · heapq.
