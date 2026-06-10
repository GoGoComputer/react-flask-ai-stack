# Ch008 · H7 — 흐름 내부 — iterator·generator·async

> 고양이 자경단 · Ch 008 · 7교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. iterator 프로토콜
3. generator와 yield
4. for 루프 내부
5. comprehension의 bytecode
6. async for와 비동기 흐름
7. itertools 내부
8. 흔한 오해 다섯 가지
9. 자주 받는 질문 다섯 가지
10. 흔한 실수 다섯 + 안심 멘트
11. 마무리 — 다음 H8에서 만나요

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 이제 일곱 번째 시간이에요. 거의 다 왔어요. 한 시간 쉬셨죠. 물 한 잔 드시고요.

지난 H6를 한 줄로 회수할게요. 본인은 v2를 우아한 운영 코드로 다듬으셨어요. early return으로 평평하게, guard clause로 입구에서 거르고, 복잡도를 radon으로 재고. 도구가 못 잡는 코드의 구조를 다듬는 법을 배웠죠.

이번 H7은 본 챕터에서 가장 깊은 시간이에요. 지금까지 본인은 for 루프를 "사용하는" 법을 배웠어요. 이번엔 for 루프가 "어떻게 동작하는지" 그 속을 열어 봐요. Ch006 셸 H7에서 fork·exec를, Ch007 Python H7에서 CPython·GIL을 봤듯, 이번엔 흐름의 속을 봐요. 본인이 `for x in xs`를 쓸 때 안에서 진짜로 무슨 일이 일어나는지, iterator라는 약속과 generator라는 마법을 만지는 시간이에요.

오늘의 약속은 한 가지예요. **본인이 for 루프 내부 메커니즘을 손에 잡습니다**. 한 시간 후엔 for가 마법에서 정직한 기계로 변해요. 그리고 generator와 yield, iterable과 iterator 같은, 면접에 단골로 나오는 단어들의 정체도 알게 돼요. 이 단어들에 막힘없이 답하는 본인을 면접관이 보면 "이 사람 깊이가 있네" 하고 끄덕여요.

미리 안심 멘트. 이번 시간은 좀 어려워요. 추상적인 개념이 많아요. 다 이해 못 하셔도 괜찮아요. "for 안에 iterator가 있고, generator는 lazy하다"는 그림만 남으면 오늘은 성공이에요. 그리고 솔직히 말씀드리면, 오늘 내용은 본인이 매일 쓰는 게 아니에요. 한 달에 한 번도 안 쓸 수 있어요. 그런데 면접에 나오고, 큰 데이터 앞에서 나오고, Python을 깊이 이해하는 토대가 돼요. 그러니까 외우려 하지 말고, 편하게 구경한다는 마음으로 따라오세요. 자, 가요.

---

## 2. iterator 프로토콜

Ch008 H1에서 "for는 사실 iter+next의 자동화"라고, H4에서 "iter/next로 iterator 직접 다루기"를 살짝 말했죠. 오늘 그 속을 제대로 봐요. Python의 모든 iterable이 따르는 약속이 있어요. 그걸 iterator 프로토콜이라고 해요. 약속이란 "이런 메서드를 가지고 있어야 for에서 돌 수 있다"는 규칙이에요. 이 규칙을 지키는 객체는 다 for에서 돌고, 안 지키는 객체는 "not iterable" 에러가 나요.

본인이 직접 iterable을 만들어 보면 이 약속이 분명해져요. 코드는 어려워 보여도 괜찮아요. 클래스 문법은 Ch011에서 배우니까, 지금은 "이런 메서드들이 있어야 for에서 돈다"는 그림만 보세요.

```python
class MyList:
    def __init__(self, items):
        self.items = items
    
    def __iter__(self):
        return MyIterator(self.items)

class MyIterator:
    def __init__(self, items):
        self.items = items
        self.idx = 0
    
    def __next__(self):
        if self.idx >= len(self.items):
            raise StopIteration
        val = self.items[self.idx]
        self.idx += 1
        return val
```

두 개의 특별한 메서드가 핵심이에요. `__iter__`(이중 밑줄로 감싼 이름이라 "던더 iter"라고 읽어요. dunder는 double underscore의 줄임말이에요)는 iterator를 돌려줘요. `__next__`는 다음 값을 줘요. 그리고 더 줄 게 없으면 StopIteration이라는 예외를 던져서 "끝났어요"라고 알려요. 이 StopIteration이 재밌어요. "끝"을 예외로 알리는 거예요. 보통 예외는 에러인데, StopIteration은 정상적인 "다 끝났음" 신호예요. for가 이 예외를 받으면 조용히 멈춰요. 에러로 안 보고 "아, 끝났구나" 하고요.

위 MyList와 MyIterator 두 클래스를 보세요. MyList는 `__iter__`로 MyIterator를 돌려줘요. MyIterator는 `__next__`로 다음 값을 주고, idx로 "지금 몇 번째인지"를 기억해요. 끝에 도달하면 StopIteration을 던지고요. 이게 for의 진짜 동작이에요. 본인이 `for x in ml`을 쓰면, Python이 먼저 ml의 `__iter__`를 불러서 iterator를 얻어요. 그 다음 iterator의 `__next__`를 계속 불러서 값을 하나씩 받아요. StopIteration이 나오면 멈춰요. 본인은 이 복잡한 과정을 한 줄로 쓰고, Python이 다 처리해 줘요.

```python
ml = MyList([1, 2, 3])
for x in ml:
    print(x)
```

for가 자동으로 iter() + next()를 반복해요. 본인은 `__next__`를 직접 안 부르지만, for가 뒤에서 부르고 있어요. 이게 우아한 설계예요. 본인이 어떤 객체든 `__iter__`와 `__next__`만 만들어 주면, 그 객체는 for에서 돌 수 있어요. 리스트든, 파일이든, 데이터베이스 결과든, 심지어 무한히 이어지는 숫자열이든요. for는 그게 뭔지 몰라도 "다음 거 줘"라고만 물어요. 그래서 Python의 for가 강력해요. 약속(프로토콜)만 지키면 뭐든 for에서 돌거든요.

자경단이 매일 만나는 list, dict, set이 다 이 프로토콜을 따라요. 그래서 다 같은 for 문법으로 돌아요. 파일도 마찬가지예요. `for line in file`이 되는 건 파일이 이 프로토콜을 따르기 때문이에요. range도, 문자열도, generator도 다요. 본인이 따로 안 배워도 다 같은 for로 도는 게 이 약속 덕이에요. 본인은 직접 iterator를 만들 일은 드물지만, "모든 for 가능한 것은 이 약속을 지킨다"는 그림을 알면, for가 왜 그렇게 다양한 것에 통하는지 이해돼요.

여기서 iterable과 iterator의 미묘한 차이를 짚고 갈게요. 헷갈리기 쉬운데, 한 번 분명히 해 두면 면접에서도 빛나요. iterable은 "for에서 돌 수 있는 것"이에요. `__iter__`를 가지고 있어요. 리스트가 iterable이에요. iterator는 "실제로 값을 하나씩 꺼내 주는 것"이에요. `__next__`를 가지고 있어요. 그러니까 리스트(iterable)에서 iter()를 부르면 iterator가 나오고, 그 iterator에서 next()를 부르면 값이 나와요. 비유하자면, iterable은 책이고 iterator는 책갈피예요. 책(리스트) 자체는 "읽을 수 있는 것"이고, 책갈피(iterator)는 "지금 몇 페이지인지 기억하며 다음 페이지를 주는 것"이에요. 한 책에 책갈피를 여러 개 꽂을 수 있듯, 한 리스트에서 iterator를 여러 개 만들 수 있어요. 각자 독립적으로 진행해요. 그래서 같은 리스트를 두 for가 동시에 돌아도 안 엉켜요. 각자 자기 iterator(책갈피)를 가지니까요. 반면 iterator 자체는 한 번 소진하면 끝이에요. 책갈피가 책 끝에 도달하면 더는 못 읽죠. 그래서 generator(iterator의 일종)를 두 번 for로 돌리면, 두 번째는 비어 있어요. 이미 소진됐거든요. 이게 H4에서 "generator는 한 번만 훑고 버릴 때"라고 한 이유예요. 이 iterable vs iterator 구별이 처음엔 헷갈리지만, "책(iterable) vs 책갈피(iterator)"로 기억하면 평생 안 헷갈려요. 면접에서 이 비유로 답하면 면접관이 좋아해요.

---

## 3. generator와 yield

자, 그런데 위에서 iterator를 직접 만들려면 클래스 두 개에 메서드 여러 개가 필요했죠. 복잡해요. Python에는 iterator를 훨씬 쉽게 만드는 마법이 있어요. generator(제너레이터)예요. yield라는 키워드 하나로 만들어요.

```python
def count_up_to(n):
    i = 0
    while i < n:
        yield i
        i += 1

for x in count_up_to(5):
    print(x)
# 0, 1, 2, 3, 4
```

이 함수가 위의 클래스 두 개가 하던 일을 다 해요. 그런데 훨씬 짧죠. 클래스 두 개에 메서드 여러 개가 yield 한 줄로 줄었어요. 이게 generator의 우아함이에요. 핵심은 yield라는 키워드예요. yield는 return과 비슷하지만 결정적으로 달라요. return은 함수를 끝내고 값을 돌려줘요. yield는 값을 돌려주되 함수를 끝내지 않고 그 자리에서 잠깐 멈춰요. 그리고 다음에 또 값을 요청받으면, 멈췄던 그 자리(yield 다음 줄)부터 다시 시작해요. 함수가 자기 상태(i가 몇인지)를 기억하고 있다가, 부를 때마다 다음 값을 주는 거예요. 위 count_up_to를 보면, while 루프 안에서 yield i를 해요. i가 0일 때 yield하고 멈추고, 다음에 부르면 i += 1을 한 다음 다시 while로 돌아가서 yield i. 이렇게 0, 1, 2, 3, 4를 하나씩 줘요. i라는 상태가 yield 사이에 보존되는 게 핵심이에요.

비유로 가 볼게요. return은 책을 다 읽고 덮는 거예요. 끝이에요. yield는 책을 읽다가 책갈피를 꽂고 잠깐 덮는 거예요. 다음에 펴면 책갈피 자리부터 이어 읽어요. generator는 이렇게 책갈피를 꽂아 가며 한 페이지씩 주는 함수예요.

한 가지 신기한 점을 더 알려드릴게요. yield가 있는 함수는 호출해도 바로 실행되지 않아요. `gen = count_up_to(5)`라고 하면, 이 줄에서는 함수 안의 코드가 한 줄도 안 돌아요. 대신 generator 객체 하나를 돌려줘요. 함수가 "실행 준비만 된" 상태로 멈춰 있는 거예요. 그러다 본인이 next()를 부르거나 for에서 돌릴 때, 비로소 첫 yield까지 실행돼요. 이게 일반 함수와 완전히 달라요. 일반 함수는 부르면 끝까지 실행되고 결과를 주죠. generator 함수는 부르면 "리모컨"을 주고, 본인이 그 리모컨의 버튼(next)을 누를 때마다 한 칸씩 실행돼요. 그래서 generator는 "본인이 통제하는 실행"이에요. 본인이 원할 때, 원하는 만큼만 값을 받아요. 이 통제권이 lazy의 본질이에요. 값을 미리 다 만드는 게 아니라, 본인이 요청할 때 그때그때 만드는 거죠. 본인이 100개만 필요하면 100번만 next를 부르고, generator는 딱 100개만 만들어요. 나머지는 영영 안 만들어요. 이게 1조 개 generator가 메모리를 안 터뜨리는 비결이에요. 안 만드니까요.

generator의 가장 큰 장점은 **lazy(게으름)**예요. 값을 미리 다 안 만들고, 요청받을 때마다 하나씩 만들어요. 그래서 메모리를 거의 안 써요. "게으르다"가 여기선 칭찬이에요. 필요할 때까지 일을 미루는 게 메모리를 아끼는 거니까요. 부지런히 1조 개를 미리 다 만드는 list보다, 게으르게 하나씩 만드는 generator가 영리해요.

```python
def big_generator():
    for i in range(10**12):
        yield i

# 메모리 폭발 없음. 한 번에 한 값만.
for x in big_generator():
    if x > 100:
        break
```

이 generator는 1조 개(10의 12승)의 숫자를 만들 수 있어요. 그런데 메모리가 안 터져요. 왜냐하면 1조 개를 미리 안 만들거든요. for가 하나 요청하면 하나 만들고, 또 요청하면 다음 거 만들고. 그래서 위 코드는 100을 넘는 순간 break로 멈춰서, 실제로는 102개 정도만 만들고 끝나요. 1조 개 중에 102개만 만든 거예요. 나머지 999,999,999,898개는 영영 안 만들어요. 필요 없으니까요. 만약 이걸 list로 만들었으면 1조 개가 메모리에 떠서 컴퓨터가 죽었을 거예요. 정수 하나가 28바이트(Ch007 H7)니까, 1조 개면 28TB예요. 어떤 컴퓨터도 못 버텨요. generator는 그걸 102개, 약 3KB로 줄여요. 이게 lazy의 마법이에요. 이게 H2·H4에서 본 generator expression `(x for x in ...)`의 정체예요. 괄호로 감싼 comprehension이 바로 이 generator를 만드는 거예요. 그리고 range도 사실 이런 lazy 동작을 해요.

자경단이 generator를 매일 쓰는 곳은 세 군데예요. 첫째, 큰 파일 처리. 천만 줄짜리 로그를 한 줄씩 흘려 읽을 때. 둘째, 무한 시퀀스. "끝없이 이어지는 ID 번호"나 "끝없는 페이지 번호" 같은 걸 만들 때. 셋째, lazy 변환. 큰 데이터를 한 번에 하나씩 변환하며 흘려 보낼 때. 이 셋이 다 "한 번에 다 들고 있으면 메모리가 터지는" 상황이에요. generator는 "큰 데이터를 메모리 폭발 없이 다루는" 비결이에요. 본인이 두 해 코스에서 큰 데이터를 만날 때, generator가 본인의 메모리를 지켜요.

첫째, 큰 파일 처리를 한 장면으로 보여드릴게요. 미니가 10GB짜리 로그 파일을 분석해야 해요. 이걸 `lines = file.readlines()`로 한 번에 다 읽으면, 10GB가 메모리에 떠서 컴퓨터가 죽어요. 그런데 `for line in file:`로 돌면 안 죽어요. 왜냐하면 파일이 generator처럼 동작해서, 한 줄씩 읽어 주거든요. 10GB든 100GB든, 메모리엔 한 줄만 있어요. 한 줄 처리하고, 버리고, 다음 줄 읽고. 그래서 미니는 작은 노트북으로도 100GB 로그를 분석해요. 이게 lazy의 힘이에요. 만약 generator라는 개념이 없었으면, 큰 데이터를 다루려면 그만큼 큰 메모리가 필요했을 거예요. generator 덕에 본인은 작은 메모리로 무한히 큰 데이터를 흘려 처리할 수 있어요. 강물을 한 컵으로 다 못 담지만, 한 컵씩 떠서 마실 수는 있잖아요. generator가 그 한 컵이에요. 데이터를 강물처럼 흘려 보내며 한 번에 한 컵씩 처리하는 거예요. 이게 Ch006 셸에서 본 파이프(`|`)의 사상과도 같아요. 파이프도 데이터를 한 번에 다 안 들고 흘려 보내죠. generator는 Python 안의 파이프예요. 본인이 셸의 파이프를 이해하면, Python의 generator도 같은 그림으로 이해돼요.

---

## 4. for 루프 내부

이제 §2와 §3을 합쳐서 for 루프의 전체 그림을 그려 볼게요. `for x in xs:`가 안에서 정확히 어떻게 풀리는지요. 본인이 매일 쓰는 그 깔끔한 for 한 줄이, 안에서는 사실 여러 단계로 풀려요. 한 번 펼쳐 볼게요.

```python
# 본인이 짠 코드
for x in [1, 2, 3]:
    print(x)

# 실제 동작
_iter = iter([1, 2, 3])
while True:
    try:
        x = next(_iter)
    except StopIteration:
        break
    print(x)
```

Python이 자동으로 이렇게 변환해요. 본인이 쓴 깔끔한 `for x in xs` 한 줄이, 안에서는 iter로 iterator 만들고, while로 돌면서 next로 값 받고, StopIteration이 나면 break하는 코드로 풀려요. 위 코드의 "본인이 짠 코드"와 "실제 동작"을 비교해 보세요. 위는 두 줄, 아래는 여섯 줄이에요. 본인은 왼쪽의 깔끔한 두 줄만 쓰고, 복잡한 다섯 줄은 Python이 알아서 해 주는 거예요. 그래서 모든 iterable이 for에서 돌아요. for는 그저 iter와 next를 자동으로 부르는 편한 문법(syntactic sugar)이에요. syntactic sugar는 "문법 설탕"이라는 뜻인데, 복잡한 걸 달콤하게(편하게) 만든 문법이라는 거예요. for가 그 대표예요. 속은 복잡하지만 겉은 한 줄로 달콤해요.

Ch007 H7에서 배운 bytecode로 직접 볼 수 있어요.

```python
import dis
dis.dis(compile("for x in [1,2,3]: print(x)", "<>", "exec"))
```

참고로 이 dis 출력은 Python 버전에 따라 명령 이름이 조금 달라요. 3.12에서는 더 최적화돼 있어요. 정확한 명령보다 "for가 bytecode로 쪼개진다"는 그림이 핵심이에요. 이걸 돌리면 GET_ITER, FOR_ITER라는 명령이 보여요. GET_ITER가 위의 `iter([1,2,3])`에 해당하고, FOR_ITER가 `next()` + StopIteration 체크에 해당해요. 본인이 쓴 for 한 줄이 진짜로 이 bytecode 명령들로 쪼개져서 실행되는 거예요. dis로 보면 "for가 마법이 아니라 정직한 기계"라는 게 눈으로 확인돼요. 매일 볼 필요는 없지만, 한 번 보면 for의 속이 손에 잡혀요.

이 for 내부 이해가 실전에서 본인을 구하는 경우가 있어요. 본인이 가끔 "이 객체는 for에서 도는데 저 객체는 왜 안 돌지?"를 만나요. 답은 iterator 프로토콜이에요. for에서 도는 건 `__iter__`가 있는 거고, 안 도는 건 없는 거예요. 에러 메시지에 "object is not iterable"이 뜨면, "아, 이건 iterator 프로토콜을 안 따르는구나"를 알아요. 그러면 list로 바꾸거나, 그 객체의 다른 메서드를 찾아요. for의 속을 알면 이런 에러가 무섭지 않아요. 원인이 보이니까요. 그리고 본인이 두 해 코스에서 직접 iterable 클래스를 만들 일이 올 수도 있어요. 그때 `__iter__`와 `__next__`만 만들어 주면, 본인의 클래스도 for에서 돌아요. 본인만의 데이터 구조를 for로 순회하게 만드는 거예요. 그게 Ch011 객체지향에서 다뤄지는데, 오늘 배운 iterator 프로토콜이 그 토대예요. for의 속을 알면, for를 쓰는 것뿐 아니라 for에서 도는 것을 만들 수도 있게 돼요.

---

## 5. comprehension의 bytecode

본인이 H2·H4에서 매일 쓰는 comprehension의 속을 봐요. 이것도 bytecode로 들여다보면 놀라운 정체가 드러나요.

```python
[x*2 for x in range(5)]
```

bytecode.

```
LOAD_CONST <code>
MAKE_FUNCTION
LOAD_FAST range
LOAD_CONST 5
CALL_FUNCTION 1
GET_ITER
CALL_FUNCTION 1
```

이 bytecode를 보면 LOAD_CONST <code>와 MAKE_FUNCTION이 보여요. 여기서 놀라운 사실 하나. comprehension은 사실 **익명 함수 + 호출**이에요. `[x*2 for x in range(5)]`를 쓰면, Python이 속으로 작은 함수를 하나 만들어서 그 안에서 for를 돌리고 결과를 모아요. MAKE_FUNCTION이라는 bytecode가 그 증거예요. 본인 눈에는 한 줄이지만, 속에서는 별도의 작은 함수가 만들어지고 호출돼요.

이게 comprehension이 일반 for 루프보다 20~30% 빠른 이유예요. 왜 함수로 만들면 빠를까요. 일반 for 루프에서 result.append(...)를 하면, 매번 result라는 변수를 찾고 append라는 메서드를 찾아야 해요. 그런데 comprehension은 함수 안에서 돌면서 결과를 모으는 게 CPython에 최적화돼 있어요. 함수 안의 지역 변수 조회가 더 빠른 방식으로 일어나거든요(Ch007 H7의 LOAD_FAST). 그래서 같은 일을 해도 comprehension이 조금 더 빨라요. 다만 이 속도 차이는 작아요. comprehension을 쓰는 진짜 이유는 속도가 아니라 가독성이에요. 짧고 읽기 쉬우니까요. 속도는 덤이에요. "comprehension은 가독성 때문에 쓰고, 빠른 건 보너스"라고 기억하세요.

그리고 dict comprehension `{k: v for ...}`, set comprehension `{x for ...}`, generator expression `(x for ...)`도 다 같은 메커니즘이에요. 다 속으로 작은 함수를 만들어요. 괄호 모양만 다르지 원리는 같아요. 본인이 이 넷을 따로 외울 필요 없이, "다 익명 함수로 변환되는 한 줄 반복"이라고 이해하면 돼요.

그리고 comprehension이 익명 함수라는 게 한 가지 좋은 부작용을 줘요. 변수 격리예요. comprehension 안에서 쓰는 변수가 바깥으로 새지 않아요. 예를 들어 `[x for x in range(5)]`를 쓴 다음에 바깥에서 x를 쓰려고 하면, x가 없어요. comprehension의 x는 그 안의 작은 함수 안에만 있거든요. 이게 좋은 거예요. 일반 for 루프는 `for x in range(5)`를 돌고 나면 x가 바깥에 5(마지막 값)로 남아요. 그게 가끔 사고를 내요. 본인이 깜빡하고 그 x를 다른 데서 쓰면 엉뚱한 값이거든요. comprehension은 변수가 안 새니까 그 사고가 없어요. 깔끔하게 격리돼요. 이게 comprehension을 선호하는 또 하나의 이유예요. 짧고, 빠르고, 변수가 안 새고. 다만 옛날 Python 2에서는 list comprehension의 변수가 샜어요. Python 3에서 고쳤어요. 그래서 "Python 3의 comprehension은 변수가 격리된다"는 게 또 하나의 장점이에요. 본인은 Python 3.12를 쓰니까 이 격리를 그냥 누리면 돼요.

---

## 6. async for와 비동기 흐름

비동기 iterator.

```python
import asyncio

async def fetch_pages():
    for url in ["url1", "url2", "url3"]:
        page = await fetch(url)
        yield page

async def main():
    async for page in fetch_pages():
        process(page)

asyncio.run(main())
```

async for(비동기 for)는 본인이 두 해 코스 후반에 만날 고급 주제예요. 오늘은 맛보기만요. 어려우면 그냥 "이런 게 있구나" 하고 넘기셔도 돼요. 보통의 for는 값을 받을 때까지 기다려요. 그런데 그 값이 네트워크에서 오는 거라면, 기다리는 동안 컴퓨터가 놀아요. async for는 그 기다리는 시간에 다른 일을 하게 해 줘요. 여러 페이지를 가져올 때, 한 페이지를 기다리는 동안 다른 페이지도 요청해서, 전체가 훨씬 빨라져요.

`async for`가 도는 건 비동기 iterable이에요. 일반 iterator의 `__iter__`·`__next__`에 대응해서, 비동기 버전은 `__aiter__`·`__anext__` 프로토콜을 따라요. 'a'가 async의 a예요. 보세요, 오늘 배운 iterator 프로토콜이 비동기에도 그대로 적용돼요. 던더 메서드에 a만 붙은 거예요. 구조는 똑같아요. 그냥 "기다릴 수 있는" 버전일 뿐이에요. 그래서 본인이 오늘 일반 iterator 프로토콜을 이해하면, 나중에 비동기 버전도 "아, 그거에 a 붙은 거구나" 하고 쉽게 받아들여요. 기초가 고급의 토대예요. Ch007 H7에서 본 GIL 기억하시죠. async가 그 GIL 우회법 중 하나예요. I/O 작업(기다리는 일)이 많을 때, async로 한 thread에서도 수천 개를 동시에 다뤄요.

자경단이 async for를 쓰는 곳은 큰 API 응답을 한 조각씩 lazy하게 처리하거나, WebSocket으로 끝없이 들어오는 메시지를 스트림으로 받을 때예요. 채팅이나 실시간 알림 같은 거요. 오늘은 "비동기 버전의 for도 있고, 기다리는 일에 강하다"는 그림만. 깊이는 두 해 코스 후반에요. 지금은 일반 for와 generator를 손에 익히는 게 먼저예요.

위 코드를 보면 async def, await, async for 같은 새 키워드가 보여요. 지금 다 이해 안 돼도 괜찮아요. async가 왜 기다리는 일에 강한지 한 비유로 짚을게요. 본인이 식당 주방장이라고 해 봐요. 라면을 끓이는데 물이 끓을 때까지 3분 걸려요. 동기(보통) 방식은 그 3분 동안 물만 쳐다보며 기다리는 거예요. 다른 일을 못 해요. 비동기(async) 방식은 물을 올려놓고, 끓는 동안 다른 요리를 하는 거예요. 물이 끓으면 알림을 받고 돌아와요. 그래서 같은 시간에 여러 요리를 해요. 네트워크 요청도 똑같아요. 한 페이지를 기다리는 3초 동안, 동기는 그냥 기다리지만, async는 다른 페이지도 요청해요. 그래서 페이지 100개를 가져올 때, 동기는 300초, async는 3초쯤이에요. 기다리는 시간을 겹치게 하는 거죠. 다만 주방장이 손이 하나라 한 번에 한 동작만 하듯, async도 한 thread라 한 번에 한 코드만 실행해요. 다만 "기다리는 동안 다른 걸 한다"가 핵심이에요. 그래서 async는 "기다리는 일이 많을 때"만 빨라요. 계속 손을 쓰는 무거운 계산은 async로 안 빨라져요. 주방장이 쉴 틈 없이 칼질만 한다면, 비동기든 동기든 칼질 속도는 같으니까요. 이게 Ch007 H7에서 본 "I/O bound는 async, CPU bound는 multiprocessing"의 그림이에요. 오늘은 이 비유만 기억하세요.

---

## 7. itertools 내부

H4에서 itertools를 카탈로그로 봤죠. 그 속도 오늘 배운 generator로 설명돼요. itertools의 모든 함수가 generator예요. 다 lazy해요.

```python
from itertools import chain, count, takewhile

# 무한 카운터
for i in takewhile(lambda x: x < 10, count()):
    print(i)
```

위 코드를 보세요. count()와 takewhile을 조합했어요. `count()`는 0, 1, 2, 3... 무한히 세는 generator예요. 끝이 없어요. 그런데도 컴퓨터가 안 죽어요. 왜냐하면 lazy하거든요. 한 번에 하나씩만 만들어요. takewhile은 "조건이 참인 동안만 받기"예요. `x < 10`이 거짓이 되는 순간(x가 10일 때) 멈춰요. 그래서 무한 카운터지만 실제로는 0부터 9까지만 만들고 끝나요.

이게 itertools의 비밀이에요. itertools의 모든 함수가 generator예요. 다 lazy해요. 그래서 무한 시퀀스도 다룰 수 있고, 큰 데이터도 메모리 폭발 없이 처리해요. H4에서 본 chain, groupby, accumulate도 다 generator라, list로 감싸야 결과가 보였죠. 그게 lazy라서 그래요. 미리 안 만들고 요청할 때 만드니까요. 무한과 게으름. 이 둘이 itertools의 철학이에요. "끝없는 것도 게으르게 다루면 안전하다." 본인이 두 해 코스에서 무한 스트림이나 큰 데이터를 만날 때, itertools의 lazy 도구들이 답일 때가 많아요. 오늘은 "itertools는 다 generator라 lazy하다"는 그림만.

그리고 itertools가 C로 짜여 있다는 것도 알아 두면 좋아요. Ch007 H7에서 본 C 확장 기억하시죠. itertools는 순수 Python이 아니라 C로 짜여 있어서 빠르기까지 해요. lazy하면서 빠른 거예요. 그래서 본인이 직접 generator 함수를 짜는 것보다, itertools에 이미 있는 도구를 쓰는 게 보통 더 빠르고 안전해요. "여러 개를 조합·그룹·누적·필터할 일이 생기면, 내가 직접 짜기 전에 itertools에 있나 먼저 봐라." 이게 5년 차의 습관이에요. 바퀴를 다시 발명하지 않는 거죠. itertools는 50년간 다듬어진 lazy 흐름 도구의 보물창고예요.

---

## 8. 흔한 오해 다섯 가지

오늘 배운 깊은 내용에 대한 흔한 오해 다섯 개를 부숩니다.

**오해 1: generator는 list보다 항상 빠르다.**

아니에요. 작은 데이터는 오히려 list가 빠를 수 있어요. generator는 "메모리를 아끼는" 도구지 "속도를 높이는" 도구가 아니에요. generator의 장점은 큰 데이터를 메모리 폭발 없이 다루는 거예요. 작은 데이터는 그냥 list가 편하고 빨라요. 그리고 list는 여러 번 돌릴 수 있고, 인덱스로 접근할 수 있고, len도 돼요. generator는 한 번만 돌고, 인덱스 접근도 len도 안 돼요. 그래서 작고 여러 번 쓸 데이터는 무조건 list예요. 데이터가 클 때, 또는 무한할 때, 또는 한 번만 훑을 때만 generator를 쓰세요.

**오해 2: yield는 return과 같다.**

달라요. return은 함수를 끝내요. yield는 값을 주되 함수를 안 끝내고 멈춰요. 다음에 부르면 멈췄던 자리부터 이어가요. 이 "상태 보존"이 결정적 차이예요. return은 책을 덮는 것, yield는 책갈피를 꽂는 것. 그리고 yield가 있는 함수는 부른다고 바로 실행 안 돼요. generator 객체(리모컨)를 줄 뿐이에요. 본인이 next를 눌러야 실행돼요. 이것도 일반 함수와 큰 차이예요.

**오해 3: for는 list만 돈다.**

아니에요. for는 iterator 프로토콜을 따르는 모든 것을 돌아요. list, dict, set, 문자열, 파일, generator, range. 다 돌아요. "__iter__와 __next__가 있으면" for에서 돌 수 있어요. 본인이 만든 클래스도요(Ch011).

**오해 4: comprehension은 그냥 짧은 for다.**

내부적으로는 익명 함수 + 호출이에요. bytecode를 보면 MAKE_FUNCTION이 있어요. 그래서 일반 for보다 조금 빠르고, 별도의 변수 범위를 가져요. 단순히 짧은 for가 아니라 작은 함수예요.

**오해 5: async는 무조건 빠르다.**

아니에요. async는 I/O 작업(기다리는 일)이 많을 때만 빨라요. CPU를 계속 쓰는 무거운 계산은 async로 안 빨라져요. 오히려 코드만 복잡해져요. "기다리는 일이 많을 때만 async." 주방장이 칼질만 한다면 비동기여도 칼질 속도는 같아요.

---

## 9. 자주 받는 질문 다섯 가지

**Q1. 이걸 다 이해 못 했어요. 괜찮나요?**

괜찮아요. 오늘 내용은 이번 챕터에서 가장 어려워요. "for 안에 iterator가 있다", "generator는 yield로 만들고 lazy하다", "comprehension은 익명 함수다" 이 세 그림만 남으면 충분해요. 나머지는 나중에 필요할 때 다시 봐요.

**Q2. generator를 언제 써야 하나요?**

세 가지 신호가 있어요. 하나, 데이터가 너무 커서 메모리에 다 못 올릴 때(천만 줄 파일). 둘, 무한히 이어지는 값이 필요할 때(끝없는 ID). 셋, 한 번만 훑고 버릴 데이터일 때. 이 경우엔 list 대신 generator예요. 반대로 데이터가 작고 여러 번 써야 하면 list가 편해요.

**Q3. yield를 직접 쓸 일이 있나요?**

처음엔 드물어요. 보통은 generator expression `(x for x in ...)`로 충분해요. 그런데 복잡한 lazy 시퀀스를 만들 때(예: 파일을 읽으며 변환하고 거르는 여러 단계), yield로 직접 generator 함수를 짜요. comprehension 한 줄로 표현 안 되는 복잡한 lazy 로직이 필요할 때요. 본인이 두 해 코스 후반에 큰 데이터를 다룰 때 만나요. 오늘은 "yield가 책갈피를 꽂는 것"만 기억하세요. yield를 직접 안 써도, generator가 뭔지 이해하는 게 더 중요해요.

**Q4. 이 깊이를 알면 일상에서 뭐가 달라지나요?**

세 가지가 달라져요. 하나, 면접에서 "generator가 뭐예요?" "yield와 return 차이는?" "iterable과 iterator 차이는?"에 막힘없이 답해요. 이 셋이 Python 면접 단골이에요. 둘, 큰 데이터를 만났을 때 "이거 list로 하면 메모리 터지겠다, generator로 해야겠다"를 떠올려요. 셋, comprehension이 왜 빠른지, for가 왜 모든 것에 통하는지를 이해해서 안 흔들려요. 깊이가 본인을 면접과 실전 문제 앞에서 받쳐 줘요.

**Q4-1. iterable과 iterator를 한 문장으로 구별하면?**

iterable은 "for에서 돌 수 있는 것"(책), iterator는 "실제로 값을 하나씩 꺼내 주는 것"(책갈피)이에요. iterable에서 iter()를 부르면 iterator가 나와요. 면접에서 이 한 문장이면 충분해요.

**Q5. async는 지금 배워야 하나요?**

아니요. 지금은 일반 for와 generator를 손에 익히는 게 먼저예요. async는 본인이 백엔드를 짤 때(Ch041 근처) 깊이 배워요. 오늘은 "비동기 버전의 for도 있다"는 것만 알아 두세요. 기초가 단단해야 고급이 쉬워요.

---

## 10. 흔한 실수 다섯 + 안심 — Python 깊이 학습 편

첫째, 깊이를 한 번에 다 외우려고. 안심하세요 — iterator·generator·익명함수 세 그림만. 나머지는 필요할 때.
둘째, bytecode를 다 읽으려고. 안심하세요 — dis로 한 번 보고 끝. 깊이 안 들어가도 돼요.
셋째, generator를 두 번 돌려서 빈 결과에 당황. 안심하세요 — generator는 한 번 소진하면 끝. 다시 쓰려면 다시 만들기.
넷째, 작은 데이터에 무리하게 generator. 안심하세요 — 작으면 list가 편하고 빨라요. 클 때만 generator.
다섯째, 가장 큰 함정 — async를 너무 일찍 깊이 파려고. 안심하세요 — 일반 for와 generator가 먼저. async는 Ch041 근처에서.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

이 다섯 중에서 셋째, "generator를 두 번 돌리는 함정"이 실전에서 진짜 자주 나와요. 한 장면으로 보여드릴게요. 본인이 `gen = (x for x in data)`로 generator를 만들었어요. 그걸 `list(gen)`으로 한 번 변환하고, 또 `sum(gen)`으로 합을 구하려 해요. 그런데 sum이 0이 나와요. 왜냐하면 첫 번째 list(gen)에서 generator를 다 소진했거든요. 책갈피가 이미 책 끝에 도달한 거예요. 두 번째로 돌리면 줄 게 없어요. 이게 generator의 일회성 특성이에요. list는 여러 번 돌려도 되지만, generator는 한 번이에요. 그래서 generator를 여러 번 써야 하면, list로 한 번 변환해 두거나, 매번 generator를 새로 만들어요. 본인이 이걸 모르고 generator를 두 번 돌리면, 두 번째가 조용히 비어 있어서 사고가 나요. 에러도 안 나요. 그냥 결과가 0이나 빈 리스트예요. 그래서 H3에서 배운 디버깅이 필요해요. "왜 0이지?" 하고 print로 확인하면 "아, generator가 소진됐구나"를 알아요. 오늘 이 함정을 미리 알아 두면, 그날 본인이 한 시간 헤맬 걸 1초에 알아채요. generator는 한 번, 기억하세요.

## 11. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요. 본 챕터에서 가장 깊은 시간이었어요. 60분 동안 본인은 for 루프의 속을 열어 봤어요. 정리하면 이래요.

본인이 매일 쓰는 for는 iterator 프로토콜(`__iter__`·`__next__`) 위에서 돌아요. 모든 iterable이 이 약속을 지켜서, for가 list든 파일이든 똑같이 돌 수 있어요. generator는 yield로 만드는 가벼운 iterator인데, 책갈피를 꽂듯 상태를 보존하며 한 값씩 lazy하게 줘요. 그래서 1조 개 데이터도 메모리 폭발 없이 다뤄요. comprehension은 사실 익명 함수라 일반 for보다 조금 빠르고, itertools는 다 generator라 무한 시퀀스도 게으르게 다뤄요. async for는 기다리는 일이 많을 때 빛나는 비동기 버전이에요.

이 모든 게 본인이 매일 쓰는 for 한 줄 안에 숨어 있어요. 본인이 그 속을 오늘 들여다봤어요. for가 마법에서 정직한 기계로 변했어요. 그리고 정직한 기계는 무섭지 않아요.

마지막으로 한 가지를 짚고 싶어요. 본인은 이제 셸(Ch006 H7), Python 인터프리터(Ch007 H7), 제어 흐름(Ch008 H7)의 속을 다 봤어요. 세 개의 우물을 팠어요. 이 우물들이 본인을 5년 차처럼 보이게 해요. 왜냐하면 대부분의 사람은 for를 쓸 줄만 알지, for의 속을 몰라요. generator를 쓸 줄만 알지, 왜 lazy한지 몰라요. 본인은 속을 알아요. 그래서 "왜 이게 느리지?", "왜 메모리가 터지지?", "왜 generator가 비어 있지?" 같은 문제를 만났을 때, 본인은 추측이 아니라 이해로 풀어요. 모르는 사람은 마법 상자 앞에서 빌고, 아는 사람은 논리로 추론해요. 그 차이가 본인을 받쳐 줘요. 깊이는 당장 빛나지 않지만, 진짜 문제 앞에서 본인을 흔들리지 않게 해요. 본인이 오늘 판 이 우물이, 두 해 코스 내내, 그리고 그 후 5년 내내 본인을 받쳐 줘요.

박수 한 번 칠게요. 진짜로요. 이번 시간은 어려웠어요. iterator, generator, yield, async. 끝까지 따라오신 본인이 자랑스러워요. 다 이해 못 하셨어도 괜찮아요. "for 안에 iterator가 있고, generator는 lazy하다"는 그림만 남으셨어도 오늘은 성공이에요. 이 깊이가 본인을 면접에서, 그리고 큰 데이터 앞에서 받쳐 줘요.

직접 한 번 for의 속을 보고 싶으면, 다음을 쳐 보세요.

```python
import dis
dis.dis("for x in [1,2,3]: pass")   # GET_ITER, FOR_ITER가 보여요
```

오늘 배운 게 그림이 아니라 진짜였다는 증거예요.

다음 H8은 본 챕터의 마지막, 적용과 회고예요. 8시간 배운 제어 흐름을 정리하고, 환율 계산기 v2를 돌아보고, Ch009 함수로 가는 다리를 놓아요. 한 시간 후 만나요. 잠깐 쉬세요. 어려운 시간 끝까지 잘 따라오셨어요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - iterator 프로토콜 (PEP 234): `__iter__`는 iterator 반환, `__next__`는 다음 값 또는 StopIteration. iterable(`__iter__`만)과 iterator(`__next__`도)는 다름. iterator는 자기 자신의 `__iter__`가 self 반환.
> - generator (PEP 255): yield 있는 함수는 호출 시 generator 객체 반환(즉시 실행 안 됨). `next()` 호출 시 yield까지 실행. generator는 한 번 소진하면 재사용 불가.
> - generator 고급: `yield from`(PEP 380)으로 sub-generator 위임. `.send()`로 값 주입, `.throw()`로 예외, `.close()`로 종료. coroutine의 기반.
> - for의 bytecode: GET_ITER → FOR_ITER(StopIteration 시 점프) → STORE_FAST → 루프 body → JUMP_BACKWARD. Python 3.12에서 FOR_ITER 최적화.
> - comprehension scope: 별도 code object + frame. Python 3에서 누수 방지(2에서는 누수). 그래서 일반 for보다 변수 격리됨.
> - async generator (PEP 525): `async def` + yield. `__aiter__`·`__anext__`. `async for`로 소비. asyncio 이벤트 루프 위에서.
> - itertools 구현: C로 짠 lazy generator. islice·tee·chain·count·cycle·groupby 등. 무한 시퀀스 + 조건 종료(takewhile)가 표준 패턴.
> - generator vs list 메모리: `sys.getsizeof(gen)`은 ~200B 고정, list는 요소 수 비례. 큰 데이터는 generator.
> - 다음 H8 키워드: 7H 회고 · v2 진화 · 다섯 원리 · Ch009 함수 다리.

---

## 추신

1. for는 iterator 프로토콜 위에서 돌아요. `__iter__`·`__next__`.
2. `__iter__`=iterator 반환, `__next__`=다음 값, StopIteration=끝.
3. for는 자동으로 iter()+next() 반복. 본인은 깔끔한 한 줄만.
4. 모든 iterable(list·dict·파일·generator)이 이 약속을 지켜요.
5. 약속만 지키면 뭐든 for에서 돌아요. for가 강력한 이유.
6. generator는 yield로 만드는 가벼운 iterator.
7. yield는 값 주되 함수 안 끝내고 멈춰요(상태 보존).
8. return=책 덮기, yield=책갈피 꽂기.
9. generator는 lazy. 미리 안 만들고 요청 때마다 하나씩.
10. 1조 개도 메모리 폭발 없음. 한 번에 한 값만.
11. generator expression `(x for x in ...)`이 그 정체.
12. generator 매일 — 큰 파일·무한 시퀀스·lazy 변환.
13. for 내부 — iter로 iterator·while+next·StopIteration 시 break.
14. for는 iter+next의 편한 문법(syntactic sugar).
15. bytecode에 GET_ITER·FOR_ITER가 for의 정체.
16. comprehension은 사실 익명 함수+호출(MAKE_FUNCTION).
17. 그래서 일반 for보다 20~30% 빨라요.
18. dict·set·generator comp 다 같은 메커니즘.
19. comprehension 쓰는 진짜 이유는 속도 아니라 가독성.
20. async for=비동기 버전. `__aiter__`·`__anext__`.
21. async는 기다리는 일(I/O) 많을 때만 빨라요.
22. itertools는 다 generator라 lazy. 무한도 안전.
23. count()=무한이지만 lazy. takewhile이 조건 멈추면 끝.
24. generator는 큰/작은 데이터 선택. 작으면 list가 편해요.
25. yield 직접은 드물어요. 보통 generator expression으로.
26. 오늘은 외우는 게 아니라 세 그림(iterator·generator·익명함수).
27. 깊이는 면접·큰 데이터 앞에서 본인을 받쳐요.
28. async는 Ch041 근처에서 깊이. 지금은 for·generator 먼저.
29. H7 체험 — `dis.dis("for x in [1,2,3]: pass")`로 for 속 보기.
30. 다음 H8은 8시간 회고 + Ch009 다리. 한 시간 쉬고 만나요. 🐾
