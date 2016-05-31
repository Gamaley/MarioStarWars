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
    [self initPlaneLayer];
    [self initInteractiveGameLayers];
    [self initFlyInSpaceEmitterLayer];
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

- (void)animateFlyToCoin:(BOOL)animate
{
    if (animate) {
        [self.flyInSpace setValue:[NSNumber numberWithFloat:-1000.0] forKeyPath:@"emitterCells.littleStar.yAcceleration"];
        [self.exhaustEmitter setValue:[NSNumber numberWithFloat:-2000.0] forKeyPath:@"emitterCells.exhaustCell.yAcceleration"];
    } else {
        [self.flyInSpace setValue:[NSNumber numberWithFloat:-20.0] forKeyPath:@"emitterCells.littleStar.yAcceleration"];
        [self.exhaustEmitter setValue:[NSNumber numberWithFloat:-600.0] forKeyPath:@"emitterCells.exhaustCell.yAcceleration"];
    }
}

#pragma mark - Private

- (void)initPlaneLayer
{
    self.planeLayer = [[CALayer alloc] init];
    self.planeLayer.bounds = CGRectMake(0.0, 0.0, 150, 150);
    self.planeLayer.position = CGPointMake(160, 160);
    [self setLayerContents:self.planeLayer withImageName:@"ship.png"];
    self.planeLayer.contentsRect = CGRectMake(-0.1, -0.1, 1.2, 1.2);
    self.planeLayer.contentsGravity = kCAGravityResizeAspect;
    [self.layer addSublayer:self.planeLayer];
    
    self.exhaustEmitter = [CAEmitterLayer layer];
    self.exhaustEmitter.frame = self.planeLayer.contentsCenter;
    self.exhaustEmitter.position = CGPointMake(self.planeLayer.position.x - 85, self.planeLayer.position.y - 150);
    self.exhaustEmitter.emitterMode = kCAEmitterLayerOutline;
    self.exhaustEmitter.emitterShape = kCAEmitterLayerLine;
    self.exhaustEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *exhaustCell = [CAEmitterCell emitterCell];
    exhaustCell.emissionLatitude = M_PI;
    exhaustCell.birthRate = 300;
    exhaustCell.lifetime = 0.4;
    exhaustCell.velocity = 80;
    exhaustCell.velocityRange = 30;
    exhaustCell.emissionRange = 1.1;
    exhaustCell.yAcceleration = -600;
    exhaustCell.scaleSpeed = 0.3;
    exhaustCell.color = [UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:1.0].CGColor;
    exhaustCell.contents = (id) [[UIImage imageNamed:@"fire.png"] CGImage];
    exhaustCell.name = @"exhaustCell";
    self.exhaustEmitter.emitterCells = @[exhaustCell];
    [self.planeLayer addSublayer:self.exhaustEmitter];
    
}

- (void)initInteractiveGameLayers
{
    self.coinLayer = [[CALayer alloc] init];
    self.coins = [NSMutableArray new];
    self.coinLayer.zPosition = 15.0f;
    [self.layer addSublayer:self.coinLayer];
    
    self.lazerLayer = [[CALayer alloc] init];
    self.lazerLayer.bounds = CGRectMake(0.0, 0.0, 20, 100);
    [self setLayerContents:self.lazerLayer withImageName:@"laser.png"];
    self.lazerLayer.contentsRect = CGRectMake(-0.1, -0.1, 1.2, 1.2);
    [self.layer insertSublayer:self.lazerLayer below:self.planeLayer];
    
    self.burstLayer = [[CALayer alloc] init];
    [self setLayerContents:self.burstLayer withImageName:@"burst.png"];
    self.burstLayer.frame = CGRectMake(60.0, 60.0, 40, 40);
    self.burstLayer.position = CGPointMake(CGRectGetMidX(self.burstLayer.frame), CGRectGetMidY(self.burstLayer.frame));
    self.burstLayer.opacity = 0.0;
    [self.planeLayer addSublayer:self.burstLayer];
}

- (void)initFlyInSpaceEmitterLayer
{
    self.flyInSpace = [CAEmitterLayer layer];
    CGSize doubleScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height *2);
    self.flyInSpace.emitterSize = doubleScreenSize;
    self.flyInSpace.emitterShape = kCAEmitterLayerLine;
    self.flyInSpace.emitterMode = kCAEmitterLayerUnordered;
    self.flyInSpace.emitterPosition = CGPointMake(doubleScreenSize.width / 2, doubleScreenSize.height);
    self.flyInSpace.emitterDepth = 1.0;
    
    CAEmitterCell *littleStar = [CAEmitterCell emitterCell];
    littleStar.birthRate = 30;
    littleStar.lifetime = 10;
    littleStar.lifetimeRange = 0.5;
    littleStar.color = [UIColor whiteColor].CGColor;
    littleStar.contents = (id) [[UIImage imageNamed:@"Ring"] CGImage];
    littleStar.velocityRange = 400;
    littleStar.emissionLongitude = M_PI;
    littleStar.scale = 0.05;
    littleStar.spin = 1.0;
    littleStar.scaleRange = 0.1;
    littleStar.alphaRange = 0.3;
    littleStar.alphaSpeed = 0.5;
    littleStar.name = @"littleStar";
    //    littleStar.xAcceleration = 10.0;
    littleStar.yAcceleration = -20.0;
    self.flyInSpace.emitterCells = @[littleStar];
    [self.layer insertSublayer:self.flyInSpace below:self.planeLayer];
}

- (float)convertToRadians:(float)degrees
{
    return degrees * M_PI / 180;
}

@end
