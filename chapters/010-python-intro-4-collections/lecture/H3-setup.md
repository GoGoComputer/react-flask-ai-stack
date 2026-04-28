# Ch010 · H3 — Python 입문 4: 환경점검 — rich.print·json·pprint·collections.abc 4 도구

> **이 H에서 얻을 것**
> - rich.print 예쁜 출력
> - json 직렬화 / 역직렬화
> - pprint 깊은 dict 출력
> - collections.abc 5 ABC 인터페이스
> - 자경단 매일 4 도구 활용

---

## 회수: H2 36 메서드에서 본 H의 도구로

지난 H2에서 본인은 list 11 + tuple 3 + dict 12 + set 10 = 36 메서드를 학습했어요. 그건 **데이터를 다루는 메서드**.

본 H3는 그 데이터를 **사람에게 보여주고·파일로 저장하고·타입을 검사하는 4 도구**예요. rich.print (예쁜 출력) + json (직렬화) + pprint (깊은 dict) + collections.abc (인터페이스) — 자경단 매일 4 도구.

까미가 묻습니다. "왜 print() 대신 다른 게 필요해요?" 본인이 답합니다. "1만 항목 dict을 print() 하면 한 줄로 나와서 못 봐요. pprint()는 들여쓰기 + 줄바꿈으로 사람이 읽을 수 있게 해줘요." 노랭이가 끄덕이고, 미니가 collections.abc를 메모하고, 깜장이가 json 코드를 따라 칩니다.

본 H의 약속 — 끝나면 자경단이 데이터를 출력·저장·타입 검사 4 도구를 손가락에 붙입니다. 디버깅 시 rich.print로 색깔 + 들여쓰기, API 통신 시 json.dumps/loads, 깊은 dict 검사 시 pprint, 사용자 정의 collection 작성 시 collections.abc. 4 도구 = 자경단 매일 100+ 호출.

---

## 1. rich.print — 예쁜 출력

### 1-1. 설치

```bash
pip install rich
# 또는
uv add rich
```

자경단 표준 — `rich`는 거의 모든 Python 프로젝트에 깔려있어요. requirements.txt 1순위.

### 1-2. 기본 사용

```python
from rich import print

print({'name': '까미', 'age': 2, 'tags': ['검정', '암컷']})
# 색깔 + 들여쓰기 + 키 강조

print([1, 2, 3, 4, 5])
# 색깔로 숫자 강조

print('🐾 안녕하세요')
# 이모지 정확히 출력
```

자경단 매일 — `from rich import print`로 기본 print 대체.

### 1-3. rich.console.Console

```python
from rich.console import Console
console = Console()

console.print('Hello', style='bold red')
console.print('Warning', style='yellow on black')

# 진행 상황
with console.status('처리 중...'):
    long_running_job()

# 룰 (구분선)
console.rule('[bold cyan]섹션 1')
```

자경단 — Console로 색깔·스타일·진행 상황 표시.

### 1-4. rich.table.Table

```python
from rich.table import Table
table = Table(title='고양이 명단')
table.add_column('이름', style='cyan')
table.add_column('나이', justify='right')
table.add_column('색깔')

table.add_row('까미', '2', '검정')
table.add_row('노랭이', '3', '노랑')
table.add_row('미니', '1', '회색')

console.print(table)
```

자경단 매일 — DB 결과 표 출력. CSV보다 명확.

### 1-5. rich.tree.Tree

```python
from rich.tree import Tree
tree = Tree('고양이 자경단')
본인 = tree.add('본인 (FastAPI)')
본인.add('routes')
본인.add('models')

까미 = tree.add('까미 (DB)')
까미.add('queries')
까미.add('migrations')

console.print(tree)
```

자경단 — 디렉토리 구조·중첩 데이터 시각화.

### 1-6. rich.json

```python
from rich import print_json

data = {'name': '까미', 'tags': ['검정'], 'meta': {'created': '2025-01-01'}}
print_json(data=data)
# 색깔 있는 JSON 출력
```

자경단 — API response 디버깅 시 사용.

### 1-7. rich.progress

```python
from rich.progress import track

for item in track(items, description='처리 중...'):
    process(item)

# 또는 컬럼 커스텀
from rich.progress import Progress, BarColumn, TimeRemainingColumn
with Progress(
    '[progress.description]{task.description}',
    BarColumn(),
    '[progress.percentage]{task.percentage:>3.0f}%',
    TimeRemainingColumn(),
) as progress:
    task = progress.add_task('다운로드', total=1000)
    for i in range(1000):
        progress.update(task, advance=1)
```

자경단 매일 — 배치 작업·다운로드·DB migration 진행 상황.

### 1-8. rich.traceback

```python
from rich.traceback import install
install(show_locals=True)

# 이후 모든 예외가 색깔 있는 traceback + locals 표시
1 / 0
```

자경단 — 디버깅 시 traceback이 30배 읽기 쉬움. 매 프로젝트 main.py 첫 줄.

### 1-9. rich 6 도구 한 페이지

| 도구 | 용도 | 자경단 |
|------|----|------|
| print | 색깔 출력 | 매일 |
| Console | 스타일·rule | 매주 |
| Table | 표 | 매주 |
| Tree | 중첩 시각화 | 가끔 |
| Progress | 진행 상황 | 매주 |
| traceback | 예외 색깔 | 항상 |

6 도구 = rich 100%.

---

## 2. json — 직렬화 / 역직렬화

### 2-1. json.dumps / json.loads

```python
import json

# Python → JSON 문자열
data = {'name': '까미', 'age': 2}
s = json.dumps(data)
# '{"name": "\\uae4c\\ubbf8", "age": 2}' (한글 escape)

s = json.dumps(data, ensure_ascii=False)
# '{"name": "까미", "age": 2}' (한글 그대로)

s = json.dumps(data, ensure_ascii=False, indent=2)
# 들여쓰기 + 줄바꿈

# JSON 문자열 → Python
data = json.loads(s)
# {'name': '까미', 'age': 2}
```

자경단 표준 — `ensure_ascii=False, indent=2` 매일.

### 2-2. json.dump / json.load (파일)

```python
# 쓰기
with open('cats.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# 읽기
with open('cats.json', encoding='utf-8') as f:
    data = json.load(f)
```

자경단 매일 — 설정 파일·DB dump·로그.

### 2-3. JSON 직렬화 가능 타입

| Python | JSON |
|--------|------|
| dict | object |
| list, tuple | array |
| str | string |
| int, float | number |
| True/False | true/false |
| None | null |

자경단 주의 — datetime·set·custom class는 그냥 안 됨. 변환 필요.

### 2-4. custom 직렬화 (default)

```python
from datetime import datetime
import json

def cat_serializer(obj):
    if isinstance(obj, datetime):
        return obj.isoformat()
    if isinstance(obj, set):
        return list(obj)
    raise TypeError(f'Not serializable: {type(obj)}')

data = {'name': '까미', 'created': datetime.now(), 'tags': {'검정', '암컷'}}
json.dumps(data, default=cat_serializer, ensure_ascii=False)
```

자경단 매일 — datetime·set·dataclass 직렬화.

### 2-5. dataclass JSON

```python
from dataclasses import dataclass, asdict
import json

@dataclass
class Cat:
    name: str
    age: int

cat = Cat('까미', 2)
json.dumps(asdict(cat), ensure_ascii=False)
# '{"name": "까미", "age": 2}'
```

자경단 — dataclass + asdict + json.dumps 매일.

### 2-6. Pydantic JSON

```python
from pydantic import BaseModel

class Cat(BaseModel):
    name: str
    age: int

cat = Cat(name='까미', age=2)
cat.model_dump_json()                  # '{"name":"까미","age":2}'
cat.model_dump()                       # dict
Cat.model_validate_json('{"name":"노랭이","age":3}')
```

자경단 1순위 — FastAPI 자동 직렬화. Pydantic 표준.

### 2-7. JSON 5 함정과 처방

```python
# 함정 1: 한글 escape
json.dumps({'name': '까미'})           # '{"name": "\\uae4c\\ubbf8"}'

# 처방
json.dumps({'name': '까미'}, ensure_ascii=False)

# 함정 2: datetime 직렬화 안 됨
json.dumps({'created': datetime.now()})    # TypeError!

# 처방: default 함수 또는 isoformat
json.dumps({'created': datetime.now().isoformat()})

# 함정 3: int 키 → str 변환
json.dumps({1: 'a', 2: 'b'})            # '{"1": "a", "2": "b"}'
# 역직렬화 시 키 string 됨!

# 처방: 의도적이면 OK·아니면 list of tuple
json.dumps([[1, 'a'], [2, 'b']])

# 함정 4: NaN/Infinity (JSON 표준 X)
json.dumps({'x': float('nan')})         # 'NaN' (비표준)

# 처방: allow_nan=False + None 변환
import math
def clean(x):
    return None if math.isnan(x) else x

# 함정 5: tuple vs list
json.dumps((1, 2, 3))                   # '[1, 2, 3]' tuple → list
# 역직렬화하면 list가 됨

# 처방: 자경단 인지·필요 시 후처리
```

5 함정 = 자경단 면역.

### 2-8. orjson (production)

```python
import orjson

# 5-10배 빠름·자동 datetime/UUID 처리
orjson.dumps({'created': datetime.now(), 'id': uuid4()})
# bytes 반환 (str 아님)

# str 필요 시 .decode()
orjson.dumps(data).decode()
```

자경단 production — orjson 1순위. 학습은 표준 json.

---

## 3. pprint — 깊은 dict 출력

### 3-1. 기본 사용

```python
from pprint import pprint

data = {
    'cats': [
        {'name': '까미', 'age': 2, 'tags': ['검정']},
        {'name': '노랭이', 'age': 3, 'tags': ['노랑', '수컷']},
    ],
    'meta': {'total': 2, 'created': '2025-01-01'},
}

pprint(data)
# 들여쓰기 + 줄바꿈 + 80자 폭
```

자경단 매일 — 깊은 dict 디버깅.

### 3-2. 옵션

```python
pprint(data, width=120)                # 폭 조정
pprint(data, depth=2)                  # 깊이 제한 (...로 표시)
pprint(data, sort_dicts=False)         # 키 정렬 X (Python 3.8+)
pprint(data, compact=True)             # 한 줄 가능하면 한 줄
```

자경단 — width 80 기본·depth 제한 큰 데이터 디버깅.

### 3-3. pformat (문자열로)

```python
from pprint import pformat

s = pformat(data, indent=2)
logger.info(f'데이터:\n{s}')
```

자경단 매일 — 로그에 깊은 dict 기록.

### 3-4. rich vs pprint vs print 비교

| 도구 | 색깔 | 깊이 | 속도 | 자경단 |
|------|----|-----|----|------|
| print() | X | 한 줄 | 빠름 | 간단 출력 |
| pprint() | X | 들여쓰기 | 빠름 | 디버깅 |
| rich.print() | O | 들여쓰기 | 느림 | 사용자 출력 |

자경단 — 디버깅 pprint·사용자 출력 rich·간단 print.

---

## 4. collections.abc — 5 ABC 인터페이스

### 4-1. ABC란?

ABC = Abstract Base Class. **인터페이스 검사**용 클래스. 자경단 매일 isinstance.

```python
from collections.abc import (
    Iterable, Iterator, Sequence, Mapping, Set,
    Sized, Container, Callable, Hashable
)

isinstance([1, 2, 3], Sequence)        # True
isinstance({1: 2}, Mapping)            # True
isinstance({1, 2}, Set)                # True
isinstance(range(10), Iterable)        # True
```

자경단 — `isinstance(x, list)` 대신 `isinstance(x, Sequence)`로 더 일반적.

### 4-2. 5 핵심 ABC

```python
# 1. Iterable — for 가능
isinstance([1, 2], Iterable)           # True
isinstance({1: 2}, Iterable)           # True (key 반복)

# 2. Sequence — index 가능 + len
isinstance([1, 2], Sequence)           # True
isinstance((1, 2), Sequence)           # True
isinstance({1, 2}, Sequence)           # False (set은 index X)

# 3. Mapping — key-value
isinstance({}, Mapping)                # True
isinstance([], Mapping)                # False

# 4. Set — set 연산
isinstance({1, 2}, Set)                # True
isinstance(frozenset(), Set)           # True

# 5. Hashable — dict 키 가능
isinstance(1, Hashable)                # True
isinstance([], Hashable)               # False
```

자경단 매일 — type 검사 표준.

### 4-3. 사용자 정의 collection

```python
from collections.abc import Sequence

class CatList(Sequence):
    def __init__(self):
        self.cats = []
    
    def __getitem__(self, i):
        return self.cats[i]
    
    def __len__(self):
        return len(self.cats)

cl = CatList()
isinstance(cl, Sequence)               # True (자동 인식)
```

자경단 — 사용자 정의 collection도 ABC 만족하면 표준 함수 적용.

### 4-4. type hint with ABC

```python
from collections.abc import Sequence, Mapping

def process(items: Sequence[int]) -> Mapping[int, int]:
    return {i: i**2 for i in items}

# 호출자: list, tuple, NamedTuple, custom Sequence 모두 OK
process([1, 2, 3])
process((1, 2, 3))
```

자경단 매일 — 함수 인자에 list보다 Sequence 더 일반적.

### 4-5. ABC vs concrete 선택

| 상황 | ABC | concrete |
|------|----|--------|
| 함수 인자 | Sequence/Mapping | list/dict |
| return type | concrete | concrete |
| isinstance | ABC | concrete |
| type hint | ABC | concrete |

자경단 규칙 — 받을 땐 ABC (포용), 줄 땐 concrete (명확).

### 4-6. collections.abc 9 인터페이스

| ABC | 의미 | 예 |
|-----|----|---|
| Container | `in` | list, dict, set |
| Iterable | for 가능 | list, dict, gen |
| Iterator | next() | gen, file |
| Sized | len() | list, dict |
| Sequence | index + len | list, tuple, str |
| MutableSequence | + 변경 | list |
| Mapping | key-value 읽기 | dict, MappingProxyType |
| MutableMapping | + 쓰기 | dict |
| Set | set 연산 | set, frozenset |

9 ABC = collections.abc 100%.

### 4-7. ABC vs typing 변천

```python
# Python 3.8까지 — typing 모듈
from typing import List, Dict, Sequence

def f(x: List[int]) -> Dict[str, int]: ...

# Python 3.9+ — built-in 직접
def f(x: list[int]) -> dict[str, int]: ...

# Python 3.9+ — collections.abc
from collections.abc import Sequence, Mapping

def f(x: Sequence[int]) -> Mapping[str, int]: ...
```

자경단 표준 — Python 3.9+ built-in (list/dict) 또는 collections.abc 직접. typing.List/Dict는 deprecated.

---

## 5. 자경단 4 도구 매일 시나리오

### 5-1. 본인 — FastAPI 응답 디버깅

```python
from rich import print as rprint
from rich.console import Console
console = Console()

@app.get('/cats')
async def list_cats():
    cats = await db.fetch_all(...)
    rprint('[bold cyan]응답:[/]', cats)    # rich로 디버깅
    return cats
```

### 5-2. 까미 — DB 마이그레이션 dump

```python
import json

def dump_schema():
    schema = inspect_database()
    with open('schema.json', 'w', encoding='utf-8') as f:
        json.dump(schema, f, ensure_ascii=False, indent=2)
```

### 5-3. 노랭이 — CLI 도구 출력

```python
from rich.table import Table
from rich.console import Console

console = Console()
table = Table(title='고양이 통계')
table.add_column('이름')
table.add_column('나이', justify='right')

for cat in cats:
    table.add_row(cat.name, str(cat.age))

console.print(table)
```

### 5-4. 미니 — 인프라 설정 검사

```python
from collections.abc import Mapping

def validate_config(config):
    if not isinstance(config, Mapping):
        raise TypeError('config must be Mapping')
    if 'host' not in config:
        raise ValueError('host required')
```

### 5-5. 깜장이 — 테스트 디버깅

```python
from pprint import pprint

def test_api_response():
    response = client.get('/cats')
    pprint(response.json())                # 깊은 dict 보기 좋게
    assert response.status_code == 200
```

5 시나리오 × 매일 = 4 도구 100% 활용.

### 5-6. 자경단 1주 4 도구 통합 워크플로우

```python
# 본인 — DB 조회 → 직렬화 → 응답 (FastAPI 매일)
from rich import print as rprint
from collections.abc import Sequence
import json

@app.get('/cats')
async def list_cats(active: bool = True):
    cats: Sequence[Cat] = await db.fetch_cats(active=active)
    
    # 디버깅 — rich
    rprint(f'[bold cyan]조회 결과:[/] {len(cats)}건')
    
    # 직렬화 — Pydantic (FastAPI 자동) 또는 json
    return [c.model_dump() for c in cats]

# 까미 — DB schema dump (월 1회)
import json

def dump_schema(output_path: str):
    schema = inspect_db()
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(schema, f, ensure_ascii=False, indent=2, default=str)
    rprint(f'[green]✓[/] 스키마 저장: {output_path}')

# 노랭이 — CLI 도구 출력 (매일)
from rich.table import Table
from rich.console import Console

console = Console()
def report(stats: Mapping[str, int]):
    table = Table(title='주간 통계')
    table.add_column('항목')
    table.add_column('수치', justify='right')
    for k, v in stats.items():
        table.add_row(k, f'{v:,}')
    console.print(table)

# 미니 — 인프라 검사 (매일)
from collections.abc import Mapping, Sequence

def validate_config(config: Mapping) -> bool:
    if not isinstance(config, Mapping):
        raise TypeError('config must be Mapping')
    if not isinstance(config.get('hosts'), Sequence):
        raise TypeError('hosts must be Sequence')
    return True

# 깜장이 — 테스트 디버깅 (매일)
from pprint import pprint

def test_complex_response():
    response = client.get('/cats?active=true').json()
    pprint(response, depth=3, sort_dicts=False)
    assert 'data' in response
```

5 자경단 통합 워크플로우 = 4 도구 100% 매일.

---

## 6. 흔한 오해 5가지

**오해 1: "rich 무거우니 production X."** — rich는 production OK. CLI 도구·배치에 매일.

**오해 2: "json 한글 깨짐 정상."** — `ensure_ascii=False` 한 줄로 해결. 매일.

**오해 3: "pprint = print 느림."** — 실제 차이 없음. 가독성 무한 가치.

**오해 4: "collections.abc 시니어용."** — 1주차 학습. type hint 매일.

**오해 5: "isinstance 안티패턴."** — duck typing 우선이지만, type 검사 필요 시 ABC 사용 정상.

**오해 6: "rich.print() 와 print()는 동일."** — 다름. rich는 깊은 dict·list 들여쓰기·색깔. 매일 디버깅 도구.

**오해 7: "json은 모든 데이터 직렬화 가능."** — 7 타입만. datetime·set·class는 default 함수 필요.

**오해 8: "pprint는 옛날 도구."** — 파이썬 표준 라이브러리·매일 디버깅. rich보다 가벼움·import 0초.

**오해 9: "Pydantic만 있으면 json 모듈 X."** — Pydantic 외부 통신 표준이지만 내부 직렬화·간단 dump는 json 직접.

**오해 10: "abc는 단지 type hint."** — isinstance 검사·사용자 정의 collection 등록·duck typing 강제 등 다양.

---

## 7. FAQ 5가지

**Q1. rich 대안?**
A. `colorama` (색깔만), `tqdm` (진행 바), `tabulate` (표). rich가 통합 1순위.

**Q2. json vs orjson?**
A. orjson 5-10배 빠름. 큰 데이터 + production은 orjson. 학습은 표준 json.

**Q3. pprint vs json.dumps(indent=2)?**
A. pprint Python 표현식 (set, tuple 보임). json은 JSON 표준 (set 안 됨). 자경단 디버깅 pprint, 외부 통신 json.

**Q4. collections.abc vs typing?**
A. typing.List → 옛 양식 (Python 3.9까지). list 또는 collections.abc.Sequence 직접 → 표준 (Python 3.9+).

**Q5. dataclass vs Pydantic?**
A. dataclass 표준 라이브러리·가벼움. Pydantic 검증 + JSON + FastAPI 통합. 자경단 FastAPI는 Pydantic.

**Q6. rich.console.Console 매번 만드나?**
A. 모듈 최상단에 `console = Console()` 1회 + import해 사용. 자경단 표준.

**Q7. json indent=2 vs indent=4?**
A. 자경단 표준 indent=2 (Black·prettier 표준). 4도 OK·일관성이 중요.

**Q8. pprint vs rich.pretty?**
A. pprint 표준 라이브러리·rich.pretty rich 패키지. 색깔 필요 시 rich.pretty.pprint 또는 그냥 rich.print.

**Q9. abc로 isinstance vs hasattr duck typing?**
A. 자경단 — isinstance 명확·hasattr 유연. 인터페이스 강제 시 isinstance, 옵셔널 시 hasattr.

**Q10. typing.Sequence와 collections.abc.Sequence 차이?**
A. Python 3.9+ typing.Sequence deprecated. collections.abc.Sequence 표준. 같은 것이지만 import 위치 다름.

---

## 7-bonus. 자경단 4 도구 함정 1+1+1+1

```python
# 함정 1 (rich): 색깔 코드가 로그 파일에 들어감
console.print('test', style='red')      # 터미널 OK·로그 파일 [...m 코드

# 처방: 환경 분기
import sys
console = Console(force_terminal=False if not sys.stdout.isatty() else None)

# 함정 2 (json): default 함수 누락
json.dumps({'created': datetime.now()})    # TypeError!

# 처방: 표준 default
def to_str(o):
    if isinstance(o, (datetime, date)): return o.isoformat()
    if isinstance(o, set): return list(o)
    if hasattr(o, '__dict__'): return o.__dict__
    raise TypeError(f'Not serializable: {type(o)}')

json.dumps(data, default=to_str)

# 함정 3 (pprint): 큰 데이터 무한 출력
pprint(huge_dict)                       # 1만 줄 터미널 폭발

# 처방: depth 제한
pprint(huge_dict, depth=2)              # ...로 표시

# 함정 4 (abc): 잘못된 ABC 사용
isinstance(x, list) and isinstance(x, tuple)    # 절대 둘 다 X

# 처방: Sequence
isinstance(x, Sequence)                  # list, tuple, str 모두 True
```

4 함정 = 자경단 면역.

---

## 8. 자경단 4 도구 결정 트리

```
질문 1: 디버깅 출력?
  - 깊은 dict → pprint
  - 사용자 보기 → rich
  - 간단 → print
질문 2: JSON 직렬화?
  - 표준 → json (ensure_ascii=False, indent=2)
  - 빠름 → orjson
  - FastAPI → Pydantic 자동
질문 3: type 검사?
  - 일반 → isinstance(x, ABC)
  - 구체 → isinstance(x, list/dict)
질문 4: type hint?
  - 인자 → Sequence/Mapping (포용)
  - return → list/dict (명확)
```

4 질문 결정 트리 = 4 도구 100% 활용.

### 8-bonus. 자경단 1주 4 도구 사용 통계

| 자경단 | rich | json | pprint | abc |
|------|----|----|------|---|
| 본인 (FastAPI) | 50 | 100 | 30 | 20 |
| 까미 (DB) | 30 | 80 | 50 | 10 |
| 노랭이 (CLI 도구) | 100 | 60 | 20 | 5 |
| 미니 (인프라) | 40 | 50 | 30 | 30 |
| 깜장이 (테스트) | 20 | 70 | 80 | 15 |

총 1주 — json 360·rich 240·pprint 210·abc 80. json이 1위 (API 통신 표준).

---

## 9. 추신

추신 1. rich.print = 색깔 + 들여쓰기 + 이모지. `from rich import print` 한 줄로 기본 print 대체.

추신 2. rich.console.Console = 스타일·진행 상황·룰. 자경단 CLI 매일.

추신 3. rich.table.Table = DB 결과 표 출력. CSV보다 명확.

추신 4. rich.tree.Tree = 디렉토리·중첩 데이터 시각화.

추신 5. rich.print_json = API response 디버깅.

추신 6. json.dumps/loads = Python ↔ JSON 문자열.

추신 7. json.dump/load = Python ↔ JSON 파일.

추신 8. `ensure_ascii=False, indent=2` = 자경단 표준. 한글 + 들여쓰기.

추신 9. JSON 직렬화 가능 — dict/list/str/int/float/bool/None 7 타입.

추신 10. JSON 안 되는 — datetime·set·dataclass·custom class. `default=` 함수로 변환.

추신 11. dataclass + asdict + json.dumps = 3 단계 직렬화.

추신 12. Pydantic = FastAPI 표준. model_dump_json() 자동.

추신 13. pprint = 깊은 dict 들여쓰기. width 80 기본.

추신 14. pprint(data, depth=2) = 깊이 제한.

추신 15. pformat = 문자열 반환. 로그 매일.

추신 16. rich vs pprint vs print = 사용자/디버깅/간단 3 분리.

추신 17. collections.abc = ABC = Abstract Base Class.

추신 18. 5 핵심 ABC — Iterable·Sequence·Mapping·Set·Hashable.

추신 19. isinstance(x, Sequence) = list/tuple/range/str 모두 True.

추신 20. isinstance(x, Mapping) = dict + dict 서브클래스 모두 True.

추신 21. isinstance(x, Hashable) = dict 키 가능 검사. set·list False.

추신 22. 사용자 정의 collection = ABC 상속하면 자동 인식.

추신 23. type hint — 인자 ABC (포용)·return concrete (명확) 자경단 규칙.

추신 24. 자경단 5 시나리오 — FastAPI rprint·DB json dump·CLI Table·인프라 abc·테스트 pprint.

추신 25. 흔한 오해 5 면역 (rich 무거움·json 한글·pprint 느림·abc 시니어용·isinstance 안티).

추신 26. FAQ 5 (rich 대안·orjson·pprint vs json·abc vs typing·dataclass vs Pydantic).

추신 27. 자경단 4 도구 결정 트리 — 디버깅·JSON·type 검사·type hint 4 질문.

추신 28. 1주 통계 — json 360 (1위)·rich 240·pprint 210·abc 80.

추신 29. json이 자경단 1위 — API 통신 표준. 매일 100+ 호출.

추신 30. rich CLI 도구 1순위 — 노랭이 매주 100+.

추신 31. pprint 테스트 디버깅 1순위 — 깜장이 매주 80+.

추신 32. abc 인프라 검사 1순위 — 미니 매주 30+.

추신 33. **본 H 끝** ✅ — Ch010 H3 환경점검 4 도구 학습 완료. 다음 H4! 🐾🐾🐾

추신 34. 본 H 학습 후 본인의 첫 5 행동 — 1) `pip install rich` 5분, 2) `from rich import print` 모든 파일, 3) json.dumps(ensure_ascii=False, indent=2) 표준화, 4) pprint 디버깅 표준화, 5) collections.abc type hint 적용.

추신 35. 본 H의 진짜 결론 — 4 도구 (rich·json·pprint·abc)가 collections를 사람과 외부 시스템에 연결.

추신 36. **본 H 진짜 끝** ✅✅ — Ch010 H3 환경점검 학습 완료! 자경단 4 도구 매일 활용! 🐾🐾🐾🐾🐾

추신 37. rich + collections = 사용자 출력. json + collections = 외부 통신. pprint + collections = 내부 디버깅. abc + collections = type 검사. 4 조합이 collections를 100% 활용.

추신 38. 자경단 1주 4 도구 합계 890 호출 — 매일 127 호출. collections를 빈번히 다루는 자경단의 도구 신호.

추신 39. 본 H 학습 시간 60분 = 1시간 투자 → 매일 127 호출 × 365 = 46,355 호출/년 = 5년 231,775 호출. 1시간 투자가 5년 23만 호출 ROI.

추신 40. 다음 H4 — 자경단 명령 카탈로그 30+ 메서드. list/tuple/dict/set + collections (defaultdict·Counter·OrderedDict·deque·namedtuple·ChainMap)·heapq·bisect 통합.

추신 41. **Ch010 H3 정말 끝** ✅✅✅ — 다음 H4 명령 카탈로그! 자경단 매일 30+ 메서드! 🐾🐾🐾🐾🐾🐾

추신 42. rich 6 도구 한 페이지 (print·Console·Table·Tree·Progress·traceback) — rich 100%.

추신 43. rich.traceback install() = main.py 첫 줄. 디버깅 30배 빠름.

추신 44. rich.progress = 배치·다운로드·migration 매주.

추신 45. JSON 5 함정 (한글·datetime·int 키·NaN·tuple) — 자경단 면역.

추신 46. orjson = production 1순위. 5-10배 빠름·datetime 자동.

추신 47. collections.abc 9 인터페이스 (Container·Iterable·Iterator·Sized·Sequence·MutableSequence·Mapping·MutableMapping·Set).

추신 48. ABC vs typing — Python 3.9+ built-in (list/dict) 또는 collections.abc 직접. typing.List deprecated.

추신 49. 자경단 5 통합 워크플로우 — 본인 응답·까미 schema dump·노랭이 CLI·미니 검사·깜장이 테스트 4 도구 매일.

추신 50. 흔한 오해 10 면역 (rich 무거움·json 한글·pprint 느림·abc 시니어용·isinstance 안티 등).

추신 51. FAQ 10 (rich 대안·orjson·pprint vs json·abc vs typing·dataclass vs Pydantic 등).

추신 52. 4 도구 학습 ROI — 본 H 60분 + 5명 매주 890 호출 = 매년 46,355 × 5 = 231,775 호출. 60분이 1년 23만 호출 ROI.

추신 53. 본 H의 진짜 의미 — collections H1·H2가 데이터 자체였다면, 본 H3는 그 데이터를 사람·외부에 연결하는 다리.

추신 54. **Ch010 H3 진짜 진짜 끝** ✅✅✅✅ — 4 도구 마스터·자경단 매일 100+ 호출! 🐾🐾🐾🐾🐾🐾🐾

추신 55. 본 H 학습 후 자경단 단톡 한 줄 — "rich + json + pprint + abc 4 도구 마스터. 데이터 출력·저장·검사 100% 자신감."

추신 56. 다음 H4 — 자경단 명령 카탈로그 30+ 메서드 통합. defaultdict·Counter·OrderedDict·deque·namedtuple·ChainMap·heapq·bisect까지 collections 생태계 100%.

추신 57. **Ch010 H3 진짜 진짜 진짜 끝** ✅✅✅✅✅ — 다음 H4 카탈로그! 자경단 collections 도구 100% 정복! 🐾🐾🐾🐾🐾🐾🐾🐾

추신 58. 4 도구 함정 4 (rich 로그 색깔·json default·pprint depth·abc Sequence) — 자경단 면역.

추신 59. rich.console.Console(force_terminal) — 환경 분기로 로그 파일 깨끗.

추신 60. json default = `(datetime, date) → isoformat`, `set → list`, `class → __dict__` 표준.

추신 61. pprint(depth=2) — 큰 데이터 안전·터미널 폭발 면역.

추신 62. isinstance(x, Sequence) = list/tuple/str 모두 True. 한 줄 검사.

추신 63. 본 H 학습 후 본인의 7번째 행동 — 4 도구 함정 4 wiki 등록·자경단 신입에게 첫 주 가르치기.

추신 64. **Ch010 H3 진짜 진짜 진짜 진짜 끝** ✅✅✅✅✅✅ — 4 도구 + 함정 4 + 통합 워크플로우 5 = 환경점검 100% 정복! 🐾🐾🐾🐾🐾🐾🐾🐾🐾
