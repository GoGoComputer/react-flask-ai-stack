# 🐱 CAT VIGILANTE — 도메인 사양

> "고양이 자경단" 사이트의 도메인 모델·페이지·사용자 플로우 정의.
> 모든 챕터의 코드와 강의 데모는 이 사양을 일관되게 사용합니다.

---

## 1. 미션

> 동네 길고양이를 **혼자 걱정하던 사람들을 연결**해, **사진 한 장으로 시작되는 구조 협업**을 가능하게 한다.

---

## 2. 사용자 역할

| 역할 | 권한 |
|------|------|
| `guest` | 제보 열람 |
| `member` | 제보 작성/댓글, 채팅 참여 |
| `vigilante` | + 라이브 송출, 구조 기록, 자경단 채팅방 |
| `vet` | + 의료 자문 답변 |
| `admin` | + 자경단 승인, 신고 처리, 통계 |

---

## 3. 핵심 페이지

| 경로 | 화면 | 권한 | 등장 챕터 |
|------|------|------|-----------|
| `/` | 랜딩 (지도+최근 제보) | guest+ | Ch 71~80 |
| `/login` | 카카오/구글 로그인 | guest | Ch 65~66 |
| `/reports` | 제보 목록 (필터/지도) | guest+ | Ch 80 |
| `/reports/new` | 제보 작성 (지도 핀+사진) | member+ | Ch 80 |
| `/reports/:id` | 제보 상세 (댓글·매칭·구조이력) | guest+ | Ch 76, 80 |
| `/cats/:id` | 고양이 프로필 | guest+ | Ch 99 |
| `/squads` | 자경단 목록 | guest+ | Ch 73 |
| `/squads/:id/chat` | 자경단 채팅방 | vigilante | Ch 82 |
| `/live/:roomId` | 구조 현장 라이브 | vigilante | Ch 84 |
| `/agent` | AI 비서 (사진 분석/조언) | member+ | Ch 90~94, 99 |
| `/adopt` | 입양 게시판 | member+ | Ch 76 |
| `/admin` | 운영자 대시보드 | admin | Ch 78 |

---

## 4. 도메인 ERD (개요)

```
┌─────────┐         ┌──────────┐         ┌──────────┐
│  User   │1───*│  CatReport  │*───1│  Region   │
└────┬────┘         └────┬─────┘         └──────────┘
     │                   │
     │1                  │1───*┌──────────┐
     │                   │      │  Photo   │ → S3 key
     │*                  │      └──────────┘
┌─────────┐              │1───*┌──────────┐
│ Squad   │*───*User    │      │ Comment  │
└────┬────┘              │1───*┌──────────┐
     │1                  │      │MatchScore│ → CatProfile
     │*                  │
┌──────────┐         ┌────┴─────┐         ┌──────────┐
│ChatRoom  │1───*│ChatMessage│         │CatProfile│1───*│RescueLog
└──────────┘         └──────────┘         └──────────┘

┌──────────────┐  ┌────────────────┐  ┌──────────────┐
│LiveSession   │  │AgentConversation│  │   Donation   │
│(LiveKit Room)│  │ + AgentMessage  │  │              │
│ + Recording  │  │ + ToolCall      │  │              │
└──────────────┘  └────────────────┘  └──────────────┘
```

### 주요 테이블 컬럼 (요약)

#### `users`
- `id`, `email` UNIQUE, `nickname`, `role` ENUM, `provider` (kakao/google), `provider_id`, `created_at`

#### `cat_reports`
- `id`, `user_id` FK, `region_id` FK, `lat`, `lng`, `description`, `urgency` ENUM(low/med/high/emergency), `status` ENUM(open/in_progress/rescued/closed), `created_at`

#### `cat_profiles` (구조 후 생성/매칭)
- `id`, `name`, `breed_guess`, `estimated_age`, `health_status`, `photo_embedding` VECTOR(1536), `created_at`

#### `photos`
- `id`, `report_id` FK, `s3_key`, `mime`, `size`, `taken_at`, `exif_stripped` BOOL

#### `match_scores`
- `report_id`, `cat_profile_id`, `score` FLOAT, `method` ENUM(vision/embedding/manual)

#### `chat_messages`
- `id`, `room_id`, `user_id`, `body`, `read_by` JSON, `created_at`

#### `agent_conversations` / `agent_messages` / `tool_calls`
- LLM Agent 대화 영속화 (Ch 90~)

---

## 5. 핵심 사용자 플로우

### F1. 제보 → 알림 → 채팅 → 구조 → 매칭

```
1. member가 동네에서 길고양이 발견
2. /reports/new 에서 핀 찍고 사진 업로드 (S3 Presigned)
3. 같은 region_id 의 vigilante 들에게 SSE 푸시
4. vigilante가 자경단 채팅방에서 "내가 갈게요" → Socket.IO 메시지
5. 현장 도착 시 /live/:roomId 에서 라이브 송출 (LiveKit)
6. 구조 완료 → status=rescued, RescueLog 생성
7. AI가 사진 임베딩으로 기존 CatProfile과 매칭 → MatchScore
8. 매칭 성공 시 "이전에 본 적 있는 고양이" 알림
```

### F2. AI Agent 흐름

```
1. /agent 에서 사진 업로드 + "이 고양이 어떻게 해야 해요?"
2. Agent Loop:
   a. tool: vision_analyze (품종/추정 나이/건강 상태)
   b. tool: search_similar_cats (벡터 검색으로 매칭)
   c. tool: get_nearby_vets (현재 위치 기반)
   d. tool: rag_query (입양 가이드 RAG)
3. 종합 답변 + 다음 행동 추천 (3가지)
4. 사용자 confirm 시 tool: notify_squad 또는 book_vet
```

### F3. 입양 플로우

```
1. AdoptionRequest 생성 → 자경단 검토
2. 면담 일정 (이메일) → 입양 확정
3. 1년 follow-up 알림 (APScheduler)
```

---

## 6. 비기능 요구사항

| 항목 | 목표 (S8 시점) |
|------|---------------|
| 응답시간 P95 | < 300ms |
| 가용성 | 99.9% |
| 동시 접속자 | 10,000 |
| 활성 사용자 | 100,000/월 |
| 비용 | < $200/월 (활성 1만 기준) |

---

## 7. 외부 통합

| 외부 | 용도 | 등장 챕터 |
|------|------|-----------|
| 카카오 OAuth | 소셜 로그인 | Ch 66 |
| 구글 OAuth | 소셜 로그인 | Ch 66 |
| 카카오맵 / OSM | 지도 (Leaflet) | Ch 80 |
| AWS S3 | 사진 저장 | Ch 80, 113 |
| AWS Bedrock | LLM/Vision | Ch 87, 119 |
| Anthropic Claude | LLM (멀티 프로바이더 폴백) | Ch 86~ |
| Google Gemini | LLM (멀티 프로바이더 폴백) | Ch 86~ |
| LiveKit Cloud (또는 self-hosted) | WebRTC SFU | Ch 84 |
| Toss Payments (선택) | 후원 결제 | 외전 |

---

## 8. 데이터 시드 (강의 데모용)

각 챕터에서 사용할 시드 데이터셋:

- `seeds/cats.csv` — 고양이 100마리 샘플
- `seeds/reports.csv` — 제보 500건
- `seeds/regions.csv` — 한국 시군구 250개
- `seeds/photos/*.jpg` — 샘플 사진 50장 (CC0 라이선스)

`final-project/seeds/` 디렉토리에 통합 관리 (Ch 41 이후).

---

## 9. 라이선스 / 윤리

- 모든 시연 데이터는 **가상**이며 실제 길고양이 사진은 사용 시 출처/동의 표기
- AI 분석 결과는 **참고용**이며 실제 의료 판단은 수의사가 함 (UI에 면책 문구)
- 위치 정보는 **반경 100m 노이즈** 추가 (학대 우려 대응)
- 미성년자 정보 수집 X

---

> 이 사양은 살아있는 문서입니다. 챕터 진행하며 발견되는 도메인 디테일은 여기에 누적합니다.
