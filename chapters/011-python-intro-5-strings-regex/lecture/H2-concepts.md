# Ch011 · H2 — str 30 메서드 + regex 8 패턴 깊이

> 고양이 자경단 · Ch 011 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. str 메서드 — 정리·검사 10
3. str 메서드 — 변환 10
4. str 메서드 — 검색·분할 10
5. f-string 깊이
6. regex 패턴 8가지
7. regex 그룹과 캡처
8. regex 함수 5가지
9. 한 줄 분해
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요.

지난 H1 회수. str·f-string·re·regex 네 친구.

이번 H2는 30+ str 메서드 + 8 regex 패턴.

오늘의 약속. **본인이 매일 만나는 텍스트 도구 30개를 손가락에 박습니다**.

자, 가요.

---

## 2. str 메서드 — 정리·검사 10

```python
"  hello  ".strip()           # 'hello'
"  hello  ".lstrip()          # 'hello  '
"  hello  ".rstrip()          # '  hello'
"hello".upper()               # 'HELLO'
"HELLO".lower()               # 'hello'
"hello".title()               # 'Hello'
"hello".capitalize()          # 'Hello'

"123".isdigit()               # True
"abc".isalpha()               # True
"abc123".isalnum()            # True
```

10개. 매일.

---

## 3. str 메서드 — 변환 10

```python
"abc".replace("a", "z")       # 'zbc'
"abc".translate(str.maketrans("a", "z"))   # 'zbc'

"hello".center(11, "*")       # '***hello***'
"hi".ljust(5, ".")            # 'hi...'
"hi".rjust(5, ".")            # '...hi'
"hi".zfill(5)                 # '000hi'

"a,b,c".split(",")            # ['a', 'b', 'c']
",".join(["a", "b", "c"])     # 'a,b,c'

"line1\nline2".splitlines()   # ['line1', 'line2']
"abc".encode("utf-8")         # b'abc'
```

10개.

---

## 4. str 메서드 — 검색·분할 10

```python
"hello world".find("world")        # 6 (없으면 -1)
"hello world".index("world")       # 6 (없으면 ValueError)
"hello world".rfind("o")           # 7 (오른쪽부터)
"hello".count("l")                 # 2

"hello".startswith("he")           # True
"hello".endswith("lo")             # True
"hello" in "hello world"           # True

"key=value".partition("=")         # ('key', '=', 'value')
"key=value".rpartition("=")
"a=b=c".split("=", 1)              # ['a', 'b=c']
```

10개.

자경단 30 메서드 매일.

---

## 5. f-string 깊이

```python
name = "자경단"
age = 5

# 기본
f"{name} {age}"

# 포매팅
f"{age:.2f}"               # '5.00'
f"{age:,}"                 # '5'
f"{age:0>5}"               # '00005' 왼쪽 0 패딩

# 정렬
f"{name:>10}"              # 오른쪽 10칸
f"{name:<10}"              # 왼쪽 10칸
f"{name:^10}"              # 가운데

# 표현식
f"{age + 1}"
f"{name.upper()}"

# 디버그 (3.8+)
f"{age=}"                  # 'age=5'

# 진수
f"{255:b}"                 # '11111111' binary
f"{255:o}"                 # '377' octal
f"{255:x}"                 # 'ff' hex
```

자경단 매일.

---

## 6. regex 패턴 8가지

```python
import re

# 1. 글자 클래스
r"\d"        # 숫자
r"\w"        # 단어 글자 (영문+숫자+_)
r"\s"        # 공백

# 2. 횟수
r"\d+"       # 1번 이상
r"\d*"       # 0번 이상
r"\d?"       # 0 또는 1
r"\d{3}"     # 정확 3번
r"\d{2,5}"   # 2~5번

# 3. 위치
r"^hello"    # 줄 시작
r"hello$"    # 줄 끝
r"\bword\b"  # 단어 경계

# 4. 그룹
r"(\d+)"     # 캡처 그룹
r"(?:\d+)"   # 비캡처

# 5. 선택
r"cat|dog"

# 6. 임의 글자
r"."         # 줄바꿈 빼고 모든 글자

# 7. 부정
r"[^abc]"    # a, b, c 제외

# 8. 커스텀 클래스
r"[a-zA-Z]"  # 영문
r"[가-힣]"   # 한글
```

8 패턴이 자경단 매일.

---

## 7. regex 그룹과 캡처

```python
m = re.search(r"(\w+)@(\w+\.\w+)", "user@example.com")
m.group(0)   # 'user@example.com' 전체
m.group(1)   # 'user'
m.group(2)   # 'example.com'

# 이름 있는 그룹
m = re.search(r"(?P<user>\w+)@(?P<domain>\w+\.\w+)", "user@example.com")
m.group("user")     # 'user'
m.group("domain")   # 'example.com'
```

자경단 매일 데이터 추출.

---

## 8. regex 함수 5가지

```python
re.match(pattern, text)      # 시작부터 매치
re.search(pattern, text)     # 어디든 매치
re.findall(pattern, text)    # 모든 매치 list
re.finditer(pattern, text)   # 모든 매치 iterator
re.sub(pattern, repl, text)  # 치환
```

자경단 매일 — search 50%, findall 30%, sub 20%.

---

## 9. 한 줄 분해

```python
re.findall(r'(\d{4})-(\d{2})-(\d{2})', text)
# 날짜 yyyy-mm-dd 패턴 다 추출
```

자경단 매일.

---

## 10. 흔한 오해 다섯 가지

**오해 1: re.match는 모든 곳.**

시작부터만. search가 자유.

**오해 2: . 모든 글자.**

줄바꿈 제외. re.DOTALL 옵션.

**오해 3: regex는 옛 도구.**

매일 사용.

**오해 4: f-string format 다 같다.**

f-string이 더 강력.

**오해 5: str.replace는 한 번.**

모두 치환.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. find vs index?**

find는 -1, index는 ValueError.

**Q2. greedy vs lazy?**

`*?`, `+?`로 lazy.

**Q3. 한글 매칭?**

`[가-힣]`.

**Q4. multiline?**

re.MULTILINE 옵션.

**Q5. 컴파일?**

`re.compile()`로 재사용.

---

## 12. 흔한 실수 다섯 + 안심 — 핵심 학습 편

첫째, regex flavors 헷갈림. 안심 — Python re만.
둘째, raw string 안 씀. 안심 — `r"..."` 표준.
셋째, greedy vs lazy. 안심 — 기본 greedy, lazy는 `?`.
넷째, anchor `^`/`$` 무지. 안심 — 시작/끝 명시.
다섯째, 가장 큰 — regex 외움. 안심 — regex101.com 매일.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 두 번째 시간 끝.

str 30 메서드, f-string 깊이, regex 8 패턴 + 그룹 + 5 함수.

다음 H3는 도구.

```python
python3 -c 'import re; print(re.findall(r"\d+", "cat-3 dog-2"))'
```

---

## 👨‍💻 개발자 노트

> - str immutable: 메모리 + 캐싱.
> - re.compile: 한 번 컴파일 후 재사용.
> - regex backtracking: catastrophic 가능. 주의.
> - unicode flag: re.UNICODE (3.x 기본).
> - 다음 H3 키워드: re module · regex101 · ipython · rich · regex tester.
