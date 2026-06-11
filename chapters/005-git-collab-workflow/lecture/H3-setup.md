# Ch005 · H3 — 자경단 GitHub 30분 셋업 — Organization·Team·Protection·CODEOWNERS

> 고양이 자경단 · Ch 005 · 3교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속
2. 30분 셋업 — 8단추의 그림
3. 첫 단추 — Organization 만들기
4. 둘째 단추 — Team으로 5명 묶기
5. 셋째 단추 — Repository 권한 5단계
6. 넷째 단추 — Branch Protection 7체크
7. 다섯째 단추 — CODEOWNERS
8. 여섯째 단추 — Conventional Commits + commitlint
9. 일곱째 단추 — husky pre-commit hooks
10. 여덟째 단추 — SSH 키와 토큰 종류
11. 자경단 셋업 체크리스트 10단계
12. 흔한 오해 다섯 가지
13. 자주 받는 질문 다섯 가지
14. 마무리 — 다음 H4에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 자경단 GitHub 환경을 코드로 — 강사 시연용
gh org list                                         # Organization 목록
gh api orgs/cat-vigilante/teams                     # team 5개 확인
ssh-keygen -t ed25519 -C "bonin@example.com"        # SSH 키 생성
gh ssh-key add ~/.ssh/id_ed25519.pub                # GitHub에 SSH 키 등록
gh api -X PUT repos/:owner/:repo/branches/main/protection ...  # main 보호 규칙
npx husky init && echo "npm run lint" > .husky/pre-commit       # pre-commit hook
npm i -D @commitlint/{cli,config-conventional}      # 커밋 메시지 검증
git commit -m "feat: 고양이 사진 업로드 추가"        # Conventional Commits
```

이 한 화면이 오늘 60분의 지도예요. 자경단 5명이 사고 없이 일하는 GitHub 환경 — Organization·Team·권한·Protection·CODEOWNERS·commitlint·husky·SSH — 이 여덟 단추가 이 명령들 안에 다 들어 있어요. 강사는 위에서 아래로 한 번 훑고 시작하면 돼요. **클릭이 아니라 코드로 거는 게 핵심** — 그래야 다음 프로젝트에 재사용할 수 있어요.

---

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠.

지난 H2를 한 줄로 회수할게요. 세 워크플로우 패턴 깊이. GitHub Flow가 자경단 표준. release vs deploy 분리. dev/staging/prod 환경 분리.

이번 H3는 자경단의 GitHub 환경을 30분에 박는 시간이에요. Organization, Team, Protection, CODEOWNERS, 그리고 husky까지.

H1에서 "왜", H2에서 "개념"을 봤다면, H3는 "도구"예요. 개념(branch protection·CODEOWNERS)이 오늘 실제 화면의 체크박스와 파일로 손에 잡혀요. 그래서 오늘은 머리가 아니라 손의 시간이에요 — 가능하면 본인 저장소를 띄워 놓고 같이 클릭하며 들으세요. 읽기만 한 셋업과 한 번 해 본 셋업은 두 해 후 손의 속도가 달라요. 오늘 한 번 해 두면, 두 해 후 새 회사 첫날 같은 화면 앞에서 손이 먼저 움직여요.

오늘의 약속. **본인이 자경단 5명이 사고 없이 일할 수 있는 GitHub 환경을 30분에 셋업합니다**.

한 가지 미리. 오늘 단어가 많아요 — Organization, Team, protection, CODEOWNERS, commitlint, husky, SSH. 다 외우려 마세요. 오늘은 "여덟 단추가 있고, 각 단추가 무슨 사고를 막나" 한 줄씩만 손에 쥐면 충분해요. 그리고 가장 좋은 건 본인 저장소를 띄워 놓고 같이 클릭하는 거예요 — 한 번 해 본 셋업은 평생 손에 남아요. 자, 가요.

---

## 2. 30분 셋업 — 8단추의 그림

본격 시작 전 그림 한 장. 30분에 본인이 받을 8단추.

1. Organization (5분)
2. Team (3분)
3. Repository 권한 (3분)
4. Branch Protection (5분)
5. CODEOWNERS (3분)
6. Conventional Commits (3분)
7. husky (5분)
8. SSH/Token (3분)

여덟 단추가 자경단 5명의 매일 안전벨트.

여덟 단추를 두 묶음으로 보면 외우기 쉬워요. 앞 다섯(Organization·Team·권한·Protection·CODEOWNERS)은 **"누가 무엇을 할 수 있나"**의 구조예요 — 조직과 권한과 보호. 뒤 셋(Conventional Commits·husky·SSH)은 **"어떻게 안전하게 일하나"**의 도구예요 — 형식·검증·인증. 앞은 GitHub 설정(클릭/api), 뒤는 코드 저장소 안의 파일이에요. 이 여덟이 H1의 "사람의 합의 + 도구의 강제"를 실제로 구현한 거예요. 합의 문서(WORKFLOW.md)는 H8에서 쓰고, 강제(이 여덟 단추)는 오늘 박아요. 30분이 다섯 명의 1년을 받쳐요.

한 가지 숫자로 못 박을게요. 이 30분 셋업이 막는 것 — main 사고(평균 5시간), 리뷰 누락 버그(평균 며칠), 비밀 유출(평균 폐기+재발급 반나절), 온보딩 반복 설명(새 멤버마다 1시간). 1년이면 수십 시간을 막아요. 30분 투자로 수십 시간 절약, ROI 수십 배예요. 그리고 이 셋업은 다섯 명이 함께 쓰니, 한 본인의 30분이 다섯 명의 1년을 받쳐요. **협업 셋업의 ROI는 늘 "인원 × 기간"으로 곱해져요.** 그게 혼자 일과 함께 일의 결정적 차이예요. 혼자면 본인 30분이 본인을 돕지만, 다섯이면 본인 30분이 다섯을 도와요.

---

## 3. 첫 단추 — Organization 만들기

본인 GitHub 계정에 로그인. 우상단 + 클릭 → New Organization.

```
이름: cat-vigilante
plan: Free
이메일: bonin@example.com
```

3분이면 끝. cat-vigilante라는 Organization이 생겼어요.

왜 Organization을 쓰나? 개인 계정의 한계 — repository를 다른 사람과 공유할 수 없어요. Organization은 회사처럼 운영. 5명이 한 곳에 모여요.

자경단 표준 — 모든 협업 프로젝트는 Organization.

Organization 안엔 개인 계정엔 없는 것들이 있어요 — team(권한 묶음), 멤버 관리, audit log(누가 뭘 했나 기록), SSO 연동, 결제 통합. 그래서 회사는 거의 다 Organization으로 운영해요. 그리고 저장소를 한 사람 개인 계정에 두면, 그 사람이 떠나면 저장소도 함께 묶여 곤란해질 수 있어요(소유권이 개인에 묶임). Organization에 두면 저장소가 조직 자산이 돼서, 멤버가 바뀌어도 안전해요. 자경단도 본인 개인 계정이 아니라 cat-vigilante 조직에 둬요 — 본인이 언젠가 메인테이너를 넘겨줄 수도 있으니까요. 조직은 "한 사람을 넘어서는 그릇"이에요.

---

## 4. 둘째 단추 — Team으로 5명 묶기

cat-vigilante Organization → Teams → New team.

```
backend (까미)
frontend (노랭이)
infra (미니)
qa (깜장이)
maintainer (본인)
```

각 team에 사람 추가. team별로 다른 권한 부여 가능.

자경단 표준 — 역할별 team. 5명 5 team.

team으로 묶는 진짜 이득은 "권한의 자동 상속"이에요(§5 미리보기). backend team에 Write 권한을 주면, 그 team의 모든 멤버가 Write를 받아요. 새 백엔드 멤버가 오면 team에 추가만 하면 끝 — 권한·리뷰 배정(CODEOWNERS)·알림이 다 따라와요. 사람마다 일일이 설정하면 다섯 명에 다섯 번이지만, team이면 한 번이에요. 그리고 team은 중첩(nested)도 돼요 — 회사가 커지면 engineering team 아래 backend·frontend sub-team을 둬요. 자경단은 다섯이라 평평한 5 team이지만, 50명이 되면 계층 구조로 자라요. team은 조직의 뼈대예요. 그래서 처음에 역할별로 잘 나눠 두면, 팀이 커져도 그 뼈대 위에 살을 붙이면 돼요.

자경단 5 team의 매핑을 다시 보면, 이게 H1의 다섯 페르소나와 1:1이에요 — backend(까미)·frontend(노랭이)·infra(미니)·qa(깜장이)·maintainer(본인). 그리고 이 team이 §7의 CODEOWNERS와 그대로 연결돼요 — `/backend/` 폴더의 owner가 backend team. 즉 team 한 번 묶으면, 권한(§5)·리뷰 배정(§7)·알림이 다 그 team을 따라가요. 조직 구조 한 번이 세 곳에서 쓰여요. 그래서 team을 역할에 맞게 잘 나누는 게 셋업의 뼈대인 거예요.

---

## 5. 셋째 단추 — Repository 권한 5단계

GitHub의 권한 다섯 단계.

1. **Read** — 코드 보기만.
2. **Triage** — issue 관리.
3. **Write** — push, PR.
4. **Maintain** — settings 일부.
5. **Admin** — 모든 것.

자경단 표준.

```
backend, frontend, infra, qa team → Write
maintainer team → Admin
```

본인 (maintainer)만 Admin. 다섯 명 다 Write로 충분.

이게 **최소 권한 원칙(least privilege)**이에요 — 일하는 데 꼭 필요한 만큼만 권한을 줘요. 까미가 코드를 짜는 데 Admin은 필요 없어요(Write면 PR·push 다 돼요). Admin은 저장소를 삭제하고 protection을 끄는 무서운 권한이라, 한 명(본인)만 가져요. 권한을 적게 주는 건 동료를 안 믿어서가 아니라, 실수의 폭발 범위를 줄이려는 거예요 — Admin이 다섯이면 누구든 실수로 protection을 끌 수 있지만, 하나면 그 위험이 5분의 1이에요. 그리고 권한을 사람이 아니라 **team에 주는** 게 핵심이에요. 새 백엔드 멤버가 오면 backend team에 추가만 하면 권한이 자동으로 따라와요 — 사람마다 일일이 권한을 안 줘도 돼요. 참고로 Triage(2018 추가)는 "코드는 못 바꾸지만 이슈·PR은 관리"라, 외부 기여자나 PM에게 딱이에요.

---

## 6. 넷째 단추 — Branch Protection 7체크

main 브랜치에 자물쇠 7개. Settings → Branches → Add rule.

```
Branch name pattern: main

✓ Require a pull request before merging
  ✓ Require approvals (1)
  ✓ Dismiss stale reviews when new commits are pushed
  ✓ Require review from Code Owners

✓ Require status checks to pass before merging
  ✓ Require branches to be up to date

✓ Require conversation resolution before merging

✓ Require signed commits

✓ Require linear history

✓ Do not allow bypassing the above settings

✓ Restrict who can push to matching branches (Admin만)
```

7장의 자물쇠. 자경단 main의 보호. force-push 사고 면역.

일곱 자물쇠를 하나씩 풀어 볼게요. **(1) Require PR** — main에 직접 push 금지, 모든 변경은 PR로. **(2) Require approvals(1)** — 최소 한 명의 승인. **(3) Dismiss stale reviews** — 승인 후 새 commit이 오면 그 승인을 무효화(승인한 코드와 머지될 코드가 같도록). **(4) Require Code Owners review** — CODEOWNERS의 소유자가 반드시 리뷰(다섯째 단추와 연결). **(5) Require status checks** — CI(테스트·lint·타입)가 초록불이어야 머지. **(6) Require conversation resolution** — 리뷰 코멘트가 다 해결돼야 머지. **(7) Require signed commits** — GPG/SSH 서명으로 "누가 진짜 짰나" 증명. 거기에 **linear history**(merge commit 없이 일직선, squash와 짝), **include administrators**(본인도 규칙에 묶임)까지.

이 일곱이 다 켜지면 main은 거의 난공불락이에요. 누구도 검토 없이, CI 없이, 서명 없이 main을 못 건드려요. 처음엔 일곱이 많아 보이지만, 핵심 셋(PR 필수·승인 1명·status check)만 켜도 사고의 90%가 막혀요. 나머지 넷은 팀이 자라며 하나씩 더해요. 자경단은 처음에 핵심 셋 + include administrators 넷으로 시작하고, 6개월 후 signed commits를 더해요. **보호는 한 번에 완벽하게가 아니라 하나씩 단단하게**예요. 그리고 이걸 클릭이 아니라 `gh api`로 코드로 걸면, 다음 저장소에 그대로 복사돼요.

일곱 중 "signed commits"를 조금 더. 평소 git은 commit의 author를 그냥 텍스트로 믿어요 — `git config user.email`에 아무거나 넣으면 누구 이름으로든 commit할 수 있어요(가짜 author). signed commits는 GPG나 SSH 키로 commit에 서명을 붙여, "이 commit을 진짜 이 사람이 만들었다"를 암호로 증명해요. GitHub에 'Verified' 초록 뱃지가 붙고요. 오픈소스나 보안이 중요한 곳에선 필수예요 — 누군가 메인테이너를 사칭한 가짜 commit을 막거든요. 자경단은 6개월 차에 이걸 켜요(처음부터 켜면 키 셋업이 번거로워 진입장벽이 되니, 팀이 익숙해진 뒤에). 보안은 한꺼번에가 아니라 단계적으로 올리는 거예요.

protection이 없던 시절과 있는 시절을 한 장면으로 비교해 볼게요. 없을 때 — 까미가 금요일 저녁 급하게 main에 직접 push, 테스트 안 돌림, 주말에 사이트가 죽음, 월요일 다섯 명이 원인 추적에 반나절. 있을 때 — 같은 push가 "PR 없이는 못 올린다"에 막힘, PR을 올리자 CI가 빨간불(테스트 실패), 까미가 고치고 나서야 머지, 사이트는 멀쩡. 같은 상황, 다른 결말. protection은 "까미를 못 믿어서"가 아니라 "금요일 저녁 급한 까미"로부터 다섯 명을 지키는 거예요. 규칙이 사람을 구해요. 좋은 규칙은 가장 약한 순간의 본인을 지켜 줘요.

---

## 7. 다섯째 단추 — CODEOWNERS

`.github/CODEOWNERS` 파일.

```
# 백엔드 코드는 까미 자동 리뷰어
/backend/    @cat-vigilante/backend
/api/        @cat-vigilante/backend

# 프론트
/frontend/   @cat-vigilante/frontend
/ui/         @cat-vigilante/frontend

# 인프라
/.github/    @cat-vigilante/infra
/terraform/  @cat-vigilante/infra
/docker/     @cat-vigilante/infra

# QA
/tests/      @cat-vigilante/qa

# main 전체는 본인 (maintainer)
*            @cat-vigilante/maintainer
```

PR이 만들어지면 자동으로 해당 파일의 owner가 리뷰어 지정. 자경단 매일.

CODEOWNERS의 규칙 몇 가지를 짚어 둘게요. 첫째, **마지막 매치가 이겨요** — 위에서 `*`(전체)를 본인으로, 아래에서 `/backend/`를 까미로 두면, 백엔드 파일은 까미가 이겨요(더 구체적인 게 아래). 그래서 일반 규칙을 위에, 구체적 규칙을 아래에 둬요. 둘째, **글로브 패턴** — `/backend/`(폴더), `*.tsx`(확장자), `/docs/**`(하위 전체)를 다 쓸 수 있어요. 셋째, 파일은 **`.github/CODEOWNERS`** 위치에 둬요(루트나 docs/도 되지만 .github/가 표준). 넷째, **branch protection의 "Require Code Owners review"와 짝**이에요 — 이걸 켜야 CODEOWNERS가 강제력을 가져요. CODEOWNERS만 있고 protection이 없으면 "추천"일 뿐, 둘이 만나야 "필수"가 돼요.

한 시나리오로 봐요. 노랭이가 급해서 백엔드 API를 직접 고친 PR을 올려요. CODEOWNERS가 까미를 자동으로 붙이고, protection이 "까미 승인 없으면 머지 금지"를 강제해요. 그래서 까미가 모르는 백엔드 변경이 main에 들어갈 수 없어요. 소유권이 코드로 지켜지는 거예요. 이게 다섯 명이 서로의 영역을 존중하며 일하는 법이에요.

---

## 8. 여섯째 단추 — Conventional Commits + commitlint

커밋 메시지 표준.

```
feat: 새 기능 추가
fix: 버그 수정
docs: 문서
refactor: 리팩토링
test: 테스트
chore: 잡일
perf: 성능
style: 코드 스타일
```

`feat: cat photo upload 추가` 같이.

commitlint로 강제.

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional
```

`commitlint.config.js`.

```js
module.exports = {
  extends: ['@commitlint/config-conventional'],
};
```

PR 시 commit 메시지 자동 검증.

이 세 줄짜리 `commitlint.config.js`가 하는 일은 단순해요 — "@commitlint/config-conventional" 규칙(feat·fix 등 표준 접두사)을 그대로 쓴다는 선언이에요. 더 세밀하게 커스터마이즈할 수도 있지만(본문 길이 제한·한국어 허용 등), 처음엔 표준 그대로가 제일 좋아요. 표준을 따르면 다른 도구(release-please)와 자동으로 맞물리거든요. 규칙을 직접 만들기 전에 표준을 먼저 쓰는 게 협업의 지혜예요 — 모두가 아는 표준이 본인만의 규칙보다 강해요.

Conventional Commits가 왜 자경단 표준이냐면, 세 가지를 한 번에 주기 때문이에요. 하나, **읽기 쉬운 history** — `git log --oneline`이 "feat 5개, fix 3개"로 한눈에 분류돼요. 둘, **자동 버전** — feat→minor, fix→patch, BREAKING→major로 SemVer가 저절로 정해져요(H2 회수). 셋, **자동 CHANGELOG** — release-please가 접두사를 읽어 release 노트를 만들어요. 첫 commit부터 `feat:`·`fix:`를 붙이는 작은 습관이 이 셋을 공짜로 줘요. 자경단 표준은 "접두사는 영어, 본문은 한국어" — `feat: 고양이 사진 업로드 추가`처럼. 접두사는 도구가 읽고, 본문은 사람이 읽으니까요. commitlint가 이 형식을 commit 순간에 검사해서, 틀린 형식은 아예 commit이 안 돼요. 사람의 규율을 기계가 지켜 주는 거예요. 그래서 다섯 명의 history가 한 사람이 쓴 것처럼 일관돼요.

---

## 9. 일곱째 단추 — husky pre-commit hooks

husky로 git hooks 관리.

```bash
npm install --save-dev husky
npx husky install
npx husky add .husky/pre-commit "npm run lint"
npx husky add .husky/commit-msg "npx commitlint --edit"
```

commit 직전 자동 실행. lint 안 통과하면 commit 안 됨. 자경단 매일.

husky의 핵심은 ".git/hooks/는 공유가 안 된다"는 Ch004 H7의 문제를 푸는 거예요. husky는 hook을 `.husky/` 폴더(코드 저장소 안)에 넣고, `npm install` 때 자동으로 `.git/hooks/`에 연결해요. 그래서 새 멤버가 `git clone` + `npm install`만 하면 다섯 명이 똑같은 hook을 써요. 자경단의 두 hook — **pre-commit**(바뀐 파일만 ruff·prettier로 빠른 검사)과 **commit-msg**(commitlint로 메시지 형식 검사). 둘 다 1~2초라 안 무거워요. 무거운 전체 테스트는 CI(GitHub Actions)로 미뤄요 — hook은 빠르게, CI는 철저하게. 그리고 `--no-verify`로 hook을 건너뛸 수 있지만, 이건 비상구지 일상 문이 아니에요. 자주 건너뛰면 hook이 없는 거나 마찬가지예요. hook은 본인 손이 잊어도 기계가 기억하는 약속이에요.

자경단의 `.husky/pre-commit`을 한번 그려 볼게요 — `npx lint-staged`(바뀐 파일만 ruff·prettier) 한 줄. `.husky/commit-msg`는 `npx commitlint --edit $1`(메시지 형식 검사) 한 줄. 두 hook이 각각 한 줄이에요. 단순할수록 빠르고, 빠를수록 안 건너뛰어요. hook이 무겁고 느리면 다들 `--no-verify`로 우회하니, "가볍게 유지"가 hook 운영의 첫 규칙이에요. 그리고 lint-staged가 "바뀐 파일만" 검사하는 게 핵심 — 전체를 매번 검사하면 느리거든요. 작은 hook 하나가 다섯 명의 코드 스타일을 한 사람이 쓴 것처럼 통일해요.

---

## 10. 여덟째 단추 — SSH 키와 토큰 종류

GitHub 인증 네 종류.

**SSH key**. 본인 노트북의 영구 키. clone, push에 사용. 자경단 매일.

**Personal Access Token (PAT)**. 옛 표준. 새 코드는 fine-grained.

**Fine-grained Token**. 2022+. 권한 세밀.

**Deploy Key**. 특정 repo만 접근. CI에 박기.

자경단 표준.

```bash
# 본인 → SSH key
ssh-keygen -t ed25519 -C "bonin@example.com"
cat ~/.ssh/id_ed25519.pub
# 복사 → GitHub Settings → SSH keys

# CI → Deploy Key 또는 Fine-grained Token
```

네 인증 방식의 자리를 정리해 둘게요. **SSH 키**는 본인 노트북의 매일 clone·push(영구, 패스프레이즈로 보호). **Fine-grained PAT**는 스크립트·CI에서 API 호출(만료 짧게, 권한 최소). **Deploy Key**는 한 저장소만 접근하는 CI용(그 repo만). **GitHub App**은 봇·통합용(가장 세밀). 자경단은 본인 매일은 SSH, CI는 Deploy Key나 OIDC(Ch091)를 써요. 핵심 원칙 셋 — 비밀은 코드에 안 박고(Settings → Secrets), 권한은 최소로, 만료는 짧게. 그리고 키가 새면 즉시 폐기(Q5). 1Password 같은 도구의 SSH agent를 쓰면 키 관리가 한결 안전하고 편해요. 인증은 "편한 만큼 위험"이라, 편함과 안전의 저울을 늘 의식하세요. ed25519를 쓰는 이유도 보안과 속도의 균형이 가장 좋아서예요(옛 RSA보다 짧고 강해요).

셋업 후 한 가지 꼭 — `ssh -T git@github.com`으로 키가 잘 등록됐는지 확인하세요. "Hi bonin! You've successfully authenticated"가 뜨면 성공이에요. 이 한 줄 확인을 안 하고 넘어가면, 나중에 push할 때 "Permission denied"로 헤매요. 셋업은 박고 나서 한 번 테스트 — 그게 §11 체크리스트 [10]의 정신이에요. 그리고 `~/.ssh/config`에 `Host github.com`을 두어 키를 명시하면, 키가 여러 개여도 안 헷갈려요. 회사 키와 개인 키를 둘 다 쓸 때 특히 유용해요(§14 함정 다섯 회수). 작은 확인과 작은 설정이 큰 헤맴을 막아요.

---

## 11. 자경단 셋업 체크리스트 10단계

```
[1]  Organization cat-vigilante 생성
[2]  Team 5개 (backend/frontend/infra/qa/maintainer)
[3]  Repository 권한 (4팀 Write, maintainer Admin)
[4]  main Branch Protection 7체크
[5]  .github/CODEOWNERS
[6]  commitlint.config.js
[7]  .husky/pre-commit + commit-msg
[8]  팀원 SSH 키 등록 (5명)
[9]  README + CONTRIBUTING.md
[10] 첫 PR 시뮬레이션 (다섯 명 다)
```

30분이면 1~10. 자경단의 안전벨트 완성.

이 열 단계를 왜 한 페이지로 묶냐면, 본인이 두 해 후 새 회사·새 프로젝트에서 그대로 쓸 체크리스트이기 때문이에요. 새 저장소를 받으면 이 열 줄을 위에서 아래로 — Organization 있나, team 묶었나, 권한 줬나, protection 켰나, CODEOWNERS 있나… 십 분이면 점검 끝이에요. 그리고 [10] "첫 PR 시뮬레이션"이 가장 중요해요 — 셋업을 다 했다고 끝이 아니라, 다섯 명이 각자 한 번씩 PR을 올려 봐야 진짜 되는지 알아요. protection이 정말 막는지, CODEOWNERS가 정말 리뷰어를 붙이는지, husky가 정말 도는지. "되는 줄 알았는데 안 되더라"를 첫날 잡는 거예요. 자경단은 이 시뮬레이션을 "셋업 졸업식"이라 불러요. 다섯 명이 첫 PR을 머지하는 순간, 자경단의 협업이 진짜 시작돼요. 셋업은 박는 게 절반, 검증이 나머지 절반이에요.

체크리스트 [9]의 CONTRIBUTING.md를 짚어 둘게요. 이건 "자경단에 기여하는 법"을 적은 한 페이지예요 — 어떤 워크플로우를 쓰고, 브랜치를 어떻게 짓고, commit 형식이 뭐고, PR을 어떻게 올리는지. 새 멤버(또는 외부 기여자)가 이 한 장만 읽으면 자경단의 규칙을 다 알아요. H2에서 본 WORKFLOW.md가 "우리의 합의"라면, CONTRIBUTING.md는 "그 합의를 새 사람에게 알려주는 안내서"예요. 좋은 오픈소스는 다 이 문서가 있어요 — 본인이 React에 첫 PR을 보낼 때도 그들의 CONTRIBUTING.md를 먼저 읽거든요. 자경단도 첫날 이 한 장을 써 두면, 6번째 멤버가 와도 본인이 일일이 설명 안 해도 돼요. 문서 한 장이 온보딩을 자동화하는 거예요.

한 단계 더 — 이 열 단계를 `setup-org.sh` 스크립트 하나로 묶을 수 있어요. `gh api`로 protection을 걸고, 파일을 생성하고, husky를 설치하는 명령을 한 파일에 적어 두면, 다음 프로젝트는 30분이 아니라 30초예요. 클릭으로 한 셋업은 다음에 또 클릭해야 하지만, 코드로 한 셋업은 복사 한 번이에요. 자경단의 미니가 이 스크립트를 dotfiles 저장소에 넣어 두고, 새 저장소마다 한 줄로 실행해요. "두 번 할 일은 한 번 적어 둔다"(Ch004 회수)가 셋업에서도 똑같아요. 본인의 첫 인프라 자동화가 바로 이 셋업 스크립트가 될 수 있어요.

---

## 12. 흔한 오해 다섯 가지

**오해 1: "개인 계정으로도 협업이 충분하다."** 두 명까지는 그럭저럭 되지만, 권한·team·audit이 필요해지는 순간 막혀요. Organization은 "회사처럼 운영"을 위한 그릇이에요 — team으로 권한을 묶고, 소유권을 분리하고, 누가 뭘 했는지 추적해요. Free로 공짜니 협업은 무조건 Organization에서 시작하세요. 나중에 옮기는 것보다 처음부터 그릇을 제대로 고르는 게 싸요.

**오해 2: "branch protection은 번거로운 부담이다."** 5분 셋업이 5년 사고 0회를 만들어요. 번거로운 건 protection이 아니라, 그게 없어서 새벽에 force-push 사고를 수동 복구하는 본인 시간이에요. protection은 족쇄가 아니라 안전벨트예요 — 평소엔 의식 못 하다가 사고 순간 본인을 살려요.

**오해 3: "CODEOWNERS는 큰 팀이나 쓰는 옵션이다."** 다섯 명만 돼도 필수예요. CODEOWNERS가 없으면 "이 PR 누가 봐야 하지?"를 매번 사람이 정해야 해요. 있으면 폴더가 리뷰어를 자동으로 정해줘서, 노랭이가 백엔드를 건드리면 까미가 자동으로 붙어요. 소유권을 코드로 박아 두는 5분이 1년의 "누가 리뷰?" 혼란을 없애요.

**오해 4: "husky는 무겁고 commit을 느리게 한다."** 잘 쓰면 안 무거워요. pre-commit엔 빠른 검사(바뀐 파일만 lint)만 넣고, 무거운 테스트는 CI로 미뤄요. 그러면 commit이 1~2초 안에 끝나요. husky가 무거운 건 hook에 전체 테스트를 넣었을 때지, husky 자체가 아니에요. "빠른 hook + 무거운 CI"가 황금 조합이에요.

**오해 5: "Conventional Commits를 강제하는 건 불필요한 규율이다."** 이 작은 규율이 자동화의 씨앗이에요. feat·fix·BREAKING 접두사를 읽어 release-please가 SemVer 버전과 CHANGELOG를 자동 생성해요(H2 회수). 첫 commit부터 접두사를 지키면, 1년 후 release 노트가 저절로 만들어져요. 규율이 자유를 주는 역설이에요 — 작은 규칙 하나가 큰 수작업을 없애요.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. GitHub Free plan으로 자경단을 운영할 수 있어요?** 충분해요. Free로 무제한 public·private 저장소, Organization, 무제한 협업자, Actions 월 2,000분, Pages를 다 써요. 유료(Team $4/인)는 더 세밀한 권한, 더 많은 Actions 분, audit log가 필요한 큰 팀용이에요. 자경단 다섯 명은 두 해 코스 내내 Free로 충분하고, 첫 직장 전까지 한 푼도 안 들어요.

**Q2. branch protection을 켜면 급할 때 본인도 main에 못 올리나요?** "include administrators"를 켰으면 본인도 못 올려요 — 그게 핵심이에요. 정말 긴급하면 잠깐 규칙을 끄고 올린 뒤 다시 켜는 방법이 있지만, 그 행위 자체가 audit log에 남아요. 새벽 3시 졸린 본인이 "규칙 끄고 직접 올리기"를 하려면 한 번 더 생각하게 되거든요. 규칙은 본인을 못 믿어서가 아니라, 졸린 본인·급한 본인으로부터 멀쩡한 본인을 지키려는 거예요.

**Q3. CODEOWNERS는 어떻게 자동으로 리뷰어를 붙여요?** PR이 만들어지면 GitHub이 변경된 파일 경로를 CODEOWNERS와 대조해, 매칭되는 owner를 자동으로 리뷰어로 등록해요. 노랭이가 `/backend/` 파일을 건드리면 까미(backend owner)가 자동으로 붙는 식이에요. 규칙은 위에서 아래로 읽되 **마지막에 매칭된 줄이 이겨요** — 그래서 `*`(전체) 규칙을 맨 위에, 구체적 폴더를 아래에 둬요(H7에서 깊이).

**Q4. husky랑 pre-commit framework 중 뭘 써요?** husky는 JS 생태계(Node 프로젝트), pre-commit(Python)은 파이썬 생태계예요. 둘 다 "hook을 코드 저장소에 넣어 팀이 공유"라는 같은 일을 해요. 자경단은 프런트(노랭이)가 Node를 쓰니 husky를 표준으로 하고, 백엔드 전용 검사는 그 안에서 호출해요. 핵심은 도구가 아니라 "hook을 공유한다"는 개념이에요(Ch004 H7 회수).

**Q5. 토큰·SSH 키가 새면 어떡해요?** 즉시 폐기(revoke)하고 새로 발급해요. 그래서 토큰은 코드에 절대 안 박고(Q4 함정), 만료일을 짧게 두고, 권한을 최소로 줘요(fine-grained). SSH 키엔 패스프레이즈를 걸어 키 파일이 새도 한 겹 더 막아요. 비밀이 새는 사고는 한 번은 나니, "안 새게"보다 "새도 피해가 작게 + 즉시 폐기"가 현실적인 방어예요. GitHub의 secret scanning이 실수로 올린 키를 자동으로 잡아 알려 주기도 해요.

다섯 질문을 관통하는 한 줄 — 셋업은 "무거운 규칙"이 아니라 "가벼운 시작 + 단계적 강화"예요. Free로 시작하고, 핵심 보호 먼저 켜고, 비밀은 안 박고, hook은 가볍게, 키는 최소 권한. 처음부터 완벽할 필요 없어요. 첫날 단단한 기초 위에, 팀이 자라며 하나씩 더하면 돼요. 그게 셋업을 부담이 아니라 성장으로 만드는 법이에요.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 환경 학습 편

마지막으로 협업 환경을 처음 셋업하는 본인이 자주 빠지는 함정 다섯을 짚고 가요. 셋업은 한 번 하면 1년을 가니, 첫 셋업을 제대로 하는 게 중요해요 — 잘못 깔면 1년 동안 그 위에서 불편하거든요. 미리 함정을 알면 처음부터 단단하게 깔 수 있어요.

첫 번째 함정, branch protection 안 켠다. 안심하세요. **첫날 main에 protection.** Force push 차단·리뷰 필수·status check 필수. 신입이 "내 작은 변경인데 굳이 PR을?" 하며 protection을 안 켜거나 우회해요. 그러다 한 번 main을 망치면 다섯 명이 멈춰요. protection은 본인의 자유를 뺏는 게 아니라, 다섯 명의 안전을 지키는 거예요. 첫날 켜는 5분이 가장 싼 보험이에요.

두 번째 함정, CODEOWNERS 너무 광범위하게. 안심하세요. **scope별 분리.** /backend = backend 팀, /frontend = frontend 팀. 본인이 `* @maintainer` 한 줄로 모든 PR을 본인에게 몰면, 본인이 병목이 돼요(매일 15건을 혼자 리뷰). scope별로 나누면 백엔드는 까미, 프런트는 노랭이가 1차로 보고, 본인은 최종만 봐요. 리뷰를 분산하는 게 협업이에요. 다만 너무 잘게 나누면 관리가 복잡하니, 폴더 단위(다섯 영역)가 적당해요. 소유권은 "한 명에게 몰기"가 아니라 "각자의 영역으로 나누기"예요.

세 번째 함정, .github/PULL_REQUEST_TEMPLATE 비어 있음. 안심하세요. **What·Why·How·Test 4섹션 템플릿.** 본인 + 동료 모두 도움. PR 템플릿은 PR을 열 때 자동으로 채워지는 양식이에요. "무엇을·왜·어떻게 테스트했나" 네 줄을 묻게 해 두면, 리뷰어가 코드를 보기 전에 맥락을 1초에 잡아요. 빈 PR 본문은 리뷰어에게 "알아서 파악해"라는 무례한 메시지예요. 템플릿 한 장이 다섯 명의 리뷰 시간을 매번 줄여요.

네 번째 함정, GitHub Actions secret을 코드에. 본인이 API key 코드에 직접. 안심하세요. **Settings → Secrets에 등록.** API 키를 코드에 박아 commit하면, 그게 GitHub에 올라가는 순간 전 세계가 봐요(public이면 봇이 몇 초 안에 긁어가요). 그래서 비밀은 절대 코드에 안 박고, GitHub Secrets나 환경변수로 주입해요. 실수로 올렸다면 키를 즉시 폐기하고 새로 발급 — git history에서 지워도 이미 본 사람이 있으니 폐기가 답이에요. .gitignore에 .env를 넣는 Ch004의 습관이 여기서 생명을 구해요.

다섯 번째 함정, 가장 큰 함정. **dotfiles를 회사·개인 분리 안 함.** 본인이 한 user.email로 다. 안심하세요. **레포별 .git/config의 user.email.** 또는 ~/.gitconfig에 includeIf로 디렉토리별 분기. 이게 왜 중요하냐면, 회사 commit에 개인 이메일이 박히면(또는 반대), GitHub 프로필이 엉키고 회사 audit이 꼬여요. `~/.gitconfig`에 `[includeIf "gitdir:~/work/"]`로 work 폴더 아래선 회사 이메일, 나머진 개인 이메일을 자동으로 쓰게 해 두면, 본인이 신경 안 써도 맞는 신분으로 commit돼요. 한 번 셋업하면 평생 안 헷갈려요. 신입 때 이걸 모르고 회사 코드에 개인 Gmail을 박는 게 흔한 첫 실수예요.

다섯 함정을 한 줄로 묶으면 — 셋업의 실수는 대부분 "나중에 하지 뭐"에서 와요. protection도, CODEOWNERS도, 이메일 분리도 첫날 5분이면 되는데 미루면 1년 불편해요. 첫날에 단단하게가 모든 셋업의 황금률이에요. 다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H4에서 만나요

자, 세 번째 시간이 끝났어요.

8단추 셋업. Organization, Team, 권한, Protection, CODEOWNERS, Conventional Commits, husky, SSH/Token. 자경단 안전벨트 완성.

오늘 한 줄 정리. **자경단의 GitHub 환경은 여덟 단추 — 조직·팀·권한·보호·소유·형식·검증·인증 — 로 30분에 완성되고, 사람의 합의를 도구가 강제한다.** 본인이 이 여덟을 손에 쥐면, 어느 회사 새 저장소를 받아도 30분에 회사 표준으로 단장할 수 있어요. 입사 첫날 "저장소 셋업 좀"이라는 부탁에 손이 자동으로 움직이는 사람 — 그게 오늘의 본인이에요. 환경 셋업은 화려하진 않지만, 다섯 명의 매일을 조용히 받치는 가장 단단한 바닥이에요.

본인 페이스. 3/8 시간. 37.5%. H1 큰그림, H2 개념, H3 도구. 이제 절반 가까이 왔어요. H4부터는 매일 쓰는 명령어 30개를 손에 익혀요. 개념과 환경을 갖춘 본인이 이제 손가락을 단련할 차례예요. 박수.

다음 H4는 30개 도구. 30 손가락 + 위험도 신호등.

```bash
gh org list
gh repo view --web
```

이 두 줄을 치면 본인 조직과 저장소가 보여요. 오늘 박은 여덟 단추가 그 화면 곳곳에 있어요 — Settings → Branches의 protection, .github/CODEOWNERS, .husky/. H4부터는 이 환경 위에서 매일 쓰는 명령어를 손가락에 익혀요. 환경(H3)을 갖췄으니 이제 그 환경에서 빠르게 일하는 법(H4)이에요. 5초예요. 본인의 H3 졸업장이에요. 잘 따라오셨어요. 5분 쉬고 H4에서 만나요.

---

## 👨‍💻 개발자 노트

> - GitHub Free vs Team vs Enterprise: 가격과 기능.
> - branch protection API: REST + GraphQL.
> - CODEOWNERS 우선순위: 마지막 매치 룰.
> - Conventional Commits + semantic-release: 자동 release.
> - husky vs pre-commit-hook (Python): 언어 차이.
> - 다음 H4 키워드: 30 git/gh 도구 · 위험도 · 매일 6 손가락.

---

## 추신

1. 첫날 30분 셋업이 5명×1년 협업의 안전벨트예요.
2. Organization은 회사처럼 — 5명이 한 곳에. 개인 계정은 공유 한계.
3. Team 5개 = 역할 5개. 권한을 사람이 아니라 team 단위로.
4. 권한 5단계 — Read·Triage·Write·Maintain·Admin. 최소 권한 원칙.
5. Admin은 본인(maintainer) 하나. 나머지 넷은 Write로 충분해요.
6. branch protection 7체크가 main의 자물쇠 7개.
7. "include administrators"로 본인도 규칙에 묶여요. 미래의 나를 위해.
8. CODEOWNERS는 폴더별 리뷰어 자동 배정. 마지막 매치 우선.
9. Conventional Commits 8접두사 — feat·fix·docs·refactor·test·chore·perf·style.
10. commitlint가 메시지를 기계로 검증. 사람이 안 깜빡해요.
11. husky가 hook을 코드 저장소에. npm install 한 번에 5명 공유.
12. pre-commit은 빠르게, 무거운 검사는 CI로 미뤄요.
13. SSH 키는 ed25519. clone·push의 영구 신분증.
14. PAT는 옛 표준, fine-grained가 2022+ 새 표준. 권한이 세밀해요.
15. Deploy Key는 특정 repo만. CI에 박아요.
16. 비밀은 코드가 아니라 Settings → Secrets에.
17. 회사·개인 user.email은 includeIf로 디렉터리별 분기.
18. 권한·보호·소유·검증 — 사람의 합의를 도구가 강제해요.
19. 셋업을 스크립트로 묶으면 다음 프로젝트는 30분이 아니라 30초.
20. require signed commits로 "누가 진짜 짰나"를 증명해요.
21. require linear history로 main을 일직선으로 깨끗하게(squash).
22. dismiss stale review — 새 commit이 오면 옛 승인 무효화.
23. Free plan으로 자경단 충분 — 무한 repo, Actions 월 2,000분.
24. 30분 셋업 ROI — 5분 protection이 5시간 사고를 막아요.
25. CODEOWNERS 글로브 — `/backend/`처럼 폴더, `*.tsx`처럼 확장자.
26. 새 멤버는 CONTRIBUTING.md 한 장으로 온보딩.
27. 첫 PR 시뮬레이션을 다섯 명 다 한 번씩 — 셋업이 진짜 되는지 검증.
28. 면접 — "branch protection 어떻게 거나요?", "CODEOWNERS가 뭐예요?".
29. 셋업은 한 번, 효과는 1년. 곱셈의 ROI예요.
30. signed commits로 가짜 author를 막아요. Verified 뱃지가 그 증거.
31. 셋업은 박는 게 절반, 첫 PR 시뮬레이션 검증이 나머지 절반.
32. 보안은 단계적으로 — 핵심 셋 먼저, signed commits는 6개월 후.
33. 회사·개인 이메일은 includeIf로 자동 분기. 신입 첫 실수 단골.
34. 여덟 단추 = 앞 다섯(누가 무엇을)+뒤 셋(어떻게 안전하게).
35. 셋업 실수는 "나중에 하지 뭐"에서. 첫날 5분이 1년 불편을 막아요.
36. CODEOWNERS는 한 명에게 몰지 말고 영역별로. 병목을 만들지 마세요.
37. 표준을 본인만의 규칙보다 먼저. 모두가 아는 표준이 강해요.
38. 셋업을 스크립트로 — 클릭은 반복, 코드는 복사 한 번.
39. ROI는 인원 × 기간. 본인 30분이 다섯 명의 1년을 받쳐요.
40. 다음 H4는 30개 git/gh 도구 + 위험도 신호등이에요. 환경을 갖춘 본인이 이제 매일 쓰는 손가락을 단련할 차례예요. 5분 쉬고 H4에서 만나요. 🐾
