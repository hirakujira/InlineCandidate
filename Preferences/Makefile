include theos/makefiles/common.mk

BUNDLE_NAME = InlineCandidate
InlineCandidate_FILES = InlineCandidate.mm
InlineCandidate_INSTALL_PATH = /Library/PreferenceBundles
InlineCandidate_FRAMEWORKS = UIKit
InlineCandidate_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InlineCandidate.plist$(ECHO_END)
	rsync -z _/Library/PreferenceBundles/InlineCandidate.bundle/* root@10.0.2.6:/Library/PreferenceBundles/InlineCandidate.bundle/
	
	ssh root@10.0.2.6 killall Preferences
