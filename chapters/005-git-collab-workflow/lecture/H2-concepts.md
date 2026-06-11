# Ch005 · H2 — 협업 워크플로우 8개념 — 세 패턴부터 환경 분리까지

> 고양이 자경단 · Ch 005 · 2교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. 첫째 — GitHub Flow 깊이
3. 둘째 — Git Flow 깊이
4. 셋째 — Trunk-based 깊이
5. 넷째 — 셋 패턴 한 표 비교
6. 다섯째 — branch 모델
7. 여섯째 — release vs deploy
8. 일곱째 — dev/staging/prod 환경 분리
9. 여덟째 — 자경단 적용 결정
10. 한 줄 분해
11. 흔한 오해 다섯 가지
12. 자주 받는 질문 다섯 가지
13. 마무리 — 다음 H3에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 세 워크플로우와 release/deploy를 눈으로 — 강사 시연용
git checkout -b feature/cat-photo-upload           # GitHub Flow: feature 브랜치
git push -u origin feature/cat-photo-upload        # 원격에 올리기
gh pr create --draft                               # draft PR로 early feedback
gh pr merge --squash --auto                        # squash + CI 통과 시 자동 머지
git tag v1.1.0 && git push --tags                  # release = SemVer 태그
gh release create v1.1.0 --generate-notes          # release 노트 자동 생성
gh api repos/:owner/:repo/branches/main/protection # main 보호 규칙 확인
gh workflow list && gh run list                    # CI/CD 워크플로우·실행
```

이 한 화면이 오늘 60분의 지도예요. 세 워크플로우(GitHub Flow·Git Flow·Trunk-based)의 차이, release와 deploy의 분리, 그리고 자경단이 고른 패턴이 이 명령들 안에 다 들어 있어요. 강사는 위에서 아래로 한 번 훑고 시작하면 돼요.

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 한 시간 쉬셨죠. 물 한 잔 드시고 오셨길 바라요.

지난 H1을 한 줄로 회수할게요. 협업 워크플로우는 다섯 명의 합의된 절차. 일곱 이유로 본인이 깊이 배워야 해요. 세 표준 패턴을 첫인상으로 봤어요. 충돌의 세 깊이도 봤고요.

이번 H2는 그 세 패턴을 깊이 들여다보고, 각 패턴의 장단을 비교하는 시간이에요. 그리고 release vs deploy의 결정적 차이, dev/staging/prod 환경 분리까지. 한 시간 후엔 본인이 자경단의 워크플로우를 결정할 수 있게 됩니다.

H1이 "왜 협업을 배우나"였다면, H2는 "협업을 어떤 개념으로 이해하나"예요. 큰 그림에서 개념으로 한 걸음 좁히는 거예요. 그리고 H2의 개념들(세 패턴·release/deploy·환경)이 H3부터 실제 도구로 손에 잡혀요. 그러니 오늘은 "아, 이런 개념이 있구나"를 머리에 그리는 데 집중하세요 — 손으로 만지는 건 다음 시간부터예요. 개념이 먼저 서야 도구가 의미를 가져요.

오늘의 약속. **본인이 어느 회사를 가도 그 워크플로우를 한 줄로 분류할 수 있게 됩니다**.

한 가지 미리 안심을. 오늘 단어가 많아요 — GitHub Flow, Git Flow, Trunk-based, release, deploy, feature flag, staging. 다 외우려 하지 마세요. 오늘은 "각 개념이 무슨 문제를 푸나" 한 줄씩만 손에 쥐면 충분해요. 세 패턴은 "통합 빈도", release/deploy는 "노출과 배포의 분리", 환경 셋은 "사고 격리". 세 한 줄이 오늘의 전부예요. 나머지 디테일은 H3~H8에서 손으로 익어요. 자, 가요.

---

## 2. 첫째 — GitHub Flow 깊이

GitHub Flow는 가장 단순한 패턴이에요. 2011년 GitHub의 공식 블로그에서 소개. 스타트업과 오픈소스의 표준.

규칙은 다섯 줄.

1. main이 항상 deployable.
2. 새 작업은 feature branch.
3. PR 만들어서 리뷰.
4. 리뷰 통과하면 머지.
5. 머지 후 즉시 배포.

이 다섯 줄에 모든 게 들어 있어요. 가장 단순. 가장 빠름. 그래서 자경단 표준이에요.

장점 — 단순해서 신입도 1주일에 익숙. release branch 없음. 짧은 사이클 (1~2일 작업).

단점 — release 시점 통제 어려움. 머지 즉시 prod. feature flag 없으면 미완성 코드 노출 위험.

자경단의 활용. 까미가 새 endpoint 짤 때 — 1) `git checkout -b feature/api-cats`, 2) commit 3~5건, 3) PR 만들기, 4) 본인이 리뷰, 5) 머지 + 자동 deploy. 1~2일 사이클.

자경단의 매주 PR이 약 15건. GitHub Flow의 효율이 자경단의 합주를 가능하게 해요.

GitHub Flow의 단점 하나를 더 깊이 볼게요 — "머지 즉시 prod"예요. 미완성 코드가 머지되면 사용자가 바로 봐요. 그래서 GitHub Flow엔 두 안전벨트가 필수예요. 하나는 **강력한 CI** — 머지 전에 자동 테스트·lint·타입 검사가 통과해야 머지 버튼이 활성화돼요(branch protection의 status check). 둘은 **작은 PR** — 미완성을 한꺼번에 머지하지 말고 완성된 작은 조각만 머지해요. 이 둘이 있으면 "머지 즉시 prod"가 위험이 아니라 속도가 돼요. CI 없는 GitHub Flow는 외줄타기, CI 있는 GitHub Flow는 안전망 위 줄타기예요.

또 하나, "release 시점 통제"는 tag로 보완해요. main에 계속 머지하되, 사용자에게 "버전"으로 알릴 땐 `git tag v1.1.0`을 찍어요. 그러면 단순한 GitHub Flow 위에 SemVer 버전 관리가 얹혀요(§7에서 깊이). 자경단은 매일 머지하지만 2주에 한 번 tag를 찍어 release를 묶어요. 단순함은 유지하면서 버전 통제를 더하는 거예요. GitHub Flow가 "단순해서 약하다"는 오해는, 이 tag 보완을 모르는 데서 와요.

자경단이 GitHub Flow를 고른 이유를 정리하면 다섯이에요. 하나, 다섯 명이라 단순함이 최고 가치(브랜치 다섯 종류를 챙길 인원이 없어요). 둘, 웹 서비스라 항상 최신 한 버전만 운영(여러 버전 지원 불필요). 셋, 매일 배포하고 싶음(빠른 사이클). 넷, 신입(까미·노랭이)이 첫날 바로 적응. 다섯, 오픈소스라 외부 기여자도 익숙. 이 다섯이 다 GitHub Flow를 가리켜요. **워크플로우 선택은 취향이 아니라 "우리 상황의 조건"에서 논리적으로 나와요.** 본인이 5년 차에 이 결정을 내릴 때도, "왜"를 다섯 줄로 댈 수 있어야 좋은 결정이에요. "남들이 쓰니까"는 이유가 아니에요.

---

## 3. 둘째 — Git Flow 깊이

Git Flow는 가장 무거운 패턴. 2010년 Vincent Driessen의 블로그 글에서 발표. 분기별 release가 있는 큰 회사의 표준.

다섯 종류의 브랜치.

1. **main** — production 배포된 코드.
2. **develop** — 개발 중인 코드.
3. **feature/** — 새 기능 개발.
4. **release/** — release 준비.
5. **hotfix/** — production 긴급 수정.

흐름. feature → develop → release → main. 각 단계에서 PR + 리뷰.

이 흐름을 한 번 따라가 볼게요. 까미가 새 기능을 `feature/`에서 만들어 `develop`에 머지해요(여기까진 GitHub Flow와 비슷). 분기 말, 그동안 develop에 쌓인 기능들을 `release/v2.0`이라는 브랜치로 따요. 이 release 브랜치에서 QA팀이 2주간 테스트하고 버그를 고쳐요(이 사이에도 develop엔 다음 버전 기능이 계속 쌓여요 — 그래서 두 줄이 필요해요). QA가 끝나면 release를 `main`에 머지하고 `v2.0` 태그를 찍어 출시, 동시에 `develop`에도 back-merge(QA 중 고친 버그를 다음 버전에도 반영). 다섯 브랜치가 이렇게 춤을 춰요. 정교하죠? 그래서 QA 주기가 분명한 큰 제품엔 강력하고, 매일 배포하는 작은 팀엔 과한 거예요. 같은 도구도 팀에 따라 약이 되고 독이 돼요.

장점 — release 시점 정확. 큰 변경의 통제. 분기별 release 자연.

단점 — 다섯 브랜치 종류 학습 비용. PR 사이클 길음 (1~2주). 변경 통합 느림.

Git Flow의 진짜 복잡함은 "두 곳에 머지"에 있어요. hotfix를 만들면 main과 develop 둘 다에 머지해야 해요(안 그러면 다음 release에서 그 수정이 사라지거든요). release 브랜치도 main과 develop 양쪽으로 back-merge해야 하고요. 이 양방향 머지를 깜빡하면 "고쳤는데 다시 터지는" 유령 버그가 나요. 그래서 Git Flow는 정교한 만큼 실수 지점도 많아요. 다섯 브랜치를 머리에 들고 양방향 머지를 챙기는 게 학습 비용의 정체예요.

그럼 Git Flow는 언제 맞을까요? **여러 버전을 동시에 유지·지원**해야 할 때예요. 예를 들어 기업용 소프트웨어가 v1.x를 쓰는 고객과 v2.x를 쓰는 고객을 둘 다 지원하면, 각 버전의 release 브랜치가 필요해요. 분기마다 정식 출시를 하고, 출시 전 QA 기간이 있고, 옛 버전에 hotfix를 보내야 하는 — 그런 무거운 제품에 Git Flow가 맞아요. 자경단처럼 항상 최신 한 버전만 운영하는 웹 서비스엔 과해요. 자경단은 Git Flow를 안 써요. 큰 회사라면 만나요. Adobe, Microsoft, 큰 금융권. 도구가 무거운 게 나쁜 게 아니라, 무거운 도구를 가벼운 일에 쓰는 게 나쁜 거예요.

---

## 4. 셋째 — Trunk-based 깊이

Trunk-based는 main 하나에 모든 게 모이는 패턴. Meta, Google, Netflix의 표준.

규칙. 모두가 main에 직접 (또는 짧은 branch). 매일 머지. feature flag로 미완성 코드를 production에서 가림.

장점 — 통합 빠름. branch 격리 비용 0. 충돌 적음 (자주 머지).

단점 — feature flag 인프라 필요. 강력한 CI 필요. 신입엔 빠름.

핵심은 **feature flag**. 미완성 코드를 main에 머지하되, flag로 사용자에게 안 보이게. 점진적 배포 가능.

feature flag를 조금 더 깊이 볼게요. flag는 다섯 종류예요. **release flag**(완성된 기능을 언제 켤지), **experiment flag**(A/B 테스트), **ops flag**(트래픽 폭주 시 무거운 기능 끄기), **permission flag**(특정 사용자에게만), **kill switch**(사고 나면 즉시 끄기). 이 다섯이 있으면 코드를 배포하는 것과 사용자에게 보이는 것을 완전히 분리할 수 있어요(§7 release vs deploy의 핵심). 그래서 Trunk-based는 "매일 머지하되 위험은 flag로 가린다"가 가능해요.

다만 Trunk-based의 전제가 무거워요 — 미완성 코드가 main에 매일 들어오니, CI가 1분 안에 모든 걸 검증하고, flag 인프라가 탄탄하고, 모니터링이 즉각적이어야 해요. 이 인프라가 없으면 main이 매일 깨져요. 그래서 빅테크(성숙한 인프라)의 패턴이에요. 자경단은 GitHub Flow가 기본이지만, 큰 변경엔 trunk-based 일부 차용 — "매일 머지" 정신과 "큰 기능은 flag 뒤에" 습관만 가져와요. 패턴은 통째로 베끼는 게 아니라 좋은 조각만 가져오는 거예요. 자경단의 인프라가 Ch091 이후 자라면 Trunk-based로 더 옮겨갈 수 있어요.

규모로 한 번 느껴 볼게요. Google은 수만 명의 개발자가 하나의 거대한 저장소(monorepo)에 하루 수만 번 commit해요. 이걸 Git Flow로 하면? 브랜치가 수천 개 엉켜 마비돼요. 그래서 Trunk-based — 모두가 main에 바로, 작게, 자주 머지하고, 미완성은 flag로 가려요. 하루 수만 번 통합하니 conflict가 생길 틈이 없어요. Trunk-based는 "규모가 커질수록 오히려 단순한 게 답"이라는 역설을 보여줘요. 작은 팀엔 과하지만, 거대한 팀엔 거의 유일한 답이에요. 본인이 빅테크 면접에서 "monorepo를 어떻게 관리해요?"를 받으면, 답은 Trunk-based + feature flag예요.

---

## 5. 넷째 — 셋 패턴 한 표 비교

| 항목 | GitHub Flow | Git Flow | Trunk-based |
|------|-------------|----------|-------------|
| branch 종류 | 2 (main + feature) | 5 | 1 (main 또는 짧은 branch) |
| 사이클 | 1~2일 | 1~2주 | 매일 |
| 학습 비용 | 낮음 | 높음 | 중간 |
| 적용 회사 | 스타트업, 오픈소스 | 큰 회사 | 빅테크 |
| feature flag | 옵션 | 옵션 | 필수 |
| 자경단 평가 | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

자경단 — GitHub Flow + Trunk-based 일부.

이 표를 외우려 하지 말고, 한 축으로 이해하세요 — **"통합을 얼마나 자주 하나"**예요. Git Flow는 release 주기마다(가끔), GitHub Flow는 PR마다(자주), Trunk-based는 매일(가장 자주). 통합이 잦을수록 conflict는 작고 자주, 통합이 드물수록 conflict는 크고 가끔이에요. 그래서 "작게 자주"가 협업의 황금률인 거예요. 세 패턴은 사실 "통합 빈도"라는 한 다이얼의 세 위치예요. 본인이 이 다이얼을 이해하면, 셋을 외우지 않아도 새 패턴을 만나도 "아, 이건 통합을 이만큼 자주 하는 거구나"로 읽을 수 있어요.

선택의 황금 규칙. 작은 팀 (10명 이하)은 GitHub Flow. 분기별 release 있는 큰 회사는 Git Flow. 빅테크 + feature flag 인프라는 Trunk-based.

한 가지만 덧붙이면, 셋은 적이 아니라 친척이에요. 많은 회사가 셋을 섞어 써요 — GitHub Flow를 기본으로 하되 큰 기능엔 feature flag(Trunk-based 요소)를 더하고, 정식 출시 땐 release 태그(Git Flow 요소)를 찍는 식. 자경단도 그래요. 순수한 한 패턴을 고집할 필요 없어요. 본인 팀에 맞게 좋은 조각을 조립하는 게 진짜 실력이에요. 패턴 이름은 출발점이지 감옥이 아니에요. 세 패턴을 다 아는 본인이, 셋의 좋은 조각을 골라 자경단만의 워크플로우를 만들어요.

---

## 6. 다섯째 — branch 모델

브랜치 종류와 작명 규칙.

**main** (또는 master). production 배포된 코드. 자경단은 main 표준.

**feature/이름**. 새 기능. 예: `feature/cat-photo-upload`. 1~2일 라이프.

**fix/이름**. 버그 수정. 예: `fix/login-redirect-loop`.

**hotfix/이름**. production 긴급. 예: `hotfix/critical-data-loss`.

**chore/이름**. 잡일. 예: `chore/update-deps`.

자경단의 작명 규칙. **prefix/짧은-설명** (kebab-case). 5단어 이내. 영어 또는 한글-영어 혼합.

```bash
git checkout -b feature/cat-photo-upload
git checkout -b fix/login-redirect
git checkout -b chore/upgrade-fastapi
```

자경단 매일.

branch 작명에 왜 이렇게 신경 쓰냐면, 이름이 곧 소통이기 때문이에요. `feature/cat-photo-upload`를 보면 동료가 한눈에 "아, 고양이 사진 업로드 기능이구나"를 알아요. 반면 `test`나 `mybranch`는 아무 정보가 없어요. 다섯 명이 일하면 브랜치가 수십 개인데, 이름만 보고 뭘 하는 브랜치인지 알 수 있어야 해요. prefix는 GitHub에서 필터링도 되고, 자동화(CI가 `hotfix/` 브랜치엔 빠른 배포를 트리거)에도 쓰여요. 이름 한 줄이 소통이자 자동화의 입구예요. 그래서 첫날부터 일관된 작명을 — 나중에 고치려면 이미 수십 개가 엉켜 있어요. 작은 일관성이 큰 질서를 만들어요.

한 가지 자주 헷갈리는 것 — `fix/`와 `hotfix/`의 차이예요. `fix/`는 일반 버그 수정(평소 사이클, dev→PR→staging→prod), `hotfix/`는 prod가 지금 터진 긴급 수정(빠른 경로, 바로 prod)이에요. 둘을 구별하는 이유는 자동화가 달라서예요 — hotfix는 일부 검사를 건너뛰고 빠르게 배포하는 경로를 타거든요. 평소 버그를 hotfix로 올리면 "늑대가 나타났다"가 되고, 진짜 긴급을 fix로 올리면 대응이 늦어요. 이름 하나가 긴급도를 알리는 신호예요. 그래서 작명 규칙은 사소해 보여도 운영의 안전장치예요.

나머지 prefix도 짚어 둘게요. `chore/`는 빌드·의존성·설정 같은 잡일(기능도 버그도 아닌 것), `docs/`는 문서만, `refactor/`는 동작은 그대로 두고 구조만 개선, `test/`는 테스트 추가. 이 prefix들이 Conventional Commits의 접두사와 짝을 이뤄요(Ch004 회수) — `feat/` 브랜치엔 `feat:` commit, `fix/` 브랜치엔 `fix:` commit. 브랜치 이름과 commit 메시지가 같은 언어를 쓰니, 자동화(release-please)가 둘을 읽어 CHANGELOG를 만들어요. 일관된 작명이 자동화의 연료예요. 그래서 작명은 '취향'이 아니라 '시스템'이에요.

---

## 7. 여섯째 — release vs deploy

이 두 단어가 자주 같은 뜻처럼 쓰여요. 사실 다른 거예요.

**Release**. 코드를 사용자에게 노출. 새 버전 발표. v1.0.0 → v1.1.0.

**Deploy**. 코드를 서버에 올리기. 사용자 노출과 무관.

같은 코드를 deploy 했는데 release 안 할 수 있어요. 어떻게? feature flag로 가려서. 사용자는 옛 버전을 보지만, 코드는 새 버전이 prod에 올라가 있음. 점진적으로 flag를 켜서 5%, 10%, 50%, 100% 노출.

이 점진 노출(canary release라고도 해요)이 왜 강력하냐면, 사고를 작게 일찍 잡기 때문이에요. 새 기능을 100% 한 번에 켜면, 버그가 있을 때 전체 사용자가 당해요. 그런데 5%에게만 먼저 켜면, 버그가 5%에게만 보이고 본인이 모니터링으로 즉시 알아채 flag를 꺼요(kill switch). 95%는 아무것도 못 느껴요. **"한 번에 전부"는 도박, "조금씩 지켜보며"는 과학이에요.** 자경단도 큰 기능은 본인(메인테이너)에게 먼저, 그다음 내부 다섯 명, 그다음 사용자 10%, 점진적으로 켜요. 같은 코드라도 노출 속도를 조절하면 사고의 크기가 20분의 1로 줄어요.

자경단의 적용. 매주 deploy는 5번. release는 2주에 한 번. 다섯 deploy 중 두 번만 사용자에게 노출.

이 분리가 안전 배포의 비결이에요.

이게 왜 중요한지 한 장면으로. Meta가 2020년에 새 Reels 기능 코드를 6월에 prod에 deploy했어요. 그런데 사용자에겐 12월에야 release했어요 — 그 사이 6개월 동안 코드는 prod에 있었지만 feature flag로 꺼 둔 거예요. 내부 직원에게만 켜서 테스트하고, 1%·5% 점진 노출하다가, 준비됐을 때 100% release. deploy와 release를 분리하니 "배포의 위험"과 "출시의 타이밍"을 따로 관리할 수 있어요.

배포 전략도 이 분리 위에서 다양해져요. **rolling**(한 대씩 교체, Ch003 H8 회수), **blue-green**(똑같은 환경 둘을 두고 통째로 전환, 문제 시 즉시 롤백), **canary**(소수에게 먼저 보내 지켜보기), **feature flag**(코드는 다 배포하고 노출만 조절). 자경단은 작아서 rolling + feature flag 둘만 써요. 회사가 커지면 canary·blue-green을 더해요. 핵심은 "한 번에 전부"가 아니라 "조금씩, 되돌릴 수 있게"예요. 안전 배포의 모든 전략이 이 한 문장의 변주예요.

release를 매길 때 쓰는 SemVer를 한 번 짚을게요. `major.minor.patch` — 예 `2.1.3`. **major**(2)는 기존 사용자의 코드를 깨는 변경(breaking change), **minor**(1)는 호환되는 새 기능 추가, **patch**(3)는 버그 수정. 그래서 버전 번호만 봐도 "이 업데이트를 안심하고 올려도 되나"를 알아요 — patch·minor는 안심, major는 주의. Conventional Commits의 fix→patch, feat→minor, BREAKING→major가 이 SemVer에 자동으로 매핑돼요(Ch004 회수). 버전은 그냥 숫자가 아니라 "이 변경이 얼마나 위험한가"를 사용자에게 알리는 약속이에요. 그래서 버전을 함부로 올리면 안 되고, 규칙대로 올려야 사용자가 본인의 release를 신뢰해요.

---

## 8. 일곱째 — dev/staging/prod 환경 분리

자경단의 세 환경.

**dev**. 본인 노트북 또는 dev 서버. 매일 코드 짜는 곳. 사고 자유. 데이터 가짜.

**staging**. prod 비슷한 환경. 머지 직후 자동 deploy. 통합 테스트. 데이터 일부 진짜.

**prod**. 진짜 사용자가 쓰는 곳. 수동 또는 검증된 자동 deploy. 데이터 진짜.

자경단의 흐름. dev에서 짜고 → PR → staging 자동 deploy + 자동 테스트 → 검증 후 prod 머지 → prod 자동 deploy.

세 환경 분리가 사고 면역의 90%.

세 환경에서 가장 자주 실수하는 건 "환경별 설정"이에요. dev의 DB 비밀번호와 prod의 비밀번호는 달라야 하고(절대 코드에 안 박아요), 외부 API 키도 dev는 테스트 키·prod는 실제 키예요. 이 설정을 어떻게 관리하냐가 환경 분리의 진짜 일이에요 — `.env` 파일을 환경별로 두고(`.env.dev`·`.env.prod`), 비밀은 AWS Secrets Manager나 GitHub Secrets에 넣어요. `.env`는 절대 git에 안 올려요(.gitignore, Ch004 회수).

그리고 환경마다 "사고의 무게"가 달라요 — dev에서 DB를 통째로 날려도 가짜 데이터라 웃고 넘기지만, prod에서 같은 실수는 진짜 사용자 데이터예요. 그래서 prod 작업은 항상 한 박자 느리게, 두 번 확인하고, 가능하면 자동화(사람 손을 줄임)해요. 자경단은 prod 배포만 수동 트리거(사람이 버튼을 누름)로 둬요 — 나머지는 자동이지만 prod 노출은 사람이 마지막으로 확인하는 거예요. 환경 분리는 "사고를 어디서 쳐도 되는가"의 지도예요. dev는 놀이터, staging은 예행연습, prod는 무대.

staging이 왜 중요한지 한 번 더. 많은 사고가 "내 노트북(dev)에선 됐는데 prod에서 터지는" 형태예요 — 환경이 다르니까(DB 버전·OS·설정). staging은 그 간극을 메우는 예행연습이에요. prod와 똑같이 만든 staging에서 한 번 돌려 보면, "내 노트북에선 됐는데"를 prod 전에 잡아요. 그래서 staging은 "진짜 같은 가짜"예요 — 가짜라서 마음 놓고 깨고, 진짜 같아서 prod 사고를 미리 잡아요. 자경단은 PR마다 임시 preview 환경을 staging처럼 써서, 머지 전에 노랭이가 실제 화면을 클릭해 봐요. 무대에 오르기 전 예행연습 한 번이 망신을 막아요. 이 환경 분리와 설정 관리는 "Twelve-Factor App"이라는 유명한 12가지 원칙의 핵심이기도 해요 — 현대 클라우드 앱의 표준 설계예요. 그중 "설정을 환경변수로", "환경 동등성(dev/staging/prod를 최대한 비슷하게)" 두 가지가 오늘 배운 거예요. 본인이 Ch091 AWS에서 이 12원칙을 깊이 만나요. 오늘 환경 셋을 나눈 게 그 첫걸음이에요.

---

## 9. 여덟째 — 자경단 적용 결정

자경단의 한 페이지 결정.

**워크플로우** — GitHub Flow.
**branch 명명** — feature/fix/hotfix/chore prefix.
**커밋 메시지** — Conventional Commits.
**PR 사이즈** — 평균 200줄, 최대 500줄.
**리뷰** — 1명 이상, 본인이 메인.
**머지 방식** — Squash and merge.
**release** — 2주에 한 번 SemVer.
**deploy** — staging 자동, prod 수동 트리거.
**feature flag** — 큰 변경에 사용.

이 한 페이지가 자경단의 헌법.

이 한 페이지를 왜 "헌법"이라 부르냐면, 다섯 명의 모든 협업이 이 아홉 줄 위에서 돌기 때문이에요. 새 멤버가 들어오면 이 한 페이지만 읽으면 자경단의 일하는 법을 다 알아요. 그리고 헌법처럼, 이건 한 번 쓰고 끝이 아니라 매년 회고하며 고쳐요 — "PR 최대 500줄이 너무 빡빡했나?", "release 2주가 너무 길었나?". 살아 있는 합의예요. 본인이 H8에서 이 헌법을 `WORKFLOW.md`로 직접 써요. 그때 각 줄에 "왜"를 한 줄씩 붙이세요 — 규칙만 있으면 새 멤버가 어기고, 이유가 있으면 지켜요(H1 회수). 좋은 워크플로우 문서는 규칙집이 아니라 "왜 이렇게 일하는지"의 설명서예요.

한 줄 더 — 자경단이 "Squash and merge"를 고른 이유. PR 하나가 main에 한 commit으로 들어가니, main history가 깔끔해져요(중간의 "오타 수정", "리뷰 반영" 같은 지저분한 commit이 안 남아요). main의 `git log`가 "PR 단위 변경 이력서"가 되는 거예요. 대신 PR 안의 세세한 과정은 GitHub PR 페이지에 남으니 잃는 게 없어요. 깨끗한 main + 자세한 PR 기록, 두 마리 토끼예요. 회사마다 머지 방식(squash·merge·rebase)이 다르니 첫날 확인하세요 — 자경단은 squash 80%, 큰 기능은 일반 merge로 history를 보존해요.

---

## 10. 한 줄 분해

```bash
git checkout -b feature/cat-photo && git push -u origin feature/cat-photo && gh pr create --draft
```

GitHub Flow의 한 줄. branch 만들고 push하고 draft PR.

이 한 줄을 풀어 볼게요. `git checkout -b feature/cat-photo`로 feature 브랜치를 만들고(GitHub Flow 규칙 2), `git push -u origin`으로 원격에 올리고, `gh pr create --draft`로 draft PR을 만들어요. draft인 이유는 "아직 완성 전이지만 일찍 보여주기" 위해서예요 — 동료가 방향을 미리 확인해 주면, 다 만든 뒤 "이거 아닌데"를 듣는 비극을 막아요(early feedback). 완성되면 draft를 풀고(`gh pr ready`) 정식 리뷰를 요청해요. 이 한 줄이 GitHub Flow의 시작이고, 본인이 매일 아침 치는 첫 명령이에요. 워크플로우는 거창한 게 아니라 이런 한 줄의 습관이에요. 8개념을 다 배워도, 결국 매일 하는 건 이 한 줄이에요.

---

## 11. 흔한 오해 다섯 가지

**오해 1: "GitHub Flow가 늘 정답이다."** 소규모·웹 서비스엔 맞지만, 여러 버전을 동시 지원하는 제품엔 Git Flow가, 하루 수십 번 배포하는 빅테크엔 Trunk-based가 맞아요. "가장 단순한 게 늘 정답"은 함정이에요. 팀 상황에 맞는 게 정답이고, 그걸 고르는 게 실력이에요.

**오해 2: "Git Flow는 한물간 옛 도구다."** 만든 Driessen이 "매일 배포 팀엔 안 맞는다"고 덧붙인 건 맞지만, 여러 버전을 유지·지원하는 기업용 소프트웨어·금융권엔 여전히 현역이에요. 도구가 옛것이 아니라, 쓰임이 다를 뿐이에요. 본인이 그런 회사 가면 만나요.

**오해 3: "Trunk-based는 main에 막 머지하니 위험하다."** feature flag와 강력한 CI가 받쳐 주면 오히려 가장 안전해요. 작게 자주 통합하니 "integration hell"이 없고, 사고가 나도 flag로 1초에 꺼요. 위험한 건 인프라 없이 Trunk-based를 흉내 내는 거지, Trunk-based 자체가 아니에요.

**오해 4: "release랑 deploy는 같은 말이다."** 달라요. deploy는 코드를 서버에 올리는 기술적 사건, release는 사용자에게 노출하는 사회적 사건이에요. feature flag로 둘을 분리하면 "배포는 했지만 아직 안 켰다"가 가능해져요. 이 분리가 안전 배포의 핵심이에요. 작은 회사는 둘이 같지만, 큰 회사일수록 갈라져요.

**오해 5: "환경을 셋(dev·staging·prod)이나 두는 건 과한 부담이다."** 환경 분리는 부담이 아니라 사고 면역이에요. dev에서 마음껏 깨고, staging에서 통합을 검증하고, prod엔 검증된 것만 올려요. 환경이 하나면 본인의 실험이 곧 사용자의 사고예요. 셋을 나누는 5분의 셋업이 1년의 prod 사고를 막아요. 무료 도구로 시작할 수 있어요(Q4).

다섯 오해를 한 줄로 묶으면 — 협업 개념엔 "늘 옳은 정답"이 없어요. 상황에 맞는 답이 있을 뿐이에요. 단순함도, 정교함도, 속도도 각자의 자리가 있어요. 본인이 "이게 무조건 좋아"라는 생각이 들 때마다, "어떤 상황에서?"를 한 번 더 물으세요. 그 질문 하나가 본인을 패턴 추종자에서 패턴 선택자로 바꿔요.

---

## 12. 자주 받는 질문 다섯 가지

**Q1. 회사가 Git Flow를 쓰면 GitHub Flow가 더 좋다고 말해야 하나요?** 아니에요. 신입 첫해는 회사 표준을 그대로 따라요. Git Flow를 쓰는 데는 그 회사의 이유(여러 버전 지원·규제·QA 주기)가 있어요. 본인이 그 맥락을 모르고 "이게 더 좋아요"라고 하면 오히려 미숙해 보여요. 1년쯤 그 패턴을 충분히 겪고 불편을 진짜로 느낀 다음에, 데이터를 들고 제안하세요. 그게 신뢰받는 제안이에요.

**Q2. feature flag는 어떻게 시작해요?** 작게 시작해요. 처음엔 환경변수나 DB 칼럼 하나(`feature_like_button = true/false`)로도 충분해요. 규모가 커지면 LaunchDarkly(유료), Unleash·Flipt(오픈소스 무료) 같은 전용 도구로 옮겨요. 핵심은 "코드 배포와 기능 노출을 분리"라는 개념이지 도구가 아니에요. 자경단은 처음엔 환경변수로, Ch090 이후 Unleash로 진화해요.

**Q3. SemVer 버전을 자동으로 매길 수 있어요?** 네. Conventional Commits(feat·fix·BREAKING)를 쓰면 semantic-release나 release-please가 자동으로 버전을 정해요 — feat이면 minor 올리고, fix면 patch, BREAKING이면 major. 머지된 PR들의 접두사를 읽어 CHANGELOG까지 자동 생성해요. 첫 commit부터 접두사를 지킨 작은 규율이 여기서 자동화로 보답받아요(Ch004 회수).

**Q4. staging 환경은 비용이 많이 들지 않아요?** 작은 팀은 옵션이에요. 처음엔 PR마다 임시 preview 환경(Vercel·Netlify가 무료로 제공)으로 staging을 대신할 수 있어요. 트래픽이 커지고 통합 테스트가 중요해지면 정식 staging을 둬요. "환경 분리"가 중요하지 "비싼 staging"이 중요한 게 아니에요. 무료로 시작해서 필요할 때 키우세요.

**Q5. 개념이 너무 많아요(세 패턴·release/deploy·환경 셋). 다 외워야 해요?** 아니에요. 한 줄만 — "워크플로우는 합의를 도구로 강제하는 것"이고, "release는 노출, deploy는 올리기"이고, "환경은 사고를 격리"예요. 이 세 한 줄만 손에 쥐면 나머지는 H3~H8에서 손으로 익으며 채워져요. 개념을 외우는 게 아니라 이해하는 거예요. 이해한 건 안 잊어요.

**Q6. squash merge랑 그냥 merge랑 뭐가 달라요?** squash는 한 PR의 여러 commit을 하나로 합쳐 main에 넣어요. 그래서 main history가 "한 PR = 한 commit"으로 깨끗해져요(중간 "오타 수정", "다시" 같은 지저분한 commit이 안 남아요). 일반 merge는 모든 commit과 merge commit을 다 남겨 history가 복잡해지고요. 자경단은 squash 80%를 표준으로 써요. main은 읽기 쉬운 변경 이력서여야 하니까요.

**Q7. 매일 main을 rebase하라는데, rebase가 위험하지 않아요?** 본인 feature 브랜치를 main 위로 rebase하는 건 안전해요(공유 안 한 본인 브랜치니까). 위험한 건 "이미 공유된 브랜치(main)"를 rebase하는 거예요 — 그건 절대 금지. "본인 브랜치를 main 위로 매일 rebase"는 작은 conflict를 매일 푸는 좋은 습관이고, `git push --force-with-lease`로 안전하게 올려요. Ch004 H7의 황금 규칙 — 공유된 history는 rebase 금지, 본인 것은 자유.

---

## 13. 흔한 실수 다섯 가지 + 안심 멘트 — 협업 핵심 학습 편

마지막으로 협업 핵심 개념을 처음 만나는 본인이 자주 빠지는 학습 함정 다섯을 짚고 가요. 개념은 머리로 알아도 손이 안 따라오는 게 협업이에요 — "PR은 작게"를 알면서도 큰 PR을 올리고, "매일 rebase"를 알면서도 한 달 묵히거든요. 미리 함정을 알아 두면 본인이 빠질 때 빨리 빠져나와요.

첫 번째 함정, GitHub Flow와 Git Flow를 둘 다 채택. 안심하세요. **한 가지만.** 작은 팀은 GitHub Flow, 큰 팀은 Trunk-based. Git Flow는 무거워서 deprecated 추세. 이게 신입이 가장 자주 하는 실수예요 — 블로그에서 GitHub Flow를 보고 따라 하다가, 다른 글에서 Git Flow가 좋다니 그것도 섞고, Trunk-based 영상 보고 또 섞어요. 결과는 다섯 명이 서로 다른 패턴으로 일하는 카오스. 워크플로우는 "하나를 골라 다섯 명이 같이"가 핵심이에요. **어떤 패턴이든 다섯 명이 똑같이 따르면 좋은 워크플로우, 최고의 패턴이라도 제각각 따르면 나쁜 워크플로우예요.** 일관성이 패턴 선택보다 중요해요.

두 번째 함정, branch 이름을 일관되지 않게. 본인이 fix-bug, feature/login, bugfix-2 식으로. 안심하세요. **type/scope 패턴.** feat/login, fix/cache, docs/api. 첫날부터 일관.

세 번째 함정, PR description 비어 있음. 안심하세요. **What·Why·How 세 줄 최소.** 6개월 후 본인이 본인 PR 다시 볼 때 그 세 줄이 본인 살림.

네 번째 함정, code review를 꼼꼼히 안 함. 본인이 LGTM만 한 줄로. 안심하세요. **5분 투자가 5시간 사고 막아요.** 수정 제안 한 줄도 OK.

다섯 번째 함정, 가장 큰 함정. **conflict 무서워서 long-running branch.** 본인 feature branch 한 달. main 멀어짐. conflict 폭탄. 안심하세요. **매일 main rebase.** 작은 conflict 매일이 큰 conflict 한 달보다 100배 좋음. 이게 H1에서 본 "예방이 최선의 충돌 해결"의 구체적 실천이에요 — 충돌을 잘 푸는 법보다 충돌이 안 쌓이게 하는 습관이 강해요. branch를 짧게 살리세요. 1~2일이 표준, 1주 넘으면 위험 신호.

다섯 함정을 한 줄로 묶으면 — 협업의 사고는 대부분 "크게, 가끔, 혼자" 할 때 나요. 반대로 "작게, 자주, 함께"가 모든 함정의 해독제예요. 작은 PR, 자주 머지, 일관된 이름, 꼼꼼한 리뷰. 이 네 습관이 다섯 함정을 한 번에 막아요. 다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 14. 마무리 — 다음 H3에서 만나요

자, 두 번째 시간이 끝났어요.

세 패턴 깊이 (GitHub Flow, Git Flow, Trunk-based), 셋 비교, branch 모델, release vs deploy, 환경 분리, 자경단 적용.

오늘 한 줄 정리. **세 워크플로우는 "통합 빈도"의 세 위치이고, release는 노출·deploy는 배포로 분리되며, dev·staging·prod 환경이 사고를 격리한다.** 본인이 이 한 줄을 손에 쥐면, 어느 회사의 워크플로우를 만나도 "통합을 얼마나 자주 하고, release/deploy를 어떻게 분리하고, 환경을 어떻게 나눴나"로 읽을 수 있어요. 그게 H2의 졸업장이에요.

본인 페이스. 2/8 시간. 25%. 오늘 본인은 협업의 "개념 지도"를 받았어요. H1에서 큰 그림(왜)을 봤다면, H2에서 그 그림의 좌표(개념)를 찍었어요. H3부터는 이 좌표 위에 도구를 깔아요 — team GitHub, branch protection, CODEOWNERS, husky. 개념을 손에 쥔 본인이 이제 도구를 만질 준비가 됐어요. 박수.

다음 H3는 환경점검. team GitHub 셋업, branch protection, CODEOWNERS, husky.

```bash
gh repo view --web
```

이 한 줄을 치면 본인 저장소가 브라우저에 떠요. Settings → Branches를 한 번 눌러 보세요. 지금은 비어 있을 거예요. H3 끝엔 거기에 branch protection 규칙이 박혀 있을 거고요. 오늘 배운 개념(워크플로우·release/deploy·환경)이 다음 시간 그 화면에서 도구로 살아나요. 개념을 머리에 그린 본인이, 이제 그 개념을 손으로 박을 준비가 됐어요. 5초예요. 본인의 H2 졸업장이에요. 잘 따라오셨어요. 한 시간 후 H3에서 만나요.

---

## 👨‍💻 개발자 노트

> - GitHub Flow vs GitLab Flow: GitLab은 staging branch 추가.
> - feature flag 도구: LaunchDarkly, Unleash, Flipt.
> - SemVer: major.minor.patch. major=breaking, minor=feature, patch=fix.
> - Conventional Commits: feat:, fix:, chore:, docs:, refactor:, test:.
> - 환경 변수 관리: dotenv, AWS Secrets Manager.
> - 다음 H3 키워드: GitHub team · branch protection · CODEOWNERS · husky · SSH key.

---

## 추신

1. 어느 회사 워크플로우든 한 줄로 분류해요 — 어떤 합의를 어떤 도구로 강제하나.
2. 세 패턴 한 줄 — GitHub Flow 단순·Git Flow 무거움·Trunk-based 속도.
3. GitHub Flow 다섯 규칙 — main 배포가능·feature 브랜치·PR 리뷰·머지·배포.
4. GitHub Flow엔 CI가 안전벨트. CI 없으면 외줄타기예요.
5. tag로 GitHub Flow 위에 SemVer 버전을 얹어요. 단순함 + 버전 통제.
6. Git Flow 다섯 브랜치 — main·develop·feature·release·hotfix.
7. Git Flow의 함정은 양방향 머지. hotfix를 main과 develop 둘 다에.
8. Git Flow는 여러 버전 동시 지원에 맞아요. 한 버전 웹 서비스엔 과해요.
9. Trunk-based는 매일 머지 + feature flag로 위험 가림.
10. feature flag 다섯 — release·experiment·ops·permission·kill switch.
11. Trunk-based 전제 — 1분 CI·flag 인프라·즉각 모니터링.
12. 패턴은 통째로 베끼는 게 아니라 좋은 조각만 가져와요.
13. release ≠ deploy. deploy는 서버에 올리기, release는 사용자에게 노출.
14. 같은 코드를 deploy하고 flag로 안 켜면 = release 안 한 deploy.
15. 점진 노출 — 5%·10%·50%·100%. 사고를 작게 일찍 잡아요.
16. SemVer — major(breaking)·minor(feature)·patch(fix).
17. 환경 셋 — dev(사고 자유)·staging(prod 복제)·prod(진짜 사용자).
18. dev→PR→staging 자동→검증→prod. 환경 분리가 사고 면역 90%.
19. branch 이름은 type/짧은-설명 kebab-case. 첫날부터 일관되게.
20. PR은 작게. 큰 PR은 리뷰 한숨, 작은 PR은 5분 승인.
21. squash merge로 main history를 깨끗하게 — 한 PR = 한 commit.
22. long-running branch는 conflict 폭탄. 매일 main을 rebase하세요.
23. 작은 conflict 매일이 큰 conflict 한 달보다 100배 나아요.
24. WORKFLOW.md가 자경단의 헌법. 합의를 글로 적어요.
25. Conventional Commits가 자동 release(semantic-release)의 씨앗.
26. 회사 워크플로우가 본인 취향보다 우선. 의견은 1년 후.
27. 도구가 무거운 게 문제가 아니라, 무거운 도구를 가벼운 일에 쓰는 게 문제.
28. 면접 단골 — Git Flow vs Trunk-based, release vs deploy 구별.
29. 5년 차엔 본인이 이 결정(워크플로우·환경·release 주기)을 내리는 사람이 돼요.
30. SemVer는 변경의 위험도를 알리는 약속 — major 주의, minor·patch 안심.
31. release 태그를 함부로 올리면 사용자 신뢰가 깨져요. 규칙대로 올려요.
32. Git Flow는 다섯 브랜치의 춤 — 양방향 back-merge를 챙겨야 해요.
33. Trunk-based의 역설 — 규모가 클수록 단순한 게 답이에요.
34. staging은 "진짜 같은 가짜". 무대 전 예행연습이 망신을 막아요.
35. .env는 환경별로, 비밀은 Secrets Manager로. git엔 절대 안 올려요.
36. squash merge로 main은 깨끗하게, PR 페이지에 자세히. 두 마리 토끼.
37. 세 패턴은 적이 아니라 친척. 좋은 조각을 골라 조립하는 게 실력.
38. 점진 노출이 사고를 20분의 1로. "한 번에 전부"는 도박, "조금씩"은 과학.
39. 일관성이 패턴 선택보다 중요 — 다섯이 똑같이 따르면 좋은 워크플로우.
40. "이게 무조건 좋아" 싶을 때 "어떤 상황에서?"를 한 번 더 물어요. 그 질문이 추종자를 선택자로 바꿔요.
41. 다음 H3는 환경점검 — team GitHub·branch protection·CODEOWNERS·husky. 5분 쉬고 H3에서 만나요. 🐾
