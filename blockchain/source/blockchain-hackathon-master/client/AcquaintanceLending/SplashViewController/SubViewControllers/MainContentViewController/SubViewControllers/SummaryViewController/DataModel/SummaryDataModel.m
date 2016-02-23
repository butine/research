//
//  SummaryDataModel.m
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import "SummaryDataModel.h"
#import "ECNetworkDataModel+Operation.h"


@implementation SummaryDataModel

- (void)requestForData
{
    __weak __typeof(self) weakSelf = self;
    
    [[ECNetworkDataModel sharedInstance]requestForSummaryInfowWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf onDataReceived:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
            [weakSelf.delegate requestFailed:error];
        }
    }];
}


- (void)onDataReceived:(NSDictionary*)dicInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataHasBeenReached:)]) {
        [_delegate dataHasBeenReached:dicInfo];
    }
}

@end
