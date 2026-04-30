# Ch010 · H3 — collections 4 도구 셋업 — rich·json·pprint·abc

> 고양이 자경단 · Ch 010 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 첫째 — rich.print로 예쁜 collections 출력
3. 둘째 — json 모듈로 직렬화
4. 셋째 — pprint로 옛 표준
5. 넷째 — collections.abc 검사
6. 자경단 매일 디버깅
7. 다섯 시나리오와 처방
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요.

지난 H2 회수. 자료구조 8개념. list, tuple, dict, set, frozen, collections, abc.

이번 H3는 collections 디버깅 도구.

오늘의 약속. **본인이 dict와 list를 예쁘게 출력하고 검사할 수 있습니다**.

자, 가요.

---

## 2. 첫째 — rich.print로 예쁜 collections 출력

```python
from rich import print

data = {
    "cats": ["까미", "노랭이"],
    "ages": {"까미": 3, "노랭이": 2},
    "colors": {"black", "yellow"},
}

print(data)
```

기본 print보다 색깔, 들여쓰기, 큰따옴표 자동.

```python
from rich.pretty import pprint
pprint(data, indent_guides=True)
```

들여쓰기 가이드 라인 추가.

자경단 매일 dict 디버깅.

---

## 3. 둘째 — json 모듈로 직렬화

```python
import json

# dict → JSON string
data = {"name": "까미", "age": 3}
s = json.dumps(data, ensure_ascii=False, indent=2)
print(s)
# {
#   "name": "까미",
#   "age": 3
# }

# JSON string → dict
parsed = json.loads(s)

# 파일에서 읽기/쓰기
with open("cats.json", "w") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

with open("cats.json") as f:
    loaded = json.load(f)
```

`ensure_ascii=False`로 한글 그대로. `indent=2`로 들여쓰기.

자경단 매일 API 응답 처리.

---

## 4. 셋째 — pprint로 옛 표준

```python
from pprint import pprint, pformat

data = {"cats": ["까미"] * 100}
pprint(data, width=80, depth=2)

s = pformat(data)   # 문자열로
```

rich보다 단순. 표준 라이브러리. 의존성 없음.

자경단은 rich 우선, pprint는 의존성 없을 때.

---

## 5. 넷째 — collections.abc 검사

```python
from collections.abc import Iterable, Mapping, Sequence

def first(items):
    if not isinstance(items, Iterable):
        raise TypeError("iterable이 필요")
    return next(iter(items))

def merge(a, b):
    if not isinstance(a, Mapping) or not isinstance(b, Mapping):
        raise TypeError("dict가 필요")
    return {**a, **b}
```

abc로 duck typing 안전.

---

## 6. 자경단 매일 디버깅

자경단 다섯 명의 매일 의식.

**1. dict 들여다보기** → `from rich import print`

**2. JSON 응답 분석** → json + jq

**3. 큰 list 일부만** → `pprint(data, depth=2)`

**4. 자료구조 type 검증** → collections.abc

**5. 성능 의심** → sys.getsizeof + dis

다섯. 자경단 매일.

---

## 7. 다섯 시나리오와 처방

**시나리오 1: dict가 너무 큼**

처방. `pprint(data, depth=2)` 또는 `print(list(data.keys())[:5])`.

**시나리오 2: JSON 파싱 실패**

처방. try/except + 응답 일부 print.

**시나리오 3: dict 순서 이상**

처방. 3.7+ 보장. 옛 코드면 OrderedDict.

**시나리오 4: list 메모리**

처방. `sys.getsizeof(lst)`.

**시나리오 5: set이 list보다 느림**

처방. set은 추가/제거 빠름. 정렬 필요 시 list.

---

## 8. 흔한 오해 다섯 가지

**오해 1: print만 충분.**

큰 dict는 rich.

**오해 2: json은 옛 도구.**

API 표준.

**오해 3: pprint 매일.**

rich가 모던.

**오해 4: abc는 시니어.**

함수 인자 type check.

**오해 5: collections만 컬렉션.**

list, tuple, dict, set이 built-in.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. rich vs pprint?**

rich 색깔, pprint 의존성 없음.

**Q2. json indent 매번?**

production 안 함. dev 시 indent=2.

**Q3. abc 매일?**

가끔. 함수 인자 검증.

**Q4. JSON에 dict?**

dict가 JSON object와 일치.

**Q5. 한글 깨짐?**

ensure_ascii=False.

---

## 10. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, IDE 무리한 셋업. 안심 — 5분.
둘째, type hint 누락. 안심 — 첫날부터.
셋째, formatter 안 씀. 안심 — black.
넷째, debugger 모름. 안심 — `breakpoint()`.
다섯째, 가장 큰 — venv 안 만듦. 안심 — 매 프로젝트.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 세 번째 시간 끝.

rich, json, pprint, abc 4 도구.

다음 H4는 30+ 도구.

```python
python3 -c 'from rich import print; print({"cats":["까미","노랭이"]})'
```

---

## 👨‍💻 개발자 노트

> - rich Pretty: indent guides, terminal width, custom encoders.
> - json default param: 커스텀 encoder.
> - pprint sort_dicts=False: 3.8+. insertion order.
> - collections.abc: 22개 ABC.
> - 다음 H4 키워드: heapq · bisect · deque · Counter · 30 도구.
