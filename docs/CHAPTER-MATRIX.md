# 📋 CHAPTER MATRIX — 120챕터 전체 매트릭스

> 각 챕터는 8교시 × 60분(H1~H8) = 8시간 강의 + 코드 실습.
> 학습 권장: **챕터당 2주** (강의 8시간 + 코드/연습 8~12시간).
> 총 120챕터 × 2주 = **약 24개월(2년) 코스**.

---

## 학기 한눈에

| Sem | 주제 | 챕터 | 산출물 |
|-----|------|------|--------|
| S1 | CS 기초 + Python 입문 | Ch 1~15 | CLI 가계부 |
| S2 | Python 심화 + 자료구조·알고리즘 + 코딩테스트 | Ch 16~30 | 코딩테스트 30문제 풀이 노트 |
| S3 | SQL + 데이터베이스 깊이 | Ch 31~42 | 고양이 자경단 ERD + 100쿼리 |
| S4 | HTML/CSS/JS/TS + 프론트 기초 | Ch 43~55 | 바닐라 TS 고양이 카드 UI |
| S5 | 백엔드 풀코스 (Flask·API·OAuth·보안) | Ch 56~70 | 고양이 제보 API 완성 |
| S6 | 프론트 심화 + 실시간 (SSE/Socket.IO/WebRTC) | Ch 71~85 | 라이브 영상까지 도는 사이트 |
| S7 | AI 엔지니어링 (LLM·Agent·MCP·Harness·MLOps) | Ch 86~103 | 자체 Agent 하니스 + MCP 서버 |
| S8 | AWS 클라우드 아키텍트 + DevOps + 취업 준비 | Ch 104~120 | 멀티리전 라이브 사이트 + 시디면접 노트 |

---

## S1 — CS 기초 + Python 입문 (Ch 1~15)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 001 | 컴퓨터 구조 기본 | CPU·메모리·디스크·네트워크 | "내 맥북 사양 읽기" |
| 002 | 운영체제 기본 | 프로세스·스레드·파일시스템·권한 | `ps`, `top` 으로 내 맥 들여다보기 |
| 003 | 네트워크 기본 | TCP/IP·HTTP·DNS·HTTPS | curl로 HTTP 요청 보내고 받기 |
| 004 | Git & GitHub 기본 | clone/commit/branch/PR | 첫 PR 보내기 |
| 005 | Git 협업 워크플로 | rebase/merge/conflict/리뷰 | 충돌 일부러 만들고 풀기 |
| 006 | 터미널·셸·Bash | 파이프·리다이렉트·find·grep | "내 맥에서 가장 큰 파일 찾기" 한 줄 |
| 007 | Python 입문 1 | 변수·자료형·연산자 | 환율 계산기 |
| 008 | Python 입문 2 | if/for/while | FizzBuzz·구구단 |
| 009 | Python 입문 3 | 함수·스코프·인자 | 가위바위보 |
| 010 | Python 입문 4 | list/tuple/dict/set | 단어 빈도수 카운터 |
| 011 | Python 입문 5 | 문자열·포맷팅·정규식 | 이메일/전화번호 추출기 |
| 012 | Python 입문 6 | 파일 I/O·예외 | CSV → 정리된 텍스트 보고서 |
| 013 | Python 입문 7 | 모듈·패키지·import | 내 모듈 만들고 임포트 |
| 014 | Python 입문 8 | venv·pip·pyproject.toml | 가상환경 만들고 패키지 설치 |
| 015 | **CS+Python 통합 미니** | CLI 가계부 | 가계부 한 달 분석 리포트 |

---

## S2 — Python 심화 + 자료구조·알고리즘 (Ch 16~30)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 016 | OOP 1 | class·instance·dunder | Cat·Squad 클래스 |
| 017 | OOP 2 | 상속·다형성·ABC·dataclass | Animal → Cat → AbandonedCat 계층 |
| 018 | 표준라이브러리 1 | datetime·zoneinfo·pathlib·json | 어제 자정 한국시간 출력 |
| 019 | 표준라이브러리 2 | collections·itertools·functools | 제보 데이터 그룹·카운트 |
| 020 | 타입힌트 끝 | typing/Generic/Protocol/TypedDict | mypy 통과시키기 |
| 021 | 예외 설계 + logging | 예외 계층·logger 구조 | 구조화 로그 한 파일 |
| 022 | pytest | fixture/parametrize/mock | 가계부 테스트 20개 |
| 023 | 데코레이터·컨텍스트매니저 | functools.wraps·`__enter__/__exit__` | timing 데코레이터 |
| 024 | 제너레이터·이터레이터 | yield·yield from | 무한 ID 발급기 |
| 025 | 비동기 | async/await/asyncio | 환율 N개 동시 가져오기 |
| 026 | 자료구조 1 | 배열/연결리스트/스택/큐/해시 | 직접 구현 + 빅오 |
| 027 | 자료구조 2 | 트리/힙/그래프/트라이 | Trie로 자동완성 |
| 028 | 알고리즘 1 | 정렬/이분/투포인터/슬라이딩윈도우 | LeetCode 5문제 |
| 029 | 알고리즘 2 | 재귀/DP/그리디/BFS·DFS | LeetCode 5문제 |
| 030 | **코딩테스트 실전** | 30문제 라이브 풀이 + 빅오 | 시간복잡도 분석 노트 |

---

## S3 — SQL + 데이터베이스 깊이 (Ch 31~42)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 031 | DB 개론 | 관계형 vs NoSQL·ACID·정규화 | 1NF→3NF 단계별 |
| 032 | **Docker로 MySQL 한 줄** ⭐ | 블랙박스 Docker (Ch 47에서 본격) | `docker run mysql` |
| 033 | SQL 입문 | SELECT/WHERE/ORDER/LIMIT | 100행 샘플 데이터 조회 |
| 034 | JOIN 끝까지 | INNER/LEFT/RIGHT/FULL/CROSS/SELF | 자경단×제보 조인 |
| 035 | 집계·서브쿼리·CTE | GROUP BY/HAVING/EXISTS | 자경단별 구조 건수 |
| 036 | 윈도우함수 | ROW_NUMBER/RANK/LAG/LEAD | 일별 누적 제보 |
| 037 | 인덱스 1 | B-Tree·복합·커버링 | EXPLAIN 비교 |
| 038 | 실행계획·튜닝 | EXPLAIN·N+1·슬로우쿼리 | 200ms → 5ms 튜닝 |
| 039 | 트랜잭션·격리수준 | ACID·MVCC | 격리수준별 현상 재현 |
| 040 | 락·데드락·동시성 | 비관/낙관·gap lock | 데드락 일부러 만들기 |
| 041 | DB 모델링 실습 | 고양이 자경단 ERD 설계 | 12 테이블 ERD |
| 042 | NoSQL + Redis 기초 | 캐시·세션·Pub/Sub 미리보기 | Redis로 핫 데이터 캐시 |

---

## S4 — HTML/CSS/JS/TS + 프론트 기초 (Ch 43~55)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 043 | HTML5 + 접근성 | 시맨틱·a11y·폼 | 접근성 통과 폼 |
| 044 | CSS 기초 | 박스모델·셀렉터·플렉스/그리드 | 카드 레이아웃 |
| 045 | CSS 심화 | 반응형·애니메이션·디자인토큰 | 모바일/데스크탑 자동 |
| 046 | JavaScript 1 | 타입·스코프·호이스팅 | 흔한 함정 5개 재현 |
| 047 | **Docker 본격** ⭐ | 이미지/컨테이너/네트워크/볼륨/Compose | 풀스택 dev 환경 |
| 048 | JavaScript 2 | 함수·클로저·this | 클로저로 카운터 만들기 |
| 049 | JavaScript 3 | 프로토타입·class·모듈 | OOP 게시판 |
| 050 | JavaScript 4 | 이벤트루프·Promise·async | 비동기 순서 퀴즈 |
| 051 | TypeScript 1 | 타입·인터페이스·제네릭 | JS 코드 TS로 |
| 052 | TypeScript 2 | 유틸리티·유니온·tsconfig | Pick/Omit/Partial 실습 |
| 053 | DOM·Fetch·Web API | querySelector·fetch·Storage | 할일 앱 (바닐라) |
| 054 | 빌드 도구 | Vite·esbuild·번들링 | Vite로 첫 프로젝트 |
| 055 | **JS+TS 미니 프로젝트** | 바닐라 TS 고양이 카드 UI | 카드 그리드 + 검색 |

---

## S5 — 백엔드 풀코스 (Ch 56~70)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 056 | 백엔드 개발환경 | Docker Compose·Make·.env·12-factor | `make dev` 한 줄 |
| 057 | Flask 1 | 첫 앱·라우팅·요청/응답 | `/hello` 엔드포인트 |
| 058 | Flask 2 | Blueprint·App Factory·Config | `cats/` `users/` 분리 |
| 059 | SQLAlchemy 2 | 모델·세션·관계 | Cat·Report 모델 |
| 060 | SQLAlchemy 로딩전략 | N+1 진단·eager/lazy | N+1 200ms→20ms |
| 061 | Flask-Migrate·Alembic | 마이그레이션·롤백 | 컬럼 추가 마이그레이션 |
| 062 | REST API 설계 | 자원·상태코드·페이징 | 12개 엔드포인트 |
| 063 | 직렬화·검증 | marshmallow/pydantic | 입력 검증 |
| 064 | OpenAPI 자동 문서화 | Swagger UI | 자동 문서 페이지 |
| 065 | OAuth2 1 | Authorization Code + PKCE | OAuth 흐름 시각화 |
| 066 | OAuth2 2 | 카카오/구글/네이버 연동 | 카카오 로그인 |
| 067 | JWT·세션·쿠키·CSRF | 액세스/리프레시·httpOnly | 토큰 자동 재발급 |
| 068 | RBAC·권한 매트릭스 | 역할·정책·감사 | 자경단원/관리자 분리 |
| 069 | 보안 OWASP Top 10 | SQLi/XSS/SSRF/IDOR | 취약→안전 비교 |
| 070 | **백엔드 통합** | 고양이 제보 API 완성 | Postman 컬렉션 시연 |

---

## S6 — 프론트 심화 + 실시간 (Ch 71~85)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 071 | React 1 | 컴포넌트·JSX·props·state | Hello Cat |
| 072 | React 2 | Hooks 정확히 | useEffect 함정 모음 |
| 073 | React 3 | Router v6 + 보호된 라우트 | 권한별 리디렉트 |
| 074 | TailwindCSS + 디자인 시스템 | 토큰·컴포넌트 추출 | 다크모드 토글 |
| 075 | 상태관리 비교 | Zustand vs Context vs Redux | 같은 기능 3가지 구현 |
| 076 | TanStack Query | 캐시·무효화·낙관적 업데이트 | 즉시 반영 폼 |
| 077 | 폼 | react-hook-form + zod | 다단계 제보 폼 |
| 078 | 성능 | 코드스플리팅·메모·Lighthouse | Lighthouse 90+ |
| 079 | 접근성·i18n·SEO | a11y·번역·메타 | 한국어/영어 토글 |
| 080 | **고양이 제보 UI** | Leaflet + S3 Presigned | 핀 찍어 제보 |
| 081 | **SSE 실시간** | gevent·EventSource·Nginx | 신규 제보 알림 배지 |
| 082 | **Socket.IO 채팅** | Room·JWT 핸드셰이크 | 자경단 지역 채팅 |
| 083 | **stateful↔serverless 다리** ⭐ | API Gateway WebSocket·AppSync | 채팅을 서버리스로 재구현 |
| 084 | **WebRTC + LiveKit** | SFU·녹화·시그널링 | 현장 라이브 송출 |
| 085 | 웹푸시 + PWA | VAPID·Service Worker | 모바일 알림 |

---

## S7 — AI 엔지니어링 (Ch 86~103)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 086 | LLM 기초 | 토큰·컨텍스트·temperature·샘플링 | 같은 prompt 다른 출력 |
| 087 | 멀티프로바이더 추상화 | Claude/Gemini/GPT/Bedrock 폴백 | 자동 폴백 라우팅 |
| 088 | 프롬프트 엔지니어링 | System/Few-shot/CoT | 같은 작업 5가지 prompt |
| 089 | **컨텍스트 엔지니어링** | 윈도우 관리·청크·요약·prompt caching | 100k 토큰 입력 처리 |
| 090 | Agent Loop & Tool Calling | ReAct·Function Calling | "사진 받아 분석" Agent |
| 091 | 멀티턴 메모리·sub-agent | plan/act 분리 | 복잡 태스크 분해 |
| 092 | **MCP 1** | 개념·서버·클라이언트 | hello-mcp 서버 |
| 093 | **MCP 2** | 자경단 MCP 서버 구현·배포 | Claude Desktop 연동 |
| 094 | **Agent Harness** | claude-code/Codex 류 분해 | 미니 하니스 직접 |
| 095 | 스트리밍·비용·레이트리밋 | SSE 토큰 스트림·백오프 | 실시간 토큰 + 비용 표시 |
| 096 | 가드레일·moderation | PII·jailbreak 방어 | 공격 prompt 차단 |
| 097 | RAG 1 | 청킹·임베딩·pgvector | 입양가이드 RAG |
| 098 | RAG 2 | hybrid·reranking·GraphRAG 개요 | BM25+벡터 비교 |
| 099 | Vision Multimodal | 사진 분석·OCR·매칭 | 같은 고양이 자동 매칭 |
| 100 | 음성 | Whisper/TTS·실시간 음성 Agent | 음성으로 제보 |
| 101 | Fine-tuning | LoRA/QLoRA·언제 vs RAG vs prompt | 의사결정 트리 |
| 102 | **LLM Eval & Observability** | eval·LLM-as-Judge·트레이싱 | 골든셋 회귀 평가 |
| 103 | **MLOps for LLM + AI Safety** | 프롬프트 버저닝·canary·EU AI Act | 프롬프트 배포 파이프라인 |

---

## S8 — AWS + DevOps + 취업 준비 (Ch 104~120)

| Ch | 제목 | 핵심 키워드 | H5 데모 |
|----|------|-------------|---------|
| 104 | AWS 입문 + Well-Architected 6 Pillars | 리전·AZ·공유책임·CLI·SDK | CLI로 첫 호출 |
| 105 | IAM 깊이 | User·Role·Policy·SSO·OIDC for GHA | 키 없는 GitHub Actions 배포 |
| 106 | VPC·네트워킹 | 서브넷·SG·VPC Endpoint·TGW | 자경단용 VPC 설계 |
| 107 | LB·DNS·CDN·인증서 | ALB/NLB/Route53/ACM/CloudFront | HTTPS 도메인 연결 |
| 108 | EC2 깊이 | AMI·Launch Template·ASG·Spot | 단일→ASG 진화 |
| 109 | ECS Fargate + EKS 개요 + App Runner | Task/Service/Capacity | Flask를 Fargate로 |
| 110 | Lambda + API Gateway + EventBridge ⭐ Ch83 회수 | REST/HTTP/**WebSocket** | WebSocket 채팅 데모 |
| 111 | **RDS·Aurora — 로컬 MySQL → Aurora 무중단 이전** ⭐ Ch59 회수 | Multi-AZ·PITR·Aurora Serverless v2 | dump→restore→cutover |
| 112 | DynamoDB | 파티션키·GSI/LSI·DAX·스트림 | 채팅 세션 스토어 |
| 113 | S3 풀세트 | 클래스·수명주기·Object Lock·CRR | 비용 50% 절감 분석 |
| 114 | SQS·SNS·Kinesis | DLQ·fan-out·스트림 | 신규 제보 fan-out |
| 115 | KMS·Secrets·WAF·GuardDuty·Security Hub | 암호화·회전·룰그룹 | Secrets 자동 회전 |
| 116 | CloudWatch·X-Ray·Athena·OpenSearch | 메트릭·트레이스·SLO | 분산 트레이스 시연 |
| 117 | Terraform 깊이 (+ CDK 비교) | 모듈·remote state·드리프트 | 전 환경 IaC |
| 118 | CI/CD | GitHub Actions OIDC·blue-green·카나리 | 자동 롤백 시연 |
| 119 | Bedrock·SageMaker·Bedrock Agents ⭐ Ch90 회수 | Knowledge Bases·Agents | Ch90 Agent를 Bedrock으로 |
| 120 | **고급 아키텍처 + 취업 준비** | 멀티리전 DR·비용 최적화·**시디면접 10문제·이력서·포트폴리오** | Well-Architected Review |

---

## ⭐ 챕터 간 핵심 회수 흐름

| 회수 | 어디서 → 어디로 | 무엇을 |
|------|----------------|--------|
| Ch 32 → Ch 47 | "Docker MySQL 블랙박스" → "Docker 본격" | 그동안 쓰던 그 Docker의 실체 |
| Ch 59 → Ch 111 | "로컬 MySQL + SQLAlchemy" → "RDS/Aurora 이전" | 같은 모델 그대로 클라우드로 |
| Ch 80 → Ch 113 | "S3 Presigned 업로드" → "S3 풀세트" | 그동안 쓰던 그 S3의 진짜 모습 |
| Ch 82 → Ch 83 → Ch 110 | "Socket.IO" → "API Gateway WebSocket 다리" → "Lambda+API GW 본격" | stateful → serverless 전환 |
| Ch 90 → Ch 119 | "자체 Agent" → "Bedrock Agents" | 같은 Agent 두 가지 방식 |
| Ch 97 → Ch 119 | "pgvector RAG" → "Bedrock Knowledge Bases" | 직접 vs 매니지드 |

---

> 모든 챕터 폴더는 `chapters/NNN-name/` 형식으로 생성됩니다 (NNN = 001~120).
> 각 챕터의 `lecture/` 하위 H1~H8 대본은 [docs/LECTURE-TEMPLATE.md](LECTURE-TEMPLATE.md)를 따릅니다.
