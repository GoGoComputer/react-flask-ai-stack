# Ch003 · H7 — 무대 뒤 — keepalive·HTTP/2·HTTP/3·로드 밸런서

> 고양이 자경단 · Ch 003 · 7교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. 200 OK 뒤의 무대 뒤 — 네 친구
3. TCP keepalive — 한 번 연결을 5분 재사용
4. HTTP/2 — 한 연결 위에 100 요청
5. HTTP/3 + QUIC — UDP 위의 새 시대
6. 로드 밸런서 — 다섯 서버를 한 IP로
7. CDN — 본인 가까운 서버에서
8. 캐시 다섯 층
9. 자경단 사이트의 무대 뒤
10. 흔한 오해 다섯 가지
11. 흔한 실수 다섯 가지 + 안심 멘트 — 무대 뒤 학습 편
12. 마무리 — 다음 H8에서 만나요

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H6을 한 줄로 회수할게요. 본인은 7다리 진단을 손에 익히셨어요. NIC, 게이트웨이, 라우팅, DNS, IP 도달, 포트, 응답. "안 돼요" 한 마디를 1분 안에 위치 좌표로 바꾸는 진단.

이번 H7은 깊이의 시간이에요. 본인이 H6 다리 7에서 받았던 "200 OK" 한 줄. 그 한 줄 뒤에는 사실 네 친구가 보이지 않게 일하고 있어요. keepalive, HTTP/2, HTTP/3, 로드 밸런서. 무대 뒤를 한 번에 다 보여 드릴게요.

오늘의 약속. **본인이 자경단 사이트가 1초에 1만 명을 받아낼 수 있는 비결을 한 시간에 다 알게 됩니다**.

자, 가요.

---

## 2. 200 OK 뒤의 무대 뒤 — 네 친구

본인이 google.com을 한 번 클릭하면 200 OK가 떠요. 그 한 줄 뒤에 네 친구가 일해요.

**친구 1 — keepalive**. TCP 연결을 한 번 만들고 5분 재사용. 매번 새 연결 만드는 비용 절감.

**친구 2 — HTTP/2**. 한 연결 위에 100개 요청 동시. 옛 HTTP/1.1은 한 연결에 한 요청씩.

**친구 3 — HTTP/3 + QUIC**. UDP 위에서. TCP의 한계를 넘기.

**친구 4 — 로드 밸런서**. 다섯 서버를 한 IP로 묶기. 본인이 google.com 쳐도 사실 100 서버 중 하나에 도달.

네 친구가 합쳐서 본인의 1초 응답을 만들어요. 한 명씩 만나러 가요.

---

## 3. TCP keepalive — 한 번 연결을 5분 재사용

본인이 google.com에 첫 요청을 보낼 때, TCP 핸드셰이크 3단계가 일어나요. SYN → SYN-ACK → ACK. 약 100ms.

```
Client → Server: SYN (안녕)
Server → Client: SYN-ACK (안녕)
Client → Server: ACK (잘 부탁해요)
```

이 3단계가 100ms 걸려요. 그런데 본인이 google.com에서 연속 10번 요청하면? 매번 100ms × 10 = 1초가 핸드셰이크에만. 너무 비싸요.

그래서 keepalive. 한 번 연결을 만들고, 데이터 교환 후에도 끊지 않아요. 5분 동안 살려 둬요. 같은 서버에 또 요청하면 그 연결 재사용. 100ms 절약.

자경단의 매일 — 한 페이지에서 100개 리소스 (CSS, JS, 이미지)를 다 같은 서버에서. keepalive로 한 연결만.

```bash
curl -v https://google.com 2>&1 | grep -i "alive\|reused"
# Connection #0 to host google.com left intact
```

본인이 직접 확인. 자경단 매일.

---

## 4. HTTP/2 — 한 연결 위에 100 요청

HTTP/1.1의 함정. 한 연결에 한 번에 한 요청만. 응답 받기 전엔 다음 요청 못 보냄. "head-of-line blocking"이라고 불러요.

```
HTTP/1.1: 요청1 → 응답1 → 요청2 → 응답2 → 요청3 → 응답3
```

브라우저는 6개 연결을 동시에 만들어서 6개 요청을 병렬로. 그래도 여전히 한 연결당 한 줄.

HTTP/2는 다른 모델. 한 연결 위에 100개 요청을 동시에. 응답도 동시에 와요. 멀티플렉싱이라 불러요.

```
HTTP/2: 요청1·2·3·...·100 (동시) → 응답들 (동시 도착)
```

자경단 사이트가 100 리소스를 가지고 있으면, HTTP/1.1은 17초, HTTP/2는 2초. 8배 빠름.

추가 기능 — server push. 서버가 클라이언트가 요청하기 전에 미리 보낼 수 있음. CSS와 JS를 HTML과 함께 푸시.

자경단 표준 — HTTP/2 항상.

---

## 5. HTTP/3 + QUIC — UDP 위의 새 시대

HTTP/2의 한계. TCP 위에서. TCP는 한 패킷 손실되면 모든 다음 패킷 멈춤. "TCP head-of-line blocking".

HTTP/3는 UDP 위에서 새로 짠 QUIC 프로토콜 사용. 패킷 손실이 한 stream에만 영향. 다른 stream은 계속.

장점.

- 0-RTT 재연결 (TCP는 1-RTT).
- 연결 마이그레이션 (와이파이→LTE 전환에서 연결 유지).
- 더 빠른 시작.

자경단 사이트는 HTTP/3 옵션. CDN (Cloudflare, Fastly)에서 자동 활성화.

```bash
curl --http3 https://google.com -I    # HTTP/3 직접 요청
```

---

## 6. 로드 밸런서 — 다섯 서버를 한 IP로

자경단 사이트가 1초에 1만 명을 받으려면? 한 서버는 안 돼요. 다섯 서버 또는 100 서버 필요.

문제. 사용자는 한 IP만 알아요. 어떻게 100 서버에 분산?

**로드 밸런서**. 한 IP 뒤에 100 서버. 들어오는 요청을 분산.

분산 알고리즘 다섯.

1. **Round Robin** — 순서대로. 1, 2, 3, 1, 2, 3.
2. **Least Connections** — 연결 적은 서버.
3. **IP Hash** — IP로 같은 서버 (sticky session).
4. **Weighted** — 서버별 가중치.
5. **Geographic** — 가까운 서버.

자경단의 미니가 AWS Application Load Balancer를 셋업. 다섯 서버 뒤. 자동 health check. 죽은 서버는 자동 제외.

```
사용자 → DNS → 로드 밸런서 IP → [서버1, 서버2, ..., 서버5]
```

L4 (TCP) vs L7 (HTTP) 로드 밸런서. L7이 더 풍부. 자경단 표준은 L7.

---

## 7. CDN — 본인 가까운 서버에서

CDN은 Content Delivery Network. 전 세계 100 도시에 서버 둠. 본인 가까운 도시에서 응답.

본인이 서울에서 google.com → 동경 서버 (50ms).
본인이 뉴욕에서 google.com → 뉴욕 서버 (10ms).

같은 콘텐츠를 100 도시에 복제. CDN이 자동 동기화.

자경단의 CDN. Cloudflare Free tier (100GB/월 무료). 정적 자산 (이미지, CSS, JS)을 CDN에. 동적 API는 origin 서버.

자경단 표준 — 모든 정적 자산은 CDN.

---

## 8. 캐시 다섯 층

요청이 200 OK 받기까지 다섯 캐시를 거쳐요.

**1. 브라우저 캐시**. 본인 노트북 디스크. 0ms.

**2. CDN 캐시**. 본인 도시 서버. 10ms.

**3. 리버스 프록시 캐시**. nginx, Cloudflare Workers. 5ms.

**4. 애플리케이션 캐시**. Redis, Memcached. 1ms.

**5. 데이터베이스 캐시**. Postgres buffer cache. 0.5ms.

다섯 캐시가 다 hit이면 5ms에 응답. 다 miss면 500ms.

자경단 매주 캐시 hit ratio 점검. 90%+ 목표.

---

## 9. 자경단 사이트의 무대 뒤

자경단 사이트의 한 요청 흐름.

```
사용자 (서울)
↓ DNS 조회 (Route53)
CloudFlare CDN (서울 edge)
↓ 캐시 hit이면 응답 (10ms)
↓ miss면 origin
AWS ALB (load balancer)
↓ Round Robin
EC2 인스턴스 5대 중 1대
↓
nginx → FastAPI app
↓ Redis 캐시 hit
응답 → ALB → CDN → 사용자
```

10단계. 평균 50ms. 1초에 1만 명을 받아내는 자경단 사이트.

---

## 10. 흔한 오해 다섯 가지

**오해 1: HTTP/2 자동.**

서버 + 클라이언트 둘 다 지원해야.

**오해 2: HTTP/3 항상 빠름.**

UDP 차단 환경에서 fallback.

**오해 3: 로드 밸런서 비싸다.**

AWS Free tier로 시작.

**오해 4: CDN 정적만.**

동적도 부분 가능.

**오해 5: 캐시 한 층이면.**

다섯 층이 곱셈.

---

## 11. 흔한 실수 다섯 가지 + 안심 멘트 — 무대 뒤 학습 편

§10에서 무대 뒤 오해 5개를 봤어요. 이번엔 본인의 학습 자세 함정 다섯을 짚고 가요.

첫 번째 함정, HTTP/2와 HTTP/3을 동시에 깊이 들어가려고. 본인이 두 프로토콜의 모든 디테일을 한 번에 외우려고. 안심하세요. **HTTP/2의 멀티플렉싱 한 줄, HTTP/3의 UDP 한 줄만 머리에 두세요.** 디테일은 두 해 후 운영자가 됐을 때 만나면 친구. 첫 챕터에는 이름과 한 줄 의미만.

두 번째 함정, keepalive를 본인이 직접 관리하려고. 본인이 코드에 connection 헤더 직접 박으려고. 안심하세요. **현대 HTTP 클라이언트(curl, requests, fetch)는 자동.** 본인이 신경 쓸 필요 없어요. 두 해 후 nginx 운영하실 때 keepalive_timeout 설정 만나면 그때 깊이.

세 번째 함정, 로드 밸런서를 처음부터 복잡하게 본다. L4·L7·sticky session·health check·SSL termination 다 한 번에. 안심하세요, 함정 풀이부터. **첫날엔 "한 IP에 여러 서버 분산" 한 줄.** ALB·NLB·Classic LB는 Ch107 시간에. 첫 챕터엔 비유만.

네 번째 함정, CDN을 정적 자산만으로 단정한다. 본인이 "CDN은 이미지·CSS만" 단순화. 안심하세요. **현대 CDN(Cloudflare, Fastly)은 동적 콘텐츠도 캐싱·프록시.** Edge Workers·Edge Computing이 진짜 큰 변화. Ch113 CloudFront에서 깊이.

다섯 번째 함정, 가장 큰 함정. **캐시 다섯 층을 동시에 다 활성화하려고.** 본인이 신입 첫날부터 브라우저·CDN·리버스 프록시·앱·DB 다섯 캐시를 다 쓰려고. 안심하세요. **한 층씩.** 첫 학기엔 브라우저 캐시(자동), 두 번째 학기엔 CDN, 세 번째 학기엔 Redis. 한 번에 다 쓰면 캐시 무효화 사고가 다섯 배. Ch001 H7에서 본 "캐시 무효화는 컴퓨터 과학의 어려운 두 문제 중 하나" — Phil Karlton 인용. 한 층씩 천천히.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 12. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요. 본인 손에 무대 뒤 네 친구가 들어왔어요. keepalive (재사용), HTTP/2 (멀티플렉싱), HTTP/3 (UDP), 로드 밸런서 (분산). 그리고 CDN과 캐시 다섯 층. 본인이 매일 1초 안에 받는 응답의 진짜 비결.

다음 H8은 마지막 시간. 적용 + 회고 + Ch004 다리. 자경단 사이트의 8주 네트워크 로드맵을 세우고, Ch003 8시간을 한 줄로 정리하고, 다음 챕터(Git & GitHub)로 다리를 놓아요. 거의 다 왔어요.

오늘 한 줄 정리. **"200 OK 한 줄 뒤에 네 친구가 보이지 않게 일하고, 그 위에 다섯 캐시가 90% 응답을 미리 만들어 놓는다."** 이 한 줄이 두 해 후 본인이 만들 모든 사이트의 진짜 모양.

본인 페이스. 7/8 시간. 87.5%. 마지막 한 시간만 남았어요. 짝짝짝. 박수. 5분 쉬고 H8에서 만나요.

> ▶ **같이 쳐보기** — HTTP 버전 직접 확인
>
> ```bash
> curl -v --http2 https://google.com 2>&1 | grep -i "http"
> ```

본인 노트북에서 google.com이 HTTP/2를 쓰는지 확인. 두 해 후 본인 사이트도 HTTP/2 기본.

---

## 👨‍💻 개발자 노트

> - keepalive 헤더: Connection: keep-alive (HTTP/1.1 기본).
> - HTTP/2 멀티플렉싱: stream ID로 식별.
> - QUIC: UDP + TLS 1.3 통합.
> - L4 vs L7: L4는 IP/Port, L7은 HTTP path/header.
> - CDN edge: 100~300 도시.
> - 다음 H8 키워드: 자경단 8주 로드맵 · CDN · ALB · 응답 시간 · SLA.
> - HTTP/2는 RFC 7540 (2015), HTTP/3는 RFC 9114 (2022) 표준. HTTP/3 + QUIC은 Google 내부 프로토콜이 IETF 표준으로 발전한 사례.
> - keepalive timeout은 nginx 기본 65초, Apache 5초, AWS ALB 60초. 클라이언트 timeout과 서버 timeout 불일치가 502 사고의 단골 원인.
> - 로드 밸런서 알고리즘 5종 — Round Robin (간단), Least Connections (정교), IP Hash (sticky), Weighted (가중), Geographic (지리). AWS ALB는 Round Robin + Least Outstanding Requests 기본.
> - CDN은 1998년 Akamai가 시초. 2010년대 Cloudflare/Fastly가 Edge Computing으로 진화. 2020년대 Edge Workers (Cloudflare Workers, Lambda@Edge) — CDN이 단순 캐시에서 진짜 컴퓨팅 플랫폼으로.
> - 캐시 다섯 층의 hit rate — 잘 설계된 사이트는 브라우저 50%, CDN 30%, 앱 캐시 15%, DB 캐시 4%, 미스 1%. 95% hit이 SLA의 진짜 비밀.
> - §11 다섯째 함정 캐시 무효화 — Phil Karlton 1996년 인용 "There are only two hard things in Computer Science: cache invalidation and naming things." Ch001 H7과 Ch003 H7 두 번 회수.
