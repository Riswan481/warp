#!/bin/bash

# =============== Warna ===============
NC='\033[0m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;34m'
LINE="========================================"

# =============== Lokasi Binary ===============
WARP_GO="/usr/bin/warp-go"

# =============== Fungsi ===============
install_warp_go() {
  echo -e "${YELLOW}📥 Mengunduh warp-go...${NC}"
  mkdir -p /usr/bin/
  wget -qO /usr/bin/warp-go https://raw.githubusercontent.com/Riswan481/bin/main/warp-go
  chmod +x /usr/bin/warp-go
  echo -e "${GREEN}✅ warp-go berhasil diinstal!${NC}"
}

register_warp() {
  if [[ -f "$WARP_GO" ]]; then
    $WARP_GO -register
    echo -e "${GREEN}✅ Pendaftaran WARP selesai!${NC}"
  else
    echo -e "${RED}❌ warp-go belum terinstal!${NC}"
  fi
}

start_warp() {
  if [[ -f "$WARP_GO" ]]; then
    $WARP_GO -start
    echo -e "${GREEN}✅ WARP telah diaktifkan!${NC}"
  else
    echo -e "${RED}❌ warp-go belum terinstal!${NC}"
  fi
}

stop_warp() {
  if [[ -f "$WARP_GO" ]]; then
    $WARP_GO -stop
    echo -e "${YELLOW}🛑 WARP telah dihentikan!${NC}"
  else
    echo -e "${RED}❌ warp-go belum terinstal!${NC}"
  fi
}

status_warp() {
  if [[ -f "$WARP_GO" ]]; then
    echo -e "${BLUE}📊 Mengecek Status WARP...${NC}"
    STATUS_OUTPUT="$($WARP_GO -status)"
    echo "$STATUS_OUTPUT"

    if echo "$STATUS_OUTPUT" | grep -q "Status: off"; then
      echo -e "${YELLOW}⚠️ WARP sedang OFF. Aktifkan sekarang? (y/n)${NC}"
      read -rp "Jawaban: " jawab
      if [[ "$jawab" == "y" || "$jawab" == "Y" ]]; then
        $WARP_GO -start
        echo -e "${GREEN}✅ WARP telah diaktifkan!${NC}"
      else
        echo -e "${RED}❌ WARP tetap nonaktif.${NC}"
      fi
    fi
  else
    echo -e "${RED}❌ warp-go belum terinstal!${NC}"
  fi
}

export_config() {
  if [[ -f "$WARP_GO" ]]; then
    echo -e "${BLUE}📤 Config WARP:${NC}"
    cat /root/warp.conf
  else
    echo -e "${RED}❌ warp-go belum terinstal!${NC}"
  fi
}

hapus_warp_go() {
  rm -f /usr/bin/warp-go /root/warp.conf
  echo -e "${YELLOW}🗑️ warp-go dan config berhasil dihapus.${NC}"
}

# =============== Menu ===============
while true; do
  clear
  echo -e "${GREEN}$LINE"
  echo -e "            🌐 MENU WARP GO"
  echo -e "$LINE${NC}"
  echo -e "1. Install warp-go"
  echo -e "2. Daftar warp-go"
  echo -e "3. Aktifkan WARP"
  echo -e "4. Nonaktifkan WARP"
  echo -e "5. Cek Status WARP"
  echo -e "6. Export Config"
  echo -e "7. Hapus warp-go"
  echo -e "0. Keluar"
  echo -e "$LINE"
  read -rp "👉 Pilih menu: " opt

  case $opt in
    1) install_warp_go ;;
    2) register_warp ;;
    3) start_warp ;;
    4) stop_warp ;;
    5) status_warp ;;
    6) export_config ;;
    7) hapus_warp_go ;;
    0) break ;;
    *) echo -e "${RED}❌ Pilihan tidak valid!${NC}"; sleep 1 ;;
  esac
  read -rp "Tekan Enter untuk kembali ke menu..."
done