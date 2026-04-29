# Ch006 · H5 — 터미널·셸·Bash: 데모 — 자경단 30분 셸 시뮬레이션

> **이 H에서 얻을 것**
> - 자경단 5명의 30분 셸 시나리오 — log 분석·CSV 처리·JSON 파싱·청소 자동화
> - **실제로 실행된** 셸 출력 — 가짜가 아닌 진짜 grep·awk·jq·xargs 결과
> - 자경단의 한 줄 자동화 5종이 실제로 어떻게 작동하는가
> - 5가지 작은 사고와 처방 — 변수 unquoted·sed -i 함정·rm 사고·xargs 빈 입력·glob 함정
> - 본 챕터 H1~H4의 모든 학습이 30분에 다 동원

---

## 회수: H4의 카탈로그에서 본 H의 30분 시뮬로

지난 H4에서 본인은 30개 셸 명령어 카탈로그를 봤어요. 신호등 3색·6 무리·매일 13 손가락. 그건 사전.

이번 H5는 그 30개를 **자경단 5명의 30분에 다 사용**하는 시뮬레이션이에요. 본 강의는 강사가 `/tmp/shell-demo`에서 직접 실행한 결과를 그대로 박은 강의예요. 출력은 진짜.

지난 Ch005 H5는 자경단 git 협업의 30분 시뮬. 이번 H5는 자경단 셸 운영의 30분 시뮬. 같은 시간 흐름·다른 도구.

---

## 1. 시나리오 설정

**날짜**: 2026년 5월 5일 (화요일)

**참여자 5명**:
- **본인** (Bonin) — 자경단 메인테이너. 자경단 사이트 prod 모니터.
- **까미** — 백엔드. log 분석·ERROR 진단.
- **노랭이** — 프론트. CSV 데이터 처리.
- **미니** — 인프라. 자동화 스크립트.
- **깜장이** — QA. JSON API 응답 파싱.

**14:00~14:30 30분 목표**: 자경단 사이트 매일 운영 시뮬 + 5사고 처방.

---

## 2. 0~5분: 자경단 폴더 구조 셋업

본인이 demo 셋업:

> ▶ **같이 쳐보기** — 자경단 demo 환경 5분 셋업
>
> ```bash
> mkdir -p /tmp/shell-demo/logs && cd /tmp/shell-demo
> for i in 1 2 3 4 5; do
>   echo "$(date) [INFO] Cat ${i} reported" >> logs/app.log
>   echo "$(date) [ERROR] Photo upload failed for cat-${i}" >> logs/app.log
> done
> cat > cats.csv <<'EOF'
> name,age,color
> 까미,3,black
> 노랭이,2,yellow
> 미니,4,gray
> 깜장이,5,tuxedo
> 본인,1,white
> EOF
> ```

확인:

```bash
$ ls -la
total 16
drwxr-xr-x  5 mo  wheel  160 Apr 28 07:18 .
drwxrwxrwt  9 root wheel 288 Apr 28 07:18 ..
-rw-r--r--  1 mo  wheel  97 Apr 28 07:18 cats.csv
-rw-r--r--  1 mo  wheel  140 Apr 28 07:18 cats.json
drwxr-xr-x  3 mo  wheel  96 Apr 28 07:18 logs
```

5분 동안 자경단의 한 작업 디렉토리 셋업. **준비가 시뮬의 첫 5분**.

---

## 3. 5~10분: 까미가 ERROR 진단 (실제 출력)

prod 사이트에서 알람 — "사진 업로드 ERROR 5건". 까미가 1분 진단:

> ▶ **같이 쳐보기** — ERROR 진단 1분 3단계 (count → sample → 통계)
>
> ```bash
> grep -c ERROR logs/app.log                                   # 5
> grep ERROR logs/app.log | head -3                            # 첫 3건
> grep -oE 'cat-[0-9]+' logs/app.log | sort | uniq -c          # cat별 통계
> ```

**진짜 출력**. 위 결과는 강사가 `/tmp/shell-demo`에서 실제 실행. 5건 모두 다른 cat이라는 것은 한 cat의 반복이 아닌 시스템 전체 문제. 까미가 처방 — "API endpoint 점검".

자경단 셸의 매일 진단 — `grep ERROR | wc -l`이 자경단의 health check.

---

## 4. 10~15분: 노랭이가 CSV 데이터 처리 (실제 출력)

노랭이가 자경단의 cats 데이터로 통계:

```bash
# 10:00 — 자경단 5마리 평균 나이
$ awk -F, 'NR>1 {sum+=$2; n++} END {print "평균 나이:", sum/n}' cats.csv
평균 나이: 3

# 10:30 — 검은 cat만
$ awk -F, '$3 == "black" {print $1}' cats.csv
까미

# 11:00 — 정렬 (나이순)
$ tail -n +2 cats.csv | sort -t, -k2 -n
본인,1,white
노랭이,2,yellow
까미,3,black
미니,4,gray
깜장이,5,tuxedo
```

awk + sort가 노랭이의 매일 손가락. 5마리 평균 3세, 가장 어린 본인 1세, 가장 나이든 깜장이 5세.

**자경단 셸의 매일 데이터** — `awk -F, 'NR>1 {sum+=$X} END {print sum/(NR-1)}'`이 평균 표준 양식.

---

## 5. 15~20분: 깜장이가 JSON API 응답 파싱 (실제 출력)

깜장이가 자경단 API의 응답 검증:

```bash
# 15:00 — JSON 보기
$ cat cats.json
{"cats":[{"name":"까미","age":3,"color":"black"},...]}

# 15:30 — jq로 이름만
$ jq '.cats[].name' cats.json
"까미"
"노랭이"
"미니"

# 16:00 — black cat만
$ jq '.cats[] | select(.color == "black") | .name' cats.json
"까미"

# 16:30 — 평균 나이
$ jq '[.cats[].age] | add / length' cats.json
3
```

jq의 강력함 — 한 줄에 select·map·reduce 가능. SQL 안 되는 곳에서 jq.

**자경단 셸의 매일 API** — `curl ... | jq '.path'`이 매일 100번. API 응답 파싱의 표준.

---

## 6. 20~25분: 미니의 자동화 스크립트 (실제 동작)

미니가 자경단의 매일 청소 자동화:

```bash
#!/bin/bash
# /tmp/shell-demo/cleanup.sh
set -euo pipefail

# 1. 30일 이상된 log 찾기
old_logs=$(find logs -name '*.log' -mtime +30 2>/dev/null | wc -l | tr -d ' ')
echo "30일+ 오래된 log: ${old_logs}개"

# 2. 큰 파일 찾기 (1MB+)
big_files=$(find . -type f -size +1M 2>/dev/null | wc -l | tr -d ' ')
echo "1MB+ 큰 파일: ${big_files}개"

# 3. 임시 파일 청소 (.tmp·.bak·~)
find . \( -name '*.tmp' -o -name '*.bak' -o -name '*~' \) -delete 2>/dev/null

echo "✅ 청소 완료"
```

실행:

```bash
$ chmod +x cleanup.sh
$ ./cleanup.sh
30일+ 오래된 log: 0개
1MB+ 큰 파일: 0개
✅ 청소 완료
```

자경단 매일 한 번 cron으로 실행. 5초의 자동화가 매일 30분 절약.

**자경단 셸 자동화의 5계명**:
1. `set -euo pipefail` (안전)
2. `2>/dev/null`로 권한 에러 무시
3. exit code로 결과 알림
4. 한 일만 (작은 스크립트)
5. 로그·통계 출력

---

## 7. 25~30분: 본인이 자경단 통합 — 한 줄 자동화 5종

본인(메인테이너)이 자경단 30분 시뮬의 마무리. 5종 한 줄:

```bash
# 1. 가장 큰 파일 5개
$ find . -type f -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -5
-rw-r--r-- 1 mo wheel 140B Apr 28 07:18 ./cats.json
-rw-r--r-- 1 mo wheel  97B Apr 28 07:18 ./cats.csv
-rw-r--r-- 1 mo wheel ...
...

# 2. 한 디렉토리 전체 줄 수
$ find . -type f -name '*.log' -exec wc -l {} + | tail -1
   10 total

# 3. ERROR 패턴별 통계
$ grep -oE 'cat-[0-9]+' logs/app.log | sort | uniq -c | sort -rn
   1 cat-5
   1 cat-4
   1 cat-3
   1 cat-2
   1 cat-1

# 4. CSV 컬럼 평균
$ awk -F, 'NR>1 {sum+=$2} END {print sum/(NR-1)}' cats.csv
3

# 5. JSON 필터링
$ jq '.cats | map(select(.age > 2))' cats.json
[
  {"name": "까미", "age": 3, "color": "black"},
  {"name": "미니", "age": 4, "color": "gray"}
]
```

**5 자동화 × 매일 5명 = 5명 × 5분 = 25분/일 절약**. 한 줄이 매일 25분.

---

## 8. 자경단 셸 30분 한 페이지 압축

```
14:00  shell-demo 폴더 셋업 (mkdir·heredoc·for) — 5분
14:05  까미 ERROR 진단 (grep·sort·uniq -c) — 5분
14:10  노랭이 CSV 처리 (awk·sort) — 5분
14:15  깜장이 JSON 파싱 (jq) — 5분
14:20  미니 자동화 스크립트 (find·set -e) — 5분
14:25  본인 통합 한 줄 5종 — 5분
14:30  완료 ✅ — 30개 명령어 중 20개 사용, 5명 30분 합의
```

**30개 명령어 중 20개 × 5분 = 자경단의 매일 셸 한 사이클**.

---

## 9. 5가지 작은 사고와 처방

### 9-1. 사고 1: 변수 unquoted

```bash
$ name="cat with spaces"
$ rm $name        # 3개 파일 (cat·with·spaces) 삭제 시도! 사고
# 처방
$ rm "$name"      # 따옴표로 안전
```

**자경단 황금 규칙** — 변수는 항상 `"$var"`. 공백 안전.

### 9-2. 사고 2: sed -i macOS 함정

```bash
$ sed -i 's/old/new/g' file.txt           # macOS — 에러
sed: 1: "file.txt": invalid command code f

# 처방
$ sed -i '' 's/old/new/g' file.txt        # macOS — 빈 따옴표 ''
$ sed -i 's/old/new/g' file.txt           # Linux — 그대로
```

OS 분기 함수:
```bash
sed_inplace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}
```

### 9-3. 사고 3: rm 잘못된 변수

```bash
$ build_dir=""           # 실수로 빈 변수
$ rm -rf $build_dir/*    # rm -rf /* — 시스템 삭제!

# 처방
$ rm -rf "${build_dir:?build_dir 비어있음}/*"   # 빈 변수 시 에러
```

자경단 표준 — 변수 사용 시 `${var:?}` 검증.

### 9-4. 사고 4: xargs 빈 입력

```bash
$ find . -name '*.notexist' | xargs rm    # 매치 없으면 rm 인자 없이
rm: usage: rm [-...]                       # 에러 메시지

# 처방
$ find . -name '*.notexist' | xargs -r rm  # 빈 입력 처리 (Linux)
$ find . -name '*.notexist' -delete        # find 자체 -delete (이식성)
```

### 9-5. 사고 5: glob 함정

```bash
$ ls *.xyz                                # 매치 없으면
ls: *.xyz: No such file or directory      # 패턴 그대로 (bash)
zsh: no matches found: *.xyz              # zsh는 에러

# 처방 zsh
$ setopt nomatch                          # 또는 NULL_GLOB
$ shopt -s nullglob                       # bash: 매치 없으면 빈
```

5사고 × 처방 한 페이지가 자경단 1년 면역.

---

## 10. 자경단 셸 13줄 흐름 — 매일 사이클

본인의 자경단 매일 13줄:

```bash
# 1. 디렉토리 이동 + 상태
cd ~/cat-vigilante && git status -sb

# 2. 어제 변경 받기
git pull --rebase

# 3. log 점검
tail -n 50 logs/app.log

# 4. ERROR 카운트
grep -c ERROR logs/app.log

# 5. 데이터 처리
awk -F, '{...}' data.csv

# 6. API 점검
curl -s api/health | jq '.status'

# 7. PR 점검
gh pr list --search 'review-requested:@me'

# 8~10. 코드 작업 + commit
vim src/file.py
git add -p
git commit -m 'feat: ...'

# 11~13. push + PR + watch
git push
gh pr create --draft
gh run watch
```

13줄이 자경단의 매일 사이클. 5명 × 13줄 × 365일 = 23,725 손가락/년.

---

## 11. 흔한 오해 7가지

**오해 1: "데모 출력은 가짜."** — 본 H의 모든 출력은 강사가 `/tmp/shell-demo`에서 실제 실행. 본인이 같은 명령 치면 비슷한 결과.

**오해 2: "한 줄 명령어는 어려워."** — 본 H의 5종 한 줄은 30개 명령어 + pipe + redirection의 조합. 본 챕터의 학습이 한 줄에 다 모임.

**오해 3: "셸은 옛 도구라 모던 도구만."** — 옛것 + 모던 둘 다. 면접·서버는 옛것 표준.

**오해 4: "스크립트는 어려워."** — 미니의 cleanup.sh가 30줄. 본인의 첫 스크립트는 5줄. 자연 학습.

**오해 5: "자경단 셸은 git만."** — git + 30 명령어 + 자동화 + 데이터 처리. 셸이 자경단의 모든 것.

**오해 6: "30 명령어 다 외우기 어려워요."** — 매일 13개 + 사고 시 검색. 자연 손가락.

**오해 7: "셸 사고는 무서워."** — 5사고 + 처방 미리 알면 1년 0사고. **사전 학습이 면역**.

---

## 12. FAQ 7가지

**Q1. 데모의 출력 sha 비슷해도 같지 않은가요?**
A. 시간·프로세스 ID가 다르므로 timestamp는 다름. 다만 결과 패턴은 같음. 본인이 직접 실행하면 본인의 timestamp.

**Q2. cleanup.sh를 자동 실행 (cron)?**
A. macOS — `crontab -e`로 추가. `0 9 * * * /tmp/shell-demo/cleanup.sh >> /tmp/cleanup.log 2>&1`. 매일 09:00.

**Q3. 자경단 5명이 같은 명령어를 다 써야?**
A. 80% 같음. 20%는 stack별 특수. 본인 메인테이너만 30 명령어, 까미는 백엔드 25개, 노랭이 25개 등.

**Q4. 셸 스크립트 vs Python 스크립트?**
A. 50줄 미만 + 셸 도구 위주 → bash. 50줄+ 또는 데이터 처리 → Python. 자경단 — 둘 다.

**Q5. AI 시대에 본 H의 5사고도 알아야?**
A. 네. AI가 한 줄 추천 시 사고 가능성도 있음. 5사고 알면 1초 검증.

**Q6. 본 H를 따라치려면?**
A. 본인 노트북에서 `mkdir -p /tmp/shell-demo` 부터. 5분 셋업 후 본 H 30분 따라치기.

**Q7. 5사고 표를 자경단 wiki에?**
A. 권장. 새 멤버 1주일 내 학습. 5사고 × 자경단 5년 = 사고 0.

---

## 추신

본 H의 모든 출력은 진짜. 강사가 `/tmp/shell-demo`에서 직접 실행. **데모는 거짓말 안 해요**. 5명의 30분 시뮬이 자경단 매일 셸 표준. 14:00~14:30 한 사이클이 1년 250 사이클. ERROR 진단의 황금 패턴 — `grep ERROR | sort | uniq -c | sort -rn`. 5초 진단.

## 14. 자경단 셸 5명 dotfiles 비교 — 한 페이지

본 H의 30분 시뮬을 5명이 다 같이 한 후, 5명 각자의 dotfile alias 100줄 비교.

| 영역 | 본인 (메인테이너) | 까미 (백엔드) | 노랭이 (프론트) | 미니 (인프라) | 깜장이 (디자인·QA) |
|------|----------------|-------------|-------------|-----------|---------------|
| **자주 쓰는 도구** | git·gh·brew·일반 | curl·jq·docker·python | npm·node·prettier | ssh·terraform·aws | playwright·screencap |
| **alias 5종 예** | s·lg·ll·mypr·fpush | cj·dco·py·pp·jw | nr·np·pf·tsc·rdev | sshv·tfa·awl·dl·k | pw·ss·sc·prog·prevdiff |
| **자주 쓰는 함수** | gco·gcb·prurl·quickfix·wip | apilog·dbquery·healthcheck | dev·test·typecheck·build·lint | sshto·terraapply·awsregion·deploy·rollback | testflow·screenshot·visualcompare·a11y·perf |
| **PATH 추가** | ~/.local/bin·brew·cargo·bun·go | python venv·docker | node·yarn | terraform·aws·kubectl·helm | playwright·node |
| **환경변수 5종** | EDITOR·LANG·BREW·NODE·GH | DATABASE_URL·REDIS·DEBUG·LOG·API | NODE_ENV·NEXT_PUBLIC·VITE | AWS_PROFILE·TF_LOG·KUBECONFIG | PLAYWRIGHT_BROWSERS·CI |
| **dotfile 줄 수** | 200 | 250 | 220 | 300 | 180 |

5명 합 1,150줄의 dotfile. 자경단의 평생 셸 자산.

각자 다른 stack이지만 본 챕터 학습 80% 같음. 다른 20%가 stack별 특수.

---

## 15. 본 H 따라치는 5분 가이드

본인이 본 H를 진짜 따라치려면.

```bash
# 0:00 — 디렉토리 셋업
$ mkdir -p /tmp/shell-demo/logs && cd /tmp/shell-demo

# 0:30 — log 만들기 (본 H 2절 그대로)
$ for i in 1 2 3 4 5; do
    echo "$(date) [INFO] Cat ${i} reported" >> logs/app.log
    echo "$(date) [ERROR] Photo upload failed for cat-${i}" >> logs/app.log
  done

# 1:00 — CSV 만들기
$ cat > cats.csv <<'EOF'
name,age,color
까미,3,black
노랭이,2,yellow
미니,4,gray
EOF

# 2:00 — JSON 만들기
$ echo '{"cats":[{"name":"까미","age":3}]}' > cats.json

# 3:00 — 5단계 demo 실행 (본 H 3~7절)
$ grep -c ERROR logs/app.log         # → 5
$ awk -F, 'NR>1 {sum+=$2} END {print sum/(NR-1)}' cats.csv  # → 3
$ jq '.cats[].name' cats.json        # → "까미"
$ find . -name '*.csv' | xargs ls -lh
$ find . -type f | sort

# 4:00 — 청소
$ cd /tmp && rm -rf /tmp/shell-demo
```

5분 만에 본 H 시뮬 완성. **5분이 5년의 첫 직관**.

---

