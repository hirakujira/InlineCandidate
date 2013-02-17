TWEAK_NAME = InlineCandidate
InlineCandidate_OBJCC_FILES = Tweak.mm
SYSROOT=/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.2.sdk
InlineCandidate_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices
InlineCandidate_PRIVATE_FRAMEWORKS = UIKit CoreGraphics GraphicsServices MediaPlayer
LDFLAGS += -march=armv7
include theos/makefiles/common.mk
include theos/makefiles/tweak.mk
export ARCHS = armv7
export TARGET=iphone:4.2:4.2

sync: stage
	rsync -z _/Library/MobileSubstrate/DynamicLibraries/* root@192.168.3.25:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@192.168.3.25 killall SpringBoard
	
sync2: stage
	rsync -z _/Library/MobileSubstrate/DynamicLibraries/* root@192.168.1.36:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@192.168.1.36 killall SpringBoard