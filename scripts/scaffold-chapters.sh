#!/usr/bin/env bash
# scaffold-chapters.sh — 120 챕터 폴더 + lecture/H1~H8 stub 파일 일괄 생성
# Usage: bash scripts/scaffold-chapters.sh
# Idempotent: 이미 존재하는 파일은 건드리지 않음.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHAPTERS_DIR="$ROOT/chapters"

# 120 챕터 메타: "NNN|slug|title|sem"
read -r -d '' CHAPTERS <<'EOF' || true
001|cs-computer-architecture|컴퓨터 구조 기본|S1
002|cs-os-basics|운영체제 기본|S1
003|cs-network-basics|네트워크 기본|S1
004|git-github-basics|Git & GitHub 기본|S1
005|git-collab-workflow|Git 협업 워크플로|S1
006|terminal-bash|터미널·셸·Bash|S1
007|python-intro-1-types|Python 입문 1 — 변수·자료형·연산자|S1
008|python-intro-2-controlflow|Python 입문 2 — 제어흐름|S1
009|python-intro-3-functions|Python 입문 3 — 함수·스코프|S1
010|python-intro-4-collections|Python 입문 4 — list/tuple/dict/set|S1
011|python-intro-5-strings-regex|Python 입문 5 — 문자열·정규식|S1
012|python-intro-6-io-exceptions|Python 입문 6 — 파일 I/O·예외|S1
013|python-intro-7-modules|Python 입문 7 — 모듈·패키지·import|S1
014|python-intro-8-venv-pip|Python 입문 8 — venv·pip·pyproject|S1
015|cs-python-cli-budget|CS+Python 통합 — CLI 가계부|S1
016|python-oop-1-class|Python OOP 1 — class·dunder|S2
017|python-oop-2-inheritance|Python OOP 2 — 상속·dataclass·ABC|S2
018|python-stdlib-1-time-path-json|표준라이브러리 1 — datetime·pathlib·json|S2
019|python-stdlib-2-collections-itertools|표준라이브러리 2 — collections·itertools·functools|S2
020|python-typing|타입힌트 끝까지 — typing/Generic/Protocol|S2
021|python-exceptions-logging|예외 설계 + logging|S2
022|python-pytest|pytest — fixture/parametrize/mock|S2
023|python-decorators-context|데코레이터·컨텍스트매니저|S2
024|python-generators|제너레이터·이터레이터|S2
025|python-async|비동기 — async/await/asyncio|S2
026|ds-array-list-stack-queue-hash|자료구조 1 — 배열·리스트·스택·큐·해시|S2
027|ds-tree-heap-graph-trie|자료구조 2 — 트리·힙·그래프·트라이|S2
028|algo-sort-search-twopointer|알고리즘 1 — 정렬·이분·투포인터|S2
029|algo-recursion-dp-bfs-dfs|알고리즘 2 — 재귀·DP·BFS/DFS|S2
030|coding-test-30|코딩테스트 실전 30문제|S2
031|db-overview|DB 개론 — 관계형 vs NoSQL·ACID·정규화|S3
032|mysql-docker-oneliner|Docker로 MySQL 한 줄 (블랙박스)|S3
033|sql-intro|SQL 입문 — SELECT/WHERE/ORDER/LIMIT|S3
034|sql-joins|JOIN 끝까지|S3
035|sql-aggregate-subquery-cte|집계·서브쿼리·CTE|S3
036|sql-window-functions|윈도우함수|S3
037|sql-index-basics|인덱스 1 — B-Tree·복합·커버링|S3
038|sql-explain-tuning|실행계획·튜닝·N+1|S3
039|sql-transactions-isolation|트랜잭션·격리수준·MVCC|S3
040|sql-locks-deadlock|락·데드락·동시성|S3
041|db-modeling-cat-vigilante|DB 모델링 — 자경단 ERD|S3
042|nosql-redis-intro|NoSQL + Redis 기초|S3
043|html5-a11y|HTML5 + 접근성|S4
044|css-basics|CSS 기초 — 박스/플렉스/그리드|S4
045|css-advanced-responsive|CSS 심화 — 반응형·애니메이션|S4
046|js-1-types-scope|JavaScript 1 — 타입·스코프·호이스팅|S4
047|docker-deepdive|Docker 본격 — 이미지·네트워크·Compose|S4
048|js-2-functions-closure|JavaScript 2 — 함수·클로저·this|S4
049|js-3-prototype-class-modules|JavaScript 3 — 프로토타입·class·모듈|S4
050|js-4-eventloop-promise-async|JavaScript 4 — 이벤트루프·Promise·async|S4
051|ts-1-basics|TypeScript 1 — 타입·인터페이스·제네릭|S4
052|ts-2-utility-tsconfig|TypeScript 2 — 유틸리티·tsconfig|S4
053|dom-fetch-webapi|DOM·Fetch·Web API|S4
054|build-tools-vite|빌드 도구 — Vite·esbuild|S4
055|vanilla-ts-cat-cards|JS+TS 미니 — 바닐라 TS 고양이 카드|S4
056|backend-dev-env|백엔드 개발환경 — Compose·Make·.env|S5
057|flask-1-first-app|Flask 1 — 첫 앱·라우팅|S5
058|flask-2-blueprint-factory|Flask 2 — Blueprint·Factory·Config|S5
059|sqlalchemy-2-models|SQLAlchemy 2 — 모델·세션·관계|S5
060|sqlalchemy-loading-n1|SQLAlchemy 로딩전략·N+1|S5
061|flask-migrate-alembic|Flask-Migrate·Alembic|S5
062|rest-api-design|REST API 설계|S5
063|serialization-validation|직렬화·검증 — marshmallow/pydantic|S5
064|openapi-docs|OpenAPI 자동 문서화|S5
065|oauth2-1-flow|OAuth2 1 — Authorization Code + PKCE|S5
066|oauth2-2-kakao-google|OAuth2 2 — 카카오/구글/네이버|S5
067|jwt-session-csrf|JWT·세션·쿠키·CSRF|S5
068|rbac-permissions|RBAC·권한 매트릭스|S5
069|owasp-top10|보안 OWASP Top 10|S5
070|backend-integration-cat-report|백엔드 통합 — 제보 API 완성|S5
071|react-1-components|React 1 — 컴포넌트·JSX·props·state|S6
072|react-2-hooks|React 2 — Hooks 정확히|S6
073|react-3-router|React 3 — Router v6 + 보호된 라우트|S6
074|tailwind-design-system|TailwindCSS + 디자인 시스템|S6
075|state-management-compare|상태관리 — Zustand/Context/Redux|S6
076|tanstack-query|TanStack Query — 서버 상태|S6
077|forms-rhf-zod|폼 — react-hook-form + zod|S6
078|frontend-performance|성능 — 코드스플리팅·메모·Lighthouse|S6
079|a11y-i18n-seo|접근성·i18n·SEO|S6
080|cat-report-leaflet-s3|제보 UI — Leaflet + S3 Presigned|S6
081|sse-realtime|SSE 실시간 푸시|S6
082|socketio-chat|Socket.IO 자경단 채팅|S6
083|stateful-to-serverless-bridge|stateful↔serverless 다리 — API GW WebSocket·AppSync|S6
084|webrtc-livekit|WebRTC + LiveKit 라이브|S6
085|webpush-pwa|웹푸시 + PWA|S6
086|llm-basics|LLM 기초 — 토큰·컨텍스트·temperature|S7
087|multi-provider-abstraction|멀티프로바이더 추상화 — Claude/Gemini/GPT/Bedrock|S7
088|prompt-engineering|프롬프트 엔지니어링|S7
089|context-engineering|컨텍스트 엔지니어링·prompt caching|S7
090|agent-loop-tool-calling|Agent Loop & Tool Calling|S7
091|agent-memory-subagent|멀티턴 메모리·sub-agent·plan/act|S7
092|mcp-1-basics|MCP 1 — 개념·서버·클라이언트|S7
093|mcp-2-cat-vigilante-server|MCP 2 — 자경단 MCP 서버 구현|S7
094|agent-harness-engineering|Agent Harness 엔지니어링|S7
095|streaming-cost-ratelimit|스트리밍·비용·레이트리밋|S7
096|guardrails-moderation|가드레일·moderation·jailbreak 방어|S7
097|rag-1-basics|RAG 1 — 청킹·임베딩·pgvector|S7
098|rag-2-hybrid-graphrag|RAG 2 — hybrid·reranking·GraphRAG|S7
099|vision-multimodal|Vision Multimodal — 사진 분석·매칭|S7
100|voice-realtime-agent|음성 — Whisper/TTS·실시간 음성 Agent|S7
101|finetuning-lora|Fine-tuning — LoRA/QLoRA·언제 vs RAG vs prompt|S7
102|llm-eval-observability|LLM Eval & Observability|S7
103|mlops-llm-safety|MLOps for LLM + AI Safety|S7
104|aws-intro-well-architected|AWS 입문 + Well-Architected 6 Pillars|S8
105|aws-iam-deep|IAM 깊이 + GitHub Actions OIDC|S8
106|aws-vpc-networking|VPC·네트워킹 끝까지|S8
107|aws-lb-dns-cdn|ALB/NLB·Route53·ACM·CloudFront|S8
108|aws-ec2-deep|EC2 깊이 + Auto Scaling|S8
109|aws-ecs-fargate-eks|ECS Fargate + EKS 개요 + App Runner|S8
110|aws-lambda-apigw-eventbridge|Lambda + API Gateway(WebSocket) + EventBridge|S8
111|aws-rds-aurora-migration|RDS·Aurora — 로컬 MySQL 무중단 이전|S8
112|aws-dynamodb|DynamoDB|S8
113|aws-s3-storage-fullset|S3·EFS·Glacier 풀세트|S8
114|aws-sqs-sns-kinesis|SQS·SNS·Kinesis 이벤트 드리븐|S8
115|aws-security-kms-secrets-waf|KMS·Secrets·WAF·GuardDuty·Security Hub|S8
116|aws-observability|CloudWatch·X-Ray·Athena·OpenSearch|S8
117|terraform-iac|Terraform 깊이 + CDK 비교|S8
118|cicd-github-actions-oidc|CI/CD — GitHub Actions OIDC·blue-green·카나리|S8
119|aws-ai-stack-bedrock|Bedrock·SageMaker·Bedrock Agents|S8
120|advanced-architecture-job-prep|고급 아키텍처 + 취업 준비|S8
EOF

# H1~H8 슬롯 메타 (일반 챕터 기본값; 챕터별 override는 추후)
declare -a HSLOTS=(
  "H1-orientation|오리엔테이션 — 왜 배우나"
  "H2-concepts|핵심 개념 4개"
  "H3-setup|환경/설치"
  "H4-catalog|기본 카탈로그"
  "H5-demo|첫 실전 데모"
  "H6-management|보관·관리"
  "H7-internals|안심하고 쓰는 원리"
  "H8-apply-wrap|적용 + 회고 + 다음 예고"
)

mkdir -p "$CHAPTERS_DIR"

count_created=0
count_skipped=0

while IFS='|' read -r num slug title sem; do
  [ -z "${num:-}" ] && continue
  ch_dir="$CHAPTERS_DIR/${num}-${slug}"
  mkdir -p "$ch_dir"/{start,finish,notes,lecture}

  # 챕터 README
  ch_readme="$ch_dir/README.md"
  if [ ! -f "$ch_readme" ]; then
    cat > "$ch_readme" <<EOF_README
# Ch ${num} · ${title}

> 학기: **${sem}** · 강의 시간: **8교시 × 60분 = 8시간** · 학습 권장: **2주**

---

## 🎯 학습 목표

- [ ] {목표 1}
- [ ] {목표 2}
- [ ] {목표 3}
- [ ] {목표 4}
- [ ] {목표 5}

## ✅ 완료 체크리스트

- [ ] H1~H8 강의 시청/음독
- [ ] start/ → finish/ 코드 실습
- [ ] exercises.md 3문제 풀이
- [ ] 음독 시뮬레이션 60분 ± 5분 (대본 작성자용)
- [ ] 다음 챕터 H1 회수 멘트와 연결되는지 확인

## 📂 폴더

- \`start/\` — 시작 코드
- \`finish/\` — 완성 코드
- \`exercises.md\` — 연습 문제
- \`notes/\` — 다이어그램·면접 Q&A·트러블슈팅
- \`lecture/\` — 8교시 강의 대본 (H1~H8)

## 🔗 연결

- ⬅ 이전: ${num/#0/}번 - 1
- ➡ 다음: ${num/#0/}번 + 1
- 📋 매트릭스: [docs/CHAPTER-MATRIX.md](../../docs/CHAPTER-MATRIX.md)
- 🎙 대본 템플릿: [docs/LECTURE-TEMPLATE.md](../../docs/LECTURE-TEMPLATE.md)

## 🛠 산출물

- {이 챕터에서 만들 것}
EOF_README
    count_created=$((count_created+1))
  else
    count_skipped=$((count_skipped+1))
  fi

  # exercises.md
  ex_file="$ch_dir/exercises.md"
  if [ ! -f "$ex_file" ]; then
    cat > "$ex_file" <<EOF_EX
# Ch ${num} · 연습 문제

## 🟢 쉬움
> {문제 1}

<details><summary>정답 보기</summary>

\`\`\`
{정답}
\`\`\`
</details>

## 🟡 중간
> {문제 2}

<details><summary>정답 보기</summary>

\`\`\`
{정답}
\`\`\`
</details>

## 🔴 어려움
> {문제 3}

<details><summary>정답 보기</summary>

\`\`\`
{정답}
\`\`\`
</details>
EOF_EX
  fi

  # lecture/README.md (마스터 목차)
  lec_readme="$ch_dir/lecture/README.md"
  if [ ! -f "$lec_readme" ]; then
    {
      echo "# Ch ${num} · ${title} — 강의 대본 (8교시)"
      echo ""
      echo "> 강사용 마스터 목차. 각 H 파일은 60분 분량의 발화 대본."
      echo ""
      echo "## 8교시 시간표"
      echo ""
      echo "| 교시 | 파일 | 부제 |"
      echo "|------|------|------|"
      for slot in "${HSLOTS[@]}"; do
        IFS='|' read -r fname subtitle <<< "$slot"
        echo "| ${fname%%-*} | [${fname}.md](${fname}.md) | ${subtitle} |"
      done
      echo ""
      echo "## 강사 사전 준비"
      echo ""
      echo "- {준비물 1}"
      echo "- {준비물 2}"
      echo ""
      echo "## 진행 팁"
      echo ""
      echo "- {팁 1}"
      echo "- {팁 2}"
      echo ""
      echo "📖 톤·길이 규약: [docs/STYLE-GUIDE.md](../../../docs/STYLE-GUIDE.md)"
    } > "$lec_readme"
  fi

  # H1~H8 stub
  for slot in "${HSLOTS[@]}"; do
    IFS='|' read -r fname subtitle <<< "$slot"
    h_file="$ch_dir/lecture/${fname}.md"
    h_num="${fname%%-*}"
    if [ ! -f "$h_file" ]; then
      cat > "$h_file" <<EOF_H
# ${h_num} · ${title} — ${subtitle}

> 고양이 자경단 · Ch ${num} · ${h_num#H}교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

- TODO: 10~20개 소제목

---

## 🔧 강사용 명령어 한눈에

> TODO: 본문과 1:1 매칭되는 수동 시연 명령

---

## 1. 들어가며

TODO: 지난 시간 회수 + 오늘 약속 + 목표 한 문장.

## 2. {본문}

TODO: 본문 — [LECTURE-TEMPLATE.md](../../../docs/LECTURE-TEMPLATE.md) 참조.

분량 기준: **순수 발화 19,000~21,000자** (공백 제외).

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - TODO: 정확한 파일 경로/함수/트레이드오프
> - TODO: 디자인 결정 이유
> - TODO: 실무 베스트 프랙티스
> - TODO: 디버깅 팁
> - TODO: 참고 링크
EOF_H
    fi
  done

done <<< "$CHAPTERS"

echo "✅ Scaffold complete."
echo "  Chapter READMEs created: $count_created"
echo "  Chapter READMEs skipped (already existed): $count_skipped"
echo ""
echo "Counts:"
find "$CHAPTERS_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | awk '{print "  Chapters:", $1}'
find "$CHAPTERS_DIR" -name "H?-*.md" | wc -l | awk '{print "  Lecture stubs (H1~H8):", $1}'
