# Ch015 · H5 — vigilante-budget 30분 만들기 — 라이브 코딩

> 고양이 자경단 · Ch 015 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 오늘 만들 것 — 시나리오
3. 0~5분 — 셋업
4. 5~10분 — DB 초기화
5. 10~15분 — add 명령
6. 15~20분 — list 명령
7. 20~25분 — summary와 chart
8. 25~30분 — 실행과 검증
9. 다섯 사고와 처방
10. 흔한 오해 다섯 가지
11. 흔한 실수 다섯 + 안심
12. 마무리 — 본인의 첫 도구가 돌다

---

## 🔧 강사용 명령어 한눈에

```bash
mkdir -p /tmp/budget && cd /tmp/budget && python3 -m venv .venv
source .venv/bin/activate && pip install typer rich plotext
python3 budget.py add 5000 food --note 점심   # 30분 뒤 이게 돌아갑니다
python3 budget.py list                          # add·list·summary·chart 네 명령
```

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다섯 번째 시간이에요. 그리고 이 챕터의 하이라이트예요. 드디어 가계부를 직접 만들거든요.

지난 H4에서 메뉴판을 그렸죠. 가계부 명령을 여섯 그룹으로 묶고, "매일 쓰는 add·list부터 만든다"고 정했어요. 오늘 그걸 실제로 만들어요. 30분 만에, 100줄 미만으로, 진짜 도는 가계부를요. add·list에 통계 두 개(summary·chart)까지 더해 네 명령으로요.

오늘의 약속은 이거예요. **본인의 첫 가계부가, 30분 뒤에 진짜로 동작합니다.** 셸에서 `python3 budget.py add 5000 food`를 치면 지출이 저장되고, `list`를 치면 예쁜 표가 뜨고, `chart`를 치면 막대 그래프가 떠요. 이건 예제 코드가 아니에요. 본인이 오늘부터 매일 쓸 진짜 도구예요.

H1에서 제 옛날이야기 기억나죠? 12년 전, 첫 CLI를 짜고 `summary`를 쳤더니 한 시간 걸릴 정산이 5초 만에 떴던 그 짜릿함이요. 오늘 본인이 그걸 경험해요. 30분 뒤, 본인이 만든 도구가 진짜로 일하는 걸 보게 될 거예요. 그 순간이 본인을 "예제 따라 치는 사람"에서 "도구를 만드는 사람"으로 바꿔요.

자, 마음의 준비를 하세요. 오늘은 듣기만 하는 시간이 아니에요. 같이 손을 움직이는 시간이에요. 6단계로 나눠서, 5분씩 차근차근 쌓을게요. 셋업(0~5분) → DB(5~10분) → add(10~15분) → list(15~20분) → summary·chart(20~25분) → 실행·검증(25~30분). 한 단계씩 따라오면, 30분 뒤 본인 손에 가계부가 있어요. 자, 가요.

---

## 2. 오늘 만들 것 — 시나리오

먼저 오늘 만들 것의 그림을 그릴게요. 30분 뒤 본인 가계부는 이렇게 돌아요.

```bash
$ python3 budget.py add 5000 food --note 점심
✅ 추가: 5000 food (2026-04-30)

$ python3 budget.py list
# 예쁜 표로 지출 목록이 뜸

$ python3 budget.py summary
# 카테고리별 합계 표

$ python3 budget.py chart
# 카테고리별 막대 그래프
```

네 명령이에요. add(추가)·list(목록)·summary(합계)·chart(차트). H4의 메뉴판에서 매일·매주 쓰는 핵심만 골랐어요. CRUD의 add·list와 통계의 summary, 시각화의 chart요. 이 넷이면 가계부의 큰 줄기가 다 돌아가요. 기록하고, 보고, 합치고, 그리는 거죠.

그리고 이걸 다 합쳐도 100줄이 안 돼요. "에이, 가계부가 100줄로 되겠어요?" 싶죠. 돼요. 왜냐하면 본인이 직접 다 짜는 게 아니거든요. 명령 받기는 typer가, 저장은 sqlite3가, 화면은 rich가, 차트는 plotext가 해 줘요. 본인은 그 네 도구를 불러 모아 이어 붙이는 거예요. H3에서 "본인은 다섯 전문가를 부르는 지휘자"라고 했죠. 오늘 그 지휘를 해요. 100줄은 본인이 도구들을 이어 붙이는 그 연결선이에요. 적은 줄로 큰 일을 하는 비결이 이거예요. 좋은 도구를 조합하는 거요.

자, 그림이 그려졌으면 시작해요. 한 단계씩, 5분씩이에요. 중간에 코드가 안 돌아도 당황하지 마세요. 라이브 코딩은 원래 중간에 한 번씩 막혀요. 그게 정상이에요. 막히면 어디가 틀렸는지 같이 찾으면 돼요. 그 과정 자체가 공부예요.

한 가지 마음가짐을 일러둘게요. 오늘 코드를 따라 칠 때, 그냥 베끼지 말고 "이 줄이 왜 여기 있나"를 생각하며 치세요. add의 `?`가 왜 있는지, list의 `WHERE 1=1`이 왜 있는지요. 베끼기만 하면 손은 움직여도 머리엔 안 남아요. 그런데 "왜"를 생각하며 치면, 나중에 본인이 새 명령을 만들 때 그 "왜"가 길잡이가 돼요. 그래서 오늘 제가 각 줄을 천천히 설명할 거예요. 빨리 완성하는 게 목적이 아니라, 한 줄씩 이해하며 완성하는 게 목적이거든요. 30분은 넉넉해요. 서두르지 말고, 한 줄씩 음미하며 가요. 그게 이 데모를 본인 것으로 만드는 길이에요.

그리고 오늘 만들 코드는 H4에서 그린 메뉴판의 첫 네 칸이에요. 메뉴판엔 서른 개가 있었지만, 오늘은 매일·매주 쓰는 핵심 넷부터요. "메뉴판은 다 그리되, 다 요리하진 않는다"고 했죠. 오늘이 바로 그 첫 요리예요. 이 넷을 완성하고 며칠 써 보면, "아, edit도 있으면 좋겠다", "search도 필요하다" 싶어져요. 그때 메뉴판에서 하나씩 더 꺼내 만들면 돼요. 오늘은 그 출발점인 네 칸을 만드는 거예요.

---

## 3. 0~5분 — 셋업

첫 5분, 집을 지어요. H3에서 배운 그대로예요.

```bash
mkdir -p /tmp/budget && cd /tmp/budget
python3 -m venv .venv
source .venv/bin/activate
pip install typer rich plotext
touch budget.py
```

한 줄씩 볼게요. `mkdir`로 작업 폴더를 만들고 들어가요. `python3 -m venv .venv`로 가상환경을 짓고, `source .venv/bin/activate`로 들어가요. 프롬프트에 `(.venv)`가 떴는지 꼭 확인하세요. 그게 떠야 가계부 집 안이에요. 그다음 `pip install typer rich plotext`로 세 도구를 깔아요. sqlite3는 내장이라 안 깔아도 되고, dateutil은 오늘 데모엔 안 쓰니 뺐어요. 마지막으로 `touch budget.py`로 빈 파일 하나를 만들어요. 이 파일에 가계부를 다 짤 거예요.

오늘은 연습이니 `/tmp/budget`에 만들었어요. /tmp는 임시 폴더라, 컴퓨터를 끄면 사라지죠. 연습엔 딱이에요. 그런데 본인이 진짜로 쓸 가계부는 H3에서처럼 제대로 된 폴더에 만들고, pyproject.toml도 갖춰야 해요. 오늘은 빠르게 만드는 데 집중하려고 한 파일(`budget.py`)로 가는 거예요. 나중에 키울 땐 Ch013에서 배운 대로 모듈로 나누고요. 작게 시작해 키우는 거죠. 오늘은 작게 시작하는 날이에요.

5분이 짧죠? 그런데 이 5분이 H3에서 미리 연습해 둔 덕분에 막힘이 없는 거예요. 환경 만들기를 H3에서 안 해 봤으면, 지금 여기서 헤맸을 거예요. 미리 갖춰 둔 게 여기서 빛나요. 자, 집이 섰으니 안에 가계부를 짓기 시작해요.

---

## 4. 5~10분 — DB 초기화

이제 budget.py를 열고, 맨 위에 도구들을 불러오고 DB를 준비해요.

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
    """DB에 연결하고, 없으면 테이블을 만든다."""
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

위에서부터 볼게요. import 줄들이 보이죠. 표준 라이브러리(sqlite3·datetime·pathlib)를 먼저, 빈 줄 두고 외부 도구(typer·rich)를 다음에 적었어요. 이 순서, Ch013에서 배운 import 정렬이에요. 입문에서 배운 게 첫 줄부터 살아나죠.

`app = typer.Typer(...)`는 가계부 앱의 뼈대예요. 앞으로 만들 명령(add·list 등)이 다 이 `app`에 매달려요. `console = Console()`은 rich의 출력 창구고요. `DB_PATH = Path.home() / ".vigilante-budget.db"`는 DB 파일의 위치예요. `Path.home()`이 사용자 홈 폴더고, 거기에 `.vigilante-budget.db`라는 숨김 파일로 DB를 두는 거죠. 점으로 시작하면 숨김 파일이라고 Ch014에서 배웠죠. /tmp가 아니라 홈에 두는 건, 가계부 데이터는 임시가 아니라 오래 남아야 하니까요. 작업 폴더는 임시라도, 데이터는 안전한 홈에 두는 거예요.

핵심은 `get_db()` 함수예요. H3에서 본 sqlite3 다섯 단계 중 "연결"과 "테이블 만들기"를 합친 거죠. `sqlite3.connect`로 DB 파일에 연결하고, `CREATE TABLE IF NOT EXISTS`로 entries 테이블을 만들어요. `IF NOT EXISTS` 덕분에, 이미 있으면 또 안 만들고 그냥 넘어가요. 그래서 이 함수를 매번 불러도 안전해요. 처음 부르면 테이블을 만들고, 다음부턴 있는 걸 쓰는 거죠. 가계부를 처음 쓰는 사람도 이 함수 덕에 자동으로 DB가 준비돼요. 따로 "초기화하세요" 할 필요가 없어요. 친절한 설계죠.

한 가지 새 줄, `conn.row_factory = sqlite3.Row`를 짚을게요. 이게 있으면 조회 결과를 `r["amount"]`처럼 칸 이름으로 꺼낼 수 있어요. 없으면 `r[3]`처럼 번호로 꺼내야 하는데, 번호는 헷갈리잖아요. 이름으로 꺼내면 코드가 읽기 좋아요. 작은 줄이지만, 뒤에서 list를 만들 때 편해져요.

그리고 get_db를 함수로 따로 뺀 것도 의미가 있어요. add도, list도, summary도, chart도 다 DB에 연결해야 하잖아요. 그 연결과 테이블 준비를 매번 적으면 같은 코드가 네 번 반복되죠. get_db 함수 하나로 빼 두니, 각 명령은 `conn = get_db()` 한 줄로 끝나요. Ch009에서 배운 "반복되면 함수로"가 가계부 첫 줄부터 적용된 거예요. 그리고 나중에 DB 설정을 바꾸고 싶으면(예: 파일 위치 변경) get_db 한 군데만 고치면 돼요. 네 명령을 다 안 고쳐도요. 이게 함수로 빼는 가치예요. 한 곳에 모아 두면, 한 곳만 고치면 되거든요. 작은 가계부에서도 이 원칙이 통해요. 자, DB가 준비됐으니 첫 명령 add를 만들어요.

---

## 5. 10~15분 — add 명령

이제 가계부의 심장, add 명령이에요. 지출을 추가하는 거죠.

```python
@app.command()
def add(
    amount: int = typer.Argument(..., help="금액"),
    category: str = typer.Argument(..., help="카테고리"),
    note: str = typer.Option("", help="메모"),
    when: str = typer.Option(None, help="날짜 YYYY-MM-DD"),
):
    """가계부에 지출을 추가합니다."""
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

천천히 볼게요. `@app.command()`는 "이 함수를 가계부 명령으로 만들어"라는 표시예요. 이걸 붙이면 `add`라는 서브커맨드가 생겨요. H2에서 배운 데코레이터죠.

매개변수를 보세요. `amount: int = typer.Argument(...)`와 `category: str = typer.Argument(...)`는 인자예요. H4에서 "금액과 카테고리는 필수"라고 했죠. 그래서 Argument로 했고, `...`(Ellipsis)로 필수라고 표시했어요. H2에서 본 그 점 세 개예요. 반면 `note`와 `when`은 `typer.Option`이에요. 있어도 되고 없어도 되는 선택값이죠. 메모는 안 적어도 되고, 날짜는 안 주면 오늘로 치니까요. 인자와 옵션의 구분, H2에서 배운 그대로 코드에 나타나죠.

함수 안을 볼게요. `today = when or date.today().isoformat()` 이 한 줄이 똘똘해요. `when`(사용자가 준 날짜)이 있으면 그걸 쓰고, 없으면(None이면) 오늘 날짜를 쓰는 거예요. Python의 `or`가 "앞이 비어 있으면 뒤를 쓴다"는 성질을 이용한 거죠. Ch008에서 배운 `or`의 응용이에요. 그래서 `add 5000 food`처럼 날짜를 안 줘도, 자동으로 오늘로 기록돼요.

그다음이 H3에서 본 INSERT예요. `get_db()`로 연결하고, `INSERT INTO ... VALUES (?, ?, ?, ?)`로 한 줄 넣고, `commit()`으로 확정하고, `close()`로 닫아요. 여기서 `?` 보이죠? 값을 직접 안 끼우고 `?`로 넘기는 그 파라미터 바인딩이에요. 안전을 위해서요(H4 FAQ). 그리고 `commit()`을 꼭 했어요. 이거 빼먹으면 저장이 안 된다고 했죠. 마지막에 `print`로 rich 마크업을 써서 초록색 성공 메시지를 띄워요. `[green]...[/green]`이 H2에서 본 그 색 입히기고요.

보세요. 이 한 함수에 입문과 이 챕터에서 배운 게 다 모였어요. 데코레이터, 타입 힌트, Argument/Option, `or` 응용, INSERT, 파라미터 바인딩, rich 마크업이요. add 하나가 그 종합이에요. 그리고 이게 가계부의 심장이에요. 지출을 기록하는 거니까요. 이거 하나만 돌아도, 본인은 이미 "기록하는 도구"를 가진 거예요.

이 add 함수의 흐름을 한 번 더 큰 그림으로 짚을게요. 사용자가 셸에서 `add 5000 food`를 치면, 이런 여행이 일어나요. 먼저 typer가 셸의 글자 `5000`을 정수 `5000`으로, `food`를 문자열로 바꿔 함수 매개변수에 꽂아요(타입 힌트 덕분에요). 그다음 함수 안에서 날짜를 정하고(`or` 응용), get_db로 DB에 연결하고, INSERT로 그 값을 entries 테이블에 한 줄 넣고, commit으로 확정하고, 성공 메시지를 rich로 띄워요. 셸의 글자 한 줄이, 여러 도구를 거쳐 DB 파일에 기록으로 남는 거예요. 이 여행이 H1에서 말한 "CS(셸)와 Python의 만남"의 구체적인 모습이에요. 검은 화면의 명령이, Python 코드를 거쳐, 파일에 영원히 남는 거죠. 본인이 이 짧은 함수로 그 다리를 놓은 거예요.

그리고 add를 짤 때 한 가지 좋은 습관을 짚을게요. 함수가 하는 일이 또렷하죠? "날짜 정하기 → DB 열기 → 넣기 → 확정 → 닫기 → 알리기." 한 함수가 한 가지 일(지출 추가)을 또박또박 해요. Ch009·Ch013에서 배운 "한 함수 한 책임"이에요. 만약 add 안에 통계 계산이나 차트 그리기까지 욱여넣었다면, 함수가 뒤죽박죽됐을 거예요. 각 명령이 자기 일만 하게 나눈 게, 코드를 읽기 좋고 고치기 쉽게 만들어요. 가계부가 작아도 이 원칙을 지키면, 나중에 커져도 안 무너져요. 좋은 습관은 작을 때부터 들이는 거예요.

---

## 6. 15~20분 — list 명령

이제 기록한 걸 보는 list예요. 조금 더 길지만, 차근차근 보면 어렵지 않아요.

```python
@app.command()
def list(
    month: str = typer.Option(None, help="YYYY-MM"),
    category: str = typer.Option(None, help="카테고리"),
):
    """지출 목록을 표로 보여줍니다."""
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
            str(r["id"]), r["date"], r["category"],
            f"{r['amount']:,}", r["note"] or "",
        )

    console.print(table)
```

list는 두 부분이에요. 위는 데이터를 가져오는 부분(SQL), 아래는 표로 그리는 부분(rich)이죠. H2에서 본 입력과 출력의 분리가 한 함수 안에도 있는 거예요.

위쪽 SQL 부분이 재미있어요. `sql = "SELECT * FROM entries WHERE 1=1"`로 시작하죠. `WHERE 1=1`이 좀 이상해 보이죠? 이건 "항상 참"인 조건이에요. 왜 이렇게 하냐면, 뒤에 조건을 `AND`로 이어 붙이기 편하려고요. month 옵션이 있으면 `AND date LIKE ?`를 더하고, category가 있으면 `AND category = ?`를 더하는 식이죠. `1=1`로 시작해 두면, 조건이 있든 없든 `AND`만 이어 붙이면 되니 코드가 깔끔해요. 작은 trick이지만 실무에서 자주 써요.

`date LIKE ?`에 `f"{month}%"`를 넘기는 것도 짚을게요. LIKE는 "비슷한 걸 찾아"라는 SQL이고, `%`는 "아무거나"라는 뜻이에요. 그래서 `2026-04%`는 "2026-04로 시작하는 모든 날짜", 즉 4월 전체를 뜻해요. 이렇게 한 달 치를 거르는 거죠. `ORDER BY date DESC`는 최신 날짜가 위로 오게 정렬하고요. 여기서도 값은 `?`로 넘기죠. 안전하게요.

아래쪽 rich 부분은 H2·H3에서 본 표 그리기예요. `Table`을 만들고, `add_column`으로 열을 정하고, for문으로 한 줄씩 `add_row`로 더해요. `f"{r['amount']:,}"`에서 `:,`가 천 단위 콤마를 찍어 줘요. 5000을 5,000으로요. 금액은 콤마가 있어야 읽기 좋잖아요. Ch011에서 배운 문자열 포맷이에요. `r["note"] or ""`는 메모가 없으면(None이면) 빈 칸으로 두는 거고요. 또 `or`의 응용이죠.

list가 길어 보여도, 결국 "조건에 맞게 가져와서, 예쁜 표로 그린다"는 두 동작이에요. SQL이 가져오고, rich가 그리고요. 본인은 그 둘을 이어 붙인 거예요. 이게 add보다 길지만, 새로운 건 별로 없어요. 다 배운 것의 조합이죠.

list에서 조건을 옵션으로 받는 부분을 조금 더 음미할게요. `month`와 `category` 옵션이 있으면 SQL에 조건을 더하고, 없으면 안 더하죠. 그래서 `list`만 치면 전체가 나오고, `list --month 2026-04`를 치면 4월만, `list --category food`를 치면 food만 나와요. 한 함수가 옵션에 따라 여러 가지로 동작하는 거예요. 이게 옵션의 힘이에요. 명령을 여러 개 만들 필요 없이, 옵션 하나로 동작을 바꾸는 거죠. 만약 옵션이 없었다면 `list-all`, `list-month`, `list-category`처럼 명령을 여러 개 만들어야 했을 거예요. 옵션 덕에 명령 하나로 깔끔하게 처리하는 거죠. H2에서 배운 옵션의 가치가 여기서 실감 나요.

그리고 `params = []` 리스트에 조건 값을 차곡차곡 모으는 방식도 봐 두세요. month가 있으면 `params.append(f"{month}%")`, category가 있으면 `params.append(category)`로 더하고, 마지막에 `conn.execute(sql, params)`로 한꺼번에 넘겨요. SQL의 `?` 개수와 params의 값 개수가 딱 맞아야 하죠. 조건을 더할 때 `?`와 값을 짝지어 같이 더하니, 항상 개수가 맞아요. 이게 안전하게 동적 쿼리를 만드는 정석이에요. 값을 문자열에 직접 끼우지 않고, `?`와 params 리스트로 분리해서요. Ch010에서 배운 리스트가 여기서 "조건 값 모으기"에 쓰이는 거예요. 입문의 자료구조가 실전에서 이렇게 쓰여요.

---

## 7. 20~25분 — summary와 chart

이제 통계 두 개를 더해요. summary(합계 표)와 chart(막대 그래프)예요.

```python
@app.command()
def summary(month: str = typer.Option(None)):
    """카테고리별 합계를 보여줍니다."""
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
    """카테고리별 막대 차트를 그립니다."""
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

summary부터 볼게요. 핵심은 SQL 한 줄이에요. `SELECT category, SUM(amount) as total FROM entries GROUP BY category`요. H4에서 말한 그 GROUP BY예요. "카테고리별로 묶어서(GROUP BY category), 금액을 합쳐(SUM(amount))"라는 뜻이죠. 그러면 food는 food끼리, transport는 transport끼리 합쳐져 나와요. 본인이 Ch010에서 Counter로 직접 세던 걸, DB가 SQL 한 줄로 해 주는 거예요. `as total`은 합계에 "total"이라는 이름을 붙이는 거고, `ORDER BY total DESC`로 많이 쓴 카테고리가 위로 오게 정렬해요. 나머지(표 그리기)는 list와 똑같죠.

chart는 summary와 거의 같아요. 같은 GROUP BY로 카테고리별 합계를 구하죠. 다른 건 마지막이에요. 표로 그리는 대신, plotext로 막대 차트를 그려요. `categories = [r["category"] for r in rows]` 이거, 리스트 컴프리헨션이죠? Ch008에서 배운 거요. 조회 결과에서 카테고리만 쫙 뽑아 리스트로 만드는 거예요. amounts도 같은 식으로 금액만 뽑고요. 그 둘을 `plt.bar`에 넘기면 막대 그래프가 떠요. H3에서 본 그대로죠.

여기서 `import plotext as plt`가 함수 안에 있는 거 눈치챘나요? 보통 import는 파일 맨 위에 적는데, plotext는 chart에서만 쓰니까 함수 안에 뒀어요. 이러면 chart를 안 쓸 땐 plotext를 안 불러와서 조금 빨라요. 작은 최적화지만, "안 쓰는 건 늦게 불러온다"는 요령이에요. 꼭 이렇게 할 필욘 없지만, 이런 방식도 있다는 걸 봐 두세요.

summary와 chart가 거의 같은 SQL을 쓴다는 거, 눈치챘나요? 둘 다 `SELECT category, SUM(amount) ... GROUP BY category`예요. 데이터를 묶어 합치는 부분은 똑같고, 그걸 표로 보여주느냐(summary) 그래프로 보여주느냐(chart)만 달라요. 이건 H4에서 말한 "통계 명령은 묶는 기준만 다른 한 가족"의 모습이에요. 그래서 한 통계를 짜 두면 다음 건 쉬워져요. summary를 짰으니 chart는 거의 복사해서 마지막 출력만 바꾼 거죠. 실무에선 이렇게 겹치는 부분을 함수로 빼기도 해요. "카테고리별 합계를 구하는" 부분을 `get_category_totals()` 같은 함수로 만들어, summary와 chart가 같이 쓰는 거죠. Ch009에서 배운 "반복되면 함수로"예요. 오늘은 데모라 각자 적었지만, 본인이 키울 땐 이 중복을 함수로 빼면 더 깔끔해져요. 그게 코드를 다듬는 다음 단계예요.

그리고 chart가 컴프리헨션으로 값을 뽑는 부분(`[r["category"] for r in rows]`)을 다시 보세요. 조회 결과(rows)에서 카테고리만, 또 금액만 쫙 뽑아 두 리스트로 만드는 거예요. plotext의 bar는 "이름 리스트와 값 리스트"를 받으니까, 그 모양으로 맞춰 주는 거죠. DB가 준 데이터를, plotext가 원하는 모양으로 바꾸는 한 줄이에요. 이렇게 한 도구의 출력을 다른 도구의 입력 모양으로 바꿔 주는 일이, 도구를 이어 붙이는 본인의 핵심 역할이에요. 지휘자가 악기들 사이를 잇듯이요. Ch008의 컴프리헨션이 그 이음매에서 일하는 거고요.

마지막 `if __name__ == "__main__": app()`이 보이죠. Ch013에서 배운 그거예요. "이 파일을 직접 실행하면 app()을 돌려라"는 뜻이죠. 이 한 줄 덕에 `python3 budget.py`로 가계부가 실행돼요. 입문 마지막에 배운 게, 가계부의 시동 버튼이 된 거예요. 자, 네 명령이 다 모였어요. 이제 돌려 봐요.

---

## 8. 25~30분 — 실행과 검증

드디어 돌려 볼 시간이에요. 마지막 5분, 본인이 만든 가계부가 진짜 도는지 봐요.

```bash
$ python3 budget.py add 5000 food --note 점심
✅ 추가: 5000 food (2026-04-30)

$ python3 budget.py add 3000 transport
✅ 추가: 3000 transport (2026-04-30)

$ python3 budget.py list
                     가계부 (2건)
┏━━━━┳━━━━━━━━━━━━┳━━━━━━━━━━━┳━━━━━━━┳━━━━━━┓
┃ ID ┃ 날짜       ┃ 카테고리  ┃   금액 ┃ 메모 ┃
┡━━━━╇━━━━━━━━━━━━╇━━━━━━━━━━━╇━━━━━━━╇━━━━━━┩
│  2 │ 2026-04-30 │ transport │ 3,000 │      │
│  1 │ 2026-04-30 │ food      │ 5,000 │ 점심 │
└────┴────────────┴───────────┴───────┴──────┘

$ python3 budget.py summary
$ python3 budget.py chart
```

`add 5000 food --note 점심`을 치면 초록색 "✅ 추가" 메시지가 떠요. `add 3000 transport`도 하나 더 넣고요. 그리고 `list`를 치면, 보세요, 예쁜 표가 떠요. 본인이 방금 넣은 두 지출이 표로 나오죠. ID도 자동으로 1, 2가 붙었고요. 금액엔 콤마도 찍혔어요. `summary`를 치면 카테고리별 합계가, `chart`를 치면 막대 그래프가 떠요.

이 순간이에요. 본인이 만든 도구가 진짜로 도는 순간. 30분 전엔 빈 파일이었는데, 지금 본인 손에 도는 가계부가 있어요. 어때요, 짜릿하죠? H1에서 말한 그 짜릿함이 바로 이거예요. 이게 예제를 따라 친 거랑은 차원이 다르죠. 본인이 명령을 설계하고, 도구를 이어 붙이고, 돌려서 결과를 본 거니까요. 본인은 방금 "도구를 만드는 사람"이 됐어요.

그리고 검증하는 습관도 봐 두세요. 만들고 끝이 아니라, 실제로 명령을 쳐서 "되는지" 확인하는 거요. add가 되는지, list에 나오는지, 합계가 맞는지요. Ch014에서 배운 "만들면 검증한다"가 여기서도 통해요. 작은 도구라도 돌려 보고 확인하는 거예요. 혹시 안 되면? 에러 메시지를 읽으세요. 대개 오타나 들여쓰기예요. Ch008에서 배운 디버깅이죠. 라이브 코딩이 한 번에 되는 일은 드물어요. 막히고 고치는 게 정상이에요. 그 과정에서 더 배워요.

100줄이 안 되는 코드로, 본인은 진짜 쓸 만한 가계부를 만들었어요. 이게 졸업 작품의 첫 완성이에요. 오늘부터 이걸 매일 쓰면 돼요.

여기서 `--help`도 한 번 쳐 보세요. `python3 budget.py --help`를 치면, 본인이 만든 네 명령(add·list·summary·chart)이 설명과 함께 쫙 떠요. 본인은 도움말을 따로 안 짰는데도요. typer가 함수 이름과 독스트링을 읽어 자동으로 만들어 준 거예요(H2). `python3 budget.py add --help`를 치면 add의 인자·옵션 설명까지 나오고요. 본인 도구가 벌써 "사용 설명서를 갖춘 도구"가 된 거예요. 이게 typer를 쓰는 큰 이득이에요. 공짜로 친절한 도구가 생기는 거죠. 한 달 뒤 쓰는 법을 까먹어도, `--help`만 치면 되니까요.

그리고 이 가계부를 진짜 본인 명령어로 만들고 싶으면, H3에서 본 pyproject.toml의 `[project.scripts]`에 등록하고 `pip install -e .`하면 돼요. 그러면 `python3 budget.py add`가 아니라 그냥 `vigilante-budget add`로 부를 수 있어요. 어느 폴더에서든요. 오늘은 빠른 데모라 `python3 budget.py`로 했지만, 본인 도구로 정착시킬 땐 그 한 단계를 더하면 진짜 명령어가 됩니다. Ch013·Ch014에서 배운 패키지·환경이 그 마지막 한 끗을 채워 주는 거예요. 입문의 마지막 두 챕터가, 가계부를 진짜 도구로 완성하는 데 쓰이는 거죠.

---

## 9. 다섯 사고와 처방

가계부를 돌리다 만날 다섯 사고를, 처방과 함께 정리할게요.

**사고 1: DB 파일 권한 문제로 저장이 안 된다.** 처방 — DB를 홈 폴더(`~/.vigilante-budget.db`)에 두세요. 본인 폴더라 권한 문제가 없어요. 코드에서 `Path.home()`을 쓴 게 그래서예요.

**사고 2: 이상한 입력으로 SQL이 깨질까 걱정된다.** 처방 — `?` 파라미터 바인딩이요. 코드의 모든 INSERT·SELECT에서 값을 `?`로 넘겼죠. 그래서 안전해요.

**사고 3: 날짜 형식이 제각각이라 헷갈린다.** 처방 — 오늘 데모는 `date.today()`로 오늘 날짜를 자동으로 넣었어요. 다양한 형식을 받고 싶으면, H3에서 본 dateutil의 parser를 더하면 돼요.

**사고 4: 카테고리 오타로 통계가 갈라진다.** 처방 — food와 Food가 따로 세어지지 않게, 입력을 소문자로 통일하거나 카테고리를 정해 두세요. Ch011의 입력 검증이에요.

**사고 5: 데이터가 날아갈까 무섭다.** 처방 — 매주 backup이요. DB 파일 하나만 복사하면 되니 쉬워요. 다음 H6에서 자동 백업을 깊이 볼게요.

이 다섯 사고를 미리 알면, 가계부를 안심하고 쓸 수 있어요. 특히 사고 1(권한)과 사고 5(손실)는 실제로 자주 겪어요. 그래서 코드에서 DB를 홈에 두고, 백업을 권하는 거예요. 좋은 도구는 이런 사고를 미리 막아 둔 도구예요. 그리고 본인이 오늘 짠 코드는 사고 1·2는 이미 막아 뒀어요. DB를 홈에 두고(사고1), `?` 바인딩을 썼으니까요(사고2). 사고 3·4·5는 본인이 키우면서 더하면 되고요. 처음부터 모든 사고를 막을 순 없지만, 흔한 둘은 처음부터 막아 둔 거예요. 그게 오늘 코드가 작아도 야무진 이유예요.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 100줄로는 부족하다, 진짜 가계부는 수천 줄이다.**

아니에요. 네 명령(add·list·summary·chart)이면 가계부의 핵심이 다 돌아요. 100줄이 적은 게 아니라, 도구를 잘 조합해서 적은 거예요.

**오해 2: DB를 쓰려면 ORM 같은 큰 도구가 필요하다.**

아니에요. 작은 프로젝트는 raw SQL(직접 SQL 쓰기)이 더 단순하고 빨라요. ORM은 큰 프로젝트에서 쓰는 거고요. 가계부엔 sqlite3에 SQL 직접 쓰는 게 딱이에요.

**오해 3: 한 파일에 다 넣으면 안 된다.**

아니에요. 100줄 정도는 한 파일이 편해요. 200줄을 넘어 복잡해지면, 그때 Ch013에서 배운 대로 모듈로 나누면 돼요. 작을 땐 한 파일, 커지면 분리. 작게 시작해 키우는 거죠.

**오해 4: typer의 Argument와 Option은 어렵다.**

아니에요. 인자는 Argument, 옵션은 Option. H2에서 배운 그 구분이에요. 필수면 Argument, 선택이면 Option이요. 한 번 잡으면 쉬워요.

**오해 5: chart는 보여주기용이라 의미 없다.**

아니에요. 한 달 지출을 그래프로 보면 소비 습관이 한눈에 보여요. 매월 한 번 chart로 돌아보는 게 가계부 쓰는 보람이에요.

---

## 11. 흔한 실수 다섯 + 안심 — 데모 편

첫째, 100줄이 부족하다며 처음부터 거창하게 만들려는 실수예요. 안심하세요 — 네 명령이면 충분하고, 나머진 쓰면서 더하면 됩니다.

둘째, DB를 쓰려고 ORM부터 배우려는 실수예요. 안심하세요 — 가계부엔 raw SQL이 더 단순하고 빠릅니다.

셋째, 코드가 길어질까 봐 처음부터 여러 파일로 쪼개는 실수예요. 안심하세요 — 100줄은 한 파일이 편하고, 200줄 넘으면 그때 나누면 됩니다.

넷째, Argument와 Option을 헷갈려 멈추는 실수예요. 안심하세요 — 필수는 Argument(위치), 선택은 Option(`--키워드`). H2에서 배웠어요.

다섯째, 가장 큰 — 데이터 손실이 무서워 가계부를 못 쓰는 실수예요. 안심하세요 — 매주 DB 파일 하나 복사하면 백업이고, H6에서 자동화합니다.

이 다섯 함정을 미리 알아 둔 본인은, 가계부를 자신 있게 만들고 씁니다. 오늘 100줄로 첫 도구를 완성했으니까요.

---

## 12. 마무리 — 본인의 첫 도구가 돌다

자, 다섯 번째 시간이 끝났어요. 그리고 본인 손에 진짜 도구가 생겼어요.

오늘 30분 만에, 100줄 미만으로, 도는 가계부를 만들었어요. add(추가)·list(목록)·summary(합계)·chart(차트) 네 명령으로요. 셋업(H3)·메뉴판(H4)을 미리 갖춰 둔 덕에, 오늘은 막힘없이 만들었죠. typer가 명령을 받고, sqlite3가 저장하고, rich가 그리고, plotext가 차트를 띄웠어요. 본인은 그 넷을 지휘했고요.

오늘 가장 기억할 한 가지는 이거예요. **본인은 이제 도구를 만드는 사람이다.** 30분 전엔 빈 파일이었는데, 지금은 매일 쓸 가계부가 있어요. 이게 입문에서 조각을 배운 본인이, 그 조각으로 작품을 만든 첫 순간이에요. "할 수 있다"가 "만들었다"로 바뀐 거죠. 이 경험이 본인을 진짜 개발자로 만들어요.

다음 H6은 운영이에요. 오늘 만든 가계부를 튼튼하게 다듬어요. 데이터를 자동으로 백업하고, 여러 기기에 동기화하고, 망가졌을 때 복구하는 법을요. 만드는 것과 오래 쓰는 건 다르거든요. 오늘 만들었으니, 다음엔 오래 쓰게 다듬는 거예요. 오늘 가계부는 돌긴 하지만, 아직 데이터를 지키는 장치가 없어요. 며칠 쓴 소중한 기록이 실수 한 번에 날아갈 수 있죠. H6에서 그 약점을 메워, 안심하고 오래 쓸 도구로 만들 거예요. 만들기는 끝났고, 이제 지키기 차례예요.

숙제는 즐거워요. 오늘 만든 가계부를, 오늘부터 진짜로 쓰세요. 점심 먹고 `add`, 저녁에 `list`. 며칠 써 보면 "아, 이 기능이 있으면 좋겠다" 싶은 게 떠올라요. 그게 본인만의 가계부를 키우는 씨앗이에요. 그리고 가능하면, 강의를 안 보고 add 명령 하나를 기억만으로 다시 짜 보세요. 손에 붙었는지 확인하는 거예요. 다음 시간에 만나요. 🐾

```bash
python3 budget.py --help
```

---

## 👨‍💻 개발자 노트

> - **30분 6단계**: 셋업(venv)→DB(get_db)→add→list→summary·chart→실행·검증.
> - **네 명령**: add(INSERT)·list(SELECT+WHERE)·summary(GROUP BY)·chart(GROUP BY+plotext).
> - **get_db**: `CREATE TABLE IF NOT EXISTS`로 자동 초기화. `row_factory = Row`로 이름 접근.
> - **add**: Argument(필수)·Option(선택)·`when or date.today()`·`?` 바인딩·rich 마크업.
> - **list**: `WHERE 1=1` + 조건부 AND·`LIKE ?`로 월 필터·`:,` 천 단위·`or ""`.
> - **입문 회수**: import 정렬(Ch013)·`or`(Ch008)·컴프리헨션(Ch008)·f-string `:,`(Ch011)·`if __name__`(Ch013).
> - **DB 위치**: `Path.home()/.vigilante-budget.db`. 데이터는 임시폴더 아닌 홈에.
> - 다음 H6 키워드: 백업 자동화·sync·복구·검증·cron.

---

## 추신

1. 오늘은 30분 만에 진짜 도는 가계부를 만들었어요. 이 챕터의 하이라이트죠.
2. 약속대로, 본인 손에 매일 쓸 도구가 생겼어요. 예제가 아니라 진짜 도구예요.
3. 네 명령: add(추가)·list(목록)·summary(합계)·chart(차트).
4. 100줄도 안 돼요. 본인이 도구를 이어 붙인 연결선이 100줄이에요.
5. 6단계 5분씩: 셋업→DB→add→list→summary·chart→실행·검증.
6. 셋업은 H3에서 연습한 그대로. 미리 갖춰 둔 게 빛나요.
7. get_db는 `CREATE TABLE IF NOT EXISTS`로 자동 초기화해요. 친절하죠.
8. DB는 홈 폴더에 둬요. 작업 폴더는 임시여도, 데이터는 오래 남아야죠.
9. `row_factory = Row`로 `r["amount"]`처럼 이름으로 꺼내요. 읽기 좋죠.
10. add가 가계부의 심장이에요. 지출을 기록하는 거니까요.
11. amount·category는 Argument(필수), note·when은 Option(선택). H2 구분이에요.
12. `when or date.today()`는 날짜를 안 주면 오늘로. Ch008 `or` 응용이죠.
13. INSERT는 `?`로 값을 넘겨요. 안전(인젝션 방지)을 위해서예요.
14. commit 꼭 하기. 안 하면 저장이 안 돼요.
15. `[green]...[/green]`으로 초록 성공 메시지. rich 마크업이에요(H2).
16. list는 두 부분: SQL로 가져오고, rich로 그려요. 입력/출력 분리죠.
17. `WHERE 1=1`은 조건을 AND로 이어 붙이기 편한 trick이에요.
18. `date LIKE '2026-04%'`로 4월 전체를 걸러요. `%`는 "아무거나".
19. `f"{amount:,}"`로 5000을 5,000으로. Ch011 문자열 포맷이에요.
20. summary는 `GROUP BY category`로 카테고리별 합계. Ch010 Counter의 SQL판.
21. chart는 같은 GROUP BY + plotext. 컴프리헨션으로 값을 뽑아요(Ch008).
22. `if __name__ == "__main__"`이 가계부의 시동 버튼. Ch013에서 배웠죠.
23. 만들면 돌려서 검증해요. add 되는지, list에 뜨는지, 합계 맞는지.
24. 라이브 코딩은 한 번에 안 돼요. 막히고 고치는 게 정상이에요.
25. 안 되면 에러 메시지를 읽어요. 대개 오타나 들여쓰기예요(Ch008 디버깅).
26. 작은 프로젝트는 raw SQL이 ORM보다 단순하고 빨라요.
27. 100줄은 한 파일이 편해요. 200줄 넘으면 모듈로 나눠요(Ch013).
28. 이 순간이 짜릿함. 빈 파일이 30분 만에 도는 도구가 됐어요.
29. 숙제: 오늘 만든 가계부를 오늘부터 진짜로 쓰세요. add·list로요.
30. 본인은 이제 도구를 만드는 사람이에요. 다음 H6은 운영. 다음 시간에 만나요. 🐾
