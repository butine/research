//
//  ECNetworkDataModel.m
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "ECNetworkDataModel.h"
#import "STUtilities.h"
#import "JSONKit.h"
#import "ConstantVariables.h"
#import "ECContext.h"
#import "SplashViewController.h"

const NSString* ECURLADDRESS = @"http://192.168.0.43:8080";
const NSString* ECOPERATIONURLADDRESS = @"http://192.168.0.43:8080";


enum {
    STATUS_OK = 0,
    STRATUS_TOKEN_INVALID = 1,
};

@implementation ECNetworkDataModel

+ (instancetype)sharedInstance {
    static ECNetworkDataModel* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ECNetworkDataModel new];
    });
    
    return instance;
}

- (void)helloWorldWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    dicParam[@"city"] = @"广州";
    dicParam[@"token"] = @"5j1znBVAsnSf5xQyNQyq";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager GET:@"http://www.pm25.in/api/querys/station_names.json" parameters:dicParam success:success failure:failure];
}

- (void)simplePost:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:dicParams success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id idResponseObject = [[BasicUtility sharedInstance]changeObjectFormat:[strResponse objectFromJSONString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(operation, idResponseObject);
        });
    } failure:failure];
}

- (void)simpleGet:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLString parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id idResponseObject = [[BasicUtility sharedInstance]changeObjectFormat:[strResponse objectFromJSONString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(operation, idResponseObject);
        });
    } failure:failure];
}

- (void)post:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:URLString parameters:dicParams success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id idResponseObject = [[BasicUtility sharedInstance]changeObjectFormat:[strResponse objectFromJSONString]];
        if ([idResponseObject isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(operation, idResponseObject);
            });
        }
        else {
            NSMutableDictionary *dicUserInfo = [NSMutableDictionary dictionary];
            dicUserInfo[@"rawData"] = responseObject;
            dicUserInfo[@"rawResponse"] = strResponse;
            NSError *error = [NSError errorWithDomain:ECErrorDomainResponseInvalidFormat code:ECErrorDomainCodeResponseInvalidFormat userInfo:dicUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(operation, error);
            });
        }
    } failure:failure];
}

- (void)get:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager GET:URLString parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id idResponseObject = [[BasicUtility sharedInstance]changeObjectFormat:[strResponse objectFromJSONString]];
        if ([idResponseObject isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(operation, idResponseObject);
            });
        }
        else {
            NSMutableDictionary *dicUserInfo = [NSMutableDictionary dictionary];
            dicUserInfo[@"rawData"] = responseObject;
            dicUserInfo[@"rawResponse"] = strResponse;
            NSError *error = [NSError errorWithDomain:ECErrorDomainResponseInvalidFormat code:ECErrorDomainCodeResponseInvalidFormat userInfo:dicUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(operation, error);
            });
        }
    } failure:failure];
}

- (void)userPost:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ECContext sharedInstance].userInfo[@"token"] forHTTPHeaderField:@"userToken"];

    [manager POST:URLString parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id idResponseObject = [[BasicUtility sharedInstance]changeObjectFormat:[strResponse objectFromJSONString]];
        if ([idResponseObject isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(operation, idResponseObject);
            });
        }
        else {
            NSMutableDictionary *dicUserInfo = [NSMutableDictionary dictionary];
            dicUserInfo[@"rawData"] = responseObject;
            dicUserInfo[@"rawResponse"] = strResponse;
            NSError *error = [NSError errorWithDomain:ECErrorDomainResponseInvalidFormat code:ECErrorDomainCodeResponseInvalidFormat userInfo:dicUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(operation, error);
            });
        }
    } failure:failure];
}

- (void)userGet:(NSString *)URLString parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ECContext sharedInstance].userInfo[@"token"] forHTTPHeaderField:@"userToken"];

    [manager GET:URLString parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id idResponseObject = [[BasicUtility sharedInstance]changeObjectFormat:[strResponse objectFromJSONString]];
        if ([idResponseObject isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(operation, idResponseObject);
            });
        }
        else {
            NSMutableDictionary *dicUserInfo = [NSMutableDictionary dictionary];
            dicUserInfo[@"rawData"] = responseObject;
            dicUserInfo[@"rawResponse"] = strResponse;
            NSError *error = [NSError errorWithDomain:ECErrorDomainResponseInvalidFormat code:ECErrorDomainCodeResponseInvalidFormat userInfo:dicUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(operation, error);
            });
        }
    } failure:failure];
}

- (NSString*)getApiServerUrl:(NSString*)strService
{
    NSString *strRet = [NSString stringWithFormat:@"%@/%@", ECURLADDRESS, strService];
    return strRet;
}

- (NSString*)getOperationServerUrl:(NSString*)strService
{
    NSString *strRet = [NSString stringWithFormat:@"%@/%@", ECOPERATIONURLADDRESS, strService];
    return strRet;
}

- (void)showCommonAlertViewWithError:(NSError*)error title:(NSString*)strTitle
{
    if (error.code == ECErrorDomainCodeResponseInvalidFormat) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:strTitle message:NSLocalizedString(@"global_alert_error_unknown", @"未知错误") delegate:nil cancelButtonTitle:NSLocalizedString(@"global_message_ok", @"确认") otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSString *strMessage = NSLocalizedString(@"global_alert_error_network_message", @"");
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] isKindOfClass:[NSData class]]) {
            NSString *strError = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *dicError = [strError objectFromJSONString];
            if ([dicError isKindOfClass:[NSDictionary class]] && dicError[@"error"]) {
                strMessage = dicError[@"error"];
            }
        }

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:strTitle.length?strTitle: NSLocalizedString(@"global_alert_error_network", @"") message:strMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"global_message_ok", @"确认") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)userUploadFile:(NSString *)URLString filePath:(NSString*)strFilePath parameters:(NSDictionary*)dicParams withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicTemp = [dicParams mutableCopy] ? : [NSMutableDictionary dictionary];
    dicTemp[@"token"] = [ECContext sharedInstance].userInfo[@"token"];
    dicParams = dicTemp;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    for (NSString *key in dicTemp.allKeys) {
        [manager.requestSerializer setValue:dicTemp[key] forHTTPHeaderField:key];
    }
    
    [manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = [NSData dataWithContentsOfFile:strFilePath];
        
        [formData appendPartWithFileData:imageData name:@"myfuserIconiles" fileName:@"userIcon.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id idResponseObject = [[BasicUtility sharedInstance]changeObjectFormat:[strResponse objectFromJSONString]];
        if ([idResponseObject isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(operation, idResponseObject);
            });
        }
        else {
            NSMutableDictionary *dicUserInfo = [NSMutableDictionary dictionary];
            dicUserInfo[@"rawData"] = responseObject;
            dicUserInfo[@"rawResponse"] = strResponse;
            NSError *error = [NSError errorWithDomain:ECErrorDomainResponseInvalidFormat code:ECErrorDomainCodeResponseInvalidFormat userInfo:dicUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(operation, error);
            });
        }
    } failure:failure];
}

@end
