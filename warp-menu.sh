#!/bin/bash
# warp-menu.sh – by Riswan481

# =============== Warna & Garis ===============
NC='\033[0m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
LINE="========================================"

# =============== Fungsi Install ===============
function install_warp_go() {
  echo -e "${YELLOW}📥 Mengunduh warp-go...${NC}"
  ARCH=$(uname -m)
  case $ARCH in
    x86_64) FILE="warp-go_amd64" ;;
    aarch64) FILE="warp-go_arm64" ;;
    *) echo -e "${RED}❌ Arsitektur tidak didukung: $ARCH${NC}"; exit 1 ;;
  esac
  curl -fsSL -A "Mozilla/5.0" -o /usr/bin/warp-go \
    "https://github.com/fscarmen/warp/releases/latest/download/${FILE}" || {
      echo -e "${RED}❌ Gagal mengunduh warp-go${NC}"
      exit 1
  }
  chmod +x /usr/bin/warp-go
  echo -e "${GREEN}✅ warp-go berhasil diinstall ke /usr/bin/warp-go${NC}"
}

# =============== Fungsi Warp ===============
function start_warp() {
  echo -e "${YELLOW}🚀 Mengaktifkan WARP...${NC}"
  warp-go --platform linux --register && \
  warp-go --generate && \
  warp-go --up && \
  echo -e "${GREEN}✅ WARP aktif!${NC}" || \
  echo -e "${RED}❌ Gagal mengaktifkan WARP${NC}"
  sleep 2
}

function stop_warp() {
  echo -e "${YELLOW}🛑 Menonaktifkan WARP...${NC}"
  warp-go --remove && echo -e "${GREEN}✅ WARP dinonaktifkan${NC}" || echo -e "${RED}❌ Gagal menonaktifkan WARP${NC}"
  sleep 2
}

function status_warp() {
  echo -e "${YELLOW}📊 Status WARP...${NC}"
  warp-go --status || echo -e "${RED}❌ warp-go tidak aktif atau belum diinstall${NC}"
  sleep 2
}

# =============== Cek warp-go valid ===============
if [[ ! -x /usr/bin/warp-go ]] || file /usr/bin/warp-go | grep -q HTML; then
  echo -e "${RED}⚠️ warp-go rusak atau belum diinstall${NC}"
  install_warp_go
fi

# =============== Menu ===============
while true; do
  echo -e "\n$LINE"
  echo -e "${GREEN}     🔧 WARP MENU – Riswan481${NC}"
  echo -e "$LINE"
  echo -e "1. 🔓 Aktifkan WARP"
  echo -e "2. 🔒 Nonaktifkan WARP"
  echo -e "3. 📈 Cek Status WARP"
  echo -e "0. ❌ Keluar"
  echo -ne "\nPilih opsi: "; read opt
  case $opt in
    1) start_warp ;;
    2) stop_warp ;;
    3) status_warp ;;
    0) echo -e "${YELLOW}Keluar...${NC}"; exit ;;
    *) echo -e "${RED}❌ Opsi tidak valid${NC}"; sleep 1 ;;
  esac
done
