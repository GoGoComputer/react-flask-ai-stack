# Ch015 · H3 — CLI 가계부 5 도구 환경 — typer·rich·sqlite3·plotext·dateutil

> 고양이 자경단 · Ch 015 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 첫째 — typer 셋업
3. 둘째 — rich 깊이
4. 셋째 — sqlite3 기본
5. 넷째 — plotext 터미널 차트
6. 다섯째 — dateutil 날짜 처리
7. 자경단 매일 의식
8. 다섯 시나리오
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요.

지난 H2 회수. argparse, click, typer, rich.

이번 H3는 5 도구 환경.

오늘의 약속. **본인의 노트북에 가계부 환경이 갖춰집니다**.

자, 가요.

---

## 2. 첫째 — typer 셋업

```bash
pip install typer
```

빠른 테스트.

```python
# test_typer.py
import typer

app = typer.Typer()

@app.command()
def hello(name: str = "자경단"):
    typer.echo(f"안녕 {name}")

if __name__ == "__main__":
    app()
```

```bash
$ python3 test_typer.py --name 까미
안녕 까미

$ python3 test_typer.py --help
# 자동 도움말
```

자동 도움말 + type 검증. typer의 매력.

---

## 3. 둘째 — rich 깊이

```bash
pip install rich
```

H2에서 봤어요. 추가 기능.

```python
from rich.live import Live
from rich.table import Table
import time

with Live(refresh_per_second=4) as live:
    for i in range(10):
        table = Table()
        table.add_column("Step")
        table.add_row(str(i))
        live.update(table)
        time.sleep(0.5)
```

실시간 업데이트 테이블. 자경단 가끔.

---

## 4. 셋째 — sqlite3 기본

stdlib. 추가 설치 없음.

```python
import sqlite3

conn = sqlite3.connect("budget.db")
cur = conn.cursor()

# 테이블 생성
cur.execute("""
CREATE TABLE IF NOT EXISTS entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL,
    category TEXT NOT NULL,
    amount INTEGER NOT NULL,
    note TEXT
)
""")

# 추가
cur.execute(
    "INSERT INTO entries (date, category, amount, note) VALUES (?, ?, ?, ?)",
    ("2026-04-30", "food", 5000, "점심"),
)
conn.commit()

# 조회
cur.execute("SELECT * FROM entries")
for row in cur.fetchall():
    print(row)

conn.close()
```

5단계 — connect, table, insert, select, close. 자경단 매일.

---

## 5. 넷째 — plotext 터미널 차트

```bash
pip install plotext
```

```python
import plotext as plt

categories = ["food", "tax", "fun"]
amounts = [8000, 8000, 5000]

plt.bar(categories, amounts)
plt.title("월간 지출")
plt.show()
```

진짜 출력.

```
   8000  ████████
   6000  ████████  ████
   4000  ████████  ████  █████
   2000  ████████  ████  █████
         food      tax   fun
```

터미널 안 차트. 자경단의 시각화.

---

## 6. 다섯째 — dateutil 날짜 처리

```bash
pip install python-dateutil
```

```python
from dateutil import parser
from dateutil.relativedelta import relativedelta
from datetime import date

# 다양한 형태 파싱
d = parser.parse("2026-04-30")
d = parser.parse("April 30, 2026")
d = parser.parse("30/4/2026")

# 한 달 후
next_month = date.today() + relativedelta(months=1)

# 첫 날, 마지막 날
first = date.today().replace(day=1)
last = (first + relativedelta(months=1)) - relativedelta(days=1)
```

자경단 매일 — 월간 보고.

---

## 7. 자경단 매일 의식

**1. 새 entry** → typer add

**2. 조회** → typer list + rich Table

**3. 시각화** → plotext chart

**4. 저장** → sqlite3

**5. 백업** → cron + S3

다섯.

---

## 8. 다섯 시나리오

**시나리오 1: 첫 entry 추가**

처방. typer add → sqlite INSERT.

**시나리오 2: 월간 통계**

처방. SELECT + GROUP BY + plotext.

**시나리오 3: 데이터 손실**

처방. 자동 백업 (.db → .db.YYYY-MM-DD).

**시나리오 4: 카테고리 추가**

처방. table 안에 category 컬럼.

**시나리오 5: 멀티 사용자**

처방. user 컬럼 추가.

---

## 9. 흔한 오해 다섯 가지

**오해 1: typer 옵션.**

자경단 표준.

**오해 2: rich 무거움.**

가벼움.

**오해 3: SQLite 한계.**

100MB 충분.

**오해 4: plotext production.**

dev에서 매일.

**오해 5: dateutil 옵션.**

자경단 매일.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. typer global install?**

pipx install typer.

**Q2. SQLite vs JSON?**

쿼리 필요하면 SQLite.

**Q3. plotext 컬러?**

지원.

**Q4. dateutil vs datetime?**

dateutil이 더 강력.

**Q5. 5 도구 다 깔아야?**

typer + rich + sqlite3 (stdlib)이 핵심.

---

## 11. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, typer 옵션 가정. 안심 — 자경단 표준.
둘째, SQLite 한계. 안심 — 100MB 충분.
셋째, plotext dev만. 안심 — 가계부 매일.
넷째, dateutil 시니어. 안심 — 매일 월간 보고.
다섯째, 가장 큰 — 5 도구 부담. 안심 — typer + rich + sqlite3가 핵심.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 세 번째 시간 끝.

typer, rich, sqlite3, plotext, dateutil. 5 도구.

다음 H4는 30+ 명령.

```bash
pip install typer rich plotext python-dateutil
```

---

## 👨‍💻 개발자 노트

> - typer auto-completion: bash, zsh, fish 지원.
> - rich live: refresh_per_second.
> - sqlite3 thread-safety: 단일 thread 권장.
> - plotext: ASCII art 차트.
> - dateutil parser: 100+ 형태 자동 인식.
> - 다음 H4 키워드: 6 그룹 명령 · add · list · summary · chart · import · export.
