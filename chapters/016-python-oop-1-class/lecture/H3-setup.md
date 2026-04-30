# Ch016 · H3 — VS Code 클래스 navigation + snippets

> 고양이 자경단 · Ch 016 · 3교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H2 회수
2. VS Code 다섯 단축키
3. snippet으로 클래스 템플릿
4. Pylance class 검사
5. ipython 실험
6. inspect 검사
7. 자경단 매일 의식
8. 마무리

---

## 1. 다시 만나서 반가워요 — H2 회수

자, 안녕하세요.

지난 H2 회수. `__init__`, self, attribute, method, @property, dunder.

이번 H3는 환경.

오늘의 약속. **본인이 VS Code에서 클래스를 빠르게 짭니다**.

자, 가요.

---

## 2. VS Code 다섯 단축키

**1. F12** — Go to Definition.

**2. Shift+F12** — Find All References.

**3. Cmd+T** — Workspace Symbol.

**4. Cmd+Shift+O** — Document Symbol.

**5. F2** — Rename Symbol.

자경단 매일 100번.

---

## 3. snippet으로 클래스 템플릿

`Cmd+Shift+P` → User Snippets → python.json.

```json
{
  "Class with init": {
    "prefix": "class",
    "body": [
      "class ${1:Name}:",
      "    def __init__(self, ${2:args}):",
      "        ${0:pass}",
      "    def __repr__(self):",
      "        return f\"${1:Name}()\""
    ]
  }
}
```

`class` 치면 자동.

---

## 4. Pylance class 검사

```python
class Cat:
    def __init__(self, name: str):
        self.name = name
    def greet(self):
        return self.nam   # ← Pylance 경고
```

오타 자동.

---

## 5. ipython 실험

```python
ipython
class Cat:
    def __init__(self, name):
        self.name = name

까미 = Cat("까미")
까미.<TAB>   # 자동완성
?Cat          # 도움말
??Cat         # source
```

---

## 6. inspect 검사

```python
import inspect

class Cat:
    def greet(self): pass

inspect.getmembers(Cat, predicate=inspect.isfunction)
inspect.signature(Cat.greet)
inspect.getsource(Cat)
Cat.__mro__
```

---

## 7. 자경단 매일 의식

**1. 새 클래스** → snippet 5초.

**2. navigation** → F12, Cmd+T.

**3. 검사** → mypy --strict.

**4. 실험** → ipython.

**5. 디버깅** → breakpoint().

---

## 8. 흔한 실수 다섯 + 안심 — 환경 학습 편

첫째, F12 안 씀. 안심 — 매일 100번.
둘째, snippet 시니어 도구. 안심 — 5분 셋업.
셋째, Pylance 옵션. 안심 — strict 매일.
넷째, ipython TAB 무지. 안심 — 자동완성 매일.
다섯째, 가장 큰 — inspect 어렵다. 안심 — 5 함수면 90%.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 9. 마무리

자, 세 번째 시간 끝.

VS Code 5 단축키, snippet, Pylance, ipython, inspect.

다음 H4는 30 dunder.

---

## 👨‍💻 개발자 노트

> - Pylance class 추론.
> - 다음 H4 키워드: __str__ · __repr__ · __eq__ · 30 dunder.
