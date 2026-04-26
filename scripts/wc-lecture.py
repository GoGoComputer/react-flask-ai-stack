#!/usr/bin/env python3
"""H 강의 분량 측정 (공백 제외 한글 글자 수).

사용:
  python3 scripts/wc-lecture.py <file.md>
  python3 scripts/wc-lecture.py --all
"""
from __future__ import annotations
import os, re, sys, glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def count_no_space(path: str) -> int:
    with open(path, encoding="utf-8") as f:
        text = f.read()
    return len(re.sub(r"\s+", "", text))


def status(n: int) -> str:
    if n >= 19000:
        return "✅"
    if n >= 17000:
        return "🟢"
    if n >= 10000:
        return "🟡"
    return "🔴"


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    if sys.argv[1] == "--all":
        files = sorted(glob.glob(os.path.join(ROOT, "chapters/*/lecture/H*.md")))
        total = 0
        for f in files:
            n = count_no_space(f)
            total += n
            rel = os.path.relpath(f, ROOT)
            print(f"{status(n)} {n:>6}  {rel}")
        print(f"-- TOTAL: {total} no-space chars across {len(files)} files --")
        return 0
    for f in sys.argv[1:]:
        n = count_no_space(f)
        print(f"{status(n)} {n:>6}  {f}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
