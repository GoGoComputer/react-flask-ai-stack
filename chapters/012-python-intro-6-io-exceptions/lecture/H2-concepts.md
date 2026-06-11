# Ch012 · H2 — 파일 모드 + with + try/except/else/finally + 예외 계층

> 고양이 자경단 · Ch 012 · 2교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속
2. open 모드 일곱 가지
3. 파일 메서드 — 읽기·쓰기·이동
4. with 문 — context manager의 원리
5. try/except/else/finally 네 블록
6. 예외 계층 구조 — 가계도
7. raise와 사용자 정의 예외
8. pathlib — 경로를 객체로
9. 한 줄 분해 — 안전한 JSON 읽기
10. 흔한 오해 다섯 가지
11. 자주 받는 질문 일곱 가지
12. 흔한 실수 다섯 + 안심
13. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
with open("f.txt", "a", encoding="utf-8") as f:   # 추가 모드
    f.write("한 줄\n")
try:
    data = Path("data.json").read_text(encoding="utf-8")
except (FileNotFoundError, PermissionError) as e:  # 여러 예외 한 번에
    data = "{}"
```

---

## 1. 다시 만나서 반가워요 — H1 회수와 오늘의 약속

자, 안녕하세요. 벌써 두 번째 시간이에요. 본인이 오늘도 와 주셨네요. 정말 반가워요.

지난 H1을 한 줄로 회수할게요. 파일과 예외의 네 친구 — open·with·try·except — 를 만났고, "파일은 바깥세상이고, 바깥세상은 사고가 난다"는 걸 배웠죠. 그래서 with로 안전하게 열고, try/except로 사고에 대비하는 두 습관을 봤어요. H1 마지막에 제가 약속했어요. "H2에서 네 친구를 손에 쥔다"고요. 오늘이 그 시간이에요.

오늘의 약속은 이거예요. **본인이 모든 파일 모드와 예외 처리 패턴을 손에 박습니다**. H1이 지도였다면, H2는 연장을 손에 쥐는 시간이에요. 오늘 만질 게 여덟 개예요. 파일 모드, 파일 메서드, with의 원리, try/except/else/finally 네 블록, 예외 계층, raise, 사용자 정의 예외, 그리고 pathlib요. 많아 보이지만, 다 H1의 네 친구를 깊이 파는 거예요.

오늘도 마음 편하게 들으세요. 다 외우는 게 아니에요. 매일 쓰는 핵심만 손에 익히고, 나머지는 "이런 게 있다"를 알아 두면 돼요. 특히 오늘 배우는 예외 처리는 본인을 "안 무너지는 코드를 짜는 사람"으로 만들어 줘요. 그게 신입과 경력자를 가르는 실력이에요. 자, 가요.

---

## 2. open 모드 일곱 가지

먼저 파일을 여는 모드예요. H1에서 표로 봤는데, 이번엔 코드로 손에 익혀요.

```python
open("f.txt")              # r — 읽기 (기본)
open("f.txt", "r")         # r — 명시적 읽기
open("f.txt", "w")         # w — 쓰기 (기존 내용 다 지움!)
open("f.txt", "a")         # a — 추가 (끝에 덧붙임)
open("f.txt", "x")         # x — 새 파일만 (있으면 에러)
open("f.txt", "rb")        # rb — 바이너리 읽기
open("f.txt", "r+")        # r+ — 읽기+쓰기
```

일곱 모드예요. 그런데 매일 쓰는 건 `r`, `w`, `a` 세 개가 90%예요. 읽기, 덮어쓰기, 추가. 다시 강조하지만 `w`는 파일을 여는 순간 기존 내용을 통째로 지워요. 그래서 "추가하려다 w를 써서 다 날린" 사고가 흔하죠. 추가는 `a`예요. 그리고 `x`는 "파일이 있으면 에러"라서, 실수로 덮어쓰는 걸 막아 줘요. 중요한 파일엔 `w` 대신 `x`가 안전하죠.

그리고 open에는 모드 말고도 중요한 인자가 있어요.

```python
open("f.txt", encoding="utf-8")           # 인코딩 (필수!)
open("f.txt", "w", encoding="utf-8", newline="")  # 줄바꿈 제어
```

가장 중요한 게 `encoding="utf-8"`이에요. Ch011 H6에서 그렇게 강조한 그거예요. 텍스트 파일을 열 땐 무조건 utf-8을 명시하세요. 안 주면 OS마다 기본값이 달라서 한글이 깨져요. 이건 거의 반사 신경으로 만드세요. "파일을 연다 = with + encoding utf-8"이 한 세트예요. `newline` 인자는 CSV를 다룰 때 줄바꿈 문제를 막아 주는데, 그건 필요할 때 보면 돼요. 지금은 encoding 하나만 손에 박으세요. 다시 강조하지만, 이 한 줄을 빼먹는 게 한국 개발자가 가장 자주 겪는 파일 사고예요. 본인 맥에선 utf-8이 기본이라 안 줘도 되지만, 회사 윈도우 서버에선 cp949가 기본이라 한글이 와장창 깨지거든요. "내 컴퓨터에선 됐는데"의 대표 사례죠. 처음부터 항상 명시하는 습관을 들이면 평생 이 사고를 안 만나요.

---

## 3. 파일 메서드 — 읽기·쓰기·이동

파일 객체에는 메서드가 여럿 있어요. 읽기·쓰기·위치 이동으로 묶어 볼게요.

```python
with open("f.txt", encoding="utf-8") as f:
    f.read()         # 전체를 한 문자열로
    f.read(100)      # 100글자만
    f.readline()     # 한 줄만
    f.readlines()    # 모든 줄을 list로
```

읽기 메서드가 넷이에요. `read()`는 파일 전체를 한 문자열로 읽어요. 작은 파일엔 편하죠. 그런데 큰 파일(수 GB 로그)에 `read()`를 쓰면 메모리가 터져요. 그럴 땐 `readline()`으로 한 줄씩 읽거나, 더 좋은 방법이 있어요.

```python
with open("f.txt", encoding="utf-8") as f:
    for line in f:        # 한 줄씩, 메모리 효율적
        print(line.strip())
```

파일 객체를 for로 바로 돌리면, 한 줄씩 읽어요. 이게 큰 파일을 다루는 표준 방법이에요. 파일 전체를 메모리에 안 올리고, 한 줄 읽고 처리하고 버리고를 반복하죠. Ch008에서 배운 iterator의 원리예요. 미니가 수 GB 로그를 다룰 때 이 방법을 써요. `read()`로 다 읽으면 터지지만, `for line in f`는 아무리 큰 파일도 안전하거든요. 이거 하나가 큰 파일 처리의 비결이에요.

이 차이가 실전에서 얼마나 중요한지 숫자로 느껴 볼게요. 10GB짜리 로그 파일이 있다고 해 봐요. `f.read()`를 하면, Python이 그 10GB를 통째로 메모리에 올리려 해요. 그런데 본인 컴퓨터 메모리가 8GB라면? 프로그램이 메모리 부족으로 죽어요. 반면 `for line in f`는 한 번에 한 줄(몇십 바이트)만 메모리에 올리고 처리해요. 그래서 10GB든 100GB든, 메모리가 작아도 안전하게 처리하죠. "파일이 메모리보다 클 수 있다"는 게 실전의 현실이에요. 본인 컴퓨터에서 작은 파일로 테스트할 땐 read()도 잘 되지만, 진짜 서비스에서 큰 파일을 만나면 터져요. 그래서 "파일은 기본적으로 for line으로 읽는다"를 습관으로 들이면, 이 사고를 평생 안 만나요. 작은 파일이면 read()도 괜찮지만, "이게 커질 수 있나?"를 늘 생각하는 거예요.

쓰기 메서드도 봐요.

```python
with open("f.txt", "w", encoding="utf-8") as f:
    f.write("한 줄\n")           # 문자열 하나 쓰기
    f.writelines(["a\n", "b\n"]) # list를 줄들로 쓰기
```

`write`는 문자열 하나를 쓰고, `writelines`는 list의 각 요소를 이어 써요. 주의할 게, write는 자동으로 줄바꿈을 안 넣어요. 그래서 줄을 구분하려면 `\n`을 직접 붙여야 해요. 이거 깜빡하면 모든 게 한 줄로 붙어 버려요. 매일 쓰는 건 `read`(또는 for line)와 `write` 둘이에요. 나머지(seek로 위치 이동, tell로 위치 확인)는 가끔이니, "이런 게 있다"만 알아 두세요.

여러 줄을 쓸 때 깔끔한 방법을 하나 알려 드릴게요. list를 줄로 합쳐서 한 번에 쓰는 거예요. `f.write("\n".join(cat_names))`처럼요. Ch011에서 배운 join이 여기서 일하죠. 이름들을 줄바꿈으로 이어 한 문자열로 만든 뒤, 한 번에 쓰는 거예요. write를 여러 번 부르는 것보다 깔끔하고, 줄바꿈도 정확히 들어가요. 보세요, Ch011의 문자열 기법이 Ch012의 파일 쓰기와 자연스럽게 만나요. 문자열을 잘 다루면 파일도 잘 다루는 거예요. 두 챕터가 짝이라는 게 여기서도 보이죠.

그리고 한 가지 자주 만나는 함정. 파일에서 `for line in f`로 읽으면, 각 줄 끝에 줄바꿈(`\n`)이 그대로 붙어 와요. 그래서 보통 `line.strip()`으로 양쪽 공백과 줄바꿈을 깎아 내고 써요. 이거 깜빡하면 줄마다 빈 줄이 생기거나 비교가 안 맞아요. Ch011에서 배운 strip이 파일 읽기의 단짝인 거죠. "파일에서 한 줄 읽으면 strip"이 거의 한 세트예요. 작은 습관이지만, 이거 하나로 텍스트 처리 사고를 많이 줄여요.

---

## 4. with 문 — context manager의 원리

이제 H1에서 본 with를 깊이 파요. with가 어떻게 자동으로 파일을 닫는지, 그 원리를 봐요.

```python
with open("f.txt", encoding="utf-8") as f:
    content = f.read()
# 여기서 자동으로 f.close()가 불림 (에러가 나도!)
```

with의 비밀은 **context manager**라는 약속이에요. 어떤 객체가 "들어갈 때 할 일"과 "나올 때 할 일"을 정해 두면, with가 그걸 자동으로 불러 줘요. 파일의 경우, "들어갈 때"는 파일을 열고, "나올 때"는 파일을 닫죠. 그래서 with 블록을 벗어나면 자동으로 close가 불려요. 심지어 블록 안에서 에러가 나도, 나오는 길에 close가 불려요. 이게 핵심이에요. try/finally로 직접 close를 보장하는 걸, with가 깔끔하게 대신해 주는 거예요.

"에러가 나도 닫힌다"가 왜 그렇게 중요한지 짚을게요. 만약 with 없이 이렇게 짰다고 해 봐요. `f = open(...); data = f.read(); process(data); f.close()`. 그런데 가운데 `process(data)`에서 에러가 나면, 마지막 `f.close()`가 영영 안 불려요. 파일이 열린 채 방치되는 거죠. 이런 게 쌓이면 file descriptor가 새서 사고가 나요. with는 이걸 막아요. 블록 안 어디서 에러가 나든, 나오는 길에 무조건 close를 부르거든요. 그래서 with는 단순히 "편한 문법"이 아니라 "안전을 보장하는 장치"예요. 옛날엔 이걸 try/finally로 직접 짰는데, 코드가 길고 깜빡하기 쉬웠어요. with가 그걸 한 단어로 깔끔하고 확실하게 만든 거예요. 2007년에 with가 Python에 들어온 게(PEP 343) 그래서 큰 발전이었어요.

with의 진짜 강력함은 여러 자원을 동시에 다룰 때 나와요.

```python
with open("a.txt", encoding="utf-8") as fa, open("b.txt", "w", encoding="utf-8") as fb:
    fb.write(fa.read())   # a를 읽어서 b에 쓰기
```

한 with에 파일 두 개를 열었어요. a를 읽어서 b에 쓰는 거죠. 둘 다 블록이 끝나면 자동으로 닫혀요. 파일 복사 같은 일이 한 줄로 깔끔하죠. 그리고 with는 파일뿐 아니라 "열었으면 닫아야 하는 모든 자원"에 써요. DB 연결, 잠금(lock), 네트워크 소켓 같은 거요. 다 같은 context manager 약속을 따르거든요. 그래서 with를 한 번 이해하면, 그 모든 자원을 안전하게 다뤄요. "자원을 열고 반드시 닫아야 하는 모든 곳에 with"가 표준이에요. H7에서 이 `__enter__`/`__exit__` 메커니즘을 더 깊이 봐요. 지금은 "with = 들어갈 때 열고, 나올 때(에러 나도) 닫기"면 충분해요.

---

## 5. try/except/else/finally 네 블록

이제 예외 처리의 본체예요. try에는 네 블록이 있어요. 하나씩 볼게요.

```python
try:
    f = open("f.txt", encoding="utf-8")
    content = f.read()
except FileNotFoundError:
    content = "기본값"            # 파일 없을 때
except PermissionError as e:
    print(f"권한 에러: {e}")
    raise                          # 다시 던지기
else:
    print("성공적으로 읽었어요")    # 사고 없을 때만
finally:
    print("정리 작업")             # 항상 실행
```

네 블록을 한국어로 정리할게요. **try**는 "사고가 날 수 있는 코드를 시도", **except**는 "사고가 나면 이렇게 처리", **else**는 "사고가 안 났을 때만 할 일", **finally**는 "사고가 나든 안 나든 항상 할 일"이에요.

except가 여러 개 올 수 있다는 게 중요해요. 위 코드는 FileNotFoundError(파일 없음)와 PermissionError(권한 없음)를 따로 처리해요. 사고 종류마다 다르게 대처하는 거죠. 파일이 없으면 기본값을 쓰고, 권한이 없으면 메시지를 찍고 다시 던져요(raise). 이렇게 구체적으로 잡는 게 좋은 예외 처리예요. H1에서 강조한 "except는 구체적으로"가 이거예요.

else와 finally를 헷갈리기 쉬운데, 차이가 명확해요. **else는 "성공했을 때만"**, **finally는 "항상"**이에요. else는 try가 사고 없이 끝났을 때만 실행되고, finally는 사고가 나든 안 나든, 심지어 except에서 raise를 해도 실행돼요. finally는 보통 "정리 작업"에 써요. 파일 닫기, 연결 끊기 같은 거요. 다만 파일은 with가 알아서 닫으니, finally를 쓸 일이 생각보다 적어요. 매일 쓰는 건 try/except가 80%, finally가 20%, else는 가끔이에요. 그러니 try/except부터 손에 익히세요.

네 블록이 실행되는 순서를 한 번 그려 볼게요. 사고가 안 났을 때는 try → else → finally 순서로 돌아요. 사고가 났을 때는 try(중간에 멈춤) → except → finally 순서고요. 보세요, finally는 어느 경우든 맨 마지막에 항상 실행돼요. 그래서 "무슨 일이 있어도 반드시 해야 하는 정리"를 finally에 넣는 거예요. 예를 들어 임시 파일을 만들어 쓰다가, 성공하든 실패하든 그 임시 파일은 지워야 한다면, finally에 삭제 코드를 넣어요. 그러면 사고가 나도 임시 파일이 안 남죠. 이 "항상 실행"이 finally의 존재 이유예요. else는 좀 더 미묘한데, "try가 성공했을 때만 이어서 할 일"을 try 본문과 분리하고 싶을 때 써요. 처음엔 try/except만 써도 충분하고, else와 finally는 필요한 상황을 만나면 그때 꺼내면 돼요.

여기서 한 가지 실전 팁. 여러 예외를 같은 방식으로 처리할 거면, 튜플로 묶어요.

```python
except (FileNotFoundError, PermissionError) as e:
    print(f"파일 문제: {e}")
```

`except (A, B)`처럼 괄호로 묶으면, A나 B 중 아무거나 나면 이 블록이 처리해요. 비슷한 사고를 한 번에 다루는 깔끔한 방법이에요.

---

## 6. 예외 계층 구조 — 가계도

예외에는 가계도가 있어요. 이걸 알면 예외를 더 잘 잡아요.

```python
BaseException
 └── Exception            ← 우리가 잡는 대부분
      ├── ArithmeticError
      │    └── ZeroDivisionError   (0으로 나눔)
      ├── LookupError
      │    ├── KeyError            (dict에 키 없음)
      │    └── IndexError          (list 범위 초과)
      ├── OSError
      │    ├── FileNotFoundError   (파일 없음)
      │    ├── PermissionError     (권한 없음)
      │    └── ConnectionError     (연결 끊김)
      ├── ValueError               (값이 이상함)
      └── TypeError                (타입이 이상함)
```

보세요. 모든 예외가 가족 나무로 이어져 있어요. 맨 위에 BaseException, 그 아래 Exception, 그 아래로 구체적인 예외들이요. 이 계층이 왜 중요하냐면, **부모 예외를 잡으면 자식 예외도 다 잡혀요.** 예를 들어 `except OSError`로 잡으면, 그 자식인 FileNotFoundError와 PermissionError가 다 잡혀요. 파일 관련 사고를 한 번에 처리하고 싶으면 OSError를, 정확히 "파일 없음"만 처리하고 싶으면 FileNotFoundError를 잡는 거죠.

자경단이 매일 만나는 다섯 예외를 짚을게요. FileNotFoundError(파일 없음), KeyError(dict에 키 없음 — Ch010에서 본 그거), ValueError(값이 이상함 — 예: "abc"를 int로 변환), TypeError(타입이 이상함), ConnectionError(네트워크 끊김)예요. 이 다섯이 매일 만나는 사고의 80%예요. 그러니 이 다섯의 이름과 뜻만 알아 두면, 대부분의 사고를 정확히 잡을 수 있어요.

예외 이름이 친절하다는 것도 알아 두세요. 이름 자체가 무슨 사고인지 말해 줘요. FileNotFoundError는 "파일을 못 찾았다", PermissionError는 "권한이 없다", KeyError는 "키가 없다"예요. 그래서 본인이 코드를 돌리다 에러가 나면, 에러 이름만 봐도 무슨 일인지 짐작할 수 있어요. 빨간 에러 메시지가 무섭게 느껴질 수 있는데, 사실 그건 Python이 "이런 일이 났어요"라고 친절하게 알려주는 거예요. 에러 이름을 읽는 습관을 들이면, 디버깅이 훨씬 빨라져요. "어, FileNotFoundError네? 그럼 파일 경로가 틀렸겠구나" 하고 바로 짚는 거죠. 에러는 적이 아니라, 문제를 알려주는 안내자예요.

그리고 본인이 코드를 짤 때, 어떤 사고가 날 수 있는지 미리 생각하는 습관이 중요해요. 파일을 열면? FileNotFoundError나 PermissionError가 날 수 있죠. dict에서 값을 꺼내면? KeyError. 문자열을 숫자로 바꾸면? ValueError. 네트워크 요청을 하면? ConnectionError나 TimeoutError. 이렇게 "이 코드에서 어떤 사고가 날 수 있나"를 물으면, 어떤 except를 써야 할지 자연스럽게 떠올라요. 코드를 짜면서 동시에 "여기서 뭐가 잘못될 수 있지?"를 생각하는 게, 견고한 코드를 짜는 사람의 사고방식이에요.

그리고 한 가지 주의. 맨 위 BaseException은 잡지 마세요. 거기엔 `KeyboardInterrupt`(사용자가 Ctrl+C로 중단) 같은, 잡으면 안 되는 것도 있거든요. 본인이 무한 루프를 Ctrl+C로 멈추려 하는데, 코드가 그걸 잡아서 무시하면 프로그램을 못 끄는 황당한 상황이 생겨요. 그래서 우리가 잡는 건 `Exception`과 그 아래예요. `except Exception`은 "거의 모든 사고"를 잡지만, 그것도 너무 넓어서 가능하면 구체적으로 잡는 게 좋아요. 계층을 알면 "얼마나 넓게 잡을지"를 정확히 조절할 수 있어요. 좁게 잡으면 정확하지만 놓치는 사고가 있을 수 있고, 넓게 잡으면 다 잡지만 엉뚱한 것까지 삼킬 수 있어요. 그 균형을 맞추는 게 예외 처리의 기술이고, 계층 지식이 그 균형을 잡아 줘요.

---

## 7. raise와 사용자 정의 예외

지금까지는 사고를 "받는"(except) 쪽이었어요. 이번엔 사고를 "일으키는"(raise) 쪽이에요.

```python
def divide(a, b):
    if b == 0:
        raise ValueError("0으로 나눌 수 없어요")
    return a / b
```

`raise`는 사고를 직접 일으키는 거예요. 위 함수는 b가 0이면 ValueError를 던져요. 왜 직접 사고를 일으키냐면, "잘못된 입력을 일찍 막기" 위해서예요. Ch008에서 배운 guard clause랑 같은 정신이에요. 함수 입구에서 잘못된 입력을 발견하면, 조용히 이상한 결과를 내는 대신 명확하게 사고를 일으켜서 "여기가 문제야"라고 알리는 거죠. 좋은 함수는 잘못된 입력을 받으면 raise로 분명히 막아요. 만약 raise 없이 그냥 진행하면, 그 잘못된 값이 함수 깊숙이 흘러가서 한참 뒤에 엉뚱한 곳에서 터져요. 그러면 "어디서 잘못됐지?" 하고 한참 헤매죠. 입구에서 raise로 막으면, 문제가 난 자리가 바로 보여서 디버깅이 쉬워요. "일찍 실패하라(fail fast)"가 좋은 코드의 원칙이에요.

그리고 본인만의 예외를 만들 수도 있어요. 사용자 정의 예외예요.

```python
class CatNotFoundError(Exception):
    """고양이를 못 찾았을 때."""
    pass

def find_cat(name, cats):
    if name not in cats:
        raise CatNotFoundError(f"{name}는 자경단에 없어요")
    return cats[name]
```

`class CatNotFoundError(Exception):`로 Exception을 상속하면, 본인만의 예외가 만들어져요. 이게 왜 좋냐면, "이 도메인에서 이런 사고가 난다"를 코드로 명확히 표현하거든요. `ValueError`보다 `CatNotFoundError`가 "아, 고양이를 못 찾았구나"를 바로 알려주죠. 그리고 잡을 때도 정확해요.

```python
try:
    cat = find_cat("없는고양이", cats)
except CatNotFoundError as e:
    print(f"⚠️ {e}")
```

이렇게 본인 도메인의 사고를 정확한 이름으로 잡으면, 코드가 읽기 좋고 처리도 정확해요. "사용자 정의 예외는 시니어나 쓰는 것"이라는 오해가 있는데, 아니에요. `class X(Exception): pass` 한 줄이면 끝이라, 신입도 도메인 예외를 만들어 써요. 본인 프로그램에 "이런 특별한 사고가 있다" 싶으면, 그때 만들면 돼요.

raise를 언제 쓰고 언제 except를 쓰는지, 그 구분을 짚을게요. raise는 "내가 사고를 일으키는" 쪽이고, except는 "남이 일으킨 사고를 받는" 쪽이에요. 보통 함수를 만드는 사람이 raise로 "이런 입력은 안 돼"라고 사고를 일으키고, 그 함수를 쓰는 사람이 except로 그 사고를 받아 처리해요. 예를 들어 find_cat 함수는 고양이가 없으면 raise로 사고를 일으키고, 그 함수를 부르는 코드는 try/except로 "없으면 이렇게 하자"를 정하죠. 그러니까 raise와 except는 함수를 만드는 쪽과 쓰는 쪽의 약속이에요. 좋은 함수는 잘못된 상황을 raise로 분명히 알리고, 좋은 호출자는 그걸 except로 우아하게 받아요. 이 둘이 짝을 이뤄야 견고한 코드가 돼요.

한 가지 중요한 원칙이 있어요. "사고를 조용히 삼키지 마라"예요. 가장 나쁜 코드가 `except: pass`예요. 사고가 나도 아무것도 안 하고 넘어가는 거죠. 이러면 뭔가 잘못됐는데 아무도 모르게 돼요. 데이터가 깨졌는데 프로그램은 멀쩡한 척 돌아가는, 가장 무서운 상황이 생기죠. 그래서 사고를 잡으면 반드시 뭔가 해야 해요. 기본값을 쓰거나, 로그를 남기거나, 사용자에게 알리거나, 아니면 raise로 다시 던지거나요. "잡았으면 처리하라, 처리 못 할 거면 잡지 마라"가 예외 처리의 황금률이에요. H6에서 이 함정을 더 깊이 봐요.

---

## 8. pathlib — 경로를 객체로

마지막 개념, pathlib예요. 파일 경로를 다루는 모던한 방법이에요.

```python
from pathlib import Path

p = Path("data/cats.txt")

# 경로 분해
p.name      # 'cats.txt'  — 파일 이름
p.stem      # 'cats'      — 확장자 뺀 이름
p.suffix    # '.txt'      — 확장자
p.parent    # Path('data') — 상위 폴더

# 검사
p.exists()  # 파일이 있나
p.is_file() # 파일인가
p.is_dir()  # 폴더인가
```

pathlib는 경로를 "문자열"이 아니라 "객체"로 다뤄요. 그래서 `.name`, `.suffix` 같은 속성으로 경로를 깔끔하게 분해하고, `.exists()` 같은 메서드로 검사하죠. 옛날엔 `os.path.basename(path)`처럼 복잡했는데, pathlib는 `p.name`처럼 읽기 좋아요. 자경단 표준은 "경로는 pathlib"예요.

pathlib의 또 다른 강점은 경로를 합치는 거예요. 옛날엔 경로를 `"data" + "/" + "cats.txt"`처럼 문자열로 이었는데, 이러면 OS마다 다른 구분자(윈도우는 `\`, 맥/리눅스는 `/`) 때문에 사고가 났어요. pathlib는 슬래시 연산자로 경로를 합쳐요. `Path("data") / "cats.txt"`처럼요. 그러면 OS에 맞는 구분자를 알아서 써 줘요. 윈도우에선 `data\cats.txt`, 맥에선 `data/cats.txt`로요. 이게 cross-platform(여러 OS에서 동작) 코드를 짜는 비결이에요. 본인 맥에서 짠 코드가 회사 윈도우 서버에서도 그대로 돌게 만드는 거죠. 경로를 문자열로 이으면 한 OS에서만 되지만, pathlib로 합치면 모든 OS에서 돼요. 이래서 pathlib가 "모던 표준"인 거예요.

pathlib의 진짜 매력은 파일 읽고 쓰기를 한 줄로 한다는 거예요.

```python
Path("f.txt").write_text("안녕", encoding="utf-8")   # 쓰기 한 줄
content = Path("f.txt").read_text(encoding="utf-8")   # 읽기 한 줄
```

`write_text`와 `read_text`는 with 없이도 알아서 파일을 열고 닫아 줘요. 작은 파일을 통째로 읽거나 쓸 땐 이게 정말 편하죠. `with open(...) as f: f.read()` 세 줄이 `Path(...).read_text()` 한 줄이 돼요. 물론 인코딩은 여기서도 줘야 해요. 그리고 폴더를 만드는 것도 쉬워요. `Path("data").mkdir(exist_ok=True)`처럼요. `exist_ok=True`는 "이미 있어도 에러 내지 마"예요. 폴더를 만들 때 이미 있으면 에러가 나는데, 이 옵션이 그걸 막아 주죠. 그리고 중간 폴더까지 한 번에 만들려면 `parents=True`를 더해요. `Path("a/b/c").mkdir(parents=True, exist_ok=True)`는 a, b, c 폴더를 다 만들어요. 결과를 저장하기 전에 폴더가 없으면, 이걸로 먼저 만들면 사고를 막아요.

다만 큰 파일을 한 줄씩 처리할 땐 여전히 `with open`과 `for line in f`를 써요. read_text는 전체를 한 번에 읽거든요. 그래서 "작은 파일은 pathlib 한 줄, 큰 파일은 with open + for line"으로 가려 쓰면 돼요. 설정 파일이나 작은 JSON은 pathlib로 한 줄에, 거대한 로그는 with open으로 스트리밍. 이 구분만 손에 익히면, 어떤 파일도 적절한 방법으로 다뤄요. H3에서 pathlib를 더 깊이 익혀요. pathlib에는 폴더 안 파일을 다 찾는 glob 같은 강력한 기능도 있는데, 그건 H3·H4에서 봐요.

---

## 9. 한 줄 분해 — 안전한 JSON 읽기

오늘 배운 걸 한 줄에 모아 볼게요. 매 챕터의 한 줄 분해예요.

```python
import json
from pathlib import Path

try:
    data = json.loads(Path("config.json").read_text(encoding="utf-8"))
except (FileNotFoundError, json.JSONDecodeError):
    data = {}
```

이 코드를 뜯어 볼게요. `Path("config.json").read_text(encoding="utf-8")`로 JSON 파일을 한 줄로 읽고(pathlib), `json.loads`로 그 문자열을 dict로 바꿔요(Ch010의 dict!). 그런데 두 가지 사고가 날 수 있죠. 파일이 없거나(FileNotFoundError), 파일 내용이 깨진 JSON이거나(json.JSONDecodeError). 그 둘을 튜플로 묶어 잡고, 사고가 나면 빈 dict를 기본값으로 써요.

보세요. pathlib(읽기), json(파싱), try/except(사고 처리), 튜플 예외(여러 사고 한 번에)가 한 코드에 다 있어요. 그리고 결과는 Ch010의 dict로 나오고요. 이게 실무에서 설정 파일을 안전하게 읽는 전형적인 패턴이에요. 까미가 매일 쓰는 코드죠. 본인이 이 코드를 읽고 "파일이 없거나 깨졌으면 빈 설정으로 시작하는구나"를 이해하면, 오늘 H2를 제대로 소화한 거예요. 여러 챕터가 한 줄에서 손을 잡는 걸 느껴 보세요.

이 패턴이 왜 좋은 설계인지 한 번 더 짚을게요. 설정 파일을 읽는데, 그 파일이 없을 수도 있고 깨졌을 수도 있어요. 만약 이걸 처리 안 하면, 프로그램이 시작하자마자 죽어요. 사용자는 "왜 안 켜지지?"하고 당황하죠. 그런데 이 패턴은 "파일에 문제가 있으면 빈 설정으로 시작"해요. 프로그램이 일단 켜지고, 사용자가 설정을 새로 만들 수 있죠. 죽는 대신 우아하게 대처하는 거예요. 이게 H1에서 본 "예외 처리는 책임"의 실제 모습이에요. 사고가 날 수 있는 곳을 미리 알고, 사고가 나도 사용자가 곤란하지 않게 대비하는 것. 좋은 프로그램은 이런 작은 배려로 가득해요. 본인이 이 패턴을 손에 익히면, 어디서든 "이 파일이 없으면?"을 자동으로 대비하게 돼요.

---

## 10. 흔한 오해 다섯 가지

**오해 1: with는 없어도 된다.**

아니에요. with 없이 open만 쓰면 close를 직접 해야 하고, 깜빡하면 자원이 새요. 자경단 표준은 "파일은 무조건 with"예요. 예외예요. with 없는 open은 거의 항상 실수예요.

**오해 2: except Exception으로 다 잡으면 편하다.**

아니에요. 너무 넓게 잡으면 예상 못 한 사고까지 삼켜서 버그를 숨겨요. "어떤 사고를 처리하는지" 명확하게, 구체적으로 잡으세요. FileNotFoundError처럼요. 계층을 알면 적절한 넓이로 잡을 수 있어요.

**오해 3: finally는 잘 안 쓴다.**

상황에 따라요. 파일은 with가 닫아 주니 finally가 적지만, with로 안 되는 정리 작업(임시 파일 삭제, 상태 복구)엔 finally가 필요해요. "정리는 반드시 해야 한다" 싶을 때 finally를 떠올리세요.

**오해 4: pathlib는 있으면 좋은 옵션이다.**

아니에요. 모던 Python의 표준이에요. 경로를 객체로 다뤄서 os.path보다 깔끔하고 안전해요. 자경단도 표준으로 써요. 새 코드는 pathlib로 짜세요.

**오해 5: 사용자 정의 예외는 시니어나 쓴다.**

아니에요. `class X(Exception): pass` 한 줄이면 끝이에요. 본인 도메인에 특별한 사고가 있으면, 신입도 만들어 써요. 코드가 읽기 좋아지고 처리도 정확해져요.

다섯 오해의 공통점은 "예외 처리를 대충 하거나 어렵게 보는" 거예요. 그런데 오늘 보니 다 단순하죠? with 쓰고, 구체적으로 잡고, 필요하면 도메인 예외 만들고. 어렵지 않아요. 정확하게 하는 습관만 들이면 돼요. 예외 처리는 어려운 기술이 아니라 꼼꼼한 태도예요. "이 코드에서 뭐가 잘못될 수 있지?"를 묻고, 그 사고에 대비하는 거죠. 머리가 좋아야 하는 게 아니라, 신중하면 되는 거예요. 본인이 오늘 그 태도를 배웠으니, 이제 코드를 짤 때마다 한 번 더 생각하는 습관만 들이면 돼요. 그 작은 습관이 본인을 견고한 코드를 짜는 사람으로 만들어요.

---

## 11. 자주 받는 질문 일곱 가지

**Q1. with 없이 파일을 열면 어떻게 돼요?**

자동으로 안 닫혀요. 그래서 직접 `f.close()`를 해야 하는데, 깜빡하기 쉽죠. 안 닫으면 file descriptor가 새서, 수만 번 반복하면 "Too many open files" 사고가 나요. 그래서 with를 쓰는 거예요. with는 절대 깜빡 안 하거든요.

**Q2. except를 여러 개 쓸 때 순서가 중요한가요?**

네, 중요해요. **구체적인 것 먼저, 일반적인 것 나중**이에요. `except FileNotFoundError` 다음에 `except OSError`처럼요. 거꾸로 OSError를 먼저 쓰면, FileNotFoundError도 OSError의 자식이라 거기서 다 잡혀서, 뒤의 구체적인 처리가 영영 안 불려요. 좁은 것부터 넓은 것 순서예요.

**Q3. raise를 인자 없이 쓰면 뭐가 돼요?**

`raise` 단독은 "지금 처리 중인 예외를 다시 던지기"예요. except 블록 안에서 쓰죠. "이 사고를 로그에 남기긴 하는데, 처리는 못 하니 위로 다시 올려보낸다"는 뜻이에요. 사고를 기록하되 떠넘기는 패턴이에요. 그냥 삼키는 것보다 정직하죠.

**Q4. else 블록은 언제 써요?**

try가 성공했을 때만 할 일이 있을 때요. 예를 들어 "파일을 성공적으로 읽었으면, 그 내용을 처리한다" 같은 거죠. 그 처리 코드를 try 안에 넣으면, 처리 중 사고가 except로 잘못 잡힐 수 있어요. else에 넣으면 "읽기 성공"과 "처리"가 분리되어 깔끔해요. 다만 안 써도 되는 경우가 많아서, 필요할 때만 쓰세요.

**Q5. pathlib랑 open 중 뭘 써요?**

작은 파일을 통째로 읽고 쓸 땐 pathlib(`read_text`/`write_text`)가 한 줄이라 편해요. 큰 파일을 한 줄씩 처리할 땐 `with open` + `for line`이고요. 경로를 다루는 건 pathlib가 깔끔하고. 둘을 상황에 맞게 가려 쓰면 돼요. 경로는 pathlib, 큰 파일 스트리밍은 open으로요.

**Q6. 8개념이 너무 많아요. 다 외워야 해요?**

아니에요. 매일 쓰는 핵심은 "with open + encoding", "try/except 구체적으로", "for line으로 큰 파일", "pathlib로 작은 파일" 정도예요. 나머지(else, finally, 사용자 정의 예외)는 "이런 게 있다"만 알고, 필요할 때 꺼내면 돼요. 외우는 게 아니라 자주 써서 손에 붙이는 거예요.

**Q7. 예외를 처리하면 프로그램이 안 죽나요?**

상황에 따라 달라요. 사고를 잡아서 대처할 수 있으면(기본값 쓰기 등) 안 죽고 계속 가요. 그런데 어떤 사고는 "더 못 가니 멈춰야" 할 때도 있어요. 그럴 땐 잡아서 로그를 남기고 raise로 다시 던져서, 깔끔하게 멈추게 해요. 핵심은 "사고를 통제하는" 거예요. 죽더라도 갑자기 와르르 죽는 게 아니라, "이런 이유로 멈춥니다"라고 명확히 알리며 멈추는 거죠. 통제된 종료와 갑작스러운 죽음은 달라요. 예외 처리는 그 통제권을 본인에게 주는 거예요.

---

## 12. 흔한 실수 다섯 + 안심 — 핵심 개념 학습 편

**첫째, 파일 모드를 다 외우려다 헷갈리기.** 안심하세요. `r`(읽기)·`w`(덮어쓰기)·`a`(추가) 셋이 90%예요. 특히 "추가는 a, w는 다 지움"만 확실히요. 나머지는 필요할 때 찾으세요.

**둘째, except 순서를 거꾸로 쓰기.** 안심하세요. 구체적인 것(FileNotFoundError)을 먼저, 일반적인 것(OSError·Exception)을 나중에요. 좁은 것부터 넓은 것 순서. 이 하나만 지키면 돼요.

**셋째, finally를 시니어 도구로 여기기.** 안심하세요. finally는 "사고가 나든 안 나든 정리할 게 있을 때" 쓰는 거예요. 어렵지 않아요. 다만 파일은 with가 닫아 주니, finally 쓸 일이 생각보다 적어요.

**넷째, 사용자 정의 예외를 어렵게 보기.** 안심하세요. `class CatNotFoundError(Exception): pass` 한 줄이면 끝이에요. 본인 도메인의 사고에 이름을 붙이는 것뿐이에요. 신입도 해요.

**다섯째, 가장 큰 함정 — pathlib를 옵션으로 보기.** 안심하세요. pathlib는 모던 표준이에요. 경로는 pathlib, 작은 파일은 read_text/write_text. 한 줄로 깔끔하니, 오늘부터 습관 들이세요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 가요. 이 다섯을 보면, 다 "정확하게 하는 습관"에 관한 거예요. 모드를 정확히 고르고, except 순서를 정확히 하고, 도구를 정확히 가려 쓰는 거죠. 예외 처리와 파일 다루기는 화려함이 아니라 정확함의 영역이에요. 그리고 정확함은 재능이 아니라 습관이에요. 본인이 오늘 배운 것들을 매일 조금씩 쓰면, 자연스럽게 정확해져요. 처음엔 의식하며 챙기다가, 곧 손이 알아서 with를 쓰고 encoding을 주고 구체적으로 잡게 돼요. 그게 견고한 코드를 짜는 사람의 손이에요.

---

## 13. 마무리

자, 두 번째 시간이 끝났어요. 오늘 본인은 파일과 예외의 여덟 개념을 손에 쥐었어요.

파일 모드 일곱(r·w·a가 핵심), 파일 메서드(read·write·for line), with의 원리(context manager·자동 close), try/except/else/finally 네 블록, 예외 계층(부모 잡으면 자식도), raise와 사용자 정의 예외, 그리고 pathlib(경로를 객체로·한 줄 읽기쓰기)까지요. 한 줄 분해로 안전한 JSON 읽기도 봤고요. 오늘 정말 많이 했어요.

한 가지만 기억하세요. **안전하게 열고, 구체적으로 잡으라.** 파일은 with로 안전하게 열고(자동 close), 예외는 구체적으로 잡으세요(FileNotFoundError처럼). 이 두 가지가 견고한 I/O의 핵심이에요. 그리고 큰 파일은 for line으로, 작은 파일은 pathlib 한 줄로. 이 감각만 손에 쥐면, 본인은 어떤 파일도 안전하게 다뤄요.

다음 H3는 이 도구들을 실제로 다루는 환경을 갖춰요. pathlib를 더 깊이, logging으로 사고를 기록하고, rich.traceback으로 에러를 예쁘게 보고요. 오늘 머리로 배운 걸 손에서 단단히 하는 시간이에요. 그 전에 마지막으로 한 줄만 쳐 보세요.

```python
python3 -c "from pathlib import Path; Path('t.txt').write_text('안녕 자경단', encoding='utf-8'); print(Path('t.txt').read_text(encoding='utf-8'))"
```

`안녕 자경단`이 나와요. pathlib로 파일에 쓰고, 바로 다시 읽은 거예요. 오늘 배운 pathlib 한 줄 읽기쓰기가 다 있죠. with도 close도 없이 깔끔하게요. 본인이 이 한 줄을 칠 수 있으면, 오늘 핵심을 손에 쥔 거예요.

마지막으로 부탁 하나. 강의를 끄고, 작은 파일 하나를 직접 만들어 보세요. `with open`으로 cat 이름 셋을 쓰고, `for line in f`로 한 줄씩 읽어 출력해 보세요. 그리고 일부러 없는 파일을 try/except로 열어 보세요. 사고가 우아하게 처리되는 걸 직접 보면, 오늘 배운 게 손에 붙어요. 다음 시간에 또 봐요. 🐾

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - open(file, mode, encoding, newline, buffering). 텍스트 기본. `for line in f`는 lazy(메모리 효율).
> - context manager: `__enter__`(자원 획득)·`__exit__`(해제, 예외 시에도). `contextlib.contextmanager` 데코레이터.
> - try/except/else/finally: else는 try 성공 시, finally는 항상(return/raise 후에도). except는 구체→일반 순서.
> - 예외 계층: BaseException(KeyboardInterrupt·SystemExit 포함, 잡지 말 것) → Exception(우리 영역). 부모로 자식 다 잡힘.
> - raise X from Y: 예외 체이닝(원인 보존). `raise X from None`: 원인 숨김.
> - pathlib: PurePath(경로 조작)·Path(I/O). read_text·write_text·glob·rglob·mkdir(parents=, exist_ok=).
> - 다음 H3 키워드: pathlib 심화 · logging · io(StringIO) · rich.traceback.

---

## 추신

1. open 모드 — r(읽기)·w(덮어씀)·a(추가)·x(새파일만)·rb/wb(바이너리).
2. 매일 r·w·a 셋이 90%.
3. w는 여는 순간 다 지움. 추가는 a.
4. x는 있으면 에러 — 덮어쓰기 사고 방지.
5. open엔 항상 encoding="utf-8".
6. read() = 전체, for line in f = 한 줄씩(큰 파일).
7. 큰 파일은 read() 말고 for line in f. 메모리 안전(10GB도 OK).
8. write는 줄바꿈 자동 안 넣음. \n 직접.
9. with = context manager. 나올 때(에러가 나도) 자동 close. 안전 장치.
10. with에 파일 여러 개 쉼표로.
11. with는 DB·lock·소켓 등 모든 자원에.
12. try(시도)·except(처리)·else(성공시)·finally(항상).
13. except는 구체적으로(FileNotFoundError). 넓게 잡으면 버그 숨김.
14. except 여러 개 — 튜플로 묶기 `(A, B)`.
15. else=성공 시만, finally=항상(raise 후에도).
16. 예외 계층 — 부모를 잡으면 자식도 다 잡힘(OSError로 파일 사고 통째).
17. 매일 다섯 — FileNotFound·Key·Value·Type·Connection.
18. BaseException은 잡지 말기(KeyboardInterrupt 등).
19. except 순서 — 구체적 먼저, 일반 나중.
20. raise = 사고 직접 일으키기(guard clause). 일찍 실패하라.
21. 사용자 정의 예외 — class X(Exception): pass.
22. 도메인 예외가 코드를 읽기 좋게.
23. raise 단독 = 처리 중 예외 다시 던지기.
24. pathlib = 경로를 객체로. os.path 대체. 슬래시로 합침(OS 무관).
25. p.name·stem·suffix·parent로 경로 분해.
26. Path().read_text()/write_text() — with 없이 한 줄 읽기쓰기.
27. 작은 파일 pathlib, 큰 파일 with open+for line.
28. pathlib도 encoding 명시. mkdir(exist_ok=True).
29. Ch012 H2 졸업장 — pathlib 쓰고 읽기 한 줄.
30. 다음 H3는 pathlib 심화·logging·rich.traceback. 바로 다음 시간에. 🐾
