//
//  SoundManager.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 25.04.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

+ (instancetype)defaultManager
{
    static SoundManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SoundManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *damagePath = [[NSBundle mainBundle]pathForResource:@"battle" ofType:@"mp3"];
        NSString *coinPath = [[NSBundle mainBundle]pathForResource:@"coinsound" ofType:@"mp3"];
        NSString *powerPath = [[NSBundle mainBundle]pathForResource:@"powerup" ofType:@"wav"];
        NSString *clearPath = [[NSBundle mainBundle]pathForResource:@"clear" ofType:@"wav"];
        NSString *diePath = [[NSBundle mainBundle]pathForResource:@"mariodie" ofType:@"wav"];
        NSString *monsterPath = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"wav"];
        NSString *buttonPath = [[NSBundle mainBundle]pathForResource:@"button_press" ofType:@"wav"];
        self.clearPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:clearPath] error:nil];
        self.coinPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:coinPath] error:nil];
        self.damagePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:damagePath] error:nil];
        self.diePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:diePath] error:nil];
        self.powerUpPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:powerPath] error:nil];
        self.monsterPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:monsterPath] error:nil];
        self.buttonPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:buttonPath] error:nil];

    }
    return self;
}

@end
