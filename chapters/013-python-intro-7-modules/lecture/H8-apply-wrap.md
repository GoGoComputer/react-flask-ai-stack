# Ch013 · H8 — 7H 회고 + vigilante 패키지 + Ch014 다리

> 고양이 자경단 · Ch 013 · 8교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수
2. Ch013 7시간 회고
3. vigilante 패키지의 진화
4. 모듈 다섯 원리
5. 5년 자산
6. Ch014 다리
7. 마무리

---

## 1. 다시 만나서 반가워요

자, 안녕하세요. 본 챕터의 마지막.

지난 H7. import 시스템 내부.

오늘. 회고.

자, 가요.

---

## 2. Ch013 7시간 회고

**H1** — 모듈/패키지 큰 그림.

**H2** — 4 단어. import, from, __init__.py, __name__.

**H3** — venv, pip, pyproject, twine, pipx.

**H4** — stdlib 30 + PyPI 30.

**H5** — vigilante 패키지 5 모듈.

**H6** — dependency, 보안.

**H7** — import 시스템 내부.

**H8** — 회고.

7시간이 코드 구조 토대.

---

## 3. vigilante 패키지의 진화

**v1 (Ch013)** — 5 모듈 100줄.

**v2 (1년 후)** — 15 모듈 500줄.

**v3 (3년 후)** — PyPI 공개. 다른 회사도 사용.

**v4 (5년 후)** — 50 모듈. 자경단의 표준 라이브러리.

본인의 첫 패키지가 5년 자산.

---

## 4. 모듈 다섯 원리

**원리 1 — 한 모듈 한 책임**.

500줄 넘으면 분리.

**원리 2 — public API는 __init__.py에**.

**원리 3 — absolute import 표준**.

**원리 4 — 의존성 lock**.

requirements.txt 정확한 버전.

**원리 5 — 패키지 첫날부터 pyproject.toml**.

다섯. 5년.

---

## 5. 5년 자산

**개념** — module, package, import, __init__.py, __name__.

**도구** — venv, pip, pyproject, twine, pipx, pip-tools.

**원리** — 다섯.

**코드** — vigilante 패키지.

**자신감** — PyPI에 본인 패키지 발행 가능.

5년.

---

## 6. Ch014 다리

다음 챕터 Ch014는 venv/pip 심화. 모듈의 환경.

본인 패키지를 더 큰 프로젝트로. uv, Makefile, Dockerfile, CI.

Ch013 모듈 + Ch014 환경 = 본인 프로젝트의 인프라.

---

## 7. 흔한 실수 다섯 + 안심 — 챕터 회고 편

첫째, 한 모듈 다 모음. 안심 — 500줄 넘으면 분리.
둘째, public API 흩어짐. 안심 — __init__.py에 모음.
셋째, relative import. 안심 — absolute 표준.
넷째, 의존성 미고정. 안심 — pip-tools lock.
다섯째, 가장 큰 — 첫 패키지 두려움. 안심 — pyproject 10줄로 시작.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 8. 마무리

박수. 본인이 모듈 8시간 끝까지.

본 챕터 끝. 다음 — Ch014 H1.

```bash
pip install -e .
python3 -c "import vigilante; print(vigilante.__version__)"
```

---

## 👨‍💻 개발자 노트

> - 모듈은 코드의 단위.
> - 다음 챕터 Ch014: venv 심화, uv, Makefile, CI.
