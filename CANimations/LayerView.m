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
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview: imageView];
    
    self.planeLayer = [[CALayer alloc] init];
    [self.planeLayer setBounds:CGRectMake(0.0, 0.0, 150, 150)];
    [self.planeLayer setPosition:CGPointMake(160, 160)];
    [self setShipImageWithImageName:@"ship.png"];
    
    [self.planeLayer setContentsRect:CGRectMake(-0.1, -0.1, 1.2, 1.2)];
    [self.planeLayer setContentsGravity:kCAGravityResizeAspect];
    [self.layer addSublayer:self.planeLayer];
    
    self.coinLayer = [[CALayer alloc] init];
    self.coins = [NSMutableArray new];
    self.coinLayer.zPosition = 15.0f;
    [self.layer addSublayer:self.coinLayer];
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
    coinlayer.zPosition = 15.0f;
    coinlayer.contents = (__bridge id)coinImage;
    coinlayer.bounds = CGRectMake(point.x, point.y, 30, 40);
    coinlayer.position = point;
    return coinlayer;
}

- (void)setShipImageWithImageName:(NSString *)name
{
    CGImageRef planeImage = [[UIImage imageNamed:name] CGImage];
    [self.planeLayer setContents:(__bridge id)planeImage];
}

#pragma mark - Private

- (float)convertToRadians:(float)degrees
{
    return degrees * M_PI / 180;
}

@end
