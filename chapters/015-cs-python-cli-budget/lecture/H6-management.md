# Ch015 · H6 — CLI 가계부 운영 — 백업·sync·복구·검증·자동화

> 고양이 자경단 · Ch 015 · 6교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속
2. 첫째 — 백업
3. 둘째 — sync (S3 또는 Git)
4. 셋째 — 복구
5. 넷째 — 데이터 검증
6. 다섯째 — cron 자동화
7. 자경단 매일 운영 의식
8. 다섯 함정과 처방
9. 흔한 오해 다섯 가지
10. 자주 받는 질문 다섯 가지
11. 마무리 — 1년차 종료

---

## 1. 다시 만나서 반가워요 — H5 회수와 오늘의 약속

자, 안녕하세요. 본 챕터의 마지막 큰 시간이에요. 1년차의 마지막 H6.

지난 H5 회수. vigilante-budget 100줄.

이번 H6은 운영. 백업, sync, 복구, 검증, 자동화.

오늘의 약속. **본인의 가계부가 5년 안전하게 운영됩니다**.

자, 가요.

---

## 2. 첫째 — 백업

```python
@app.command()
def backup():
    """DB 백업."""
    import shutil
    from datetime import datetime
    
    backup_dir = Path.home() / ".vigilante-budget-backups"
    backup_dir.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup_path = backup_dir / f"budget-{timestamp}.db"
    
    shutil.copy(DB_PATH, backup_path)
    print(f"[green]✅ 백업: {backup_path}[/green]")
    
    # 최근 30개만 유지
    backups = sorted(backup_dir.glob("budget-*.db"))
    for old in backups[:-30]:
        old.unlink()
```

자동 정리 + 백업.

---

## 3. 둘째 — sync (S3 또는 Git)

**S3 sync** (자경단 미니).

```python
@app.command()
def sync_s3(bucket: str):
    """S3 동기화."""
    import boto3
    
    s3 = boto3.client("s3")
    s3.upload_file(str(DB_PATH), bucket, "budget.db")
    print(f"[green]✅ S3 sync 완료[/green]")
```

**Git sync** (간단).

```python
@app.command()
def sync_git():
    """Git 저장소로 동기화."""
    import subprocess
    
    repo = Path.home() / "budget-data"
    if not repo.exists():
        repo.mkdir()
        subprocess.run(["git", "init"], cwd=repo, check=True)
    
    shutil.copy(DB_PATH, repo / "budget.db")
    
    subprocess.run(["git", "add", "budget.db"], cwd=repo, check=True)
    subprocess.run(["git", "commit", "-m", f"sync {date.today()}"], cwd=repo, check=True)
    
    print("[green]✅ Git sync 완료[/green]")
```

자경단 매주.

---

## 4. 셋째 — 복구

```python
@app.command()
def restore(backup_file: str):
    """백업에서 복구."""
    backup_path = Path(backup_file)
    if not backup_path.exists():
        print(f"[red]백업 없음: {backup_file}[/red]")
        return
    
    # 현재 DB를 임시 백업
    if DB_PATH.exists():
        temp_backup = DB_PATH.with_suffix(".pre-restore.db")
        shutil.copy(DB_PATH, temp_backup)
    
    shutil.copy(backup_path, DB_PATH)
    print(f"[green]✅ 복구 완료: {backup_file}[/green]")
```

복구 전 자동 백업 (사고 방지).

---

## 5. 넷째 — 데이터 검증

```python
@app.command()
def verify():
    """DB 무결성 검증."""
    conn = get_db()
    
    # 1. 무결성 체크
    result = conn.execute("PRAGMA integrity_check").fetchone()
    if result[0] != "ok":
        print(f"[red]❌ 무결성 실패: {result[0]}[/red]")
        return
    
    # 2. 음수 금액 검사
    rows = conn.execute("SELECT COUNT(*) FROM entries WHERE amount < 0").fetchone()
    if rows[0] > 0:
        print(f"[yellow]⚠️ 음수 금액 {rows[0]}건[/yellow]")
    
    # 3. 빈 카테고리 검사
    rows = conn.execute("SELECT COUNT(*) FROM entries WHERE category = ''").fetchone()
    if rows[0] > 0:
        print(f"[yellow]⚠️ 빈 카테고리 {rows[0]}건[/yellow]")
    
    # 4. 미래 날짜 검사
    rows = conn.execute("SELECT COUNT(*) FROM entries WHERE date > ?", (date.today().isoformat(),)).fetchone()
    if rows[0] > 0:
        print(f"[yellow]⚠️ 미래 날짜 {rows[0]}건[/yellow]")
    
    print("[green]✅ 검증 완료[/green]")
```

자경단 매주.

---

## 6. 다섯째 — cron 자동화

```bash
# crontab -e
# 매일 9시 백업
0 9 * * * /usr/local/bin/vigilante-budget backup

# 매주 일요일 sync
0 10 * * 0 /usr/local/bin/vigilante-budget sync-git

# 매월 1일 검증
0 8 1 * * /usr/local/bin/vigilante-budget verify
```

cron이 자동 실행. 자경단 매월.

macOS는 launchd 권장.

---

## 7. 자경단 매일 운영 의식

**1. 매일** → add (가계부)

**2. 매주** → backup + verify

**3. 매월** → sync + report

**4. 매분기** → trend 분석

**5. 매년** → export + archive

다섯.

---

## 8. 다섯 함정과 처방

**함정 1: 백업 안 함**

처방. cron 자동.

**함정 2: 복구 시 사고**

처방. pre-restore 백업.

**함정 3: 동기화 충돌**

처방. timestamp 기반.

**함정 4: 데이터 손상**

처방. integrity_check.

**함정 5: 무한 backup**

처방. 30개 유지.

---

## 9. 흔한 오해 다섯 가지

**오해 1: 백업 옵션.**

5년 안전 보장의 첫.

**오해 2: SQLite 안전.**

손상 가능. integrity_check.

**오해 3: cron 어렵다.**

5줄.

**오해 4: 복구 잘 안 씀.**

사고 시 사용.

**오해 5: sync 인터넷만.**

local Git도.

---

## 10. 자주 받는 질문 다섯 가지

**Q1. backup 주기?**

매일. cron.

**Q2. S3 비용?**

GB당 $0.02. 가계부는 무시.

**Q3. 복구 시간?**

shutil.copy. 즉시.

**Q4. 검증 자동?**

매주 cron.

**Q5. Git LFS?**

100MB 넘으면.

---

## 11. 흔한 실수 다섯 + 안심 — 운영 학습 편

첫째, 백업 옵션. 안심 — 5년 안전의 첫.
둘째, SQLite 무한 안전. 안심 — integrity_check.
셋째, cron 어렵다. 안심 — 5줄.
넷째, 복구 안 씀. 안심 — 사고 시 즉시.
다섯째, 가장 큰 — sync 인터넷만. 안심 — local Git OK.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리 — 1년차 종료

자, 여섯 번째 시간 끝. **1년차의 마지막 H6**.

vigilante-budget의 운영 다섯 — 백업, sync, 복구, 검증, 자동화.

박수 한 번 칠게요. 진짜로요. 큰 박수예요. 본인이 1년차 끝을 맞이했어요. Ch001 컴퓨터 구조부터 Ch015 가계부까지. 15 챕터, 120 H 시간. 본인이 자경단 한 명의 손가락이 됐어요.

본 H7은 깊이. SQLite 내부, B-tree, transaction. 한 시간 후 만나요.

본 H8이 본 챕터의 마무리이자 1년차의 마무리. 본인의 1년 회고 + 2년차 다리.

박수 진짜 큰 박수.

---

## 👨‍💻 개발자 노트

> - PRAGMA integrity_check: SQLite 무결성.
> - shutil.copy vs copy2: copy2가 metadata도.
> - boto3: AWS SDK. 자경단 미니.
> - cron 표현: 분 시 일 월 요일.
> - launchd: macOS. plist.
> - 다음 H7 키워드: SQLite · B-tree · transaction · WAL.
