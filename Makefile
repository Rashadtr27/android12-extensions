getprop = $(shell cat module.prop | grep "^$(1)=" | head -n1 | cut -d'=' -f2)

MODNAME ?= $(call getprop,id)
MODVER ?= $(call getprop,version)
ZIP = $(MODNAME)-$(MODVER).zip

all: $(ZIP)

zip: $(ZIP)

%.zip: clean
	zip -r0 $(ZIP) . -x $(MODNAME)-*.zip LICENSE /.git* Makefile *.DS_Store* *placeholder /overlays*

install: $(ZIP)
	adb push $(ZIP) /sdcard/
	echo '/sbin/.magisk/busybox/unzip -p "/sdcard/$(ZIP)" META-INF/com/google/android/update-binary | /sbin/.magisk/busybox/sh /proc/self/fd/0 x 1 "/sdcard/$(ZIP)"' | adb shell su -c sh -

clean:
	rm -f *.zip

.PHONY: all zip %.zip install clean
