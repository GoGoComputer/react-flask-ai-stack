# Ch015 · H7 — CLI 가계부 내부 — SQLite·B-tree·transaction

> 고양이 자경단 · Ch 015 · 7교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. SQLite 한 파일 = 하나의 DB
3. B-tree — 인덱스의 비밀
4. transaction과 ACID
5. WAL (Write-Ahead Logging)
6. SQL 파싱과 query plan
7. typer의 동작 원리
8. CLI 도구가 OS와 만나는 방식
9. 흔한 오해 다섯 가지
10. 마무리

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요.

지난 H6 회수. 백업, sync, 복구, 검증, cron 자동화. 본인의 가계부가 5년 안전.

이번 H7은 깊이의 시간이에요. SQLite 안에서 무엇이 일어나는지.

오늘의 약속. **본인이 가계부의 한 INSERT가 디스크에 어떻게 박히는지 만집니다**.

자, 가요.

---

## 2. SQLite 한 파일 = 하나의 DB

SQLite의 가장 신기한 점. **한 .db 파일이 통째로 데이터베이스**.

Postgres나 MySQL은 서버 프로세스 + 데이터 파일들 + 설정 파일. 복잡.

SQLite는 .db 파일 하나. 본인이 그 파일을 USB에 복사해도 통째로 살아 있어요.

```bash
file ~/.vigilante-budget.db
# SQLite 3.x database
```

내부 구조. 4KB 페이지의 연속.

```
페이지 1: 헤더 + 스키마
페이지 2: 인덱스 root
페이지 3-N: 데이터
```

각 페이지는 B-tree의 노드.

자경단의 매일 — 본인 가계부가 .db 한 파일에. 5년 후 1MB 정도. USB에 백업 5초.

---

## 3. B-tree — 인덱스의 비밀

SELECT가 빠른 이유. B-tree.

```
                [50]
              /      \
          [25]        [75]
         /   \        /   \
       [10] [40]   [60] [90]
```

balanced tree. 어느 노드든 깊이 비슷. log(n) 검색.

100만 행에서 한 행 찾기 — 10번 비교. 일반 list는 100만 번. **10만 배 빠름**.

자경단 가계부의 인덱스.

```sql
CREATE INDEX idx_date ON entries(date);
```

date 컬럼에 B-tree 인덱스. WHERE date='2026-04-30'이 100만 행에서도 0.001초.

자경단 매주 — 자주 검색하는 컬럼에 인덱스.

---

## 4. transaction과 ACID

SQLite의 ACID.

**A** (Atomicity). 모두 또는 전혀.

```python
conn.execute("BEGIN")
conn.execute("INSERT ... values (1)")
conn.execute("INSERT ... values (2)")
# 사고 발생 시
conn.execute("ROLLBACK")   # 둘 다 취소
# 또는
conn.execute("COMMIT")     # 둘 다 적용
```

**C** (Consistency). 제약 조건 항상 만족.

**I** (Isolation). 동시 트랜잭션이 서로 안 보임.

**D** (Durability). 커밋 후 디스크에 영구.

자경단의 매일 — 본인이 entry 추가 시 자동 transaction. SQLite가 알아서.

---

## 5. WAL (Write-Ahead Logging)

옛 SQLite는 매 INSERT 시 디스크 sync. 느림.

WAL 모드 (3.7+).

1. 변경을 WAL 파일 (write-ahead log)에 먼저.
2. 주기적으로 WAL을 .db에 적용 (checkpoint).
3. 크래시 시 WAL로 복구.

```sql
PRAGMA journal_mode=WAL;
```

장점. 동시 read 가능. 빠른 write.

```bash
ls -la budget.db*
# budget.db
# budget.db-shm   (shared memory)
# budget.db-wal   (write-ahead log)
```

자경단 표준 — WAL 모드.

---

## 6. SQL 파싱과 query plan

본인이 `SELECT * FROM entries WHERE date='...'` 한 번 칠 때.

**1. parser**. SQL 문자열 → AST.

**2. planner**. 가장 빠른 실행 경로 찾기. 인덱스 사용 여부 결정.

**3. executor**. plan 실행. B-tree 순회.

```sql
EXPLAIN QUERY PLAN SELECT * FROM entries WHERE date='2026-04-30';
-- USING INDEX idx_date
```

본인이 query plan 보고 인덱스 안 쓰면 의심. 자경단 매주.

---

## 7. typer의 동작 원리

`@app.command()` decorator가 안에서.

1. 함수의 시그니처 검사 (inspect).
2. type hints에서 click의 Option/Argument 자동 생성.
3. 함수를 click의 명령으로 등록.
4. CLI 호출 시 인자 파싱 + type 변환 + 함수 호출.

```python
@app.command()
def add(amount: int, category: str):
    ...

# 자동으로 click.command 등록
# python script.py add 5000 food
```

type hints가 없으면 typer가 동작 안 함. 그래서 type hints 강제.

---

## 8. CLI 도구가 OS와 만나는 방식

본인이 `vigilante-budget add 5000 food` 친다.

**1. shell이 PATH 검색**. `vigilante-budget` 실행 파일 찾기.

**2. 셸이 fork + exec**. 새 프로세스.

**3. Python 인터프리터 시작**. shebang `#!/usr/bin/env python3`.

**4. 본인 스크립트 실행**. typer가 인자 파싱.

**5. 함수 호출**. add(amount=5000, category='food').

**6. SQLite 호출**. INSERT INTO ... 실행.

**7. 결과 출력**. rich가 색깔.

**8. 프로세스 종료**. exit code 0.

7단계. 평균 0.2초. 자경단 매일 10번.

---

## 9. 흔한 오해 다섯 가지

**오해 1: SQLite 약하다.**

100GB까지 OK. 자경단 충분.

**오해 2: 인덱스 항상 좋다.**

write 느려짐. 균형.

**오해 3: WAL 자동.**

명시적 PRAGMA 필요.

**오해 4: typer 무거움.**

가벼움. 0.05초 시작.

**오해 5: CLI 매번 fork.**

맞음. 그러나 빠름.

---

## 10. 흔한 실수 다섯 + 안심 — 깊이 학습 편

첫째, SQLite 약함 가정. 안심 — 100GB까지.
둘째, 인덱스 무한 좋음. 안심 — write 느려짐, 균형.
셋째, WAL 자동. 안심 — PRAGMA 명시.
넷째, typer 무거움. 안심 — 0.05초 시작.
다섯째, 가장 큰 — fork 비쌈. 안심 — 0.2초, 매일 10번 OK.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 11. 마무리

자, 일곱 번째 시간이 끝났어요.

SQLite 한 파일, B-tree, ACID, WAL, query plan, typer 내부, OS 흐름.

박수.

다음 H8은 적용 + 회고. 본 챕터 + 1년차 마무리.

```bash
sqlite3 ~/.vigilante-budget.db ".schema"
sqlite3 ~/.vigilante-budget.db "EXPLAIN QUERY PLAN SELECT * FROM entries WHERE date='2026-04-30';"
```

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - SQLite 페이지: 4KB 기본. PRAGMA page_size로 변경.
> - B-tree fanout: 페이지당 평균 100. 100만 행에 깊이 4-5.
> - WAL checkpoint: 자동 또는 PRAGMA wal_checkpoint.
> - typer + click: typer는 click의 type hints 래퍼.
> - shebang vs entry_points: pyproject.toml의 scripts.
> - 다음 H8 키워드: Ch015 회고 · 1년차 종료 · 2년차 다리.
