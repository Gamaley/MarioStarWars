//
//  LayerView.h
//  CANimations
//
//  Created by Vladyslav Gamalii on 16.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>

@interface LayerView : UIView

@property (strong, nonatomic) CALayer *planeLayer;
@property (strong, nonatomic) CALayer *coinLayer;

@property (strong, nonatomic) NSMutableArray *coins;
@property (assign, nonatomic) NSInteger coinsCount;

@property (assign, nonatomic, getter=isCoinsAnimating) BOOL coinsAnimate;

- (float)angleForLayer:(CALayer *)layer withTouchPoint:(CGPoint)point;
- (CALayer *)getCoinLayerInPosition:(CGPoint)point withImage:(CGImageRef)coinImage;
- (void)setShipImageWithImageName:(NSString *)name;

@end
