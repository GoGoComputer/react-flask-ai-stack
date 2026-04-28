# Ch008 · H1 — Python 입문 2: 제어 흐름 오리엔 — if·for·while·comprehension 4단어

> **이 H에서 얻을 것**
> - 제어 흐름 7이유 — 왜 if + for가 코드의 60%
> - 4 핵심 단어 (if·for·while·comprehension)
> - 8H 큰그림 — Ch008의 60분 × 8 = 8시간 전체
> - 자경단 5명 매일 if + for 1000+ 줄
> - 12회수 지도 (Ch009부터 평생)
> - 면접 5질문 + 흔한 오해 + FAQ

---

## 회수: Ch007의 자료형에서 Ch008의 흐름으로

지난 Ch007 (8시간) — Python 입문 1. 본인은 5 자료형(int·float·str·bool·None) + 18 연산자 + exchange.py 50줄 + PEP 8·black·ruff·mypy 7 운영 도구 + CPython VM·GIL·dis 5 원리를 익혔어요. **자료형이 데이터의 모양**.

본 Ch008 — Python 입문 2 (8시간). 본인은 if·for·while·comprehension 4 도구로 그 데이터를 **흐르게** 만들어요. **흐름이 로직의 결정**.

자료형 + 흐름 = Python 코드의 95%. Ch007 + Ch008이 자경단 1년 후 시니어의 두 다리.

지난 Ch005 H1은 git 협업 7이유, Ch006 H1은 터미널 7이유, Ch007 H1은 Python 7이유. 본 H는 제어 흐름 7이유. 셋이 합쳐 자경단 평생 학습의 4 첫 만남.

---

## 1. 제어 흐름 7이유 — 왜 if + for가 코드의 60%

### 이유 1: 데이터에 분기가 있다

자경단 5명 매일 — "환율이 1500원 이상이면 알림" "고양이가 5살 이상이면 노년 사료" "응답이 200이면 OK·404면 재시도". 모든 비즈니스 로직 = if 분기.

```python
if rate >= 1500:
    send_alert()
elif rate >= 1400:
    log_warning()
else:
    log_normal()
```

자경단 매일 1000+ 줄 if 분기. 60% 코드.

본인이 자경단 1주차에 본 첫 코드 — `if amount > 100000:` 한 줄. 1년 후 그 한 줄이 자경단 환율 알림 시스템 1,000줄로 진화. **모든 시스템의 시작이 if**.

### 이유 2: 데이터가 반복된다

자경단 — "5명 사료 예산 계산" "100 URL 동시 fetch" "1년 365일 환율 추세". 모든 데이터 처리 = for 반복.

```python
for cat in cats:
    process(cat)              # 5명

for url in urls:
    fetch(url)                # 100 URL

for date in date_range(2026, 1, 1, 2026, 12, 31):
    record_rate(date)         # 365일
```

자경단 매일 1000+ 줄 for 반복.

본인이 자경단 1주차에 본 첫 for — `for cat in cats:` 한 줄로 5명 사료 예산 합. 1년 후 같은 패턴이 자경단 100,000명+ 사용자 처리. for이 모든 데이터 처리의 다리.

### 이유 3: comprehension이 Python의 가독성

```python
# 일반 for (3줄)
result = []
for cat in cats:
    result.append(cat['name'])

# list comprehension (1줄, 자경단 표준)
result = [cat['name'] for cat in cats]
```

list comp 한 줄 = Python의 가독성 자랑. 자경단 매일 100+ comp.

자경단 본인의 첫 comp — `[c for c in cats if c['age'] > 5]` 한 줄. JavaScript `cats.filter(c => c.age > 5)`보다 Python이 더 한국어 같음 ("c for c in cats if..."). 1주일 학습 = 평생 가독성.

### 이유 4: while로 무한 + 조건 종료

```python
# 서버 무한 루프 (FastAPI)
while True:
    request = await server.recv()
    handle(request)

# 재시도 (자경단 매일 5회)
attempts = 0
while attempts < 5:
    if try_fetch():
        break
    attempts += 1
    time.sleep(2 ** attempts)  # exponential backoff
```

while = 서버·재시도·게임 루프. 자경단 매일 10+ while.

자경단 본인의 첫 while — API 재시도. `while attempts < 5: try fetch except retry`. exponential backoff 추가 = production. 1년 후 자경단 매일 100,000+ 재시도 자동 처리.

### 이유 5: break·continue·else로 흐름 미세 조정

```python
for cat in cats:
    if cat['age'] > 10:
        break                  # 루프 즉시 종료
    if cat['name'] == '본인':
        continue              # 다음 반복으로
    process(cat)
else:
    print("모든 cat 처리 완료")  # break 없을 때만
```

3 도구 = 흐름의 미세 조정. 자경단 1년 후 시니어 표준.

특히 `for + else` 패턴 — search 시나리오의 자경단 표준. "찾으면 break, 못 찾으면 else 실행"의 명확한 의도 표현. 자경단 1년 차에 본 본인의 코드 50+ 곳에서 사용.

### 이유 6: match-case로 패턴 매칭 (Python 3.10+)

```python
match status_code:
    case 200:
        return data
    case 404:
        raise NotFound
    case 500 | 502 | 503:
        retry()
    case _:
        log_unknown(status_code)
```

match-case = Python 3.10+의 새 도구. 자경단 표준.

자경단의 match-case 도입 — 1년 차 9월. 그 전엔 `if/elif` 5개 길이. match-case 도입 후 가독성 + 패턴 매칭 (구조 분해) = 1줄 짧고 강력. 자경단 표준 검토 권장.

### 이유 7: 면접 단골 — comprehension·zip·enumerate

자경단 1년 후 본인이 본 Python 면접 — `[i**2 for i in range(10)]`·`zip(a, b)`·`enumerate(items)` 모두 단골. 본 Ch008이 정답.

7 이유 × 매일 = 자경단 60% 코드.

### 1-1. 7이유의 진짜 의미

본인이 자경단 1년 차에 본 사실 — Python 코드 60%가 if + for. 자료형 (Ch007) + 흐름 (Ch008) = 95%. 나머지 5%가 함수·모듈·예외·OOP.

**본 Ch008 8H 학습 = Python의 60% 마스터**. 1주일이면 본인의 첫 알고리즘. 1개월이면 첫 데이터 처리 100줄. 1년이면 시니어.

### 1-2. 7이유의 자경단 매일 시나리오

```python
# 시나리오 1: 환율 분기 (이유 1)
if rate >= 1500:
    notify_5_cats()

# 시나리오 2: 5명 사료 예산 (이유 2)
total = sum(cat['budget'] for cat in cats)

# 시나리오 3: API 응답 변환 (이유 3)
names = [c['name'] for c in cats if c['active']]

# 시나리오 4: 재시도 (이유 4)
while attempts < 5 and not success:
    attempts += 1

# 시나리오 5: 검색 + early exit (이유 5)
for cat in cats:
    if cat['name'] == '까미':
        target = cat
        break

# 시나리오 6: 상태 분기 (이유 6, Python 3.10+)
match response.status:
    case 200: handle_ok()
    case 404: handle_not_found()
    case _: handle_other()

# 시나리오 7: 면접 — comprehension + zip + enumerate
pairs = [(i, name) for i, name in enumerate(zip(cats, ages))]
```

7 시나리오 × 자경단 매일 = 본 Ch008의 진짜.

---

## 2. 4 핵심 단어

### 2-1. if (조건 분기)

```python
if condition:
    do_something()
elif other_condition:
    do_other()
else:
    do_default()
```

`if`는 영어의 "만약". 단순·강력. 자경단 매일 첫 단어.

조건 작성 5 패턴:
- 비교 — `if x > 5:`
- 멤버십 — `if 'cat' in cats:`
- 진위 — `if not data:` (빈 list·dict·str·None falsy)
- isinstance — `if isinstance(x, int):`
- 짧은 표현 — `value = a if cond else b` (ternary)

5 패턴 = 자경단 매일 if의 95%.

### 2-2. for (반복 — 정해진 횟수)

```python
for item in iterable:
    process(item)
```

`for`는 "각각에 대해". list·tuple·dict·set·str·range·generator 모두 반복 가능 (iterable).

for 5 패턴:
- 단순 — `for x in items:`
- 인덱스 — `for i, x in enumerate(items):`
- 병렬 — `for a, b in zip(list_a, list_b):`
- 범위 — `for i in range(10):`
- dict — `for k, v in d.items():`

5 패턴 = 자경단 매일 for의 95%.

### 2-3. while (반복 — 조건 동안)

```python
while condition:
    do_work()
```

`while`은 "동안에". 횟수 모를 때·무한 루프·재시도.

while 5 패턴:
- 카운터 — `while attempts < 5:`
- 조건 — `while not done:`
- walrus 읽기 — `while chunk := f.read(1024):`
- 무한 + break — `while True: ... if cond: break`
- 서버 — `while True: handle(await server.recv())` (FastAPI)

5 패턴 = 자경단 while의 100%.

### 2-4. comprehension (한 줄 변환)

```python
# list comp
[x**2 for x in range(10)]

# dict comp
{k: v*2 for k, v in items.items()}

# set comp
{x % 10 for x in numbers}

# generator expression
(x**2 for x in range(10))   # 메모리 절약
```

comprehension = Python의 가독성 무기. 자경단 매일 100+.

comprehension 4 종 + 1 nested:
- list — `[x for x in items]` 매일 100+
- dict — `{k: v for k, v in items.items()}` 매일 30+
- set — `{x for x in items}` 매일 5+
- generator — `(x for x in items)` 메모리 절약
- nested — `[[i*j for j in range(5)] for i in range(5)]` 2차원

5 종 × 매일 = 자경단 comp 100% 사용.

### 2-5. 4 단어 한 페이지 비교

| 단어 | 의미 | 자경단 매일 |
|------|------|------------|
| if | 분기 | 1000+ 줄 |
| for | 반복 | 500+ 줄 |
| while | 조건 반복 | 10+ 줄 |
| comprehension | 한 줄 변환 | 100+ 줄 |

4 단어 × 1610+ 줄 = 자경단 매일 60% 코드.

### 2-6. 4 단어의 진짜 사용 빈도 — 자경단 1년 측정

자경단 본인이 1년 차에 코드 측정한 결과:
- `if` 키워드: 12,000회 (전체 키워드 1위)
- `for` 키워드: 5,000회 (2위)
- `return` 키워드: 4,000회 (3위)
- `def` 키워드: 1,500회 (4위)
- `while` 키워드: 50회 (서버 + 재시도)
- comprehension: 1,200회

**if + for + comp = 18,200회 / 25,000 = 73%**. 본 Ch008이 자경단 코드의 73%.

### 2-7. 4 단어의 짝꿍

```python
# if + early return (자경단 표준)
def process(cat):
    if not cat:
        return None              # guard
    if cat['age'] < 0:
        raise ValueError
    return do_work(cat)

# for + enumerate (인덱스 필요)
for i, cat in enumerate(cats):
    print(f"{i}: {cat['name']}")

# for + zip (병렬 반복)
for cat, age in zip(cats, ages):
    print(f"{cat}: {age}살")

# while + walrus := (Python 3.8+)
while chunk := f.read(1024):
    process(chunk)

# comp + filter (조건부)
active = [c for c in cats if c['active']]

# comp + nested
matrix = [[i*j for j in range(5)] for i in range(5)]
```

6 짝꿍 × 매일 = 자경단 표준 패턴 6.

---

## 3. 8H 큰그림 — Ch008의 60분 × 8

| H | 슬롯 | 핵심 |
|---|------|------|
| H1 | 오리엔 (본 H) | 7이유·4단어·8H 지도 |
| H2 | 핵심개념 | if/elif/else·for·while·break/continue/else·match-case |
| H3 | 환경점검 | VS Code 디버거·breakpoint()·pdb·rich.print |
| H4 | 명령카탈로그 | range·enumerate·zip·map·filter·comprehension 4종 |
| H5 | 데모 | 환율 계산기 + 분기·반복 추가 (50줄→150줄) |
| H6 | 운영 | early return·guard clause·복잡도 줄이기 5 패턴 |
| H7 | 원리 | iterator protocol·generator·yield from·async for |
| H8 | 적용+회고 | Ch008 마무리·Ch009 예고 (함수) |

8H × 60분 = 8시간 = 자경단 제어 흐름 마스터.

### 3-1. 8H 큰그림의 학습 곡선

| H | 누적 시간 | 자경단 본인의 상태 |
|---|---------|----------------|
| H1 | 1시간 | 4 단어 외움 + 7 이유 이해 |
| H2 | 2시간 | if/for/while 첫 코드 |
| H3 | 3시간 | VS Code 디버거 + breakpoint() |
| H4 | 4시간 | 18 도구 손가락 익숙 |
| H5 | 5시간 | exchange.py 150줄 진화 |
| H6 | 6시간 | early return 패턴 5 |
| H7 | 7시간 | generator 첫 작성 |
| H8 | 8시간 | Ch008 종합 + Ch009 예고 |

8시간 학습 곡선 = 자경단 첫 production 코드 작성 가능. 1주차 이정표.

---

## 4. 자경단 5명 매일 제어 흐름 사용표

| 누구 | 매일 사용 |
|------|---------|
| 본인 | if 1000+ 줄·for 500+ 줄 (FastAPI 라우팅) |
| 까미 | comprehension 200+ 줄 (DB 쿼리 결과 변환) |
| 노랭이 | for+map (React state·Python 도구) |
| 미니 | while 50+ 줄 (인프라 폴링·재시도) |
| 깜장이 | for+enumerate (테스트 케이스 100+ 반복) |

5명 × 매일 = 자경단 60% 코드 = if + for + comprehension.

### 4-1. 5명 자경단의 첫 제어 흐름 1주차 일정

| 일 | 본인 | 까미 | 노랭이 | 미니 | 깜장이 |
|----|------|------|--------|------|--------|
| 월 | if 5종 학습 | for 5종 학습 | comp 학습 | while 학습 | enumerate |
| 화 | exchange.py 분기 추가 | DB 쿼리 변환 | React state for | 폴링 5종 | 테스트 100건 |
| 수 | guard clause 패턴 | early return | comp + filter | retry exponential | parametrize |
| 목 | match-case 도입 | comp + nested | zip + map | walrus := | for + zip |
| 금 | 5명 PR review | 5명 PR review | 5명 PR review | 5명 PR review | 5명 PR review |

5일 × 5명 = 25 학습 = 자경단 첫 주 제어 흐름 마스터.

---

## 5. 한 줄 코드 0.001초 흐름 (CPython 내부)

```python
# 한 줄: [x**2 for x in range(10)]
```

CPython VM 흐름 (0.001초):
1. tokenize: `[`·`x`·`**`·`2`·`for`·...
2. parse: ListComp(elt, generators)
3. compile: LIST_COMP frame + LOAD_CONST + BINARY_OP + STORE_NAME
4. exec: 10번 반복 + list 생성
5. return: [0,1,4,9,16,25,36,49,64,81]

5단계 × 0.001초 = 자경단 매일 100+ comp 실행.

### 5-1. 한 줄 if의 0.0001초 흐름

```python
# 한 줄: if cat['age'] > 5: notify()
```

CPython VM 흐름:
1. LOAD_FAST `cat` (지역변수)
2. LOAD_CONST `'age'` (문자열 상수)
3. BINARY_SUBSCR (`cat['age']`)
4. LOAD_CONST `5`
5. COMPARE_OP `>`
6. POP_JUMP_IF_FALSE → 다음 줄
7. LOAD_GLOBAL `notify`
8. CALL

8 opcode × 0.0001초 = 자경단 매일 1000+ if 실행.

### 5-2. 한 줄 for의 0.001초 흐름

```python
# for cat in cats: process(cat)
```

CPython VM 흐름:
1. LOAD_FAST `cats`
2. GET_ITER (iterator 만들기)
3. **루프 시작** — FOR_ITER (다음 값 or 루프 종료)
4. STORE_FAST `cat`
5. LOAD_GLOBAL `process`
6. LOAD_FAST `cat`
7. CALL
8. JUMP_BACKWARD → 3
9. **루프 끝** — END_FOR

9 opcode × 5명 cat × 0.0001초 = 0.0005초.

---

### 5-3. 한 줄 comp의 0.001초 흐름

```python
# [x**2 for x in range(10)]
```

CPython VM 흐름:
1. LOAD_CONST `<code object listcomp>` (별도 frame)
2. MAKE_FUNCTION
3. LOAD_GLOBAL `range`
4. LOAD_CONST `10`
5. CALL `range(10)`
6. GET_ITER
7. **CALL** comp 함수
8. **comp frame 안** — LIST_APPEND 10회
9. RETURN_VALUE [0,1,4,9,16,25,36,49,64,81]

comp이 별도 frame이라 가변 누설 안 됨 (Python 3 개선). 그래서 `[x for x in range(10)]` 후 `x` 접근 X.

---

## 6. 12회수 지도 — Ch009부터 평생

| 회수 챕터 | 회수 내용 | 시기 |
|----------|---------|------|
| Ch009 | 함수 — def·*args·**kwargs·decorator | 다음 |
| Ch010 | 모듈/패키지 — import·sys.path | 3주 후 |
| Ch013 | 파일 I/O — open·with·json·csv | 6주 후 |
| Ch017 | 함수형 — map·filter·reduce·closure | 10주 후 |
| Ch018 | iterator·generator·yield | 11주 후 |
| Ch019 | context manager·with·__enter__ | 12주 후 |
| Ch022 | pytest·@pytest.mark.parametrize | 15주 후 |
| Ch041 | FastAPI — async def + for/await | 34주 후 |
| Ch060 | 풀스택 — React state + Python for | 53주 후 |
| Ch080 | ML — for batch in dataloader | 73주 후 |
| Ch103 | CI/CD — for matrix | 96주 후 |
| Ch118 | 면접 — comprehension·yield·async | 111주 후 |

12회수 = 본 Ch008의 4 단어가 평생 등장. if + for이 코드의 60%.

### 6-1. 12회수의 시간축 적용

본 Ch008 H1을 들은 본인의 1년 후:
- **1주 후 (Ch009)**: 함수 안에 if/for 조합. exchange.py에 `def get_alert(rate)` 추가.
- **3주 후 (Ch010)**: import 받은 모듈 안의 if/for 호출. 자경단 utils.py 첫 작성.
- **6주 후 (Ch013)**: 파일 read + for 줄별 처리. 환율 history 100일 분석.
- **10주 후 (Ch017)**: lambda + map/filter + comp 비교. 함수형 패러다임.
- **11주 후 (Ch018)**: yield + generator. 무한 환율 스트림.
- **34주 후 (Ch041)**: FastAPI `async for` + 비동기 if/for.
- **111주 후 (Ch118)**: 면접 5질문 본 H 답변.

12회수 × 113주 = 본 H의 진짜 평생 가치.

---

## 7. 자경단 5명 매일 시나리오 5

자경단의 매일 제어 흐름 5 시나리오:

### 7A-1. 본인 — FastAPI 라우팅 if 분기

```python
@app.post('/convert')
async def convert(req: ConvertRequest):
    if req.amount_krw < 0:
        raise HTTPException(400, "음수")
    if req.currency not in RATES:
        raise HTTPException(400, "지원 안 함")
    if req.amount_krw > 10_000_000:
        await notify_5_cats(req)
    return {"result": req.amount_krw / RATES[req.currency]}
```

if 4개 = 라우팅의 검증 + 알림. 자경단 매일 100+ 라우팅.

### 7A-2. 까미 — DB 결과 comprehension

```python
async def get_active_cats():
    rows = await db.fetch_all("SELECT * FROM cats WHERE active = TRUE")
    return [{"name": r['name'], "age": r['age']} for r in rows]
```

comp 한 줄 = DB → API 응답 변환. 자경단 매일 50+ DB 쿼리.

### 7A-3. 노랭이 — Python 도구 for 처리

```python
def generate_typescript_types():
    api_models = load_pydantic_models()
    for model in api_models:
        ts_code = pydantic_to_typescript(model)
        write_file(f"src/types/{model.__name__}.ts", ts_code)
```

for 한 루프 = OpenAPI → TypeScript 자동. 자경단 매주 5+ 모델.

### 7A-4. 미니 — 인프라 while 폴링

```python
def wait_for_ec2_running(instance_id):
    while True:
        state = ec2.describe_instance(instance_id).state
        if state == 'running':
            break
        elif state == 'failed':
            raise InfraError
        time.sleep(5)
```

while 무한 + break = AWS EC2 상태 폴링. 자경단 매일 10+ 인프라 작업.

### 7A-5. 깜장이 — 테스트 for + parametrize

```python
@pytest.mark.parametrize("amount,currency,expected", [
    (1380.50, "USD", 1.0),
    (9100, "JPY", 1000.0),
    (1495.30, "EUR", 1.0),
    (0, "USD", 0.0),
    (-1, "USD", ValueError),
])
def test_convert(amount, currency, expected):
    if isinstance(expected, type) and issubclass(expected, Exception):
        with pytest.raises(expected):
            convert(amount, currency)
    else:
        assert convert(amount, currency) == expected
```

parametrize for = 5 테스트 케이스 한 함수. 자경단 매주 100+ 테스트.

5 시나리오 × 자경단 매일 = 본 H의 진짜 적용.

---

## 7. 면접 5질문 (자경단 1년 후)

**Q1. list comprehension vs map?**
A. comp 빠름·가독성. map은 함수 인자만. lambda 사용 시 comp가 표준.

**Q2. for + else는 무엇?**
A. for 정상 종료 (break 없음) 시만 else 실행. while + else도 같음.

**Q3. range vs xrange?**
A. Python 2 xrange. Python 3 range가 lazy iterator (xrange 동일).

**Q4. enumerate vs zip?**
A. enumerate (인덱스+값)·zip (여러 iterable 동시). 둘 다 자경단 매일.

**Q5. match-case vs if/elif?**
A. 패턴 매칭 (구조 분해 가능)·가독성. Python 3.10+. 자경단 표준 검토.

5 질문 = 자경단 면접 단골.

### 7-1. 면접 5 질문의 진짜 깊이

자경단 1년 후 본인이 본 면접 — 5 질문 답에서 추가 5 질문 파생:
1. "comp가 빠른 이유?" → bytecode LIST_COMP frame 1개
2. "for+else 사용한 적?" → search 패턴 (자경단 매일)
3. "range가 lazy인 이유?" → 메모리 절약 (1억까지 4MB만)
4. "enumerate(start=1) 같은 옵션?" → 1부터 시작
5. "match-case가 표현식?" → 문장 (Python 3.10), 표현식 PEP 후보

추가 5 = 자경단 1년 후 시니어 답변.

### 7-2. 면접 추가 5 질문 (본 H 깊이)

**Q6. ternary가 한 줄 if?**
A. `value = a if cond else b`. f-string 안 ternary `f"{name if active else 'inactive'}"`도 자경단 매일.

**Q7. walrus `:=` 언제 쓰나요?**
A. while + read 패턴. `while chunk := f.read(1024):`. Python 3.8+.

**Q8. iterable vs iterator 차이?**
A. iterable (반복 가능 객체)·iterator (next() 호출 가능). list는 iterable·`iter(list)`이 iterator.

**Q9. break vs return for 안에서?**
A. break — 루프만 종료. return — 함수 종료. 의도에 맞게.

**Q10. while True + break 안전?**
A. break 명확하면 안전. 자경단 서버 표준 (FastAPI·uvicorn).

5+5 = 10 질문 = 자경단 1년 후 면접 마스터.

---

## 8. 흔한 오해 5가지

**오해 1: "for 루프는 느려서 numpy 써야 한다."** — 100만 미만 데이터는 for OK. numpy는 1000만+ 데이터.

**오해 2: "while True는 무한 루프 위험."** — break + 명확한 조건이면 안전. 자경단 서버 표준.

**오해 3: "comprehension은 가독성 떨어진다."** — 1줄 OK·2~3줄 OK·4줄+ 비권장. 자경단 표준 3줄 이내.

**오해 4: "if + elif + else 많으면 나쁜 코드."** — 5+ elif는 dict·class로 리팩토링. 3 elif까지는 OK.

**오해 5: "match-case는 새거라 안 쓴다."** — Python 3.10+ 4년 됨. 자경단 표준.

**오해 6: "if + elif 5개면 무조건 dict로 리팩토링."** — 5개까지는 if/elif. 10+ 일때 dict 또는 strategy 패턴.

**오해 7: "comprehension이 항상 빠르다."** — 작은 데이터 OK. 큰 데이터 (100만+)는 generator (`(...)` 괄호) 메모리 절약.

**오해 8: "while True 무한루프는 위험."** — 자경단 서버 표준. uvicorn·gunicorn·celery 모두 while True. break + 신호 처리만 명확하면 안전.

---

### 8-1. 흔한 오해의 진짜 의미

오해 5와 6이 자경단 신입의 함정. 본인이 1주차에 "elif 5개 = 나쁜 코드"라고 들었는데 1년 후 본 진실 — 5 elif가 가독성 좋고 dict refactor가 더 나쁠 수 있음. 도구는 맥락이 결정.

자경단 표준 — 코드 가독성이 최고. 패턴은 도구이지 규칙이 아님.

---

## 9. FAQ 5가지

**Q1. 한 줄 if 표현식?**
A. ternary `value = a if condition else b`. 자경단 매일.

**Q2. for 안에서 list 수정?**
A. 비권장 (인덱스 꼬임). copy 또는 새 list 만드세요.

**Q3. while True + break vs while condition?**
A. 둘 다 OK. break 양식이 자경단 명확함 표준.

**Q4. zip의 길이 다를 때?**
A. 짧은 쪽 기준 자름. itertools.zip_longest로 긴 쪽 기준.

**Q5. yield는 언제?**
A. 큰 데이터 (메모리 절약)·무한 시퀀스. Ch017에서 깊이.

**Q6. nested comprehension 가독성?**
A. 2 중첩까지 OK. 3 이상은 for 루프로 분리. 자경단 표준.

**Q7. zip 길이 다를 때 안전?**
A. 짧은 쪽 자름 (silent). 명시적 — `zip(a, b, strict=True)` (Python 3.10+) 다른 길이면 ValueError.

**Q8. enumerate 시작 1로?**
A. `enumerate(items, start=1)` 옵션. 사람용 출력은 1부터.

**Q9. for + range vs while + 카운터?**
A. for + range가 표준. while + 카운터는 옛 양식·실수 가능 (off-by-one).

**Q10. dict comprehension 순서 보장?**
A. Python 3.7+ dict 순서 보장. comp도 입력 순서 따름.

**Q11. for 안 try/except 위치?**
A. 한 항목 처리 실패 시 계속 — try/except 안에. 하나라도 실패 시 중단 — 밖에. 자경단 매일 결정.

**Q12. while 안에서 i++ 같은 양식?**
A. Python 없음. `i += 1` 명시적. C에서 온 사람 자주 실수.

**Q13. for의 break가 nested 두 루프 모두?**
A. 안쪽 break만 종료. 두 루프 모두는 함수로 감싸 return 또는 flag 변수.

**Q14. while True 종료를 신호로?**
A. signal 모듈로 SIGINT/SIGTERM 처리. 자경단 서버 표준 — uvicorn이 자동.

**Q15. comp 안 if + else 양식?**
A. `[x if cond else y for x in items]` (앞)·`[x for x in items if cond]` (뒤). 둘 차이 — filter vs transform.

### 9-1. FAQ 15 질문의 자경단 매일 답

| Q | 답 | 자경단 매일 |
|---|----|------------|
| ternary | `a if c else b` | 100+ 줄 |
| for 수정 | copy or 새 list | 매일 |
| while 양식 | break 명확 | 매일 |
| zip 길이 | strict=True | 표준 |
| yield 시점 | 큰 데이터 | 1년 차 |
| nested comp | 2 중첩까지 | 매일 |
| zip strict | Python 3.10+ | 표준 |
| enumerate start | 사람 출력 1부터 | 매일 |
| for vs while | for 표준 | 매일 |
| dict comp 순서 | Python 3.7+ | 매일 |

10 답변 = 자경단 매일 의식.

---

## 10. 추신

추신 1. 제어 흐름이 Python 코드 60%. if + for + while + comprehension 4 단어가 평생.

추신 2. if 1000+ 줄·for 500+ 줄·comprehension 100+ 줄·while 10+ 줄 자경단 매일.

추신 3. 4 단어 한 페이지 비교 = 자경단 첫 주 외움.

추신 4. comprehension 4종 (list·dict·set·gen) 자경단 매일 100+.

추신 5. break·continue·for+else 3 도구 = 흐름 미세 조정.

추신 6. match-case Python 3.10+ 패턴 매칭. 자경단 표준 검토.

추신 7. range·enumerate·zip·map·filter 5 도구 자경단 매일.

추신 8. early return·guard clause·복잡도 5 패턴 (H6).

추신 9. iterator protocol + generator + yield (H7) = Python의 진화.

추신 10. 면접 5질문 (comp vs map·for+else·range·enumerate vs zip·match) 정답.

추신 11. 흔한 오해 5 면역 (for 느림·while 위험·comp 가독성·elif 나쁨·match 새것).

추신 12. FAQ 5 (ternary·for 수정·while 양식·zip 길이·yield 시점) 정답.

추신 13. 다음 Ch009는 함수 (def·*args·**kwargs·decorator). 본 Ch008의 흐름이 함수 안에 들어감.

추신 14. 자경단 5명 매일 60% 코드 = if + for + comp = 본 Ch008 마스터 시.

추신 15. 본 Ch008 8H 학습 후 자경단 본인의 첫 production 코드 작성 가능.

추신 16. 자경단 1년 후 본인이 본 면접 5질문 모두 본 H 정답.

추신 17. CPython VM의 LIST_COMP·FOR_ITER·POP_JUMP_IF_FALSE 3 opcode가 본 H의 내부.

추신 18. dis 모듈로 본인의 if·for·comp 직접 확인. 자경단 매일.

추신 19. PEP 274 (comp), PEP 308 (ternary), PEP 380 (yield from), PEP 525 (async gen), PEP 634 (match) 5 PEP가 본 Ch008 깊이.

추신 20. 본 H가 Ch008의 첫 만남. 8H 큰그림 + 4 단어 + 12회수 지도. 평생 시작.

추신 21. 자경단 매일 if 분기 표 5종 (==, in, is, isinstance, hasattr) 자경단 표준.

추신 22. 자경단 매일 for 표 5종 (range·enumerate·zip·dict.items·sorted) 자경단 표준.

추신 23. 자경단 매일 while 표 3종 (재시도·polling·서버 루프) 자경단 표준.

추신 24. 자경단 매일 comp 표 4종 (list·dict·set·gen) + 1종 (nested) = 5 패턴.

추신 25. 자경단 매일 break/continue 표 5상황 (early exit·skip·search·limit·error) 자경단 표준.

추신 26. for + else 패턴 — search 표준. for cat in cats: if found: break / else: not found.

추신 27. while + else 패턴 — 거의 안 씀. for + else만 매일.

추신 28. ternary `a if cond else b` — 자경단 매일 100+ 줄. f-string 안에서도.

추신 29. walrus `:=` (Python 3.8+) — while + read 패턴. `while chunk := f.read(1024):`. 자경단 매일 매직.

추신 30. **본 H 끝** ✅ — Ch008 H1 오리엔 학습 완료. 4 단어 + 8H 큰그림 + 12회수 지도. 다음 H2 핵심개념 (if/elif/else·for·while·break/continue·match-case)! 🐾🐾🐾

추신 31. 자경단 5명 1주차 25 학습 (5일 × 5명) = 본 Ch008 첫 주.

추신 32. 자경단 1년 코드 측정 — if 12,000 + for 5,000 + comp 1,200 = 18,200회 / 25,000 키워드 = 73%. 본 Ch008이 자경단 73%.

추신 33. 6 짝꿍 (if+early return·for+enumerate·for+zip·while+walrus·comp+filter·comp+nested) = 자경단 표준 패턴.

추신 34. 한 줄 if 8 opcode·한 줄 for 9 opcode·한 줄 comp 10+ opcode = CPython VM의 본 Ch008 내부.

추신 35. dis 모듈로 본인의 if·for·comp 직접 확인. 매일 30초 내부 검토.

추신 36. 면접 추가 5 질문 (ternary·walrus·iterable vs iterator·break vs return·while True 안전) 답변.

추신 37. FAQ 추가 5 (nested comp 가독성·zip strict·enumerate start·for+range vs while·dict comp 순서) 답변.

추신 38. 흔한 오해 8 면역 (for 느림·while 위험·comp 가독성·elif 나쁨·match 새것·dict 리팩토링·comp 빠름·while True 위험).

추신 39. PEP 274/308/380/525/634 5 PEP가 본 Ch008 깊이. 자경단 매월 1 PEP.

추신 40. **Ch008 H1 학습 완료** ✅ — 자경단 제어 흐름 첫 만남. 다음 7H에서 Python 60% 코드 마스터. 🐾🐾🐾🐾🐾

추신 41. if 5 패턴 (비교·멤버십·진위·isinstance·ternary)이 자경단 매일 if의 95%.

추신 42. for 5 패턴 (단순·인덱스·병렬·범위·dict.items)이 자경단 매일 for의 95%.

추신 43. while 5 패턴 (카운터·조건·walrus·무한+break·서버)이 자경단 while의 100%.

추신 44. comprehension 5 종 (list·dict·set·gen·nested)이 자경단 comp 100%.

추신 45. 4 단어 × 5 패턴 = 20 패턴 = 자경단 1주일 외움.

추신 46. 면접 추가 5 질문 (for try/except·i++·nested break·while 종료 신호·comp if-else 양식) 답변.

추신 47. CPython VM 흐름 — if 8 opcode·for 9 opcode·comp 별도 frame이 본 H의 내부.

추신 48. comp의 별도 frame이 변수 누설 차단 (Python 3 개선). Python 2와 차이.

추신 49. 본인의 첫 if 한 줄이 1년 후 1,000줄 자경단 알림 시스템.

추신 50. 본인의 첫 for 한 줄이 1년 후 100,000명 사용자 처리.

추신 51. 본인의 첫 comp 한 줄이 평생 가독성 자랑. JavaScript filter보다 한국어 같음.

추신 52. 본인의 첫 while이 자경단 매일 100,000+ 재시도 자동 처리.

추신 53. for + else 패턴이 자경단 search 시나리오 표준. 1년 차에 50+ 곳.

추신 54. match-case가 자경단 1년 차 9월 도입. 가독성 + 패턴 매칭.

추신 55. 본 H의 진짜 결론 — 4 단어 × 5 패턴 = 20 패턴이고, 자경단 매일 60% 코드이며, 8H 학습 = 평생 자산이에요. 다음 H2 핵심개념에서 if/elif/else·for·while·match-case 깊이! 🐾

추신 56. 자경단 5명 매일 5 시나리오 (FastAPI·DB comp·OpenAPI for·EC2 while·pytest parametrize) = 본 H 적용.

추신 57. 본인의 첫 라우팅 if 4개 = 자경단 매일 100+ 라우팅의 시작.

추신 58. 까미의 첫 DB comp = 자경단 매일 50+ DB → API 변환.

추신 59. 노랭이의 첫 generate for = 자경단 매주 5+ OpenAPI → TS.

추신 60. 미니의 첫 EC2 while + break = 자경단 매일 10+ 인프라.

추신 61. 깜장이의 첫 parametrize for = 자경단 매주 100+ 테스트.

추신 62. **본 Ch008 H1 진짜 끝** ✅ — 4 단어 + 7 이유 + 8H 큰그림 + 12회수 지도 + 면접 15질문 + FAQ 15 + 자경단 5명 5 시나리오. 다음 H2! 🐾🐾🐾🐾🐾

추신 63. 본 H 직후 본인이 할 5 행동 — 1) `python3 -c "for i in range(5): print(i)"` 한 줄 실행, 2) `[x**2 for x in range(10)]` REPL 실행, 3) `if __name__ == '__main__':` 양식 학습, 4) walrus `:=` Python 3.12 검증, 5) match-case Python 3.10+ REPL 실험.

추신 64. 5 행동 5분 = 자경단 본인의 첫 제어 흐름 손가락. 평생 시작.

추신 65. 본 H의 마지막 추신 — 4 단어 (if·for·while·comp)이 자경단 평생 60% 코드. 1주일이면 첫 production. 1년이면 시니어. 5년이면 평생 자산. **다음 H2 핵심개념에서 만나요**. 🐾🐾🐾🐾🐾🐾
