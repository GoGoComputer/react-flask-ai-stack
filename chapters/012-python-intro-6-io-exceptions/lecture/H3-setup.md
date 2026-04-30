# Ch012 · H3 — pathlib·io·logging·rich.traceback 5 도구

> 고양이 자경단 · Ch 012 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 첫째 — pathlib 깊이
3. 둘째 — io 모듈
4. 셋째 — logging 표준
5. 넷째 — rich.traceback
6. 다섯째 — sys.exc_info와 traceback
7. 자경단 매일 의식
8. 다섯 시나리오
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요.

지난 H2 회수. open mode, try/except/else/finally, 예외 계층, custom, pathlib.

이번 H3는 5 도구.

오늘의 약속. **본인이 logging과 rich.traceback으로 production 사고를 5초에 진단합니다**.

자, 가요.

---

## 2. 첫째 — pathlib 깊이

H2에서 봤어요. 자경단 매일 메서드 10.

```python
from pathlib import Path

# 경로 만들기
p = Path("data") / "cats" / "k.txt"   # 슬래시 OS 무관

# 검사
p.exists()
p.is_file()
p.is_dir()
p.is_symlink()

# 디렉토리 순회
for f in Path(".").iterdir():
    print(f)

# 재귀 검색
for f in Path(".").rglob("*.py"):
    print(f)

# 글로브
list(Path(".").glob("*.txt"))
```

자경단 매일.

---

## 3. 둘째 — io 모듈

`io`는 파일 같은 객체 (file-like).

```python
from io import StringIO, BytesIO

# 메모리 안 텍스트 파일
buf = StringIO()
buf.write("안녕")
buf.seek(0)
print(buf.read())

# binary
b = BytesIO(b"raw bytes")
b.read()
```

자경단 — 테스트 시, 메모리 처리 시.

```python
# 함수에 file-like 전달
def process(f):
    return f.read()

# 진짜 파일도 OK
with open("file.txt") as f:
    process(f)

# StringIO도 OK
process(StringIO("test data"))
```

duck typing이 자경단 표준.

---

## 4. 셋째 — logging 표준

print 대신 logging.

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
)

log = logging.getLogger(__name__)

log.debug("디테일")
log.info("정상 흐름")
log.warning("주의")
log.error("에러")
log.critical("심각")
```

5 레벨. 자경단 표준 — DEBUG는 dev, INFO 이상이 production.

```python
try:
    risky_operation()
except Exception:
    log.exception("실패")   # traceback 자동 포함
```

`log.exception`이 traceback 자동 첨부.

---

## 5. 넷째 — rich.traceback

```python
from rich.traceback import install
install(show_locals=True)
```

이 두 줄만 있으면 모든 traceback이 예쁘게. 줄 번호, 변수 값, 코드 컨텍스트 다 표시.

```python
def divide(a, b):
    return a / b

divide(10, 0)
# rich이 예쁜 traceback + 변수 값 표시
```

자경단 dev 표준. production은 logging.

---

## 6. 다섯째 — sys.exc_info와 traceback

```python
import sys
import traceback

try:
    risky()
except Exception:
    exc_type, exc_value, exc_tb = sys.exc_info()
    traceback.print_exc()           # 표준 출력
    tb_str = traceback.format_exc()  # 문자열로
```

자경단 — 에러 로그에 traceback 저장 시.

---

## 7. 자경단 매일 의식

**1. 작은 사고** → print + breakpoint

**2. 중간 사고** → logging.exception

**3. 큰 사고 (production)** → log.error + Sentry

**4. 새 사고 종류** → custom exception

**5. 디버깅** → rich.traceback + show_locals

---

## 8. 다섯 시나리오

**시나리오 1: 파일 없음**

처방. FileNotFoundError + default.

**시나리오 2: 권한 없음**

처방. PermissionError + 사용자 메시지.

**시나리오 3: 디스크 가득**

처방. OSError + cleanup.

**시나리오 4: encoding 에러**

처방. UnicodeDecodeError + utf-8 명시.

**시나리오 5: 동시 접근**

처방. file lock 또는 atomic write.

---

## 9. 흔한 오해 다섯 가지

**오해 1: print 대신 logging 항상.**

dev는 print OK.

**오해 2: rich production.**

dev만.

**오해 3: pathlib 옵션.**

자경단 표준.

**오해 4: io 자주 안 씀.**

테스트에서 매일.

**오해 5: traceback 자동.**

명시 필요.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. logging 레벨 어떻게?**

INFO 기본. DEBUG dev.

**Q2. logger.error vs exception?**

exception이 traceback 포함.

**Q3. rich production 안전?**

ANSI escape가 환경에 영향.

**Q4. logging vs print?**

production은 logging.

**Q5. custom logger?**

`logging.getLogger("myapp")`.

---

## 11. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, print만 매일. 안심 — production은 logging.
둘째, traceback 무시. 안심 — log.exception.
셋째, rich production. 안심 — dev만.
넷째, io.StringIO 시니어. 안심 — 테스트에 매일.
다섯째, 가장 큰 — pathlib 안 씀. 안심 — Path() 표준.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 세 번째 시간 끝.

pathlib, io, logging, rich.traceback, traceback 5 도구.

다음 H4는 30+ exception + 20+ file 패턴.

```python
python3 -c "import logging; logging.basicConfig(level=logging.INFO); logging.info('hi')"
```

---

## 👨‍💻 개발자 노트

> - logging 핸들러: console, file, syslog, http.
> - logging filter: 메시지 선별.
> - rich.traceback show_locals: 변수 값 표시.
> - pathlib WindowsPath vs PosixPath: 자동 선택.
> - io.RawIOBase: 모든 file-like의 베이스.
> - 다음 H4 키워드: 30 exception · 20 file 패턴 · context manager.
