#define kCFCoreFoundationVersionNumber_iOS_5_0 675.00
#define kCFCoreFoundationVersionNumber_iOS_5_1 690.10
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20

@interface UIKeyboardImpl : UIView
+ (id)activeInstance;
@property(assign, nonatomic) BOOL showsCandidateInline;
@property(assign, nonatomic) BOOL showsCandidateBar;
@end

@interface UIKBTree 
@property(retain, nonatomic) NSMutableDictionary* cache;
@property(retain, nonatomic) NSMutableArray* subtrees;
@property(retain, nonatomic) NSMutableDictionary* properties;
@property(retain, nonatomic) NSString* name;
@property(assign, nonatomic) int type;
@end

@interface TWTweetComposeViewController : UIViewController
- (id)init;
-(void)keyboardWillShow:(id)keyboard;
@end

@interface UIKeyboardCandidateGridCell : UIView
@property(assign, nonatomic) int candidatesVisualStyle;
@end

@interface UIKBRenderConfig 
@property(readonly, assign, nonatomic) BOOL whiteText;
@end

@interface UIView (InlineCandidate)
@property(readonly, assign, nonatomic) UIKBRenderConfig* _inheritedRenderConfig;
@end
//==============================================================================
static BOOL isTweetView = NO;
static BOOL enableBar;
static int mode;
static NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.hiraku.inlinecandidate.plist"];
static BOOL noWhiteText = YES;
static BOOL showFloating = NO;

%hook UIKeyboardCandidateBar
-(CALayer *)layer
{
	CALayer* view = %orig;	
	if(mode == 0) {
		float candidcateBarOpacity = [[plistDict objectForKey:@"candidcateBarOpacity"] floatValue];

		NSFileManager *fileManager = [[NSFileManager alloc] init];
 		if(	[fileManager fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/iAcces.dylib"] && 
 			[fileManager fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/notweetkb.dylib"] && isTweetView == YES) {
			view.opacity = 0;
 		}
		else {
			view.opacity = candidcateBarOpacity;
		}
	}
	return view;
}
%end

%hook UIKeyboardImpl
-(BOOL)_shouldShowCandidateBar:(BOOL)bar
{
	enableBar = %orig;
	
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	NSFileManager *fileManager2 = [[NSFileManager alloc] init];
 	if(	[fileManager2 fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/iAcces.dylib"] &&
 		[fileManager2 fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/notweetkb.dylib"] && isTweetView == YES) {
		return YES;
 	}
 	else
 	{
		mode = [[plistDict objectForKey:@"mode"] intValue];
		if ([[plistDict objectForKey:[@"Bar-" stringByAppendingString:identifier]] boolValue]||[[plistDict objectForKey:[@"Float-" stringByAppendingString:identifier]] boolValue])
		{
			if ([[plistDict objectForKey:[@"Bar-" stringByAppendingString:identifier]] boolValue] && isTweetView == NO && self.showsCandidateBar == NO) {
				self.showsCandidateBar = YES;
				self.showsCandidateInline = NO;
			}
			else if ([[plistDict objectForKey:[@"Float-" stringByAppendingString:identifier]] boolValue] && isTweetView == NO && self.showsCandidateBar == YES) {
				self.showsCandidateBar = NO;
				self.showsCandidateInline = YES;
			}
		}
		else if (isTweetView == NO && mode == 1 && self.showsCandidateBar == YES) {
			self.showsCandidateBar = NO;
			self.showsCandidateInline = YES;
		}
		return enableBar;
	}
	return enableBar;
}

%end

%group GiOS7WhiteText
%hook UIKeyboardCandidateGridCell
-(void)drawText {
	if (showFloating == YES) {
		noWhiteText = NO;
	}
	%orig;
}
%end

%hook UIKBRenderConfig
-(BOOL)whiteText {
	if (noWhiteText == NO) {
		return NO;
	}
	noWhiteText = YES;
	return %orig;
}
%end
%end

%group GiOS6 %hook UIKeyboardImpl
-(BOOL)showsCandidateInline
{
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];

	mode = [[plistDict objectForKey:@"mode"] intValue];
	if ([[plistDict objectForKey:[@"Bar-" stringByAppendingString:identifier]] boolValue]||[[plistDict objectForKey:[@"Float-" stringByAppendingString:identifier]] boolValue])
	{
		if ([[plistDict objectForKey:[@"Bar-" stringByAppendingString:identifier]] boolValue] && isTweetView == NO) {
			return NO;
		}
		else if ([[plistDict objectForKey:[@"Float-" stringByAppendingString:identifier]] boolValue] && isTweetView == NO) {
			showFloating = YES;
			return YES;
		}
	}
	else if (isTweetView == NO && mode == 1) {
		showFloating = YES;
		return YES;
	}
	else {
		return %orig;
	}
	showFloating = YES;
	return YES;
}

-(BOOL)showsCandidateBar {
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];

	mode = [[plistDict objectForKey:@"mode"] intValue];
	if ([[plistDict objectForKey:[@"Bar-" stringByAppendingString:identifier]] boolValue]||[[plistDict objectForKey:[@"Float-" stringByAppendingString:identifier]] boolValue])
	{
		if ([[plistDict objectForKey:[@"Bar-" stringByAppendingString:identifier]] boolValue] && isTweetView == NO) {
			return %orig;
		}
		else if ([[plistDict objectForKey:[@"Float-" stringByAppendingString:identifier]] boolValue] && isTweetView == NO) {
			return NO;
		}
	}
	else if (isTweetView == NO && mode == 0) {
		return %orig;
	}
	else {
		return %orig;
	}
	return %orig;
}
%end %end

%hook TWTweetComposeViewController
-(void)keyboardWillShow:(id)keyboard {
	isTweetView = YES;
	%orig;
}
%end

//==============================================================================
%group GSetPreferences %hook SpringBoard 

- (void)applicationDidFinishLaunching:(id)application
{
    %orig;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
 	if(![fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/com.hiraku.inlinecandidate.plist"])
 	{
 		NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"0", @"mode", 
                                        @"1", @"candidcateBarOpacity",
                                        nil];
 		[plistDict writeToFile:@"/var/mobile/Library/Preferences/com.hiraku.inlinecandidate.plist" atomically:YES ];
 	}
}

%end %end

//==============================================================================
__attribute__((constructor)) static void init()
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // Setup hooks
    %init;

    // Setup app-dependent hooks
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier isEqualToString:@"com.apple.springboard"]) {
        %init(GSetPreferences);
    }

    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) {
    	%init(GiOS6);
    }
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
		%init(GiOS7WhiteText);
	}

    [pool release];
}
