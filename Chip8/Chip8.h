//
//  Chip8.h
//  Chip8
//
//  Created by nhigh on 6/6/12.
//  Copyright (c) 2012 nhigh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenView.h"

@interface Chip8 : NSObject {
    unsigned char memory[0xFFF];
    bool screen[32*64];
    unsigned int V[16];
    unsigned int stack[16];
    
    unsigned int PC, SP, I;
    
    ScreenView *scr;
    
    NSTimer *cpuTimer;
    NSTimer *funcTimers;
    
    unsigned int delay_timer, sound_timer;
}

@property (nonatomic, retain) ScreenView *scr;

-(void)cycle;

-(void)loadROM:(NSString*)path;

-(void)startTimer;
-(void)stopTimer;

-(void)updateTimers;

@end
