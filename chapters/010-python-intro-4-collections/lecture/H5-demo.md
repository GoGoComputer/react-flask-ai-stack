# Ch010 · H5 — exchange v4 데모 — collections 통합 적용

> 고양이 자경단 · Ch 010 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. v3 → v4 진화 표
3. 0~5분 — Counter로 통화 빈도
4. 5~10분 — defaultdict로 그룹화
5. 10~15분 — namedtuple로 Conversion
6. 15~20분 — heapq로 top 5 환율
7. 20~25분 — itertools.groupby로 통계
8. 25~30분 — 실행과 검증
9. v3 vs v4 다섯 차이
10. 다섯 사고와 처방
11. 흔한 오해 다섯 가지
12. 흔한 실수 다섯 + 안심
13. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
from collections import Counter, defaultdict, namedtuple
import heapq
from itertools import groupby

Counter(currencies).most_common(3)        # 빈도 top-3
heapq.nlargest(5, history, key=lambda c: c.result)   # 상위 5
```

```bash
black exchange_v4.py && python3 exchange_v4.py
```

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다시 만났어요. 자료구조 챕터의 다섯 번째 시간, 드디어 데모예요. 오늘은 강의를 듣기만 하는 게 아니라, 본인이 손으로 따라 치는 시간이에요. 키보드 앞에 앉으세요. 데모는 손가락으로 배우는 시간이거든요.

지난 H4를 한 줄로 회수할게요. 본인은 자료구조 30+ 도구를 카탈로그로 구경했어요. 기본 메서드, collections 모듈(Counter·defaultdict 등), heapq, bisect, itertools요. 그런데 카탈로그는 구경이었어요. 오늘은 그걸 손으로 써요. 구경한 도구를 손으로 쓰면, 비로소 본인 것이 되거든요.

이번 H5는 본인의 환율 계산기를 또 키우는 시간이에요. Ch007에서 v1 50줄, Ch008에서 v2 150줄, Ch009에서 v3 200줄을 만들었죠. 오늘은 v4예요. 250줄로 자라요. 그런데 이번엔 단순히 길어지는 게 아니라, "통계 기능"을 더해요. 환율 계산기가 그동안의 환산 기록(history)을 분석해서, "가장 많이 쓴 통화", "통화별 평균", "상위 환산 5개" 같은 통계를 보여 주게요. 그 통계를 오늘 배운 collections 도구로 만들어요.

오늘의 약속은 이거예요. **본인의 v4가 collections 다섯 도구를 동원합니다**. Counter로 빈도를 세고, defaultdict로 그룹을 묶고, namedtuple로 기록을 담고, heapq로 top-N을 구하고, groupby로 시계열을 묶어요. H4에서 구경한 다섯 도구가 한 프로그램에서 다 일하는 거예요. 30분 동안 한 줄씩 같이 쳐요. 다 치고 나면, 본인의 환율 계산기가 "계산기"에서 "분석 도구"로 진화해요.

오늘 데모가 특별한 이유를 하나 말할게요. 본인은 지금까지 자료구조를 "배우기만" 했어요. 그런데 오늘은 그걸로 "진짜 쓸모 있는 기능"을 만들어요. 통계 기능이요. 누가 본인의 환율 계산기를 쓰면, "당신이 가장 많이 쓴 통화는 USD네요" 같은 걸 알려 줘요. 이게 데이터를 다루는 진짜 이유예요. 데이터를 모으는 건 그 자체가 목적이 아니라, 거기서 의미를 뽑아 사람에게 보여 주려는 거거든요. 본인이 오늘 만드는 통계가 작아 보여도, 이게 모든 데이터 분석의 씨앗이에요. 넷플릭스의 "당신을 위한 추천", 쇼핑몰의 "이 상품을 산 사람들이 함께 산 상품", 다 본인이 오늘 만드는 것과 같은 원리예요. 데이터를 모으고, 묶고, 세고, 순위를 매기는 거죠. 규모만 다를 뿐이에요. 자, 가요.

---

## 2. v3 → v4 진화 표

먼저 v3에서 v4로 뭐가 달라지는지 표로 볼게요.

| 항목 | v3 (Ch009) | v4 (Ch010) |
|------|-----------|-----------|
| 줄 수 | 200 | 250 |
| collections 사용 | dict, list | Counter·defaultdict·namedtuple·heapq·groupby |
| 통계 기능 | 없음 | top-N·그룹화·빈도 |
| HISTORY | list of dict | list of namedtuple |

보세요. v3는 함수 기술(데코레이터·closure)로 우아해졌다면, v4는 자료구조 도구로 "분석 능력"을 얻어요. 그동안 환율 계산기는 환산만 했는데, 이제 그 기록을 모아서 통계를 내요. "당신이 가장 많이 환산한 통화는 USD입니다", "USD의 평균 환산액은 7만 5천 원입니다" 같은 걸요. 이게 진짜 프로그램이 데이터를 다루는 모습이에요.

오늘 30분의 흐름을 미리 한눈에 보여 줄게요. 0~5분에 Counter로 통화 빈도를 세고, 5~10분에 defaultdict로 통화별 평균을 내고, 10~15분에 namedtuple로 기록 그릇을 만들고, 15~20분에 heapq로 상위 5개를 뽑고, 20~25분에 groupby로 날짜별 그룹을 만들고, 25~30분에 다 합쳐 통계 메뉴를 실행해요. 빈도·평균·기록·순위·그룹. 데이터에서 뽑을 수 있는 거의 모든 종류의 통계를 한 챕터에서 다 만들어 보는 거예요. 이 30분이 자료구조 챕터의 클라이맥스예요. H2의 개념, H4의 도구가 여기서 다 실전이 되거든요. 자, 5분씩 끊어서 하나씩 만들어요.

---

## 3. 0~5분 — Counter로 통화 빈도

첫 5분. Counter로 "가장 많이 쓴 통화"를 구해요. "내가 어떤 통화를 자주 환산했지?"를 보여 주는 통계예요.

```python
from collections import Counter

def most_used_currencies(history, n=3):
    """가장 많이 사용된 상위 N개 통화."""
    currencies = [c.from_curr for c in history] + [c.to_curr for c in history]
    counter = Counter(currencies)
    return counter.most_common(n)
```

첫 5분이니 긴장하지 마세요. 통계 함수는 정해진 모양이 있어요. "데이터를 받아서, collections 도구로 가공해서, 결과를 돌려준다." 이 골격만 익히면 어떤 통계든 짜요. most_used_currencies도 그 골격이에요. history를 받아서, Counter로 가공해서, most_common 결과를 돌려주죠.

한 줄씩 읽을게요. `history`는 그동안의 환산 기록 리스트예요. 각 기록에서 출발 통화(from_curr)와 도착 통화(to_curr)를 다 모아 하나의 큰 리스트로 만들어요(comprehension 두 개를 `+`로 이어서요). 그 다음 `Counter`로 빈도를 세고, `most_common(n)`으로 상위 n개를 뽑아요. 이게 끝이에요.

만약 Counter가 없었다면? 빈 dict를 만들고, for로 돌면서 `if 통화 in dict: dict[통화] += 1 else: dict[통화] = 1`을 일일이 짜야 해요. 그리고 빈도순 정렬도 직접 해야 하죠. 여러 줄이 돼요. 그런데 Counter 한 줄이 그걸 다 해 줘요. H4에서 본 "빈도는 Counter"가 본인 코드에서 동작하는 거예요. 본인이 통화 사용 통계를 세 줄로 만든 거예요. 자, 첫 도구가 동작했어요.

여기서 데모를 어떻게 들으면 좋은지 한 가지 말할게요. 절대 눈으로만 따라오지 마세요. 진짜로 키보드를 두드리세요. 강의를 멈추고, 본인이 Ch009에서 만든 exchange_v3.py를 열고, 거기에 이 함수들을 하나씩 추가하세요. 본인의 history에 환산 기록 몇 개를 넣어 두고, most_used_currencies를 불러서 진짜 결과가 나오는지 보세요. 오타가 나도 좋아요. 에러를 보고 고치면서 더 배워요. 데모의 가치는 "보는 것"이 아니라 "손가락이 기억하는 것"이에요. Counter를 눈으로 백 번 본 사람보다, 손으로 한 번 쳐서 `[('USD', 5), ...]`가 출력되는 걸 본 사람이 Counter를 진짜 아는 거예요.

그리고 `[c.from_curr for c in history] + [c.to_curr for c in history]`이 한 줄을 한 번 더 음미하세요. comprehension 두 개를 `+`로 이어 붙였죠. 출발 통화 목록과 도착 통화 목록을 합친 거예요. Ch008에서 배운 comprehension이 여기서 데이터를 만드는 데 쓰여요. 자료구조(list)·흐름(comprehension)이 어울리는 거죠. 본인이 지금까지 배운 게 이렇게 한 줄에서 만나요. 통화를 모으고(comprehension), 빈도를 세고(Counter), 상위를 뽑는(most_common) 거예요. 세 도구가 손을 잡아 통계 한 줄이 돼요.

---

## 4. 5~10분 — defaultdict로 그룹화

다음 5분. defaultdict로 "통화별 평균 금액"을 구해요. "USD는 평균 얼마씩 환산했지?"를 보여 주는 통계예요.

```python
from collections import defaultdict

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

`defaultdict(list)`로 "통화 → 금액들"의 묶음을 만들어요. for로 돌면서 `by_curr[c.from_curr].append(c.amount)`만 반복하면, 통화별로 금액이 모여요. 여기서 defaultdict의 마법이 보여요. 보통 dict라면 처음 보는 통화 키에서 KeyError가 나는데, defaultdict(list)는 자동으로 빈 리스트를 만들어 줘요. "이 통화가 처음인가?"를 일일이 확인 안 해도 되죠. H4에서 본 "그룹은 defaultdict"예요. 만약 일반 dict로 짰다면 `if c.from_curr not in by_curr: by_curr[c.from_curr] = []` 같은 줄을 매번 넣어야 해요. defaultdict가 그 한 줄을 없애 주는 거예요. 작아 보이지만, 그룹 묶기를 할 때마다 이 한 줄이 빠지면 코드가 확 깔끔해져요.

그리고 마지막에 dict comprehension으로 각 묶음의 평균을 구해요. `sum(amounts) / len(amounts)`로요. H2에서 본 "한 줄 분해"가 여기 그대로 쓰였죠. 통화별로 금액을 묶고(defaultdict), 각 묶음의 평균을 내는(dict comp) 거예요. 데이터를 그룹으로 묶어 집계하는, 백엔드의 전형적인 패턴이에요. 본인이 두 번째 도구를 손에 쥐었어요.

이 "그룹으로 묶어 집계하기" 패턴이 정말 중요해요. 실무 데이터 처리의 절반이 이거거든요. "지역별 매출 합계", "카테고리별 상품 개수", "사용자별 주문 횟수", "날짜별 방문자 수" 다 이 패턴이에요. 무언가를 어떤 기준으로 묶고(group), 각 그룹을 집계(합계·평균·개수)하는 거죠. SQL을 배우면 GROUP BY라는 게 나오는데, 그게 정확히 이거예요. 본인이 지금 Python의 defaultdict로 하는 걸, 나중에 데이터베이스에선 GROUP BY로 해요. 같은 사고예요. 그러니 이 패턴 하나를 손에 익히면, Python에서도 SQL에서도 데이터를 집계할 수 있어요. defaultdict로 묶고 집계하는 이 다섯 줄이, 데이터 다루기의 핵심 패턴이에요. 통째로 외워 두세요.

집계 함수도 sum·len 말고 다양하게 쓸 수 있어요. `max(amounts)`면 통화별 최댓값, `min(amounts)`면 최솟값, `len(amounts)`면 환산 횟수예요. 위 코드의 `sum/len`을 `max`로 바꾸면 "통화별 최고 환산액"이 되죠. 그러니까 이 패턴은 한 번 짜 두면, 집계 부분만 바꿔서 온갖 통계를 만들 수 있어요. 본인이 defaultdict로 묶는 틀을 익히면, 그 위에서 평균·합계·최대·최소·개수를 자유롭게 뽑아요. 데이터에서 의미를 캐내는 본인만의 도구가 생기는 거예요.

---

## 5. 10~15분 — namedtuple로 Conversion

이제 환산 기록을 담는 그릇을 namedtuple로 만들어요. 통계를 내려면 먼저 기록을 잘 담을 그릇이 있어야 하거든요.

```python
from collections import namedtuple
from datetime import datetime

# namedtuple 버전 (가볍고 못 바꿈)
Conversion = namedtuple("Conversion", ["amount", "from_curr", "to_curr", "result", "timestamp"])

c = Conversion(50.0, "USD", "KRW", 65000.0, datetime.now())
print(c.amount)      # 50.0 — 이름으로 접근
print(c[0])          # 50.0 — tuple처럼 인덱스로도
```

`namedtuple`로 Conversion이라는 새 타입을 만들었어요. amount·from_curr·to_curr·result·timestamp 다섯 필드를 가진 짝이에요. 이제 환산 기록 하나하나가 그냥 dict가 아니라, 이름표가 붙은 Conversion이에요. `c.amount`처럼 이름으로 접근하니 `c["amount"]`보다 깔끔하고, `c[0]`처럼 tuple로도 접근돼요. H2·H4에서 본 namedtuple의 실전이에요.

Ch009 H5에서는 Conversion을 @dataclass로 만들었죠. namedtuple과 dataclass의 차이를 짚을게요. namedtuple은 가볍고 못 바꿔요(immutable). dataclass는 더 풍부하고 메서드도 가질 수 있어요. 환산 기록처럼 "한 번 만들면 안 바뀌는 가벼운 데이터"는 namedtuple이 딱이에요. 안 바뀐다는 보장이 오히려 안전하고, 메모리도 적게 쓰거든요. 그래서 v4의 history는 namedtuple 리스트로 바꿨어요. "환산은 한 번 일어나면 기록으로 남고 안 바뀐다"는 의미를 namedtuple이 표현하는 거예요. 본인이 세 번째 도구를 손에 쥐었어요.

여기서 자료구조 선택의 중요한 교훈이 나와요. "데이터의 의미가 그릇을 정한다." 환산 기록은 "일어난 사실"이에요. 일어난 사실은 안 바뀌죠. 어제 USD를 환산한 기록을 오늘 고치면 안 되잖아요. 그 "안 바뀜"이라는 의미를 namedtuple(immutable)이 코드로 표현해요. 만약 이걸 일반 dict로 두면, 누가 실수로 `record["amount"] = 999`처럼 과거 기록을 바꿔 버릴 수 있어요. namedtuple로 두면 그게 아예 불가능해요. 시도하면 에러가 나죠. 그래서 namedtuple이 데이터를 보호하는 거예요. Ch010 H2에서 본 immutable의 가치가 여기서 실전이 돼요. 본인이 자료구조를 고를 때, "이 데이터는 바뀌어도 되나?"를 물으세요. 안 바뀌어야 하면 immutable(tuple·namedtuple·frozenset)을, 바뀌어야 하면 mutable(list·dict)을 고르는 거예요. 그 선택이 본인 코드를 안전하게 만들어요.

그리고 namedtuple의 편리한 기능 하나. `c._asdict()`를 부르면 namedtuple을 dict로 바꿔 줘요. JSON으로 내보낼 때(H3에서 배운 json.dumps) 유용하죠. 환산 기록을 namedtuple로 다루다가, 파일에 저장하거나 API로 보낼 땐 `_asdict()`로 dict로 바꿔서 json.dumps에 넘기는 거예요. 또 `c._replace(amount=100)`을 부르면, amount만 바꾼 "새" namedtuple을 만들어 줘요. 원본은 그대로 두고요. immutable이라 원본은 못 바꾸지만, 일부를 바꾼 복사본은 만들 수 있는 거죠. 이게 immutable 데이터를 다루는 방식이에요. "바꾸는" 게 아니라 "바꾼 새것을 만드는" 거예요. Ch009 H6의 pure function 정신과 통하죠.

---

## 6. 15~20분 — heapq로 top 5 환율

이제 heapq로 "상위 5개 환산"을 구해요. "가장 큰 환산이 뭐였지?"를 보여 주는 통계예요.

```python
import heapq

def top_rates(history, n=5):
    """결과 금액 기준 상위 N개."""
    return heapq.nlargest(n, history, key=lambda c: c.result)

def cheapest_conversions(history, n=5):
    """결과 금액 기준 하위 N개."""
    return heapq.nsmallest(n, history, key=lambda c: c.result)
```

`heapq.nlargest(5, history, key=lambda c: c.result)` 한 줄이면, 결과 금액이 가장 큰 5개 환산이 나와요. `key`로 "무엇을 기준으로"를 lambda로 주죠. Ch009에서 배운 lambda가 여기서 빛나요. nsmallest는 반대로 가장 작은 5개고요. H4에서 본 "top-N은 heapq"예요. 이 key 옵션은 sorted에서도 똑같이 쓰는 거라, 한 번 익히면 정렬·top-N 어디서나 써먹어요. "무엇을 기준으로 줄 세울지"를 lambda로 주는 거죠. 나이순이면 `key=lambda c: c.age`, 이름순이면 `key=lambda c: c.name`. 기준만 바꾸면 돼요.

왜 sorted로 정렬해서 앞 5개를 자르지 않고 heapq를 쓰냐면, 의도가 분명하고 큰 데이터에서 더 빠르거든요. `heapq.nlargest(5, ...)`는 "상위 5개"라고 코드가 말하잖아요. `sorted(...)[:5]`보다 읽기 좋아요. 그리고 환산 기록이 10만 개로 쌓여도, 전체를 정렬하지 않고 상위 5개만 빠르게 추려요. 본인이 네 번째 도구를 손에 쥐었어요. 통계가 점점 풍부해지죠.

top-N 통계가 실전에서 얼마나 흔한지 한 번 생각해 보세요. "이번 달 매출 top-10 상품", "가장 활동적인 사용자 top-5", "가장 오래 걸린 요청 top-20"… 어디서나 "상위 몇 개"를 보고 싶어 해요. 사람은 전체 100만 개를 다 못 보지만, 상위 10개는 한눈에 보거든요. 그래서 데이터를 사람에게 보여줄 땐 거의 항상 "정렬 또는 top-N"을 거쳐요. heapq.nlargest가 그 top-N을 한 줄로 해 주는 거고요. 본인이 이 패턴을 손에 익히면, 어떤 데이터든 "가장 ~한 것 몇 개"를 즉시 뽑아낼 수 있어요. 그게 데이터를 사람이 이해할 수 있게 요약하는 능력이에요. 그리고 key 옵션으로 "무엇을 기준으로"를 바꾸면, 같은 데이터에서 다른 top-N을 뽑아요. 금액 기준 top-5, 날짜 기준 최신 5개, 이름 길이 기준… 기준만 바꾸면 무한한 통계가 나와요.

---

## 7. 20~25분 — itertools.groupby로 통계

이제 itertools.groupby로 "날짜별 그룹"을 만들어요. "어느 날에 환산을 몇 번 했지?"를 보여 주는 통계예요.

```python
from itertools import groupby
from collections import defaultdict

def group_by_date(history):
    """timestamp의 날짜로 그룹."""
    sorted_history = sorted(history, key=lambda c: c.timestamp.date())
    groups = {}
    for date, items in groupby(sorted_history, key=lambda c: c.timestamp.date()):
        groups[date] = list(items)
    return groups

def group_by_pair(history):
    """(from, to) 통화 쌍으로 그룹."""
    by_pair = defaultdict(list)
    for c in history:
        by_pair[(c.from_curr, c.to_curr)].append(c)
    return dict(by_pair)
```

`group_by_date`는 환산을 날짜별로 묶어요. 여기서 핵심은 첫 줄이에요. `sorted`로 먼저 정렬했죠? H4에서 강조한 "groupby 앞엔 sorted"예요. groupby는 연속된 같은 것만 묶으니까, 같은 날짜를 모으려면 먼저 정렬해야 해요. 정렬 안 하면 같은 날짜가 흩어져서 제대로 안 묶여요. 이 함정을 미리 배웠으니, 본인은 안 틀리죠. 그리고 sorted와 groupby에 같은 key 함수(`lambda c: c.timestamp.date()`)를 줬다는 걸 보세요. 정렬 기준과 그룹 기준이 같아야 제대로 묶여요. 이 "sorted + groupby 같은 key" 패턴을 통째로 외워 두면 groupby로 고생할 일이 없어요.

그리고 `group_by_pair`를 보세요. (from, to) 통화 쌍으로 묶는 건 defaultdict로 했어요. 왜 여기선 groupby 안 쓰고 defaultdict를 썼을까요? defaultdict는 정렬이 필요 없어서 더 간단하거든요. H4에서 "단순 그룹 묶기는 defaultdict가 더 쉽다"고 했죠. 그래서 자경단은 단순 그룹엔 defaultdict, 정렬된 연속 처리엔 groupby를 써요. 두 도구를 상황에 맞게 고른 거예요. 본인이 다섯 번째 도구까지 손에 쥐었어요. 오늘의 약속, collections 다섯 도구가 다 동작했어요.

여기서 `(c.from_curr, c.to_curr)`을 dict 키로 쓴 걸 주목하세요. 튜플을 키로 쓴 거예요. H2에서 "tuple은 dict 키가 될 수 있다(hashable)"고 했죠. 그게 여기서 쓰여요. "USD에서 KRW로", "USD에서 JPY로" 같은 통화 쌍 하나하나를 키로 삼아 묶는 거예요. 만약 통화 쌍을 list `[from, to]`로 만들었다면 키로 못 써요(unhashable). tuple이라 가능한 거죠. 이렇게 "여러 값의 조합을 하나의 키로" 쓸 때 tuple이 빛나요. 좌표 (x, y)별로 묶거나, (연, 월)별로 묶거나, (사용자, 날짜)별로 묶을 때요. H2에서 배운 "tuple은 키가 된다"가 실전에서 이렇게 쓰여요. 본인이 무심코 친 한 줄에, 그동안 배운 자료구조 지식이 다 녹아 있는 거예요.

---

## 8. 25~30분 — 실행과 검증

마지막 5분. 지금까지 만든 통계를 메뉴에 붙이고 다 같이 실행해요.

```python
def main():
    # ... 기존 메뉴 ...
    if choice == "5":          # 새 메뉴: 통계
        show_stats(HISTORY)

def show_stats(history):
    """통계 출력."""
    if not history:
        print("[yellow]히스토리가 없어요[/yellow]")
        return

    print("\n[bold]=== 통계 ===[/bold]")
    top_currs = most_used_currencies(history, n=3)
    print(f"가장 많이 쓴 통화: {top_currs}")
    avgs = avg_by_currency(history)
    print(f"통화별 평균: {avgs}")
    top5 = top_rates(history, n=5)
    print(f"상위 결과: {[c.result for c in top5]}")
```

`show_stats`가 오늘 만든 함수들을 다 불러서 통계를 보여줘요. Ch008 H6에서 배운 early return(`if not history: return`)으로 빈 기록을 먼저 막죠. 기록이 없는데 통계를 내려 하면 에러가 나니까, 입구에서 막는 거예요. guard clause(Ch009 H2)의 정신이죠. 그리고 show_stats가 다섯 통계 함수를 차례로 부르는 게 보이죠? 각 함수는 한 가지 통계만 책임지고(단일 책임, Ch009 H6), show_stats는 그것들을 조율해요. 이게 함수를 잘 나눈 모습이에요. 만약 통계 로직을 다 show_stats 안에 욱여넣었다면 50줄짜리 괴물이 됐을 거예요. 작은 함수 다섯 개로 나누니, 각각 테스트하기도 쉽고 읽기도 좋죠. 오늘 배운 자료구조와 지난 챕터의 함수 설계가 여기서 만나요. 실행하면 이렇게 나와요.

```
=== 통계 ===
가장 많이 쓴 통화: [('USD', 5), ('KRW', 4), ('JPY', 2)]
통화별 평균: {'USD': 75.0, 'EUR': 100.0}
상위 결과: [130000.0, 65000.0, ...]
```

보세요. 통계가 다 나와요. Counter가 빈도를, defaultdict가 평균을, heapq가 상위 5개를 구한 거예요. 본인이 오늘 짠 다섯 도구가 한 화면에서 다 일하는 거죠. 환율 계산기가 이제 단순한 계산기가 아니라, "내 환산 습관을 분석해 주는 도구"가 됐어요. 이게 본인의 첫 v4예요. 이 출력 한 화면에 본인이 오늘 배운 모든 게 동시에 일하는 모습이 담겨 있어요. 빈도도, 평균도, 순위도, 그게 다 본인이 짠 거예요.

여기서 잠깐 느껴 보세요. 30분 전 본인의 환율 계산기는 "환산만" 했어요. 지금은 그 기록을 분석해서 통계를 내요. collections 도구 다섯 개를 얹었을 뿐인데요. 데이터를 다루는 도구가 있으면, 같은 데이터에서 이렇게 풍부한 정보를 뽑아낼 수 있어요. 그게 자료구조의 힘이에요.

만약 본인이 따라 치다가 에러가 났다면, 그것도 축하해요. 진심이에요. 에러는 본인이 진짜로 코드를 짰다는 증거거든요. 가장 흔한 에러는 groupby에서 정렬을 빠뜨려서 그룹이 이상하게 나오거나, namedtuple을 수정하려다 막히는 거예요. 둘 다 오늘 배운 함정이죠. H3에서 배운 대로 rich.print로 중간 결과를 찍어 보면서, 어디서 어긋났는지 확인하세요. 예를 들어 `most_used_currencies`가 이상하면, 중간의 `currencies` 리스트를 rich로 찍어서 "통화가 제대로 모였나"를 보는 거예요. 그 디버깅 과정이 오늘 데모의 진짜 알맹이예요. 본인이 에러를 한 번 만나고 고쳤다면, 그 에러를 평생 기억해요. 다음엔 안 틀리죠. 그렇게 한 땀 한 땀 실력이 쌓여요.

그리고 이 v4가 보여주는 큰 그림이 있어요. 본인의 환율 계산기가 챕터마다 자랐죠. v1(함수)→v2(흐름)→v3(데코레이터)→v4(통계). 매번 그 챕터에서 배운 걸 같은 프로그램에 더했어요. 코드가 본인의 학습 일기가 된 거예요. git 히스토리를 보면 v1의 어설픈 50줄부터 v4의 250줄까지, 본인이 자란 게 다 남아 있어요. 그리고 이게 끝이 아니에요. Ch091에서 v5(production)로 자라요. AWS에 올라가 진짜 서비스가 되죠. 본인의 환율 계산기 하나가 두 해 코스 내내 본인과 함께 자라는 동반자예요. 5년 후 본인이 이 히스토리를 보면, 어떤 졸업장보다 본인을 잘 증명할 거예요.

---

## 9. v3 vs v4 다섯 차이

v3와 v4의 다섯 차이를 정리할게요.

**1. Counter.** 통화 사용 빈도를 자동으로 세요. v3엔 없던 거예요. most_common으로 상위 N개까지.

**2. defaultdict.** 통화별로 묶어 평균을 내요. 그룹 집계. KeyError 면역.

**3. namedtuple.** 환산 기록을 이름표 붙은 가벼운 짝으로. immutable이라 안전.

**4. heapq.** 상위/하위 N개를 빠르게. key로 기준을 골라서.

**5. groupby + tuple 키.** 날짜별 시계열 그룹, (from, to) 통화 쌍별 그룹. 여러 값의 조합을 하나의 키로.

이 다섯이 v4에 "분석 능력"을 줘요. 그런데 중요한 건, v4가 v3보다 새 계산을 하는 게 아니라는 거예요. 똑같이 환율을 계산해요. 다만 그 기록을 모아 분석하는 능력이 생긴 거죠. 데이터가 쌓이면 그 데이터에서 의미를 뽑아낼 수 있어요. 그게 통계고요. 본인은 지금 "데이터를 만드는 것"에서 "데이터에서 의미를 뽑는 것"으로 한 단계 올라간 거예요. H6에서 이 자료구조 선택을 더 깊이 파요.

이 다섯 도구를 다시 보면, 각각이 H4에서 본 "맞는 자리"에 정확히 쓰였어요. 빈도엔 Counter, 그룹 집계엔 defaultdict, 안 바뀌는 기록엔 namedtuple, top-N엔 heapq, 시계열 연속 처리엔 groupby. 도구를 상황에 맞게 고른 거죠. 이게 H4에서 강조한 "도구의 맞는 자리"가 실전이 된 모습이에요. 본인이 오늘 통계 함수를 짜면서, 무의식적으로 "이 통계엔 이 도구"를 고른 거예요. 빈도를 세고 싶을 때 자연스럽게 Counter가 손에 잡혔잖아요. 그게 도구가 몸에 배기 시작한 신호예요. 처음엔 "어떤 도구를 쓰지?" 고민하지만, 익숙해지면 상황을 보자마자 도구가 떠올라요. 본인은 오늘 그 첫걸음을 뗐어요.

---

## 10. 다섯 사고와 처방

v4를 짜며 자주 만나는 다섯 사고와 처방이에요.

**사고 1: namedtuple을 수정하려다 에러나요.** namedtuple은 못 바꿔요(immutable). 처방은 바꿔야 하면 dataclass로 교체하거나, `_replace`로 새 namedtuple을 만드는 거예요.

**사고 2: defaultdict가 키를 자동 생성해서 메모리가 늘어요.** 없는 키를 읽기만 해도 빈 값이 생겨요. 처방은 읽기만 할 땐 `.get(key)`나 `if key in d`를 쓰는 거예요. defaultdict는 "추가할 때"만 편한 거예요. 통계를 다 만든 다음엔 `dict(by_curr)`로 일반 dict로 바꿔 두면, 이 자동 생성 함정에서 벗어나요. group_by_pair에서 `return dict(by_pair)`라고 한 게 그 이유예요.

**사고 3: heapq가 가장 큰 값을 안 줘요.** min-heap이라 가장 작은 값을 줘요. 처방은 큰 게 필요하면 nlargest를 쓰거나 부호를 반전하는 거예요. H4에서 본 함정이죠.

**사고 4: groupby가 안 묶여요.** 정렬을 안 했기 때문이에요. 처방은 먼저 sorted로 정렬하는 거예요. group_by_date에서 본 그거죠.

**사고 5: Counter를 직접 수정하려 해요.** 처방은 `counter.update(other)`로 다른 Counter를 합치거나, 산술 연산(`+`)을 쓰는 거예요. 두 기간의 빈도를 합칠 때 `counter1 + counter2`면 한 줄이에요. Counter는 그냥 세기만 하는 게 아니라 빈도끼리 계산도 된다는 걸 기억하세요.

다섯 사고. 다 H2·H4에서 미리 본 함정들이에요. 그래서 본인은 오늘 안 당황했죠. 이게 강의를 순서대로 듣는 이유예요. H2에서 namedtuple의 immutable을, H4에서 groupby의 정렬 함정을 미리 봤기 때문에, 오늘 데모에서 그게 나와도 "아, 그거" 하고 넘어가요. 만약 본인이 데모만 보고 따라 쳤다면, 동작은 하겠지만 "왜 정렬을 먼저 하지?"는 몰랐을 거예요. 본인은 왜 그런지 알고 짜요. 그게 복붙하는 사람과 이해하는 사람의 차이예요. 본인이 H1부터 차근히 쌓아 온 게 오늘 보상받는 거예요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: collections를 다 써야 멋지다.**

아니에요. 매일 쓰는 건 Counter와 defaultdict 정도예요. 나머지는 필요할 때만. 안 쓰는 도구를 억지로 끼워 넣으면 코드가 복잡해져요. Ch009 H6의 KISS(단순하게)를 기억하세요. 도구를 많이 쓰는 게 멋진 게 아니라, 상황에 맞는 도구를 정확히 고르는 게 멋진 거예요.

**오해 2: heapq는 데이터가 작으면 의미 없다.**

아니에요. 작은 데이터에서도 top-N은 nlargest가 깔끔해요. 의도가 분명하거든요. `nlargest(5, ...)`는 "상위 5개"라고 코드가 말하잖아요. 속도보다 "읽기 좋음"이 nlargest를 쓰는 진짜 이유일 때가 많아요.

**오해 3: namedtuple과 dataclass 중 헷갈린다.**

간단해요. 못 바꾸는 가벼운 짝이면 namedtuple, 바꾸거나 메서드가 필요하면 dataclass예요. 헷갈리면 dataclass를 기본으로 생각하세요. 더 유연하거든요. namedtuple은 "정말 가볍고 안 바뀌어야 할 때"의 특수 선택이에요.

**오해 4: groupby는 너무 어렵다.**

정렬 먼저 하고 돌면 끝이에요. 그리고 단순 그룹은 defaultdict가 더 쉬워요. groupby는 정렬된 연속 처리에만요. 사실 본인이 매일 쓸 그룹 묶기는 거의 다 defaultdict로 충분해요. groupby는 "이미 정렬돼 있다"는 특수 상황의 도구라고 생각하면 마음이 편해요.

**오해 5: Counter는 데이터 분석 팀만 쓴다.**

아니에요. 자경단 백엔드에서 매일 써요. 빈도 세기는 어디서나 필요하거든요. "가장 많이 본 페이지", "인기 상품 top-10" 다 Counter예요.

다섯 오해를 보면, 오늘 데모의 가장 큰 수확이 보여요. 본인이 H4에서 "구경만" 한 도구들을 다 손으로 써 봤다는 거예요. Counter, defaultdict, heapq, groupby, namedtuple — 카탈로그에서 이름만 봤던 것들이, 오늘 본인 코드에서 진짜 통계를 만들었어요. 구경과 실전은 천지차이예요. 구경한 도구는 한 달이면 까먹지만, 손으로 써서 결과를 본 도구는 평생 기억해요. 그래서 카탈로그(H4) 다음에 데모(H5)가 오는 거예요. 보고, 쓰고, 익히는 거죠. 본인이 오늘 다섯 도구를 손으로 썼으니, 이제 이건 본인 것이에요. 다음에 "통화별 평균"이나 "상위 5개" 같은 게 필요하면, 오늘 친 코드가 손에서 바로 나와요.

---

## 12. 흔한 실수 다섯 + 안심 — 데모 학습 편

v4를 따라 치며 자주 빠지는 함정 다섯 개예요.

**첫째, 완벽하게 만들려다 시작을 못 하기.** 안심하세요. 일단 30분 동안 돌아가게 만드세요. 완벽은 나중에 다듬으면 돼요. 동작하는 게 먼저고, 우아함은 그 다음이에요.

**둘째, 들여쓰기 실수.** 안심하세요. black을 깔면 저장할 때 자동으로 맞춰 줘요. 손으로 고생 마세요. Python은 들여쓰기가 중요한데 black이 다 책임져 줘요.

**셋째, 변수 이름 충돌.** 안심하세요. 함수 안 지역 변수 이름을 분명히 다르게 지으세요. counter, by_curr처럼 의미 있게요. Ch009 H6의 명명 규칙이 여기서도 통해요.

**넷째, 출력을 안 보고 넘어가기.** 안심하세요. 각 함수를 만들고 바로 실행해서 출력을 확인하세요. H3에서 배운 "추측하지 말고 찍어 보기"예요. Counter를 짰으면 바로 `print(most_used_currencies(history))`로 결과를 봐야, 제대로 동작하는지 알아요. 다 만들고 한 번에 돌리면 어디서 틀렸는지 못 찾아요.

**다섯째, 가장 큰 함정 — GitHub에 안 올리기.** 안심하세요. 오늘 친 exchange_v4.py를 GitHub에. v1·v2·v3 옆에 v4를요. 본인의 성장이 git 히스토리에 남아요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 가요. 오늘 데모를 따라 치다 막히면, 이 다섯을 먼저 의심하세요. 그리고 가장 중요한 건 첫째예요. "완벽하게 만들려다 시작을 못 하기." 본인이 통계 다섯 개를 한 번에 완벽하게 짜려 하면 부담돼요. 그러지 말고, Counter 하나만 먼저 짜서 돌려 보세요. 그게 되면 defaultdict 하나 더, 그게 되면 또 하나 더. 한 번에 하나씩 쌓아 가세요. 각 단계가 동작하는 걸 확인하면서요. 그러면 30분 후엔 다섯 개가 다 동작해요. 큰 걸 한 번에 만들려 하지 말고, 작은 걸 하나씩 쌓는 것. 이게 모든 프로그래밍의 비결이에요.

---

## 13. 마무리

자, 자료구조 챕터의 다섯 번째 시간이 끝났어요. 손으로 친 데모였죠.

오늘 본인은 환율 계산기를 v3에서 v4로 키웠어요. Counter(빈도), defaultdict(그룹), namedtuple(기록), heapq(top-N), groupby(시계열)를 다 적용했어요. 30분 만에 환율 계산기에 통계 기능을 붙였죠. 계산기가 분석 도구로 진화한 거예요. 이 챕터에서 H2의 개념과 H4의 도구가, 오늘 H5에서 본인 손끝에 다 모였어요. 배운 걸 손으로 옮기는, 가장 보람찬 시간이었어요.

오늘의 약속을 지켰어요. 본인의 v4가 collections 다섯 도구를 동원했어요. H4에서 구경한 도구들이 본인 손에서 다 살아 움직였죠. 그리고 한 가지 큰 걸 느꼈을 거예요. 데이터를 다루는 도구가 있으면, 같은 데이터에서 풍부한 의미를 뽑을 수 있다는 걸요. 그게 자료구조를 배우는 이유예요. 본인은 오늘 그걸 머리가 아니라 손으로 깨달았어요.

한 가지 부탁할게요. 오늘 친 exchange_v4.py를 GitHub에 올리세요. v1에서 v4까지 진화한 본인의 환율 계산기가 git 히스토리에 남아요. 그게 본인의 포트폴리오예요. 두 해 후 누가 보면, "이 사람은 코드를 키우는 사람이구나"를 한눈에 알아요. 커밋 메시지는 "v4: collections로 통계 기능 추가" 정도로 적으면 돼요. Ch004에서 배운 git이 여기서 빛나죠. 코드를 짜는 것만큼, 그 성장을 남기는 게 중요해요. 안 남기면 사라지거든요.

오늘 본인이 한 일을 한 문장으로 남길게요. "본인은 데이터를 만드는 사람에서, 데이터에서 의미를 뽑는 사람이 됐다." 이게 큰 변화예요. 많은 초보가 데이터를 모으기만 하고 거기서 뭘 뽑을지 몰라요. 본인은 오늘 모은 데이터(환산 기록)에서 빈도·평균·순위·그룹이라는 의미를 뽑았어요. 그게 데이터 다루기의 진짜 실력이에요. 그리고 이 실력은 환율 계산기에만 쓰는 게 아니에요. 본인이 어떤 데이터를 만나든 — 사용자 로그, 판매 기록, 센서 데이터 — "이걸 어떻게 묶고 세고 순위 매길까"를 떠올릴 수 있게 됐어요. 그게 오늘 데모의 진짜 선물이에요. 통계 함수 다섯 개를 짠 것보다, "데이터에서 의미를 뽑는 사고"를 얻은 게 더 값져요.

다음 H6은 운영이에요. 오늘 만든 v4를 보며 "어떤 자료구조를 언제 골라야 하는가"를 깊이 배워요. 자료구조 선택의 안목을 기르는 시간이에요. 그 전에 마지막으로 한 줄만 쳐 보세요.

```bash
black exchange_v4.py
```

본인의 v4를 black으로 예쁘게 다듬는 거예요. 통과하면 본인 코드가 자경단 표준이에요.

마지막으로 오늘을 한 문장으로 남길게요. "데이터를 모으는 건 시작일 뿐, 거기서 의미를 뽑는 게 진짜다." 본인은 오늘 그걸 손으로 증명했어요. 환산 기록이라는 데이터에서, 다섯 가지 통계를 뽑아냈죠. 이게 본인이 앞으로 만날 모든 데이터 작업의 축소판이에요. 백엔드를 짜든, 데이터를 분석하든, AI를 다루든, 결국 "데이터에서 의미를 뽑는" 일이거든요. 본인은 오늘 그 일의 기본기를 손에 익혔어요. 다음 시간에 봐요. 자료구조 선택의 안목을 배워요. 오늘 정말 큰 일을 해냈어요. 본인의 환율 계산기가 분석 도구가 됐어요. 자랑스러워하셔도 돼요. 🐾

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - Counter.most_common(N): 내부적으로 heapq.nlargest 사용. O(n log N). 인자 없으면 전체 정렬.
> - defaultdict 함정: 없는 키를 읽기만 해도 default 생성·삽입. 읽기 전용이면 `.get`. `dict(defaultdict)`로 일반 dict 변환.
> - namedtuple: `_asdict()`(dict 변환)·`_replace(field=val)`(수정본)·`_fields`(필드명). typing.NamedTuple은 type hint·메서드 가능.
> - heapq: `nlargest`/`nsmallest`(O(n log k))·`merge`(정렬된 iterable 병합)·`heappushpop`/`heapreplace`(원자적).
> - groupby: 연속 그룹(정렬 전제)·`operator.attrgetter`/`itemgetter`로 key 함수 간결화. group은 iterator(한 번만 소비).
> - 환율 계산기 진화: v1(함수)→v2(흐름)→v3(데코·closure)→v4(collections 통계)→v5(production, Ch091).
> - 다음 H6 키워드: 자료구조 선택 트리 · 시간/공간 복잡도 · 메모리 측정 · 안티패턴.

---

## 추신

1. v3 200줄 → v4 250줄. collections로 분석 능력.
2. 오늘의 약속 — collections 다섯 도구 동원.
3. v4는 환산만 하던 계산기에 통계를 더해요.
4. Counter — 통화 빈도. most_common(3).
5. Counter 없으면 dict로 일일이 세야 해요.
6. defaultdict(list) — 통화별 금액 묶기.
7. defaultdict는 KeyError 면역. 그룹 집계.
8. dict comp로 각 그룹 평균. H2 한 줄 분해.
9. namedtuple Conversion — 이름표 붙은 가벼운 짝.
10. c.amount(이름)·c[0](인덱스) 둘 다 가능.
11. 환산 기록처럼 안 바뀌는 데이터는 namedtuple.
12. namedtuple=immutable 가벼움, dataclass=풍부.
13. heapq.nlargest(5, history, key=...) — 상위 5.
14. nlargest는 sorted[:5]보다 의도 분명·큰 데이터 빠름.
15. lambda(Ch009)로 정렬 기준 key.
16. groupby — 날짜별 시계열 그룹.
17. groupby 앞엔 sorted! 연속만 묶어요.
18. 단순 그룹은 defaultdict가 더 쉬움.
19. 두 그룹 도구를 상황에 맞게 골라요.
20. show_stats에 early return으로 빈 기록 막기.
21. v4 = 데이터를 만들기 → 의미 뽑기.
22. 사고 — namedtuple 수정·defaultdict 메모리·heap min·groupby 정렬.
23. 다 H2·H4에서 미리 본 함정. 안 당황.
24. collections 다 쓸 필요 없어요. Counter·defaultdict 매일.
25. Counter는 데이터팀 아닌 백엔드 매일 도구.
26. 손으로 친 30분 > 강의 열 시간.
27. exchange_v4.py를 GitHub에. v1→v4 성장.
28. v4는 Ch091에서 v5(production)로 또 자라요.
29. black 통과하면 자경단 표준.
30. 다음 H6은 자료구조 선택 안목. 🐾
