# Ch011 · H5 — text_processor 30분 — str + regex 통합 적용

> 고양이 자경단 · Ch 011 · 5교시 (60분)

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속
2. text_processor 시나리오
3. 0~5분 — 폴더 셋업
4. 5~10분 — clean() 함수
5. 10~15분 — extract_emails()
6. 15~20분 — mask_sensitive()
7. 20~25분 — main()와 파이프라인
8. 25~30분 — 실행과 검증
9. 다섯 사고와 처방
10. 흔한 오해 다섯 가지
11. 마무리

---

## 1. 다시 만나서 반가워요 — H4 회수와 오늘의 약속

자, 안녕하세요.

지난 H4 회수. 30 패턴 — 검증, 추출, 변환.

이번 H5는 30분에 text_processor 짜기.

오늘의 약속. **본인이 첫 텍스트 프로세서 100줄을 짭니다**.

자, 가요.

---

## 2. text_processor 시나리오

자경단 미니의 의뢰. "로그 파일에서 이메일과 IP를 추출하고, 비밀번호를 마스킹해서 정리된 보고서로 만들어 주세요."

입력 — raw_logs.txt (로그 1만 줄).
출력 — clean_report.txt (정리된 보고서).

30분에 100줄 짜기.

---

## 3. 0~5분 — 폴더 셋업

```bash
mkdir -p /tmp/text-demo && cd /tmp/text-demo
python3 -m venv .venv
source .venv/bin/activate
pip install rich

cat > raw_logs.txt <<'EOF'
2026-04-30 10:00:00 [INFO] User user@example.com logged in from 192.168.1.1
2026-04-30 10:01:00 [ERROR] Password 12345678 mismatch
2026-04-30 10:02:00 [INFO] User admin@vigilante.com from 10.0.0.5
EOF

touch text_processor.py
```

---

## 4. 5~10분 — clean() 함수

```python
"""text_processor.py — 자경단 텍스트 정리 도구"""

import re
from rich import print


def clean(text: str) -> str:
    """공백, 줄바꿈 정리."""
    # 여러 공백을 하나로
    text = re.sub(r'[ \t]+', ' ', text)
    # 여러 줄바꿈을 하나로
    text = re.sub(r'\n{3,}', '\n\n', text)
    # 양쪽 공백 제거 (멀티라인)
    text = re.sub(r'^\s+|\s+$', '', text, flags=re.MULTILINE)
    return text
```

3줄 정리. 자경단 매일.

---

## 5. 10~15분 — extract_emails()

```python
def extract_emails(text: str) -> list[str]:
    """모든 이메일 주소 추출."""
    pattern = r'[\w.+-]+@[\w.-]+\.\w+'
    return re.findall(pattern, text)


def extract_ips(text: str) -> list[str]:
    """모든 IPv4 주소 추출."""
    pattern = r'(?:\d{1,3}\.){3}\d{1,3}'
    return re.findall(pattern, text)


def extract_dates(text: str) -> list[str]:
    """모든 ISO 날짜 추출."""
    return re.findall(r'\d{4}-\d{2}-\d{2}', text)
```

세 추출 함수. 패턴 매일.

---

## 6. 15~20분 — mask_sensitive()

```python
def mask_password(text: str) -> str:
    """Password 뒤 숫자/문자 마스킹."""
    return re.sub(r'(Password\s+)(\S+)', r'\1********', text)


def mask_email(text: str) -> str:
    """이메일의 user 부분만 *로."""
    def replacer(match):
        local, domain = match.group(0).split('@')
        return '*' * len(local) + '@' + domain
    return re.sub(r'[\w.+-]+@[\w.-]+\.\w+', replacer, text)


def mask_ip(text: str) -> str:
    """IP의 마지막 octet 마스킹."""
    return re.sub(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.)\d{1,3}', r'\1xxx', text)
```

세 마스킹. 보안 매일.

---

## 7. 20~25분 — main()와 파이프라인

```python
def process_pipeline(text: str) -> dict:
    """전체 파이프라인."""
    cleaned = clean(text)
    
    return {
        "cleaned": cleaned,
        "emails": extract_emails(cleaned),
        "ips": extract_ips(cleaned),
        "dates": extract_dates(cleaned),
        "masked": mask_email(mask_ip(mask_password(cleaned))),
    }


def main() -> None:
    with open("raw_logs.txt") as f:
        raw = f.read()
    
    result = process_pipeline(raw)
    
    print("[bold]=== 추출 결과 ===[/bold]")
    print(f"이메일: {result['emails']}")
    print(f"IP: {result['ips']}")
    print(f"날짜: {result['dates']}")
    
    print("\n[bold]=== 마스킹 결과 ===[/bold]")
    print(result['masked'])
    
    with open("clean_report.txt", "w") as f:
        f.write(result['masked'])
    
    print("\n[green]✅ 보고서 저장: clean_report.txt[/green]")


if __name__ == "__main__":
    main()
```

파이프라인 패턴. 자경단 표준.

---

## 8. 25~30분 — 실행과 검증

```bash
$ python3 text_processor.py
=== 추출 결과 ===
이메일: ['user@example.com', 'admin@vigilante.com']
IP: ['192.168.1.1', '10.0.0.5']
날짜: ['2026-04-30', '2026-04-30', '2026-04-30']

=== 마스킹 결과 ===
2026-04-30 10:00:00 [INFO] User ****@example.com logged in from 192.168.1.xxx
2026-04-30 10:01:00 [ERROR] Password ******** mismatch
2026-04-30 10:02:00 [INFO] User *****@vigilante.com from 10.0.0.xxx

✅ 보고서 저장: clean_report.txt
```

3개 함수 + 파이프라인 + 마스킹. 100줄 미만.

---

## 9. 다섯 사고와 처방

**사고 1: greedy 너무 많이 매치**

처방. lazy `*?`.

**사고 2: 멀티라인 매치 안 됨**

처방. re.MULTILINE.

**사고 3: 한글 깨짐**

처방. open() encoding="utf-8".

**사고 4: 정규식 컴파일 매번**

처방. re.compile 모듈 레벨.

**사고 5: replacer 함수 캡처 안 됨**

처방. group(1), group(2)로.

---

## 10. 흔한 오해 다섯 가지

**오해 1: 100줄 너무 많다.**

함수 5개 × 평균 15줄.

**오해 2: 마스킹은 한 번.**

여러 단계 chaining.

**오해 3: 파이프라인 함수형이다.**

OOP에도 가능.

**오해 4: re.findall이 정렬됨.**

순서대로. 정렬은 sorted.

**오해 5: rich 옵션.**

자경단 표준.

---

## 11. 흔한 실수 다섯 + 안심 — 데모 학습 편

첫째, regex 한 번에 복잡. 안심 — 단순 패턴부터.
둘째, 인코딩 사고. 안심 — UTF-8 강제.
셋째, str 변환 누락. 안심 — `str(x)` 명시.
넷째, multiline 무지. 안심 — `re.MULTILINE`.
다섯째, 가장 큰 — 정규식 다 외움. 안심 — regex101 매번.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게.

## 12. 마무리

자, 다섯 번째 시간 끝.

text_processor 100줄. clean, extract 3개, mask 3개, pipeline.

다음 H6은 운영. 함정, 성능, encoding.

```bash
black text_processor.py
ruff check text_processor.py
```

---

## 👨‍💻 개발자 노트

> - re.sub callable: 함수도 가능. 동적 치환.
> - flags=re.MULTILINE | re.IGNORECASE: 비트 OR.
> - regex DOS: 1만 줄 텍스트에 nested .* 위험.
> - 마스킹 보안: 마스킹된 데이터도 패턴 분석 가능.
> - 다음 H6 키워드: encoding · UTF-8 · 성능 · catastrophic backtracking.
