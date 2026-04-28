# Ch007 · H8 — Python 입문 1: 적용+회고 — 7H 종합·환율 계산기 진화·다섯 원리·Ch008 예고

> **이 H에서 얻을 것**
> - Ch007 7개 H 한 페이지 종합표
> - 환율 계산기 50줄 → API 진화 5단계 로드맵
> - Python 다섯 원리 (인터프리터·동적 타입·자료형·GIL·PEP)
> - 12회수 지도 (Ch008부터 평생 회수)
> - Ch008 예고 (제어 흐름 — if·for·comprehension)
> - 우선순위 Must/Should/Could 15개

---

## 회수: H1~H7의 8시간 큰 그림

8시간 자경단 Python 입문 여정:
- **H1 오리엔** — 7이유·4단어(인터프리터·변수·자료형·연산자)·8H 큰그림
- **H2 핵심개념** — 5 자료형(int·float·str·bool·None) + 18 연산자 + f-string
- **H3 환경점검** — brew·pyenv·REPL·Jupyter·VS Code·5 dotfile·30분 셋업
- **H4 명령어카탈로그** — 18 도구 (인터프리터 6·패키지 5·가상환경 3·품질 3·테스트 1)
- **H5 데모** — 환율 계산기 50줄 자경단 5명 매월 사료 예산 345,125 KRW
- **H6 운영** — PEP 8·black·ruff·docstring·type hint·pre-commit·CI 7 도구
- **H7 원리** — CPython VM·GIL·dis·PEP 진화·메모리 관리

7시간 학습 + 본 H 1시간 회고 = 8시간 = 자경단 Python 입문 완료.

---

## 1. Ch007 7H 한 페이지 종합표

| H | 슬롯 | 핵심 산출물 | 자경단 적용 |
|---|------|-----------|------------|
| H1 | 오리엔 | 4단어 + 8H 지도 | 매일 |
| H2 | 핵심개념 | 5자료형 + 18연산자 표 | 매 줄 |
| H3 | 환경점검 | 30분 셋업 9도구 | 1회 |
| H4 | 명령카탈로그 | 18도구 + 13줄 흐름 | 매일 |
| H5 | 데모 | exchange.py 50줄 | 매월 사료 |
| H6 | 운영 | 7 품질 도구 + pre-commit | 매 commit |
| H7 | 원리 | VM·GIL·dis·PEP·메모리 | 1년 후 시니어 |

7H × 1H = 8H Python 입문 1 완료. 자경단 5명 매일 25 적용.

### 1-1. Ch007의 진짜 메시지

**Python은 도구가 아니라 사고방식이에요.**

자경단 5명 — Python으로 백엔드(까미)·도구(노랭이)·인프라 스크립트(미니)·테스트(깜장이)·메인테이너(본인) 모두. 5명 같은 언어 = 합의 비용 0.

Python 1주일이면 첫 50줄. 1개월이면 첫 API. 6개월이면 첫 production. 1년이면 시니어. 5년이면 평생 자산.

---

## 2. 환율 계산기 50줄 → API 진화 5단계 로드맵

### 2-1. 1주차 — 50줄 함수 (H5 완료)

```python
RATES = {"USD": 1380.50, "JPY": 9.10, "EUR": 1495.30}

def convert(amount_krw: float, currency: str) -> float:
    return amount_krw / RATES[currency]
```

50줄 + REPL 실행. 자경단 5명 매월 사료 예산 계산.

### 2-2. 1개월 — requests로 실시간 API

```python
import requests

def get_rates() -> dict[str, float]:
    """ExchangeRate-API에서 실시간 환율 가져오기."""
    resp = requests.get("https://api.exchangerate-api.com/v4/latest/KRW")
    resp.raise_for_status()
    return resp.json()["rates"]

def convert(amount_krw: float, currency: str) -> float:
    rates = get_rates()
    if currency not in rates:
        raise ValueError(f"지원 안 함: {currency}")
    return amount_krw * rates[currency]
```

100줄 + 외부 API + 에러 처리. 매주 환율 갱신.

### 2-3. 3개월 — class + 영속화

```python
from dataclasses import dataclass, field
from datetime import datetime
import json

@dataclass
class ExchangeService:
    cache_file: str = "rates.json"
    rates: dict[str, float] = field(default_factory=dict)
    last_update: datetime | None = None
    
    def load(self) -> None:
        with open(self.cache_file) as f:
            data = json.load(f)
            self.rates = data["rates"]
            self.last_update = datetime.fromisoformat(data["timestamp"])
    
    def refresh(self) -> None:
        # API 호출 + cache 갱신
        pass
    
    def convert(self, amount_krw: float, currency: str) -> float:
        if (datetime.now() - self.last_update).hours > 24:
            self.refresh()
        return amount_krw * self.rates[currency]
```

300줄 + class + 영속화 + 24시간 cache. 자경단 매일 사용.

### 2-4. 6개월 — FastAPI 서비스

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()
service = ExchangeService()

class ConvertRequest(BaseModel):
    amount_krw: float
    currency: str

@app.post("/convert")
async def convert(req: ConvertRequest) -> dict:
    result = service.convert(req.amount_krw, req.currency)
    return {"krw": req.amount_krw, "currency": req.currency, "result": result}
```

500줄 + REST API + Pydantic + async. localhost:8000에서 자경단 5명 동시 사용.

### 2-5. 1년 — production SaaS

- PostgreSQL (rate history)
- Redis (cache)
- Celery (매일 환율 갱신 task)
- Docker (배포)
- AWS ECS (스케일)
- Sentry (모니터링)
- 고양이 자경단 외부 사용자 100명+

5,000줄 + 8개 서비스 + production. 1년 ROI 100배.

### 2-6. 5단계 시간·LOC 표

| 단계 | 시기 | LOC | 사용자 |
|------|------|-----|--------|
| 함수 | 1주 | 50 | 본인 |
| API 사용 | 1개월 | 100 | 5명 |
| class+cache | 3개월 | 300 | 5명 매일 |
| FastAPI | 6개월 | 500 | 자경단 |
| Production | 1년 | 5,000 | 100명+ |

50→5,000 LOC 100배 = 1년 진화. 자경단 첫 코드의 진짜 ROI.

### 2-7. 진화 단계별 학습 챕터 매핑

| 단계 | 학습 챕터 | 주요 도구 |
|------|---------|----------|
| 1주 함수 | Ch007·H5 | def·dict·type hint |
| 1개월 API | Ch013·H1 | requests·exception |
| 3개월 class | Ch017·H2 | dataclass·json |
| 6개월 FastAPI | Ch041·H1 | FastAPI·Pydantic·async |
| 1년 production | Ch091~103 | AWS·CI/CD·Docker |

Ch007 → Ch103 = 1년 학습 로드맵. 본 H가 시작점.

### 2-8. 진화 시 5명 자경단 협업 변화

```
1주 (50줄): 본인 단독 작성
1개월 (100줄): 까미가 PR 1건 (에러 처리 추가)
3개월 (300줄): 까미·노랭이 동시 개발 (5 PR/주)
6개월 (500줄): FastAPI 5명 협업 (10 PR/주)
1년 (5,000줄): 5명 코드 owner 분담 (50 PR/주)
```

5명 협업 진화 = 자경단 코드의 진짜 의미.

---

## 3. Python 다섯 원리 한 페이지

### 원리 1: 인터프리터 — REPL이 평생 친구

REPL 한 줄 즉시 실행이 Python의 핵심 가치. 자경단 매일 `python3 -i` 또는 `ipython`. 5초에 의문 해결.

### 원리 2: 동적 타입 + 점진 type hint

Python은 동적 타입 (런타임 타입 결정). 단점 — 런타임 에러. 처방 — type hint + mypy 정적 검사. **점진 적용**이 자경단 표준 (1주차 0% → 1년 100%).

### 원리 3: 자료형은 한 페이지

5 기본 자료형 (int·float·str·bool·None) + 5 컨테이너 (list·tuple·dict·set·frozenset). 모든 Python 코드의 95%가 이 10개. 한 페이지로 평생.

### 원리 4: GIL은 우회 — multiprocessing·asyncio·C 확장

GIL이 CPU 1코어 한계. 우회 3 — multiprocessing(CPU)·asyncio(I/O)·numpy(C 확장). 자경단 매일.

### 원리 5: PEP가 자경단 평생 학습

700+ PEP 중 매일 10 (8·257·484·526·585·604·612·695·703·744). 매월 1 PEP 학습 = 60개월 = 5년 마스터.

### 5 원리 통합

5 원리 = Python의 모든 것. **인터프리터의 즉시성·동적 타입의 자유·자료형 단순함·GIL 우회·PEP 진화** 다섯이 자경단 1년 후 시니어의 5 stack.

---

## 4. 12회수 지도 — Ch007부터 Ch120까지

| 회수 챕터 | 회수 내용 | 시기 |
|----------|---------|------|
| Ch008 | 제어 흐름 — if/for/while/comprehension | 다음 |
| Ch013 | 모듈/패키지 — import·sys.path | 6주 후 |
| Ch014 | venv·가상환경 깊이 | 7주 후 |
| Ch020 | type hint·typing·mypy strict | 13주 후 |
| Ch022 | pytest·테스트 자동화 | 15주 후 |
| Ch041 | FastAPI 백엔드 | 34주 후 |
| Ch060 | 풀스택 통합 | 53주 후 |
| Ch080 | ML/AI Python | 73주 후 |
| Ch091 | AWS boto3·인프라 자동화 | 84주 후 |
| Ch103 | CI/CD 파이프라인 | 96주 후 |
| Ch118 | 면접 — Python 5질문 | 111주 후 |
| Ch120 | 1년 회고 + 자경단 진화 | 113주 후 |

12회수 = 자경단 본 H의 18 도구 + 5 자료형 + 18 연산자가 평생 등장.

---

## 5. Ch008 예고 — 제어 흐름

### 5-1. Ch008 8H 큰그림

- **H1 오리엔** — 제어 흐름 7이유·4단어(if·for·while·comprehension)
- **H2 핵심개념** — if/elif/else·for·while·break/continue/else·match-case
- **H3 환경점검** — VS Code 디버거·breakpoint()·pdb
- **H4 명령카탈로그** — for+enumerate·zip·range·comprehension 4종 (list·dict·set·gen)
- **H5 데모** — 자경단 환율 계산기 + 분기·반복 추가
- **H6 운영** — early return·guard clause·복잡도 줄이기 5 패턴
- **H7 원리** — for의 iterator protocol·generator·yield from
- **H8 적용+회고** — Ch008 마무리

다음 8시간 = 제어 흐름 마스터.

### 5-2. Ch008의 한 줄 약속

**"Python 코드의 60%가 if + for. 두 도구로 모든 로직."**

자경단 매일 if + for 1000+ 줄. 두 도구가 Python의 두 다리.

### 5-3. Ch008 → Ch020 사이 12 챕터 미리보기

| 챕터 | 주제 | 자경단 자산 |
|------|------|-----------|
| Ch008 | 제어 흐름 | if·for·comprehension |
| Ch009 | 함수 깊이 | def·*args·**kwargs·decorator |
| Ch010 | 모듈 시스템 | import·sys.path·__init__.py |
| Ch011 | 패키지 + venv | pip·requirements.txt·pyproject.toml |
| Ch012 | 예외 처리 | try/except/finally·raise·custom |
| Ch013 | 파일 I/O | open·with·json·csv·yaml |
| Ch014 | 표준 라이브러리 | os·sys·datetime·collections |
| Ch015 | OOP 기초 | class·self·__init__·상속 |
| Ch016 | OOP 고급 | dataclass·property·dunder |
| Ch017 | 함수형 | map·filter·reduce·lambda·closure |
| Ch018 | 이터레이터·제너레이터 | yield·next·iter |
| Ch019 | context manager | with·__enter__·__exit__·contextlib |
| Ch020 | type hint 깊이 | typing·mypy strict·Generic·Protocol |

13 챕터 × 8H = 104시간 = 자경단 Python 마스터 큰 줄기.

---

## 6. 우선순위 — Must/Should/Could 15개

### Must 5 (1주차 무조건)

1. brew install python@3.12 + pyenv (H3)
2. REPL `python3 -i` 매일 30분 (H1)
3. 5 자료형 + 18 연산자 한 페이지 외움 (H2)
4. exchange.py 50줄 직접 작성 (H5)
5. pre-commit + black + ruff (H6)

### Should 5 (1개월 권장)

6. type hint 6 패턴 (H6)
7. dataclass + Pydantic (H2 확장)
8. requests + httpx (H6 확장)
9. pytest 5 옵션 (H4)
10. mypy strict 1단계 (H6)

### Could 5 (1년 후 검토)

11. asyncio + FastAPI (H7)
12. multiprocessing 데이터 처리 (H7)
13. dis·tracemalloc 디버깅 (H7)
14. CPython 소스 5 디렉토리 (H7)
15. PyPy·uv·poetry 모던 도구 (H4)

15 우선순위 × 자경단 진화 = 5년 마스터.

---

### 6-1. 우선순위 도구별 학습 시간

| 우선순위 | 학습 시간 | 자경단 ROI |
|---------|---------|-----------|
| Must 5 | 5시간 | 매일 5년 |
| Should 5 | 30시간 | 매주 5년 |
| Could 5 | 100시간 | 매월 5년 |

5+30+100 = 135시간 1년 학습 = 자경단 Python 시니어. 시간 ROI 100배.

### 6-2. Must 5의 진짜 의미

Must 5가 자경단의 평생 5 손가락. 1주차 5시간 학습 = 5년 매일 사용. 시간 가치 8,760배 (1년 365일 × 24시간 / 5시간).

본인이 1년 차에 본 것 — Must 5 아닌 도구는 거의 사용 안 함. 자경단 코드 90%가 Must 5 안에서.

---

## 7. 시간축 — 0분에서 5년

| 시점 | 자경단 본인 |
|------|-----------|
| 0분 | 본 H 끝, exchange.py 50줄 작성됨 |
| 30분 | brew + pyenv 셋업 |
| 1시간 | REPL 첫 실험 5종 |
| 1주 | exchange.py 100줄 + requests |
| 1개월 | class + cache + 5 PR |
| 3개월 | FastAPI 서비스 + production |
| 6개월 | type hint 100% + mypy strict |
| 1년 | Python 시니어 + 면접 7질문 정답 |
| 3년 | 자경단 메인테이너 + 신입 멘토 |
| 5년 | 평생 Python + AI 시대 도구화 |

5년 시간축 = 본 H의 50줄에서 시작.

### 7-1. 자경단의 1년 후 본인 편지

> 1년 후 본인에게 — 본 H의 50줄을 다시 보세요. exchange.py가 5,000줄이 되었고, 자경단 5명 중 본인이 메인테이너. 본 H의 5 자료형이 매 줄, 18 연산자가 매 줄, 7 운영 도구가 매 commit. 본 H가 평생.
> 
> Python 8H 입문이 1년 5,000줄 production이 되었고, 5년 후 평생 자산이 되었습니다.

본 H의 진짜 가치는 1년 후 본인의 편지에 있어요.

### 7-2. 자경단 1주차 매일 시간표

| 일 | 시간 | 내용 |
|----|------|------|
| 월 | 30분 | brew + pyenv 셋업 (H3) |
| 화 | 30분 | REPL 첫 실험 (H1) |
| 수 | 1시간 | 5 자료형 + 18 연산자 (H2) |
| 목 | 1시간 | exchange.py 50줄 작성 (H5) |
| 금 | 1시간 | pre-commit + black + ruff (H6) |
| 토일 | 2시간 | 첫 PR + 5명 review |

5일 + 주말 = 6시간 = 자경단 첫 주 Python 마스터.

---

## 8. 비용표 — 첫 1년 $0~$36

| 항목 | 비용 | 비고 |
|------|------|------|
| Python 인터프리터 | $0 | 오픈소스 |
| pyenv·venv | $0 | 표준 |
| black·ruff·mypy | $0 | 오픈소스 |
| pytest | $0 | 오픈소스 |
| VS Code + Pylance | $0 | Microsoft 무료 |
| Cursor | $0~$20/월 | 옵션 |
| GitHub Copilot | $0~$10/월 | 학생 무료 |
| ExchangeRate-API | $0~$10/월 | 무료 1500/월 |
| AWS (1년) | $0 | Free Tier |
| Sentry (소형) | $0 | Free Tier |

자경단 첫 1년 = $0 (필수 only). 옵션 5개 합 $40/월. 5명 = $200/월. 5년 후 자산 100배.

---

### 8-1. 비용표의 진짜 의미 — 자경단 첫 1년 $0

자경단의 진짜 자랑 — Python 학습 첫 1년 $0. 모든 필수 도구 무료 + 오픈소스. 5년 5명 누적 $0~$2,000 (옵션 only) = 자경단 평생 자산 ROI 무한대.

비교 — Java 1년 IDEA Ultimate $499 + JetBrains All Pack $649 = $1,148. C# Visual Studio Pro $1,200/년. Swift Mac $1,500.

Python = 모든 환경 $0. AI 시대 가성비 1위.

### 8-2. 시간 비용 vs 도구 비용

자경단 1년 — 도구 비용 $0 + 시간 비용 135시간 (Must+Should+Could) = $0 + 135h × $50/h = $6,750. 도구 절약 가치 = $1,200/년 × 5년 = $6,000.

자경단 5명 = $30,000 5년 절약. **Python 선택의 진짜 ROI**.

---

## 9. 면접 정리 — Python 7질문 (Ch007 종합)

**Q1. Python이 왜 인기?**
A. 가독성·다용도·생태계·AI 시대.

**Q2. 변수에 type 안 쓰는데 왜?**
A. 동적 타입. type hint은 정적 검사 (mypy).

**Q3. list vs tuple?**
A. list mutable·tuple immutable. tuple이 작고 빠름.

**Q4. dict 순서 보장?**
A. Python 3.7+ 보장 (PEP 468).

**Q5. == vs is?**
A. == 값·is 객체. None은 `is None`.

**Q6. f-string vs format?**
A. f-string 표준. 3 명령어·format 6 명령어.

**Q7. GIL이 무엇?**
A. 1 thread만 bytecode. CPU 1코어. I/O는 해제. multiprocessing 우회.

7 질문 = Ch007 종합 면접 단골.

### 9-1. 면접 5 추가 질문 (자경단 1년 후)

**Q8. Python에서 메모리 누수 추적 방법?**
A. tracemalloc 표준. start + take_snapshot + statistics. lru_cache·weakref 처방.

**Q9. dict의 시간 복잡도?**
A. O(1) lookup·insert·delete (평균). 충돌 시 worst O(n). open addressing + Robin Hood (3.6+).

**Q10. list comprehension vs map?**
A. list comp 빠름·가독성. map은 함수 인자만 (lambda 사용 시 list comp가 표준).

**Q11. **kwargs vs **dict 차이?**
A. **kwargs는 함수 정의·호출 양식. dict 풀어 인자로. 같은 dict.

**Q12. async 함수 안에서 동기 함수 호출?**
A. `asyncio.to_thread(sync_func)` 또는 `loop.run_in_executor`. CPU 집약은 ProcessPoolExecutor.

5+7 = 12 질문 = 자경단 1년 후 면접 마스터.

---

## 10. 자경단 5명 1년 회고

### 본인 (메인테이너) 1년

- exchange.py 50줄 → 자경단 internal API 5,000줄
- type hint 100% + mypy strict
- PR 100건 review + 7건 본인
- Python 면접 5회 합격

### 까미 (백엔드) 1년

- FastAPI 서비스 5개 + Pydantic 100% type
- pytest coverage 90%
- Production traffic 100 RPS
- asyncio 마스터

### 노랭이 (프론트) 1년

- Python 도구 20% + TypeScript 80%
- black + ruff Python 도구 표준
- API 클라이언트 자동 생성 (openapi-python-client)
- 풀스택 진화

### 미니 (인프라) 1년

- Python script 30개 + boto3·terraform
- AWS Lambda 5개 + CloudWatch
- 새벽 3시 0회 (자동화)
- 인프라 시니어

### 깜장이 (QA) 1년

- pytest + playwright 100% 자동
- mypy strict + ruff 0 에러
- 5명 PR 1차 review
- QA → SET (Software Engineer in Test)

5명 1년 = 자경단 Python의 진짜 ROI.

### 10-1. 자경단 5명 코드 라인 1년 누적

| 멤버 | 1주 | 1개월 | 6개월 | 1년 |
|------|-----|------|------|-----|
| 본인 | 50 | 200 | 2,000 | 10,000 |
| 까미 | 100 | 500 | 5,000 | 20,000 |
| 노랭이 | 50 (py) | 200 | 1,000 | 3,000 |
| 미니 | 100 | 400 | 3,000 | 8,000 |
| 깜장이 | 50 | 300 | 2,000 | 5,000 |
| **합계** | **350** | **1,600** | **13,000** | **46,000** |

자경단 1년 합 46,000 Python 줄 = 본 H의 50줄에서 시작.

### 10-2. 자경단 5명의 5년 후

5년 후 자경단:
- 본인 — Python·React 풀스택 시니어, 메인테이너, 외부 컨퍼런스 발표
- 까미 — FastAPI·DB 백엔드 시니어, asyncio 마스터, OSS contributor
- 노랭이 — TypeScript·Python 풀스택, openapi codegen 마스터
- 미니 — AWS·Terraform·Python 인프라 시니어, 자동화 전문가
- 깜장이 — pytest·playwright SET (Software Engineer in Test) 시니어

5년 = 5명 모두 시니어 = 본 H의 50줄에서 시작한 평생 자산.

---

## 11. 흔한 오해 7가지 (Ch007 종합)

**오해 1: "Python은 입문 언어."** — Google·Meta·Netflix·Instagram production. 입문이 평생.

**오해 2: "Python 느려서 production 못 씀."** — async + 캐시 + DB로 99% 워크로드. 진짜 병목은 DB.

**오해 3: "type hint은 시니어 일."** — 1주차부터 적용. 미래 본인에게 친절.

**오해 4: "REPL은 학습용만."** — 1년 차 본인도 매일. 의문 5초 해결.

**오해 5: "Jupyter는 데이터과학자만."** — 자경단 매일 시각화·분석·문서화.

**오해 6: "PEP 8 외워야."** — black + ruff 자동. 외울 필요 X.

**오해 7: "GIL이 Python의 죽음."** — 90% I/O는 영향 X. CPU는 multiprocessing.

**오해 8: "AI 시대 Python 수요 줄 것."** — 정반대. AI 도구 80%가 Python 생성·실행. AI 시대 가장 안전한 언어.

**오해 9: "Python 코드는 짧아서 안전."** — 짧다고 안전 X. type hint + mypy + pytest 90% coverage 필요.

**오해 10: "한 번 배우면 끝."** — 매년 새 PEP 5+. 자경단 매월 1 PEP 학습 = 평생.

---

## 12. FAQ 7가지 (Ch007 종합)

**Q1. Python 2 vs 3?**
A. Python 2 EOL 2020. 자경단 무조건 Python 3.12+.

**Q2. brew vs pyenv vs uv?**
A. brew (간단·시스템) · pyenv (다중 버전) · uv (2024 새 표준·10배 빠름). 자경단 brew + pyenv. 1년 후 uv 검토.

**Q3. venv vs poetry vs uv?**
A. venv 표준. poetry 의존성 관리. uv 통합 (2024). 자경단 — venv + pip + pyproject.toml. 1년 후 uv.

**Q4. black vs ruff format?**
A. black 표준. ruff format 호환 + 100배. 자경단 — black 현재, 1년 후 ruff format 검토.

**Q5. type hint 학습 곡선?**
A. 6 패턴 1주일. Generic·Protocol 1개월. mypy strict 1년.

**Q6. async vs sync 어떻게 결정?**
A. I/O 집약 (HTTP·DB·파일) → async. CPU 집약 → sync + multiprocessing. 자경단 FastAPI 100% async.

**Q7. AI 시대 Python 학습 의미?**
A. 더 중요. AI 도구 (Claude·Cursor·Copilot)도 Python 코드 가장 잘 생성. 1주일 학습 = 평생 자산.

**Q8. Python vs JavaScript/TypeScript?**
A. 자경단 — 둘 다. Python 백엔드·도구. JS 프론트엔드. 자경단 5년 후 모두 풀스택.

**Q9. Python vs Go?**
A. Python 가독성·생태계. Go 성능·동시성. 자경단 — Python 95% + Go 5% (특수 워크로드).

**Q10. 신입이 Python으로 시작 추천?**
A. 강력 추천. 1주일 첫 코드·1년 production·5년 시니어. 가독성·생태계·AI 시대 모두 1위.

---

## 13. 자경단 Ch007 한 줄 평

본인의 Ch007 한 줄: **"Python은 자경단 5명의 공통 언어, 5 자료형 + 18 연산자가 평생, 운영 7 도구가 매일, 원리 5 개념이 시니어."**

8시간 학습 → 1년 5,000줄 → 5년 평생 자산.

### 13-1. 자경단 5명 각자의 한 줄

- **본인 (메인테이너)**: "Python으로 5명 합의 비용 0. 같은 언어가 평생 자산."
- **까미 (백엔드)**: "FastAPI + Pydantic + asyncio가 매일. 1년 후 production 시니어."
- **노랭이 (프론트)**: "Python 도구 20%가 풀스택의 시작. TypeScript와 짝."
- **미니 (인프라)**: "boto3 + Lambda Python script. 새벽 3시 0회 자동화."
- **깜장이 (QA)**: "pytest + playwright Python. 1년 후 SET 시니어."

5 한 줄 = 자경단 5명의 Python 의미. 본 H가 평생.

### 13-2. 본인의 본 H 직후 첫 행동

본 H 끝나자마자 본인이 할 5 행동:
1. `pip install black ruff mypy pytest pre-commit` (5분)
2. `~/.zshrc`에 alias `py='python3'` `pyi='ipython'` 추가 (1분)
3. `mkdir cat-vigilante && cd cat-vigilante && python3 -m venv .venv` (2분)
4. exchange.py 50줄 직접 타이핑 (10분)
5. `python exchange.py` 실행 결과 보기 (1분)

19분 = 자경단 본인의 첫 Python 환경 + 첫 코드 + 첫 실행. 본 H의 진짜 끝.

---

## 13-3. Ch007 한 페이지 요약 카드

```
[ Ch007 — Python 입문 1 ]

4단어: 인터프리터·변수·자료형·연산자
5자료형: int·float·str·bool·None
18연산자: 산술7·비교6·논리3·할당8·멤버십2
9도구: brew·pyenv·python3·pip·venv·black·ruff·mypy·pytest
7운영: PEP 8·black·ruff·docstring·type hint·pre-commit·CI
5원리: VM·동적타입·자료형·GIL·PEP

자경단 5명 매일 25 도구. 1년 후 시니어. 5년 평생.
```

이 카드 한 장 = Ch007 8H 종합. 자경단 책상 위 평생.

---

## 14. 추신

추신 1. 본 H가 Ch007의 마무리. 8H Python 입문 1 완료. 자경단 5명 같은 언어.

추신 2. 환율 계산기 50줄이 1년 후 5,000줄 production SaaS. 100배 진화.

추신 3. Python 다섯 원리 (인터프리터·동적 타입·자료형·GIL·PEP)가 1년 후 시니어의 5 stack.

추신 4. 12회수 지도 — Ch008부터 Ch120까지 본 Ch007의 자료형이 평생.

추신 5. Ch008 예고 — 제어 흐름 if·for·comprehension. Python 코드 60%.

추신 6. Must 5 (brew·REPL·자료형·exchange.py·pre-commit) = 1주차 무조건.

추신 7. Should 5 (type hint·dataclass·requests·pytest·mypy 1단계) = 1개월.

추신 8. Could 5 (asyncio·multiprocessing·dis·CPython·uv) = 1년 후.

추신 9. 시간축 0분 → 5년 — 본 H 50줄에서 평생까지.

추신 10. 비용표 첫 1년 $0 (필수). 옵션 $40/월. 5년 ROI 100배.

추신 11. 자경단 5명 1년 회고 — 본인·까미·노랭이·미니·깜장이 5명 모두 Python 시니어.

추신 12. Ch007 7질문 면접 정답. 자경단 1년 후 본인이 본 면접 7회 누적.

추신 13. 흔한 오해 7 면역 (입문언어·느림·type hint·REPL·Jupyter·PEP 8·GIL).

추신 14. FAQ 7 (2vs3·brew/pyenv/uv·venv/poetry·black/ruff·type 학습·async·AI 시대).

추신 15. Python 1주일 첫 50줄 → 1개월 첫 API → 6개월 첫 production → 1년 시니어 → 5년 평생.

추신 16. 자경단 5명 같은 Python = 합의 비용 0. 1년 후 25 도구 매일.

추신 17. 본 H의 진짜 결론 — Python 입문은 8시간이고, 진화는 1년이며, 평생은 5년이에요. 자경단 5명 같은 사고방식 + 같은 도구 + 같은 5 자료형이 평생.

추신 18. exchange.py 50줄이 본인의 첫 Python. 평생 기념. 1년 후 한 번 다시 보세요.

추신 19. REPL 매일 30분이 자경단 1년 후 본인의 평생 친구.

추신 20. type hint이 미래 본인에게 친절. 6개월 후 본인이 감사.

추신 21. PEP 8이 5명 합의 비용 0. 외울 필요 없는 자동화.

추신 22. black + ruff + mypy + pytest 4 도구가 자경단 매 commit.

추신 23. pre-commit + CI 두 단계가 자경단 코드 품질 100%.

추신 24. CPython VM 5단계가 본인의 매 `python script.py`.

추신 25. GIL의 90% I/O는 asyncio·10% CPU는 multiprocessing.

추신 26. dis 모듈로 30초 내부 확인. 자경단 의심 코드 의식.

추신 27. PEP 진화 30년 700+ 중 매일 10 PEP. 매월 1 PEP 학습.

추신 28. 메모리 5 함정 면역이 1년 OOM 무사고.

추신 29. tracemalloc 30분이 메모리 누수 처방. 자경단 1년 차 의무.

추신 30. __slots__ 100만 객체 50% 절약. ORM·dataclass 짝.

추신 31. f-string·list comp·dict.get·is None·join이 자경단 매일 5 표준.

추신 32. asyncio 100 URL 1초 vs 순차 100초. 100배 throughput.

추신 33. multiprocessing Pool(4) 한 줄 = CPU 4코어. 데이터 처리 표준.

추신 34. numpy·pandas C 확장 GIL 해제. 자경단 데이터 표준.

추신 35. Python 3.6→3.13 진화 8 버전. 자경단 3.12 표준 + 3.13 검토.

추신 36. PEP 703 (no-GIL)·744 (JIT)이 Python 3.13~3.14 미래.

추신 37. Cursor·Claude Code·Copilot 3 AI 도구가 Python 80/20 자동완성.

추신 38. 자경단의 진짜 가르침 — "1년 후 본인이 본 H 다시 보면 5분에 모든 의문 해결."

추신 39. exchange.py 50줄 + 1년 진화 = 본인의 첫 production. 평생 기념.

추신 40. Ch007 7H 종합 한 페이지 = 자경단 1년 후 첫 신입 멘토 자료.

추신 41. 본인의 Python 첫 commit이 평생 git 로그. 1년 후 한 번 다시.

추신 42. REPL `python3 -i script.py`이 디버깅 표준. 즉시 실험.

추신 43. ipython이 REPL 진화. tab 자동완성·magic command.

추신 44. Jupyter가 시각화·분석·문서화 표준. 매일 데이터 작업.

추신 45. VS Code + Pylance + black + ruff가 자경단 IDE 4 도구.

추신 46. brew install python@3.12이 macOS 자경단 첫 단계.

추신 47. pyenv install 3.12.0이 다중 버전 표준.

추신 48. python -m venv .venv가 가상환경 표준. 매 프로젝트.

추신 49. pip install -r requirements.txt이 의존성 표준. 매번 venv 안.

추신 50. pyproject.toml이 자경단 표준 설정 (black·ruff·mypy·pytest 통합).

추신 51. .python-version이 pyenv 자동 적용. cd 시 버전 자동 전환.

추신 52. requests가 HTTP 표준. httpx가 async 버전.

추신 53. Pydantic이 데이터 검증 표준. FastAPI 짝.

추신 54. dataclass가 보일러플레이트 제거 표준. Python 3.7+.

추신 55. functools.cache가 메모이제이션 표준. lru_cache 무한 버전.

추신 56. itertools 5 (chain·groupby·product·combinations·count) 자경단 매일.

추신 57. collections 5 (defaultdict·Counter·OrderedDict·deque·namedtuple) 자경단 매일.

추신 58. logging 표준 라이브러리가 자경단 production 표준. print 자제.

추신 59. argparse가 CLI 표준. typer이 모던 대체.

추신 60. rich가 터미널 출력 화려화. 자경단 매일 import.

추신 61. Ch007 다음 Ch008부터 Ch120까지 113 챕터 = 자경단 평생 학습.

추신 62. **Ch007 완료** ✅ — 56/960 = 5.83%. Python 입문 1 마침. 자경단 첫 Python 마스터!

추신 63. 본인의 환율 계산기 50줄이 평생 첫 Python. 1년 후 한 번 보세요. 추신 5 (Ch008 예고)와 함께.

추신 64. 본 H의 진짜 결론 — Python 8H 학습 = 평생 자산이고, 50줄 코드 = 1년 후 5,000줄 production이며, 자경단 5명 같은 Python = 합의 비용 0이에요. 다음 Ch008은 제어 흐름 if·for·comprehension. Python 코드의 다른 60%. 🐾🐾🐾

추신 65. exchange.py 50줄을 본 H 직후 직접 타이핑하세요. 19분 = 자경단 본인의 첫 환경.

추신 66. 1주차 6시간 (월 30분 + 화 30분 + 수 1h + 목 1h + 금 1h + 주말 2h) = Python 첫 마스터.

추신 67. 자경단 5명 1년 합 46,000 줄 = 본 H의 50줄에서 시작.

추신 68. 5년 후 자경단 5명 모두 시니어 = 본 H가 시작점. 평생 기념.

추신 69. AI 시대 Python = 가장 안전한 선택. 80% AI 도구가 Python 생성·실행.

추신 70. 본 H의 한 페이지 요약 카드 = 책상 위 평생. 4단어·5자료형·18연산자·9도구·7운영·5원리.

추신 71. 자경단 코드 90%가 Must 5 안에서. 시간 ROI 8,760배.

추신 72. 도구 비용 vs 시간 비용 — Python = $0 도구 + 135시간 학습 = $6,750. Java·Swift 대비 $30,000 5명 5년 절약.

추신 73. 자경단 5년 5명 합 코드 1,000,000+ 줄. 본 H의 50줄에서 시작.

추신 74. Ch007 8H 학습 = 자경단 5명 1년 후 시니어의 첫 발자국. 평생 기념.

추신 75. **Ch007 100% 완료** ✅✅✅ — 56/960 = 5.83%. 자경단 Python 입문 1 마침. Ch008 제어 흐름 시작!

추신 76. exchange.py를 git commit 하세요. 평생 첫 Python commit. 1년 후 reflog에서 찾아 보세요.

추신 77. 본 H 직후 본인이 자경단 wiki에 "내 첫 Python — Ch007 완료"라고 적으세요. 평생 기념.

추신 78. 자경단 5명 첫 모임에서 본 H 카드 한 장씩 들고 사진 찍으세요. 1년 후 보면 평생 기념.

추신 79. Python 1.0 (1994) → 3.12 (2023) 30년. 본 H 학습 = 30년 누적의 8H 압축.

추신 80. Guido van Rossum의 1991년 첫 Python 코드도 50줄. 본 H의 50줄과 같은 시작.

추신 81. 자경단 5명 같은 PEP 8·black·ruff·mypy = 1년 후 같은 양식. 합의 비용 0의 진짜 ROI.

추신 82. 본 H가 자경단 Python 입문의 마침이자 평생의 시작. **다음 만남은 Ch008 제어 흐름**. 🐾🐾🐾

추신 83. 자경단 본인의 첫 Python type hint — `def convert(amount_krw: float, currency: str) -> float`. 6개월 후 본인이 감사.

추신 84. 자경단 본인의 첫 docstring — Google 양식 4줄. 1년 후 본인의 평생 사전.

추신 85. 자경단 본인의 첫 pre-commit 5초 통과. 매 commit 자동. 5년 누적 25,000회.

추신 86. 자경단 본인의 첫 pytest 테스트 — exchange.py의 convert() 5 케이스. 1년 후 100+ 테스트.

추신 87. 자경단 본인의 첫 PR — exchange.py 50줄. 5명 review 5분. 평생 git log.

추신 88. **본 H 진짜 끝** ✅ — 자경단 Python 입문 1 8H 학습 완료. Ch008 제어 흐름 다음 만남에서! 🐾🐾🐾🐾🐾

추신 89. 자경단 5명의 첫 venv `python3 -m venv .venv` 한 줄. 매 프로젝트 표준. 평생 1만 번 사용.

추신 90. 자경단 5명의 첫 import — `import os` 또는 `import sys`. 평생 첫 줄.

추신 91. 자경단 5명의 첫 print() — `print("안녕 자경단 5명!")`. 평생 기념.

추신 92. 자경단 5명의 첫 list — `cats = ["까미", "노랭이", "미니", "깜장이", "본인"]`. 평생 자경단 list.

추신 93. 자경단 5명의 첫 dict — `RATES = {"USD": 1380.50, "JPY": 9.10, "EUR": 1495.30}`. 환율 계산기 핵심.

추신 94. 자경단 5명의 첫 for — `for name in cats: print(name)`. 평생 5명 출력.

추신 95. 자경단 5명의 첫 if — `if currency in RATES:`. 평생 입력 검증.

추신 96. 자경단 5명의 첫 def — `def convert(amount_krw, currency):`. 평생 첫 함수.

추신 97. 자경단 5명의 첫 try/except — `try: ... except ValueError:`. 평생 에러 처리.

추신 98. 자경단 5명의 첫 with — `with open("rates.json") as f:`. 평생 파일 안전.

추신 99. 자경단 5명의 첫 class — `class ExchangeService:`. 1년 후 OOP 마스터.

추신 100. **추신 100 — 본 H 마지막** ✅✅✅✅✅ — Ch007 8H 학습 100% 완료. 자경단 5명 같은 Python = 평생 자산. 다음 Ch008 제어 흐름에서! 🐾🐾🐾🐾🐾

---

## 📌 Ch007 마무리 한 단락

8시간 자경단 Python 입문 1 끝났어요. 본인은 첫 환경 셋업 30분, 첫 50줄 exchange.py 30분, 첫 pre-commit 5초, 첫 5명 PR 5분을 모두 직접 했어요. 본 H의 50줄이 1주일이면 100줄, 1개월이면 첫 API, 6개월이면 첫 production, 1년이면 시니어, 5년이면 평생 자산. 5명 자경단 같은 Python으로 합의 비용 0. 4단어·5자료형·18연산자·9도구·7운영·5원리 = 한 페이지 카드 평생. 다음 Ch008 제어 흐름 (if·for·comprehension)에서 만나요. 🐾
