# Ch011 · H1 — Python 입문 5: 문자열·정규식 — 오리엔테이션

> **이 H에서 얻을 것**
> - str·regex 7 이유
> - 4 단어 (str·f-string·re·pattern) + 5 활용 = 20 활용
> - str 50+ 메서드 + regex 5 핵심
> - 자경단 5명 매일 1,500+ str 호출
> - 12회수 지도

---

## 회수: Ch010 collections에서 본 H의 문자열로

지난 Ch010 8 H 동안 본인은 collections 67+ 도구를 학습했어요. list·tuple·dict·set + collections 모듈 + heapq + bisect + itertools + 환경 4 도구 + 운영 5 패턴 + 원리. 자경단 1주 17,200 호출·1년 895,000 호출 마스터. exchange v1→v4 진화·면접 30 질문·CPython 소스·5명 1년 회고 모두 학습 완료.

본 Ch011은 **문자열과 정규식**이에요. 자경단의 매일 사용량 1위가 사실 collections (1,150회/일) 다음으로 str (1,500회/일). FastAPI URL·DB query·로그·사용자 입력·API response 모두 str로 시작·str로 끝. Python 입문 1+2+3+4를 마쳤으니 이제 입문 5로 진입.

까미가 묻습니다. "왜 한 챕터를 str에 써요?" 본인이 답해요. "Python의 모든 데이터가 결국 str로 입출력. URL parsing·이메일 검증·로그 분석·HTML 정리·SQL 안전 escape — 매일 1,500+ 호출. str + regex 마스터하면 자경단 1주차 능력 정점."

노랭이가 끄덕이고, 미니가 regex 메타 문자를 메모하고, 깜장이가 f-string 5 양식을 따라 칩니다. 자경단 5명이 매일 자신의 코드에서 str을 어떻게 활용하는지 시나리오로 봐요. 본인 (FastAPI)이 매일 600+ f-string·까미 (DB)가 매일 400+ str·노랭이 (도구)가 매일 300+·미니 (인프라)가 100+·깜장이 (테스트)가 100+ = 합 1,500.

본 H의 약속 — 끝나면 자경단이 str의 50+ 메서드와 regex 5 핵심을 손가락에 붙입니다. f-string·split·join·strip·replace·find·startswith·endswith·format·encode·decode 등 매일·re.match·re.search·re.findall·re.sub·re.compile 5개 매주.

본 H 진행 순서 — 1) str·regex 7 이유, 2) 4 단어 + 5 활용, 3) str 50+ 메서드 미리보기, 4) regex 5 핵심 미리보기, 5) 8 H 학습 곡선, 6) 자경단 매일 시나리오, 7) 12회수 지도, 8) 면접 10 질문, 9) 흔한 오해 + FAQ + 추신.

본 H 학습 후 본인은 — Python 입문 1 (자료형) + 입문 2 (제어 흐름) + 입문 3 (함수) + 입문 4 (collections) + 입문 5 (str/regex) = 40시간 학습 진행. Python 마스터 80h 길의 50%. 자경단 본인이 매일 1,500+ str 호출 능력 1주차 마스터 시작.

---

## 0. 본 H 도입 — 자경단의 첫 str

본인이 자경단 코드 베이스를 처음 봤을 때 가장 많은 줄 — `print(f'...')`. 그 다음 — `name.split('/')`. 그 다음 — `if 'error' in log`. 모두 str 메서드. 자경단의 매일 1,500+ str 호출이 코드 베이스 어디든 있어요.

까미가 첫 PR을 올렸을 때 — 5 줄 코드 중 3줄이 str 처리. URL parsing → query string → escape → format. str 마스터 없으면 자경단에서 1주차 못 버팀.

본 H에서 본인은 — str·regex의 7 이유·4 단어·5 활용·50+ 메서드 미리보기·5 함수·5 카테고리 모두 한 시간에 봅니다. 8 H 학습 곡선의 시작·자경단 매일 1,500+ 호출의 토대.

이 H를 마치면 본인은 — Ch011 학습 시작·자경단 첫 str/regex 패턴 인식·면접 10 질문 미리 답변 준비·8 H 후 마스터 약속.

---

## 1. str · regex 7 이유

### 1-1. 이유 1: 모든 데이터가 결국 str

```python
# DB → Python → API → 클라이언트
row = db.fetch_one('SELECT name FROM cats WHERE id = 1')
name = row['name']                   # str
response = {'name': name}            # JSON에서 str
return json.dumps(response)          # str
```

자경단 매일 — DB·HTTP·파일 모두 str.

### 1-2. 이유 2: f-string은 자경단 표준

```python
# Python 3.6+ f-string
name = '까미'
age = 2
greeting = f'안녕 {name}! {age}살이구나'
# '안녕 까미! 2살이구나'

# Python 3.12+ self-documenting
debug = f'{name=}, {age=}'
# "name='까미', age=2"
```

매일 100+ f-string 사용.

### 1-3. 이유 3: regex로 5줄 → 1줄

```python
# regex 없이
def is_email(s):
    if '@' not in s: return False
    local, domain = s.split('@')
    if not local: return False
    if '.' not in domain: return False
    return True

# regex 한 줄
import re
def is_email(s):
    return bool(re.match(r'^[\w.]+@[\w.]+\.\w+$', s))
```

5줄 → 1줄 압축.

### 1-4. 이유 4: 입력 검증 매일

```python
# 자경단 매일 — API 입력 검증
if not user_id.isdigit(): raise ValueError
if len(name) > 50: raise ValueError
if not re.match(r'^\d{3}-\d{4}-\d{4}$', phone): raise ValueError
```

검증 = str 메서드 + regex.

### 1-5. 이유 5: 로그 분석

```python
# Apache log parsing
log = '127.0.0.1 - - [10/Oct/2025:13:55:36 +0000] "GET /api/cats HTTP/1.1" 200 1234'
match = re.match(r'(\S+) - - \[([^\]]+)\] "(\w+) (\S+) [^"]+" (\d+) (\d+)', log)
ip, date, method, path, status, size = match.groups()
```

자경단 매주 — 로그 분석 + Counter.

### 1-6. 이유 6: SQL 안전 (str escape)

```python
# 위험 — SQL injection
query = f"SELECT * FROM cats WHERE name = '{user_input}'"

# 안전 — 파라미터 + escape
query = "SELECT * FROM cats WHERE name = ?"
db.execute(query, (user_input,))
```

자경단 표준 — str 안전 escape.

### 1-7-pre. 이유 6.5: 다국어 (i18n)

```python
# 한국어 처리
name = '까미'
len(name)                   # 2 (글자 수)
name.encode('utf-8')        # b'\xea\xb9\x8c\xeb\xaf\xb8' (6 byte)

# 일본어
title = 'ねこ警察'
len(title)                  # 4

# 이모지
emoji = '🐾'
len(emoji)                  # 1 (Python 3 모든 유니코드 한 글자)
```

자경단 매일 — 한국어·일본어·이모지 100% UTF-8.

### 1-7. 이유 7: 면접 단골

```
면접 단골 10 질문:
1. f-string vs format() 차이?
2. str.join vs +?
3. str immutable? 왜?
4. encode vs decode?
5. regex greedy vs lazy?
6. re.match vs search 차이?
7. \d vs [0-9]?
8. raw string r''?
9. capture group?
10. lookahead/lookbehind?
```

면접 100% 합격 신호.

---

## 2. 4 단어 + 5 활용 = 20 활용

### 2-1. 단어 1: str

```python
s = '안녕 자경단'
type(s)                  # <class 'str'>

# 5 활용
s.upper()                # '안녕 자경단'
s.split()                # ['안녕', '자경단']
s.replace('안녕', 'Hi')  # 'Hi 자경단'
s[0]                     # '안'
len(s)                   # 6
```

### 2-2. 단어 2: f-string

```python
name = '까미'

# 5 활용
f'안녕 {name}'                       # 보간
f'{name:>10}'                       # 우 정렬 10
f'{1234567:,}'                      # 1,234,567 (천 단위)
f'{0.123:.2%}'                      # 12.30% (퍼센트)
f'{name=}'                          # name='까미' (debug)
```

### 2-3. 단어 3: re

```python
import re

# 5 활용
re.match(r'\d+', '123abc')          # match (시작만)
re.search(r'\d+', 'abc123')         # search (어디든)
re.findall(r'\d+', 'a1b2c3')        # ['1', '2', '3']
re.sub(r'\d', 'X', 'a1b2')          # 'aXbX'
re.compile(r'\d+')                  # 컴파일된 pattern
```

### 2-4. 단어 4: pattern (regex 메타 문자)

```python
# 5 활용
r'\d'                               # 숫자
r'\w'                               # 단어 문자 (a-z, 0-9, _)
r'\s'                               # 공백
r'.'                                # 모든 문자 (1개)
r'^...$'                            # 시작/끝 anchor
```

4 단어 × 5 활용 = 20 활용 자경단 매일.

---

## 2-bonus. 자경단 매일 4 단어 사용 통계

```
자경단 5명 매주 4 단어 사용:
- str 자체:       1,300 (기본 변수·매개변수)
- f-string:       1,050 (보간·디버깅)
- re 함수:        100 (5 함수 평균)
- pattern (regex): 100 (5 카테고리)

총 매주 2,550 호출 = 자경단 매일 364 호출.

매년 5명 합 — 약 132,600 호출.
5년 5명 합 — 약 663,000 호출.
```

4 단어가 자경단 평생 사용량 1위 그룹 중 하나.

---

## 3. str 50+ 메서드 미리보기

### 3-1. 카테고리 5

```python
# 1. 변환 (8개)
upper, lower, title, capitalize, swapcase, casefold, encode, decode

# 2. 검색 (10개)
find, rfind, index, rindex, count, startswith, endswith, in, isxxx() 등

# 3. 변경 (8개)
replace, strip, lstrip, rstrip, removeprefix, removesuffix, expandtabs, translate

# 4. 분할/결합 (5개)
split, rsplit, splitlines, partition, join

# 5. 포맷 (10+개)
format, format_map, f-string, %, ljust, rjust, center, zfill, isxxx (10+)

총 50+ str 메서드.
```

자경단 매일 — 12-15 메서드 빈번. 나머지는 가끔.

### 3-2. 자경단 매일 12 메서드 우선순위

```
1순위 (매일 100+ 호출):
  split, join, strip, replace, find, startswith, endswith, format, lower, upper, isdigit, encode

2순위 (매주 10+ 호출):
  rstrip, lstrip, count, removesuffix, removeprefix, splitlines, partition, decode, ljust, rjust, isalpha, isalnum

3순위 (가끔):
  rfind, index, swapcase, capitalize, title, casefold, expandtabs, translate, format_map, zfill, center, %, isxxx (다수)
```

자경단 — 1순위 12개만 손가락에 붙이면 매일 코드 100% 작성. 2순위 12개는 코드 리뷰 시 알아보기. 3순위는 검색.

### 3-3. str 첫 5 메서드 (자경단 1주차)

```python
# 1. split — 분할
'a,b,c'.split(',')                  # ['a', 'b', 'c']

# 2. join — 결합
','.join(['a', 'b', 'c'])           # 'a,b,c'

# 3. strip — 공백/문자 제거
'  hello  '.strip()                 # 'hello'

# 4. replace — 치환
'hello world'.replace('o', 'O')     # 'hellO wOrld'

# 5. format / f-string — 보간
f'{name}'                           # 'name 값'
```

5 메서드 = 자경단 1주차 마스터.

---

## 4. regex 5 핵심 미리보기

### 4-1. 5 함수

```python
import re

# 1. match — 시작
re.match(r'^\d', 'abc123')          # None
re.match(r'^\d', '123abc')          # match

# 2. search — 어디든
re.search(r'\d+', 'abc123')         # match

# 3. findall — 모두 (list)
re.findall(r'\d+', 'a1b2c3')        # ['1', '2', '3']

# 4. sub — 치환
re.sub(r'\d', 'X', 'a1b2')          # 'aXbX'

# 5. compile — 재 사용
p = re.compile(r'\d+')
p.findall('a1b2c3')                 # ['1', '2', '3']
```

5 함수 = regex 100%.

### 4-2. 5 메타 문자 카테고리

```
1. 문자 클래스: \d \w \s \D \W \S [abc] [^abc]
2. 수량: * + ? {n} {n,m} {n,}
3. anchor: ^ $ \b \B
4. 그룹: () (?:) (?P<name>)
5. lookaround: (?=) (?!) (?<=) (?<!)
```

5 카테고리 × 평균 5 = 25 메타 문자.

### 4-3. regex 첫 5 패턴 (자경단 1주차 학습)

```
1. 이메일: r'^[\w.+-]+@[\w.-]+\.\w+$'
2. 전화: r'^\d{3}-\d{3,4}-\d{4}$'
3. URL: r'https?://[\w./?=&-]+'
4. IPv4: r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$'
5. 날짜 (ISO): r'^\d{4}-\d{2}-\d{2}$'
```

5 패턴 × 자경단 매주 = 1주차 학습 완성.

### 4-4. regex 면접 단골 5

```
면접 1: greedy vs lazy (.* vs .*?)
면접 2: re.match vs re.search vs re.fullmatch
면접 3: capture group vs non-capture (()  vs (?:))
면접 4: lookahead vs lookbehind
면접 5: re.compile 캐싱·언제 필요?
```

5 단골 = 자경단 면접 매주.

---

## 4-bonus. regex 한 줄 매직 5 예시

```python
import re

# 1. 이메일 검증
re.match(r'^[\w.+-]+@[\w.-]+\.\w+$', 'kami@catteam.com')    # match

# 2. 전화번호 (한국)
re.match(r'^\d{3}-\d{3,4}-\d{4}$', '010-1234-5678')         # match

# 3. URL 추출
re.findall(r'https?://[\w./?=&-]+', text)                   # ['https://...']

# 4. HTML tag 제거
re.sub(r'<[^>]+>', '', html)                                # plain text

# 5. 공백 정리 (1+ 공백 → 1 공백)
re.sub(r'\s+', ' ', text).strip()                           # 정리된 text
```

5 한 줄 매직 = 자경단 매주 활용.

### 4-bonus2. f-string 한 줄 매직 5 예시

```python
# 1. 천 단위 콤마
f'{1234567:,}'                       # '1,234,567'

# 2. 0 padding
f'{42:05d}'                          # '00042'

# 3. 소수점 2자리
f'{3.14159:.2f}'                     # '3.14'

# 4. 퍼센트 (백분율)
f'{0.123:.1%}'                       # '12.3%'

# 5. 16진수
f'{255:08x}'                         # '000000ff'
```

5 매직 = 자경단 매일 사용.

---

## 5. 8 H 학습 곡선

| H | 슬롯 | 핵심 |
|---|----|----|
| H1 | 오리엔 | 본 H — str·regex 7 이유 |
| H2 | 핵심개념 | str 50+ 메서드 + f-string 5 양식 |
| H3 | 환경점검 | re module + regex101.com + repl.it |
| H4 | 카탈로그 | str 50+ + regex 5 함수 + 5 메타 |
| H5 | 데모 | exchange_v5: str + regex 통합 |
| H6 | 운영 | encode/decode 함정·정규식 성능 |
| H7 | 원리 | str 메모리·intern·UTF-8 |
| H8 | 회고 |

8 H × 60분 = 8시간 = 자경단 str·regex 100% 마스터.

### 5-2. 8 H 학습 후 본인의 진짜 능력

✅ 50+ str 메서드 손가락에 (split·join·strip·replace·find 등 15+ 매일)
✅ f-string 5 양식 (보간·정렬·천단위·퍼센트·debug)
✅ regex 5 함수 (match·search·findall·sub·compile)
✅ regex 5 카테고리 (문자 클래스·수량·anchor·그룹·lookaround)
✅ exchange_v5 데모에 str+regex 통합 적용
✅ encode/decode 함정 면역 (UTF-8·errors)
✅ regex performance 최적화 (compile·non-greedy)
✅ str 메모리·intern·UTF-8 원리

8 능력 = 자경단 str·regex 마스터.

### 5-3. 8 H 학습 후 자경단 단톡 한 줄

"Ch011 8 H 마스터 완료. str 50+ 메서드·regex 5+5·exchange_v5 데모·encode/decode·intern·매일 1,500+ 호출 능력. 자경단 매일 str·regex 100% 자신감!"

---

## 5-bonus. 자경단의 매일 5분 — str 첫 만남

```python
# 시나리오 1: 사용자 입력 검증 (본인 FastAPI)
@app.post('/cats')
async def create_cat(name: str, age: str):
    name = name.strip()                   # 공백 제거
    if not name or len(name) > 50:        # 길이 검증
        raise HTTPException(400, '이름 1-50자')
    if not age.isdigit():                  # 숫자 검증
        raise HTTPException(400, '나이는 숫자')
    return {'name': name, 'age': int(age)}

# 시나리오 2: 로그 분석 (까미 DB)
import re
log = '127.0.0.1 GET /api/cats 200 0.123s'
match = re.match(r'(\S+) (\w+) (\S+) (\d+) ([\d.]+)s', log)
if match:
    ip, method, path, status, time = match.groups()

# 시나리오 3: 파일 path (노랭이 도구)
path = '/Users/mo/projects/cat-vigilante/main.py'
if path.endswith('.py'):                  # 확장자 검사
    parts = path.split('/')               # 분할
    filename = parts[-1]                  # 'main.py'
    name = filename.removesuffix('.py')   # 'main'

# 시나리오 4: 환경 변수 파싱 (미니 인프라)
import os
db_url = os.getenv('DATABASE_URL', 'sqlite:///default.db')
if db_url.startswith('postgresql://'):
    use_postgres()

# 시나리오 5: 테스트 assertion (깜장이 테스트)
def test_response_format():
    response = '{"name": "까미", "age": 2}'
    assert '"name"' in response
    assert response.count('"') == 4
```

5 시나리오 = 자경단 매일 50+ str 활용.

---

## 6. 자경단 5명 매일 시나리오

### 6-1. 본인 (FastAPI)
- 매일 600+ f-string
- URL parsing·query string·response str
- regex 5+ 입력 검증

### 6-2. 까미 (DB)
- 매일 400+ str
- SQL escape·column name·결과 str
- regex 일주 50+ (로그 분석)

### 6-3. 노랭이 (도구)
- 매일 300+ str
- CLI 인자·파일 path·텍스트 처리
- regex 매일 20+ (텍스트 변환)

### 6-4. 미니 (인프라)
- 매일 100+ str
- IP·hostname·환경 변수·yaml/json
- regex 가끔 (10/주)

### 6-5. 깜장이 (테스트)
- 매일 100+ str
- 테스트 데이터·assertion·로그
- regex 가끔 (15/주)

자경단 5명 매일 합 — 약 1,500 str 호출·매주 100 regex.

---

## 6-bonus. 자경단 1주 str+regex 사용 통계

| 자경단 | f-string | str.method | regex | 합 |
|------|--------|----------|-----|---|
| 본인 (FastAPI) | 600 | 400 | 5 | 1,005 |
| 까미 (DB) | 200 | 400 | 50 | 650 |
| 노랭이 (도구) | 150 | 300 | 20 | 470 |
| 미니 (인프라) | 50 | 100 | 10 | 160 |
| 깜장이 (테스트) | 50 | 100 | 15 | 165 |

총 1주 — f-string 1,050·str method 1,300·regex 100. 자경단 5명 1주 합 2,450 호출.

자경단 매일 350 호출. 매년 5명 합 약 127,400 호출.

### 6-bonus2. str·regex 학습 ROI

```
학습 시간: 8 H × 60분 = 8시간 (Ch011 전체)
사용 빈도: 매주 2,450 호출 × 5명
연간:    2,450 × 52 = 127,400 호출/년
5년:    127,400 × 5 = 637,000 호출/5년
ROI:    8시간 → 5년 60만+ 호출 = 무한 ROI
```

자경단 5명 5년 60만+ str·regex 호출. 8시간 학습 무한 ROI.

---

## 6-bonus3. 자경단 5명 1년 str·regex 회고

```
[본인] 1년 str+regex 호출 — 약 52,260 (매주 1,005)
       URL parsing·response str·검증 매일
       이메일 검증·전화번호·HTTP 헤더 regex
       
[까미] 1년 — 약 33,800 (매주 650)
       SQL escape·column name·결과 str
       Apache log 분석 매주·DB schema dump
       
[노랭이] 1년 — 약 24,440 (매주 470)
       CLI 인자·파일 path·텍스트 변환
       sed/awk 대체 regex 매일
       
[미니] 1년 — 약 8,320 (매주 160)
       IP·hostname·환경 변수
       yaml/toml 파싱·config 검증
       
[깜장이] 1년 — 약 8,580 (매주 165)
       테스트 데이터·assertion·로그 검증
       JSON pattern matching
```

5명 1년 합 — 약 127,400 호출. 매일 350. str·regex이 자경단 매일 인프라.

---

## 7. 12회수 지도

| 챕터 | 회수 |
|-----|----|
| Ch013 (모듈) | from re import compile |
| Ch014 (venv) | regex 패키지 (regex - re의 슈퍼셋) |
| Ch016 (OOP) | __str__·__repr__·__format__ |
| Ch018 (stdlib) | string module + textwrap |
| Ch020 (typing) | LiteralString (Python 3.11+) |
| Ch041 (심화) | str 메모리·intern·UTF-8 깊이 |
| Ch060 (FastAPI) | URL pattern·response str |
| Ch080 (DB) | SQL safe escape |
| Ch091 (Pydantic) | str 검증·constr |
| Ch103 (배포) | 환경 변수·config 파싱 |
| Ch118 (보안) | XSS·HTML escape·SQL 안전 |
| Ch120 (마무리) | str·regex 12년 회고 |

12회수 = Ch011이 평생 회수의 시작.

### 7-bonus. Ch011 → Ch020 9 챕터 학습 미리보기

```
Ch011: 문자열·정규식 (본 챕터)
Ch012: 파일 I/O·예외 처리
Ch013: 모듈/패키지
Ch014: venv·pip·uv
Ch015: CLI 도구 (cat budget)
Ch016: OOP 1 (class·instance)
Ch017: OOP 2 (상속·다형성)
Ch018: stdlib 1 (time·path·json)
Ch019: stdlib 2 (collections·itertools 회수)
Ch020: typing
```

10 챕터 × 8 H = 80 H = Python 입문 80h 마스터.

자경단 본인의 길 — Ch011 (str/regex) → Ch020 (typing) 9 챕터 더 = Python 입문 80h 완성.

---

## 8. 면접 10 질문

**Q1. str이 immutable인 이유?**
A. hash 가능·dict 키·thread-safe·메모리 share (intern). Python 디자인 결정.

**Q2. f-string vs format() 차이?**
A. f-string은 컴파일 타임·30% 빠름·가독성. format()은 dynamic.

**Q3. str.join vs + 연산자?**
A. join O(n)·새 str 한 번. + 매 연산 새 str O(n²).

**Q4. encode vs decode?**
A. encode str → bytes (UTF-8 표준). decode bytes → str.

**Q5. regex greedy vs lazy?**
A. `.*` greedy (최대). `.*?` lazy (최소). HTML parsing은 lazy.

**Q6. re.match vs re.search?**
A. match 시작만. search 어디든.

**Q7. `\d` vs `[0-9]`?**
A. 같음 (ASCII 기준). re.UNICODE는 \d가 모든 숫자.

**Q8. raw string r''?**
A. backslash 그대로. regex 표준 양식.

**Q9. capture group?**
A. () 그룹화. .groups()로 추출.

**Q10. lookahead `(?=)`?**
A. 검사만 하고 매치 X. 위치 검사용.

10 면접 질문 = 자경단 시니어 신호.

### 8-bonus. 면접 5단계 표준 답 예시

```
질문: "f-string vs format() 차이?"

1. 5초 답: "f-string은 컴파일 타임 보간"
2. 5초 부연: "Python 3.6+ 표준·30% 빠름"
3. 5초 깊이: "FORMAT_VALUE opcode·string concat 최적화"
4. 5초 수치: "1만 호출 timeit f-string 0.1s vs format 0.13s"
5. 5초 예시: "format은 동적 양식 (template). f-string은 정적·가독성"

총 25초 = 자경단 면접 시니어 신호.
```

면접 10 질문 × 25초 = 4분. 자경단 매주 면접 시뮬레이션.

### 8-bonus2. 면접 깊이 10 질문 추가

11. str.encode 기본 인코딩? UTF-8.
12. UTF-8 byte 수 한글? 3 byte.
13. str hash 안정성? 같은 str 같은 hash (intern).
14. f-string 한국어 OK? 100% OK.
15. regex flag re.I·re.M·re.S 차이?
16. regex backreference \1?
17. regex non-greedy 성능?
18. str.find vs index?
19. str split maxsplit?
20. str format spec full grammar?

10 깊이 질문 추가 = 면접 20 질문 자경단 시니어 표준.

---

## 9. 흔한 오해 + FAQ + 추신

### 9-1. 흔한 오해 5가지

**오해 1: "str.format()이 표준."** — Python 3.6+ f-string 1순위. format()은 동적 양식.

**오해 2: "regex는 어렵다."** — 5 함수 + 5 카테고리만 매일. 외울 필요 X.

**오해 3: "str 메서드 50+ 모두 외움."** — 12-15만 매일. 나머지 검색.

**오해 4: "regex로 모든 텍스트 처리."** — HTML은 BeautifulSoup·JSON은 json·regex는 단순 패턴만.

**오해 5: "str.replace는 한 번만."** — 모두 치환. count=1로 한 번 가능.

**오해 6: "한국어는 regex \\w 안 됨."** — re.UNICODE flag (기본·Python 3+) 한국어 OK.

**오해 7: "f-string은 단순 보간."** — format spec·alignment·conversion 강력. 100+ 문법.

**오해 8: "str + str 빠름."** — 1만+ concat은 join 100배. 작은 것만 +.

**오해 9: "regex `.`는 모든 문자."** — 줄바꿈 X·re.S flag로 가능.

**오해 10: "str.format()이 옛날 양식이라 deprecated."** — Python 표준·동적 양식 (template) 자경단 가끔.

### 9-2. FAQ 10가지

**Q1. f-string 인코딩?**
A. UTF-8 표준. 한글 OK. 파일도 utf-8 표준.

**Q2. regex compile 매번?**
A. 매번 X·반복 사용 시 compile. CPython이 캐시도 함.

**Q3. str slicing 메모리?**
A. 새 str 생성. 큰 str slicing은 메모리 주의.

**Q4. str * N?**
A. `'-' * 10` = '----------'. 빠름·메모리 한 번.

**Q5. regex 디버깅?**
A. regex101.com (온라인 visual debugger). 자경단 표준.

**Q6. f-string 안에 dict?**
A. `f'{d["key"]}'` (다른 quote). 또는 변수 분리.

**Q7. multiline f-string?**
A. triple quote `f'''...'''`. 또는 implicit concat `f'a' f'b'`.

**Q8. regex performance 측정?**
A. timeit + re.compile. 매번 compile 100배 느림.

**Q9. str method chain?**
A. OK·매 method 새 str 반환. `s.strip().lower().replace('a','b')` 4 새 str.

**Q10. encode errors='ignore'?**
A. 인코딩 실패 시 문자 무시. 안전·하지만 데이터 잃음. 자경단 errors='replace' 추천.

### 9-3. 추신 50

추신 1. str·regex 7 이유 — 데이터·f-string·5줄→1줄·검증·로그·SQL·면접.

추신 2. 4 단어 (str·f-string·re·pattern) + 5 활용 = 20 활용.

추신 3. str 50+ 메서드 5 카테고리 — 변환 8·검색 10·변경 8·분할/결합 5·포맷 10+.

추신 4. f-string 5 양식 — 보간·정렬·천 단위·퍼센트·debug.

추신 5. regex 5 함수 — match·search·findall·sub·compile.

추신 6. regex 5 메타 카테고리 — 문자 클래스·수량·anchor·그룹·lookaround.

추신 7. 8 H 학습 — 오리엔·핵심·환경·카탈로그·데모·운영·원리·회고.

추신 8. 자경단 5명 매일 — 본인 600·까미 400·노랭이 300·미니 100·깜장이 100 = 합 1,500.

추신 9. 자경단 매주 regex — 100+ (로그 분석 까미 50·노랭이 20·깜장이 15·미니 10·본인 5).

추신 10. 12회수 지도 — Ch013·014·016·018·020·041·060·080·091·103·118·120.

추신 11. 면접 10 질문 — str immutable·f-string vs format·join vs +·encode/decode·greedy/lazy·match/search·\d/[0-9]·raw·group·lookahead.

추신 12. 흔한 오해 5 면역 — format 표준·regex 어려움·메서드 50 외움·HTML regex·replace 한 번.

추신 13. FAQ 5 — UTF-8·compile·slicing·* N·regex101.

추신 14. f-string은 Python 3.6+. 모든 자경단 코드 표준.

추신 15. self-documenting f-string은 Python 3.12+. 디버깅 1순위.

추신 16. regex101.com = 자경단 visual debugger. 매일 5분 사용.

추신 17. raw string r'' = regex 표준 양식. backslash escape 회피.

추신 18. str.format은 동적 양식 (template engine). 자경단 가끔.

추신 19. f-string vs format vs % — f-string > format > %. 자경단 표준.

추신 20. str.join vs + — 1만 element 100배 차이.

추신 21. str immutable의 가치 — hash·dict 키·thread-safe·메모리 share.

추신 22. str intern (sys.intern) — 같은 str 메모리 공유. 자경단 거의 자동.

추신 23. encode/decode — str ↔ bytes. UTF-8 표준.

추신 24. UTF-8 = 가변 길이 (1-4 byte). 한글 3 byte.

추신 25. regex greedy `.*` vs lazy `.*?` — HTML parsing은 lazy.

추신 26. re.match = 시작·re.search = 어디든·re.fullmatch = 전체.

추신 27. re.findall = 모두 list·re.finditer = generator (큰 데이터).

추신 28. re.sub = 치환. 함수 전달도 가능 (동적 치환).

추신 29. capture group `()` — .groups() 또는 .group(N).

추신 30. named group `(?P<name>...)` — .group('name') 또는 dict.

추신 31. non-capture `(?:...)` — 그룹화만·capture X.

추신 32. lookahead `(?=)` — 매치 후 검사. 위치 마커.

추신 33. lookbehind `(?<=)` — 매치 전 검사.

추신 34. \d \w \s — 숫자·단어·공백. \D \W \S 반대.

추신 35. anchor ^ $ \b \B — 시작·끝·단어 경계.

추신 36. 수량 * + ? — 0+·1+·0/1.

추신 37. 수량 {n} {n,m} {n,} — 정확히 n·n-m·n+.

추신 38. f-string format spec — `:>10` 정렬·`:,` 천 단위·`:.2f` 소수·`:%` 퍼센트.

추신 39. f-string + alignment — `<` 좌·`>` 우·`^` 중앙.

추신 40. 자경단 매일 메서드 12-15개 — split·join·strip·replace·find·startswith·endswith·upper·lower·format·encode·decode·isdigit·isalpha·isalnum.

추신 41. 자경단 매주 regex — 5 함수·5 카테고리. 1주차 1+ regex 작성.

추신 42. **본 H 끝** ✅ — Ch011 H1 오리엔 학습 완료. 다음 H2 핵심개념! 🐾🐾🐾

추신 43. 본 H 학습 후 본인의 첫 5 행동 — 1) f-string 모든 print 교체, 2) str.format 다 f-string으로, 3) regex101.com 북마크, 4) 자경단 코드 regex 패턴 wiki, 5) 면접 10 질문 외움.

추신 44. 본 H의 진짜 결론 — str·regex가 자경단 매일 1,500+ 호출. collections (1,150) 다음 2위.

추신 45. **본 H 진짜 끝** ✅✅ — Ch011 H1 오리엔 완료! 자경단 매일 1,500 str! 🐾🐾🐾🐾🐾

추신 46. 자경단의 1주차 학습 패턴 — H1 오리엔 → H2 핵심 → H3 환경 → H4 카탈로그 → H5 데모 → H6 운영 → H7 원리 → H8 회고.

추신 47. Ch011 학습 후 자경단 — Python 입문 5 (str/regex) 추가 마스터. Python 입문 80h 길의 11/20 = 55%.

추신 48. 자경단 1년 후 — Ch020 (테스트) 마치면 Python 입문 80h 완성. 진짜 시니어 자경단.

추신 49. **Ch011 H1 진짜 진짜 끝** ✅✅✅ — 다음 H2 str 50+ 메서드 깊이! 🐾🐾🐾🐾🐾🐾🐾

추신 50. **마지막 인사 🐾** — Ch011 H1 학습 후 자경단의 str·regex 학습 시작·8 H 후 마스터·다음 Ch012 (파일/예외) 학습 시작·자경단 Python 마스터 길의 55% 진행 중! 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾

추신 51. 자경단 1주 str/regex 통계 — f-string 1,050·str method 1,300·regex 100 = 합 2,450 호출. 매년 5명 합 127,400.

추신 52. ROI — 8시간 학습 → 5년 60만+ 호출 → 무한 ROI.

추신 53. 자경단 매일 5분 5 시나리오 — 사용자 입력·로그·파일 path·환경 변수·테스트 assertion.

추신 54. 면접 5단계 표준 답 — 5초답·5초부연·5초깊이·5초수치·5초예시 = 25초.

추신 55. 면접 깊이 10 질문 추가 — encode/UTF-8/intern/한국어/regex flag/backreference/non-greedy/find vs index/maxsplit/format spec.

추신 56. 면접 20 질문 (10 + 10) — 자경단 시니어 신호.

추신 57. 흔한 오해 10 면역 — format 표준·regex 어려움·메서드 50·HTML regex·replace 한 번·\w 한국어·f-string 단순·+ 빠름·`.` 줄바꿈·format deprecated.

추신 58. FAQ 10 답 — UTF-8·compile·slicing·* N·regex101·dict 보간·multiline·perf·chain·encode errors.

추신 59. **본 H 정말 진짜 끝** ✅✅✅✅ — Ch011 H1 오리엔 완성·자경단 str·regex 학습 시작·다음 H2 핵심개념 (str 50+ 메서드·f-string 5 양식)! 🐾🐾🐾🐾🐾🐾🐾🐾🐾

추신 60. **마지막 마지막 인사 🐾🐾🐾** — 자경단의 Python 입문 5 (Ch011 str/regex) 학습 시작 인증·Python 마스터 80h 길의 55% 진행·자경단 본인이 매일 1,500+ str 호출 마스터로 진화 중! 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾

추신 61. regex 한 줄 매직 5 — 이메일·전화번호·URL 추출·HTML tag 제거·공백 정리.

추신 62. f-string 한 줄 매직 5 — 천 단위·0 padding·소수점·퍼센트·16진수.

추신 63. 8 H 학습 후 본인의 8 능력 — 50+ 메서드·f-string 5·regex 5+5·exchange_v5·encode/decode·perf·intern·UTF-8.

추신 64. 자경단 5명 1년 회고 — 본인 52,260·까미 33,800·노랭이 24,440·미니 8,320·깜장이 8,580 = 합 127,400.

추신 65. Ch011 → Ch020 9 챕터 = Python 입문 80h 완성 길.

추신 66. **본 H 정말 정말 진짜 끝** ✅✅✅✅✅ — Ch011 H1 오리엔 + 5 시나리오 + 5명 1주 통계 + ROI + regex 5 매직 + f-string 5 매직 + 8 능력 + 5명 1년 회고 + Ch020 미리보기 모두 완성! 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾

추신 67. 자경단 매일 4 단어 사용 통계 — 매주 2,550 호출 = 매일 364 호출. 5명 1년 132,600. 5년 663,000.

추신 68. str 12 메서드 1순위 — split·join·strip·replace·find·startswith·endswith·format·lower·upper·isdigit·encode.

추신 69. str 12 메서드 2순위 (매주 10+) — rstrip·lstrip·count·removesuffix·removeprefix·splitlines·partition·decode·ljust·rjust·isalpha·isalnum.

추신 70. str 첫 5 메서드 (1주차) — split·join·strip·replace·format/f-string.

추신 71. regex 첫 5 패턴 — 이메일·전화·URL·IPv4·날짜.

추신 72. 다국어 str — 한국어·일본어·이모지 100% UTF-8 한 글자 len 1.

추신 73. **본 H 정말 정말 정말 끝** ✅✅✅✅✅✅ — Ch011 H1 오리엔 모든 학습 완성·str·regex 1주차 능력·자경단 다음 H2 핵심개념 학습 시작! 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾
