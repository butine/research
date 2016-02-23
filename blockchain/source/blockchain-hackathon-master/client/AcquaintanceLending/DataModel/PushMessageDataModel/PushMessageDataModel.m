//
//  PushMessageDataModel.m
//  ECarDriver
//
//  Created by 李晓春 on 15/10/1.
//  Copyright © 2015年 upluscar. All rights reserved.
//

#import "PushMessageDataModel.h"
#import "ConstantVariables.h"
#import "MainContentViewController.h"
#import "ECContext.h"
#import "JSONKit.h"

@implementation PushMessageDataModel

+ (instancetype)sharedInstance {
    static PushMessageDataModel* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PushMessageDataModel new];
    });
    
    return instance;
}

- (void)dealWithPushMessage:(NSDictionary*)dicUserInfo
{

}

@end
