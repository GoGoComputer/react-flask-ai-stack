# Ch015 · H4 — 가계부 30+ 명령 카탈로그 — 6 그룹

> 고양이 자경단 · Ch 015 · 4교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 30+ 명령 한 표
3. CRUD 그룹 (add·list·edit·delete·get)
4. 통계 그룹 (sum·avg·top·trend·category)
5. 시각화 그룹 (chart·plot·report)
6. import/export 그룹
7. 백업/복구 그룹
8. 자경단 매일 13줄 흐름
9. 다섯 함정과 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 다섯 가지
12. 마무리

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요.

지난 H3 회수. typer, rich, sqlite3, plotext, dateutil.

이번 H4는 30+ 명령.

오늘의 약속. **본인이 매일 만날 가계부 명령을 그룹화**.

자, 가요.

---

## 2. 30+ 명령 한 표

| 그룹 | 명령 |
|------|------|
| CRUD | add, list, edit, delete, get, search |
| 통계 | sum, avg, top, trend, category, monthly |
| 시각화 | chart, plot, report, calendar |
| I/O | import, export, csv, json |
| 백업 | backup, restore, sync |
| 관리 | init, config, history, version |

30+.

---

## 3. CRUD 그룹

```bash
# add
vigilante-budget add 5000 food --note "점심"

# list
vigilante-budget list
vigilante-budget list --month 2026-04
vigilante-budget list --category food

# edit
vigilante-budget edit 42 --amount 6000

# delete
vigilante-budget delete 42

# get
vigilante-budget get 42

# search
vigilante-budget search "점심"
```

6 명령. 자경단 매일.

---

## 4. 통계 그룹

```bash
# sum
vigilante-budget sum --month 2026-04
# 합계: 21,000

# avg
vigilante-budget avg --category food
# 평균: 4,000

# top
vigilante-budget top 5
# 상위 5개

# trend
vigilante-budget trend --period 3months
# 3개월 추세

# category
vigilante-budget category
# food: 8,000 (40%)
# tax:  6,000 (30%)
# ...

# monthly
vigilante-budget monthly --year 2026
```

6 명령. 자경단 매주.

---

## 5. 시각화 그룹

```bash
# chart (bar)
vigilante-budget chart

# plot (line)
vigilante-budget plot --period month

# report (markdown)
vigilante-budget report > report.md

# calendar (heatmap)
vigilante-budget calendar
```

4 명령. 자경단 매월.

---

## 6. import/export 그룹

```bash
# CSV import
vigilante-budget import data.csv

# CSV export
vigilante-budget export csv > all.csv

# JSON
vigilante-budget export json > all.json

# excel (옵션)
vigilante-budget export xlsx --output budget.xlsx
```

4 명령. 자경단 가끔.

---

## 7. 백업/복구 그룹

```bash
# backup
vigilante-budget backup

# restore
vigilante-budget restore backup-2026-04-30.db

# sync (S3)
vigilante-budget sync --target s3://bucket/budget/
```

3 명령. 자경단 매주.

---

## 8. 자경단 매일 13줄 흐름

```bash
# 매일
vigilante-budget add 5000 food
vigilante-budget add 3000 transport
vigilante-budget list

# 매주
vigilante-budget summary
vigilante-budget chart
vigilante-budget backup

# 매월
vigilante-budget monthly --month 2026-04
vigilante-budget report > april.md
vigilante-budget category

# 매분기
vigilante-budget trend --period 3months
vigilante-budget export csv > q1.csv

# 백업
vigilante-budget sync
vigilante-budget backup
```

13줄.

---

## 9. 다섯 함정과 처방

**함정 1: 명령 너무 많음**

처방. 6 그룹으로 묶기.

**함정 2: 도움말 부족**

처방. typer help docstring.

**함정 3: 데이터 손실**

처방. add 후 자동 백업.

**함정 4: 날짜 형식 혼란**

처방. dateutil parser.

**함정 5: 카테고리 오타**

처방. enum 또는 검증.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 30 명령 다 만들기.**

핵심 6개부터.

**오해 2: 모든 명령 즉시.**

매일 사용 후 추가.

**오해 3: SQLite 한계.**

10만 entry까지.

**오해 4: 백업 옵션.**

자동 백업 표준.

**오해 5: chart 무거움.**

plotext 가벼움.

---

## 11. 자주 받는 질문 다섯 가지

**Q1. 6 그룹 다?**

CRUD 5개로 시작.

**Q2. 카테고리 enum?**

string도 OK. 자유 입력.

**Q3. SQL injection?**

? 매개변수 사용.

**Q4. 멀티 user?**

스키마에 user_id 추가.

**Q5. 동기화 충돌?**

last-write-wins 또는 timestamp.

---

## 12. 흔한 실수 다섯 + 안심 — 명령어 학습 편

첫째, 30 명령 다 만듦. 안심 — 핵심 6개부터.
둘째, 도움말 부족. 안심 — docstring 자동.
셋째, 백업 옵션. 안심 — add 후 자동.
넷째, SQL injection 두려움. 안심 — ? 매개변수.
다섯째, 가장 큰 — 카테고리 오타. 안심 — enum 또는 검증.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 13. 마무리

자, 네 번째 시간 끝.

30+ 명령, 6 그룹.

다음 H5는 100줄 데모.

```bash
vigilante-budget --help
```

---

## 👨‍💻 개발자 노트

> - typer subcommand: app.add_typer.
> - SQL parameterized: ? for sqlite, $1 for postgres.
> - SQLite full-text search: FTS5.
> - plotext bar/line/scatter.
> - cron 자동 백업: @daily.
> - 다음 H5 키워드: vigilante-budget · 100줄 · 6 단계 라이브.
