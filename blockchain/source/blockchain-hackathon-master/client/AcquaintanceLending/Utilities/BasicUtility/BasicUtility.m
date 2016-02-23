//
//  BasicUtility.m
//  TengNiu
//
//  Created by 李晓春 on 15/4/8.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "BasicUtility.h"

@interface BasicUtility()

@property (strong, nonatomic) NSMutableDictionary *dicDateFormatter;
@property (strong, nonatomic) NSMutableDictionary *dicData;

@end

@implementation BasicUtility

+ (instancetype)sharedInstance {
    static BasicUtility* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BasicUtility new];
        instance.dicDateFormatter = [NSMutableDictionary dictionary];
        instance.dicData = [NSMutableDictionary dictionary];
    });
    
    return instance;
}

- (void)setButton:(UIButton*)btn titleForAllState:(NSString*)strTitle
{
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitle:strTitle forState:UIControlStateHighlighted];
    [btn setTitle:strTitle forState:UIControlStateDisabled];
}

- (void)setButton:(UIButton*)btn titleColorForAllState:(UIColor *)titleColor
{
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateHighlighted];
    [btn setTitleColor:titleColor forState:UIControlStateDisabled];
}

- (void)setButton:(UIButton*)btn titleColors:(NSArray *)arrayColors
{
    [btn setTitleColor:arrayColors[0] forState:UIControlStateNormal];
    [btn setTitleColor:arrayColors.count >= 2?arrayColors[1]:arrayColors[0] forState:UIControlStateHighlighted];
    [btn setTitleColor:arrayColors.count >= 3?arrayColors[2]:arrayColors[0] forState:UIControlStateDisabled];
}

- (void)setButton:(UIButton*)button images:(NSArray*)arrayImages
{
    [button setBackgroundImage:arrayImages[0] forState:UIControlStateNormal];
    
    if (arrayImages.count < 3) {
        return;
    }
    
    [button setBackgroundImage:arrayImages[1] forState:UIControlStateHighlighted];
    [button setBackgroundImage:arrayImages[2] forState:UIControlStateDisabled];
}

- (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [window subviews].lastObject;
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (NSMutableDictionary*)changeDictionaryFormat:(NSDictionary*)dicInfo
{
    NSMutableDictionary *dicReturn = [NSMutableDictionary dictionary];
    for (NSString* strKey in dicInfo.allKeys) {
        if ([dicInfo[strKey] isKindOfClass:[NSDictionary class]]) {
            dicReturn[strKey] = [self changeDictionaryFormat:dicInfo[strKey]];
        }
        else if ([dicInfo[strKey] isKindOfClass:[NSArray class]]) {
            dicReturn[strKey] = [self changeArrayFormat:dicInfo[strKey]];
        }
        else if ([dicInfo[strKey] isKindOfClass:[NSString class]]) {
            if ([dicInfo[strKey] length]) {
                dicReturn[strKey] = dicInfo[strKey];
            }
        }
        else if ([dicInfo[strKey] isKindOfClass:[NSNull class]]) {
            //do nothing
            
        }
        else if ([dicInfo[strKey] isKindOfClass:[NSNumber class]]) {
            dicReturn[strKey] = [dicInfo[strKey] stringValue];
        }
    }
    return dicReturn;
}

- (NSMutableArray*)changeArrayFormat:(NSArray*)arrayInfo
{
    NSMutableArray *arrayReturn = [NSMutableArray array];
    for (id item in arrayInfo) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            [arrayReturn addObject:[self changeDictionaryFormat:item]];
        }
        else if ([item isKindOfClass:[NSArray class]]) {
            [arrayReturn addObject:[self changeArrayFormat:item]];
        }
        else if ([item isKindOfClass:[NSString class]]) {
            if ([item length]) {
                [arrayReturn addObject:item];
            }
        }
        else if ([item isKindOfClass:[NSNull class]]) {
            //do nothing
            
        }
        else if ([item isKindOfClass:[NSNumber class]]) {
            [arrayReturn addObject:[item stringValue]];
        }
    }
    return arrayReturn;
}


- (id)changeObjectFormat:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [self changeDictionaryFormat:object];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        return [self changeArrayFormat:object];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        //do nothing
        return nil;
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    else {
        return object;
    }
}

- (NSDateFormatter*)formatterForString:(NSString*)strFormatter
{
    if (_dicDateFormatter[strFormatter]) {
        return _dicDateFormatter[strFormatter];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = strFormatter;
    _dicDateFormatter[strFormatter] = formatter;
    return formatter;
}

- (NSDate*)getLastCheckPinDate
{
    if (_dicData[@"LastCheckPinDate"]) {
        return _dicData[@"LastCheckPinDate"];
    }
    
    return nil;
}

- (void)setLastCheckPinDate:(NSDate*)date
{
    _dicData[@"LastCheckPinDate"] = date;
}

- (NSString*)defaultTimeForTimeInterval:(NSTimeInterval)tTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tTime / 1000];
    return [[self formatterForString:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:date];
}

@end
