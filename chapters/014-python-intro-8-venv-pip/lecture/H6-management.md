# Ch014 · H6 — 운영 5 최적화 — 캐시·parallel·matrix·layer·hash

> 고양이 자경단 · Ch 014 · 6교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 첫째 — 캐시 (pip, GitHub Actions)
3. 둘째 — parallel 실행
4. 셋째 — matrix 다중 환경
5. 넷째 — Docker layer 캐싱
6. 다섯째 — hash (lock file)
7. 자경단 매일 운영 의식
8. 다섯 함정과 처방
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요.

지난 H5 회수. Makefile, Dockerfile, CI 100% 자동.

이번 H6은 운영 5 최적화.

오늘의 약속. **본인의 CI 시간이 5분에서 1분으로 줄어듭니다**.

자, 가요.

---

## 2. 첫째 — 캐시 (pip, GitHub Actions)

**pip 캐시**.

```bash
pip install --cache-dir ~/.cache/pip requests
# 두 번째부터 빠름
```

**GitHub Actions cache**.

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

CI 두 번째부터 5분 → 1분. 자경단 표준.

---

## 3. 둘째 — parallel 실행

**pytest-xdist**.

```bash
pip install pytest-xdist
pytest -n 4   # 4 코어 동시
```

100 테스트가 30초 → 8초.

**Makefile parallel**.

```makefile
test-parallel:
	pytest -n auto
```

자경단 매일.

---

## 4. 셋째 — matrix 다중 환경

GitHub Actions matrix로 여러 환경 동시.

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    python-version: ["3.10", "3.11", "3.12"]
```

3 OS × 3 Python = 9 환경 동시. 5분 안에.

자경단 — Python 3 버전 매트릭스 표준.

---

## 5. 넷째 — Docker layer 캐싱

```dockerfile
FROM python:3.12-slim

WORKDIR /app

# Layer 1: requirements (자주 안 변함)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Layer 2: 코드 (자주 변함)
COPY . .
```

requirements 안 변하면 Layer 1 캐싱. 빌드 5분 → 30초.

자경단 표준.

---

## 6. 다섯째 — hash (lock file)

requirements.txt에 hash 박기.

```bash
pip-compile --generate-hashes requirements.in
```

```
requests==2.31.0 \
    --hash=sha256:8badf17c...
```

CI에서 `pip install --require-hashes -r requirements.txt`. 변조 면역.

자경단 production 표준.

---

## 7. 자경단 매일 운영 의식

**1. CI 느림** → cache 점검

**2. 테스트 느림** → pytest-xdist

**3. 다중 환경** → matrix

**4. Docker 빌드 느림** → layer 정리

**5. 보안** → hash + safety

다섯.

---

## 8. 다섯 함정과 처방

**함정 1: cache key 잘못**

처방. hashFiles로 변경 시 invalidate.

**함정 2: parallel 깨짐 (공유 상태)**

처방. fixture isolation.

**함정 3: matrix 너무 많음**

처방. 필요한 조합만.

**함정 4: Docker layer 자주 변경**

처방. requirements 먼저 COPY.

**함정 5: hash 미스매치**

처방. lock 다시 생성.

---

## 9. 흔한 오해 다섯 가지

**오해 1: 최적화는 시니어.**

신입도 cache.

**오해 2: parallel 항상 좋다.**

I/O bound는 효과.

**오해 3: matrix 무료 무한.**

GitHub 한도.

**오해 4: layer 자동.**

설계 필요.

**오해 5: hash production만.**

dev도 권장.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. cache 만료?**

GitHub 7일 안 사용 시.

**Q2. pytest-xdist random?**

순서 무관 테스트만.

**Q3. matrix 어디까지?**

현실적인 조합.

**Q4. multi-stage Docker?**

build + runtime 분리.

**Q5. hash 만들기?**

pip-compile --generate-hashes.

---

## 11. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, cache key 무지. 안심 — hashFiles로 자동.
둘째, parallel 모든 곳. 안심 — I/O bound에만.
셋째, matrix 너무 많음. 안심 — 필요한 조합만.
넷째, Docker layer 무지. 안심 — requirements 먼저.
다섯째, 가장 큰 — hash production만. 안심 — dev도 권장.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 여섯 번째 시간 끝.

캐시, parallel, matrix, layer, hash 5 최적화.

다음 H7은 깊이.

```bash
pytest -n auto -v
```

---

## 👨‍💻 개발자 노트

> - GitHub Actions cache: 7일 미사용 만료.
> - pytest-xdist: 다중 워커.
> - Docker BuildKit: 모던 빌드.
> - hash 알고리즘: sha256 표준.
> - lock file 종류: requirements.txt, poetry.lock, Pipfile.lock.
> - 다음 H7 키워드: venv 내부 · pip resolver · sys.prefix · activate script.
