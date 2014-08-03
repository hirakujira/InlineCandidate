BUNDLE_NAME = InlineCandidate
InlineCandidate_FILES = InlineCandidate.mm
InlineCandidate_INSTALL_PATH = /Library/PreferenceBundles
InlineCandidate_FRAMEWORKS = UIKit
InlineCandidate_PRIVATE_FRAMEWORKS = Preferences
IP_ADDRESS = 10.0.1.13
export ARCHS = armv7 arm64
export TARGET = iphone:clang::6.0

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InlineCandidate.plist$(ECHO_END)
	rsync -z _/Library/PreferenceBundles/InlineCandidate.bundle/* root@$(IP_ADDRESS):/Library/PreferenceBundles/InlineCandidate.bundle/
	
	ssh root@$(IP_ADDRESS) killall Preferences
	
sync: stage
	rsync -z _/Library/PreferenceBundles/InlineCandidate.bundle/* root@$(IP_ADDRESS):/Library/PreferenceBundles/InlineCandidate.bundle/
	rsync -z _/Library/PreferenceLoader/Preferences/InlineCandidate.plist root@$(IP_ADDRESS):/Library/PreferenceLoader/Preferences/InlineCandidate.plist
	ssh root@$(IP_ADDRESS) killall Preferences
