# Ch012 · H1 — 파일 I/O + 예외 처리 오리엔테이션

> 고양이 자경단 · Ch 012 · 1교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — Ch011 회수와 오늘의 약속
2. I/O가 무엇인가 — 코드의 외부 세계
3. 옛날 이야기 — 첫 try/except를 만난 그 날
4. 왜 I/O와 예외인가 — 일곱 가지 이유
5. 같이 쳐 보기 — 5줄로 파일 읽기
6. 네 친구 — open·with·try·except
7. 0.001초의 여행 — 파일 읽기 5단계
8. 파일 모드 한 표
9. 자경단 다섯 명의 매일 I/O
10. 8교시 미리보기
11. I/O 50년 — Unix file부터 async I/O까지
12. AI 시대의 I/O
13. 자주 받는 질문 다섯 가지
14. 흔한 오해 다섯 가지
15. 마무리

---

## 1. 다시 만나서 반가워요 — Ch011 회수와 오늘의 약속

자, 안녕하세요. 12번째 챕터예요.

지난 Ch011 회수. 텍스트 처리 — str 30 메서드, regex 8 패턴.

이번 Ch012는 파일 I/O와 예외 처리. 본인이 만나는 외부 세계.

오늘의 약속. **본인이 파일을 안전하게 읽고 쓰고, 사고를 우아하게 처리합니다**.

자, 가요.

---

## 2. I/O가 무엇인가 — 코드의 외부 세계

I/O는 Input/Output의 약자. 본인의 코드가 외부와 만나는 모든 일.

파일 읽고 쓰기, 네트워크 요청, 사용자 입력, 데이터베이스 쿼리. 모든 게 I/O.

I/O는 모든 사고의 진원지예요. 파일이 없을 수도, 네트워크가 끊길 수도, 디스크가 가득 찰 수도. 본인이 이 사고를 어떻게 처리하느냐가 production 안정성의 80%.

---

## 3. 옛날 이야기 — 첫 try/except를 만난 그 날

옛날 이야기. 12년 전.

저는 처음 짠 파일 읽기 코드가 production에서 죽었어요. 파일이 없을 때 FileNotFoundError. 5,000명에게 영향. 새벽 3시 호출.

사수 형이 와서 한 줄 추가했어요. `try: ... except FileNotFoundError: return None`. 그게 끝. 코드 5줄 → 7줄. 사고 0.

저는 그날 예외 처리의 가치를 깨달았어요. 5,000명을 살리는 두 줄. 본인도 8시간 후 같아요.

---

## 4. 왜 I/O와 예외인가 — 일곱 가지 이유

**1. production 안정성**. 사고의 80% I/O.

**2. 사용자 경험**. 좋은 에러 메시지.

**3. 데이터 안전**. 손실 방지.

**4. 디버깅**. 명확한 에러.

**5. 보안**. 권한 체크.

**6. 자경단 매일**. 모든 endpoint에서.

**7. 면접 단골**. exception 질문.

일곱.

---

## 5. 같이 쳐 보기 — 5줄로 파일 읽기

```python
python3
>>> with open("test.txt", "w") as f:
...     f.write("안녕\n자경단")
>>> with open("test.txt") as f:
...     print(f.read())
```

5줄. 파일 쓰기 + 읽기.

```
안녕
자경단
```

---

## 6. 네 친구 — open·with·try·except

**open()**. 파일 열기.

```python
f = open("file.txt")
content = f.read()
f.close()
```

**with**. 자동 close (context manager).

```python
with open("file.txt") as f:
    content = f.read()
# 자동 close
```

**try/except**. 예외 처리.

```python
try:
    with open("file.txt") as f:
        content = f.read()
except FileNotFoundError:
    content = "default"
```

자경단 표준 — `with` + `try`.

---

## 7. 0.001초의 여행 — 파일 읽기 5단계

`open("file.txt").read()`.

**1. 파일 시스템 조회**. 파일 존재 확인.

**2. 권한 체크**. 읽기 권한.

**3. file descriptor 할당**. OS에 fd 요청.

**4. 데이터 읽기**. 디스크에서 메모리로.

**5. 닫기**. fd 해제.

5단계. 0.01초 (작은 파일). 큰 파일은 더.

---

## 8. 파일 모드 한 표

| 모드 | 의미 |
|------|------|
| `r` | 읽기 (기본) |
| `w` | 쓰기 (덮어쓰기) |
| `a` | 추가 |
| `x` | 새 파일만 (있으면 에러) |
| `b` | binary |
| `t` | text (기본) |
| `+` | 읽기/쓰기 |

조합. `rb`, `wb`, `r+`. 자경단 매일.

---

## 9. 자경단 다섯 명의 매일 I/O

**까미**. DB 매일 100번. 파일 50번.

**노랭이**. 파일 매일 30번. JSON 100번.

**미니**. 파일 매일 200번. 로그.

**깜장이**. 테스트 데이터 매일 50번.

**본인**. 다양 매일 100번.

---

## 10. 8교시 미리보기

H2 — open mode 7, try/except 깊이.

H3 — pathlib, io, logging, rich.traceback.

H4 — 30+ exception, 20+ file 패턴.

H5 — file_processor 30분.

H6 — 함정, 성능, chunking.

H7 — file system, OS syscall.

H8 — Ch013 modules와 다리.

---

## 11. I/O 50년

1971년. Unix file. read, write, open, close.

1976년. C stdio. fopen, fclose.

1991년. Python file object.

2007년. with statement (PEP 343).

2014년. async I/O (asyncio).

2017년. pathlib (PEP 519).

---

## 12. AI 시대의 I/O

AI한테 "이 CSV 안전하게 읽기" 한 줄. 즉시 try/except + with 추천.

자경단 80/20.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. open vs pathlib?**

pathlib가 모던. 자경단 표준.

**Q2. with 항상?**

자경단 표준 항상.

**Q3. except 모든 곳?**

가능한 좁게. 모든 except는 위험.

**Q4. binary vs text?**

이미지 등은 binary, 글자는 text.

**Q5. 8시간 길어요.**

I/O가 production 토대.

---

## 14. 흔한 오해 다섯 가지

**오해 1: open 후 close 자동.**

with 없으면 수동.

**오해 2: try 모든 곳.**

좁게 사용.

**오해 3: print로 디버깅.**

logging.

**오해 4: pathlib 옵션.**

자경단 표준.

**오해 5: encoding 자동.**

명시.

---

## 15. 흔한 실수 다섯 + 안심 — I/O 첫 학습 편

첫째, with 없이 open. 안심 — with 표준.
둘째, except 너무 넓게. 안심 — 좁게 잡기.
셋째, encoding 누락. 안심 — UTF-8 명시.
넷째, 사고 = 실패. 안심 — 사고 = 정상.
다섯째, 가장 큰 — production 사고 두려움. 안심 — try/except 두 줄로 5,000명 살림.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 16. 마무리

자, 첫 시간 끝.

네 친구 — open, with, try, except. 자경단 매일.

다음 H2는 8개념.

```python
python3 -c "with open('t.txt', 'w', encoding='utf-8') as f: f.write('hi')"
```

---

## 👨‍💻 개발자 노트

> - file descriptor: OS 레벨. limit 1024-4096.
> - context manager PEP 343: __enter__, __exit__.
> - exception hierarchy: BaseException → Exception → 구체.
> - pathlib PEP 519: os.path 객체지향 대체.
> - async open: aiofiles.
> - 다음 H2 키워드: open mode · try/except · finally · raise · custom exception.
