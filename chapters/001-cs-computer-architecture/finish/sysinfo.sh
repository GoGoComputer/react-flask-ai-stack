#!/usr/bin/env bash
# sysinfo.sh — 내 맥의 자기소개서 한 장 출력 (완성본)
#
# 사용법:  bash sysinfo.sh
# 권한 부여:  chmod +x sysinfo.sh && ./sysinfo.sh
#
# 대상: macOS (Apple Silicon / Intel 둘 다 지원)
# 리눅스 사용자는 Ch 006에서 크로스플랫폼 버전을 만듭니다.

set -e

# ── 색상 코드 ───────────────────────────────────────────────
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

LINE="================================================================"

# ── 1) OS ───────────────────────────────────────────────────
OS_NAME=$(sw_vers -productName)
OS_VERSION=$(sw_vers -productVersion)
OS_BUILD=$(sw_vers -buildVersion)

# ── 2) CPU ──────────────────────────────────────────────────
ARCH=$(uname -m)
CPU_BRAND=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown")
CORES_PHYS=$(sysctl -n hw.physicalcpu)
CORES_LOG=$(sysctl -n hw.logicalcpu)

# ── 3) RAM & Disk ───────────────────────────────────────────
RAM_BYTES=$(sysctl -n hw.memsize)
RAM_GB=$((RAM_BYTES / 1024 / 1024 / 1024))

DISK_INFO=$(df -h / | tail -1)
DISK_TOTAL=$(echo "$DISK_INFO" | awk '{print $2}')
DISK_USED=$(echo "$DISK_INFO" | awk '{print $3}')
DISK_PCT=$(echo "$DISK_INFO" | awk '{print $5}')

# ── 4) Network & Uptime ─────────────────────────────────────
IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "N/A")
UPTIME_INFO=$(uptime | sed 's/^ *//')

# ── 5) Print ────────────────────────────────────────────────
echo -e "${GREEN}${BOLD}${LINE}${RESET}"
echo -e "${BOLD}  ✨ My Mac — System Information ✨${RESET}"
echo -e "${GREEN}${BOLD}${LINE}${RESET}"
printf "${CYAN}%-12s${RESET}%s\n" "[OS]"      "${OS_NAME} ${OS_VERSION} (Build ${OS_BUILD})"
printf "${CYAN}%-12s${RESET}%s\n" "[Arch]"    "${ARCH}"
printf "${CYAN}%-12s${RESET}%s\n" "[CPU]"     "${CPU_BRAND}"
printf "${CYAN}%-12s${RESET}%s\n" "[Cores]"   "${CORES_LOG} (Physical: ${CORES_PHYS}, Logical: ${CORES_LOG})"
printf "${CYAN}%-12s${RESET}%s\n" "[RAM]"     "${RAM_GB} GB"
printf "${CYAN}%-12s${RESET}%s\n" "[Disk]"    "${DISK_USED} used / ${DISK_TOTAL} total (${DISK_PCT})"
printf "${CYAN}%-12s${RESET}%s\n" "[IP]"      "${IP_ADDR}"
printf "${CYAN}%-12s${RESET}%s\n" "[Uptime]"  "${UPTIME_INFO}"
echo -e "${GREEN}${BOLD}${LINE}${RESET}"
