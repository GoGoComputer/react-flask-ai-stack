# Ch011 · H6 — str·regex 운영 — 함정 + 성능 + encoding

> 고양이 자경단 · Ch 011 · 6교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. encoding 다섯 함정
3. 정규식 성능 다섯 패턴
4. catastrophic backtracking
5. unicode와 한글
6. 자경단 매일 코드 리뷰
7. 다섯 함정과 처방
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요.

지난 H5 회수. text_processor 100줄.

이번 H6은 운영. encoding, 성능, 한글.

오늘의 약속. **본인이 5년 동안 만날 텍스트 사고에 면역**.

자, 가요.

---

## 2. encoding 다섯 함정

**1. UnicodeDecodeError**

```python
with open("file.txt") as f:    # 기본 encoding
    text = f.read()
# UnicodeDecodeError 가능
```

처방. 명시적 UTF-8.

```python
with open("file.txt", encoding="utf-8") as f:
    text = f.read()
```

**2. 한글 깨짐 (cp949 vs utf-8)**

처방. 항상 UTF-8.

**3. BOM 마크**

처방. `encoding="utf-8-sig"`.

**4. bytes vs str**

```python
b = "hello".encode("utf-8")
s = b.decode("utf-8")
```

**5. 파일 쓰기 한글**

처방. `open(path, "w", encoding="utf-8")`.

자경단 표준 — 모든 open()에 `encoding="utf-8"` 명시.

---

## 3. 정규식 성능 다섯 패턴

**1. 컴파일 + 재사용**

```python
EMAIL_RE = re.compile(r'[\w.+-]+@\w+\.\w+')

# 여러 곳에서
EMAIL_RE.match(text1)
EMAIL_RE.match(text2)
```

**2. 단순 패턴 vs 복잡**

```python
# 느림
re.match(r'.+@.+\..+', email)

# 빠름
re.match(r'[\w.+-]+@\w+\.\w+', email)
```

**3. anchor 사용**

```python
re.match(r'^abc', text)   # ^로 시작 명시
```

**4. lazy quantifier**

```python
re.findall(r'<.+?>', html)   # ? for lazy
```

**5. 컴파일된 패턴 in module level**

```python
# bad — 함수 안에서 매번
def process(text):
    return re.findall(r'\d+', text)

# good — 모듈 레벨
NUM_RE = re.compile(r'\d+')

def process(text):
    return NUM_RE.findall(text)
```

자경단 매일.

---

## 4. catastrophic backtracking

```python
# 위험한 패턴
re.match(r'(a+)+b', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaa!')
# 1000년 걸림 (실제로)
```

nested quantifier가 backtracking 폭발. 1만 글자 입력에서 timeout.

처방. atomic group 또는 단순화.

```python
re.match(r'a+b', text)   # 단순화
```

자경단의 매일 점검 — 정규식에 nested `+`, `*` 있으면 의심.

---

## 5. unicode와 한글

```python
# 한글 매칭
re.findall(r'[가-힣]+', text)

# 한글 + 영어 + 숫자
re.findall(r'[\w가-힣]+', text)

# 자모
re.findall(r'[ㄱ-ㅎㅏ-ㅣ]+', text)

# 정렬 (한글 사전 순)
import locale
locale.setlocale(locale.LC_ALL, 'ko_KR.UTF-8')
sorted(words, key=locale.strxfrm)
```

자경단 표준 — 한글은 [가-힣].

---

## 6. 자경단 매일 코드 리뷰

텍스트 다섯 점검.

**1. encoding 명시?**

**2. raw string `r''`?**

**3. 정규식 컴파일?**

**4. catastrophic 위험?**

**5. 한글 안전?**

다섯. PR 표준.

---

## 7. 다섯 함정과 처방

**함정 1: open() encoding 누락**

처방. 항상 utf-8.

**함정 2: re.search vs match 혼동**

처방. 시작부터는 match 또는 ^.

**함정 3: greedy 폭발**

처방. lazy.

**함정 4: backslash escape**

처방. raw string.

**함정 5: 한글 \w 호환**

처방. Python 3 자동.

---

## 8. 흔한 오해 다섯 가지

**오해 1: encoding 자동.**

명시 안전.

**오해 2: 정규식 항상 빠르다.**

복잡한 패턴 느림.

**오해 3: 한글 특별 처리.**

Python 3 자동.

**오해 4: re.compile 시니어.**

매일.

**오해 5: catastrophic 안 일어남.**

production에서 자주.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. utf-8 vs utf-8-sig?**

BOM 있으면 sig.

**Q2. cp949?**

옛 윈도우. 안 씀.

**Q3. 정규식 vs str.find?**

단순한 건 str.find가 빠름.

**Q4. catastrophic 진단?**

regex101에 디버거.

**Q5. 한글 sorting?**

locale 모듈.

---

## 10. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, regex performance 무지. 안심 — compile 후 재사용.
둘째, ReDoS 공격 가능. 안심 — 복잡한 regex 검증.
셋째, encoding 누락. 안심 — UTF-8 명시.
넷째, str + str 큰 데이터. 안심 — join.
다섯째, 가장 큰 — 정규식 우선. 안심 — str 메서드 우선.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 여섯 번째 시간 끝.

encoding 5 함정, 성능 5 패턴, catastrophic, unicode.

다음 H7은 깊이. NFA, DFA, str 내부.

```python
python3 -c "with open('test.txt', 'w', encoding='utf-8') as f: f.write('한글')"
```

---

## 👨‍💻 개발자 노트

> - PEP 597: encoding 미명시 경고. 3.10+.
> - re.compile cache: 512개. 그 이상은 미컴파일.
> - catastrophic 검출: regex101 debugger.
> - unicode normalization: NFC vs NFD. 한글 자모.
> - PCRE vs re: re는 더 단순. PCRE는 더 강력.
> - 다음 H7 키워드: NFA · DFA · regex 엔진 · str 메모리.
