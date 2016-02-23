//
//  ECNetworkDataModel+Operation.m
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "ECNetworkDataModel+Operation.h"
#import "ECContext.h"

@implementation ECNetworkDataModel (Operation)

- (void)getBorrowInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"status"] = @"INIT";
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade/as-borrower", [ECContext sharedInstance].userInfo[@"token"]];
    [self userGet:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)getBorrowingInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"status"] = @"ING";
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade/as-borrower", [ECContext sharedInstance].userInfo[@"token"]];
    [self userGet:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)getLendInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"status"] = @"INIT";
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade/as-lender", [ECContext sharedInstance].userInfo[@"token"]];
    [self userGet:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)getLendingInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"status"] = @"ING";
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade/as-lender", [ECContext sharedInstance].userInfo[@"token"]];
    [self userGet:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)getDoneInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade", [ECContext sharedInstance].userInfo[@"token"]];
    [self userGet:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)requestForNewBorrow:(NSString*)strAmount profit:(NSString*)strProfit repayDate:(NSString*)strRepayDate withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"amount"] = strAmount;
    dicParams[@"interest"] = strProfit;
    dicParams[@"repayDate"] = strRepayDate;
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade", [ECContext sharedInstance].userInfo[@"token"]];
    [self userPost:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)requestForLend:(NSString*)strOrder withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"status"] = @"ING";
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade/%@", [ECContext sharedInstance].userInfo[@"token"], strOrder];
    [self userPost:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)requestForRepay:(NSString*)strOrder withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"status"] = @"COM";
    
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade/%@", [ECContext sharedInstance].userInfo[@"token"], strOrder];
    [self userPost:[self getOperationServerUrl:strPath] parameters:dicParams withSuccess:success failure:failure];
}

- (void)requestForSummaryInfowWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *strPath = [NSString stringWithFormat:@"user/%@/trade/summary", [ECContext sharedInstance].userInfo[@"token"]];
    
    [self userGet:[self getOperationServerUrl:strPath] parameters:nil withSuccess:success failure:failure];
}

- (void)requestForHashInfo:(NSString*)strHashCode withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
    dicParams[@"hash"] = strHashCode;
    
    [self get:[self getOperationServerUrl:@"/api/trade-by-hash"] parameters:dicParams withSuccess:success failure:failure];
}


@end
