# Ch 001 · 컴퓨터 구조 기본 — CPU·메모리·디스크·네트워크

> 학기: **S1 · CS 기초 + Python 입문** · 강의 시간: **8교시 × 60분 = 8시간** · 학습 권장: **2주**

---

## 🎯 학습 목표

- [ ] CPU·메모리(RAM)·디스크(SSD)·네트워크 카드의 역할과 차이를 비유와 숫자로 설명할 수 있다
- [ ] "프로그램이 실행된다"는 말이 디스크 → RAM → CPU로의 데이터 흐름임을 안다
- [ ] 폰노이만 구조와 캐시 계층(L1/L2/L3/RAM/SSD/네트워크)의 속도 차이를 체감 단위로 비교할 수 있다
- [ ] 내 맥/PC의 실제 사양을 명령어로 직접 확인하고, 무엇을 사야 할지 의사결정할 수 있다
- [ ] 다음 챕터(Ch 002 운영체제)에서 다룰 "프로세스"가 왜 필요한지 한 줄로 말할 수 있다

## ✅ 완료 체크리스트

- [ ] H1~H8 강의 시청/음독
- [ ] `start/` → `finish/` 코드 실습 (시스템 정보 수집 Bash 스크립트)
- [ ] `exercises.md` 3문제 풀이
- [ ] 내 맥의 CPU 코어 수·RAM·디스크 용량을 외워서 말할 수 있음
- [ ] 다음 챕터(Ch 002) H1 회수 멘트와 자연스럽게 연결됨

## 📂 폴더

- `start/` — 빈 Bash 스크립트 한 개 (`sysinfo.sh`)
- `finish/` — 시스템 정보를 한 화면에 모아 출력하는 완성 스크립트
- `exercises.md` — 3문제 (쉬움/중간/어려움)
- `notes/` — 폰노이만 구조 다이어그램·캐시 계층 표·면접 Q&A
- `lecture/` — 8교시 강의 대본 (H1~H8)

## 🔗 연결

- ⬅ 이전: (없음 — 이 코스의 첫 챕터)
- ➡ 다음: [Ch 002 · 운영체제 기본](../002-cs-os-basics/)
- 📋 매트릭스: [docs/CHAPTER-MATRIX.md](../../docs/CHAPTER-MATRIX.md)
- 🎙 대본 템플릿: [docs/LECTURE-TEMPLATE.md](../../docs/LECTURE-TEMPLATE.md)
- 🎨 톤 가이드: [docs/STYLE-GUIDE.md](../../docs/STYLE-GUIDE.md)

## 🛠 산출물

- **`sysinfo.sh`** — 내 맥의 CPU·RAM·디스크·네트워크를 한 화면에 보여주는 Bash 스크립트
- **사양 카드** — 내 맥 한 대의 사양을 A4 한 장에 정리한 노트

## 🎙 강의 시간표 (8교시)

| 교시 | 부제 | 파일 |
|------|------|------|
| H1 | 왜 컴퓨터 구조부터 배우나 — 보이지 않는 손 | [H1-orientation.md](lecture/H1-orientation.md) |
| H2 | 핵심 부품 네 개 — CPU·RAM·디스크·네트워크 | [H2-concepts.md](lecture/H2-concepts.md) |
| H3 | 내 맥의 신분증 — 한 줄로 사양 확인하기 | [H3-setup.md](lecture/H3-setup.md) |
| H4 | 시스템 명령어 카탈로그 10개 | [H4-catalog.md](lecture/H4-catalog.md) |
| H5 | 데모 — 내 맥의 모든 부품을 한 화면에 | [H5-demo.md](lecture/H5-demo.md) |
| H6 | 부품 관리 — 메모리 압박·디스크 정리·네트워크 진단 | [H6-management.md](lecture/H6-management.md) |
| H7 | 원리 — 폰노이만·캐시 계층·왜 빠른가 | [H7-internals.md](lecture/H7-internals.md) |
| H8 | 적용 — 내 다음 노트북 사양 의사결정 + 다음 챕터 예고 | [H8-apply-wrap.md](lecture/H8-apply-wrap.md) |
