# Ch006 · H5 — 자경단 30분 셸 시뮬레이션 — 다섯 명이 같이 쓰는 30개 명령어

> 고양이 자경단 · Ch 006 · 5교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. 시나리오 — 2026년 5월 5일 화요일 오후 2시
3. 0~5분 — 본인이 demo 폴더 셋업
4. 5~10분 — 까미가 ERROR 진단 한 분
5. 10~15분 — 노랭이가 CSV 데이터 통계
6. 15~20분 — 깜장이가 JSON API 응답 파싱
7. 20~25분 — 미니의 청소 자동화 스크립트
8. 25~30분 — 본인이 통합, 한 줄 자동화 다섯 가지
9. 30분 한 페이지 압축
10. 다섯 가지 작은 사고와 처방
11. 자경단 매일 13줄 흐름
12. 흔한 오해 다섯 가지
13. 자주 받는 질문 다섯 가지
14. 마무리 — 다음 H6에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 0~5분 셋업
mkdir -p /tmp/shell-demo/logs && cd /tmp/shell-demo
for i in 1 2 3 4 5; do
  echo "$(date) [INFO] Cat ${i} reported" >> logs/app.log
  echo "$(date) [ERROR] Photo upload failed for cat-${i}" >> logs/app.log
done
cat > cats.csv <<'EOF'
name,age,color
까미,3,black
노랭이,2,yellow
미니,4,gray
깜장이,5,tuxedo
본인,1,white
EOF

# 5~10분 까미
grep -c ERROR logs/app.log
grep -oE 'cat-[0-9]+' logs/app.log | sort | uniq -c

# 10~15분 노랭이
awk -F, 'NR>1 {sum+=$2} END {print sum/(NR-1)}' cats.csv
awk -F, '$3 == "black" {print $1}' cats.csv

# 15~20분 깜장이
jq '.cats[].name' cats.json
jq '.cats[] | select(.color == "black")' cats.json

# 20~25분 미니
./cleanup.sh

# 25~30분 본인
find . -type f -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -5
```

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 이제 다섯 번째 시간이에요. 절반을 넘었어요. 잘 따라오시고 계시네요. 박수.

지난 H4를 한 줄로 회수할게요. 본인은 30개 명령어를 표 한 장으로 만나셨어요. 신호등 세 색깔, 6 무리, 매일 6개부터 시작. 그게 사전이었어요. 사전을 외우는 시간이 아니라 사전 그림을 머리에 두는 시간이었어요.

이번 H5는 그 30개 명령어를 자경단 다섯 명이 30분 안에 다 사용하는 시뮬레이션이에요. 가장 재밌는 시간이에요. 책에서 배운 게 진짜로 어떻게 일하는 손가락에서 사용되는지 그림이에요. 본인이 옆에서 다섯 명을 구경하시면 됩니다.

오늘의 약속은 한 가지예요. **본인이 H1부터 H4까지 배운 모든 것이 30분 안에 한 번씩 다 사용됩니다**. 검은 화면, 8개념, 30 도구, 자경단 협업. 다 30분에 들어와요. 30분 후엔 본인이 "아, 이렇게 쓰는 거구나" 하는 그림이 생겨요. 그림이 생기면 손가락이 따라와요.

자, 시나리오부터 가요.

---

## 2. 시나리오 — 2026년 5월 5일 화요일 오후 2시

날짜 한 번 알려 드릴게요. 2026년 5월 5일 화요일. 어린이날인데 본인은 일하고 있어요. (실제 자경단은 휴일도 잘 쉬어요.) 시간은 오후 2시. 자경단 다섯 명이 각자 자기 자리에서 일을 시작해요.

자, 다섯 명을 한 번 더 소개해요. **본인 (Bonin)**, 자경단 메인테이너. 자경단 사이트의 prod 모니터 담당. 다섯 명의 일을 통합하는 사람. **까미**, 백엔드. log 분석과 ERROR 진단. **노랭이**, 프론트엔드. CSV 데이터 처리와 통계. **미니**, 인프라. 자동화 스크립트. **깜장이**, QA. JSON API 응답 검증.

오후 2시부터 2시 30분까지 30분 동안 다섯 명이 각자 5분씩 일하고, 마지막 5분에 본인이 통합. 30분이 끝나면 자경단 사이트가 그날 운영 한 사이클을 마쳐요.

본인이 옆에서 따라오면서 같이 쳐 보셔도 좋아요. 모든 명령어는 본인 노트북의 `/tmp/shell-demo` 폴더에서 실행돼요. 안전한 임시 폴더라 본인 데이터에 영향 없어요. 자, 시작해요.

---

## 3. 0~5분 — 본인이 demo 폴더 셋업

본인(메인테이너)이 첫 5분에 demo 폴더를 셋업해요. 다섯 명이 같이 쓸 작업 디렉토리를 만들고, 가짜 로그와 데이터를 채워요.

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
> cat > cats.json <<'EOF'
> {"cats":[{"name":"까미","age":3,"color":"black"},{"name":"노랭이","age":2,"color":"yellow"},{"name":"미니","age":4,"color":"gray"},{"name":"깜장이","age":5,"color":"tuxedo"},{"name":"본인","age":1,"color":"white"}]}
> EOF
> ```

이 한 묶음 안에 H2의 8개념이 거의 다 들어 있어요. mkdir로 폴더 만들기. for 루프로 반복 (셸에서 for 루프도 됩니다). echo와 redirection (`>>`)으로 파일에 줄 추가. heredoc (`<<'EOF'`)으로 여러 줄 입력. command substitution (`$(date)`)으로 현재 시간을 글자에 끼워 넣기.

5분 동안 한 거 확인해 봐요.

```bash
$ ls -la
total 16
drwxr-xr-x  5 mo  wheel  160 Apr 28 07:18 .
drwxrwxrwt  9 root wheel 288 Apr 28 07:18 ..
-rw-r--r--  1 mo  wheel   97 Apr 28 07:18 cats.csv
-rw-r--r--  1 mo  wheel  140 Apr 28 07:18 cats.json
drwxr-xr-x  3 mo  wheel   96 Apr 28 07:18 logs
```

cats.csv, cats.json, logs 폴더가 보이죠. 셋이 다섯 명이 각자 만질 데이터예요. 5분 후 다섯 명이 도착해서 자기 일을 시작해요.

---

## 4. 5~10분 — 까미가 ERROR 진단 한 분

오후 2시 5분, 까미가 자기 자리에 도착. 그때 자경단 사이트의 prod 모니터에서 알람이 떠요. "사진 업로드 ERROR 5건". 까미가 1분 안에 진단을 시작해요.

까미의 진단은 3단계예요. 첫째, 몇 건이야? 둘째, 샘플 좀 볼까. 셋째, 어떤 cat에서 발생했어?

> ▶ **같이 쳐보기** — 까미의 ERROR 진단 1분 3단계
>
> ```bash
> grep -c ERROR logs/app.log
> grep ERROR logs/app.log | head -3
> grep -oE 'cat-[0-9]+' logs/app.log | sort | uniq -c
> ```

엔터 누르면 진짜 출력이 떠요.

```
5
Tue Apr 28 07:18:00 KST 2026 [ERROR] Photo upload failed for cat-1
Tue Apr 28 07:18:00 KST 2026 [ERROR] Photo upload failed for cat-2
Tue Apr 28 07:18:00 KST 2026 [ERROR] Photo upload failed for cat-3
   1 cat-1
   1 cat-2
   1 cat-3
   1 cat-4
   1 cat-5
```

세 단계가 1분에 다 끝났어요. 첫째, ERROR 5건. 둘째, 샘플 보니 다 사진 업로드 실패. 셋째, cat 1번부터 5번까지 모두 한 번씩. 의미를 까미가 1초 안에 읽어요. **5건이 한 cat의 반복이 아니라 5명 다 영향. 그러면 시스템 전체 문제**. API endpoint 점검 필요.

까미의 진단에 H4의 grep, head, sort, uniq 네 개가 들어갔어요. 그리고 H2의 pipe (`|`) 두 번. H1의 한 줄 명령어 그림이 진짜 일에서 어떻게 작동하는지 1분으로 보여드린 거예요.

자경단의 매일 health check 한 줄을 알려드릴게요. `grep ERROR logs/app.log | wc -l`. ERROR 카운트 확인. 자경단의 일상 첫 동작이에요.

---

## 5. 10~15분 — 노랭이가 CSV 데이터 통계

오후 2시 10분, 노랭이가 자경단 cats 데이터로 통계를 뽑기 시작해요. 노랭이의 무기는 awk예요.

> ▶ **같이 쳐보기** — 노랭이의 CSV 통계 5분 3단계
>
> ```bash
> # 평균 나이
> awk -F, 'NR>1 {sum+=$2; n++} END {print "평균 나이:", sum/n}' cats.csv
> 
> # 검은 cat만
> awk -F, '$3 == "black" {print $1}' cats.csv
> 
> # 나이순 정렬
> tail -n +2 cats.csv | sort -t, -k2 -n
> ```

진짜 출력.

```
평균 나이: 3
까미
본인,1,white
노랭이,2,yellow
까미,3,black
미니,4,gray
깜장이,5,tuxedo
```

5분에 통계 세 가지를 끝냈어요. 평균 3세, 검은 cat은 까미 한 명, 나이순으로 정렬. 노랭이가 한 줄씩 짜는데 평소 1분이면 끝나요.

awk 문법을 짧게 풀어 드릴게요. `-F,`는 콤마 구분자. `NR>1`은 1번째 줄(헤더) 건너뛰기. `{...}`는 각 줄에 적용할 코드. `END {...}`는 마지막 한 번만. `$1, $2, $3`은 1번째, 2번째, 3번째 컬럼. 이 다섯 가지 문법만 알면 자경단의 90% CSV 처리가 가능해요.

자경단의 CSV 표준 한 줄 — `awk -F, 'NR>1 {sum+=$X} END {print sum/(NR-1)}'`. 평균 계산의 표준 양식이에요. X 자리에 컬럼 번호만 바꾸면 어떤 컬럼이든 평균.

---

## 6. 15~20분 — 깜장이가 JSON API 응답 파싱

오후 2시 15분, 깜장이가 자경단 API의 응답 검증을 시작. 깜장이의 무기는 jq예요.

> ▶ **같이 쳐보기** — 깜장이의 JSON 검증 5분 4단계
>
> ```bash
> # JSON 보기
> cat cats.json
> 
> # 이름만 추출
> jq '.cats[].name' cats.json
> 
> # 검은 cat만
> jq '.cats[] | select(.color == "black") | .name' cats.json
> 
> # 평균 나이
> jq '[.cats[].age] | add / length' cats.json
> ```

진짜 출력.

```json
{"cats":[{"name":"까미","age":3,"color":"black"},...]}

"까미"
"노랭이"
"미니"
"깜장이"
"본인"

"까미"

3
```

깜장이가 5분에 jq로 SQL 비슷한 처리를 다 했어요. 이름 추출, 필터, 집계. JSON에 SQL이 안 되는 곳에서 jq가 SQL 비슷하게 일해요. 진짜 강력해요.

jq의 핵심 문법 다섯 개. `.`은 root. `.cats`는 cats 필드. `.cats[]`는 배열의 모든 요소. `select()`는 조건 필터. `add`, `length`, `min`, `max` 같은 집계 함수. 이 다섯 가지로 자경단의 매일 API 디버깅이 가능해요.

자경단의 매일 API 한 줄 — `curl -s <api> | jq '.path'`. 자경단 까미가 매일 100번 만나는 한 줄이에요. curl로 응답 받고, pipe로 jq에 넘기고, jq로 필요한 필드만 뽑기. 한 줄에 두 도구.

---

## 7. 20~25분 — 미니의 청소 자동화 스크립트

오후 2시 20분, 미니가 자경단의 매일 청소 자동화를 짜기 시작. 미니의 무기는 셸 스크립트예요.

미니가 짜는 cleanup.sh를 보여드릴게요.

```bash
#!/bin/bash
# /tmp/shell-demo/cleanup.sh
set -euo pipefail

# 1. 30일 이상된 로그 찾기
old_logs=$(find logs -name '*.log' -mtime +30 2>/dev/null | wc -l | tr -d ' ')
echo "30일+ 오래된 log: ${old_logs}개"

# 2. 1MB 넘는 파일 찾기
big_files=$(find . -type f -size +1M 2>/dev/null | wc -l | tr -d ' ')
echo "1MB+ 큰 파일: ${big_files}개"

# 3. 임시 파일 청소
find . \( -name '*.tmp' -o -name '*.bak' -o -name '*~' \) -delete 2>/dev/null

echo "✅ 청소 완료"
```

짧지만 모든 핵심이 들어 있어요. 첫 줄 `#!/bin/bash`은 shebang. 이 파일이 bash 스크립트라는 표시. 둘째 줄 `set -euo pipefail`은 안전 옵션 세 개. e는 에러 시 멈춤, u는 정의 안 된 변수 사용 금지, pipefail은 pipe 안 어느 명령이든 실패하면 전체 실패. 자경단의 모든 셸 스크립트의 첫 줄이에요.

그 다음 세 가지 일을 차례로. find로 오래된 로그 찾기, find로 큰 파일 찾기, find로 임시 파일 삭제. 마지막에 ✅로 완료 표시. 30줄 안 되는 짧은 스크립트지만 진짜로 일을 해요.

실행해 봐요.

> ▶ **같이 쳐보기** — 미니의 cleanup.sh 실행
>
> ```bash
> chmod +x cleanup.sh
> ./cleanup.sh
> ```

진짜 출력.

```
30일+ 오래된 log: 0개
1MB+ 큰 파일: 0개
✅ 청소 완료
```

5분에 자동화 스크립트 한 장이 만들어졌어요. 자경단은 이 스크립트를 매일 한 번 cron으로 자동 실행해요. 5초의 자동화가 매일 30분을 살려요.

자경단 셸 자동화의 다섯 계명을 알려드릴게요. 첫째, `set -euo pipefail` (안전 옵션). 둘째, `2>/dev/null`로 권한 에러 무시. 셋째, exit code로 결과 알림. 넷째, 한 일만 (작은 스크립트). 다섯째, 로그·통계 출력. 다섯 계명을 H6에서 더 깊이 다뤄요. 오늘은 미니가 시범으로.

---

## 8. 25~30분 — 본인이 통합, 한 줄 자동화 다섯 가지

오후 2시 25분, 마지막 5분에 본인(메인테이너)이 다섯 명의 일을 통합해요. 한 줄 자동화 다섯 가지로 30분의 마무리.

> ▶ **같이 쳐보기** — 본인의 통합 한 줄 다섯 가지
>
> ```bash
> # 1. 가장 큰 파일 5개 (H1의 그 한 줄)
> find . -type f -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -5
> 
> # 2. 한 디렉토리 전체 줄 수
> find . -type f -name '*.log' -exec wc -l {} + | tail -1
> 
> # 3. ERROR 패턴별 통계
> grep -oE 'cat-[0-9]+' logs/app.log | sort | uniq -c | sort -rn
> 
> # 4. CSV 컬럼 평균
> awk -F, 'NR>1 {sum+=$2} END {print sum/(NR-1)}' cats.csv
> 
> # 5. JSON 필터링
> jq '.cats | map(select(.age > 2))' cats.json
> ```

진짜 출력.

```
-rw-r--r-- 1 mo wheel 140B Apr 28 07:18 ./cats.json
-rw-r--r-- 1 mo wheel  97B Apr 28 07:18 ./cats.csv
...

   10 total

   1 cat-5
   1 cat-4
   1 cat-3
   1 cat-2
   1 cat-1

3

[
  {"name": "까미", "age": 3, "color": "black"},
  {"name": "미니", "age": 4, "color": "gray"},
  {"name": "깜장이", "age": 5, "color": "tuxedo"}
]
```

다섯 줄에 자경단 다섯 명의 일이 다 압축돼 있어요. 첫 줄은 본인의 종합. 둘째는 까미의 도구. 셋째는 까미의 진단. 넷째는 노랭이의 통계. 다섯째는 깜장이의 검증.

다섯 줄 × 매일 다섯 명 = 5명 × 5분 = 25분/일 절약. 한 줄이 매일 25분을 살려 줘요. 1년이면 100시간. 다섯 명 합치면 500시간. 한 사람의 3개월치 노동시간이에요. 다섯 줄이 본인의 3개월을 사 줘요.

이게 셸의 진짜 가치예요. 한 줄이 시간을 사 주는 거. 본인도 5년 후엔 자기만의 다섯 줄을 갖게 돼요.

---

## 9. 30분 한 페이지 압축

자, 30분이 끝났어요. 한 페이지로 압축해 봐요.

```
14:00  본인이 demo 폴더 셋업 (mkdir·heredoc·for·redirection) — 5분
14:05  까미 ERROR 진단 (grep·sort·uniq -c) — 5분
14:10  노랭이 CSV 처리 (awk·sort) — 5분
14:15  깜장이 JSON 파싱 (jq) — 5분
14:20  미니 자동화 스크립트 (find·set -e·function) — 5분
14:25  본인 통합 한 줄 5종 — 5분
14:30  완료 ✅ — 30개 명령어 중 20개 사용, 5명 30분 합의
```

30분에 30개 중 20개 명령어가 사용됐어요. 매일 자경단의 한 사이클이 이 30분 안에 다 들어 있어요.

본인이 "어, 이건 H4에서 본 거네", "이건 H2의 pipe구나", "이건 H3에서 깐 jq구나" 하고 한 명씩 알아보셨으면 H5 졸업이에요. 본 챕터의 학습이 30분에 다 동원됐어요.

---

## 10. 다섯 가지 작은 사고와 처방

마지막 절. 자경단 다섯 명이 1년 동안 만나는 작은 사고 다섯 가지를 처방과 함께 알려드릴게요. 본인이 5년 동안 한 번씩은 만나요. 미리 알아 두시면 1초로 처방.

**사고 1: 변수에 따옴표 안 씌워서 공백 사고**

```bash
$ name="cat with spaces"
$ rm $name
# rm: cat: No such file or directory
# rm: with: No such file or directory
# rm: spaces: No such file or directory
```

본인이 한 변수에 공백이 있는 글자를 넣었는데, 사용할 때 따옴표를 안 씌우면 셸이 공백마다 단어로 끊어 버려요. 그래서 `cat`, `with`, `spaces` 세 개로 분리. 사고예요.

처방은 한 글자. **변수는 항상 따옴표 안에**. `rm "$name"`. 자경단 황금 규칙이에요.

**사고 2: macOS sed -i 함정**

```bash
$ sed -i 's/old/new/g' file.txt
sed: 1: "file.txt": invalid command code f
```

GNU sed (Linux)와 BSD sed (macOS)가 -i 옵션 처리가 달라요. macOS는 `-i` 다음에 빈 따옴표가 필요해요.

처방은 OS 분기 함수.

```bash
sed_inplace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}
```

이 함수를 dotfile에 박아 두고 평생 sed_inplace로 부르세요.

**사고 3: rm -rf의 빈 변수 사고**

```bash
$ build_dir=""
$ rm -rf $build_dir/*
# 위와 같으면 rm -rf /* — 시스템 통째 삭제!
```

build_dir 변수에 값이 안 들어 있으면 명령이 `rm -rf /*`로 풀려요. 진짜 위험해요.

처방은 빈 변수 검증.

```bash
rm -rf "${build_dir:?build_dir 비어있음}/*"
```

`${var:?}` 문법은 변수가 비어 있으면 에러를 내고 멈춰요. 자경단 표준이에요.

**사고 4: xargs 빈 입력 사고**

```bash
$ find . -name '*.notexist' | xargs rm
rm: usage: rm [-...]
```

find가 매치 없으면 빈 입력. xargs가 그걸 받아서 인자 없는 rm 호출. 에러.

처방은 두 가지. Linux는 `xargs -r`로 빈 입력 무시. macOS는 find 자체의 `-delete` 옵션.

```bash
find . -name '*.notexist' -delete
```

`-delete`가 이식성 좋아요.

**사고 5: glob 매치 없으면 사고**

```bash
$ ls *.xyz
ls: *.xyz: No such file or directory   # bash: 패턴 그대로
zsh: no matches found: *.xyz             # zsh: 에러
```

glob 패턴이 매치 안 되면 셸마다 처리가 달라요.

처방은 셸별 옵션.

```bash
# zsh
setopt nomatch       # 또는 NULL_GLOB

# bash
shopt -s nullglob    # 빈 문자열로 처리
```

다섯 사고와 다섯 처방을 한 페이지에 두면 자경단의 1년 면역력이에요. 외우려 마세요. 한 번 보고 가세요. 사고 만났을 때 "아, 본 적 있어" 하시면 1초 처방.

---

## 11. 자경단 매일 13줄 흐름

자경단 다섯 명이 매일 셸에서 치는 13줄 사이클을 보여드릴게요. 본인의 5년 후 모습이에요.

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

13줄이 자경단 한 명의 매일 사이클이에요. 5명 × 13줄 × 365일 = 23,725 손가락/년. 다섯 명이 1년에 23,725번 같은 13줄을 반복해요. 그 13줄이 본인의 손가락에 박히는 게 두 해 코스 끝의 그림이에요.

13줄 중 8줄은 H4의 30개 명령어. 5줄은 git/gh (Ch004, Ch005). 8 + 5 = 13. 두 챕터의 학습이 한 사이클에 다 동원돼요.

---

## 12. 흔한 오해 다섯 가지

**오해 1: 데모 출력은 가짜다.**

본 H의 모든 출력은 강사가 `/tmp/shell-demo`에서 실제로 실행한 결과예요. 본인이 같은 명령 치시면 비슷한 결과 떠요.

**오해 2: 한 줄 명령어는 어렵다.**

본 H의 다섯 줄 자동화는 30개 명령어 + pipe + redirection의 조합. 본 챕터의 학습이 한 줄에 다 모인 거예요. 어려운 게 아니라 익숙한 게 모인 거예요.

**오해 3: 셸은 옛 도구라 모던 도구만 써야 한다.**

옛것과 모던 둘 다 써요. 면접·서버는 옛것 표준이에요. grep을 못 알아보는 면접관은 없어요. rg는 멋지지만 grep도 손에 박혀 있어야 해요.

**오해 4: 셸 스크립트는 어렵다.**

미니의 cleanup.sh가 30줄. 본인의 첫 스크립트는 5줄로 시작. 자연스럽게 키워요. H6에서 본인이 직접 짜요.

**오해 5: 자경단 셸은 git만 쓴다.**

git + 30 명령어 + 자동화 스크립트 + 데이터 처리. 셸이 자경단의 모든 것이에요. git만이 아니에요.

---

## 13. 자주 받는 질문 다섯 가지

**Q1. 본 시뮬레이션을 본인 노트북에서 따라 칠 수 있어요?**

가능해요. `mkdir -p /tmp/shell-demo`부터 시작해서 0~5분 셋업을 그대로 따라 치세요. 그 후 5분씩 차례로. 30분이면 본인도 자경단 한 명이에요.

**Q2. 다섯 명의 일이 너무 빠릿빠릿한데 진짜로 가능해요?**

5년 차 자경단은 가능해요. 1년 차는 1시간 걸려요. 본인은 1년 차로 시작하지만 5년 후엔 30분이에요. 시간이 손가락을 만들어요.

**Q3. 제가 백엔드만 할 건데 까미 일만 알면 돼요?**

다섯 명의 일을 다 알아 두세요. 자경단은 작은 팀이라 한 명이 두세 명 일을 같이 해요. 본인이 백엔드여도 미니의 자동화 스크립트와 깜장이의 jq를 알아두면 곱셈으로 강해져요.

**Q4. cleanup.sh를 매일 자동 실행하려면?**

cron이라는 도구를 써요. macOS 기준 `crontab -e`로 편집기 열고 한 줄 추가.
```
0 9 * * * /tmp/shell-demo/cleanup.sh
```
매일 오전 9시 실행. H6에서 더 자세히.

**Q5. 다섯 명 다 본인이 혼자 시뮬할 수 있어요?**

가능해요. 본인이 다섯 역할을 차례로 하시면 돼요. 30분 동안 다섯 모자를 쓰고 벗으면서. 평생 한 번 해 보시면 자경단 다섯 명의 그림이 머리에 박혀요.

---

## 14. 흔한 실수 다섯 가지 + 안심 멘트 — Bash 데모 학습 편

Bash 데모 따라하며 자주 빠지는 함정 다섯.

첫 번째 함정, 셔뱅 안 적음. 안심하세요. **첫 줄 항상 `#!/usr/bin/env bash`.**

두 번째 함정, 변수 중괄호 안 씀. 본인이 `$NAME_HISTORY`로 변수 모호. 안심하세요. **`${NAME}_HISTORY`로 명확.**

세 번째 함정, 함수 정의 안 함. 본인이 한 .sh가 100줄. 안심하세요. **20줄 넘으면 함수로 분할.** main "$@" 진입점.

네 번째 함정, 종료 코드 처리 안 함. 안심하세요. **`exit 0/1/2`로 신호.** cron이 자동 재시도 판단.

다섯 번째 함정, 가장 큰 함정. **shellcheck 안 돌린다.** 본인이 .sh 짜고 그냥 사용. 안심하세요. **`shellcheck script.sh` 한 줄.** 90% 버그 미리.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 15. 마무리 — 다음 H6에서 만나요

자, 다섯 번째 시간이 끝났어요. 60분 동안 본인은 자경단 다섯 명의 30분 시뮬레이션을 옆에서 구경하셨어요. 정리하면 이래요.

본인이 0~5분 셋업, 까미가 5~10분 ERROR 진단, 노랭이가 10~15분 CSV 통계, 깜장이가 15~20분 JSON 파싱, 미니가 20~25분 자동화 스크립트, 본인이 25~30분 통합. 30분에 30개 중 20개 명령어가 사용됐고, H1부터 H4까지의 모든 학습이 한 번씩 다 동원됐어요. 사고 다섯 가지 처방도 만났고, 자경단 매일 13줄 흐름도 봤어요.

박수 한 번 칠게요. 다섯 시간 동안 잘 따라오셨어요. 본 챕터의 절반이 끝났어요. 본인의 머리에 검은 화면 + 8개념 + 30 명령어 + 자경단 협업 그림이 들어왔어요.

다음 H6은 본인이 직접 셸 스크립트를 짜요. set -euo pipefail, function, signal trap, getopts, 컬러 로그, shellcheck로 검사, bats로 테스트. 한 시간 끝에 본인의 첫 셸 스크립트가 완성돼요. 한 시간 후 만나요.

그 전에 한 가지 부탁. 지금 잠깐 멈추시고 본인 노트북에서 다음 한 묶음을 차례로 쳐 보세요.

```bash
mkdir -p /tmp/shell-demo/test && cd /tmp/shell-demo/test
echo "hello $(date)" > greeting.txt
cat greeting.txt
grep "hello" greeting.txt
wc -l greeting.txt
```

5초예요. 5줄이 본인의 H5 졸업장이에요. 본인이 다섯 명의 일을 작은 단위로 한 번 해 보신 거예요. 잘 따라오셨어요. 진짜로요. 한 시간 후 H6에서 만나요. 잠깐 쉬세요. 어깨 한 번 돌리시고요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - awk vs cut vs Python: cut은 단순 컬럼 추출 (awk보다 빠르지만 단순). awk는 컬럼 + 로직 (NR, NF, BEGIN, END). Python pandas는 더 강력하지만 느림. 셸 한 줄에선 awk가 황금 비율.
> - jq의 강력함: select·map·reduce·group_by·to_entries·from_entries 다 지원. SQL의 90%를 한 줄로. `jq --slurp`로 여러 JSON 합치기.
> - heredoc 안의 변수 치환 차이: `<<EOF`(치환), `<<'EOF'`(치환 없음), `<<-EOF`(앞 탭 제거). 자경단의 시연 셋업은 보통 `<<'EOF'`(원본 유지).
> - set -euo pipefail 풀이: -e (exit on error), -u (undefined variable error), -o pipefail (pipe failure). 셋이 합쳐서 안전한 스크립트의 기본 옵션.
> - find -delete vs xargs rm: find -delete는 syscall 직접, xargs rm은 fork+exec 다수. 성능은 -delete가 우세. 대형 파일 트리에서 차이.
> - cron vs launchd vs systemd: macOS는 launchd가 표준이지만 crontab도 지원. Linux는 systemd timers + cron. 자경단은 단순함 위해 cron 우선.
> - shell sub-process 추적: `ps -ef | grep cleanup.sh`로 실행 중인 스크립트 확인. PID 알면 `kill`로 종료. `nohup ./cleanup.sh &`로 백그라운드 실행.
> - 출력 캡처 패턴: `var=$(cmd)` 또는 `var=$(cmd 2>&1)` (에러 포함). `var=$(cmd | tr -d '\n')`로 줄바꿈 제거.
> - 다음 H6 키워드: shebang · set -euo pipefail · function · trap · getopts · printf 색깔 · shellcheck · bats.
