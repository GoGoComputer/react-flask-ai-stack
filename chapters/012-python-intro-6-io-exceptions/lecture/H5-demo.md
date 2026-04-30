# Ch012 · H5 — file_processor 30분 — CSV → JSON 통합 데모

> 고양이 자경단 · Ch 012 · 5교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 시나리오 — 자경단 데이터 변환
3. 0~5분 — 폴더 셋업
4. 5~10분 — read_csv() 함수
5. 10~15분 — transform() 변환
6. 15~20분 — write_json() 안전 저장
7. 20~25분 — main() 파이프라인
8. 25~30분 — 실행과 검증
9. 다섯 사고와 처방
10. 흔한 오해 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요.

지난 H4 회수. 30 exception + 20 file 패턴.

이번 H5는 30분 데모. CSV → JSON 변환기.

오늘의 약속. **본인이 100줄짜리 file_processor를 짭니다**.

자, 가요.

---

## 2. 시나리오 — 자경단 데이터 변환

미니의 의뢰. "자경단 5명 데이터를 CSV로 받았는데 JSON으로 변환해 주세요. 사고 시 알림과 백업도 필요해요."

입력 — cats.csv.
출력 — cats.json.
조건 — atomic write, 사고 처리, 로깅.

30분에 100줄.

---

## 3. 0~5분 — 폴더 셋업

```bash
mkdir -p /tmp/file-demo && cd /tmp/file-demo
python3 -m venv .venv
source .venv/bin/activate
pip install rich

cat > cats.csv <<'EOF'
name,age,color
까미,3,black
노랭이,2,yellow
미니,4,gray
깜장이,5,tuxedo
본인,1,white
EOF

touch file_processor.py
```

---

## 4. 5~10분 — read_csv() 함수

```python
"""file_processor.py — CSV → JSON 변환기"""

import csv
import json
import logging
import shutil
from pathlib import Path
from typing import Any

from rich.logging import RichHandler

logging.basicConfig(
    level=logging.INFO,
    handlers=[RichHandler()],
)
log = logging.getLogger(__name__)


def read_csv(path: Path) -> list[dict[str, Any]]:
    """CSV 파일을 dict 리스트로 읽기."""
    if not path.exists():
        raise FileNotFoundError(f"{path} 없음")
    
    try:
        with path.open(encoding="utf-8") as f:
            reader = csv.DictReader(f)
            rows = list(reader)
        log.info(f"CSV 읽음: {len(rows)}행")
        return rows
    except UnicodeDecodeError as e:
        log.error(f"인코딩 실패: {e}")
        raise
```

자경단 표준 — encoding 명시, 로깅, 예외 처리.

---

## 5. 10~15분 — transform() 변환

```python
def transform(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """CSV row를 JSON 형태로 변환. age는 int."""
    transformed = []
    for i, row in enumerate(rows, start=1):
        try:
            transformed.append({
                "name": row["name"].strip(),
                "age": int(row["age"]),
                "color": row["color"].lower().strip(),
            })
        except (KeyError, ValueError) as e:
            log.warning(f"행 {i} 변환 실패: {e}")
            continue
    log.info(f"변환 완료: {len(transformed)}/{len(rows)}")
    return transformed
```

guard clause + 변환. 사고 행만 skip.

---

## 6. 15~20분 — write_json() 안전 저장

```python
def write_json_atomic(path: Path, data: Any) -> None:
    """atomic write로 JSON 저장."""
    # 백업
    if path.exists():
        backup = path.with_suffix(path.suffix + ".bak")
        shutil.copy(path, backup)
        log.info(f"백업: {backup}")
    
    # tmp 파일에 쓰기
    tmp = path.with_suffix(path.suffix + ".tmp")
    try:
        tmp.write_text(
            json.dumps(data, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )
        # rename = atomic
        tmp.rename(path)
        log.info(f"저장 완료: {path}")
    except Exception:
        if tmp.exists():
            tmp.unlink()
        raise
```

backup + tmp + atomic rename. 자경단 표준.

---

## 7. 20~25분 — main() 파이프라인

```python
def main() -> int:
    """파이프라인. exit code 반환."""
    src = Path("cats.csv")
    dst = Path("cats.json")
    
    try:
        rows = read_csv(src)
        data = transform(rows)
        write_json_atomic(dst, data)
        log.info("✅ 모두 성공")
        return 0
    except FileNotFoundError as e:
        log.error(str(e))
        return 1
    except Exception as e:
        log.exception(f"예상 못한 사고: {e}")
        return 2


if __name__ == "__main__":
    import sys
    sys.exit(main())
```

exit code로 성공/실패 알림. 자경단 표준 — 0 성공, 1 알려진 사고, 2 예상 못한 사고.

---

## 8. 25~30분 — 실행과 검증

```bash
$ python3 file_processor.py
[INFO] CSV 읽음: 5행
[INFO] 변환 완료: 5/5
[INFO] 저장 완료: cats.json
[INFO] ✅ 모두 성공

$ cat cats.json
[
  {
    "name": "까미",
    "age": 3,
    "color": "black"
  },
  ...
]
```

파일 없을 때.

```bash
$ rm cats.csv
$ python3 file_processor.py
[ERROR] cats.csv 없음
$ echo $?
1
```

exit code 1. 자경단 CI에서 자동 처리.

---

## 9. 다섯 사고와 처방

**사고 1: encoding 사고 (cp949)**

처방. 명시적 utf-8.

**사고 2: 손상된 CSV row**

처방. transform()의 try/except per row.

**사고 3: write 중 사고**

처방. atomic write (tmp + rename).

**사고 4: 디스크 가득**

처방. tmp 만들 때 OSError catch.

**사고 5: 동시 실행**

처방. file lock.

---

## 10. 흔한 오해 다섯 가지

**오해 1: backup 안 해도 됨.**

5년 후 사고 시 후회.

**오해 2: atomic write 옵션.**

자경단 표준.

**오해 3: try/except 커버 모두.**

좁게.

**오해 4: log.error만.**

log.exception이 traceback.

**오해 5: exit code 0만.**

CI에서 사고 처리.

---

## 11. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, encoding 누락. 안심 — utf-8 명시.
둘째, transform 사고 시 전체 중단. 안심 — per row try/except.
셋째, atomic write 무시. 안심 — tmp + rename.
넷째, exit code 안 씀. 안심 — 0/1/2 표준.
다섯째, 가장 큰 — backup 안 함. 안심 — 5년 후 본인 살림.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 다섯 번째 시간 끝.

file_processor 100줄. read_csv, transform, atomic write, main 파이프라인. 자경단 표준.

다음 H6는 운영. 함정, 성능, chunking.

```bash
python3 file_processor.py
echo $?
```

---

## 👨‍💻 개발자 노트

> - csv DictReader: 첫 줄을 header로.
> - json.dumps default param: 커스텀 encoder.
> - atomic rename: POSIX. Windows는 다름.
> - RichHandler: rich 색깔 logging.
> - sys.exit(N): exit code 반환.
> - 다음 H6 키워드: chunking · 성능 · 메모리 · async I/O.
