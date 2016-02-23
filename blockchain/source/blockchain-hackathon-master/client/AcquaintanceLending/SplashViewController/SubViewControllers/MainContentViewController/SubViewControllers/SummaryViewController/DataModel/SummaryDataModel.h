//
//  SummaryDataModel.h
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SummaryDataModelDelegate <NSObject>
@optional

- (void)dataHasBeenReached:(NSDictionary*)dicInfo;
- (void)requestFailed:(NSError*)error;

@end

@interface SummaryDataModel : NSObject

@property (nonatomic, weak) id<SummaryDataModelDelegate> delegate;

- (void)requestForData;

@end
