# Ch012 · H4 — 예외·파일 패턴 카탈로그 — 30+ 예외와 20+ 패턴

> 고양이 자경단 · Ch 012 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 왜 카탈로그인가 — 사고에 1초 처방
3. 자주 만나는 예외 열다섯
4. 가끔 만나는 예외 열다섯
5. 파일 처리 패턴 — 안전 읽기·청크·안전 쓰기
6. 디렉토리 패턴 다섯
7. JSON·CSV 패턴 다섯
8. 자경단 까미의 매일 한 흐름
9. 다섯 함정과 처방
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 일곱 가지
12. 흔한 실수 다섯 + 안심
13. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
# 안전 읽기
def safe_read(path, default=""):
    try:
        return Path(path).read_text(encoding="utf-8")
    except FileNotFoundError:
        return default
# 안전 쓰기 (atomic)
tmp = Path("out.json.tmp")
tmp.write_text(data, encoding="utf-8")
tmp.rename("out.json")    # 한 번에 교체
```

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요. 벌써 네 번째 시간이에요. 본인이 오늘도 빠짐없이 와 주셨네요. 정말 반가워요.

지난 H3를 한 줄로 회수할게요. I/O 도구 다섯 개 — pathlib, logging, rich.traceback, io, traceback — 를 손에 넣었죠. "사고는 짐작하지 말고 도구로 보라", "except에선 log.exception"을 배웠어요. 이제 본인은 사고를 보는 눈과 도구가 있어요. 그럼 오늘은 뭘 할까요? 그 도구로 다룰 **진짜 예외와 파일 패턴**을 한자리에 모아요.

오늘의 약속은 이거예요. **본인이 매일 만나는 사고와 파일 작업에 1초 처방을 갖춥니다**. 매 챕터의 네 번째 시간은 카탈로그예요. Ch011에서 정규식 패턴 30개를 모았듯, 이번엔 예외 30개 이상과 파일 패턴 20개 이상을 모아요. 자주 만나는 예외, 안전하게 파일 읽고 쓰는 패턴, JSON·CSV 다루기까지요. 본인이 파일로 하는 일의 거의 전부예요.

오늘도 마음 편하게 들으세요. 예외 30개를 다 외우라는 게 아니에요. "이런 사고들이 있다"를 한 번 훑고, 자주 만나는 열다섯 개의 이름과 뜻만 알아 두면 돼요. 파일 패턴도 마찬가지예요. 한 번 만들어 두고, 필요할 때 여기서 꺼내 쓰는 거죠. 특히 오늘 배우는 "안전 쓰기(atomic write)" 패턴은 본인의 데이터를 지켜 주는 보물이에요. 자, 가요.

---

## 2. 왜 카탈로그인가 — 사고에 1초 처방

본격적으로 보기 전에, 왜 예외와 패턴을 카탈로그로 모으는지 짚을게요.

실무에서 본인이 만나는 사고의 90%는 "전에 본 사고"예요. FileNotFoundError, KeyError, ValueError — 이런 건 매일 만나죠. 그리고 파일 작업도 비슷해요. 설정 읽기, 결과 저장하기, JSON 다루기 — 매번 새로 짜는 게 아니라, 한 번 잘 짜 둔 패턴을 재사용해요. 그래서 고수들은 예외 이름을 외우는 게 아니라, "이 사고엔 이 처방"을 카탈로그로 가지고 있어요. 사고가 나면 그 카탈로그에서 처방을 1초에 꺼내는 거죠.

오늘 본인이 만들 게 바로 그 카탈로그예요. 예외 쪽은 "어떤 사고가 어떤 뜻인지"를, 파일 쪽은 "이런 작업은 이렇게 한다"를 모아요. 이 두 가지를 알면, 사고가 나도 당황하지 않아요. "아, 이건 FileNotFoundError니 파일 경로 문제구나", "큰 파일을 처리해야 하니 청크로 읽어야겠다" 하고 바로 처방을 떠올리죠. 막막함이 구체적인 대처로 바뀌는 거예요.

그리고 카탈로그가 있으면 좋은 점이 또 있어요. 한 번 검증한 패턴을 재사용하니까 실수가 줄어요. 예를 들어 "안전 쓰기"를 매번 새로 짜면, 어떤 날은 encoding을 빼먹고 어떤 날은 임시 파일 위치를 틀려요. 그런데 한 번 잘 만든 atomic_write 함수를 카탈로그에 두고 계속 쓰면, 그 함수가 항상 똑같이 안전하게 동작하죠. 좋은 코드를 한 번 짜서 평생 쓰는 거예요. 그래서 시니어 개발자일수록 자기만의 도구 모음이 두툼해요. 매번 처음부터 짜는 게 아니라, 검증된 걸 꺼내 쓰거든요. 본인도 오늘부터 그 모음을 만들기 시작하는 거예요.

그리고 한 가지 중요한 게 있어요. 오늘 배우는 파일 패턴 중에는 "데이터를 안전하게 지키는" 패턴들이 있어요. 안전 쓰기(atomic write), 백업 후 쓰기 같은 거요. 파일을 다루다 보면 데이터가 깨질 위험이 있거든요. 쓰다가 프로그램이 죽으면 파일이 반쯤 쓰인 채 망가지죠. 그런 사고에서 데이터를 지키는 게 이 패턴들이에요. 사용자의 소중한 데이터를 지키는 건 개발자의 책임이고, 그 책임을 다하는 도구가 오늘 카탈로그에 있어요. 자, 하나씩 열어 볼게요.

---

## 3. 자주 만나는 예외 열다섯

먼저 예외예요. 본인이 매일 만나는 열다섯 개를 봐요.

```python
ValueError            # 값이 이상함 (예: int("abc"))
TypeError             # 타입이 이상함 (예: "a" + 1)
KeyError              # dict에 키가 없음
IndexError            # list 범위를 벗어남
AttributeError        # 객체에 그 속성/메서드 없음
NameError             # 정의 안 된 변수 사용
ImportError           # import 실패
ModuleNotFoundError   # 모듈을 못 찾음
FileNotFoundError     # 파일이 없음
PermissionError       # 권한이 없음
ZeroDivisionError     # 0으로 나눔
RuntimeError          # 일반 런타임 사고
NotImplementedError   # 아직 구현 안 함
StopIteration         # iterator가 끝남
RecursionError        # 재귀가 너무 깊음
```

열다섯 개예요. 그런데 이름이 다 친절하죠? Ch012 H2에서 말했듯, 예외 이름이 무슨 사고인지 말해 줘요. ValueError는 "값이 이상하다", KeyError는 "키가 없다", FileNotFoundError는 "파일을 못 찾았다"예요. 그래서 이걸 다 외울 필요 없어요. 코드를 돌리다 에러가 나면, 그 이름만 보고 "아, 값이 이상하구나" 하고 짚으면 돼요.

이 중에 본인이 가장 자주 만날 다섯 개를 콕 짚을게요. ValueError(값 변환 실패 — "abc"를 숫자로), TypeError(타입 안 맞음 — 문자열에 숫자 더하기), KeyError(dict 키 없음 — Ch010의 그거), FileNotFoundError(파일 없음 — Ch012의 단골), AttributeError(None에 점 찍기 — `None.something`)예요. 특히 AttributeError가 흔해요. 함수가 None을 돌려줬는데 거기에 `.method()`를 부르면 나죠. "어, 분명 객체일 줄 알았는데 None이었네" 하는 사고예요. 이 다섯의 이름과 뜻만 알아 두면, 매일 만나는 사고의 대부분을 1초에 진단해요.

예외를 진단하는 법을 좀 더 구체적으로 드릴게요. 에러가 나면, 빨간 메시지의 **맨 마지막 줄**을 보세요. 거기에 `예외이름: 설명`이 있어요. 예를 들어 `KeyError: 'name'`이면 "name이라는 키를 dict에서 찾으려는데 없다"는 뜻이에요. `ValueError: invalid literal for int() with base 10: 'abc'`면 "abc를 int로 바꾸려는데 못 한다"는 거고요. 예외 이름이 "무슨 종류의 사고"인지, 그 뒤 설명이 "구체적으로 뭐가 문제"인지 알려줘요. 그리고 그 위 traceback(H3에서 배운)이 "어디서 났는지"를 보여주죠. 이 세 가지 — 이름·설명·위치 — 를 읽으면, 거의 모든 사고를 스스로 진단할 수 있어요. 에러 메시지를 무서워하지 말고 읽으세요. 친절한 안내문이에요.

그리고 이 예외들은 사실 본인이 앞 챕터들에서 이미 다 만났어요. KeyError는 Ch010 dict에서, ValueError는 Ch007 형 변환에서, IndexError는 list 인덱싱에서요. 그동안은 "에러가 났네" 하고 고쳤다면, 이제는 "아, 이건 KeyError고 dict 문제구나" 하고 이름으로 정확히 짚는 거예요. 같은 사고를 더 깊이 이해하는 거죠. 예외에 이름을 붙여 아는 것과 그냥 "에러"로 뭉뚱그려 아는 것은 큰 차이예요. 이름을 알면 처방이 정확해지거든요.

---

## 4. 가끔 만나는 예외 열다섯

다음은 가끔 만나는 열다섯 개예요. 자주는 아니지만, 알아 두면 만났을 때 안 당황해요.

```python
ConnectionError       # 네트워크 연결 끊김
TimeoutError          # 시간 초과
IsADirectoryError     # 파일인 줄 알았는데 폴더
NotADirectoryError    # 폴더인 줄 알았는데 파일
UnicodeDecodeError    # 인코딩 깨짐 (읽기)
UnicodeEncodeError    # 인코딩 깨짐 (쓰기)
MemoryError           # 메모리 부족
KeyboardInterrupt     # 사용자가 Ctrl+C
SystemExit            # sys.exit() 호출
EOFError              # 입력이 끝남
JSONDecodeError       # JSON 형식이 깨짐
OverflowError         # 숫자가 너무 큼
BlockingIOError       # 비차단 I/O 사고
FloatingPointError    # 부동소수점 사고
StopAsyncIteration    # async iterator 끝
```

열다섯 개 더예요. 이건 "이런 게 있다"만 알아 두면 돼요. 외울 필요 없어요. 그런데 이 중에 I/O와 직접 관련된 걸 짚을게요. UnicodeDecodeError(파일 읽는데 한글 깨짐 — encoding 문제), ConnectionError·TimeoutError(네트워크 작업), JSONDecodeError(JSON 파일이 깨짐), IsADirectoryError(파일 경로인 줄 알았는데 폴더였음)예요. 파일을 다루다 이런 게 나오면, 이름을 보고 처방을 떠올리세요. UnicodeDecodeError면 encoding을 확인하고, JSONDecodeError면 JSON 형식을 보고요.

그리고 H2에서 말한 두 개를 다시 짚을게요. KeyboardInterrupt(Ctrl+C)와 SystemExit예요. 이 둘은 BaseException의 자식이라, `except Exception`으로 안 잡혀요. 일부러 그렇게 만든 거예요. 본인이 Ctrl+C로 프로그램을 멈추려는데 코드가 그걸 잡아 무시하면 안 되니까요. 그래서 이 둘은 "잡지 않는 게 정상"이에요. 예외에도 "잡을 것"과 "잡지 말 것"이 있다는 걸 기억하세요. 우리가 잡는 건 Exception과 그 아래예요.

---

## 5. 파일 처리 패턴 — 안전 읽기·청크·안전 쓰기

이제 파일 패턴이에요. 본인이 평생 쓸 핵심 패턴들을 봐요. 먼저 가장 중요한 셋이에요.

```python
from pathlib import Path

# 1. 안전 읽기 — 없으면 기본값
def safe_read(path, default=""):
    try:
        return Path(path).read_text(encoding="utf-8")
    except FileNotFoundError:
        return default

# 2. 큰 파일 — 한 줄씩 (메모리 안전)
with open("huge.log", encoding="utf-8") as f:
    for line in f:
        process(line.strip())

# 3. 안전 쓰기(atomic) — 데이터 안 깨짐
def atomic_write(path, content):
    tmp = Path(str(path) + ".tmp")
    tmp.write_text(content, encoding="utf-8")
    tmp.rename(path)   # 한 번에 교체!
```

이 셋이 핵심이에요. **안전 읽기**는 H2에서 본 패턴이에요. 파일이 없으면 죽지 말고 기본값을 쓰는 거죠. **큰 파일은 한 줄씩**도 H2에서 배웠어요. read_text로 다 읽지 말고 for line으로 스트리밍하는 거예요.

세 번째 **안전 쓰기(atomic write)**가 오늘의 보물이에요. 이게 왜 중요한지 설명할게요. 파일에 직접 쓰다가 프로그램이 중간에 죽으면, 파일이 "반쯤 쓰인" 상태로 망가져요. 사용자의 원본 데이터가 깨지는 거죠. 그래서 안전 쓰기는 이렇게 해요. 먼저 임시 파일(.tmp)에 다 쓰고, 다 됐으면 그걸 진짜 이름으로 **한 번에 바꿔요**(rename). rename은 운영체제가 "끊기지 않는 한 동작"으로 보장하거든요. 그래서 쓰다 죽으면 임시 파일만 망가지고, 진짜 파일은 멀쩡해요. 다 쓰여야만 교체되니까요. 까미가 중요한 설정 파일을 저장할 때 항상 이 패턴을 써요. "쓰다 죽어도 원본은 안전"이 데이터를 지키는 핵심이에요.

이 atomic이라는 말을 풀어 볼게요. "더 이상 쪼갤 수 없는"이라는 뜻이에요. rename은 "되거나 안 되거나" 둘 중 하나지, "반쯤 되는" 게 없어요. 그래서 그 순간 파일은 옛날 내용이거나 새 내용이지, 절대 "반쯤 섞인" 상태가 안 돼요. 이게 데이터 안전의 핵심 개념이에요. 직접 쓰기는 한 글자 한 글자 써 내려가니까 중간에 죽으면 반쯤 쓰인 게 남죠. 그런데 atomic write는 "완성된 임시 파일을 한 번에 교체"하니까, 중간 상태가 없어요. 은행 송금을 생각해 보세요. 돈이 빠져나가고 안 들어가는 "반쯤 상태"가 있으면 큰일이죠. 그래서 송금도 atomic하게 처리해요. 데이터를 다루는 모든 진지한 시스템이 이 atomic 개념을 써요. 본인이 오늘 그 개념을 파일에서 배운 거예요. 나중에 데이터베이스(트랜잭션)에서 또 만나는데, 뿌리가 같아요.

그리고 한 가지 디테일. 임시 파일은 진짜 파일과 **같은 폴더**에 만들어야 해요. rename이 같은 디스크 안에서만 "한 번에" 보장되거든요. 다른 디스크로 옮기는 건 사실 복사라서 atomic이 깨져요. 그래서 `with_suffix(".tmp")`처럼 같은 위치에 임시 파일을 두는 거예요. 작은 디테일이지만, 이걸 알면 atomic write를 제대로 써요. 까미도 처음엔 임시 파일을 다른 폴더에 뒀다가 이 함정에 빠진 적이 있어요. 같은 폴더에 두는 게 정답이에요.

나머지 파일 패턴들도 빠르게 봐요.

```python
# 백업 후 쓰기 — 원본을 .bak으로 보관
import shutil
def write_with_backup(path, content):
    if Path(path).exists():
        shutil.copy(path, str(path) + ".bak")
    Path(path).write_text(content, encoding="utf-8")

# 마지막 N줄 (tail)
def tail(path, n=10):
    with open(path, encoding="utf-8") as f:
        return f.readlines()[-n:]

# 줄 수 세기 (메모리 안전)
def line_count(path):
    with open(path, encoding="utf-8") as f:
        return sum(1 for _ in f)
```

백업 후 쓰기는 원본을 .bak으로 복사해 두고 쓰는 거예요. 안전 쓰기와 짝이죠. tail은 로그 파일의 마지막 몇 줄을 보는 거고(셸의 tail 명령처럼), line_count는 줄 수를 세는데 `sum(1 for _ in f)`로 한 줄씩 세서 메모리에 안전해요. 이 패턴들을 patterns.py 같은 데 모아 두면, 본인의 파일 처리 도구함이 돼요.

line_count의 `sum(1 for _ in f)`를 잠깐 음미해 보세요. 파일을 한 줄씩 돌면서, 각 줄마다 1을 더하는 거예요. Ch008의 제너레이터 표현식과 Ch010의 sum이 만났죠. `for _ in f`는 "각 줄(내용은 안 쓰니 언더스코어)마다", `1`은 "1을 세고", `sum`은 "다 더해요". 결국 줄 개수가 나오죠. 그런데 핵심은, 이게 파일을 메모리에 통째로 안 올린다는 거예요. `len(f.readlines())`는 모든 줄을 list로 만들어 메모리에 올리지만, `sum(1 for _ in f)`는 한 줄씩 세고 버려서 10GB 파일도 안전해요. 같은 "줄 수 세기"인데, 메모리 사용이 하늘과 땅이죠. 보세요, 앞 챕터들에서 배운 게 이렇게 우아한 한 줄로 합쳐져요. 입문 트랙의 도구들이 다 연결되어 있다는 게 이런 데서 느껴지죠.

이 파일 패턴들에 공통으로 흐르는 정신이 "메모리 안전"과 "데이터 안전"이에요. 큰 파일을 한 줄씩 읽는 건 메모리 안전, atomic write와 백업은 데이터 안전이죠. 이 둘이 견고한 파일 처리의 두 기둥이에요. 작은 파일, 안 죽는 환경에선 신경 안 써도 되지만, 진짜 서비스에선 파일이 크고 프로그램이 죽을 수 있으니 이 두 가지를 챙겨야 해요. 본인이 이 패턴들을 손에 익히면, 어떤 파일도 메모리 걱정 없이, 데이터 걱정 없이 다뤄요. 그게 production 개발자의 파일 처리예요.

---

## 6. 디렉토리 패턴 다섯

폴더를 다루는 다섯 패턴이에요. H3에서 본 pathlib가 여기서 일해요.

```python
from pathlib import Path

# 1. 폴더 만들기 (이미 있어도 OK, 중간 폴더까지)
Path("data/logs").mkdir(parents=True, exist_ok=True)

# 2. 폴더 안 파일만 순회
for f in Path("data").iterdir():
    if f.is_file():
        process(f)

# 3. 하위 폴더까지 재귀로 찾기
for f in Path("data").rglob("*.json"):
    process(f)

# 4. 빈 폴더인지 확인
if not any(Path("data").iterdir()):
    print("비었어요")

# 5. 폴더 통째로 삭제 (위험!)
import shutil
shutil.rmtree("temp", ignore_errors=True)
```

다섯 패턴이에요. 폴더 만들기는 `mkdir(parents=True, exist_ok=True)`가 공식이에요. parents는 중간 폴더까지 만들고, exist_ok는 이미 있어도 에러 안 내요. 결과를 저장하기 전에 폴더가 없으면 이걸로 먼저 만들면 사고를 막죠. 순회는 iterdir(바로 아래)과 rglob(하위까지)을 H3에서 봤어요. 그리고 빈 폴더 확인 `any(Path("data").iterdir())`도 유용해요. any는 "하나라도 있으면 True"니까, `not any(...)`는 "하나도 없으면", 즉 "비었으면"이에요. Ch008에서 배운 any가 여기서 일하죠. 폴더가 비었는지 확인해서, 비었으면 지우거나 안내하는 데 써요.

특히 마지막 `shutil.rmtree`를 조심하라고 강조할게요. **이건 폴더와 그 안의 모든 걸 통째로 지워요.** 그것도 되돌릴 수 없어요. 셸의 `rm -rf`(Ch006에서 배운 그 위험한 명령)와 같아요. 그래서 rmtree를 쓸 땐 경로를 두 번, 세 번 확인하세요. 변수에 든 경로가 비어 있거나 잘못된 값이면, 엉뚱한 폴더가 통째로 날아가요. 실제로 이걸로 중요한 데이터를 날린 사고가 많아요. "강력한 도구일수록 조심"이 철칙이에요. 가능하면 rmtree 전에 "정말 이 경로가 맞나?"를 확인하는 코드를 한 줄 넣으세요.

유명한 사고 하나를 들려드릴게요. 옛날에 어떤 프로그램이 `rmtree(base + "/" + folder)`처럼 경로를 조합했는데, base 변수가 빈 문자열이고 folder도 비어서 결과가 그냥 "/"가 됐어요. 그래서 시스템 전체를 지우려 한 거죠. 변수가 예상과 다른 값일 때 이런 끔찍한 일이 생겨요. 그래서 강력한 삭제 명령 앞엔 안전장치를 둬요. "경로가 비었으면 멈춰", "경로가 특정 폴더 아래가 아니면 멈춰" 같은 거요. `if not folder: raise ValueError("경로가 비었어요")` 한 줄이 시스템을 구할 수 있어요. H2에서 배운 guard clause(입구에서 막기)와 raise가 여기서 안전장치가 되는 거죠. 파괴적인 작업일수록 그 앞에 문지기를 두세요. 이게 진짜 데이터를 지키는 프로의 자세예요.

---

## 7. JSON·CSV 패턴 다섯

마지막은 JSON과 CSV예요. 실무에서 데이터를 주고받는 가장 흔한 두 형식이죠.

```python
import json, csv
from pathlib import Path

# 1. JSON 읽기
data = json.loads(Path("data.json").read_text(encoding="utf-8"))

# 2. JSON 쓰기 (한글 안 깨지게!)
Path("out.json").write_text(
    json.dumps(data, ensure_ascii=False, indent=2),
    encoding="utf-8",
)

# 3. CSV 읽기 (헤더를 키로)
with open("data.csv", encoding="utf-8") as f:
    for row in csv.DictReader(f):
        print(row["name"], row["age"])

# 4. CSV 쓰기
with open("out.csv", "w", encoding="utf-8", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["name", "age"])
    writer.writeheader()
    writer.writerows(rows)
```

JSON은 Ch010에서 본 dict·list의 짝이에요. `json.loads`는 문자열을 dict로, `json.dumps`는 dict를 문자열로 바꾸죠. 여기서 **꼭 챙길 게 `ensure_ascii=False`**예요. 이걸 안 주면, 한글이 `자경` 같은 이상한 코드로 저장돼요. False를 줘야 한글이 한글로 예쁘게 저장되죠. `indent=2`는 보기 좋게 들여쓰기하고요. JSON 쓸 땐 "한글이면 ensure_ascii=False"가 철칙이에요.

CSV는 표 형태 데이터예요. 엑셀로 여는 그 형식이죠. `DictReader`는 첫 줄(헤더)을 키로 삼아서, 각 행을 dict로 줘요. `row["name"]`처럼 컬럼 이름으로 접근하죠. 그리고 CSV 쓸 땐 `newline=""`을 꼭 줘야 해요. 안 주면 윈도우에서 빈 줄이 사이사이 생기는 사고가 나거든요. "CSV 쓰기 = newline 빈 문자열"을 기억하세요. CSV는 쉬워 보이지만, 따옴표·줄바꿈·인코딩 함정이 많아서 직접 쪼개지 말고 꼭 csv 모듈을 쓰세요. Ch011의 split으로 직접 쪼개면 따옴표 안 쉼표 같은 데서 깨져요. 전용 도구가 있으면 그걸 쓰는 게 답이에요.

왜 CSV를 split으로 쪼개면 안 되는지 예를 들어 볼게요. CSV에서 값에 쉼표가 들어가면, 그 값을 따옴표로 감싸요. 예를 들어 `"서울, 강남구",10` 같은 줄이 있으면, 주소("서울, 강남구")가 한 값이고 10이 다른 값이에요. 그런데 이걸 `split(",")`로 쪼개면 "서울"과 " 강남구"와 "10" 세 개로 잘못 쪼개지죠. 따옴표 안의 쉼표를 구분자로 착각하는 거예요. csv 모듈은 이 따옴표 규칙을 다 알아서, 정확히 두 값으로 쪼개요. 이게 "전용 도구를 쓰는" 이유예요. CSV 형식은 보기보다 규칙이 복잡해서, 직접 처리하면 꼭 어딘가에서 깨져요. 바퀴를 다시 발명하지 말고, 검증된 csv 모듈에 맡기세요. Ch011 H6에서 "전용 라이브러리가 있으면 쓰라"고 한 게 여기서도 통해요.

JSON과 CSV의 쓰임을 한 번 정리할게요. JSON은 중첩된 복잡한 데이터(설정·API 응답)에 좋아요. dict 안에 list, list 안에 dict가 자유롭게 들어가니까요. CSV는 단순한 표 데이터(엑셀로 열 만한 것)에 좋고요. 행과 열이 딱 떨어지는 데이터요. 그래서 "설정이나 구조화된 데이터는 JSON, 표 형태 데이터는 CSV"로 가려 써요. 본인이 데이터를 저장할 때 "이게 표인가, 중첩 구조인가?"를 물으면 형식이 정해져요. 둘 다 Ch010의 dict·list와 자연스럽게 연결되고요. 파일에서 읽으면 dict나 list가 되고, dict나 list를 파일로 저장하죠. 자료구조와 파일이 이렇게 손을 잡아요.

---

## 8. 자경단 까미의 매일 한 흐름

오늘 배운 걸 한 흐름으로 모아 볼게요. 까미가 매일 하는 데이터 처리예요.

```python
from pathlib import Path
import json, logging
log = logging.getLogger(__name__)

# 1. 설정 읽기 (안전하게)
try:
    config = json.loads(Path("config.json").read_text(encoding="utf-8"))
except (FileNotFoundError, json.JSONDecodeError):
    config = {}

# 2. 데이터 처리 (큰 파일은 한 줄씩)
results = []
with open("data.csv", encoding="utf-8") as f:
    for row in csv.DictReader(f):
        results.append(process(row))

# 3. 결과 저장 (atomic write)
output = Path("result.json")
tmp = output.with_suffix(".tmp")
tmp.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")
tmp.rename(output)

# 4. 기록
log.info("처리 완료: %d개", len(results))
```

보세요. 오늘 배운 패턴이 한 흐름에 다 있어요. 설정을 안전하게 읽고(try/except), 큰 CSV를 한 줄씩 처리하고(for row), 결과를 atomic write로 안전하게 저장하고(tmp+rename), logging으로 기록하죠. 이게 실무 데이터 처리의 전형적인 모습이에요. 입력 읽기 → 처리 → 안전하게 저장 → 기록. 그리고 H1~H3에서 배운 게 다 여기 모였어요. with, try/except, pathlib, json, logging이요. 챕터가 쌓여 하나의 일하는 코드가 되는 거예요.

여기서 한 가지 강조하고 싶은 게, 3번의 atomic write예요. `with_suffix(".tmp")`로 임시 파일 경로를 만들고, 거기에 쓴 뒤 rename으로 한 번에 교체하죠. 이 패턴 덕에, 처리 중 프로그램이 죽어도 기존 result.json은 안전해요. 새 결과가 완전히 쓰여야만 교체되니까요. 본인이 중요한 데이터를 저장할 땐, 이 atomic write를 습관으로 만드세요. 사용자의 데이터를 지키는 작은 배려가, 신뢰받는 서비스를 만들어요.

---

## 9. 다섯 함정과 처방

파일을 다루다 자주 빠지는 함정 다섯 개와 처방이에요. 앞에서 본 것들의 요약이에요.

**함정 1: encoding을 빼먹어서 한글 깨짐.** 처방은 모든 open과 read_text/write_text에 `encoding="utf-8"`. 텍스트 사고 1순위예요. Ch011 H6부터 계속 강조한 그거죠. 이제 거의 외웠을 만큼 들었으니, 손이 알아서 utf-8을 칠 거예요.

**함정 2: with를 빼먹어서 자원이 샘.** 처방은 파일은 무조건 `with open` 또는 pathlib의 read_text/write_text. 자동으로 닫히게요.

**함정 3: 큰 파일을 read_text로 통째로 읽어 메모리 터짐.** 처방은 for line으로 한 줄씩, 또는 청크로 읽기. "이 파일이 커질 수 있나?"를 늘 생각하세요.

**함정 4: 파일에 직접 써서 죽으면 데이터 깨짐.** 처방은 atomic write(tmp에 쓰고 rename). 중요한 데이터엔 꼭이요. 데이터를 지키는 패턴이에요. 특히 사용자가 만든 데이터(작성한 글·설정)를 저장할 땐 반드시 atomic으로요. 한 번 날리면 사용자의 시간과 신뢰를 잃거든요.

**함정 5: except를 비워서 사고를 삼킴.** 처방은 구체적 예외로 잡고 log.exception으로 기록. `except: pass`는 가장 나쁜 코드예요.

다섯 함정의 공통점이 보이죠. 대부분 "사고를 미리 안 챙겨서" 생겨요. encoding, with, 큰 파일, 안전 쓰기, 예외 기록. 이걸 처음부터 챙기면, 실전에서 파일 사고를 거의 안 겪어요. 그리고 막혔을 땐 H3의 logging으로 기록해 두면, 다음에 더 잘 대비할 수 있어요. 카탈로그와 처방이 손에 있으면, 사고가 무섭지 않아요.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 예외 30개를 다 외워야 한다.**

아니에요. 자주 만나는 다섯 개(ValueError·TypeError·KeyError·FileNotFoundError·AttributeError)면 80%예요. 나머지는 이름을 보고 뜻을 짐작하면 돼요. 예외 이름이 친절하니까요. 외우는 게 아니라 읽는 거예요. 그리고 새 예외를 만나면, 그 이름을 검색하면 1분이면 뜻이 나와요. 외우려 애쓰지 말고, 만날 때 읽고 처리하면 돼요.

**오해 2: 큰 파일도 read_text로 읽으면 된다.**

아니에요. 큰 파일을 통째로 읽으면 메모리가 터져요. for line으로 한 줄씩, 또는 청크로 읽으세요. "이 파일이 10GB면?"을 늘 상상하세요. 작은 파일만 read_text예요.

**오해 3: JSON은 항상 dict다.**

아니에요. JSON의 최상위가 list일 수도, 숫자나 문자열일 수도 있어요. `[1, 2, 3]`도 유효한 JSON이죠. 그래서 json.loads의 결과가 항상 dict라고 가정하면 사고가 나요. 받은 게 뭔지 확인하고 다루세요. 특히 외부 API에서 받은 JSON은 형태를 장담할 수 없으니, `isinstance(data, dict)`로 확인하거나 try/except로 감싸는 게 안전해요. "외부에서 온 데이터는 의심하라"는 H1의 정신이 여기서도 통해요.

**오해 4: CSV는 쉬워서 직접 쪼개도 된다.**

아니에요. CSV엔 따옴표 안 쉼표, 줄바꿈이 든 값 같은 함정이 많아요. `split(",")`로 직접 쪼개면 그런 데서 깨져요. 꼭 csv 모듈을 쓰세요. 전용 도구가 그 함정을 다 처리해 줘요.

**오해 5: shutil.rmtree는 편하게 써도 된다.**

아니에요. 통째로 지우고 되돌릴 수 없어요. 경로가 잘못되면 엉뚱한 데가 날아가요. rm -rf만큼 위험해요. 경로를 꼭 확인하고, 신중하게 쓰세요.

다섯 오해의 공통점은 "파일 작업을 만만하게 보는" 거예요. 그런데 파일은 사용자의 데이터고, 한 번 날리면 못 되돌려요. 그래서 신중하게, 안전 패턴을 써서 다뤄야 해요. 오늘 배운 카탈로그가 그 신중함의 도구예요. 만만하게 보지 않는 그 태도가, 사실 가장 큰 안전장치예요.

---

## 11. 자주 받는 질문 일곱 가지

**Q1. read_text랑 open().read() 중 뭘 써요?**

같은 일을 해요. read_text가 더 짧죠(with 없이 한 줄). 작은 파일을 통째로 읽을 땐 read_text가 편해요. 큰 파일을 한 줄씩 처리할 땐 with open + for line이고요. 상황에 맞게 가려 쓰면 돼요. 짧게는 read_text, 스트리밍은 open.

**Q2. JSON에 한글을 저장하면 깨져요.**

`ensure_ascii=False`를 안 줘서예요. json.dumps에 이걸 주면 한글이 한글로 저장돼요. 안 주면 `자` 같은 코드로 저장되죠(깨진 건 아니고 읽기 힘든 것). 한글 JSON엔 무조건 `ensure_ascii=False`예요. 그리고 `indent=2`로 보기 좋게 들여쓰기도 하고요.

**Q3. CSV에 헤더가 있으면 어떻게 다뤄요?**

`csv.DictReader`를 쓰세요. 첫 줄을 헤더(키)로 삼아서, 각 행을 dict로 줘요. `row["name"]`처럼 컬럼 이름으로 접근하니 읽기 좋죠. 쓸 땐 `csv.DictWriter`로 `writeheader()` 후 `writerows()`예요. 헤더가 있는 CSV엔 Dict 버전이 편해요.

**Q4. atomic write가 정말 안전한가요?**

네, rename이 운영체제 차원에서 "끊기지 않는 동작"으로 보장돼요(유닉스 계열). 그래서 임시 파일에 다 쓰고 rename하면, 그 순간 진짜 파일이 완전히 교체되죠. 쓰다 죽으면 임시 파일만 망가지고 원본은 안전해요. 다만 윈도우는 미묘하게 다른 부분이 있으니, 정말 중요한 데이터는 라이브러리(예: 전용 atomic write 도구)를 쓰기도 해요. 기본 패턴으로는 tmp+rename이면 충분해요.

**Q5. 정말 큰 파일은 어떻게 다뤄요?**

for line으로 한 줄씩이 기본이에요. 바이너리 파일이거나 줄 개념이 없으면 청크로 읽고요(`f.read(4096)`을 반복). 더 극단적이면 mmap(메모리 매핑)이라는 고급 기법도 있는데, 그건 정말 필요할 때 찾으면 돼요. 핵심은 "전체를 메모리에 안 올린다"예요. 한 줄씩, 한 조각씩 처리하는 거죠. 그리고 큰 파일을 처리할 땐 결과도 한 번에 모으지 말고, 처리하면서 바로바로 출력 파일에 쓰는 게 좋아요. 입력도 스트리밍, 출력도 스트리밍하면 메모리가 작아도 무한히 큰 데이터를 처리해요. 이게 빅데이터 처리의 기본 원리예요.

**Q6. 이 패턴들을 어떻게 정리해요?**

자주 쓰는 패턴(safe_read·atomic_write 등)을 본인의 utils.py나 io_helpers.py 같은 파일에 모으세요. Ch011에서 patterns.py를 만든 것처럼요. 그러면 새 프로젝트마다 그걸 가져다 쓸 수 있어요. 안전 읽기, 안전 쓰기 같은 패턴은 어느 프로젝트에서나 필요하니, 한 번 잘 만들어 두면 평생 자산이에요.

**Q7. 이미 만들어진 안전 쓰기 라이브러리는 없나요?**

있어요. 정말 중요한 데이터를 다룬다면 검증된 라이브러리를 쓰는 게 더 안전할 수 있어요. atomic write를 제대로 하려면 디스크 동기화(fsync) 같은 디테일까지 챙겨야 하는데, 전용 라이브러리가 그걸 다 해 주거든요. 다만 일상적인 작업엔 오늘 배운 tmp+rename 패턴이면 충분해요. "기본 패턴으로 90%, 정말 중요한 건 전용 라이브러리"로 가려 쓰면 돼요. 핵심은 atomic이라는 개념을 이해하는 거고, 그걸 직접 짜든 라이브러리를 쓰든 같은 원리예요. 오늘 그 원리를 배운 게 가장 값져요.

---

## 12. 흔한 실수 다섯 + 안심 — 카탈로그 학습 편

**첫째, 예외 30개를 한 번에 외우려다 지치기.** 안심하세요. 자주 만나는 다섯 개부터예요. 나머지는 이름을 읽으면 뜻이 보여요. 외우지 말고 카탈로그에 두세요.

**둘째, encoding을 매번 깜빡하기.** 안심하세요. "파일 = encoding utf-8"을 반사 신경으로. 이 한 줄이 한글 사고를 막아요. 카탈로그의 모든 패턴에 이미 들어 있어요.

**셋째, atomic write를 시니어 도구로 여기기.** 안심하세요. tmp에 쓰고 rename, 두 줄이에요. 중요한 데이터를 저장할 땐 이 두 줄이면 안전해요. 신입도 쓸 수 있어요.

**넷째, JSON 한글이 깨진다고 당황하기.** 안심하세요. `ensure_ascii=False` 한 옵션이면 끝이에요. 깨진 게 아니라 읽기 힘든 코드로 저장된 거고, 이 옵션이 한글로 예쁘게 만들어요.

**다섯째, 가장 큰 함정 — 큰 파일을 read_text로 통째로 읽기.** 안심하세요. for line으로 한 줄씩 읽으면 10GB도 안전해요. "이 파일이 커질 수 있나?"를 묻고, 그렇다면 스트리밍하세요. 이 습관 하나가 메모리 사고를 평생 막아요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 가요. 이 다섯을 보면, 결국 "안전"이라는 한 단어로 모여요. 인코딩 안전(한글), 자원 안전(with), 메모리 안전(스트리밍), 데이터 안전(atomic), 진단 안전(기록). 파일을 다루는 건 사용자의 데이터를 다루는 거라, 모든 게 안전으로 통해요. 화려한 기능보다 이 안전을 챙기는 게, 신뢰받는 코드를 짜는 길이에요. 본인이 오늘 이 다섯 안전을 손에 넣었으니, 이제 파일을 다룰 때 자연스럽게 이것들을 챙기게 돼요. 처음엔 의식하며 챙기다가, 곧 손이 알아서 안전 패턴으로 가요.

---

## 13. 마무리

자, 네 번째 시간이 끝났어요. 오늘 본인은 예외·파일 패턴 카탈로그를 손에 넣었어요.

예외 30개(자주 만나는 15 + 가끔 15), 파일 처리 패턴(안전 읽기·청크·안전 쓰기·백업·tail), 디렉토리 패턴 다섯, JSON·CSV 패턴 다섯까지요. 그리고 까미의 하루 흐름에서 이것들이 함께 일하는 것도 봤어요. 안전 쓰기로 데이터를 지키는 법, JSON에 한글을 예쁘게 저장하는 법, 큰 파일을 안전하게 처리하는 법까지 다 카탈로그에 담았죠.

한 가지만 기억하세요. **외우지 말고 모아 두고, 데이터를 안전하게 지켜라.** 예외는 외우는 게 아니라 이름을 읽는 거고, 파일 패턴은 카탈로그에서 꺼내 쓰는 거예요. 그리고 그중 가장 중요한 건 "데이터를 지키는" 패턴이에요. atomic write로 쓰다 죽어도 원본을 지키고, 안전 읽기로 파일이 없어도 안 무너지고, encoding으로 한글을 지키고. 본인이 다루는 건 사용자의 소중한 데이터예요. 그걸 지키는 게 개발자의 책임이고, 오늘 그 도구들을 손에 넣었어요.

다음 H5는 드디어 만드는 시간이에요. file_processor라는 도구를 30분 만에 만들어요. 여러 파일을 읽어 처리하고, 사고를 우아하게 다루고, 결과를 안전하게 저장하는 진짜 도구를요. 오늘 배운 패턴들을 다 동원해서요. 그 전에 마지막으로 한 줄만 쳐 보세요.

```python
python3 -c "from pathlib import Path; print(list(Path('.').glob('*.md')))"
```

현재 폴더의 모든 .md 파일이 list로 나와요. 오늘 배운 glob이 한 줄에 있죠. 그리고 그 list의 각 요소는 Path 객체라서, 바로 `.read_text()`로 읽을 수 있어요. 찾고 읽는 게 자연스럽게 이어지죠. 본인이 이 결과를 보면, 오늘 카탈로그의 한 조각을 손에 쥔 거예요.

마지막으로 부탁 하나. 강의를 끄고, 빈 파일 `io_helpers.py`를 만드세요. 그리고 오늘 배운 패턴 중에 본인이 당장 쓸 것 같은 셋 — safe_read, atomic_write, safe JSON 읽기 — 을 적어 두세요. 그게 본인의 파일 처리 카탈로그 첫 페이지예요. Ch011의 patterns.py에 이어, 또 하나의 자산이 생기는 거예요. 그리고 그 자산은 본인이 개발하는 내내 자라요. 이렇게 본인만의 도구 모음을 차곡차곡 쌓는 게, 1년 뒤 본인을 빠르고 견고한 개발자로 만들어요. 매번 처음부터 짜는 사람과, 검증된 걸 꺼내 쓰는 사람의 차이는 시간이 갈수록 벌어지거든요. 다음 시간에 또 봐요. 🐾

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - 예외 계층 자주: ValueError·TypeError·KeyError·IndexError·AttributeError·FileNotFoundError·PermissionError·OSError·JSONDecodeError. BaseException(KeyboardInterrupt·SystemExit) 잡지 말 것.
> - atomic write: tmp 쓰고 os.replace/Path.rename. POSIX rename 원자성 보장. 같은 파일시스템 내에서만. fsync로 디스크 동기화 강화.
> - 큰 파일: for line(텍스트)·iter(lambda: f.read(4096), b"")(바이너리)·mmap(랜덤 접근). 절대 read() 전체 금지.
> - JSON: json.dumps(ensure_ascii=False, indent=2). 한글·이모지 보존. json.JSONDecodeError 처리.
> - CSV: DictReader/DictWriter. open에 newline="". quoting=csv.QUOTE_MINIMAL 기본. 직접 split 금지.
> - shutil.rmtree·os.remove: 비가역. 경로 검증 필수. exception group(3.11+) except*.
> - 다음 H5 키워드: file_processor · 디렉토리 순회 · 안전 쓰기 · 예외 처리 · 통계 · 로깅.

---

## 추신

1. 실무 사고의 90%는 "전에 본 사고". 카탈로그에서 처방 꺼내기.
2. 예외 이름은 친절 — 읽으면 뜻이 보임. 맨 마지막 줄을 봐라.
3. 자주 다섯 — Value·Type·Key·FileNotFound·Attribute. 매일 만남.
4. AttributeError 흔함 — None에 점 찍기.
5. 가끔 만나는 15는 "이런 게 있다"만 알아 두기.
6. UnicodeDecodeError=인코딩, JSONDecodeError=JSON 깨짐.
7. KeyboardInterrupt·SystemExit는 잡지 말기(BaseException).
8. 안전 읽기 — 없으면 기본값(try/except).
9. 큰 파일은 for line — 10GB도 안전(메모리에 한 줄씩).
10. atomic write — tmp에 쓰고 rename. 쓰다 죽어도 원본 안전. 데이터의 보물.
11. rename은 OS 원자성 보장(같은 폴더). 완전히 쓰여야 교체.
12. 백업 후 쓰기 — 원본을 .bak으로.
13. mkdir(parents=True, exist_ok=True) 공식.
14. shutil.rmtree는 rm -rf만큼 위험. 경로 확인 + guard clause로 문지기.
15. JSON 한글 — ensure_ascii=False 필수(안 주면 코드로 저장).
16. json.dumps indent=2 — 보기 좋게.
17. CSV는 DictReader/DictWriter. 헤더를 키로.
18. CSV 쓰기 — newline="" 필수(윈도우 빈 줄 방지).
19. CSV 직접 split 금지 — 따옴표·줄바꿈 함정. csv 모듈.
20. JSON 최상위가 항상 dict는 아님(list·primitive도).
21. 까미 흐름 — 안전 읽기→스트리밍→atomic write→로그.
22. 데이터를 지키는 게 개발자 책임. 사용자의 시간과 신뢰.
23. 함정 다섯 — encoding·with·큰파일·atomic·빈 except.
24. except: pass는 최악. log.exception으로 기록.
25. 자주 쓰는 패턴은 io_helpers.py에 모으기.
26. 큰 파일 극단 — 청크 read(4096)·mmap.
27. read_text는 작은 파일, with open은 스트리밍.
28. 카탈로그는 외우는 게 아니라 꺼내 쓰는 것.
29. Ch012 H4 졸업장 — glob으로 .md 파일 찾기.
30. 다음 H5는 file_processor 30분 데모. 손으로 만들기. 바로 다음 시간에. 🐾
