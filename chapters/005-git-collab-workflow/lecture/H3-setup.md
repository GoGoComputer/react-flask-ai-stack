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

## 1. 다시 만나서 반가워요 — H2 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠.

지난 H2를 한 줄로 회수할게요. 세 워크플로우 패턴 깊이. GitHub Flow가 자경단 표준. release vs deploy 분리. dev/staging/prod 환경 분리.

이번 H3는 자경단의 GitHub 환경을 30분에 박는 시간이에요. Organization, Team, Protection, CODEOWNERS, 그리고 husky까지.

오늘의 약속. **본인이 자경단 5명이 사고 없이 일할 수 있는 GitHub 환경을 30분에 셋업합니다**. 자, 가요.

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

---

## 12. 흔한 오해 다섯 가지

**오해 1: 개인 계정으로 충분.**

협업은 Organization.

**오해 2: branch protection 부담.**

5분 셋업, 5년 안전.

**오해 3: CODEOWNERS 옵션.**

자경단 표준.

**오해 4: husky 무거움.**

commit 자동 검증.

**오해 5: Conventional Commits 강제 부담.**

자동 release의 토대.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. Free plan 한계?**

3 team, 무한 public repo. 자경단 충분.

**Q2. branch protection 우회?**

Admin만. 본인이 신중히.

**Q3. CODEOWNERS 자동?**

GitHub가 PR 시 자동 할당.

**Q4. husky vs pre-commit?**

husky는 JS, pre-commit은 Python. 둘 다 OK.

**Q5. Token 보안?**

환경변수 또는 secret store.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 환경 학습 편

협업 환경 셋업하며 자주 빠지는 함정 다섯.

첫 번째 함정, branch protection 안 켠다. 안심하세요. **첫날 main에 protection.** Force push 차단·리뷰 필수·status check 필수.

두 번째 함정, CODEOWNERS 너무 광범위하게. 안심하세요. **scope별 분리.** /backend = backend 팀, /frontend = frontend 팀.

세 번째 함정, .github/PULL_REQUEST_TEMPLATE 비어 있음. 안심하세요. **What·Why·How·Test 4섹션 템플릿.** 본인 + 동료 모두 도움.

네 번째 함정, GitHub Actions secret을 코드에. 본인이 API key 코드에 직접. 안심하세요. **Settings → Secrets에 등록.** Conventional patterns.

다섯 번째 함정, 가장 큰 함정. **dotfiles를 회사·개인 분리 안 함.** 본인이 한 user.email로 다. 안심하세요. **레포별 .git/config의 user.email.** 또는 ~/.gitconfig에 includeIf로 디렉토리별 분기.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H4에서 만나요

자, 세 번째 시간이 끝났어요.

8단추 셋업. Organization, Team, 권한, Protection, CODEOWNERS, Conventional Commits, husky, SSH/Token. 자경단 안전벨트 완성.

박수.

다음 H4는 30개 도구. 30 손가락 + 위험도 신호등.

```bash
gh org list
gh repo view --web
```

---

## 👨‍💻 개발자 노트

> - GitHub Free vs Team vs Enterprise: 가격과 기능.
> - branch protection API: REST + GraphQL.
> - CODEOWNERS 우선순위: 마지막 매치 룰.
> - Conventional Commits + semantic-release: 자동 release.
> - husky vs pre-commit-hook (Python): 언어 차이.
> - 다음 H4 키워드: 30 git/gh 도구 · 위험도 · 매일 6 손가락.
