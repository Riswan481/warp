#!/bin/bash
# warp-menu.sh by Riswan481 – versi auto start & menu langsung

# =============== Warna & Garis ===============
NC='\033[0m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;34m'
LINE="========================================"

# =============== Path & File ===============
WARP_GO="/usr/bin/warp-go"
CONF_FILE="warp.conf"

# =============== Fungsi Cek WARP ===============
function cek_status_warp() {
    if [[ -f "$CONF_FILE" ]]; then
        curl -s https://www.cloudflare.com/cdn-cgi/trace | grep -q "warp=on"
        [[ $? -eq 0 ]] && echo "on" || echo "off"
    else
        echo "off"
    fi
}

# =============== Install WARP-Go ===============
function install_warp_go() {
    echo -e "${YELLOW}📥 Mengunduh warp-go...${NC}"
    arch=$(uname -m)
    if [[ $arch == "x86_64" ]]; then
        FILE_NAME="warp-go-linux-amd64"
    elif [[ $arch == "aarch64" ]]; then
        FILE_NAME="warp-go-linux-arm64"
    else
        echo -e "${RED}❌ Arsitektur tidak didukung: $arch${NC}"
        exit 1
    fi

    wget -qO warp-go.gz "https://github.com/ViRb3/warp-go/releases/latest/download/${FILE_NAME}.gz"
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}❌ Gagal mengunduh warp-go. Periksa koneksi atau URL.${NC}"
        exit 1
    fi

    gunzip warp-go.gz
    mv warp-go /usr/bin/warp-go
    chmod +x /usr/bin/warp-go
    echo -e "${GREEN}✅ warp-go berhasil diinstal!${NC}"
}

# =============== Aktifkan WARP ===============
function aktifkan_warp() {
    echo -e "${YELLOW}🚀 Mengaktifkan WARP...${NC}"
    nohup $WARP_GO > /dev/null 2>&1 &
    sleep 3
    echo -e "${GREEN}✅ WARP aktif!${NC}"
}

# =============== Reset Konfigurasi ===============
function reset_konfigurasi() {
    echo -e "${YELLOW}⚠️ Mereset konfigurasi...${NC}"
    rm -f "$CONF_FILE"
    $WARP_GO -register
    echo -e "${GREEN}✅ Konfigurasi baru dibuat${NC}"
}

# =============== Pasang Lisensi ===============
function pasang_lisensi() {
    read -rp "🔑 Masukkan lisensi WARP+: " LICENSE
    if [[ ! -f "$CONF_FILE" ]]; then
        echo -e "${RED}❌ warp.conf belum ada. Jalankan reset dulu!${NC}"
        return
    fi
    $WARP_GO -license "$LICENSE"
    echo -e "${GREEN}✅ Lisensi berhasil dipasang${NC}"
}

# =============== Export WireGuard ===============
function export_wireguard() {
    $WARP_GO -export-wireguard warp.conf > wgcf.conf
    echo -e "${GREEN}✅ Konfigurasi WireGuard disimpan di wgcf.conf${NC}"
}

# =============== Tampilkan Menu ===============
function tampilkan_menu() {
    clear
    echo -e "${BLUE}$LINE"
    echo -e "      🌐 WARP-Go Menu (by Riswan481)"
    echo -e "$LINE${NC}"
    echo "1. Aktifkan WARP"
    echo "2. Reset Konfigurasi"
    echo "3. Cek Status WARP"
    echo "4. Pasang Lisensi WARP+"
    echo "5. Export WireGuard Config"
    echo "0. Keluar"
    echo -e "$LINE"
    read -rp "Pilih opsi: " opsi

    case $opsi in
        1) aktifkan_warp ;;
        2) reset_konfigurasi ;;
        3)
            status=$(cek_status_warp)
            echo -e "📡 Status WARP: warp=$status"
            ;;
        4) pasang_lisensi ;;
        5) export_wireguard ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Pilihan tidak valid!${NC}" ;;
    esac

    echo ""
    read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu..."
    tampilkan_menu
}

# =============== Eksekusi Awal ===============
if [[ ! -f "$WARP_GO" ]]; then
    echo -e "${YELLOW}⚠️ warp-go rusak atau belum diinstall${NC}"
    install_warp_go
fi

status=$(cek_status_warp)
if [[ "$status" != "on" ]]; then
    aktifkan_warp
fi

tampilkan_menu