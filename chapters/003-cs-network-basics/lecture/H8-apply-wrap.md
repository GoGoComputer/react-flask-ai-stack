# Ch003 · H8 — 자경단 8주 네트워크 로드맵 + 회고

> 고양이 자경단 · Ch 003 · 8교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속
2. Ch003 7시간 회고
3. 자경단 사이트 8주 로드맵
4. 1주차 — 도메인과 DNS
5. 2주차 — HTTPS와 인증서
6. 3주차 — CDN 셋업
7. 4주차 — 로드 밸런서
8. 5주차 — 모니터링
9. 6~8주차 — 진화
10. 본인의 학습 회고
11. Ch004로 가는 다리
12. 흔한 실수 다섯 가지 + 안심 멘트 — Ch003 회고 학습 편
13. 마무리

---

## 1. 다시 만나서 반가워요 — H7 회수와 오늘의 약속

자, 안녕하세요. 본 챕터의 마지막 시간이에요.

지난 H7 회수. 무대 뒤 네 친구 — keepalive, HTTP/2, HTTP/3, 로드 밸런서. CDN과 캐시 다섯 층.

이번 H8은 적용과 회고. Ch003에서 배운 모든 것을 자경단 사이트의 8주 청사진으로 압축.

오늘의 약속. **본인이 "네트워크가 무엇인지 안다"에서 "내가 만들 사이트의 네트워크 청사진을 그릴 수 있다"로 넘어갑니다**.

자, 가요.

---

## 2. Ch003 7시간 회고

본인이 7시간 동안 무엇을 만나셨는지 한 페이지로.

**H1** — 네트워크의 큰 그림. 왜 배우나. 일곱 이유.

**H2** — 핵심 4 — TCP/IP, HTTP, DNS, HTTPS.

**H3** — 환경점검. 본인 노트북의 IP 어디.

**H4** — 도구 14. ping, dig, curl, traceroute, ...

**H5** — 0.3초의 30단계. 클릭 한 번이 거치는 길.

**H6** — 7다리 진단. "안 돼요"를 1분에.

**H7** — 무대 뒤. keepalive, HTTP/2/3, LB, CDN.

**H8** — 지금. 8주 로드맵.

7시간이 자경단 사이트 한 채를 짓는 토대. 본인의 노트북에 7층 빌딩이 박혔어요.

---

## 3. 자경단 사이트 8주 로드맵

본인이 자경단 사이트를 8주에 인터넷에 올리는 청사진.

| 주차 | 작업 | 완료 결과 |
|------|------|----------|
| 1 | 도메인 + DNS | cat-vigilante.com 작동 |
| 2 | HTTPS 인증서 | 자물쇠 표시 |
| 3 | CDN | 정적 자산 가속 |
| 4 | 로드 밸런서 | 5 서버 분산 |
| 5 | 모니터링 | 사고 알림 |
| 6 | HTTP/2 + keepalive | 응답 50% 빠름 |
| 7 | HTTP/3 | UDP 옵션 |
| 8 | 보안 헤더 + 회고 | 자경단 표준 |

8주. 자경단 5명이 매일 한 시간씩.

---

## 4. 1주차 — 도메인과 DNS

월요일. 본인이 cat-vigilante.com을 사요. namecheap에서 $10. 1년.

화요일. AWS Route 53에 등록.

```bash
# Route 53 hosted zone
aws route53 create-hosted-zone --name cat-vigilante.com
```

A 레코드를 본인 EC2 IP로.

```
A    cat-vigilante.com    52.x.x.x
A    www.cat-vigilante.com    52.x.x.x
```

수요일. DNS 전파 대기 (24시간).

목요일. `dig cat-vigilante.com`로 전파 확인.

금요일. 브라우저에서 `cat-vigilante.com` 직접 — 자경단 사이트 첫 인사.

1주차 완료. 본인 사이트가 인터넷에 도착.

---

## 5. 2주차 — HTTPS와 인증서

월요일. Let's Encrypt로 무료 인증서.

```bash
# certbot
brew install certbot
sudo certbot certonly --nginx -d cat-vigilante.com
```

화요일. nginx 설정.

```nginx
server {
    listen 443 ssl http2;
    server_name cat-vigilante.com;
    
    ssl_certificate /etc/letsencrypt/live/cat-vigilante.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/cat-vigilante.com/privkey.pem;
    
    # 자동 80→443 redirect
}

server {
    listen 80;
    server_name cat-vigilante.com;
    return 301 https://$host$request_uri;
}
```

수요일. 자동 갱신 cron.

```
0 0 * * 0 certbot renew --quiet
```

목요일. 브라우저 자물쇠 확인.

금요일. Qualys SSL Labs로 등급 점검. A+ 목표.

2주차 완료. HTTPS 자물쇠.

---

## 6. 3주차 — CDN 셋업

월요일. Cloudflare 무료 plan 가입.

화요일. DNS를 Route 53 → Cloudflare로 이전.

수요일. Cloudflare 설정.

- Always Use HTTPS: ON
- Auto Minify (CSS, JS, HTML): ON
- Brotli compression: ON
- HTTP/3: ON

목요일. 정적 자산 캐싱 규칙.

- /images/* → Cache 1년
- /css/*, /js/* → Cache 1주

금요일. 응답 시간 측정. Before 200ms → After 50ms.

3주차 완료. 사이트가 4배 빠름.

---

## 7. 4주차 — 로드 밸런서

월요일. AWS Application Load Balancer 생성.

화요일. EC2 5 인스턴스 띄움.

수요일. ALB 뒤에 5 인스턴스 등록.

목요일. health check 셋업. 죽은 서버 자동 제외.

금요일. 부하 테스트. 1만 동시 사용자 시뮬.

4주차 완료. 5 배 처리량.

---

## 8. 5주차 — 모니터링

월요일. CloudWatch 셋업. CPU, 메모리, 응답 시간 지표.

화요일. PagerDuty 또는 Slack 연결. 사고 시 알림.

수요일. 응답 시간 SLA. 99% 요청이 100ms 안.

목요일. 알람 룰 5개. 5xx 에러율 1% 초과 등.

금요일. 첫 알람 시뮬레이션. 30초 안에 본인 폰에 알림.

5주차 완료. 자경단의 24/7 감시.

---

## 9. 6~8주차 — 진화

**6주차** — HTTP/2 + keepalive. 응답 50% 빠름.

**7주차** — HTTP/3 옵션. Cloudflare에서 한 클릭.

**8주차** — 보안 헤더 (HSTS, CSP). + 회고.

8주 끝. 자경단 사이트가 google.com과 거의 같은 수준의 인프라.

---

## 10. 본인의 학습 회고

7시간 + 8주 청사진 후 본인이 가진 것.

**개념** — TCP/IP, HTTP, DNS, HTTPS, keepalive, HTTP/2/3, LB, CDN.

**도구** — ping, dig, curl, traceroute, nc, nettest 함수.

**진단** — 7다리. "안 돼요" 1분 진단.

**구축** — 8주에 자경단 사이트 한 채.

**자신감** — 어느 회사 가도 네트워크 사고에 1분 안 진단.

이게 본인의 Ch003 자산. 5년 갑니다.

---

## 11. Ch004로 가는 다리

다음 챕터 Ch004는 Git/GitHub. Ch003과 다리.

자경단 사이트의 코드를 어떻게 관리하나? Git. 어떻게 배포하나? `git push` → GitHub Actions → AWS deploy.

Ch003에서 배운 7단계 (DNS, TCP, TLS, HTTP, ...)가 매 `git push`마다 발동. 본인이 commit 한 번 칠 때마다 Ch003의 모든 게 한 번에 일어나요.

Ch004 8시간이 자경단 사이트의 두 번째 토대.

---

## 12. 흔한 실수 다섯 가지 + 안심 멘트 — Ch003 회고 학습 편

8시간 마무리 직전 학습 자세 함정 다섯을 짚고 가요.

첫 번째 함정, 8주 로드맵을 그대로 따라하려고 한다. 본인이 "1주차 도메인, 2주차 HTTPS..." 그대로 8주 안에. 안심하세요. **8주는 평균이에요.** 본인 페이스로 12주 가도 OK, 4주 가도 OK. 페이스보다 완주가 중요. 한 주차 막히면 다음 주차 가지 마시고 그 자리에서 풀세요. 막힘이 학습이에요.

두 번째 함정, 자경단 도메인을 진짜 사야 한다고 생각. 본인이 cat-vigilante.com 진짜 $10 결제. 안심하세요. **로컬 도메인 + /etc/hosts로 충분.** `127.0.0.1 cat-vigilante.local` 한 줄. 진짜 도메인은 8학기 이후 본인 사이트 진짜 띄울 때. Ch003은 학습용, 진짜 운영은 두 해 후.

세 번째 함정, 모든 도구·서비스를 사용한다. 본인이 1주차에 Cloudflare·Route53·Let's Encrypt·certbot·nginx·CloudWatch·PagerDuty 다. 안심하세요, 함정 풀이부터. **첫날엔 가장 단순한 조합으로.** 도메인 + 정적 사이트 + HTTPS 셋만. Cloudflare가 다 묶어 줘요. 진화는 두 해 후. 첫 시작은 가벼움이 진짜 핵심.

네 번째 함정, 8시간 끝나면 다 안다고 단정. 본인이 "Ch003 끝, 네트워크 다 안다." 안심하세요. **두 해 코스에서 네트워크는 12번 더 등장.** Ch004 git push, Ch035 SQL, Ch062 Redis, Ch068 nginx, Ch097 RAG, Ch113 CloudFront 등. 매번 만날 때마다 한 단계 깊이. Ch003 8시간은 두 해 코스의 약 2.5%일 뿐. 자만하지 마시고 다음 챕터로.

다섯 번째 함정, 가장 큰 함정. **다음 챕터로 바로 가지 않고 멈춘다.** 본인이 8시간 듣고 너무 피곤해서 두 주 휴식. 그 두 주가 한 달, 두 달, 영영. 안심하세요. **두 주 후 정확히 다시 와 주세요.** 챕터 사이 두 주는 표준. 그 이상 비면 잊는 게 더 빠름. 잊으면 다시 듣기 더 어려움. 두 해 코스의 진짜 비결 — 멈추지 않기. Ch001~Ch120까지 한 번도 안 빠지고 가는 사람이 두 해 후 진짜 신입 개발자. 본인이 그 길의 1.7%. 작아 보이지만 시작이 절반. 한 번 시작했으니 끝까지 가세요.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 13. 마무리

자, 여덟 번째 시간이 끝났어요. 본 챕터 끝.

7시간 회고, 8주 로드맵, 학습 자산, Ch004 다리, 흔한 실수 다섯.

박수 한 번 칠게요. 진짜 큰 박수예요. 본인이 8시간 끝까지 따라오셨어요. 두 해 코스의 큰 마디 한 칸을 더 채우신 거예요.

본 챕터 끝. 진행률 24/960 = 2.5%. Ch001 0.83%부터 Ch003 2.5%까지. 한 챕터에 약 0.83% 추가. 페이스 일정. 좋은 신호.

다음 만남 — Ch004 H1. 두 주 후. Git & GitHub. 본인이 만든 코드를 진짜 사람들과 나누는 도구. 자경단 사이트의 두 번째 토대.

> ▶ **같이 쳐보기** — 본인의 두 해 후 시연 미리보기
>
> ```bash
> nettest cat-vigilante.com
> ```

본인의 첫 자경단 사이트 진단. 8주 후엔 본인이 진짜로 쳐요. 두 해 후엔 본인이 만들어 놓은 도구들로.

오늘 한 줄 정리. **"네트워크는 지구 규모의 우편 시스템이고, 우리는 8시간 동안 그 시스템의 4기둥(TCP/IP·HTTP·DNS·HTTPS)·14도구·7다리 진단·30단계·무대 뒤·8주 로드맵을 손에 쥐었다."** 이 한 줄이 두 해 코스의 진짜 큰 자산.

본인 페이스. 8/8 시간. 100%. 본 챕터 진짜 끝. 두 해 후 본인이 만들 자경단 사이트의 네트워크 청사진이 머리에 박힌 본인. 본인 자신에게 진짜 큰 박수. 짝짝짝. 두 주 후 Ch004에서 만나요. 본인이 그날 다시 와 주시는 게 두 해 코스의 진짜 비결. 약속해 주세요. 두 주 후. 잘 들어 주셔서 진심으로 감사합니다. 안녕히 계세요.

---

## 👨‍💻 개발자 노트

> - 도메인 등록: namecheap, GoDaddy, Cloudflare Registrar.
> - DNS hosting: Route 53, Cloudflare DNS.
> - 인증서: Let's Encrypt (무료) vs DigiCert (유료).
> - CDN tier: Cloudflare Free → Pro → Business.
> - 모니터링 stack: CloudWatch + PagerDuty + DataDog.
> - 다음 챕터 Ch004: Git, GitHub, .git 내부.
> - 8주 로드맵은 평균. 학습자별 4~12주 변동 가능. 페이스보다 완주 우선.
> - 학습용 도메인은 /etc/hosts + .local TLD로 충분. 진짜 도메인은 두 해 후 capstone에서.
> - Ch003은 두 해 코스에서 12번 회수 (Ch004 git push HTTPS, Ch035 SQL connection, Ch062 Redis, Ch068 nginx, Ch097 RAG, Ch113 CloudFront 등).
> - §12 다섯째 함정 "멈추지 않기"는 Spaced Repetition + Forgetting Curve 학습 이론. 두 주 간격이 단기 → 장기 메모리 전환의 표준 간격.
> - 분량: 본 H8은 본문 짧지만 8주 로드맵의 실용성을 우선. 핵심 디벨롭 패턴 (흔한 실수 + 노트) 적용 완료. 분량 보강은 후속 작업으로.
