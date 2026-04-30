# Ch007 · H5 — 자경단 환율 계산기 30분 — 본인의 첫 진짜 Python 스크립트

> 고양이 자경단 · Ch 007 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 시나리오 — 자경단 미니의 의뢰
3. 0~5분 — 폴더 셋업 + RATES dict
4. 5~10분 — convert() 함수
5. 10~15분 — format_result() f-string
6. 15~20분 — cat_budget_demo() 자경단 적용
7. 20~25분 — main() 함수와 입력 받기
8. 25~30분 — 실행과 검증
9. 30분 한 페이지 압축
10. 다섯 가지 작은 사고와 처방
11. 한 줄 자동화 다섯 가지
12. 흔한 오해 다섯 가지
13. 자주 받는 질문 다섯 가지
14. 마무리 — 다음 H6에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
mkdir -p /tmp/python-demo && cd /tmp/python-demo
python3 -m venv .venv
source .venv/bin/activate
touch exchange.py

# 코드 작성 후
python3 exchange.py
```

```python
# exchange.py 핵심
RATES = {"USD": 1300.0, "JPY": 9.0, "EUR": 1400.0}

def convert(amount, from_curr, to_curr):
    krw = amount * RATES[from_curr]
    return krw / RATES[to_curr]

def format_result(amount, currency):
    return f"{amount:,.2f} {currency}"

def main():
    amount = float(input("금액: "))
    from_c = input("부터: ").upper()
    to_c = input("로: ").upper()
    result = convert(amount, from_c, to_c)
    print(format_result(result, to_c))
```

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 이제 다섯 번째 시간이에요. 절반을 넘었어요. 잘 따라오시고 계시네요. 박수.

지난 H4를 한 줄로 회수할게요. 본인은 Python 18 도구를 표 한 장으로 만나셨어요. 인터프리터 6, 패키지 5, 가상환경 3, 품질 3, 테스트 1. 자경단 매일 13줄 흐름. 그게 사전이었어요.

이번 H5는 그 사전을 본인의 첫 진짜 Python 스크립트로 묶는 시간이에요. 자경단 다섯 명이 매월 사료 예산을 환산하는 환율 계산기. 30분 시뮬로 본인이 직접 50줄을 짜요.

오늘의 약속은 한 가지예요. **본인이 H1부터 H4까지 배운 모든 것이 30분 안에 한 스크립트로 묶입니다**. 변수, 자료형 다섯, 연산자, f-string, 함수, dict, input/output, import. 다 한 스크립트에 들어가요. 30분 후엔 본인의 첫 Python 스크립트가 GitHub에 올라가요.

자, 시나리오부터.

---

## 2. 시나리오 — 자경단 미니의 의뢰

자경단의 미니가 어느 날 본인에게 와서 한 가지 부탁을 해요. "본인, 자경단 다섯 마리의 매월 사료 예산을 환산해 주세요. 외국 후원자가 USD, JPY, EUR로 보내고 싶어 해요."

조건은 다음과 같아요. 한 마리당 월 $50 (USD 기준). 자경단이 다섯 마리. 환율은 1 USD = 1,300 KRW, 1 JPY = 9 KRW, 1 EUR = 1,400 KRW. 본인이 30분 안에 KRW·USD·JPY·EUR 네 통화 환산기를 짜야 해요.

본인은 미니의 부탁을 받고 셸을 켜요. 30분 동안 본인이 짤 환율 계산기 50줄. 5단계로 나눠 짜요. 5분씩 한 단계.

자, 시작.

---

## 3. 0~5분 — 폴더 셋업 + RATES dict

첫 5분은 폴더 셋업이에요.

> ▶ **같이 쳐보기** — 폴더 셋업과 venv
>
> ```bash
> mkdir -p /tmp/python-demo && cd /tmp/python-demo
> python3 -m venv .venv
> source .venv/bin/activate
> code exchange.py     # VS Code로 빈 파일 열기
> ```

VS Code에서 새 파일이 열렸어요. 첫 줄부터 짜요.

```python
# exchange.py — 자경단 환율 계산기
"""자경단 5명 사료 예산 환산기 (KRW/USD/JPY/EUR)"""

RATES = {
    "KRW": 1.0,
    "USD": 1300.0,
    "JPY": 9.0,
    "EUR": 1400.0,
}
```

세 가지를 짚고 갈게요.

첫째, 첫 줄의 `#`은 주석이에요. Python에서 한 줄 주석은 `#`으로 시작. 이 줄은 실행 안 돼요. 본인이 코드의 의도를 적어 두는 곳.

둘째, 둘째 줄의 `"""..."""`. 모듈 docstring이에요. 파일 첫 줄에 적으면 그 파일의 설명이 돼요. 자경단 표준 — 모든 .py 파일은 첫 줄에 docstring.

셋째, RATES는 dict예요. 중괄호 `{}` 안에 key:value 쌍. KRW를 기준 1.0으로 두고, USD는 1,300배, JPY는 9배, EUR는 1,400배. 환율은 변할 수 있으니 코드 위에 dict로 둬요. 나중에 한 줄 수정으로 바꿀 수 있게.

dict는 Python의 핵심 자료구조예요. H8 (collections)에서 더 깊이 다뤄요. 오늘은 "key로 value 찾는 자료구조"만 머리에 두세요. RATES["USD"]가 1300.0을 돌려줘요.

5분 끝났어요. 다음 5분.

---

## 4. 5~10분 — convert() 함수

이제 환율 변환 함수를 짜요.

```python
def convert(amount: float, from_curr: str, to_curr: str) -> float:
    """from_curr를 to_curr로 환산.
    
    예: convert(50, "USD", "KRW") = 65000.0
    """
    krw = amount * RATES[from_curr]
    return krw / RATES[to_curr]
```

함수의 문법을 풀어 드릴게요.

`def 함수이름(인자):`로 시작. `def`는 define의 약자. `convert`가 함수 이름. 괄호 안에 인자 세 개. 콜론으로 끝.

`amount: float`은 type hint. amount가 float이라고 명시. Python 3.5+의 표준이에요. 자경단 표준은 모든 함수 인자에 type hint. 안 써도 되지만 쓰면 mypy가 검사해 줘서 안전.

`-> float`은 반환 type. 이 함수가 float을 돌려준다는 표시. 셋 다 명시하면 mypy가 100% 검증해요.

함수 안의 첫 줄 `"""..."""`은 함수 docstring. 함수 설명. `help(convert)`로 볼 수 있어요.

논리는 간단해요. amount를 KRW로 한 번 환산하고, 그 KRW를 to_curr로 환산. 두 단계. 

테스트해 봐요.

> ▶ **같이 쳐보기** — convert 함수 시범
>
> ```python
> >>> convert(50, "USD", "KRW")
> 65000.0
> >>> convert(50, "USD", "JPY")
> 7222.222222222222
> >>> convert(50, "USD", "EUR")
> 46.42857142857143
> ```

세 줄. 미니가 부탁한 환산이 다 됐어요. $50 = 65,000원 = 7,222엔 = 46유로. 환산기의 핵심이 한 함수에 다 들어 있어요.

---

## 5. 10~15분 — format_result() f-string

결과를 예쁘게 출력하는 함수를 짜요.

```python
def format_result(amount: float, currency: str) -> str:
    """결과를 천 단위 콤마와 함께 포맷팅."""
    return f"{amount:,.2f} {currency}"
```

f-string의 강력한 옵션을 한 번에 두 개 써요. `:,`로 천 단위 콤마, `.2f`로 소수점 둘째 자리.

테스트.

```python
>>> format_result(65000.0, "KRW")
'65,000.00 KRW'
>>> format_result(46.428571, "EUR")
'46.43 EUR'
>>> format_result(7222.22, "JPY")
'7,222.22 JPY'
```

깔끔하죠. f-string 한 줄이 1990년대 C printf의 다섯 줄을 대체해요.

format_result는 H2의 f-string을 진짜로 사용하는 곳이에요. H2에서 보여드린 다섯 가지 옵션 중 두 가지 (천 단위 콤마, 소수점)를 한 줄에 묶어요.

---

## 6. 15~20분 — cat_budget_demo() 자경단 적용

이제 자경단 다섯 마리의 예산 환산을 짜요.

```python
def cat_budget_demo() -> None:
    """자경단 5명의 매월 사료 예산 환산."""
    cats = ["본인", "까미", "노랭이", "미니", "깜장이"]
    monthly_usd = 50.0
    
    print(f"\n=== 자경단 사료 예산 ({len(cats)}명, $50/마리) ===\n")
    
    total_usd = monthly_usd * len(cats)
    
    for currency in ["KRW", "JPY", "EUR"]:
        result = convert(total_usd, "USD", currency)
        print(f"  {format_result(result, currency)}")
```

새로운 문법 두 가지.

첫째, `for ... in ...`. 반복문이에요. 리스트의 각 요소에 대해 한 번씩 실행. 다른 언어의 for/while과 비슷하지만 더 직관적.

둘째, `len(cats)`. 리스트의 길이. 5가 떠요. Python의 표준 함수.

테스트.

```python
>>> cat_budget_demo()

=== 자경단 사료 예산 (5명, $50/마리) ===

  325,000.00 KRW
  36,111.11 JPY
  232.14 EUR
```

다섯 마리 사료 예산이 세 통화로 환산. 미니가 외국 후원자에게 보낼 자료가 한 줄로 만들어졌어요.

---

## 7. 20~25분 — main() 함수와 입력 받기

마지막 5분은 사용자 입력 받기. 본인이 환율 계산기를 인터랙티브하게 쓸 수 있게.

```python
def main() -> None:
    """메인 진입점. 사용자 입력을 받아서 환산."""
    print("=== 자경단 환율 계산기 ===")
    print(f"지원 통화: {', '.join(RATES.keys())}\n")
    
    try:
        amount = float(input("금액을 입력하세요: "))
        from_c = input("부터 (예: USD): ").upper().strip()
        to_c = input("로 (예: KRW): ").upper().strip()
        
        result = convert(amount, from_c, to_c)
        print(f"\n결과: {format_result(amount, from_c)} = {format_result(result, to_c)}")
    except (KeyError, ValueError) as e:
        print(f"에러: {e}")
    
    print()
    cat_budget_demo()


if __name__ == "__main__":
    main()
```

새 문법 세 가지.

첫째, `input("...")`. 사용자에게 글자 한 줄 입력 받기. 항상 str 반환. 그래서 숫자가 필요하면 `float()` 또는 `int()`로 변환.

둘째, `.upper().strip()`. 메서드 chaining. 입력을 대문자로 바꾸고 양쪽 공백 제거. "  usd  "도 "USD"로 변환.

셋째, `try...except`. 예외 처리. 에러가 나면 except 블록 실행. KeyError는 dict에 없는 key, ValueError는 float() 변환 실패.

마지막에 `if __name__ == "__main__": main()`. Python 표준 양식. 이 파일을 직접 실행할 때만 main() 호출. import 됐을 땐 안 실행.

---

## 8. 25~30분 — 실행과 검증

이제 다 짰으니 실행. 진짜 출력을 보여드릴게요.

```bash
$ python3 exchange.py

=== 자경단 환율 계산기 ===
지원 통화: KRW, USD, JPY, EUR

금액을 입력하세요: 100
부터 (예: USD): usd
로 (예: KRW): krw

결과: 100.00 USD = 130,000.00 KRW

=== 자경단 사료 예산 (5명, $50/마리) ===

  325,000.00 KRW
  36,111.11 JPY
  232.14 EUR
```

본인의 첫 Python 스크립트가 동작했어요. 50줄 미만의 코드. 30분 안에 짠 거예요. 박수.

이 한 스크립트 안에 H1부터 H4까지의 모든 학습이 들어 있어요. 자료형 (float, str, dict, list), 연산자 (*, /, ==), f-string (천 단위, 소수점), 함수 (def, type hints, docstring), 입출력 (input, print), 제어 흐름 (for, try/except), 모듈 진입점 (`if __name__`).

품질 검사도 한 번.

```bash
black exchange.py
ruff check exchange.py
mypy exchange.py
```

세 도구 다 통과하면 자경단 표준 코드. PR 만들 준비 완료.

---

## 9. 30분 한 페이지 압축

```
14:00  폴더 셋업 + venv + RATES dict — 5분
14:05  convert() 함수 — 5분
14:10  format_result() f-string — 5분
14:15  cat_budget_demo() 자경단 적용 — 5분
14:20  main() + 입력 받기 — 5분
14:25  실행 + 검증 — 5분
14:30  완료 ✅ — 50줄 미만, H1~H4 학습 다 동원
```

30분 = 50줄. 평균 줄당 36초. 본인의 첫 코드 속도예요. 5년 후엔 같은 코드 5분에. 시간이 손가락을 만들어요.

---

## 10. 다섯 가지 작은 사고와 처방

본인이 첫 1년에 만나는 사고 다섯 가지.

**사고 1: KeyError**

```python
>>> RATES["KRR"]    # 오타
KeyError: 'KRR'
```

처방. dict.get()을 쓰거나 try/except로 잡기.

```python
RATES.get("KRR", 0)   # 없으면 0
```

**사고 2: ValueError**

```python
>>> float("abc")
ValueError: could not convert string to float
```

처방. try/except.

**사고 3: None과 비교**

```python
result = some_function()
if result == None:    # 안 좋은 스타일
```

처방. `is None` 사용.

**사고 4: 들여쓰기 사고**

```python
if True:
print("hi")    # IndentationError
```

처방. VS Code의 자동 들여쓰기. Tab은 4칸 spaces.

**사고 5: import 누락**

```python
print(datetime.now())
# NameError: name 'datetime' is not defined
```

처방. 파일 위에 `from datetime import datetime`.

다섯 사고와 처방을 한 페이지로. 1년 면역.

---

## 11. 한 줄 자동화 다섯 가지

자경단이 매일 쓰는 Python 한 줄 자동화 다섯 개.

```python
# 1. 한 줄 HTTP 서버
python3 -m http.server 8000

# 2. JSON 예쁘게 출력
cat data.json | python3 -m json.tool

# 3. 가짜 데이터 생성
python3 -c "import random; print([random.randint(1,100) for _ in range(10)])"

# 4. 시간 측정
python3 -c "import timeit; print(timeit.timeit('sum(range(100))', number=1000))"

# 5. UUID 생성
python3 -c "import uuid; print(uuid.uuid4())"
```

다섯 줄. 자경단 매일 한 번씩 만나요.

---

## 12. 흔한 오해 다섯 가지

**오해 1: 첫 코드는 완벽해야 한다.**

50줄 코드는 절대 첫 시도에 완벽하지 않아요. 5번 고쳐야 통과. 그게 정상이에요.

**오해 2: type hints 없으면 Python이 안 도는다.**

도네요. 선택적이에요. 하지만 자경단 표준은 항상.

**오해 3: 함수 짧을수록 좋다.**

너무 짧으면 분리비용. 한 일에 한 함수. 보통 5~30줄.

**오해 4: 주석은 많을수록 좋다.**

코드가 좋은 이름이면 주석 적게. docstring으로 함수 설명.

**오해 5: f-string은 어렵다.**

가장 쉬운 방법이에요. 다른 두 방법 (% , .format)이 더 어려워요.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. type hints 매번 써야?**

자경단 표준은 모든 함수에. 작은 스크립트는 생략 가능.

**Q2. 50줄 안에 다 못 끝나면?**

천천히. 한 시간 걸려도 됨. 첫 시도는 시간이 걸려요.

**Q3. dict 대신 list 쓰면?**

가능하지만 RATES는 dict가 직관적. key로 빠르게 찾기.

**Q4. 함수 분리 기준?**

한 일에 한 함수. 5줄 짧으면 분리 안 해도 OK.

**Q5. main 함수가 꼭 필요한가요?**

자경단 표준은 항상. 모듈 import 시 자동 실행 안 되게.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — Python 데모 학습 편

Python 데모 따라하며 자주 빠지는 함정 다섯.

첫 번째 함정, finish/ 먼저 본다. 안심하세요. **start/에서 30분 시도 후만.**

두 번째 함정, 들여쓰기 한 칸 차이로 멈춤. 안심하세요. **Python 들여쓰기 4칸 표준.** Tab vs Space 헷갈리면 reformat.

세 번째 함정, 복잡한 한 줄 list comprehension. 안심하세요. **for 두 줄이 한 줄 comprehension보다 가독성 100배.**

네 번째 함정, print 디버깅만. 안심하세요. **breakpoint() 또는 pdb로 한 번.** 5분 학습이 5시간 디버깅.

다섯 번째 함정, 가장 큰 함정. **에러 메시지 안 읽음.** 본인이 빨간 글씨 보고 닫음. 안심하세요. **Traceback 마지막 줄이 답.** 30초 읽으면 90% 해결.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H6에서 만나요

자, 다섯 번째 시간이 끝났어요. 60분 동안 본인은 첫 Python 스크립트를 직접 짜셨어요. 정리하면 이래요.

자경단 미니의 환율 계산기 의뢰. 5단계 30분에 50줄 작성. RATES dict, convert 함수, format_result f-string, cat_budget_demo 자경단 적용, main 함수와 입력 받기. H1부터 H4까지의 모든 학습이 한 스크립트에 동원됐어요. 사고 다섯 가지 처방도 만났고요.

박수 한 번 칠게요. 정말 큰 박수예요. 본인이 자기 손으로 첫 진짜 Python 스크립트를 짠 거예요. 5년 후엔 본인이 1만 줄 짜리 자경단 백엔드를 짜는 사람이에요. 첫 50줄이 가장 어려워요. 그 첫 줄을 오늘 끝냈어요.

다음 H6는 운영 시간이에요. PEP 8 스타일 가이드, type hints 깊이, docstring 양식, black/ruff/mypy 자동화, pre-commit hook, 본인의 첫 pytest 테스트. 한 시간 끝에 본인의 첫 패키지가 GitHub에 올라가요. 한 시간 후 만나요.

그 전에 한 가지 부탁. 본인의 exchange.py를 black으로 한 번 돌려 보세요.

```bash
black exchange.py
ruff check exchange.py
mypy exchange.py
```

3초예요. 본인의 H5 졸업장이에요. 본인이 짠 코드가 자경단 표준 통과.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - dict 내부: hash table. O(1) lookup. Python 3.7+에서 insertion order 유지.
> - type hints 런타임 검증: 기본은 안 함. Pydantic, typeguard 같은 라이브러리로 가능.
> - docstring 양식: Google, NumPy, Sphinx. 자경단 표준은 Google.
> - f-string 성능: % > .format() < f-string. f-string이 가장 빠름.
> - input() 보안: 사용자 입력은 항상 검증. eval() 절대 금지.
> - try/except 범위: 좁게. 한 줄만 감싸기. 전체를 감싸면 디버깅 어려움.
> - if __name__ 패턴: 모듈을 직접 실행 vs import 구분. 자경단 표준.
> - .strip()의 미묘함: 공백뿐 아니라 줄바꿈, 탭도 제거. .strip(',') 같이 특정 문자만도 가능.
> - 천 단위 콤마: f"{n:,}". Python 3.6+. 다른 locale은 locale 모듈.
> - 다음 H6 키워드: PEP 8 · black · ruff · mypy · docstring · pytest · pre-commit.
