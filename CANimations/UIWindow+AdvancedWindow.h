//
//  UIWindow+AdvancedWindow.h
//  Log In Animation
//
//  Created by Vladyslav Gamalii on 22.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypeLeft,
    AnimationTypeRight
};

@interface UIWindow (AdvancedWindow)

- (void)setNewRootViewController:(UIViewController *)controller animationType:(AnimationType)type;

@end
