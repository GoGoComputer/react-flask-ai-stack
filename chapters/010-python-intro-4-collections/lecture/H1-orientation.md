# Ch010 · H1 — collections 오리엔테이션 — list·tuple·dict·set 네 단어

> 고양이 자경단 · Ch 010 · 1교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — Ch009 회수와 오늘의 약속
2. collections이 무엇인가 — 데이터를 묶는 도구
3. 옛날 이야기 — 제가 처음 dict를 만난 그 날
4. 왜 collections인가 — 일곱 가지 이유
5. 같이 쳐 보기 — 다섯 줄로 자경단 데이터
6. 네 친구 — list·tuple·dict·set
7. 0.001초의 여행 — dict.get() 5단계
8. 자료구조 선택 가이드
9. 자경단 다섯 명의 매일 collections
10. 8교시 미리보기
11. collections 50년 — Lisp부터 Python 3.12까지
12. AI 시대의 데이터
13. 자주 받는 질문 다섯 가지
14. 흔한 오해 다섯 가지
15. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
cats = ["까미", "노랭이"]              # list
point = (1, 2)                          # tuple
ages = {"까미": 3, "노랭이": 2}        # dict
unique = {"검정", "노랑", "회색"}      # set
```

---

## 1. 다시 만나서 반가워요 — Ch009 회수와 오늘의 약속

자, 안녕하세요. 10번째 챕터예요.

지난 Ch009 회수. 함수의 모든 종류 — def, lambda, closure, decorator. 데코레이터 두 개 직접 짰어요.

이번 Ch010은 collections. Python의 자료구조 네 가지를 깊이.

오늘의 약속. **본인이 list, tuple, dict, set을 도구처럼 골라 쓸 수 있게 됩니다**.

자, 가요.

---

## 2. collections이 무엇인가 — 데이터를 묶는 도구

collections는 여러 값을 한 묶음으로 다루는 자료구조예요. 데이터의 거의 모든 게 collections로 표현돼요.

자경단 다섯 명도 collections로 표현.

```python
cats = ["본인", "까미", "노랭이", "미니", "깜장이"]   # list
ages = {"본인": 1, "까미": 3, "노랭이": 2, "미니": 4, "깜장이": 5}  # dict
colors = {"black", "yellow", "gray", "tuxedo", "white"}  # set
```

세 자료구조에 같은 정보가 다른 형태로 들어 있어요. 어느 걸 쓸지가 본인의 매일 결정.

---

## 3. 옛날 이야기 — 제가 처음 dict를 만난 그 날

옛날 이야기. 제가 처음 dict를 만난 날. 12년 전.

회사에서 사용자 데이터를 list로 처리하고 있었어요. `[("까미", 3), ("노랭이", 2)]` 같은 식. 어떤 cat의 나이를 찾으려면 for 루프로 일일이 비교. 5만 명이면 5만 번.

사수 형이 보고 "dict 써" 한 줄. `{"까미": 3, "노랭이": 2}`. dict의 lookup이 O(1). 5만 명도 0.001초.

저는 그날 자료구조의 힘을 깨달았어요. 같은 데이터지만 어떻게 묶느냐에 따라 100배 빨라요. 그날 이후 저는 list와 dict 사이에서 매번 고민하기 시작했어요.

본인도 8시간 후 똑같이 깨달아요.

---

## 4. 왜 collections인가 — 일곱 가지 이유

**1. 데이터의 표현**. 모든 데이터가 collections.

**2. 성능**. dict의 O(1), list의 O(n). 100배 차이.

**3. API 응답**. JSON이 dict + list.

**4. 알고리즘**. 정렬, 검색이 collections 위.

**5. 면접 단골**. 자료구조 질문 80%.

**6. 함수형**. comp + collections.

**7. 자경단 매일**. 1,000번 collections 조작.

일곱 이유.

---

## 5. 같이 쳐 보기 — 다섯 줄로 자경단 데이터

> ▶ **같이 쳐보기** — 자경단 데이터를 네 자료구조로
>
> ```python
> python3
> >>> cats = ["본인", "까미", "노랭이"]
> >>> ages = {"본인": 1, "까미": 3, "노랭이": 2}
> >>> colors = {"white", "black", "yellow"}
> >>> point = (1, 2)
> >>> [print(c, ages[c]) for c in cats]
> ```

다섯 줄에 네 자료구조 다.

---

## 6. 네 친구 — list·tuple·dict·set

**list**. 순서 있는 묶음, mutable.

```python
cats = ["까미", "노랭이"]
cats.append("미니")
cats[0]   # "까미"
```

**tuple**. 순서 있는 묶음, immutable.

```python
point = (1, 2)
# point[0] = 5  # TypeError
```

**dict**. key-value 매핑.

```python
ages = {"까미": 3}
ages["노랭이"] = 2
ages.get("미니", 0)   # 없으면 0
```

**set**. 순서 없는 unique 묶음.

```python
colors = {"black", "yellow"}
colors.add("gray")
"black" in colors   # O(1)
```

네 친구. 매일 모두 사용.

---

## 7. 0.001초의 여행 — dict.get() 5단계

본인이 `ages.get("까미")` 한 줄 실행하면.

**1. hash 계산**. "까미"의 hash 값.

**2. bucket 위치**. hash → bucket index.

**3. bucket 검색**. 해당 bucket 안에서 key 매칭.

**4. value 반환**. 매칭된 value.

**5. 못 찾으면 default**. 두 번째 인자 또는 None.

5단계. 0.0001초. dict의 O(1) 비결. H7에서 깊이.

---

## 8. 자료구조 선택 가이드

**list**. 순서 중요, 인덱스 접근, 중복 OK.

**tuple**. 순서 중요, immutable, 좌표/쌍.

**dict**. key로 빠른 lookup. 매핑.

**set**. unique 보장, 멤버십 검사.

자경단의 매일 선택 — 80% list와 dict, 15% set, 5% tuple.

---

## 9. 자경단 다섯 명의 매일 collections

**까미**. dict 매일 50번 (API 응답).

**노랭이**. list 매일 100번 (props).

**미니**. set 매일 30번 (unique 자원).

**깜장이**. tuple 매일 20번 (좌표, 결과 쌍).

**본인**. 네 가지 매일 100번씩.

다섯 명 합치면 매일 1,000번 collections. 1년 36만 번.

---

## 10. 8교시 미리보기

H2 — 8개념. list 메서드, tuple unpacking, dict comprehension, set 연산, frozen, ChainMap, OrderedDict, defaultdict.

H3 — 디버깅. rich.print, json, pprint.

H4 — 30+ 도구. heapq, bisect, deque, Counter.

H5 — 30분 데모. v4로 진화. collections 활용.

H6 — 운영. 자료구조 선택, 성능, 메모리.

H7 — 깊이. dict의 hash table, list의 array.

H8 — 적용. Ch011 strings와 다리.

---

## 11. collections 50년

1958년. LISP의 list. 모든 자료구조의 조상.

1970년대. C의 array, struct.

1991년. Python 0.9. list, tuple, dict 첫 버전부터.

2008년. Python 3.0. set comprehension.

2010년. collections 모듈 풍부.

2017년. dict insertion order 보장.

2024년. AI가 자료구조 자동 추천.

---

## 12. AI 시대의 데이터

AI가 본인 코드를 보고 "이 list는 dict로 바꾸세요" 추천. 자료구조 선택의 자동화.

자경단의 80/20. 본인이 80% 자료구조 선택, AI가 20% 검토.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. list vs tuple?**

mutable vs immutable. 변하지 않으면 tuple.

**Q2. dict 순서 보장?**

3.7+. 보장.

**Q3. set 메모리?**

dict와 비슷. 큼.

**Q4. namedtuple vs dataclass?**

namedtuple immutable, dataclass 더 풍부.

**Q5. 8시간 길어요.**

자료구조가 코드의 토대.

---

## 14. 흔한 오해 다섯 가지

**오해 1: list가 만능.**

dict가 lookup 빠름.

**오해 2: tuple은 옛 도구.**

dataclass와 함께 표준.

**오해 3: set 자주 안 씀.**

unique 검사 매일.

**오해 4: dict는 무거움.**

3.7+ 가벼움.

**오해 5: collections.abc 어려움.**

ABC는 H7에서.

---

## 15. 흔한 실수 다섯 + 안심 — Collections 학습 편

첫째, list만 쓰고 set/dict 무시. 안심 — 멤버십 체크는 set, 매핑은 dict.
둘째, dict 키로 list 사용. 안심 — list는 unhashable. tuple 사용.
셋째, list/set/dict의 시간 복잡도 무시. 안심 — list O(n), set O(1).
넷째, 깊은 복사 안 함. 안심 — copy.deepcopy 또는 list comprehension.
다섯째, 가장 큰 — collection 종류 다 외움. 안심 — list/dict/set 셋만.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 16. 마무리

자, 첫 시간 끝.

네 친구 — list, tuple, dict, set. 자료구조 선택 가이드.

다음 H2는 8개념 깊이.

```python
python3 -c 'cats={"까미":3,"노랭이":2}; print({k for k,v in cats.items() if v >= 3})'
```

---

## 👨‍💻 개발자 노트

> - list: dynamic array. amortized O(1) append.
> - tuple: immutable, hashable. dict key 가능.
> - dict: hash table. Python 3.7+ insertion order.
> - set: hash set. O(1) membership.
> - frozenset: immutable set. dict key 가능.
> - 다음 H2 키워드: list 메서드 · tuple unpacking · dict comp · set 연산 · ChainMap.
