# Ch009 · H8 — 7H 회고 + v3 진화 + Ch010 다리

> 고양이 자경단 · Ch 009 · 8교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속
2. Ch009 7시간 회고
3. v2 → v3 진화 정리
4. 함수 다섯 원리
5. 본인의 함수 5년 자산
6. Ch010으로 가는 다리
7. 흔한 오해 다섯 가지
8. 마무리

---

## 1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속

자, 안녕하세요. 본 챕터의 마지막 시간이에요.

지난 H7 회수. LEGB scope, closure cell, frame, decorator 내부.

이번 H8은 적용 + 회고.

오늘의 약속. **본인의 함수 5년 자산 정리**.

자, 가요.

---

## 2. Ch009 7시간 회고

**H1** — 함수는 코드 재사용. 네 친구.

**H2** — 8개념. def 6 인자, return 5패턴, default, *args, type hints, docstring, lambda, closure.

**H3** — 디버깅. inspect, dis, profile.

**H4** — 18 도구. functools, decorator 5종.

**H5** — 환율 v3. @timer, @validate, closure, @property.

**H6** — 운영. pure, SOLID, DRY, KISS, 합성.

**H7** — 내부. LEGB, closure, frame.

**H8** — 지금. 회고.

7시간이 함수 토대.

---

## 3. v2 → v3 진화 정리

| 항목 | v2 | v3 |
|------|-----|-----|
| 줄 수 | 150 | 200 |
| decorator | 0 | 3 |
| closure | 0 | 1 |
| @property | 0 | 2 |
| @dataclass | 0 | 1 |

3 decorator + 1 closure. 본인의 첫 데코레이터.

---

## 4. 함수 다섯 원리

**원리 1 — 한 함수 한 일** (SRP).

5~30줄. 30줄 넘으면 분리.

**원리 2 — pure function 우선**.

부수 효과 없으면 캐싱, 테스트, 병렬 가능.

**원리 3 — type hints 모든 함수**.

mypy --strict.

**원리 4 — docstring 모든 public 함수**.

Google 양식.

**원리 5 — pytest 모든 함수**.

coverage 80%+.

다섯 원리. 5년.

---

## 5. 본인의 함수 5년 자산

**개념** — def 6 인자 + return 5패턴 + default + *args + lambda + closure + decorator.

**도구** — functools (reduce, partial, lru_cache, wraps), @property, @dataclass.

**원리** — 다섯.

**코드** — 환율 v3 200줄. 첫 데코레이터.

**자신감** — 함수 설계 + 리뷰.

5년.

---

## 6. Ch010으로 가는 다리

다음 챕터 Ch010은 collections. 함수의 데이터.

자료형 4개 (list, tuple, dict, set)을 깊이.

Ch008 흐름 + Ch009 함수 + Ch010 데이터 = 본인 코드의 95%.

---

## 7. 흔한 오해 다섯 가지

**오해 1: 함수 단순.**

closure, decorator 깊음.

**오해 2: lambda 모든 곳.**

한 줄까지.

**오해 3: pure 옵션.**

자경단 80% 표준.

**오해 4: decorator 시니어.**

신입 H5에서.

**오해 5: 8시간 길어요.**

코드 단위.

---

## 8. 흔한 실수 다섯 + 안심 — 회고 학습 편

첫째, 함수만 쓰고 OOP 안 봄. 안심 — Ch016에서.
둘째, 자기 함수만. 안심 — built-in + 표준 라이브러리.
셋째, 함수형 vs OOP 양자택일. 안심 — 둘 다 도구.
넷째, GitHub 안 올림. 안심 — 첫 .py도.
다섯째, 가장 큰 — 다음 챕터 안 감. 안심 — 두 주 후 Ch010.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 9. 마무리

자, 여덟 번째 시간 끝.

7시간 회고, v3 진화, 다섯 원리, 5년 자산, Ch010 다리.

박수. 본인이 함수 8시간 끝까지.

본 챕터 끝. 다음 — Ch010 H1.

```python
from functools import lru_cache
@lru_cache
def fib(n): return n if n < 2 else fib(n-1) + fib(n-2)
print(fib(30))
```

---

## 👨‍💻 개발자 노트

> - 함수는 first-class object: Python의 핵심.
> - decorator chain: @a @b @c는 a(b(c(f))).
> - 다음 챕터 Ch010: list, tuple, dict, set.
