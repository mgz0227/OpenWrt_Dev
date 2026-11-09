--- a/feeds/miaogongzi/luci-app-adguardhome/Makefile
+++ b/feeds/miaogongzi/luci-app-adguardhome/Makefile
@@ -12,7 +12,8 @@ LUCI_DEPENDS:=+luci-base +adguardhome
 LUCI_PKGARCH:=all
 USERID:=adguardhome=853:adguardhome=853
 
-PKG_UNPACK:=$(CURDIR)/.prepare.sh $(PKG_NAME) $(CURDIR) $(PKG_BUILD_DIR)
+# These feed integration patches are already applied to the packaged sources.
+PATCH_DIR:=
 
 define Package/luci-app-adguardhome/conffiles
 /etc/adguardhome/adguardhome.yaml
