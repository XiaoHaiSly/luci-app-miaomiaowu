# SPDX-License-Identifier: MIT

include $(TOPDIR)/rules.mk

PKG_NAME:=miaomiaowu
PKG_VERSION:=0.8.7
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/iluobei/miaomiaowu/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=8b969a95da5766b64351d0a63b85c4447c52a6aeb11140a586fb475713e40d68
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=MIT
PKG_MAINTAINER:=xiaohaisly

PKG_BUILD_DEPENDS:=golang/host node/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=miaomiaowu
GO_PKG_BUILD_PKG:=$(GO_PKG)/cmd/server

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/miaomiaowu
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Subscription
  TITLE:=Clash 配置订阅管理工具
  URL:=https://miaomiaowu.net
  DEPENDS:=@(aarch64||arm||i386||x86_64||riscv64) +ca-bundle
endef

define Package/miaomiaowu/description
  Clash配置订阅管理工具，支持节点管理、生成订阅、导入外部订阅节点、聚合流量、聚合订阅等功能。
endef

define Package/miaomiaowu/conffiles
/etc/config/miaomiaowu
/etc/miaomiaowu/
endef

define Build/Compile
	cd $(PKG_BUILD_DIR)/miaomiaowu && \
		export PATH="$(STAGING_DIR_HOSTPKG)/bin:$$$$PATH" && \
		export npm_config_cache="$(PKG_BUILD_DIR)/.npm-cache" && \
		npm ci --no-audit --no-fund && \
		npm run build
	$(call GoPackage/Build/Compile)
endef

define Package/miaomiaowu/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/server $(1)/usr/bin/miaomiaowu

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/miaomiaowu.init $(1)/etc/init.d/miaomiaowu

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/miaomiaowu.config $(1)/etc/config/miaomiaowu
endef

$(eval $(call BuildPackage,miaomiaowu))
