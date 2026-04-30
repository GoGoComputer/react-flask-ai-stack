# Ch007 · H2 — Python 핵심 8개념 — 다섯 자료형과 열여덟 연산자와 f-string

> 고양이 자경단 · Ch 007 · 2교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. 첫째 자료형 — int, 무한대 정수
3. 둘째 자료형 — float, IEEE 754의 함정
4. 셋째 자료형 — str, 글자의 묶음
5. 넷째 자료형 — bool, 참과 거짓
6. 다섯째 자료형 — None, 없음을 표현하기
7. 연산자 열여덟 가지 — 산술·비교·논리·할당
8. 문자열 포매팅 — % 옛, .format() 중간, f-string 표준
9. mutable vs immutable — 자경단의 매일 함정
10. == vs is, type() vs isinstance() — 면접 단골
11. 한 줄 분해 — 8개념을 한 줄에 모아 보기
12. 흔한 오해 다섯 가지
13. 자주 받는 질문 다섯 가지
14. 마무리 — 다음 H3에서 만나요

---

## 🔧 강사용 명령어 한눈에

```python
# 다섯 자료형
print(type(42), type(3.14), type("hello"), type(True), type(None))

# 연산자
10 // 3  # 몫 = 3
10 % 3   # 나머지 = 1
2 ** 10  # 제곱 = 1024

# f-string
name = "자경단"
age = 5
print(f"{name}은 {age}살이에요")

# mutable
a = [1, 2, 3]
b = a
b.append(4)
print(a)   # [1, 2, 3, 4] — a도 변함

# == vs is
[1, 2] == [1, 2]  # True (값 같음)
[1, 2] is [1, 2]  # False (객체 다름)
```

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠. 물 한 잔 드시고 오셨길 바라요.

지난 H1을 한 줄로 회수할게요. Python은 본인의 평생 두뇌예요. 가독성, 다용도, AI 시대 표준, 자경단 백엔드. 일곱 이유로 본인이 Python을 첫 언어로 만나셨어요. 그 안에 친구가 네 명 살고 있다고 했어요. 인터프리터·변수·자료형·연산자.

이번 H2는 그 네 명 중 자료형과 연산자를 깊이 만나러 가는 시간이에요. Python의 자료형 다섯 가지 — int, float, str, bool, None. 연산자 열여덟 가지. 그리고 보너스로 문자열 포매팅 세 가지 방법. 한 시간 후엔 본인이 Python의 단어 50%를 알아들을 수 있게 만들어 드릴게요.

오늘의 약속은 한 가지예요. **본인이 H4에서 만날 환율 계산기의 토대가 이 한 시간에 다 박힙니다**. 환율 계산기는 input(), float(), if/else, print()로 짜요. 오늘 그 다섯 도구의 자료형과 연산자를 다 만나요. 한 시간 후엔 본인이 환율 계산기의 한 줄 한 줄을 미리 머리에 그릴 수 있어요.

자, 가요. 첫째 자료형부터.

---

## 2. 첫째 자료형 — int, 무한대 정수

Python의 정수형은 다른 언어와 한 가지 다른 점이 있어요. **크기 제한이 없어요**. C나 Java는 int가 32비트 또는 64비트로 제한이 있는데, Python의 int는 메모리가 허락하는 한 무한히 커요.

> ▶ **같이 쳐보기** — int의 무한대 모습
>
> ```python
> >>> 5
> >>> 100_000_000
> >>> 2 ** 100
> >>> 0b1010      # binary
> >>> 0o17        # octal
> >>> 0x1F        # hex
> ```

엔터 누를 때마다 결과가 떠요.

```
5
100000000
1267650600228229401496703205376
10
15
31
```

신기한 게 두 가지. 첫째, 큰 숫자 100,000,000을 적을 때 100_000_000처럼 언더스코어를 끼워 넣을 수 있어요. 가독성을 위한 Python의 배려예요. 둘째, 2의 100승이 정말 큰 숫자가 그대로 정확히 떠요. 다른 언어 같으면 overflow 나거나 부정확한 근사값이 떴을 거예요.

그리고 binary, octal, hex 표기법. `0b`로 시작하면 2진수, `0o`로 8진수, `0x`로 16진수. 본인이 시스템 프로그래밍을 할 때 진짜 유용해요. 하지만 매일 쓰지는 않아요.

자경단의 매일 int 사용 — 나이 카운트, 인덱스, 반복 횟수, 페이지 번호. 정수 매일 100번.

---

## 3. 둘째 자료형 — float, IEEE 754의 함정

float은 실수. Python의 float은 C의 double과 같아요. IEEE 754 double precision. 그런데 한 가지 함정이 있어요.

> ▶ **같이 쳐보기** — float의 함정
>
> ```python
> >>> 0.1 + 0.2
> ```

엔터 누르면 깜짝 놀라실 거예요.

```
0.30000000000000004
```

0.1 + 0.2가 0.3이 안 나와요. 0.30000000000000004라는 이상한 숫자가 나와요. 이게 IEEE 754의 함정이에요. 컴퓨터는 이진수로 계산하는데 0.1을 이진수로 정확히 표현 못 해요. 무한 반복이에요. 그래서 작은 오차가 나와요.

이건 Python의 버그가 아니에요. 모든 언어가 똑같이 그래요. JavaScript도, Java도, C도 0.1 + 0.2 = 0.30000000000000004예요. IEEE 754 표준의 본질적 함정.

처방은 두 가지. 작은 오차 무시 가능한 경우는 그냥 넘어가요. 정확한 계산이 필요한 금융 코드는 Decimal 모듈을 써요.

```python
from decimal import Decimal
Decimal('0.1') + Decimal('0.2')  # Decimal('0.3') 정확
```

자경단의 환율 계산기는 보통 float으로 충분해요. 1원 단위까지만 보면 되니까. 진짜 금융 (만원 단위 정확) 작업이면 Decimal.

float의 다른 표기. `1e10`은 1 × 10^10 = 100억. 지수 표기. 큰 숫자에 편해요.

자경단의 매일 float 사용 — 환율, 평균값, 시간 측정, 백분율. float 매일 50번.

---

## 4. 셋째 자료형 — str, 글자의 묶음

문자열. Python에서 글자 묶음을 표현하는 자료형. 따옴표로 감싸요. 작은따옴표든 큰따옴표든 다 돼요.

> ▶ **같이 쳐보기** — str의 다양한 표기
>
> ```python
> >>> "안녕"
> >>> '자경단'
> >>> """여러 줄
> ... 글자"""
> >>> "다섯" + "마리"     # 더하기
> >>> "냥" * 3            # 곱하기
> >>> "자경단"[0]         # 인덱스
> >>> "자경단"[1:3]       # 슬라이스
> >>> len("자경단")       # 길이
> ```

각 줄의 결과를 보여 드릴게요.

```
'안녕'
'자경단'
'여러 줄\n글자'
'다섯마리'
'냥냥냥'
'자'
'경단'
3
```

여러 줄 문자열은 `"""..."""` 또는 `'''...'''` 세 따옴표. 더하기는 글자 합치기, 곱하기는 반복. 인덱스는 0부터 시작. 슬라이스는 시작 포함, 끝 제외.

문자열의 메서드도 많아요. `.upper()` 대문자, `.lower()` 소문자, `.strip()` 공백 제거, `.split()` 자르기, `.replace()` 바꾸기. 자경단이 매일 만나는 다섯 메서드예요.

```python
"  hello  ".strip()       # 'hello'
"a,b,c".split(",")        # ['a', 'b', 'c']
"cat".upper()             # 'CAT'
"CAT".lower()             # 'cat'
"hello".replace("l", "L") # 'heLLo'
```

자경단의 매일 str 사용 — 사용자 입력, API 응답, 로그 메시지, 파일 경로. str 매일 200번. 가장 자주 쓰는 자료형이에요.

---

## 5. 넷째 자료형 — bool, 참과 거짓

bool은 참/거짓. True 또는 False. 두 가지 값만 있어요. 첫 글자가 대문자예요.

```python
>>> True
True
>>> False
False
>>> 5 > 3
True
>>> 5 == 3
False
>>> not True
False
```

bool은 비교 연산자의 결과로 자주 만나요. `>`, `<`, `==`, `!=`, `>=`, `<=` 여섯 가지가 다 bool을 돌려줘요.

논리 연산자 세 가지도 알려 드릴게요. `and`, `or`, `not`. 다른 언어의 `&&`, `||`, `!`과 같은데 Python은 영어 단어로.

```python
True and False    # False
True or False     # True
not True          # False
```

자경단의 매일 bool 사용 — if 조건, 루프 종료, 검증 결과. bool 매일 100번.

bool의 작은 비밀 한 가지. Python에서 빈 값들은 모두 False로 평가돼요.

```python
bool(0)          # False
bool(0.0)        # False
bool("")         # False (빈 문자열)
bool([])         # False (빈 리스트)
bool(None)       # False
bool({})         # False (빈 dict)
```

이걸 "falsy 값"이라고 불러요. 0, 빈 글자, 빈 리스트, None은 다 거짓 취급. 그 외는 다 참(truthy). 이 규칙이 Python의 if 문을 짧게 만들어 줘요.

```python
if name:    # name이 비어있지 않으면
    print(f"안녕 {name}")
```

`if name != ""` 안 써도 돼요. `if name`만 써도 알아서 처리. 짧고 명료해요.

---

## 6. 다섯째 자료형 — None, 없음을 표현하기

None은 "없음"을 표현하는 특별한 값이에요. JavaScript의 null, Java의 null, C의 NULL과 같은 개념. 그러나 Python은 None 한 가지로 통일.

```python
>>> None
>>> x = None
>>> print(x)
None
>>> x is None
True
```

None은 함수가 아무것도 돌려주지 않을 때, 변수가 아직 값이 없을 때, "값이 없는 상태"를 표현할 때 사용해요.

```python
def find_cat(name):
    cats = ["까미", "노랭이"]
    if name in cats:
        return name
    return None    # 명시적으로 "없음"

result = find_cat("미니")
if result is None:
    print("그런 cat 없어요")
```

여기서 짚고 갈 한 가지. **None과 비교할 때는 `is None` 또는 `is not None`**을 써요. `== None` 안 써요. 비슷해 보이지만 미묘한 차이가 있어요. is는 객체 동일성, ==는 값 동일성. None은 한 객체뿐이라 is가 정확.

자경단의 매일 None 사용 — 함수 반환 없음, 데이터 없음 표시, 기본값. None 매일 50번.

---

## 7. 연산자 열여덟 가지 — 산술·비교·논리·할당

자료형 다섯을 다 봤어요. 이제 연산자. Python에 연산자가 한 30개쯤 있는데 매일 쓰는 18개만 짚어 드릴게요.

**산술 연산자 일곱**: `+`, `-`, `*`, `/`, `//`, `%`, `**`. 더하기·빼기·곱하기·나누기·몫·나머지·제곱.

```python
10 + 3   # 13
10 - 3   # 7
10 * 3   # 30
10 / 3   # 3.3333...
10 // 3  # 3 (몫)
10 % 3   # 1 (나머지)
2 ** 10  # 1024 (제곱)
```

`//`와 `**`가 Python 특유. `/`는 항상 float, `//`는 정수 몫.

**비교 연산자 여섯**: `==`, `!=`, `<`, `>`, `<=`, `>=`. 같음·다름·작음·큼·이하·이상. 모두 bool 반환.

```python
5 == 5    # True
5 != 3    # True
5 < 10    # True
5 > 10    # False
```

**논리 연산자 세**: `and`, `or`, `not`. 영어 단어 그대로.

```python
True and False   # False
True or False    # True
not True         # False
```

**할당 연산자 두**: `=`, `+=`, `-=`, `*=`, `/=`. 첫 줄은 보통 할당, 그 다음은 단축 형태.

```python
x = 5
x += 3   # x = x + 3 = 8
x -= 1   # x = x - 1 = 7
x *= 2   # x = x * 2 = 14
```

열여덟 개. 외우려 마세요. 매일 쓰면 박혀요. `+`, `-`, `*`, `/`, `==`, `!=`, `<`, `>`, `and`, `or`, `not`, `=`, `+=` 정도가 매일 100번. 나머지는 주간 한 번씩.

> ▶ **같이 쳐보기** — 연산자 열여덟 한 번씩
>
> ```python
> >>> 10 + 3; 10 - 3; 10 * 3
> >>> 10 / 3; 10 // 3; 10 % 3
> >>> 2 ** 10
> >>> 5 == 5; 5 != 3; 5 < 10
> >>> True and False; True or False; not True
> >>> x = 5; x += 3; print(x)
> ```

REPL에서 한 줄씩 쳐 보세요. 18개가 한 번씩 본인 손가락에서 다녀가요.

---

## 8. 문자열 포매팅 — % 옛, .format() 중간, f-string 표준

본인이 글자에 변수를 끼워 넣고 싶을 때 세 가지 방법이 있어요. 진화의 역사이기도 해요.

**옛날 방식 — % 포매팅**

```python
name = "자경단"
age = 5
print("%s는 %d살" % (name, age))
```

C 언어의 printf 비슷. 1990년대 표준. 지금은 잘 안 써요.

**중간 방식 — .format()**

```python
print("{}는 {}살".format(name, age))
print("{0}는 {1}살".format(name, age))
print("{n}는 {a}살".format(n=name, a=age))
```

Python 2.6에 추가. 더 유연하지만 길어요.

**현대 표준 — f-string** (Python 3.6+)

```python
print(f"{name}는 {age}살")
```

가장 짧고, 가장 빠르고, 가장 명료. **자경단 표준은 f-string**. 본인은 f-string만 쓰시면 됩니다. 옛 방식은 그냥 알아 두기만.

f-string의 강력한 기능 다섯 가지.

```python
# 기본
f"{name}는 {age}살"

# 표현식 안에서
f"내년엔 {age + 1}살"

# 함수 호출
f"이름 길이: {len(name)}자"

# 포매팅 옵션 (소수점 자리)
f"환율: {1234.5678:.2f}"     # 1234.57

# 정렬과 채우기
f"{name:>10}"       # 오른쪽 정렬, 10칸
f"{name:*<10}"      # 왼쪽 정렬, *로 채우기
```

다섯 가지가 자경단의 매일 f-string 사용. 외우려 마세요. 매일 만나면 박혀요.

---

## 9. mutable vs immutable — 자경단의 매일 함정

Python의 자료형은 두 부류로 나뉘어요. **mutable** (변경 가능)과 **immutable** (변경 불가능). 이 차이가 자경단의 매일 함정 중 하나예요.

**Immutable** (변경 불가능): int, float, str, bool, None, tuple. 한 번 만들면 안 바뀌어요.

**Mutable** (변경 가능): list, dict, set. 만든 후에 안에 값을 추가·변경할 수 있어요.

차이가 뭐냐. 변수에 할당했을 때 동작이 달라져요.

```python
# Immutable (str)
a = "hello"
b = a
b = "world"
print(a)   # 'hello' — 안 바뀜

# Mutable (list)
a = [1, 2, 3]
b = a
b.append(4)
print(a)   # [1, 2, 3, 4] — 같이 바뀜!
```

list는 b를 바꾸면 a도 같이 바뀌어요. 둘이 같은 메모리를 가리키는 거예요. 이게 자경단이 매일 만나는 함정이에요.

처방은 복사. `b = a.copy()` 또는 `b = list(a)`. 새 리스트를 만들어요.

```python
a = [1, 2, 3]
b = a.copy()
b.append(4)
print(a)   # [1, 2, 3] — 안 바뀜
print(b)   # [1, 2, 3, 4]
```

이 함정은 H8 (collections)에서 더 깊이 다뤄요. 오늘은 "mutable과 immutable이 다르다"만 머리에.

---

## 10. == vs is, type() vs isinstance() — 면접 단골

Python 면접의 단골 질문 두 쌍.

**== vs is**

`==`는 값이 같은지. `is`는 같은 객체인지.

```python
a = [1, 2, 3]
b = [1, 2, 3]
a == b    # True (값 같음)
a is b    # False (다른 객체)

c = a
a is c    # True (같은 객체)
```

자경단 표준 — 값 비교는 `==`, None 비교는 `is None`.

**type() vs isinstance()**

`type()`은 정확한 type. `isinstance()`는 상속 관계도 인정.

```python
type(5) == int          # True
isinstance(5, int)      # True
isinstance(True, int)   # True (bool은 int의 자식)
type(True) == int       # False
```

자경단 표준 — 상속 인정해야 하면 isinstance, 정확히 같은 type만 보려면 type. 보통 isinstance가 더 안전.

---

## 11. 한 줄 분해 — 8개념을 한 줄에 모아 보기

자, 이번 시간에 배운 8개념을 한 줄에 모아 보면 환율 계산기의 한 줄이 보여요.

```python
won = float(input("달러: ")) * 1300
print(f"원: {won:.2f}원")
```

이 두 줄을 단어 단위로 풀어 봐요.

`input("달러: ")` — 사용자에게 글자 입력 받기. str 반환.

`float(...)` — str을 float으로 타입 변환.

`* 1300` — 산술 연산자. 곱하기.

`won = ...` — 할당 연산자.

`f"원: {won:.2f}원"` — f-string. 변수 끼워 넣기 + 소수점 둘째 자리.

`print(...)` — 출력.

자료형 두 가지 (str, float), 연산자 두 가지 (=, *), 함수 세 가지 (input, float, print), f-string 한 가지. 8개념 중 6개가 두 줄에 다 들어 있어요. H5에서 본인이 이 두 줄을 직접 짜요.

---

## 12. 흔한 오해 다섯 가지

**오해 1: int에는 크기 제한이 있다.**

Python 3의 int는 무한대. 메모리만 있으면 얼마든지 큰 숫자.

**오해 2: 0.1 + 0.2 = 0.3이다.**

아니에요. 0.30000000000000004예요. 모든 언어가 그래요. 정확한 계산은 Decimal.

**오해 3: == None이 표준이다.**

`is None`이 표준. == None은 안 써요.

**오해 4: f-string은 옛 방식보다 느리다.**

반대. f-string이 가장 빨라요. Python 3.6+에서 가장 효율적인 방식.

**오해 5: list와 tuple은 같다.**

다른 자료형. list는 mutable, tuple은 immutable. tuple은 ()로, list는 []로.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. 자료형 다섯 다 외워야 하나요?**

매일 만나는 게 int, str, bool 세 개. 나머지 둘은 며칠 안에 자연스럽게. 외우는 게 아니라 만나는 거예요.

**Q2. f-string의 모든 옵션 다 외워야?**

다섯 가지 (기본·표현식·함수·소수점·정렬)면 90% 충분. 더 깊은 옵션은 필요할 때 검색.

**Q3. mutable vs immutable이 진짜로 사고 나요?**

매일 한 번씩 사고 나요. 함수 안에서 list를 받아서 수정하면 함수 밖의 list도 같이 바뀌어요. 5년 차도 가끔 사고. .copy() 습관이 사고 면역.

**Q4. type hints는 H2부터 써야 하나요?**

자경단 표준은 H6부터. 첫 5시간은 type hints 없이 자료형 직관 익히고, H6에서 type hints로 안전 추가.

**Q5. None은 falsy인가요?**

네. `bool(None)`이 False. if None은 안 들어가요.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — Python 자료형 학습 편

Python 자료형 만나며 자주 빠지는 함정 다섯.

첫 번째 함정, mutable vs immutable 헷갈림. 안심하세요. **list·dict·set은 mutable, str·tuple·int는 immutable.** 작은 표 한 번 외우면 평생.

두 번째 함정, `==` vs `is` 헷갈림. 안심하세요. **`==` = 값 비교, `is` = 객체 비교(메모리 주소).** 거의 항상 `==`. None은 `is None`.

세 번째 함정, 빈 list를 함수 기본값으로. 본인이 `def fn(x=[])`로 부수 효과. 안심하세요. **`def fn(x=None): if x is None: x = []`.** 표준 패턴.

네 번째 함정, str 연결을 += 반복. 본인이 1만 번 += 로 느림. 안심하세요. **`"".join(list)` 사용.** Big O 차이.

다섯 번째 함정, 가장 큰 함정. **모든 변환을 명시적 안 함.** 본인이 `int(input())` 안 함. 안심하세요. **input은 항상 str.** 숫자 받을 땐 int·float 명시 변환.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H3에서 만나요

자, 두 번째 시간이 끝났어요. 60분 동안 본인은 Python의 핵심 8개념을 만나셨어요. 정리하면 이래요.

자료형 다섯 가지 — int, float, str, bool, None. 연산자 열여덟 가지 — 산술 7, 비교 6, 논리 3, 할당 2. 문자열 포매팅 세 가지 중 f-string이 표준. mutable vs immutable의 함정. == vs is와 type vs isinstance의 차이. 그리고 환율 계산기 두 줄 안에 6개념이 다 들어 있다는 그림.

박수 한 번 칠게요. 8개념을 한 시간에 듣는 게 빽빽해요. 잘 따라오셨어요. 이제 본인의 Python 어휘가 50% 채워진 거예요.

다음 H3은 본인 노트북 셋업이에요. pyenv로 Python 다중 버전, venv로 가상 환경, pip와 requirements.txt, VSCode + Pylance + Ruff. 30분이면 본인 노트북에 Python 표준 환경. 한 시간 후 만나요.

그 전에 한 가지 부탁. 지금 잠깐 멈추시고 본인 셸에서 다음 다섯 줄을 차례로 쳐 보세요.

```python
python3 -c 'print(type(42), type(3.14), type("hi"), type(True), type(None))'
python3 -c 'print(0.1 + 0.2)'
python3 -c 'name="자경단"; age=5; print(f"{name} {age}살")'
python3 -c 'print(2**100)'
python3 -c 'print([1,2,3] == [1,2,3], [1,2,3] is [1,2,3])'
```

5초예요. 5줄이 본인의 H2 졸업장이에요. 8개념이 본인 손가락에서 한 번 다녀가요. 잘 따라오셨어요. 한 시간 후 H3에서 만나요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - int 무한 정밀도: Python 3.0에서 int와 long 통합 (PEP 237). C로 짠 GMP-like 다정밀도 정수.
> - float IEEE 754: Python의 float = C double = 64-bit. 15-17 유효 자릿수. Decimal은 사용자 정의 정밀도.
> - 문자열 인코딩: Python 3 str은 항상 unicode (UTF-8 기본). bytes는 별도 자료형. encode()/decode()로 변환.
> - 작은 int 캐싱: -5 ~ 256은 미리 만들어 둔 객체 재사용. `is` 비교가 우연히 True. 큰 정수는 매번 새 객체.
> - 문자열 인터닝: 짧은 문자열은 자동 inning. `"a" is "a"` True 가능. sys.intern()으로 강제.
> - mutable의 default 인자 함정: `def f(x=[])` 같은 경우 리스트가 함수 정의 시 한 번만 만들어져 호출마다 공유. None default 후 안에서 [] 생성 권장.
> - == vs is의 정확한 차이: == 호출하면 `__eq__` 실행 (오버라이드 가능). is는 id() 비교 (메모리 주소).
> - isinstance vs type: bool은 int의 subclass. `isinstance(True, int)` True지만 `type(True) is int` False. duck typing은 isinstance.
> - f-string 안의 = 디버그 (3.8+): `f"{x=}"`가 `"x=42"`로 풀림. 디버깅에 진짜 유용.
> - 다음 H3 키워드: pyenv · venv · pip · requirements.txt · VSCode · Pylance · Ruff · mypy.
