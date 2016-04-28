//
//  LayerView.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 16.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "LayerView.h"

@implementation LayerView 


- (void)awakeFromNib
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sky.jpg"]];
    [self addSubview: imageView];
    self.coinsAnimate = NO;
    
    self.planeLayer = [[CALayer alloc] init];
    self.planeLayer.bounds = CGRectMake(0.0, 0.0, 150, 150);
    self.planeLayer.position = CGPointMake(160, 160);
    [self setLayerContents:self.planeLayer withImageName:@"ship.png"];
    self.planeLayer.contentsRect = CGRectMake(-0.1, -0.1, 1.2, 1.2);
    self.planeLayer.contentsGravity = kCAGravityResizeAspect;
    [self.layer addSublayer:self.planeLayer];
    
    self.coinLayer = [[CALayer alloc] init];
    self.coins = [NSMutableArray new];
    self.coinLayer.zPosition = 15.0f;
    [self.layer addSublayer:self.coinLayer];
    
    self.lazerLayer = [[CALayer alloc] init];
    self.lazerLayer.bounds = CGRectMake(0.0, 0.0, 20, 100);
    [self setLayerContents:self.lazerLayer withImageName:@"laser.png"];
    self.lazerLayer.contentsRect = CGRectMake(-0.1, -0.1, 1.2, 1.2);
    [self.layer insertSublayer:self.lazerLayer below:self.planeLayer];
//    [self.layer addSublayer:self.lazerLayer];
    
    self.burstLayer = [[CALayer alloc] init];
    [self setLayerContents:self.burstLayer withImageName:@"burst.png"];
    self.burstLayer.frame = CGRectMake(60.0, 60.0, 40, 40);
    self.burstLayer.position = CGPointMake(CGRectGetMidX(self.burstLayer.frame), CGRectGetMidY(self.burstLayer.frame));
    self.burstLayer.opacity = 0.0;
    [self.planeLayer addSublayer:self.burstLayer];
}

#pragma mark - Public

- (float)angleForLayer:(CALayer *)layer withTouchPoint:(CGPoint)point
{
    float dY = layer.position.y - point.y;
    float dX = layer.position.x - point.x;
    return atan2f(dY, dX) + 1.571f;
}

- (CALayer *)getCoinLayerInPosition:(CGPoint)point withImage:(CGImageRef)coinImage
{
    CALayer *coinlayer = [[CALayer alloc] init];
    coinlayer.contents = (__bridge id)coinImage;
    coinlayer.bounds = CGRectMake(point.x, point.y, 30, 40);
    coinlayer.position = point;
    return coinlayer;
}

- (void)setLayerContents:(CALayer *)layer withImageName:(NSString *)name
{
    CGImageRef planeImage = [[UIImage imageNamed:name] CGImage];
    [layer setContents:(__bridge id)planeImage];
}

#pragma mark - Private

- (float)convertToRadians:(float)degrees
{
    return degrees * M_PI / 180;
}

@end
