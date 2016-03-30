//
//  CoreViewController.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 29.03.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>
#import "CoreViewController.h"

@interface CoreViewController () <FBSDKLoginButtonDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) FBSDKLoginButton *loginButton;

@end

@implementation CoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.center = self.view.center;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate = self;
    [self.view addSubview:self.loginButton];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
}

- (IBAction)startButton:(UIButton *)sender
{
    
}

#pragma mark - <FBSDKLoginButtonDelegate>

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

@end
