//
//  PushMessageDataModel.h
//  ECarDriver
//
//  Created by 李晓春 on 15/10/1.
//  Copyright © 2015年 upluscar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessageDataModel : NSObject

+ (instancetype)sharedInstance;

- (void)dealWithPushMessage:(NSDictionary*)dicUserInfo;

@end
