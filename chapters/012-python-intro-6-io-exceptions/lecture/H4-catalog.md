# Ch012 · H4 — 30 exception + 20 file 패턴

> 고양이 자경단 · Ch 012 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 자주 만나는 exception 15
3. 추가 exception 15
4. 파일 처리 10 패턴
5. 디렉토리 5 패턴
6. JSON/CSV 5 패턴
7. 자경단 매일 13줄 흐름
8. 다섯 함정과 처방
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요.

지난 H3 회수. pathlib, io, logging, rich, traceback.

이번 H4는 30+ exception + 20+ file 패턴.

오늘의 약속. **본인이 매일 만나는 사고에 1초 처방**.

자, 가요.

---

## 2. 자주 만나는 exception 15

```python
ValueError              # 잘못된 값
TypeError               # 잘못된 type
KeyError                # dict key 없음
IndexError              # list index 범위 밖
AttributeError          # 객체에 속성 없음
NameError               # 변수 미정의
ImportError             # import 실패
ModuleNotFoundError     # 모듈 없음
FileNotFoundError       # 파일 없음
PermissionError         # 권한 없음
ZeroDivisionError       # 0 나눔
OverflowError           # 산술 overflow
RuntimeError            # 일반 런타임
NotImplementedError     # 미구현
StopIteration           # iterator 끝
```

15 exception. 자경단 매일.

---

## 3. 추가 exception 15

```python
ConnectionError         # 네트워크
TimeoutError            # 타임아웃
IsADirectoryError       # 파일 자리에 디렉토리
NotADirectoryError
UnicodeDecodeError      # encoding
UnicodeEncodeError
RecursionError          # 재귀 깊이
MemoryError
SystemError
KeyboardInterrupt       # Ctrl+C
SystemExit              # sys.exit
EOFError                # 입력 끝
BlockingIOError         # 비차단 I/O
FloatingPointError
JSONDecodeError         # json.loads 실패
```

15 추가. 자경단 가끔.

---

## 4. 파일 처리 10 패턴

```python
from pathlib import Path

# 1. 안전 읽기
def safe_read(path: str, default: str = "") -> str:
    try:
        return Path(path).read_text(encoding="utf-8")
    except FileNotFoundError:
        return default

# 2. 라인별 처리
with open("file.txt", encoding="utf-8") as f:
    for line in f:
        process(line.strip())

# 3. 큰 파일 chunking
def read_chunks(path, chunk_size=1024):
    with open(path, "rb") as f:
        while chunk := f.read(chunk_size):
            yield chunk

# 4. atomic write
import tempfile
def atomic_write(path: str, content: str):
    tmp = path + ".tmp"
    Path(tmp).write_text(content, encoding="utf-8")
    Path(tmp).rename(path)

# 5. 백업 후 쓰기
import shutil
def write_with_backup(path: str, content: str):
    if Path(path).exists():
        shutil.copy(path, path + ".bak")
    Path(path).write_text(content, encoding="utf-8")

# 6. 파일 비교
import filecmp
filecmp.cmp("a.txt", "b.txt")

# 7. 체크섬
import hashlib
def file_hash(path: str) -> str:
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            h.update(chunk)
    return h.hexdigest()

# 8. tail (마지막 N줄)
def tail(path: str, n: int = 10) -> list[str]:
    with open(path, encoding="utf-8") as f:
        return f.readlines()[-n:]

# 9. 라인 수
def line_count(path: str) -> int:
    with open(path, encoding="utf-8") as f:
        return sum(1 for _ in f)

# 10. 임시 파일
import tempfile
with tempfile.NamedTemporaryFile(mode="w", delete=False) as tmp:
    tmp.write("data")
    tmp_path = tmp.name
```

10 패턴. 자경단 매일.

---

## 5. 디렉토리 5 패턴

```python
# 1. 만들기 (이미 있어도 OK)
Path("data").mkdir(parents=True, exist_ok=True)

# 2. 모든 파일 순회
for f in Path("data").iterdir():
    if f.is_file():
        ...

# 3. 재귀 검색
for f in Path("data").rglob("*.py"):
    ...

# 4. 빈 디렉토리?
if not list(Path("data").iterdir()):
    Path("data").rmdir()

# 5. 통째 삭제
import shutil
shutil.rmtree("data", ignore_errors=True)
```

5 패턴.

---

## 6. JSON/CSV 5 패턴

```python
import json
import csv

# 1. JSON 읽기
with open("data.json", encoding="utf-8") as f:
    data = json.load(f)

# 2. JSON 쓰기
with open("data.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# 3. CSV 읽기
with open("data.csv", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row["name"])

# 4. CSV 쓰기
with open("out.csv", "w", encoding="utf-8", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["name", "age"])
    writer.writeheader()
    writer.writerows(data)

# 5. JSONL (한 줄 한 JSON)
with open("data.jsonl", encoding="utf-8") as f:
    for line in f:
        obj = json.loads(line)
        process(obj)
```

5 패턴. 자경단 매일.

---

## 7. 자경단 매일 13줄 흐름

```python
from pathlib import Path
import json

# 1. 설정 읽기
config = json.loads(Path("config.json").read_text(encoding="utf-8"))

# 2. 데이터 처리
try:
    raw = Path("data.csv").read_text(encoding="utf-8")
except FileNotFoundError:
    raw = ""

# 3. 결과 저장 (atomic)
output = Path("result.json")
tmp = output.with_suffix(".tmp")
tmp.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
tmp.rename(output)

# 4. 로그
log.info(f"처리 완료: {len(data)}개")

# 5. 재귀 정리
for f in Path("temp").rglob("*.tmp"):
    f.unlink()
```

13줄.

---

## 8. 다섯 함정과 처방

**함정 1: encoding 누락**

처방. 항상 utf-8.

**함정 2: with 누락**

처방. 항상.

**함정 3: 큰 파일 read_text**

처방. chunking 또는 line iter.

**함정 4: atomic write 누락**

처방. tmp + rename.

**함정 5: 빈 except**

처방. 구체적 exception.

---

## 9. 흔한 오해 다섯 가지

**오해 1: 30 exception 다 외움.**

자주 만나는 15.

**오해 2: 큰 파일 메모리.**

chunking으로.

**오해 3: JSON 항상 dict.**

list, primitive도.

**오해 4: CSV는 쉽다.**

quote, encoding 함정.

**오해 5: shutil 위험.**

rmtree는 신중히.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. read_text vs open.read?**

같음. read_text가 짧음.

**Q2. JSON 한글?**

ensure_ascii=False.

**Q3. CSV header?**

DictReader/DictWriter.

**Q4. atomic write?**

tmp + rename. POSIX 보장.

**Q5. 큰 파일?**

generator 또는 mmap.

---

## 11. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, exception 30 외움. 안심 — 자주 15.
둘째, encoding 매번 까먹음. 안심 — utf-8 항상.
셋째, atomic write 시니어. 안심 — tmp + rename 표준.
넷째, JSON 한글 깨짐. 안심 — ensure_ascii=False.
다섯째, 가장 큰 — 큰 파일 read_text. 안심 — line iter.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 네 번째 시간 끝.

30 exception, 20 file 패턴.

다음 H5는 file_processor 30분.

```python
python3 -c "from pathlib import Path; print(list(Path('.').glob('*.md')))"
```

---

## 👨‍💻 개발자 노트

> - exception group (3.11+): except*. 여러 동시 예외.
> - mmap: 메모리 매핑 파일. 큰 파일에 강력.
> - atomic rename: POSIX 보장, Windows는 일부 다름.
> - csv quoting: minimal, all, nonnumeric.
> - 다음 H5 키워드: file_processor · pipeline · CSV → JSON · 통계.
