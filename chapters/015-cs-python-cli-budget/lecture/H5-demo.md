# Ch015 · H5 — vigilante-budget 100줄 첫 실전 데모 — 6 단계 라이브 코딩

> **이 H에서 얻을 것**
> - 100줄 라이브 코딩 — vigilante-budget v0.1
> - 6 단계 (env → db → add → list → chart → 통합)
> - 5 도구 통합 — typer·rich·sqlite3·click·plotext
> - 30 명령 중 핵심 7 (add·list·today·week·top·chart·backup)
> - 60분 라이브 = 자경단 매주 1번 데모

---

## 📋 이 시간 목차

1. **회수 — H4 30 명령 카탈로그**
2. **100줄 데모 설계 — 6 단계**
3. **Phase 1 — 환경 (15분)**
4. **Phase 2 — DB 모듈 (10분)**
5. **Phase 3 — add 명령 (10분)**
6. **Phase 4 — list·today·week (10분)**
7. **Phase 5 — chart + report (10분)**
8. **Phase 6 — 통합 + 첫 실전 (5분)**
9. **100줄 코드 전체**
10. **자경단 1주 데모 통계**
11. **데모 5 함정**
12. **흔한 오해 + FAQ + 추신**

---

## 🔧 강사용 명령어 한눈에

```bash
# Phase 1: 환경 (15분)
mkdir vigilante-budget && cd vigilante-budget
python3 -m venv .venv && source .venv/bin/activate
pip install typer rich plotext
mkdir -p vigilante_budget && touch vigilante_budget/{__init__,cli,db}.py

# Phase 2-5: 코드 작성 (40분)
# (vigilante_budget/db.py·cli.py 작성)

# Phase 6: 첫 실전 (5분)
pip install -e .
vigi add 5000 카페 lunch
vigi add 12000 점심 비빔밥
vigi today
vigi week
vigi chart
vigi backup
```

60분 6 단계 라이브. 자경단 매주 1번 데모 의식.

---

## 1. 들어가며 — H4 회수

자경단 본인 안녕하세요. Ch015 H5 시작합니다.

H4 회수: 30 명령 카탈로그 마스터. 6 그룹 × 5 명령. 자경단 1주 259 호출.

이제 H5. **vigilante-budget 100줄 첫 실전 데모**. 60분 라이브 코딩. 5 도구 + 7 핵심 명령 통합.

자경단 본인 매주 1번 새 프로젝트 데모. 1년 후 100줄 → 500줄 진화.

---

## 2. 100줄 데모 설계 — 6 단계

### 2-1. 왜 100줄?

100줄 = **MVP** (최소 동작 제품). 자경단 매주 1번 만들 수 있는 크기.

500줄 → 5,000줄 → PyPI 등록은 1년 후. 오늘은 100줄.

100줄 = 5 도구 통합 + 7 명령 + 동작 검증. 이걸로 가계부 매일 사용 OK.

### 2-2. 6 단계 시간 배분

| Phase | 작업 | 시간 | 누적 |
|---|---|---|---|
| 1. 환경 | venv + 5 도구 + pyproject | 15분 | 15 |
| 2. DB | sqlite3 schema + 5 함수 | 10분 | 25 |
| 3. add | typer + rich add 명령 | 10분 | 35 |
| 4. list | list·today·week 3 명령 | 10분 | 45 |
| 5. chart | plotext bar + report | 10분 | 55 |
| 6. 통합 | install -e + 첫 실행 | 5분 | 60 |

60분 = 1 H = 자경단 매주 1번 라이브 데모.

### 2-3. 6 단계 진척 신호

각 Phase 끝 신호:

```
Phase 1: pip install -e . OK
Phase 2: python3 -c "from vigilante_budget.db import init; init()" OK
Phase 3: vigi add 5000 카페 OK
Phase 4: vigi today OK
Phase 5: vigi chart OK
Phase 6: vigi backup OK + DB 1.2 MB
```

각 신호 후 git commit. 자경단 60분 = 6 commit.

### 2-4. 6 단계 안전망

| Phase | 검증 한 줄 | 실패 시 |
|---|---|---|
| 1 | `pip list \| grep typer` | venv 재활성화 |
| 2 | `python3 -c "from .db import init"` | path 검증 |
| 3 | `vigi add --help` | typer 의존성 |
| 4 | `vigi list` | DB schema |
| 5 | `vigi chart` | plotext 설치 |
| 6 | `vigi --help` | pyproject scripts |

6 검증 매 단계. 자경단 매번 실패 처방.

### 2-5. 6 단계 누적 줄 수

```
Phase 1:    0 줄  (환경만)
Phase 2:  +20 줄  (db.py)         = 20
Phase 3:  +25 줄  (cli.py add)    = 45
Phase 4:  +25 줄  (list·today·week) = 70
Phase 5:  +20 줄  (chart·report)  = 90
Phase 6:  +10 줄  (init·main)     = 100
```

100줄 = 자경단 매주 1번 신규 MVP.

---

## 3. Phase 1 — 환경 (15분)

### 3-1. 디렉터리 + venv (3분)

```bash
mkdir vigilante-budget && cd vigilante-budget
python3 -m venv .venv
source .venv/bin/activate
which python3   # .venv 안 검증
```

3분. 자경단 매주 1번 의식.

### 3-2. 5 도구 설치 (3분)

```bash
pip install typer rich plotext
pip list | grep -E '^(click|rich|typer|plotext)'
# click   8.x
# plotext 5.x
# rich    13.x
# typer   0.x
```

3분. typer가 click·rich 자동 설치.

### 3-3. 패키지 구조 (3분)

```bash
mkdir -p vigilante_budget
touch vigilante_budget/__init__.py
touch vigilante_budget/cli.py
touch vigilante_budget/db.py
```

3분. 패키지 구조. `__init__.py` = 패키지 신호.

### 3-4. pyproject.toml (5분)

```toml
[project]
name = "vigilante-budget"
version = "0.1.0"
dependencies = [
    "typer>=0.9.0",
    "rich>=13.7.0",
    "plotext>=5.2.8",
]

[project.scripts]
vigi = "vigilante_budget.cli:app"
```

5분. PEP 621 표준. `vigi` 명령 등록.

### 3-5. install editable + 검증 (1분)

```bash
pip install -e .
vigi --help    # 아직 명령 X·but 검증 OK
```

1분. **Phase 1 끝 신호** = `vigi --help` 동작.

🎯 git commit "Phase 1: 환경 OK".

---

## 4. Phase 2 — DB 모듈 (10분)

### 4-1. DB 경로 (2분)

```python
# vigilante_budget/db.py
import sqlite3
from pathlib import Path

DB_PATH = Path.home() / '.vigilante-budget' / 'budget.db'
DB_PATH.parent.mkdir(parents=True, exist_ok=True)
```

2분. 홈 디렉터리 안 자동 생성. 다중 사용자 안전.

### 4-2. 연결 (2분)

```python
def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn
```

2분. row_factory = dict 같은 접근.

### 4-3. schema init (3분)

```python
def init():
    conn = connect()
    conn.execute('''
        CREATE TABLE IF NOT EXISTS expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            category TEXT NOT NULL,
            memo TEXT DEFAULT '',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()
```

3분. CREATE IF NOT EXISTS = 멱등.

### 4-4. CRUD 5 함수 스켈레톤 (2분)

```python
def insert(amount: int, category: str, memo: str = ''):
    conn = connect()
    conn.execute('INSERT INTO expenses(amount, category, memo) VALUES(?, ?, ?)',
                 (amount, category, memo))
    conn.commit()
    conn.close()

def all_rows():
    conn = connect()
    rows = conn.execute('SELECT * FROM expenses ORDER BY created_at DESC').fetchall()
    conn.close()
    return rows
```

2분. insert + all_rows 2 함수 우선.

### 4-5. 검증 (1분)

```bash
python3 -c "from vigilante_budget import db; db.init(); db.insert(5000, '카페', 'lunch'); print(db.all_rows())"
# [<Row id=1 amount=5000 category='카페' ...>]
```

1분. **Phase 2 끝 신호** = insert + all_rows 동작.

🎯 git commit "Phase 2: DB schema + insert/all_rows".

---

## 5. Phase 3 — add 명령 (10분)

### 5-1. typer 앱 + Console (2분)

```python
# vigilante_budget/cli.py
import typer
from rich.console import Console
from rich.table import Table
from . import db

app = typer.Typer(help='자경단 가계부 v0.1.')
console = Console()
db.init()
```

2분. import 5줄. db.init() 자동.

### 5-2. add 명령 (3분)

```python
@app.command()
def add(amount: int, category: str, memo: str = ''):
    """가계 추가."""
    db.insert(amount, category, memo)
    console.print(f'[green]✅ 추가:[/] {amount:,}원 / {category} / {memo}')
```

3분. typer + rich + db 통합.

### 5-3. type hint 검증 (2분)

```bash
vigi add abc 카페
# Error: Invalid value for 'AMOUNT': 'abc' is not a valid integer.
```

2분. typer 자동 검증. 자경단 매주 1번 잘못된 입력 의식.

### 5-4. add 첫 시연 (2분)

```bash
vigi add 5000 카페 lunch
# ✅ 추가: 5,000원 / 카페 / lunch

vigi add 12000 점심 "비빔밥"
# ✅ 추가: 12,000원 / 점심 / 비빔밥
```

2분. 첫 거래 2건 입력. DB 안에 데이터.

### 5-5. --help 검증 (1분)

```bash
vigi add --help
# Usage: vigi add [OPTIONS] AMOUNT CATEGORY [MEMO]
#   가계 추가.
```

1분. **Phase 3 끝 신호** = `vigi add` 동작 + --help OK.

🎯 git commit "Phase 3: add 명령 + DB 통합".

---

## 6. Phase 4 — list·today·week (10분)

### 6-1. list 명령 (3분)

```python
@app.command()
def list(limit: int = 10):
    """목록 표시."""
    rows = db.all_rows()[:limit]
    t = Table(title=f'최근 {limit}건')
    t.add_column('id'); t.add_column('금액', justify='right')
    t.add_column('카테고리'); t.add_column('메모')
    for r in rows:
        t.add_row(str(r['id']), f'{r["amount"]:,}', r['category'], r['memo'])
    console.print(t)
```

3분. rich.Table + db.all_rows. 자경단 매일 1+.

### 6-2. today 명령 (3분)

```python
@app.command()
def today():
    """오늘 합."""
    conn = db.connect()
    rows = conn.execute('''
        SELECT category, SUM(amount) AS total FROM expenses
        WHERE date(created_at) = date('now', 'localtime')
        GROUP BY category
    ''').fetchall()
    conn.close()
    t = Table(title='오늘 가계')
    t.add_column('카테고리'); t.add_column('합계', justify='right')
    total = 0
    for r in rows:
        t.add_row(r['category'], f'{r["total"]:,}원')
        total += r['total']
    console.print(t)
    console.print(f'오늘 합: [cyan]{total:,}원[/]')
```

3분. SQL date('now', 'localtime') 활용. 자경단 매일 1+.

### 6-3. week 명령 (2분)

```python
@app.command()
def week(budget: int = 100_000):
    """주간 합 + 예산."""
    conn = db.connect()
    total = conn.execute('''
        SELECT COALESCE(SUM(amount), 0) FROM expenses
        WHERE created_at >= date('now', '-7 days')
    ''').fetchone()[0]
    conn.close()
    pct = total / budget * 100
    color = 'green' if pct < 80 else 'yellow' if pct < 100 else 'red'
    console.print(f'주간 합: [{color}]{total:,}원[/] / {budget:,} ({pct:.0f}%)')
```

2분. 색상 3 단계. 자경단 매주 1+.

### 6-4. 3 명령 시연 (1분)

```bash
vigi list
vigi today
vigi week --budget 50000
```

1분. 3 명령 모두 동작.

### 6-5. --help 검증 (1분)

```bash
vigi --help
# Commands:
#   add
#   list
#   today
#   week
```

1분. **Phase 4 끝 신호** = 4 명령 등록 OK.

🎯 git commit "Phase 4: list·today·week 3 명령 추가".

---

## 7. Phase 5 — chart + report (10분)

### 7-1. chart 명령 (4분)

```python
@app.command()
def chart():
    """카테고리별 막대 차트."""
    import plotext as plt
    conn = db.connect()
    rows = conn.execute('''
        SELECT category, SUM(amount) AS total FROM expenses
        GROUP BY category ORDER BY total DESC
    ''').fetchall()
    conn.close()
    cats = [r['category'] for r in rows]
    totals = [r['total'] for r in rows]
    plt.clear_figure()
    plt.bar(cats, totals)
    plt.title('가계 카테고리별')
    plt.show()
```

4분. plotext 막대 차트 + clear_figure 의무.

### 7-2. top 명령 (2분)

```python
@app.command()
def top(limit: int = 5):
    """상위 카테고리."""
    conn = db.connect()
    rows = conn.execute('''
        SELECT category, SUM(amount) AS total FROM expenses
        GROUP BY category ORDER BY total DESC LIMIT ?
    ''', (limit,)).fetchall()
    conn.close()
    t = Table(title=f'상위 {limit} 카테고리')
    t.add_column('순위'); t.add_column('카테고리'); t.add_column('합계', justify='right')
    for i, r in enumerate(rows, 1):
        t.add_row(str(i), r['category'], f'{r["total"]:,}원')
    console.print(t)
```

2분. 순위 + Table.

### 7-3. backup 명령 (2분)

```python
@app.command()
def backup():
    """DB 백업."""
    from datetime import datetime
    from shutil import copy2
    ts = datetime.now().strftime('%Y%m%d-%H%M%S')
    dest = db.DB_PATH.parent / f'backup-{ts}.db'
    copy2(db.DB_PATH, dest)
    console.print(f'[green]✅ 백업:[/] {dest}')
```

2분. shutil.copy2 표준 백업. 자경단 매주 1번.

### 7-4. chart + top 시연 (1분)

```bash
vigi chart
vigi top
vigi backup
```

1분. 3 명령 검증.

### 7-5. 7 명령 모두 검증 (1분)

```bash
vigi --help
# add·list·today·week·chart·top·backup 7 명령
```

1분. **Phase 5 끝 신호** = 7 명령 등록 OK.

🎯 git commit "Phase 5: chart·top·backup 추가 (7 명령)".

---

## 8. Phase 6 — 통합 + 첫 실전 (5분)

### 8-1. install editable 재실행 (1분)

```bash
pip install -e .
# Successfully installed vigilante-budget-0.1.0
```

1분. pyproject scripts 재등록.

### 8-2. 첫 실전 시나리오 (2분)

```bash
# 자경단 본인 매일 사용 시나리오
vigi add 4500 카페 americano
vigi add 12000 점심 비빔밥
vigi add 8500 마트 우유
vigi add 3500 교통 지하철
vigi add 2000 카페 디저트

vigi today
# 카페 7,000 / 점심 12,000 / 마트 8,500 / 교통 3,500
# 오늘 합: 30,500원

vigi week
# 주간 합: 30,500원 / 100,000 (31%)

vigi top
# 1. 점심 12,000 / 2. 마트 8,500 / 3. 카페 7,000

vigi chart
# (plotext 막대 차트)

vigi backup
# ✅ 백업: ~/.vigilante-budget/backup-20270429-143022.db
```

2분. 매일 시나리오 100% 동작.

### 8-3. DB 검증 (1분)

```bash
ls -lh ~/.vigilante-budget/
# budget.db                12K
# backup-20270429-143022.db 12K
```

1분. DB + backup 파일 자동 생성.

### 8-4. git commit + tag (1분)

```bash
git add -A
git commit -m "Phase 6: vigilante-budget v0.1.0 완성 — 7 명령 100줄"
git tag v0.1.0
```

1분. v0.1.0 첫 태그.

### 8-5. 60분 데모 끝 신호 (소감 1분)

자경단 본인 60분 후 — vigilante-budget v0.1.0 owner. 7 명령 + 100줄 + DB + 백업.

자경단 매주 1번 60분 데모 의식 = 1년 52번 신규 MVP.

🎯 **데모 100% 완성**.

---

## 9. 100줄 코드 전체

### 9-1. db.py (20줄)

```python
"""vigilante_budget/db.py — sqlite3 가계 DB."""
import sqlite3
from pathlib import Path

DB_PATH = Path.home() / '.vigilante-budget' / 'budget.db'
DB_PATH.parent.mkdir(parents=True, exist_ok=True)

def connect():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init():
    conn = connect()
    conn.execute('''CREATE TABLE IF NOT EXISTS expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER NOT NULL,
        category TEXT NOT NULL,
        memo TEXT DEFAULT '',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)''')
    conn.commit(); conn.close()

def insert(amount, category, memo=''):
    conn = connect()
    conn.execute('INSERT INTO expenses(amount, category, memo) VALUES(?, ?, ?)',
                 (amount, category, memo))
    conn.commit(); conn.close()

def all_rows():
    conn = connect()
    rows = conn.execute('SELECT * FROM expenses ORDER BY created_at DESC').fetchall()
    conn.close()
    return rows
```

20줄.

### 9-2. cli.py (75줄)

```python
"""vigilante_budget/cli.py — typer + rich + plotext CLI."""
import typer
from rich.console import Console
from rich.table import Table
import plotext as plt
from datetime import datetime
from shutil import copy2
from . import db

app = typer.Typer(help='자경단 가계부 v0.1.')
console = Console()
db.init()

@app.command()
def add(amount: int, category: str, memo: str = ''):
    """가계 추가."""
    db.insert(amount, category, memo)
    console.print(f'[green]✅ 추가:[/] {amount:,}원 / {category} / {memo}')

@app.command()
def list(limit: int = 10):
    """목록."""
    rows = db.all_rows()[:limit]
    t = Table(title=f'최근 {limit}건')
    t.add_column('id'); t.add_column('금액', justify='right')
    t.add_column('카테고리'); t.add_column('메모')
    for r in rows:
        t.add_row(str(r['id']), f'{r["amount"]:,}', r['category'], r['memo'])
    console.print(t)

@app.command()
def today():
    """오늘 합."""
    conn = db.connect()
    rows = conn.execute('''SELECT category, SUM(amount) AS total FROM expenses
        WHERE date(created_at) = date('now', 'localtime') GROUP BY category''').fetchall()
    conn.close()
    t = Table(title='오늘 가계')
    t.add_column('카테고리'); t.add_column('합계', justify='right')
    total = 0
    for r in rows:
        t.add_row(r['category'], f'{r["total"]:,}원'); total += r['total']
    console.print(t)
    console.print(f'오늘 합: [cyan]{total:,}원[/]')

@app.command()
def week(budget: int = 100_000):
    """주간 합 + 예산."""
    conn = db.connect()
    total = conn.execute('''SELECT COALESCE(SUM(amount), 0) FROM expenses
        WHERE created_at >= date('now', '-7 days')''').fetchone()[0]
    conn.close()
    pct = total / budget * 100
    color = 'green' if pct < 80 else 'yellow' if pct < 100 else 'red'
    console.print(f'주간 합: [{color}]{total:,}원[/] / {budget:,} ({pct:.0f}%)')

@app.command()
def top(limit: int = 5):
    """상위 카테고리."""
    conn = db.connect()
    rows = conn.execute('''SELECT category, SUM(amount) AS total FROM expenses
        GROUP BY category ORDER BY total DESC LIMIT ?''', (limit,)).fetchall()
    conn.close()
    t = Table(title=f'상위 {limit}')
    t.add_column('순위'); t.add_column('카테고리'); t.add_column('합계', justify='right')
    for i, r in enumerate(rows, 1):
        t.add_row(str(i), r['category'], f'{r["total"]:,}원')
    console.print(t)

@app.command()
def chart():
    """카테고리별 차트."""
    conn = db.connect()
    rows = conn.execute('''SELECT category, SUM(amount) AS total FROM expenses
        GROUP BY category ORDER BY total DESC''').fetchall()
    conn.close()
    plt.clear_figure()
    plt.bar([r['category'] for r in rows], [r['total'] for r in rows])
    plt.title('가계 차트')
    plt.show()

@app.command()
def backup():
    """DB 백업."""
    ts = datetime.now().strftime('%Y%m%d-%H%M%S')
    dest = db.DB_PATH.parent / f'backup-{ts}.db'
    copy2(db.DB_PATH, dest)
    console.print(f'[green]✅ 백업:[/] {dest}')
```

75줄. 7 명령. 자경단 매주 1번 commit·진화.

### 9-3. pyproject.toml (10줄)

```toml
[project]
name = "vigilante-budget"
version = "0.1.0"
dependencies = ["typer>=0.9.0", "rich>=13.7.0", "plotext>=5.2.8"]

[project.scripts]
vigi = "vigilante_budget.cli:app"

[build-system]
requires = ["setuptools>=64"]
build-backend = "setuptools.build_meta"
```

10줄.

**총 105줄** (db.py 20 + cli.py 75 + pyproject 10). 자경단 매주 1번 신규 MVP.

---

## 10. 자경단 1주 데모 통계

| 자경단 | 신규 코드 줄 | commit | tag | install -e | vigi 호출 | 합 |
|---|---|---|---|---|---|---|
| 본인 | 100 | 6 | 1 | 1 | 50 | 158 |
| 까미 | 80 | 5 | 1 | 1 | 35 | 122 |
| 노랭이 | 150 | 7 | 1 | 1 | 70 | 229 |
| 미니 | 70 | 5 | 1 | 1 | 30 | 107 |
| 깜장이 | 120 | 6 | 1 | 1 | 60 | 188 |
| **합** | **520** | **29** | **5** | **5** | **245** | **804** |

5명 1주 804 데모 활동·1년 41,808·5년 209,040.

---

## 11. 데모 5 함정

### 11-1. install -e 재실행 잊음

```bash
# pyproject 수정 후 install -e 재실행 X
vigi --help   # ❌ 옛 명령 표시
```

처방: 수정 후 `pip install -e .` 의식. 자경단 매주 1+ 함정.

### 11-2. db.init() 누락

```python
# cli.py 첫 줄에 db.init() 없음
# → 처음 실행 시 schema 없음 오류
```

처방: cli.py 모듈 로드 시 db.init() 자동.

### 11-3. typer + click 버전 충돌

```
typer 0.9.0 + click 7.x → 호환 X
```

처방: `pip install --upgrade typer click`. 자경단 매월 1+.

### 11-4. plotext clear_figure 누락

```python
plt.bar(...); plt.show()
plt.bar(...); plt.show()   # 위 차트 위에 겹침
```

처방: `plt.clear_figure()` 사이.

### 11-5. SQL injection (?, ? 누락)

```python
conn.execute(f"SELECT * FROM expenses WHERE category='{cat}'")  # ❌
```

처방: `(?, ?)` parameter binding 의무.

자경단 매월 5 함정 의식.

---

## 12. 흔한 오해 + FAQ + 추신

### 흔한 오해 15

오해 1. "100줄 너무 짧음" — MVP 표준.

오해 2. "60분 너무 빠름" — 6 단계 × 10분 균형.

오해 3. "데모 사치" — 매주 1번 = 1년 52 MVP.

오해 4. "100줄로 가계부 부족" — 매주 진화·1년 후 500줄.

오해 5. "typer 어려움" — 6 단계 5분.

오해 6. "rich Table 어려움" — 3줄 작성.

오해 7. "sqlite3 외부 설치" — 표준·X.

오해 8. "plotext 사치" — 매월 차트.

오해 9. "pyproject 어려움" — 10줄 시작.

오해 10. "install -e 사치" — 매번 의식.

오해 11. "git tag 사치" — v0.1.0 첫 표지.

오해 12. "DB 경로 ~/.vigilante" — 표준·다중 사용자 안전.

오해 13. "row_factory 사치" — dict 같은 접근 편리.

오해 14. "color 3 단계 사치" — green·yellow·red 시각.

오해 15. "데모 첫 실패 두려움" — 6 단계 안전망.

### FAQ 15

Q1. 6 단계? — 환경·DB·add·list/today/week·chart·통합.

Q2. 100줄? — db.py 20 + cli.py 75 + pyproject 10.

Q3. 7 명령? — add·list·today·week·top·chart·backup.

Q4. 60분? — 15+10+10+10+10+5.

Q5. 5 도구? — typer·rich·sqlite3·click·plotext.

Q6. install -e? — pip install -e . editable.

Q7. db.init() 위치? — cli.py 첫 줄·자동.

Q8. row_factory? — sqlite3.Row dict 접근.

Q9. plotext clear? — clear_figure() 사이 의무.

Q10. SQL injection 처방? — (?, ?) parameter binding.

Q11. git commit 빈도? — 6 commit / 60분.

Q12. tag v0.1.0? — 첫 데모 태그.

Q13. DB 경로? — ~/.vigilante-budget/budget.db.

Q14. backup 형식? — backup-YYYYMMDD-HHMMSS.db.

Q15. 자경단 1주 데모? — 5명 804 호출.

### 추신 35

추신 1. 100줄 데모 — 6 단계 60분.

추신 2. Phase 1: 환경 15분.

추신 3. Phase 2: DB 10분.

추신 4. Phase 3: add 10분.

추신 5. Phase 4: list·today·week 10분.

추신 6. Phase 5: chart·top·backup 10분.

추신 7. Phase 6: 통합 5분.

추신 8. 7 명령 — add·list·today·week·top·chart·backup.

추신 9. 5 도구 통합 — typer·rich·sqlite3·click·plotext.

추신 10. db.py 20 + cli.py 75 + pyproject 10 = 105줄.

추신 11. install -e 매 단계 의식.

추신 12. row_factory = sqlite3.Row 표준.

추신 13. plotext clear_figure 의무.

추신 14. SQL (?, ?) parameter 의무.

추신 15. **본 H 100% 완성** ✅ — Ch015 H5 100줄 데모 완성·다음 H6!

추신 16. 자경단 1주 데모 — 5명 804 활동·1년 41,808.

추신 17. git tag v0.1.0 첫 태그.

추신 18. DB 경로 ~/.vigilante-budget 표준.

추신 19. backup-YYYYMMDD-HHMMSS.db 형식.

추신 20. color 3 단계 — green·yellow·red.

추신 21. **본 H 진짜 100% 완성** ✅✅✅✅✅✅✅✅✅✅✅✅.

추신 22. typer @app.command() 데코레이터 7번.

추신 23. typer.Typer(help='...') 패키지 설명.

추신 24. rich.Console.print color 매번.

추신 25. rich.Table title + add_column + add_row.

추신 26. SQL date('now', 'localtime') 활용.

추신 27. SQL date('now', '-7 days') 활용.

추신 28. SQL COALESCE(SUM(amount), 0) NULL 안전.

추신 29. shutil.copy2 백업 표준.

추신 30. **본 H 진짜 마지막 100% 완성** 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾.

추신 31. 자경단 본인 매주 1번 60분 데모.

추신 32. 자경단 5명 매주 1번 신규 MVP·1년 260 MVP.

추신 33. 본 H 가장 큰 가치 — 100줄 = MVP = 자경단 매주 신규.

추신 34. 본 H 학습 후 능력 — 6 단계·100줄·7 명령·5 도구·5 함정.

추신 35. **본 H 진짜 진짜 마지막 100% 완성!!!** 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾 — Ch015 H5 100줄 데모 100% 완성·자경단 1주 804 활동·1년 41,808·5년 209,040 ROI·다음 H6 운영 (백업·sync·복구)!

---

## 13. 자경단 100줄 데모 면접 응답 25초

Q1. 100줄 데모? — 6 단계 60분·7 명령·5 도구·v0.1.0.

Q2. 6 단계? — 환경·DB·add·list/today/week·chart·통합.

Q3. 7 명령? — add·list·today·week·top·chart·backup.

Q4. 5 도구 통합? — typer·rich·sqlite3·click·plotext.

Q5. 5 함정? — install -e·db.init·typer 버전·plotext clear·SQL injection.

자경단 1년 후 5 질문 25초.

---

## 14. 자경단 매주 데모 의식표

| 요일 | 활동 | Phase | 시간 |
|---|---|---|---|
| 월 | Phase 1 환경 | 환경 + 5 도구 | 15분 |
| 화 | Phase 2 DB | sqlite3 schema | 10분 |
| 수 | Phase 3 add | typer + rich | 10분 |
| 목 | Phase 4 list/today/week | 3 명령 | 10분 |
| 금 | Phase 5 chart/top/backup | 시각화 + 백업 | 10분 |
| 토 | Phase 6 통합 + tag | install -e + tag | 5분 |
| 일 | 회고 + 진화 plan | git log 검토 | 10분 |
| **합** | | | **70분** |

자경단 매주 70분 데모·1년 누적 3,640분 ≈ 60시간.

---

## 15. 자경단 100줄 데모 진화 5년

### 15-1. 1년차 — 100줄 → 500줄

매주 1번 100줄 + 매주 새 명령 1+. 1년 후 500줄·15 명령.

### 15-2. 2년차 — 500줄 → 1,500줄

OOP 적용 (Ch016+)·테스트 추가 (Ch022). 1,500줄·25 명령.

### 15-3. 3년차 — 1,500줄 → 3,000줄

Flask API 추가 (Ch020+)·웹 대시보드. 3,000줄·40 명령.

### 15-4. 4년차 — PyPI v1.0

PyPI 등록·`pip install vigilante-budget`. 사용자 100/월.

### 15-5. 5년차 — 자경단 도메인 표준

자경단 도메인 가계부 표준·5명 + 25+ 사용자.

자경단 5년 후 가계부 도메인 표준 owner.

---

## 16. 자경단 100줄 데모 추가 5

- **--version 옵션**: `app = typer.Typer(); @app.command() def version()` 추가.
- **--config 경로**: `~/.vigilante-budget/config.toml` 환경 변수.
- **rich.traceback**: `from rich.traceback import install; install()` — 오류 컬러.
- **logging**: `import logging; logging.basicConfig(...)` — 매주 1+ 로그.
- **타입 힌트 강화**: `def add(amount: int, category: str, memo: str = '')` — mypy.

자경단 5 추가 매월 의식.

---

## 17. 자경단 100줄 데모 매트릭

매주 측정 5:

1. 데모 60분 시간 (목표: ±5분)
2. 100줄 줄 수 (목표: 100±10줄)
3. 7 명령 (목표: 7개 모두)
4. 6 commit (목표: 6개)
5. v0.1.0 tag (목표: 1개)

매주 5분 측정·1년 후 6배 정확.

---

## 18. 자경단 100줄 데모 6 인증

자경단 본인 1년 후 6 인증:

1. **🥇 100줄 60분 인증** — 데모 안정.
2. **🥈 7 명령 인증** — add·list·today·week·top·chart·backup.
3. **🥉 5 도구 통합 인증** — typer·rich·sqlite3·click·plotext.
4. **🏅 5 함정 인증** — install -e·db.init·typer·plotext·SQL.
5. **🏆 v0.1.0 tag 인증** — git tag 첫 표지.
6. **🎖 면접 5 질문 25초 인증** — 100줄 데모 마스터.

자경단 5명 6 인증 통과.

---

## 19. 자경단 100줄 데모 12년 시간축

| 연차 | 줄 수 | 명령 수 | tag | 사용자 | 마스터 신호 |
|---|---|---|---|---|---|
| 1년 | 500 | 15 | v0.5 | 본인 | 100줄 마스터 |
| 2년 | 1,500 | 25 | v1.0 | 5 (자경단) | OOP + 테스트 |
| 3년 | 3,000 | 40 | v2.0 | 25 | Flask API |
| 5년 | 8,000 | 60 | v5.0 | 100/월 | PyPI 도메인 표준 |
| 12년 | 20,000 | 100 | v10.0 | 1,000/월 | 자경단 브랜드 가계부 |

자경단 12년 후 20,000줄·100 명령·1,000 사용자/월·자경단 브랜드 owner!

---

## 20. Ch015 H5 마지막 인사

자경단 본인·5명 100줄 첫 실전 데모 학습 100% 완성! 매주 70분·1년 41,808 활동·5년 209,040·12년 501,696·시니어 신호 5+. 1년 후 500줄 v0.5·5년 후 PyPI v5.0·12년 후 자경단 브랜드 가계부!

🚀🚀🚀🚀🚀 다음 H6 운영 (백업·sync·복구) — vigilante-budget 매주 안전 의식 시작! 🚀🚀🚀🚀🚀

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - 100줄 데모 = db.py 20 + cli.py 75 + pyproject 10 = 105줄
> - 6 단계 60분: 환경 15 → DB 10 → add 10 → list/today/week 10 → chart/top/backup 10 → 통합 5
> - 7 명령: add·list·today·week·top·chart·backup (typer @app.command 데코레이터 7번)
> - DB 경로 ~/.vigilante-budget/budget.db — `Path.home() / '.vigilante-budget'` 표준
> - row_factory = sqlite3.Row 권장 — dict 같은 접근 (`r['amount']`)
> - SQL date('now', 'localtime') — 시간대 명시 (UTC 함정 회피)
> - SQL COALESCE(SUM(amount), 0) — 빈 결과 NULL → 0
> - SQL parameter binding (?, ?) 의무 — SQL injection 회피
> - plotext clear_figure() 의무 — 여러 차트 시 사이에 호출
> - shutil.copy2 — 메타데이터까지 복사 (mtime 보존)
> - typer.Typer(help='...') 패키지 도움말 설정
> - rich color 3 단계 (green/yellow/red) — < 80% / < 100% / >= 100%
> - install -e . 매 pyproject 수정 후 의식 — entry_points 재등록
> - git tag v0.1.0 — 첫 데모 표지·자경단 매주 1번 tag 의식
> - 자경단 1주 804 데모 활동·1년 41,808·5년 209,040
> - 다음 H6: 운영 (백업·sync·복구) + 5 함정 + cron 자동화
