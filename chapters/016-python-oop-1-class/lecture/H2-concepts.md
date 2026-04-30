# Ch016 · H2 — 클래스 8개념 — `__init__`·self·dunder·classmethod

> 고양이 자경단 · Ch 016 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수
2. `__init__` — 객체 초기화
3. self — 자기 자신
4. attribute 두 종류
5. method 세 종류
6. @property로 getter/setter
7. dunder method 다섯
8. 한 줄 분해
9. 흔한 오해
10. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수

자, 안녕하세요.

지난 H1 회수. OOP 네 친구. 자경단 다섯 마리가 객체.

이번 H2는 8개념 깊이.

오늘의 약속. **본인이 클래스의 표준 메서드를 손에 익힙니다**.

자, 가요.

---

## 2. `__init__` — 객체 초기화

```python
class Cat:
    def __init__(self, name, age=0):
        self.name = name
        self.age = age

까미 = Cat("까미", 3)
```

`Cat("까미", 3)`이 사실 `__init__` 호출. 생성자 아니에요. 진짜 생성자는 `__new__`. 99%는 `__init__`만.

자경단 매일.

---

## 3. self — 자기 자신

```python
class Cat:
    def greet(self):
        return f"안녕 {self.name}"

까미 = Cat()
까미.greet()
# 사실은 Cat.greet(까미)
```

self가 인스턴스. 메서드 첫 인자로 자동.

---

## 4. attribute 두 종류

```python
class Cat:
    species = "Felis catus"   # class attribute (공유)
    
    def __init__(self, name):
        self.name = name       # instance attribute (각자)

까미 = Cat("까미")
print(Cat.species)   # 'Felis catus'
print(까미.species)  # 'Felis catus' (공유)
print(까미.name)     # '까미' (자기만)
```

class attribute는 메모리 절감.

---

## 5. method 세 종류

```python
class Cat:
    def greet(self):                    # instance
        return self.name
    
    @classmethod
    def from_dict(cls, d):              # class
        return cls(d["name"])
    
    @staticmethod
    def is_valid_name(name):            # static
        return len(name) > 0
```

instance 매일, classmethod 가끔 (factory), staticmethod 거의 안.

---

## 6. @property로 getter/setter

```python
class Cat:
    def __init__(self, age):
        self._age = age
    
    @property
    def age(self):
        return self._age
    
    @age.setter
    def age(self, value):
        if value < 0:
            raise ValueError
        self._age = value
```

attribute처럼 보이지만 검증 가능.

---

## 7. dunder method 다섯

**`__init__`** — 초기화.
**`__repr__`** — `repr()`.
**`__str__`** — `print()`.
**`__eq__`** — `==`.
**`__len__`** — `len()`.

```python
class Cat:
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return f"Cat({self.name!r})"
    def __eq__(self, other):
        return self.name == other.name
```

자경단 표준 — 모든 클래스에 `__repr__`.

---

## 8. 한 줄 분해

```python
@dataclass
class Cat:
    name: str
    age: int = 0
```

dataclass가 `__init__`, `__repr__`, `__eq__` 자동.

---

## 9. 흔한 오해

**오해 1: self 명령어.** 관습.

**오해 2: dunder 다 외워.** 매일 5개.

**오해 3: classmethod 자주.** factory만.

**오해 4: @property 무거움.** 가벼움.

**오해 5: instance attribute 무겁다.** class가 절감.

---

## 10. 흔한 실수 다섯 + 안심 — 핵심 학습 편

첫째, self 명령어 가정. 안심 — 관습.
둘째, dunder 100 외움. 안심 — 매일 5.
셋째, classmethod 자주. 안심 — factory만.
넷째, @property 무거움. 안심 — 가벼움.
다섯째, 가장 큰 — dataclass 무지. 안심 — boilerplate 자동.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 두 번째 시간 끝.

`__init__`, self, attribute 둘, method 셋, @property, dunder 다섯.

다음 H3은 디버깅 도구.

```python
class Cat:
    def __init__(self, name): self.name = name
    def __repr__(self): return f"Cat({self.name!r})"
print(Cat("까미"))
```

---

## 👨‍💻 개발자 노트

> - dunder 100개. 매일 5.
> - dataclass PEP 557.
> - 다음 H3 키워드: VS Code · snippets · ipython.
