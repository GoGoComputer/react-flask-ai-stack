#!/usr/bin/env bash
# sysinfo.sh — 내 맥의 자기소개서 한 장 출력
# TODO: H5에서 같이 채웁니다. 다섯 단계로 진행하세요.
#
# 1단계: 헤더와 OS 정보 (sw_vers)
# 2단계: CPU 정보 (uname -m, sysctl machdep.cpu.brand_string, hw.ncpu)
# 3단계: RAM과 디스크 (sysctl hw.memsize, df -h /)
# 4단계: 네트워크와 가동 시간 (ipconfig getifaddr en0, uptime)
# 5단계: 색깔 입히기 (ANSI 코드)

set -e   # 명령 하나라도 실패하면 멈춰요

echo "TODO: 여기에 시스템 정보를 출력하세요"
echo "참고: chapters/001-cs-computer-architecture/finish/sysinfo.sh"
