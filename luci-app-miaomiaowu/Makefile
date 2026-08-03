include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-miaomiaowu

PKG_VERSION:=$(strip $(shell wget -qO- "https://miaomiaowu-openwrt.pages.dev/openwrt-24.10/$(ARCH_PACKAGES)/Packages" 2>/dev/null | \
	awk '/^Package: luci-app-miaomiaowu$$/{f=1;next} f&&/^Version:/{print $$2;exit} /^$$/{f=0}'))
ifeq ($(PKG_VERSION),)
  PKG_VERSION:=0.0.0-VERSION-FETCH-FAILED
endif
PKG_RELEASE:=1

PKG_MAINTAINER:=第十六夜月
PKG_LICENSE:=MIT

LUCI_TITLE:=LuCI support for miaomiaowu (妙妙屋)
LUCI_DEPENDS:=+miaomiaowu

include $(TOPDIR)/feeds/luci/luci.mk

ifeq ($(PKG_VERSION),0.0.0-VERSION-FETCH-FAILED)
  $(error Failed to fetch the version number from https://miaomiaowu-openwrt.445568.xyz/openwrt-24.10/$(ARCH_PACKAGES)/Packages. Please check if the URL is accessible and if the luci-app-miaomiaowu entry actually exists in the Packages index)
endif

$(eval $(call BuildPackage,luci-app-miaomiaowu))
