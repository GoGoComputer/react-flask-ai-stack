# Ch007 · H4 — Python 도구 카탈로그 — 18 도구로 본인의 매일 손가락 만들기

> 고양이 자경단 · Ch 007 · 4교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속
2. 위험도 신호등 — 18 도구를 세 색깔로
3. 18 도구 한 표
4. 첫째 무리 — 인터프리터 여섯 손가락
5. 둘째 무리 — 패키지 다섯 손가락
6. 셋째 무리 — 가상환경 세 손가락
7. 넷째 무리 — 품질 세 손가락
8. 다섯째 무리 — 테스트 한 손가락
9. 매일·주간·월간 손가락 리듬
10. 자경단 매일 13줄 흐름 (Python 버전)
11. 모던 도구 다섯 가지 (uv·poetry·pdm·hatch·rye)
12. AI 시대의 18 도구
13. 흔한 오해 다섯 가지
14. 자주 받는 질문 다섯 가지
15. 마무리 — 다음 H5에서 만나요

---

## 🔧 강사용 명령어 한눈에

```bash
# 인터프리터 6
python3
python3 -V
python3 -c 'print("hi")'
python3 -m http.server 8000
python3 -i script.py
python3 -O script.py

# 패키지 5
pip install requests
pip install -r requirements.txt
pip uninstall requests
pip freeze > requirements.txt
pip list

# 가상환경 3
python3 -m venv .venv
source .venv/bin/activate
deactivate

# 품질 3
black .
ruff check .
mypy .

# 테스트 1
pytest
```

---

## 1. 다시 만나서 반가워요 — H3 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다. 이번이 네 번째 시간이에요. 절반 가까이 오셨어요. 잘 따라오시고 계시네요.

지난 H3을 한 줄로 회수할게요. 본인은 30분 셋업으로 자경단 Python 표준 환경을 박으셨어요. python3, pyenv, venv, pip, VS Code, ipython. 본인 노트북이 자경단 한 명의 환경으로 변했어요.

이번 H4는 그 환경 위에서 본인이 매일 치는 18 도구를 표 한 장에 누이는 시간이에요. Ch006 H4가 셸 30 명령어, 본 H가 Python 18 도구. 둘이 합쳐 본인의 매일 48 손가락이에요.

오늘의 약속은 두 가지예요. 하나, **18 도구가 표 한 장으로 본인 머리에 들어옵니다**. 둘, **각 도구마다 위험도 신호등이 붙어 있어서 본인이 사고 칠 확률을 1%로 떨어뜨립니다**. 18 중 빨강은 거의 없어요. Python은 셸보다 안전한 언어예요.

자, 가요.

---

## 2. 위험도 신호등 — 18 도구를 세 색깔로

Ch006에서 본 그 신호등을 그대로 적용해요.

**🟢 초록**은 read-only. 정보만 읽고 변화 없음. `python3 -V`, `pip list`, `mypy .`, `ruff check .`, `deactivate`. 사고 칠 확률 0%.

**🟡 노랑**은 local 변경. 본인 노트북만 영향. 복구 가능. `pip install`, `python3 script.py`, `venv 생성`, `black .`. 거의 모든 매일 도구가 노랑.

**🔴 빨강**은 거의 없어요. Python은 셸보다 안전. 굳이 빨강을 꼽으면 `pip install --break-system-packages` (시스템 Python에 강제 설치) 정도. 자경단은 절대 안 써요. 항상 venv 안에서.

18 도구 중 17개가 안전. 본인은 거의 사고 안 쳐요. Python 도구의 첫 인상이 그래요.

---

## 3. 18 도구 한 표

| # | 도구 | 무리 | 신호등 | 한 줄 정의 |
|---|------|------|-------|----------|
| 1 | `python3` | 인터프리터 | 🟢 | REPL/스크립트 실행 |
| 2 | `python3 -V` | 인터프리터 | 🟢 | 버전 확인 |
| 3 | `python3 -c` | 인터프리터 | 🟡 | 한 줄 실행 |
| 4 | `python3 -m` | 인터프리터 | 🟡 | 모듈 CLI |
| 5 | `python3 -i` | 인터프리터 | 🟡 | 실행 후 REPL |
| 6 | `python3 -O` | 인터프리터 | 🟢 | optimized 모드 |
| 7 | `pip install` | 패키지 | 🟡 | 패키지 설치 |
| 8 | `pip install -r` | 패키지 | 🟡 | 일괄 설치 |
| 9 | `pip uninstall` | 패키지 | 🟡 | 제거 |
| 10 | `pip freeze` | 패키지 | 🟡 | 의존성 백업 |
| 11 | `pip list` | 패키지 | 🟢 | 설치 목록 |
| 12 | `venv 생성` | 가상환경 | 🟡 | venv 만들기 |
| 13 | `activate` | 가상환경 | 🟡 | venv 진입 |
| 14 | `deactivate` | 가상환경 | 🟢 | venv 나감 |
| 15 | `black .` | 품질 | 🟡 | 자동 포매팅 |
| 16 | `ruff check` | 품질 | 🟢 | linter |
| 17 | `mypy .` | 품질 | 🟢 | type checker |
| 18 | `pytest` | 테스트 | 🟡 | 테스트 실행 |

18개. 5 무리. 한 무리씩 만나러 가요.

---

## 4. 첫째 무리 — 인터프리터 여섯 손가락

본인이 Python을 사용할 때 가장 자주 만나는 게 python3 명령. 옵션 다섯 가지가 본인 손가락에 박혀요.

**python3** (옵션 없음). REPL을 켜요.

> ▶ **같이 쳐보기** — REPL 5분 의식
>
> ```python
> python3
> >>> 2 + 3
> >>> name = "까미"
> >>> f"안녕 {name}"
> >>> import datetime; datetime.datetime.now()
> >>> exit()
> ```

자경단의 매일 5분 REPL 의식. 새 라이브러리 한 줄 시도, 표현식 검증, datetime 계산. 1년에 1,800번. 손가락에 박힌 도구.

**python3 -V**. 버전 확인.

```bash
python3 -V
# Python 3.12.0
```

본인 노트북 또는 venv의 Python 버전 검증. 새 셋업이나 CI 첫 줄에서 매일 만나요.

**python3 -c '코드'**. 한 줄 실행. 셸에서 빠른 실험.

```bash
python3 -c 'print("hello"); print(2+3)'
```

자경단의 셸 한 줄 자동화에서 자주 만나요. 셸 스크립트 안에서 작은 Python 로직 끼워 넣기.

**python3 -m 모듈**. 모듈을 CLI 도구로 실행. 진짜 강력해요.

```bash
python3 -m http.server 8000      # 한 줄 HTTP 서버
python3 -m json.tool data.json   # JSON 예쁘게 출력
python3 -m venv .venv            # venv 만들기
python3 -m pip install requests  # pip 호출
```

`-m`은 Python의 숨은 무기예요. 100가지 모듈을 CLI로 호출 가능. 자경단의 매일 한 줄.

**python3 -i 파일**. 파일 실행 후 REPL 진입. 디버깅에 진짜 유용.

```bash
python3 -i script.py
# script.py 실행 후 변수가 살아 있는 REPL 진입
>>> result
```

본인이 짠 스크립트의 결과를 REPL에서 추가로 만져 볼 수 있어요.

**python3 -O 파일**. optimized 모드. assert 문 제거 + .pyo로 컴파일.

```bash
python3 -O production_script.py
```

production 환경에서 살짝 빨라요. 일상에선 안 써도 충분.

여섯 옵션 중 매일 쓰는 건 1번 (REPL), 4번 (-m), 7번 (-c). 나머지는 가끔.

---

## 5. 둘째 무리 — 패키지 다섯 손가락

pip는 자경단 다섯 명이 매일 5번 이상 만나는 도구예요. 다섯 옵션이 90% 일을 해요.

**pip install**. 패키지 설치.

```bash
pip install requests
pip install pandas==2.1.4    # 정확한 버전
pip install -U requests      # 업그레이드
```

`-U`는 upgrade. 이미 깔린 패키지를 새 버전으로.

**pip install -r requirements.txt**. 일괄 설치.

```bash
pip install -r requirements.txt
```

새 환경 셋업 시 매일 한 번. 5초에 모든 패키지 복원.

**pip uninstall**. 제거.

```bash
pip uninstall requests
```

자경단 거의 안 써요. venv를 통째로 다시 만드는 게 더 깔끔.

**pip freeze**. 깔린 패키지를 정확한 버전과 함께 텍스트로.

```bash
pip freeze > requirements.txt
```

자경단의 매일 한 줄. 환경 백업의 표준.

**pip list**. 깔린 목록만.

```bash
pip list
pip list --outdated   # 업그레이드 가능한 것
```

`--outdated`로 오래된 패키지 확인. 매주 한 번 보안 점검.

다섯 옵션 중 매일 쓰는 건 install과 install -r. 다른 셋은 주간 또는 월간.

---

## 6. 셋째 무리 — 가상환경 세 손가락

venv 사용은 세 단계예요. 만들고, 들어가고, 나가고.

**python3 -m venv .venv**. 가상 환경 만들기. `.venv` 폴더 생성.

```bash
python3 -m venv .venv
ls .venv/
# bin/  include/  lib/  pyvenv.cfg
```

3초. 새 프로젝트마다 한 번씩.

**source .venv/bin/activate**. 가상 환경 진입. 셸 프롬프트에 `(.venv)` 표시.

```bash
source .venv/bin/activate
which python3
# /your/project/.venv/bin/python3
```

본인이 가상 환경 안에 있으면 python3와 pip가 그 환경의 것을 가리켜요.

**deactivate**. 가상 환경 나감. `(.venv)` 사라짐.

```bash
deactivate
which python3
# /opt/homebrew/bin/python3
```

세 손가락. 매일 새 프로젝트 시작 시 만들기, 매일 일 시작 시 진입, 일 끝 후 나감. 단순.

자경단의 dotfile 별명을 다시 알려드릴게요.

```bash
alias venv="python3 -m venv .venv && source .venv/bin/activate"
alias act="source .venv/bin/activate"
```

`venv` 한 줄로 만들기 + 진입. `act` 한 줄로 진입. 자경단 매일 사용.

---

## 7. 넷째 무리 — 품질 세 손가락

본인 코드의 품질을 자동으로 챙겨 주는 세 도구. 자경단의 모든 PR이 이 셋을 통과해야 main에 들어가요.

**black** — 자동 포매터. 본인 코드를 표준 스타일로 자동 변환.

```bash
pip install black
black my_script.py     # 한 파일
black .                # 폴더 전체
```

설정이 거의 없어요. "no configuration"이 black의 철학. 자경단 다섯 명이 다 같은 스타일로 짜요. 합의 비용 0.

**ruff** — Rust로 짠 linter. 코드의 잠재 버그 검출.

```bash
pip install ruff
ruff check my_script.py
ruff check .
```

flake8보다 100배 빨라요. 1만 줄짜리 프로젝트도 1초.

**mypy** — type checker. 본인이 type hints를 적었으면 mypy가 검증해 줘요.

```bash
pip install mypy
mypy my_script.py
mypy .
```

type 미스매치를 컴파일 시점에 잡아 줘요. 큰 코드베이스에서 진짜 강력.

세 도구를 한 줄로 묶어서 자경단의 표준 검증.

```bash
black . && ruff check . && mypy .
```

PR 만들기 전에 매번 이 한 줄. 통과하면 안전. 자경단 표준이에요.

---

## 8. 다섯째 무리 — 테스트 한 손가락

**pytest**. Python의 표준 테스트 도구. Java의 JUnit, JS의 Jest.

```bash
pip install pytest
pytest                    # 모든 테스트 실행
pytest test_calc.py       # 한 파일
pytest -v                 # verbose
pytest -k "test_add"      # 이름 매치
pytest --cov              # coverage (pytest-cov)
```

자경단의 매일 운영 사이클이 — 코드 짜고, pytest 돌리고, 통과하면 commit. 5번 사이클이 30분.

pytest는 H6에서 깊이 다뤄요. 오늘은 한 줄.

---

## 9. 매일·주간·월간 손가락 리듬

18 도구를 시간 단위로 나눠 봐요.

**매일 6개**. python3, pip install, source activate, deactivate, black, ruff. 매일 일 시작과 끝에 만나요. 1주일이면 박혀요.

**주간 7개**. python3 -m, pip install -r, pip freeze, pip list, mypy, pytest, python3 -V. 1주일에 두세 번. 1개월이면 박혀요.

**월간 5개**. python3 -c, python3 -i, python3 -O, pip uninstall, venv 새로 만들기. 가끔 만나요.

매일 6개부터 시작하시고, 6주에 18개 다 박아 가세요. 자연스럽게.

---

## 10. 자경단 매일 13줄 흐름 (Python 버전)

자경단 다섯 명이 매일 치는 Python 13줄을 보여드릴게요.

```bash
# 1. 프로젝트 진입
cd ~/cat-vigilante-backend

# 2. venv 진입
source .venv/bin/activate

# 3. 의존성 동기화
git pull --rebase
pip install -r requirements.txt

# 4-5. 개발 시작
python3 -V
python3 -m pytest

# 6-8. 코드 짜기
vim main.py
black main.py
ruff check main.py

# 9-10. type 검사
mypy main.py

# 11. 테스트
pytest -v

# 12-13. commit + push
git add main.py
git commit -m "feat: 환율 계산기"
git push
```

13줄. 자경단 한 명의 매일 사이클. 5명 × 13줄 × 365일 = 23,725 손가락/년. 본인이 5년 후엔 매일 이걸 자동으로 해요.

---

## 11. 모던 도구 다섯 가지

pip의 발전된 대안 다섯 가지. 자경단의 1-2년 후 모습이에요.

| 도구 | 한 줄 | 자경단 평가 |
|------|-------|-------------|
| **uv** | Rust로 짠 pip의 100배 빠른 대체 | ⭐⭐⭐⭐⭐ 1년 후 표준 |
| **poetry** | 의존성 + 빌드 + 출판 통합 | ⭐⭐⭐⭐ 큰 프로젝트 |
| **pdm** | poetry 비슷, 더 표준적 (PEP 582) | ⭐⭐⭐ 마니아 |
| **hatch** | poetry + 환경 관리 | ⭐⭐⭐ 새 도구 |
| **rye** | Astral의 도구 (uv 만든 곳) | ⭐⭐⭐⭐ 통합 도구 |

자경단 표준은 아직 pip + venv. 1년 후엔 uv로 갈 가능성. 5년 후엔 rye가 표준일 수도. 미리 한 번 들어 두세요.

uv 한 줄 시연.

```bash
brew install uv
uv pip install requests       # pip 비슷, 100배 빠름
uv venv .venv                 # venv 만들기
```

본인이 큰 프로젝트 만나면 한 번 써 보세요. pip와 거의 같은 사용법이에요.

---

## 12. AI 시대의 18 도구

AI 도구가 Python 도구를 어떻게 다루는지 살짝 보여드릴게요.

**Claude Code / Cursor**. 본인이 코드 짜면서 "이 함수에 type hints 추가" 한 줄 부탁하면 AI가 mypy 통과 가능한 type을 추가. "pytest 케이스 짜 줘"라고 하면 5개 테스트 자동 생성.

**Copilot CLI**. 셸에서 `?? "venv 만들고 fastapi 깔기"` 한 줄 부탁하면 AI가 명령어 두 줄을 추천. 본인이 그대로 치면 끝.

**ChatGPT**. 코드를 붙여 넣고 "ruff 경고 다 고쳐 줘" 부탁하면 수정된 코드 반환. 본인이 그대로 적용.

자경단의 AI + Python 비율 — 80/20. 본인이 80%를 Python 도구로 직접 다루고, 모르는 20%만 AI에 묻기. 비율이 0/100이면 AI 앵무새, 100/0이면 5분 검색을 평생.

---

## 13. 흔한 오해 다섯 가지

**오해 1: 18 도구 다 외워야 한다.**

매일 6개부터. 6주에 18개. 자연.

**오해 2: pip install로 글로벌에 깔아도 된다.**

안 돼요. 항상 venv 안에서.

**오해 3: black은 너무 강제적이다.**

자경단의 합의 비용 0이 black의 가치. 자유보다 합의.

**오해 4: ruff와 black은 같은 도구다.**

다른 도구. ruff는 linter (검사만), black은 formatter (수정). 자경단은 둘 다.

**오해 5: type hints는 매번 써야 한다.**

자경단 표준은 모든 함수에. 작은 스크립트는 생략 가능.

---

## 14. 자주 받는 질문 다섯 가지

**Q1. python vs python3?**

`python3` 표준. dotfile에 alias로 `py=python3`.

**Q2. pip vs pip3?**

가상 환경 안에서는 `pip`로 충분. 글로벌 시스템에선 `pip3`.

**Q3. black과 ruff 충돌하나요?**

안 해요. 자경단은 둘 다 사용. ruff format도 black 호환.

**Q4. mypy --strict가 너무 엄격해요.**

처음엔 그래요. 6주 정도 견디면 본인 코드 품질이 50% 향상돼요.

**Q5. pytest 첫 테스트가 어떻게 짜요?**

H6에서 자세히. 한 줄 시범.
```python
def test_add():
    assert 2 + 3 == 5
```

---

## 15. 흔한 실수 다섯 가지 + 안심 멘트 — Python 도구 학습 편

Python 도구 만나며 자주 빠지는 함정 다섯.

첫 번째 함정, pip 직접 사용. 안심하세요. **`python3 -m pip` 권장.** 어느 Python에 깔리는지 명확.

두 번째 함정, black·ruff·mypy 다 한 번에. 안심하세요. **첫달은 black 하나.** 한 도구씩 손에 익히기.

세 번째 함정, REPL과 .py 헷갈림. 안심하세요. **REPL은 실험, .py는 자산.** REPL에서 한 줄 → 동작 확인 → .py로 옮기기.

네 번째 함정, type hint 한 번에 다. 안심하세요. **공개 함수만 첫달.** 내부 함수는 두 번째 달.

다섯 번째 함정, 가장 큰 함정. **import * 사용.** 본인이 `from module import *`. 네임스페이스 오염. 안심하세요. **명시적 `from module import a, b`.** 가독성 + IDE 지원.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 16. 마무리 — 다음 H5에서 만나요

자, 네 번째 시간이 끝났어요. 60분 동안 본인은 Python 18 도구를 표 한 장으로 만나셨어요. 정리하면 이래요.

위험도 신호등 세 색깔. 5 무리 18 도구. 인터프리터 6, 패키지 5, 가상환경 3, 품질 3, 테스트 1. 매일 6개부터 시작해서 6주에 18개. 자경단 매일 13줄 흐름. 모던 도구 5종. AI 시대의 80/20 황금비.

박수 한 번 칠게요. 18 도구를 한 시간에 듣는 게 빽빽해요. 잘 따라오셨어요.

다음 H5는 30분 데모. 본인이 직접 환율 계산기를 짜요. 50줄짜리. input() → float() → if/else → print(). 5단계 + 5사고. 한 시간 후 만나요.

그 전에 한 가지 부탁. 지금 잠깐 멈추시고 다음 다섯 줄을 차례로 쳐 보세요.

```bash
python3 -V
pip list | head -10
python3 -c "print('hello')"
python3 -m http.server 8000   # Ctrl+C로 종료
deactivate 2>/dev/null || true
```

5초예요. 본인의 H4 졸업장이에요. 매일 5개가 본인 손가락에서 한 번 다녀가요.

---

## 👨‍💻 개발자 노트 (참고 — 비개발자는 그냥 넘기셔도 됩니다)

> - python3 -m vs script: -m이 sys.path 처리가 더 표준적. 패키지 안의 스크립트는 -m으로 실행.
> - pip 캐시: ~/.cache/pip. `pip cache purge`로 청소. 큰 패키지 다운로드 후 캐시 활용.
> - venv 위치 표준: 프로젝트 안 .venv (자경단), 또는 ~/.virtualenvs (pyenv-virtualenv). .venv가 단순.
> - black 정책: PEP 8 + 더 강함. 88자 줄 길이, 공백 표준화. `--line-length=100`으로 변경 가능.
> - ruff 규칙: 700+ 룰. `pyproject.toml`에서 활성화. 자경단 표준은 default + select=["E", "F", "W", "I", "N"].
> - mypy strict: --strict 옵션은 8가지 검사 활성화. type 미명시 함수 경고. 자경단 표준.
> - pytest fixture: @pytest.fixture로 setup/teardown. conftest.py 자동 로드.
> - uv 성능: pip의 10-100배. 의존성 해결도 빠름. 자경단 1년 후 도입 검토.
> - poetry vs pdm: poetry는 lock + 빌드, pdm은 PEP 582 표준. 자경단은 단순함 위해 pip + requirements.txt.
> - 다음 H5 키워드: input · float · if/else · print · 환율 계산기 · 5사고.
