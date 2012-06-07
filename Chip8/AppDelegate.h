//
//  AppDelegate.h
//  Chip8
//
//  Created by nhigh on 6/6/12.
//  Copyright (c) 2012 nhigh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScreenView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    ScreenView *screen;
}

@property (assign) IBOutlet NSWindow *window;

@end
