//
//  ScreenView.m
//  Chip8
//
//  Created by Nick High on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView

-(id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        drawTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)setData:(bool*)newData {
    memcpy(data, newData, 32*64);
}

-(void)drawRect:(NSRect)dirtyRect {
    [self drawFrame];
}

-(void)drawFrame {
    CGLLockContext([[self openGLContext] CGLContextObj]);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //Immediate mode is easier for now. Will switch later.
    for (int x = 0; x < 64; x++) {
        for (int y = 0; y < 32; y++) {
            if (data[(y*64)+x]) {
                glBegin(GL_TRIANGLES);
                glVertex2d(x*5, y*5);
                glVertex2d(x*5+5, y*5);
                glVertex2d(x*5, y*5+5);
                
                glVertex2d(x*5+5, y*5);
                glVertex2d(x*5+5, y*5+5);
                glVertex2d(x*5, y*5+5);
                glEnd();
             }
        }
    }
    
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
    glEnableClientState(GL_VERTEX_ARRAY);
    [NSOpenGLContext clearCurrentContext];
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

@end
