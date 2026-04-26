# 🏗 ARCHITECTURE — 고양이 자경단

> "고양이 자경단" 은 길고양이 목격 제보·구조·입양·자경단 커뮤니티 플랫폼입니다. 이 문서는 코스 전체에서 단계적으로 진화시킬 시스템의 최종 목표 아키텍처를 정의합니다.

---

## 1. 도메인 한 줄 요약

> 동네에서 발견한 길고양이를 **사진과 함께 지도에 핀으로 제보**하면, 근처 자경단원에게 **실시간으로 알림**이 가고, 필요 시 **라이브 영상**으로 현장을 공유하며 구조한다. AI가 **사진을 분석**해 같은 고양이인지·건강 상태는 어떤지·다음 행동은 무엇이 좋을지 제안한다.

---

## 2. 핵심 사용자

| 역할 | 설명 |
|------|------|
| 일반 회원 | 누구나 제보·열람·후원 가능 |
| 자경단원 | 인증된 구조 활동가, 채팅·라이브·구조 기록 권한 |
| 입양 희망자 | 보호 중인 고양이 신청 |
| 관리자 | 자경단원 승인, 신고 처리, 통계 |

---

## 3. 핵심 기능 → 기술 매핑

| 기능 | 기술 | 코스 챕터 |
|------|------|----------|
| 길고양이 제보 (위치+사진) | Flask REST API + Leaflet + S3 Presigned | Ch 56~70, Ch 80 |
| 신규 제보 실시간 알림 | SSE | Ch 81 |
| 자경단 지역 채팅 | Socket.IO | Ch 82 |
| 채팅의 클라우드 네이티브 버전 | API Gateway WebSocket / AppSync | Ch 83 |
| 구조 현장 라이브 | WebRTC + LiveKit | Ch 84 |
| 모바일 푸시 | 웹푸시 VAPID + PWA | Ch 85 |
| AI 사진 분석·고양이 매칭 | Vision LLM + Embedding | Ch 99, Ch 97~98 |
| Agent 비서 ("이 고양이 어떻게 해요?") | LLM Agent + Tool Calling + MCP | Ch 90~94 |
| 입양·후원·결제 | Toss Payments (선택) | 외전 |
| 운영자 대시보드 | React + Recharts | Ch 76~78 |

---

## 4. 시스템 다이어그램 (최종 — Ch 120 시점)

```
                              ┌─────────────────┐
                              │   Route 53      │
                              │  (DNS, Health)  │
                              └────────┬────────┘
                                       │
                              ┌────────▼────────┐
                              │   CloudFront    │  (CDN, OAC, WAF)
                              └────────┬────────┘
                                       │
                ┌──────────────────────┼──────────────────────┐
                │                      │                      │
        ┌───────▼────────┐    ┌────────▼────────┐    ┌────────▼────────┐
        │   ALB (HTTPS)  │    │  API Gateway    │    │   S3 (static)   │
        │                │    │ (WebSocket/HTTP)│    │  + 이미지 업로드│
        └───────┬────────┘    └────────┬────────┘    └─────────────────┘
                │                      │
       ┌────────▼────────┐    ┌────────▼────────┐
       │  ECS Fargate    │    │     Lambda      │
       │  - Flask API    │    │ - WebSocket fn  │
       │  - Gunicorn+    │    │ - Background fn │
       │    gevent       │    └────────┬────────┘
       │  - Socket.IO    │             │
       └───┬─────────┬───┘             │
           │         │                 │
           │         └─► EventBridge ◄─┘
           │              │
           ▼              ▼
   ┌──────────────┐  ┌──────────────┐
   │  RDS / Aurora│  │   DynamoDB   │  (WebSocket 연결 관리)
   │   (MySQL)    │  └──────────────┘
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
   │ Aurora       │  │   Bedrock    │  │   LiveKit    │
   │  pgvector    │  │  (LLM/Agent) │  │  (WebRTC SFU)│
   │  (RAG 메모리)│  │  + Knowledge │  │   + S3 녹화  │
   └──────────────┘  │     Bases    │  └──────────────┘
                     └──────────────┘
```

---

## 5. 학기별 시스템 진화 단계

| Sem | 단계 | 변화 |
|-----|------|------|
| S1~S2 | Local CLI | Python으로 가계부/제보 기록 — DB 없음 |
| S3 | Local DB | Docker MySQL + 직접 SQL |
| S5 | Local Backend | Flask + SQLAlchemy + 로컬 MySQL + JWT |
| S6 | Local Fullstack | + React + Leaflet + 로컬 SSE/Socket.IO + 로컬 LiveKit |
| S7 | + AI | + Agent + MCP + RAG + Vision |
| S8 (초중반) | Cloud Lift | EC2 → ECS Fargate, 로컬 MySQL → RDS, S3, CloudFront |
| S8 (후반) | Production | Multi-AZ → Multi-Region DR, IaC, CI/CD, Bedrock Agents, 비용 최적화 |

---

## 6. 데이터 모델 (개요)

```
User ─< Squad ─< Region
  │
  ├─< CatReport >─ CatProfile
  │       │            │
  │       └< Photo     ├< MatchScore
  │       └< Comment   └< AdoptionRequest
  │
  ├─< RescueLog
  ├─< Donation
  └─< ChatMessage (Room: per region)

LiveSession (LiveKit Room) ─ Recording (S3)
AgentConversation ─< AgentMessage ─< ToolCall
```

상세 ERD: [docs/CAT-VIGILANTE-SPEC.md](docs/CAT-VIGILANTE-SPEC.md)

---

## 7. 비기능 요구사항 (S8 시점)

- **가용성**: 99.9% (Multi-AZ 기본, Multi-Region 옵션)
- **응답시간**: P95 < 300ms (정적 자원 제외)
- **비용**: 활성 사용자 1만 명 기준 월 $200 이하 (S8 Ch 120에서 분석)
- **보안**: OWASP Top 10 통과, KMS 암호화, IAM 최소 권한, WAF
- **관측**: CloudWatch + X-Ray 분산 추적, SLO/에러버짓
- **재해 복구**: RPO ≤ 15분, RTO ≤ 1시간 (Warm Standby)

---

## 8. 의도적 결정 (Trade-offs)

| 결정 | 이유 |
|------|------|
| Flask (vs FastAPI) | 학습 자료·생태계 풍부, gevent로 SSE/Socket.IO 자연스러움 |
| MySQL 기본 (vs Postgres) | 한국 실무 빈도, 단 RAG는 Aurora pgvector로 Postgres 도입 |
| TanStack Query (vs Redux) | 서버 상태 90% — 보일러플레이트 최소화 |
| Terraform (vs CDK) | 멀티클라우드 가능성, HCL 가독성 |
| LiveKit (vs Agora/Twilio) | 오픈소스 self-host 가능, 비용 통제 |
| MCP (vs 단일 SDK) | 2026년 표준, 도구 재사용성 |

---

> 이 ARCHITECTURE는 살아있는 문서입니다. 학기별로 갱신되며, 각 챕터 README는 이 문서의 어느 부분을 다루는지 명시합니다.
