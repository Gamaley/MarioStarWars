//
//  AppDelegate.h
//  CANimations
//
//  Created by Vladyslav Gamalii on 16.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

