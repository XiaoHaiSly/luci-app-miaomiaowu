#!/bin/sh
set -e

echo "=== 妙妙屋 (miaomiaowu) 卸载 ==="

DATA_DIR="/etc/mmw"
if command -v uci >/dev/null 2>&1; then
    DB_PATH=$(uci -q get miaomiaowu.miaomiaowu.database_path 2>/dev/null || true)
    [ -n "$DB_PATH" ] && DATA_DIR=$(dirname "$DB_PATH")
fi

if command -v opkg >/dev/null 2>&1; then
    echo "检测到 opkg（OpenWrt 24.05 及更早版本）"
    opkg remove luci-app-miaomiaowu 2>/dev/null || true
    opkg remove miaomiaowu 2>/dev/null || true

elif command -v apk >/dev/null 2>&1; then
    echo "检测到 apk（OpenWrt 25.12 及更新版本）"
    apk del luci-app-miaomiaowu 2>/dev/null || true
    apk del miaomiaowu 2>/dev/null || true

else
    echo "错误: 未检测到 opkg 或 apk" >&2
    exit 1
fi

echo "删除数据目录 $DATA_DIR"
rm -rf "$DATA_DIR"

echo "=== 卸载完成 ==="
