//
//  ECNetworkDataModel+User.m
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "ECNetworkDataModel+User.h"
#import "STUtilities.h"
#import "ConstantVariables.h"
#import "ECContext.h"

@implementation ECNetworkDataModel (User)

- (void)login:(NSString*)strLoginName password:(NSString*)strPassword withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"phone"] = strLoginName;
    dicParams[@"password"] = strPassword;
    
    [self post:[self getApiServerUrl:@"users/logon"] parameters:dicParams withSuccess:success failure:failure];
}

- (void)getUserDetailWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *strPath = [NSString stringWithFormat:@"users/%@", [ECContext sharedInstance].userInfo[@"token"]];
    [self userGet:[self getApiServerUrl:strPath] parameters:nil withSuccess:success failure:failure];
}

- (void)registerUser:(NSString*)strPhone realName:(NSString*)strRealName password:(NSString*)strPassword personalId:(NSString*)strPersonalId contracts:(NSArray*)arrayContacts withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"name"] = strRealName;
    dicParams[@"phone"] = strPhone;
    dicParams[@"idCard"] = strPersonalId;
    dicParams[@"password"] = strPassword;
    dicParams[@"contacts"] = arrayContacts;
    
    [self post:[self getApiServerUrl:@"users"] parameters:dicParams withSuccess:success failure:failure];
}

- (void)requestForRecharge:(NSString*)strAmount withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"balance"] = strAmount;
    
    NSString *strPath = [NSString stringWithFormat:@"users/%@/recharge", [ECContext sharedInstance].userInfo[@"token"]];

    [self post:[self getApiServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}


@end
