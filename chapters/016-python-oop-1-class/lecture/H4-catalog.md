# Ch016 · H4 — 30 dunder method 카탈로그

> 고양이 자경단 · Ch 016 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수
2. dunder 30 한 표
3. 표현 무리 5
4. 비교 무리 6
5. 산술 무리 6
6. 컨테이너 무리 5
7. 호출 무리 5
8. 자경단 매일 13줄
9. 흔한 오해
10. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수

자, 안녕하세요.

지난 H3 회수. VS Code 도구.

이번 H4는 30 dunder.

자, 가요.

---

## 2. dunder 30 한 표

| 무리 | 메서드 |
|------|--------|
| 표현 5 | `__str__`, `__repr__`, `__format__`, `__bytes__`, `__hash__` |
| 비교 6 | `__eq__`, `__lt__`, `__le__`, `__gt__`, `__ge__`, `__ne__` |
| 산술 6 | `__add__`, `__sub__`, `__mul__`, `__truediv__`, `__mod__`, `__pow__` |
| 컨테이너 5 | `__len__`, `__getitem__`, `__setitem__`, `__contains__`, `__iter__` |
| 호출 5 | `__call__`, `__enter__`, `__exit__`, `__init__`, `__new__` |

매일 12, 주간 8, 월간 10.

---

## 3. 표현 무리 5

```python
class Cat:
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return f"Cat({self.name!r})"
    def __str__(self):
        return f"고양이 {self.name}"

c = Cat("까미")
repr(c)   # "Cat('까미')"
str(c)    # "고양이 까미"
```

자경단 표준 — `__repr__` 필수.

---

## 4. 비교 무리 6

```python
from functools import total_ordering

@total_ordering
class Cat:
    def __init__(self, age):
        self.age = age
    def __eq__(self, other):
        return self.age == other.age
    def __lt__(self, other):
        return self.age < other.age
```

@total_ordering이 나머지 자동.

---

## 5. 산술 무리 6

```python
class Vector:
    def __init__(self, x, y):
        self.x, self.y = x, y
    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)
    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)

Vector(1,2) + Vector(3,4)
```

NumPy의 비결.

---

## 6. 컨테이너 무리 5

```python
class Vigilante:
    def __init__(self):
        self.cats = []
    def __len__(self):
        return len(self.cats)
    def __getitem__(self, i):
        return self.cats[i]
    def __contains__(self, name):
        return any(c.name == name for c in self.cats)
    def __iter__(self):
        return iter(self.cats)
```

본인 클래스를 list 비슷하게.

---

## 7. 호출 무리 5

```python
class Counter:
    def __init__(self):
        self.n = 0
    def __call__(self):
        self.n += 1
        return self.n

class DB:
    def __enter__(self):
        return self
    def __exit__(self, *args):
        pass
```

context manager. 자경단 매일.

---

## 8. 자경단 매일 13줄

```python
from dataclasses import dataclass
from functools import total_ordering

@dataclass
@total_ordering
class Cat:
    name: str
    age: int
    
    def __lt__(self, other):
        return self.age < other.age
```

자경단 표준.

---

## 9. 흔한 오해

**오해 1: 30 다 외워.** 매일 5개.

**오해 2: dunder 시니어.** `__init__`, `__repr__` 신입도.

**오해 3: @dataclass 무거움.** 가벼움.

**오해 4: total_ordering 비싸.** 한 번만.

**오해 5: 모든 클래스에 __hash__.** dict key 필요할 때만.

---

## 10. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, 30 dunder 다 외움. 안심 — 매일 5.
둘째, dunder 시니어. 안심 — `__init__`, `__repr__` 신입.
셋째, total_ordering 비싸. 안심 — 한 번만.
넷째, 모든 클래스 __hash__. 안심 — dict key만.
다섯째, 가장 큰 — dataclass 옵션. 안심 — boilerplate 자동.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 네 번째 시간 끝.

30 dunder 5 무리.

다음 H5는 30분 데모.

---

## 👨‍💻 개발자 노트

> - dunder 전체: docs.python.org/3/reference/datamodel.html.
> - functools.total_ordering.
> - 다음 H5 키워드: 자경단 v6 · OOP 재작성.
