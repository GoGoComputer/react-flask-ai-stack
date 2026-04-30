# Ch014 · H3 — 환경 5 도구 비교 — venv·virtualenv·conda·pyenv·uv

> 고양이 자경단 · Ch 014 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 다섯 도구 한 표
3. venv (표준)
4. virtualenv (옛 표준)
5. conda (데이터 분야)
6. pyenv (다중 버전)
7. uv (모던)
8. 자경단 매일 의식
9. 다섯 시나리오
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요.

지난 H2 회수. venv 7, pip 10, pyproject 7, uv 5.

이번 H3는 5 도구 비교.

오늘의 약속. **본인이 어떤 도구를 언제 쓸지 직관 갖습니다**.

자, 가요.

---

## 2. 다섯 도구 한 표

| 도구 | 사용처 | 자경단 평가 |
|------|--------|------------|
| venv | 표준 가상환경 | ⭐⭐⭐⭐⭐ 매일 |
| virtualenv | 옛 표준 | ⭐⭐ 호환성 |
| conda | 데이터 분야 | ⭐⭐⭐ 데이터팀 |
| pyenv | 다중 버전 | ⭐⭐⭐⭐ 자주 |
| uv | 모던 통합 | ⭐⭐⭐⭐⭐ 1년 후 |

---

## 3. venv (표준)

Python 3.3+ 내장. 추가 설치 없음.

```bash
python3 -m venv .venv
source .venv/bin/activate
```

자경단 매일.

장점 — 표준, 가벼움. 단점 — 다중 버전 안 됨 (시스템 Python 사용).

---

## 4. virtualenv (옛 표준)

```bash
pip install virtualenv
virtualenv .venv
```

venv 등장 전 표준. 이제 거의 안 씀. 호환성으로만.

---

## 5. conda (데이터 분야)

```bash
brew install miniconda

conda create -n myenv python=3.12
conda activate myenv
conda install numpy pandas
```

장점 — non-Python 라이브러리도 (CUDA, MKL). 데이터·ML 분야 강력.
단점 — 무거움, pip와 충돌.

자경단 — 데이터팀만.

---

## 6. pyenv (다중 버전)

Ch007 H3에서 봤어요.

```bash
brew install pyenv
pyenv install 3.10
pyenv install 3.12
pyenv global 3.12
pyenv local 3.10   # 폴더별
```

장점 — 다중 Python 버전.
단점 — venv와 같이 써야 패키지 격리.

조합. `pyenv local 3.12 + python3 -m venv .venv`.

---

## 7. uv (모던)

```bash
brew install uv

uv venv .venv
uv pip install requests
uv pip sync
```

장점 — pip 10-100배 빠름. pip + venv 통합.
단점 — 새 도구 (1년).

자경단 1년 후 표준.

---

## 8. 자경단 매일 의식

**1. 일반 프로젝트** → pyenv + venv + pip

**2. 데이터 프로젝트** → conda

**3. 큰 프로젝트** → pyenv + venv + pip-tools

**4. 새 시도** → uv

**5. CI** → venv (단순)

자경단 매일.

---

## 9. 다섯 시나리오

**시나리오 1: 새 프로젝트**

처방. `python3 -m venv .venv && source .venv/bin/activate && pip install -e .`

**시나리오 2: 다른 Python 버전 필요**

처방. pyenv install + pyenv local.

**시나리오 3: 데이터 분야**

처방. conda + numpy + pandas.

**시나리오 4: 빠른 실험**

처방. uv venv + uv pip.

**시나리오 5: CI 셋업**

처방. venv + requirements.txt + cache.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 한 도구로 충분.**

상황별 다름.

**오해 2: conda는 항상 좋다.**

데이터 분야만.

**오해 3: virtualenv 옛 도구.**

venv가 표준. virtualenv는 호환.

**오해 4: pyenv는 시니어.**

신입도. 다중 버전 자주.

**오해 5: uv는 실험.**

production 가능.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. venv vs virtualenv?**

venv 표준.

**Q2. conda 깔아야?**

데이터 분야만.

**Q3. pyenv vs asdf?**

asdf는 다언어 (Python + Node + ...). 자경단 pyenv.

**Q4. uv production?**

가능. Astral 정식.

**Q5. 5 도구 다 알아야?**

venv + pyenv + uv면 90%.

---

## 12. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, 한 도구로 충분 가정. 안심 — 상황별 다름.
둘째, conda 항상 사용. 안심 — 데이터 분야만.
셋째, pyenv 시니어 도구. 안심 — 다중 버전 매주.
넷째, virtualenv 매일. 안심 — venv 표준.
다섯째, 가장 큰 — 5 도구 다 외움. 안심 — venv + pyenv + uv면 90%.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 세 번째 시간 끝.

venv (표준), virtualenv (옛), conda (데이터), pyenv (다중), uv (모던).

다음 H4는 30+ CLI.

```bash
which python3
python3 -m venv test
source test/bin/activate && deactivate
rm -rf test
```

---

## 👨‍💻 개발자 노트

> - PEP 405: venv.
> - virtualenv 외부 라이브러리.
> - conda env vs pip env: conda가 binary 포함.
> - pyenv shims: PATH 가로채기.
> - uv resolver: pip-tools 호환.
> - 다음 H4 키워드: lint · format · test · doc · debug 30 도구.
