//
//  ECContext.h
//  ECarDriver
//
//  Created by sola on 15/8/24.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RESideMenu/RESideMenu.h>

@interface ECContext : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSDictionary* userInfo;
@property (nonatomic, strong) RESideMenu* sideMenu;
@property (nonatomic, strong) UIViewController* vcMain;
@property (nonatomic, strong) UIViewController* vcMainContent;
@property (nonatomic, strong) UIViewController* vcSplash;

- (NSString*)getLastLoginUser;
- (void)setLastLoginUser:(NSString*)strLoginUser;



@end
