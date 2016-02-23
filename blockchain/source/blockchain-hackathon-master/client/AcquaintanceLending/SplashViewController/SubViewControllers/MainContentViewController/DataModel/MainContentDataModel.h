//
//  MainContentDataModel.h
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainContentDataModelDelegate <NSObject>
@optional

- (void)dataHasBeenReached;
- (void)requestFailed:(NSError*)error;

@end

@interface MainContentDataModel : NSObject

@property (nonatomic, weak) id<MainContentDataModelDelegate> delegate;

- (void)requestForData:(NSDictionary*)dicRequest;

- (NSArray*)getborrowCells;
- (BOOL)isborrowHasMore;

- (NSArray*)getBorrowingCells;
- (BOOL)isBorrowingHasMore;

- (NSArray*)getLendCells;
- (BOOL)isLendHasMore;

- (NSArray*)getLendingCells;
- (BOOL)isLendingHasMore;

- (NSArray*)getDoneCells;
- (BOOL)isDoneHasMore;

@end
