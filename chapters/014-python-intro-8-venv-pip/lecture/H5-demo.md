# Ch014 · H5 — 자경단 dev 환경 100% 자동 — Makefile + Dockerfile + CI

> 고양이 자경단 · Ch 014 · 5교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 시나리오 — 100% 자동 dev 환경
3. 0~5분 — 폴더 구조
4. 5~10분 — Makefile
5. 10~15분 — Dockerfile
6. 15~20분 — docker-compose
7. 20~25분 — GitHub Actions CI
8. 25~30분 — 실행과 검증
9. 다섯 사고와 처방
10. 흔한 오해 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요.

지난 H4 회수. 30+ CLI 도구.

이번 H5는 100% 자동 dev 환경 구축.

오늘의 약속. **본인의 프로젝트가 한 줄로 셋업·테스트·배포 가능합니다**.

자, 가요.

---

## 2. 시나리오 — 100% 자동 dev 환경

자경단의 모든 프로젝트가 같은 표준. 본인이 새 프로젝트 받으면 한 줄로 시작.

`make setup && make test`. 끝.

CI도 자동. PR 만들면 자동 검증.

---

## 3. 0~5분 — 폴더 구조

```
vigilante/
├── Makefile
├── Dockerfile
├── docker-compose.yml
├── pyproject.toml
├── requirements.txt
├── requirements-dev.txt
├── .github/
│   └── workflows/
│       └── ci.yml
└── vigilante/
    └── ...
```

자경단 표준 8 파일.

---

## 4. 5~10분 — Makefile

```makefile
.PHONY: setup test format lint run clean

setup:
	python3 -m venv .venv
	. .venv/bin/activate && pip install -e ".[dev]"

test:
	. .venv/bin/activate && pytest -v --cov

format:
	. .venv/bin/activate && black . && ruff format .

lint:
	. .venv/bin/activate && ruff check . && mypy --strict .

run:
	. .venv/bin/activate && python3 -m vigilante.cli

clean:
	rm -rf .venv build dist *.egg-info __pycache__ .pytest_cache .mypy_cache

check: format lint test
	@echo "✅ 모두 통과"

ci: check
	@echo "🚀 CI 통과"
```

`make check`로 전체 검증. 자경단 매일.

---

## 5. 10~15분 — Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

# 의존성 먼저 (캐싱)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 코드
COPY . .
RUN pip install --no-cache-dir -e .

# 비루트 사용자
RUN useradd --create-home appuser
USER appuser

CMD ["python3", "-m", "vigilante.cli"]
```

multi-stage 빌드와 layer 캐싱. 자경단 표준.

---

## 6. 15~20분 — docker-compose

```yaml
# docker-compose.yml
version: "3.9"

services:
  app:
    build: .
    volumes:
      - .:/app
    environment:
      - PYTHONDONTWRITEBYTECODE=1
      - PYTHONUNBUFFERED=1
    ports:
      - "8000:8000"

  db:
    image: postgres:16
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

```bash
docker-compose up      # 시작
docker-compose down    # 정지
docker-compose logs    # 로그
```

dev 환경 한 줄.

---

## 7. 20~25분 — GitHub Actions CI

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: pip
      
      - name: Install dependencies
        run: |
          pip install -e ".[dev]"
      
      - name: Lint
        run: |
          ruff check .
          mypy --strict .
      
      - name: Format check
        run: |
          black --check .
      
      - name: Test
        run: |
          pytest -v --cov --cov-report=xml
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

3 Python 버전 동시 테스트. 자경단 표준.

---

## 8. 25~30분 — 실행과 검증

local에서.

```bash
$ make setup
✅ venv 생성, 의존성 설치 완료

$ make check
black . ; ruff check . ; pytest -v
✅ 모두 통과
```

Docker.

```bash
$ docker-compose up --build
✅ 컨테이너 실행
```

PR 만들면 GitHub Actions가 3 Python 버전 동시 검증. 통과해야 머지.

100% 자동 dev 환경 작동.

---

## 9. 다섯 사고와 처방

**사고 1: Makefile tab vs space**

처방. tab 사용.

**사고 2: Dockerfile 캐싱 깨짐**

처방. requirements.txt 먼저 COPY.

**사고 3: docker-compose volume 권한**

처방. user 매핑.

**사고 4: CI 시간 길다**

처방. cache + matrix 줄이기.

**사고 5: 다중 Python 충돌**

처방. tox.ini 또는 nox.

---

## 10. 흔한 오해 다섯 가지

**오해 1: Makefile은 옛 도구.**

자경단 표준.

**오해 2: Docker dev 무거움.**

production parity 가치.

**오해 3: CI 매번.**

PR마다 자동.

**오해 4: matrix 부담.**

GitHub Actions 무료.

**오해 5: 한 OS만.**

ubuntu, macos, windows 매트릭스.

---

## 11. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, Makefile tab vs space. 안심 — tab 표준.
둘째, Dockerfile 캐시 깨짐. 안심 — requirements 먼저 COPY.
셋째, docker-compose 무거움. 안심 — production parity 가치.
넷째, CI matrix 부담. 안심 — GHA 무료.
다섯째, 가장 큰 — 자동화 시니어. 안심 — `make check` 한 줄.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 다섯 번째 시간 끝.

Makefile, Dockerfile, docker-compose, GitHub Actions. 100% 자동.

다음 H6은 5 최적화.

```bash
make setup
make check
```

---

## 👨‍💻 개발자 노트

> - Makefile: GNU Make. tab indented.
> - Dockerfile: multi-stage, layer cache.
> - docker-compose: services 정의.
> - GitHub Actions: matrix, cache, secrets.
> - codecov: coverage 시각화.
> - 다음 H6 키워드: 캐시 · parallel · matrix · layer · hash.
