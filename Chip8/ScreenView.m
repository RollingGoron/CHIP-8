//
//  ScreenView.m
//  Chip8
//
//  Created by Nick High on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect {
    [self drawFrame];
}

-(void)drawFrame {
    CGLLockContext([[self openGLContext] CGLContextObj]);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glFlush();
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

-(void)reshape {
    CGLLockContext([[self openGLContext] CGLContextObj]);
    [[self openGLContext] makeCurrentContext];
    NSRect bounds = [self bounds];
    glViewport(0, 0, NSWidth(bounds), NSHeight(bounds));
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, NSWidth(bounds), NSHeight(bounds), 0, 1, -1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    [NSOpenGLContext clearCurrentContext];
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

@end
