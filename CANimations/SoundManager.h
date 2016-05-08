//
//  SoundManager.h
//  CANimations
//
//  Created by Vladyslav Gamalii on 25.04.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject

@property (strong, nonatomic) AVAudioPlayer *damagePlayer;
@property (strong, nonatomic) AVAudioPlayer *coinPlayer;
@property (strong, nonatomic) AVAudioPlayer *powerUpPlayer;
@property (strong, nonatomic) AVAudioPlayer *clearPlayer;
@property (strong, nonatomic) AVAudioPlayer *diePlayer;
@property (strong, nonatomic) AVAudioPlayer *monsterPlayer;
@property (strong, nonatomic) AVAudioPlayer *buttonPlayer;

+ (instancetype)defaultManager;

@end
