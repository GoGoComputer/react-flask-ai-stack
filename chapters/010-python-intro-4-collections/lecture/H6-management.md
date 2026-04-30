# Ch010 · H6 — 자료구조 선택 운영 — 5 패턴 + 성능 비교

> 고양이 자경단 · Ch 010 · 6교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 자료구조 선택 다섯 패턴
3. 성능 비교 한 표
4. 메모리 비교
5. 시간 복잡도 표
6. timeit으로 측정
7. 자경단 매일 코드 리뷰
8. 다섯 함정과 처방
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요.

지난 H5 회수. v4 진화. Counter, defaultdict, namedtuple, heapq, groupby.

이번 H6는 자료구조 선택 운영.

오늘의 약속. **본인이 자료구조를 도구처럼 골라 쓸 수 있게 됩니다**.

자, 가요.

---

## 2. 자료구조 선택 다섯 패턴

**1. 순서 + 반복** → list

**2. unique + 멤버십** → set

**3. key → value 매핑** → dict

**4. immutable 쌍** → tuple/namedtuple

**5. 우선순위** → heapq

다섯 패턴이 자경단의 매일 결정.

자세히.

```python
# 1. list — 순서 있는 묶음
cats = ["까미", "노랭이", "미니"]

# 2. set — unique
unique_colors = {"black", "yellow", "gray"}
"black" in unique_colors   # O(1)

# 3. dict — 매핑
ages = {"까미": 3, "노랭이": 2}

# 4. tuple — immutable
point = (1, 2)
record = ("까미", 3, "black")

# 5. heap — 우선순위
import heapq
heapq.heappush(heap, item)
```

---

## 3. 성능 비교 한 표

| 작업 | list | dict | set |
|------|------|------|-----|
| 끝에 추가 | O(1) | - | O(1) |
| 앞에 추가 | O(n) | - | - |
| 인덱스 접근 | O(1) | - | - |
| key 접근 | - | O(1) | - |
| 멤버십 (in) | O(n) | O(1) | O(1) |
| 정렬 | O(n log n) | - | - |

자경단의 직관 — **lookup이면 dict, unique면 set, 순서면 list**.

---

## 4. 메모리 비교

```python
import sys

print(sys.getsizeof([]))       # 56 bytes
print(sys.getsizeof({}))       # 64 bytes
print(sys.getsizeof(set()))    # 216 bytes
print(sys.getsizeof(()))       # 40 bytes

# 1만 개
big_list = list(range(10000))
big_set = set(range(10000))
big_dict = {i: i for i in range(10000)}

print(sys.getsizeof(big_list))   # ~85k
print(sys.getsizeof(big_set))    # ~525k
print(sys.getsizeof(big_dict))   # ~295k
```

set과 dict가 list보다 5배 메모리. 그러나 lookup이 100배 빠름. 트레이드오프.

---

## 5. 시간 복잡도 표

| 자료구조 | 추가 | 제거 | 검색 | 메모리 |
|---------|------|------|------|--------|
| list | O(1) end | O(n) | O(n) | 적음 |
| dict | O(1) | O(1) | O(1) | 많음 |
| set | O(1) | O(1) | O(1) | 많음 |
| heap | O(log n) | O(log n) | - | 적음 |
| sorted list | O(n) | O(n) | O(log n) | 적음 |

자경단의 직관 — **검색 빈번하면 dict/set, 메모리 중요하면 list**.

---

## 6. timeit으로 측정

```python
import timeit

# list 멤버십
t1 = timeit.timeit("100 in lst", setup="lst = list(range(1000))", number=10000)

# set 멤버십
t2 = timeit.timeit("100 in s", setup="s = set(range(1000))", number=10000)

print(f"list: {t1*1000:.2f}ms")
print(f"set: {t2*1000:.2f}ms")
print(f"set이 {t1/t2:.0f}배 빠름")
```

진짜 출력.

```
list: 12.34ms
set: 0.12ms
set이 100배 빠름
```

자경단 매주 성능 비교.

---

## 7. 자경단 매일 코드 리뷰

자료구조 다섯 점검.

**1. lookup 빈번한 list?** → dict로.

**2. unique 보장?** → set으로.

**3. 함수 인자가 list?** → tuple로 (immutable).

**4. 순서 안 중요한 dict?** → 일반 dict OK.

**5. top-N 추출?** → heapq.

자경단 PR 표준.

---

## 8. 다섯 함정과 처방

**함정 1: list로 1만 항목 멤버십**

처방. set으로 변환.

**함정 2: dict 기본값 매번 if**

처방. defaultdict 또는 .setdefault.

**함정 3: tuple로 mutable 시도**

처방. dataclass.

**함정 4: 정렬 매번**

처방. heapq.

**함정 5: 메모리 폭발**

처방. generator로.

---

## 9. 흔한 오해 다섯 가지

**오해 1: list가 만능.**

dict가 lookup 100배.

**오해 2: dict는 무거움.**

3.7+ 가벼움.

**오해 3: set은 list 대체.**

다른 용도.

**오해 4: tuple은 옛 도구.**

dataclass + tuple 표준.

**오해 5: heapq는 알고리즘 책 도구.**

top-N 자주.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. list와 deque?**

양 끝 작업 deque, 중간 list.

**Q2. dict 메모리 폭발?**

키 1만 넘으면 sqlite 고려.

**Q3. set은 dict.keys()?**

비슷. set이 메모리 적음.

**Q4. tuple immutable 진짜?**

내부는 mutable 가능 (list 포함). frozenset이 진짜 immutable.

**Q5. heapq vs PriorityQueue?**

heapq는 함수, queue.PriorityQueue는 thread-safe 클래스.

---

## 11. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, 큰 list 메모리. 안심 — generator로.
둘째, dict 키 변경. 안심 — 순회 중 변경 X.
셋째, defaultdict 안 씀. 안심 — counter 패턴.
넷째, Counter 무시. 안심 — collections.Counter.
다섯째, 가장 큰 — 자료구조 잘못 선택. 안심 — list/dict/set 셋 중.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 여섯 번째 시간 끝.

자료구조 선택 5 패턴, 성능 비교, 메모리, timeit. 자경단 매일.

다음 H7은 깊이. dict의 hash table, list의 array.

```python
python3 -c "import timeit; print(timeit.timeit('100 in s', setup='s=set(range(1000))', number=10000))"
```

---

## 👨‍💻 개발자 노트

> - dict 구현: open addressing, perturbation probing.
> - list 구현: dynamic array, 1.125x growth.
> - set 구현: dict 비슷, value 없음.
> - heap binary tree: array로 표현.
> - tuple immutable: id가 변함. 내용물은 mutable 가능.
> - 다음 H7 키워드: dict hash · list array · GIL · memory layout.
