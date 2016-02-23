//
//  SplashViewErrorFactory.m
//  TengNiu
//
//  Created by YangNan on 15/4/21.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "SplashViewErrorFactory.h"

const NSString* TNSplashErrorDomain = @"com.tengniu.error.splash";
const NSString* TNSplashErrorTitleKey = @"TNSplashErrorTitleKey";
const NSString* TNSplashErrorSubtitleKey = @"TNSplashErrorSubtitleKey";
const NSString* TNSplashErrorButtonNormalTitleKey = @"TNSplashErrorButtonNormalTitleKey";
const NSString* TNSplashErrorButtonHighlightedTitleKey = @"TNSplashErrorButtonHighlightedTitleKey";
const NSString* TNSplashErrorButtonDisabledTitleKey = @"TNSplashErrorButtonDisabledTitleKey";

@implementation SplashViewErrorFactory

+ (NSError *)errorWithSplashViewTitleKey:(NSString *)titleKey subtitleKey:(NSString *)subtitleKey buttonTitleKey:(NSString *)buttonTitleKey {
    NSString* title = titleKey != nil ? NSLocalizedString(titleKey, nil) : nil;
    NSString* subtitle = subtitleKey != nil ? NSLocalizedString(subtitleKey, nil) : nil;
    NSString* buttonTitle = buttonTitleKey != nil ? NSLocalizedString(buttonTitleKey, nil) : nil;
    NSArray* buttonTitles;
    if (buttonTitle) {
        buttonTitles = @[buttonTitle, buttonTitle, buttonTitle];
    } else {
        buttonTitles = nil;
    }
    return [SplashViewErrorFactory errorWithSplashViewTitle:title subtitle:subtitle buttonTitles:buttonTitles];
}

+ (NSError *)errorWithSplashViewTitleKey:(NSString *)titleKey subtitleKey:(NSString *)subtitleKey buttonTitleKeys:(NSArray *)buttonTitleKeys {
    NSString* title = titleKey != nil ? NSLocalizedString(titleKey, nil) : nil;
    NSString* subtitle = subtitleKey != nil ? NSLocalizedString(subtitleKey, nil) : nil;
    return [SplashViewErrorFactory errorWithSplashViewTitle:title subtitle:subtitle buttonTitles:buttonTitleKeys];
}

+ (NSError *)errorWithSplashViewTitle:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle {
    NSArray* buttonTitles;
    if (buttonTitle) {
        buttonTitles = @[buttonTitle, buttonTitle, buttonTitle];
    } else {
        buttonTitles = nil;
    }
    return [SplashViewErrorFactory errorWithSplashViewTitle:title subtitle:subtitle buttonTitles:buttonTitles];
}

+ (NSError *)errorWithSplashViewTitle:(NSString *)title subtitle:(NSString *)subtitle buttonTitles:(NSArray *)buttonTitles {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (title) {
        dict[TNSplashErrorTitleKey] = title;
    }
    if (subtitle) {
        dict[TNSplashErrorSubtitleKey] = subtitle;
    }
    NSInteger i = buttonTitles.count;
    if (i > 0) {
        dict[TNSplashErrorButtonNormalTitleKey] = buttonTitles[0];
    }
    if (i > 1) {
        dict[TNSplashErrorButtonDisabledTitleKey] = buttonTitles[1];
    }
    if (i > 2) {
        dict[TNSplashErrorButtonHighlightedTitleKey] = buttonTitles[1];
        dict[TNSplashErrorButtonDisabledTitleKey] = buttonTitles[2];
    }
    NSError* error = [NSError errorWithDomain:[TNSplashErrorDomain copy] code:9527 userInfo:dict];
    return error;
}

@end
