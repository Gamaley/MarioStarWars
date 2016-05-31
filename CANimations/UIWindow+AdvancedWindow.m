//
//  UIWindow+AdvancedWindow.m
//  Log In Animation
//
//  Created by Vladyslav Gamalii on 22.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "UIWindow+AdvancedWindow.h"

static NSInteger const Spacing = 70;
static NSInteger const Compression = 50;
static CGFloat const AnimationDuration = .5f;

static NSString *kPosition = @"position";
static NSString *kTransform = @"transform";


typedef void (^AnimationCompletion) (void);

@interface CAAnimation (AnimationWithBlock)

@property (copy, nonatomic) AnimationCompletion completion;

- (void)animateRootView:(UIView *)rootView withSecondView:(UIView *)secondView animationType:(AnimationType)type withCompletion:(AnimationCompletion)completion;

@end


@implementation CAAnimation (AnimationWithBlock)

@dynamic completion;

- (void)animateRootView:(UIView *)rootView withSecondView:(UIView *)secondView animationType:(AnimationType)type withCompletion:(AnimationCompletion)completion
{
    CGRect toRect = [self toRectForFirstView:rootView animationType:type];
    self.completion = completion;
    CGPoint rootViewToPosition =  CGPointMake(CGRectGetMidX(toRect), CGRectGetMidY(toRect));
    
    CABasicAnimation *animationRootView = [CABasicAnimation animationWithKeyPath:kPosition];
    animationRootView.fromValue = [NSValue valueWithCGPoint:[[rootView.layer presentationLayer] position]];
    animationRootView.toValue = [NSValue valueWithCGPoint:rootViewToPosition];
    animationRootView.duration = AnimationDuration;
    [rootView.layer setPosition:rootViewToPosition];
    
    CABasicAnimation *transformRootView = [CABasicAnimation animationWithKeyPath:kTransform];
    transformRootView.fromValue = [NSValue valueWithCATransform3D:rootView.layer.transform];
    transformRootView.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.f)];
    transformRootView.duration = AnimationDuration;
    
    CABasicAnimation *animationSecondView = [CABasicAnimation animationWithKeyPath:kPosition];
    animationSecondView.fromValue = [NSValue valueWithCGPoint:secondView.center];
    animationSecondView.toValue = animationRootView.fromValue;
    animationSecondView.duration = AnimationDuration;
    [secondView.layer setPosition:((NSValue *)animationRootView.fromValue).CGPointValue];
    
    CABasicAnimation *transformSecondView = [CABasicAnimation animationWithKeyPath:kTransform];
    transformSecondView.fromValue = transformRootView.toValue;
    transformSecondView.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.f, 1.f, 1.f)];
    transformSecondView.duration = AnimationDuration;
    transformSecondView.delegate = self;
    
    [rootView.layer addAnimation:animationRootView forKey:@"firstViewAnimation"];
    [rootView.layer addAnimation:transformRootView forKey:@"firstViewScale"];
    [secondView.layer addAnimation:animationSecondView forKey:@"secondViewAnimation"];
    [secondView.layer addAnimation:transformSecondView forKey:@"secondViewTransform"];
}

- (CGRect)toRectForFirstView:(UIView *)view animationType:(AnimationType)type
{
    if (type == AnimationTypeRight) {
        return CGRectMake(view.frame.origin.x + view.frame.size.width + Spacing, view.frame.origin.y+Spacing, view.frame.size.width - Compression, view.frame.size.height - Compression - Spacing);
    } else if (type == AnimationTypeLeft) {
        return CGRectMake(view.frame.origin.x - view.frame.size.width - Spacing, view.frame.origin.y+ Spacing, view.frame.size.width - Compression, view.frame.size.height - Compression - Spacing);
    }
    return CGRectZero;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.completion();
}

@end




@implementation UIWindow (AdvancedWindow)

- (void)setNewRootViewController:(UIViewController *)controller animationType:(AnimationType)type
{
    UIView *rootView = self.rootViewController.view;
    CGRect secondFrame = controller.view.frame;
    
    if (type == AnimationTypeRight) {
        secondFrame.origin.x -= secondFrame.size.width + Spacing;
    } else if (type == AnimationTypeLeft) {
        secondFrame.origin.x += secondFrame.size.width + Spacing;
    }
    
    UIView * secondView = controller.view;
    secondView.frame = secondFrame;
    [self addSubview:secondView];
    
    CAAnimation *animation = [CAAnimation animation];
    [animation animateRootView:rootView withSecondView:secondView animationType:type withCompletion:^{
        self.rootViewController = controller;
    }];
}

@end
