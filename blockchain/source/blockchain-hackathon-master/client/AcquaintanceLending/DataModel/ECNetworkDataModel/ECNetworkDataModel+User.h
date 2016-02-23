//
//  ECNetworkDataModel+User.h
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECNetworkDataModel.h"

@interface ECNetworkDataModel (User)

- (void)login:(NSString*)strLoginName password:(NSString*)strPassword withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getUserDetailWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)registerUser:(NSString*)strPhone realName:(NSString*)strRealName password:(NSString*)strPassword personalId:(NSString*)strPersonalId contracts:(NSArray*)arrayContacts withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)requestForRecharge:(NSString*)strAmount withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
