//
//  ViewController.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 16.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "ViewController.h"
#import "LayerView.h"
#import "UIWindow+AdvancedWindow.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LayerView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;

@property (strong, nonatomic) NSTimer *lazerTimer;
@property (strong, nonatomic) NSTimer *collision;
@property (assign, nonatomic) NSTimeInterval secondsCount;
@property (assign, nonatomic) NSInteger healthCount;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPlayground];
}

//- (void)dealloc
//{
//    [self.lazerTimer invalidate];
//    [self.collision invalidate];
//}

#pragma mark - Overrides

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if ((self.layerView.lastCoinPosition.x == point.x && self.layerView.lastCoinPosition.y == point.y) || self.layerView.isCoinsAnimating) {
        return;
    }
    self.layerView.lastCoinPosition = point;
    CGImageRef coinImage;
    if ((self.layerView.coinsCount + self.layerView.subviews.lastObject.layer.sublayers.count) == 9) {
        coinImage = [UIImage imageNamed:@"gribok.png"].CGImage;
    } else {
        coinImage = [UIImage imageNamed:@"coin.png"].CGImage;
    }
    
    CALayer *coinlayer = [self.layerView getCoinLayerInPosition:point withImage:coinImage];

    [self.layerView.subviews.lastObject.layer addSublayer:coinlayer];
    [self.layerView.coins addObject:coinlayer];
    [self animatePlaneAndMoveToPoint:point];
}

#pragma mark - Private

- (void)animatePlaneAndMoveToPoint:(CGPoint)point
{
    float angle = [self.layerView angleForLayer:self.layerView.planeLayer withTouchPoint:point];
    
    CABasicAnimation *planeMoveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [planeMoveAnimation setFromValue:[NSValue valueWithCGPoint:[[self.layerView.planeLayer presentationLayer] position]]];
    [planeMoveAnimation setToValue:[NSValue valueWithCGPoint:point]];
    [planeMoveAnimation setDuration:1.0f];
    [self.layerView.planeLayer setPosition:point];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.layerView.planeLayer.transform = CATransform3DMakeAffineTransform(transform);
    planeMoveAnimation.delegate = self;
    [self.layerView.planeLayer addAnimation:planeMoveAnimation forKey:@"planeAnimation"];
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

- (void)animateRandomLazer
{
    [self countDown];
    BOOL rand = arc4random_uniform(100000) % 2;
    CGPoint toLazerPoint;// =CGPointMake([UIScreen mainScreen].bounds.size.width+50,[UIScreen mainScreen].bounds.size.height);
    if (rand) {
        toLazerPoint = CGPointMake([UIScreen mainScreen].bounds.size.width+50, arc4random_uniform([UIScreen mainScreen].bounds.size.height));
    } else {
        toLazerPoint = CGPointMake(arc4random_uniform([UIScreen mainScreen].bounds.size.width),[UIScreen mainScreen].bounds.size.height+50);
    }
    CABasicAnimation *lazerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [lazerAnimation setFromValue:[NSValue valueWithCGPoint:self.layerView.lazerLayer.frame.origin]];
    [lazerAnimation setToValue:[NSValue valueWithCGPoint:toLazerPoint]];
    lazerAnimation.duration = .5f;
    
    float angle = [self.layerView angleForLayer:self.layerView.lazerLayer withTouchPoint:toLazerPoint];
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.layerView.lazerLayer.transform = CATransform3DMakeAffineTransform(transform);
    [self.layerView.lazerLayer addAnimation:lazerAnimation forKey:@"lazerAnimation"];
}

- (void)setupPlayground
{
    self.coinsLabel.text = [NSString stringWithFormat:@"= %li",self.layerView.coinsCount];
    self.secondsCount = 30.f;
    self.healthCount = 100;
    self.healthLabel.text = [NSString stringWithFormat:@"%ld%c",self.healthCount,'%'];
    self.lazerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(animateRandomLazer) userInfo:nil repeats:YES];
    self.collision = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(collisionCheck) userInfo:nil repeats:YES];
    [self.lazerTimer fire];
    [self.collision fire];
}

- (void)countDown
{
    if (self.secondsCount >= 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"00:%.0f",self.secondsCount];
        self.secondsCount--;
    } else {
        [self.lazerTimer invalidate];
        [self.collision invalidate];
        __weak typeof(self)weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Well Done" message:@"Level Completed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf finishLevel];
        }];
        [alertController addAction:doneAction];
        [self showViewController:alertController sender:nil];
    }
}

- (void)collisionCheck
{
    CGRect laserRect = [[self.layerView.lazerLayer presentationLayer] frame];
    CGRect planeRect = [[self.layerView.planeLayer presentationLayer] frame];
    planeRect.origin.x += 40;
    planeRect.origin.y += 25;
    planeRect.size.width = 50.f;
    planeRect.size.height = 100.f;
    
    laserRect.origin.x += 5;
    laserRect.origin.y += 10;
    laserRect.size.width = 10;
    laserRect.size.height = 80;
    
    if (CGRectIntersectsRect(laserRect, planeRect)) {
        CAKeyframeAnimation *burstAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        burstAnimation.values = @[@1.0, @0.0, @1.0, @0.0];
        burstAnimation.duration = 0.3;
        [self.layerView.burstLayer addAnimation:burstAnimation forKey:@"burstAnimation"];
        self.healthCount -= arc4random_uniform(20);
        if (self.healthCount <= 0) {
            [self.lazerTimer invalidate];
            [self.collision invalidate];
            __weak typeof(self)weakSelf = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Plane Destroyed" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Game Over" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf finishLevel];
            }];
            [alertController addAction:doneAction];
            [self showViewController:alertController sender:nil];
        }
        self.healthLabel.text = [NSString stringWithFormat:@"%ld%c",self.healthCount,'%'];
        NSLog(@"BOOM");
    }
}

- (void)finishLevel
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *newViewController = [secondStoryBoard instantiateInitialViewController];
    
    UIWindow *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
    [window setNewRootViewController:newViewController animationType:AnimationTypeRight];
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
                [self.layerView setLayerContents:self.layerView.planeLayer withImageName:@"ship2.png"];
            }
            [self.layerView.coins removeAllObjects];
            self.layerView.coinsAnimate = NO;
        }
    }
}

@end
