# Ch009 · H6 — pure function·SOLID·DRY·함수 합성 — 자경단 운영

> 고양이 자경단 · Ch 009 · 6교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. pure function — 부수 효과 없는 함수
3. SOLID 다섯 원칙
4. DRY — Don't Repeat Yourself
5. KISS — Keep It Simple
6. 함수 합성 — compose 패턴
7. 함수 명명 규칙 다섯 가지
8. 자경단 매일 코드 리뷰
9. 다섯 함정과 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요.

지난 H5 회수. v3로 진화. 데코레이터 3, closure, @dataclass.

이번 H6는 함수 운영 원칙. pure function, SOLID, DRY, 합성.

오늘의 약속. **본인 함수의 90%가 자경단 표준 운영 코드로 변합니다**.

자, 가요.

---

## 2. pure function — 부수 효과 없는 함수

pure function 두 조건. 같은 입력이면 항상 같은 출력. 외부 상태 안 바꿈.

**Pure**

```python
def add(a, b):
    return a + b
```

**Impure** (전역 변수 수정)

```python
total = 0
def add_to_total(x):
    global total
    total += x
    return total
```

자경단 표준 — 가능한 한 pure. 80% 함수가 pure이면 5년 사고 절감.

pure function의 다섯 효과. 첫째, 테스트 쉬움. 둘째, 캐싱 가능 (lru_cache). 셋째, 병렬 실행 안전. 넷째, 디버깅 쉬움. 다섯째, 추론 가능.

---

## 3. SOLID 다섯 원칙

함수와 클래스의 다섯 원칙. (자세한 건 Ch017 OOP에서.)

**S — Single Responsibility**. 한 함수 한 책임.

**O — Open/Closed**. 확장 가능, 수정 닫힘.

**L — Liskov Substitution**. 서브타입 대체 가능.

**I — Interface Segregation**. 작은 인터페이스.

**D — Dependency Inversion**. 추상화 의존.

함수에 적용은 첫째 (S)가 가장 중요. 한 함수 한 일.

```python
# Bad — 두 일
def get_and_save(user_id):
    user = db.get(user_id)
    save_to_file(user)
    return user

# Good — 두 함수
def get_user(user_id):
    return db.get(user_id)

def save_user(user):
    save_to_file(user)
```

---

## 4. DRY — Don't Repeat Yourself

같은 코드 두 번 적으면 함수로.

**Bad**

```python
def process_user(user):
    if user.age >= 18 and user.is_active and not user.is_banned:
        ...

def show_user(user):
    if user.age >= 18 and user.is_active and not user.is_banned:
        ...
```

**Good**

```python
def is_eligible(user):
    return user.age >= 18 and user.is_active and not user.is_banned

def process_user(user):
    if is_eligible(user):
        ...

def show_user(user):
    if is_eligible(user):
        ...
```

조건도 함수로. 한 곳 수정으로 전체 적용.

자경단 매일. 두 번 복붙하면 함수.

---

## 5. KISS — Keep It Simple

단순함이 답. 짧을수록 좋음. 명료할수록 좋음.

**Bad** (너무 영리)

```python
result = (lambda x: x*2 if x>0 else -x)(value)
```

**Good** (단순)

```python
def double_or_abs(x):
    return x * 2 if x > 0 else -x

result = double_or_abs(value)
```

영리한 한 줄보다 명료한 두 줄.

---

## 6. 함수 합성 — compose 패턴

함수를 chain으로 연결.

```python
def compose(*fns):
    """f(g(h(x))) 같은 합성."""
    def composed(x):
        result = x
        for fn in reversed(fns):
            result = fn(result)
        return result
    return composed

# 사용
double = lambda x: x * 2
add5 = lambda x: x + 5
to_str = str

f = compose(to_str, add5, double)
f(3)   # str(add5(double(3))) = str(11) = "11"
```

함수형 프로그래밍의 패턴. 자경단 가끔.

pipe도 비슷.

```python
def pipe(*fns):
    """h(g(f(x))) — 왼쪽에서 오른쪽."""
    def piped(x):
        result = x
        for fn in fns:
            result = fn(result)
        return result
    return piped
```

---

## 7. 함수 명명 규칙 다섯 가지

**1. snake_case**. `calculate_tax`, `find_user_by_id`.

**2. 동사로 시작**. get, set, find, create, update, delete, calculate, validate.

**3. is_/has_/should_** for bool. `is_active`, `has_permission`.

**4. _private** prefix. `_internal_helper`.

**5. 의미 있게**. `f`, `g`, `tmp` 피하기. `count`, `result`도 모호.

다섯 규칙. 자경단 표준.

---

## 8. 자경단 매일 코드 리뷰

PR 리뷰 시 함수 다섯 점검.

**1. 길이**. 30줄 이상이면 분리.

**2. 인자 수**. 4개 이상이면 dataclass.

**3. 부수 효과**. pure인지.

**4. 이름**. 함수 이름이 한 줄 설명인지.

**5. 테스트**. pytest 케이스 있는지.

다섯 점검. 자경단 PR 표준.

---

## 9. 다섯 함정과 처방

**함정 1: 50줄 함수**

처방. SRP로 분리.

**함정 2: 인자 7개**

처방. dataclass.

**함정 3: 글로벌 수정**

처방. 인자로 받기.

**함정 4: 같은 코드 5곳**

처방. 함수 추출.

**함정 5: 함수 이름 abc**

처방. 의미 있는 이름.

---

## 10. 흔한 오해 다섯 가지

**오해 1: pure는 옵션.**

자경단 80% pure 표준.

**오해 2: SOLID는 클래스만.**

함수에도 SRP 적용.

**오해 3: DRY 항상.**

너무 일찍 추상화 사고. 세 번 반복 후 추출.

**오해 4: KISS는 시니어 룰.**

신입부터.

**오해 5: 합성은 어렵다.**

compose/pipe 한 번 익히면 강력.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. pure 함수만 쓰면?**

I/O는 impure. 80%만 pure 목표.

**Q2. SOLID 매번?**

SRP만 매일. 나머지 OOP에서.

**Q3. DRY와 KISS 충돌?**

KISS가 우선. 너무 추상화하지 마.

**Q4. compose vs pipe?**

선호 차이. pipe가 더 직관적.

**Q5. 함수 이름 영어?**

자경단 표준 영어. 도메인 용어는 한글 OK.

---

## 12. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, type hint 미루기. 안심 — 공개부터.
둘째, docstring 빈칸. 안심 — 한 줄.
셋째, mypy 안 돌림. 안심 — pre-commit.
넷째, signature 변경 시 호출처. 안심 — IDE refactor.
다섯째, 가장 큰 — pytest 안 씀. 안심 — 한 함수 한 테스트.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 여섯 번째 시간 끝.

pure function, SOLID, DRY, KISS, 합성, 명명 규칙. 자경단 매일 운영.

다음 H7은 깊이. CPython frame, closure 내부, GIL.

```bash
ruff check exchange_v3.py
mypy --strict exchange_v3.py
```

---

## 👨‍💻 개발자 노트

> - pure function: referential transparency. 결과로 호출 대체 가능.
> - SOLID: Robert Martin의 객체지향 다섯 원칙.
> - DRY rule of three: 두 번 복붙 OK, 세 번부터 추출.
> - KISS: Kelly Johnson 1960. 단순함이 가장 강력.
> - compose vs pipe: 수학 vs 흐름. pipe가 모던.
> - 다음 H7 키워드: CPython frame · closure cell · GIL · async event loop.
