#!/bin/sh
set -e

REPO_URL="https://miaomiaowu-openwrt.445568.xyz"

mmw_setup_feed() {

echo "=== 妙妙屋 (miaomiaowu) 添加软件源 ==="

if command -v opkg >/dev/null 2>&1; then
    echo "检测到 opkg（OpenWrt 23.05 及更早版本）"
    ARCH=$(opkg print-architecture | awk '$1=="arch" && $2!="all" && $2!="noarch" {print $3, $2}' | sort -n -r | head -n1 | awk '{print $2}')
    [ -z "$ARCH" ] && { echo "错误: 无法识别本机架构" >&2; exit 1; }
    echo "识别到架构: $ARCH"

    FEED_LINE="src/gz miaomiaowu $REPO_URL/openwrt-24.10/$ARCH"

    wget -q -O /tmp/mmw-ipk.pub "$REPO_URL/miaomiaowu-ipk.pub"
    opkg-key add /tmp/mmw-ipk.pub
    rm -f /tmp/mmw-ipk.pub

    mkdir -p /etc/opkg
    touch /etc/opkg/customfeeds.conf
    sed -i '/^src\/gz miaomiaowu /d' /etc/opkg/customfeeds.conf
    echo "$FEED_LINE" >> /etc/opkg/customfeeds.conf

    opkg update || true

    echo "=== 软件源添加完成 ==="
    echo "现在可以执行: opkg install miaomiaowu luci-app-miaomiaowu"
    echo "也可以在 LuCI 的软件包菜单里搜 miaomiaowu 安装"

elif command -v apk >/dev/null 2>&1; then
    echo "检测到 apk（OpenWrt 25.12 及更新版本）"

    CANDIDATES=$( (cat /etc/apk/arch 2>/dev/null; apk --print-arch 2>/dev/null) \
        | tr ' ' '\n' | awk 'NF && !seen[$0]++ && $0!="all" && $0!="noarch"' )
    [ -z "$CANDIDATES" ] && { echo "错误: 无法识别本机架构（/etc/apk/arch 为空）" >&2; exit 1; }

    ARCH=""
    for CAND in $CANDIDATES; do
        echo "尝试架构: $CAND ..."
        if wget -q -O /tmp/mmw-test.adb "$REPO_URL/openwrt-25.12/$CAND/packages.adb" && [ -s /tmp/mmw-test.adb ]; then
            ARCH="$CAND"
            rm -f /tmp/mmw-test.adb
            break
        fi
        rm -f /tmp/mmw-test.adb
    done

    if [ -z "$ARCH" ]; then
        echo "错误: 软件源里没有找到匹配的架构目录，已尝试: $CANDIDATES" >&2
        echo "请执行 'cat /etc/apk/arch' 确认本机架构，如果显示的是笼统名字（如 aarch64/x86_64）" >&2
        echo "而不是具体型号（如 aarch64_cortex-a53），这是 OpenWrt 官方已知问题，" >&2
        echo "可以手动把正确的具体架构名写进 /etc/apk/arch 后重试。" >&2
        exit 1
    fi
    echo "识别到架构: $ARCH"

    mkdir -p /etc/apk/keys
    wget -q -O /etc/apk/keys/miaomiaowu-apk.pem "$REPO_URL/miaomiaowu-apk.pem"

    mkdir -p /etc/apk/repositories.d
    echo "$REPO_URL/openwrt-25.12/$ARCH/packages.adb" > /etc/apk/repositories.d/miaomiaowu.list

    apk update || true

    echo "=== 软件源添加完成 ==="
    echo "现在可以执行: apk add miaomiaowu luci-app-miaomiaowu"
    echo "也可以在 LuCI 的软件包菜单里搜 miaomiaowu 安装"

else
    echo "错误: 未检测到 opkg 或 apk" >&2
    exit 1
fi

}

if [ "${MMW_SOURCED:-0}" != "1" ]; then
    mmw_setup_feed
fi
