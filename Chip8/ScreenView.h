//
//  ScreenView.h
//  Chip8
//
//  Created by Nick High on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>

@interface ScreenView : NSOpenGLView {
    bool data[32*64];
    bool keys[16];
    NSTimer *drawTimer;
}

+(ScreenView*)sharedScreen;

-(void)drawFrame;
-(void)setData:(bool*)newData;
-(BOOL)getKey:(int)kIndex;

@end
