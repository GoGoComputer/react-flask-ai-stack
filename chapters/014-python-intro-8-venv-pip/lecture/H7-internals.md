# Ch014 · H7 — Python 패키징 PEP — 517·518·621·440·723

> 고양이 자경단 · Ch 014 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. PEP 517 — build backend
3. PEP 518 — pyproject.toml
4. PEP 621 — 메타데이터 표준
5. PEP 440 — 버전 specifier
6. PEP 723 — single file scripts
7. wheel 형식
8. uv 알고리즘
9. 흔한 오해 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요

자, 안녕하세요.

지난 H6 회수. 5 최적화 — cache, parallel, matrix, layer, hash.

이번 H7은 Python 패키징의 표준.

오늘의 약속. **본인이 pyproject.toml의 모든 줄을 이해합니다**.

자, 가요.

---

## 2. PEP 517 — build backend

옛 — setup.py가 표준. setuptools만 가능.

PEP 517 (2017) — build backend 분리. setuptools, hatchling, flit, poetry-core 선택 가능.

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

자경단 표준 — hatchling. 가벼움, 모던.

빌드 흐름.

```
pip install . →
pip이 build-backend 호출 →
backend가 wheel 만들기 →
pip이 wheel 설치
```

자경단 매주 한 번.

---

## 3. PEP 518 — pyproject.toml

옛 — setup.py + setup.cfg + requirements.txt + 여러 파일.

PEP 518 — 한 파일에 모든 설정. pyproject.toml.

```toml
[build-system]
[project]
[tool.ruff]
[tool.mypy]
[tool.pytest.ini_options]
```

자경단 표준 — 모든 설정 한 파일.

---

## 4. PEP 621 — 메타데이터 표준

`[project]` 섹션의 표준화.

```toml
[project]
name = "vigilante"
version = "1.0.0"
description = "..."
readme = "README.md"
requires-python = ">=3.10"
license = {text = "MIT"}
authors = [{name = "Bonin", email = "..."}]
keywords = ["cat", "vigilante"]
classifiers = ["..."]
dependencies = [...]

[project.optional-dependencies]
dev = [...]

[project.scripts]
vigilante = "vigilante.cli:main"

[project.urls]
Homepage = "..."
```

PEP 621 이전엔 build backend마다 형식 달랐어요. 이제 표준.

---

## 5. PEP 440 — 버전 specifier

```
==1.0.0       # 정확
>=1.0,<2.0    # 범위
~=1.0         # compatible (1.x)
!=1.5         # 제외
1.0.0a1       # alpha
1.0.0b1       # beta
1.0.0rc1      # release candidate
1.0.0.dev0    # dev
1.0.0+local   # local 빌드
```

자경단 표준 — `==` 정확 버전 (production), `>=,<` 범위 (라이브러리).

---

## 6. PEP 723 — single file scripts

Python 3.12+의 새 PEP. 한 파일 안에 의존성 명시.

```python
# /// script
# dependencies = [
#   "requests>=2.30",
#   "rich>=13",
# ]
# ///

import requests
from rich import print

print(requests.get("https://api.com").json())
```

`pipx run script.py` 또는 `uv run script.py`로 실행. 의존성 자동 설치 + 격리.

자경단 — 작은 도구 스크립트에. 큰 프로젝트는 pyproject.toml.

---

## 7. wheel 형식

`.whl` 파일이 Python 패키지의 표준 배포 형식.

```
vigilante-1.0.0-py3-none-any.whl

vigilante: 패키지 이름
1.0.0: 버전
py3: Python 3
none: ABI 없음 (pure Python)
any: 모든 OS
```

내부는 zip 압축. metadata + 코드.

C 확장이 있으면 OS/Python 버전 별 wheel.

```
numpy-1.24.0-cp312-cp312-macosx_11_0_arm64.whl
```

자경단 매일 — pip이 알아서 wheel 다운.

---

## 8. uv 알고리즘

uv가 pip보다 100배 빠른 비결.

**1. Rust로 짜짐**. Python보다 빠름.

**2. 병렬 다운로드**. 여러 패키지 동시.

**3. 캐싱**. 글로벌 cache 한 곳.

**4. 의존성 해결 알고리즘**. PubGrub. pip의 backtracking보다 효율.

**5. 메모리 매핑**. 다운로드한 wheel을 mmap.

자경단 1년 후 표준 가능.

---

## 9. 흔한 오해 다섯 가지

**오해 1: setup.py 표준.**

PEP 517 이후 pyproject.toml.

**오해 2: 모든 PEP 외워야.**

원리만. pip이 자동.

**오해 3: wheel 직접 만들기.**

build로 자동.

**오해 4: uv 위험.**

Astral 정식.

**오해 5: PEP 723 모든 곳.**

작은 스크립트만.

---

## 10. 흔한 실수 다섯 + 안심 — 깊이 학습 편

첫째, setup.py 표준 가정. 안심 — pyproject.toml.
둘째, PEP 다 외움. 안심 — 원리만, pip 자동.
셋째, wheel 직접 만들기. 안심 — build로 자동.
넷째, uv 실험적. 안심 — Astral 정식.
다섯째, 가장 큰 — PEP 723 모든 곳. 안심 — 작은 스크립트만.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 일곱 번째 시간 끝.

PEP 517 (backend), 518 (pyproject), 621 (metadata), 440 (version), 723 (single file). wheel, uv 알고리즘.

다음 H8은 적용 + 회고.

```bash
cat pyproject.toml | head -20
```

---

## 👨‍💻 개발자 노트

> - PEP 517, 518, 621: pyproject.toml 표준화.
> - wheel vs sdist: wheel은 binary, sdist는 source.
> - uv resolver: PubGrub.
> - 다음 H8 키워드: 7H 회고 · venv/pip 마스터 · Ch015 다리.
