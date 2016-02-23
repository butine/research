//
//  ConstantVariables.h
//  ST
//
//  Created by 李晓春 on 15/4/7.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
    MAIN_CONTENT_TAB_BORROW = 0,
    MAIN_CONTENT_TAB_BORROW_ING = 1,
    MAIN_CONTENT_TAB_LEND = 2,
    MAIN_CONTENT_TAB_LEND_ING = 3,
    MAIN_CONTENT_TAB_DONE = 4,
};

enum {
    ORDER_STATUS_CANCELED = 0,
    ORDER_STATUS_ORDERING = 1,
    ORDER_STATUS_GRABING = 2,
    ORDER_STATUS_RECEIVED = 3,
    ORDER_STATUS_TRANSFERING = 4,
    ORDER_STATUS_TRANSFERED = 5,
    ORDER_STATUS_ON = 6,
    ORDER_STATUS_OFF = 7,
    ORDER_STATUS_PAID = 8,
    ORDER_STATUS_DONE = 9,
};

enum {
    VEHICLE_LEVEL_COMFORTABLE = 0,
    VEHICLE_LEVEL_ECONOMICS = 1,
    VEHICLE_LEVEL_NEW_ENERGY = 2,
    VEHICLE_LEVEL_BUSINESS = 3,
    VEHICLE_LEVEL_LUXURY = 4,
};

extern NSString* UserHasLogined;
extern NSString* UserTokenData;
extern NSString* UserAuthId;
extern NSString* UserDisplayName;

extern NSString* LastLoginUserName;

extern NSString* LastLoginUserData;
extern NSString* LastLoginUserBackData;

extern NSString* DEVICE_TOKEN;

extern NSString* IS_OFF_DUTY;

extern NSString* ECErrorDomainResponseInvalidFormat;
extern const NSInteger ECErrorDomainCodeResponseInvalidFormat;



extern NSString* BaiduMapKey;
extern NSString* BaiduPushKey;
extern NSString* RongCloudKey;

extern NSString* ECMessageSaver;


