--- a/package/kernel/linux/modules/usb.mk
+++ b/package/kernel/linux/modules/usb.mk
@@ -576,7 +576,7 @@
 	CONFIG_SND_USB_AUDIO
   $(call AddDepends/usb)
   $(call AddDepends/sound)
-  DEPENDS+=+kmod-media-controller
+  DEPENDS+=+(LINUX_6_1||LINUX_6_6||LINUX_6_12):kmod-media-controller
   FILES:= \
 	$(LINUX_DIR)/sound/usb/snd-usbmidi-lib.ko \
 	$(LINUX_DIR)/sound/usb/snd-usb-audio.ko
