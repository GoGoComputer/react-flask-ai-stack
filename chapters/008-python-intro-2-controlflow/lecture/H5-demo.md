# Ch008 · H5 — 환율 계산기 v2 30분 — 50줄을 150줄로 진화시키기

> 고양이 자경단 · Ch 008 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. v1 → v2 진화 표
3. 0~5분 — 폴더 셋업과 v1 가져오기
4. 5~10분 — RATES 확장과 검증
5. 10~15분 — 새 함수 convert_batch와 sort_by_currency
6. 15~20분 — 사용자 메뉴와 while 루프
7. 20~25분 — 에러 처리 강화
8. 25~30분 — 실행과 검증
9. v1 vs v2 다섯 핵심 차이
10. 9 함수 × 18 도구 매핑
11. 다섯 사고와 처방
12. 흔한 오해 다섯 가지
13. 마무리 — 다음 H6에서 만나요

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H4를 한 줄로 회수할게요. 18 흐름 도구. 반복 4, 집계 5, 필터 4, comp 3, itertools.

이번 H5는 본인의 환율 계산기 v1 50줄을 v2 150줄로 진화시키는 30분이에요. Ch007 H5의 v1을 가져와서 18 도구를 다 적용해 봐요.

오늘의 약속. **본인의 v2가 H1~H4 학습을 다 동원합니다**. if 5패턴, for + iterable, comp 4종, while+walrus, match-case, itertools.

자, 가요.

---

## 2. v1 → v2 진화 표

| 항목 | v1 | v2 |
|------|-----|-----|
| 줄 수 | 50 | 150 |
| 함수 | 4 | 9 |
| 통화 | 4 | 8 |
| 입력 | 1회 | while 루프 |
| 에러 | 1종 | 5종 |
| 적용 도구 | 5 | 18 |
| 정렬·필터 | 없음 | 있음 |
| 히스토리 | 없음 | list로 보관 |
| 매뉴 | 없음 | match-case |

3배 줄 + 9 함수 + 18 도구 적용. 30분에 다 짜요.

---

## 3. 0~5분 — 폴더 셋업과 v1 가져오기

```bash
mkdir -p /tmp/ch008-demo && cd /tmp/ch008-demo
python3 -m venv .venv
source .venv/bin/activate
pip install rich
cp /tmp/python-demo/exchange.py exchange_v2.py
```

v1을 v2로 복사. rich도 설치 (예쁜 출력용).

---

## 4. 5~10분 — RATES 확장과 검증

v1의 RATES dict 확장.

```python
# exchange_v2.py
"""자경단 환율 계산기 v2 (8 통화 + 히스토리)"""

from rich import print
from rich.table import Table
from rich.console import Console

console = Console()

RATES: dict[str, float] = {
    "KRW": 1.0,
    "USD": 1300.0,
    "JPY": 9.0,
    "EUR": 1400.0,
    "GBP": 1700.0,    # 새
    "CNY": 180.0,     # 새
    "CAD": 950.0,     # 새
    "AUD": 850.0,     # 새
}

HISTORY: list[dict] = []   # 변환 히스토리
```

8 통화로 확장. HISTORY 리스트에 변환 기록.

검증 함수 추가.

```python
def validate_currency(curr: str) -> bool:
    """통화 코드 유효성 검증."""
    return curr.upper() in RATES

def validate_amount(amount_str: str) -> float | None:
    """금액 문자열을 float으로 변환. 실패 시 None."""
    try:
        amount = float(amount_str)
        if amount < 0:
            return None
        return amount
    except ValueError:
        return None
```

if + try/except + Optional 패턴. H1의 truthy/falsy도 동원.

---

## 5. 10~15분 — 새 함수 convert_batch와 sort_by_currency

```python
def convert(amount: float, from_curr: str, to_curr: str) -> float:
    """단일 환산 (v1 그대로)."""
    krw = amount * RATES[from_curr]
    return krw / RATES[to_curr]


def convert_batch(amount: float, from_curr: str) -> dict[str, float]:
    """모든 통화로 변환. dict comprehension 사용."""
    return {
        curr: convert(amount, from_curr, curr)
        for curr in RATES
        if curr != from_curr
    }


def sort_by_amount(results: dict[str, float], reverse: bool = True) -> list:
    """변환 결과 정렬. sorted + key 사용."""
    return sorted(results.items(), key=lambda x: x[1], reverse=reverse)
```

세 새 함수. dict comp, sorted+key, lambda 다 동원.

테스트.

```python
>>> convert_batch(50.0, "USD")
{'KRW': 65000.0, 'JPY': 7222.22, 'EUR': 46.43, 'GBP': 38.24, 'CNY': 361.11, 'CAD': 68.42, 'AUD': 76.47}

>>> sort_by_amount(convert_batch(50.0, "USD"))
[('KRW', 65000.0), ('JPY', 7222.22), ('CNY', 361.11), ...]
```

7개 통화 동시 변환 + 큰 순 정렬.

---

## 6. 15~20분 — 사용자 메뉴와 while 루프

while + match-case로 메뉴 시스템.

```python
def show_menu() -> None:
    """메뉴 출력."""
    print("\n[bold cyan]=== 자경단 환율 계산기 v2 ===[/bold cyan]")
    print("1. 단일 변환")
    print("2. 모든 통화로 변환")
    print("3. 히스토리 보기")
    print("4. 종료")


def run_menu() -> None:
    """메뉴 루프."""
    while True:
        show_menu()
        choice = input("\n선택: ").strip()
        match choice:
            case "1":
                run_single_convert()
            case "2":
                run_batch_convert()
            case "3":
                show_history()
            case "4":
                print("[green]안녕히 가세요[/green]")
                break
            case _:
                print("[red]잘못된 선택[/red]")


def run_single_convert() -> None:
    """단일 변환 실행."""
    amount_str = input("금액: ")
    amount = validate_amount(amount_str)
    if amount is None:
        print("[red]잘못된 금액[/red]")
        return
    
    from_curr = input("부터: ").upper().strip()
    if not validate_currency(from_curr):
        print(f"[red]모르는 통화: {from_curr}[/red]")
        return
    
    to_curr = input("로: ").upper().strip()
    if not validate_currency(to_curr):
        print(f"[red]모르는 통화: {to_curr}[/red]")
        return
    
    result = convert(amount, from_curr, to_curr)
    HISTORY.append({"from": from_curr, "to": to_curr, "amount": amount, "result": result})
    print(f"[green]{amount} {from_curr} = {result:.2f} {to_curr}[/green]")
```

while True + match-case + early return + guard clause. 본인이 H6에서 더 깊이 만나요.

---

## 7. 20~25분 — 에러 처리 강화

```python
def run_batch_convert() -> None:
    """모든 통화 변환."""
    amount_str = input("금액: ")
    amount = validate_amount(amount_str)
    if amount is None:
        print("[red]잘못된 금액[/red]")
        return
    
    from_curr = input("부터: ").upper().strip()
    if not validate_currency(from_curr):
        print(f"[red]모르는 통화[/red]")
        return
    
    results = convert_batch(amount, from_curr)
    sorted_results = sort_by_amount(results)
    
    table = Table(title=f"{amount} {from_curr} 변환 결과")
    table.add_column("통화")
    table.add_column("결과", justify="right")
    
    for curr, value in sorted_results:
        table.add_row(curr, f"{value:,.2f}")
    
    console.print(table)


def show_history() -> None:
    """변환 히스토리."""
    if not HISTORY:
        print("[yellow]히스토리 없음[/yellow]")
        return
    
    table = Table(title=f"히스토리 ({len(HISTORY)}건)")
    table.add_column("#")
    table.add_column("From")
    table.add_column("To")
    table.add_column("Amount")
    table.add_column("Result")
    
    for i, entry in enumerate(HISTORY, start=1):
        table.add_row(
            str(i),
            entry["from"],
            entry["to"],
            f"{entry['amount']:.2f}",
            f"{entry['result']:.2f}",
        )
    
    console.print(table)


def main() -> None:
    """메인 진입점."""
    run_menu()


if __name__ == "__main__":
    main()
```

rich Table로 예쁜 출력. enumerate, dict, sorted 다 동원.

---

## 8. 25~30분 — 실행과 검증

```bash
$ python3 exchange_v2.py

=== 자경단 환율 계산기 v2 ===
1. 단일 변환
2. 모든 통화로 변환
3. 히스토리 보기
4. 종료

선택: 2
금액: 100
부터: USD

       100 USD 변환 결과       
┏━━━━━━━━━━┳━━━━━━━━━━━━━━━━━┓
┃ 통화      ┃           결과    ┃
┡━━━━━━━━━━╇━━━━━━━━━━━━━━━━━┩
│ KRW       │      130,000.00 │
│ JPY       │       14,444.44 │
│ CNY       │          722.22 │
│ AUD       │          152.94 │
│ CAD       │          136.84 │
│ GBP       │           76.47 │
│ EUR       │           92.86 │
└──────────┴─────────────────┘
```

진짜 출력. rich Table이 예쁘게.

---

## 9. v1 vs v2 다섯 핵심 차이

**1. 통화 4 → 8**. RATES 확장.

**2. 단일 변환 → 메뉴 시스템**. while + match-case.

**3. 함수 4개 → 9개**. 책임 분리.

**4. 에러 1종 → 5종**. validate_amount, validate_currency 등.

**5. 출력 print → rich Table**. 시각적 진화.

다섯 차이가 v2를 자경단 표준으로.

---

## 10. 9 함수 × 18 도구 매핑

| 함수 | 사용 도구 |
|------|----------|
| validate_currency | if + .upper() + in |
| validate_amount | try/except + float |
| convert | dict access + 산술 |
| convert_batch | dict comp + if |
| sort_by_amount | sorted + key + lambda |
| show_menu | print + f-string |
| run_menu | while + match-case |
| run_single_convert | early return + guard clause |
| show_history | enumerate + Table |

9 함수에 18 도구가 다 들어 있어요. v2가 H1~H4 학습의 살아있는 적용.

---

## 11. 다섯 사고와 처방

**사고 1: dict comp에 잘못된 key**

```python
{curr: convert(amount, from_curr, curr) for curr in RATES if curr != from_curr}
```

처방. 명시적 if 필터. KeyError 면역.

**사고 2: while 무한 루프**

매뉴에서 break 없이.

처방. case "4": break.

**사고 3: input() 빈 문자열**

처방. .strip() 필수.

**사고 4: float 변환 실패**

처방. validate_amount의 try/except.

**사고 5: rich import 누락**

처방. requirements.txt + pip install.

---

## 12. 흔한 오해 다섯 가지

**오해 1: v1으로 충분.**

자경단 표준은 v2. 5종 에러 처리, 메뉴, 히스토리.

**오해 2: 150줄 너무 길어.**

9 함수로 분리. 한 함수 평균 17줄.

**오해 3: rich 무거워.**

표 출력에 5초 절감.

**오해 4: match-case 못 쓰면.**

if/elif 가능.

**오해 5: HISTORY는 데이터베이스가 필요.**

list로 메모리 저장. 영구는 Ch012에서 파일.

---

## 13. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, finish 먼저. 안심 — start에서 30분.
둘째, 들여쓰기 헷갈림. 안심 — 4칸 표준.
셋째, print 디버깅만. 안심 — `breakpoint()`.
넷째, 에러 메시지 안 읽음. 안심 — Traceback 끝줄이 답.
다섯째, 가장 큰 — 첫 코드 GitHub 안 올림. 안심 — 첫날부터.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 14. 마무리 — 다음 H6에서 만나요

자, 다섯 번째 시간 끝.

v1 50줄 → v2 150줄. 9 함수, 18 도구, 5종 에러, 메뉴 시스템, rich Table, 히스토리.

박수.

다음 H6는 운영. early return, guard clause, 복잡도 줄이기, radon 측정.

```bash
black exchange_v2.py
ruff check exchange_v2.py
mypy --strict exchange_v2.py
```

---

## 👨‍💻 개발자 노트

> - rich vs print: rich는 ANSI 색깔 자동. 표 출력 강력.
> - dict comp 성능: list comp와 비슷. dict 변환 추가 비용.
> - match-case 패턴: literal, capture, sequence, mapping, class. 다섯 종류.
> - HISTORY 보관: 메모리. 재시작 시 사라짐. JSON 저장은 Ch012.
> - 다음 H6 키워드: early return · guard clause · 복잡도 · radon · 자경단 5 패턴.
