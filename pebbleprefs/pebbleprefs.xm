#import <Preferences/PSListController.h>

@interface PebblePreferencesListController : PSListController
@end

@implementation PebblePreferencesListController
-(NSArray *)specifiers {
	if (!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"pebbleprefs" target:self] retain];

	return _specifiers;
}
@end
