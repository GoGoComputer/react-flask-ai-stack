# 🐱 고양이 자경단 — 풀스택 + AI 엔지니어링 + AWS 클라우드 아키텍트 코스

> **이 코스 하나로 신입~주니어 백엔드/프론트엔드/풀스택/AI 엔지니어/DevOps 어디든 지원할 수 있는 역량을 만든다.**
> 오픈소스 "고양이 자경단" 사이트(길고양이 구조 커뮤니티)를 0에서 프로덕션 배포까지 직접 만들면서 배운다.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Status](https://img.shields.io/badge/status-WIP-orange)
![Chapters](https://img.shields.io/badge/chapters-120-blue)
![Lectures](https://img.shields.io/badge/lectures-960-blue)

---

## 📌 한눈에

| 항목 | 값 |
|------|-----|
| 학기 | 8학기 |
| 챕터 | **120챕터** |
| 강의 대본 | **960개** (120 × H1~H8 = 8교시) |
| 학습 기간 | **약 24개월 (주 5~10시간)** |
| 챕터당 학습 | 2주 |
| 도메인 | 고양이 자경단 (오픈소스 길고양이 구조 커뮤니티 사이트) |
| 라이선스 | MIT (사내 교육·부트캠프·유튜브 자유 사용) |

---

## 🎯 이 코스를 끝내면

- **백엔드 엔지니어** — Python/Flask/SQLAlchemy/MySQL/RESTful/OAuth/JWT/RBAC/보안
- **프론트엔드 엔지니어** — TypeScript/React/TailwindCSS/TanStack Query/실시간 UI
- **풀스택 엔지니어** — 위 두 가지 + 통합 + 배포
- **AI 엔지니어 / LLM 엔지니어** — Agent / MCP / Harness / RAG / Eval / MLOps / Safety
- **DevOps / 클라우드 엔지니어** — AWS 클라우드 아키텍트 실무 역량 + Terraform + CI/CD
- **신입 개발자** — CS 기초 + 자료구조·알고리즘 + 시스템 디자인 면접 + 이력서·포트폴리오

---

## 🧭 8학기 로드맵

| Sem | 주제 | 챕터 | 산출물 |
|-----|------|------|--------|
| **S1** | CS 기초 + Python 입문 | Ch 1~15 | CLI 가계부 |
| **S2** | Python 심화 + 자료구조·알고리즘 + 코딩테스트 | Ch 16~30 | 코딩테스트 30문제 풀이 노트 |
| **S3** | SQL + 데이터베이스 깊이 | Ch 31~42 | 고양이 자경단 ERD + 100쿼리 |
| **S4** | HTML/CSS/JavaScript/TypeScript + 프론트 기초 | Ch 43~55 | 바닐라 TS 고양이 카드 UI |
| **S5** | 백엔드 풀코스 (Flask·API·OAuth·보안) | Ch 56~70 | 고양이 제보 API 완성 |
| **S6** | 프론트엔드 심화 + 실시간 (SSE/Socket.IO/WebRTC) | Ch 71~85 | 라이브 영상까지 도는 사이트 |
| **S7** | AI 엔지니어링 (LLM·Agent·MCP·Harness·MLOps) | Ch 86~103 | 자체 Agent 하니스 + MCP 서버 |
| **S8** | AWS 클라우드 아키텍트 + DevOps + 취업 준비 | Ch 104~120 | 멀티리전 라이브 사이트 + 시디면접 노트 |

📖 학기·챕터 전체 매트릭스: [docs/CHAPTER-MATRIX.md](docs/CHAPTER-MATRIX.md)

---

## 📂 레포 구조

```
react-flask-ai-stack/
├── README.md                       # 이 파일
├── ARCHITECTURE.md                 # 시스템 아키텍처
├── LICENSE
│
├── docs/
│   ├── CHAPTER-MATRIX.md           # 120챕터 전체 표
│   ├── LECTURE-TEMPLATE.md         # 강의 대본 표준 템플릿 (H1~H8)
│   ├── STYLE-GUIDE.md              # 톤·길이·박스 규약
│   └── CAT-VIGILANTE-SPEC.md       # 도메인 사양 (ERD/페이지/플로우)
│
├── chapters/
│   ├── 001-cs-computer-architecture/
│   ├── 002-cs-os-basics/
│   ├── ...
│   └── 120-advanced-architecture-and-job-prep/
│
└── final-project/                   # 모든 챕터 통합 완성본 (S8 후)
    ├── backend/  frontend/  agent/  infra/  deploy/
```

각 챕터 폴더 표준 구조:

```
chapters/NNN-name/
├── README.md          # 개발자용 (학습 목표·체크리스트·코드 가이드)
├── start/             # 시작 코드 (이전 챕터 finish 복사)
├── finish/            # 완성 코드
├── exercises.md       # 연습 문제 (쉬움/중간/어려움)
├── notes/             # 다이어그램, 면접 Q&A, 트러블슈팅
└── lecture/           # 비개발자도 이해 가능한 강의 대본 (8교시 × 60분)
    ├── README.md      # 강의 운영 가이드 + 마스터 목차
    ├── H1-orientation.md
    ├── H2-concepts.md
    ├── H3-setup.md
    ├── H4-catalog.md
    ├── H5-demo.md         ⭐ "보이는 결과물"
    ├── H6-management.md
    ├── H7-internals.md
    └── H8-apply-wrap.md
```

---

## 🎙 H1~H8 표준 시간 슬롯

각 챕터는 **60분짜리 강의 8교시**로 구성됩니다 (총 8시간).

| 교시 | 역할 |
|------|------|
| H1 | 오리엔테이션 — 왜 이걸 배우나, ROI |
| H2 | 핵심 개념 4개 — 비유로 친해지기 |
| H3 | 환경/설치 — 한 줄의 의미 |
| H4 | 기본 명령/API/문법 카탈로그 |
| H5 | **첫 실전 데모 — "보이는 결과물"** ⭐ |
| H6 | 보관/관리 (백업·디버깅·흔한 실수) |
| H7 | 안심하고 쓰는 원리 (멱등성·격리·보안·내부 동작) |
| H8 | 내 일에 적용 + 회고 + 다음 챕터 예고 |

📖 대본 상세 규약: [docs/LECTURE-TEMPLATE.md](docs/LECTURE-TEMPLATE.md), [docs/STYLE-GUIDE.md](docs/STYLE-GUIDE.md)

---

## 🚀 빠른 시작

### 학습자

```bash
git clone https://github.com/GoGoComputer/react-flask-ai-stack.git
cd react-flask-ai-stack
open docs/CHAPTER-MATRIX.md   # 전체 코스 한눈에
cd chapters/001-cs-computer-architecture
open lecture/H1-orientation.md
```

### 강사 / 부트캠프

각 챕터의 `lecture/` 폴더에 있는 H1~H8 대본을 마이크 앞에서 그대로 읽어도 강의가 진행됩니다.

---

## 🛠 기술 스택 (전 코스 통합)

**언어/런타임**: Python 3.12+, TypeScript 5+, Node.js 20+, SQL(MySQL 8/PostgreSQL 16), Bash
**백엔드**: Flask, SQLAlchemy 2, Alembic, Gunicorn+gevent, Flask-SocketIO, Flask-JWT-Extended
**프론트엔드**: React 18+, TanStack Query, TailwindCSS, react-hook-form+zod, Leaflet, Vite
**실시간**: SSE, Socket.IO, LiveKit (WebRTC SFU), API Gateway WebSocket, AppSync
**데이터베이스**: MySQL, PostgreSQL+pgvector, Redis, DynamoDB
**AI**: Anthropic Claude, Google Gemini, AWS Bedrock, Ollama, MCP, LangSmith/Promptfoo, LoRA/QLoRA
**인프라**: Docker/Compose, AWS (60+ 서비스), Terraform, GitHub Actions OIDC
**관측·보안**: CloudWatch, X-Ray, Sentry, KMS, Secrets Manager, WAF, GuardDuty

---

## 📜 라이선스

[MIT License](LICENSE) — 사내 교육·부트캠프·유튜브 등 자유 사용/수정/배포 가능. 출처(`react-flask-ai-stack` / 고양이 자경단) 표기 부탁드립니다.

---

## 🤝 기여

이 코스는 오픈 컨트리뷰션을 환영합니다. 챕터별 README의 체크리스트를 기준으로 PR 부탁드립니다.

---

**자, 시작합시다. → [docs/CHAPTER-MATRIX.md](docs/CHAPTER-MATRIX.md)**
