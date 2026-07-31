#!/bin/sh
set -e

REPO_URL="https://miaomiaowu-openwrt.445568.xyz"

echo "=== 妙妙屋 (miaomiaowu) 一键安装 ==="

TMP_FEED=$(mktemp)
trap 'rm -f "$TMP_FEED"' EXIT
wget -q -O "$TMP_FEED" "$REPO_URL/feed.sh"

MMW_SOURCED=1
export MMW_SOURCED
. "$TMP_FEED"
mmw_setup_feed

if command -v opkg >/dev/null 2>&1; then
    opkg install miaomiaowu luci-app-miaomiaowu
elif command -v apk >/dev/null 2>&1; then
    apk add miaomiaowu luci-app-miaomiaowu
else
    echo "错误: 未检测到 opkg 或 apk" >&2
    exit 1
fi

echo "=== 安装完成 ==="
