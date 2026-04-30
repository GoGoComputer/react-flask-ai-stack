# Ch010 · H2 — list·tuple·dict·set 깊이 — 자료구조 8개념

> 고양이 자경단 · Ch 010 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. 첫째 — list 메서드 열 가지
3. 둘째 — list slicing 다섯 패턴
4. 셋째 — tuple unpacking
5. 넷째 — dict 메서드와 comprehension
6. 다섯째 — set 연산 다섯 가지
7. 여섯째 — frozen 자료구조
8. 일곱째 — collections 모듈 다섯 도구
9. 여덟째 — collections.abc
10. 한 줄 분해
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요.

지난 H1 회수. 네 친구 — list, tuple, dict, set.

이번 H2는 8개념 깊이.

오늘의 약속. **본인이 자료구조의 90% 메서드를 만집니다**.

자, 가요.

---

## 2. 첫째 — list 메서드 열 가지

```python
cats = ["까미", "노랭이"]

cats.append("미니")            # 끝에 추가
cats.insert(0, "본인")         # 위치 삽입
cats.remove("노랭이")          # 값으로 제거
cats.pop()                     # 끝 제거 + 반환
cats.pop(0)                    # 위치 제거 + 반환
cats.index("까미")             # 위치 찾기
cats.count("까미")             # 등장 횟수
cats.sort()                    # 제자리 정렬
cats.reverse()                 # 제자리 역순
cats.copy()                    # 얕은 복사
```

열 가지. 자경단 매일.

---

## 3. 둘째 — list slicing 다섯 패턴

```python
nums = [0, 1, 2, 3, 4, 5]

nums[1:4]      # [1, 2, 3]  start:stop
nums[:3]       # [0, 1, 2]  처음부터
nums[3:]       # [3, 4, 5]  끝까지
nums[::2]      # [0, 2, 4]  step 2
nums[::-1]     # [5, 4, 3, 2, 1, 0]  역순
```

다섯 패턴. 매일.

---

## 4. 셋째 — tuple unpacking

```python
point = (1, 2)
x, y = point   # x=1, y=2

a, b, c = (10, 20, 30)
a, *rest = (1, 2, 3, 4)   # a=1, rest=[2,3,4]
*head, last = (1, 2, 3, 4)
```

tuple unpacking은 list에도 적용.

```python
first, second, *rest = [1, 2, 3, 4, 5]
```

자경단 매일.

---

## 5. 넷째 — dict 메서드와 comprehension

```python
ages = {"까미": 3, "노랭이": 2}

ages.get("미니")              # None (없으면)
ages.get("미니", 0)           # 0 (default)
ages.setdefault("미니", 4)    # 없으면 추가
ages.update({"깜장이": 5})    # 다른 dict 합치기
ages.pop("까미")              # 제거 + 반환
list(ages.keys())             # key 목록
list(ages.values())           # value 목록
list(ages.items())            # (key, value) 쌍
```

dict comp.

```python
{k: v*2 for k, v in ages.items()}
{k: v for k, v in ages.items() if v >= 3}
```

자경단 매일.

---

## 6. 다섯째 — set 연산 다섯 가지

```python
a = {1, 2, 3}
b = {2, 3, 4}

a | b   # union {1, 2, 3, 4}
a & b   # intersection {2, 3}
a - b   # difference {1}
a ^ b   # symmetric difference {1, 4}
a <= b  # subset
```

다섯 연산. 매일 멤버십 + intersection.

---

## 7. 여섯째 — frozen 자료구조

immutable 버전.

```python
fs = frozenset([1, 2, 3])
# fs.add(4)   # AttributeError
```

frozenset은 dict의 key 가능.

```python
groups = {
    frozenset(["까미", "노랭이"]): "고양이",
    frozenset(["뽀삐"]): "강아지",
}
```

@dataclass(frozen=True)도 비슷.

---

## 8. 일곱째 — collections 모듈 다섯 도구

```python
from collections import (
    Counter,
    defaultdict,
    OrderedDict,
    deque,
    namedtuple,
)

# Counter — 빈도수
Counter("hello")   # {'l': 2, 'h': 1, 'e': 1, 'o': 1}
Counter("hello").most_common(2)   # 상위 2개

# defaultdict — 기본값
d = defaultdict(list)
d["cats"].append("까미")   # KeyError 없음

# deque — 양방향 큐 (O(1) appendleft)
q = deque([1, 2, 3])
q.appendleft(0)

# namedtuple — 이름 있는 tuple
Point = namedtuple("Point", ["x", "y"])
p = Point(1, 2)
p.x   # 1

# OrderedDict — 순서 보장 dict (3.7부터 일반 dict도)
```

다섯 도구. 자경단 매일.

---

## 9. 여덟째 — collections.abc

추상 베이스 클래스. 자료구조 인터페이스.

```python
from collections.abc import Iterable, Mapping, Sequence

def process(items):
    if isinstance(items, Mapping):
        ...   # dict-like
    elif isinstance(items, Sequence):
        ...   # list-like
    elif isinstance(items, Iterable):
        ...   # 일반 iterable
```

자경단 가끔. 함수 인자 type check.

---

## 10. 한 줄 분해

```python
{k: sum(v) / len(v) for k, v in groupby_dict.items()}
```

dict comp + sum + len + .items(). 자경단 매일.

---

## 11. 흔한 오해 다섯 가지

**오해 1: dict 순서 무작위.**

3.7+ insertion order.

**오해 2: list.sort vs sorted.**

sort는 제자리, sorted는 새 list.

**오해 3: tuple은 list보다 느림.**

immutable이라 더 빠름.

**오해 4: set은 list 대체.**

unique + 빠른 멤버십. 다른 용도.

**오해 5: namedtuple은 옛 도구.**

dataclass와 공존. immutable 필요 시 namedtuple.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. list와 tuple 언제?**

변하면 list, 변하지 않으면 tuple.

**Q2. dict.get vs []?**

[]는 KeyError, get은 default.

**Q3. set 정렬?**

순서 없음. sorted(set)으로.

**Q4. defaultdict vs setdefault?**

defaultdict가 더 깔끔.

**Q5. Counter 매일?**

빈도 분석 매일.

---

## 13. 흔한 실수 다섯 + 안심 — 핵심 학습 편

첫째, list 슬라이싱 헷갈림. 안심 — `[start:stop:step]`.
둘째, dict 순서 의존. 안심 — Python 3.7+ 삽입 순서 보장.
셋째, set 자동 중복 제거 무지. 안심 — `set([1,1,2])` = {1,2}.
넷째, tuple immutable 의미. 안심 — 한 번 만들면 변경 X.
다섯째, 가장 큰 — collection 메서드 다 외움. 안심 — append/pop/get 셋.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 14. 마무리

자, 두 번째 시간 끝.

list 메서드 10, slicing 5, tuple unpacking, dict comp, set 5, frozen, collections 5, abc.

다음 H3는 디버깅 도구.

```python
python3 -c 'from collections import Counter; print(Counter("자경단자경단").most_common(3))'
```

---

## 👨‍💻 개발자 노트

> - list dynamic array: 1.125x growth. amortized O(1) append.
> - tuple internal: PyTuple struct. C array.
> - dict open addressing: 빈 bucket 찾기. resize at 2/3 load.
> - set hash table: dict 비슷. value 없음.
> - frozenset: hashable. dict key.
> - 다음 H3 키워드: rich · json · pprint · collections.abc 검사.
