# Ch010 · H5 — exchange v4 데모 — collections 통합 적용

> 고양이 자경단 · Ch 010 · 5교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. v3 → v4 진화 표
3. 0~5분 — Counter로 통화 빈도
4. 5~10분 — defaultdict로 그룹화
5. 10~15분 — namedtuple / @dataclass for Conversion
6. 15~20분 — heapq로 top 5 환율
7. 20~25분 — itertools.groupby로 통계
8. 25~30분 — 실행과 검증
9. v3 vs v4 다섯 차이
10. 다섯 사고와 처방
11. 흔한 오해 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요.

지난 H4 회수. 30+ collections 도구.

이번 H5는 v3 → v4. collections 통합.

오늘의 약속. **본인의 v4가 collections 다섯 도구를 동원합니다**.

자, 가요.

---

## 2. v3 → v4 진화 표

| 항목 | v3 | v4 |
|------|-----|-----|
| 줄 수 | 200 | 250 |
| collections 사용 | dict, list | Counter, defaultdict, namedtuple, heapq, groupby |
| 통계 기능 | 없음 | top-N, 그룹화, 빈도 |
| HISTORY | list of dict | list of namedtuple |

---

## 3. 0~5분 — Counter로 통화 빈도

```python
from collections import Counter

# 환산 history에서 가장 많이 사용된 통화
def most_used_currencies(history, n=3):
    """상위 N개 통화."""
    currencies = [
        c.from_curr for c in history
    ] + [
        c.to_curr for c in history
    ]
    counter = Counter(currencies)
    return counter.most_common(n)
```

Counter가 빈도수 자동.

---

## 4. 5~10분 — defaultdict로 그룹화

```python
from collections import defaultdict

# 통화별 평균 금액
def avg_by_currency(history):
    """from_curr별 금액 평균."""
    by_curr = defaultdict(list)
    for c in history:
        by_curr[c.from_curr].append(c.amount)
    
    return {
        curr: sum(amounts) / len(amounts)
        for curr, amounts in by_curr.items()
    }
```

defaultdict로 KeyError 면역. dict comp으로 평균.

---

## 5. 10~15분 — namedtuple / @dataclass for Conversion

```python
from collections import namedtuple
from dataclasses import dataclass
from datetime import datetime

# namedtuple 버전 (간단)
Conversion = namedtuple("Conversion", ["amount", "from_curr", "to_curr", "result", "timestamp"])

c = Conversion(50.0, "USD", "KRW", 65000.0, datetime.now())
print(c.amount)   # 50.0
print(c[0])       # 50.0 (tuple처럼)
```

namedtuple은 tuple + 이름. 가벼움.

@dataclass는 H5 (Ch009)에서 봤어요.

---

## 6. 15~20분 — heapq로 top 5 환율

```python
import heapq

# 최고/최저 환율
def top_rates(history, n=5):
    """결과 금액 기준 상위 N개."""
    return heapq.nlargest(n, history, key=lambda c: c.result)

def cheapest_conversions(history, n=5):
    """결과 금액 기준 하위 N개."""
    return heapq.nsmallest(n, history, key=lambda c: c.result)
```

heapq.nlargest/nsmallest은 sorted보다 빠름. top-N 패턴.

---

## 7. 20~25분 — itertools.groupby로 통계

```python
from itertools import groupby
from operator import attrgetter

# 날짜별 그룹화
def group_by_date(history):
    """timestamp의 날짜로 그룹."""
    sorted_history = sorted(history, key=lambda c: c.timestamp.date())
    groups = {}
    for date, items in groupby(sorted_history, key=lambda c: c.timestamp.date()):
        groups[date] = list(items)
    return groups

# 통화 쌍별 그룹
def group_by_pair(history):
    """(from, to) 쌍으로 그룹."""
    by_pair = defaultdict(list)
    for c in history:
        by_pair[(c.from_curr, c.to_curr)].append(c)
    return dict(by_pair)
```

groupby는 연속된 같은 key만. 정렬 먼저 필요. defaultdict가 더 직관적인 경우 많음.

---

## 8. 25~30분 — 실행과 검증

```python
def main():
    # ... 기존 메뉴 ...
    
    # 새 메뉴 옵션 5: 통계
    if choice == "5":
        show_stats(HISTORY)


def show_stats(history):
    """통계 출력."""
    if not history:
        print("[yellow]히스토리 없음[/yellow]")
        return
    
    print("\n[bold]=== 통계 ===[/bold]")
    
    # 1. 가장 많이 사용된 통화
    top_currs = most_used_currencies(history, n=3)
    print(f"가장 많이 사용된 통화: {top_currs}")
    
    # 2. 통화별 평균
    avgs = avg_by_currency(history)
    print(f"통화별 평균: {avgs}")
    
    # 3. 상위 결과 5개
    top5 = top_rates(history, n=5)
    print(f"상위 결과: {[c.result for c in top5]}")
```

진짜 출력.

```
=== 통계 ===
가장 많이 사용된 통화: [('USD', 5), ('KRW', 4), ('JPY', 2)]
통화별 평균: {'USD': 75.0, 'EUR': 100.0}
상위 결과: [130000.0, 65000.0, ...]
```

v4가 통계 기능까지. 자경단 표준.

---

## 9. v3 vs v4 다섯 차이

**1. Counter**. 빈도수 자동.

**2. defaultdict**. 그룹화.

**3. namedtuple**. immutable Conversion.

**4. heapq**. top-N 빠름.

**5. groupby**. 시계열 그룹.

다섯 차이.

---

## 10. 다섯 사고와 처방

**사고 1: namedtuple 수정**

처방. immutable. dataclass로 교체.

**사고 2: defaultdict 키 자동 생성**

처방. .get(key) 또는 if key in d.

**사고 3: heapq min-heap만**

처방. max는 부호 반전.

**사고 4: groupby 정렬 안 함**

처방. sorted 먼저.

**사고 5: Counter mutable**

처방. counter.update(other).

---

## 11. 흔한 오해 다섯 가지

**오해 1: collections 다 써야.**

매일 5개. 가끔 더.

**오해 2: heapq는 데이터가 작으면 의미 없음.**

top-N은 작은 데이터도 빠름.

**오해 3: namedtuple vs @dataclass.**

immutable이면 namedtuple, mutable면 dataclass.

**오해 4: groupby 어렵다.**

정렬 + iter.

**오해 5: Counter는 데이터팀 도구.**

자경단 매일.

---

## 12. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, finish 먼저. 안심 — 30분 시도.
둘째, 들여쓰기. 안심 — black.
셋째, 변수 충돌. 안심 — local.
넷째, 출력 안 봄. 안심 — print 한 줄.
다섯째, 가장 큰 — GitHub 안 올림. 안심 — 첫 .py도.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 다섯 번째 시간 끝.

v3 → v4. Counter, defaultdict, namedtuple, heapq, groupby.

다음 H6는 운영. 자료구조 선택, 성능, 메모리.

```bash
black exchange_v4.py
```

---

## 👨‍💻 개발자 노트

> - Counter.most_common(N): heap 사용. O(n log N).
> - defaultdict 함정: 키 자동 생성으로 메모리 사고.
> - namedtuple._asdict(): dict로 변환.
> - heapq.merge: 정렬된 iterator 병합.
> - groupby vs collections.defaultdict: 연속 vs 전체.
> - 다음 H6 키워드: 자료구조 선택 5 패턴 · 성능 비교 · 메모리.
