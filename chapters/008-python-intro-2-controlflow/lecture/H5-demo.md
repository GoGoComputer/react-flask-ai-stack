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

지난 H4를 한 줄로 회수할게요. 18 흐름 도구. 반복 4, 집계 5, 필터 4, comp 3, itertools. 도구 상자를 구경했어요. 오늘은 그 도구로 진짜 물건을 만들어요. 구경에서 제작으로 넘어가는 시간이에요.

이번 H5는 본인의 환율 계산기 v1 50줄을 v2 150줄로 진화시키는 30분이에요. Ch007 H5의 v1을 가져와서 18 도구를 다 적용해 봐요.

오늘의 약속. **본인의 v2가 H1~H4 학습을 다 동원합니다**. if 5패턴, for + iterable, comp 4종, while+walrus, match-case, itertools.

이 시간이 본 챕터에서 가장 신나는 시간이에요. 지금까지 H1~H4는 재료를 모으는 시간이었어요. 네 친구, 8개념, 디버깅 도구, 18 도구. 오늘은 그 재료로 요리를 해요. 그것도 새 요리가 아니라, Ch007에서 만든 환율 계산기를 더 멋지게 키우는 거예요. Ch007 H8에서 "환율 계산기를 버리지 말고 키워 가라"고 했죠. 오늘이 그 첫 진화예요. 본인의 50줄짜리 v1이 150줄짜리 v2로 자라요. 메뉴가 생기고, 8개 통화를 다루고, 히스토리를 기억하게 돼요. 그러니까 가능하면 본인의 Ch007 환율 계산기 파일을 열어 두고 같이 키우세요. 그러면 30분 끝에 본인 손에 진짜로 자란 프로그램이 남아요. 강의를 듣기만 하는 것과, 본인 코드가 눈앞에서 자라는 걸 보는 건 완전히 달라요. 본인 작품이 자라는 그 재미를 한 번 느끼면, 본인은 멈출 수 없게 돼요. 자, 가요.

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

이 표를 보면 v1과 v2의 격차가 한눈에 보여요. 그런데 줄 수가 세 배 늘었다고 어려움이 세 배가 된 건 아니에요. 오히려 v2가 v1보다 더 짜기 쉬울 수 있어요. 왜냐하면 v2는 9개의 작은 함수로 나뉘어 있어서, 본인은 한 번에 한 함수씩 짜면 되거든요. 17줄짜리 함수 하나를 짜는 건 어렵지 않아요. 그걸 9번 반복하는 거예요. 한 함수가 동작하면 다음 함수로. 이렇게 하나씩 쌓으면 150줄이 부담스럽지 않아요. 반대로 150줄을 한 덩어리로 짜려고 하면 머리가 터져요. 그래서 "큰 프로그램을 작은 함수로 나눠서 하나씩"이 핵심이에요. 본인이 오늘 30분에 150줄을 짤 수 있는 비결이 이 분할이에요. 한 입에 안 삼키고, 9입으로 나눠 먹는 거죠. 그리고 각 함수를 짜자마자 테스트해요. convert_batch를 짰으면 바로 REPL에서 `convert_batch(50, "USD")`를 쳐서 동작을 확인해요. 동작하면 다음으로. 이렇게 작게 짜고 자주 확인하면, 사고가 나도 방금 짠 그 함수만 보면 되니까 빨리 잡아요. 작게 나누고, 하나씩 짜고, 자주 확인하기. 이게 큰 프로그램을 두려움 없이 짜는 방법이에요.

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

여기서 본인이 Ch007 H3에서 배운 게 빛나요. 새 프로젝트를 시작할 때 무조건 venv부터죠. `python3 -m venv .venv && source .venv/bin/activate`. 그 다음 필요한 패키지를 깔아요. 여기서는 rich예요. 그리고 v1을 복사해서 v2로 시작해요. 처음부터 새로 짜는 게 아니라, 잘 돌아가는 v1을 가져와서 키우는 거예요. 이게 진짜 개발 방식이에요. 백지에서 시작하는 일은 드물어요. 보통은 있는 걸 가져와서 고치고 더해요. 그러니까 본인의 Ch007 환율 계산기를 복사해서 시작하세요. 잘 돌아가는 토대 위에서 키우는 게, 백지에서 다시 짜는 것보다 빠르고 안전해요. v1이 이미 검증된 토대니까, 본인은 새로 더하는 부분만 신경 쓰면 돼요. 그리고 복사본으로 작업하니까, 실험하다 망쳐도 v1 원본은 안전해요. 이것도 일종의 안전망이에요.

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

여덟 통화로 확장. HISTORY 리스트에 변환 기록을 쌓아요.

여기서 RATES에 type hint가 붙은 걸 보세요. `RATES: dict[str, float]`. "이건 문자열을 키로, 실수를 값으로 하는 딕셔너리"라고 명시했어요. Ch007 H6에서 배운 type hint예요. v1에서는 생략했지만, v2는 더 큰 프로그램이라 타입을 명시해요. 이러면 mypy가 "RATES에 잘못된 타입을 넣으려 하면" 잡아줘요. 그리고 HISTORY도 `list[dict]`로 타입을 줬어요. "딕셔너리들의 리스트"라고요. 이게 코드를 읽는 사람에게 "여기엔 이런 모양의 데이터가 들어간다"를 알려줘요. 변수 이름 옆의 타입 한 줄이 미래의 본인과 동료에게 보내는 안내예요. v2가 v1보다 단단한 이유 중 하나가 이 타입 명시예요. 작은 프로그램은 타입을 생략해도 되지만, 커질수록 타입이 안전망이 돼요. 본인이 환율 계산기를 키우면서 타입도 같이 챙기는 것, 그게 코드를 제품 수준으로 만드는 습관이에요.

RATES 위에 from rich import 세 줄이 보이죠. rich의 print, Table, Console을 가져왔어요. 이게 H3에서 깐 rich예요. import는 항상 파일 맨 위에 모아요(Ch007 PEP 8). console = Console()로 콘솔 객체를 하나 만들어 두고, 표를 그릴 때 써요.

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

이 두 검증 함수가 v2를 v1보다 단단하게 만드는 핵심이에요. v1은 사용자가 이상한 걸 입력하면 그냥 죽었어요. v2는 입력을 먼저 검증해요. validate_currency는 "이 통화가 우리가 아는 통화인가?"를 확인해요. `curr.upper() in RATES`로요. 사용자가 소문자로 "usd"를 치든 "USD"를 치든, upper()로 대문자로 바꿔서 RATES에 있는지 봐요. H2에서 본 정규화예요. validate_amount는 "이게 진짜 숫자이고 음수가 아닌가?"를 확인해요. float() 변환이 실패하면(사용자가 "오십"이라고 치면) try/except가 잡아서 None을 줘요. 그리고 Optional 타입(`float | None`)으로 "성공하면 숫자, 실패하면 None"을 표현해요. H2에서 배운 None의 우아한 활용이에요. 이게 방어적 프로그래밍의 기본 패턴이에요. 사용자 입력을 받자마자 검증하고, 이상하면 친절하게 안내하고, 정상이면 진행. 이 패턴이 v2를 "사용자가 뭘 입력해도 안 죽는" 프로그램으로 만들어요. 본인이 두 해 코스에서 사용자를 받는 모든 프로그램에 이 검증 패턴이 들어가요. 입력의 문 앞에 검증이라는 경비를 세우는 거예요.

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

세 개의 새 함수예요. dict comp, sorted+key, lambda를 다 동원했어요.

이 세 함수에 H4에서 배운 18 도구가 살아 움직여요. convert_batch를 보세요. `{curr: convert(amount, from_curr, curr) for curr in RATES if curr != from_curr}`. 이게 dict comprehension이에요. "RATES의 각 통화 curr에 대해, 출발 통화가 아니면, 그 통화로 환산한 결과를 짝지어 딕셔너리로." 한 줄에 for·if·dict comp가 다 들어가요. v1이었으면 빈 dict 만들고 for 돌면서 하나씩 넣는 여섯 줄이었을 거예요. dict comprehension 한 줄로 줄였어요. sort_by_amount는 `sorted(results.items(), key=lambda x: x[1], reverse=True)`예요. H4에서 배운 sorted + key + lambda 조합이에요. "결과를 금액 기준으로 큰 순서로 정렬." results.items()로 (통화, 금액) 쌍을 얻고, key=lambda x: x[1]로 "두 번째 값(금액)을 기준으로", reverse=True로 "큰 순서로". 이 한 줄이 정렬 로직 전체예요. 보세요, H4에서 카탈로그로만 봤던 도구들이 여기서 진짜 일을 해요. dict comp로 변환하고, sorted로 정렬하고. 이게 "도구를 배운다"와 "도구를 쓴다"의 차이예요. H4에서 본인은 도구를 구경했고, H5에서 본인은 도구로 진짜 프로그램을 만들어요. 도구는 쓸 때 진짜 본인 것이 돼요. 오늘 이 세 함수를 본인 손으로 짜 보면, dict comp와 sorted가 머리가 아니라 손에 박혀요.

테스트.

```python
>>> convert_batch(50.0, "USD")
{'KRW': 65000.0, 'JPY': 7222.22, 'EUR': 46.43, 'GBP': 38.24, 'CNY': 361.11, 'CAD': 68.42, 'AUD': 76.47}

>>> sort_by_amount(convert_batch(50.0, "USD"))
[('KRW', 65000.0), ('JPY', 7222.22), ('CNY', 361.11), ...]
```

7개 통화 동시 변환 + 큰 순 정렬. 그리고 `if curr != from_curr`로 출발 통화 자기 자신은 제외했어요. USD에서 USD로 환산하는 건 의미 없으니까요. 이 작은 if 필터가 dict comprehension 안에 들어가서, 결과가 깔끔해져요. 보세요, $50가 7개 통화로 한 번에 환산되고, 금액 큰 순으로 정렬돼서 나와요. v1이었으면 통화 하나씩 일곱 번 환산해야 했어요. v2는 convert_batch 한 번에 일곱 개를 다 환산해요. 그게 dict comprehension의 힘이에요. 그리고 각 함수를 짜자마자 이렇게 REPL에서 바로 테스트하는 습관을 들이세요. convert_batch를 짰으면 바로 `convert_batch(50, "USD")`로 동작을 확인하고, 맞으면 다음 함수로. 작게 짜고 자주 확인하면, 사고가 나도 방금 짠 그 함수만 보면 되니까 빨리 잡아요.

---

## 6. 15~20분 — 사용자 메뉴와 while 루프

while + match-case로 메뉴 시스템. 이게 본인이 처음 만드는 "대화형 프로그램"이에요. 지금까지 본인 코드는 위에서 아래로 한 번 흐르고 끝났죠. 이제 사용자와 주고받으며 계속 도는 프로그램이 돼요.

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

이 메뉴 시스템이 v2를 진짜 프로그램으로 만드는 부분이에요. v1은 한 번 환산하고 끝났어요. v2는 사용자와 대화해요. while True로 "사용자가 종료할 때까지 계속" 메뉴를 보여줘요. 사용자가 1을 누르면 단일 변환, 2를 누르면 모든 통화 변환, 3을 누르면 히스토리, 4를 누르면 종료. 이 분기를 match-case가 깔끔하게 처리해요. H2에서 "메뉴 분기에 match-case가 좋다"고 했죠. 여기가 그 실전이에요. `match choice: case "1": ... case "4": break`. 같은 변수(choice)를 여러 값과 비교할 때 match-case가 if/elif보다 읽기 쉬워요. 그리고 `case _:`가 default예요. 사용자가 5나 엉뚱한 걸 누르면 "잘못된 선택"이라고 안내해요. 이 while + match-case 조합이 "사용자와 대화하는 프로그램"의 표준 골격이에요. 본인이 두 해 코스에서 CLI 도구를 만들 때마다 이 골격을 써요. 그리고 run_single_convert를 보세요. early return이 보이죠. "금액이 잘못됐으면 print하고 return", "통화가 잘못됐으면 print하고 return". 조건이 안 맞으면 일찍 빠져나가요. 이게 H6에서 깊이 배울 guard clause예요. 중첩 if를 쌓는 대신, "안 되는 경우를 먼저 걸러내고 빠져나가는" 패턴이에요. 코드가 계단처럼 깊어지지 않고 평평하게 흘러요. v2가 v1보다 읽기 쉬운 이유 중 하나가 이 early return이에요.

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

run_batch_convert 함수가 v2의 백미예요. 한 줄씩 풀어 볼게요. 먼저 금액과 통화를 받아서 검증해요(early return 패턴). 그 다음 `convert_batch`로 모든 통화로 환산하고, `sort_by_amount`로 큰 순서로 정렬해요. 여기까지가 H4 도구들의 조합이에요. 그리고 rich Table을 만들어서 결과를 예쁜 표로 그려요. `for curr, value in sorted_results`로 정렬된 결과를 하나씩 표에 추가하죠. `f"{value:,.2f}"`로 천 단위 콤마와 소수점 둘째 자리까지요(Ch007 f-string). 보세요, 이 한 함수 안에 검증(if), 변환(dict comp), 정렬(sorted), 반복(for), 포맷(f-string), 출력(Table)이 다 들어 있어요. 본인이 Ch007부터 Ch008까지 배운 게 이 한 함수에 응축돼 있어요. 이게 "학습이 코드가 되는" 모습이에요. 따로따로 배운 개념들이 하나의 함수로 합쳐져서 진짜 일을 해요.

show_history 함수를 보세요. H4에서 배운 enumerate가 진짜 일을 해요. `for i, entry in enumerate(HISTORY, start=1)`. HISTORY 리스트를 돌면서, 1번·2번·3번 번호를 붙여서 표에 넣어요. start=1로 1부터 시작했죠. 사람에게 보여줄 때는 0번이 아니라 1번부터가 자연스러우니까요. 그리고 맨 앞의 `if not HISTORY: return`을 보세요. H2에서 배운 falsy예요. HISTORY가 비어 있으면(falsy면) "히스토리 없음"이라고 안내하고 빠져나가요. `if len(HISTORY) == 0` 대신 `if not HISTORY`로 짧게요. 이게 v2 곳곳에 H1~H4의 학습이 자연스럽게 녹아 있는 모습이에요. enumerate, falsy, early return, rich Table. 본인이 따로따로 배운 조각들이 한 함수 안에서 한 몸으로 움직여요. 이게 학습이 실력으로 바뀌는 순간이에요. 외운 게 아니라, 필요한 곳에서 자연스럽게 꺼내 쓰는 거예요. 오늘 v2를 본인 손으로 짜면, 이 도구들이 "아, 여기서 enumerate 쓰면 되겠다", "여기는 falsy로 짧게" 하고 손에서 자동으로 나와요. 그게 본인이 Python을 진짜로 아는 단계예요.

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

진짜 출력. rich Table이 예쁘게 그려졌죠. 검은 화면에 깔끔한 표가 떠요.

본인이 방금 한 일을 한 발 떨어져서 보세요. 본인은 50줄짜리 코드를 150줄로 키웠어요. 그런데 그게 단순히 줄을 세 배로 늘린 게 아니에요. 프로그램이 질적으로 달라졌어요. v1은 한 번 쓰고 끝나는 계산기였어요. v2는 사용자와 대화하고, 여러 통화를 다루고, 기록을 남기고, 예쁜 표를 그리는 진짜 도구예요. 이게 소프트웨어가 자라는 모습이에요. 처음엔 작게 시작해서, 기능을 하나씩 더하며 커져요. 그리고 중요한 건, 본인이 이걸 한 번에 짠 게 아니라는 거예요. v1을 가져와서, 통화를 더하고, 검증을 더하고, 메뉴를 더하고, 표를 더했어요. 한 조각씩 쌓아 올린 거예요. 이게 진짜 개발이에요. 자경단 사이트도 이렇게 자라요. 작게 시작해서 한 기능씩 더하며 1만 줄로요. 본인이 환율 계산기를 v1에서 v2로 키운 이 경험이, 진짜 소프트웨어를 키우는 연습이에요. 그리고 이 v2도 Ch013에서 v3로, Ch041에서 v4로 더 자라요. 본인의 환율 계산기 하나가 두 해 코스 내내 본인과 함께 자라는 동반자예요. 오늘 본인은 그 동반자를 한 뼘 더 키웠어요.

---

## 9. v1 vs v2 다섯 핵심 차이

**1. 통화 4 → 8**. RATES 확장.

**2. 단일 변환 → 메뉴 시스템**. while + match-case.

**3. 함수 4개 → 9개**. 책임 분리.

**4. 에러 1종 → 5종**. validate_amount, validate_currency 등.

**5. 출력 print → rich Table**. 시각적 진화. 같은 데이터라도 보기 좋게 표로 보여주면 사용자 경험이 확 달라져요. H3에서 배운 rich가 여기서 빛나요.

이 다섯 차이를 한마디로 요약하면, v1은 "동작하는 코드"였고 v2는 "쓸 만한 프로그램"이에요. 동작하는 것과 쓸 만한 것은 달라요. v1은 본인 혼자 한 번 돌려보는 데모였고, v2는 사용자가 실제로 쓸 수 있는 도구예요. 메뉴로 안내하고, 에러를 친절히 처리하고, 결과를 예쁘게 보여줘요. 이 차이가 "취미 코드"와 "제품 코드"의 경계선이에요. 본인은 오늘 그 경계선을 넘었어요. 그리고 이게 끝이 아니에요. v3, v4, v5로 더 자라요. 각 버전이 더 쓸 만해져요. 소프트웨어는 이렇게 한 단계씩 더 좋아지는 거예요. 완벽한 v1을 한 번에 만드는 게 아니라, 동작하는 v1을 만들고 계속 키워요.

다섯 차이가 v2를 자경단 표준으로.

이 다섯 차이 중에서 가장 중요한 게 네 번째, "에러 1종 → 5종"이에요. 이게 v1과 v2의 진짜 격차예요. v1은 사용자가 조금만 이상하게 입력해도 빨간 에러를 토하고 죽었어요. 통화를 잘못 치면 KeyError, 금액에 글자를 치면 ValueError. 사용자는 무슨 일인지도 모르고 당황해요. v2는 다섯 가지 잘못된 입력을 다 친절하게 처리해요. 모르는 통화, 음수 금액, 글자 금액, 빈 입력, 잘못된 메뉴 선택. 각각에 "모르는 통화예요", "잘못된 금액이에요" 같은 안내를 줘요. 프로그램이 안 죽고 우아하게 대응해요. 이게 "장난감 프로그램"과 "진짜 프로그램"의 차이예요. 장난감은 정해진 대로만 쓰면 동작하지만, 진짜 프로그램은 사용자가 뭘 잘못해도 안 죽어요. 그리고 사실 코드의 절반이 이 "에러 처리"예요. H1에서 "if가 코드의 60%"라고 했죠. 그 if의 상당수가 "잘못된 입력을 거르는" 검증이에요. 5년 차의 코드를 보면, 정상 흐름은 짧고 에러 처리가 길어요. "될 때"보다 "안 될 때"를 더 신경 쓰거든요. 본인이 v2에서 다섯 종류 에러를 처리한 게, 진짜 프로그래머의 사고방식을 연습한 거예요. "사용자가 뭘 잘못할 수 있을까?"를 미리 상상하고 막는 것. 그게 단단한 프로그램을 만드는 길이에요.

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

9 함수에 18 도구가 다 들어 있어요. v2가 H1~H4 학습의 살아있는 적용. 표를 보면 어느 함수에 어떤 도구가 쓰였는지가 한눈에 보여요. if, try/except, dict comp, sorted, lambda, while, match-case, early return, enumerate, Table. 본 챕터에서 배운 거의 모든 게 이 9 함수에 흩어져 있어요.

이 매핑 표를 보면서 한 가지를 느끼셨으면 좋겠어요. 9개 함수가 각자 한 가지 일만 해요. validate_currency는 통화 검증만, convert는 환산만, sort_by_amount는 정렬만. 이게 "한 함수에 한 책임"이라는 원칙이에요. Ch007 H6에서 배운 거죠. v1은 함수가 4개라 한 함수가 여러 일을 했어요. v2는 9개로 나눠서 각자 한 가지만 해요. 그러면 뭐가 좋을까요. 첫째, 읽기 쉬워요. 함수 이름만 봐도 뭘 하는지 알아요. 둘째, 테스트하기 쉬워요. convert만 따로 테스트할 수 있어요. 셋째, 고치기 쉬워요. 정렬이 이상하면 sort_by_amount만 보면 돼요. 어디를 봐야 할지가 분명해요. 이게 함수를 잘게 나누는 이유예요. 그리고 이 9개 함수를 main에서 조립해요. run_menu가 다른 함수들을 부르고, run_single_convert가 validate와 convert를 부르고. 작은 함수가 중간 함수를, 중간 함수가 전체를. 레고처럼 조립하는 거예요. 본인이 5년 후 짤 1만 줄 프로그램도 이렇게 만들어져요. 작은 함수 수백 개를 조립한 거예요. 1만 줄이 무서운 게 아니라, 17줄짜리 함수 600개일 뿐이에요. 본인이 오늘 9개 함수를 조립할 줄 알면, 600개도 조립할 줄 아는 거예요. 거대한 건 작은 것의 조립이에요.

---

## 11. 다섯 사고와 처방

**사고 1: dict comp에 잘못된 key**

```python
{curr: convert(amount, from_curr, curr) for curr in RATES if curr != from_curr}
```

처방. 명시적 if 필터. KeyError 면역. RATES에 있는 통화만 도니까, 없는 키를 만질 일이 없어요. dict comprehension에서 키를 다룰 땐 항상 "이 키가 진짜 있는가"를 생각하세요.

**사고 2: while 무한 루프**

메뉴에서 break 없이.

처방. case "4": break.

이 무한 루프 사고가 v2에서 가장 흔해요. while True로 메뉴를 도는데, 종료 case에 break를 깜빡하면 프로그램이 안 끝나요. 사용자가 4를 눌러도 또 메뉴가 떠요. H2에서 배운 그 무한 루프예요. while True를 쓸 때는 반드시 안에 break가 있어서 빠져나갈 길이 있어야 해요. `case "4": break`가 그 출구예요. 만약 정말 무한 루프에 빠졌으면, Ch006에서 배운 Ctrl+C로 멈추세요. 그리고 코드를 다시 보면서 "어디서 break가 빠졌지?"를 찾으세요. while True는 강력하지만 항상 출구를 챙겨야 하는 도구예요.

**사고 3: input() 빈 문자열**

처방. .strip() 필수. 사용자가 통화를 "USD "처럼 뒤에 공백을 넣어 입력하면, 그 공백 때문에 RATES에서 못 찾아요. .strip()으로 양쪽 공백을 먼저 제거하면 안전해요. H2에서 본 정규화예요. 사용자 입력은 항상 .strip()으로 다듬고 시작하세요.

**사고 4: float 변환 실패**

처방. validate_amount의 try/except. 사용자가 금액에 "오십" 같은 글자를 치면 float() 변환이 실패하면서 ValueError가 나요. try/except로 그걸 잡아서 None을 돌려주고, 호출하는 쪽에서 "잘못된 금액"이라고 안내해요. 사용자 입력을 숫자로 바꿀 때는 항상 try/except로 감싸세요.

**사고 5: rich import 누락**

처방. requirements.txt + pip install.

이 다섯 사고를 보면서 한 가지를 가져가세요. 이 사고들은 본인이 v2를 짜면서 거의 다 한 번씩 만날 거예요. dict comp에서 출발 통화를 안 걸러서 자기 자신으로 환산하거나, while에 break를 깜빡해서 종료가 안 되거나, input에 strip을 안 해서 공백 때문에 통화를 못 찾거나. 이게 정상이에요. 50줄도 다섯 번 고쳐야 한다고 했죠. 150줄은 더 많이 고쳐요. 그리고 그 고치는 과정에서 H3에서 배운 디버깅 도구가 빛나요. v2가 이상하게 동작하면, `print(f"{choice=}")`로 사용자 입력을 확인하고, `breakpoint()`로 멈춰서 변수를 들여다봐요. 막혀도 당황하지 마세요. 막힘은 코딩의 정상 과정이에요. 본인이 v2를 짜다가 막히고, 디버거로 원인을 찾고, 고치고, 다시 돌리는 그 사이클을 한 번 돌면, 본인은 진짜 개발자의 하루를 경험한 거예요. 코드를 짜는 30분보다, 막힌 걸 푸는 그 과정에서 본인이 더 많이 배워요. 그러니까 v2가 첫 시도에 안 돌아도 실망하지 마세요. 안 도는 게 정상이고, 그걸 고치는 게 진짜 실력이에요.

---

## 12. 흔한 오해 다섯 가지

**오해 1: v1으로 충분.**

자경단 표준은 v2. 5종 에러 처리, 메뉴, 히스토리. v1은 데모였고, v2가 진짜 쓸 수 있는 도구예요. 사용자가 실제로 쓰는 프로그램은 v2 수준이 필요해요. 에러 처리 없는 v1은 사용자가 조금만 이상하게 해도 죽거든요.

**오해 2: 150줄 너무 길어.**

9 함수로 분리. 한 함수 평균 17줄. 150줄을 한 덩어리로 보면 막막하지만, 17줄짜리 9개로 보면 하나도 안 무서워요. 큰 건 작은 것의 모음이에요.

**오해 3: rich 무거워.**

가벼워요. import에 0.1초. 표 출력으로 디버깅·확인 시간을 훨씬 더 아껴요. 출력이 예쁘면 찾는 값을 빨리 찾으니까요. 투자 대비 이득이 커요.

**오해 4: match-case 못 쓰면.**

if/elif 가능. Python 3.10 미만이면 `if choice == "1": ... elif choice == "2": ...`로 똑같이 짜요. match-case는 더 깔끔할 뿐, 필수는 아니에요. 자경단은 3.12를 쓰니 match-case를 쓰지만, 옛 환경이면 if/elif로 충분해요.

**오해 6: v2가 완성이다.**

아니에요. v2도 진화의 한 단계예요. Ch013에서 v3(파일 저장), Ch041에서 v4(웹 API)로 자라요. 어떤 버전도 완성이 아니에요. 소프트웨어는 계속 자라요. v2는 "지금 단계의 좋은 버전"이지 "최종"이 아니에요.

**오해 5: HISTORY는 데이터베이스가 필요.**

list로 메모리 저장. 영구는 Ch012에서 파일.

이 다섯 번째 오해를 조금 더 풀어 볼게요. v2의 HISTORY는 그냥 list예요. 변환할 때마다 dict 하나를 append하죠. 이건 프로그램이 돌아가는 동안만 메모리에 있어요. 프로그램을 끄면 사라져요. "어, 그러면 기록이 안 남잖아요?" 맞아요. 영구 저장은 아직이에요. 그런데 그게 v2의 단계에선 괜찮아요. 모든 걸 한 번에 만들 필요는 없거든요. v2에서는 "메모리에 기록을 모으는 것"까지만 해요. Ch012에서 파일을 배우면, 그 HISTORY를 JSON 파일로 저장해서 프로그램을 꺼도 남게 만들어요. 그게 v5의 진화예요. 이게 소프트웨어를 단계적으로 키우는 방식이에요. 처음부터 데이터베이스를 붙이는 게 아니라, 일단 list로 시작하고, 필요해지면 파일로, 그 다음 데이터베이스로 키워요. 각 단계가 그 단계에 맞는 도구를 써요. v2에 데이터베이스를 붙이는 건 과해요. list면 충분해요. "지금 단계에 맞는 가장 단순한 도구"를 고르는 게 좋은 설계예요. 본인이 두 해 코스에서 "이거 데이터베이스 써야 하나?" 싶을 때, "일단 list나 파일로 충분하지 않나?"를 먼저 물어보세요. 과한 도구는 복잡함만 늘려요. 단순함이 미덕이에요.

---

## 13. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, 완성본 먼저 보기. 안심 — 본인이 30분 직접 짠 후에 보세요. 짜 보는 게 보는 것보다 백 배 배워요.
둘째, 들여쓰기 헷갈림. 안심 — 4칸 표준. VS Code가 자동으로 맞춰 줘요.
셋째, print 디버깅만. 안심 — H3에서 배운 `breakpoint()`로 멈춰서 보기.
넷째, 에러 메시지 안 읽음. 안심 — Traceback 마지막 줄에 답의 90%.
다섯째, 가장 큰 함정 — 첫 코드를 GitHub에 안 올림. 안심 — 본인이 짠 v2를 첫날부터 GitHub에. 포트폴리오의 시작.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

이 다섯 중에서 가장 중요한 게 마지막, "첫 코드를 GitHub에 안 올리는 것"이에요. 본인이 오늘 짠 v2를 꼭 GitHub에 올리세요. Ch007에서 짠 v1 옆에 v2를 커밋하면, 본인의 환율 계산기가 어떻게 자랐는지가 git 히스토리에 다 남아요. "v1 50줄 → v2 150줄"이라는 본인의 성장이 기록되는 거예요. 그리고 이게 본인의 포트폴리오예요. 두 해 후 취업할 때, 본인의 GitHub에 환율 계산기가 v1에서 v5까지 진화한 기록이 있으면, 그게 어떤 이력서보다 강력해요. "이 사람은 코드를 한 번 짜고 버리는 게 아니라, 계속 키우고 다듬는 사람이구나"를 보여주거든요. 그게 진짜 개발자의 증거예요. 그러니까 강의를 따라 친 코드라도, 본인 손으로 친 거면 GitHub에 올리세요. 작은 것부터 쌓는 습관이 두 해 후 큰 포트폴리오를 만들어요. 본인의 v2가 그 포트폴리오의 한 줄이 돼요.

## 14. 마무리 — 다음 H6에서 만나요

자, 다섯 번째 시간 끝.

v1 50줄 → v2 150줄. 9 함수, 18 도구, 5종 에러, 메뉴 시스템, rich Table, 히스토리. H1~H4에서 배운 모든 제어 흐름이 한 프로그램에 다 동원됐어요.

박수 한 번 칠게요. 정말 큰 박수예요. 본인이 자기 코드를 처음으로 "키웠어요." 새로 짠 게 아니라, 있던 걸 더 좋게 만들었어요. 이게 진짜 개발자가 매일 하는 일이에요. 코드를 한 번 짜고 끝내는 게 아니라, 계속 키우고 다듬어요. 본인은 오늘 그 경험을 처음 했어요. v1에서 v2로. 그리고 본인 코드가 눈앞에서 자라는 그 재미를 느꼈길 바라요. 그 재미가 본인을 계속 코드 짜게 만들어요.

다음 H6는 운영이에요. 오늘 짠 v2를 더 우아하게 다듬어요. early return, guard clause로 중첩을 평평하게, 복잡도를 줄이고, radon으로 측정해요. 오늘은 "동작하는 v2"를 만들었다면, H6는 그걸 "우아한 v2"로 만드는 시간이에요. 한 시간 후 만나요.

그 전에 한 가지 부탁. 본인이 짠 v2를 Ch007 H6에서 배운 세 도구로 검사해 보세요.

```bash
black exchange_v2.py
ruff check exchange_v2.py
mypy --strict exchange_v2.py
```

10초예요. 본인의 H5 졸업장이에요. 본인이 키운 150줄짜리 v2가 자경단 표준(black·ruff·mypy)을 통과하는 거예요. 동작하는 코드를 좋은 코드로. 본인은 이제 코드를 짤 뿐 아니라 키우고 다듬을 줄 알아요. 잘 따라오셨어요. 한 시간 후 H6에서 만나요.

---

## 👨‍💻 개발자 노트

> - rich vs print: rich는 ANSI 색깔 자동. 표 출력 강력.
> - dict comp 성능: list comp와 비슷. dict 변환 추가 비용.
> - match-case 패턴: literal, capture, sequence, mapping, class. 다섯 종류.
> - HISTORY 보관: 메모리. 재시작 시 사라짐. JSON 저장은 Ch012.
> - 다음 H6 키워드: early return · guard clause · 복잡도 · radon · 자경단 5 패턴.

---

## 추신

1. v1(50줄)이 v2(150줄)로. 같은 파일을 키워요.
2. H1~H4 학습이 v2 한 프로그램에 다 동원돼요.
3. v1→v2 — 통화 4→8·함수 4→9·입력 1회→while·에러 1→5종.
4. RATES 8 통화로 확장. HISTORY list로 변환 기록.
5. validate_currency — `curr.upper() in RATES` truthy 활용.
6. validate_amount — try/except + Optional(`float | None`).
7. convert_batch — dict comprehension + if 필터.
8. sort_by_amount — sorted + key=lambda + reverse.
9. run_menu — while True + match-case + break.
10. match choice: case "1"~"4" + `case _:` default.
11. run_single_convert — early return + guard clause.
12. show_history — enumerate(start=1) + rich Table.
13. rich Table로 예쁜 표 출력. console.print(table).
14. 9 함수 각자 한 가지 일. 평균 17줄.
15. 9 함수에 18 도구가 다 들어 있어요. 학습의 살아있는 적용.
16. 큰 문제를 9개 작은 함수로 쪼개고 조립.
17. v2도 첫 시도엔 안 돼요. 짜고 돌리고 고치고.
18. 사고 — dict comp key·while break·input strip·float·rich import.
19. HISTORY는 메모리. 재시작 시 사라짐. 영구는 Ch012 파일.
20. v2는 사용자와 대화. 메뉴 보여주고 입력 받고 반복.
21. early return으로 중첩 if 평평하게.
22. guard clause — "조건 안 맞으면 일찍 빠져나가기".
23. match-case가 if/elif보다 메뉴에 깔끔. 같은 변수 여러 값.
24. dict comp `{curr: convert(...) for curr in RATES if ...}`.
25. 짜고 → black → ruff → mypy. v2도 자경단 표준 통과.
26. v2를 GitHub에. 본인 코드의 성장이 git 히스토리에.
27. 현실의 요구(8통화·메뉴)를 코드로 푸는 게 진짜 프로그래밍.
28. 코드가 눈앞에서 자라는 재미. 멈출 수 없게 돼요.
29. H5 졸업장 — v2를 black·ruff·mypy 통과.
30. 다음 H6은 v2를 더 우아하게. 한 시간 쉬고 만나요. 🐾
