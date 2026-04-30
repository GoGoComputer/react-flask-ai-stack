# Ch015 · H5 — vigilante-budget 100줄 — 6 단계 라이브 코딩

> 고양이 자경단 · Ch 015 · 5교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 시나리오
3. 0~5분 — 셋업
4. 5~10분 — DB 초기화
5. 10~15분 — add 명령
6. 15~20분 — list 명령
7. 20~25분 — summary와 chart
8. 25~30분 — 실행과 검증
9. 다섯 사고와 처방
10. 흔한 오해 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요.

지난 H4 회수. 30+ 명령 6 그룹.

이번 H5는 30분 라이브 코딩.

오늘의 약속. **본인의 첫 가계부 100줄이 동작합니다**.

자, 가요.

---

## 2. 시나리오

본인이 30분에 100줄로 가계부 만들기. add, list, summary, chart 4 명령.

---

## 3. 0~5분 — 셋업

```bash
mkdir -p /tmp/budget && cd /tmp/budget
python3 -m venv .venv
source .venv/bin/activate
pip install typer rich plotext
touch budget.py
```

---

## 4. 5~10분 — DB 초기화

```python
"""budget.py — 자경단 가계부"""

import sqlite3
from datetime import date
from pathlib import Path

import typer
from rich import print
from rich.console import Console
from rich.table import Table

app = typer.Typer(help="자경단 가계부")
console = Console()

DB_PATH = Path.home() / ".vigilante-budget.db"


def get_db():
    """DB 연결."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("""
        CREATE TABLE IF NOT EXISTS entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            category TEXT NOT NULL,
            amount INTEGER NOT NULL,
            note TEXT
        )
    """)
    conn.commit()
    return conn
```

DB 자동 생성. 자경단 표준.

---

## 5. 10~15분 — add 명령

```python
@app.command()
def add(
    amount: int = typer.Argument(..., help="금액"),
    category: str = typer.Argument(..., help="카테고리"),
    note: str = typer.Option("", help="메모"),
    when: str = typer.Option(None, help="날짜 YYYY-MM-DD"),
):
    """가계부 추가."""
    today = when or date.today().isoformat()
    
    conn = get_db()
    conn.execute(
        "INSERT INTO entries (date, category, amount, note) VALUES (?, ?, ?, ?)",
        (today, category, amount, note),
    )
    conn.commit()
    conn.close()
    
    print(f"[green]✅ 추가: {amount} {category} ({today})[/green]")
```

decorator + type hints. typer가 자동 처리.

---

## 6. 15~20분 — list 명령

```python
@app.command()
def list(
    month: str = typer.Option(None, help="YYYY-MM"),
    category: str = typer.Option(None, help="카테고리"),
):
    """가계부 목록."""
    conn = get_db()
    
    sql = "SELECT * FROM entries WHERE 1=1"
    params = []
    
    if month:
        sql += " AND date LIKE ?"
        params.append(f"{month}%")
    if category:
        sql += " AND category = ?"
        params.append(category)
    
    sql += " ORDER BY date DESC"
    rows = conn.execute(sql, params).fetchall()
    conn.close()
    
    table = Table(title=f"가계부 ({len(rows)}건)")
    table.add_column("ID", justify="right")
    table.add_column("날짜")
    table.add_column("카테고리")
    table.add_column("금액", justify="right")
    table.add_column("메모")
    
    for r in rows:
        table.add_row(
            str(r["id"]),
            r["date"],
            r["category"],
            f"{r['amount']:,}",
            r["note"] or "",
        )
    
    console.print(table)
```

조건부 쿼리 + rich Table. 자경단 매일.

---

## 7. 20~25분 — summary와 chart

```python
@app.command()
def summary(month: str = typer.Option(None)):
    """카테고리별 합계."""
    conn = get_db()
    sql = "SELECT category, SUM(amount) as total FROM entries"
    params = []
    if month:
        sql += " WHERE date LIKE ?"
        params.append(f"{month}%")
    sql += " GROUP BY category ORDER BY total DESC"
    
    rows = conn.execute(sql, params).fetchall()
    conn.close()
    
    table = Table(title="카테고리 합계")
    table.add_column("카테고리")
    table.add_column("금액", justify="right")
    
    for r in rows:
        table.add_row(r["category"], f"{r['total']:,}")
    
    console.print(table)


@app.command()
def chart(month: str = typer.Option(None)):
    """카테고리 차트."""
    import plotext as plt
    
    conn = get_db()
    sql = "SELECT category, SUM(amount) as total FROM entries"
    params = []
    if month:
        sql += " WHERE date LIKE ?"
        params.append(f"{month}%")
    sql += " GROUP BY category"
    
    rows = conn.execute(sql, params).fetchall()
    conn.close()
    
    categories = [r["category"] for r in rows]
    amounts = [r["total"] for r in rows]
    
    plt.bar(categories, amounts)
    plt.title(f"가계부 차트 {month or '전체'}")
    plt.show()


if __name__ == "__main__":
    app()
```

GROUP BY + plotext 차트.

---

## 8. 25~30분 — 실행과 검증

```bash
$ python3 budget.py add 5000 food --note "점심"
✅ 추가: 5000 food (2026-04-30)

$ python3 budget.py add 3000 transport
✅ 추가: 3000 transport (2026-04-30)

$ python3 budget.py list
                     가계부 (2건)                      
┏━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━┳━━━━━━━┳━━━━━━━┓
┃ ID ┃ 날짜        ┃ 카테고리   ┃ 금액   ┃ 메모   ┃
┡━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━━╇━━━━━━━╇━━━━━━━┩
│ 1  │ 2026-04-30 │ food       │ 5,000 │ 점심   │
│ 2  │ 2026-04-30 │ transport  │ 3,000 │       │
└────┴────────────┴───────────┴───────┴───────┘

$ python3 budget.py summary
$ python3 budget.py chart
```

100줄 미만의 가계부 동작. 자경단 표준.

---

## 9. 다섯 사고와 처방

**사고 1: DB 권한**

처방. ~/.vigilante-budget.db. 사용자 폴더.

**사고 2: SQL injection**

처방. ? 매개변수.

**사고 3: 날짜 형식**

처방. dateutil parser.

**사고 4: 카테고리 오타**

처방. enum 또는 검증.

**사고 5: 데이터 손실**

처방. 매주 backup.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 100줄 부족.**

핵심 4 명령으로 충분.

**오해 2: ORM 필요.**

작은 프로젝트는 raw SQL.

**오해 3: 한 파일 충분.**

200줄 넘으면 분리.

**오해 4: typer 옵션 어렵.**

decorator 학습.

**오해 5: chart 의미 없음.**

매월 한 번 시각화.

---

## 11. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, 100줄 부족. 안심 — 4 명령 충분.
둘째, ORM 필요. 안심 — raw SQL OK.
셋째, 한 파일 매일. 안심 — 200줄 넘으면 분리.
넷째, typer Argument vs Option 헷갈림. 안심 — 위치 vs 키워드.
다섯째, 가장 큰 — DB 손실 두려움. 안심 — 매주 backup.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 다섯 번째 시간 끝.

vigilante-budget 100줄. add, list, summary, chart.

다음 H6은 운영. 백업, sync, 복구.

```bash
python3 budget.py --help
```

---

## 👨‍💻 개발자 노트

> - sqlite3.Row: dict-like access.
> - typer.Argument vs Option: 위치 vs 키워드.
> - GROUP BY + SUM: 집계.
> - plotext.bar: 단순 시각화.
> - DB 마이그레이션: alembic 또는 수동.
> - 다음 H6 키워드: 백업 · sync · 복구 · 검증 · 자동화.
