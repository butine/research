//
//  ECContext.m
//  ECarDriver
//
//  Created by sola on 15/8/24.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "ECContext.h"
#import "STUtilities.h"
#import "ConstantVariables.h"
#import "TNCryptor.h"

@interface ECContext ()
{
    BOOL m_bOrderListNeedUpdate;
}

@end

@implementation ECContext


+ (instancetype)sharedInstance {
    static ECContext* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ECContext new];
        [instance initUserInfo];
    });
    
    return instance;
}

- (void)initUserInfo
{
    if ([[[PersistentHelper sharedInstance]getNumberForKey:UserHasLogined]boolValue]) {
        NSData *data = [[PersistentHelper sharedInstance]getDataForKey:LastLoginUserData];
        NSString *strToken = [TNCryptor stringByAES256WithData:data];
        
        NSMutableDictionary *dicSave = [NSMutableDictionary dictionary];
        dicSave[@"token"] = strToken;
        dicSave[@"displayName"] = [[PersistentHelper sharedInstance]getStringForKey:UserDisplayName];
        
        _userInfo = dicSave;
    }
}

- (NSString*)getLastLoginUser
{
    return [[PersistentHelper sharedInstance]getStringForKey:LastLoginUserName];
}

- (void)setLastLoginUser:(NSString*)strLoginUser
{
    [[PersistentHelper sharedInstance]saveString:strLoginUser forKey:LastLoginUserName];
}


@end
