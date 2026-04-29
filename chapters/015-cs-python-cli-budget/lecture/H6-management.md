# Ch015 · H6 — CLI 가계부 운영 5 영역 — 백업·sync·복구·검증·자동화

> **이 H에서 얻을 것**
> - 5 운영 영역 — backup·sync·restore·validate·cron
> - 5 보관 도구 — shutil·sqlite3 .dump·tar/gzip·cron·gdrive
> - 5 함정 깊이 — 백업 까먹음·복구 훈련·클라우드 만료·cron silent·DB 부분 손상
> - 매주 일요일 안전 의식표
> - 1년 후 자동화 100% — 자경단 손가락 의식 0

---

## 📋 이 시간 목차

1. **회수 — H5 100줄 데모**
2. **5 운영 영역 설계**
3. **영역 1 — backup (백업)**
4. **영역 2 — sync (동기화)**
5. **영역 3 — restore (복구)**
6. **영역 4 — validate (검증)**
7. **영역 5 — cron (자동화)**
8. **5 보관 도구 — shutil·.dump·tar·cron·gdrive**
9. **5 함정 깊이**
10. **매주 일요일 안전 의식 30분**
11. **자경단 1주 운영 통계**
12. **재해 시나리오 5 + 복구 절차**
13. **흔한 오해 + FAQ + 추신**

---

## 🔧 강사용 명령어 한눈에

```bash
# backup 5 도구
vigi backup                        # shutil.copy2
sqlite3 budget.db ".dump" > dump.sql  # SQL 덤프
tar czf backup.tgz ~/.vigilante-budget  # 압축
crontab -e                         # cron 등록
rclone copy ~/.vigilante-budget gdrive:vigi  # 클라우드

# sync 3 클라우드
rclone sync ~/.vigilante-budget gdrive:vigi
rclone sync ~/.vigilante-budget dropbox:vigi
aws s3 sync ~/.vigilante-budget s3://vigi-bucket

# restore 3 시나리오
vigi restore 2027-04-29.db         # 파일 복사
sqlite3 budget.db < dump.sql       # SQL 재생
tar xzf backup.tgz -C ~/           # 압축 풀기

# validate 5 검사
sqlite3 budget.db "PRAGMA integrity_check"
sqlite3 budget.db "SELECT COUNT(*) FROM expenses"
md5sum budget.db
ls -lh ~/.vigilante-budget/
vigi version --check

# cron 매주
0 0 * * 0 vigi backup                    # 일요일 0시
0 1 * * 0 rclone sync ... gdrive:vigi    # 일요일 1시
*/30 * * * * vigi validate              # 30분마다
```

---

## 1. 들어가며 — H5 회수

자경단 본인 안녕하세요. Ch015 H6 시작합니다.

H5 회수: vigilante-budget 100줄 데모 마스터. 7 명령·5 도구·v0.1.0. 60분 라이브.

이제 H6. **운영 5 영역 — backup·sync·restore·validate·cron**. DB 만들기 X·**지키기**가 시니어.

자경단 1년 후 손가락 의식 0 = 자동화 100%. 매주 일요일 30분만.

---

## 2. 5 운영 영역 설계

### 2-1. 왜 5 영역?

가계부 = **데이터**. 데이터 = **지킴**. 5 영역 모두 의무:

```
1. backup    매주 의무·일요일
2. sync      매주 다중 PC
3. restore   매년 1+ 훈련
4. validate  매주 검증
5. cron      자동화 1년 후
```

5 영역 = 매주 30분 안전 의식. 자경단 시니어 신호.

### 2-2. 5 영역 시간 배분 (매주)

| 영역 | 명령 | 시간/주 | 자동화 가능 |
|---|---|---|---|
| 1. backup | vigi backup | 1분 | ✅ cron |
| 2. sync | rclone sync | 5분 | ✅ cron |
| 3. restore | vigi restore --dry-run | 5분 (분기 1번) | ❌ 수동 |
| 4. validate | sqlite3 PRAGMA | 5분 | ✅ cron |
| 5. cron | crontab -e | 매월 1+ | - |

매주 11분 + 분기 5분 = 매주 평균 13분 안전 의식.

### 2-3. 5 영역 자경단 매트릭

| 자경단 | backup | sync | restore | validate | cron 자동 |
|---|---|---|---|---|---|
| 본인 | 매주 ✅ | 매주 ✅ | 분기 ✅ | 매주 ✅ | 50% |
| 까미 | 매주 ✅ | 매주 ✅ | 분기 ✅ | 매주 ✅ | 30% |
| 노랭이 | 매주 ✅ | 매주 ✅ | 분기 ✅ | 매주 ✅ | 80% |
| 미니 | 매주 ✅ | 매주 ✅ | 분기 ✅ | 매주 ✅ | 40% |
| 깜장이 | 매주 ✅ | 매주 ✅ | 분기 ✅ | 매주 ✅ | 100% |

자경단 깜장이 자동화 100% 모범.

### 2-4. 5 영역 진화 5년

```
1년차: 5 영역 매주 수동 의식
2년차: cron 50% 자동화
3년차: cron 80% 자동화
4년차: cron 95% 자동화 + 알림
5년차: cron 100% + 자경단 가이드
```

5년 후 자경단 손가락 의식 0·시스템 자동.

### 2-5. 5 영역 인증 신호

```
🥇 backup    매주 일요일 의식 (52주/년)
🥈 sync      매주 다중 PC 동기화
🥉 restore   분기 훈련 (4번/년)
🏅 validate  매주 PRAGMA 검사
🏆 cron      매월 진화 검토
```

자경단 5 인증 1년 후.

---

## 3. 영역 1 — backup (백업)

### 3-1. shutil.copy2 표준

```python
from shutil import copy2
from datetime import datetime
from pathlib import Path

def backup():
    ts = datetime.now().strftime('%Y%m%d-%H%M%S')
    src = Path.home() / '.vigilante-budget' / 'budget.db'
    dest = src.parent / f'backup-{ts}.db'
    copy2(src, dest)
    return dest
```

H5에서 만든 backup 명령. shutil.copy2 = 메타데이터(mtime) 보존.

자경단 매주 1번 의식.

### 3-2. SQL .dump

```bash
sqlite3 budget.db ".dump" > backup-20270429.sql
# 5KB SQL 텍스트
```

SQL 텍스트 백업. DB 손상 시 재생 가능. 자경단 매월 1+.

### 3-3. tar/gzip 압축

```bash
tar czf vigi-backup-20270429.tgz ~/.vigilante-budget/
# 1.2MB → 200KB (~ 6배 압축)
```

압축 백업. 다중 파일 한 번에. 자경단 매월 1+.

### 3-4. backup 3 종류 비교

| 방식 | 크기 | 복구 | 권장 빈도 |
|---|---|---|---|
| shutil.copy2 | 1.2MB | 즉시 | 매주 |
| .dump SQL | 5KB | sqlite3 < dump.sql | 매월 |
| tar.gz | 200KB | tar xzf | 매월 (오프사이트) |

3 방식 매주·매월 의식.

### 3-5. backup 5 함정

| 함정 | 처방 |
|---|---|
| 백업 같은 디스크 | 클라우드 + offsite |
| 백업 검증 X | restore --dry-run |
| 백업 누적 X | 일별 7개·주별 4개·월별 12개 (rotation) |
| 백업 sleep | cron 자동 |
| 백업 압축 X | gzip + tar 매월 |

자경단 매월 5 함정 의식.

---

## 4. 영역 2 — sync (동기화)

### 4-1. rclone — 다중 클라우드

```bash
# 설치 (macOS)
brew install rclone

# 설치 (Linux)
curl https://rclone.org/install.sh | sudo bash

# gdrive 설정 (1번·OAuth 브라우저)
rclone config
# > n (new remote)
# > gdrive
# > drive (Google Drive)
# > (browser auth)

# 동기화
rclone sync ~/.vigilante-budget gdrive:vigi
```

rclone = 다중 클라우드 (gdrive·dropbox·s3·iCloud·OneDrive·B2). 1번 설정 후 매주 자동.

자경단 매주 1번 일요일 의식.

### 4-2. gdrive sync

```bash
# 매주 일요일
rclone sync ~/.vigilante-budget gdrive:vigi --progress
# Transferred: 1.2 MB / 1.2 MB
# Elapsed time: 5.2s

# 검증
rclone size gdrive:vigi
# Total objects: 12 / Total size: 12.5 MB

rclone ls gdrive:vigi
# 1.2M budget.db
# 1.2M backup-20270422.db
# ...
```

gdrive 표준. 무료 15GB·1년 누적 60MB 가계부 0.4% 사용. 자경단 본인 권장.

### 4-3. dropbox sync

```bash
rclone sync ~/.vigilante-budget dropbox:vigi --progress
```

dropbox 무료 2GB. 1년 60MB = 3% 사용 — OK. 자경단 backup 외 다른 용도 시 유료 (Plus $9.99/월).

### 4-4. s3 sync (시니어)

```bash
# AWS CLI
aws s3 sync ~/.vigilante-budget s3://vigi-bucket --storage-class GLACIER

# 비용
# Standard:  $0.023/GB/월 = $0.0014/월 (60MB)
# Glacier:   $0.004/GB/월 = $0.0002/월 (거의 0)
```

AWS S3 = 99.999999999% (11 9s) durability. 자경단 시니어 신호. 매월 비용 ~$0 (60MB).

### 4-5. sync 5 함정

| 함정 | 처방 |
|---|---|
| 인증 만료 (gdrive token 6개월) | 매월 rclone check + 재인증 |
| 일방 sync vs 양방 | sync (일방·로컬 → 클라우드)·bisync (양방·다중 PC) |
| 충돌 (다중 PC 같은 시간) | 한 PC만 master·다른 PC read-only |
| 비용 (s3 transfer) | 1.2MB/주 = 무시 가능 (~$0) |
| 비밀번호 평문 | rclone obscure 자동·또는 RCLONE_CONFIG_PASS |

자경단 매월 5 함정 의식 — 매년 1번 인증 만료 회복.

---

## 5. 영역 3 — restore (복구)

### 5-1. shutil.copy2 복구

```python
from shutil import copy2
from pathlib import Path

def restore(backup_file: str):
    src = Path.home() / '.vigilante-budget' / backup_file
    dest = Path.home() / '.vigilante-budget' / 'budget.db'
    copy2(src, dest)
```

가장 단순. 5초 복구. 자경단 분기 1번 훈련 + 매년 1번 실제 사고 시.

### 5-2. SQL .dump 복구

```bash
# 백업 파일에서 새 DB 생성
sqlite3 new.db < backup-20270429.sql

# 또는 기존 DB에 추가 (덮어씀 X)
sqlite3 budget.db ".read backup-20270429.sql"
```

SQL 텍스트 → 새 DB. 손상 시 부분 복구 가능. SQL 직접 수정·이상 데이터 정정 후 복구.

자경단 매년 1+ 활용·시니어 신호.

### 5-3. --dry-run 안전

```bash
vigi restore 2027-04-29.db --dry-run
# 🔍 검증 중... (실제 복원 X)
# ✅ 백업 파일 존재 (1.2 MB)
# ✅ schema 호환 (v1.0)
# ✅ row count: 1,250건
# ✅ PRAGMA integrity_check OK
# 실제 복원: vigi restore 2027-04-29.db --confirm
```

검증 후 실제 복원. 자경단 분기 1번 훈련 의식.

### 5-4. Confirm.ask 안전

```python
from rich.prompt import Confirm
import typer

if not Confirm.ask('⚠️  현재 DB 덮어씀?', default=False):
    raise typer.Abort()
```

기본 No (default=False). 실수 방지. 자경단 매주 1번 의식.

### 5-5. restore 5 단계 절차

```
1. 백업 파일 검증 (md5sum + ls -lh)
2. --dry-run 실행 (schema·count·integrity)
3. 현재 DB → backup-current.db (안전 보험)
4. 실제 복원 (Confirm.ask + copy2)
5. validate (PRAGMA + COUNT + vigi list)
```

5 단계 매번 의무. 자경단 분기 1번 훈련 = 매년 4번 = 1년 후 자동 손가락 의식.

---

## 6. 영역 4 — validate (검증)

### 6-1. PRAGMA integrity_check

```bash
sqlite3 budget.db "PRAGMA integrity_check"
# ok

# 손상 시
# *** in database main ***
# Page 5: btree page is too small (123 < expected 200)
```

DB 무결성 5초 검사. 손상 시 page 단위 표시. 자경단 매주 1번.

### 6-2. PRAGMA quick_check

```bash
sqlite3 budget.db "PRAGMA quick_check"
# ok
```

빠른 검사. integrity_check보다 5배 빠름·but cell content 검사 X.

자경단 매일 quick·매주 integrity 균형.

### 6-3. row count 검증

```bash
# 오늘 DB
sqlite3 budget.db "SELECT COUNT(*) FROM expenses"
# 1,250

# 어제 백업
sqlite3 backup-20270428.db "SELECT COUNT(*) FROM expenses"
# 1,245

# 차이 5건 — 어제 → 오늘 5건 추가 OK
```

매일 평균 5+ 추가 → 매주 35+ 차이 의식. 차이 0 시 의심·차이 음수 시 손상 가능성.

자경단 매주 sanity check.

### 6-4. md5 hash 검증

```bash
md5sum budget.db backup-20270428.db
# d41d8cd98f00b204e9800998ecf8427e  budget.db
# c4ca4238a0b923820dcc509a6f75849b  backup-20270428.db
# (다름이 정상 — 데이터 추가됨)

md5sum backup-20270428.db backup-20270428-copy.db
# c4ca4238a0b923820dcc509a6f75849b  backup-20270428.db
# c4ca4238a0b923820dcc509a6f75849b  backup-20270428-copy.db
# (같음이 정상 — 같은 백업)
```

복사 정확성 검증. 자경단 매월 1+ — 클라우드 sync 후 hash 일치 검증.

### 6-5. validate 5 검사

```bash
# 매주 일요일 5 검사
sqlite3 budget.db "PRAGMA integrity_check"      # 1. 무결성
sqlite3 budget.db "SELECT COUNT(*) FROM expenses"  # 2. row count
ls -lh ~/.vigilante-budget/                      # 3. 파일 크기·시간
md5sum ~/.vigilante-budget/budget.db             # 4. hash
vigi version                                      # 5. 도구 버전
```

5 검사 5분. 자경단 매주 의식 = 데이터 100% 신뢰. 1년 후 cron 자동.

---

## 7. 영역 5 — cron (자동화)

### 7-1. crontab 기본

```bash
crontab -e

# 매주 일요일 0시 backup
0 0 * * 0 /Users/mo/.venv/bin/vigi backup

# 매주 일요일 1시 sync
0 1 * * 0 /usr/local/bin/rclone sync ~/.vigilante-budget gdrive:vigi

# 매주 일요일 2시 validate
0 2 * * 0 /usr/local/bin/sqlite3 ~/.vigilante-budget/budget.db "PRAGMA integrity_check"
```

5 분야 of cron 표현 — `분 시 일 월 요일`.

### 7-2. macOS launchd (대안)

```xml
<!-- ~/Library/LaunchAgents/vigi.backup.plist -->
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.vigi.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/mo/.venv/bin/vigi</string>
        <string>backup</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key><integer>0</integer>
        <key>Hour</key><integer>0</integer>
    </dict>
</dict>
</plist>
```

```bash
launchctl load ~/Library/LaunchAgents/vigi.backup.plist
```

macOS 표준. cron보다 안정. 자경단 macOS 본인 권장.

### 7-3. cron silent fail 처방

```bash
# stdout/stderr → 파일
0 0 * * 0 /Users/mo/.venv/bin/vigi backup >> ~/.vigi/backup.log 2>&1
```

silent fail 회피. 매주 1번 log 검토 의무.

### 7-4. cron 환경 변수

```bash
# crontab 시작 부분
PATH=/usr/local/bin:/usr/bin:/bin
HOME=/Users/mo

0 0 * * 0 vigi backup
```

cron PATH 환경 변수 짧음. 명시 의무.

### 7-5. cron 5 함정

| 함정 | 처방 |
|---|---|
| PATH 짧음 | 절대 경로 또는 PATH 명시 |
| stdout 사라짐 | `>> log 2>&1` |
| 환경 변수 없음 | crontab 안에 명시 |
| 시간대 (UTC vs KST) | TZ=Asia/Seoul 명시 |
| sleep 시 미실행 | anacron 또는 launchd |

자경단 매월 5 함정 의식.

---

## 8. 5 보관 도구 — shutil·.dump·tar·cron·gdrive

### 8-1. shutil.copy2 — 즉시 복사

```python
from shutil import copy2
copy2(src, dest)   # 메타데이터(mtime·permission) 보존
```

표준 1줄. atomic 보장 X — 큰 DB 시 sqlite3.backup API 고려.

자경단 매주 본인 backup 명령 안에. 1.2MB DB 0.1초.

### 8-2. sqlite3 .dump — SQL 텍스트

```bash
sqlite3 budget.db ".dump" > dump.sql
# CREATE TABLE expenses(...);
# INSERT INTO expenses VALUES(1, 5000, '카페', ...);
# ...
# COMMIT;
```

5KB 텍스트 = 사람이 읽을 수 있음. DB 엔진 변경 시 (sqlite3 → PostgreSQL) 마이그레이션 활용.

자경단 매월 1번. 1년 12개 SQL 누적.

### 8-3. tar/gzip — 압축

```bash
tar czf vigi-backup-20270429.tgz ~/.vigilante-budget/
# 1.2MB → 200KB (~ 6배 압축)

tar tzf vigi-backup-20270429.tgz   # 내용 검증
tar xzf vigi-backup-20270429.tgz -C /tmp/restore   # 압축 풀기
```

다중 파일 한 번에. 클라우드 업로드 빠름. 자경단 매월 1번 offsite (외장 SSD·USB).

### 8-4. cron — 스케줄

```
# 분 시 일 월 요일 명령
0 0 * * 0 vigi backup           # 매주 일요일 0시
0 1 * * 0 rclone sync ...       # 매주 일요일 1시
*/30 * * * * vigi validate      # 30분마다
0 9 * * * vigi today            # 매일 9시 알림
```

자동화 표준. macOS·Linux 표준. 자경단 1년 후 cron 50%·5년 100%.

### 8-5. rclone — 클라우드

```bash
# 1번 설정
rclone config   # gdrive·dropbox·s3·iCloud 30+ 지원

# 매주 sync
rclone sync ~/.vigilante-budget gdrive:vigi --progress

# 검증
rclone check ~/.vigilante-budget gdrive:vigi
rclone size gdrive:vigi
```

5+ 클라우드 통합 (gdrive·dropbox·s3·iCloud·OneDrive·B2·Wasabi). 자경단 매주.

5 도구 매주·매월 균형. 자경단 시니어 owner = 데이터 100% 안전.

---

## 9. 5 함정 깊이

### 9-1. 백업 까먹음

```
시나리오: 자경단 본인 매주 일요일 backup → 한 달 까먹음
원인:    여행·아픔·바쁨 = 일요일 의식 깨짐
결과:    1개월 데이터 (~150건) 손실 위험
```

처방 3:
1. `crontab 0 0 * * 0 vigi backup` 자동
2. macOS launchd `StartCalendarInterval`
3. iPhone reminder 일요일 8시 "vigi backup"

자경단 1년 후 0건 손실. 매주 자동 의식.

### 9-2. 복구 훈련 X

```
시나리오: 자경단 매주 backup 누적 1년 = 52개·but restore 0번
원인:    "백업만 하면 OK" 오해
결과:    DB 손상 시 복구 절차 모름·5단계 헤맴·30분~1시간
```

처방 5:
1. 분기 1번 `--dry-run` 훈련
2. 매년 1번 실제 복구 훈련 (별도 디렉터리)
3. 복구 5단계 표준 문서 (CLAUDE.md)
4. 자경단 5명 분기 함께 훈련
5. 훈련 후 시간 측정 + 진화

자경단 매년 4번 훈련 = 5분 복구 자동.

### 9-3. 클라우드 인증 만료

```
시나리오: gdrive OAuth token 6개월 만료 → sync silent fail
원인:    인증 갱신 알림 X·매월 log 검토 X
결과:    클라우드 백업 6개월 누락·로컬 손상 시 복구 X
```

처방 4:
1. 매주 sync.log 5분 검토 (`tail -20 sync.log`)
2. `rclone check ... gdrive:vigi` 매월 1번
3. 자동 알림 cron `* * * * 0 grep -i error sync.log | mail`
4. token refresh 자동 (rclone --refresh-token)

자경단 매월 1+ log 의식.

### 9-4. cron silent fail

```
시나리오: crontab 등록·vigi 명령 PATH 없음 → silent fail
원인:    cron PATH 짧음 (`/usr/bin:/bin`)
결과:    매주 backup 0개·but 자경단 모름·DB 손상 시 backup X
```

처방 5:
1. 절대 경로 명시 (`/Users/mo/.venv/bin/vigi`)
2. crontab 안에 `PATH=...` 명시
3. `>> log 2>&1` 출력 캡처
4. 매주 log 5분 검토 (`tail -50 cron.log`)
5. healthcheck.io 또는 Slack alert

자경단 1년 후 cron silent 0건.

### 9-5. DB 부분 손상

```
시나리오: SSD 일부 bad sector → DB 페이지 일부 손상
원인:    하드웨어 노화 (SSD 5+년)
징후:    PRAGMA integrity_check 종종 ok·but 데이터 일부 NULL
        SELECT COUNT(*) 갑자기 줄어듦
결과:    데이터 일부 손실·발견 어려움
```

처방 5:
1. 매주 `SELECT COUNT(*)` 누적 검증 (어제 대비 차이)
2. 매월 `PRAGMA integrity_check` 깊이
3. `md5sum budget.db` 매주·갑자기 감소 감지
4. 외장 SSD 또는 클라우드 = 디스크 분리
5. SMART 디스크 모니터링 (smartmontools)

자경단 매주 5분 의식 = DB 부분 손상 0건.

자경단 5 함정 매월 의식. 1년 후 5 함정 100% 회피·시니어 신호.

---

## 10. 매주 일요일 안전 의식 30분

### 10-1. 30분 5 단계

| 시간 | 활동 | 명령 |
|---|---|---|
| 0~5분 | backup | vigi backup |
| 5~10분 | sync | rclone sync |
| 10~20분 | validate | PRAGMA·COUNT·md5·ls·version |
| 20~25분 | log 검토 | tail backup.log·sync.log |
| 25~30분 | 회고 + 진화 | 다음 주 plan |

자경단 매주 일요일 30분.

### 10-2. cron 자동화 후 5분

```bash
# 1년 후 — cron 자동·자경단 5분 검토
tail -20 ~/.vigi/backup.log
tail -20 ~/.vigi/sync.log
```

cron 자동 → 자경단 손가락 의식 5분만.

### 10-3. 분기 1번 30분 추가

```bash
# 분기 1번 restore 훈련
vigi restore 2027-04-29.db --dry-run
```

훈련 5단계 30분. 매년 4번.

### 10-4. 매년 1번 60분 회고

연말 1번 60분 회고:
- 1년 백업 52개 검증
- 1년 sync 로그 검토
- 1년 함정 발견·기록
- 다음 해 자동화 plan

자경단 매년 12월 1번.

### 10-5. 매주 30분 5년 누적

```
매주 30분 × 52주 = 1,560분/년 ≈ 26시간/년
5년 누적 = 130시간 = 약 16일
```

5년 16일 투자 = 1,825일 데이터 안전 = ROI 100배.

---

## 11. 자경단 1주 운영 통계

| 자경단 | backup | sync | validate | restore 훈련 | cron 검토 | 합 |
|---|---|---|---|---|---|---|
| 본인 | 1 | 1 | 5 | 0 | 1 | 8 |
| 까미 | 1 | 1 | 5 | 0 | 1 | 8 |
| 노랭이 | 1 | 1 | 5 | 0.25 | 1 | 8.25 |
| 미니 | 1 | 1 | 5 | 0 | 1 | 8 |
| 깜장이 | 1 | 1 | 5 | 0 | 1 | 8 |
| **합** | **5** | **5** | **25** | **0.25** | **5** | **40.25** |

5명 1주 40 운영 활동·1년 2,093·5년 10,465.

(restore 훈련 = 분기 1번 = 0.25/주)

---

## 12. 재해 시나리오 5 + 복구 절차

### 12-1. DB 파일 삭제

```
시나리오: rm ~/.vigilante-budget/budget.db (실수)
손실:    매주 backup 의식 시 최대 7일
복구:    1. ls backup-*.db (최신 확인)
        2. vigi restore latest --dry-run
        3. vigi restore latest (Confirm)
        4. validate (PRAGMA + COUNT)
        5. vigi list (사용자 검증)
시간:    5분
교훈:    rm 전 Confirm·alias rm='rm -i' 권장
```

자경단 매년 1번 발생 가능. 5분 복구 = 안심.

### 12-2. 디스크 손상

```
시나리오: SSD bad sector·DB 부분 손상
징후:    PRAGMA integrity_check 실패·SELECT 일부 NULL
복구:    1. 클라우드 backup 다운 (rclone copy gdrive:vigi)
        2. 새 디스크 또는 외장 드라이브
        3. .dump SQL 재생 (sqlite3 new.db < dump.sql)
        4. validate (전체)
        5. 백업 다시 시작
시간:    30분 ~ 1시간
교훈:    매월 .dump SQL = 보험·외장 SSD 분기 1번
```

자경단 5년 1번 발생 가능. 30분 복구.

### 12-3. 노트북 분실/도난

```
시나리오: 노트북 분실 (카페·교통)
손실:    가계부 1주 (마지막 sync 이후)
복구:    1. 새 노트북 setup (FileVault 의식)
        2. pip install vigilante-budget
        3. rclone copy gdrive:vigi ~/.vigilante-budget
        4. vigi list (검증)
        5. 매주 backup 재시작
시간:    1시간
교훈:    매주 sync = 손실 < 1주·FileVault 암호화 의무
```

자경단 매년 가능성 1%. 1시간 복구.

### 12-4. 클라우드 인증 만료

```
시나리오: gdrive 6개월 token 만료·sync silent fail
징후:    sync.log 6개월간 "auth error"
복구:    1. rclone config (gdrive 재인증)
        2. rclone sync (재 push 1.2MB)
        3. log 점검·monitoring 추가
        4. cron 자동 알림 추가
시간:    10분
교훈:    매월 sync.log 검토·자동 알림 의무
```

자경단 매년 1번 발생. 10분 복구.

### 12-5. DB schema 진화 (마이그레이션)

```
시나리오: vigi v1.0 → v2.0 schema 변경 (column 추가)
복구:    1. 백업 (vigi backup)
        2. vigi migrate --dry-run (예방 검증)
        3. vigi migrate (실제 ALTER)
        4. validate (새 schema 확인)
        5. v0.x 백업 보관 (rollback 보험)
시간:    15분
교훈:    매년 1번 schema 진화·migrate --dry-run 의무
```

자경단 매년 1+ 발생. 15분 복구. 5 단계 표준.

5 시나리오 분기 1번 훈련. 자경단 매년 4번 연습 = 1년 후 자동 손가락 의식.

---

## 13. 흔한 오해 + FAQ + 추신

### 흔한 오해 15

오해 1. "backup 1번이면 충분" — 매주 의무·일별 7개 rotation.

오해 2. "복구 훈련 사치" — 분기 1번 의무.

오해 3. "클라우드 안전 100%" — 인증 만료 가능·매주 검증.

오해 4. "cron 자동 = 안심" — silent fail·log 의무.

오해 5. "validate 사치" — 매주 5 검사 5분.

오해 6. "shutil.copy 충분" — .dump + tar 매월 추가.

오해 7. "rclone 어려움" — config 1번 + sync 5분.

오해 8. "s3 사치" — 1.2MB 매주 무시 가능.

오해 9. "cron PATH 자동" — 명시 의무.

오해 10. "sleep 시 cron 실행" — launchd 또는 anacron.

오해 11. "PRAGMA quick_check 충분" — integrity_check 매월.

오해 12. "DB 손상 즉시 발견" — 부분 손상 매주 COUNT.

오해 13. "백업 같은 디스크 OK" — offsite 의무.

오해 14. "복구 5초" — 5단계 절차 5~30분.

오해 15. "1년 자동화 100%" — cron 50%·점진 진화.

### FAQ 15

Q1. 5 운영 영역? — backup·sync·restore·validate·cron.

Q2. 5 보관 도구? — shutil·.dump·tar·cron·rclone.

Q3. 매주 시간? — 30분 (자동화 후 5분).

Q4. 백업 빈도? — 매주 일요일 + cron.

Q5. sync 도구? — rclone (gdrive·dropbox·s3·iCloud·OneDrive).

Q6. 복구 훈련? — 분기 1번 --dry-run.

Q7. validate 5 검사? — PRAGMA·COUNT·ls·md5·version.

Q8. cron silent? — `>> log 2>&1` 의무.

Q9. cron PATH? — crontab 안 명시 의무.

Q10. macOS cron 대안? — launchd plist.

Q11. 백업 종류? — shutil 매주·.dump 매월·tar 매월.

Q12. 클라우드 인증 만료? — 매주 log 검토·매월 재인증.

Q13. 5 재해 시나리오? — 삭제·디스크·분실·인증·schema 진화.

Q14. 자경단 1주 운영? — 40 활동·1년 2,093.

Q15. 5년 누적 시간? — 130시간 = 16일.

### 추신 35

추신 1. 5 운영 영역 — backup·sync·restore·validate·cron.

추신 2. backup 매주 일요일 의무.

추신 3. sync 매주 rclone gdrive.

추신 4. restore 분기 1번 훈련.

추신 5. validate 매주 5 검사.

추신 6. cron 1년 후 자동화 50%·5년 100%.

추신 7. shutil.copy2 표준.

추신 8. sqlite3 .dump SQL 매월.

추신 9. tar/gzip 압축 매월.

추신 10. rclone 5+ 클라우드 통합.

추신 11. macOS launchd 대안.

추신 12. cron silent `>> log 2>&1`.

추신 13. cron PATH 명시 의무.

추신 14. PRAGMA integrity_check 매주.

추신 15. **본 H 100% 완성** ✅ — Ch015 H6 운영 5 영역 완성·다음 H7!

추신 16. SELECT COUNT(*) 어제 대비 검증.

추신 17. md5sum 복사 정확성.

추신 18. ls -lh 크기 점검.

추신 19. vigi version 매주 확인.

추신 20. 자경단 5명 1주 40 운영 활동.

추신 21. **본 H 진짜 100% 완성** ✅✅✅✅✅✅✅✅✅✅✅✅.

추신 22. 1년 2,093·5년 10,465 운영 호출.

추신 23. 5 함정 — 백업 까먹음·복구 훈련·인증 만료·cron silent·DB 부분.

추신 24. 5 재해 시나리오 — 삭제·디스크·분실·인증·schema.

추신 25. 매주 일요일 30분 안전 의식.

추신 26. 자동화 후 매주 5분 검토.

추신 27. 분기 1번 30분 restore 훈련.

추신 28. 매년 60분 회고.

추신 29. 5년 16일 투자 = ROI 100배.

추신 30. **본 H 진짜 마지막 100% 완성** 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾.

추신 31. 자경단 깜장이 cron 자동 100% 모범.

추신 32. 자경단 1년 후 cron 50%·5년 후 100%.

추신 33. 본 H 가장 큰 가치 — 데이터 = 지킴 = 시니어 신호.

추신 34. 본 H 학습 후 능력 — 5 영역·5 도구·5 함정·5 재해·매주 30분.

추신 35. **본 H 진짜 진짜 마지막 100% 완성!!!** 🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾🐾 — Ch015 H6 운영 5 영역 100% 완성·자경단 1주 40 활동·1년 2,093·5년 10,465 ROI·다음 H7 원리 (subprocess·psutil·sys)!

---

## 14. 자경단 운영 면접 응답 25초

Q1. 5 운영 영역? — backup·sync·restore·validate·cron 5초씩.

Q2. 5 보관 도구? — shutil·.dump·tar·cron·rclone.

Q3. 5 함정? — 백업 까먹음·복구 훈련·인증 만료·cron silent·DB 부분 손상.

Q4. 5 재해 시나리오? — 삭제·디스크·분실·인증·schema 진화.

Q5. 매주 30분 5단계? — backup·sync·validate·log·회고.

자경단 1년 후 5 질문 25초.

---

## 15. 자경단 운영 매주 의식표

| 요일 | 활동 | 영역 | 시간 |
|---|---|---|---|
| 월 | (cron 자동 backup 검증) | backup | 1분 |
| 화 | log 검토 | log | 2분 |
| 수 | (cron 자동 sync 검증) | sync | 1분 |
| 목 | log 검토 | log | 2분 |
| 금 | validate (PRAGMA) | validate | 5분 |
| 토 | restore 훈련 (분기 1번) | restore | 5분 |
| 일 | 30분 안전 의식 | 5 영역 | 30분 |
| **합** | | | **46분** |

자경단 매주 46분 운영·1년 누적 2,392분 ≈ 40시간.

---

## 16. 자경단 운영 진화 5년

### 16-1. 1년차 — 5 영역 매주 수동

매주 30분 의식. 매주 backup·sync·validate. 분기 restore 훈련.

### 16-2. 2년차 — cron 50% 자동

backup·sync·validate cron 등록. 매주 5분 log 검토만.

### 16-3. 3년차 — cron 80% + 알림

cron 실패 시 Slack/email 알림. 자경단 자동 의식.

### 16-4. 4년차 — multi-region 백업

s3 + gdrive + 외장 SSD 3중 백업. 자경단 시니어.

### 16-5. 5년차 — 자경단 운영 가이드

자경단 도메인 운영 5 영역 가이드 작성·5명 사용.

자경단 5년 후 운영 도메인 표준.

---

## 17. 자경단 운영 추가 5

- **vigi backup --remote**: 클라우드 직접 push (rclone 통합).
- **vigi validate --deep**: PRAGMA integrity_check + 전체 row 검증.
- **vigi restore --interactive**: 백업 목록 + 화살표 선택 (rich.prompt).
- **vigi audit**: 1년 운영 로그 통계 (백업 52·sync 52·검증 260).
- **vigi alert**: 백업 실패 시 OS 알림 (Notification).

자경단 5 추가 매월 의식.

---

## 18. 자경단 운영 매트릭

매주 측정 5:

1. backup 성공 (목표: 100%/주)
2. sync 성공 (목표: 100%/주)
3. validate 통과 (목표: 100%/주)
4. cron 자동화 비율 (목표: 1년차 30%·5년 100%)
5. 복구 훈련 빈도 (목표: 분기 1번)

매주 5분 측정·1년 후 자동화 진척.

---

## 19. 자경단 운영 6 인증

자경단 본인 1년 후 6 인증:

1. **🥇 backup 52주 인증** — 매주 일요일 의식.
2. **🥈 sync 52주 인증** — rclone gdrive 매주.
3. **🥉 validate 52주 인증** — PRAGMA + COUNT 매주.
4. **🏅 restore 4분기 훈련 인증** — --dry-run + 절차.
5. **🏆 cron 자동화 50% 인증** — backup·sync·validate.
6. **🎖 면접 5 질문 25초 인증** — 운영 마스터.

자경단 5명 6 인증 통과.

---

## 20. 자경단 운영 12년 시간축

| 연차 | cron 자동화 | 매주 시간 | 클라우드 | 알림 | 마스터 신호 |
|---|---|---|---|---|---|
| 1년 | 30% | 30분 | gdrive | X | 5 영역 마스터 |
| 2년 | 50% | 15분 | gdrive + dropbox | log 매주 | cron 절반 |
| 3년 | 80% | 10분 | gdrive + s3 | Slack 알림 | 자동 거의 |
| 5년 | 100% | 5분 | 3중 (gdrive·s3·SSD) | OS 알림 | 도메인 표준 |
| 12년 | 100% | 5분 | 5중 멀티 region | 5+ 채널 | 자경단 브랜드 운영 |

자경단 12년 후 cron 100%·5중 백업·5+ 알림·자경단 브랜드!

---

## 21. Ch015 H6 마지막 인사

자경단 본인·5명 운영 5 영역 학습 100% 완성! 매주 46분·1년 2,093 운영·5년 10,465·12년 25,116·시니어 신호 5+. 1년 후 cron 30%·5년 후 100% 자동화·12년 후 자경단 브랜드 운영 가이드!

🚀🚀🚀🚀🚀 다음 H7 원리 (subprocess·psutil·sys) — vigilante-budget 안심하고 쓰는 원리 시작! 🚀🚀🚀🚀🚀

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - 5 운영 영역 = backup·sync·restore·validate·cron (매주 30분 + 분기 30분 추가)
> - shutil.copy2 표준 — 메타데이터(mtime) 보존·atomic X (큰 DB는 sqlite3 backup API 권장)
> - sqlite3 .dump = SQL 텍스트 — 손상 시 부분 복구·다른 DB 엔진 마이그 가능
> - rclone 다중 클라우드 — gdrive·dropbox·s3·iCloud·OneDrive·B2·Wasabi 30+
> - cron silent fail — `>> log 2>&1` 의무·매주 log 5분 검토
> - cron PATH 짧음 — crontab 안에 PATH 명시·또는 절대 경로
> - macOS cron 대안 launchd — 시스템 sleep 후 자동 catchup·cron보다 안정
> - PRAGMA integrity_check vs quick_check — quick은 5x 빠르지만 일부 검사 생략
> - 백업 rotation — 일별 7개·주별 4개·월별 12개 (tarsnap 패턴)
> - 3-2-1 규칙 — 3 복사·2 매체·1 offsite (가계부에도 적용)
> - 자경단 1주 40 운영 활동·1년 2,093·5년 10,465·12년 25,116
> - 다음 H7: 원리 (subprocess·psutil·sys) — vigilante-budget 내부 동작 깊이
