# Ch006 · H7 — 셸 내부 — fork·exec·signal·job control

> 고양이 자경단 · Ch 006 · 7교시 (60분)
> 이 파일은 강사가 마이크 앞에서 그대로 읽을 수 있는 말 그대로의 대본입니다.

---

## 📋 이 시간 목차

1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속
2. 0.3초 7단계 깊이 (H1 회수)
3. fork() 시스템콜
4. exec() 시스템콜
5. wait() — 부모가 자식 기다리기
6. signal — 프로세스 간 통신
7. job control — 백그라운드 관리
8. 환경변수 상속
9. pipe와 redirection 내부
10. 자경단 매일의 0.3초 안
11. 흔한 오해 다섯 가지
12. 마무리 — 다음 H8에서 만나요

---

## 1. 다시 만나서 반가워요 — H6 회수와 오늘의 약속

자, 안녕하세요. 다시 만났습니다.

지난 H6 회수. 본인이 첫 deploy.sh 50줄을 짰어요. set -euo pipefail, function, trap, getopts.

이번 H7은 깊이의 시간. H1에서 봤던 0.3초 7단계를 0.001초 단위로 풀어요.

오늘의 약속. **본인이 ls 한 번 칠 때 일어나는 fork-exec의 진짜 메커니즘을 만집니다**.

자, 가요.

---

## 2. 0.3초 7단계 깊이 (H1 회수)

H1에서 본인이 ls 한 번 칠 때 0.3초 7단계.

1. 키보드 입력
2. 터미널이 셸에 전달
3. 셸이 PATH 검색
4. fork + exec
5. ls 실행
6. ls 결과 출력
7. 셸이 다음 prompt

이번엔 4번 (fork + exec)을 깊이.

---

## 3. fork() 시스템콜

`fork()`는 부모 프로세스를 복제해서 자식 프로세스 만드는 syscall.

```c
pid_t pid = fork();
if (pid == 0) {
    // 자식 코드
} else if (pid > 0) {
    // 부모 코드, pid는 자식 PID
} else {
    // fork 실패
}
```

핵심. **fork() 후 두 프로세스가 거의 동일**. 메모리, 파일 디스크립터, 환경변수 다 복사.

다른 점 — pid 값이 다름. 부모는 자식의 pid, 자식은 0.

비유. 본인이 종이를 한 장 들고 있는데 fork()를 호출하면 같은 종이가 두 장이 돼요. 한 장은 본인이, 한 장은 자식이.

성능. fork()가 비싸 보이지만 copy-on-write로 빠름. 변경되는 페이지만 실제 복사.

---

## 4. exec() 시스템콜

`exec()`은 현재 프로세스의 코드를 새 프로그램으로 갈아끼우는 syscall.

```c
execve("/bin/ls", argv, envp);
```

fork 후 자식이 exec 호출. 자식의 코드가 ls로 변신.

핵심. **exec 후 원래 코드는 사라짐**. 같은 프로세스(같은 PID)지만 다른 프로그램.

비유. 본인이 자식 종이에 ls 코드를 덮어 써요. 종이 (PID)는 같지만 내용이 ls.

전체 흐름.

```
셸 (부모) → fork() → 자식 (셸 복제)
                     ↓ exec("/bin/ls")
                     자식이 ls로 변신
                     ↓ ls 실행
                     ↓ 종료
        ↓ wait()로 종료 알림 받기
        프롬프트 표시
```

이게 셸이 외부 명령을 실행하는 표준 방식. fork + exec.

---

## 5. wait() — 부모가 자식 기다리기

자식이 일하는 동안 부모는 wait로 기다려요.

```c
int status;
wait(&status);   // 자식 종료까지 멈춤
```

자식이 끝나면 wait가 반환. exit code가 status에 들어옴.

본인이 셸에서.

```bash
ls
echo $?    # 직전 명령의 exit code
```

`$?`가 wait가 받은 status.

zombie 프로세스. 자식이 끝났는데 부모가 wait 안 하면 자식은 zombie 상태. PID는 살아 있고 결과만 저장. 부모가 wait해야 해방.

```bash
ps aux | grep defunct   # zombie 찾기
```

자경단의 매일 — 셸 스크립트가 항상 wait. 그래서 zombie 안 생김.

---

## 6. signal — 프로세스 간 통신

signal은 프로세스에 짧은 메시지 보내기.

자경단의 매일 만나는 signal 다섯.

**SIGINT** (2). Ctrl+C. 정상 종료 요청.

**SIGTERM** (15). kill의 기본. 정상 종료.

**SIGKILL** (9). kill -9. 강제 종료. 무시 못 함.

**SIGHUP** (1). 셸 종료 시 자식에게.

**SIGCHLD**. 자식이 끝났음을 부모에게.

```bash
kill -INT 1234     # SIGINT
kill -TERM 1234    # SIGTERM (기본)
kill -9 1234       # SIGKILL
```

trap으로 signal 처리.

```bash
#!/bin/bash
trap 'echo "Ctrl+C 받음, 정리 중..."; exit 1' INT

while true; do sleep 1; done
```

Ctrl+C 누르면 정리 후 종료. 자경단 표준.

---

## 7. job control — 백그라운드 관리

본인이 셸에서 명령 뒤에 `&`을 붙이면 백그라운드.

```bash
sleep 100 &
# [1] 12345

jobs
# [1]+  Running    sleep 100

fg %1     # foreground로
bg %1     # background로

# Ctrl+Z로 일시 정지
# bg로 백그라운드 재개

kill %1   # job 종료
```

job control이 자경단의 매일 — `npm run dev &`로 dev 서버 띄우고 셸에서 다른 일.

깊이. job control은 process group + session 기반. 같은 group의 프로세스에 signal 한 번에 전달.

```bash
ps -j     # process group 정보
```

---

## 8. 환경변수 상속

부모의 환경변수가 자식에게 자동 복사. 그러나 자식의 변경은 부모에 안 돌아옴.

```bash
# 부모 셸
export NAME="자경단"

# 자식 (새 bash)
bash
echo $NAME    # 자경단 (상속받음)
NAME="다른"   # 자식의 변경
exit

# 부모로 돌아옴
echo $NAME    # 자경단 (그대로)
```

이게 자경단 dotfile의 동작 원리. ~/.zshrc에 export하면 모든 자식 프로세스가 받음.

---

## 9. pipe와 redirection 내부

`cmd1 | cmd2`가 내부에서.

1. 셸이 pipe() syscall 호출. 두 fd (read, write).
2. 셸이 fork. 자식 1 (cmd1).
3. 자식 1의 stdout을 pipe write fd로 dup2.
4. 자식 1이 exec("cmd1").
5. 셸이 또 fork. 자식 2 (cmd2).
6. 자식 2의 stdin을 pipe read fd로 dup2.
7. 자식 2가 exec("cmd2").
8. 두 자식이 동시 실행. cmd1의 출력이 pipe로 cmd2의 입력에.

같은 원리로 redirection.

```bash
ls > out.txt
```

1. 셸이 open("out.txt", O_WRONLY).
2. 셸이 fork.
3. 자식의 stdout을 그 fd로 dup2.
4. 자식이 exec("ls").
5. ls의 출력이 out.txt로.

자경단 매일 만지는 한 줄의 내부.

---

## 10. 자경단 매일의 0.3초 안

본인이 `ls -l | grep .py | wc -l` 한 줄 실행.

```
0.000s  키보드 입력
0.001s  터미널이 셸에 전달
0.002s  셸이 파싱: ls, grep, wc
0.003s  pipe() x 2
0.005s  fork x 3 (자식 셋)
0.007s  exec x 3 (각자 변신)
0.020s  ls가 디렉토리 읽기 시작
0.050s  ls의 출력이 grep으로 흐르기 시작
0.080s  grep 결과가 wc로
0.100s  wc가 줄 수 출력
0.150s  세 자식 다 종료
0.160s  셸이 wait로 받음
0.200s  prompt 표시
```

15개 단계. 0.2초. 자경단 매일 1,000번. 0.2초 × 1000 = 200초. 매일 본인의 손가락이 200초의 fork+exec.

---

## 11. 흔한 오해 다섯 가지

**오해 1: fork가 비싸다.**

copy-on-write로 빠름.

**오해 2: kill -9 표준.**

SIGTERM 먼저, SIGKILL은 마지막.

**오해 3: zombie 자동 정리.**

부모가 wait해야.

**오해 4: pipe는 파일.**

메모리. fd만 파일 같음.

**오해 5: 환경변수 양방향.**

자식 → 부모는 안 됨.

---

## 12. 흔한 실수 다섯 가지 + 안심 멘트 — Bash 깊이 학습 편

Bash 깊이 학습하며 자주 빠지는 함정 다섯.

첫 번째 함정, syscall 깊이까지 한 번에. 안심하세요. **fork·exec·pipe 셋만.** 나머지는 두 해 후 OS 챕터에서.

두 번째 함정, subshell vs 부모 셸 헷갈림. 안심하세요. **`(...)` = subshell, `{...;}` = 부모 셸.** 변수 영향 범위 다름.

세 번째 함정, here-document 헷갈림. 안심하세요. **`<<EOF` = 변수 치환, `<<'EOF'` = 그대로.** 따옴표 한 글자 차이.

네 번째 함정, IFS 무지성 변경. 본인이 IFS 바꾸고 안 복원. 안심하세요. **로컬 IFS는 함수 안에서만.** `local IFS=...`.

다섯 번째 함정, 가장 큰 함정. **POSIX vs Bashism 헷갈림.** 본인 .sh가 sh에서 안 동작. 안심하세요. **`#!/usr/bin/env bash` 명시 또는 POSIX 한정.** 셔뱅이 약속.

다섯 함정 미리 알아둔 본인이 두 해 동안 한 박자 빠르게 손이 움직여요.

## 13. 마무리 — 다음 H8에서 만나요

자, 일곱 번째 시간이 끝났어요.

fork, exec, wait, signal, job control, 환경변수 상속, pipe/redirection 내부, 0.3초의 진짜 단계.

박수.

다음 H8은 적용 + 회고. 검은 화면이 평생 친구가 되기까지.

```bash
strace -f -e trace=fork,execve ls 2>&1 | head -20
```

---

## 👨‍💻 개발자 노트

> - fork() copy-on-write: 페이지 테이블 공유, 변경 시 분리.
> - vfork(): 자식이 exec 또는 exit 보장 시. 빠름.
> - exec family: execl, execv, execle, execve. envp 전달 차이.
> - signal handler: SA_RESTART 플래그.
> - process group leader: setpgid.
> - 다음 H8 키워드: 검은 화면 평생 친구 · dotfile · 5년 자산.
