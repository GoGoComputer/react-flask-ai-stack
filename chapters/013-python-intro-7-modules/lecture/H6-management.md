# Ch013 · H6 — 모듈/패키지 운영 — 5 함정 + 측정 + dependency

> 고양이 자경단 · Ch 013 · 6교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 다섯 함정과 처방
3. 의존성 관리 — pip-tools
4. 보안 측정 — safety, pip-audit
5. 의존성 그래프 시각화
6. 자동 업데이트 — dependabot
7. 자경단 매일 운영 의식
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요.

지난 H5 회수. vigilante 패키지 5 모듈.

이번 H6은 운영. 의존성, 측정, 보안.

오늘의 약속. **본인의 패키지 의존성을 안전하게 관리합니다**.

자, 가요.

---

## 2. 다섯 함정과 처방

**함정 1: 의존성 폭발**

처방. 필요한 것만. transitive 검토.

**함정 2: 버전 미고정**

처방. requirements.txt에 ==.

**함정 3: 보안 취약점**

처방. dependabot + safety.

**함정 4: 패키지 충돌**

처방. venv 격리.

**함정 5: 너무 많은 모듈**

처방. 합리적 분할 (3-7개).

---

## 3. 의존성 관리 — pip-tools

```bash
pip install pip-tools

# requirements.in (직접 관리)
echo "requests>=2.30" > requirements.in
echo "rich>=13" >> requirements.in

# requirements.txt 생성 (lock)
pip-compile requirements.in
# requirements.txt — 모든 transitive 의존성과 정확한 버전

# 설치
pip-sync requirements.txt
```

자경단 표준 — 직접 의존성은 .in, lock은 .txt.

---

## 4. 보안 측정 — safety, pip-audit

```bash
pip install safety
safety check
# 알려진 취약점 보고

pip install pip-audit
pip-audit
```

CI에 박아 두면 매주 자동 검사.

---

## 5. 의존성 그래프 시각화

```bash
pip install pipdeptree
pipdeptree
# 트리 형태로 표시

pipdeptree --graph-output png > deps.png
```

```
vigilante==0.1.0
├── requests [required: >=2.30]
│   ├── certifi
│   ├── charset-normalizer
│   ├── idna
│   └── urllib3
└── rich [required: >=13]
    └── markdown-it-py
```

자경단 매주.

---

## 6. 자동 업데이트 — dependabot

GitHub의 자동 업데이트 도구.

`.github/dependabot.yml`.

```yaml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
```

매주 자동으로 PR 만들어 줌. 자경단 표준.

---

## 7. 자경단 매일 운영 의식

**1. 새 의존성** → safety check

**2. 의존성 lock** → pip-tools

**3. 보안** → pip-audit + dependabot

**4. 시각화** → pipdeptree

**5. 업데이트** → 매주 한 번 PR 검토

다섯.

---

## 8. 흔한 오해 다섯 가지

**오해 1: 의존성 적을수록 좋다.**

필요한 건 OK. 재발명 안 함.

**오해 2: 버전 안 고정.**

production은 항상 고정.

**오해 3: pip만으로 충분.**

큰 프로젝트는 pip-tools.

**오해 4: 보안 검사 시니어.**

신입부터.

**오해 5: dependabot 노이즈.**

처음만. 익숙해짐.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. requirements.in vs .txt?**

.in은 직접, .txt는 lock.

**Q2. poetry는?**

옵션. pip + pip-tools 표준.

**Q3. uv?**

100배 빠름. 1년 후 표준.

**Q4. semantic versioning?**

major.minor.patch. major는 호환 깨짐.

**Q5. dev vs production 의존성?**

[project.optional-dependencies] 분리.

---

## 10. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, 의존성 폭발. 안심 — 필요한 것만.
둘째, 버전 안 고정. 안심 — production ==.
셋째, 보안 무시. 안심 — pip-audit + dependabot.
넷째, lock 파일 무지. 안심 — pip-tools.
다섯째, 가장 큰 — 수동 업데이트. 안심 — dependabot 자동 PR.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 여섯 번째 시간 끝.

5 함정, pip-tools, 보안, 시각화, dependabot.

다음 H7은 깊이. import 시스템 내부.

```bash
pip install pipdeptree
pipdeptree
```

---

## 👨‍💻 개발자 노트

> - PEP 440: version specifiers.
> - PEP 508: dependency specification.
> - lock file (pip-tools): 정확한 버전.
> - dependabot vs renovatebot: GitHub vs 다용도.
> - virtualenv 다중: tox로 다중 Python 테스트.
> - 다음 H7 키워드: import 시스템 · finder · loader · spec.
