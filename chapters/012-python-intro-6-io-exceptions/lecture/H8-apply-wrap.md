# Ch012 · H8 — 7H 회고 + file_processor + Ch013 다리

> 고양이 자경단 · Ch 012 · 8교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수
2. Ch012 7시간 회고
3. file_processor 진화
4. I/O 다섯 원리
5. 5년 자산
6. Ch013 다리
7. 마무리

---

## 1. 다시 만나서 반가워요

자, 안녕하세요. 본 챕터의 마지막.

지난 H7. fd, context manager, buffered.

오늘. 회고.

자, 가요.

---

## 2. Ch012 7시간 회고

**H1** — I/O = 외부 세계.

**H2** — 8개념. open mode, with, try/except, pathlib.

**H3** — pathlib, io, logging, rich, traceback.

**H4** — 30 exception + 20 file 패턴.

**H5** — file_processor 100줄.

**H6** — chunking, 성능, async.

**H7** — fd, context manager, buffered 내부.

**H8** — 회고.

7시간이 I/O 토대.

---

## 3. file_processor 진화

**v1 (Ch012)** — 100줄. CSV → JSON 변환기.

**v2 (Ch013)** — 200줄. 모듈화.

**v3 (1년 후)** — 500줄. 스트리밍 처리.

**v4 (3년 후)** — 자경단 ETL 도구.

---

## 4. I/O 다섯 원리

**원리 1 — 항상 with**.

**원리 2 — encoding 항상 명시**.

**원리 3 — atomic write (tmp + rename)**.

**원리 4 — exception 구체적 catch**.

**원리 5 — 큰 파일은 chunking 또는 generator**.

다섯. 5년.

---

## 5. 5년 자산

**개념** — open mode 7, with, try/except/else/finally, exception 계층, custom, pathlib.

**도구** — pathlib, io, logging, rich, traceback, json, csv.

**원리** — 다섯.

**코드** — file_processor 100줄.

**자신감** — 1GB 파일도 안전 처리.

5년.

---

## 6. Ch013 다리

다음 챕터 Ch013은 모듈/패키지. I/O의 단위.

본인의 파일 처리 함수를 어디에 둘까. 모듈에. 그 모듈을 어디에. 패키지에.

Ch012 I/O + Ch013 모듈 = 본인 코드의 구조.

---

## 7. 흔한 실수 다섯 + 안심 — 챕터 회고 편

첫째, with 잊음. 안심 — 자경단 표준 항상.
둘째, encoding 자동 가정. 안심 — utf-8 명시.
셋째, atomic write 시니어. 안심 — tmp + rename.
넷째, except 너무 넓게. 안심 — 구체적 → 일반.
다섯째, 가장 큰 — production 사고 두려움. 안심 — 다섯 원리로 80% 안전.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 8. 마무리

박수. 본인이 I/O 8시간 끝까지.

본 챕터 끝. 다음 — Ch013 H1.

```python
from pathlib import Path
print(list(Path('.').glob('*.md'))[:3])
```

---

## 👨‍💻 개발자 노트

> - I/O가 production 사고 80%.
> - 다음 챕터 Ch013: import, from, __init__.py.
