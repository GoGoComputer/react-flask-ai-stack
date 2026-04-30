# Ch013 · H3 — venv·pip·pyproject·twine·pipx 5 도구

> 고양이 자경단 · Ch 013 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 첫째 — venv 깊이 (Ch007 회수)
3. 둘째 — pip 깊이
4. 셋째 — pyproject.toml
5. 넷째 — twine으로 PyPI 공개
6. 다섯째 — pipx로 CLI 격리
7. 자경단 매일 패키지 의식
8. 다섯 시나리오
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요.

지난 H2 회수. import 5, from 5, __init__.py, __name__.

이번 H3는 패키지 도구 5.

오늘의 약속. **본인이 자기 패키지를 만들고 PyPI에 공개할 수 있게 됩니다**.

자, 가요.

---

## 2. 첫째 — venv 깊이

Ch007 H3에서 봤어요. 한 번 더.

```bash
python3 -m venv .venv
source .venv/bin/activate
deactivate
```

자경단 매일.

---

## 3. 둘째 — pip 깊이

```bash
# 기본
pip install requests
pip install requests==2.31.0
pip install "requests>=2.30,<3.0"
pip install -e .                # editable install (현재 폴더)
pip install -r requirements.txt

# 정보
pip show requests
pip list
pip list --outdated

# 업그레이드
pip install -U requests
pip install --upgrade pip

# 제거
pip uninstall requests
```

자경단 매일.

---

## 4. 셋째 — pyproject.toml

modern Python의 표준 프로젝트 파일. setup.py를 대체.

```toml
[project]
name = "vigilante"
version = "0.1.0"
description = "자경단 도구"
authors = [{name = "Bonin", email = "bonin@example.com"}]
requires-python = ">=3.10"
dependencies = [
    "requests>=2.30",
    "rich>=13",
]

[project.scripts]
vigilante = "vigilante.cli:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
line-length = 88

[tool.mypy]
strict = true
```

한 파일에 모든 설정. 의존성, 빌드, 린터, 타입.

자경단 표준.

---

## 5. 넷째 — twine으로 PyPI 공개

본인 패키지를 PyPI에 올리는 도구.

```bash
pip install twine

# 빌드
pip install build
python3 -m build

# 업로드 (test PyPI 먼저)
twine upload --repository testpypi dist/*

# 진짜 PyPI
twine upload dist/*
```

자경단 — 자주 안 씀. 본인의 첫 패키지 공개 시 한 번.

---

## 6. 다섯째 — pipx로 CLI 격리

CLI 도구를 글로벌로 깔되 격리. 라이브러리는 pip + venv, CLI는 pipx.

```bash
brew install pipx

# CLI 도구 설치
pipx install black
pipx install ruff
pipx install httpie

# 사용
black .
http GET https://api.com
```

각 도구가 자기 venv에 깔림. 의존성 충돌 0.

자경단 표준 — 글로벌 CLI는 pipx.

---

## 7. 자경단 매일 패키지 의식

**1. 새 프로젝트** → venv + pip install + pyproject.toml

**2. 기존 프로젝트** → venv + pip install -r

**3. CLI 도구** → pipx install

**4. 패키지 발행** → twine

**5. 의존성 업데이트** → pip-review 또는 dependabot

다섯.

---

## 8. 다섯 시나리오

**시나리오 1: 의존성 충돌**

처방. venv 격리.

**시나리오 2: 새 머신 셋업**

처방. requirements.txt + pip install -r.

**시나리오 3: 패키지 공개**

처방. twine upload.

**시나리오 4: 글로벌 CLI 충돌**

처방. pipx.

**시나리오 5: editable install**

처방. `pip install -e .`.

---

## 9. 흔한 오해 다섯 가지

**오해 1: setup.py 표준.**

modern은 pyproject.toml.

**오해 2: pip vs poetry.**

pip + pyproject 표준. poetry 옵션.

**오해 3: pipx 옵션.**

자경단 표준.

**오해 4: PyPI 무서움.**

검증된 패키지만.

**오해 5: requirements.txt 충분.**

pyproject가 더 강력.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. requirements vs pyproject?**

pyproject가 modern.

**Q2. pip vs uv?**

uv가 100배 빠름. 자경단 1년 후.

**Q3. 패키지 vs 모듈 발행?**

PyPI는 패키지.

**Q4. 본인 패키지 검색?**

PyPI 검색 또는 pip search.

**Q5. test PyPI?**

연습용. test.pypi.org.

---

## 11. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, setup.py 표준. 안심 — pyproject.toml로.
둘째, pipx 옵션. 안심 — 글로벌 CLI는 pipx.
셋째, requirements.txt 충분. 안심 — pyproject 강력.
넷째, twine 어렵다. 안심 — build + upload 두 단계.
다섯째, 가장 큰 — venv 잊음. 안심 — 새 프로젝트마다.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 세 번째 시간 끝.

venv, pip, pyproject, twine, pipx 5 도구.

다음 H4는 stdlib 30+ + PyPI 30+.

```bash
pipx install black
black --version
```

---

## 👨‍💻 개발자 노트

> - pyproject.toml PEP 621: 메타데이터 표준.
> - build backend: hatchling, setuptools, flit, poetry-core.
> - twine vs python -m build: build로 만들고 twine으로 업로드.
> - pipx vs pip --user: pipx가 격리.
> - editable install PEP 660: pyproject 표준.
> - 다음 H4 키워드: stdlib 30 · PyPI 30 · 자경단 백엔드 stack.
