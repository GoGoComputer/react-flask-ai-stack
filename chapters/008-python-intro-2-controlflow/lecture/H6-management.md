# Ch008 · H6 — Python 입문 2: 운영 — early return·guard clause·복잡도 5 패턴

> **이 H에서 얻을 것**
> - early return 패턴 — 자경단 매일 함수 표준
> - guard clause 5 종류 — 입력 검증·타입·범위·상태·권한
> - 복잡도 줄이기 5 패턴 — McCabe·중첩·polymorphism
> - radon + ruff C901 lint — 자동 측정
> - 자경단 5명 매일 코드 리뷰 5 패턴
> - 5 함정 + 처방

---

## 회수: H5의 v2 코드에서 본 H의 운영으로

지난 H5에서 본인은 v2 150줄 9 함수를 작성했어요. 그건 **첫 production-grade 코드**.

본 H6는 그 코드를 **유지보수 가능하게**하는 패턴이에요. early return·guard·복잡도 줄이기 5 패턴이 자경단 1년 후 시니어 표준.

지난 Ch005 H6은 git 운영, Ch006 H6은 셸 운영, Ch007 H6은 Python 품질. 본 H는 제어 흐름 운영. 자경단 매일 4 stack의 운영.

---

## 1. early return 패턴

### 1-1. early return 정의

함수의 끝에서 return하지 않고, 조건 만족 시 즉시 return. **함수 깊이를 줄임 + 가독성 향상**.

```python
# 비권장 — 깊은 중첩 (4 단계)
def process(cat):
    if cat is not None:
        if cat['active']:
            if cat['age'] >= 1:
                if cat['budget_usd'] > 0:
                    return do_real_work(cat)
                else:
                    return None
            else:
                return None
        else:
            return None
    else:
        return None

# 권장 — early return (1 단계)
def process(cat):
    if cat is None:
        return None
    if not cat['active']:
        return None
    if cat['age'] < 1:
        return None
    if cat['budget_usd'] <= 0:
        return None
    return do_real_work(cat)
```

자경단 표준 — 함수의 모든 검증을 위에 모음.

위 비권장 코드는 4 단계 깊이. 본인이 수정하려면 4 단계를 추적. 권장 코드는 1 단계만. 새 검증 추가 = 한 줄 끼워넣음. **유지보수 100배**.

### 1-2. early return의 5 가치

1. **가독성** — 한 단계 깊이만
2. **유지보수** — 새 검증 추가 쉬움
3. **테스트** — 각 분기 독립적
4. **디버깅** — breakpoint이 검증 분기마다 가능
5. **mental model** — "잘못된 입력 먼저 거르고 정상 처리"

5 가치 = 자경단 1년 후 시니어 표준.

### 1-3. early return의 함정 + 처방

```python
# 함정 — finalize 못 함
def process(cat):
    open_resource()
    if cat is None:
        return None              # 자원 누수!
    do_work(cat)
    close_resource()

# 처방 — context manager (with)
def process(cat):
    with managed_resource() as r:
        if cat is None:
            return None          # with이 자동 close
        do_work(cat, r)
```

자경단 — 자원 관리는 with. early return 함정 면역.

### 1-4. early return의 5 시나리오 (자경단 매일)

```python
# 1. None 검증
def find_cat(cats, name):
    if not cats:
        return None
    return next((c for c in cats if c['name'] == name), None)

# 2. 빈 입력
def calculate_average(values):
    if not values:
        return 0.0
    return sum(values) / len(values)

# 3. 비활성 객체
def process_payment(account, amount):
    if not account.is_active:
        return PaymentResult(success=False, reason="비활성")
    return account.charge(amount)

# 4. 권한 없음
def delete_resource(user, resource_id):
    if not user.can_delete(resource_id):
        return DeletionResult(success=False, reason="권한 없음")
    db.delete(resource_id)
    return DeletionResult(success=True)

# 5. 비즈니스 규칙
def apply_discount(cart, code):
    if not code:
        return cart.total
    if not is_valid_code(code):
        return cart.total
    return cart.total * 0.9
```

5 시나리오 = 자경단 매일 early return의 진짜.

---

## 2. guard clause 5 종류

### 2-1. 입력 검증 guard

```python
def convert(amount_krw, currency):
    if amount_krw is None:
        raise ValueError("amount 필수")
    if currency is None:
        raise ValueError("currency 필수")
    return amount_krw / RATES[currency]
```

자경단 매일 — 모든 외부 입력 검증.

### 2-2. 타입 guard

```python
def convert(amount_krw, currency):
    if not isinstance(amount_krw, (int, float)):
        raise TypeError(f"amount는 number, 받음: {type(amount_krw)}")
    if not isinstance(currency, str):
        raise TypeError("currency는 str")
    return amount_krw / RATES[currency]
```

자경단 — type hint + isinstance 짝.

### 2-3. 범위 guard

```python
def convert(amount_krw, currency):
    if amount_krw < 0:
        raise ValueError("amount는 0 이상")
    if amount_krw > 10**10:
        raise ValueError("amount 너무 큼 (10조 이하)")
    return amount_krw / RATES[currency]
```

자경단 — 비즈니스 범위 명시.

### 2-4. 상태 guard

```python
def withdraw(account, amount):
    if not account.is_active:
        raise StateError("계정 비활성")
    if account.is_frozen:
        raise StateError("계정 동결")
    if account.balance < amount:
        raise InsufficientFundsError
    account.balance -= amount
```

자경단 — 객체 상태 검증.

### 2-5. 권한 guard

```python
def delete_cat(user, cat_id):
    if not user.is_authenticated:
        raise AuthError("로그인 필요")
    if not user.has_permission('delete'):
        raise PermissionError("삭제 권한 없음")
    if cat_id not in user.owned_cats:
        raise PermissionError("내 cat만 삭제 가능")
    db.delete(cat_id)
```

자경단 — 모든 변경 작업 권한 검증.

### 2-6. 5 guard 한 페이지

| 종류 | 양식 | 자경단 매일 |
|------|------|------------|
| 입력 | `if x is None:` | 모든 함수 |
| 타입 | `if not isinstance:` | type hint 부족 시 |
| 범위 | `if x < 0:` | 비즈니스 |
| 상태 | `if not obj.active:` | 객체 메서드 |
| 권한 | `if not user.permission:` | API 표준 |

5 guard = 자경단 함수 안전 100%.

### 2-7. guard의 진짜 가치 — fail fast

```python
# fail fast — 빨리 실패
def convert(amount, currency):
    if amount is None:
        raise ValueError("amount 필수")    # 즉시 실패
    if currency not in RATES:
        raise ValueError(f"통화 없음: {currency}")
    return amount / RATES[currency]

# fail late — 늦게 실패 (비권장)
def convert(amount, currency):
    try:
        return amount / RATES[currency]    # 깊은 곳에서 실패
    except (TypeError, KeyError) as e:
        raise ValueError(...)              # 원인 모호
```

자경단 — fail fast가 디버깅 1000배 쉬움. guard로 명확한 에러 메시지.

### 2-8. Pydantic으로 guard 자동화

```python
from pydantic import BaseModel, Field, validator

class ConvertRequest(BaseModel):
    amount_krw: float = Field(ge=0, le=10**10)  # 0~10조
    currency: str = Field(min_length=3, max_length=3)
    
    @validator('currency')
    def currency_must_exist(cls, v):
        if v not in RATES:
            raise ValueError(f"지원 안 함: {v}")
        return v

# FastAPI 자동 검증
@app.post('/convert')
async def convert_api(req: ConvertRequest):
    return {"result": req.amount_krw / RATES[req.currency]}
```

자경단 — FastAPI + Pydantic이 guard 자동 표준. 1년 차에 학습.

---

## 3. 복잡도 줄이기 5 패턴

### 3-1. McCabe 복잡도 정의

함수 안 분기 수 + 1. if·for·while·case·and/or 마다 +1.

```python
def f(x):                       # 1
    if x > 0:                   # 2
        if x > 10:              # 3
            return "big"
        return "small"
    return "negative"           # 복잡도 3
```

자경단 표준 — McCabe ≤ 10. 11+ 는 리팩토링.

### 3-2. 패턴 1: dict로 if/elif 대체

```python
# 복잡도 5 (if 4개)
def get_label(status):
    if status == 'pending':
        return '대기'
    elif status == 'active':
        return '활성'
    elif status == 'paused':
        return '일시정지'
    elif status == 'closed':
        return '닫힘'
    else:
        return '알 수 없음'

# 복잡도 1 (dict lookup)
LABELS = {
    'pending': '대기',
    'active': '활성',
    'paused': '일시정지',
    'closed': '닫힘',
}
def get_label(status):
    return LABELS.get(status, '알 수 없음')
```

자경단 — 5+ if/elif은 dict 표준.

### 3-3. 패턴 2: 중첩 if를 early return으로

(이미 1-1에서 봤어요) 자경단 매일 적용.

### 3-4. 패턴 3: nested for를 함수 분리

```python
# 복잡도 6 (for 2 + if 3)
def process_all():
    for cat in cats:
        for budget in cat['budgets']:
            if budget > 100:
                if budget > 1000:
                    if cat['active']:
                        do_work(cat, budget)

# 복잡도 1 + 1 (각 함수 1)
def process_one(cat, budget):
    if not cat['active']: return
    if budget <= 100: return
    if budget <= 1000: return
    do_work(cat, budget)

def process_all():
    for cat in cats:
        for budget in cat['budgets']:
            process_one(cat, budget)
```

자경단 — 깊은 for/if는 함수 분리.

### 3-5. 패턴 4: polymorphism (class)

```python
# 복잡도 5 (if/elif 4)
def make_sound(animal):
    if animal['type'] == 'cat':
        return 'meow'
    elif animal['type'] == 'dog':
        return 'woof'
    elif animal['type'] == 'cow':
        return 'moo'
    elif animal['type'] == 'duck':
        return 'quack'

# 복잡도 1 + 4 (class별 1)
class Cat:
    def make_sound(self): return 'meow'
class Dog:
    def make_sound(self): return 'woof'
# 사용
animal.make_sound()
```

자경단 — type 분기는 class. 1년 차 시니어.

### 3-6. 패턴 5: comprehension + 함수 짝

```python
# 복잡도 4 (for + if + nested)
def get_active_names():
    result = []
    for cat in cats:
        if cat['active']:
            if cat['age'] >= 1:
                result.append(cat['name'])
    return result

# 복잡도 1 (comp)
def get_active_names():
    return [c['name'] for c in cats if c['active'] and c['age'] >= 1]
```

자경단 매일 — for + if는 comp.

### 3-7. 5 패턴 한 페이지

| 패턴 | 적용 | 효과 |
|------|------|------|
| dict 대체 | 5+ if/elif | 복잡도 5→1 |
| early return | 깊은 중첩 | 4단계→1단계 |
| 함수 분리 | nested for | 분리·테스트 |
| polymorphism | type 분기 | OOP·확장 |
| comp | for+if | 한 줄·가독성 |

5 패턴 = 자경단 매일 리팩토링.

### 3-8. 5 패턴 적용 시점

| 패턴 | 적용 시점 | 자경단 매일 |
|------|---------|------------|
| dict 대체 | 5+ if/elif | 매주 |
| early return | 3+ 깊이 | 매일 |
| 함수 분리 | nested for/if | 매주 |
| polymorphism | type 분기 5+ | 매월 |
| comp | for+if 단순 | 매일 |

5 패턴 적용 시점 = 자경단 코드 리뷰 표준.

### 3-9. 복잡도 진짜 측정 — 자경단 본인의 v2

```bash
$ radon cc exchange_v2.py -a
exchange_v2.py
    F 22:0 get_rate - A (3)
    F 30:0 convert - A (1)
    F 33:0 total_budget_krw - A (2)
    F 36:0 cats_by_age - A (1)
    F 39:0 find_cat - A (2)
    F 42:0 all_active - A (1)
    F 45:0 any_senior - A (1)
    F 48:0 age_distribution - A (2)
    F 51:0 grouped_by_age - A (3)
    F 57:0 alert_high_rates - A (2)
    F 61:0 cat_status_report - B (6)
    F 75:0 main - A (4)

Average: A (2.3)
```

12 함수 평균 A (2.3) = 자경단 우수. cat_status_report만 B (6, match-case 5 case + for).

---

## 4. radon + ruff C901 lint 자동 측정

### 4-1. radon 설치 + 사용

```bash
$ pip install radon

# McCabe 복잡도 측정
$ radon cc exchange_v2.py -a
exchange_v2.py
    F 25:0 process - A (3)
    F 30:0 calculate - C (15)    # 15 = 위험!
    F 50:0 main - A (5)

Average complexity: A (5.5)
```

`A` (1-5) 좋음·`B` (6-10) OK·`C` (11-20) 주의·`D` (21-30) 위험·`E/F` 즉시 리팩토링.

### 4-2. ruff C901 자동 lint

```toml
# pyproject.toml
[tool.ruff.lint]
select = ["C90"]
mccabe = { max-complexity = 10 }
```

```bash
$ ruff check exchange_v2.py
exchange_v2.py:30: C901 `calculate` is too complex (15 > 10)
```

자경단 — pre-commit hook으로 자동. PR 머지 거부.

### 4-3. radon mi (Maintainability Index)

```bash
$ radon mi exchange_v2.py
exchange_v2.py - A (75.5)        # 100 만점, 75+ 좋음
```

자경단 — MI 65+ 표준. 65 미만 리팩토링.

### 4-4. radon raw (LOC)

```bash
$ radon raw exchange_v2.py
exchange_v2.py
    LOC: 150
    LLOC: 100                   # 논리 줄
    SLOC: 110                   # 소스 줄
    Comments: 25
    Comment Stats: (C % L): 23%

```

자경단 — 함수 < 50 줄·파일 < 500 줄.

### 4-5. 측정 도구 5 통합

| 도구 | 측정 | 자경단 표준 |
|------|------|----------|
| radon cc | McCabe 복잡도 | ≤ 10 |
| radon mi | 유지보수성 지수 | ≥ 65 |
| radon raw | LOC | 함수 ≤ 50 |
| ruff C901 | 자동 lint | pre-commit |
| pylint | 종합 | 매주 |

5 도구 = 자경단 매일 자동 측정.

### 4-6. CI integration

```yaml
# .github/workflows/quality.yml
name: Code Quality
on: [pull_request]
jobs:
  complexity:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - run: pip install radon ruff
      - run: radon cc src/ -a -nc       # 복잡도 측정 + 정렬 + show
      - run: radon mi src/ -nb          # MI ≥ 65 미달 시 실패
      - run: ruff check src/ --select C90  # 복잡도 lint
```

자경단 매 PR 자동 검사. 복잡도 위반 시 머지 거부.

### 4-7. 자경단 매월 복잡도 추세 차트

본인이 6개월 추세 측정:
- 1월: 평균 A (2.5)
- 2월: 평균 A (2.7)
- 3월: 평균 A (2.6)
- 4월: 평균 A (2.4) (리팩토링 후)
- 5월: 평균 A (2.5)
- 6월: 평균 A (2.5)

평균 A (2.5) 안정적 = 자경단 코드 품질 표준 유지. 매월 회의 시 검토.

---

## 5. 자경단 5명 매일 코드 리뷰 5 패턴

### 5-1. 패턴 1: early return 누락 지적

```python
# PR 코멘트
# "guard clause 위로 올려주세요. early return 패턴."
```

가장 흔한 코멘트.

### 5-2. 패턴 2: 5+ if/elif → dict

```python
# PR 코멘트
# "이 5 elif는 dict로 변환하면 어떨까요? 복잡도 1로 줄어듭니다."
```

자경단 매주.

### 5-3. 패턴 3: nested for → 함수 분리

```python
# PR 코멘트
# "안쪽 for을 process_one() 함수로 분리하면 테스트하기 쉽습니다."
```

자경단 매주.

### 5-4. 패턴 4: type 분기 → polymorphism

```python
# PR 코멘트
# "Animal type별 분기는 class로 분리하면 확장이 쉬워요."
```

자경단 1년 차.

### 5-5. 패턴 5: for + if → comp

```python
# PR 코멘트
# "이 for+if는 comp으로 한 줄 됩니다."
```

자경단 매일.

### 5-6. 5 패턴 = 자경단 95% 코드 리뷰

5 패턴이 자경단 PR 코멘트 95%. 1년 후 자동으로 적용 가능.

### 5-7. 자경단 5명 매일 코드 리뷰 시간 분포

| 시점 | 활동 | 시간 |
|------|------|------|
| PR 작성 | 본인 self-review (5 패턴 자동 적용) | 5분 |
| PR 첫 review | 다른 멤버 1명 (5 패턴 검토) | 10분 |
| 수정 | PR 작성자 (5 패턴 적용) | 10분 |
| 재 review | 다른 멤버 (승인) | 5분 |
| 머지 | squash + auto-delete branch | 1분 |

총 31분 = 자경단 평균 PR 사이클. 1년 누적 250 PR × 31분 = 130시간 코드 리뷰.

### 5-8. 5 패턴 적용 전후 비교 — 자경단 본인의 1년

**1주차** (5 패턴 모름):
- 평균 함수 LOC: 25
- McCabe 평균: 8
- PR 수정 평균: 5회
- 머지 평균 시간: 2시간

**1년 차** (5 패턴 마스터):
- 평균 함수 LOC: 8
- McCabe 평균: 2.5
- PR 수정 평균: 1회
- 머지 평균 시간: 30분

**4배 효율**. 1년 평균 250 PR × 1.5시간 절약 = 375시간 절약. 5 패턴 학습 1시간 = ROI 375배.

---

## 6. 자경단 매일 운영 의식

### 6-1. 매 commit (pre-commit)

```bash
$ git commit -m "feat: alert 추가"
black....................................Passed
ruff (C901).............................Passed   # 복잡도 자동 검사
mypy....................................Passed
pytest..................................Passed
[main abc1234] feat: alert 추가
```

자경단 매 commit — 5 검사 자동.

### 6-2. 매 PR (수동)

```bash
$ radon cc src/ -a               # 복잡도 측정
$ radon mi src/                  # MI 측정
$ ruff check src/                # lint
```

자경단 매 PR 직전 3 측정.

### 6-3. 매주 (코드 리뷰)

```bash
# 1. 복잡도 상위 10 함수 검토
$ radon cc src/ -nc -s          # 정렬 + show

# 2. MI 하위 5 파일 검토
$ radon mi src/ -s

# 3. 5 패턴 적용 PR 작성
```

자경단 매주 1시간.

### 6-4. 매월 (회고)

```bash
# 1. 복잡도 추세 (월 비교)
$ radon cc src/ -a > complexity-2026-01.txt

# 2. MI 추세
$ radon mi src/ > mi-2026-01.txt

# 3. 자경단 회의 — 패턴 진화 검토
```

자경단 매월 회의.

### 6-5. 운영 진화 5단계 (1주~5년)

| 단계 | 시기 | 적용 |
|------|------|------|
| 1단계 | 1주차 | early return + guard 학습 |
| 2단계 | 1개월 | 5 패턴 적용 + radon 측정 |
| 3단계 | 6개월 | ruff C901 + pre-commit + CI |
| 4단계 | 1년 | 매주 리뷰 + 매월 회고 |
| 5단계 | 5년 | 패턴 자동 적용 + 신입 멘토 |

5 단계 진화 = 자경단 1년 후 시니어. 5년 후 멘토.

### 6-6. 자경단 매일 운영 시간 분포

| 시점 | 시간 | 활동 |
|------|------|------|
| 매 commit | 5초 | pre-commit 자동 |
| 매 PR | 5분 | 3 측정 (radon cc/mi/raw) |
| 매주 | 1시간 | 복잡도 상위 10 검토 |
| 매월 | 30분 | 추세 회고 |
| 매분기 | 1시간 | 패턴 진화 검토 |

매월 누적 약 12시간 운영 의식. 매월 12시간 = 매년 144시간. ROI 무한대 (코드 품질 + 디버깅 절약).

---

## 7. 5 함정 + 처방

### 7-1. 함정 1: early return으로 finalize 누락

```python
# 처방 (재회수) — with 사용
def process(cat):
    with managed_resource() as r:
        if cat is None:
            return None
        do_work(cat, r)
```

### 7-2. 함정 2: guard 너무 많아 가독성 떨어짐

```python
# 함정 — 10+ guard
def process(cat):
    if cat is None: return None
    if not cat['active']: return None
    if cat['age'] < 1: return None
    if cat['age'] > 20: return None
    if cat['budget_usd'] <= 0: return None
    if cat['budget_usd'] > 1000: return None
    if not cat['name']: return None
    if len(cat['name']) > 50: return None
    if cat['name'].isdigit(): return None
    if cat['name'].startswith('_'): return None
    do_work(cat)

# 처방 — 검증 함수 분리
def validate_cat(cat) -> tuple[bool, str | None]:
    if cat is None: return False, "cat 필수"
    # ... 검증 모음
    return True, None

def process(cat):
    valid, error = validate_cat(cat)
    if not valid:
        raise ValueError(error)
    do_work(cat)
```

자경단 — 검증은 별도 함수.

### 7-3. 함정 3: dict 대체가 복잡한 로직 못 표현

```python
# 함정 — dict는 단순 매핑만
LABELS = {'pending': '대기', ...}

# 복잡한 로직은 함수
def get_label(status, user):
    if status == 'pending':
        if user.is_admin:
            return '대기 (관리자 알림)'
        return '대기'
    ...
```

자경단 — 단순 매핑은 dict, 복잡 로직은 함수/if.

### 7-4. 함정 4: comp 너무 길어 가독성 떨어짐

```python
# 함정
result = [process(c['data']['nested']['value'])
          for c in cats
          for v in c.values()
          if c['active'] and c['age'] >= 1 and v > 100
          if not c['frozen']]

# 처방 — for 분리
result = []
for cat in cats:
    if not cat['active'] or cat['age'] < 1:
        continue
    if cat['frozen']:
        continue
    for v in cat.values():
        if v > 100:
            result.append(process(cat['data']['nested']['value']))
```

자경단 — comp 3 줄 이상은 for.

### 7-5. 함정 5: McCabe 복잡도 측정 X

```python
# 함정 — 복잡도 모르고 그냥 commit
# pre-commit + ruff C901 추가 안 함

# 처방 — pre-commit 강제
# pyproject.toml
[tool.ruff.lint]
select = ["C90"]
mccabe = { max-complexity = 10 }
```

자경단 — 자동 측정 표준.

5 함정 면역 = 자경단 1년 자산.

### 7-6. 함정 6 (보너스): polymorphism 과 적용

```python
# 함정 — 불필요한 class 분리
class Cat:
    def get_age(self): return self.age
class Dog:
    def get_age(self): return self.age
# 동일한 코드. 그냥 dict이 더 간단

# 처방 — type 분기 5+ 일 때만 polymorphism
class Animal:
    def make_sound(self): raise NotImplementedError

class Cat(Animal):
    def make_sound(self): return 'meow'
# ... 5+ 동물

# 5 미만은 dict 또는 함수 가독성
```

자경단 — polymorphism은 5+ type 일 때만.

### 7-7. 함정 7 (보너스): 측정 후 안 함

```python
# 함정 — radon 측정 후 무시
$ radon cc src/ -nc
src/api.py F 30:0 calculate - C (15)
# 그러나 리팩토링 안 함

# 처방 — pre-commit으로 강제
# pyproject.toml
[tool.ruff.lint]
select = ["C90"]
mccabe = { max-complexity = 10 }
```

자경단 — 측정 → 자동 강제 → 머지 거부.

---

## 7-8. 자경단 5 패턴 + 운영 의식 통합 표

| 영역 | 패턴/의식 | 매일 적용 |
|------|----------|----------|
| 함수 | early return | 모든 함수 |
| 함수 | guard 5 종류 | 외부 입력 |
| 분기 | dict 대체 | 5+ if/elif |
| 분기 | match-case | Python 3.10+ |
| 반복 | comp | 단순 for+if |
| 반복 | 함수 분리 | nested |
| 측정 | radon cc/mi | 매 PR |
| 측정 | ruff C901 | pre-commit |
| 리뷰 | 5 패턴 코멘트 | 매 PR |
| 회고 | 매주 + 매월 | 추세 |

10 항목 = 자경단 매일 운영 100%.

---

## 8. 흔한 오해 5가지

**오해 1: "early return 비권장 (single exit point)."** — 옛 C 스타일. 현대 Python 표준 early return.

**오해 2: "복잡도 10 너무 엄격."** — Google·Meta 표준 5. 10이 자경단 합리적.

**오해 3: "guard clause는 함수 길어짐."** — 깊은 중첩보다 100배 가독성.

**오해 4: "comp이 무조건 좋다."** — 3줄 이상은 for이 가독성.

**오해 5: "복잡도 측정 자동 안 됨."** — radon + ruff C901 자동.

**오해 6: "polymorphism이 항상 좋다."** — 5 미만 type은 dict 또는 함수 가독성.

**오해 7: "단순 함수는 guard 필요 없다."** — 모든 외부 입력은 guard. 내부 helper만 생략.

**오해 8: "Pydantic은 무겁다."** — FastAPI 표준. 자경단 1년 차 가치 100배.

---

## 9. FAQ 5가지

**Q1. early return vs return value 변수?**
A. early return 표준. return 변수는 옛 C 스타일.

**Q2. guard clause 위치?**
A. 함수 시작·docstring 아래. 검증 모음.

**Q3. dict 매핑 한계?**
A. 단순 lookup만. 복잡 로직은 if/elif·class.

**Q4. radon vs pylint?**
A. radon 복잡도/MI/LOC 전문·pylint 종합. 자경단 둘 다.

**Q5. 복잡도 10 vs 15?**
A. 자경단 10 표준. PEP 추천 10. Google 5.

**Q6. early return이 디버깅 어렵게 만드나요?**
A. 정반대. 각 분기에 breakpoint 가능. mental model 명확.

**Q7. guard clause vs decorator?**
A. 함수 안 검증 — guard. 공통 검증 (auth) — decorator. 자경단 둘 다.

**Q8. ruff C901 vs pylint similarity?**
A. C901 복잡도만. pylint 종합 (similarity·too-many-args 등). 자경단 둘 다.

**Q9. radon mi 측정의 한계?**
A. 함수 짧으면 항상 높음. 비즈니스 로직 검증은 별도.

**Q10. polymorphism 학습 시점?**
A. Ch017 (10주 후) class 학습 후. 본 H에선 함수 분리 우선.

---

## 10. 추신

추신 1. early return = 함수 가독성 표준. 깊은 중첩 → 1 단계.

추신 2. early return 5 가치 (가독성·유지보수·테스트·디버깅·mental model).

추신 3. guard clause 5 종류 (입력·타입·범위·상태·권한) = 자경단 함수 안전 100%.

추신 4. McCabe 복잡도 = 분기 수 + 1. 자경단 표준 ≤ 10.

추신 5. 복잡도 5 패턴 (dict·early return·함수 분리·polymorphism·comp).

추신 6. radon cc/mi/raw + ruff C901 + pylint = 5 측정 도구.

추신 7. 자경단 표준 — McCabe ≤ 10·MI ≥ 65·함수 ≤ 50줄·파일 ≤ 500줄.

추신 8. 자경단 5명 매일 코드 리뷰 5 패턴 = PR 코멘트 95%.

추신 9. 매 commit pre-commit 자동·매 PR 3 측정·매주 1시간 리뷰·매월 회고.

추신 10. 5 함정 면역 (finalize·guard 많음·dict 복잡 로직·comp 길음·복잡도 측정 X).

추신 11. 흔한 오해 5 면역 (early return·복잡도 10·guard 길음·comp 무조건·자동 측정).

추신 12. FAQ 5 답변.

추신 13. 옛 C 스타일 single exit point 폐기. 현대 Python early return.

추신 14. dict 5+ if/elif 대체 → 복잡도 5→1.

추신 15. polymorphism class 분리 → 1년 차 시니어 양식.

추신 16. comp 3줄 이내 자경단 표준. 4줄+ for 분리.

추신 17. ruff C901 = pre-commit hook 자동 복잡도 검사.

추신 18. radon Average A 좋음·B OK·C+ 리팩토링.

추신 19. MI 75+ 자경단 좋음·65+ OK·65 미만 리팩토링.

추신 20. 자경단 매주 복잡도 상위 10 함수 검토 = 매주 1시간.

추신 21. 자경단 매월 복잡도 추세 비교 = 진화 측정.

추신 22. early return의 진짜 가치 — 함수 mental model "잘못된 입력 먼저 거름".

추신 23. guard clause + early return 짝꿍 = 자경단 매일 함수 표준.

추신 24. 검증 함수 분리 (validate_cat) = guard 10+ 시 표준.

추신 25. dict 매핑 — 단순 lookup·class — 복잡 로직 + 확장.

추신 26. comp + if 한 줄 vs for 3줄 — 가독성 결정.

추신 27. 본인의 첫 early return — `if not data: return None`. 자경단 매 함수.

추신 28. 본인의 첫 guard — `if not user.is_authenticated: raise AuthError`. 자경단 매 API.

추신 29. 본 H의 진짜 결론 — early return + guard + 복잡도 5 패턴이 자경단 1년 후 시니어 양식이고, radon + ruff C901이 매일 자동 측정이며, 5 함정 면역이 평생 자산이에요.

추신 30. **본 H 끝** ✅ — Ch008 H6 운영 학습 완료. 다음 H7 원리/내부 (iterator protocol·generator·yield from·async for)! 🐾🐾🐾

추신 31. early return 5 시나리오 (None·빈 입력·비활성·권한·비즈니스 규칙) = 자경단 매일.

추신 32. fail fast vs fail late — guard로 빨리 실패. 디버깅 1000배 쉬움.

추신 33. Pydantic이 guard 자동화 표준. FastAPI 짝.

추신 34. 5 패턴 적용 시점 — dict (5+ if)·early (3+ 깊이)·함수 분리 (nested)·polymorphism (5+ type)·comp (단순 for+if).

추신 35. radon cc 자경단 본인의 v2 평균 A (2.3) = 우수 코드.

추신 36. cat_status_report만 B (6) — match-case 5 case + for. 자경단 합리적 한계.

추신 37. CI integration — radon + ruff C901 자동 검사. 머지 거부.

추신 38. 6개월 추세 평균 A (2.5) 안정 = 자경단 코드 품질 표준.

추신 39. PR 사이클 31분 = 자경단 평균. 1년 250 PR × 31분 = 130시간.

추신 40. 5 패턴 마스터 ROI 375배 (1년 250 PR × 1.5h 절약 / 1h 학습).

추신 41. 운영 진화 5 단계 (1주 학습·1개월 측정·6개월 자동·1년 매주·5년 멘토).

추신 42. 매월 운영 12시간 = 매년 144시간 = 자경단 평생 자산.

추신 43. 5 함정 + 보너스 2 (polymorphism 과적용·측정 후 안 함) 면역.

추신 44. 흔한 오해 8 면역 (early return·복잡도·guard·comp·측정·polymorphism·단순 함수·Pydantic).

추신 45. FAQ 10 답변.

추신 46. 옛 single exit point → 현대 early return 패러다임 전환.

추신 47. 본인의 첫 5 패턴 적용 = 자경단 1년 후 시니어의 첫 발자국.

추신 48. radon 평균 A (2.3) → 1년 후 A (2.0) = 자경단 진화.

추신 49. 본 H의 진짜 결론 — early return + guard + 5 패턴이 자경단 1년 후 시니어이고, radon + ruff C901이 매일 자동 측정이며, 매월 12시간 운영이 평생 자산이에요.

추신 50. **본 H 진짜 끝** ✅✅✅ — early return·guard 5·복잡도 5 패턴·radon 5 도구·매일 운영 의식·5명 PR 31분·ROI 375배. 자경단 1년 후 시니어 운영 양식! 🐾🐾🐾🐾🐾

추신 51. 통합 표 10 항목 = 자경단 매일 운영 100%.

추신 52. early return + guard + 5 패턴 + radon + ruff + CI = 자경단 6 의식.

추신 53. 자경단 매일 코드 리뷰 5 패턴 = PR 코멘트 95%.

추신 54. 1년 후 본인이 5 패턴 자동 적용 = 자경단 시니어.

추신 55. 5년 후 본인이 신입 멘토 = 본 H를 가르침.

추신 56. **본 H 마지막** ✅ — Ch008 H6 운영 마침. 다음 H7 원리/내부에서 iterator·generator·yield·async! 🐾🐾🐾🐾🐾🐾🐾

추신 57. early return의 진짜 효과 — 함수 4 단계 깊이 → 1 단계. 유지보수 100배.

추신 58. guard 5 종류의 진짜 효과 — fail fast로 디버깅 1000배 쉬움.

추신 59. 5 패턴의 진짜 효과 — 함수 LOC 25→8 줄 절반. McCabe 8→2.5 4배.

추신 60. radon + ruff C901 자동 = 매 commit 5초 검사. 1년 누적 30시간 절약.

추신 61. 본인의 첫 5 패턴 적용 후 첫 PR — 5명 머지 30분 (vs 옛 2시간). 4배.

추신 62. 본 H의 진짜 메시지 — "코드는 작성보다 읽기·수정이 100배 흔하다." 5 패턴이 그 100배 효율의 도구.

추신 63. **본 H 100%** ✅ — Ch008 H6 운영 학습 완료. 다음 H7 원리! 🐾

추신 64. early return + guard 5 종 + Pydantic 자동화 = 자경단 외부 입력 100% 안전.

추신 65. 5 패턴 적용 시점 (dict·early·함수 분리·polymorphism·comp) 자경단 매일 결정.

추신 66. radon CC A (1-5)·B (6-10)·C (11-20)·D/E/F 위험. 자경단 표준 A~B만.

추신 67. radon MI 75+ 좋음·65+ OK·65 미만 리팩토링. 자경단 매주 검토.

추신 68. Maintainability Index = Halstead Volume + McCabe + LOC + Comments 4 측정 통합.

추신 69. ruff C901 = mccabe lint. pre-commit hook으로 강제.

추신 70. 자경단 매월 12시간 운영 (commit 5초 + PR 5분 + 매주 1h + 매월 30분 + 매분기 1h) = 매년 144시간 = 평생 자산.

추신 71. **본 H 100% 끝** ✅✅✅ — Ch008 H6 운영 마침. 자경단 1년 후 시니어 패턴! 🐾🐾🐾🐾🐾🐾🐾🐾

추신 72. early return의 옛 비판 — "single exit point가 디버깅 쉬움". 1990년대 C 시대 신화. 현대 IDE/디버거는 다 분기 처리.

추신 73. guard clause는 영구히 함수 표준. 모든 외부 입력 검증.

추신 74. fail fast의 진짜 가치 — log + traceback이 명확한 에러 위치 알려줌. 30초 디버깅 vs 30분.

추신 75. **본 H 진짜 마지막** ✅ — Ch008 H6 운영 학습 완료. 다음 H7 원리/내부에서 iterator/generator/yield/async! 🐾

추신 76. 본 H가 자경단 본인의 1년 후 시니어 양식의 핵심 5 패턴. 평생 적용.

추신 77. 본 H 학습 후 본인의 첫 행동 — `pip install radon` + `radon cc src/ -a` 한 줄. 5분에 본인 코드 평가.

추신 78. 자경단 wiki — "내 첫 5 패턴 적용 후 PR 머지 30분" 한 줄 적기. 평생 기념.

추신 79. **본 H 100% 진짜 마지막** ✅✅✅✅✅ — Ch008 H6 운영 학습 100% 완료. 62/960 = 6.46% 자경단 진행. 다음 H7! 🐾🐾🐾🐾🐾🐾🐾
