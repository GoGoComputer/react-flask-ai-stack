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

이번 H2는 그 네 친구를 8개념으로 깊이 만나는 시간이에요. if 5패턴, truthy/falsy, for+iterable, while+walrus, break/continue, match-case, comprehension 4종, nested. 한 시간 후 본인의 흐름 어휘가 90% 채워져요. H1에서 네 친구의 얼굴만 봤다면, 오늘은 한 명씩 깊이 사귀어요. 각 친구가 어떤 패턴으로 쓰이는지, 어떤 함정이 있는지까지요.

오늘의 약속은 한 가지예요. **본인이 H5에서 만날 환율 계산기 v2의 모든 흐름이 이 한 시간에 박힙니다**. 환율 계산기 v2는 while로 메뉴를 반복하고, match-case로 메뉴를 분기하고, for로 통화를 돌고, comprehension으로 히스토리를 변환해요. 오늘 배울 8개념이 거기 다 들어가요. 그러니까 오늘 배우는 게 추상적인 문법 공부가 아니에요. H5에서 본인이 직접 짤 코드의 부품들이에요. 오늘 부품을 하나씩 손에 쥐고, H5에서 조립해요. 부품 하나하나에 집중하세요.

자, 가요.

---

## 2. 첫째 — if/elif/else 다섯 패턴

if는 가장 자주 만나는 친구. 다섯 패턴을 알면 자경단의 매일 if가 다 커버. 그리고 if를 쓸 때 항상 콜론(:)을 잊지 마세요. `if 조건:` 다음에 콜론을 찍고, 다음 줄을 들여쓰기 해요. Ch007에서 배웠듯 Python은 들여쓰기가 문법이에요. 들여쓴 부분이 "조건이 참일 때 실행할 코드"예요. 콜론을 빠뜨리면 SyntaxError가 나요. 초보자가 가장 자주 하는 실수가 콜론 빠뜨리기예요. if·elif·else·for·while·match·case 다 콜론으로 끝나요. "콜론 찍고 들여쓰기"가 Python 제어 흐름의 기본 리듬이에요.

**1. 단일 if**

```python
if user.is_admin:
    grant_access()
```

조건이 참이면 한 일을 실행. 가장 단순한 패턴이에요.

**2. if/else**

```python
if age >= 18:
    label = "성인"
else:
    label = "미성년"
```

두 가지 분기. 참이면 이거, 아니면 저거.

**3. if/elif/else**

```python
if age >= 18:
    label = "성인"
elif age >= 13:
    label = "청소년"
else:
    label = "어린이"
```

세 가지 이상 분기. 여기서 elif는 "else if"의 줄임말이에요. 위 조건이 안 맞으면 그 다음 조건을 확인하고, 그것도 안 맞으면 또 다음. 위에서부터 차례로 내려가다가 처음 맞는 곳에서 멈춰요. 그래서 조건의 순서가 중요해요. 가장 구체적인 조건을 위에, 일반적인 걸 아래에 둬요. 만약 `age >= 13`을 `age >= 18`보다 위에 두면, 20살도 13 이상이라 "청소년"으로 잘못 분류돼요. 순서가 로직을 결정해요.

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

이 다섯 중에서 본인이 특히 주목할 게 4번 삼항 연산자와 5번 중첩 if예요. 둘은 정반대예요. 4번은 좋은 패턴이고 5번은 나쁜 패턴이에요. 삼항 연산자 `label = "성인" if age >= 18 else "미성년"`은 "간단한 두 분기"를 한 줄로 우아하게 표현해요. 변수에 조건에 따라 다른 값을 담을 때, if/else 네 줄을 쓰는 대신 한 줄로요. 영어처럼 "성인, 만약 18살 이상이면, 아니면 미성년"이라고 읽혀요. 자경단이 매일 쓰는 표현이에요. 반면 5번 중첩 if는 피해야 해요. if 안에 if 안에 if가 3단, 4단 쌓이면, 코드가 오른쪽으로 계단처럼 밀려나면서 읽기가 지옥이 돼요. 이걸 "화살표 안티패턴"이라고도 불러요. 코드가 화살표(>) 모양으로 깊어지거든요. 그런데 이 중첩 if는 대부분 풀 수 있어요. H6에서 배울 early return으로요. "조건이 안 맞으면 일찍 빠져나간다"는 패턴으로 바꾸면, 계단이 평평해져요. 오늘은 "삼항은 좋고, 깊은 중첩은 나쁘다"만 기억하세요. 같은 if라도 어떻게 쓰느냐가 코드의 품질을 가르거든요.

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

이 truthy/falsy 규칙이 Python 코드를 얼마나 우아하게 만드는지 보여드릴게요. 다른 언어 출신 개발자는 "리스트가 비었나?"를 `if len(items) == 0:`처럼 길게 써요. Python은 `if not items:`예요. "items가 비었으면"이라고 영어처럼 읽혀요. "값이 있나?"도 `if items:` 한 줄이에요. 이게 falsy 규칙 덕이에요. 빈 것(빈 리스트·빈 문자열·빈 딕셔너리)은 다 falsy니까, "비었나?"를 한 단어로 물을 수 있어요. 그리고 이건 단축 평가와도 연결돼요. `name or "익명"`이라고 쓰면, name이 truthy면 name을, falsy(빈 문자열 등)면 "익명"을 줘요. 기본값을 주는 우아한 한 줄이죠. 사용자가 이름을 안 적었으면 "익명"으로요. 이게 Python다운 코드예요. 짧고, 영어처럼 읽히고, 명료해요. 다만 H1에서 말한 함정 하나만 기억하세요. 0과 빈 문자열은 둘 다 falsy지만 의미가 달라요. "포인트가 0"과 "이름이 빈 문자열"은 다른 상황이죠. 그래서 숫자를 다룰 때는 falsy에 기대지 말고 명시적으로 비교하세요. 빈 컨테이너를 확인할 때만 falsy의 우아함을 쓰고, 숫자가 0일 수 있을 때는 조심하기. 이 구별이 본인을 falsy 함정에서 지켜요.

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

이 함정이 실전에서 진짜 사고를 내요. 한 장면으로 보여드릴게요. 까미가 사용자의 포인트를 확인하는 코드를 짰어요. `if user.points:`로요. "포인트가 있으면 보여줘"라는 뜻이었죠. 그런데 포인트가 정확히 0인 사용자가 로그인했어요. 0은 falsy라서, `if user.points:`가 거짓이 됐어요. 그래서 포인트가 0인 사용자에게 포인트 화면이 안 보였어요. 까미는 "포인트가 0이어도 0이라고 보여줘야 하는데" 하고 버그를 찾느라 한참 헤맸어요. 원인은 falsy 함정이었어요. 0(진짜 포인트 0)과 None(포인트 정보 없음)이 둘 다 falsy라서 구별이 안 된 거예요. 처방은 명확해요. "값이 있나 없나(None인가)"를 물을 때는 `if x is not None`을 쓰고, "비어 있나(빈 리스트·빈 문자열)"를 물을 때만 `if x`를 써요. 숫자를 다룰 때는 특히 조심하세요. 0은 의미 있는 숫자인데 falsy거든요. 본인이 두 해 코스에서 숫자나 카운트를 if로 확인할 때마다, "0이 valid한 값인가?"를 한 번 물어보세요. valid하면 `is not None`, 아니면 `if x`. 이 작은 구별이 까미가 헤맨 그 한 시간을 본인에게는 안 일어나게 해요.

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

dict를 for로 도는 게 처음엔 헷갈려요. 분명히 해 둘게요. dict는 키-값 쌍의 모음이죠. 그래서 dict를 돌 때 "키만 필요한지, 값만 필요한지, 둘 다 필요한지"에 따라 메서드가 달라요. 둘 다 필요하면 `.items()` — `for cat, age in cats_dict.items()`로 키(cat)와 값(age)을 한 번에 받아요. 키만 필요하면 `.keys()`, 값만 필요하면 `.values()`예요. 그냥 `for x in cats_dict`라고 쓰면 키만 나와요(키가 기본이에요). 본인이 환율 계산기에서 RATES dict를 도는 일이 많을 거예요. "각 통화와 그 환율을 보여줘"라면 `.items()`로 통화와 환율을 같이 받아요. "지원하는 통화 목록을 보여줘"라면 `.keys()`로 통화만 받고요. 가장 자주 쓰는 건 `.items()`예요. 보통 키와 값을 같이 다루니까요. 그리고 Ch007 H7에서 배웠듯, dict는 3.7부터 순서를 유지해요. 본인이 넣은 순서대로 돌아요. 그래서 for로 돌 때 결과 순서가 예측 가능해요. 이 일관성이 본인 코드를 안정적으로 만들어요.

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

zip은 "여러 리스트를 나란히 묶어서 동시에 도는" 도구예요. 이름 리스트와 나이 리스트가 따로 있을 때, zip으로 묶으면 "까미와 3", "노랭이와 2"처럼 짝을 지어 줘요. 지퍼가 양쪽 이를 맞물리듯이요. 그래서 이름이 zip이에요. 한 가지 주의할 게, zip은 가장 짧은 리스트에서 멈춰요. 이름이 3개인데 나이가 2개면, 2개까지만 묶고 멈춰요. 세 번째 이름은 짝이 없으니 버려져요. 보통은 이게 안전한 동작이지만, 길이가 다르면 데이터를 잃을 수 있으니 조심하세요. 두 리스트의 길이가 같은지 확실할 때 zip을 쓰는 게 안전해요. zip은 본인이 "관련된 여러 데이터를 같이 처리"할 때 자주 만나요. 예를 들어 이름과 점수, 통화와 환율, 질문과 답. 짝지어진 데이터를 동시에 다룰 때 zip 한 줄이면 돼요.

**5. range (숫자 시퀀스)**

```python
for i in range(5):
    print(i)
# 0, 1, 2, 3, 4
```

`range(시작, 끝, 단계)`로 더 세밀하게.

다섯 종류. 매일 1, 3번이 80%. 2, 4번은 가끔. 5번은 횟수 반복용.

이 다섯 중에서 본인이 자주 헷갈릴 게 3번 enumerate와 5번 range예요. 둘의 차이를 분명히 해 둘게요. range는 그냥 숫자를 만들어요. `range(5)`는 0,1,2,3,4를 만들어요. 그래서 "5번 반복해라"처럼 횟수만 필요할 때 써요. enumerate는 리스트를 돌면서 "몇 번째인지(인덱스)와 그 값"을 같이 줘요. 초보자가 자주 하는 실수가 `for i in range(len(cats)): print(cats[i])`예요. 인덱스를 range로 만들고 그걸로 리스트를 꺼내는 거죠. 이건 C 스타일이고 Python답지 않아요. off-by-one 위험도 있고요. Python다운 방법은 `for i, cat in enumerate(cats):`예요. 인덱스 i와 값 cat을 한 번에 안전하게 받아요. AI도 range(len(...))를 보면 무조건 enumerate로 바꾸라고 추천해요. 그러니까 규칙은 이래요. **순수하게 횟수만 필요하면 range, 리스트를 돌면서 인덱스도 필요하면 enumerate.** 그리고 인덱스 없이 값만 필요하면 그냥 `for cat in cats`예요. 인덱스가 필요할 때만 enumerate를 꺼내세요. 이 셋(그냥 for, enumerate, range)을 구별하면, 본인은 어떤 반복 상황에서도 Python다운 코드를 짜요.

---

## 5. 넷째 — while과 walrus 연산자

while은 조건이 참인 동안 반복.

```python
count = 5
while count > 0:
    print(count)
    count -= 1
```

while을 자경단이 매일 쓰는 곳은 두 곳뿐이에요. 첫째, 알 수 없는 횟수의 반복. 둘째, 사용자 입력 받을 때. 본인이 H5에서 짤 환율 계산기 v2가 바로 두 번째 경우예요. "사용자가 종료를 누를 때까지 메뉴를 계속 보여준다." 몇 번 보여줄지 미리 모르죠. 사용자가 한 번 쓰고 끝낼 수도, 백 번 쓸 수도 있어요. 이렇게 횟수를 모를 때 while이에요. 반대로 "통화 다섯 개를 환산한다"는 다섯 번인 걸 미리 아니까 for예요. 횟수를 알면 for, 모르면 while. 이 한 줄 규칙이 본인이 둘 중 뭘 쓸지 항상 알려줘요.

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

while을 쓸 때 본인이 평생 조심할 한 가지가 무한 루프예요. H1에서 살짝 말했지만 여기서 제대로 짚을게요. while은 "조건이 참인 동안" 도는데, 만약 그 조건이 영영 거짓이 안 되면 영원히 돌아요. 프로그램이 멈추질 않아요. 가장 흔한 실수가 `while count > 0:` 안에서 `count -= 1`을 깜빡하는 거예요. count가 안 줄어드니까 영원히 0보다 크고, 영원히 돌아요. 본인이 이걸 만나면, 화면에 같은 게 끝없이 뜨거나 프로그램이 멈춘 듯 보여요. 그때는 당황하지 말고 Ch006에서 배운 Ctrl+C를 누르세요. SIGINT를 보내서 멈춰요. 그래서 while을 쓸 때는 항상 두 가지를 확인하세요. 하나, 루프 안에서 조건에 영향을 주는 변수를 바꾸고 있는가(count -= 1 같은 것). 둘, 그게 언젠가 조건을 거짓으로 만드는가. `while True`처럼 일부러 무한 루프를 만들 때는, 반드시 안에 break가 있어서 빠져나갈 길을 만들어요. 빠져나갈 길 없는 무한 루프는 버그예요. 그래서 자경단은 while보다 for를 선호해요. for는 정해진 것만 돌고 자동으로 멈추니까 무한 루프가 안 생기거든요. while은 정말 필요할 때만, 그리고 항상 빠져나갈 길을 확인하면서 쓰세요. 이게 while의 가장 중요한 안전 수칙이에요.

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

break와 continue를 언제 쓰는지 한 장면으로 구별해 드릴게요. 본인이 100명의 cat 중에서 특정 cat을 찾고 있어요. 찾으면 더 볼 필요가 없죠. 그래서 찾는 순간 break로 루프를 끝내요. 100명을 다 안 돌고 멈춰요. 이게 break예요. "목적을 이뤘으니 그만." 반면 continue는 "이번 건 건너뛰고 다음 거"예요. 본인이 100명의 cat 중에서 활동 중인 cat만 처리하고 싶어요. 비활동 cat을 만나면, 그 cat은 건너뛰고 다음 cat으로 가요. 그게 continue예요. break는 루프를 통째로 끝내지만, continue는 이번 한 바퀴만 건너뛰고 루프는 계속돼요. 그리고 for+else는 정말 독특한 Python 기능이에요. for 루프가 break 없이 끝까지 다 돌면 else가 실행돼요. break로 중간에 빠져나왔으면 else가 실행 안 돼요. 이게 "찾았으면 break, 끝까지 못 찾았으면 else"라는 검색 패턴에 딱 맞아요. 다른 언어에는 없는 기능이라 처음엔 생소해요. 안 써도 되지만, 코드에서 만나면 "아, 끝까지 못 찾은 경우구나" 하고 읽을 줄은 알아야 해요. break는 목적 달성, continue는 건너뛰기, for+else는 끝까지 못 찾음. 이 셋이 루프를 미세 조정하는 도구예요.

---

## 7. 여섯째 — match-case 다섯 패턴

Python 3.10+의 새 무기. switch 문보다 강력해요. 다른 언어를 해 본 분은 switch 문을 아실 거예요. Python에는 오랫동안 switch가 없었어요. if/elif로 충분하다는 철학이었죠. 그런데 2021년 match-case가 들어오면서, 단순한 switch를 넘어 "패턴 매칭"이라는 더 강력한 기능을 줬어요. 늦게 온 만큼 더 좋은 걸 가져온 거예요.

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

match-case가 if/elif 체인과 뭐가 다른지 짚고 갈게요. 같은 일을 if/elif로도 할 수 있어요. `if status == 200: ... elif status == 404: ...`처럼요. 그런데 match-case가 두 가지에서 더 나아요. 첫째, 가독성이에요. 같은 변수(status)를 여러 값과 비교할 때, if/elif는 `status ==`를 매번 반복해요. match-case는 `match status:` 한 번 쓰고 case로 값만 나열해요. 무엇을 비교하는지가 한눈에 보여요. 둘째, 패턴 매칭이에요. 이게 진짜 강력해요. match-case는 단순히 값만 비교하는 게 아니라 "구조"를 비교해요. 예를 들어 `case {"type": "cat", "name": name}:`는 "이 딕셔너리가 type이 cat이고 name 키가 있으면, 그 name을 꺼내라"는 뜻이에요. 비교와 추출을 한 번에 해요. if/elif로 이걸 하려면 `if data.get("type") == "cat" and "name" in data: name = data["name"]`처럼 길어져요. match-case는 한 줄이에요. 그래서 본인이 API 응답이나 복잡한 데이터를 다룰 때 match-case가 빛나요. 다만 Python 3.10 이상에서만 돼요. 자경단은 3.12를 쓰니까 마음껏 써요. 옛 Python 호환이 필요하면 if/elif를 쓰고요. 오늘은 "match-case는 값뿐 아니라 구조를 비교한다"는 게 핵심이에요. 단순 값 비교는 if/elif와 비슷하지만, 구조를 다룰 때 match-case가 압도적으로 우아해요.

---

## 8. 일곱째 — comprehension 네 종류

본인의 흐름 도구의 정점. 네 가지. comprehension은 Python을 다른 언어와 구별 짓는 가장 특징적인 문법이에요. "데이터를 변환해서 새 컬렉션을 만든다"는 일을 한 줄로 우아하게 표현해요. 네 종류가 있는데, 괄호만 다르고 원리는 같아요.

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

comprehension의 네 종류 중에서 본인이 가장 많이 쓸 건 list comprehension이고, 가장 신기한 건 generator expression이에요. 둘의 차이가 중요해요. list comprehension `[x*2 for x in xs]`는 결과를 통째로 메모리에 만들어요. 만 개를 변환하면 만 개짜리 리스트가 메모리에 떠요. generator expression `(x*2 for x in xs)`는 다르게 동작해요. 결과를 미리 안 만들고, 본인이 하나씩 요청할 때마다 하나씩 만들어요. 이걸 lazy(게으른) 평가라고 해요. 그래서 generator는 메모리를 거의 안 써요. 만 개든 백만 개든, 한 번에 하나씩만 메모리에 있거든요. 이게 큰 데이터에서 결정적이에요. 본인이 천만 줄짜리 로그 파일을 처리할 때, list로 만들면 메모리가 터져요. generator로 하면 한 줄씩 흘려 보내니까 메모리가 안 터져요. 그래서 규칙은 이래요. **결과를 여러 번 쓰거나 전체가 필요하면 list, 한 번만 훑고 버리거나 데이터가 크면 generator.** 작은 데이터는 list가 편하고, 큰 데이터는 generator가 안전해요. 이게 H7에서 깊이 배울 내용인데, 오늘은 "list는 통째로, generator는 하나씩"만 기억하세요. 그리고 set comprehension `{...}`은 중복을 자동으로 제거해요. "고유한 값만 모아라" 할 때 set comprehension 한 줄이면 돼요. dict comprehension `{k: v for ...}`은 키-값 쌍을 만들어요. 네 종류가 각자 쓸모가 있어요. 모양은 비슷한데(괄호만 다름) 결과가 리스트·집합·딕셔너리·제너레이터로 달라요. 괄호 하나로 자료형이 결정되는 게 Python의 우아함이에요.

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

nested(중첩) 흐름에 대해 한 가지 원칙을 드릴게요. **깊이가 깊어질수록 코드가 어려워진다.** 한 단계(for 하나)는 쉬워요. 두 단계(for 안의 for)도 괜찮아요. 행렬이나 표를 다룰 때 자연스럽게 나오니까요. 그런데 세 단계, 네 단계로 깊어지면, 코드를 읽는 사람의 머리가 터져요. 각 단계가 무엇을 도는지, 지금 어느 깊이에 있는지 따라가기가 불가능해져요. 그래서 자경단은 "중첩은 2단까지"를 규칙으로 해요. 3단 이상이 필요하면, 안쪽 루프를 함수로 빼내요. 위 예시처럼 `process_row`라는 함수로 안쪽 for를 빼면, 바깥 for는 한 단계만 남아서 읽기 쉬워져요. 그리고 함수로 빼면 그 함수를 따로 테스트할 수도 있어요. 일석이조죠. 이게 H1에서 본 "복잡한 걸 작게 나눈다"는 원칙이 제어 흐름에 적용된 거예요. 깊은 중첩은 복잡함의 신호예요. 복잡하면 나눠라. 함수로 빼면 깊이가 평평해지고, 각 조각이 한 가지 일만 하게 돼요. 본인이 두 해 코스에서 for 안에 for 안에 for를 쓰고 있다면, 그건 "여기 함수로 빼야 한다"는 신호예요. 코드의 깊이가 본인에게 보내는 경고 신호인 거죠. 그 신호를 읽을 줄 아는 게 좋은 개발자의 감각이에요.

---

## 10. 한 줄 분해 — 8개념을 한 줄에

자경단의 까미가 매일 짜는 진짜 한 줄을 분해해 볼게요. 8개념이 어떻게 한 줄에 모이는지 보세요.

```python
[c.name for c in cats if c.age >= 3 and c.is_active]
```

이 한 줄을 풀어 보면.

`for c in cats` — for + iterable.
`if c.age >= 3 and c.is_active` — if + 비교 + and.
`c.name` — 표현식.
`[...]` — list comprehension.

8개념 중 4개가 한 줄에. 본인이 8시간 후엔 이런 한 줄을 5초에 짜요.

이 한 줄을 처음 보면 외계어 같지만, 읽는 순서를 알면 영어처럼 읽혀요. 읽는 순서는 이래요. 먼저 가운데 `for c in cats`를 봐요 — "cats의 각 c에 대해". 다음 `if c.age >= 3 and c.is_active`를 봐요 — "나이가 3 이상이고 활동 중이면". 마지막에 앞의 `c.name`을 봐요 — "그 c의 이름을". 그리고 전체를 `[...]`가 감싸니 — "다 모은 리스트". 합치면 "cats의 각 c에 대해, 나이가 3 이상이고 활동 중이면, 그 이름을 모은 리스트"예요. 가운데(for) → 조건(if) → 결과(앞)의 순서로 읽으면 돼요. 이게 comprehension을 읽는 비결이에요. 결과가 앞에 오니까 처음엔 헷갈리는데, "for부터 읽어라"를 기억하면 술술 읽혀요. 그리고 이 한 줄이 일반 for로는 다섯 줄이에요. 빈 리스트 만들고, for 돌고, if 확인하고, append하고. comprehension은 그 다섯 줄을 한 줄로, 그것도 더 읽기 쉽게 압축해요. 본인이 이 읽기와 쓰기에 익숙해지면, 데이터를 다루는 본인의 코드가 절반으로 줄어요. 그리고 짧아진 만큼 버그도 줄어요. 줄이 적으면 틀릴 곳도 적으니까요. comprehension은 짧음과 명료함과 안전함을 한 번에 주는 Python의 선물이에요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: range가 list다.**

range는 iterable이지만 lazy. list가 아님. `list(range(5))`로 변환.

**오해 2: dict의 순서가 무작위다.**

Python 3.7+ insertion order 유지. 순서 있음. 본인이 넣은 순서대로 for가 돌아요. 옛날 Python(3.6 이전)에서는 무작위였지만, 지금은 순서가 보장돼요. 그래서 dict를 for로 돌 때 결과 순서를 믿어도 돼요.

**오해 3: comprehension은 항상 빠르다.**

작은 데이터는 일반 for와 비슷. comprehension이 빠른 건 CPython 최적화 덕인데, 차이는 작아요. 그리고 큰 데이터에서는 list comprehension보다 generator가 메모리 효율로 이겨요. "빠르다"가 아니라 "짧고 읽기 쉽다"가 comprehension의 진짜 가치예요.

**오해 4: match-case는 switch와 같다.**

다른 거예요. switch는 값만 비교하지만, match-case는 구조(tuple·dict·class)까지 비교하고 그 안의 값을 꺼내요. 패턴 매칭이라 더 강력해요. 단순 값 비교는 switch와 비슷하지만, 구조를 다룰 때 차원이 달라요.

**오해 5: while보다 for가 항상 좋다.**

90% 그래요. 5%는 while이 명확해요.

**오해 6: comprehension은 무조건 한 줄로 욱여넣어야 멋지다.**

아니에요. 간단한 변환만 comprehension으로. 복잡한 로직(여러 조건, 여러 단계)은 차라리 풀어 쓴 for가 읽기 쉬워요. 파이썬의 선 — 가독성이 짧음보다 우선. comprehension에 if가 두 개 이상 붙거나 중첩이 깊어지면, 그건 for로 풀라는 신호예요.

**오해 7: match-case가 if/elif를 완전히 대체한다.**

아니에요. 단순한 두세 분기는 if/elif가 더 간단해요. match-case는 같은 변수를 여러 값/구조와 비교할 때 빛나요. 둘 다 도구고, 상황에 맞게 골라 써요.

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

**Q6. 8개념이 너무 많아요. 다 외워야 하나요?**

아니요. 매일 쓰는 건 if/elif/else, for, list comprehension 셋이에요. 이 셋만 손에 익히면 본인 코드의 90%가 돼요. 나머지는 필요할 때 다시 보면서 천천히. 다 외우려는 욕심이 오히려 본인을 지치게 해요. 셋부터 손에 박으세요.

**Q7. comprehension과 일반 for 중 뭘 먼저 익혀야 하나요?**

일반 for부터요. for로 풀어 쓰는 게 더 이해하기 쉽거든요. 빈 리스트 만들고, for 돌고, append하고. 이 패턴이 손에 익은 다음에, "아, 이걸 comprehension 한 줄로 줄일 수 있네" 하고 압축하세요. for를 모르고 comprehension부터 배우면 마법처럼 느껴져서 응용을 못 해요. for가 기본이고, comprehension은 그 압축이에요. 순서를 지키세요.

---

## 13. 흔한 실수 다섯 + 안심 — 핵심 개념 학습 편

첫째, 비교 연산자 `==` vs `is` 헷갈림. 안심 — `is`는 None만, 나머지는 `==`.
둘째, truthy/falsy 무지성 단정. 안심 — 빈 list·dict·set·str은 False, 0도 False.
셋째, list comprehension 한 줄 욕심. 안심 — 3중 이상은 for 두 줄.
넷째, range 마지막 포함 헷갈림. 안심 — `range(10)`는 0~9. 공식 한 번 외움.
다섯째, 가장 큰 함정 — break vs return 헷갈림. 안심 — break는 루프, return은 함수.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

이 다섯 함정 중에서 가장 자주 만나는 게 네 번째, range의 끝값이에요. `range(10)`은 0부터 9까지예요. 10은 포함 안 해요. 처음 배우는 사람이 거의 다 한 번씩 여기서 off-by-one 버그를 만나요. "10번 반복하려고 range(10)을 썼는데 왜 9까지만 나오지?" 사실 10번 맞아요. 0,1,2,3,4,5,6,7,8,9가 10개거든요. 0부터 시작하니까 끝이 9예요. 이걸 한 번 외워 두면 평생 안 헷갈려요. **range(n)은 0부터 n-1까지, 총 n개.** 그리고 슬라이스 `[1:3]`도 같은 규칙이에요. 시작은 포함, 끝은 제외. 이게 Python 전체에 일관되게 적용돼요. range도, 슬라이스도, 다 "끝은 제외". 한 번 익히면 모든 곳에 통해요. 처음엔 어색하지만, 익숙해지면 오히려 편해요. range(len(items))가 정확히 items의 개수만큼이고, [a:b]의 길이가 정확히 b-a거든요. 빼기 한 번이면 길이가 나와요. 이 "끝 제외" 규칙이 Python의 일관성이에요.

## 14. 마무리 — 다음 H3에서 만나요

자, 두 번째 시간이 끝났어요. 60분 동안 본인은 8개념을 만나셨어요. 정리하면 이래요.

if 5패턴, truthy/falsy 7가지, for+iterable 5종, while+walrus, break/continue/for+else, match-case 5패턴, comprehension 4종, nested 흐름. 한 줄 분해 — `[c.name for c in cats if c.age >= 3 and c.is_active]`.

박수 한 번 칠게요. 8개념을 한 시간에 듣는 게 빽빽했어요. 잘 따라오셨어요.

오늘 배운 8개념을 다 외우려고 하지 마세요. 매일 쓰는 건 사실 몇 개예요. if/elif/else, 그냥 for, list comprehension. 이 셋이 본인이 매일 쓰는 거예요. 나머지(while, match-case, generator, for+else)는 필요할 때 다시 만나면서 천천히 익혀요. 오늘 한 시간의 목적은 "이런 게 있구나"를 머리에 그려 두는 거예요. 제어 흐름의 지도를 한 번 본 거예요. 본인이 H5에서 환율 계산기 v2를 짤 때, 오늘 본 게 "아, 이거 그거구나" 하고 손에 잡혀요. 그리고 두 해 코스를 지나면서 이 8개념을 하나씩 더 깊이 만나요. 오늘은 지도, 앞으로는 그 길을 직접 걷기. 지도와 실전을 오가면서 본인의 흐름 감각이 깊어져요.

다음 H3은 디버깅 셋업이에요. VS Code 디버거, breakpoint(), pdb, rich.print, ipython. 본인이 짠 코드가 이상하게 동작할 때, 그 속을 들여다보는 도구들이에요. 제어 흐름은 버그가 자주 나는 곳이라, 디버깅 도구가 특히 중요해요. 한 시간 후 만나요.

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

---

## 추신

1. 제어 흐름 8개념이 본인 흐름 어휘의 90%.
2. if 5패턴 — 단일·if/else·if/elif/else·삼항·중첩.
3. 삼항 `label = "성인" if age>=18 else "미성년"` 한 줄.
4. 중첩 if 3단 이상은 사고. early return으로(H6).
5. falsy 7 — False·None·0·0.0·""·[]·{}. 그 외 truthy.
6. `if name:`이 `if name != "":`보다 짧고 Python답게.
7. 함정 — 0도 falsy. 0이 valid면 `if x is not None`.
8. for+iterable 5 — list·dict.items()·enumerate·zip·range.
9. `range(len(...))` 대신 `enumerate`. Python 표준.
10. zip으로 여러 리스트 동시 순회.
11. while은 두 곳만 — 모르는 횟수·사용자 입력.
12. `while True` + `break`가 표준 패턴.
13. walrus `:=`(3.8+)는 할당+조건 동시. while 짧게.
14. break=루프 종료, continue=다음 반복.
15. `if`+`continue`로 필터링.
16. for+else — break 없이 끝나면 else. "다 봤는데 못 찾음".
17. match-case(3.10+) 5패턴 — 값·`|`여러값·tuple·dict·class.
18. `case _:`가 default. switch보다 강력한 패턴 매칭.
19. comprehension 4 — list[]·set{}·dict{k:v}·generator().
20. 각 comprehension에 `if 필터` 추가 가능.
21. generator()는 lazy. 큰 데이터 메모리 효율 400배.
22. set comprehension은 중복 자동 제거.
23. nested for는 2단까지. 3단은 함수 분리.
24. `[cell for row in m for cell in row]`로 평탄화.
25. 한 줄 분해 — `[c.name for c in cats if c.age>=3 and c.is_active]`.
26. range(10)은 0~9. 끝값 미포함. 외워 두기.
27. dict는 3.7+ 순서 유지(insertion order).
28. `is`는 None만, 나머지는 `==`.
29. comprehension은 변환에, 부수효과(print)는 일반 for.
30. 다음 H3은 디버깅 셋업. 한 시간 쉬고 만나요. 🐾
