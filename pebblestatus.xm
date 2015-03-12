#include "BluetoothManager.framework/BluetoothManager.h"
#import "libstatusbar/LSStatusBarItem.h"
#import "libstatusbar/UIApplication_libstatusbar.h"

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface BluetoothManager (pebblestatus)
-(BOOL)getHideBluetooth;
-(void)updateForPebbleConnection;
@end

%hook BluetoothManager
static LSStatusBarItem *pebbleItem;

%new -(void)updateForPebbleConnection{
	BOOL pebbleConnected = NO;
	for(id device in [self connectedDevices]){
		if([[device name] rangeOfString:@"Pebble"].location != NSNotFound){
			NSLog(@"[pebblestatus] Detected connection to Pebble with name: %@", [device name]);
			pebbleConnected = YES;
			break;
		}
	}
	
	pebbleItem =  [[%c(LSStatusBarItem) alloc] initWithIdentifier: @"pbstatus.Connected" alignment:StatusBarAlignmentRight];
	pebbleItem.imageName = @"PB_connected";

	if(pebbleConnected){
		NSLog(@"[pebblestatus] Statusbar updated to display Pebble connected!");
		pebbleItem.visible = YES;
	}

	else{
		NSLog(@"[pebblestatus] Statusbar updated to display that NO Pebble is connected.");
		pebbleItem.visible = NO;
	}
}

-(id)init{
	NSLog(@"[pebblestatus] BluetoothManager initialized, checking for Pebble...");
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[self updateForPebbleConnection];
	});
	return %orig;
}

-(void)_connectedStatusChanged {
	NSLog(@"[pebblestatus] Detected change of Bluetooth connection status, checking for Pebble...");
	[self updateForPebbleConnection];
	%orig;
}//end statuschanged
%end
/*
@interface UIStatusBarItemView : UIView
-(id)contentsImage;
-(BOOL)updateForNewData:(id)arg1 actions:(int)arg2;
@end

@interface UIStatusBarBluetoothItemView : UIStatusBarItemView
-(BOOL)hideBluetooth;
@end

%hook UIStatusBarBluetoothItemView
static BOOL shouldUpdateToHide;

%new -(BOOL)hideBluetooth{
	BOOL pebbleConnected;
	for(id device in [[%c(BluetoothManager) sharedInstance] connectedDevices]){
		if([[device name] rangeOfString:@"Pebble"].location != NSNotFound){
			NSLog(@"[pebblestatus] Detected connection to Pebble with name: %@", [device name]);
			pebbleConnected = YES;
			break;
		}
	}

	return [[[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.hesze.pebblestatus.plist"]] objectForKey:@"hideBluetooth"] boolValue] && pebbleConnected;
}//end hide

-(id)contentsImage{
	if([self hideBluetooth]){
		shouldUpdateToHide = YES;
		return nil;
	}

	return %orig;
}

-(id)imageWithShadowNamed:(id)arg1{
	if([self hideBluetooth]){
		shouldUpdateToHide = YES;
		return nil;
	}

	return %orig;
}

-(BOOL)updateForNewData:(id)arg1 actions:(int)arg2{
	if(shouldUpdateToHide){
		shouldUpdateToHide = NO;
		return YES;
	}

	return %orig;
}
%end*/