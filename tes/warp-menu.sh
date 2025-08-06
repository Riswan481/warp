#!/bin/bash

# =============== Warna ===============
NC='\033[0m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
LINE="===================================="

# ============ Fungsi =============

function install_warp_go() {
    echo -e "${YELLOW}📥 Mengunduh warp-go...${NC}"
    ARCH=$(uname -m)
    case $ARCH in
        x86_64) FILE="warp-go_amd64" ;;
        aarch64) FILE="warp-go_arm64" ;;
        *) echo -e "${RED}❌ Arsitektur tidak didukung: $ARCH${NC}"; exit 1 ;;
    esac

    curl -L -A "Mozilla/5.0" -o /usr/bin/warp-go "https://github.com/fscarmen/warp/releases/latest/download/${FILE}" || {
        echo -e "${RED}❌ Gagal mengunduh warp-go.${NC}"
        exit 1
    }

    chmod +x /usr/bin/warp-go
    echo -e "${GREEN}✅ warp-go terpasang di /usr/bin/warp-go${NC}"
}

function start_warp() {
    warp-go --mode proxy
    echo -e "${GREEN}🚀 WARP sudah aktif dengan mode proxy${NC}"
}

function stop_warp() {
    warp-go --disconnect
    echo -e "${YELLOW}⛔️ WARP dinonaktifkan${NC}"
}

function status_warp() {
    echo -e "${YELLOW}📊 Status WARP...${NC}"
    warp-go --status || echo -e "${RED}❌ WARP belum terpasang atau tidak aktif.${NC}"
}

# ============ Cek & Pasang warp-go =============
if [[ ! -f /usr/bin/warp-go ]] || [[ $(file /usr/bin/warp-go) == *"HTML document"* ]]; then
    install_warp_go
fi

# ============ Menu =============
while true; do
    clear
    echo -e "$LINE"
    echo -e "${GREEN}           MENU WARP-GO${NC}"
    echo -e "$LINE"
    echo -e "1. Aktifkan WARP (mode proxy)"
    echo -e "2. Nonaktifkan WARP"
    echo -e "3. Cek Status WARP"
    echo -e "0. Keluar"
    echo -e "$LINE"
    read -p "Pilih opsi: " OPT
    case $OPT in
        1) start_warp ;;
        2) stop_warp ;;
        3) status_warp ;;
        0) exit ;;
        *) echo -e "${RED}❌ Pilihan tidak valid!${NC}"; sleep 1 ;;
    esac
done