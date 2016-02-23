//
//  LoadingSplashView.m
//  TengNiu
//
//  Created by 李晓春 on 15/4/16.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "LoadingSplashView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MBProgressHUDExtensions/UIViewController+MBProgressHUD.h>

@interface LoadingSplashView ()

@property (strong, nonatomic) MBProgressHUD *progressHud;

@end

@implementation LoadingSplashView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setLoading:(BOOL)bLoading
{
    if (!_progressHud) {
        UIView *hudSuperView = self;
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:hudSuperView];
        //        hud.dimBackground = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hudSuperView addSubview:hud];
        _progressHud = hud;
    }
    
    if (bLoading) {
        [_progressHud show:YES];
    }
    else {
        [_progressHud hide:YES];
    }
}

@end
