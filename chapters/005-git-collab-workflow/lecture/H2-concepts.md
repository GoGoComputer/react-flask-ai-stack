# Ch005 · H2 — 협업 워크플로우 핵심 개념: 세 패턴 깊이 + branch 모델 + release vs deploy + 환경 분리

> **이 H에서 얻을 것**
> - **세 패턴 깊이** — GitHub Flow / Git Flow / Trunk-based의 branch 모델·release 주기·hotfix 처리.
> - **branch 모델 한 페이지** — 각 패턴의 branch 그래프를 손가락으로 그릴 수 있게.
> - **release ≠ deploy** — 두 단어를 분리하면 큰 회사가 매일 deploy하면서도 사용자엔 안정적인 비밀이 풀려요.
> - **환경 분리** — dev / staging / prod 3환경의 의미와 자경단 적용.

---

## 회수: H1의 첫인상에서 H2의 이론으로

지난 H1에서 본인이 셋 패턴(GitHub Flow·Git Flow·Trunk-based)의 첫인상과 충돌 3깊이를 만났어요. **첫인상**이었어요. 이번 H2는 **이론**이에요. 같은 셋 패턴을 깊이 봐요. branch 그래프를 손가락으로 그릴 수 있게, release와 deploy의 단어 차이를 손에 잡을 수 있게, dev·staging·prod 3환경이 왜 필요한지 머리에 박을 수 있게.

**왜 깊이 보나요?** 첫인상만으론 본인이 회사에 가서 "우리는 Git Flow예요"를 들었을 때 1주일을 헤매요. 깊이 한 번 보면 1시간 안에 적응. 그리고 5년 후 본인이 워크플로우를 디자인하는 자리에 갔을 때 셋 패턴의 장단을 본인 머리에서 끌어낼 수 있어야 결정이 가능. **신입의 1시간 적응이 시니어의 1시간 결정으로 이어져요**. H2가 그 다리.

본 H의 큰 흐름 — 세 패턴을 차례대로 깊이 본 후, 셋의 공통 분모(branch 모델·release vs deploy·환경 분리)를 추출해 한 표로 정리. 마지막에 자경단이 어느 패턴인지·왜 그 패턴인지·5년 후 어디로 갈지를 한 페이지.

---

## 1. GitHub Flow 깊이 — 단순함의 미학

**한 줄 요약 (재등장)**: main 한 개 + feature branch 여러 개 + PR 한 번 + 머지 후 즉시 deploy.

### 1-1. branch 모델 그래프

```
main ●────●────●────●────●────●────●────●────●────●→ (production)
          │                   │              │
          ●─●─● feat/cat-card ●─●─● feat/login ●─●─● fix/typo
                ↑PR머지              ↑PR머지        ↑PR머지
```

**규칙 5줄**:
1. main은 항상 deploy 가능 상태.
2. 새 기능·수정은 main에서 branch를 따요(`git switch -c feat/x`).
3. branch에서 자유롭게 commit, 자주 push.
4. 준비되면 PR 만들고 리뷰 받고 머지.
5. 머지된 branch는 자동 삭제(또는 손으로). main은 즉시 deploy.

**5줄이 끝**. 이게 GitHub Flow의 전부예요. branch 종류가 main + feature 둘뿐. 새 멤버가 1시간 안에 이해. Scott Chacon이 2011년 GitHub 블로그에 한 페이지로 정리한 후 사실상 업계 기본이 됐어요. 단순함이 무기이자 정체성. **단어 수가 적을수록 합의가 빨라요**. 5줄짜리 워크플로우는 5명이 5분 안에 합의 가능. 50줄짜리 워크플로우는 5명이 5시간 회의해도 합의가 안 나요. 단순함이 합의의 비용을 줄여요.

### 1-2. release 주기

GitHub Flow는 **release 개념이 거의 없어요**. main이 곧 production. 매일 머지 = 매일 deploy. release v1.0·v2.0 같은 마일스톤이 없거나 매우 가벼워요. SaaS 같은 continuous deployment 환경에 자연스러워요. 사용자에게 "이번 주 화요일에 새 기능이 나왔어요"가 release 노트의 전부.

다만 실무에선 GitHub Flow를 쓰면서도 **태그(tag)**로 release를 가볍게 표시해요. 매주 금요일 17:00에 `git tag v0.5.0 && git push origin v0.5.0` 한 줄. 그 시점의 main commit에 라벨을 붙여서 "이게 v0.5.0이에요"를 표시. 사용자에겐 같은 production이지만 본인 팀 내부엔 마일스톤. **태그는 가볍지만 의미는 무거워요**.

### 1-3. hotfix 처리

GitHub Flow엔 hotfix branch가 따로 없어요. **사고가 나면 그냥 새 feature branch 따서 PR**. 빠르게 리뷰 1명·CI 통과 후 머지. main이 곧 production이라 별도 release branch가 필요 없어요. 단순함의 또 한 번 미학.

다만 빠르게 처리하려고 보호장치를 우회하면 사고. branch protection은 지키고, 다만 리뷰어 수를 1명으로 낮추거나(평소 2명 → 긴급 1명), CI를 빠른 모드로(전체 테스트 → 핵심 테스트만) 돌리는 식의 조정. **빠른 길도 길은 길**, 보호장치는 살아 있어야.

### 1-4. 누가 쓰나·언제 안 맞나

**잘 맞는 회사**: 5명 미만 스타트업, 오픈소스, 자경단 같은 작은 팀, SaaS, continuous deployment 환경. **잘 안 맞는 회사**: release 일정이 명확한 대형 제품(매년 v1·v2 식 메이저 release), 제3자 인증(FDA·금융·항공)이 release 단위로 필요한 곳, branch 별 동시 유지보수가 필요한 곳(v1.0 사용자와 v2.0 사용자가 동시 존재).

자경단은 GitHub Flow가 정답. Ch005 전체가 자경단을 GitHub Flow로 굴리는 챕터.

### 1-5. 한 가지 함정

GitHub Flow의 단순함이 함정으로 작동하기도 해요. branch가 길어지면(>1주) integration hell. 본인이 feat/big-feature를 2주 동안 따로 짜면 main이 그동안 100개 commit 갱신돼서 머지 시 conflict 폭발. **GitHub Flow의 단순함은 "branch 짧게"가 전제**. 매일 main에서 rebase, 일주일 안에 머지. 못 지키면 단순함이 아니라 지옥.

또 한 함정 — main이 곧 production이라 main에 commit 한 번이 사용자에게 즉시 영향. CI가 빠지면 사용자 화면이 깨져요. CI가 단단해야 GitHub Flow가 작동. **CI는 GitHub Flow의 안전벨트**. 안전벨트 없는 GitHub Flow는 사고 직행.

---

## 2. Git Flow 깊이 — 정교함의 비용

**한 줄 요약 (재등장)**: main + develop + feature + release + hotfix 다섯 종류 branch.

### 2-1. branch 모델 그래프

```
main      ────────●────●─tag-v1.0──────●─tag-v1.1──────●─tag-v2.0──→
                  ↑release back-merge   ↑hotfix          ↑release
                  │                     │                │
develop   ──●──●──●──●──●──●──●──●──●──●──●──●──●──●──●──●──→
            │     │  │              │
            ●─●─● │  ●─●─● feat/x   │
                  │                 │
                  release/1.0       hotfix/1.0.1
```

**5종 branch의 역할**:
- **main**: production 안정 상태. 직접 commit 금지. release·hotfix만 머지. 항상 사용자 손에 있는 코드.
- **develop**: 다음 release를 위한 통합. feature가 머지되는 곳. "다음 v2.0이 될 후보".
- **feature/***: 새 기능. develop에서 따서 develop으로 머지.
- **release/***: 다음 release 준비. develop에서 따서 QA·버그 수정 후 main으로 머지(+develop으로 back-merge).
- **hotfix/***: production 긴급 수정. main에서 따서 main + develop 둘 다로 머지.

5종이 5규칙. 새 멤버가 1주일 동안 헤매요. "지금 어디에 commit해야 하지?"가 매일 질문. 본인이 Git Flow 회사에 신입으로 가면 첫 주 월요일에 동료에게 "이 작업은 어디서 시작해야 하나요?"를 5번 묻게 돼요. 부끄럽지 않아요 — 5종 branch는 모든 신입의 통과의례. 5번 물으면 손가락이 익혀져요. 그 후엔 자동. **5번의 질문이 5년의 자산**. 신입의 한 주 헤맴이 시니어의 한 시간 결정으로 이어져요.

### 2-2. release 주기

Git Flow의 핵심이 **release branch**. develop이 충분히 모이면 `git switch -c release/1.0 develop`. 이 branch에서 QA·테스트·문서·버그 수정. 새 기능은 못 들어가요. 안정화만. 준비되면 main으로 머지(+ tag v1.0) + develop으로 back-merge(release branch 동안 수정한 버그를 develop에도 적용).

이 패턴은 **분기·반기 release 리듬**에 자연스러워요. 게임 회사가 분기마다 큰 패치, SaaS 큰 회사가 반기마다 메이저 release, 모바일 앱이 매월 새 버전 — 다 Git Flow.

### 2-3. hotfix 처리

production 사고가 나면 main에서 `git switch -c hotfix/1.0.1 main`. 수정 후 main으로 머지(+ tag v1.0.1) + develop으로도 머지(같은 버그가 develop에도 있으니). **두 곳에 다 머지**가 핵심. 한 곳만 머지하면 다음 release에서 같은 버그가 다시 나와요(regression).

### 2-4. 누가 쓰나·언제 안 맞나

**잘 맞는 회사**: 50명+ 큰 회사, 분기·반기 release, 게임·은행·항공 같은 안정성 우선 제품, v1.0·v2.0 사용자가 동시에 존재(병행 유지보수). **잘 안 맞는 회사**: 매일 deploy하는 SaaS, 5명 미만 작은 팀, 인프라가 부족한 스타트업.

### 2-5. 작가의 갱신

Vincent Driessen이 2010년에 Git Flow 블로그를 쓴 후 사실상 표준이 됐어요. 모든 git 책에 등장. 그러다가 **2020년 작가 본인이 글에 "이젠 모든 팀에 권하지 않는다"고 갱신**했어요. 이유 — continuous deployment 환경이 늘어났고, Git Flow의 5종 branch가 그런 환경엔 과한 무게. 작가도 인정한 진화. **워크플로우는 시대를 따라가요**. 본인이 신입으로 입사한 회사가 Git Flow를 쓰면 "전통 산업·큰 회사구나"를 추측. continuous deployment를 쓰면 "스타트업·SaaS구나"를 추측. 패턴이 회사의 성격을 보여줘요.

### 2-6. 자경단은 안 맞아요

자경단 5명에 Git Flow를 적용하면 매일 "지금 어느 branch에 commit해야 하지?"가 발생. 5종 branch 합의가 5명에 부담. develop이 비어 있는 날도 많고, release branch를 따도 거기에 머지할 게 없을 수도. **5명에 5종 branch는 1:1 비율**. 과해요.

다만 본인이 큰 회사 입사 시 만나니 알고 있어야. Ch005가 자경단 적용은 GitHub Flow지만 Git Flow의 이론도 다뤄요. **이론을 알면 어느 패턴도 적응**.

---

## 3. Trunk-based 깊이 — 자동화의 끝

**한 줄 요약 (재등장)**: main 한 개에 모든 사람이 매일 매시간 머지. branch는 짧게(1일 미만). feature flag로 미완성 기능을 숨겨요.

### 3-1. branch 모델 그래프

```
main ──●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─●─→
       (50명이 매시간 머지)
       ↑ feature flag 0/1 토글로 미완성 기능 숨김
       ↑ release branch는 별도(필요 시) — main에서 잘라 production 정지 시점 표시
```

**규칙 5줄**:
1. branch는 1일 미만. 길어지면 무조건 머지(또는 폐기).
2. 미완성 기능은 feature flag(`if (FLAG_NEW_LOGIN) { ... }`)로 숨김. main에 코드는 들어가도 사용자엔 안 보여요.
3. PR은 작게(<300줄). 리뷰 1명·CI 통과 후 매시간 머지.
4. release는 main의 한 시점을 잘라서 표시(별도 branch 또는 tag).
5. 사고는 hotfix 대신 feature flag off 또는 revert(`git revert`).

5규칙이 5규칙. 다만 모든 규칙의 전제가 **CI/CD 인프라 + feature flag 시스템 + 자동 모니터링**. 인프라가 빠지면 5규칙이 위험. 본인이 Trunk-based를 회사에서 만나면 그 회사의 인프라가 5년 이상 다듬어진 결과. 회사 첫 주 월요일에 "우리 CI는 무엇으로?·deploy 도구는?·feature flag 도구는?" 셋을 물어요. 답을 알면 본인이 매일 손가락 어디에 둘지 결정 가능. **인프라가 패턴의 전제**, 패턴은 인프라의 결과.

### 3-2. release vs deploy 분리의 정점

Trunk-based가 release vs deploy 분리를 가장 깊이 활용. **deploy는 매일 100번**(main의 새 commit이 production 서버에 자동 올라감), **release는 분기에 한 번**(사용자에게 새 메이저 기능을 알리는 사회적 이벤트). 둘이 완전히 다른 일.

예 — Meta가 2024년 12월에 새 Reels 기능을 release 했다고 사용자에게 알림. 그 기능 코드는 사실 2024년 6월에 main에 머지됐어요. feature flag로 6개월 동안 숨겨져 있다가 12월에 flag on. **deploy는 6월, release는 12월**. 사용자에겐 12월이 의미. 본인 팀 내부엔 6월이 의미. 두 단어가 다르다는 게 큰 회사의 비밀.

### 3-3. hotfix 처리

Trunk-based엔 hotfix branch가 사실상 없어요. 사고가 나면 두 길:
1. **feature flag off** — 사고 원인이 새 기능이면 flag를 0으로. 코드는 그대로, 사용자에겐 안 보임. 1초 작업.
2. **revert commit** — 사고 원인이 일반 변경이면 `git revert <bad-commit>`로 main에 역commit. 1분 작업.

둘 다 main에 직접. branch 따지 않아요. **hotfix가 일상의 손가락**. 그만큼 자동화·CI·feature flag 인프라가 단단해야 가능.

### 3-4. 누가 쓰나·언제 안 맞나

**잘 맞는 회사**: Google·Meta·Netflix·Spotify·Microsoft 일부 팀. CI/CD가 완벽, 자동 테스트 90%+, 자동 deploy, feature flag 인프라 완비, 50명+ 또는 100명+ 팀. **잘 안 맞는 회사**: 인프라가 없는 작은 팀(매일 production 사고), 안정성 우선 산업(은행·의료·항공), 사용자가 버전을 의식하는 제품.

### 3-5. feature flag 깊이

Trunk-based의 핵심 무기가 feature flag. 한 줄로 — **`if (FLAG_X) { 새코드 } else { 옛코드 }`** 로 미완성·실험 기능을 숨기는 토글. flag 종류 5가지:
- **release flag**: 미완성 기능을 숨김. 완성되면 on, 코드 정리 후 flag 제거.
- **experiment flag**: A/B 테스트. 사용자 50%엔 A, 50%엔 B.
- **ops flag**: 운영 토글. 사고 시 즉시 off.
- **permission flag**: 사용자 권한별 노출. 베타 사용자만 on.
- **kill switch**: 위험한 기능을 즉시 off하는 비상 스위치.

5종 flag를 잘 관리하면 trunk-based가 작동. 못 관리하면 코드베이스가 if·else 미궁. **flag cleanup**(완료된 flag를 제거하는 작업)이 별도 일이에요. 매주 정리. Ch090에서 깊이.

### 3-6. 자경단은 Ch090 이후

자경단도 Ch090(feature flag) + Ch103(DevOps) + Ch118(GitOps) 이후엔 trunk-based로 갈 수 있어요. 다만 그 전엔 GitHub Flow. 인프라가 부족한 trunk-based는 사고. **인프라 없는 자동화는 자살**. Ch005~Ch089 동안 자경단은 GitHub Flow.

---

## 4. 셋 패턴 한 표 (재등장 + 깊이)

| 항목 | GitHub Flow | Git Flow | Trunk-based |
|------|------------|---------|-------------|
| branch 종류 | main + feature | main + develop + feat + release + hotfix | main(+ 짧은 feat) |
| branch 수명 | 1일~1주 | 1주~3개월 | 1일 미만 |
| release 주기 | 수시 | 분기·반기 | deploy 매일 100회, release 분기 |
| hotfix | feature branch로 처리 | hotfix branch | flag off 또는 revert |
| feature flag | 선택 | 거의 안 씀 | 필수 |
| CI 단단함 | 필수 | 권장 | 절대 필수 |
| 적합 팀 크기 | <50명 | 50명+ | 50명+ (인프라 완비) |
| 학습 곡선 | 1시간 | 1주일 | 1달 |
| 유래 | Scott Chacon (GitHub) 2011 | Vincent Driessen 2010 (2020 갱신) | Google·DORA 연구 2017 |
| 자경단 | ✅ 정답 | ❌ 과함 | △ Ch090+ 후 검토 |

**한 가지 결정 트리**:
- 팀 5명 미만? → GitHub Flow.
- 5~50명, release 주기 명확? → Git Flow 또는 GitHub Flow 변형.
- 50명+, 인프라 완비? → Trunk-based 검토.
- 50명+, 인프라 부족? → GitHub Flow + Conventional Commits로 시작, 인프라 갖춰지면 Trunk-based로 진화.

**또 한 가지 — 패턴은 섞여요**. 실제 회사는 100% 한 패턴이 아니에요. "GitHub Flow + release 태그(Git Flow의 release 개념 빌림) + 일부 trunk-based 요소(feature flag)" 식의 혼합. 본인이 입사하면 그 회사의 혼합 비율을 파악하는 게 첫 주의 일. **순수 패턴은 책에만 존재, 실무는 다 혼합**.

---

## 5. branch 모델 — 한 페이지 정리

세 패턴의 branch 모델을 한 페이지로 압축. 본인이 손가락으로 그릴 수 있게.

### 5-1. GitHub Flow 한 줄

```
main ━━━●━━━●━━━●━━━●━━━●━━━●━━━●━━━●━━━●━━━●━→
        ↑    ↑    ↑    ↑    ↑    ↑    ↑    ↑
        feat feat feat feat feat feat feat feat
        머지 머지 머지 머지 머지 머지 머지 머지
```

**그리는 법**: 가로 직선 하나(main) + 위에서 feature branch가 짧게 내려와 머지. 끝.

### 5-2. Git Flow 두 줄 + 가지

```
main    ━━━━━━━━━━━━●─tag1.0━━━━━●─tag1.1━━━━●─tag2.0━→
                    ↑release      ↑hotfix     ↑release
                    │             │           │
develop ━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━━━→
         ↓     ↓     ↓
         feat  feat  feat (develop에 머지)
```

**그리는 법**: 가로 두 줄(main 위, develop 아래) + feature가 develop에서 시작·종료 + release branch가 develop→main 다리 + hotfix가 main→main+develop.

### 5-3. Trunk-based 한 줄 + 점

```
main ━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━●━→
      ↑매시간 머지        ↑release tag (별도 branch 거의 없음)
      ↑feature flag로 미완성 숨김
```

**그리는 법**: 가로 직선 하나, 점이 매우 촘촘. branch가 거의 없거나 매우 짧음. release tag만 가끔.

### 5-4. 손가락으로 그리는 게 왜 중요한가

본인이 머릿속에 branch 그래프가 그려지면 워크플로우 사고가 빨라요. "지금 우리 main이 어디?"·"이 feature는 어디서 시작?"·"머지 후 어디로 가나?"가 머리에서 자동. 면접에서 "Git Flow의 release branch 흐름을 설명해 보세요"를 물었을 때 손가락이 자동으로 가지 모양을 그려요. **그래프가 머리에 박히면 사고가 머리에 박혀요**.

본 챕터 H4(카탈로그)에서 명령어 23개 + 본 H의 그래프 셋이 짝지어져요. 명령어가 그래프를 만들고, 그래프가 명령어를 정당화. 둘이 같이 머리에 박히면 git의 표면이 본인 손에 잡혀요.

---

## 6. release ≠ deploy — 두 단어의 결정적 차이

협업 워크플로우에서 가장 자주 헷갈리는 두 단어. 둘이 다르다는 걸 알면 큰 회사의 비밀이 풀려요.

### 6-1. 단어 정의

- **deploy(배포)**: 서버에 새 코드를 올리는 **기술적 사건**. `git push` → CI 통과 → production 서버 갱신. 사용자는 모를 수도 있어요.
- **release(공개)**: 사용자에게 새 버전을 알리는 **사회적 사건**. 새 기능 안내·release 노트·마케팅. 코드는 이미 deploy됐을 수도 있어요.

**한 줄 차이**: deploy는 코드의 일, release는 사람의 일. 코드는 매시간 움직여도 사람의 알림은 매주·매분기에 한 번. 자동화의 시대일수록 둘이 더 멀어져요. 자동화 이전엔 deploy가 어려운 사건(새벽 2시 작업·서버 재시작·다운타임)이라 deploy = release가 자연스러웠어요. 지금은 deploy가 1초 자동, release는 사용자 알림 한 번. **시대가 두 단어를 분리**. 본인의 자경단은 작은 팀이라 둘이 거의 같지만, 본인이 5년 후 큰 회사 가면 둘이 100:1 비율로 멀어져요.

### 6-2. 작은 회사: deploy = release

자경단 5명이 GitHub Flow로 굴리면 deploy와 release가 같아요. 화요일 14:00에 PR 머지 → 자동 deploy → 사용자에게 새 기능 노출. 같은 사건. release 노트는 가벼워요(슬랙 메시지 한 줄). 단순함의 또 한 미덕.

### 6-3. 큰 회사: deploy ≫ release

Meta가 매일 main에 100개 commit + 100번 deploy. 다만 사용자에겐 분기에 한 번 release 알림. **deploy 100회 : release 1회 = 100:1 비율**. 어떻게? feature flag로 미완성 기능을 숨겨요. 코드는 deploy됐지만 flag가 0이라 사용자 화면엔 안 나타남. 분기 말 release 시점에 flag를 1로 토글 + 마케팅 발표. 그 순간 사용자에겐 "새 기능이 나왔다"가 돼요.

이 분리가 큰 회사의 비밀. **매일 deploy하면서도 사용자에겐 안정**. deploy는 자주(빠른 피드백), release는 가끔(사용자 안정·마케팅 타이밍).

### 6-4. release 종류 4가지

- **major release (v2.0)**: 큰 변경. UI 개편·아키텍처 변경. 사용자 마케팅·문서·공지 큰 일.
- **minor release (v1.5)**: 새 기능 추가. 사용자 release 노트.
- **patch release (v1.0.1)**: 버그 수정. 가벼운 release 노트.
- **hotfix release (v1.0.2)**: 긴급 사고 수정. release 노트 없거나 사후 공지.

이 분류가 **SemVer(Semantic Versioning) 2.0.0** 표준. major.minor.patch 세 숫자. 본인이 자경단 release 시 이 분류를 따라요. `v0.1.0`(첫 alpha), `v1.0.0`(첫 stable), `v1.5.0`(새 기능), `v1.5.1`(버그 수정).

### 6-5. deploy 종류 4가지

- **rolling deploy**: 서버를 한 대씩 새 버전으로 교체. 가장 흔함. 다만 일시적으로 두 버전이 공존.
- **blue-green deploy**: 두 환경(blue·green)을 두고 한쪽엔 새 버전, 한쪽엔 옛 버전. 라우팅을 toggle. 즉시 rollback 가능.
- **canary deploy**: 새 버전을 사용자 1%·5%·10% 순서로 점진 노출. 사고 시 즉시 rollback. Trunk-based의 단짝.
- **feature flag deploy**: 코드는 100% deploy + flag로 사용자 노출 제어. 가장 정밀.

자경단은 rolling 또는 feature flag로 시작. blue-green·canary는 Ch103(DevOps) 이후.

### 6-6. release vs deploy의 면접 질문

**"release와 deploy의 차이를 설명해 보세요"** — 신입 면접 자주 등장. 답 — "deploy는 서버에 코드를 올리는 기술적 사건, release는 사용자에게 새 버전을 알리는 사회적 사건. 큰 회사는 둘을 분리해서 deploy 100회 : release 1회 비율로 굴려요. 분리의 도구는 feature flag." 이 한 답이 본인의 협업 깊이를 보여줘요. 면접관의 1초 고개 끄덕임.

---

## 7. 환경 분리 — dev / staging / prod

세 패턴 모두에 공통으로 등장하는 개념. **환경**(environment)은 코드가 돌아가는 한 벌의 서버·DB·설정·도메인. 보통 셋:

### 7-1. dev (개발 환경)

본인 노트북 또는 팀 공용 dev 서버. **자유롭게 망가뜨려도 됨**. DB는 가짜 데이터, 외부 API는 mock, 결제는 테스트 카드. 본인이 새 기능 짤 때 첫 실행 환경. 사고가 나도 사용자엔 영향 0.

도메인 예 — `localhost:3000`(본인 노트북) 또는 `dev.cat-vigilante.org`(팀 공용 dev).

### 7-2. staging (스테이징·검수 환경)

production과 거의 똑같은 환경. **사용자엔 안 보임**. release 직전에 마지막 검수. DB는 production의 익명화 복사본, 외부 API는 진짜(테스트 계정), 결제는 sandbox 계정. QA 팀·디자이너·기획자가 여기서 한 사이클 손으로 테스트.

도메인 예 — `staging.cat-vigilante.org`. URL은 진짜처럼 보이지만 사용자는 없음.

### 7-3. prod (프로덕션 환경)

진짜 사용자가 쓰는 환경. **사고가 나면 즉시 영향**. DB는 진짜 사용자 데이터, 외부 API는 진짜 운영, 결제는 진짜 돈. 모든 모니터링·알람이 여기에 집중.

도메인 예 — `cat-vigilante.org` 또는 `app.cat-vigilante.org`.

### 7-4. 셋의 비교 표

| 환경 | 사용자 | DB | 외부 API | 결제 | 사고 영향 |
|------|--------|----|----|------|---------|
| dev | 본인·팀 | 가짜 | mock | 테스트 카드 | 0 |
| staging | QA·기획자 | 익명화 복사본 | 진짜 (테스트 계정) | sandbox | 거의 0 |
| prod | 진짜 사용자 | 진짜 | 진짜 운영 | 진짜 돈 | 즉시 |

### 7-5. 코드의 흐름

```
본인 노트북
   ↓ git push
GitHub main
   ↓ CI 통과
   ↓ deploy
dev 환경 (자동)
   ↓ 본인·팀 손 검증
   ↓ 머지 후 또는 주기적
staging 환경
   ↓ QA·디자이너 검수
   ↓ 승인
prod 환경 (사용자)
```

**환경마다 한 번씩 검수**가 핵심. dev에서 본인 OK → staging에서 팀 OK → prod에서 사용자 사용. 세 단계 검수가 사고를 거의 0으로 만들어요. 한 환경만 있으면 첫 실수가 곧 사용자 사고. **3환경의 비용이 1사고의 비용보다 100배 싸요**.

### 7-6. 자경단 환경

자경단은 처음엔 2환경(dev + prod)으로 시작. staging은 비용·인프라 부담. 5명이 작은 팀이라 staging 없이도 본인의 노트북 + production deploy preview(PR마다 임시 URL `pr-123.cat-vigilante.org`)로 충분. preview가 사실상 staging 역할. **PR preview가 작은 팀의 staging**.

성장하면(20명+) 정식 staging 환경 도입. Ch103(DevOps)에서 깊이. staging의 한 가지 함정 — staging이 prod와 다르면 검수가 의미 없어요. DB schema·환경변수·외부 API·서버 사양 — 다 같아야. 다르면 staging에서 OK인데 prod에서 사고. **staging의 가치는 prod와의 동일성**. 자경단의 PR preview는 백엔드·프론트 코드는 prod와 같지만 DB는 별도(작은 가짜 데이터). 그 정도면 작은 팀엔 충분. 결제·외부 API 통합이 들어가면 PR preview의 한계 — 그때 정식 staging.

### 7-7. 환경별 비밀 분리

각 환경은 다른 비밀(secret) 사용. dev는 가짜 키, staging은 sandbox 키, prod는 진짜 키. **절대 섞지 말 것**. dev에 진짜 key를 잘못 넣으면 본인 노트북에서 진짜 사용자에게 영향. AWS access key·DB password·Stripe key·OAuth secret — 모두 환경별 별도. `.env.dev`·`.env.staging`·`.env.prod` 분리. 본인 git repo엔 절대 안 들어감(.gitignore + secret manager).

---

## 8. 자경단 적용 — 한 페이지 결정

본인의 자경단이 H2의 이론을 어떻게 흡수하는지 한 페이지로:

1. **패턴**: GitHub Flow. 5명 미만이라 단순함이 정답.
2. **branch 모델**: main + feature. branch 수명 1일~3일. 1주일 넘기면 무조건 머지(또는 폐기 후 새 PR).
3. **release**: 매주 금요일 17:00 `git tag v0.X.0` + GitHub Release 노트 자동 생성(release-please 도구). SemVer 따라요.
4. **deploy**: main 머지 즉시 자동 rolling deploy (1대 서버부터 시작이라 rolling 의미는 약함). PR 머지 → 5분 안에 production.
5. **hotfix**: 새 feature branch + `fix/` prefix + 빠른 리뷰 1명 + CI 통과. 5분 안에 머지·deploy.
6. **환경**: dev(본인 노트북) + prod(`cat-vigilante.org`). PR마다 preview URL(`pr-N.cat-vigilante.org`)이 staging 역할.
7. **feature flag**: Ch090 이전엔 안 씀. 이후 도입 검토.
8. **release vs deploy**: 작은 팀이라 거의 동일. 다만 사용자 공지(release)는 매주 금요일에 한 번만. deploy(코드 배포)는 매일·매시간 가능.

이 결정이 H1의 첫인상 + H2의 이론을 자경단 한 줄 결정으로 압축한 결과. H3에서 셋업, H4에서 명령어, H5에서 시뮬레이션, H6에서 운영, H7에서 원리, H8에서 마무리.

**왜 이 결정인가** — 5명 + 인프라 부족 + continuous deployment 가능 + release 일정 없음. 이 4조건이 GitHub Flow의 정답을 가리켜요. 본인이 큰 회사 가서 50명 + 분기 release 환경을 만나면 Git Flow로 옮겨야 하고, 100명 + 인프라 완비를 만나면 Trunk-based로 옮겨야 해요. **자경단의 결정이 회사 결정의 학습판**.

그리고 한 가지 더 — 패턴 결정은 한 번이 아니라 매년 회고. 자경단이 1년 후에도 5명이면 GitHub Flow 유지. 10명이 되면 "GitHub Flow + 일부 Git Flow 요소(release branch)"의 혼합 검토. 20명+이 되고 인프라(CI 단단·자동 deploy·feature flag)가 갖춰지면 Trunk-based 검토. **결정은 매년 갱신**, 한 번 정한 결정에 평생 묶이지 않아요. 작가가 2020년에 Git Flow 글을 갱신한 것처럼, 본인의 자경단도 매년 갱신할 권리·의무 둘 다 있어요. **갱신이 진화의 신호**.

---

## 9. 흔한 오해 7가지

**오해 1: "GitHub Flow엔 release가 없어요."** — 가벼울 뿐 있어요. tag로 표시. release 노트도 가볍게 작성. "release = 사용자 공지" 정의를 따르면 GitHub Flow도 release가 있어요. 다만 Git Flow처럼 무거운 release branch가 없을 뿐.

**오해 2: "Git Flow는 옛 패턴이라 안 써요."** — 큰 회사는 여전히 써요. 작가가 2020년에 "모든 팀에 권하지 않는다"고 했지만 일부 팀엔 여전히 권해요. release 일정이 명확한 회사·전통 산업·게임은 Git Flow가 아직 정답. 오래된 게 죽은 게 아니에요.

**오해 3: "Trunk-based는 큰 회사만 써요."** — 작은 팀도 쓸 수 있어요. 다만 인프라가 단단해야. CI 90%+ 자동화·자동 deploy·feature flag가 있는 작은 팀(2~5명)은 Trunk-based가 가능. Ruby on Rails나 Heroku 시절 일부 스타트업이 그랬어요. **인프라가 패턴을 결정**.

**오해 4: "deploy = release예요."** — 다른 단어. 작은 회사는 같은 사건이지만 큰 회사는 100:1. 면접 단골 질문. **분리를 알면 큰 회사 사고 패턴이 보여요**.

**오해 5: "환경은 prod 한 개면 충분해요."** — 사고 직행. 최소 dev + prod 둘. 가능하면 staging까지 셋. 환경 추가 비용보다 사고 비용이 100배 커요. 한 사고 = staging 1년 운영 비용.

**오해 6: "feature flag는 trunk-based에서만 써요."** — 모든 패턴에서 유용. GitHub Flow + feature flag, Git Flow + feature flag도 가능. 다만 trunk-based가 가장 깊이 활용. 작은 팀도 한두 개 flag는 일찍 도입할 만해요.

**오해 7: "한 패턴을 정하면 1년 동안 못 바꿔요."** — 진화 가능. 5명 → 50명 → 500명 성장하면 패턴도 GitHub Flow → Git Flow 변형 → Trunk-based로 진화. 분기마다 회고로 점검. 안 바뀌는 워크플로우는 죽은 워크플로우. 진화의 방향은 항상 "사람 합의 → 도구 강제"의 한 길. 처음엔 5명이 매번 합의로 결정, 시간이 지나며 도구가 결정을 대신. 그게 성숙의 신호. 본인의 자경단도 1년 후 회고에서 "이제 release-please 도구 도입", "이제 deploy 자동화", "이제 feature flag 도입" 식으로 한 칸씩 자동화로 옮겨 가요. **자동화의 한 칸이 합의의 한 부담을 덜어요**.

**오해 8: "워크플로우 패턴은 git의 일이에요."** — git 명령어 + 도구 + 사람 합의의 셋이 합쳐진 게 워크플로우. git만으로는 워크플로우가 아니에요. branch protection(GitHub 설정)·CI(Actions)·Slack 공지·QA 절차·release 마케팅 — 다 합쳐서 워크플로우. **git은 토대, 워크플로우는 건물**. 본인이 git 명령어 23개를 다 외워도 워크플로우의 사고가 없으면 작동 안 해요.

---

## 10. FAQ 5가지

**Q1. 본인의 자경단이 GitHub Flow인데, 회사 입사 시 Git Flow를 만나면 헷갈리지 않을까요?**
A. 1주일 안에 적응. 본 H의 이론을 한 번 깊이 봤으면 5종 branch의 의미·release branch의 역할·hotfix 흐름이 머리에 있어요. 첫 주 월요일에 동료에게 "release branch는 누가 따나요?"만 물으면 1시간 안에 작업 가능. **이론이 적응 비용**.

**Q2. release 주기를 매주 vs 매월 vs 분기 중 어떻게 정하나요?**
A. 사용자의 변화 속도. 사용자가 매일 새 기능을 원하면 매주, 안정성을 원하면 매월·분기. SaaS는 보통 매주, 모바일 앱은 매월(앱스토어 심사 비용), 게임·은행은 분기·반기. 자경단은 매주 금요일 17:00이 표준. **사용자가 결정**.

**Q3. feature flag를 자경단에 일찍 도입해야 하나요?**
A. 첫 6개월은 안 도입. flag 없이 GitHub Flow 단순함을 누리는 게 우선. 6개월 후 큰 기능(결제 도입·디자인 개편)을 짤 때 flag 첫 도입. 그 시점에 도구(LaunchDarkly 또는 자체 구현) 검토. **필요할 때 도입, 아니면 단순함 유지**.

**Q4. 환경 셋(dev·staging·prod) 중 staging이 진짜 필요한가요?**
A. 5명 미만은 PR preview로 대체 가능. 10명+ 또는 결제·외부 API 통합이 복잡해지면 정식 staging 필요. staging의 비용(인프라·관리)보다 한 사고의 비용이 항상 큼. **사고 한 번에 staging 1년치**.

**Q5. release 노트는 누가 쓰나요?**
A. 자경단은 본인(메인테이너). PR 머지 시 PR 본문이 자동으로 release 노트 한 줄이 되도록 Conventional Commits + release-please 도구 셋업. 본인이 release 시 노트를 한 번 손 검수 + 사용자 친화적 한 줄 추가. **자동 + 한 손**의 조합. Ch005 H8에서 셋업. release 노트의 황금 양식 — "한 줄 요약 + 사용자가 받는 가치 + 변경 항목 3~5개 + 마이그레이션 가이드(있으면) + 기여자 목록". 5섹션이 표준. 본인이 v1.0.0 release를 쓸 때 이 양식만 따르면 30분 안에 한 페이지 노트 완성. 사용자가 1분 안에 핵심을 파악.

**Q6. branch 이름 규칙(naming convention)은 어떻게?**
A. 자경단 표준 — `<type>/<short-desc>` (예: `feat/cat-card`, `fix/login-bug`, `chore/deps-update`, `docs/contributing-guide`). type은 Conventional Commits의 7prefix와 같이. short-desc는 영어 케밥 케이스, 3~5단어. issue 번호 붙이려면 `feat/123-cat-card` 식. **이름이 한 줄 문서**. 동료가 branch 이름만 보고 무엇인지·왜인지 1초 안에 파악. 안 좋은 예 — `temp`·`my-branch`·`fix`·`new-feature`. 정보가 0. 좋은 이름이 좋은 협업.

**Q7. PR 사이즈가 너무 크면 어떻게 쪼개나요?**
A. 두 가지 길. **Stack PR**(여러 PR을 차례대로 쌓아서 차례대로 머지) 또는 **feature flag**(큰 기능 코드는 한 번에 머지하되 flag로 숨김). Meta·Google이 stack PR 자주 사용. 신입 때는 stack PR이 어려우니 "PR 만들기 전에 5단계로 쪼개서 commit" + "각 단계마다 별도 PR" 식으로 시작. 본인의 큰 PR이 작은 PR 5개로 쪼개지면 리뷰 시간이 1/5로. 머지 속도가 5배. **쪼개기가 협업의 첫 기술**.

---

## 11. 추신

추신 1. 세 패턴은 진화. 5명 GitHub Flow → 50명 Git Flow → 500명 Trunk-based. 본인의 자경단도 5년 후 다른 패턴으로 갈 수도. **패턴은 살아 있는 계약**. 매년 회고로 점검, 매년 한 칸씩 진화. 진화의 한 칸이 5년의 깊이.

추신 2. branch 모델 그래프를 손가락으로 그릴 수 있게 연습. 면접에서 "Git Flow의 release branch 흐름을 그려 주세요" 단골 질문. 종이에 한 번 그려 보면 머리에 박혀요.

추신 3. release ≠ deploy. 큰 회사의 비밀. 본인이 신입 때 이 분리를 알면 시니어 동료의 결정이 보여요. 두 단어가 다르다는 한 줄이 본인의 첫 시니어 신호.

추신 4. SemVer (major.minor.patch). 자경단 v0.1.0 → v0.5.0 → v1.0.0의 의미를 알면 release 결정이 가벼워져요. 세 숫자가 다섯 결정을 압축.

추신 5. 환경 셋(dev·staging·prod). 자경단은 처음엔 둘로 시작, 성장하면 셋. **셋 환경의 비용이 1사고의 비용보다 100배 싸요**.

추신 6. feature flag는 trunk-based의 무기지만 모든 패턴에 유용. 자경단은 Ch090 이후 도입. 무기는 일찍 알면 일찍 적용 가능.

추신 7. CI는 GitHub Flow의 안전벨트. 안전벨트 없는 GitHub Flow는 사고 직행. Ch005 H3에서 CI 셋업 첫 손. 안전벨트는 평생 자산.

추신 8. branch 짧게 유지(<1주). 길어지면 integration hell. **자주 작게**가 황금 규칙. 황금 규칙 한 줄이 평생 손가락 습관.

추신 9. hotfix는 일상. GitHub Flow는 feature branch로, Git Flow는 hotfix branch로, Trunk-based는 flag off로. 셋이 다 다른 손가락. 본인 패턴을 알면 hotfix 시 손가락이 자동. 새벽 3시에 손가락이 흔들리지 않아요.

추신 10. 워크플로우는 도구 + 사람의 합의. 둘 다 있어야 작동. branch protection 한 칸이 본인 합의 100마디보다 단단. 도구가 합의를 평생 기억해 줘요.

추신 11. 본 H의 이론을 종이 한 페이지로 적어 보세요. branch 그래프 셋 + release vs deploy 표 + 환경 셋 표. 한 페이지면 본인의 협업 사고 다 들어가요. 종이에 손으로 적는 게 머리에 박히는 가장 빠른 방법. 키보드 100번보다 펜 한 번이 깊어요.

추신 12. 다음 H3는 환경점검 — GitHub 팀·organization 셋업, protected branch 7체크, CODEOWNERS 깊이. 본 H의 이론이 H3의 셋업으로 손에 잡혀요. 🐾

추신 13. 본 H를 다 읽은 본인이 한 가지 실험 — 본인이 좋아하는 오픈소스 저장소 셋(예: React, FastAPI, VS Code)의 CONTRIBUTING.md를 열어 보세요. 어느 패턴인지 1분 안에 파악될 거예요. React는 Trunk-based 변형, FastAPI는 GitHub Flow, VS Code는 release branch 있는 GitHub Flow 변형. 셋이 다 다른 패턴. 본인의 자경단도 5년 후엔 어디일까요?

추신 14. 마지막 — 패턴 이름에 매이지 마세요. 본질은 "main 보호 + branch 작업 + 리뷰 + 머지". 변수는 branch 종류 수와 release 주기뿐. 본질을 잡으면 어느 회사의 어느 패턴도 1주일 안에 적응. **이름이 표면, 본질이 영원**. 🐾🐾
