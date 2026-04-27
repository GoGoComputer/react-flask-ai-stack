# Ch004 · H7 — 내부 동작: `.git/objects`·SHA-1·packfile·refs·hooks 깊게 들여다보기

> **이 H에서 얻을 것**
> - `.git/` 디렉터리의 9개 자리(objects/·refs/·HEAD·index·hooks/·config·logs/·packed-refs·info/)를 한눈에.
> - **4종 객체**(blob·tree·commit·tag)의 본질 — 모든 게 SHA-1 해시 키의 zlib 압축 텍스트.
> - **packfile + delta 압축**이 어떻게 GB짜리 저장소를 KB로 줄이는가.
> - **fsck·gc·prune·repack** 4가지 정비 명령어 + 본인의 응급실 도구.

---

## 회수: H6의 운영에서 H7의 내부로

지난 H6에선 본인이 자경단 저장소를 회사 저장소처럼 운영하는 시간이었어요. Issue·PR·Project·Discussions·branch protection·CODEOWNERS — 6개 도구가 본인의 일주일을 만든다는 그림. 운영의 시간. 이번 H7은 **그 운영 아래 깔린 내장**을 봅니다. 본인이 매일 두드리는 `git commit` 한 줄이 노트북의 어떤 파일을 어떻게 만드는지, `git push` 한 줄을 두드릴 때 어떤 바이트가 인터넷을 건너가는지.

**왜 내부를 봐야 하나요?** 본인이 git을 매일 쓰는데도 내부를 모르면 사고가 났을 때 손가락이 막혀요. "왜 이게 안 되지?" 같은 질문에 답이 안 보여요. 내부를 한 번 본 사람은 사고를 만나도 침착해요 — 시스템이 어떻게 굴러가는지 머리에 그려져 있으니까. **5년 차의 침착함은 내부를 본 사람의 침착함**이에요. 본인이 신입일 때 한 번만 깊이 들여다보면 평생 본인을 지탱해 줍니다. 한 번이 어렵지, 한 번 들여다본 후의 git은 같은 git이 아니에요.

또 하나 — **git의 내부는 의외로 단순해요.** 4종 객체와 1개 인덱스, refs 몇 줄, hooks 몇 개. 그게 다예요. 본인이 매일 두드리는 30개 명령어가 사실은 이 작은 데이터 구조 위의 표면 동작에 불과해요. 표면이 화려해 보일 뿐, 속은 깔끔합니다. **Linus Torvalds가 2주 만에 첫 버전을 만든** 이유가 여기 있어요. 데이터 모델이 단순하니까. 본인이 이 단순함을 한 번 보면 git이 친구로 느껴져요. 안 무서운 친구.

---

## 1. `.git/` 디렉터리 한눈에 — 9개 자리

H5의 데모 폴더 `~/playground/git-demo`로 돌아가서 `ls -la .git/`를 두드려 보세요. 출력에 보이는 9개 자리:

```
.git/
├── HEAD                 # 현재 가지 한 줄짜리 텍스트
├── config               # 저장소별 설정 (INI 형식)
├── description          # GitWeb용 한 줄 (거의 안 씀)
├── index                # staging 영역의 바이너리 인덱스
├── hooks/               # commit·push 전후 자동 스크립트
├── info/                # exclude 등 보조 정보
├── logs/                # reflog 텍스트 로그
├── objects/             # 4종 객체 저장소(SHA-1 키)
├── packed-refs          # 압축된 refs (없을 수도)
└── refs/                # 가지·태그 포인터들
```

9개 자리예요. 본인이 매일 만나는 게 사실 이 9개. 한 줄씩 — `HEAD`는 현재 가지를 가리키는 한 줄짜리 텍스트(`ref: refs/heads/main`), `config`는 저장소 로컬 설정(`~/.gitconfig`보다 우선), `index`는 `git add`가 채우는 staging 영역의 바이너리, `hooks/`는 `pre-commit`·`pre-push` 같은 자동 스크립트가 모이는 폴더, `objects/`는 본인 commit·파일이 다 들어가는 진짜 저장소, `refs/`는 가지·태그 이름표가 모이는 폴더, `logs/`는 reflog의 본체.

**가장 중요한 두 자리** — `objects/`(저장소의 모든 데이터)와 `refs/`(데이터를 가리키는 이름표). 나머지 7개는 보조. 이 둘을 이해하면 git의 99%를 이해해요. **데이터(objects) + 이름표(refs)**, 이게 git의 본질입니다. 책으로 비유하면 — `objects/`는 도서관의 모든 책이 SHA-1이라는 청구기호로 꽂혀 있는 거대한 서가, `refs/`는 그 서가에서 "우리 가족이 빌려 온 책 목록" 같은 작은 종이 한 장. 가족이 다른 책을 빌리면 종이의 청구기호가 갱신될 뿐이에요. **서가는 안 움직이고, 종이만 갱신**. 이게 git이 가지를 자유롭게 만들 수 있는 비밀이에요. 새 가지를 만든다는 건 종이 한 장 더 적는 것뿐. 책 자체를 복사하지 않아요.

**한 가지 신기한 점** — `.git/`의 모든 파일이 텍스트(또는 zlib 압축된 텍스트)예요. 바이너리는 `index`와 packfile뿐. `HEAD`·`config`·`refs/heads/main`은 다 평범한 텍스트 파일. `cat`으로 직접 열어 볼 수 있어요. **git은 데이터베이스가 아니라 파일 시스템**이에요. 본인이 `.git/refs/heads/main`을 vim으로 열어서 sha-1을 손으로 고치면 git이 그걸 그대로 따라요. 무서운 사실이지만 **git이 사람에게 투명**하다는 증거. 다른 VCS는 보통 binary 데이터베이스라서 안을 못 봐요. SVN은 Berkeley DB·SQLite, Perforce는 자체 binary. **투명함은 디버깅의 자유**예요. 본인이 5년 차에 사고를 만났을 때 vim으로 .git을 열 수 있다는 사실 하나가 본인의 침착함의 80%예요.

**또 한 가지 보너스 — `.git/COMMIT_EDITMSG`·`.git/MERGE_MSG`·`.git/FETCH_HEAD`** 같은 임시 파일들도 있어요. commit 메시지 작성 중간 상태, merge 진행 중 메시지, 마지막 fetch한 내용. 본인이 사고 후 한 번씩 들여다보면 git이 어디까지 갔는지 정확히 알아요. **git은 자기 상태를 텍스트로 다 적어 둬요.** 그래서 본인이 git을 신뢰할 수 있어요. 블랙박스가 아니에요.

---

## 2. `objects/` — 4종 객체와 SHA-1 키

`ls .git/objects/`를 두드려 보면 두 자리 hex(`00`~`ff`) 폴더 + `info/`·`pack/`이 보여요. 두 자리 hex 폴더 안에 38자 hex 파일이 들어 있어요. 합쳐서 40자 = SHA-1 해시 한 개. 첫 두 자리를 폴더 이름으로 쓰는 이유 — **파일 시스템 효율** 때문이에요. 한 폴더에 파일 100만 개 있으면 ls가 느려요. 256개 폴더로 나누면 폴더당 평균 4천 개. 그 정도는 OS가 빨라요.

```bash
cd ~/playground/git-demo
git log --oneline -1
# 8888888 (HEAD -> main) merge: 까미 색깔 표기 통일

ls .git/objects/88/
# 88888888...   ← 첫 commit의 객체 본체
```

이 한 파일이 본인의 한 commit이에요. 까 봐요.

```bash
git cat-file -t 8888888    # 타입 출력
# commit
git cat-file -p 8888888    # 내용 출력
# tree 7777777...
# parent 666aaaa...
# parent 555bbbb...
# author GoGoComputer <gogo@local> 1745740800 +0900
# committer GoGoComputer <gogo@local> 1745740800 +0900
#
# merge: 까미 색깔 표기 통일
```

**5필드 텍스트.** H2에서 본 commit 5필드가 그대로 거기 있어요. parent가 두 개인 건 merge commit이라서. 첫 commit(root-commit)은 parent가 0개. 일반 commit은 parent 1개. 본인이 본 모든 git 시각화의 그래프가 이 parent 필드 한 줄로 만들어져요.

**4종 객체의 분류**:

| 객체 | 역할 | 내용 |
|------|------|------|
| **blob** | 파일 한 개의 내용(raw bytes) | 본인 README.md의 바이트 그대로 |
| **tree** | 폴더 한 개의 목록(이름·모드·sha) | 한 줄에 한 항목 |
| **commit** | 한 시점의 스냅샷 + 메타데이터 | tree·parent·author·committer·message |
| **tag** | annotated tag (lightweight tag는 ref만) | sha·tagger·message |

```bash
git cat-file -p 8888888^{tree}
# 100644 blob aaa1234...    README.md
# 040000 tree bbb5678...    docs
```

**tree의 구조** — 한 줄에 (mode, type, sha, name). mode는 권한(100644 = 일반 파일, 100755 = 실행 파일, 040000 = 폴더, 120000 = 심볼릭 링크, 160000 = 서브모듈). type은 blob 또는 tree. tree가 또 다른 tree를 가리키면 폴더가 폴더를 품는 거예요. **재귀 구조**. 본인의 자경단 폴더 한 채가 root tree 한 개에서 시작해서 가지를 펼쳐요.

```bash
git cat-file -p aaa1234   # blob 보기
# # 자경단 데모 저장소
# ## 길고양이 카드 1
# - 이름: 까미 (검정·턱시도 믹스)
# ## 길고양이 카드 2
# - 이름: 노랭이
# ## 길고양이 카드 3
# - 이름: 미니
```

**blob은 파일의 raw bytes 그대로.** 압축된 형태로 디스크에 박혀 있고 `cat-file -p`가 풀어서 보여 줘요. 파일 이름은 blob 안에 없어요 — 파일 이름은 tree 항목에. 그래서 같은 내용의 파일 두 개(예: 두 폴더의 README.md가 똑같은 내용)는 **blob 한 개**만 저장돼요. 같은 sha니까. **자동 중복 제거**. git의 가장 큰 비밀 한 줄.

---

## 3. SHA-1 — 내용이 키가 되는 신기한 주소 체계

객체의 파일 이름이 SHA-1 해시예요. **내용에서 sha를 계산하고 sha를 파일 이름으로 씀**. content-addressable storage(내용 주소화 저장). 이게 git의 핵심 마법입니다.

```bash
echo -n "hello" | git hash-object --stdin
# b6fc4c620b67d95f953a5c1c1230aaab5db5a1b0
```

본인이 같은 줄을 두드리면 같은 sha가 나와요. **결정론적**. 내용이 1비트라도 다르면 sha가 완전히 다른 값으로 변해요. 이걸 avalanche(눈사태) 효과라고 해요. 1비트의 차이가 만 비트의 차이를 만들어요. 그래서 sha를 비교하기만 해도 내용이 같은지 다른지 100% 알 수 있어요. 비교 한 번이 파일 전체 비교를 대체.

**git hash-object의 진짜 형식**:

```
<type> <length>\0<content>
```

블롭이면 `blob 5\0hello`를 sha-1에 넣어요. 그래서 위에서 `echo -n hello`의 sha와 `sha1sum`으로 직접 계산한 sha가 달라요 — git은 헤더를 붙여 계산하니까. **이 한 줄이 git이 텍스트 파일을 인식하는 방법**. 본인이 외우진 마세요. 이런 게 안에 있다는 사실만 머리에 두면 됩니다.

**SHA-1의 충돌 가능성** — 이론상 2^80 객체쯤에서 충돌이 한 번 생겨요(생일 역설). 천문학적 수. 우주의 모든 별보다 많아요. 실용적으론 안전. 다만 2017년에 Google이 SHAttered 공격으로 두 개의 PDF가 같은 SHA-1 해시를 가지도록 만들었어요. 이걸 일부러 만든 첫 사례. 그래서 git은 **SHA-256 마이그레이션**을 시작했어요. 2026년 현재 git 2.42부터 SHA-256 저장소를 만들 수 있고, GitHub도 단계적으로 받기 시작. 본인의 새 저장소엔 `git init --object-format=sha256` 한 줄로 SHA-256으로 시작 가능. 다만 호환성 문제로 아직 SHA-1이 표준. 5년 후엔 SHA-256이 표준이 될 거예요. 천천히, 안전하게.

**왜 SHA가 키여야 하나** — (1) 내용 변경 감지 자동, (2) 중복 제거 자동, (3) 분산(distributed) 환경에서 ID 충돌 없이 합치기 가능, (4) 무결성 검증 — `git fsck`로 모든 객체의 실제 sha를 다시 계산해서 파일 이름과 비교, 일치 안 하면 손상. SHA 한 줄이 4가지 일을 동시에 해요. **단순함이 강력함**의 정확한 예.

---

## 4. zlib 압축 — `.git/objects/`의 모든 파일은 압축돼 있다

본인이 `cat .git/objects/88/88888888...`로 직접 열면 깨진 글자만 보여요. **zlib 압축**돼 있어서. `git cat-file -p`가 풀어서 보여 줬을 뿐. 직접 풀어 보면:

```bash
python3 -c "import zlib, sys; sys.stdout.buffer.write(zlib.decompress(open('.git/objects/88/88888888...', 'rb').read()))"
# commit 234\x00tree 7777777...\nparent 666aaaa...\n...
```

**모든 객체가 zlib로 압축됨.** 텍스트 commit·tree는 압축률이 높아요(반복 패턴 많아서). blob은 파일 종류에 따라 다름 — 텍스트 파일은 잘 압축, 이미 압축된 jpg·png·zip은 거의 안 줄어요. **그래서 git이 binary 큰 파일을 안 좋아하는 거**예요. 압축이 안 되니까 저장소가 부풀어요. 큰 binary는 Git LFS(Large File Storage)로 따로 관리. Ch041 모노레포에서 다뤄요.

**압축의 부작용 한 가지** — 같은 내용의 파일을 작은 변경 후 commit하면 약간 다른 새 blob이 또 만들어져요. 1바이트 차이여도 새 blob 하나. 디스크 사용량이 빠르게 늘어나는 이유 한 가지. **packfile**이 이 문제를 해결해요(다음 절).

---

## 5. packfile + delta 압축 — GB를 KB로

저장소가 커지면 객체 한 개당 한 파일은 비효율적이에요. git이 `git gc`(garbage collect)를 돌리면 객체들을 묶어서 **packfile**을 만들어요.

```bash
ls .git/objects/pack/
# pack-abcdef123456...idx
# pack-abcdef123456...pack
```

`.pack`은 객체 본체가 모인 파일, `.idx`는 그 안의 객체들을 sha로 빠르게 찾는 인덱스. 두 파일이 한 쌍.

**delta 압축의 본질** — 비슷한 두 blob을 둘 다 통째 저장하지 않고, 한쪽을 base로, 다른 쪽을 "base에서 이만큼 변경"하는 차이만 저장. 본인이 README.md를 수정해서 commit 100번 만들면 100개 blob이 생기지만, 이게 packfile에 모이면 base + 99개 delta로 압축돼요. **저장 공간이 100분의 1**. Linux 커널 저장소가 30년치 history 200만 commit인데도 5GB 정도인 이유. delta가 없으면 200GB는 됐을 거예요.

**delta 알고리즘** — base와 변형의 공통 부분을 찾아 인덱스로 가리키고, 다른 부분만 직접 저장. 압축이 아니라 차분(differential) 표현. zlib 위에 또 한 겹의 압축. 두 겹이 합쳐져 git의 디스크 효율을 만들어요. **delta의 base 선택이 git의 똑똑함** — 같은 파일의 다른 버전이 자동으로 base 후보가 되고, git이 윈도우 크기(기본 10) 안에서 가장 잘 압축되는 base를 선택해요. 사람이 "이 commit은 저 commit의 자식이야"를 알려 줄 필요가 없어요. **휴리스틱이 알아서**. 그래서 history의 모양과 무관하게 비슷한 내용은 자동으로 묶여요. cherry-pick·revert로 같은 내용이 두 가지에 동시에 있어도 blob 한 개만 저장돼요.

**언제 packfile이 만들어지나** — `git gc`(수동) 또는 `git gc --auto`(임계치 도달 시 자동 — 보통 6,700개 loose object 또는 50개 packfile). 평소엔 commit이 loose object로 쌓이다가, 임계 넘으면 자동 pack. 본인이 매일 commit 5개씩 한 달이면 150개. 1년이면 1,800개. 1년에 한두 번 정도 자동 gc 돌아요. 본인이 직접 두드릴 일 거의 없음. **그래도 한 가지 팁** — `git gc --auto`는 commit·fetch 등의 동작 직후에 "이제 정비할 시간인가?"를 자기 자신에게 물어요. 매번 모든 동작 후. 그래서 본인이 사실 매일 미세하게 자동 정비를 만나고 있어요. 본인이 모르는 사이에. **git은 자기 자신을 돌봐요.**

**`git push`가 빠른 이유도 packfile** — push할 때 git이 즉석에서 packfile을 만들어서 보내요. 객체 100개를 한 파일로 묶고 delta 압축. 네트워크 한 번에 다 보내요. 100번 왕복할 일이 한 번으로. **분산 git의 효율은 packfile 위에 서 있어요.** Linux 커널 같은 거대 저장소를 clone할 때도 마찬가지 — GitHub이 미리 만들어 둔 packfile을 한 번에 다운로드. 5GB 저장소가 30분이면 받아져요(인터넷 속도에 따라). 객체 한 개씩 받았으면 며칠 걸렸을 거예요.

---

## 6. `refs/` — 이름표가 sha를 가리키는 한 줄

`refs/` 디렉터리는 본인 가지·태그·remote 가지의 이름표가 모이는 곳이에요.

```bash
ls .git/refs/
# heads/   tags/   remotes/

cat .git/refs/heads/main
# 8888888888888888888888888888888888888888

cat .git/refs/heads/feat/cat-3-mini
# 7777777777777777777777777777777777777777
```

**한 줄, 41바이트**(40자 sha + 줄바꿈). 가지가 한 파일. 가지 이름이 `feat/cat-3-mini`처럼 슬래시면 폴더로 나뉘어 저장돼요(`refs/heads/feat/cat-3-mini`). 본인이 가지 하나 만들 때마다 41바이트 텍스트 파일 한 개가 생기는 거예요. **41바이트가 본인 새 기능의 무게.** 너무 가벼워서 가지를 자유롭게 만들 수 있는 것.

**`HEAD`는 가지의 가지** — `cat .git/HEAD`는 `ref: refs/heads/main`. 가지를 가리키는 가지. attached HEAD. detached HEAD가 되면 sha 직접(`cat .git/HEAD` → `8888888...`). H2에서 본 그림이 여기 한 줄에 박혀 있어요.

**packed-refs** — 가지·태그가 수천 개로 늘면 41바이트 파일 수천 개가 되는데 OS가 느려져요. 그래서 git이 가끔 모든 ref를 한 텍스트 파일(`.git/packed-refs`)에 모아 둬요. 한 줄에 `<sha> <ref-name>` 한 쌍. 그러면 개별 ref 파일이 사라지고 한 파일에 다 박혀요. 본인은 알 필요 없음 — git이 알아서. 사고 났을 때 packed-refs 파일을 vim으로 열어 한 줄 직접 고쳐서 ref를 살린 사례가 5년 차의 영웅담으로 가끔 회자돼요.

**`refs/remotes/origin/main`** — 원격 main의 마지막으로 본 위치. 본인이 fetch할 때마다 이게 갱신. 본인 local main과 분리되어 있어서 `git log main..origin/main`으로 "내가 아직 안 받은 commit"을 볼 수 있어요. 이 분리가 git이 분산 환경에서도 매끈한 이유.

---

## 7. `index` — staging의 바이너리 본체

`git add`가 채우는 staging 영역은 사실 `.git/index` 파일 한 개예요. **유일한 바이너리** 자리. `git ls-files --stage`로 안을 봐요:

```bash
git ls-files --stage
# 100644 aaa1234... 0   README.md
# 100644 bbb5678... 0   .gitignore
```

한 줄에 (mode, blob sha, stage number, path). **이게 다음 commit이 만들 tree의 미리보기**. `git commit`을 두드리면 git이 이 index를 읽어서 tree 객체를 만들고, 거기에 parent + author 정보를 붙여 commit 객체를 만들어요. **index가 staging이고, staging이 다음 tree**.

stage number는 보통 0(정상). conflict 중엔 1·2·3으로 갈라져요 — 1=공통 조상, 2=현재(HEAD), 3=합쳐 들어오는 쪽. 한 파일이 세 번 등장. `git add`로 해결하면 다시 0으로 모여요.

**index의 신기한 사실** — index는 sha를 가지고 있지만 실제 blob은 `git add` 시점에 이미 `.git/objects/`에 만들어져 박혀요. **index는 포인터만**. 그래서 `git add` 후 본인이 working tree의 파일을 또 수정해도 index의 sha(= staging의 내용)는 안 바뀜. `git diff`(working vs staging) vs `git diff --staged`(staging vs HEAD)의 차이가 여기서 옵니다.

**index가 있어서 빠른 이유 한 가지** — `git status`가 4만 개 파일 저장소에서도 1초 안에 끝나는 건 index가 각 파일의 stat 정보(timestamp·size)를 캐싱해서. timestamp가 안 바뀐 파일은 git이 내용을 다시 안 읽어요. **OS의 stat 한 번이 read 한 번을 대체**. 큰 저장소에서 status 속도의 비밀.

**더 멈춰서 볼 점** — index가 손상되면 본인의 저장소가 이상해져요. `git status`가 엘릭이거나, `add`를 두드렸는데 staging에 안 올라가거나. 응급 처방 — `rm .git/index && git reset` 두 줄. index는 working tree와 HEAD에서 다시 만들 수 있어요(working tree의 stat 정보 + HEAD의 tree). 있을 게 없는 자리이 index. **복구 가능한 데이터는 일회용**. 이게 본인의 우서자 한 줄이 돼요 — 사고 난 데이터가 복구 가능한지 먼저 판단.

---

## 8. `hooks/` — commit·push 전후 자동 스크립트

`ls .git/hooks/`을 두드려 보면 .sample 파일들이 있어요. `cp pre-commit.sample pre-commit && chmod +x pre-commit`으로 활성화. shell·python·node 어떤 언어로든 실행 파일이면 git이 자동 호출.

| hook | 언제 |
|------|------|
| `pre-commit` | commit 직전 — 코드 lint·테스트 실행, 실패 시 commit 차단 |
| `prepare-commit-msg` | commit 메시지 입력 직전 — 자동 prefix·이슈 번호 삽입 |
| `commit-msg` | commit 메시지 입력 후 — 메시지 형식 검증 |
| `pre-push` | push 직전 — 마지막 테스트, force-push 보호 |
| `post-commit` | commit 직후 — 알림 등 |
| `pre-receive` / `post-receive` | 서버 측 — 원격 git 서버에서 push 받을 때 |

**가장 자주 쓰는 건 `pre-commit`**. 본인이 비밀 키·디버그 print·console.log를 실수로 commit하는 사고를 막아요. 회사에선 보통 **husky** 또는 **pre-commit framework**(python)로 hook 관리. `.pre-commit-config.yaml` 한 장에 설정 적고 `pre-commit install` 한 번 두드리면 hook이 자동 셋업.

**hook의 함정** — `.git/hooks/`는 push가 안 돼요(`.git/`은 통째로 push 안 됨). 그래서 동료와 hook을 공유하려면 `scripts/git-hooks/` 같은 폴더에 넣고 README에 "셋업 시 `cp scripts/git-hooks/* .git/hooks/`" 안내, 또는 husky 같은 도구로 자동화. **개인 hook은 .git/hooks, 팀 hook은 도구**.

자경단에선 pre-commit 한 장으로 (1) AWS 키 검색 차단, (2) Markdown lint, (3) Python 코드 black 자동 포맷, (4) 큰 파일(>5MB) 차단 4가지를 박아 두면 평생 사고 80%가 막혀요. 5분 셋업이 5년 안전.

**hook을 작성하는 팝 5가지** — (1) 실행 권한 필수(`chmod +x`), (2) 첫 줄은 shebang(`#!/bin/sh` 또는 `#!/usr/bin/env python3`), (3) 종료 코드 0은 OK, 1이면 차단, (4) hook 안에서 git 명령어를 다시 두드리면 무한루프 가능성 조심, (5) 테스트는 `git commit -m "test" --allow-empty`로 항상 먼저. 이 5가지를 머릿속에 두면 hook 쓰고 디버깅하는 시간이 절반으로 줄어요.

**회사의 hook 표준은 보통 monorepo 단위** — husky + lint-staged + pre-commit framework를 조합해서. lint-staged는 staging에 올라간 파일만 검사해서 큰 저장소에서도 commit이 5초 내 끝나게 해줘요. 본인의 자경단에선 이는 과행· 혜는 husky 한 장만으로 충분. 자경단이 아주 커지면 그때 하나씩 도입.

---

## 9. `git fsck`·`gc`·`prune`·`repack` — 4가지 정비 도구

본인이 1년에 한두 번 만나는 정비 명령어 4가지.

**`git fsck`**(file system check) — 모든 객체의 무결성 검증. 각 객체의 실제 sha를 다시 계산해서 파일 이름과 비교, 다르면 손상 보고. 또 어떤 ref도 가리키지 않는 dangling(매달린) 객체 찾기. 사고 후 첫 응급 도구. `git fsck --full`이 표준.

**`git gc`**(garbage collect) — loose objects를 packfile로 묶고, 압축, prune까지. 보통 자동(`gc.auto`). 본인이 큰 작업 후 `git gc --aggressive` 한 번 두드리면 저장소가 작아져요. 다만 시간 오래 걸려서 가끔만.

**`git prune`** — 어떤 ref도 안 가리키고 reflog에도 안 남은 객체를 영구 삭제. **빨강** — 한 번 prune되면 못 살림. 보통 reflog 만료(90일) 후에 동작. 본인이 직접 두드릴 일 거의 없음.

**`git repack`** — 여러 packfile을 하나로 합치기. `gc`가 내부적으로 호출. 본인이 직접 두드릴 일 거의 없음.

**한 가지 더 — `git count-objects -v`** — 저장소의 객체 통계. loose object 개수·크기, packfile 개수·크기. 본인 저장소가 비대해진 것 같으면 한 번 두드려 봐요. 1GB 넘으면 `git gc --aggressive` 한 번. 10GB 넘으면 history 정리(filter-repo)나 LFS 도입을 고민.

---

## 10. 응급실 도구 — 사고 났을 때 본인이 두드릴 한 줄들

본인이 사고 친 후 떠올릴 응급실 명령어들. **외우려 말고 표를 머릿속 위치에 박아 두세요**.

```bash
# "commit이 사라졌어요"
git reflog                              # 90일치 자취
git reset --hard HEAD@{N}               # 그 시점으로

# "어떤 객체에 무엇이 들어 있나"
git cat-file -t <sha>                   # 타입
git cat-file -p <sha>                   # 내용

# "이 sha가 어느 가지·tag에서 닿나"
git branch --contains <sha>
git tag --contains <sha>

# "이 줄을 누가·언제·왜 썼나"
git blame <file>
git log -S "검색어" -p                  # 그 줄이 추가된 commit 찾기 (pickaxe)

# "두 commit 사이의 줄 단위 차이"
git diff <sha1>..<sha2>

# "내 working tree가 깨졌어요"
git fsck --full
git stash                               # 현재 변경 임시 보관
git checkout HEAD -- <file>             # 한 파일을 HEAD 상태로

# "rebase 망쳤어요"
git rebase --abort                      # 시작 전으로
ORIG_HEAD                               # rebase 직전 위치, git reset --hard ORIG_HEAD

# "push 거부됐어요(non-fast-forward)"
git fetch
git rebase origin/main                  # 원격 변경 위에 올라타기
git push                                # 또는 --force-with-lease
```

이 한 페이지가 본인의 응급실. 매일 두드리진 않지만 알고 있는 것과 모르고 있는 것의 차이가 크다. **`ORIG_HEAD`는 git이 자동으로 "직전 위치"를 저장해 주는 ref**. rebase·merge·reset 직전마다 갱신. 본인이 백업 가지를 따로 만들지 않아도 한 단계 전으론 자동으로 돌아갈 수 있어요. 5년 차의 또 한 가지 비밀 단어.

**응급실 사용의 5계명** — (1) **두드리기 전 한 번 더 보기**. 본인이 다급할수록 명령어를 잘못 두드려 사고를 키워요. 한 호흡 쉬고 두드리세요. (2) **`--force` 대신 `--force-with-lease`**. force-with-lease는 본인이 마지막으로 본 원격 상태와 다르면 push를 거부해 동료의 작업 위에 덮어쓰기를 막아 줘요. force는 그런 보호 없이 무조건 덮어쓰기. 평생 force-with-lease만. (3) **`reset --hard` 전 `git status`로 변경 사항 확인**. hard는 working tree까지 날려요. 미저장 변경이 있으면 사라져요. (4) **모르겠으면 백업 가지 한 줄**. `git branch backup-$(date +%s)` 한 줄이면 현재 위치가 영원히 보존돼요. 사고 후에도 그 가지로 복귀 가능. 빨강 명령어 직전엔 항상. (5) **동료에게 알리기**. 본인이 force-push 같은 빨강 명령어를 칠 땐 채팅에 한 줄 — "main에 force-push 합니다, 5분 후"라는 한 줄이 동료의 5시간을 살려요. 본인의 사고가 동료의 사고가 되지 않게.

**그리고 `git reflog`의 보존 기간** — 기본 90일. 그 안에 본인이 사라진 commit을 복구할 수 있어요. 90일 지나면 `git gc`가 자동으로 정리. 본인이 1년 전 commit을 잃었다면 reflog로도 못 찾아요. 그래서 진짜 중요한 건 **태그를 박아 두세요**(`git tag v1.0.0`). 태그는 영원. gc가 안 건드려요. 본인의 자경단 release마다 태그를 박는 습관이 5년 후 본인을 살릴 수 있어요. **태그는 무게 없는 영원의 표식**.

---

## 11. 자경단 적용 + H8 예고

본인이 자경단 저장소에서 `git cat-file -p HEAD`로 본인 첫 commit 속을 한 번 봐 보세요. tree·parent·author·committer·message 5필드가 그대로 보여요. **5년 후에도 그 5필드가 그 자리에 그대로 박혀 있을 거**예요. 본인이 만든 git 객체는 영원해요. 본인이 자경단을 떠나도, 다른 누군가 clone 하나로 모든 commit을 가져갈 수 있어요. **분산 git의 영원성**. 본인의 자경단 활동이 평생 인터넷 어딘가에 남아요.

다음 H8은 **자경단 적용 + 챕터 마무리**. 본인이 진짜 자경단 저장소를 회사 저장소처럼 셋업하는 30분 종합 실습 + 다섯 원리 정리 + Ch005(협업 워크플로우)로 가는 다리. 본 챕터의 마지막 시간. 여덟 H가 합쳐서 본인의 git 기둥 한 개를 만들어요. H1(오리엔테이션)에서 "사진앨범 비유"로 시작한 여정이 H7(내부 동작)의 "4종 객체·zlib·packfile·delta"에 닿은 다음, H8에서 "본인의 이야기"로 멈춰요. 이야기는 끝의 이야기가 아니라 다음 챕터로 가는 이야기예요. **공부는 끝이 아니라 다음 공부를 위한 준비**이에요. Ch005에서 틀을 명확히 잡은 협업 패턴(GitHub Flow vs Git Flow vs Trunk-based)을 본인의 자경단에 적용해 봅니다.

**또 한 가지 — 본인이 H7을 한 번 읽고 1주일 후 다시 읽으세요.** 첫 독해엔 내용이 너무 많아 머리에 다 안 들어와요. 1주일 후엔 본인이 git을 더 두드리고 난 다음이니 같은 글이 다른 깊이로 읽혀요. 세 번째는 6개월 후. 본인이 주니어가 된 후 다시 펼쳐보면 또 다른 깊이. **같은 글을 세 번 읽는 게 다른 글 세 편 읽는 것보다 깊은 학습**이에요.

**마지막으로 — git의 내부를 본 사람과 안 본 사람의 차이**는 명령어 개수의 차이가 아니라 **사고 시 침착함의 차이**예요. 본인이 reset·rebase·force-push로 사고를 만났을 때 머릿속에 .git/objects가 그려진 사람은 "객체는 안 사라졌어, reflog에 sha 있을 거야"라고 30초 안에 침착해져요. 안 그려진 사람은 "내 코드 다 날아갔어"라고 패닉. 같은 사고, 다른 반응. 다른 30분. **본인이 H7을 읽은 30분이 5년 후 본인의 30분 패닉 한 번을 막아 줘요.** 30분이 30분을 살려요. 가장 효율적인 투자.

**진짜 마지막 한 줄** — git은 21년 된 도구이지만 21년 동안 본질이 안 바뀌었어요. 4종 객체·SHA-1·zlib·packfile·refs·hooks. 5년 후에도 그대로일 거예요. 본인이 지금 익힌 H7이 평생 유효한 자산. **빠르게 변하는 시대에 안 변하는 도구를 익히는 게 가장 확실한 투자**예요. 🐾

---

## 12. 흔한 오해 5가지

**오해 1: ".git/ 폴더는 만지면 안 돼요."** — 만질 수 있어요. 다만 두려워하면서. .git의 모든 파일은 텍스트 또는 zlib 압축 텍스트. cat·vim으로 직접 열어 볼 수 있어요. 직접 수정도 가능 — 사고 후 마지막 수단으로. 평소엔 git 명령어로만, 사고 시엔 텍스트 직접도. 본인이 .git을 두려워하지 않는 게 5년 차로 가는 한 단계.

**오해 2: "SHA-1 충돌이 일어나면 우리 저장소가 망해요."** — 실용적으론 안 일어나요. 2017년 SHAttered도 일부러 만들기 위해 6500 CPU-year를 썼어요. 우연히 일어날 확률은 우주 나이만큼. 그래도 git은 SHA-256로 천천히 옮기는 중. 본인이 새 저장소 만들 때 `--object-format=sha256`을 쓸 수 있지만 호환성 때문에 아직 SHA-1이 표준.

**오해 3: "blob에 파일 이름이 들어 있어요."** — 안 들어 있어요. 파일 이름은 tree 항목에. blob은 raw bytes만. 그래서 같은 내용의 파일 100개가 blob 한 개를 공유. 자동 중복 제거. **이게 git의 가장 큰 디스크 절약 마법**이에요.

**오해 4: "packfile은 git이 알아서 만드니까 신경 안 써도 돼요."** — 99% 맞아요. 다만 큰 저장소에선 가끔 `git gc --aggressive`를 수동으로 돌리면 GB 단위로 줄어요. 분기마다 한 번 정도 점검. 그리고 `git push --no-thin` 같은 옵션은 packfile 동작을 바꾸는 옵션 — 평소엔 안 써도 됨.

**오해 5: "hooks는 회사용이에요."** — 본인 노트북에 pre-commit 한 장 깔아 두는 게 가장 빠른 사고 방지. AWS 키·console.log·디버그 print 자동 차단. 5분 셋업이 5년 안전. 회사용이 아니라 본인용.

---

## 13. FAQ 5가지

**Q1. `git cat-file`을 일상에서 쓸 일이 있나요?**
A. 거의 없어요. 사고 추적·교육·디버깅에서만. 본인이 5년 차가 돼도 평균 한 분기에 한 번 두드리는 정도. 다만 한 번 두드려 보면 git의 내장이 보여요. **이번 H7이 그 한 번**이에요. 평생 안 두드려도 되지만 한 번은 두드려 봐야.

**Q2. 저장소가 너무 커졌어요(10GB+). 어떻게 줄이나요?**
A. (1) `git gc --aggressive`로 정비, (2) 큰 binary 파일이 있다면 BFG Repo-Cleaner 또는 `git filter-repo`로 history에서 제거, (3) Git LFS로 binary를 별도 저장소로 옮기기. 회사 저장소는 보통 (3)을 표준. Ch041(모노레포)에서 깊이 다뤄요. 빨강 명령어 — 두드리기 전 반드시 백업, 동료에게 알리기.

**Q3. SHA-256으로 옮기는 게 좋나요?**
A. 2026년 현재 아직 권장 안 됨. GitHub·GitLab이 단계적으로 받기 시작했지만 모든 도구가 호환되진 않아요. 본인의 새 사이드 프로젝트에서 한 번 써 보는 건 좋아요(`git init --object-format=sha256`). 다만 회사 저장소는 IT 정책에 따라. 5년 후엔 SHA-256이 표준이 될 거예요.

**Q4. `.git/`을 통째로 백업하면 저장소 백업이 되나요?**
A. 됩니다. .git/이 본인 저장소의 모든 것. `.git/`만 외장 디스크에 복사해 두면 working tree까지 다 복원할 수 있어요(`git checkout HEAD -- .` 한 줄로). 다만 본인이 push해 두면 GitHub이 자동 백업이라 거의 안 필요해요. **분산 git의 본질** — 모든 clone이 풀 백업.

**Q5. hook이 너무 느려서 commit이 답답해요.**
A. (1) hook 안의 명령어 중 가장 느린 게 뭔지 측정, (2) 무거운 검사(typecheck·전체 테스트)는 pre-commit이 아니라 pre-push로 옮기기, (3) lint 같은 건 변경된 파일만 검사하도록(예: lint-staged 도구). pre-commit은 5초 안에 끝나야 일상이 매끈해요. 30초 넘어가면 본인이 hook을 우회(`git commit --no-verify`)하기 시작 — 그러면 hook이 무의미해져요.

**보너스 Q: git 객체의 sha를 본인이 직접 계산할 수 있나요?**
A. 가능해요. `printf "blob %d\0" $(wc -c < file) | cat - file | sha1sum` 같은 한 줄로 git이 그 파일에 줄 sha를 미리 계산할 수 있어요. 5년 차 동료에게 보여 주면 "아 이거 알아요?"라고 신기해 해요. 일상에선 쓸 일 없지만 git의 본질이 어디까지 단순한지 보여 주는 한 줄.

---

## 14. 추신

추신 1. .git의 모든 파일은 텍스트(또는 zlib 압축 텍스트). 본인이 cat·vim·python으로 직접 만질 수 있어요. 두려워하지 마세요. 한 번 까 보면 평생 친해져요.

추신 2. 4종 객체(blob·tree·commit·tag)와 1개 인덱스. 이게 git의 데이터 모델 전부예요. 본인이 1년 뒤에 git을 다시 들여다봐도 이 5개가 그 자리에 그대로 있어요. **단순함이 강력함**.

추신 3. SHA-1은 평생 안 잊을 단어. content-addressable storage의 마법. 같은 내용이면 같은 sha, 1비트 다르면 완전히 다른 sha. avalanche 효과. 천문학적 충돌 안전.

추신 4. packfile은 git이 알아서 — 본인이 신경 안 써도 GB가 KB로. 다만 1년에 한 번 `git count-objects -v`로 본인 저장소 통계를 한 번 보는 건 좋아요. 자기 저장소를 알면 사고 시 침착해요.

추신 5. refs/는 한 줄짜리 텍스트. 가지 = 41바이트. 무게 없음. 자유롭게 따고 자유롭게 지우세요. 41바이트가 본인 새 기능의 무게.

추신 6. `index`는 staging의 본체 — 다음 commit이 만들 tree의 미리보기. `git add` 후 `git diff --staged`로 한 번 더 검문. 5년 차의 자기 리뷰 한 줄.

추신 7. `hooks/`는 본인 노트북의 자동 동료. pre-commit 한 장이 사고 80% 방지. husky나 pre-commit framework로 셋업 5분.

추신 8. `git fsck`·`gc`·`prune`·`repack`은 1년에 한두 번. 본인이 직접 두드릴 일 거의 없지만 알고 있는 것과 모르는 것의 차이. 사고 시 응급실.

추신 9. `ORIG_HEAD`와 `reflog`는 본인의 두 가지 자동 백업. rebase·reset·merge 직전 위치가 자동 저장. 본인이 따로 백업 가지 안 만들어도 한 단계 전으론 자동 복원.

추신 10. `.git/`을 직접 만지는 건 사고의 마지막 수단. 평소엔 git 명령어로만. 그래도 .git 안의 모든 파일이 사람이 읽을 수 있는 텍스트라는 사실이 본인을 안심시켜 줘요. **투명한 도구**가 가장 신뢰할 수 있는 도구.

추신 11. git의 단순함은 1주일에 만든 도구라서가 아니라, **단순함을 일부러 지킨 디자인 원칙** 때문이에요. Linus가 매번 새 기능 제안에 "이게 정말 필요한가?"를 가장 엄격하게 따져요. 그래서 21년이 지난 지금도 git의 본질은 그대로. 본인이 한 번 익히면 평생.

추신 12. H7을 한 번 읽고 H8로 넘어가세요. H8에서 8개 H가 합쳐져 본인의 git 기둥 한 개가 완성돼요. Ch005(협업 워크플로우)로 가는 다리가 그 마지막 30분에.

추신 13. **본인이 git의 내부를 처음 본 오늘 날짜를 기억해 두세요.** 5년 후 본인이 사고를 만나도 침착할 때, "그래, 그 H7 읽은 날부터 git이 안 무서워졌지"라고 떠올릴 수 있어요. 학습엔 분기점이 있어요 — 도구가 안 무섭게 느껴지는 첫 날. 오늘이 그 날일 수 있어요. 본인이 .git/objects를 한 번 까 본 오늘이.

추신 14. **다른 사람에게 H7을 설명할 수 있다면 본인 것이 된 거예요.** 동료에게 "git의 객체는 4종이야 — blob·tree·commit·tag, 다 SHA-1로 주소되고 zlib으로 압축돼"라고 한 줄로 말할 수 있나요? 못하면 한 번 더 읽으세요. 할 수 있으면 본인의 자산. **설명할 수 있는 지식만 본인의 지식**이에요.

추신 15. 본 챕터의 마지막 추신 — git을 만든 Linus Torvalds가 한 인터뷰에서 "git의 데이터 모델은 단순해. 복잡한 건 사용자 인터페이스(명령어)뿐"이라고 말했어요. 본인이 H7에서 본 게 그 단순한 데이터 모델. 명령어가 30개라도 데이터 모델은 4종 객체뿐. **단순함을 본 사람이 복잡함을 다스려요.** 그래서 H7이 H4(명령어 카탈로그)보다 깊은 시간이에요. 명령어는 변해도 객체는 안 변해요. 본인이 5년 후 H7만 다시 펼쳐도 그 자리에 있어요. **고전이 된 글은 평생의 친구**예요. 본인의 첫 고전이 H7이에요. 평생 친구. 🐾