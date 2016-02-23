//
//  PersistentHelper.m
//  ST
//
//  Created by 李晓春 on 15/4/7.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import "PersistentHelper.h"
#import <SQPersist/SQPersist.h>

NSString* const PERSISTENT_HELPER_DATABASE = @"PersistentHelper.db";
NSString* const PERSISTENT_HELPER_VERSION_KEY = @"PersistentHelperVersionKey";
NSString* const PERSISTENT_HELPER_VERSION = @"1.0.0";

@interface PersistentHelperObject : SQPObject

@property (nonatomic, strong) NSString *strKey;
@property (nonatomic, strong) NSString *strValue;
@property (nonatomic, strong) NSNumber *nValue;
@property (nonatomic, strong) UIImage *imgValue;
@property (nonatomic, strong) NSData *dataValue;
@property (nonatomic, strong) NSDate *dateValue;

@end

@implementation PersistentHelperObject
@end


@interface PersistentHelper()

@property (nonatomic, strong) NSLock *lock;

@end

@implementation PersistentHelper

+ (instancetype)sharedInstance {
    static PersistentHelper* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PersistentHelper new];
        instance.lock = [NSLock new];
        [[SQPDatabase sharedInstance] setupDatabaseWithName:PERSISTENT_HELPER_DATABASE];
        
        //If we change the database structure, we need to rebuilt the database
        NSString *strVersion = [instance getStringForKey:PERSISTENT_HELPER_VERSION_KEY];
        if (!strVersion || ![strVersion isEqualToString:PERSISTENT_HELPER_VERSION]) {
            //Rebuilt the database
            [[SQPDatabase sharedInstance] removeDatabase];
            [[SQPDatabase sharedInstance] setupDatabaseWithName:PERSISTENT_HELPER_DATABASE];
            [instance saveString:PERSISTENT_HELPER_VERSION forKey:PERSISTENT_HELPER_VERSION_KEY];
        }
    });
    
    return instance;
}

- (void)saveString:(NSString*)strValue forKey:(NSString*)strKey;
{
    if (!strValue || !strKey) {
        return;
    }
    
    [_lock lock];
    
    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        object.strValue = strValue;
        [object SQPSaveEntity];
    }
    else {
        object = [PersistentHelperObject SQPCreateEntity];
        
        object.strKey = strKey;
        object.strValue = strValue;
        
        [object SQPSaveEntity];
    }
    
    [_lock unlock];
}


- (void)saveNumber:(NSNumber*)nValue forKey:(NSString*)strKey
{
    if (!nValue || !strKey) {
        return;
    }
    
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        object.nValue = nValue;
        [object SQPSaveEntity];
    }
    else {
        object = [PersistentHelperObject SQPCreateEntity];
        
        object.strKey = strKey;
        object.nValue = nValue;
        
        [object SQPSaveEntity];
    }
    
    [_lock unlock];
}

- (void)saveImage:(UIImage*)imgValue forKey:(NSString*)strKey
{
    if (!imgValue || !strKey) {
        return;
    }
    
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        object.imgValue = imgValue;
        [object SQPSaveEntity];
    }
    else {
        object = [PersistentHelperObject SQPCreateEntity];
        
        object.strKey = strKey;
        object.imgValue = imgValue;
        
        [object SQPSaveEntity];
    }
    
    [_lock unlock];
}

- (void)saveData:(NSData*)dValue forKey:(NSString*)strKey
{
    if (!dValue || !strKey) {
        return;
    }
    
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        object.dataValue = dValue;
        [object SQPSaveEntity];
    }
    else {
        object = [PersistentHelperObject SQPCreateEntity];
        
        object.strKey = strKey;
        object.dataValue = dValue;
        
        [object SQPSaveEntity];
    }
    
    [_lock unlock];
}


- (void)saveDate:(NSDate*)dValue forKey:(NSString*)strKey
{
    if (!dValue || !strKey) {
        return;
    }
    
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        object.dateValue = dValue;
        [object SQPSaveEntity];
    }
    else {
        object = [PersistentHelperObject SQPCreateEntity];
        
        object.strKey = strKey;
        object.dateValue = dValue;
        
        [object SQPSaveEntity];
    }
    
    [_lock unlock];
}

- (NSString*)getStringForKey:(NSString*)strKey;
{
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        NSString *strRet = object.strValue;
        
        [_lock unlock];
        
        return strRet;
    }
    else {
        [_lock unlock];

        return nil;
    }
}


- (NSNumber*)getNumberForKey:(NSString*)strKey
{
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        NSNumber *nRet = object.nValue;
        
        [_lock unlock];
        
        return nRet;
    }
    else {
        [_lock unlock];

        return nil;
    }
}

- (UIImage*)getImageForKey:(NSString*)strKey
{
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        UIImage *image = object.imgValue;
        
        [_lock unlock];
        
        return image;
    }
    else {
        [_lock unlock];

        return nil;
    }
}

- (NSData*)getDataForKey:(NSString*)strKey
{
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        NSData *data = object.dataValue;
        
        [_lock unlock];
        
        return data;
    }
    else {
        [_lock unlock];

        return nil;
    }
}

- (NSDate*)getDateForKey:(NSString*)strKey
{
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        NSDate *date = object.dateValue;

        [_lock unlock];
        
        return date;
    }
    else {
        [_lock unlock];

        return nil;
    }
}

- (void)removeOjectForKey:(NSString*)strKey
{
    [_lock lock];

    PersistentHelperObject *object = [PersistentHelperObject SQPFetchOneByAttribut:@"strKey" withValue:strKey];
    if (object) {
        object.deleteObject = YES;
        [object SQPSaveEntity];
    }
    
    [_lock unlock];
}

@end
