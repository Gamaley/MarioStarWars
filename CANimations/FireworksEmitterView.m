//
//  FireworksEmitterView.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 08.05.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "FireworksEmitterView.h"

@implementation FireworksEmitterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
        CGRect viewBounds = self.layer.bounds;
        fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
        fireworksEmitter.frame = frame;
        fireworksEmitter.masksToBounds = YES;
        fireworksEmitter.emitterShape = kCAEmitterLayerLine;
        fireworksEmitter.renderMode	= kCAEmitterLayerAdditive;
        fireworksEmitter.seed = (arc4random()%100)+1;
        
        CAEmitterCell* rocket = [CAEmitterCell emitterCell];
        rocket.birthRate = 1.0;
        rocket.emissionRange = 0.15 * M_PI;  // angle
        rocket.velocity = 580;
        rocket.velocityRange = 120;
        rocket.yAcceleration = 75;
        rocket.lifetime	= 1.02;
        rocket.contents	= (id) [[UIImage imageNamed:@"Ring"] CGImage];
        rocket.scale = 0.2;
        rocket.color = [[UIColor redColor] CGColor];
        rocket.greenRange = 1.0;		// different colors
        rocket.redRange	= 1.0;
        rocket.blueRange = 1.0;
        rocket.spinRange = M_PI;
        
        CAEmitterCell* burst = [CAEmitterCell emitterCell];
        burst.birthRate	= 1.0;		// at the end of travel
        burst.velocity = 0;
        burst.scale	= 2.5;
        burst.redSpeed = -1.5;		// shifting
        burst.blueSpeed	= 1.5;		// shifting
        burst.greenSpeed = 1.0;		// shifting
        burst.lifetime = 0.35;
        
        CAEmitterCell* spark = [CAEmitterCell emitterCell];
        spark.birthRate = 400; // stars count
        spark.velocity = 125; // how far stars spread
        spark.emissionRange = 2 * M_PI;	// 360 deg
        spark.yAcceleration	= 75;		// gravity
        spark.lifetime = 2;
        spark.contents = (id) [[UIImage imageNamed:@"Star"] CGImage];
        spark.scaleSpeed = -0.2;
        spark.greenSpeed = -0.1;
        spark.redSpeed = 0.4;
        spark.blueSpeed	= -0.1;
        spark.alphaSpeed = -0.25;
        spark.spin = 2 * M_PI;
        spark.spinRange = 2 * M_PI;
        
        fireworksEmitter.emitterCells = @[rocket];
        rocket.emitterCells	= @[burst];
        burst.emitterCells = @[spark];

        [self.layer addSublayer:fireworksEmitter];
    }
    return self;
}

@end
