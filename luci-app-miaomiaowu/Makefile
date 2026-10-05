# SPDX-License-Identifier: MIT

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-miaomiaowu
PKG_VERSION:=0.8.6
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_MAINTAINER:=xiaohaisly

LUCI_TITLE:=LuCI support for miaomiaowu (妙妙屋)
LUCI_DEPENDS:=+miaomiaowu
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,luci-app-miaomiaowu))
