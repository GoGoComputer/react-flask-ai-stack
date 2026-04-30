# Ch015 · H2 — CLI 4 단어 깊이 — argparse·click·typer·rich

> 고양이 자경단 · Ch 015 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. argparse 깊이
3. click 깊이
4. typer 깊이
5. rich 깊이
6. 자경단 표준 — typer + rich
7. 한 줄 분해
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요.

지난 H1 회수. 네 친구.

이번 H2는 4 단어 깊이.

오늘의 약속. **본인이 4 라이브러리를 비교해서 선택할 수 있습니다**.

자, 가요.

---

## 2. argparse 깊이

표준 라이브러리. 외부 의존성 없음.

```python
import argparse

def main():
    parser = argparse.ArgumentParser(description="가계부")
    
    # 서브커맨드
    subparsers = parser.add_subparsers(dest="command")
    
    # add
    add = subparsers.add_parser("add")
    add.add_argument("amount", type=int)
    add.add_argument("category")
    add.add_argument("--note", default="")
    
    # list
    list_p = subparsers.add_parser("list")
    list_p.add_argument("--month", default="all")
    
    args = parser.parse_args()
    
    if args.command == "add":
        print(f"추가: {args.amount} {args.category}")
    elif args.command == "list":
        print(f"목록: {args.month}")

if __name__ == "__main__":
    main()
```

```bash
$ python3 cli.py add 5000 food
$ python3 cli.py list --month 2026-04
```

장점 — stdlib. 단점 — boilerplate 많음.

---

## 3. click 깊이

```python
import click

@click.group()
def cli():
    """자경단 가계부."""
    pass

@cli.command()
@click.argument("amount", type=int)
@click.argument("category")
@click.option("--note", default="")
def add(amount, category, note):
    """가계부 추가."""
    click.echo(f"추가: {amount} {category}")

@cli.command()
@click.option("--month", default="all")
def list(month):
    """목록."""
    click.echo(f"목록: {month}")

if __name__ == "__main__":
    cli()
```

decorator 기반. argparse보다 짧고 명료.

---

## 4. typer 깊이

```python
import typer

app = typer.Typer(help="자경단 가계부")

@app.command()
def add(
    amount: int,
    category: str,
    note: str = "",
):
    """가계부 추가."""
    typer.echo(f"추가: {amount} {category}")

@app.command()
def list(month: str = "all"):
    """목록."""
    typer.echo(f"목록: {month}")

if __name__ == "__main__":
    app()
```

type hints만으로 CLI 자동 생성. 자동 도움말, 검증.

자경단 표준.

---

## 5. rich 깊이

```python
from rich.console import Console
from rich.table import Table
from rich.progress import track

console = Console()

# 색깔
console.print("[bold red]ERROR[/bold red]")
console.print("[green]✓ 성공[/green]")

# 테이블
table = Table(title="가계부")
table.add_column("날짜")
table.add_column("금액", justify="right")
table.add_row("2026-04-30", "5,000")
console.print(table)

# 진행률
for i in track(range(100), description="처리..."):
    process(i)
```

자경단 매일.

---

## 6. 자경단 표준 — typer + rich

```python
import typer
from rich import print
from rich.table import Table
from rich.console import Console

app = typer.Typer()
console = Console()

@app.command()
def add(amount: int, category: str):
    """추가."""
    # 저장 로직
    print(f"[green]✅ 추가: {amount} {category}[/green]")

@app.command()
def list():
    """목록."""
    table = Table(title="가계부")
    table.add_column("날짜")
    table.add_column("금액")
    # 데이터 로드
    table.add_row("2026-04-30", "5,000")
    console.print(table)

if __name__ == "__main__":
    app()
```

typer (CLI) + rich (출력) = 자경단 표준.

---

## 7. 한 줄 분해

```python
@app.command()
def cmd(amount: int = typer.Option(..., help="금액"))
```

typer + type hints + Option 메타데이터. 자경단 매일.

---

## 8. 흔한 오해 다섯 가지

**오해 1: argparse만으로 충분.**

작은 CLI는 OK. 큰 건 typer.

**오해 2: click vs typer.**

typer가 modern.

**오해 3: rich production.**

가능. ANSI escape.

**오해 4: 4 라이브러리 다.**

자경단은 typer + rich.

**오해 5: type hints 옵션.**

typer에 필수.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. argparse 언제?**

표준 라이브러리만 쓸 때.

**Q2. click vs typer 진짜 차이?**

typer가 type hints 기반. 더 짧음.

**Q3. rich 의존성?**

가벼움.

**Q4. typer 다국어?**

지원. help 메시지.

**Q5. CLI 배포?**

pyproject.toml의 scripts.

---

## 10. 흔한 실수 다섯 + 안심 — 핵심 학습 편

첫째, argparse만 매일. 안심 — 작은 거 OK, 큰 건 typer.
둘째, click vs typer 헷갈림. 안심 — typer modern.
셋째, rich production 위험. 안심 — ANSI 표준.
넷째, 4 라이브러리 다. 안심 — typer + rich.
다섯째, 가장 큰 — type hints 옵션. 안심 — typer 필수.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 두 번째 시간 끝.

argparse, click, typer, rich 깊이. 자경단 표준 typer + rich.

다음 H3는 5 도구 환경.

```bash
pip install typer rich
```

---

## 👨‍💻 개발자 노트

> - argparse: stdlib, 모든 Python.
> - click: 8 결국 PyPI 1위 CLI.
> - typer: FastAPI 동일 저자, type hints 기반.
> - rich: ANSI escape, Markdown, Syntax 지원.
> - prompt_toolkit: 고급 prompt.
> - 다음 H3 키워드: typer · rich · sqlite3 · plotext · 5 환경.
