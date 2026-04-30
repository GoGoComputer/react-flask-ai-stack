# Ch011 · H4 — 30+ 자경단 매일 텍스트 패턴

> 고양이 자경단 · Ch 011 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 검증 패턴 10
3. 추출 패턴 10
4. 변환 패턴 10
5. 매일·주간·월간 리듬
6. 자경단 매일 13줄 흐름
7. 다섯 함정과 처방
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요.

지난 H3 회수. re, regex101, VS Code, rich, ipython.

이번 H4는 30+ 패턴.

오늘의 약속. **본인이 매일 만나는 검증 + 추출 + 변환 30 패턴이 손가락에 박힙니다**.

자, 가요.

---

## 2. 검증 패턴 10

```python
import re

# 1. 이메일
re.match(r'[\w.+-]+@\w+\.\w+', email)

# 2. 전화번호 (한국)
re.match(r'^010-\d{4}-\d{4}$', phone)

# 3. URL
re.match(r'https?://[\w.-]+', url)

# 4. IPv4
re.match(r'^(\d{1,3}\.){3}\d{1,3}$', ip)

# 5. UUID
re.match(r'^[0-9a-f-]{36}$', uuid)

# 6. ISO 날짜
re.match(r'^\d{4}-\d{2}-\d{2}$', date)

# 7. 비밀번호 (8자, 영숫자)
re.match(r'^[a-zA-Z0-9]{8,}$', password)

# 8. 한글
re.match(r'^[가-힣]+$', name)

# 9. 정수
re.match(r'^-?\d+$', s)

# 10. 실수
re.match(r'^-?\d+\.?\d*$', s)
```

10 검증.

---

## 3. 추출 패턴 10

```python
# 1. 모든 숫자
re.findall(r'\d+', text)

# 2. 모든 단어
re.findall(r'\w+', text)

# 3. 이메일 주소들
re.findall(r'[\w.+-]+@\w+\.\w+', text)

# 4. URL들
re.findall(r'https?://\S+', text)

# 5. 해시태그
re.findall(r'#\w+', text)

# 6. 멘션
re.findall(r'@\w+', text)

# 7. 따옴표 안 텍스트
re.findall(r'"([^"]*)"', text)

# 8. HTML 태그
re.findall(r'<[^>]+>', html)

# 9. 날짜 yyyy-mm-dd
re.findall(r'\d{4}-\d{2}-\d{2}', text)

# 10. 시간 HH:MM
re.findall(r'\d{2}:\d{2}', text)
```

10 추출.

---

## 4. 변환 패턴 10

```python
# 1. 공백 정리 (여러 공백을 하나로)
re.sub(r'\s+', ' ', text)

# 2. 줄바꿈 제거
re.sub(r'\n+', ' ', text)

# 3. HTML 태그 제거
re.sub(r'<[^>]+>', '', html)

# 4. 비밀번호 마스킹
re.sub(r'\d', '*', password)

# 5. 카멜 → 스네이크
re.sub(r'(?<!^)(?=[A-Z])', '_', name).lower()

# 6. 스네이크 → 카멜
re.sub(r'_(\w)', lambda m: m.group(1).upper(), name)

# 7. 전화번호 포매팅
re.sub(r'(\d{3})(\d{4})(\d{4})', r'\1-\2-\3', phone)

# 8. 주민번호 마스킹
re.sub(r'(\d{6})-?(\d{7})', r'\1-*******', ssn)

# 9. URL 도메인만
re.sub(r'https?://([^/]+).*', r'\1', url)

# 10. 멀티라인 trim
re.sub(r'^\s+|\s+$', '', text, flags=re.MULTILINE)
```

10 변환.

---

## 5. 매일·주간·월간 리듬

**매일 10**. find, replace, split, join, strip, upper, lower, contains, startswith, format.

**주간 10**. re.search, re.findall, re.sub, re.match, re.compile, group, named group, lazy, multiline, ignorecase.

**월간 10**. lookahead, lookbehind, backreference, atomic group, named replace, regex flags.

매일 10개부터.

---

## 6. 자경단 매일 13줄 흐름

```python
import re

# 자경단 까미의 매일 텍스트 처리

# 1. 사용자 입력 정리
clean = user_input.strip().lower()

# 2. 이메일 검증
if not re.match(r'[\w.+-]+@\w+\.\w+', email):
    raise ValueError("이메일 형식")

# 3. 로그에서 ERROR 추출
errors = re.findall(r'\[ERROR\] (.+)', log)

# 4. URL 도메인
domain = re.sub(r'https?://([^/]+).*', r'\1', url)

# 5. 카멜케이스 변환
column_name = re.sub(r'(?<!^)(?=[A-Z])', '_', col).lower()

# 6. 비밀번호 마스킹
masked = re.sub(r'\d', '*', password)

# 7. 멀티라인 정리
clean_text = re.sub(r'\n{3,}', '\n\n', text)
```

13줄.

---

## 7. 다섯 함정과 처방

**함정 1: greedy 매칭**

```python
re.findall(r'<.+>', '<a><b><c>')   # ['<a><b><c>']
```

처방. lazy `<.+?>`.

**함정 2: 한글 \w 안 됨 (옛날)**

처방. Python 3는 자동.

**함정 3: 멀티라인 ^$**

처방. `re.MULTILINE`.

**함정 4: re.match vs search**

처방. 어디든 매치는 search.

**함정 5: 백슬래시 escape**

처방. raw string `r'\d+'`.

---

## 8. 흔한 오해 다섯 가지

**오해 1: 정규식 외워야.**

5 패턴이면 90%.

**오해 2: regex101 옵션.**

매일.

**오해 3: re.compile 항상.**

자주 쓰는 것만.

**오해 4: lookahead 시니어 도구.**

본인도 가끔.

**오해 5: f-string vs format.**

f-string 표준.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. 30 패턴 다 외움?**

매일 10개부터.

**Q2. 한글 매칭?**

`[가-힣]+`.

**Q3. greedy 항상 안 좋음?**

용도. lazy가 보통 안전.

**Q4. lookahead 어디?**

다음 글자 보면서 매치 안 함.

**Q5. regex 성능?**

컴파일 + 캐싱.

---

## 10. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, str 메서드 다 외움. 안심 — split·strip·replace 셋.
둘째, regex 메서드 헷갈림. 안심 — match·search·findall·sub 넷.
셋째, format 종류 다섯. 안심 — f-string만.
넷째, encode 메서드 무지. 안심 — `s.encode('utf-8')`.
다섯째, 가장 큰 — str slicing. 안심 — `s[start:stop]`.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 네 번째 시간 끝.

검증 10, 추출 10, 변환 10. 30 패턴.

다음 H5는 30분 데모 text_processor.

```python
python3 -c 'import re; print(re.sub(r"(\d{4})(\d{4})", r"\1-\2", "12345678"))'
```

---

## 👨‍💻 개발자 노트

> - lookahead `(?=)`, lookbehind `(?<=)`: 매치 위치 검사만.
> - atomic group `(?>)`: backtracking 방지.
> - named group `(?P<name>)`: Python 표준.
> - regex DOS 공격: catastrophic backtracking 주의.
> - 다음 H5 키워드: text_processor · 30 패턴 적용 · 클린업 파이프라인.
