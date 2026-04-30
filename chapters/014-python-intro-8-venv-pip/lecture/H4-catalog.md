# Ch014 · H4 — CLI 도구 카탈로그 30+ — lint·format·test·doc·debug

> 고양이 자경단 · Ch 014 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 30+ 도구 한 표
3. 첫째 — lint 6개
4. 둘째 — format 5개
5. 셋째 — test 7개
6. 넷째 — doc 5개
7. 다섯째 — debug 7개
8. 자경단 매일 13줄 흐름
9. 다섯 함정과 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요.

지난 H3 회수. 5 환경 도구.

이번 H4는 30+ CLI 도구.

오늘의 약속. **본인이 매일 만날 30+ 도구를 카테고리별로 손가락에 박습니다**.

자, 가요.

---

## 2. 30+ 도구 한 표

| 카테고리 | 도구 |
|---------|------|
| Lint | ruff, pylint, flake8, bandit, vulture, prospector |
| Format | black, ruff format, isort, autopep8, yapf |
| Test | pytest, pytest-cov, hypothesis, tox, nox, faker, mock |
| Doc | sphinx, mkdocs, pdoc, pydoc, interrogate |
| Debug | pdb, ipdb, py-spy, memory_profiler, line_profiler, cProfile, scalene |

30+ 도구.

---

## 3. 첫째 — lint 6개

```bash
# ruff (자경단 표준, Rust 100배)
ruff check .

# pylint (옛 표준, 강력)
pylint myfile.py

# flake8 (PEP 8 + 더)
flake8 .

# bandit (보안 lint)
bandit -r .

# vulture (dead code)
vulture .

# prospector (통합)
prospector .
```

자경단 표준 — ruff. 그 외는 옵션.

---

## 4. 둘째 — format 5개

```bash
# black (자경단 표준)
black .

# ruff format (모던 통합)
ruff format .

# isort (import 정렬)
isort .

# autopep8 (PEP 8 자동)
autopep8 --in-place .

# yapf (Google)
yapf -i .
```

자경단 표준 — black + ruff format.

---

## 5. 셋째 — test 7개

```bash
# pytest (표준)
pytest

# coverage
pytest --cov

# hypothesis (property-based)
# pytest 코드 안에서 사용

# tox (다중 환경 테스트)
tox

# nox (tox 대안, Python으로 설정)
nox

# faker (가짜 데이터)
# 코드 안에서 사용

# mock (Mock 객체)
# unittest.mock 또는 pytest-mock
```

자경단 표준 — pytest + cov + hypothesis.

---

## 6. 넷째 — doc 5개

```bash
# sphinx (대형 표준)
sphinx-quickstart docs

# mkdocs (간단 markdown)
mkdocs new docs
mkdocs serve

# pdoc (자동 API doc)
pdoc vigilante

# pydoc (표준 라이브러리)
pydoc vigilante.exchange

# interrogate (docstring coverage)
interrogate -v .
```

자경단 — mkdocs (간단), sphinx (큰 프로젝트).

---

## 7. 다섯째 — debug 7개

```bash
# pdb (표준)
python3 -m pdb script.py

# ipdb (ipython 기반)
import ipdb; ipdb.set_trace()

# py-spy (실행 중 sampling)
py-spy top --pid 12345

# memory_profiler
python3 -m memory_profiler script.py

# line_profiler
kernprof -l script.py

# cProfile (표준)
python3 -m cProfile script.py

# scalene (통합 profiler)
scalene script.py
```

자경단 — pdb 매일, py-spy 가끔.

---

## 8. 자경단 매일 13줄 흐름

```bash
# 자경단 매일 코드 검증 13줄

# 1-2. format
black .
ruff format .

# 3-4. lint
ruff check . --fix
mypy --strict .

# 5-7. test
pytest -v
pytest --cov --cov-report=html
hypothesis show

# 8-9. doc
interrogate -v .
mkdocs build

# 10-11. security
bandit -r .
safety check

# 12-13. profile (가끔)
python3 -m cProfile -s cumtime script.py
py-spy top --pid $(pgrep -f myapp)
```

13줄.

---

## 9. 다섯 함정과 처방

**함정 1: ruff와 black 충돌**

처방. ruff format이 black 호환.

**함정 2: pylint vs ruff**

처방. ruff 표준.

**함정 3: tox 셋업 어렵다**

처방. nox로.

**함정 4: docstring 부족**

처방. interrogate로 측정.

**함정 5: profile 너무 많은 데이터**

처방. cProfile + snakeviz로 시각화.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 30 도구 다 외움.**

매일 5개부터.

**오해 2: pylint는 옛 도구.**

ruff가 90% 대체. pylint는 깊은 검사.

**오해 3: tox 항상.**

자경단은 GitHub Actions matrix 우선.

**오해 4: sphinx만.**

mkdocs가 더 간단.

**오해 5: profiler 시니어.**

신입도 가끔.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. ruff vs flake8?**

ruff 표준.

**Q2. pytest vs unittest?**

pytest 표준.

**Q3. sphinx vs mkdocs?**

mkdocs 간단, sphinx 강력.

**Q4. tox vs nox?**

nox가 modern (Python 설정).

**Q5. profile 매일?**

가끔. 성능 의심 시.

---

## 12. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, 30 도구 다 외움. 안심 — 매일 5개부터.
둘째, ruff와 black 중복. 안심 — ruff format이 호환.
셋째, tox 셋업 어렵다. 안심 — nox 또는 GHA matrix.
넷째, profiler 시니어. 안심 — pdb 매일.
다섯째, 가장 큰 — pylint 표준 가정. 안심 — ruff가 90% 대체.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 네 번째 시간 끝.

lint 6, format 5, test 7, doc 5, debug 7. 30 도구.

다음 H5는 100% 자동 dev 환경.

```bash
ruff check .
black .
pytest -v
mypy --strict .
```

---

## 👨‍💻 개발자 노트

> - ruff: pyflakes + flake8 + isort + 일부 pylint 통합.
> - pytest fixtures: conftest.py.
> - hypothesis: property-based testing.
> - sphinx: reST + autodoc.
> - py-spy: BPF, sampling profiler.
> - 다음 H5 키워드: Makefile · Dockerfile · CI · 100% 자동.
