#import <Preferences/Preferences.h>

@interface InlineCandidateListController: PSListController {
}
@end

@implementation InlineCandidateListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"InlineCandidate" target:self] retain];
	}
	return _specifiers;
}


-(void)save:(id)param
{
	    sleep(1);
        system("killall lsd SpringBoard");

}
@end

// vim:ft=objc
