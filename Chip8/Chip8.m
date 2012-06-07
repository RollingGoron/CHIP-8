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
        case 0x0000: {
            switch (opcode) {
                //Clear the screen
                case 0x00E0:
                    memset(screen, 0, 32*64);
                    [scr setData:screen];
                    PC += 2;
                    break;
                //Return from a subroutine
                case 0x00EE:
                    SP++;
                    PC = stack[SP];
                    PC += 2;
                    break;
                default:
                    NSLog(@"Unknown Opcode: %x", opcode);
                    break;
            }
            break;
        }
        //Jump to address (0x1NNN)
        case 0x1000:
            PC = opcode & 0x0FFF;
            break;
        //Call subroutine (0x2NNN)
        case 0x2000:
            stack[SP] = PC;
            SP--;
            PC = opcode & 0x0FFF;
            break;
        
        //Skip next instruction if VX = NN (0x3XNN)
        case 0x3000:
            PC += 2;
            if (V[(opcode & 0x0F00)>>8] == (opcode & 0x00FF))
                PC += 2;
            break;
            
        //------
            
        //Set V[X] to NN (0x6XNN)
        case 0x6000:
            V[(opcode & 0x0F00)>>8] = opcode & 0x00FF;
            PC += 2;
            break;
            
        //Add NN to V[X] (0x7XNN)
        case 0x7000:
            V[(opcode & 0x0F00)>>8] += (opcode & 0x00FF);
            PC += 2;
            break;
            
        //Set I to NNN (0xANNN)
        case 0xA000:
            I = opcode & 0x0FFF;
            PC += 2;
            break;
            
        //Draw sprite at VX, VY with height N (0xDXYN)
        case 0xD000: {
            unsigned int spriteX = V[(opcode & 0x0F00) >> 8];
            unsigned int spriteY = V[(opcode & 0x00F0) >> 4];
            unsigned int spriteH = opcode & 0x000F;
            
            V[0xF] = 0;
            for (int y = 0; y < spriteH; y++) {
                unsigned char byte = memory[I + y];
                for (int x = 0; x < 8; x++) {
                    if ((byte & (0x80 >> x)) != 0) {
                        if (screen[spriteX + x + (spriteY + y)*64])
                            V[0xF] = 1;
                        screen[spriteX + x + (spriteY + y)*64] ^= 1;
                    }
                }
            }
            [scr setData:screen];
            PC += 2;
            
            break;
        }
        default:
            NSLog(@"Unknown Opcode: %x", opcode);
            break;
    }
}

-(void)startTimer {
    cpuTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(cycle) userInfo:nil repeats:YES];
}

-(void)stopTimer {
    [cpuTimer invalidate];
    cpuTimer = nil;
}

@end
