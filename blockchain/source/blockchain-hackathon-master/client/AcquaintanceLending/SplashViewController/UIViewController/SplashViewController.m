//
//  SplashViewController.m
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "SplashViewController.h"
#import "MainContentViewController.h"
#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import <RESideMenu/RESideMenu.h>
#import "PersistentHelper.h"
#import "ECNetworkDataModel+User.h"
#import "ECNetworkDataModel+Operation.h"
#import "ConstantVariables.h"
#import "ECContext.h"
#import <Toast/UIView+Toast.h>
#import "STUtilities.h"

@interface SplashViewController () <SplashFailedViewDelegate, UIAlertViewDelegate, RESideMenuDelegate>

@property (strong, nonatomic) NSDictionary* dicVersion;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loginIfNeeded];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loginIfNeeded
{
    __weak __typeof(self) weakSelf = self;
    
    if ([[[PersistentHelper sharedInstance]getNumberForKey:UserHasLogined]boolValue]) {
        [[ECNetworkDataModel sharedInstance]getUserDetailWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *dicInfo = responseObject;
            dicInfo[@"token"] = dicInfo[@"id"];
            [ECContext sharedInstance].userInfo = dicInfo;

            [weakSelf showContentViewController];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf showLoginViewController:YES];
        }];
    }
    else {
        [weakSelf showLoginViewController:NO];
    }
}

- (void)showLoginViewController:(BOOL)bTokenExpired
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [ECContext sharedInstance].sideMenu = nil;
    [[UIApplication sharedApplication]delegate].window.rootViewController = nav;
    if (bTokenExpired) {
        [vc.view makeToast:@"会话已过期，请重新登录" duration:2 position:CSToastPositionCenter];
    }
}

- (void)showContentViewController
{
    MainContentViewController *vcContent = [[MainContentViewController alloc]initWithNibName:nil bundle:nil];
    LeftMenuViewController *vcLeft = [[LeftMenuViewController alloc]initWithNibName:nil bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcContent];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:vcLeft rightMenuViewController:nil];
    
    sideMenuViewController.delegate = vcContent;
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    
    [ECContext sharedInstance].sideMenu = sideMenuViewController;
    [ECContext sharedInstance].vcMain = navigationController;
    [ECContext sharedInstance].vcMainContent = vcContent;
    [ECContext sharedInstance].vcSplash = self;
    
    [[UIApplication sharedApplication]delegate].window.rootViewController = sideMenuViewController;
}

#pragma mark - SplashFailedViewDelegate
- (void)st_reloadData
{
    [self loginIfNeeded];
}


@end
