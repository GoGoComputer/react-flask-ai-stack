# Ch011 · H3 — str/regex 5 도구 — re·regex101·VS Code·rich

> 고양이 자경단 · Ch 011 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 첫째 — re 모듈 표준
3. 둘째 — regex101 웹 도구
4. 셋째 — VS Code regex 검색
5. 넷째 — rich.console 텍스트 출력
6. 다섯째 — ipython 텍스트 실험
7. 자경단 매일 텍스트 의식
8. 다섯 시나리오와 처방
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요.

지난 H2 회수. str 30 메서드, regex 8 패턴, f-string.

이번 H3는 텍스트 도구.

오늘의 약속. **본인이 정규식을 시각적으로 만지고 검증할 수 있습니다**.

자, 가요.

---

## 2. 첫째 — re 모듈 표준

re는 Python 표준 라이브러리. 추가 설치 없음.

```python
import re

# 기본
re.search(pattern, text)
re.findall(pattern, text)
re.sub(pattern, repl, text)

# 컴파일 (재사용)
phone_re = re.compile(r'\d{3}-\d{4}-\d{4}')
phone_re.search(text1)
phone_re.search(text2)

# 옵션 플래그
re.search(r'hello', text, re.IGNORECASE)
re.search(r'.+', text, re.DOTALL)         # . 줄바꿈 포함
re.search(r'^abc', text, re.MULTILINE)    # ^ 매줄 시작
```

자경단 매일.

---

## 3. 둘째 — regex101 웹 도구

regex101.com은 정규식 시각 디버거. 본인의 패턴을 입력하면 매칭이 색깔로 표시. 그룹 캡처도 보여줌.

사용법.

1. 브라우저로 regex101.com 접속.
2. Flavor에서 Python 선택.
3. 좌상에 패턴 입력. `\d+`.
4. 좌하에 텍스트 입력. "cat-3 dog-2".
5. 매칭이 우상에 표시.

regex101이 본인의 정규식 코드 짜는 시간을 5배 줄여 줘요. 자경단 매일 사용.

---

## 4. 셋째 — VS Code regex 검색

VS Code의 검색 (Cmd+Shift+F)에서 정규식 모드 켜기. `.*` 아이콘.

```
\w+@\w+\.\w+    # 이메일 패턴 검색
TODO|FIXME|XXX  # 마커 검색
^def \w+        # 함수 정의 검색
```

코드베이스 전체에서 패턴 검색. 자경단 매일.

---

## 5. 넷째 — rich.console 텍스트 출력

```python
from rich.console import Console
from rich.markdown import Markdown
from rich.syntax import Syntax

console = Console()
console.print("[bold red]ERROR[/bold red] 메시지")
console.print(Markdown("# Header\n- item 1"))
console.print(Syntax("def f(): pass", "python"))
```

색깔, markdown, 코드 syntax highlight. 자경단 매일.

---

## 6. 다섯째 — ipython 텍스트 실험

```python
ipython
In [1]: import re
In [2]: text = "cat-3 dog-2 bird-5"
In [3]: re.findall(r'\d+', text)
Out[3]: ['3', '2', '5']

In [4]: re.findall(r'(\w+)-(\d+)', text)
Out[4]: [('cat', '3'), ('dog', '2'), ('bird', '5')]
```

ipython은 정규식 즉시 실험. 자경단 매일.

---

## 7. 자경단 매일 텍스트 의식

**1. 작은 패턴** → ipython REPL

**2. 복잡한 패턴** → regex101 시각화

**3. 코드베이스 검색** → VS Code regex

**4. 출력 색깔** → rich

**5. 성능 의심** → re.compile + timeit

다섯.

---

## 8. 다섯 시나리오와 처방

**시나리오 1: 정규식 매칭 안 됨**

처방. regex101에서 시각화.

**시나리오 2: 한글 안 매치**

처방. `[가-힣]` 사용.

**시나리오 3: greedy 너무 많이 매치**

처방. `*?` lazy.

**시나리오 4: 정규식 느림**

처방. re.compile + 캐싱.

**시나리오 5: 멀티라인 매칭 안 됨**

처방. re.MULTILINE.

---

## 9. 흔한 오해 다섯 가지

**오해 1: regex101이 옵션.**

매일 도구.

**오해 2: VS Code regex 어렵다.**

5 패턴이면 90%.

**오해 3: rich는 무거움.**

가벼움.

**오해 4: ipython은 데이터 도구.**

텍스트 실험에 강력.

**오해 5: re.compile 매번.**

자주 쓰는 패턴만.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. regex101 vs Python re?**

regex101 시각화, re 실행.

**Q2. VS Code 정규식 강력?**

표준. 매일 사용.

**Q3. rich vs print?**

rich 색깔.

**Q4. 한글 정규식?**

[가-힣]. 자모는 [ㄱ-ㅣ].

**Q5. unicode flag 매번?**

Python 3 기본.

---

## 11. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, regex tester 안 씀. 안심 — regex101 매번.
둘째, encoding 안 명시. 안심 — `encoding='utf-8'`.
셋째, locale dependent. 안심 — UTF-8 강제.
넷째, multiline flag 무지. 안심 — `re.MULTILINE`.
다섯째, 가장 큰 — IDE 정규식 시각화 안 씀. 안심 — VS Code regex preview.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 세 번째 시간 끝.

re, regex101, VS Code, rich, ipython 5 도구.

다음 H4는 30+ 패턴.

```python
ipython
import re
re.findall(r'\d+', 'cat-3 dog-2')
```

---

## 👨‍💻 개발자 노트

> - re._cache: 컴파일된 패턴 자동 캐싱 (512개).
> - regex101 cheatsheet: 우측에 표준 패턴.
> - VS Code regex: PCRE 호환.
> - rich Console.print: 자동 wrap, color.
> - 다음 H4 키워드: 이메일 · 전화 · URL · IP · UUID · ISO date · 30 패턴.
