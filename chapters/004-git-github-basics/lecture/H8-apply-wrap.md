# Ch004 · H8 — 자경단 적용 + 챕터 마무리: 30분 종합 셋업과 다섯 원리

> **이 H에서 얻을 것**
> - 본인의 자경단 저장소를 회사 저장소처럼 셋업하는 **30분 종합 실습** (10단계).
> - Ch004의 **다섯 원리** 한 페이지 정리.
> - **12회수 지도** (Ch005~Ch120 어디서 다시 만나나) + Ch005(협업 워크플로우) 예고.
> - 우선순위(Must/Should/Could) + 비용표 + 흔한 오해 7 + FAQ 7 + 추신.

---

## 회수: H1~H7의 일곱 시간을 한 줄로

여덟 H의 마지막 시간이에요. 본인이 이번 챕터에서 만난 git의 일곱 얼굴을 한 줄씩 떠올려 보세요. **H1**(오리엔)에선 git을 사진앨범+타임머신+분산 백업+협업 도구 네 일을 한 도구로 보았고, **H2**(핵심개념4)에선 commit·branch·remote·HEAD 네 단어와 객체 그래프(blob·tree·commit) Merkle DAG을 보았고, **H3**(환경점검)에선 macOS 3길 설치와 7줄 config·SSH 키·.gitignore 5부류로 본인의 머신을 길들였고, **H4**(카탈로그)에선 23개 명령어를 6무리로 묶고 신호등 🟢🟡🔴으로 위험도를 가늠했고, **H5**(데모)에선 빈 폴더에서 git init부터 PR까지 30분 흐름을 두드렸고, **H6**(운영)에선 Issue·PR·Project·Discussions·Actions·Pages 6도구로 회사 저장소처럼 운영했고, **H7**(내부동작)에선 .git/objects 4종 객체와 SHA-1·zlib·packfile delta로 내장을 들여다봤어요.

일곱 시간이 본인의 머릿속에 **하나의 git 그림**을 그려요. 표면(명령어 23개) → 운영(도구 6개) → 내부(객체 4종). 위에서 아래로 깊어지는 세 층. 이 세 층이 한 머릿속에 다 들어 있는 사람이 5년 차예요. 본인이 신입일 때 한 챕터로 이 세 층을 다 건드린 거예요. **시간을 절약**한 거예요. 일하면서 5년에 걸쳐 천천히 쌓일 그림을 8시간으로 압축. 압축의 대가는 한 번에 다 안 들어와요. 그래서 H8에서 한 번 더 묶어 줘요.

이번 H8은 **본인의 자경단 저장소를 진짜 회사 저장소처럼 만드는 30분**이에요. 일곱 H에서 배운 모든 게 손가락 끝으로 모이는 시간. 30분 후 본인의 저장소는 **신입 개발자가 clone해서 한 줄도 안 두드려 보지 않아도 무엇을 어떻게 해야 할지 다 적혀 있는 저장소**가 돼요. 회사가 본인을 뽑을 때 본인의 GitHub 프로필 첫 화면에 이 저장소가 떠 있다면 — 면접관은 5분 안에 "이 사람은 협업할 줄 안다"를 판단해요. **저장소 한 개가 이력서 한 줄보다 강해요**.

**왜 30분인가** — 본인이 한 자리에서 끊김 없이 끝낼 수 있는 시간. 더 길면 중간에 끊겨요. 더 짧으면 한두 가지를 빠뜨려요. 30분은 본인이 커피 한 잔 들고 한 번에 끝낼 수 있는 길이. 그리고 본인이 1년 후에 새 저장소를 또 만들 때 — 같은 30분으로 같은 셋업을 다시 박을 수 있어요. **반복 가능한 30분**이 5년 차의 자산. 본인이 회사를 옮기든 새 사이드 프로젝트를 시작하든, 같은 30분 한 장으로 모든 저장소가 같은 품질에서 시작해요. 30분이 평생.

**또 한 가지 — 본인이 단계 1~10을 순서 그대로 따르세요.** 순서가 의미가 있어요. config 먼저 안 박으면 commit author가 잘못 박혀서 나중에 amend 잔치. .gitignore 먼저 안 박으면 비밀이 첫 commit에 들어가서 history rewrite 사고. 단계 1~2가 단단해야 단계 3~10이 매끈히. **순서가 깨지면 사고가 시작**돼요. 30분이 60분이 되는 가장 흔한 이유는 순서를 안 지킨 것. 본인이 신입일 때 한 번 외우면 평생 자동.

---

## 1. 30분 종합 셋업 — 10단계 한 줄씩

### 단계 1 (3분) — `git config` 7줄 (H3 회수)

본인 자경단 저장소 폴더(`~/code/cat-vigilante`)로 이동 후 **저장소 로컬 config 7줄**:

```bash
cd ~/code/cat-vigilante
git config user.name "GoGoComputer"
git config user.email "you@cat-vigilante.org"   # 회사·도메인용 이메일
git config init.defaultBranch main
git config pull.rebase true
git config push.autoSetupRemote true
git config rerere.enabled true
git config core.autocrlf input                  # macOS·Linux용
```

**왜 로컬?** 자경단 commit의 author email을 회사·프로젝트별로 분리하기 위해. `~/.gitconfig`(global)는 본인 개인 commit용. 자경단 폴더 안에서만 다른 email로 박혀요. **5년 차의 다중 정체성** — git은 폴더별로 다른 사람이 될 수 있어요.

### 단계 2 (3분) — `.gitignore` 5부류 보강

`gitignore.io` API 한 줄로 보일러플레이트 받기:

```bash
curl -sL "https://www.toptal.com/developers/gitignore/api/macos,linux,windows,visualstudiocode,node,python" > .gitignore
```

여기에 **자경단 도메인 5부류**를 추가:

```
# 비밀 — 절대 커밋 금지
.env
.env.*
*.pem
secrets/
config/credentials.yml

# 빌드·캐시
node_modules/
__pycache__/
.next/
dist/
*.log

# OS·에디터 (위에서 받음)
# 의존성 (위에서 받음)

# 자경단 도메인
uploads/cats/*.jpg          # 회원 업로드 — Git LFS 또는 S3로
uploads/cats/.gitkeep       # 단, 빈 폴더 유지용 .gitkeep은 추적

# 본인 작업 임시
TODO-mine.md
scratch/
```

`git add .gitignore && git commit -m 'chore: setup gitignore for cat-vigilante'`. **첫 commit 전에 .gitignore가 있어야** 비밀이 안 들어가요. H5에서 외운 황금 규칙.

### 단계 3 (5분) — branch protection (GitHub Settings)

브라우저로 `Settings → Branches → Add rule` 가서 `main`에 7체크:

1. ☑ Require pull request before merging (1+ approvals)
2. ☑ Dismiss stale approvals on new commits
3. ☑ Require review from Code Owners
4. ☑ Require status checks (CI 초록)
5. ☑ Require branches to be up to date
6. ☑ Require conversation resolution
7. ☑ Do not allow bypassing (관리자도 따름)

**가장 중요한 건 7번** — 본인이 관리자라도 본인 규칙을 어길 수 없게. 그래야 5년 차에 새벽 3시에 졸리며 force-push 한 번을 본인 손으로 막아요. **본인의 미래를 본인 현재가 보호**하는 한 칸.

### 단계 4 (3분) — `CODEOWNERS` 한 장

`.github/CODEOWNERS` 파일 만들기 (H6 회수):

```
# 모든 파일의 기본 리뷰어
*                    @GoGoComputer

# 백엔드는 백엔드팀
/backend/            @GoGoComputer @cat-vigilante/backend

# 프론트엔드는 프론트팀
/frontend/           @GoGoComputer @cat-vigilante/frontend

# 인프라·CI는 신중
/.github/            @GoGoComputer
/infra/              @GoGoComputer
*.tf                 @GoGoComputer

# 보안 민감
/auth/               @GoGoComputer @cat-vigilante/security
*.env.example        @GoGoComputer
```

**5년 차 자경단 활동** — 본인이 모든 PR을 다 보지 않아도 됩니다. CODEOWNERS가 자동으로 적합한 사람을 부르니까. 본인은 본인 영역만. 시간이 절약돼요. 그리고 GitHub UI에서 PR 우측에 자동으로 리뷰어가 붙어서 새 멤버가 "누구한테 리뷰 받아야 하지?"를 안 물어봐요.

### 단계 5 (3분) — Issue·PR 템플릿

`.github/ISSUE_TEMPLATE/bug.yml`:

```yaml
name: 🐛 버그 신고
description: 자경단 사이트에서 발견한 버그
labels: ["type:bug", "status:triage"]
body:
  - type: textarea
    attributes:
      label: 무엇이 잘못됐나요
      placeholder: "고양이 사진 업로드 시 500 에러"
    validations:
      required: true
  - type: textarea
    attributes:
      label: 재현 절차
      placeholder: "1. 로그인 → 2. 업로드 클릭 → 3. ..."
  - type: dropdown
    attributes:
      label: 영향 범위
      options: ["나만", "일부 사용자", "모든 사용자"]
```

`.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## 무엇을 바꿨나요
<!-- 한 문장 요약 -->

## 왜
<!-- Issue 링크: closes #123 -->

## 어떻게 검증했나요
- [ ] 로컬 `npm test` 초록
- [ ] 수동 시나리오 (로그인 → 업로드 → 확인)
- [ ] 스크린샷 첨부 (UI 변경 시)

## 체크리스트
- [ ] Conventional Commits prefix 적용
- [ ] 새 환경변수는 `.env.example`에 반영
- [ ] 문서·README 업데이트 (필요 시)
```

**왜 템플릿?** 본인이 매번 빈 박스 앞에서 고민할 필요가 없어요. 손가락이 자동으로 채울 칸을 알아요. **반복 작업의 인지 비용 0**으로. 그리고 새 멤버가 와도 본인이 옆에서 가르치지 않아도 됩니다 — 템플릿이 가르쳐요. **저장소가 직접 사람을 가르쳐요.**

### 단계 6 (3분) — Conventional Commits + commitlint

`.commitlintrc.json`:

```json
{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "type-enum": [2, "always", [
      "feat", "fix", "docs", "chore", "refactor",
      "test", "style", "perf", "ci", "build"
    ]],
    "subject-case": [0]
  }
}
```

설치 + husky 연결:

```bash
npm i -D @commitlint/cli @commitlint/config-conventional husky
npx husky init
echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg
```

이제 본인이 `git commit -m "fix bug"` 두드리면 거부. `git commit -m "fix: cat upload 500 error"`처럼 prefix가 있어야 통과. **자동 강제**가 사람의 뇌를 절약해요. 본인이 "이번 commit은 feat인가 fix인가"만 결정하고, 나머진 도구가 끌고 가요.

### 단계 7 (3분) — pre-commit hook (AWS 키 차단)

`.husky/pre-commit`:

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# 1. 변경된 파일 가져오기
files=$(git diff --cached --name-only --diff-filter=ACM)

# 2. AWS 키 패턴 검색
if echo "$files" | xargs grep -lE "AKIA[0-9A-Z]{16}" 2>/dev/null; then
  echo "❌ AWS Access Key 발견 — commit 차단"
  exit 1
fi

# 3. 큰 파일(5MB+) 차단
for f in $files; do
  size=$(wc -c < "$f" 2>/dev/null || echo 0)
  if [ "$size" -gt 5242880 ]; then
    echo "❌ $f 가 5MB를 초과 — Git LFS를 쓰세요"
    exit 1
  fi
done

# 4. lint·format
npx --no lint-staged
```

`chmod +x .husky/pre-commit`. 이 30줄짜리 hook 한 장이 본인의 평생 사고 80%를 차단해요. **30줄이 30년**. 가성비 가장 좋은 30줄.

### 단계 8 (3분) — 5문서 (README·CONTRIBUTING·CODE_OF_CONDUCT·SECURITY·LICENSE)

루트에 5개 파일:

- **README.md** — 자경단 한 줄 소개 + 빠른 시작 5줄(`clone → npm install → cp .env.example .env → npm run dev → http://localhost:3000`) + 폴더 구조 한 그림 + 기여 안내 한 줄("CONTRIBUTING.md 참고") + 라이선스 배지.
- **CONTRIBUTING.md** — 기여 절차(이슈 만들기 → fork → 브랜치 → PR → 리뷰 → squash 머지) + 코딩 스타일(prettier·black) + 테스트 방법.
- **CODE_OF_CONDUCT.md** — Contributor Covenant 표준 (한국어 번역 있음). 한 줄도 본인이 안 적어도 돼요. 표준 그대로 복사.
- **SECURITY.md** — 보안 취약점 신고 채널(이메일·private issue). 공개 이슈로 올리지 말라는 한 줄 경고.
- **LICENSE** — MIT(가장 자유) 또는 Apache 2.0(특허 보호). 자경단 같은 커뮤니티 도구는 MIT 추천.

**5문서가 다 있는 저장소는 신뢰가 자동으로 생겨요.** 본인이 한 줄도 안 보고도 "여긴 진지한 프로젝트구나"가 느껴져요. 첫인상의 80%. GitHub은 5문서 다 있는 저장소엔 "Community Standards 100%" 뱃지를 자동으로 줘요. 면접관이 5초 안에 봐요.

### 단계 9 (3분) — GitHub Actions CI 한 장

`.github/workflows/ci.yml`:

```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm test
```

push·PR마다 자동 실행. branch protection에서 "Require status checks" 켜 뒀으니 CI 빨강이면 머지 자체가 막혀요. **자동으로 막힘**이 5년 차의 평화. 본인이 졸려도 코드가 본인을 지켜요.

### 단계 10 (1분) — 첫 PR 자체로 만들기

이 모든 변경을 **PR 한 개로** 본인 main에 머지. 자기 자신에게 PR 만들어 본인이 리뷰. 어색해 보여도 5년 차 동료들도 다 해요. **자기 리뷰가 두 번째 눈**. 30분 동안 박은 셋업 한 장이 한 번에 main에 안착. 이게 본인 자경단 저장소의 v0.1.0. `git tag v0.1.0 && git push origin v0.1.0`.

**자기 PR을 만드는 5가지 이유** — (1) PR 본문에 이 30분 셋업의 의도를 적어 두면 6개월 후 본인이 다시 봐도 "왜 이렇게 했지"가 안 됨, (2) 동료가 새로 합류하면 PR #1을 보면 본인이 어떤 기준으로 셋업했는지 한눈에, (3) CI 한 장이 PR에서 처음 돌아가서 셋업이 잘 됐는지 검증, (4) 본인이 PR 본문 쓰는 손가락 리듬을 첫날부터 익힘, (5) 첫 squash merge로 main의 첫 commit이 깔끔히 한 줄. **첫 PR이 첫 commit보다 중요**. main에 직접 commit하지 않는 습관이 30분 셋업의 마지막 마침표.

**v0.1.0 태그의 의미** — 본인의 자경단이 처음 "버전"을 가진 순간. semantic versioning(major.minor.patch) 0.1.0은 "개발 중·기능 1". 0.x.x는 안정 전. 1.0.0이 첫 안정 release. 자경단의 v1.0.0은 본인이 첫 사용자에게 사이트를 보여 줄 때. 그날까지의 모든 release는 0.x.x. 매주 0.1.0 → 0.2.0 → 0.3.0으로 올라가면서 본인의 진보가 태그로 박혀요. **태그가 본인의 일기장**. 1년 후 `git tag --list`로 본인의 한 해를 한눈에.

**30분 종합 셋업 끝.** 본인의 저장소는 이제 회사 저장소예요. 본인이 5년 차 동료의 저장소 옆에 본인 저장소를 놔도 부끄럽지 않아요. 같은 셋업, 같은 품질, 같은 신뢰. 신입과 5년 차의 차이가 코드 품질이 아니라 **저장소 품질**에서 먼저 나타나요. 본인은 8시간으로 그 격차를 좁혔어요.

---

## 2. Ch004의 다섯 원리 한 페이지

여덟 H를 가로지르는 다섯 원리. 본인이 5년 후에도 잊지 않을 다섯 줄.

**원리 1 — 분산 (Distributed).** git은 중앙 서버가 죽어도 본인의 .git/이 풀 백업. 모든 clone이 모든 history를 가져요. SVN이 죽으면 회사가 마비되지만 GitHub이 죽어도 본인 노트북은 온전. **단일 장애점이 없음**이 git의 첫째 원리. H1·H2.

**원리 2 — 콘텐츠 주소 (Content-addressable).** 모든 객체가 SHA-1으로 키. 같은 내용이면 같은 sha. 자동 중복 제거. 변경 감지가 O(1). 무결성 검증이 자동. H7. **데이터의 정체성이 이름이 아니라 내용**이라는 발상.

**원리 3 — 불변성 + 추가만 (Immutable + append-only).** 한 번 만든 commit은 안 바뀌어요. rebase·amend는 새 commit을 만들고 ref만 갱신. **객체는 안 사라짐**. 그래서 reflog로 90일 복구가 가능. H2·H7.

**원리 4 — 분리 (Separation).** 데이터(objects)와 이름표(refs)의 분리. 가지를 만든다는 건 종이 한 장 더 적는 것. 책을 복사하지 않아요. 41바이트가 새 기능의 무게. H7. **무거운 데이터 + 가벼운 포인터**의 패턴은 git만의 게 아니에요 — 데이터베이스·파일시스템·OS 어디서나 만나요.

**원리 5 — 자동화 + 신호등 (Automation + traffic-lights).** 23개 명령어 중 매일 6개·주1~2 7개·1년 8개의 리듬. 위험한 건 빨강(force-push·reset --hard·history rewrite). hook·CI·branch protection이 본인의 사고를 자동 차단. **사람의 신중함 + 기계의 자동화**가 함께. H4·H6·H7.

**다섯 원리는 5년 후에도 그대로**예요. 명령어는 변할 수 있고 GitHub UI는 변할 수 있지만 이 다섯 원리는 git이 살아 있는 한 안 변해요. 본인이 평생 의지할 다섯 줄.

**다섯 원리가 git만의 게 아니에요** — 분산은 분산 시스템(Cassandra·Kafka)의 원리. 콘텐츠 주소는 IPFS·Docker 이미지의 원리. 불변성은 함수형 프로그래밍·블록체인의 원리. 분리는 데이터베이스·OS·네트워크의 원리. 자동화는 모든 인프라의 원리. **본인이 git에서 익힌 다섯 원리는 컴퓨터 과학의 다섯 기둥**. Ch041(모노레포)에서 분리·자동화를 다시, Ch080(인프라)에서 분산·자동화를 다시, Ch103(AI 배포)에서 콘텐츠 주소(모델 hash)·불변성(MLflow run id)을 다시 만나요. **git을 깊이 본 사람은 시스템 디자인이 깊어요**. Ch120(시스템 디자인 면접)에서 본인이 이 다섯 원리를 다시 꺼내 쓸 거예요. 8시간이 5년이에요.

---

## 3. 12회수 지도 — Ch005~Ch120 어디서 다시 만나나

본 챕터에서 익힌 것이 어디서 다시 등장하나, 미리 박아 두는 좌표 12개:

| 챕터 | 무엇을 회수 |
|------|----------|
| **Ch005** | 협업 워크플로우 — GitHub Flow vs Git Flow vs Trunk-based, 본인 자경단에 적용 |
| **Ch006** | 코드 리뷰 문화 — 리뷰 5톤 깊이·async vs sync 리뷰·time-zone 협업 |
| **Ch014** | 패키지 관리 + monorepo — npm·pnpm·yarn·git submodule vs subtree |
| **Ch020** | Python 패키징 — `pyproject.toml`, semantic versioning, git tag 기반 release |
| **Ch022** | 알고리즘 면접 — git bisect를 이진 탐색의 실전 예로 |
| **Ch041** | 모노레포 + 큰 저장소 — Git LFS, partial clone, sparse-checkout, history rewrite (BFG·filter-repo) |
| **Ch062** | 백엔드 배포 — git tag 기반 release, CHANGELOG 자동 생성, semantic-release |
| **Ch070** | API 게이트웨이 — gitops 워크플로우 (선언적 설정 → git → 자동 적용) |
| **Ch080** | 인프라 자동화 — Terraform·Pulumi의 git 기반 PR 검토 |
| **Ch103** | AI 배포 — 모델 버전 관리, MLflow + git, DVC(data version control) |
| **Ch118** | DevOps 종합 — GitOps(ArgoCD·Flux), trunk-based + feature flag |
| **Ch120** | 면접 + 이력서 — GitHub 프로필이 이력서, contribution graph, 자경단 저장소 자체가 포트폴리오 |

12개 챕터에서 본인이 H7의 4종 객체·H4의 23명령·H6의 PR 운영을 다시 만나요. 본인이 처음 만났을 땐 추상이지만 다시 만날 때마다 살이 붙어요. **나선형 학습** — 같은 개념이 점점 깊어지면서 다시 와요. 본인이 5년 후 Ch118(GitOps)에 도달했을 때 "아 이거 Ch004 H7에서 봤지"라며 미소를 지을 거예요. 그게 좋은 코스의 모양.
**회수 권장 순서** — 12챕터를 다 먼저 읽으려 하지 마세요. 경험이 쌓이기 전엔 추상이라 흔적이 안 남아요. 차라리 차례대로, Ch005·Ch006·Ch014·Ch020 순으로 진행하면서 그때그때 이 H8에 보이는 표를 돌아봐 "아 여기서 회수 예고했던 그 개념이구나"가 시각화돼요. **회수는 일을 하며 돌아볼 때 가치 발생**. 지도는 않아서 읽는 게 아니라 일하며 다시 펼쳐 보는 거예요.
---

## 4. Ch005(협업 워크플로우) 예고 — 다음 챕터로 가는 다리

다음 챕터 Ch005는 **본인이 혼자가 아닌 팀에서 git을 쓰는 방법**이에요. 본 챕터가 git 자체였다면 Ch005는 **git × 사람들**. 세 가지 협업 패턴 — **GitHub Flow**(가장 단순, 1 main + feature branch + PR), **Git Flow**(complex, develop·release·hotfix branch), **Trunk-based**(Google·Meta 표준, main에 매우 자주 머지 + feature flag). 본인의 자경단엔 GitHub Flow가 정답. 회사 입사 후엔 셋 다 만나요.

또 Ch005에선 **세 가지 충돌의 깊이**를 봐요 — (1) 코드 충돌(같은 줄), (2) 의도 충돌(같은 기능을 두 사람이 다르게), (3) 사회적 충돌(리뷰 톤·머지 권한). 도구로 푸는 건 (1)뿐. (2)·(3)은 사람으로 풀어요. **5년 차의 일은 (2)·(3)이 90%**예요. (1)은 git이 알아서.

그리고 **CI/CD의 첫 등장** — Ch005에서 본인의 자경단에 GitHub Actions 5단계(lint → test → build → deploy preview → deploy prod)를 박아요. H8 단계 9에서 박은 한 장이 다섯 단계로 펼쳐져요. **이번 H8이 Ch005의 씨앗**이에요.

**Ch005가 Ch004와 다른 점** — 본 챕터는 "git을 알도록 만들기". 다음 챕터는 "git으로 일하도록 만들기". 알았다 != 쓴다. 본인이 23개 명령어를 다 알아도 동료 5명과 1주일 같이 일해 보지 않으면 git이 회사에서 어떻게 굴러가는지는 못 느껴요. **일해 본 사람만 아는 게 있어요** — PR이 1주일 멈춰 있을 때의 답답함, 리뷰어가 잠수중일 때의 초조, conflict가 주말에 쌓일 때의 일요일 출근의 도전. 그건 코드도 회사에서만. Ch005가 최대한 재현해 보아요.

---

## 5. 우선순위 — Must / Should / Could

본 챕터에서 본인이 절대·되도록·가능하면 챙길 것을 세 단으로:

**MUST (절대 — 첫 주에)**:
- `git config` 7줄 (H3)
- `.gitignore` 5부류 + 비밀 절대 commit 안 하기 (H3·H5)
- 매일 6개 명령어 손가락 리듬 (H4)
- branch protection 7체크 + main 직접 push 금지 (H6)
- `git pull --rebase` 기본값 (H3)

**SHOULD (되도록 — 첫 달에)**:
- SSH 키 + GPG/SSH 서명 commit (H3)
- pre-commit hook (AWS 키·큰 파일 차단) (H7)
- Conventional Commits + commitlint (H6·H8)
- 5문서(README·CONTRIBUTING·CODE_OF_CONDUCT·SECURITY·LICENSE) (H6·H8)
- CI 한 장(GitHub Actions lint·test) (H8)

**COULD (가능하면 — 첫 해에)**:
- CODEOWNERS + Issue/PR 템플릿 (H6·H8)
- Project 보드 + Discussions (H6)
- `git bisect`·`git blame`·`reflog` 응급실 도구 (H7)
- `git rebase -i` squash·reword (H4)
- Git LFS (큰 파일) (Ch041에서 깊이)

**Must 5개를 첫 주에 박지 않으면** 자경단 저장소가 시작부터 흐트러져요. Should 5개는 첫 달에 박으면 두고두고 회수. Could 5개는 1년 동안 천천히. **3단의 시간 축**이 5년 차의 우선순위 감각이에요.

**왜 3단으로 나누나** — 한 번에 다 박으려 하면 본인이 지쳐요. 첫 주에 15개를 박으려 하면 첫 주에 끝나요(코드 한 줄도 안 쓰고). 그래서 첫 주에는 Must 5개만, 하루 한 개씩 천천히. 그 후 쓰면서 "아 hook 하나 있으면 편하겠다"라고 느낀 순간 Should로 올라가요. 쓰다 보면 자연스럽게 올라가요. **필요함이 도구를 부르게**, 도구가 필요함을 만들지 않게. 이게 테크 도입의 황금규칙. 처음부터 다 박은 저장소는 보통 됨 달 후엔 더 이상 코드가 안 올라가요(셋업만 되고 코드는 없음). **도구는 일의 아래에**.

---

## 6. 비용표 — 어디에 시간·돈이 드나

| 항목 | 시간 | 돈 | 한 줄 평가 |
|------|------|-----|----------|
| Git 본체 | 0 | 0 (오픈소스) | 무한 가성비 |
| GitHub 개인 계정 | 5분 | 0 (무료) | 가입 즉시 |
| GitHub Pro | 0 | $4/월 | 개인은 보통 무료로도 충분 |
| GitHub Team | 0 | $4/사용자/월 | 자경단 5명: $20/월 |
| GitHub Enterprise | 0 | $21/사용자/월 | 50명+ 회사용 |
| GitHub Actions | 셋업 30분 | 무료 2,000분/월 (Public 무제한) | 자경단 무료로 충분 |
| Git LFS | 셋업 10분 | 1GB 무료, $5/월/50GB | 큰 파일 있으면 |
| Codespaces | 셋업 5분 | 60시간 무료/월 | 브라우저로 코딩 |
| 본인의 시간(셋업) | 30분 | 0 | 평생 1회 |
| 본인의 시간(매일) | 5~10분 | 0 | 손가락 리듬 |

**핵심** — 자경단 같은 오픈소스는 **거의 무료**. 회사 저장소는 사용자당 월 $4~$21. 5년 차 회사가 본인에게 주는 1년 비용 ~$50~$250 — 본인의 1주 임금보다 작아요. **GitHub은 가장 저렴한 인프라**. 본인이 회사를 옮겨도 본인의 GitHub 프로필은 그대로 따라가요. **이력서가 자동 갱신되는 가장 싼 도구**.

**숨은 비용 한 가지** — 본인의 시간. 표의 서울 30분은 평생 1회이지만, 매일 5~10분(손가락 리듬)은 평생 매일. 5년이면 약 200~400시간. **시간이 가장 비싼 비용**이지만 git이 본인에게 주는 감가1·협업 자산은 그 200시간을 수백 배로 돌려줘요. ROI가 최소 수십 배. 다른 어떤 투자도 이 볐이 안 와요.

**한 가지 주의** — GitHub Free도 충분하지만, 본인이 비공개 저장소에 협업자를 4명+ 추가하면 Pro 권장. Free는 협업자 3명까지 제한. 혀심한 고대신 자경단이 멠버 5명+ 되면 Pro $4/월이 필요. 다만 자경단은 대개 공개 저장소라 무료 무제한. **공개 저장소의 핀±자 하나 이 가격 구조**에서 나와요.

---

## 7. 흔한 오해 7가지

**오해 1: "git을 하루 만에 마스터할 수 있어요."** — 못 해요. 8시간 코스(본 챕터)는 큰 그림. 진짜 git은 5년 동안 사고를 만나면서 익혀요. 본인이 force-push로 동료 코드 한 번 날려 보면 평생 안 잊어요. **사고가 가장 좋은 선생님**. 다만 사고를 작게 만드는 게 본 챕터의 목적. "하루 마스터"는 마케팅 문구. **기술은 시간과 사고가 만들어요**, 강의가 만드는 게 아니에요. 강의는 시작을 만드는 거니 본인이 오늘 시작하면 되고, 마스터는 5년 뒤에 자연스럽게.

**오해 2: "GitHub만 쓰면 되지 GitLab·Bitbucket 안 봐도 돼요."** — 도구는 다 비슷해요. GitHub이 표준이지만 회사가 GitLab을 쓰면 GitLab. UI만 다르고 본질(branch protection·PR·CI)은 같아요. 본인이 GitHub을 마스터하면 다른 곳에 가도 1주 안에 적응. **개념은 도구를 초월**.

**오해 3: "혼자 쓰는 사이드 프로젝트는 git 안 써도 돼요."** — 더 써야 해요. 6개월 후 본인이 본인 코드를 봐도 "이거 누가 썼지?"가 돼요. git log가 본인 자신과의 대화. 그리고 노트북 갈아끼울 때 GitHub에 있어야 안 잃어요. **혼자 쓸수록 git이 더 필요**.

**오해 4: "force-push는 절대 쓰면 안 돼요."** — 상황에 따라. 본인의 feature branch에 본인 혼자 작업 중이면 `git push --force-with-lease`로 history 정리는 일상. 다만 main이나 동료 공유 브랜치에선 절대. **맥락 의존적 빨강**. force vs force-with-lease 차이를 H7에서 봤어요.

**오해 5: "commit은 자주 작게 만들어야 해요."** — 반은 맞아요. 작업 중간엔 자주 commit(WIP). PR 머지 시엔 squash로 한 개 commit으로 묶어요. **로컬은 자주, 원격은 정리**. 5년 차의 commit 미학.

**오해 6: "commit 메시지는 짧을수록 좋아요."** — 한 줄(50자) 제목 + 빈 줄 + 본문(72자 wrap). 본문에 **왜**(why)를 적어요. 1년 후 본인이 "왜 이렇게 짰지?"를 묻을 때 본문이 답. 짧음이 미덕이지만 0은 아니에요. **제목 50자 + 본문 본인의 미래**.

**오해 7: "git의 모든 명령어를 외워야 해요."** — H4의 매일 6개·주1~2 7개·1년 8개의 리듬으로 충분. 23개. 그 외 100개 옵션은 검색해서 그때그때. **외워야 할 건 6개·기억해야 할 건 23개·검색할 건 무한**. 손가락 메모리는 6개에만. 5년 차도 매일 두드리는 건 그 6개.

**보너스 오해: "git은 프로만 쓰는 도구예요."** — 원고지·논문·레시피·일기·감상 노트 모두 git으로 관리 가능. 텍스트 파일이면 뭐든지. 본인의 일기도 git으로 관리하면 5년 전 하루와 오늘 하루의 차이가 한 눈에. **git은 쓰기의 도구**이기도 해요. 이 공부 노트도 지금 git에 담겼있어요. 본인도 한 권으로.

---

## 8. FAQ 7가지

**Q1. 본 챕터가 너무 많아요. 어디서부터 다시 봐야 하나요?**
A. (1) H4(명령어 카탈로그) 23개 표를 출력해서 책상 앞에 붙여 두세요. (2) H5(데모)를 본인이 손으로 한 번 더 따라 두드려 보세요(40~60분). (3) H8(이번 H)의 30분 셋업을 본인 자경단 저장소에 적용. 이 셋이 본인이 1주일 안에 할 일. 나머지 H1·H2·H3·H6·H7은 한 달에 걸쳐 천천히 다시. 순서가 중요 — 손을 먼저 움직이고 머리는 나중에. 손이 모르는 지식은 평생 모르는 지식. 머리만 아는 건 면접 속의 지식.

**Q2. 회사에 가면 GitHub이 아니라 GitLab을 쓸 수도 있다는데, GitHub 배운 게 헛수고인가요?**
A. 90% 그대로 쓰여요. PR이 GitLab에선 MR(Merge Request)이라는 이름만 다를 뿐 본질 동일. branch protection·CODEOWNERS·CI/CD 다 있어요. 본인이 GitHub에서 익힌 패턴이 GitLab에서도 1주 안에 손에 익어요. **개념은 보편, 도구는 변형**.

**Q3. 자경단 저장소를 처음 만드는데, 처음부터 30분 셋업을 다 해야 하나요?**
A. 안 해도 돼요. 처음엔 `git init` + `.gitignore` + first commit만. 협업자가 1명 추가될 때 README + CONTRIBUTING. 협업자 3명이 되면 branch protection + CODEOWNERS. 협업자 5명+ 면 CI + 템플릿. **저장소는 사람과 함께 자라요**. 처음부터 다 박아 두면 무거워서 시작이 안 돼요.

**Q4. force-push 한 번 잘못 쳐서 동료 commit 한 시간치를 날렸어요. 어떻게 복구하나요?**
A. 동료의 노트북에서 `git reflog`로 sha 찾아서 `git push origin <sha>:main --force-with-lease`. 동료의 .git/objects엔 그 commit이 살아 있어요. **분산 git의 자동 백업**. 패닉 금지. 다만 5분 안에 동료에게 알리고, 향후 force-push 전 동료 알림 + branch protection 활성화. **사고 하나로 시스템 한 칸**을 강화.

**Q5. 본인이 자경단 외에 회사 코드를 같은 노트북에서 다룰 때 author email을 어떻게 분리하나요?**
A. 단계 1의 로컬 config로 폴더별 분리. 또는 `~/.gitconfig`에 `includeIf "gitdir:~/work/"` 블록으로 회사 폴더 안에선 자동으로 회사 email. 본인이 어느 폴더에 있냐만으로 정체성이 바뀌어요. **5년 차의 다중 정체성**.

**Q6. GitHub 프로필 contribution graph가 비어 보여요. 어떻게 채우나요?**
A. (1) 자경단 같은 본인의 사이드 프로젝트에 매일 작은 commit 한 개. (2) 다른 오픈소스에 typo 수정 PR. (3) 본인의 학습 노트도 GitHub 저장소로 — 본 챕터처럼. 단, **남에게 보이려고 가짜 commit 만들지 마세요**. 면접관이 commit 내용을 1초 안에 봐요. 의미 있는 commit 1개가 의미 없는 100개보다 강해요.

**Q7. 본 챕터를 다 끝냈는데 git을 쓰는 게 여전히 무서워요.**
A. 정상이에요. 8시간 코스 후에도 무서운 게 정상. 본인이 사고를 한 번도 안 만났으니까. 1주일 동안 자경단 저장소에 매일 commit + push하면서 손에 익히고, 1달 후 사고 한 번 만나서 reflog로 복구해 보면 — 그 후엔 안 무서워요. **사고가 무서움을 풀어 줘요**. 그리고 본인 옆에 5년 차 동료 한 명 — 사고 시 30초 안에 답을 줘요. **혼자 무서워하지 마세요**.
**보너스 Q: 본인이 git을 잘 쓰는지 자가 진단할 방법?**
A. 체크리스트 6줄 — (1) 하루 한 번 이상 commit을 하나요? (2) commit 메시지가 prefix와 본문을 갖추나요? (3) main에 직접 push하지 않고 PR으로 머지나요? (4) 동료 코드에 리뷰 5톤(칭찬·질문·제안·요청·nit) 쓰나요? (5) 사고 시 reflog·ORIG_HEAD를 떠올리나요? (6) 1주일 후 본인 commit 메시지를 다시 봤을 때 "왜 이렇게 했지"가 안 나오나요? 6줄 중 4줄+ ✅이면 본인은 지금 충분해요. 1~3줄이면 1년 더 쓰며 자연스럽게 올라와요.
---

## 9. 추신

추신 1. 본 챕터의 본질 한 줄 — git은 **분산 + 콘텐츠 주소 + 불변성 + 분리 + 자동화** 다섯 원리의 도구. 21년 동안 안 변한 다섯 원리. 본인이 평생 의지할 다섯 줄. 이 다섯 줄은 git의 이야기만이 아니라 소프트웨어 엔지니어링의 다섯 줄이기도.

추신 2. 본인이 자경단 저장소를 30분 셋업한 후, 그 저장소가 본인의 이력서가 돼요. 면접관이 5분 안에 봐요. **30분이 5년의 평판**. 코드 한 줄보다 README 한 장·CONTRIBUTING 한 장이 면접관의 첫 인상을 더 많이 만들어요. 코드는 재능을 보여 주고, 문서는 **함께 일하는 능력**을 보여 줘요. 회사가 찾는 건 후자.

추신 3. 5문서(README·CONTRIBUTING·CODE_OF_CONDUCT·SECURITY·LICENSE)는 본인이 한 줄도 안 쓴 게 더 신뢰. 표준 그대로 복사. **표준의 힘**. Contributor Covenant·MIT 라이선스는 어철수없이 표준. 본인이 창의를 부릴 데가 아니에요. **창의는 핵심에 남겨 두세요**.

추신 4. branch protection 7체크는 본인의 미래를 본인 현재가 보호하는 한 칸. 새벽 3시 졸린 본인을 새벽 0시 정신 멀줦한 본인이 막아 줘요. 본인이 관리자이든 아니든, **귀칙 앞엔 명이 평등**. 이 사실 하나가 5년 동안 본인의 큰 사고 몇 개를 아예 안 만나게 해 줘요.

추신 5. CODEOWNERS는 본인이 모든 PR을 안 봐도 되게 해 주는 한 장. 본인 시간을 시간으로 절약. 그리고 새 멤버가 와도 "누구에게 리뷰 받아야 하지?"를 안 물어봐요. 저장소가 스스로 답을 주니까.

추신 6. Conventional Commits는 본인의 commit 메시지를 자동 분류. 1년 후 CHANGELOG 자동 생성. **prefix 한 단어가 1년의 정리**. semantic-release 같은 도구가 prefix를 읽어 버전까지 자동 올려 줘요. 본인이 손 대지 않아도.

추신 7. pre-commit hook 30줄이 평생 사고 80% 차단. 가성비 가장 좋은 30줄. 본인의 자경단 저장소에 한 장만 박아 두면 이후 본인이 종종 졵 상태에서도 AWS키·큰 파일·링트 주안이 자동으로. **졵릴 때도 안전**한 저장소.

추신 8. 매일 6개 명령어(status·diff·add·commit·pull --rebase·push)가 본인의 손가락 리듬. 5년 후에도 그 6개. **단순함이 평생**. 본인이 5년 차 동료 막 압으로 쓰는 명령어도 똑같은 6개예요. 다른 명령어는 손이 떨어져 느려져요. **손의 속도는 단순함에서 나와요.**

추신 9. force-push 대신 `--force-with-lease`. 평생 force-with-lease만. 본인의 동료를 살리는 11글자. 손가락에 귀림과자 alias `git config --global alias.fwl 'push --force-with-lease'`. 이제 `git fwl`. 4글자. 더 안전.

추신 10. 12회수 지도(Ch005·006·014·020·022·041·062·070·080·103·118·120) — 본 챕터가 어디서 다시 자라나는지. 5년 후 본인이 만날 좌표 12개. 그 좌표를 돌아 봤을 때 본 챕터가 다시 살아나요. 읽은 게 아니라 **원입되었다**고 느껴요.

추신 11. 다음 Ch005는 **GitHub Flow vs Git Flow vs Trunk-based** 세 패턴 + 충돌 3깊이(코드·의도·사회) + CI/CD 5단계. 본 챕터의 자연스러운 연장. **함께 일하는 기술을 함께 익힌 수 있는 곳**은 몇 안 돼요. 회사가 그래서 귀해요.

추신 12. **본 챕터 Ch004의 마지막 추신** — git을 본 사람과 안 본 사람의 차이는 명령어가 아니라 **태도**예요. git을 본 사람은 사고를 만나도 침착하고, 동료의 코드를 존중하고, 본인의 history를 정직하게 적어요. **도구가 사람을 만들어요**. 본인이 8시간 동안 git을 익히면서 사실은 5년 차 개발자의 태도를 익힌 거예요. 그 태도가 본인의 평생 자산. **명령어는 잊혀도 태도는 남아요.** 본인의 5년 차 평판은 commit 메시지 한 줄, PR 리뷰 한 줄로 만들어져요. 한 줄 한 줄이 모여 본인의 평판. 그래서 한 줄을 적을 때마다 5년 뒤의 본인을 돌보세요.

추신 13. 본인이 자경단을 떠나도, GitHub에 push한 모든 commit은 평생 인터넷에 남아요. 본인의 이름과 함께. **분산 git의 영원성** — 본인의 활동이 영원해요. 그래서 매 commit이 작은 비석. 작게 자주 정성껏. 본인이 졵을 때 "난 코드로 세상에 뭐 남겼나"를 물어 보면 GitHub contribution graph가 답이에요.

추신 14. Ch005에서 만나요. 본 챕터 Ch004의 일곱 시간이 끝났어요. 본인이 git의 표면(명령어) → 운영(도구) → 내부(객체)를 한 챕터로 다 만났어요. 다음 챕터에선 사람들과 함께. 더 깊고 더 인간적인 시간이 기다려요. **절반 완성이에요** — 8챕터(8개 시간 추적: H1→H8)을 끝냈다면 git 기둥 한 개 완성. 이제 협업 기둥 Ch005→Ch006으로. 120챕터 중 이제 4/120 = 3.33% 완주. 하나씩 차근차근. 🐾

추신 15. **마지막 한 줄** — 본인이 오늘 자경단 저장소에 첫 commit을 박으세요. 한 줄짜리 README라도. 그 commit이 본인 5년 자경단 활동의 첫 걸음. 5년 후 `git log --reverse`로 본인의 첫 commit을 다시 봤을 때 미소가 나오게. **시작이 가장 어려운 일**. 오늘이 그 시작. 한 번 commit하면 두 번째 commit이 쉬워져요. 그리고 세 번째부터는 습관. **세 번의 commit이 습관을 만들어요.** 오늘이 첫 번째. 내일이 두 번째. 모레가 세 번째. 그 후 평생. 본인을 진심으로 응원해요. Ch005에서 만나요. 🐾
