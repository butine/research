//
//  UIViewController+SplashView.m
//  TengNiu
//
//  Created by 李晓春 on 15/4/16.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "UIViewController+SplashView.h"
#import <objc/runtime.h>
#import "LoadingSplashView.h"
#import "SplashFailedView.h"
#import "STUtilities.h"
#import "NoneDataView.h"
#import <PureLayout/PureLayout.h>


@interface UIViewController (SplashViewHolder)

@property (nonatomic, strong) LoadingSplashView *st_viewSplash;
@property (nonatomic, strong) SplashFailedView *st_viewSplashFailed;
@property (nonatomic, strong) NoneDataView *st_noDataView;

@end

static const void *LoadingSplashViewKey = &LoadingSplashViewKey;
static const void *SplashFailedViewKey = &SplashFailedViewKey;
static const void *TNNoDataViewKey = &TNNoDataViewKey;

@implementation UIViewController (SplashViewHolder)

- (LoadingSplashView*)st_viewSplash
{
    return objc_getAssociatedObject(self, LoadingSplashViewKey);
}

- (void)setSt_viewSplash:(LoadingSplashView *)st_viewSplash
{
    objc_setAssociatedObject(self, LoadingSplashViewKey, st_viewSplash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SplashFailedView*)st_viewSplashFailed
{
    return objc_getAssociatedObject(self, SplashFailedViewKey);
}

- (void)setSt_viewSplashFailed:(SplashFailedView *)st_viewSplashFailed
{
    objc_setAssociatedObject(self, SplashFailedViewKey, st_viewSplashFailed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NoneDataView *)st_noDataView {
    return objc_getAssociatedObject(self, TNNoDataViewKey);
}

- (void)setSt_noDataView:(NoneDataView *)st_noDataView {
    objc_setAssociatedObject(self, TNNoDataViewKey, st_noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



@implementation UIViewController (SplashView)


- (void)st_setViewControlerInLoading
{
    if (!self.st_viewSplash) {
        self.st_viewSplash = [LoadingSplashView viewFromNib];
    }
    
    [self.st_viewSplash setLoading:YES];
    [self.view addSubview:self.st_viewSplash];
    [self.st_viewSplash autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)st_setViewControlerInLoadingWithViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets
{
    if (!self.st_viewSplash) {
        self.st_viewSplash = [LoadingSplashView viewFromNib];
    }
    
    [self.st_viewSplash setLoading:YES];
    [self.view addSubview:self.st_viewSplash];
    [self.st_viewSplash autoPinEdgesToSuperviewEdgesWithInsets:viewEdgeInstets];
}

- (void)st_setViewControlerLoadingSuccess
{
    if (self.st_viewSplash) {
        [self.st_viewSplash setLoading:NO];
        [self.st_viewSplash removeFromSuperview];
        self.st_viewSplash = nil;
    }
    
    if (self.st_viewSplashFailed) {
        [self.st_viewSplashFailed removeFromSuperview];
        self.st_viewSplashFailed = nil;
    }
    
    if (self.st_noDataView) {
        [self.st_noDataView removeFromSuperview];
        self.st_noDataView = nil;
    }
}

- (void)st_setViewControlerLoadingFailed:(NSError*)error withViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets
{
    if (self.st_viewSplash) {
        [self.st_viewSplash setLoading:NO];
        [self.st_viewSplash removeFromSuperview];
        self.st_viewSplash = nil;
    }
    
    if (!self.st_viewSplashFailed) {
        self.st_viewSplashFailed = [SplashFailedView viewFromNib];

        self.st_viewSplashFailed.delegate = self;
        [self.view addSubview:self.st_viewSplashFailed];
        [self.st_viewSplashFailed autoPinEdgesToSuperviewEdgesWithInsets:viewEdgeInstets];
    }
    
    [self.st_viewSplashFailed setFailedState:error];
}

- (void)st_setViewControlerLoadingFailed:(NSError*)error
{
    [self st_setViewControlerLoadingFailed:error withViewEdgeInstets:UIEdgeInsetsZero];
}

- (void)st_setViewControlerLoadingFinishedWithNoneDataWithViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets
{
    [self st_setViewControlerLoadingFinishedWithNoneDataWithViewEdgeInstets:viewEdgeInstets message:@"暂无记录"];
}

- (void)st_setViewControlerLoadingFinishedWithNoneDataWithViewEdgeInstets:(UIEdgeInsets)viewEdgeInstets message:(NSString*)strMessage
{
    if (self.st_viewSplash) {
        [self.st_viewSplash removeFromSuperview];
    }
    
    if (self.st_viewSplashFailed) {
        [self.st_viewSplashFailed removeFromSuperview];
    }
    
    if (self.st_noDataView) {
        return;
    }
    
    self.st_noDataView = [NoneDataView viewFromNib];
    self.st_noDataView.labelMessage.text = strMessage;
    [self.view addSubview:self.st_noDataView];
    [self.st_noDataView autoPinEdgesToSuperviewEdgesWithInsets:viewEdgeInstets];
}

- (void)st_setViewControlerLoadingFinishedWithNoneData
{
    [self st_setViewControlerLoadingFinishedWithNoneDataWithViewEdgeInstets:UIEdgeInsetsZero message:@"暂无记录"];
}

- (void)st_setViewControlerLoadingFinishedWithNoneData:(NSString*)strTitle
{
    [self st_setViewControlerLoadingFinishedWithNoneDataWithViewEdgeInstets:UIEdgeInsetsZero message:strTitle];
}

@end