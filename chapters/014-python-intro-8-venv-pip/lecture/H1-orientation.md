# Ch014 · H1 — venv/pip/pyproject 심화 오리엔테이션

> 고양이 자경단 · Ch 014 · 1교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — Ch013 회수와 오늘의 약속
2. 환경 격리가 무엇인가
3. 옛날 이야기 — 의존성 충돌의 그 날
4. 왜 환경 격리인가 — 일곱 가지 이유
5. 같이 쳐 보기 — venv 5초 셋업
6. 네 친구 — venv·pip·pyproject·uv
7. uv 첫 인상 — 100배 빠름
8. 자경단 다섯 명의 매일 환경
9. 8교시 미리보기
10. 환경 도구 30년
11. AI 시대의 dev 환경
12. 자주 받는 질문 다섯 가지
13. 흔한 오해 다섯 가지
14. 마무리

---

## 1. 다시 만나서 반가워요 — Ch013 회수와 오늘의 약속

자, 안녕하세요. 14번째 챕터예요.

지난 Ch013 회수. 모듈, 패키지, import. 첫 패키지 vigilante.

이번 Ch014는 환경 격리 심화. venv 깊이, uv 빠름.

오늘의 약속. **본인이 100% 자동화된 dev 환경을 구축합니다**.

자, 가요.

---

## 2. 환경 격리가 무엇인가

본인이 A 프로젝트에서 requests 2.28을 쓰고, B 프로젝트에서 requests 2.31을 쓴다고 해 봐요. 글로벌 Python 한 가지에 두 버전이 못 들어가요. 환경 격리가 그 문제를 해결.

각 프로젝트마다 자기만의 Python + 자기만의 패키지. 다른 프로젝트에 영향 없음.

자경단의 매일 — 모든 프로젝트는 venv 안에서.

---

## 3. 옛날 이야기 — 의존성 충돌의 그 날

옛날 이야기. 12년 전.

저는 처음 venv를 안 썼어요. pip install로 글로벌에 다 깔았어요. 한 달 후 다른 프로젝트의 패키지가 첫 프로젝트를 깼어요. system 통째 망가짐.

사수 형이 와서 venv를 알려줬어요. 모든 프로젝트는 venv. 의존성 충돌 0.

본인도 8시간 후 같아요.

---

## 4. 왜 환경 격리인가 — 일곱 가지 이유

**1. 의존성 충돌 0**.

**2. 정확한 재현**. 동료 같은 환경.

**3. CI/CD**. 깨끗한 환경.

**4. 보안**. 격리된 영향.

**5. 성능**. uv 100배 빠름.

**6. 자경단 매일**.

**7. 면접 단골**.

일곱.

---

## 5. 같이 쳐 보기 — venv 5초 셋업

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install requests
deactivate
```

5줄. 5초.

---

## 6. 네 친구 — venv·pip·pyproject·uv

**venv**. 표준 가상환경.

**pip**. 패키지 매니저.

**pyproject.toml**. 메타데이터.

**uv**. Rust 빠른 대체.

자경단 매일.

---

## 7. uv 첫 인상 — 100배 빠름

```bash
brew install uv

# venv (10ms vs python -m venv 1s)
uv venv .venv

# install (0.5s vs pip install 30s)
uv pip install requests

# sync from pyproject
uv pip sync
```

100배 빠름. 자경단 1년 후 표준.

---

## 8. 자경단 다섯 명의 매일 환경

다섯 명 다 venv 매일. 평균 3-5 venv 동시.

---

## 9. 8교시 미리보기

H2 — 4 단어 깊이.

H3 — 5 도구 비교 (venv, virtualenv, conda, pyenv, uv).

H4 — 30+ CLI 도구.

H5 — Makefile + Dockerfile + CI 자동화.

H6 — 5 최적화.

H7 — 깊이.

H8 — Ch015와 다리.

---

## 10. 환경 도구 30년

1990년대. virtualenv 첫.

2008년. PEP 8.

2012년. virtualenv 표준.

2014년. Python 3.3+ venv 내장.

2016년. pipenv 등장.

2018년. poetry.

2024년. uv (Astral).

---

## 11. AI 시대의 dev 환경

AI한테 "이 프로젝트 dev 환경 셋업" 한 줄. 즉시 venv + pip 명령.

자경단 80/20.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. venv vs virtualenv?**

venv 표준 (3.3+).

**Q2. conda vs venv?**

conda는 데이터 분야. venv 표준.

**Q3. uv 도입 시기?**

자경단 1년 후 검토.

**Q4. pipenv vs poetry?**

poetry가 더 활성. 자경단은 pip + pyproject.

**Q5. 8시간 길어요.**

dev 환경이 모든 코드의 토대.

---

## 13. 흔한 오해 다섯 가지

**오해 1: venv 부담스러움.**

3초.

**오해 2: 글로벌 OK.**

한 달 후 사고.

**오해 3: 한 venv 모든 프로젝트.**

프로젝트마다 venv.

**오해 4: uv는 실험적.**

Astral 정식 도구.

**오해 5: poetry 표준.**

자경단은 pip + pyproject.

---

## 14. 흔한 실수 다섯 + 안심 — 환경 첫 학습 편

첫째, venv 부담스러움. 안심 — 3초.
둘째, 글로벌에 다 깔기. 안심 — 한 달 후 사고.
셋째, 한 venv 다 사용. 안심 — 프로젝트마다 격리.
넷째, uv 실험적. 안심 — Astral 정식.
다섯째, 가장 큰 — poetry 표준 가정. 안심 — 자경단 pip + pyproject.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 15. 마무리

자, 첫 시간 끝.

네 친구 — venv, pip, pyproject, uv. 자경단 매일.

다음 H2는 깊이.

```bash
python3 -m venv test-env
source test-env/bin/activate
deactivate
rm -rf test-env
```

---

## 👨‍💻 개발자 노트

> - venv 내부: 별도 site-packages, sys.prefix 변경.
> - pip --user: 글로벌 user 설치. 안 권장.
> - uv: Rust + Astral. ruff 만든 곳.
> - PEP 405 (venv): Python 3.3+.
> - 다음 H2 키워드: venv 활성화 · pip lock · pyproject · uv 명령.
