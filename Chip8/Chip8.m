//
//  Chip8.m
//  Chip8
//
//  Created by nhigh on 6/6/12.
//  Copyright (c) 2012 nhigh. All rights reserved.
//

#import "Chip8.h"

@implementation Chip8
@synthesize scr;

-(id)init {
    self = [super init];
    if (self) {
        PC = 0x200;
        SP = 0xF;
    }
    return self;
}

-(void)loadROM:(NSString *)path {
    //Load ROM into 0x200.
    NSData *romDat = [NSData dataWithContentsOfFile:path];
    memcpy(&memory[0x200], [romDat bytes], [romDat length]);
}

-(void)cycle {
    if (PC > 0xFFF) {
        NSLog(@"Unexpected program end.");
        exit(0);
    }
    unsigned int opcode = (memory[PC]<<8)+memory[PC+1];
    switch (opcode & 0xF000) {
            default:
            NSLog(@"Unknown Opcode: %x", opcode);
            break;
    }
    //Update the screen
    [scr setData:screen];
}

-(void)startTimer {
    cpuTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(cycle) userInfo:nil repeats:YES];
}

-(void)stopTimer {
    [cpuTimer invalidate];
    cpuTimer = nil;
}

@end
