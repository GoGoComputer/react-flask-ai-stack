# Ch004 · H8 — 자경단 30분 종합 셋업 + 다섯 원리 + 챕터 회고

> 고양이 자경단 · Ch 004 · 8교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속
2. Ch004 7시간 회고
3. 자경단 30분 종합 셋업
4. 다섯 원리 한 페이지
5. 본인의 git 5년 자산
6. Ch005로 가는 다리
7. 흔한 오해 다섯 가지
8. 자주 받는 질문 다섯 가지
9. 흔한 실수 다섯 가지 + 안심 멘트 — Ch004 회고 학습 편
10. 마무리

---

## 1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속

자, 안녕하세요. 본 챕터의 마지막 시간이에요.

지난 H7 회수. .git 안의 네 친구 — objects, refs, HEAD, config. SHA-1, packfile, hooks, reflog.

이번 H8은 적용과 회고. 자경단 30분 종합 셋업, 다섯 원리, Ch005로 다리.

오늘의 약속. **본인이 자경단 저장소를 회사 표준으로 바꾸는 30분을 손에 익힙니다**.

자, 가요.

---

## 2. Ch004 7시간 회고

본인이 7시간 동안 무엇을 만나셨는지.

**H1** — Git이 코드의 사진앨범. 사진 + 평행 우주 + 구름 백업.

**H2** — 4 단어. Repository, Commit, Branch, Remote.

**H3** — 환경점검. 설치, config, SSH 키.

**H4** — 23 명령어. 위험도 신호등.

**H5** — 데모. git init부터 첫 push까지.

**H6** — 운영. Issue, PR, Project, Discussions, branch protection.

**H7** — 내부. .git 폴더의 네 친구.

**H8** — 지금. 종합 셋업 + 회고.

7시간이 자경단 저장소의 토대.

---

## 3. 자경단 30분 종합 셋업

본인이 새 저장소를 자경단 표준으로 바꾸는 30분.

> ▶ **같이 쳐보기** — 자경단 30분 셋업
>
> ```bash
> # 1. 저장소 만들기
> mkdir cat-vigilante && cd cat-vigilante
> git init
> 
> # 2. README + .gitignore
> echo "# 자경단" > README.md
> curl -o .gitignore https://www.toptal.com/developers/gitignore/api/python,node,macos
> 
> # 3. user 설정
> git config user.name "Bonin"
> git config user.email "bonin@example.com"
> 
> # 4. 첫 commit
> git add .
> git commit -m "chore: initial commit"
> 
> # 5. main 브랜치 명시
> git branch -M main
> 
> # 6. GitHub 저장소 만들기 (gh CLI)
> gh repo create cat-vigilante --public --source=. --push
> 
> # 7. issue 템플릿
> mkdir -p .github/ISSUE_TEMPLATE
> 
> # 8. PR 템플릿
> cat > .github/pull_request_template.md <<'EOF'
> ## 무엇을
> ## 왜
> ## 어떻게 테스트
> EOF
> 
> # 9. CODEOWNERS
> echo "* @cat-vigilante/maintainer" > .github/CODEOWNERS
> 
> # 10. branch protection (gh API)
> gh api -X PUT repos/:owner/cat-vigilante/branches/main/protection \
>   --field required_status_checks='{"strict":true,"contexts":[]}' \
>   --field enforce_admins=true \
>   --field required_pull_request_reviews='{"required_approving_review_count":1}'
> 
> # commit + push
> git add .github/
> git commit -m "chore: github workflow templates"
> git push
> ```

10단계. 30분이면 자경단 저장소.

---

## 4. 다섯 원리 한 페이지

본인이 5년 동안 잊지 말아야 할 다섯 원리.

**원리 1 — Git은 분산이다**.

본인 .git 폴더 한 개에 모든 history. GitHub은 사본 중 하나일 뿐. 인터넷 끊겨도 commit·branch·log 다 됨.

**원리 2 — 한 commit은 한 의도다**.

Conventional Commits. 1년 후 본인이 그 commit 메시지를 읽고 의도가 떠올라야.

**원리 3 — 브랜치는 공짜다**.

부담 없이 만들고 부담 없이 버려요. 한 작업 = 한 브랜치.

**원리 4 — main을 보호한다**.

직접 push 금지. PR + 리뷰 + 자동 검사. 사고 면역.

**원리 5 — reflog가 30일 안전망**.

force-push 사고 후 5분에 복구. 너무 무서워 마세요.

다섯 원리를 한 페이지에. 5년 자산.

---

## 5. 본인의 git 5년 자산

7시간 + 30분 셋업 후 본인이 가진 것.

**개념** — 4 단어 (repo, commit, branch, remote) + 4 친구 (objects, refs, HEAD, config).

**도구** — 23 명령어 + gh CLI + 6 GitHub 도구.

**환경** — 자경단 표준 저장소. branch protection, CODEOWNERS.

**원리** — 다섯 원리. 분산, 의도, 공짜 branch, 보호, reflog.

**자신감** — 어느 회사 가도 git 사고에 5분 안 처방.

5년 갑니다.

---

## 6. Ch005로 가는 다리

다음 챕터 Ch005는 협업 워크플로우. Ch004와 다리.

Ch004는 본인 혼자 git. Ch005는 다섯 명이 git. 같은 도구, 다른 게임.

GitHub Flow vs Git Flow vs Trunk-based. PR 리뷰의 톤. force-push 안전. 이 모든 게 Ch005.

본인이 Ch004의 4 단어 + 23 명령어를 손에 들고 가요. Ch005가 그 위에 다섯 명의 합주를 얹어요.

---

## 7. 흔한 오해 다섯 가지

**오해 1: git은 외워야.**

원리 5개면 충분.

**오해 2: 명령어가 많아 어려움.**

매일 6개부터.

**오해 3: GitHub만 쓰면.**

GitLab, Bitbucket도 가능.

**오해 4: 사고나면 끝.**

reflog로 30일 복구.

**오해 5: 자동화는 시니어.**

신입 1주차부터.

---

## 8. 자주 받는 질문 다섯 가지

**Q1. Git 마스터가 되려면?**

5년. 매일 사용.

**Q2. 모든 명령어 외우기?**

매일 6개. 6주에 23개.

**Q3. GitHub 무료 한계?**

자경단 충분.

**Q4. 회사 git 다르면?**

원리는 같음. 명령어도 90%.

**Q5. 두 해 코스 후?**

5년 차에 자경단 사이트가 진짜 출시.

---

## 9. 흔한 실수 다섯 가지 + 안심 멘트 — Ch004 회고 학습 편

8시간 마무리 직전 학습 함정 다섯.

첫 번째 함정, 30분 셋업으로 끝. 본인이 첫날 한 번 하고 영영 안 봄. 안심하세요. **매주 .gitconfig 한 번 점검.** 새 도구 깔 때마다 한 줄씩 늘어요.

두 번째 함정, dotfiles 안 만든다. 안심하세요. **.gitconfig·.zshrc·gitignore_global을 dotfiles 레포에.** 두 해 후 새 컴퓨터에서 한 줄로.

세 번째 함정, 첫 PR 안 낸다. 본인이 본인 코드만 commit. 안심하세요. **OSS 한 곳에 첫 PR.** 오타 수정 한 줄도 PR. 두 해 코스의 진짜 첫 단계.

네 번째 함정, GitHub README 비어 있음. 본인 dotfiles 레포 README 비어 있음. 안심하세요. **한 줄 README — "내 dotfiles".** 그 한 줄이 본인 포트폴리오 시작.

다섯 번째 함정, 가장 큰 함정. **다음 챕터로 안 간다.** 본인이 8시간 듣고 잠깐 휴식이 영영. 안심하세요. **두 주 후 정확히 다시.** Ch005 협업 워크플로 — 자경단 다섯 명이 같이 일하는 법. Ch004 + Ch005 = 진짜 협업 개발자.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 10. 마무리

자, 여덟 번째 시간이 끝났어요. 본 챕터 끝.

7시간 회고, 30분 셋업, 다섯 원리, 5년 자산, Ch005 다리.

박수 한 번 칠게요. 진짜 큰 박수예요. 본인이 8시간 끝까지 따라오셨어요. 두 해 코스의 큰 마디 한 칸을 더 채우셨어요.

본인의 자경단 저장소가 이제 회사 표준. 어디 가도 부끄럽지 않은 git 손가락.

본 챕터 끝.

다음 만남 — Ch005 H1. 두 주 후. 협업 워크플로우.

```bash
gh repo view --web
git log --oneline --all --graph -10
```

본인의 자경단 첫 인사예요.

---

## 👨‍💻 개발자 노트

> - 30분 셋업 자동화: dotfile 또는 init 스크립트.
> - branch protection API: GitHub REST.
> - PR 템플릿: .github/pull_request_template.md.
> - CODEOWNERS 우선순위: 마지막 매치.
> - 다음 챕터 Ch005: GitHub Flow, PR 리뷰, 다섯 명 합주.
