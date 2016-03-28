//
//  ViewController.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 16.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "ViewController.h"
#import "LayerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LayerView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.coinsLabel.text = [NSString stringWithFormat:@"= %li",self.layerView.coinsCount];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.layerView.isCoinsAnimating) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGImageRef coinImage;
    if ((self.layerView.coinsCount + self.layerView.subviews.lastObject.layer.sublayers.count) == 9) {
        coinImage = [[UIImage imageNamed:@"gribok.png"] CGImage];
    } else {
        coinImage = [[UIImage imageNamed:@"coin.png"] CGImage];
    }
    
    CALayer *coinlayer = [self.layerView getCoinLayerInPosition:point withImage:coinImage];

    [self.layerView.subviews.lastObject.layer addSublayer:coinlayer];
    [self.layerView.coins addObject:coinlayer];
    float angle = [self.layerView angleForLayer:self.layerView.planeLayer withTouchPoint:point];
    
    CABasicAnimation *planeMoveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [planeMoveAnimation setFromValue:[NSValue valueWithCGPoint:[[self.layerView.planeLayer presentationLayer] position]]];
    [planeMoveAnimation setToValue:[NSValue valueWithCGPoint:point]];
    [planeMoveAnimation setDuration:1.0f];

    [self.layerView.planeLayer setPosition:point];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.layerView.planeLayer.transform = CATransform3DMakeAffineTransform(transform);
    planeMoveAnimation.delegate = self;
//    planeMoveAnimation.removedOnCompletion = NO;
    [self.layerView.planeLayer addAnimation:planeMoveAnimation forKey:@"MoveShip"];
}

- (void)animateCoins
{
    self.layerView.coinsAnimate = YES;
    for (int i = 0;  i < self.layerView.coins.count; i++) {
        CALayer *layer = [self.layerView.coins objectAtIndex:i];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:layer.position];
        animation.toValue = [NSValue valueWithCGPoint:[[self.layerView.planeLayer presentationLayer] position]];
        animation.duration = 0.9f;
        if (self.layerView.coins.count -1 == i) {
            animation.delegate = self;
        }
        [layer setPosition:[[self.layerView.planeLayer presentationLayer] position]];
        [layer addAnimation:animation forKey:@"coinAnimation"];
    }
}

#pragma mark - <CAAnimationDelegate>

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [self animateCoins];
        if (anim.duration == 0.9f) {
            for (CALayer *layer in self.layerView.coins) {
                [layer removeFromSuperlayer];
                self.layerView.coinsCount++;
                self.coinsLabel.text = [NSString stringWithFormat:@"= %li",self.layerView.coinsCount];
            }
            if (self.layerView.coinsCount > 9) {
                [self.layerView setShipImageWithImageName:@"ship2.png"];
            }
            [self.layerView.coins removeAllObjects];
            self.layerView.coinsAnimate = NO;
        }
    }
}

@end
