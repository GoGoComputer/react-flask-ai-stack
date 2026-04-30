# Ch011 · H8 — 7H 회고 + text_processor + Ch012 다리

> 고양이 자경단 · Ch 011 · 8교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속
2. Ch011 7시간 회고
3. text_processor의 진화
4. str/regex 다섯 원리
5. 5년 자산
6. Ch012로 가는 다리
7. 마무리

---

## 1. 다시 만나서 반가워요

자, 안녕하세요. 본 챕터의 마지막.

지난 H7. PEP 393, interning, NFA, normalization.

오늘. 회고.

자, 가요.

---

## 2. Ch011 7시간 회고

**H1** — 텍스트가 코드 30%.

**H2** — 30 메서드 + regex 8 패턴.

**H3** — re, regex101, VS Code, rich, ipython.

**H4** — 30 패턴. 검증, 추출, 변환.

**H5** — text_processor 100줄.

**H6** — 운영. encoding, 성능, catastrophic, unicode.

**H7** — 내부. PEP 393, NFA.

**H8** — 회고.

7시간이 텍스트 토대.

---

## 3. text_processor의 진화

**1주차** — 100줄. clean, extract 3, mask 3.

**1개월** — 200줄. 더 많은 패턴.

**6개월** — 500줄. 도메인별 모듈.

**1년** — 자경단의 표준 텍스트 라이브러리.

---

## 4. str/regex 다섯 원리

**원리 1 — 항상 UTF-8 명시**.

**원리 2 — f-string 표준**.

**원리 3 — re.compile 자주 쓰는 패턴만**.

**원리 4 — catastrophic 패턴 의심**.

**원리 5 — 사용자 입력은 NFC normalize**.

다섯. 5년.

---

## 5. 5년 자산

**개념** — str 30 메서드, regex 8 패턴 + 그룹 + 5 함수, f-string.

**도구** — re, regex101, rich, ipython.

**원리** — 다섯.

**코드** — text_processor 100줄.

**자신감** — 어느 텍스트도 5분 처리.

5년.

---

## 6. Ch012로 가는 다리

다음 챕터 Ch012는 파일 I/O + 예외. 텍스트의 외부.

문자열을 파일로 저장. 파일에서 읽기. 사고 처리.

Ch011 텍스트 + Ch012 I/O = 본인 코드의 외부 세계.

---

## 7. 흔한 실수 다섯 + 안심 — 챕터 회고 편

첫째, str·regex 외움. 안심 — 30 메서드 + 8 패턴.
둘째, regex101 안 씀. 안심 — 매번 시각화.
셋째, encoding 자동. 안심 — UTF-8 명시.
넷째, 정규식 우선. 안심 — str 메서드 우선.
다섯째, 가장 큰 — 5년 자산 안 만듦. 안심 — text_processor 100줄 시작.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 8. 마무리

박수. 본인이 텍스트 8시간 끝까지.

본 챕터 끝. 다음 — Ch012 H1.

```python
import re
print(re.findall(r'\w+@\w+\.\w+', '자경단: bonin@cat.com'))
```

---

## 👨‍💻 개발자 노트

> - 텍스트 처리가 코드 30%.
> - 다음 챕터 Ch012: open, with, try/except, pathlib.
