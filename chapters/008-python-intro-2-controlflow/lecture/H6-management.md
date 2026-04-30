# Ch008 · H6 — early return·guard clause·복잡도 — 자경단 코드 운영

> 고양이 자경단 · Ch 008 · 6교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 왜 코드 복잡도가 중요한가
3. 첫째 패턴 — early return
4. 둘째 패턴 — guard clause 다섯 가지
5. 셋째 패턴 — 복잡도 줄이기 다섯 가지
6. radon으로 복잡도 자동 측정
7. ruff의 C901 lint 규칙
8. 자경단 매일 코드 리뷰 다섯 패턴
9. 자경단 매일 운영 의식
10. 다섯 함정과 처방
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리 — 다음 H7에서 만나요

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H5를 한 줄로 회수할게요. 환율 계산기 v2 150줄. 9 함수, 18 도구, 5종 에러, 메뉴, rich.

이번 H6는 그 v2를 자경단 평생 운영 코드로 다듬는 시간이에요. early return, guard clause, 복잡도 줄이기, radon 측정.

오늘의 약속. **본인의 함수 9개가 다섯 명이 같이 봐도 부끄럽지 않은 운영 코드로 변합니다**.

자, 가요.

---

## 2. 왜 코드 복잡도가 중요한가

복잡도라는 게 측정 가능한 숫자예요. 한 함수의 if, for 분기 수를 세면 그게 cyclomatic complexity라는 점수.

자경단 표준은 한 함수당 복잡도 10 이하. 10 넘으면 분리 신호. 5년 후에도 본인이 읽기 가능한 코드의 한계.

복잡도가 낮은 코드의 다섯 효과. 첫째, 본인이 6개월 후 다시 봐도 이해. 둘째, 동료가 1분에 이해. 셋째, 사고 확률 80% 감소. 넷째, 테스트 짜기 쉬움. 다섯째, 디버깅 시간 절감.

자경단의 매일 운영 — 함수 짤 때 복잡도 10 이하 자동으로. 5년 손가락에 박힘.

---

## 3. 첫째 패턴 — early return

중첩 if를 평탄화하는 첫 도구.

**Before** (중첩 깊음, 복잡도 4)

```python
def get_user_data(user_id):
    user = db.find(user_id)
    if user is not None:
        if not user.is_banned:
            if user.is_active:
                return user.data
            else:
                return None
        else:
            return None
    else:
        return None
```

**After** (early return, 복잡도 4지만 평탄)

```python
def get_user_data(user_id):
    user = db.find(user_id)
    if user is None:
        return None
    if user.is_banned:
        return None
    if not user.is_active:
        return None
    return user.data
```

같은 로직, 같은 복잡도 점수지만 평탄한 코드. 들여쓰기 1단계만. 가독성이 두 배.

자경단 표준 — 함수의 들여쓰기 3단계 이하. 그 이상이면 분리 또는 early return.

---

## 4. 둘째 패턴 — guard clause 다섯 가지

guard clause는 함수 시작에서 잘못된 입력을 즉시 거르는 패턴.

**1. None 체크**

```python
def process(user):
    if user is None:
        return None
    # 본 로직
```

**2. 빈 컬렉션**

```python
def avg(numbers):
    if not numbers:
        return 0
    return sum(numbers) / len(numbers)
```

**3. 잘못된 타입**

```python
def divide(a, b):
    if not isinstance(a, (int, float)):
        raise TypeError("a must be number")
    return a / b
```

**4. 잘못된 값**

```python
def divide(a, b):
    if b == 0:
        raise ValueError("b cannot be 0")
    return a / b
```

**5. 권한 체크**

```python
def admin_only(user):
    if not user.is_admin:
        raise PermissionError("admin only")
    # 본 로직
```

다섯 guard. 함수의 첫 5줄에. 본 로직은 그 다음.

---

## 5. 셋째 패턴 — 복잡도 줄이기 다섯 가지

**1. 함수 분리**

```python
# Before — 50줄
def big_function():
    # 검증 10줄
    # 처리 20줄
    # 출력 20줄

# After
def validate(): ...    # 10줄
def process(): ...     # 20줄
def output(): ...      # 20줄

def big_function():
    validate()
    process()
    output()
```

**2. dict로 if/elif 대체**

```python
# Before
if status == "ok":
    color = "green"
elif status == "warn":
    color = "yellow"
elif status == "error":
    color = "red"

# After
COLORS = {"ok": "green", "warn": "yellow", "error": "red"}
color = COLORS.get(status, "gray")
```

**3. comprehension으로 for+if 압축**

```python
# Before
result = []
for item in items:
    if item.is_valid:
        result.append(item.value)

# After
result = [item.value for item in items if item.is_valid]
```

**4. lambda 없애기**

```python
# Before
sorted(cats, key=lambda c: c.age)

# After (named function)
def by_age(cat):
    return cat.age
sorted(cats, key=by_age)
```

자경단은 한 줄 lambda는 OK, 두 줄 이상은 named.

**5. early return**

위에서 봤어요.

다섯 패턴이 본인의 매일 리팩토링.

---

## 6. radon으로 복잡도 자동 측정

radon은 Python 코드의 복잡도를 자동 측정.

```bash
pip install radon
radon cc exchange_v2.py
```

진짜 출력.

```
exchange_v2.py
    F 9:0 validate_currency - A (1)
    F 12:0 validate_amount - A (3)
    F 22:0 convert - A (1)
    F 27:0 convert_batch - A (2)
    F 35:0 sort_by_amount - A (1)
    F 39:0 show_menu - A (1)
    F 47:0 run_menu - A (5)
    F 65:0 run_single_convert - B (7)
```

각 함수의 복잡도 점수. A는 1-5 (가장 좋음), B는 6-10, C는 11-20 (분리 권장).

자경단 표준은 모든 함수 A 또는 B. C는 분리.

```bash
radon cc . -a   # 전체 평균
radon cc . -nc   # C 이상만 출력
```

CI에 박아서 PR마다 자동 검사.

---

## 7. ruff의 C901 lint 규칙

ruff에 복잡도 검사 규칙 C901이 있어요.

`pyproject.toml`.

```toml
[tool.ruff]
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "C901"]

[tool.ruff.lint.mccabe]
max-complexity = 10
```

복잡도 10 넘으면 ruff가 경고.

```bash
$ ruff check .
exchange_v2.py:65:1: C901 `run_single_convert` is too complex (12 > 10)
```

이 경고가 뜨면 함수 분리 신호.

---

## 8. 자경단 매일 코드 리뷰 다섯 패턴

자경단 다섯 명이 PR 리뷰할 때 보는 다섯 가지.

**1. 함수 길이**. 30줄 넘으면 분리 코멘트.

**2. 들여쓰기 깊이**. 3단계 넘으면 early return 코멘트.

**3. 함수 인자 수**. 4개 넘으면 dataclass 코멘트.

**4. 변수 이름**. 한 글자 이름 (i, x 빼고) 풀어쓰기 코멘트.

**5. 주석**. 코드가 좋으면 주석 없어도. 주석으로 설명 못 하면 함수 이름 개선.

다섯 패턴이 자경단의 매일 리뷰. 본인이 PR 만들 때 미리 자가 점검.

---

## 9. 자경단 매일 운영 의식

자경단 다섯 명이 매일 commit 전에 치는 한 줄 의식.

```bash
black . && ruff check . --fix && mypy --strict . && pytest -v && radon cc . -nc
```

다섯 도구를 한 줄로. 통과하면 commit.

자경단 미니의 dotfile.

```bash
alias check="black . && ruff check . --fix && mypy --strict . && pytest -v && radon cc . -nc"
```

`check` 한 단어로 매일 의식.

---

## 10. 다섯 함정과 처방

**함정 1: 한 함수 100줄**

처방. 30줄 단위로 분리.

**함정 2: 인자 7개**

처방. dataclass 또는 dict로.

```python
@dataclass
class UserCreateRequest:
    name: str
    email: str
    age: int
    ...

def create_user(req: UserCreateRequest):
    ...
```

**함정 3: 5단계 중첩 if**

처방. early return.

**함정 4: 변수 이름 a, b, c**

처방. 의미 있는 이름. user, count, total.

**함정 5: 주석 많은 코드**

처방. 코드가 자명하게. 함수 이름 개선.

---

## 11. 흔한 오해 다섯 가지

**오해 1: 짧을수록 좋다.**

너무 짧으면 분리비용. 5~30줄이 황금 비율.

**오해 2: 함수 인자 적을수록 좋다.**

3개 이하 추천. 4개 넘으면 dataclass.

**오해 3: 주석은 많을수록 좋다.**

좋은 코드는 주석 적게. 함수 이름이 주석.

**오해 4: 복잡도는 시니어만.**

신입 1주차부터. 빨리 박을수록 좋음.

**오해 5: radon은 옵션.**

자경단 CI 표준. 매번 자동.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. 함수 길이 황금 비율?**

5~30줄. 평균 15줄.

**Q2. early return 너무 많으면?**

5개 넘으면 그것도 신호. 함수 분리.

**Q3. 복잡도 10이 절대값?**

자경단 표준. 도메인에 따라 달라요.

**Q4. dict로 if 대체 항상?**

3개 이상 분기일 때. 2개는 if/else가 명확.

**Q5. lambda 한 줄 vs def?**

한 줄까지 lambda. 두 줄부터 def.

---

## 13. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, PEP 8 무시. 안심 — black 한 줄.
둘째, type hint 안 씀. 안심 — 공개 함수부터.
셋째, docstring 빈칸. 안심 — 한 줄 한 줄 표준.
넷째, pre-commit 안 씀. 안심 — 첫날 설치.
다섯째, 가장 큰 — 테스트 0. 안심 — pytest 한 줄부터.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 14. 마무리 — 다음 H7에서 만나요

자, 여섯 번째 시간 끝.

early return, guard clause 5종, 복잡도 줄이기 5 패턴, radon 측정, ruff C901, 자경단 리뷰 5 패턴.

박수. 본인의 환율 계산기 v2가 자경단 표준 운영 코드로 변했어요.

다음 H7은 깊이의 시간. CPython의 for 구현, iterator 프로토콜, generator, GIL.

```bash
radon cc exchange_v2.py -a
```

---

## 👨‍💻 개발자 노트

> - cyclomatic complexity (McCabe 1976): 분기 수 + 1.
> - radon 분류: A(1-5), B(6-10), C(11-20), D(21-30), E(31-40), F(40+).
> - guard clause 패턴: defensive programming의 일부.
> - early return vs single-exit: single-exit는 옛 C 패턴. 모던은 early return.
> - dataclass (PEP 557): 3.7+. class boilerplate 줄이기.
> - 다음 H7 키워드: CPython · iterator 프로토콜 · generator · yield · GIL.
