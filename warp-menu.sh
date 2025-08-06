#!/bin/bash
# warp-menu.sh – by Riswan481 (fix & update by ChatGPT)

# =============== Warna & Garis ===============
NC='\033[0m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;34m'
LINE="========================================"

# =============== Cek & Install warp-go ===============
function check_warp_go() {
  if [[ ! -f /usr/bin/warp-go ]]; then
    echo -e "${RED}⚠️ warp-go rusak atau belum diinstall${NC}"
    echo -e "${YELLOW}📥 Mengunduh warp-go...${NC}"
    wget -O warp-go.tar.gz "https://github.com/Riswan481/warp/releases/download/1.0.8/warp-go_1.0.8_linux_amd64.tar.gz"
    if [[ $? -ne 0 ]]; then
      echo -e "${RED}❌ Gagal mengunduh file warp-go!${NC}"
      exit 1
    fi
    tar -xzf warp-go.tar.gz
    mv warp-go /usr/bin/warp-go
    chmod +x /usr/bin/warp-go
    rm -f warp-go.tar.gz
    echo -e "${GREEN}✅ warp-go berhasil diinstall ke /usr/bin/warp-go${NC}"
  fi
}

# =============== Menu ===============
function show_menu() {
  clear
  echo -e "$LINE"
  echo -e "     🔧 ${BLUE}WARP MENU – Riswan481${NC}"
  echo -e "$LINE"
  echo -e "1. 🔓 Aktifkan WARP"
  echo -e "2. 🔒 Nonaktifkan WARP"
  echo -e "3. 📈 Cek Status WARP"
  echo -e "4. 📜 Pasang Lisensi WARP+"
  echo -e "5. 📋 Lihat Device Info"
  echo -e "6. 📤 Export WireGuard Config"
  echo -e "7. ❌ Reset Konfigurasi"
  echo -e "0. ❎ Keluar"
  echo -ne "\nPilih opsi: "
  read -r opsi

  case $opsi in
    1)
      echo -e "${YELLOW}🚀 Mengaktifkan WARP...${NC}"
      nohup warp-go -config warp.conf > /dev/null 2>&1 &
      sleep 1
      echo -e "${GREEN}✅ WARP aktif!${NC}"
      ;;
    2)
      echo -e "${YELLOW}🛑 Menonaktifkan WARP...${NC}"
      pkill -f warp-go
      echo -e "${GREEN}✅ WARP dinonaktifkan${NC}"
      ;;
    3)
      echo -e "${BLUE}📡 Status WARP:${NC}"
      curl -s https://www.cloudflare.com/cdn-cgi/trace | grep warp
      ;;
    4)
      echo -ne "${YELLOW}🔑 Masukkan lisensi WARP+: ${NC}"
      read -r LICENSE
      warp-go -license "$LICENSE" -update
      echo -e "${GREEN}✅ Lisensi berhasil dipasang${NC}"
      ;;
    5)
      echo -e "${BLUE}📋 Device Info:${NC}"
      warp-go -update
      ;;
    6)
      echo -e "${YELLOW}📤 Mengekspor konfigurasi WireGuard...${NC}"
      warp-go -export-wireguard warp.conf
      echo -e "${GREEN}✅ Berhasil diexport ke warp.conf${NC}"
      ;;
    7)
      echo -e "${RED}⚠️ Mereset konfigurasi...${NC}"
      pkill -f warp-go
      rm -f warp.conf
      warp-go -register
      echo -e "${GREEN}✅ Konfigurasi baru dibuat${NC}"
      ;;
    0)
      exit 0
      ;;
    *)
      echo -e "${RED}❌ Opsi tidak valid!${NC}"
      ;;
  esac

  echo ""
  read -n 1 -s -r -p "Tekan tombol apapun untuk kembali ke menu..."
  show_menu
}

# =============== Eksekusi ===============
check_warp_go
show_menu