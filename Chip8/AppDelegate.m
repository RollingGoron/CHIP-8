//
//  AppDelegate.m
//  Chip8
//
//  Created by nhigh on 6/6/12.
//  Copyright (c) 2012 nhigh. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[_window contentView] addSubview:[ScreenView sharedScreen]];
    
    c8 = [[Chip8 alloc] init];
    [c8 loadROM:@"/Users/Nick/Desktop/BLINKY"];
    [c8 startTimer];
    [[ScreenView sharedScreen] becomeFirstResponder];
}

@end
