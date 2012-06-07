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
    screen = [[ScreenView alloc] initWithFrame:NSMakeRect(0, 0, 320, 160)];
    [[_window contentView] addSubview:screen];
    
    c8 = [[Chip8 alloc] init];
    [c8 setScr:screen];
    [c8 loadROM:@"/Users/Nick/Desktop/INVADERS"];
    [c8 startTimer];
}

@end
