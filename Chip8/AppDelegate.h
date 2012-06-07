//
//  AppDelegate.h
//  Chip8
//
//  Created by nhigh on 6/6/12.
//  Copyright (c) 2012 nhigh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScreenView.h"
#import "Chip8.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    ScreenView *screen;
    Chip8 *c8;
}

@property (assign) IBOutlet NSWindow *window;

@end
