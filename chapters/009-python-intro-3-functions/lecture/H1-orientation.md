# Ch009 · H1 — Python 함수 오리엔테이션 — 코드 재사용을 만드는 도구

> 고양이 자경단 · Ch 009 · 1교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — Ch008 회수와 오늘의 약속
2. 함수가 무엇인가 — 코드 재사용의 시작
3. 옛날 이야기 — 제가 처음 함수를 짠 그 날
4. 왜 함수인가 — 일곱 가지 이유
5. 같이 쳐 보기 — 다섯 줄 함수
6. 네 친구 — def·return·*args·**kwargs
7. 0.001초의 여행 — 함수 호출 5단계
8. 함수의 다섯 종류
9. 자경단 다섯 명의 매일 함수
10. 8교시 미리보기
11. 함수 60년 — Lambda calculus부터 async/await까지
12. AI 시대의 함수
13. 자주 받는 질문 다섯 가지
14. 흔한 오해 다섯 가지
15. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
def greet(name: str) -> str:
    return f"안녕 {name}!"

def sum_all(*args):
    return sum(args)

def make_user(**kwargs):
    return kwargs

double = lambda x: x * 2
```

---

## 1. 다시 만나서 반가워요 — Ch008 회수와 오늘의 약속

자, 안녕하세요. 9번째 챕터예요. 두 주 만이죠.

지난 Ch008 회수. 제어 흐름이 코드의 60%. if·for·while·comprehension. 환율 계산기 v2 150줄.

이번 Ch009는 함수예요. Ch007에서 살짝 만났지만 본격은 이번. 다섯 줄 함수부터 30줄 클로저까지.

오늘의 약속. **본인이 함수의 모든 종류를 만나고, 본인의 첫 데코레이터를 짭니다**.

자, 가요.

---

## 2. 함수가 무엇인가 — 코드 재사용의 시작

함수는 코드 묶음에 이름 붙이는 것. 이름 부르면 묶음 실행.

```python
def greet(name):
    return f"안녕 {name}!"

greet("까미")
greet("노랭이")
```

같은 묶음을 다른 인자로 여러 번. 그게 재사용이에요.

함수가 없으면. 매번 같은 코드 복붙. 100명이면 100번. 하나 고치려면 100곳 수정.

함수가 있으면. 한 번 짜고 100번 호출. 하나 고치면 100곳 자동 적용.

자경단 까미가 매일 짜는 함수가 평균 30개. 그 30개를 하루에 1,000번 호출. 호출이 자동 코드 재사용.

---

## 3. 옛날 이야기 — 제가 처음 함수를 짠 그 날

옛날 이야기 하나. 제가 처음 함수를 짠 날. 12년 전.

회사에서 같은 코드 다섯 줄을 100곳에 복붙하고 있었어요. 사수 형이 보고 "함수로 묶어" 한 줄. 저는 처음 def를 쳤어요. 다섯 줄을 함수 안에 넣고, 100곳을 함수 호출로 변경. 코드가 절반으로 줄었어요.

그날 저는 "재사용이 진짜 강력하구나" 깨달았어요. 그 후 매일 다섯 함수씩 짰어요. 1년 후 1,500함수. 5년 후 셀 수 없을.

그런데 정말 충격은 한 1년 후. 어느 날 후배가 200줄짜리 코드를 짜 왔어요. 같은 패턴이 다섯 번 반복. 저는 함수 하나로 줄여 줬어요. 200줄이 50줄로. 후배 충격. 본인도 8시간 후 같아요.

---

## 4. 왜 함수인가 — 일곱 가지 이유

**1. 재사용**. 한 번 짜고 평생 호출.

**2. 추상화**. 복잡한 로직을 한 이름으로.

**3. 테스트 가능**. 함수마다 pytest 케이스.

**4. 가독성**. `calculate_tax(amount)`이 5줄 코드보다 명확.

**5. 합의**. 다섯 명이 같은 함수 호출.

**6. AI 시대**. AI가 함수 단위로 짜고 리뷰.

**7. 면접 단골**. 함수 설계 질문 50%.

일곱 이유. **함수는 본인 코드의 단위**.

---

## 5. 같이 쳐 보기 — 다섯 줄 함수

> ▶ **같이 쳐보기** — 본인의 첫 함수
>
> ```python
> def greet(name: str, age: int = 0) -> str:
>     if age > 0:
>         return f"안녕 {name} ({age}살)!"
>     return f"안녕 {name}!"
> 
> print(greet("까미"))
> print(greet("노랭이", age=2))
> ```

다섯 줄에 함수의 모든 핵심. type hints, default 인자, 조건 분기, return.

```
안녕 까미!
안녕 노랭이 (2살)!
```

---

## 6. 네 친구 — def·return·*args·**kwargs

함수의 네 친구.

**def**. 함수 정의 키워드.

```python
def add(a, b):
    return a + b
```

**return**. 함수 결과 반환.

```python
def first_or_none(items):
    if not items:
        return None
    return items[0]
```

return 없으면 자동으로 None.

***args**. 가변 인자 (위치).

```python
def sum_all(*args):
    return sum(args)

sum_all(1, 2, 3)        # 6
sum_all(1, 2, 3, 4, 5)  # 15
```

**\*\*kwargs**. 가변 인자 (이름).

```python
def make_user(**kwargs):
    return kwargs

make_user(name="까미", age=3)
```

네 친구. 함수의 토대.

---

## 7. 0.001초의 여행 — 함수 호출 5단계

본인이 `greet("까미")` 한 줄 실행하면.

**1. 인자 평가**. "까미" 평가.

**2. 새 frame 생성**. 함수 안 변수 공간.

**3. 인자 binding**. name = "까미".

**4. 함수 본문 실행**.

**5. frame 제거 + 결과 반환**.

5단계. 0.001초. CPython의 frame 메커니즘. H7에서 깊이.

---

## 8. 함수의 다섯 종류

**1. 일반 함수** (def). 가장 자주.

**2. lambda**. 익명 함수, 한 줄.

```python
double = lambda x: x * 2
sorted(cats, key=lambda c: c.age)
```

**3. closure**. 함수 안의 함수, 외부 변수 캡처.

```python
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment

counter = make_counter()
counter()  # 1
counter()  # 2
```

**4. decorator**. 함수를 감싸는 함수.

```python
@timer
def slow_function():
    ...
```

**5. generator** (yield). H7에서.

다섯 종류. 매일 1, 2번이 95%.

---

## 9. 자경단 다섯 명의 매일 함수

**까미**. 매일 30개. 백엔드 endpoint.

**노랭이**. 매일 20개. React component.

**미니**. 매일 25개. AWS 자동화.

**깜장이**. 매일 15개. 테스트 케이스.

**본인**. 매일 35개. 다양한 리뷰.

다섯 명 합치면 매일 125개. 1년 45,000개.

---

## 10. 8교시 미리보기

H2 — 8개념. def, return, default, *args, **kwargs, lambda, closure, decorator.

H3 — 디버깅. inspect, dis, profile.

H4 — 18 도구. functools, partial, reduce, lru_cache.

H5 — 30분 데모. v2 → v3. 데코레이터 적용.

H6 — 운영. SOLID, DRY, 명명 규칙.

H7 — 깊이. frame, closure 내부.

H8 — 적용. Ch010 collections와 다리.

---

## 11. 함수 60년

1936년. Alonzo Church의 lambda calculus.

1958년. LISP. 함수형 프로그래밍.

1972년. C 언어. 함수 표준화.

1991년. Python 0.9. def 문법.

2007년. Python 2.5. with 문.

2014년. Python 3.5. async/await.

2018년. Python 3.7. dataclass.

2024년. AI 함수 추천.

---

## 12. AI 시대의 함수

AI가 함수 단위로 일해요. 본인이 함수 이름과 시그니처 적으면 AI가 본문 채움.

자경단의 80/20. 본인이 80% 시그니처, AI가 20% 본문.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. 함수 길이?**

5~30줄. 평균 15줄.

**Q2. lambda vs def?**

한 줄까지 lambda.

**Q3. *args, **kwargs 매번?**

특수. 보통 명시 인자.

**Q4. closure 어디서?**

decorator, partial, factory.

**Q5. 8시간 길어요.**

함수는 코드의 단위. 깊이 한 번.

---

## 14. 흔한 오해 다섯 가지

**오해 1: 함수는 단순.**

표면은 단순, 내부는 깊음.

**오해 2: lambda 모든 곳.**

한 줄까지. 그 이상 def.

**오해 3: closure는 시니어 도구.**

신입도. decorator 만들 때.

**오해 4: decorator는 마법.**

함수를 감싸는 함수.

**오해 5: type hints 옵션.**

자경단 표준 항상.

---

## 15. 흔한 실수 다섯 + 안심 — Python 함수 학습 편

첫째, 함수 안 만들고 한 흐름. 안심 — 20줄 넘으면 함수.
둘째, 인자·반환 타입 무시. 안심 — type hint 첫날.
셋째, mutable 기본값. 안심 — `def fn(x=None)`.
넷째, return 없는 함수. 안심 — None 반환 명시.
다섯째, 가장 큰 — 함수 docstring 빈칸. 안심 — 한 줄 표준.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 16. 마무리

자, 첫 시간 끝.

함수 = 코드 재사용. 네 친구. 다섯 종류. 자경단 매일 125개.

다음 H2는 8개념 깊이.

```python
python3 -c 'def f(x, y=10): return x*y
print(f(5)); print(f(5, 20))'
```

---

## 👨‍💻 개발자 노트

> - lambda calculus: Church 1936. 계산 가능 함수의 수학적 토대.
> - first-class function: Python 함수는 객체. 변수에 할당 가능.
> - frame 객체: 함수 호출마다 새 frame.
> - closure + nonlocal: 외부 변수 캡처와 수정.
> - decorator PEP 318: 2.4+. @ 문법.
> - 다음 H2 키워드: def · return · default · *args · **kwargs · lambda · closure · decorator.
