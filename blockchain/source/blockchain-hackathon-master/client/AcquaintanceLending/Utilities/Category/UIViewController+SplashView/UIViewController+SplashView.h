//
//  UIViewController+SplashView.h
//  TengNiu
//
//  Created by 李晓春 on 15/4/16.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewErrorFactory.h"

@protocol SplashFailedViewDelegate <NSObject>
@optional
- (void)st_reloadData;

@end

@interface UIViewController (SplashView) <SplashFailedViewDelegate>

- (void)st_setViewControlerInLoading;
- (void)st_setViewControlerInLoadingWithViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets;

- (void)st_setViewControlerLoadingSuccess;

- (void)st_setViewControlerLoadingFailed:(NSError*)error;
- (void)st_setViewControlerLoadingFailed:(NSError*)error withViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets;

- (void)st_setViewControlerLoadingFinishedWithNoneDataWithViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets;
- (void)st_setViewControlerLoadingFinishedWithNoneDataWithViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets message:(NSString*)strMessage;
- (void)st_setViewControlerLoadingFinishedWithNoneData;
- (void)st_setViewControlerLoadingFinishedWithNoneData:(NSString*)strTitle;

@end