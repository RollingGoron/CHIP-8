//
//  Chip8.m
//  Chip8
//
//  Created by nhigh on 6/6/12.
//  Copyright (c) 2012 nhigh. All rights reserved.
//

#import "Chip8.h"

@implementation Chip8

unsigned char font[80] = {
    0xF0, 0x90, 0x90, 0x90, 0xF0, //0
    0x20, 0x60, 0x20, 0x20, 0x70, //1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, //2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, //3
    0x90, 0x90, 0xF0, 0x10, 0x10, //4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, //5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, //6
    0xF0, 0x10, 0x20, 0x40, 0x40, //7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, //8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, //9
    0xF0, 0x90, 0xF0, 0x90, 0x90, //A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, //B
    0xF0, 0x80, 0x80, 0x80, 0xF0, //C
    0xE0, 0x90, 0x90, 0x90, 0xE0, //D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, //E
    0xF0, 0x80, 0xF0, 0x80, 0x80  //F
};

-(id)init {
    self = [super init];
    if (self) {
        PC = 0x200;
        SP = 0xF;
        //Load font
        memcpy(memory, font, 80);
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
                    [[ScreenView sharedScreen] setData:screen];
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
            
        //Skip next instruction if VX != NN (0x4XNN)
        case 0x4000:
            PC += 2;
            if (V[(opcode & 0x0F00)>>8] != (opcode & 0x00FF))
                PC += 2;
            break;
            
        //Skip the next instruction if VX = VY (0x5XY0)
        case 0x5000:
            PC += 2;
            if (V[(opcode & 0x0F00)>>8] == V[(opcode & 0x00F0)>>4])
                PC += 2;            
            break;
            
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
            
        case 0x8000: {
            switch (opcode & 0x000F) {
                //Set V[X] to V[Y] (0x8XY0)
                case 0x0000:
                    V[(opcode & 0x0F00)>>8] = V[(opcode & 0x00F0)>>4];
                    PC += 2;
                    break;
                //Set V[X] to V[X] | V[Y] (0x8XY1)
                case 0x0001:
                    V[(opcode & 0x0F00)>>8] |= V[(opcode & 0x00F0)>>4];
                    PC += 2;
                    break;
                //Set V[X] to V[X] & V[Y] (0x8XY2)
                case 0x0002:
                    V[(opcode & 0x0F00)>>8] &= V[(opcode & 0x00F0)>>4];
                    PC += 2;
                    break;
                //Set V[X] to V[X] ^ V[Y] (0x8XY3)
                case 0x0003:
                    V[(opcode & 0x0F00)>>8] ^= V[(opcode & 0x00F0)>>4];
                    PC += 2;
                    break;
                //Add V[Y] to V[X]. 
                case 0x0004:
                    V[(opcode&0x0F00)>>8] += V[(opcode&0x00F0)>>4];
                    PC += 2;
                    break;
                default:
                    NSLog(@"Unknown Opcode: %x", opcode);
                    break;
            }
            break;
        }
            
        //Skip next instruction if V[X] != V[Y]
        case 0x9000:
            PC += 2;
            if (V[(opcode & 0x0F00)>>8] != V[(opcode & 0x00F0)>>4])
                PC += 2;  
            break;
            
        //Set I to NNN (0xANNN)
        case 0xA000:
            I = opcode & 0x0FFF;
            PC += 2;
            break;
        
        //Jump to address NNN + V[0] (0xBNNN)
        case 0xB000:
            PC = (opcode & 0x0FFF) + V[0];
            break;
            
        //Set V[X] to a random number & NN.            
        case 0xC000:
            V[(opcode & 0x0F00)>>8] = (arc4random()%256) & (opcode & 0x00FF);
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
            [[ScreenView sharedScreen] setData:screen];
            PC += 2;
            
            break;
        }
            
        case 0xE000: {
            switch (opcode & 0x00FF) {
                //Skip next instruction if key in V[X] is pressed (0xEX9E)
                case 0x009E:
                    PC += 2;
                    if ([[ScreenView sharedScreen] getKey:(opcode&0x0F00)>>8])
                        PC += 2;
                    break;
                    
                //Skip next instruction if key in V[X] isn't pressed (0xEXA1)
                case 0x00A1:
                    PC += 2;
                    if (![[ScreenView sharedScreen] getKey:(opcode&0x0F00)>>8])
                        PC += 2;
                    break;
                    
                default:
                    NSLog(@"Unknown Opcode: %x", opcode);
                    break;
            }
            break;
        }
            
        case 0xF000: {
            switch (opcode & 0x00FF) {
                //Set VX to value of delay timer.
                case 0x0007:
                    V[(opcode & 0x0F00)>>8] = delay_timer;
                    PC += 2;
                    break;
                //Set delay timer to V[X]
                case 0x0015:
                    delay_timer = V[(opcode & 0x0F00)>>8];
                    PC += 2;
                    break;
                //Set sound timer to V[X]
                case 0x0018:
                    sound_timer = V[(opcode & 0x0F00)>>8];
                    PC += 2;
                    break;
                //Add V[X] to I (0xFX1E)
                case 0x001E:
                    I += V[(opcode & 0x0F00)>>8];
                    PC += 2;
                    break;
                //Set I to location of sprite for char in VX.
                case 0x0029:
                    I = V[(opcode & 0x0F00) >> 8] * 0x5;
                    PC += 2;
                    break;
                //Store BCD rep of V[X] at I, I+1, and I+2
                case 0x0033:
                    memory[I] = V[(opcode&0x0F00)>>8]/100;
                    memory[I+1] = (V[(opcode&0x0F00)>>8]/10)%10;
                    memory[I+2] = (V[(opcode&0x0F00)>>8]%100)%10;
                    PC += 2;
                    break;
                //Store V[0] to V[X] in mem starting a (I)
                case 0x0055: {
                    unsigned int len = (opcode & 0x0F00)>>8;
                    for (int a = 0; a < len; a++) {
                        memory[I+a] = V[a];
                    }
                    PC += 2;
                    break;
                }
                //Fill V[0] to V[X] with mem vals starting at (I) (0xFX65)
                case 0x0065: {
                    unsigned int len = (opcode & 0x0F00)>>8;
                    memcpy(V, &memory[I], len + 1);
                    PC += 2;
                    break;
                }
                default:
                    NSLog(@"Unknown Opcode: %x", opcode);
                    break;
            }
            break;
        }
            
        default:
            NSLog(@"Unknown Opcode: %x", opcode);
            break;
    }
}

-(void)updateTimers {
    if (delay_timer > 0)
        delay_timer--;
    if (sound_timer > 0)
        sound_timer--;
}

-(void)startTimer {
    cpuTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(cycle) userInfo:nil repeats:YES];
    funcTimers = [NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(updateTimers) userInfo:nil repeats:YES]; 
}

-(void)stopTimer {
    [cpuTimer invalidate];
    cpuTimer = nil;
}

@end
