# Ch013 · H4 — stdlib 30 + PyPI 30 카탈로그

> 고양이 자경단 · Ch 013 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. stdlib 매일 10
3. stdlib 주간 10
4. stdlib 월간 10
5. PyPI 자경단 표준 30
6. 자경단 매일 13줄 흐름
7. 다섯 함정과 처방
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요.

지난 H3 회수. venv, pip, pyproject, twine, pipx.

이번 H4는 stdlib 30 + PyPI 30.

오늘의 약속. **본인이 매일 만나는 60 모듈을 표 한 장으로**.

자, 가요.

---

## 2. stdlib 매일 10

```python
import os               # 운영체제
import sys              # 시스템
import json             # JSON
import re               # 정규식
import logging          # 로깅
import datetime         # 날짜시간
from pathlib import Path
from collections import Counter, defaultdict
from typing import Optional
import argparse         # CLI
```

10. 자경단 매일.

---

## 3. stdlib 주간 10

```python
import csv              # CSV
import http.client      # HTTP
import urllib.parse     # URL
import hashlib          # 해시
import secrets          # 보안 random
import base64           # base64
import sqlite3          # SQLite
import io               # io
import time             # 시간
import functools        # 함수형
```

10. 주간.

---

## 4. stdlib 월간 10

```python
import asyncio          # 비동기
import multiprocessing  # 멀티 프로세스
import threading        # 스레드
import xml.etree        # XML
import zipfile          # ZIP
import tarfile          # TAR
import pickle           # 직렬화
import struct           # 바이너리
import socket           # 소켓
import inspect          # 검사
```

10. 월간.

---

## 5. PyPI 자경단 표준 30

**Web (5)**
- requests, httpx, aiohttp, urllib3, websockets

**Backend (5)**
- fastapi, flask, django, sqlalchemy, pydantic

**Data (5)**
- pandas, numpy, polars, pyarrow, openpyxl

**Test (5)**
- pytest, pytest-cov, hypothesis, faker, mock

**Quality (5)**
- black, ruff, mypy, pylint, coverage

**Utils (5)**
- rich, click, typer, python-dotenv, loguru

30. 자경단 매일 5-10개 사용.

---

## 6. 자경단 매일 13줄 흐름

```python
"""모든 자경단 코드의 첫 13줄."""

# stdlib
from pathlib import Path
from typing import Any
from datetime import datetime
import json
import logging
import os

# PyPI
import requests
from rich import print
from pydantic import BaseModel
import pytest

# 본인 코드
from vigilante.config import settings
from vigilante.utils import format_currency
```

13줄. 자경단 매일 첫 13줄.

---

## 7. 다섯 함정과 처방

**함정 1: 안 쓰는 import**

처방. ruff F401.

**함정 2: 너무 많은 wildcard**

처방. 명시적.

**함정 3: 의존성 폭발**

처방. 필요한 것만.

**함정 4: PyPI 검증 없음**

처방. 다운로드 수, GitHub 스타.

**함정 5: 보안 패키지 안 업데이트**

처방. dependabot.

---

## 8. 흔한 오해 다섯 가지

**오해 1: stdlib 다 외움.**

매일 10. 6주.

**오해 2: PyPI 다 좋음.**

검증.

**오해 3: 의존성 적을수록 좋다.**

필요한 건 OK. 과하게 적으면 재발명.

**오해 4: numpy = pandas.**

다른 도구.

**오해 5: pytest는 큰 프로젝트.**

작은 프로젝트도.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. requests vs httpx?**

requests 표준. httpx async.

**Q2. flask vs fastapi?**

자경단 표준 fastapi.

**Q3. pandas vs polars?**

pandas 표준. polars 빠름.

**Q4. click vs typer?**

typer가 modern.

**Q5. 60 모듈 다 외움?**

매일 10부터.

---

## 10. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, 60 모듈 다 외움. 안심 — 매일 10부터.
둘째, 안 쓰는 import 쌓임. 안심 — ruff F401 자동.
셋째, PyPI 다 좋음 가정. 안심 — 다운로드 + 스타 검증.
넷째, 의존성 폭발. 안심 — 필요한 것만.
다섯째, 가장 큰 — 보안 안 업데이트. 안심 — dependabot 자동.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 네 번째 시간 끝.

stdlib 30, PyPI 30. 자경단 60.

다음 H5는 vigilante_pkg 30분.

```bash
pip list | head -20
```

---

## 👨‍💻 개발자 노트

> - stdlib 우선: 외부 의존성 최소.
> - PyPI 검증: download/month, GitHub stars, last commit.
> - 의존성 충돌: pip-tools로 lock.
> - typing-extensions: Python 호환성.
> - safety check: 보안 취약점 스캔.
> - 다음 H5 키워드: vigilante_pkg · 5 모듈 · pyproject · pip install -e.
