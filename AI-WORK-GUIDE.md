# AI 작업 가이드 — "고양이 자경단" 풀스택+AI 코스 강의 완성

> **목적**: 다른 AI 어시스턴트가 이 한 파일만 읽고 "작업 가이드 읽고 모두 완성해줘" 한 마디에 남은 모든 강의(현재 34/960 완료, 남은 926 H)를 표준 품질로 완성할 수 있게 만든 단일 진실원 (single source of truth).
>
> **대상 AI**: Claude·GPT·Gemini 등 코딩 에이전트. VS Code Copilot Chat, Cursor, Aider, Windsurf 등 도구 무관.
>
> **사용법**: 사용자가 "작업 가이드 읽고 모두 완성해줘"라고 하면 → 이 파일 처음부터 끝까지 읽고 → "워크플로 한 턴" 절차를 무한 반복.

---

## 0. 30초 요약 (TL;DR)

- **목표 산출물**: `chapters/<NNN>-<slug>/lecture/H{1..8}.md` 총 960개 강의 대본. 각 H = 한국어 60분 강의, **공백 제외 17,000자 이상** (🟢).
- **현재 상태**: 34/960 완료 (Ch001~Ch004 ✅, Ch005 H1·H2 ✅). 다음 작업 = **Ch005 H3**.
- **한 턴 = 한 H 작성**: stub 확인 → 풀 드래프트 작성 → `python3 scripts/wc-lecture.py` 측정 → 17,000 미만이면 미세 확장 → 🟢 도달 → 진행표·메모리 업데이트 → commit & push → 다음 H.
- **품질 기준**: 한국어, 강사가 마이크 앞에서 그대로 읽을 수 있는 대본 톤, "본인" 호칭, 고양이 자경단 도메인 비유, 회수(이전 챕터)·예고(다음 H) 포함.
- **commit 규칙**: GoGoComputer 이름 + `'...'` 단일 인용으로 zsh `!` 이스케이프 + 의미 있는 한 줄 + push origin main.

---

## 1. 프로젝트 큰 그림

### 1-1. 코스 명세

- **코스명**: "고양이 자경단" (오픈소스 길고양이 구조 커뮤니티 데모 사이트로 풀스택+AI+AWS를 전 부분 학습하는 취업 완성 코스)
- **타겟**: 신입~주니어 백/프/풀/AI/DevOps 전 영역. "이 코스만 들으면 취업" 목표.
- **분량**: 8학기 × 15챕터 = **120챕터**, 각 챕터 = 8H (1시간 강의 단위) = **960 강의**.
- **학습자 예상 시간**: 2년 (주 5시간 기준).
- **저장소**: `react-flask-ai-stack` (GitHub: GoGoComputer/react-flask-ai-stack, 로컬: `/Users/mo/DEV/devStudy/react-flask-ai-stack`).
- **데모 도메인**: 고양이 자경단 (openclaw 와는 다른 가상의 사이트, 길고양이 사진 등록·공유·구조 신호).
- **자경단 5명 페르소나** (모든 챕터 공통):
  - **본인** — 풀스택, 메인테이너, 모든 PR 1차 리뷰
  - **까미** — 백엔드 (Python/FastAPI), `/backend/` 소유
  - **노랭이** — 프론트 (React/TypeScript), `/frontend/` 소유
  - **미니** — 인프라 (AWS/Terraform/CI/CD), `/infra/`·`.github/` 소유
  - **깜장이** — 디자이너+QA (Figma), `/design/`·`/qa/` 소유

### 1-2. 챕터 맵 (반드시 확인)

`docs/CHAPTER-MATRIX.md`에 120챕터 전체 목록이 있어요. **반드시 챕터를 시작하기 전에 그 챕터의 정확한 주제를 확인**하세요. (실수 사례: Ch004는 "Git & GitHub"이지 "웹 프론트엔드"가 아님. HTML/CSS/JS는 Ch043~053.)

학기별 큰 묶음:
- S1 CS+Python기초 (Ch001~015)
- S2 Python심화+자료구조·알고리즘 (Ch016~030)
- S3 백엔드 기초 (Ch031~045)
- S4 프론트엔드 기초 (Ch046~060)
- S5 풀스택 통합 (Ch061~075)
- S6 AI/ML (Ch076~090)
- S7 AWS+DevOps (Ch091~105)
- S8 마무리/면접/포트폴리오 (Ch106~120)

(정확한 챕터 제목은 항상 `docs/CHAPTER-MATRIX.md` 또는 `chapters/` 폴더 이름에서 확인.)

### 1-3. 디렉토리 구조

```
react-flask-ai-stack/
├── AI-WORK-GUIDE.md              ← (이 파일)
├── README.md                     ← 사용자용 README
├── ARCHITECTURE.md               ← 시스템 아키텍처
├── chapters/
│   └── NNN-<kebab-slug>/         ← 예: 005-git-collab-workflow
│       ├── README.md             ← 챕터 개요 (종종 stub)
│       └── lecture/
│           ├── H1-orientation.md
│           ├── H2-concepts.md
│           ├── H3-setup.md
│           ├── H4-catalog.md
│           ├── H5-demo.md
│           ├── H6-management.md
│           ├── H7-internals.md
│           └── H8-apply-wrap.md
├── docs/
│   ├── CAT-VIGILANTE-SPEC.md     ← 도메인 명세 (자경단 사이트 기능 명세)
│   ├── CHAPTER-MATRIX.md         ← 120챕터 전체 매트릭스
│   ├── LECTURE-TEMPLATE.md       ← 강의 한 H 템플릿
│   ├── STYLE-GUIDE.md            ← 작성 톤·문체 가이드
│   └── WRITING-PROGRESS.md       ← ★ 진행표 (매 턴 갱신 필수) ★
└── scripts/
    └── wc-lecture.py             ← 분량 측정 헬퍼
```

---

## 2. 한 턴 워크플로 (필수 7단계)

각 턴(= 한 H 작성)은 정확히 다음 7단계를 따르세요. 절대 줄이거나 건너뛰지 마세요.

### 단계 1: 다음 H 확인

```bash
# 진행표 마지막 부분 확인
grep -A2 "다음 턴 즉시 할 일" docs/WRITING-PROGRESS.md
```

또는 `docs/WRITING-PROGRESS.md` 파일 끝의 "다음 턴 즉시 할 일" 섹션을 직접 읽기. 거기에 다음 작업이 명시돼 있어요 (예: "Ch 005 H3 신규 작성").

### 단계 2: 챕터·H 컨텍스트 수집

병렬로:
1. 해당 챕터 폴더 listing → stub 파일 확인
2. 같은 챕터의 이미 완성된 H들 빠르게 훑어 (어떤 회수·연결 필요한지)
3. `docs/CHAPTER-MATRIX.md`에서 그 챕터 주제 확정
4. 직전 H의 "다음 H 예고" 섹션 확인 (해당 H가 무엇을 다루기로 했는지)

### 단계 3: stub 제거 후 풀 드래프트 작성

stub 파일은 보통 38줄짜리 placeholder. **`create_file`은 기존 파일이 있으면 실패**하므로 먼저 삭제:

```bash
rm chapters/<NNN>-<slug>/lecture/<H>-<slot>.md
```

그 다음 `create_file`로 새로 작성. 첫 시도 목표 = **공백 제외 12,000~14,000자**. (한 번에 17,000을 만들면 좋지만 실패해도 OK — 다음 단계에서 보강.)

### 단계 4: 분량 측정

```bash
python3 scripts/wc-lecture.py chapters/<NNN>-<slug>/lecture/<H>-<slot>.md
```

출력 예: `🟡  14306  chapters/005-...`. 색깔 의미:
- 🟢 17,000~18,999 (합격)
- ✅ 19,000+ (목표)
- 🟡 10,000~16,999 (부족, 보강 필요)
- 🔴 <10,000 (대폭 보강 필요)

### 단계 5: 🟢 도달까지 미세 확장

`replace_string_in_file` 또는 `multi_replace_string_in_file`로 기존 문장에 자연스럽게 추가:

- 기존 문단 끝에 1~3문장 추가 (보충 설명·역사·자경단 적용·면접 팁)
- 또는 추신·FAQ 새 항목 추가
- 매번 측정 → 부족하면 또 추가

**중요 함정 (실전 학습)**:
- `replace_string_in_file`의 `oldString`은 반드시 **3줄 이상의 고유 컨텍스트**를 포함하세요. 너무 짧으면 부분 매치 → 텍스트 중복 버그 발생.
- `multi_replace_string_in_file`은 **정확히 2개 이상의 replacements 배열**이 필요. 1개만 보낼 거면 `replace_string_in_file` 사용.
- `multi_replace_string_in_file`의 한국어 newString은 큰따옴표 안의 백슬래시 이스케이프 정확해야 함. 실패하면 `replace_string_in_file`로 분리해서 시도.

### 단계 6: 진행표·메모리·기타 갱신

`docs/WRITING-PROGRESS.md` 갱신:
1. 해당 챕터 표에 새 H 행 추가 (또는 분량·상태 업데이트)
2. 챕터 합계 갱신 (합계 라인 있으면)
3. 챕터 마지막 H 완료 시 "**ChNNN 완료** ✅" 추가
4. 끝의 "다음 턴 즉시 할 일" 섹션을 **다음 H로 갱신** (이게 다음 턴의 진입점!)

`/memories/session/plan.md` line 7 갱신 (메모리 도구 있는 경우):
- 완료 H 추가, 다음 H 명시, N/960 비율 갱신

### 단계 7: commit + push

```bash
cd /Users/mo/DEV/devStudy/react-flask-ai-stack && \
git add -A && \
git -c user.name="GoGoComputer" -c user.email="gogo@local" \
  commit -m '<commit message>' && \
git push origin main 2>&1 | tail -5
```

**commit 메시지 양식**:
```
ChNNN H<n>: new 17k chars (<슬롯명> — <핵심 키워드 5~10개 ·로 구분>)
```

예시:
```
Ch005 H2: new 17k chars (핵심개념 — 세 패턴 깊이 + branch 모델 + release vs deploy + 환경 분리: GitHub Flow 5규칙·Git Flow 5종 branch·Trunk-based feature flag 5종·SemVer·환경 dev/staging/prod·자경단 8결정·오해8·FAQ7·추신14)
```

**zsh 함정**: 반드시 **단일 인용** `'...'`. 이중 인용은 `!`·`$`을 해석. 작은따옴표 안에 작은따옴표 필요하면 메시지에서 빼거나 백슬래시 이스케이프.

**push 거부 시**: 누군가 다른 환경에서 push한 경우 (mirror 워크플로 가능성). `git pull --rebase origin main && git push origin main`.

### 단계 8: task_complete 호출 (도구 있는 환경에서)

한 턴 = 한 H 완료가 원칙. 한 턴에 여러 H를 욕심내지 말 것 (토큰 budget 초과 위험).

---

## 3. 강의 한 H 작성 표준

### 3-1. 골격 (반드시 포함)

```markdown
# ChNNN · H<n> — <챕터 한국어명>: <H의 한 줄 부제>

> **이 H에서 얻을 것**
> - 항목 1
> - 항목 2
> - 항목 3
> - 항목 4

---

## 회수: <이전 H 또는 이전 챕터>의 ~에서 본 H의 ~로

(2~4문단. "지난 ~에서 본인이 X를 만났어요. 이번엔 Y를 ..." 톤.)

---

## 1. <첫 본론 섹션>
...
## 2. <두 번째 섹션>
...
(중략 — 보통 7~10개 본론 섹션. H의 슬롯에 따라 구성 다름)

---

## N. 자경단 적용 + 다음 H 예고

(자경단 5명 시나리오에 어떻게 적용되는지 + 다음 H에서 다룰 내용 예고)

---

## N+1. 흔한 오해 5~8가지

**오해 1: "..."** — (반박과 진실)
**오해 2: "..."** — ...

---

## N+2. FAQ 5~7가지

**Q1. ...?**
A. ...

---

## N+3. 추신

추신 1. (한 줄 격언/팁)
추신 2. ...
...
추신 12~15. (마지막 추신은 다음 H 예고 + 🐾 이모지)
```

### 3-2. 8H 슬롯의 표준 의미

H 번호별 슬롯은 챕터마다 약간 다르지만 **표준 패턴** (Ch001~Ch004의 검증된 흐름):

| H | 슬롯 | 무엇을 다루나 |
|---|------|------------|
| H1 | 오리엔 | 왜 이 챕터, 큰 그림, 8H 로드맵, 회수(이전 챕터)+예고 |
| H2 | 핵심개념 | 4~7개 핵심 단어/모델 깊이 |
| H3 | 환경점검 | 도구 설치·설정·환경 변수·확인 명령 |
| H4 | 카탈로그 | 명령어/API/도구 표 (15~25개) + 위험도 신호등 |
| H5 | 데모 | 30분짜리 손 시연 시나리오 (코드/터미널) ★ 챕터의 심장 |
| H6 | 운영/관리 | 운영 문제·대시보드·문화·코드 리뷰·문서 |
| H7 | 원리/내부 | 내부 동작·역사·알고리즘 깊이 |
| H8 | 적용+회고 | 자경단에 박아 넣기 + 다음 챕터 예고 + 회수 마무리 |

(챕터 주제에 맞게 슬롯을 살짝 변형해도 됨. 예: 운영 챕터에서 H6=대시보드, H7=장애 사례.)

### 3-3. 톤·문체 (`docs/STYLE-GUIDE.md` 참조)

- **호칭**: "본인"을 학습자 호칭으로 사용 (예: "본인이 PR을 만들면..."). 절대 "여러분"·"독자"·"개발자"라고 부르지 말 것.
- **존댓말**: "~예요·~해요·~하세요" 친근한 존댓말. 강사가 말하듯이.
- **고양이 자경단 도메인**: 비유·예시는 자경단 사이트로. 까미·노랭이·미니·깜장이 5명 페르소나 활용.
- **숫자·구체성**: "5명", "30분", "17,000자", "1초", "5년 차" 같은 구체 숫자가 추상적 설명보다 강함.
- **굵은 글씨**: 핵심 한 줄은 `**...**`. 한 섹션에 1~3개.
- **표·코드·이모지**: 표는 자주 (한 페이지 비교에 효과적). 코드 블록은 fenced. 이모지는 절제 (🟢🔴🐾 정도).
- **한 H 안에**: 다섯 묶음 패턴 (예: "5단계", "5가지", "5종 branch") 자주. 외우기 쉬움.

### 3-4. 분량 도달 비법

17,000자가 부족할 때 자연스럽게 늘리는 패턴:

1. **역사 문장 추가**: "(작가 본인이 2010년에 ~을 정리, 2020년에 갱신)"
2. **회사 사례**: "Google·Meta·Netflix는 ~"
3. **자경단 적용**: "본인의 자경단도 5년 후엔 ~"
4. **면접 팁**: "면접에서 자주 묻는 질문 — ..."
5. **함정 한 문장**: "다만 한 가지 함정 — ..."
6. **반복·요약**: "한 줄로 — ..." 식 압축 한 문장
7. **추신 새 항목**: "추신 N. ..."

**한 번의 micro-add는 평균 100~300자**. 17,000 - 현재 = 부족분을 평균 200으로 나누면 필요 횟수.

---

## 4. 진행 상태 (2026-04-28 기준)

### 4-1. 완료된 챕터 (32 H + 2 = 34/960 = 3.54%)

| 챕터 | H 완료 | 상태 |
|------|------|------|
| Ch001 컴퓨터 구조 기본 | 8/8 | ✅ |
| Ch002 운영체제 기본 | 8/8 | ✅ |
| Ch003 네트워크 기본 | 8/8 | ✅ |
| Ch004 Git & GitHub | 8/8 | ✅ |
| Ch005 Git 협업 워크플로우 | 2/8 (H1·H2) | 🚧 |

### 4-2. 다음 작업 (확정)

**Ch005 H3 신규 작성** (환경점검 — GitHub 팀·organization 셋업 + protected branch 7체크 + CODEOWNERS 깊이 + commitlint+husky)

직전 H들의 "다음 H 예고"가 가리키는 내용:
- GitHub organization·team 만들기·권한 분리
- branch protection rule 7체크 항목 깊이 (require PR·require review·require status check·require linear history·require signed commits·dismiss stale review·include administrators)
- CODEOWNERS 글로브 패턴·복수 owner OR/AND·.github/ 위치
- Conventional Commits + commitlint + husky pre-commit hook 셋업
- SSH 키·PAT vs SSH 비교

(이후 큐: H4 카탈로그 → H5 데모 → H6 운영 → H7 원리 → H8 적용)

---

## 5. 자주 만나는 함정 (실전 학습)

### 5-1. 도구 함정

- **`create_file` 실패** = 파일 이미 존재. `rm` 먼저.
- **`replace_string_in_file` 텍스트 중복 버그** = `oldString`이 너무 짧음. 항상 3+ 줄 컨텍스트.
- **`multi_replace_string_in_file` "must be array" 에러** = 1개만 전달. 1개면 `replace_string_in_file` 사용.
- **분량 측정 출력의 NoteSimplified 메시지**는 무시. 실제 출력만 사용.
- **터미널 한국어 깨짐**: macOS 기본 zsh + UTF-8이라 보통 OK. 깨지면 `echo $LANG` 확인.

### 5-2. git 함정

- **zsh `!` 이스케이프**: 반드시 `'...'` 단일 인용으로 commit 메시지 감싸기.
- **push 거부**: `git pull --rebase origin main && git push origin main`.
- **저자 정보**: 매번 `-c user.name="GoGoComputer" -c user.email="gogo@local"` 명시 (글로벌 설정 신뢰 X).

### 5-3. 챕터 주제 혼동

- **Ch004 = Git & GitHub** (웹 프론트엔드 아님!)
- **Ch043~053 = HTML/CSS/JS/DOM** (프론트엔드 기초)
- 항상 `docs/CHAPTER-MATRIX.md` 또는 폴더명으로 확인.

### 5-4. 분량 함정

- **17,000은 합격선, 19,000이 목표**. 첫 작성에서 17,000 정확히 맞추려 하지 말고 12,000~14,000으로 풀 드래프트 → 미세 보강이 안전.
- **공백 제외 한국어 글자 수 기준**. 영어·숫자·기호도 포함되지만 공백·줄바꿈은 제외. (`scripts/wc-lecture.py` 참조.)
- **너무 욕심내지 말 것**: 한 턴에 여러 H 만들면 토큰 부족으로 미완 상태로 잘림.

---

## 6. 한 턴 체크리스트 (복사해서 매 턴 사용)

```
[ ] 1. docs/WRITING-PROGRESS.md 읽고 다음 H 확인
[ ] 2. 챕터 폴더 listing + 같은 챕터 직전 H의 "다음 H 예고" 확인
[ ] 3. stub 삭제 (rm) + create_file로 풀 드래프트 (목표 12k~14k)
[ ] 4. python3 scripts/wc-lecture.py로 측정
[ ] 5. 17,000 미만이면 micro-add 반복 (replace_string_in_file)
[ ] 6. 🟢 도달 확인
[ ] 7. docs/WRITING-PROGRESS.md 갱신 (H 행 추가 + "다음 턴 즉시 할 일" 갱신)
[ ] 8. /memories/session/plan.md 갱신 (있으면)
[ ] 9. git add -A && commit (단일 인용 메시지) && push origin main
[ ] 10. 사용자에게 한 줄 보고 (분량·commit hash·다음 H)
```

---

## 7. "모두 완성해줘" 명령 받았을 때

사용자가 단순히 "**작업 가이드 읽고 모두 완성해줘**" 또는 비슷한 말을 했을 때:

1. **이 파일 처음부터 끝까지 읽기** (한 번만, 첫 턴에).
2. **`docs/WRITING-PROGRESS.md` 마지막 부분 확인** → 다음 H 파악.
3. **단계 1~10 (위 체크리스트) 한 턴 실행** = 한 H 완성.
4. **사용자에게 보고**: "ChNNN H<n> 완료 — <분량> 🟢 (commit <hash>). 다음 = ChNNN H<n+1>."
5. **task_complete 호출** (도구 환경이면).
6. 사용자가 "다음" 또는 "계속"이라고 말하면 단계 2부터 다시 (= 다음 H).

**한 턴 = 한 H가 원칙**. 토큰 budget이 매우 넉넉하다면 2~3 H를 한 턴에 시도해도 되지만, 안전한 기본은 1 H.

**자동 무한 모드**: 사용자가 "쉴 때까지 계속" 같이 명시적으로 자동 모드 요청하면 매 H 완료 후 보고 + 자동으로 다음 H 시작. 토큰이 떨어지거나 도구 에러가 반복되면 사용자에게 알림.

---

## 8. 품질 자가 체크 (한 H 작성 후)

작성한 H가 다음을 만족하는지 확인:

- [ ] 공백 제외 17,000자 이상 (🟢)
- [ ] 첫 줄 `# ChNNN · H<n> — <한국어 부제>` 형식
- [ ] "이 H에서 얻을 것" 4~6개 불릿
- [ ] 회수 섹션 (이전 H/챕터 연결)
- [ ] 본론 7~10개 번호 섹션
- [ ] 자경단 5명 페르소나 중 최소 2명 이상 등장
- [ ] 표 1개 이상 (한 페이지 비교)
- [ ] 코드 블록 1개 이상 (해당하는 챕터면)
- [ ] 흔한 오해 5~8개
- [ ] FAQ 5~7개
- [ ] 추신 12~15개 (마지막 추신은 다음 H 예고 + 🐾)
- [ ] "본인" 호칭 일관성
- [ ] 강사 대본 톤 (마이크 앞에서 그대로 읽기 가능)

---

## 9. 참고 파일 우선순위

이 파일 외에 추가로 읽을 만한 것 (필요시만):

1. **`docs/WRITING-PROGRESS.md`** — 매 턴 필수.
2. **`docs/CHAPTER-MATRIX.md`** — 새 챕터 시작 시 주제 확인.
3. **이미 완성된 H 파일** (특히 같은 챕터의 직전 H) — 톤·연결·예고 확인.
4. **`docs/LECTURE-TEMPLATE.md`** — 슬롯별 가이드 (있으면).
5. **`docs/STYLE-GUIDE.md`** — 톤 헷갈릴 때.
6. **`docs/CAT-VIGILANTE-SPEC.md`** — 자경단 도메인 명세.
7. **`scripts/wc-lecture.py`** — 측정 헬퍼 코드 (수정 불필요).

---

## 10. 마지막 한 마디

이 코스는 한 사람이 평생 한 번 만드는 **취업 완성 풀스택 코스**. 한 H가 학습자 한 시간이고, 학습자 한 시간이 그의 5년 후 무게. **한 H의 17,000자가 한 사람의 5년**. 

작성자(AI)는 매 턴 한 H를 정성껏. 욕심내서 여러 H를 한 턴에 흔들리게 만들지 말고, 한 턴 한 H를 단단히. 한 H 한 H가 쌓이면 960이 어느 날 도달해요.

**다음 H를 시작하세요. 🐾**

---

## 부록: 명령어 치트시트

```bash
# 진행 상태 확인
cat docs/WRITING-PROGRESS.md | tail -10

# 다음 작업할 챕터 폴더 listing
ls chapters/005-git-collab-workflow/lecture/

# stub 삭제
rm chapters/005-git-collab-workflow/lecture/H3-setup.md

# 분량 측정
python3 scripts/wc-lecture.py chapters/005-git-collab-workflow/lecture/H3-setup.md

# 전체 분량 일괄 측정
python3 scripts/wc-lecture.py --all | tail -20

# commit + push (한 줄)
git add -A && git -c user.name="GoGoComputer" -c user.email="gogo@local" commit -m 'ChNNN Hn: new 17k chars (...)' && git push origin main 2>&1 | tail -5

# push 거부 시
git pull --rebase origin main && git push origin main

# 최근 commit 5개 확인
git log --oneline -5
```
