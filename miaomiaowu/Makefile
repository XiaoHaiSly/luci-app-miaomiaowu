include $(TOPDIR)/rules.mk

PKG_NAME:=miaomiaowu

PKG_VERSION:=$(strip $(shell wget -qO- "https://miaomiaowu-openwrt.pages.dev/openwrt-24.10/$(ARCH_PACKAGES)/Packages" 2>/dev/null | \
	awk '/^Package: miaomiaowu$$/{f=1;next} f&&/^Version:/{print $$2;exit} /^$$/{f=0}'))
ifeq ($(PKG_VERSION),)
  PKG_VERSION:=0.0.0-VERSION-FETCH-FAILED
endif
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://miaomiaowu-openwrt.445568.xyz/openwrt-24.10/$(ARCH_PACKAGES)
PKG_SOURCE:=$(PKG_NAME)_$(PKG_VERSION)_$(ARCH_PACKAGES).ipk
PKG_SOURCE_PROTO:=default
PKG_HASH:=skip

PKG_MAINTAINER:=第十六夜月
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/miaomiaowu
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Clash 配置订阅管理工具 (妙妙屋后端)
  DEPENDS:=+libc
endef

define Package/miaomiaowu/description
  miaomiaowu 后端服务，配合 luci-app-miaomiaowu 使用
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
ifeq ($(PKG_VERSION),0.0.0-VERSION-FETCH-FAILED)
	@echo "错误: 没能从 https://miaomiaowu-openwrt.445568.xyz/openwrt-24.10/$(ARCH_PACKAGES)/Packages 取到版本号" >&2
	@echo "      请检查该 URL 是否能访问，以及 Packages 里是不是真有 miaomiaowu 这个条目" >&2
	@exit 1
endif
	@if ! gzip -t "$(DL_DIR)/$(PKG_SOURCE)" 2>/dev/null; then \
		echo "错误: $(DL_DIR)/$(PKG_SOURCE) 不是合法的 ipk(不是 gzip 格式)" >&2; \
		echo "      前 200 字节内容如下，很可能下载到的是 404 页面:" >&2; \
		head -c 200 "$(DL_DIR)/$(PKG_SOURCE)" >&2; echo >&2; \
		exit 1; \
	fi
	tar -xzf $(DL_DIR)/$(PKG_SOURCE) -O ./data.tar.gz | tar -xzC $(PKG_BUILD_DIR)
endef

define Build/Compile
endef

define Package/miaomiaowu/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/mmw $(1)/usr/bin/mmw

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/miaomiaowu.init $(1)/etc/init.d/miaomiaowu

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/miaomiaowu.config $(1)/etc/config/miaomiaowu
endef

$(eval $(call BuildPackage,miaomiaowu))
