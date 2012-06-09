//
//  ScreenView.m
//  Chip8
//
//  Created by Nick High on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView

+(ScreenView*)sharedScreen {
    static ScreenView *sharedScreen;
    @synchronized(self) {
        if (!sharedScreen)
            sharedScreen = [[ScreenView alloc] initWithFrame:NSMakeRect(0, 0, 320, 160)];
    }
    return sharedScreen;
}

-(id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        drawTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
    }
    return self;
}

-(BOOL)acceptsFirstResponder {
    return YES;
}

-(void)setData:(bool*)newData {
    memcpy(data, newData, 32*64);
}

-(void)drawRect:(NSRect)dirtyRect {
    [self drawFrame];
}

-(BOOL)getKey:(int)kIndex {
    return keys[kIndex];
}

-(void)keyDown:(NSEvent *)theEvent {
    int kc = theEvent.keyCode;
    switch (kc) {
        case 18:
            //1
            keys[0] = 1;
            break;
        case 19:
            //2
            keys[1] = 1;
            break;
        case 20:
            //3
            keys[2] = 1;
            break;
        case 12:
            //Q
            keys[3] = 1;
            break;
        case 13:
            //W
            keys[4] = 1;
            break;
        case 14:
            //E
            keys[5] = 1;
            break;
        case 0:
            //A
            keys[6] = 1;
            break;
        case 1:
            //S
            keys[7] = 1;
            break;
        case 2:
            //D
            keys[8] = 1;
            break;
        case 6:
            //Z
            keys[9] = 1;
            break;
        case 7:
            //X
            keys[10] = 1;
            break;
        case 8:
            //C
            keys[11] = 1;
            break;
    }
}

-(void)keyUp:(NSEvent *)theEvent {
    int kc = theEvent.keyCode;
    switch (kc) {
        case 18:
            //1
            keys[0] = 0;
            break;
        case 19:
            //2
            keys[1] = 0;
            break;
        case 20:
            //3
            keys[2] = 0;
            break;
        case 12:
            //Q
            keys[3] = 0;
            break;
        case 13:
            //W
            keys[4] = 0;
            break;
        case 14:
            //E
            keys[5] = 0;
            break;
        case 0:
            //A
            keys[6] = 0;
            break;
        case 1:
            //S
            keys[7] = 0;
            break;
        case 2:
            //D
            keys[8] = 0;
            break;
        case 6:
            //Z
            keys[9] = 0;
            break;
        case 7:
            //X
            keys[10] = 0;
            break;
        case 8:
            //C
            keys[11] = 0;
            break;
    }
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
