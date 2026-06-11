# Ch008 · H4 — 18 제어 도구 카탈로그 — 본인의 매일 흐름 손가락

> 고양이 자경단 · Ch 008 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 18 도구 한 표
3. 첫째 무리 — 반복 네 도구
4. 둘째 무리 — 집계 다섯 도구
5. 셋째 무리 — 필터·변환·정렬 네 도구
6. 넷째 무리 — comprehension·iter·next 세 도구
7. 다섯째 무리 — itertools·functools·collections
8. 매일·주간·월간 손가락 리듬
9. 자경단 매일 13줄 흐름
10. 다섯 함정과 처방
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리 — 다음 H5에서 만나요

---

## 🔧 강사용 명령어 한눈에

```python
# 반복 4
for x in xs: ...
enumerate(xs)
zip(xs, ys)
range(10)

# 집계 5
sum(xs); min(xs); max(xs); len(xs); any(xs); all(xs)

# 필터 4
filter(f, xs); map(f, xs); sorted(xs); reversed(xs)

# comprehension 3
[x for x in xs]
iter(xs); next(it)

# itertools 5
chain, groupby, accumulate, product, combinations
```

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H3을 한 줄로 회수할게요. 디버깅 5도구. VS Code, breakpoint, pdb, rich, ipython.

이번 H4는 흐름 도구 18개를 표 한 장에 누이는 시간. 본인이 매일 흐름 짤 때 만나는 손가락.

오늘의 약속. **18 도구가 한 시간에 본인 머리에 들어옵니다**. 6주 후엔 손가락에 박혀요.

오늘 시간은 카탈로그예요. Ch006 셸 H4, Ch007 Python H4와 같은 구조예요. 도구 상자를 열어서 안에 뭐가 있는지 한 번 구경하는 거예요. 본인이 오늘 18개를 다 외울 필요는 없어요. "흐름을 다루는 도구가 이렇게 있구나, 합은 sum, 정렬은 sorted, 세는 건 Counter" 하고 지도를 그리는 게 목적이에요. 그래야 나중에 본인이 코드를 짜다가 "합 구하는 거 뭐였지?" 할 때 "아, sum이 집계 무리에 있었지" 하고 떠올려요. 오늘은 지도를 그리는 날이지 외우는 날이 아니에요. 그리고 이 18 도구는 H1~H2에서 배운 if·for·while·comprehension 위에 얹혀요. 기본 흐름을 알아야 이 도구들이 의미가 있거든요. sum도 결국 for로 더하는 걸 한 줄로 만든 거예요. 그러니까 기본(네 친구)이 먼저고, 도구는 그 위의 우아함이에요. 편하게 따라오세요.

자, 가요.

---

## 2. 18 도구 한 표

| # | 도구 | 무리 | 한 줄 정의 |
|---|------|------|----------|
| 1 | `for` | 반복 | iterable 순회 |
| 2 | `enumerate` | 반복 | 인덱스 + 값 |
| 3 | `zip` | 반복 | 여러 iterable 동시 |
| 4 | `range` | 반복 | 숫자 시퀀스 |
| 5 | `sum` | 집계 | 합 |
| 6 | `min` | 집계 | 최소 |
| 7 | `max` | 집계 | 최대 |
| 8 | `len` | 집계 | 길이 |
| 9 | `any` | 집계 | 하나라도 truthy |
| 10 | `all` | 집계 | 모두 truthy |
| 11 | `filter` | 필터 | 조건 필터 |
| 12 | `map` | 변환 | 변환 |
| 13 | `sorted` | 정렬 | 정렬 |
| 14 | `reversed` | 정렬 | 역순 |
| 15 | `[..]` | comp | list comp |
| 16 | `iter` | iter | iterator 만들기 |
| 17 | `next` | iter | 다음 요소 |
| 18 | `itertools` | 조합 | 함수형 도구 |

18개. 다섯 무리예요. 반복(4개)·집계(5개)·필터변환정렬(4개)·comprehension(3개)·조합(itertools 등). 한 무리씩 만나러 가요.

---

## 3. 첫째 무리 — 반복 네 도구

**for**. 가장 기본. iterable 순회. 본인이 가장 많이 쓸 도구예요. 다른 17개 도구가 다 for의 변주이거나 for와 함께 쓰여요.

```python
for cat in cats:
    print(cat)
```

**enumerate**. 인덱스와 값을 같이.

```python
for i, cat in enumerate(cats, start=1):
    print(f"{i}번: {cat}")
```

start로 시작 인덱스 변경. 자경단 매일. enumerate는 본인이 정말 자주 쓸 도구예요. "몇 번째인지"가 필요할 때마다요. "1번 까미, 2번 노랭이"처럼 번호를 붙여 보여줄 때, `enumerate(cats, start=1)`로 1부터 번호를 매겨요. start=1을 안 주면 0부터 시작하니까, 사람에게 보여줄 때는 보통 start=1을 줘요. 그리고 H2에서 강조했듯, `for i in range(len(cats)): cats[i]` 대신 무조건 enumerate예요. range(len)은 C 스타일이고 off-by-one 위험이 있어요. enumerate는 인덱스와 값을 안전하게 한 번에 줘요. AI도 range(len)을 보면 enumerate로 바꾸라고 추천해요. "인덱스가 필요하면 enumerate"를 손가락에 박아 두세요.

**zip**. 두 iterable 동시.

```python
names = ["까미", "노랭이"]
ages = [3, 2]
for n, a in zip(names, ages):
    print(f"{n}는 {a}살")
```

길이 다르면 짧은 쪽에서 멈춤. `itertools.zip_longest`로 채우기. zip은 "관련된 여러 리스트를 짝지어 도는" 도구예요. 이름 리스트와 나이 리스트가 따로 있을 때 zip으로 묶어요. 그리고 zip의 재밌는 활용 하나. 두 리스트를 dict로 만들 때 `dict(zip(names, ages))`예요. 이름과 나이를 짝지어 딕셔너리로요. 또 `zip(*matrix)`로 행렬을 뒤집을 수도 있어요(전치). zip은 작아 보이지만 데이터를 재구성하는 강력한 도구예요. 다만 길이가 다르면 데이터를 잃을 수 있으니, 길이가 같은지 확인하거나 zip_longest로 채우세요. Python 3.10부터는 `zip(a, b, strict=True)`로 길이가 다르면 에러를 내게 할 수도 있어요. 길이가 같아야 하는 상황이면 strict=True가 안전해요.

**range**. 숫자 시퀀스.

```python
range(5)         # 0, 1, 2, 3, 4
range(1, 6)      # 1, 2, 3, 4, 5
range(0, 10, 2)  # 0, 2, 4, 6, 8
```

세 종류. range는 lazy iterable. list 아님.

range가 lazy iterable이라는 게 무슨 뜻인지 짚을게요. 본인이 `range(1000000)`을 만들어도, 백만 개의 숫자가 메모리에 안 떠요. range는 "0부터 백만까지"라는 규칙만 기억하고, 본인이 하나씩 요청할 때마다 하나씩 만들어요. 그래서 `range(10억)`을 만들어도 메모리가 안 터져요. 만약 range가 진짜 리스트였으면 10억 개가 메모리에 떠서 컴퓨터가 죽었을 거예요. 이 lazy(게으른) 성질이 H2에서 본 generator와 같은 원리예요. 미리 안 만들고 필요할 때 만드는 거죠. 그래서 본인이 `range`를 직접 보려면 `list(range(5))`로 감싸야 [0,1,2,3,4]가 보여요. 그냥 `range(5)`는 `range(0, 5)`라고만 떠요. 규칙만 보여주는 거예요. 이게 처음엔 헷갈리는데, "range는 숫자를 미리 안 만들고 규칙만 갖고 있다"고 이해하면 돼요. 그리고 이 lazy 성질 덕에 `for i in range(10억)`을 써도 안전해요. for가 하나씩 요청하고, range가 하나씩 주니까요. 메모리는 한 번에 하나만 있어요. itertools의 도구들도 다 이렇게 lazy해요. Python이 큰 데이터를 다룰 수 있는 비결이 이 lazy 설계예요. 미리 다 안 만들고, 필요할 때 하나씩. 본인이 두 해 코스에서 큰 데이터를 만날 때, 이 lazy 도구들이 본인의 메모리를 지켜요.

---

## 4. 둘째 무리 — 집계 다섯 도구

**sum** — 합.
```python
sum([1, 2, 3])         # 6
sum(c.age for c in cats)  # generator
```

둘째 줄을 주목하세요. `sum(c.age for c in cats)`. sum 안에 generator expression이 들어갔어요. 대괄호 없이 sum 안에 바로요. 이게 Python의 우아한 패턴이에요. 리스트를 따로 안 만들고, "각 cat의 나이"를 sum이 하나씩 받아서 더해요. 메모리도 안 쓰고 한 줄로 끝나요. sum뿐 아니라 min, max, any, all에도 generator를 바로 넣을 수 있어요. `max(c.age for c in cats)`, `any(c.is_active for c in cats)`. 이게 집계 도구 + generator의 황금 조합이에요. "각 요소에서 무언가를 뽑아 집계해라"를 한 줄로요. 본인이 두 해 코스에서 "평균 나이", "최고 점수", "활동 사용자 있나" 같은 걸 구할 때, 이 패턴 한 줄이면 돼요. 일반 for로 빈 변수 만들고 더하는 네 줄이 한 줄로 줄어요.

**min**, **max** — 최소/최대.
```python
min(ages)
max(cats, key=lambda c: c.age)   # key로 비교 기준
```

min과 max는 짝이에요. 둘 다 key 인자로 비교 기준을 정해요. "가장 어린 cat"은 min, "가장 나이 많은 cat"은 max. key 없이 객체를 넣으면 비교를 못 해서 에러가 나니, 객체를 다룰 땐 항상 key를 줘요.

**len** — 길이.
```python
len(cats)         # 5
len("hello")      # 5
len({"a": 1})     # 1
```

len은 거의 모든 컬렉션에 통해요. 리스트, 문자열, 딕셔너리, 집합. 무엇이든 "몇 개인지"를 한 단어로 줘요. H2에서 본 falsy와도 연결돼요. `if len(items) == 0:` 대신 `if not items:`를 쓰지만, 정확한 개수가 필요하면 len이에요.

**any**, **all** — 조건 검증.
```python
any(c.is_active for c in cats)   # 하나라도 활성
all(c.age > 0 for c in cats)     # 모두 양수
```

다섯 도구. 매일 sum, min, max가 가장 자주.

이 집계 도구들이 왜 강력한지 짚고 갈게요. 본인이 "cat들의 나이 합"을 구한다고 해 봐요. 일반 for로 하면 빈 변수 만들고, for 돌면서 더하고, 네 줄이에요. sum 하나면 `sum(c.age for c in cats)` 한 줄이에요. 그것도 영어처럼 "cats의 각 c의 나이를 합해라"라고 읽혀요. min, max, len, any, all도 다 그래요. "가장 어린 cat은?" `min(cats, key=...)`. "활동 중인 cat이 하나라도 있나?" `any(...)`. "모든 cat이 건강한가?" `all(...)`. 이 도구들이 자주 쓰는 집계를 한 단어로 만들어요. 그리고 여기서 중요한 게 key 인자예요. `max(cats, key=lambda c: c.age)`는 "나이를 기준으로 가장 큰 cat"을 줘요. 그냥 max(cats)는 cat 객체끼리 비교를 못 해서 에러가 나요. key로 "무엇을 기준으로 비교할지"를 알려줘야 해요. 이 key 인자는 sorted, min, max에 다 있어요. "무엇을 기준으로?"를 정하는 거죠. 본인이 "나이순으로", "이름순으로", "점수순으로" 같은 걸 할 때 key를 써요. key 하나로 정렬 기준, 최대 기준, 최소 기준을 자유자재로 바꿔요. 이게 5년 차가 데이터를 우아하게 다루는 비결이에요. 집계 도구 + key 인자. 이 조합을 손에 익히면, 데이터에서 원하는 걸 한 줄로 뽑아내요.

---

## 5. 셋째 무리 — 필터·변환·정렬 네 도구

**filter** — 조건 필터.
```python
adults = filter(lambda c: c.age >= 18, cats)
list(adults)
```

자경단은 보통 list comprehension 선호. `[c for c in cats if c.age >= 18]`. 둘이 같은 일을 하는데, comprehension이 lambda도 없고 list로 감쌀 필요도 없어서 더 깔끔하거든요. filter는 알아만 두고, 짤 때는 comprehension을 쓰세요.

**map** — 변환.
```python
ages = map(lambda c: c.age, cats)
list(ages)
```

역시 comp 선호. `[c.age for c in cats]`. map은 "각 요소를 변환"하는 도구인데, comprehension이 같은 일을 더 읽기 쉽게 해요. map도 옛 코드에서 만나면 알아보되, 본인이 짤 땐 comprehension으로.

**sorted** — 정렬.
```python
sorted(ages)
sorted(cats, key=lambda c: c.age)
sorted(cats, key=lambda c: c.age, reverse=True)
```

key와 reverse 매일. sorted는 본인이 데이터를 다룰 때 정말 자주 써요. "나이순으로 정렬", "이름순으로", "점수 높은 순으로". 다 sorted + key예요. key에 lambda로 "무엇을 기준으로 정렬할지"를 주고, reverse=True로 내림차순을 만들어요. 그리고 중요한 점 하나. sorted는 원본을 안 바꾸고 새 list를 줘요. `sorted(cats)`는 정렬된 새 list를 돌려주고, 원본 cats는 그대로예요. 반면 리스트의 `.sort()` 메서드는 원본을 직접 바꿔요. 둘이 달라요. 원본을 보존하고 싶으면 sorted(), 원본을 바꿔도 되면 .sort(). 보통은 원본을 안 바꾸는 sorted()가 안전해요. H2에서 본 mutable 함정 기억하시죠. 원본을 바꾸는 .sort()는 그 함정에 빠질 수 있어요. 그래서 자경단은 sorted()를 선호해요. 새 정렬본을 받고 원본은 그대로 두는 게 사고가 적어요.

**reversed** — 역순.
```python
list(reversed([1, 2, 3]))   # [3, 2, 1]
```

리스트를 거꾸로 뒤집어요. 최근 것부터 보여줄 때 자주 써요.

reversed는 lazy. list로 감싸야 결과 봄.

여기서 자경단의 흥미로운 선택을 짚고 싶어요. filter와 map은 다른 언어에서 정말 많이 쓰는 함수예요. 그런데 자경단은 이 둘을 거의 안 쓰고 comprehension을 써요. 왜일까요. `list(filter(lambda c: c.age >= 18, cats))`와 `[c for c in cats if c.age >= 18]`를 비교해 보세요. 둘이 같은 일을 하는데, comprehension이 더 읽기 쉬워요. filter는 lambda를 쓰고, 결과를 list로 또 감싸야 해요. comprehension은 그냥 한 줄에 다 들어가고 영어처럼 읽혀요. map도 마찬가지예요. `list(map(lambda c: c.age, cats))`보다 `[c.age for c in cats]`가 명료해요. 그래서 파이썬의 선("가독성이 중요하다")을 따라, 자경단은 filter/map 대신 comprehension을 표준으로 해요. 다만 filter와 map을 알아는 둬야 해요. 다른 사람 코드나 옛 코드에서 만나거든요. 만나면 "아, 이건 comprehension으로 바꿀 수 있겠네" 하고 읽으면 돼요. 반면 sorted와 reversed는 매일 써요. 이 둘은 comprehension으로 대체가 안 되거든요. 정렬과 역순은 sorted/reversed의 고유 영역이에요. 정리하면, 필터와 변환은 comprehension으로, 정렬은 sorted로. 이게 자경단의 데이터 처리 표준이에요. 도구가 여럿 있어도, 가장 읽기 쉬운 걸 고르는 게 좋은 개발자예요.

---

## 6. 넷째 무리 — comprehension·iter·next 세 도구

**comprehension** 4종은 H2에서 자세히. 본인의 흐름 도구 중 가장 자주 쓰는 거예요. 한 줄.

```python
[x*2 for x in xs]
{x*2 for x in xs}
{k:v for k,v in pairs}
(x*2 for x in xs)
```

comprehension이 이 18 도구의 중심에 있는 이유를 짚을게요. 사실 filter와 map은 comprehension으로 대체되고, sum·min·max에 generator로 들어가는 것도 comprehension의 사촌이에요. comprehension 하나를 깊이 익히면, 데이터 변환의 대부분이 풀려요. "거르기"(if 필터), "바꾸기"(표현식), "모으기"(괄호). 이 세 가지를 한 줄에 조합해요. 그래서 자경단은 신입에게 "comprehension을 손에 익히는 게 흐름 도구의 절반"이라고 말해요. 본인이 18 도구를 다 못 외워도, comprehension 하나만 자유자재로 쓰면 데이터 처리의 80%가 돼요. 매일 쓰면서 손에 박으세요. for로 풀어 짜다가 "아, 이거 comprehension 한 줄로 되네" 하는 순간이 점점 늘어요. 그게 본인이 Python다워지는 과정이에요.

**iter** + **next** — iterator 직접 다루기.

```python
it = iter([1, 2, 3])
next(it)   # 1
next(it)   # 2
next(it)   # 3
next(it)   # StopIteration
```

자경단 가끔. 보통 for가 자동 처리. 그래도 알아 두면 "딱 하나만 꺼내기" 같은 특수한 상황에서 본인을 구해요.

iter와 next를 본인이 직접 쓸 일은 드물지만, 이게 for 루프의 진짜 정체예요. Ch008 H1에서 살짝 봤죠. 본인이 `for x in xs`를 쓰면, Python이 안에서 `it = iter(xs)`로 iterator를 만들고, `next(it)`를 계속 불러서 하나씩 꺼내고, StopIteration이 나면 멈춰요. for가 이 과정을 자동으로 해 주는 거예요. 그러니까 본인이 직접 iter/next를 쓰는 건, for가 하는 일을 수동으로 하는 거예요. 그럼 언제 직접 쓸까요. "딱 한 개만 꺼내고 싶을 때"예요. 예를 들어 어떤 조건에 맞는 첫 번째 요소만 필요하면, `next(c for c in cats if c.is_active, None)`처럼 generator에서 next로 하나만 꺼내요. for를 다 돌 필요 없이 첫 번째에서 멈춰요. 이게 H5 환율 계산기 v2에서 "특정 통화를 찾는" 코드에 쓰여요. 그리고 본인이 두 해 코스 후반에 generator를 직접 만들 때(yield), iter/next의 이해가 토대가 돼요. 오늘은 "for는 사실 iter+next의 자동화다"라는 그림만. 이게 H7에서 깊이 다뤄져요. for의 속을 알면, for가 마법이 아니라 정직한 기계로 보여요.

---

## 7. 다섯째 무리 — itertools·functools·collections

표준 라이브러리의 함수형 도구 묶음이에요. 세 모듈을 차례로 봐요.

**itertools 다섯 가지**

```python
from itertools import chain, groupby, accumulate, product, combinations

# chain — 여러 iterable을 하나로
list(chain([1, 2], [3, 4]))   # [1, 2, 3, 4]

# groupby — 같은 key 그룹화
for key, group in groupby(sorted(cats, key=lambda c: c.color), key=lambda c: c.color):
    print(key, list(group))

# accumulate — 누적합
list(accumulate([1, 2, 3, 4]))   # [1, 3, 6, 10]

# product — 곱 (모든 조합)
list(product([1, 2], ["a", "b"]))   # [(1,'a'), (1,'b'), (2,'a'), (2,'b')]

# combinations — 조합
list(combinations([1, 2, 3], 2))   # [(1,2), (1,3), (2,3)]
```

이 itertools 도구들은 매일은 아니지만, 필요한 순간에 본인을 구해요. chain은 여러 리스트를 하나로 이어 줘요. 여러 곳에서 온 데이터를 합쳐서 한 번에 처리할 때요. groupby는 "같은 종류끼리 묶기"를 해 줘요. cat들을 색깔별로 묶을 때, 정렬한 다음 groupby를 쓰면 색깔별 그룹이 나와요. 다만 groupby는 함정이 있어요. 반드시 먼저 그 기준으로 정렬해야 해요. groupby는 "연속된 같은 값"만 묶거든요. 정렬 안 하면 흩어진 같은 값들을 못 묶어요. 그래서 `groupby(sorted(...))`가 표준 패턴이에요. accumulate는 누적합이에요. [1,2,3,4]를 [1,3,6,10]으로요. 매출 누적, 점수 누적 같은 데 써요. product는 "모든 조합"을 만들어요. 색깔 3개 × 크기 2개 = 6가지 모든 조합처럼요. 이게 H2에서 본 중첩 for를 한 줄로 만드는 도구이기도 해요. `product(colors, sizes)`가 이중 for를 대체해요. combinations는 "순서 없이 고르기"예요. 5명 중 2명 짝짓기 같은 거요. 이 도구들은 본인이 데이터를 조합하거나 그룹핑할 때 빛나요. 매일 쓰진 않지만, "이거 어떻게 하지?" 싶을 때 itertools에 답이 있을 때가 많아요. "여러 개를 조합·그룹·누적할 일이 생기면 itertools를 뒤져라." 이게 5년 차의 습관이에요.

**functools**

```python
from functools import reduce, lru_cache, partial

# reduce — 누적
reduce(lambda a, b: a + b, [1, 2, 3, 4])   # 10

# lru_cache — 함수 결과 캐싱
@lru_cache(maxsize=128)
def fib(n):
    return n if n < 2 else fib(n-1) + fib(n-2)

# partial — 일부 인자 고정
add5 = partial(lambda a, b: a + b, 5)
add5(3)   # 8
```

이 셋 중에서 lru_cache가 진짜 마법이에요. 한 장면으로 보여드릴게요. 위 fib(피보나치) 함수는 자기 자신을 두 번 부르는데, 이게 캐싱 없이는 끔찍하게 느려요. fib(40)을 부르면 같은 계산을 수백만 번 반복하거든요. 그런데 함수 위에 `@lru_cache` 한 줄만 붙이면, Python이 "이 입력에 대한 결과를 이미 계산했으면 다시 안 하고 저장해 둔 걸 준다"고 해요. fib(10)을 한 번 계산하면, 다음에 fib(10)이 필요할 때 다시 계산 안 하고 저장된 답을 줘요. fib(40)이 몇 초 걸리던 게 0.001초가 돼요. 줄 하나로 수천 배 빨라지는 거예요. 이게 "메모이제이션"이라고 부르는 기법이에요. 같은 계산을 반복하는 함수에 lru_cache 한 줄만 붙이면 마법처럼 빨라져요. 다만 주의할 게 있어요. 캐싱은 "같은 입력엔 같은 출력"이 보장될 때만 안전해요. 함수가 매번 다른 결과를 내거나(랜덤·시간), 입력이 mutable(리스트)이면 사고가 나요. 그래서 lru_cache는 입력이 immutable(숫자·문자열·튜플)이고 결과가 일정한 순수 함수에만 써요. 이 조건만 지키면, lru_cache는 본인의 느린 함수를 한 줄로 구해 주는 마법이에요. 본인이 두 해 코스에서 같은 계산을 반복하는 함수를 만나면, lru_cache를 떠올리세요.

**collections**

```python
from collections import Counter, defaultdict, deque, namedtuple

# Counter — 빈도수
Counter("hello")   # {'l': 2, 'h': 1, 'e': 1, 'o': 1}

# defaultdict — 기본값 dict
d = defaultdict(list)
d["cats"].append("까미")   # KeyError 없음

# deque — 양방향 큐
q = deque([1, 2, 3])
q.appendleft(0)

# namedtuple — 이름 있는 tuple
Point = namedtuple("Point", ["x", "y"])
p = Point(1, 2)
```

deque와 namedtuple도 짧게 짚을게요. deque(데크)는 "양쪽 끝에서 빠르게 넣고 빼는" 리스트예요. 일반 리스트는 맨 앞에 넣는 게 느려요(뒤의 모든 걸 밀어야 하니까). deque는 앞뒤 둘 다 빨라요. 큐(줄서기)나 최근 N개 기록 같은 데 써요. namedtuple은 "이름이 붙은 튜플"이에요. 일반 튜플은 `p[0]`, `p[1]`로 접근하는데 그게 뭔지 헷갈려요. namedtuple은 `p.x`, `p.y`로 접근해서 의미가 분명해요. 다만 요즘은 namedtuple보다 dataclass를 더 써요(Ch009에서). dataclass가 더 유연하거든요. 그래서 deque는 특수한 경우에, namedtuple은 dataclass로 넘어가는 징검다리로 알아 두세요. collections의 핵심은 역시 Counter와 defaultdict예요. 이 둘이 매일이고, deque·namedtuple은 가끔이에요.

세 모듈이 자경단의 흐름 곱셈 도구.

이 세 모듈 중에서 본인이 가장 자주 쓸 건 collections의 Counter와 defaultdict예요. 왜 강력한지 한 장면으로 보여드릴게요. 본인이 "어떤 색깔 cat이 몇 마리인지" 세고 싶어요. 일반 dict로 하면 골치 아파요. "이 색깔이 dict에 있나? 없으면 0으로 시작, 있으면 +1" 같은 걸 매번 확인해야 해요. defaultdict(int)를 쓰면 `d[color] += 1` 한 줄이면 돼요. 없는 키도 자동으로 0부터 시작하거든요. KeyError가 안 나요. 더 간단하게는 Counter예요. `Counter(c.color for c in cats)`라고 하면, 색깔별 개수가 한 줄에 다 세어져요. 그리고 `.most_common(3)`으로 "가장 많은 색깔 3개"를 바로 뽑아요. H2에서 "빈도 분석"을 면접 단골이라고 했죠. Counter가 그 한 줄 답이에요. 본인이 두 해 코스에서 데이터를 셀 일이 정말 많아요. 단어 빈도, 색깔 분포, 사용자 국가별 수. 이걸 일반 dict로 하면 매번 고생이지만, Counter와 defaultdict가 한 줄로 만들어요. 그래서 자경단의 데이터 처리 코드에 이 둘이 자주 나와요. itertools의 groupby와 chain도 가끔 빛나지만, 매일 쓰는 건 Counter와 defaultdict예요. 이 둘만 먼저 손에 익혀도 본인의 데이터 처리가 우아해져요. 나머지는 필요할 때 다시 만나면서요. 이 collections 도구들은 Ch010에서 더 깊이 다뤄요. 오늘은 "세는 건 Counter, 그룹핑은 defaultdict"만 기억하세요.

---

## 8. 매일·주간·월간 손가락 리듬

**매일 6개** (Ch007 도구 포함). for, enumerate, len, list comp, zip, sorted.

**주간 5개**. sum, min, max, any, all.

**월간 3개**. filter, map, reversed.

**필요 시**. itertools, functools, collections.

매일 6개부터.

이 리듬에서 한 가지를 강조하고 싶어요. 이 18 도구는 H1의 네 친구(if·for·while·comprehension)와 다른 역할이에요. 네 친구는 "흐름을 만드는" 기본이고, 18 도구는 "흐름을 더 우아하게 만드는" 도구예요. 본인이 네 친구만 알아도 코드는 짜져요. for로 일일이 돌면서 합을 구할 수 있어요. 그런데 sum 한 줄을 알면 그게 더 짧고 명료해요. 그러니까 18 도구는 "필수"가 아니라 "있으면 더 좋은" 거예요. 본인이 처음엔 for로 풀어 짜다가, "아, 이거 sum 한 줄로 되네", "이거 sorted 한 줄로 되네" 하면서 하나씩 도구를 들여요. 그러면 본인 코드가 점점 짧고 우아해져요. 그래서 이 도구들을 한 번에 다 외우려 하지 마세요. for로 코드를 짜다가, 반복되는 패턴이 보이면 "이걸 한 줄로 만드는 도구가 있나?" 하고 찾으세요. 합을 자주 구하면 sum을, 정렬을 자주 하면 sorted를, 세는 걸 자주 하면 Counter를. 본인의 필요가 본인에게 도구를 가르쳐 줘요. 매일 만나는 6개부터 손에 익히고, 나머지는 필요가 생길 때 하나씩. 그게 도구를 진짜 본인 것으로 만드는 길이에요.

---

## 9. 자경단 매일 13줄 흐름

```python
# 자경단 백엔드 까미의 매일
def get_active_users(users):
    return [u for u in users if u.is_active]

def avg_age(users):
    return sum(u.age for u in users) / len(users)

def find_user(users, user_id):
    for u in users:
        if u.id == user_id:
            return u
    return None

def group_by_country(users):
    from collections import defaultdict
    result = defaultdict(list)
    for u in users:
        result[u.country].append(u)
    return result
```

13줄 안에 18 도구 중 8개. 자경단 매일 패턴.

이 까미의 코드를 한 줄씩 음미해 보세요. get_active_users는 comprehension + if로 활동 중인 사용자만 걸러요. avg_age는 sum + len으로 평균을 한 줄에 구해요. find_user는 for + if로 찾고 return으로 빠져나오고, 못 찾으면 None을 줘요(H2의 None 패턴). group_by_country는 defaultdict로 국가별 그룹을 만들어요. 이 네 함수가 백엔드에서 가장 흔한 네 가지 일이에요. 거르기, 집계하기, 찾기, 그룹핑하기. 본인이 두 해 코스에서 백엔드를 짜면, 이 네 패턴을 하루에도 수십 번 만나요. 그리고 보세요, 각 함수가 짧아요. 두세 줄이에요. 18 도구 덕에 짧게 짜지는 거예요. 만약 도구 없이 일반 for로만 짰으면 각 함수가 두 배는 길어졌을 거예요. 짧은 함수는 읽기 쉽고, 테스트하기 쉽고, 버그도 적어요. 이게 18 도구가 본인에게 주는 진짜 선물이에요. 코드를 짧고 명료하게. 본인이 이 네 패턴을 손에 익히면, 본인의 백엔드 코드가 까미처럼 깔끔해져요. 오늘 이 13줄을 본인 환율 계산기에도 적용해 보세요. 활동 통화 거르기, 평균 환율 구하기, 특정 통화 찾기. 같은 패턴이에요.

---

## 10. 다섯 함정과 처방

**함정 1: range로 인덱스 직접**

```python
for i in range(len(items)):
    print(i, items[i])
```

처방. enumerate.

**함정 2: list comp 부수 효과**

```python
[print(c) for c in cats]   # 결과 안 씀
```

처방. 일반 for.

**함정 3: lambda 남용**

```python
sorted(cats, key=lambda c: c.age)
```

OK지만 named function이 더 가독성. 자경단은 lambda 한 줄까지.

**함정 4: filter/map vs comp**

```python
list(filter(lambda c: c.age > 3, cats))
```

처방. comp.

```python
[c for c in cats if c.age > 3]
```

**함정 5: dict.keys() iteration**

```python
for k in d.keys():
    print(k, d[k])
```

처방. .items().

```python
for k, v in d.items():
    print(k, v)
```

이 다섯 함정에 공통점이 있어요. 다 "C 스타일이나 옛 방식을 Python 방식으로 바꾸기"예요. range(len) 대신 enumerate, filter/map 대신 comprehension, keys() 대신 items(). 다른 언어에서 온 사람이나 옛 Python 코드가 이런 함정에 빠져요. Python에는 더 우아한 길이 있는데 모르고 돌아가는 거죠. 이걸 "Pythonic하지 않다"고 해요. Pythonic은 "Python답게"라는 뜻이에요. 같은 일을 해도 Python의 정신(가독성·간결함)에 맞게 짜는 거예요. AI 코드 리뷰 도구들이 이 함정들을 다 잡아요. range(len)을 보면 enumerate를, 부수효과 comprehension을 보면 for를 추천해요. 본인이 이 다섯 함정을 미리 알아 두면, 처음부터 Pythonic하게 짤 수 있어요. 그러면 코드 리뷰에서 "이거 enumerate로 바꾸세요" 같은 지적을 안 받아요. Pythonic하게 짜는 것, 그게 본인이 Python 개발자 사회에 자연스럽게 녹아드는 길이에요. 다섯 함정을 피하는 것만으로도 본인 코드가 한결 Python다워져요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: 18 도구 다 외워야.**

매일 6개. 6주에 18개.

**오해 2: filter/map이 comp보다 빠르다.**

비슷. comp가 가독성 우선.

**오해 3: itertools는 옵션.**

매일은 아니어도, 데이터를 그룹핑·조합·누적할 때 itertools에 답이 있어요. groupby, chain을 알아 두면 그날 본인이 바퀴를 다시 발명 안 해요.

**오해 4: lambda는 함수.**

익명 함수. def보다 짧지만 디버깅 어려움.

**오해 5: sorted가 list만.**

iterable 모두. 결과는 list. dict든 set이든 generator든 sorted에 넣을 수 있고, 결과는 항상 정렬된 list로 나와요. `sorted(my_dict)`는 키를 정렬한 list를 줘요.

**오해 6: 도구를 많이 알수록 좋은 개발자다.**

아니에요. 적은 도구를 깊이 쓰는 게 나아요. for·comprehension·sum·sorted 정도면 본인 코드의 90%가 돼요. 화려한 itertools를 남발하면 오히려 동료가 못 읽어요. 읽기 쉬운 게 우선이에요.

**오해 7: lambda를 많이 쓰면 고수다.**

반대예요. 복잡한 lambda는 읽기 어려워요. 한 줄 넘는 로직은 named function(def)으로 빼는 게 나아요. lambda는 sorted의 key처럼 정말 짧은 한 줄에만.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. lambda vs def?**

한 줄 표현은 lambda, 복잡한 로직은 def.

**Q2. sorted key?**

`key=lambda c: c.age`. 정렬 기준 함수.

**Q3. itertools 어디서?**

큰 데이터 처리. groupby가 자주.

**Q4. Counter 매일?**

빈도 분석에 강력. 자경단 데이터팀 매일.

**Q5. lru_cache 위험?**

mutable 인자에 사고. immutable만 캐싱. 그리고 캐시가 메모리에 쌓이니까, maxsize를 정해 두는 게 안전해요. `@lru_cache(maxsize=128)`처럼요. 무제한으로 두면 메모리가 끝없이 늘 수 있어요.

**Q6. 18 도구 중 진짜 매일 쓰는 건?**

솔직히 for, comprehension, len, sum, sorted, enumerate 여섯이에요. 이 여섯이 본인 흐름 도구의 90%예요. 나머지 12개는 가끔 또는 필요할 때. 그러니까 부담 갖지 마세요. 여섯만 손에 박으면 본인은 충분히 빠른 개발자예요.

**Q7. itertools와 collections를 외워야 하나요?**

아니요. "이런 게 있다"만 알아 두세요. 세는 건 Counter, 그룹핑은 defaultdict, 조합은 itertools. 이 정도 그림만 있으면, 필요할 때 검색해서 정확한 사용법을 찾아요. 외우는 게 아니라 "어디에 답이 있는지"를 아는 거예요. 그게 진짜 실력이에요.

---

## 13. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, 명령 다 외우기. 안심 — 매일 5개.
둘째, 위험 명령 함부로. 안심 — 0.5초 멈춤.
셋째, 결과 확인 안 함. 안심 — `git status`/`echo $?`.
넷째, 한 줄 욱여넣기. 안심 — 다섯 줄이 명확.
다섯째, 가장 큰 — 검색 명령 그대로. 안심 — explainshell.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

이 다섯 실수 중에서 흐름 도구와 가장 관련 깊은 게 네 번째, "한 줄 욱여넣기"예요. 본인이 18 도구를 배우면, 모든 걸 한 줄로 만들고 싶은 유혹이 생겨요. comprehension 안에 if를 두 개 넣고, lambda를 중첩하고, itertools를 줄줄이 엮고. "이거 봐, 한 줄로 했어!" 하고 뿌듯해해요. 그런데 그 한 줄은 6개월 후 본인도 못 읽어요. 도구를 많이 안다고 다 한 줄에 욱여넣는 게 실력이 아니에요. 읽기 쉽게 적절히 나누는 게 실력이에요. 파이썬의 선 — "가독성이 중요하다", "단순한 게 복잡한 것보다 낫다". 한 줄짜리 영리한 코드보다, 세 줄짜리 읽기 쉬운 코드가 나아요. 18 도구는 본인을 "한 줄 마법사"로 만들려고 있는 게 아니라, 본인의 코드를 "적절히 짧고 명료하게" 만들려고 있는 거예요. 도구를 많이 알수록, 오히려 "언제 쓰고 언제 안 쓸지"를 아는 게 중요해져요. 그게 절제예요. 좋은 개발자는 도구를 절제할 줄 알아요.

## 14. 마무리 — 다음 H5에서 만나요

자, 네 번째 시간이 끝났어요. 60분에 18 도구. 정리하면.

반복 4, 집계 5, 필터 4, comp 3, itertools/functools/collections. 매일 6개부터 6주에 18개. 자경단 13줄 흐름.

오늘 18 도구 중에서 딱 여섯만 가져가세요. for, comprehension, len, sum, sorted, enumerate. 이 여섯이 본인이 매일 쓸 거예요. 나머지 12개는 카탈로그에 있다는 것만 기억하고, 필요해지는 순간에 다시 펼쳐 보세요. 도구는 한 번에 다 익히는 게 아니라, 필요가 생길 때 하나씩 손에 잡는 거예요. 그리고 이 도구들이 H1~H2의 네 친구를 더 우아하게 만든다는 걸 기억하세요. 기본(if·for·while·comprehension)이 토대고, 18 도구는 그 위의 우아함이에요. 본인은 이제 흐름의 기본과 도구를 다 봤어요. H5에서 그걸 본인 손으로 조립해요.

박수 한 번 칠게요. 잘 따라오셨어요.

다음 H5는 30분 데모예요. 본인이 Ch007에서 짠 환율 계산기 v1 50줄을, 오늘 배운 제어 흐름으로 v2 150줄로 진화시켜요. 메뉴가 생기고, 히스토리가 생기고, 진짜 프로그램다워져요. 본인 코드가 눈앞에서 자라는 걸 보는 시간이에요. 한 시간 후 만나요.

```python
python3 -c 'cats=[(\"까미\",3),(\"노랭이\",2)]; print(sorted(cats, key=lambda c: c[1]))'
```

---

## 👨‍💻 개발자 노트

> - itertools 게으름: 모두 generator. list로 감싸야 결과.
> - functools.reduce: 우→좌 또는 좌→우 (initial value).
> - collections.Counter.most_common(N): 상위 N개.
> - lru_cache vs cache: cache는 무제한, lru_cache는 N개 제한.
> - namedtuple vs dataclass: namedtuple은 tuple 기반, dataclass는 class 기반. 모던은 dataclass.
> - 다음 H5 키워드: 환율 계산기 v2 · 150줄 · 9 함수 · 18 도구.

---

## 추신

1. 흐름 도구 18개. 제어 흐름을 더 우아하게.
2. 5 무리 — 반복 4·집계 5·필터 4·comp 3·itertools 등.
3. 반복 4 — for·enumerate·zip·range.
4. enumerate `start=1`로 1부터. zip은 짧은 쪽에서 멈춤.
5. range 3 — range(5)·range(1,6)·range(0,10,2). lazy.
6. 집계 5 — sum·min·max·len·any·all.
7. `max(cats, key=lambda c: c.age)`로 비교 기준.
8. any=하나라도 truthy, all=모두 truthy.
9. 필터/변환/정렬 4 — filter·map·sorted·reversed.
10. filter/map보다 comprehension 선호. 가독성.
11. sorted `key`·`reverse=True` 매일.
12. reversed는 lazy. list로 감싸야 결과.
13. comprehension 4 — list·set·dict·generator(H2).
14. iter()+next()로 iterator 직접. 보통 for가 자동.
15. itertools 5 — chain·groupby·accumulate·product·combinations.
16. chain=여러 iterable 하나로. groupby=같은 key 묶기.
17. functools — reduce·lru_cache·partial.
18. lru_cache는 함수 결과 캐싱. immutable 인자만.
19. collections — Counter·defaultdict·deque·namedtuple.
20. Counter=빈도수, `.most_common(N)`로 상위 N.
21. defaultdict(list)로 KeyError 없이 append.
22. itertools는 다 generator. list로 감싸야 결과.
23. lambda는 익명 함수. 한 줄까지만, 복잡하면 def.
24. 매일 6 — for·enumerate·len·list comp·zip·sorted.
25. 함정 — range(len) 대신 enumerate, keys() 대신 items().
26. list comp 부수효과(print) 금지. 결과 쓸 때만 comp.
27. namedtuple보다 dataclass가 모던(Ch009).
28. 도구는 제어 흐름의 곱셈기. 같은 일을 더 짧고 우아하게.
29. H4 졸업장 — `sorted(cats, key=lambda c: c[1])`.
30. 다음 H5는 환율 계산기 v2 150줄. 한 시간 쉬고 만나요. 🐾
