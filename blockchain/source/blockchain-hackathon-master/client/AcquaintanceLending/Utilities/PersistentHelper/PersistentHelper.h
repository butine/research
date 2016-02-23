//
//  PersistentHelper.h
//  ST
//
//  Created by 李晓春 on 15/4/7.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PersistentHelper : NSObject

+ (instancetype)sharedInstance;

- (void)saveString:(NSString*)strValue forKey:(NSString*)strKey;
- (void)saveNumber:(NSNumber*)nValue forKey:(NSString*)strKey;
- (void)saveImage:(UIImage*)imgValue forKey:(NSString*)strKey;
- (void)saveData:(NSData*)dValue forKey:(NSString*)strKey;
- (void)saveDate:(NSDate*)dValue forKey:(NSString*)strKey;

- (NSString*)getStringForKey:(NSString*)strKey;
- (NSNumber*)getNumberForKey:(NSString*)strKey;
- (UIImage*)getImageForKey:(NSString*)strKey;
- (NSData*)getDataForKey:(NSString*)strKey;
- (NSDate*)getDateForKey:(NSString*)strKey;

- (void)removeOjectForKey:(NSString*)strKey;

@end
