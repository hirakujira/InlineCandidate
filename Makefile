TWEAK_NAME = InlineCandidate
InlineCandidate_OBJCC_FILES = Tweak.mm
InlineCandidate_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices
InlineCandidate_PRIVATE_FRAMEWORKS = UIKit
export ARCHS = armv7 arm64
export TARGET = iphone:clang::5.0

include theos/makefiles/common.mk
include theos/makefiles/tweak.mk

sync: stage
	rsync -e "ssh -p 2222" -z _/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall MobileNotes
	
sync2: stage
	rsync -z _/Library/MobileSubstrate/DynamicLibraries/* root@192.168.1.36:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@192.168.1.36 killall SpringBoard