# Ch010 · H8 — 7H 회고 + v4 진화 + Ch011 다리

> 고양이 자경단 · Ch 010 · 8교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속
2. Ch010 7시간 회고
3. v3 → v4 진화
4. collections 다섯 원리
5. 5년 자산
6. Ch011로 가는 다리
7. 마무리

---

## 1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속

자, 안녕하세요. 본 챕터의 마지막.

지난 H7 회수. dict hash, list array, hash 함수.

오늘의 약속. **collections 5년 자산 정리**.

자, 가요.

---

## 2. Ch010 7시간 회고

**H1** — 네 친구 list, tuple, dict, set.

**H2** — 8개념 깊이.

**H3** — rich, json, pprint, abc 4 도구.

**H4** — 30+ 도구. heapq, bisect, itertools.

**H5** — v4. Counter, defaultdict, namedtuple, heapq, groupby.

**H6** — 자료구조 선택, 성능, 메모리.

**H7** — hash table 내부.

**H8** — 회고.

7시간이 데이터 토대.

---

## 3. v3 → v4 진화

| 항목 | v3 | v4 |
|------|-----|-----|
| 줄 수 | 200 | 250 |
| collections | dict, list | + Counter, defaultdict, namedtuple, heapq, groupby |
| 통계 | 없음 | top-N, 그룹화, 빈도 |

5 collections 도구 동원.

---

## 4. collections 다섯 원리

**원리 1 — lookup 빈번하면 dict, unique면 set, 순서면 list**.

**원리 2 — immutable 우선** (tuple, frozenset, namedtuple).

**원리 3 — Counter는 빈도 표준**.

**원리 4 — defaultdict는 그룹화 표준**.

**원리 5 — heapq는 top-N 표준**.

다섯. 5년.

---

## 5. 5년 자산

**개념** — 4 자료형 + 8개념 + collections 5 도구 + 30 메서드.

**도구** — heapq, bisect, itertools, Counter, defaultdict.

**원리** — 다섯.

**v4 코드** — 250줄.

**자신감** — 자료구조 선택 직관.

5년.

---

## 6. Ch011로 가는 다리

다음 챕터 Ch011은 문자열·정규식. collections의 텍스트.

본인의 dict의 key, list의 요소가 거의 다 string. string 처리가 코드의 30%.

---

## 7. 흔한 실수 다섯 + 안심 — 회고 학습 편

첫째, collections만 외움. 안심 — 매일 쓰는 셋 중 둘.
둘째, 큰 데이터 처리 못 함. 안심 — generator + chunk.
셋째, GitHub 안 올림. 안심 — 첫 .py도.
넷째, 다음 챕터 안 감. 안심 — 두 주 후 Ch011.
다섯째, 가장 큰 — Python 한 챕터로 끝. 안심 — Ch011-014 더.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 8. 마무리

박수. 본인이 collections 8시간 끝까지.

본 챕터 끝. 다음 — Ch011 H1.

```python
from collections import Counter
print(Counter("자경단고양이"))
```

---

## 👨‍💻 개발자 노트

> - 자료구조 선택이 성능 1차 결정.
> - 다음 챕터 Ch011: str, regex.
