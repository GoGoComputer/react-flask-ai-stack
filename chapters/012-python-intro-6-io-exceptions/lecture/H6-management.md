# Ch012 · H6 — file/exception 운영 — 함정 + 성능 + chunking

> 고양이 자경단 · Ch 012 · 6교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 큰 파일 chunking 다섯 패턴
3. 메모리 효율 — generator
4. 성능 측정 — timeit + profile
5. async I/O 첫 인상
6. 자경단 매일 운영 의식
7. 다섯 함정과 처방
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요.

지난 H5 회수. file_processor 100줄.

이번 H6는 운영. 큰 파일, 성능, async.

오늘의 약속. **본인이 1GB 파일도 안전하게 처리할 수 있습니다**.

자, 가요.

---

## 2. 큰 파일 chunking 다섯 패턴

**1. line iter (작은 줄)**

```python
with open("big.txt", encoding="utf-8") as f:
    for line in f:
        process(line.strip())
```

메모리 한 줄씩.

**2. chunk read (binary)**

```python
def read_chunks(path, size=4096):
    with open(path, "rb") as f:
        while chunk := f.read(size):
            yield chunk
```

generator 패턴.

**3. csv 큰 파일**

```python
with open("big.csv", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        process(row)
```

DictReader도 lazy.

**4. JSON Lines**

```python
with open("big.jsonl", encoding="utf-8") as f:
    for line in f:
        obj = json.loads(line)
        process(obj)
```

거대한 JSON 한 번에 vs JSONL 한 줄씩.

**5. mmap (메모리 매핑)**

```python
import mmap

with open("big.txt", "rb") as f:
    with mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ) as mm:
        # 메모리 안에 있는 것처럼
        if b"ERROR" in mm:
            ...
```

OS가 lazy 로딩. 큰 파일 검색에 강력.

---

## 3. 메모리 효율 — generator

```python
# Bad — 메모리 폭발
all_rows = []
with open("huge.csv") as f:
    reader = csv.DictReader(f)
    all_rows = list(reader)   # 전체 메모리

# Good — generator
def read_rows(path):
    with open(path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        yield from reader

for row in read_rows("huge.csv"):
    process(row)
```

generator로 메모리 절감. 자경단 표준.

---

## 4. 성능 측정 — timeit + profile

```python
import timeit

t1 = timeit.timeit(
    "Path('a.txt').read_text()",
    setup="from pathlib import Path",
    number=1000,
)

t2 = timeit.timeit(
    "open('a.txt').read()",
    number=1000,
)

print(f"pathlib: {t1*1000:.2f}ms")
print(f"open: {t2*1000:.2f}ms")
```

cProfile.

```bash
python3 -m cProfile -s cumtime file_processor.py
```

자경단 매주.

---

## 5. async I/O 첫 인상

```python
import asyncio
import aiofiles

async def read_async(path):
    async with aiofiles.open(path, encoding="utf-8") as f:
        return await f.read()

async def main():
    contents = await asyncio.gather(
        read_async("a.txt"),
        read_async("b.txt"),
        read_async("c.txt"),
    )
    return contents

asyncio.run(main())
```

3개 파일 동시 읽기. async가 I/O bound에 강력.

자경단은 일반 동기 매일, async는 특수.

---

## 6. 자경단 매일 운영 의식

I/O 다섯 점검.

**1. encoding 명시?**

**2. with 사용?**

**3. atomic write?**

**4. exception 구체적?**

**5. 큰 파일 chunking?**

다섯. PR 표준.

---

## 7. 다섯 함정과 처방

**함정 1: read_text로 1GB 파일**

처방. line iter 또는 chunk.

**함정 2: 모든 except**

처방. 구체적 exception.

**함정 3: write 중 사고**

처방. atomic write.

**함정 4: encoding 누락**

처방. 항상 utf-8.

**함정 5: file descriptor 누수**

처방. with 항상.

---

## 8. 흔한 오해 다섯 가지

**오해 1: 작은 파일은 안전.**

수만 개 모이면 사고.

**오해 2: chunking 큰 파일만.**

100MB+부터.

**오해 3: async 항상 좋다.**

I/O bound만.

**오해 4: mmap 매번.**

큰 파일 검색만.

**오해 5: production은 sync.**

async도 production.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. chunk size?**

4096 (페이지 크기) 또는 64KB.

**Q2. yield from?**

다른 generator 위임.

**Q3. async vs threading?**

async I/O bound, threading은 GIL 영향.

**Q4. mmap Windows?**

Windows도 지원. 단 일부 옵션 다름.

**Q5. 1TB 파일?**

mmap + chunk 또는 데이터베이스.

---

## 10. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, 큰 파일 read_text. 안심 — line iter 또는 chunk.
둘째, async 항상 좋음. 안심 — I/O bound만.
셋째, generator 시니어. 안심 — yield from 매일.
넷째, mmap 어렵다. 안심 — 큰 파일 검색만.
다섯째, 가장 큰 — fd 누수. 안심 — with 항상.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 여섯 번째 시간 끝.

chunking 5 패턴, generator, 성능, async I/O.

다음 H7은 깊이. file system, syscall.

```bash
python3 -c "import mmap; print(mmap.PAGESIZE)"
```

---

## 👨‍💻 개발자 노트

> - chunk size 페이지: 4096 OS 표준.
> - generator memory: lazy. yield 시점만.
> - async I/O 한계: CPU bound는 threading/multiprocessing.
> - mmap 가상 메모리: lazy 페이지 로딩.
> - aiofiles: async open. asyncio 호환.
> - 다음 H7 키워드: file system · inode · syscall · POSIX I/O.
