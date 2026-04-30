# Ch014 · H2 — venv/pip/pyproject/uv 4 단어 깊이

> 고양이 자경단 · Ch 014 · 2교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. venv 깊이 — 7 명령어
3. pip 깊이 — 10 명령어
4. pyproject.toml 7 섹션
5. uv 깊이 — 5 명령어
6. lock file 패턴
7. 한 줄 분해
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요.

지난 H1 회수. 네 친구.

이번 H2는 깊이.

오늘의 약속. **본인이 4 도구의 모든 명령어를 다룹니다**.

자, 가요.

---

## 2. venv 깊이 — 7 명령어

```bash
# 1. 생성
python3 -m venv .venv
python3 -m venv .venv --prompt myproject  # 프롬프트 이름

# 2. 활성화
source .venv/bin/activate           # macOS/Linux
.venv\Scripts\activate              # Windows

# 3. 비활성화
deactivate

# 4. 삭제
rm -rf .venv

# 5. Python 버전 명시
python3.12 -m venv .venv

# 6. 시스템 site-packages 접근 (권장 X)
python3 -m venv .venv --system-site-packages

# 7. 검증
which python3            # .venv/bin/python3
python3 -c "import sys; print(sys.prefix)"
```

---

## 3. pip 깊이 — 10 명령어

```bash
# 1. install
pip install requests

# 2. 정확한 버전
pip install requests==2.31.0

# 3. 범위
pip install "requests>=2.30,<3.0"

# 4. requirements
pip install -r requirements.txt

# 5. editable (개발)
pip install -e .

# 6. -U upgrade
pip install -U requests

# 7. 캐시 비활성화
pip install --no-cache-dir requests

# 8. private index
pip install --index-url https://my.pypi.com/simple/ pkg

# 9. download만
pip download requests

# 10. wheel 빌드
pip wheel requests
```

---

## 4. pyproject.toml 7 섹션

```toml
# 1. 프로젝트 메타데이터
[project]
name = "vigilante"
version = "1.0.0"
description = "자경단 도구"
authors = [{name = "Bonin"}]
requires-python = ">=3.10"

# 2. 의존성
dependencies = [
    "requests>=2.30",
    "rich>=13",
]

# 3. 옵션 의존성 (dev 등)
[project.optional-dependencies]
dev = ["pytest", "ruff", "mypy"]
docs = ["sphinx"]

# 4. CLI 진입점
[project.scripts]
vigilante = "vigilante.cli:main"

# 5. 빌드 시스템
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

# 6. 도구 설정 (ruff, mypy 등)
[tool.ruff]
line-length = 88

[tool.mypy]
strict = true

# 7. URL
[project.urls]
Homepage = "https://github.com/cat-vigilante"
Repository = "https://github.com/cat-vigilante/vigilante"
```

7 섹션. 자경단 표준.

---

## 5. uv 깊이 — 5 명령어

```bash
# 1. venv (빠름)
uv venv .venv

# 2. install
uv pip install requests

# 3. sync (lock 기반)
uv pip sync requirements.txt

# 4. compile (lock 생성)
uv pip compile requirements.in -o requirements.txt

# 5. 도구로 실행 (pipx 비슷)
uv tool install black
```

5 명령어. 자경단 1년 후.

---

## 6. lock file 패턴

```bash
# requirements.in (직접 의존성)
echo "requests>=2.30" > requirements.in
echo "rich>=13" >> requirements.in

# pip-compile로 lock
pip-compile requirements.in
# 결과: requirements.txt

# 또는 uv
uv pip compile requirements.in -o requirements.txt
```

`requirements.txt` 예시.

```
# generated from requirements.in
requests==2.31.0
rich==13.7.0
markdown-it-py==3.0.0    # via rich
certifi==2023.11.17       # via requests
...
```

direct + transitive 모두 정확한 버전. 자경단 표준.

---

## 7. 한 줄 분해

```bash
uv venv .venv && source .venv/bin/activate && uv pip sync requirements.txt
```

자경단 매일 첫 명령.

---

## 8. 흔한 오해 다섯 가지

**오해 1: pip만으로 충분.**

큰 프로젝트는 pip-tools.

**오해 2: pyproject 어렵다.**

10줄로 시작.

**오해 3: uv 실험적.**

production 가능.

**오해 4: lock 없어도 OK.**

production은 lock 필수.

**오해 5: editable install 부담.**

pip install -e . 한 번.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. requirements vs pyproject?**

pyproject 표준. requirements lock으로.

**Q2. uv 안전?**

Astral. ruff와 같은 회사.

**Q3. dev 의존성?**

`[project.optional-dependencies] dev`.

**Q4. transitive 의존성?**

pip-compile이 자동.

**Q5. 패키지 발행 vs 사용?**

pyproject가 둘 다.

---

## 10. 흔한 실수 다섯 + 안심 — 핵심 학습 편

첫째, pip만 사용. 안심 — pip-tools 또는 uv.
둘째, lock 파일 무지. 안심 — pip-compile.
셋째, pyproject 어렵다. 안심 — 10줄로 시작.
넷째, dev 의존성 섞음. 안심 — optional-dependencies로.
다섯째, 가장 큰 — uv 실험. 안심 — Astral 정식 production.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 두 번째 시간 끝.

venv 7, pip 10, pyproject 7 섹션, uv 5.

다음 H3는 5 도구 비교.

```bash
uv venv test
source test/bin/activate
uv pip install requests
deactivate
```

---

## 👨‍💻 개발자 노트

> - venv 활성화 스크립트: PATH 변경 + PROMPT.
> - pip resolver: 2020+ 새 resolver. 충돌 검사.
> - pyproject.toml PEP 621: 표준화.
> - uv resolver: pip-tools 호환.
> - hatchling vs setuptools: hatchling이 modern.
> - 다음 H3 키워드: venv · virtualenv · conda · pyenv · uv 비교.
