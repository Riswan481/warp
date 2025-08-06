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

  URL="https://github.com/fscarmen/warp/releases/latest/download/${FILE}"
  curl -L --retry 5 --retry-connrefused -A "Mozilla/5.0" -o /usr/bin/warp-go "$URL"
  if ! file /usr/bin/warp-go | grep -q ELF; then
    echo -e "${RED}❌ Download gagal, file bukan binary${NC}"
    rm -f /usr/bin/warp-go
    exit 1
  fi

  chmod +x /usr/bin/warp-go
  echo -e "${GREEN}✅ warp‑go sudah terpasang di /usr/bin/warp‑go${NC}"
}

# =============== Fungsi WARP ===============
function start_warp() {
  echo -e "${YELLOW}🚀 Mengaktifkan WARP…${NC}"
  /usr/bin/warp-go --platform linux --register && \
  /usr/bin/warp-go --generate && \
  /usr/bin/warp-go --up && \
  echo -e "${GREEN}✅ WARP aktif!${NC}" || \
  echo -e "${RED}❌ Gagal aktifkan WARP${NC}"
  sleep 2
}

function stop_warp() {
  echo -e "${YELLOW}🛑 Menonaktifkan WARP…${NC}"
  /usr/bin/warp-go --remove && echo -e "${GREEN}✅ WARP dinonaktifkan${NC}" || echo -e "${RED}❌ Gagal nonaktifkan WARP${NC}"
  sleep 2
}

function status_warp() {
  echo -e "${YELLOW}📊 Status WARP…${NC}"
  /usr/bin/warp-go --status || echo -e "${RED}❌ warp‑go belum aktif atau belum terpasang${NC}"
  sleep 2
}

# Check apakah warp-go valid
if [[ ! -x /usr/bin/warp-go ]] || file /usr/bin/warp-go | grep -q HTML; then
  echo -e "${RED}⚠️ warp-go rusak atau belum terinstall${NC}"
  install_warp_go
fi

# =============== Menu Utama ===============
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
