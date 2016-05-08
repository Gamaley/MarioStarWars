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
#import "ViewController.h"
#import "UIWindow+AdvancedWindow.h"
#import "AppDelegate.h"
#import "Level.h"
#import "SoundManager.h"

static const CGFloat FacebookLoginButtonWidth = 124.f;

@interface CoreViewController () <FBSDKLoginButtonDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleButton;
@property (weak, nonatomic) IBOutlet UITextField *levelTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftPaddingFacbookButtonConstraint;

@end

@implementation CoreViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
//    self.loginButton.delegate = self;
    self.loginButton.loginBehavior = FBSDKLoginBehaviorWeb;
    [GIDSignIn sharedInstance].uiDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat padding = (screenWidth - FacebookLoginButtonWidth)/2;
    self.leftPaddingFacbookButtonConstraint.constant = padding;
    [self.view layoutIfNeeded];
}

#pragma mark - IBActions

- (IBAction)startButton:(UIButton *)sender
{
    [[SoundManager defaultManager].buttonPlayer play];
    if (!self.levelTextField.text.length) {
        [self shakeTextField];
        return;
    }
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"GameStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *newViewController = [secondStoryBoard instantiateInitialViewController];

    [self saveLevel];
    UIWindow *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
    [window setNewRootViewController:newViewController animationType:AnimationTypeLeft];
}

#pragma mark - Overrides

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.levelTextField isFirstResponder]) {
        [self.levelTextField resignFirstResponder];
    }
}

#pragma mark - Private

- (void)shakeTextField
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    animation.values = @[@0, @10, @-10, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    
    animation.additive = YES;
    [self.levelTextField.layer addAnimation:animation forKey:@"shake"];
}

- (void)saveLevel
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *levelPath = [path stringByAppendingPathComponent:@"level"];
    Level *level = [[Level alloc] initWithLevel:self.levelTextField.text.integerValue];
    [NSKeyedArchiver archiveRootObject:level toFile:levelPath];
}


#pragma mark - <FBSDKLoginButtonDelegate>

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

#pragma mark - <GIDSignInUIDelegate>

//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
//{
//    
//}
//
//
//- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
//{
//    
//}
//
//- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
//{
//    
//}

@end
