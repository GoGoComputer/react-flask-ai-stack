# Ch008 · H2 — 제어 흐름 8개념 — if 5패턴부터 comprehension 4종까지

> 고양이 자경단 · Ch 008 · 2교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. 첫째 — if/elif/else 다섯 패턴
3. 둘째 — truthy/falsy 일곱 가지 깊이
4. 셋째 — for + iterable 다섯 종류
5. 넷째 — while과 walrus 연산자
6. 다섯째 — break/continue/for+else
7. 여섯째 — match-case 다섯 패턴
8. 일곱째 — comprehension 네 종류
9. 여덟째 — nested 흐름과 함정
10. 한 줄 분해 — 8개념을 한 줄에
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리 — 다음 H3에서 만나요

---

## 🔧 강사용 명령어 한눈에

```python
# if 5패턴
if x > 0: ...
if x: ...                    # truthy
match x:
    case 0: ...

# for + iterable
for x in items: ...
for i, x in enumerate(items): ...
for k, v in d.items(): ...

# comprehension 4종
[x*2 for x in xs]            # list
{x*2 for x in xs}            # set
{k:v for k,v in pairs}       # dict
(x*2 for x in xs)            # generator
```

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠.

지난 H1을 한 줄로 회수할게요. 제어 흐름이 본인 코드의 60%. 네 친구 — if·for·while·comprehension. 일곱 이유. 자경단 다섯 명이 매일 550번 흐름.

이번 H2는 그 네 친구를 8개념으로 깊이 만나는 시간이에요. if 5패턴, truthy/falsy, for+iterable, while+walrus, break/continue, match-case, comprehension 4종, nested. 한 시간 후 본인의 흐름 어휘가 90% 채워져요.

오늘의 약속은 한 가지예요. **본인이 H5에서 만날 환율 계산기 v2의 모든 흐름이 이 한 시간에 박힙니다**.

자, 가요.

---

## 2. 첫째 — if/elif/else 다섯 패턴

if는 가장 자주 만나는 친구. 다섯 패턴을 알면 자경단의 매일 if가 다 커버.

**1. 단일 if**

```python
if user.is_admin:
    grant_access()
```

조건이 참이면 한 일. 가장 단순.

**2. if/else**

```python
if age >= 18:
    label = "성인"
else:
    label = "미성년"
```

두 가지 분기.

**3. if/elif/else**

```python
if age >= 18:
    label = "성인"
elif age >= 13:
    label = "청소년"
else:
    label = "어린이"
```

세 가지 이상 분기.

**4. 삼항 연산자 (한 줄 if)**

```python
label = "성인" if age >= 18 else "미성년"
```

간단한 두 분기를 한 줄로. 자경단 매일 표현.

**5. 중첩 if**

```python
if user is not None:
    if user.is_active:
        if user.has_permission:
            access()
```

3단계 이상 중첩은 사고. early return으로 풀기 (H6에서).

다섯 패턴. 매일 1, 2, 3번이 90%. 4번은 짧은 식, 5번은 피해야 할 패턴.

> ▶ **같이 쳐보기** — if 다섯 패턴
>
> ```python
> python3
> >>> age = 20
> >>> if age >= 18: print("성인")
> >>> label = "성인" if age >= 18 else "미성년"
> >>> print(label)
> ```

---

## 3. 둘째 — truthy/falsy 일곱 가지 깊이

Python의 if 조건은 bool뿐만 아니라 모든 값을 평가해요. 어떤 값이 falsy인지 일곱 가지를 외워 두세요.

**Falsy (False로 평가)**

1. `False`
2. `None`
3. `0` (int)
4. `0.0` (float)
5. `""` (빈 문자열)
6. `[]` (빈 리스트)
7. `{}` (빈 dict)

이 일곱 가지가 모두 if에서 False로. 그 외는 다 truthy.

```python
if name:           # 빈 문자열 아니면
    ...
if items:          # 빈 리스트 아니면
    ...
if user_data:      # None도 빈 dict도 아니면
    ...
```

자경단의 매일 한 줄. `if x != ""` 안 써요. `if x`만 써요. Python 표준.

**함정 한 가지**. 0과 None을 구분해야 할 때.

```python
def get_age(user):
    return user.age   # None 또는 0 또는 양수

age = get_age(user)
if age:           # 위험! 0도 falsy.
    process(age)
if age is not None:  # 안전.
    process(age)
```

`is None` vs `if x`의 미묘한 차이. 0이 valid 값일 땐 항상 `is None`.

---

## 4. 셋째 — for + iterable 다섯 종류

Python의 for는 iterable이라는 객체를 순회해요. iterable의 다섯 종류를 알면 자경단의 매일 for가 다 커버.

**1. list**

```python
for cat in cats:
    print(cat)
```

가장 자주.

**2. dict**

```python
for cat, age in cats_dict.items():
    print(f"{cat}: {age}")

for cat in cats_dict.keys():
    ...
for age in cats_dict.values():
    ...
```

`.items()`로 (key, value) 쌍. `.keys()`, `.values()`도 가능.

**3. enumerate (인덱스 + 값)**

```python
for i, cat in enumerate(cats):
    print(f"{i+1}번째: {cat}")
```

`for i in range(len(cats))` 안 써요. `enumerate`가 표준.

**4. zip (여러 리스트 동시)**

```python
names = ["까미", "노랭이"]
ages = [3, 2]
for name, age in zip(names, ages):
    print(f"{name}는 {age}살")
```

**5. range (숫자 시퀀스)**

```python
for i in range(5):
    print(i)
# 0, 1, 2, 3, 4
```

`range(시작, 끝, 단계)`로 더 세밀하게.

다섯 종류. 매일 1, 3번이 80%. 2, 4번은 가끔. 5번은 횟수 반복용.

---

## 5. 넷째 — while과 walrus 연산자

while은 조건이 참인 동안 반복.

```python
count = 5
while count > 0:
    print(count)
    count -= 1
```

while을 자경단이 매일 쓰는 곳은 두 곳뿐이에요. 첫째, 알 수 없는 횟수의 반복. 둘째, 사용자 입력 받을 때.

```python
while True:
    answer = input("계속? (y/n): ")
    if answer == "n":
        break
```

`while True` + `break`가 표준 패턴.

**walrus 연산자 (`:=`)** Python 3.8+. while과 잘 어울려요.

```python
# Before
while True:
    line = f.readline()
    if not line:
        break
    process(line)

# walrus 사용
while line := f.readline():
    process(line)
```

`:=`가 "할당하면서 값 반환". 한 줄에 할당 + 조건. while 루프가 짧아져요. 자경단 표준.

---

## 6. 다섯째 — break/continue/for+else

루프 안에서 흐름을 미세 조정하는 세 키워드.

**break**. 루프 즉시 종료.

```python
for cat in cats:
    if cat == "찾는 cat":
        print("찾았다!")
        break
```

**continue**. 다음 iteration으로.

```python
for cat in cats:
    if cat.is_inactive:
        continue
    process(cat)
```

`if` + `continue`로 필터링.

**for + else**. 루프가 break 없이 끝나면 else 실행.

```python
for cat in cats:
    if cat.name == "찾는 cat":
        print("찾았다")
        break
else:
    print("못 찾았다")  # break 없이 끝남
```

생소한 패턴. 자경단도 가끔 만나요. "전체를 다 봤는데 못 찾은 경우"의 표준 양식.

---

## 7. 여섯째 — match-case 다섯 패턴

Python 3.10+의 새 무기. switch 문보다 강력해요.

**1. 값 매칭**

```python
match status:
    case 200:
        return "OK"
    case 404:
        return "Not Found"
    case _:
        return "Unknown"
```

`_`가 default.

**2. 여러 값 한 번에**

```python
match status:
    case 200 | 201 | 202:
        return "Success"
    case 400 | 404:
        return "Client Error"
```

`|`로 여러 값.

**3. tuple 매칭**

```python
match point:
    case (0, 0):
        return "원점"
    case (x, 0):
        return f"x축 ({x})"
    case (0, y):
        return f"y축 ({y})"
```

**4. dict 매칭**

```python
match data:
    case {"type": "cat", "name": name}:
        return f"고양이 {name}"
    case {"type": "dog"}:
        return "강아지"
```

**5. class 매칭**

```python
match shape:
    case Circle(radius=r):
        return 3.14 * r ** 2
    case Rectangle(w, h):
        return w * h
```

다섯 패턴. 자경단이 매일 1, 2번 자주, 3, 4번 가끔. 5번은 객체지향에서 (Ch016).

---

## 8. 일곱째 — comprehension 네 종류

본인의 흐름 도구의 정점. 네 가지.

**1. list comprehension**

```python
[x * 2 for x in xs]
```

`[표현식 for 변수 in iterable]`. 가장 자주.

**2. set comprehension**

```python
{x * 2 for x in xs}
```

`{}`로 감싸면 set. 중복 자동 제거.

**3. dict comprehension**

```python
{cat: len(cat) for cat in cats}
```

`{key: value for ...}`. dict 만들기.

**4. generator expression**

```python
(x * 2 for x in xs)
```

`()`로 감싸면 lazy. 메모리 효율. 큰 데이터에 강력.

각 comprehension에 if 필터를 추가할 수 있어요.

```python
[x for x in xs if x > 0]               # 양수만
{x for x in xs if x > 0}
{k: v for k, v in d.items() if v > 0}
(x for x in xs if x > 0)
```

자경단 매일 한 줄.

---

## 9. 여덟째 — nested 흐름과 함정

루프 안에 루프가 있을 때 주의 사항.

```python
matrix = [[1, 2, 3], [4, 5, 6]]
for row in matrix:
    for cell in row:
        print(cell)
```

2단계까지 OK. 3단계 넘으면 사고.

처방. 함수로 분리.

```python
def process_row(row):
    for cell in row:
        process_cell(cell)

for row in matrix:
    process_row(row)
```

또는 itertools.product (H4에서).

```python
from itertools import product
for row, cell in product(matrix, range(3)):
    ...
```

nested comprehension도 가능하지만 가독성 우선.

```python
flat = [cell for row in matrix for cell in row]
```

한 줄로 평탄화. 자경단 매일 패턴.

---

## 10. 한 줄 분해 — 8개념을 한 줄에

자경단의 매일 한 줄.

```python
[c.name for c in cats if c.age >= 3 and c.is_active]
```

이 한 줄을 풀어 보면.

`for c in cats` — for + iterable.
`if c.age >= 3 and c.is_active` — if + 비교 + and.
`c.name` — 표현식.
`[...]` — list comprehension.

8개념 중 4개가 한 줄에. 본인이 8시간 후엔 이런 한 줄을 5초에 짜요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: range가 list다.**

range는 iterable이지만 lazy. list가 아님. `list(range(5))`로 변환.

**오해 2: dict의 순서가 무작위다.**

Python 3.7+ insertion order 유지. 순서 있음.

**오해 3: comprehension은 항상 빠르다.**

작은 데이터는 비슷. 큰 데이터에서 generator가 메모리 효율.

**오해 4: match-case는 switch와 같다.**

다른 거예요. 패턴 매칭이라 더 강력.

**오해 5: while보다 for가 항상 좋다.**

90% 그래요. 5%는 while이 명확해요.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. comprehension 언제 쓰고 언제 안 쓰나요?**

데이터 변환 한 줄이면 comprehension. 부수 효과 (print 등) 있으면 일반 for.

**Q2. for+else 진짜 써요?**

자경단 가끔. "다 봤는데 못 찾음" 표현이 명확해서.

**Q3. match-case가 느린가요?**

switch 비교. 짧은 if/elif와 비슷. 패턴이 복잡할 때 더 빠름.

**Q4. nested comprehension 어디까지?**

2단계까지. 3단계는 함수 분리.

**Q5. walrus 어디서 자주?**

while 조건, list comp의 if, regex 매치 결과 등. 6주면 자연.

---

## 13. 흔한 실수 다섯 + 안심 — 핵심 개념 학습 편

첫째, 비교 연산자 `==` vs `is` 헷갈림. 안심 — `is`는 None만, 나머지는 `==`.
둘째, truthy/falsy 무지성 단정. 안심 — 빈 list·dict·set·str은 False, 0도 False.
셋째, list comprehension 한 줄 욕심. 안심 — 3중 이상은 for 두 줄.
넷째, range 마지막 포함 헷갈림. 안심 — `range(10)`는 0~9. 공식 한 번 외움.
다섯째, 가장 큰 함정 — break vs return 헷갈림. 안심 — break는 루프, return은 함수.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 14. 마무리 — 다음 H3에서 만나요

자, 두 번째 시간이 끝났어요. 60분 동안 본인은 8개념을 만나셨어요. 정리하면 이래요.

if 5패턴, truthy/falsy 7가지, for+iterable 5종, while+walrus, break/continue/for+else, match-case 5패턴, comprehension 4종, nested 흐름. 한 줄 분해 — `[c.name for c in cats if c.age >= 3 and c.is_active]`.

박수 한 번 칠게요.

다음 H3은 디버깅 셋업. VS Code 디버거, breakpoint(), pdb, rich.print, ipython. 한 시간 후 만나요.

그 전에 한 가지 부탁.

```python
python3 -c 'cats=["까미","노랭이","미니"]; [print(f"{i+1}: {c}") for i,c in enumerate(cats)]'
```

---

## 👨‍💻 개발자 노트

> - if 단축 평가: `a or b`는 a가 truthy면 a 반환, 아니면 b. `a and b`는 a가 falsy면 a, 아니면 b.
> - iterable vs iterator: iterable은 `__iter__` 가짐, iterator는 `__next__` 가짐. for는 iter() 호출.
> - dict.items() 메모리: view 객체. lazy. 큰 dict에서도 효율.
> - enumerate(start=1): 1부터 시작. 가독성.
> - zip의 짧은 쪽: zip은 가장 짧은 iterable에서 멈춤. itertools.zip_longest로 채우기.
> - walrus PEP 572: 3.8+. 논쟁 많았지만 표준화.
> - match-case PEP 634: 3.10+. structural pattern matching.
> - generator vs list: generator는 lazy, list는 eager. 큰 데이터는 generator.
> - 다음 H3 키워드: VS Code 디버거 · breakpoint · pdb · rich · ipython.
