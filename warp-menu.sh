#!/bin/bash
# warp-menu.sh – by Riswan481 (modified/fixed by ChatGPT)

# =============== Warna & Garis ===============
NC='\033[0m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;34m'
LINE="========================================"

# =============== Fungsi Install ===============
function install_warp_go() {
  echo -e "${YELLOW}📥 Mengunduh warp-go...${NC}"
  
  # Hapus jika ada sisa sebelumnya
  rm -f warp-go-linux-amd64.gz warp-go

  # Unduh dari rilis resmi ViRb3
  wget -O warp-go-linux-amd64.gz https://github.com/ViRb3/warp-go/releases/latest/download/warp-go-linux-amd64.gz
  
  if file warp-go-linux-amd64.gz | grep -q "gzip compressed"; then
    gunzip warp-go-linux-amd64.gz
    chmod +x warp-go-linux-amd64
    mv warp-go-linux-amd64 /usr/bin/warp-go
    echo -e "${GREEN}✅ warp-go berhasil diinstall ke /usr/bin/warp-go${NC}"
  else
    echo -e "${RED}❌ File yang diunduh bukan file gzip valid!${NC}"
    exit 1
  fi
}

function cek_warp_go() {
  if [[ ! -f /usr/bin/warp-go ]] || ! /usr/bin/warp-go --version &>/dev/null; then
    echo -e "${YELLOW}⚠️ warp-go rusak atau belum diinstall${NC}"
    install_warp_go
  fi
}

function aktifkan_warp() {
  echo -e "${YELLOW}🚀 Mengaktifkan WARP...${NC}"
  /usr/bin/warp-go --accept-tos --register --connect
  if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ WARP berhasil diaktifkan!${NC}"
  else
    echo -e "${RED}❌ Gagal mengaktifkan WARP${NC}"
  fi
}

function nonaktifkan_warp() {
  echo -e "${YELLOW}🛑 Menonaktifkan WARP...${NC}"
  pkill warp-go && echo -e "${GREEN}✅ WARP dinonaktifkan${NC}" || echo -e "${RED}❌ Gagal menonaktifkan WARP${NC}"
}

function cek_status_warp() {
  echo -e "${YELLOW}📈 Mengecek status WARP...${NC}"
  if pgrep warp-go >/dev/null; then
    echo -e "${GREEN}✅ WARP sedang AKTIF${NC}"
  else
    echo -e "${RED}❌ WARP sedang NONAKTIF${NC}"
  fi
}

# =============== MENU ===============
cek_warp_go
while true; do
  echo -e "$LINE"
  echo -e "${BLUE}     🔧 WARP MENU – Riswan481${NC}"
  echo -e "$LINE"
  echo -e "1. 🔓 Aktifkan WARP"
  echo -e "2. 🔒 Nonaktifkan WARP"
  echo -e "3. 📈 Cek Status WARP"
  echo -e "0. ❌  Keluar"
  echo -n "Pilih opsi: "; read opsi

  case $opsi in
    1) aktifkan_warp ;;
    2) nonaktifkan_warp ;;
    3) cek_status_warp ;;
    0) echo -e "${YELLOW}👋 Keluar...${NC}"; exit ;;
    *) echo -e "${RED}❌ Opsi tidak valid!${NC}" ;;
  esac
done