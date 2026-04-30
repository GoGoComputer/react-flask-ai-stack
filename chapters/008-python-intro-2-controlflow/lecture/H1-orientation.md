# Ch008 · H1 — Python 제어 흐름 오리엔테이션 — 코드의 60%를 차지하는 네 친구

> 고양이 자경단 · Ch 008 · 1교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — Ch007 회수와 오늘의 약속
2. 제어 흐름이 무엇인가 — 코드의 60%
3. 옛날 이야기 — 제가 처음 for 루프를 봤던 날
4. 왜 제어 흐름인가 — 일곱 가지 이유
5. 같이 쳐 보기 — 다섯 줄로 자경단 이름 출력
6. 네 친구 — if·for·while·comprehension
7. 0.001초의 여행 — for 한 줄이 거치는 5단계
8. Python의 흐름 vs 다른 언어
9. 자경단 다섯 명의 매일 흐름
10. 8교시 미리보기 — H2부터 H8까지
11. 제어 흐름 50년 — Dijkstra부터 match-case까지
12. AI 시대의 흐름 — Claude가 추천하는 패턴
13. 자주 받는 질문 다섯 가지
14. 흔한 오해 다섯 가지
15. 마무리 — 다음 H2에서 만나요

---

## 🔧 강사용 명령어 한눈에

```python
# if
if age >= 5:
    print("어른 cat")

# for
for cat in cats:
    print(cat)

# while
while count > 0:
    count -= 1

# comprehension
ages = [c.age for c in cats]
```

---

## 1. 다시 만나서 반가워요 — Ch007 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 8번째 챕터예요. 두 주 만이죠. 그동안 본인은 어떻게 지내셨어요. 지난 주말에 환율 계산기 한 번 다시 켜 보셨어요? 안 켜 보셨다고요. 괜찮아요. 살아있는 부탁이에요.

지난 Ch007을 한 줄로 회수할게요. 본인은 Python의 자료형과 도구를 만나셨어요. int·float·str·bool·None 다섯 자료형, 18 연산자, f-string, 18 도구. 그리고 본인의 첫 진짜 Python 스크립트 50줄. 그게 사전이었어요.

이번 챕터 Ch008은 그 사전을 진짜 문장으로 만드는 시간이에요. 자료형이 단어라면, 제어 흐름이 문법이에요. 본인이 단어를 알아도 문법이 없으면 문장을 못 만들어요. 제어 흐름이 본인의 문법.

오늘 8시간의 약속은 세 가지예요. 하나, 본인이 if, for, while, comprehension을 한 줄씩 영어처럼 짭니다. 둘, 본인 노트북에서 직접 30줄 짜리 자경단 게임을 짭니다. 셋, 8시간 끝에 본인의 환율 계산기가 v1 50줄에서 v2 150줄로 진화합니다. 약속드릴게요.

자, 가요.

---

## 2. 제어 흐름이 무엇인가 — 코드의 60%

본인이 1만 줄짜리 코드를 들여다보면 60%가 제어 흐름이에요. 진짜로요. if 문, for 루프, while 루프. 나머지 40%가 변수 할당, 함수 호출, 데이터 정의.

왜 60%인가. 컴퓨터에게 일을 시키려면 두 가지를 알려줘야 해요. 첫째, 어떤 데이터를 쓸지. 둘째, 그 데이터로 무엇을 할지. 무엇을 할지의 90%가 "어떤 조건에서 무엇을 한다"와 "여러 번 반복한다"예요. 그게 if와 for.

제어 흐름은 본인이 컴퓨터에게 "이렇게 결정하라"고 알려 주는 문법이에요. 다른 말로 logic이라고 불러요. 본인의 로직이 코드에 박혀요.

자경단 까미가 매일 짜는 백엔드 코드 한 부분을 보여드릴게요.

```python
def get_user(user_id):
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise UserNotFoundError(user_id)
    if user.is_banned:
        raise BannedUserError(user_id)
    if user.is_deleted:
        return None
    return user
```

세 if문이 보이죠. 이 함수의 60%가 if. 데이터 가져오기 한 줄, return 한 줄, 나머지가 다 if. 자경단의 매일 이런 코드예요. 제어 흐름이 코드의 절반 이상을 차지해요.

본인이 8시간 후엔 이런 코드를 1초에 읽고, 5초에 짜요. 그게 약속이에요.

---

## 3. 옛날 이야기 — 제가 처음 for 루프를 봤던 날

옛날 이야기 하나 할게요. 제가 처음 for 루프를 본 날. 12년 전. Python을 시작하고 한 달쯤 지났을 때예요.

회사에서 사수 형이 또 와서 부탁했어요. 1만 개 파일에서 특정 단어를 찾으라고. 저는 또 Excel 켜려고 했어요. 형이 말려요. "Python으로 한 줄에 끝나" 하고 코드를 한 줄 보여줘요.

```python
matches = [f for f in files if "ERROR" in f]
```

저는 그 한 줄을 한참 봤어요. 무슨 뜻인지 모르겠더라고요. for인데 끝에 if가 붙고, 결과가 리스트가 되고. 형이 풀어 줬어요. "files 안의 각 f에 대해, ERROR가 들어 있으면, f를 모은 리스트". 영어로 그대로 읽혔어요.

저는 그날 이후 list comprehension에 빠졌어요. for 루프 한 줄로 못 하는 게 없어 보였어요. 매일 다섯 줄씩 새 패턴을 짰어요. 한 달 후 저는 "아무 데이터든 한 줄로 처리하는 사람"이 됐어요.

그런데 정말 충격은 한 1년 후에 왔어요. 어느 날 후배가 50줄짜리 for 루프로 짠 코드를 가지고 왔어요. "도와주세요" 하고. 저는 그 50줄을 5줄짜리 list comprehension으로 줄여 줬어요. 후배가 입을 벌렸어요. 그날 저는 깨달았어요. **for 루프는 단순한 반복이 아니다. 데이터 변환의 표현이다**. 본인도 8시간 후 똑같이 깨달아요. 약속드려요.

---

## 4. 왜 제어 흐름인가 — 일곱 가지 이유

본인이 제어 흐름을 깊이 배워야 하는 이유가 일곱 개 있어요.

첫째, **코드의 60%**예요. 위에서 봤어요. 60%를 못 짜면 본인은 코드의 40%만 가진 사람이에요.

둘째, **데이터 처리**예요. 본인이 만나는 모든 데이터 — 사용자 목록, API 응답, 로그 파일 — 다 반복으로 처리해요. for 루프 없으면 데이터를 못 만져요.

셋째, **알고리즘의 토대**예요. 정렬, 검색, 그래프, 트리. 모든 알고리즘이 if와 for로 짜요. 면접 단골 알고리즘 100개가 다 제어 흐름 위에 있어요.

넷째, **버그의 80%가 제어 흐름**이에요. 무한 루프, off-by-one, 경계 조건. 본인이 5년 동안 만날 버그의 80%가 if와 for의 함정이에요. 깊이 알면 버그 면역.

다섯째, 이게 정말 새로운 이유인데요. **AI 시대의 코드 리뷰 도구**예요. AI가 본인 코드를 보고 "이 for 루프는 list comprehension으로 더 간결하게"라고 추천해요. 본인이 추천을 알아들으려면 comprehension 패턴을 알아야 해요.

여섯째, **자경단 매일 사용**이에요. 까미는 매일 50번 if, 100번 for. 노랭이는 매일 30번. 미니는 매일 80번. 다섯 명 합치면 매일 1,500번 제어 흐름. 5년이면 270만 번.

일곱째, **면접 단골**이에요. "리스트에서 중복 제거", "두 리스트 교집합", "가장 자주 나오는 단어 5개". 모두 제어 흐름 한 줄. 1초 답이면 합격.

일곱 가지 다 외우실 필요 없어요. 한 가지만 머리에 두세요. **제어 흐름은 본인의 코드 두뇌의 60%다**. 그 60%를 8시간에 깊이 박아요.

---

## 5. 같이 쳐 보기 — 다섯 줄로 자경단 이름 출력

말로만 하면 졸리잖아요. 한 번 손을 풀어 봅시다.

> ▶ **같이 쳐보기** — 자경단 다섯 명 출력
>
> ```python
> python3
> >>> cats = ["본인", "까미", "노랭이", "미니", "깜장이"]
> >>> for cat in cats:
> ...     print(f"안녕 {cat}!")
> ```

엔터 누르면 다섯 줄이 떠요.

```
안녕 본인!
안녕 까미!
안녕 노랭이!
안녕 미니!
안녕 깜장이!
```

다섯 줄이 한 번에. 본인이 다섯 번 print 안 친 거예요. for 루프가 한 번 돌면서 다섯 번 자동으로. 그게 반복의 마법이에요.

이 한 줄을 list comprehension으로 한 번 더 짧게 만들 수 있어요.

```python
>>> [f"안녕 {cat}!" for cat in cats]
```

[]로 감싸면 결과가 리스트로 나와요.

```
['안녕 본인!', '안녕 까미!', '안녕 노랭이!', '안녕 미니!', '안녕 깜장이!']
```

세 줄짜리 for문이 한 줄로. comprehension의 매력이에요. H2에서 깊이 다뤄요.

---

## 6. 네 친구 — if·for·while·comprehension

Python의 제어 흐름에는 네 친구가 살고 있어요.

첫 친구는 **if**예요. 조건 분기. "이 조건이면 이걸 해라". 가장 자주 만나는 친구.

```python
if age >= 5:
    print("어른 cat")
elif age >= 3:
    print("청년 cat")
else:
    print("어린 cat")
```

if 다음에 elif (else if), 마지막에 else. 셋이 한 묶음.

두 번째 친구는 **for**예요. iterable을 차례로 돌기.

```python
for cat in cats:
    print(cat)
```

세 번째 친구는 **while**이에요. 조건이 참인 동안 반복.

```python
count = 0
while count < 5:
    print(count)
    count += 1
```

네 번째 친구는 **comprehension**이에요. for를 한 줄에 압축한 표현.

```python
ages = [c.age for c in cats]
```

네 친구가 본인의 매일 60% 코드를 만들어 줘요. H2에서 한 명씩 깊이.

---

## 7. 0.001초의 여행 — for 한 줄이 거치는 5단계

본인이 `for cat in cats: print(cat)`이라고 한 줄 짜고 실행을 누르면, 그 0.001초 안에 무엇이 일어나는지 따라가요.

0초. 인터프리터가 이 한 줄을 bytecode로 컴파일.

0.0001초. cats 리스트의 iter() 메서드 호출. iterator 객체 생성.

0.0003초. iterator의 __next__() 호출. 첫 요소 "본인" 가져오기.

0.0005초. cat 변수에 "본인" 할당. print("본인") 호출. 화면에 출력.

0.0007초. 다시 __next__(). 다음 요소 "까미". 같은 사이클.

0.001초. StopIteration 예외 발생. 루프 종료.

다섯 단계. 0.001초. 다섯 명 출력 한 사이클이에요. iterator 프로토콜이 Python의 핵심이에요. H7에서 깊이 다뤄요. 오늘은 그림만.

---

## 8. Python의 흐름 vs 다른 언어

| 언어 | for 루프 | 한 줄 평 |
|------|---------|----------|
| Python | `for x in xs:` | 영어 같음, iterable 모두 |
| JavaScript | `for (let x of xs)` | 비슷, 세미콜론 있음 |
| C | `for (int i=0; i<n; i++)` | 인덱스 기반, 길고 복잡 |
| Rust | `for x in xs.iter()` | Python 비슷, 더 안전 |

Python의 for가 가장 짧고 직관적. C 같은 언어는 인덱스를 직접 다루지만 Python은 iterable을 직접. 그래서 본인이 짜는 코드가 짧아요.

---

## 9. 자경단 다섯 명의 매일 흐름

자경단 다섯 명이 매일 짜는 제어 흐름의 종류가 달라요.

**까미** (백엔드). if 50번, for 100번. API 핸들러의 검증과 데이터 변환.

**노랭이** (프론트). if 30번, for 50번. 컴포넌트 렌더링과 props 처리.

**미니** (인프라). if 40번, for 80번. AWS 리소스 순회와 조건 처리.

**깜장이** (QA). if 20번, for 30번. 테스트 케이스 생성과 검증.

**본인** (메인테이너). if 50번, for 100번. 다양한 코드 리뷰.

다섯 명 합치면 매일 if 190번, for 360번. 합쳐 550번 제어 흐름. 1년이면 20만 번.

본인이 두 해 코스 끝엔 까미와 비슷하게 매일 100번 for를 짜요. 시작은 오늘.

---

## 10. 8교시 미리보기 — H2부터 H8까지

H2 — 핵심 개념 8개. if/elif/else, truthy/falsy, for+iterable, while, break/continue, match-case, comprehension 4종, walrus.

H3 — 디버깅 셋업. VS Code 디버거, breakpoint(), pdb, rich.print, ipython 매직.

H4 — 18 도구 카탈로그. 반복 4, 집계 5, 필터 4, comprehension 3, itertools/functools/collections.

H5 — 30분 데모. 환율 계산기 v1 50줄을 v2 150줄로 진화.

H6 — 운영. early return, guard clause, 복잡도 줄이기, radon으로 측정.

H7 — 깊이. CPython의 for 구현, iterator 프로토콜, generator, GIL.

H8 — 적용과 회고. Ch009 함수와 다리.

---

## 11. 제어 흐름 50년 — Dijkstra부터 match-case까지

쉬어 가는 한 절. 제어 흐름의 50년 역사.

1968년. Dijkstra가 "Go To Statement Considered Harmful"이라는 논문 발표. goto 사용 금지의 시작. 구조화 프로그래밍의 탄생.

1970년대. C 언어가 if/for/while을 표준화. 모든 언어의 토대.

1991년. Python 0.9. for, while, if/elif/else 첫 버전부터 있었어요.

2000년. Python 2.0. list comprehension 도입. `[x*2 for x in xs]`.

2008년. Python 3.0. dict, set comprehension 추가.

2018년. Python 3.8. walrus operator (`:=`) 추가. while 루프에서 강력.

2021년. Python 3.10. **match-case** 추가. switch 문의 강력 진화.

50년 진화. **goto → if/for/while → comprehension → walrus → match-case**. 본인이 매일 쓰는 흐름이 50년 진화의 정점이에요.

---

## 12. AI 시대의 흐름 — Claude가 추천하는 패턴

AI 도구가 본인 코드를 보고 추천하는 흐름 패턴 다섯 가지.

**1. 명시적 for를 list comprehension으로**

```python
# Before
result = []
for x in items:
    if x > 0:
        result.append(x * 2)

# Claude 추천
result = [x * 2 for x in items if x > 0]
```

**2. while True + break를 walrus로**

```python
# Before
while True:
    line = f.readline()
    if not line:
        break
    process(line)

# Claude 추천
while line := f.readline():
    process(line)
```

**3. 중첩 if를 early return으로**

```python
# Before
if user:
    if not user.is_banned:
        if user.has_permission:
            return user.data

# Claude 추천
if not user:
    return None
if user.is_banned:
    return None
if not user.has_permission:
    return None
return user.data
```

**4. if/elif 체인을 match-case로** (Python 3.10+)

**5. 인덱스 for를 enumerate로**

```python
# Before
for i in range(len(items)):
    print(i, items[i])

# Claude 추천
for i, item in enumerate(items):
    print(i, item)
```

다섯 패턴이 자경단의 매일 코드 리뷰 표준. AI가 추천하면 본인이 1초에 받아들일 수 있어야 해요. 8시간 후엔 가능.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. for와 while 어느 걸 쓰나요?**

iterable이 있으면 for. 조건만 있으면 while. 자경단 매일 95% for, 5% while.

**Q2. comprehension 못 따라가요.**

처음만 그래요. for 한 줄로 풀어서 짜고, 나중에 comprehension으로 압축. 6주면 자연.

**Q3. match-case 써도 되나요?**

Python 3.10+ 가능. 자경단 표준은 사용. 옛 Python 호환 필요하면 if/elif.

**Q4. break와 continue 차이?**

break는 루프 종료, continue는 다음 iteration. 사용처가 달라요.

**Q5. 8시간 너무 길어요.**

길어요. 그런데 60% 코드의 토대라 깊이 한 번. 한 시간씩 두 주에 한 번. 천천히.

---

## 14. 흔한 오해 다섯 가지

**오해 1: 제어 흐름은 단순하다.**

60%를 차지하는 단순함. 단순한 게 가장 어려워요.

**오해 2: comprehension은 어렵다.**

가장 짧은 표현이에요. 한 번 익히면 영어 그대로.

**오해 3: while이 자주 쓰여요.**

거의 안 써요. 95% for. while은 특수 경우.

**오해 4: 중첩 for가 깊으면 좋다.**

3단계 넘으면 사고. comprehension이나 함수로 분리.

**오해 5: match-case는 옵션이다.**

Python 3.10+ 표준. 자경단 표준은 사용.

---

## 15. 흔한 실수 다섯 가지 + 안심 멘트 — Python Control Flow 학습 편

Control flow 첫 시간 학습 함정 다섯.

첫 번째 함정, if/else만으로 모든 분기. 안심하세요. **3개 이상은 dict mapping이 깔끔.**

두 번째 함정, for vs while 헷갈림. 안심하세요. **횟수 정해진 건 for, 조건 기반은 while.** 99% for.

세 번째 함정, range 끝값 헷갈림. 본인이 `range(10)` 0~10으로 생각. 안심하세요. **0~9까지.** 끝값 미포함.

네 번째 함정, break vs continue 헷갈림. 안심하세요. **break = 루프 즉시 탈출, continue = 다음 반복.**

다섯 번째 함정, 가장 큰 함정. **deeply nested loop.** for 안 for 안 for. 안심하세요. **3단 이상은 함수로 분리.** 가독성 + 테스트.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 16. 마무리 — 다음 H2에서 만나요

자, 첫 시간이 끝났어요. 60분 동안 본인은 제어 흐름의 큰 그림을 받아 가셨어요. 정리하면 이래요.

제어 흐름은 본인 코드의 60%. 네 친구 — if·for·while·comprehension. 일곱 이유 — 60%, 데이터 처리, 알고리즘, 버그 80%, AI 시대, 자경단 매일, 면접. 다섯 명이 매일 합쳐 550번 흐름. 50년 진화 — goto부터 match-case까지.

박수 한 번 칠게요. 첫 시간 끝까지 들으신 본인이 자랑스러워요.

다음 H2는 핵심 개념 8개. if 5패턴, truthy/falsy 7깊이, for + iterable 5종, while + walrus, break/continue, match-case, comprehension 4종.

그 전에 한 가지 부탁. 본인 셸에서 다음 다섯 줄.

```python
python3 -c 'cats = ["까미", "노랭이"]; [print(c) for c in cats]'
python3 -c 'print([x*2 for x in range(5)])'
python3 -c 'print([x for x in range(10) if x%2==0])'
python3 -c 'print({c: len(c) for c in ["까미", "노랭이"]})'
python3 -c 'i=0
while i<3:
    print(i); i+=1'
```

5초예요. 본인의 H1 졸업장.

---

## 👨‍💻 개발자 노트

> - 구조화 프로그래밍: Dijkstra의 goto 폐지 → 시퀀스, 분기, 반복 세 가지로 모든 알고리즘 표현.
> - Python의 for: iterator 프로토콜 (__iter__, __next__). C의 인덱스 for와 다름.
> - while + walrus (PEP 572): 3.8+. 조건과 할당 동시.
> - match-case (PEP 634): 3.10+. switch보다 강력. 패턴 매칭.
> - list comprehension 성능: for 루프보다 20-30% 빠름. CPython 최적화.
> - dict/set comprehension: 3.0+. {k:v for ...}, {x for ...}.
> - generator expression: ()로 감싸면 lazy. 메모리 효율.
> - itertools.chain, groupby, accumulate: 함수형 흐름 도구.
> - 다음 H2 키워드: if 5패턴 · truthy/falsy · for+iterable · while+walrus · match-case · comprehension 4종.
