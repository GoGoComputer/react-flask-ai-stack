# Ch009 · H7 — 함수 내부 — scope·LEGB·closure·frame

> 고양이 자경단 · Ch 009 · 7교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. LEGB scope 규칙
3. global, nonlocal 키워드
4. closure cell 객체
5. function frame과 stack
6. function object의 속성
7. decorator 내부
8. async function 내부
9. 흔한 오해 다섯 가지
10. 흔한 실수 다섯 + 안심
11. 마무리

---

## 🔧 강사용 명령어 한눈에

```python
def outer():
    x = 10
    def inner():
        return x
    return inner

f = outer()
f.__closure__[0].cell_contents   # 10 — closure가 캡처한 변수

import inspect
inspect.currentframe()           # 현재 frame
```

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났어요. 함수 챕터의 일곱 번째 시간, 가장 깊은 시간이에요.

지난 H6를 한 줄로 회수할게요. 본인은 좋은 함수의 원칙을 배웠죠. pure function, SOLID(특히 단일 책임), DRY, KISS, 함수 합성이요. "어떻게 짜야 좋은가"라는 태도를 익혔어요.

이번 H7은 함수의 가장 깊은 속이에요. Ch008 H7에서 for 루프의 가장 깊은 속(iterator, generator)을 봤죠. 이번엔 함수의 가장 깊은 속이에요. 변수가 어떤 순서로 찾아지는지(LEGB), closure가 어떻게 바깥 변수를 기억하는지(cell), 함수 호출이 어떻게 쌓이는지(frame), 데코레이터의 정체가 뭔지요. H2·H5에서 "closure는 책상을 안 치우는 함수", "cell 상자에 담아 들고 다닌다"고 비유했는데, 오늘 그 cell의 진짜 정체를 봐요.

오늘의 약속은 이거예요. **본인이 함수 호출 시 일어나는 메커니즘을 만집니다**. 함수가 마법이 아니라 정직한 기계라는 걸, 오늘 끝까지 파서 확인해요. 이 시간은 좀 깊어요. 솔직히 말하면, 오늘 내용을 매일 쓰진 않아요. 그런데 한 번 깊이 보면, 본인이 closure나 데코레이터 앞에서 영영 안 무서워져요. 속을 봤으니까요. 그리고 이게 면접 단골이기도 해요. "closure가 어떻게 동작하죠?"라는 질문에 본인은 cell 객체까지 설명할 수 있게 돼요. 마음 편하게, 그러나 집중해서 들으세요.

오늘 내용을 듣는 마음가짐을 하나 말할게요. 오늘은 "당장 써먹을 것"을 배우는 시간이 아니에요. "이해의 깊이"를 더하는 시간이에요. 그게 무슨 가치냐면, 본인이 H5에서 closure를 짤 때 "이게 왜 되지?" 하고 찜찜했던 부분이 오늘 다 풀려요. 찜찜함 없이 도구를 쓰는 것과, 원리를 알고 쓰는 것은 자신감이 달라요. 요리사가 불의 원리를 알면 어떤 재료도 자신 있게 다루듯, 본인이 함수의 원리를 알면 어떤 함수 코드도 자신 있게 다뤄요. 그리고 이 깊은 이해가 본인을 "그냥 쓰는 사람"에서 "아는 사람"으로 바꿔요. 5년 차와 1년 차의 차이가 여기서도 나요. 둘 다 closure를 쓰지만, 5년 차는 cell까지 알아서 함정도 피하고 디버깅도 빨라요. 오늘 본인이 그 5년 차의 깊이를 미리 가져가는 거예요. 자, 가요.

---

## 2. LEGB scope 규칙

첫째, LEGB예요. Python이 변수를 찾는 순서예요. 본인이 `print(x)`를 쳤을 때, Python이 그 `x`를 어디서 찾는지의 규칙이죠. 순서는 **L**ocal → **E**nclosing → **G**lobal → **B**uiltin이에요.

```python
x = "global"   # G

def outer():
    x = "enclosing"   # E

    def inner():
        x = "local"   # L
        print(x)   # 'local'

    inner()
    print(x)   # 'enclosing'

outer()
print(x)   # 'global'
```

읽어 볼게요. `inner` 안에서 `print(x)`를 하면, 가장 안쪽 Local에 x가 있죠("local"). 그래서 그걸 써요. 만약 inner 안에 x가 없었다면, 한 단계 위 Enclosing(outer의 x)을 봤을 거예요. 그것도 없으면 Global(파일 전체의 x), 그것도 없으면 Builtin(Python 기본)을 봐요. 같은 이름 x가 세 군데(L·E·G)에 다 있는데, 가장 안쪽 걸 쓴다는 게 핵심이에요. 안쪽이 바깥을 "가린다"고 표현해요(shadowing). inner의 local x가 outer의 x를 가리고, outer의 x가 global x를 가리죠. 그래서 inner는 "local", outer는 "enclosing", 파일 맨 바깥은 "global"을 출력해요. 각자 자기에게 가장 가까운 x를 보는 거예요.

LEGB를 양파 껍질로 생각하세요. 가장 안쪽(Local)부터 보고, 없으면 한 겹씩 바깥으로 나가요. Local은 함수 안, Enclosing은 그걸 감싼 바깥 함수, Global은 파일 전체, Builtin은 Python이 기본으로 주는 것들이에요. print, len, range 같은 게 Builtin이죠. 그래서 본인이 어디서든 `print`를 쓸 수 있는 거예요. LEGB의 맨 바깥 B에 print이 있어서, 다른 데서 못 찾으면 결국 거기서 찾거든요.

```python
print(__builtins__)
```

이걸 치면 Python이 기본으로 주는 모든 것(Builtin)이 나와요. 자경단은 이 LEGB 규칙을 매일 쓰는데, 의식하진 않아요. 그냥 자동으로 동작하거든요. 본인도 매일 이 규칙의 덕을 봐 왔어요. 오늘 처음 그 이름을 안 거죠. "변수는 안쪽부터 바깥으로 찾는다." 이 한 문장이 LEGB의 전부예요.

LEGB를 알면 실전에서 한 가지 함정을 피할 수 있어요. Builtin을 실수로 덮어쓰는 거예요. 예를 들어 본인이 `list = [1, 2, 3]`이라고 변수 이름을 `list`로 쓰면, Builtin인 `list()` 함수가 가려져요. LEGB에서 Local이나 Global의 list가 먼저 잡히니까요. 그러면 그 아래에서 `list("abc")`처럼 list 함수를 쓰려다 "리스트는 호출할 수 없다"는 에러를 만나요. 본인이 list라는 이름을 빼앗아 버렸거든요. 그래서 변수 이름으로 `list`, `dict`, `str`, `sum`, `id`, `type` 같은 Builtin 이름을 쓰면 안 돼요. 이게 H6에서 "의미 있는 이름을 쓰라"고 한 것과도 통해요. `list` 대신 `cat_list`나 `cats`처럼 쓰면, Builtin도 안 가리고 의미도 분명하죠. ruff 같은 도구가 이 Builtin 덮어쓰기를 경고해 주기도 해요(A001). LEGB의 맨 바깥 B를 함부로 가리지 마세요.

그리고 LEGB의 E(Enclosing)가 바로 closure의 무대예요. 안쪽 함수가 바깥 함수의 변수를 본다는 게 E 단계거든요. 오늘 뒤에서 배울 cell이 이 E 단계의 변수를 담는 상자예요. 그러니 LEGB의 L과 E를 잘 구분하는 게, closure를 이해하는 첫걸음이에요. Local은 그 함수만의 것, Enclosing은 바깥 함수의 것. closure는 안쪽 함수가 Enclosing의 변수를 붙잡는 거죠. 이 그림을 머리에 두고 cell 이야기를 들으면 훨씬 쉬워요.

---

## 3. global, nonlocal 키워드

둘째, global과 nonlocal이에요. LEGB는 "읽기"의 규칙인데, "쓰기"는 좀 달라요.

기본 규칙은 이래요. 변수를 읽는 건 LEGB로 바깥까지 찾는데, 쓰는 건 무조건 Local에 만들어요. 그래서 이런 함정이 생겨요.

```python
x = 0

def increment():
    x = x + 1   # UnboundLocalError!
```

이게 왜 에러냐면, `x = x + 1`에서 왼쪽 `x =`가 "Local에 x를 만들겠다"는 선언이거든요. 그러면 Python은 이 함수 안의 x를 Local로 취급해요. 그런데 오른쪽 `x + 1`에서 그 Local x를 읽으려니, 아직 만들어지지 않았죠. 그래서 "묶이지 않은 지역 변수" 에러가 나요. 본인이 분명 바깥에 x=0을 뒀는데도요.

처방은 global이에요.

```python
def increment():
    global x
    x = x + 1
```

`global x`는 "이 x는 Local이 아니라 Global이야"라고 선언하는 거예요. 그러면 바깥의 x를 직접 고쳐요. 그런데 자경단은 global을 거의 안 써요. H6에서 배웠듯, 전역을 건드리는 건 impure라 위험하거든요.

closure에서는 nonlocal을 써요. H2·H5에서 본 그거예요.

```python
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment
```

`nonlocal count`는 "이 count는 Local이 아니라 한 단계 바깥(Enclosing)의 count야"라는 선언이에요. nonlocal이 없으면 어떻게 될까요?

```python
def make_counter():
    count = 0
    def increment():
        count += 1   # UnboundLocalError!
        return count
    return increment
```

똑같은 에러가 나요. `count += 1`이 "Local에 count를 만들겠다"가 돼서, 아직 없는 Local count를 읽으려다 터지죠. nonlocal이 "새로 만들지 말고 바깥 거를 고쳐"라고 알려 주는 거예요. 자경단 표준은 "global은 안 쓰고, nonlocal은 closure에서만"이에요. global을 안 쓰는 건 pure를 위해, nonlocal을 closure에 쓰는 건 카운터 같은 상태 함수를 위해서요.

여기서 헷갈리기 쉬운 걸 하나 정리할게요. "읽기는 선언이 필요 없는데, 쓰기는 왜 필요한가?"예요. 읽기는 LEGB로 알아서 바깥까지 찾아가니까 선언이 필요 없어요. `print(x)`는 x를 못 찾으면 바깥에서 찾죠. 그런데 쓰기(`x = ...`)는 Python이 "안전을 위해" 기본적으로 Local에 새로 만들어요. 왜냐면 함수가 실수로 바깥 변수를 덮어쓰는 사고를 막으려는 거예요. 그래서 "정말로 바깥 걸 고치고 싶다"면 global이나 nonlocal로 명시적으로 선언하게 한 거죠. 이건 Python의 안전장치예요. "바깥 변수를 고치는 건 위험한 일이니, 일부러 선언해라"는 거예요. 그 덕분에 본인이 함수 안에서 무심코 바깥 변수를 망가뜨리는 일이 안 생겨요. 불편해 보이지만 본인을 지키는 규칙이에요. 그리고 이 규칙이 있어서, 함수가 대체로 pure하게 유지되는 거예요. 바깥을 건드리려면 일부러 선언해야 하니, 자연스럽게 안 건드리게 되거든요. Python의 설계 철학이 여기 담겨 있어요.

---

## 4. closure cell 객체

셋째, 오늘의 핵심, cell 객체예요. H2·H5에서 "closure가 바깥 변수를 상자에 담아 들고 다닌다"고 했죠. 그 상자가 cell이에요. 진짜 정체를 봐요.

```python
def outer():
    x = 10
    def inner():
        return x
    return inner

f = outer()
f()   # 10

# 캡처 확인
f.__closure__
# (<cell at 0x..., int object at 0x...>,)

f.__closure__[0].cell_contents
# 10
```

자, 천천히요. `outer`가 끝나면 보통 그 안의 x는 사라져야 해요. 함수가 끝나면 그 작업 공간이 치워지니까요. 그런데 `inner`가 x를 쓰고 있죠. 그래서 Python은 x를 cell이라는 특별한 상자에 담아 둬요. 그리고 inner가 그 cell을 참조해요. outer가 끝나도, inner가 cell을 붙잡고 있으니 cell은 안 사라져요. 그 안의 x도 살아 있고요.

`f.__closure__`를 보면 cell이 들어 있어요. `f.__closure__[0].cell_contents`를 보면 그 안의 값 10이 나와요. 이게 closure의 비밀이에요. "바깥 함수의 변수를 cell이라는 상자에 담아서, 안쪽 함수가 그 상자를 들고 다닌다." H2에서 비유로만 말한 걸, 오늘 `__closure__`로 진짜 확인한 거예요.

여기서 한 가지 중요한 걸 짚을게요. cell은 "값"이 아니라 "상자"라는 거예요. 무슨 차이냐면, cell 안의 값은 바뀔 수 있어요. nonlocal로 count를 += 1 하면, cell 안의 값이 0에서 1로, 2로 바뀌죠. 그런데 cell이라는 상자 자체는 그대로예요. inner 함수는 그 상자를 가리키고 있고, 상자 안의 내용물만 바뀌는 거예요. 이게 왜 중요하냐면, make_counter가 1, 2, 3을 셀 수 있는 이유거든요. 만약 cell이 그냥 값 복사였다면, count는 영영 0에 머물렀을 거예요. 상자를 공유하니까, 한쪽에서 내용을 바꾸면 다른 쪽도 그 바뀐 값을 봐요. inner가 상자를 들여다볼 때마다 최신 값이 보이는 거죠. "값을 복사하는 게 아니라 상자를 공유한다." 이게 closure의 핵심 메커니즘이에요.

그리고 이 cell 메커니즘이 late binding이라는 유명한 함정의 원인이기도 해요. 반복문 안에서 closure를 여러 개 만들면, 다들 같은 cell(같은 상자)을 공유해서, 마지막 값만 보게 되는 경우가 있어요. 예를 들어 `[lambda: i for i in range(3)]`을 만들면, 세 lambda가 다 2를 돌려줘요. i라는 상자를 셋이 공유하는데, 반복이 끝나면 그 상자엔 마지막 값 2가 들었거든요. 처방은 `lambda i=i: i`처럼 기본값으로 그때의 값을 박제하는 거예요. 이건 좀 어려우니 지금은 "반복문 안 closure는 같은 상자를 공유한다"만 기억하세요. 나중에 이 함정을 만나면 "아, cell을 공유해서 그렇구나" 하고 알아챌 거예요.

그래서 H5에서 RateProvider를 두 개 만들면 각자 따로 센다고 했죠? 이제 그 이유가 명확해요. 각 RateProvider가 자기만의 cell을 가지거든요. `c1 = make_counter()`와 `c2 = make_counter()`는 각자 다른 cell을 들고 있어요. 그래서 c1의 count와 c2의 count가 안 섞여요. cell이 서로 다른 상자니까요. 이게 closure가 "독립된 상태"를 가질 수 있는 메커니즘이에요. 면접에서 "closure가 어떻게 동작하나요?"를 물으면, "바깥 변수를 cell 객체에 캡처하고, 안쪽 함수가 `__closure__`로 그걸 참조해서, 바깥 함수가 끝나도 살아남는다"고 답하면 만점이에요.

---

## 5. function frame과 stack

넷째, frame과 stack이에요. H1에서 "함수가 호출되면 작업 책상(frame)을 받는다"고 했죠. 그 frame의 정체를 봐요.

```python
import inspect

def outer():
    x = 1
    inner()

def inner():
    frame = inspect.currentframe()
    print("My function:", frame.f_code.co_name)
    print("Caller:", frame.f_back.f_code.co_name)
    print("Caller locals:", frame.f_back.f_locals)

outer()
```

`inspect.currentframe()`로 지금 frame을 꺼내요. frame은 함수의 모든 상태를 담은 객체예요. 지역 변수(`f_locals`), 코드(`f_code`), 지금 실행 중인 줄 번호(`f_lineno`), 그리고 나를 부른 이전 frame(`f_back`)까지요. 함수가 실행되는 동안 필요한 모든 정보가 이 frame 하나에 들어 있어요. H1에서 "작업 책상"이라고 비유한 게 정확히 이거예요. 책상 위에 변수도, 지금 보는 코드 줄도, 어디서 왔는지도 다 놓여 있는 거죠. `f_back`이 중요해요. inner의 frame에서 `f_back`을 보면 outer의 frame이 나와요. "누가 나를 불렀는지"를 거슬러 올라갈 수 있는 거예요.

이 frame들이 stack(스택)처럼 쌓여요. outer를 부르면 outer의 frame이 쌓이고, outer가 inner를 부르면 inner의 frame이 그 위에 쌓이죠. inner가 끝나면 inner frame이 치워지고, outer로 돌아와요. 접시를 쌓았다 위에서부터 꺼내는 것처럼요. 이걸 call stack(호출 스택)이라고 해요. 본인이 에러가 났을 때 보는 그 긴 traceback이 사실 이 call stack이에요. "어느 함수가 어느 함수를 불러서 여기까지 왔는지"의 기록이죠.

그런데 이 스택은 무한정 못 쌓여요. 한도가 있어요.

```python
import sys
sys.getrecursionlimit()   # 1000
sys.setrecursionlimit(2000)
```

기본이 1000이에요. 함수가 자기를 1000번 넘게 부르면(깊은 재귀) "RecursionError"가 나요. 스택이 넘친 거죠. 이걸 stack overflow라고 해요. 그 유명한 개발자 사이트 이름이 여기서 왔어요. H2에서 본 "재귀 깊이 폭발" 함정이 이거예요. 처방은 반복으로 바꾸거나, 정 필요하면 setrecursionlimit으로 한도를 올리는 거였죠. 이제 그 안쪽 원리까지 본 거예요.

frame과 stack을 이해하면, 본인이 매일 보는 에러 메시지가 새롭게 읽혀요. 에러가 나면 Python이 긴 traceback을 토해 내잖아요. "File ..., line ..., in 함수이름"이 여러 줄 쌓인 그거요. 그게 사실 call stack을 그대로 출력한 거예요. 맨 아래가 처음 부른 함수(예: main), 맨 위가 실제로 에러가 난 함수예요. 그러니까 traceback을 읽을 때는 맨 위(에러 난 곳)부터 보되, 그 위에서 아래로 "누가 누구를 불러서 여기까지 왔는지" 경로를 읽을 수 있어요. 초보는 traceback이 길면 겁먹고 안 읽는데, 이게 frame 스택의 지도라는 걸 알면 안 무서워요. "아, main이 process를 부르고, process가 convert를 불렀는데, convert에서 터졌구나"가 보이거든요. 에러를 추적하는 게 사실 이 frame 스택을 거슬러 올라가는 거예요. 오늘 frame을 배운 덕분에, 본인은 이제 traceback을 지도처럼 읽을 수 있어요.

그리고 `f_back`을 거슬러 올라갈 수 있다는 게, 디버거가 동작하는 원리이기도 해요. H3에서 배운 VS Code 디버거의 "Call Stack" 패널 기억하세요? 그게 바로 이 frame들의 `f_back` 사슬을 보여 주는 거예요. 디버거에서 멈췄을 때 "이 함수를 누가 불렀지?"를 클릭으로 거슬러 올라가는 게, 코드로는 `frame.f_back`을 따라가는 거죠. 디버거가 마법처럼 호출 경로를 보여 주는 게, 사실 이 frame 메커니즘 위에 만들어진 거예요. 본인이 오늘 그 디버거의 속까지 본 거고요.

---

## 6. function object의 속성

다섯째, 함수 객체의 속성이에요. H1에서 "함수는 일급 객체"라고 했죠. 객체니까 속성을 가져요. 그 속성들을 봐요.

```python
def greet(name: str) -> str:
    """Greeting."""
    return f"Hi {name}"

greet.__name__        # 'greet'
greet.__doc__         # 'Greeting.'
greet.__annotations__ # {'name': str, 'return': str}
greet.__defaults__    # None
greet.__code__        # <code object>
greet.__module__      # '__main__'
greet.__qualname__    # 'greet'
greet.__globals__     # 모듈 globals
```

함수가 자기 이름(`__name__`), docstring(`__doc__`), type hints(`__annotations__`), 기본값(`__defaults__`), 그리고 실제 코드(`__code__`)까지 다 품고 있어요. H3에서 inspect로 캤던 정보들이 사실 이 속성들이에요. inspect는 이 속성들을 예쁘게 꺼내 주는 도구였던 거죠.

이게 왜 중요하냐면, 데코레이터가 이 속성들을 다뤄요. H4·H5에서 "@functools.wraps를 안 붙이면 함수 이름이 wrapper로 바뀐다"고 했죠. 그 이유가 이거예요. 데코레이터가 원래 함수를 wrapper로 감싸면, 밖에서 보이는 건 wrapper의 `__name__`("wrapper")이에요. 원래 함수의 `__name__`("greet")이 가려지죠. `@functools.wraps`가 하는 일은, 원래 함수의 이 속성들(`__name__`·`__doc__`·`__annotations__`)을 wrapper로 복사해 주는 거예요. 그러면 데코레이터를 씌워도 원래 함수의 정체가 보존돼요. H5에서 @wraps를 꼭 붙이라고 한 게, 이 속성 보존 때문이었어요. 이제 그 안쪽까지 본 거예요.

함수가 객체라서 생기는 재밌는 일이 하나 더 있어요. 함수에 본인이 직접 속성을 붙일 수도 있어요. `greet.call_count = 0`처럼요. 함수도 객체니까, 객체에 속성을 다는 게 가능하거든요. 가끔 함수가 자기 호출 횟수를 기억하게 하거나, 캐시를 함수 자신에 붙이거나 할 때 써요. 다만 이건 좀 특이한 기법이라 자주 쓰진 않아요. 중요한 건 "함수가 그냥 코드 덩어리가 아니라, 이름표도 달고 메모도 붙일 수 있는 진짜 객체"라는 걸 느끼는 거예요. H1에서 "함수는 일급 객체"라고 한 게, 여기까지 와닿죠. 함수를 변수에 담고, 인자로 넘기고, 속성을 달고, 정보를 캐고. 함수가 숫자나 문자열처럼 완전한 하나의 값이에요. 이 사실이 lambda·closure·decorator를 다 가능하게 만든 토대였어요. 오늘 본인은 그 토대의 끝까지 본 거예요.

---

## 7. decorator 내부

여섯째, 데코레이터의 완전한 정체예요. H5에서 본인이 직접 짰던 데코레이터, 그 속을 끝까지 봐요.

```python
@timer
def slow():
    ...

# 위는 사실 이것과 똑같아요
def slow():
    ...
slow = timer(slow)
```

`@timer`는 마법이 아니라, `slow = timer(slow)`의 예쁜 표기예요. timer가 slow를 받아서, 새 함수(wrapper)를 돌려주고, 그걸 다시 slow라는 이름에 붙이는 거죠. 그래서 이제 `slow()`를 부르면 사실 wrapper가 불려요.

```python
def timer(func):
    def wrapper(*args, **kwargs):
        # 시간 측정
        return func(*args, **kwargs)
    return wrapper
```

여기서 모든 게 만나요. `wrapper`는 closure예요. 바깥의 `func`를 cell에 캡처하거든요. `wrapper.__closure__`를 보면 func가 들어 있어요. 그래서 wrapper가 나중에 불려도, 자기가 감싼 원래 함수 func를 기억하고 있죠. `*args, **kwargs`는 어떤 인자든 받아서 func에 그대로 넘기려는 거고요. 오늘 배운 cell, closure, 그리고 H2의 \*args·\*\*kwargs가 데코레이터 하나에 다 모여 있어요.

그러니까 데코레이터를 한 문장으로 정리하면 이래요. "함수를 받아, 그 함수를 cell에 캡처한 closure(wrapper)를 만들어 돌려주고, 그걸 원래 이름에 다시 붙이는 것." 본인이 H5에서 무서워하며 짰던 데코레이터가, 사실 오늘 배운 closure와 cell로 다 설명돼요. 마법이 완전히 풀렸죠. 그리고 `@functools.wraps`는 그 과정에서 원래 함수의 속성을 wrapper로 복사하는 거고요. 데코레이터의 모든 조각이 이제 본인 손에 있어요.

이 시점에서 함수 챕터 전체가 하나로 이어지는 게 느껴지죠. H1에서 "함수는 일급 객체"를 배웠고, H2에서 closure와 \*args·\*\*kwargs를 배웠고, H5에서 데코레이터를 손으로 짰고, 오늘 H7에서 그게 cell·closure로 동작한다는 걸 봤어요. 하나하나 따로 배운 게 아니라, 다 데코레이터라는 한 점에서 만나요. 일급 객체라서 함수를 받고 돌려줄 수 있고(H1), closure라서 원래 함수를 기억하고(H2·H7), \*args로 어떤 인자든 넘기고(H2), 그래서 데코레이터가 가능한 거예요(H5). 강의가 흩어진 조각이 아니라 한 그림을 그려 온 거죠. 본인이 이걸 깨달으면, 앞으로 새로운 개념을 배울 때도 "이게 전에 배운 거랑 어떻게 이어지지?"를 자연스럽게 묻게 돼요. 그 연결을 보는 눈이 깊은 이해예요. 본인은 오늘 함수 챕터의 모든 조각이 데코레이터에서 만나는 걸 봤어요.

---

## 8. async function 내부

일곱째, 비동기 함수의 내부예요. Ch008 H7과 H4에서 본 그거예요.

```python
async def fetch():
    await something()

# 호출하면 coroutine 객체
coro = fetch()
type(coro)   # <class 'coroutine'>

# 실행은 event loop가
import asyncio
asyncio.run(coro)
```

여기서 중요한 사실 하나. `async def` 함수를 그냥 부르면 실행이 안 돼요. coroutine(코루틴) 객체만 나와요. H4에서 본 함정이죠. "분명 불렀는데 왜 안 돌지?" 하는 그거요. 비동기 함수는 `asyncio.run`이나 `await`으로 시동을 걸어야 실제로 돌아가요. `type(coro)`를 찍으면 `<class 'coroutine'>`이 나오는 게 그 증거예요. 일반 함수는 부르면 바로 결과가 나오는데, 비동기 함수는 "실행할 준비가 된 coroutine"이라는 포장지만 나와요. 그 포장을 event loop가 풀어서 실제로 돌리는 거죠. 이 한 단계가 비동기를 처음 만나는 사람을 헷갈리게 해요. "함수 = 부르면 실행"이라는 상식이 안 통하거든요. 그래서 비동기는 "부르기"와 "실행"이 분리돼 있다고 기억하세요.

coroutine은 사실 generator의 진화예요. Ch008 H7에서 generator가 yield로 값을 하나씩 흘린다고 했죠. coroutine은 그 yield가 await으로 바뀐 거예요. generator가 "여기서 멈췄다가 다시 이어서"를 하듯, coroutine도 "여기서 기다림에 멈췄다가, 응답 오면 다시 이어서"를 해요. 그 멈췄다 잇는 걸 event loop(이벤트 루프)가 관리해요. event loop가 "이 코루틴은 지금 기다리는 중이니, 다른 코루틴을 돌리자" 하고 교통정리를 하는 거죠. 그래서 H4의 라면 비유처럼, 기다리는 시간에 다른 일을 할 수 있어요.

그리고 오해 하나를 미리 깨면, async는 thread(스레드)가 아니에요. thread는 진짜 여러 일꾼이 동시에 일하는 거고, async는 한 일꾼이 기다리는 틈에 다른 일을 하는 거예요. coroutine + event loop, 한 스레드 안에서 협력적으로 돌아가요. 이건 Ch007 H7에서 본 GIL과도 연결돼요. Python은 GIL 때문에 한 번에 한 스레드만 Python 코드를 실행하는데, async는 그 한 스레드를 효율적으로 쓰는 방법이에요. 자경단은 매일 I/O 많은 일(HTTP, DB)에 async를 써요. 깊은 건 Ch020에서요.

"협력적"이라는 말을 한 번 더 풀게요. async가 thread와 다른 결정적 차이가 이거예요. thread는 운영체제가 일꾼들을 강제로 번갈아 일시키는 거예요(선점적). 언제 바뀔지 일꾼들도 몰라요. 그래서 둘이 같은 데이터를 건드리면 충돌(race condition)이 나죠. Ch002에서 본 그거예요. 반면 async는 코루틴들이 "내가 기다리는 동안 너 해"라고 자발적으로 양보해요(협력적). 양보하는 지점이 정확히 `await`이에요. await을 만나야 다른 코루틴에게 차례가 넘어가요. 그래서 await이 없으면 한 코루틴이 끝까지 독차지해요. 이게 장점이자 단점이에요. 장점은, 양보 지점이 명확해서 충돌이 거의 없어요. 단점은, 한 코루틴이 await 없이 CPU를 오래 쓰면 다른 게 다 멈춰요. 그래서 async에서는 무거운 계산(await 없는)을 피해야 하고, CPU 일은 따로 빼야 해요. H4에서 "CPU 일은 multiprocessing"이라고 한 게 이 때문이에요. 협력의 규칙을 깨는 코루틴 하나가 전체를 멈추니까요.

coroutine이 generator의 진화라는 걸 한 번 더 음미하면 재밌어요. Ch008 H7에서 generator의 yield가 "여기서 잠깐 멈췄다가 다시 이어서"라고 했죠. async의 await이 정확히 그거예요. await에서 코루틴이 멈추고, event loop가 그 자리를 기억해 뒀다가, 응답이 오면 그 자리부터 다시 이어요. generator가 값을 흘리려고 멈췄다면, coroutine은 기다리려고 멈추는 거죠. 멈췄다 잇는 메커니즘은 똑같아요. 그래서 Python의 async가 generator 위에 지어졌다고 하는 거예요. 본인이 Ch008에서 generator를 잘 봐 둔 게, 오늘 async를 이해하는 토대가 됐어요. 모든 게 연결돼 있죠.

---

## 9. 흔한 오해 다섯 가지

**오해 1: global을 쓰면 코드가 깔끔해진다.**

아니에요. 자경단은 global을 거의 안 써요. 전역을 건드리면 impure가 되고, 어디서 바뀌었는지 추적이 안 돼요. H6에서 배운 거죠. 필요한 건 인자로 받고 결과로 돌려주세요. global은 당장은 편해 보여도, 코드가 커지면 반드시 발목을 잡아요.

**오해 2: closure는 비싸다(메모리를 많이 쓴다).**

아니에요. cell 하나만 추가될 뿐이라 가벼워요. 다만 closure가 아주 큰 객체를 캡처하면, 그 객체가 closure 살아 있는 동안 안 치워져요. 그것만 주의하면 closure는 가벼운 도구예요. 보통의 카운터나 설정 정도는 전혀 부담이 안 돼요.

**오해 3: stack overflow가 자주 난다.**

거의 안 나요. 1000 깊이는 보통의 코드에선 안 닿아요. 깊은 재귀를 짤 때만 만나죠. 대부분의 재귀는 그보다 훨씬 얕아요. 만약 stack overflow가 났다면, 보통은 재귀의 종료 조건을 빠뜨려서 무한 재귀에 빠진 거예요. "언제 멈출지"를 안 적으면 함수가 자기를 영원히 부르거든요. 깊이 한계가 오히려 그 무한 재귀를 빨리 잡아 주는 안전장치예요.

**오해 4: decorator는 마법이다.**

오늘 끝까지 봤죠? 마법이 아니라 "함수를 받아 closure를 돌려주는 것"이에요. cell과 closure로 다 설명돼요. 본인은 이제 그 정체를 알아요. 골뱅이(@) 기호가 신비로워 보였지만, 그냥 `f = deco(f)`의 짧은 표기였을 뿐이죠.

**오해 5: async는 thread다.**

아니에요. async는 coroutine + event loop예요. 한 스레드 안에서 기다림의 틈을 활용하는 거죠. 진짜 동시 실행인 thread와는 달라요.

다섯 오해를 부수고 나니, 오늘 시간의 큰 메시지가 보여요. "어려워 보이는 것의 속을 보면, 결국 단순한 부품의 조합"이라는 거예요. closure는 cell이라는 상자, frame은 함수의 상태 보따리, 데코레이터는 closure에 이름을 다시 붙인 것, async는 generator의 진화. 다 한 꺼풀 벗기면 본인이 이미 아는 것들로 설명돼요. 새로운 마법이 아니라, 익숙한 부품의 새로운 조합인 거죠. 이게 컴퓨터 과학의 아름다움이에요. 거대하고 복잡해 보이는 시스템도, 끝까지 파고들면 단순한 원리 몇 개로 지어져 있어요. 본인이 오늘 그걸 함수에서 체험했어요. 앞으로 본인이 만날 모든 복잡한 기술 — 데이터베이스, 웹 프레임워크, 클라우드 — 도 마찬가지예요. 겉은 복잡해도 속은 단순한 원리의 조합이에요. 그러니 어떤 기술 앞에서도 "속을 보면 별거 아닐 거야"라는 배짱을 가지세요. 오늘 함수의 속을 끝까지 본 본인이라면, 그 배짱을 가질 자격이 있어요.

---

## 10. 흔한 실수 다섯 + 안심 — 함수 깊이 학습 편

함수 내부를 배우며 자주 빠지는 함정 다섯 개예요.

**첫째, closure를 무작정 쓰기.** 안심하세요. closure는 "상태를 기억하는 함수가 필요할 때"만 쓰세요. 명확한 의도가 있을 때요. 그냥 멋있어 보여서 쓰면 코드가 헷갈려져요. 단순한 함수로 될 일을 closure로 꼬지 마세요.

**둘째, 데코레이터를 한 번에 다 익히려 하기.** 안심하세요. @lru_cache 하나부터 써 보세요. 직접 짜는 건 @timer 정도면 충분해요. 복잡한 데코레이터(인자를 받는 데코레이터 등)는 나중에요. 그건 함수가 3중으로 중첩돼서 머리가 아프거든요. 천천히 가도 돼요.

**셋째, generator와 iterator를 헷갈리기.** 안심하세요. Ch008 H7에서 배웠죠. yield가 있으면 generator, `__next__`가 있으면 iterator. generator는 iterator의 한 종류예요. 둘을 굳이 구분 안 해도 일상에선 괜찮아요.

**넷째, \*args·\*\*kwargs를 양쪽에 강제로 쓰기.** 안심하세요. 데코레이터의 wrapper처럼 "어떤 인자든 받아야 할 때"만 쓰세요. 보통 함수는 인자를 명시하는 게 나아요. 명시된 인자가 읽기 쉽고 실수도 덜 나거든요.

**다섯째, 가장 큰 함정 — 함수로 클래스를 흉내 내기.** 안심하세요. closure로 상태를 너무 복잡하게 관리하려 들면, 차라리 클래스(Ch011)가 나아요. closure는 가벼운 상태에, 복잡한 상태는 클래스에. 도구를 상황에 맞게요.

이 다섯째 함정이 사실 다음 챕터로 가는 다리이기도 해요. closure로 상태를 관리하다 보면, 상태가 둘, 셋, 넷으로 늘어나는 순간이 와요. RateProvider가 rates만이 아니라 history도, 설정도, 통계도 기억해야 한다면? closure로는 점점 버거워져요. 함수 여러 개를 돌려주고, nonlocal을 여러 개 선언하고... 복잡해지죠. 그때가 클래스를 쓸 때예요. 클래스는 "데이터와 그걸 다루는 함수를 한 묶음으로" 깔끔하게 관리하거든요. closure가 그 클래스의 가벼운 사촌이라고 했죠. 그러니까 본인이 closure가 버겁다고 느끼는 순간, 그게 "이제 클래스를 배울 때"라는 신호예요. 마침 Ch011이 클래스(OOP)예요. 오늘 closure의 한계를 본 게, 클래스가 왜 필요한지를 미리 느끼게 해 줘요. 모든 도구엔 한계가 있고, 그 한계가 다음 도구를 부르는 거예요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 가요.

---

## 11. 마무리

자, 함수의 일곱 번째 시간이 끝났어요. 가장 깊은 시간이었죠.

오늘 본인은 함수의 가장 깊은 속을 팠어요. LEGB scope 규칙(변수를 안쪽부터 찾기), global/nonlocal(쓰기 키워드), closure cell 객체(바깥 변수를 담는 상자), frame과 stack(함수 호출이 쌓이는 구조), function 객체의 속성, 데코레이터의 완전한 정체, 그리고 async 함수의 내부까지요. H2·H5에서 비유로만 알던 cell과 closure를, 오늘 `__closure__`로 진짜 확인했어요.

오늘의 약속을 지켰어요. 본인은 이제 함수 호출 시 일어나는 메커니즘을 만져 봤어요. 함수가 마법이 아니라, cell과 frame이라는 정직한 부품으로 돌아가는 기계라는 걸 봤죠. 본인은 이제 closure나 데코레이터 앞에서 안 무서워요. 속을 봤으니까요. 그리고 면접에서 "closure가 어떻게 동작하나요?"를 물으면, cell 객체까지 설명할 수 있어요. 그게 본인을 시니어처럼 보이게 해요.

솔직히 오늘 내용은 매일 쓰진 않아요. 그래도 한 번 깊이 본 게 중요해요. Ch006 셸의 fork/exec, Ch007 Python의 bytecode/GIL, Ch008 흐름의 iterator/generator, 그리고 오늘 함수의 closure/cell. 본인은 매번 "내가 매일 쓰는 것의 속"을 한 번씩 봤어요. 그 경험이 쌓여, 본인은 어떤 코드 앞에서도 "결국 정직한 기계겠지"라는 침착함을 갖게 돼요. 그게 본인을 깊이 있는 개발자로 만들어요.

본인이 이 다섯 번째 H7(내부 시간)을 겪으면서, 한 가지 패턴을 알아챘으면 좋겠어요. 모든 챕터의 H7이 "내부"예요. 셸, Python, 흐름, 함수, 그리고 앞으로 올 모든 기술의 H7에서 본인은 그 속을 봐요. 왜 자경단이 매번 속을 보여 줄까요? "도구를 쓰는 사람"이 아니라 "도구를 아는 사람"으로 키우려는 거예요. 쓰기만 하는 사람은 도구가 고장 나면 멈춰요. 아는 사람은 고쳐 써요. 그리고 새 도구가 와도, 속의 원리가 비슷하니 금방 익혀요. 본인은 지금 그 "아는 사람"으로 자라고 있어요. 매 챕터의 H7이 본인을 한 뼘씩 더 깊게 만들어요. 오늘 cell과 frame을 본 게, 그 깊이의 한 켜예요. 당장 안 써먹어도, 본인 안에 단단한 토대로 쌓여요.

다음 H8은 함수 챕터의 마지막, 적용과 회고예요. 7시간을 한 페이지로 묶고, v3의 진화를 돌아보고, Ch010 자료구조로 가는 다리를 놓아요. 그 전에 마지막으로 이 한 줄을 쳐 보세요.

```python
def outer():
    x = 1
    def inner():
        return x
    return inner
print(outer().__closure__[0].cell_contents)
```

`1`이 나와요. outer가 끝났는데도, inner가 cell에 담아 둔 x(1)가 살아 있죠. 본인이 이 한 줄을 이해하면, 오늘 closure의 가장 깊은 속을 본 거예요.

오늘 어려웠죠? 솔직히 H7은 함수 챕터에서 가장 머리 아픈 시간이에요. cell이니 frame이니 낯선 단어가 쏟아졌으니까요. 그런데 본인이 여기까지 왔다는 게 대단한 거예요. 많은 사람이 "내부"라고 하면 어렵다고 건너뛰어요. 본인은 안 건너뛰었어요. 오늘 다 이해 못 했어도 괜찮아요. 한 번 본 것과 안 본 것은 천지차이거든요. 나중에 closure 함정을 만나거나, 면접에서 cell 질문을 받으면, "아, H7에서 봤던 거다" 하고 떠올라요. 그때 진짜 본인 것이 돼요. 오늘은 씨앗을 심은 거예요. 다음 시간에 봐요. 함수 챕터를 닫아요. 오늘 어려운 시간 끝까지 와 주셔서 정말 고마워요. 본인이 정말 자랑스러워요. 🐾

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - LEGB: PEP 227(nested scopes). 변수 해석은 컴파일 타임에 결정(`LOAD_FAST`/`LOAD_DEREF`/`LOAD_GLOBAL`/`LOAD_NAME`). dis로 확인 가능.
> - cell object: free variable을 담는 컨테이너. `func.__closure__`는 cell 튜플, `__code__.co_freevars`는 이름. nonlocal/global 선언이 바인딩 방식 결정.
> - frame: `PyFrameObject`. `f_locals`·`f_globals`·`f_back`·`f_code`·`f_lineno`. `f_locals` 쓰기는 비영구(CPython 구현 세부). sys.setrecursionlimit로 한도 조정.
> - function object 속성: `__name__`·`__doc__`·`__annotations__`·`__defaults__`·`__kwdefaults__`·`__code__`·`__closure__`·`__globals__`·`__qualname__`.
> - decorator: `@d` = `f = d(f)`. wrapper는 closure(`__closure__`에 원본 func cell). functools.wraps가 `__wrapped__`·메타데이터 복사.
> - async: PEP 492. coroutine은 generator 기반(`__await__`). event loop(asyncio)가 스케줄. 단일 스레드 협력적 멀티태스킹, GIL과 무관하게 I/O 대기 활용.
> - 다음 H8 키워드: 7H 회고 · v3 진화 · 함수 다섯 원리 · Ch010 자료구조 다리.

---

## 추신

1. 함수 내부 — LEGB·global/nonlocal·cell·frame·decorator·async.
2. 오늘의 약속 — 함수 호출 메커니즘을 만집니다.
3. LEGB — Local·Enclosing·Global·Builtin. 변수 찾는 순서.
4. 양파 껍질 — 안쪽부터 바깥으로.
5. print·len은 Builtin(B). 그래서 어디서나 써요.
6. 읽기는 LEGB, 쓰기는 기본 Local.
7. UnboundLocalError — Local 만든다 선언 후 읽으려다 터짐.
8. global = 바깥 Global 고치기. 자경단 거의 안 씀.
9. nonlocal = 바깥 Enclosing 고치기. closure에만.
10. cell = closure가 바깥 변수를 담는 상자.
11. f.__closure__[0].cell_contents로 값 확인.
12. outer 끝나도 inner가 cell 붙잡아 x 살아남음.
13. RateProvider 둘이 각자 cell. 그래서 안 섞여요.
14. frame = 함수의 모든 상태(locals·code·lineno·back).
15. f_back = 나를 부른 이전 frame. 거슬러 올라가기.
16. call stack = frame들이 쌓임. traceback이 이거.
17. 재귀 깊이 1000 한계. 넘으면 RecursionError(stack overflow).
18. 함수는 객체 — __name__·__doc__·__code__ 등 속성.
19. inspect는 이 속성을 꺼내는 도구.
20. @wraps는 원본 속성을 wrapper로 복사.
21. @timer = slow = timer(slow). 예쁜 표기.
22. wrapper는 closure. func를 cell에 캡처.
23. 데코레이터 = 함수 받아 closure 돌려주기.
24. async def 그냥 부르면 coroutine 객체만.
25. asyncio.run/await로 시동.
26. coroutine = generator의 진화. yield → await.
27. event loop가 코루틴 교통정리.
28. async ≠ thread. coroutine + event loop, 한 스레드.
29. 오늘 깊은 건 매일 안 써도, 한 번 봄이 중요.
30. 다음 H8은 함수 챕터 마무리. 회고. 🐾
