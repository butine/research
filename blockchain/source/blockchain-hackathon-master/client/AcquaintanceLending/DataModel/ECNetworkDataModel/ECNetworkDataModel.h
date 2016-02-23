//
//  ECNetworkDataModel.h
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

extern const NSString* ECSTATICURLADDRESS;

@interface ECNetworkDataModel : NSObject

+ (instancetype)sharedInstance;

- (void)helloWorldWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)simplePost:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)simpleGet:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)post:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)get:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)userPost:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)userGet:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (NSString*)getApiServerUrl:(NSString*)strService;
- (NSString*)getOperationServerUrl:(NSString*)strService;

- (void)showCommonAlertViewWithError:(NSError*)error title:(NSString*)strTitle;

- (void)userUploadFile:(NSString *)URLString filePath:(NSString*)strFilePath parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
