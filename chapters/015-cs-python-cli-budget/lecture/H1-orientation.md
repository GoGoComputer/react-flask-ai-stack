# Ch015 · H1 — CLI 가계부 오리엔테이션 — 본인의 첫 실전 도구

> 고양이 자경단 · Ch 015 · 1교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — Ch014 회수와 오늘의 약속
2. CLI 가계부가 무엇인가
3. 옛날 이야기 — 첫 CLI를 짠 그 날
4. 왜 CLI 가계부인가 — 일곱 가지 이유
5. 같이 쳐 보기 — 5줄 CLI
6. 네 친구 — argparse·click·typer·rich
7. 가계부 화면 미리보기
8. 자경단 다섯 명의 매일 CLI
9. 8교시 미리보기
10. CLI 50년
11. AI 시대의 CLI
12. 자주 받는 질문 다섯 가지
13. 흔한 오해 다섯 가지
14. 마무리

---

## 1. 다시 만나서 반가워요 — Ch014 회수와 오늘의 약속

자, 안녕하세요. 마지막 챕터예요. 15번째.

지난 Ch014 회수. venv, pip, pyproject, uv. 100% 자동 dev 환경.

이번 Ch015는 본 두 해 코스 1년차의 마지막. CS + Python 통합 첫 실전 도구. CLI 가계부.

오늘의 약속. **본인이 자기 가계부 CLI 도구를 만들어 매일 사용합니다**.

자, 가요.

---

## 2. CLI 가계부가 무엇인가

CLI는 Command Line Interface. 셸에서 명령어로 사용하는 도구.

```bash
$ vigilante-budget add --amount 5000 --category food
✅ 추가됨

$ vigilante-budget list
2026-04-30  food   5000
2026-04-29  food   3000

$ vigilante-budget summary
food: 8,000
total: 8,000
```

본인의 매일 가계부. Excel 대신 CLI. 5초에 추가.

---

## 3. 옛날 이야기 — 첫 CLI를 짠 그 날

옛날 이야기. 12년 전.

저는 매일 가계부를 종이에 적었어요. 한 달 후 정리할 때 1시간. 사수 형이 보고 "Python으로 만들어" 한 줄.

저는 첫 CLI를 짰어요. argparse 학습. 200줄 코드. 한 달 후 매일 가계부 정리가 5초. 1시간 → 5초.

그 CLI를 5년 사용했어요. 아직도 매일 켜요. 본인도 8시간 후 같아요.

---

## 4. 왜 CLI 가계부인가 — 일곱 가지 이유

**1. 본 챕터 1년차 통합**. CS + Python 모두.

**2. 매일 사용**. 본인 가계부.

**3. 모든 기술 동원**. file I/O, dict, regex, click.

**4. CLI 표준**. 모든 dev 도구가 CLI.

**5. SQLite**. 가벼운 DB.

**6. 시각화**. plotext로 터미널 차트.

**7. 자경단 적용**. 5명이 각자 가계부.

일곱.

---

## 5. 같이 쳐 보기 — 5줄 CLI

```python
# mini_cli.py
import click

@click.command()
@click.option("--name", default="자경단")
def hello(name):
    click.echo(f"안녕 {name}!")

hello()
```

```bash
$ python3 mini_cli.py --name 까미
안녕 까미!
```

5줄에 CLI 기본.

---

## 6. 네 친구 — argparse·click·typer·rich

**argparse**. 표준 라이브러리. 외부 의존성 없음.

**click**. 인기 CLI 라이브러리. decorator 기반.

**typer**. modern. type hints 기반. FastAPI 만든 사람.

**rich**. 예쁜 출력.

자경단 표준 — typer + rich.

---

## 7. 가계부 화면 미리보기

```bash
$ vigilante-budget add 5000 food --note "점심"
✅ 추가됨

$ vigilante-budget list --month 2026-04
        2026년 4월 가계부        
┏━━━━━━━━━━━━┳━━━━━━━┳━━━━━━━┓
┃ 날짜        ┃ 카테고리 ┃ 금액   ┃
┡━━━━━━━━━━━━╇━━━━━━━╇━━━━━━━┩
│ 2026-04-30 │ food   │ 5,000 │
│ 2026-04-29 │ food   │ 3,000 │
│ 2026-04-28 │ tax    │ 8,000 │
└────────────┴───────┴───────┘

$ vigilante-budget chart
food  ████████ 8,000
tax   ████     8,000
```

rich Table + plotext 차트. 본인이 짤 화면.

---

## 8. 자경단 다섯 명의 매일 CLI

다섯 명 다 자기 가계부 CLI. 매일 5분 정리.

---

## 9. 8교시 미리보기

H2 — 4 단어 깊이.

H3 — 5 도구 환경.

H4 — 30+ 명령 카탈로그.

H5 — vigilante-budget 100줄 데모.

H6 — 운영. 백업, sync, 복구.

H7 — 깊이. SQLite 내부.

H8 — 1년차 마무리, 2년차 다리.

---

## 10. CLI 50년

1971년. Unix shell.

1989년. argparse 비슷 (getopt).

2003년. argparse Python 표준.

2014년. click.

2019년. typer.

2024년. AI 통합 (Warp, etc).

---

## 11. AI 시대의 CLI

AI한테 "이 CLI 도구 만들어" 한 줄. typer + rich 자동 추천.

자경단 80/20.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. argparse vs click?**

작은 거 argparse, 큰 거 click/typer.

**Q2. typer vs click?**

typer가 modern.

**Q3. SQLite 진짜?**

가벼운 DB 표준.

**Q4. CLI vs GUI?**

CLI 빠름.

**Q5. 8시간 길어요.**

본인의 첫 실전 도구.

---

## 13. 흔한 오해 다섯 가지

**오해 1: CLI 옛 도구.**

매일 사용.

**오해 2: 가계부는 Excel.**

CLI가 빠름.

**오해 3: SQLite 한계.**

100MB까지 충분.

**오해 4: 차트는 GUI만.**

plotext로 터미널.

**오해 5: typer 어렵다.**

type hints 알면 쉬움.

---

## 14. 흔한 실수 다섯 + 안심 — CLI 첫 학습 편

첫째, CLI 옛 도구. 안심 — dev 매일.
둘째, Excel 더 편함. 안심 — CLI 5초.
셋째, SQLite 한계 가정. 안심 — 100MB 충분.
넷째, typer 어렵다. 안심 — type hints만 알면.
다섯째, 가장 큰 — 차트 GUI만. 안심 — plotext 터미널.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 15. 마무리

자, 첫 시간 끝.

네 친구 — argparse, click, typer, rich. 본인의 첫 실전 도구.

다음 H2는 깊이.

```python
pip install typer rich
```

---

## 👨‍💻 개발자 노트

> - argparse: stdlib. 표준.
> - click: decorator 기반.
> - typer: type hints. FastAPI 동일 저자.
> - rich: 색깔 + Table.
> - SQLite: file-based, 트랜잭션.
> - 다음 H2 키워드: argparse · click · typer · rich · 4 도구 깊이.
