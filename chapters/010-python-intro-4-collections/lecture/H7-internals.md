# Ch010 · H7 — collections 내부 — hash·dict resizing·list array

> 고양이 자경단 · Ch 010 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. dict 내부 — hash table
3. dict resizing
4. list 내부 — dynamic array
5. set 내부
6. tuple 내부
7. hash 함수
8. 자경단 매일의 메모리 그림
9. 흔한 오해 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요.

지난 H6 회수. 자료구조 선택 5 패턴, 성능 비교.

이번 H7은 깊이.

오늘의 약속. **본인이 dict의 O(1) 비결을 이해합니다**.

자, 가요.

---

## 2. dict 내부 — hash table

dict는 hash table. key를 hash 함수로 정수로 변환. 그 정수를 table 인덱스로.

```python
ages = {"까미": 3, "노랭이": 2}

# 내부적으로
# 1. hash("까미") = 12345
# 2. 12345 % table_size = bucket_index
# 3. bucket에 ("까미", 3) 저장
```

검색도 O(1).

```python
ages["까미"]
# 1. hash("까미") = 12345
# 2. bucket_index 계산
# 3. bucket에서 "까미" 매치
# 4. 3 반환
```

충돌 처리. open addressing. 충돌 시 다음 빈 bucket.

Python 3.7+ insertion order 보장. compact dict 구현.

---

## 3. dict resizing

dict의 load factor가 2/3 넘으면 resize.

```python
d = {}
# 처음엔 8 bucket
# 5번째 insert 후 (5/8 > 2/3 안 됨, 그래서 OK)
# 6번째 insert 시 (6/8 > 2/3, resize 트리거)
# 새 table 16 bucket 생성. 모든 key를 새 위치로.
```

resize 비용 O(n). 그러나 매번 안 일어남. amortized O(1).

자경단 매일 — dict 1만 항목 넣어도 resize 약 14번. 무시 가능.

---

## 4. list 내부 — dynamic array

list는 dynamic array. 연속 메모리.

```c
// CPython 내부
typedef struct {
    PyObject_VAR_HEAD
    PyObject **ob_item;       // 포인터 배열
    Py_ssize_t allocated;     // 할당된 크기
} PyListObject;
```

`ob_item`이 PyObject 포인터의 배열.

append O(1). 끝에 새 요소.

```python
lst = []
for i in range(10):
    lst.append(i)
```

allocated가 차면 1.125배 늘림. 8 → 9 → 10 → 12 → 13 → 14 → 15.

insert(0, x) O(n). 모든 요소를 한 칸 뒤로.

자경단의 표준 — 끝에 추가는 list, 앞에 추가는 deque.

---

## 5. set 내부

set은 dict 비슷. value 없는 hash table.

```c
typedef struct {
    Py_hash_t hash;
    PyObject *key;
} setentry;
```

dict보다 살짝 가벼움. 같은 알고리즘.

`in` 연산자가 O(1). list보다 100배 빠름 (1만 항목 기준).

```python
import timeit

# list
timeit.timeit("100 in lst", setup="lst=list(range(1000))", number=10000)
# 약 12ms

# set
timeit.timeit("100 in s", setup="s=set(range(1000))", number=10000)
# 약 0.1ms
```

100배 차이.

---

## 6. tuple 내부

tuple은 immutable. PyTupleObject. C 배열 한 번에 할당.

```c
typedef struct {
    PyObject_VAR_HEAD
    PyObject *ob_item[1];   // 가변 길이
} PyTupleObject;
```

list보다 가벼움. 메모리 한 chunk.

```python
import sys
sys.getsizeof((1, 2, 3))   # 64 bytes
sys.getsizeof([1, 2, 3])   # 88 bytes
```

tuple이 24 bytes 적음. 1만 tuple이면 240KB 절감.

immutable이라 hashable. dict의 key 가능.

---

## 7. hash 함수

hash()의 동작.

```python
hash(5)        # 5 (int는 자기 자신)
hash("hello")  # 큰 정수 (Python 시작마다 다름)
hash((1, 2))   # tuple은 요소 hash 조합
hash([1, 2])   # TypeError (mutable은 unhashable)
```

PYTHONHASHSEED로 매번 다름. hash collision 공격 방지.

```bash
PYTHONHASHSEED=0 python3 -c "print(hash('hello'))"
# 0이면 deterministic
```

자경단 매일 — hash 직접 안 만짐. dict가 자동.

---

## 8. 자경단 매일의 메모리 그림

본인이 자경단 코드 한 줄.

```python
cats = {"까미": 3, "노랭이": 2, "미니": 4, "깜장이": 5, "본인": 1}
```

내부에서.

```
PyDictObject:
  ma_keys → [hash, "까미"] [hash, "노랭이"] ...
  ma_values → 3, 2, 4, 5, 1

각 string도 PyUnicodeObject (한 객체)
각 int도 PyLongObject (단, -5~256은 캐싱)
```

총 메모리. dict 232 bytes + 5 string × 약 60 bytes + 5 int (캐싱이라 0).

자경단 5명 데이터가 약 532 bytes.

---

## 9. 흔한 오해 다섯 가지

**오해 1: dict 항상 O(1).**

worst case O(n). 그러나 거의 안 일어남.

**오해 2: list 끝 추가 비싸다.**

amortized O(1).

**오해 3: tuple 빠름.**

immutable이라 살짝.

**오해 4: hash 매번 같다.**

PYTHONHASHSEED.

**오해 5: set은 dict의 키.**

set은 hashable, dict.keys()는 view.

---

## 10. 흔한 실수 다섯 + 안심 — 깊이 학습 편

첫째, hash table 깊이까지. 안심 — 시간 복잡도만.
둘째, 메모리 layout 다 외움. 안심 — 추후 Ch026.
셋째, CPython 내부 다 봄. 안심 — 표면만.
넷째, big-O 무지성. 안심 — list O(n), dict O(1).
다섯째, 가장 큰 — 깊이 강박. 안심 — 표면이 80%.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 일곱 번째 시간 끝.

dict hash table, resizing, list array, set, tuple, hash 함수.

다음 H8은 적용 + 회고.

```python
import sys
print(sys.getsizeof({}), sys.getsizeof([]), sys.getsizeof(()), sys.getsizeof(set()))
```

---

## 👨‍💻 개발자 노트

> - PEP 468: dict insertion order 3.7+.
> - compact dict: PyPy에서 시작, CPython 3.6+.
> - hash randomization: PYTHONHASHSEED.
> - list growth factor: 1.125.
> - 다음 H8 키워드: 7H 회고 · v4 · Ch011 다리.
