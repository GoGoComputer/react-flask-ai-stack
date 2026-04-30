# Ch012 · H2 — open mode 7 + try/except 깊이

> 고양이 자경단 · Ch 012 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. open() 모드 일곱 가지
3. 파일 메서드 다섯
4. with 문 (context manager)
5. try/except/else/finally
6. 예외 계층 구조
7. raise와 custom exception
8. pathlib 깊이
9. 한 줄 분해
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요.

지난 H1 회수. open, with, try, except 네 친구.

이번 H2는 8개념 깊이.

오늘의 약속. **본인이 모든 파일 모드와 예외 처리 패턴을 손에 박습니다**.

자, 가요.

---

## 2. open() 모드 일곱 가지

```python
open("file.txt")              # r 기본 (text 읽기)
open("file.txt", "r")         # 명시
open("file.txt", "w")         # 쓰기 (덮어쓰기)
open("file.txt", "a")         # 추가
open("file.txt", "x")         # 새 파일만
open("file.txt", "rb")        # binary 읽기
open("file.txt", "r+")        # 읽기 + 쓰기
```

7 모드. 매일 r, w, a 세 개가 90%.

추가 인자.

```python
open("file.txt", encoding="utf-8")
open("file.txt", encoding="utf-8", newline="\n")
open("file.txt", buffering=1024)
```

자경단 표준 — encoding 항상 명시.

---

## 3. 파일 메서드 다섯

```python
f = open("file.txt")

f.read()              # 전체
f.read(100)           # 100 글자
f.readline()          # 한 줄
f.readlines()         # 모든 줄 list
f.write("text")
f.writelines(["a\n", "b\n"])
f.seek(0)             # 위치 이동
f.tell()              # 현재 위치
f.flush()             # 버퍼 비우기
f.close()
```

자경단 매일 read, write, readline.

---

## 4. with 문 (context manager)

```python
with open("file.txt") as f:
    content = f.read()
# 자동 close (예외 발생해도)
```

여러 파일 동시.

```python
with open("a.txt") as fa, open("b.txt", "w") as fb:
    fb.write(fa.read())
```

자경단 표준 — 모든 open()은 with.

---

## 5. try/except/else/finally

```python
try:
    f = open("file.txt")
    content = f.read()
except FileNotFoundError:
    content = "default"
except PermissionError as e:
    print(f"권한 에러: {e}")
    raise
else:
    # try가 성공했을 때만
    print("성공")
finally:
    # 항상 실행
    print("청소")
```

다섯 부분. 매일 try/except가 80%, finally 20%.

---

## 6. 예외 계층 구조

```python
BaseException
 └── Exception
      ├── ArithmeticError
      │    └── ZeroDivisionError
      ├── LookupError
      │    ├── KeyError
      │    └── IndexError
      ├── OSError
      │    ├── FileNotFoundError
      │    ├── PermissionError
      │    └── ConnectionError
      ├── ValueError
      ├── TypeError
      └── RuntimeError
```

자경단 매일 자주 만나는 다섯. FileNotFoundError, KeyError, ValueError, TypeError, ConnectionError.

---

## 7. raise와 custom exception

```python
def divide(a, b):
    if b == 0:
        raise ValueError("0으로 나눔")
    return a / b
```

**Custom exception**

```python
class CatNotFoundError(Exception):
    """고양이 못 찾음."""
    pass

def find_cat(name):
    if name not in cats:
        raise CatNotFoundError(f"{name} 없음")
    return cats[name]
```

자경단 표준 — 도메인 예외 명시.

```python
try:
    cat = find_cat("ㅇㅇ")
except CatNotFoundError as e:
    print(f"⚠️ {e}")
```

---

## 8. pathlib 깊이

`pathlib`는 os.path의 객체지향 대체.

```python
from pathlib import Path

p = Path("data/cats.txt")

# 속성
p.name        # 'cats.txt'
p.stem        # 'cats'
p.suffix      # '.txt'
p.parent      # Path('data')

# 검사
p.exists()
p.is_file()
p.is_dir()

# 조작
p.parent.mkdir(exist_ok=True)
p.write_text("hello")
text = p.read_text()
```

자경단 표준 — `pathlib > os.path`.

```python
# pathlib 한 줄
Path("file.txt").write_text("hello")
content = Path("file.txt").read_text()
```

with 없이도 자동 close.

---

## 9. 한 줄 분해

```python
try:
    data = json.loads(Path("data.json").read_text(encoding="utf-8"))
except (FileNotFoundError, json.JSONDecodeError) as e:
    data = {}
```

pathlib + json + try + tuple of exceptions. 자경단 매일.

---

## 10. 흔한 오해 다섯 가지

**오해 1: with 없어도 됨.**

자경단 표준 항상.

**오해 2: except Exception 모든 것.**

너무 넓음. 구체적으로.

**오해 3: finally 안 씀.**

cleanup에 자주.

**오해 4: pathlib는 옵션.**

자경단 표준.

**오해 5: custom exception 시니어.**

신입도 도메인 예외.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. with 없이?**

자동 close 안 됨. fd 누수.

**Q2. except 순서?**

구체적 → 일반.

**Q3. raise 다시?**

예외 재발생. `raise` 단독.

**Q4. else 언제?**

성공 시만 실행할 코드.

**Q5. pathlib 매일?**

자경단 표준.

---

## 12. 흔한 실수 다섯 + 안심 — 핵심 학습 편

첫째, mode 다 외움. 안심 — r·w·a 셋이 90%.
둘째, except 순서 무지. 안심 — 구체적 → 일반.
셋째, finally 시니어 도구. 안심 — cleanup 매일.
넷째, custom exception 어렵다. 안심 — `class X(Exception): pass`.
다섯째, 가장 큰 — pathlib 옵션. 안심 — pathlib 표준.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 두 번째 시간 끝.

7 mode, 5 메서드, with, try/except/else/finally, 예외 계층, custom, pathlib.

다음 H3는 도구.

```python
python3 -c "from pathlib import Path; Path('t.txt').write_text('안녕', encoding='utf-8')"
```

---

## 👨‍💻 개발자 노트

> - open() context: __enter__ 시 file 객체, __exit__ 시 close.
> - exception chaining: `raise X from Y`.
> - pathlib PurePath: 추상 (조작), Path: 구체 (I/O).
> - encoding default: locale.getpreferredencoding(). 명시 권장.
> - 다음 H3 키워드: pathlib · logging · io · rich.traceback.
