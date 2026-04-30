# Ch011 · H7 — str·regex 내부 — PEP 393·intern·NFA/DFA

> 고양이 자경단 · Ch 011 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. PEP 393 — Flexible String Representation
3. string interning
4. regex 엔진 — NFA vs DFA
5. backtracking과 catastrophic
6. unicode normalization
7. encoding과 bytes
8. 흔한 오해 다섯 가지
9. 마무리

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요.

지난 H6 회수. encoding, 정규식 성능, catastrophic, unicode.

이번 H7은 깊이.

오늘의 약속. **본인이 string 메모리와 regex 엔진을 이해합니다**.

자, 가요.

---

## 2. PEP 393 — Flexible String Representation

Python 3.3+ string의 메모리 최적화.

옛 Python — 모든 string이 UCS-4 (4 bytes per char). "abc" = 12 bytes. 영문도 한글도.

PEP 393 — 가장 큰 글자에 맞춰 1, 2, 4 bytes.

```python
import sys

sys.getsizeof("a")        # 50 bytes (ASCII)
sys.getsizeof("ä")        # 74 bytes (Latin-1)
sys.getsizeof("가")       # 76 bytes (BMP, 2 bytes/char)
sys.getsizeof("😀")       # 80 bytes (Astral, 4 bytes/char)
```

영문만 있으면 1 byte. 한글 있으면 2 byte. 이모지 있으면 4 byte.

자경단 매일 — 메모리 자동 최적화. 본인 신경 안 씀.

---

## 3. string interning

CPython이 짧은 string을 자동 인터닝.

```python
a = "hello"
b = "hello"
a is b   # True (같은 객체)

a = "h" * 100
b = "h" * 100
a is b   # False (긴 string은 인터닝 안 함)
```

interning 조건. ASCII만, 짧고, identifier 같은 형태.

`sys.intern()`으로 강제.

```python
import sys
a = sys.intern("hello world")
b = sys.intern("hello world")
a is b   # True
```

자경단 매일 — 자주 비교하는 string에 intern. 메모리 + 속도.

---

## 4. regex 엔진 — NFA vs DFA

정규식 매칭에는 두 알고리즘.

**NFA** (Nondeterministic Finite Automaton). backtracking 기반. Python의 `re`가 NFA. 복잡한 패턴 가능 (lookahead 등). 그러나 catastrophic backtracking 위험.

**DFA** (Deterministic Finite Automaton). 모든 상태 미리 계산. 항상 빠름. 그러나 lookahead 등 못 함.

Python `re`는 NFA. `regex` 라이브러리도 NFA. Go의 RE2는 DFA.

자경단 매일 — Python `re`. catastrophic 패턴만 주의.

---

## 5. backtracking과 catastrophic

위험한 패턴.

```python
import re
re.match(r'(a+)+b', 'aaaaaaaaaaaaaaaaaaaaaa')
# 무한대 시간
```

`(a+)+`가 nested quantifier. NFA가 모든 가능한 분해 시도. 입력 길이의 지수.

처방.

```python
# atomic group
re.match(r'(?>a+)b', text)

# 단순화
re.match(r'a+b', text)
```

자경단 매주 — 정규식에 nested `+`, `*` 보면 의심.

---

## 6. unicode normalization

같은 글자도 여러 방식으로 표현 가능.

```python
import unicodedata

a = "가"   # 한 글자
b = "ㄱㅏ"   # 두 글자

a == b   # False
unicodedata.normalize("NFC", a) == unicodedata.normalize("NFC", b)
# True

# 또는
unicodedata.normalize("NFD", a) == unicodedata.normalize("NFD", b)
```

NFC (composed)와 NFD (decomposed). NFC가 표준.

자경단 매일 — 사용자 입력은 항상 NFC normalize.

```python
text = unicodedata.normalize("NFC", user_input)
```

---

## 7. encoding과 bytes

string과 bytes는 다른 자료형.

```python
s = "안녕"
b = s.encode("utf-8")   # bytes
b   # b'\xec\x95\x88\xeb\x85\x95'

s_back = b.decode("utf-8")
s_back   # '안녕'
```

UTF-8이 표준. 한글은 3 bytes per char. 영문은 1 byte.

```python
len("hello")   # 5 (글자)
len("hello".encode("utf-8"))   # 5 (bytes, 같음)

len("안녕")   # 2 (글자)
len("안녕".encode("utf-8"))   # 6 (bytes, 다름)
```

자경단 표준 — 항상 UTF-8.

---

## 8. 흔한 오해 다섯 가지

**오해 1: string immutable 비효율.**

PEP 393으로 메모리 최적화.

**오해 2: regex 항상 빠르다.**

backtracking 폭발 가능.

**오해 3: 한글 깨짐 자주.**

UTF-8 명시면 0.

**오해 4: intern 모든 string.**

자동만 안전.

**오해 5: NFC vs NFD.**

자경단 NFC 표준.

---

## 9. 흔한 실수 다섯 + 안심 — 깊이 학습 편

첫째, string memory 무지. 안심 — PEP 393 자동.
둘째, intern 직접 매번. 안심 — CPython 자동.
셋째, NFA·DFA 헷갈림. 안심 — Python re는 NFA만.
넷째, NFC·NFD 무지. 안심 — 입력 NFC normalize.
다섯째, 가장 큰 — encoding 자동 기대. 안심 — UTF-8 명시.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 10. 마무리

자, 일곱 번째 시간 끝.

PEP 393, string interning, NFA vs DFA, backtracking, normalization, encoding.

다음 H8은 적용 + 회고.

```python
import sys
print(sys.getsizeof("a"), sys.getsizeof("가"), sys.getsizeof("😀"))
```

---

## 👨‍💻 개발자 노트

> - PEP 393: 3.3+. 메모리 최적화.
> - sys.intern(): 명시적 인터닝.
> - re vs regex 라이브러리: regex가 더 강력.
> - RE2 (Go): DFA, catastrophic 면역.
> - 다음 H8 키워드: 7H 회고 · text_processor · Ch012 다리.
