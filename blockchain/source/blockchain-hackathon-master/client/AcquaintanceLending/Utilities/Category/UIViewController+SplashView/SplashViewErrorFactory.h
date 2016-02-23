//
//  SplashViewErrorFactory.h
//  TengNiu
//
//  Created by YangNan on 15/4/21.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* TNSplashErrorDomain;
/**
 *  错误页的页面标题
 */
extern NSString* TNSplashErrorTitleKey;
/**
 *  错误页的页面副标题
 */
extern NSString* TNSplashErrorSubtitleKey;
/**
 *  错误页的按钮普通状态的标题
 */
extern NSString* TNSplashErrorButtonNormalTitleKey;
/**
 *  错误页的按钮点击状态的标题
 */
extern NSString* TNSplashErrorButtonHighlightedTitleKey;
/**
 *  错误页的按钮不可用状态的标题
 */
extern NSString* TNSplashErrorButtonDisabledTitleKey;

@interface SplashViewErrorFactory : NSObject

+ (NSError *)errorWithSplashViewTitleKey:(NSString *)titleKey subtitleKey:(NSString *)subtitleKey buttonTitleKey:(NSString *)buttonTitleKey;

+ (NSError *)errorWithSplashViewTitleKey:(NSString *)titleKey subtitleKey:(NSString *)subtitleKey buttonTitleKeys:(NSArray *)buttonTitleKeys;

+ (NSError *)errorWithSplashViewTitle:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle;

+ (NSError *)errorWithSplashViewTitle:(NSString *)title subtitle:(NSString *)subtitle buttonTitles:(NSArray *)buttonTitles;

@end
