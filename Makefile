THEOS_PACKAGE_DIR_NAME = debs
TARGET =: clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = pebblestatus
pebblestatus_FILES = pebblestatus.xm
pebblestatus_LDFLAGS = -L./lib
pebblestatus_LIBRARIES = statusbar

pebblestatus_FRAMEWORKS = UIKit
pebblestatus_PRIVATE_FRAMEWORKS = AppSupport BluetoothManager

include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec "killall -9 backboardd"