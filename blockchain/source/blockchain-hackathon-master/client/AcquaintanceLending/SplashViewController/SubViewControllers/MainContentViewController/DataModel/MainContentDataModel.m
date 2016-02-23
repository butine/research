//
//  MainContentDataModel.m
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import "MainContentDataModel.h"
#import "ECNetworkDataModel+Operation.h"
#import "ConstantVariables.h"
#import "SimpleHorizontalTableViewCell.h"
#import "STUtilities.h"
#import "BorrowDetailTableViewCell.h"
#import "LendDetailTableViewCell.h"

@interface MainContentDataModel ()
{
    BOOL m_bBorrowHasMore;
    BOOL m_bBorrowingHasMore;
    BOOL m_bLendHasMore;
    BOOL m_bLendingHasMore;
    BOOL m_bDoneHasMore;
}

@property (strong, nonatomic) NSMutableDictionary *dicInfo;

@property (strong, nonatomic) NSMutableArray *arrayBorrow;
@property (strong, nonatomic) NSMutableArray *arrayBorrowing;
@property (strong, nonatomic) NSMutableArray *arrayLend;
@property (strong, nonatomic) NSMutableArray *arrayLending;
@property (strong, nonatomic) NSMutableArray *arrayDone;

@end

@implementation MainContentDataModel


- (void)requestForData:(NSDictionary*)dicRequest
{
    __weak __typeof(self)weakSelf = self;
    
    switch ([dicRequest[@"Type"] integerValue]) {
        case MAIN_CONTENT_TAB_BORROW:
        {
            [[ECNetworkDataModel sharedInstance]getBorrowInfoWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf onDataReceived:responseObject withRequest:dicRequest];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
                    [weakSelf.delegate requestFailed:error];
                }
            }];
        }
            break;
        case MAIN_CONTENT_TAB_BORROW_ING:
        {
            [[ECNetworkDataModel sharedInstance]getBorrowingInfoWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf onDataReceived:responseObject withRequest:dicRequest];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
                    [weakSelf.delegate requestFailed:error];
                }
            }];
        }
            break;
        case MAIN_CONTENT_TAB_LEND:
        {
            [[ECNetworkDataModel sharedInstance]getLendInfoWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf onDataReceived:responseObject withRequest:dicRequest];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
                    [weakSelf.delegate requestFailed:error];
                }
            }];
        }
            break;
        case MAIN_CONTENT_TAB_LEND_ING:
        {
            [[ECNetworkDataModel sharedInstance]getLendingInfoWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf onDataReceived:responseObject withRequest:dicRequest];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
                    [weakSelf.delegate requestFailed:error];
                }
            }];
        }
            break;
        case MAIN_CONTENT_TAB_DONE:
        {
            [[ECNetworkDataModel sharedInstance]getDoneInfoWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf onDataReceived:responseObject withRequest:dicRequest];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
                    [weakSelf.delegate requestFailed:error];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)onDataReceived:(NSDictionary*)dicInfo withRequest:(NSDictionary*)dicRequest
{
    switch ([dicRequest[@"Type"] integerValue]) {
        case MAIN_CONTENT_TAB_BORROW:
            [self dealWithBorrowInfo:dicInfo withRequest:dicRequest];
            break;
        case MAIN_CONTENT_TAB_BORROW_ING:
            [self dealWithBorrowingInfo:dicInfo withRequest:dicRequest];
            break;
        case MAIN_CONTENT_TAB_LEND:
            [self dealWithLendInfo:dicInfo withRequest:dicRequest];
            break;
        case MAIN_CONTENT_TAB_LEND_ING:
            [self dealWithLendingInfo:dicInfo withRequest:dicRequest];
            break;
        case MAIN_CONTENT_TAB_DONE:
            [self dealWithDoneInfo:dicInfo withRequest:dicRequest];
            break;
        default:
            break;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(dataHasBeenReached)]) {
        [_delegate dataHasBeenReached];
    }
}

- (void)dealWithBorrowInfo:(NSDictionary*)dicResponse withRequest:(NSDictionary*)dicRequest
{
    NSMutableArray *arrayCellsTemp = _arrayBorrow;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        _arrayBorrow = [NSMutableArray array];
    }
    
    for (NSDictionary* dicItem in dicResponse[@"data"]) {
        BorrowDetailTableViewCell *cell = [BorrowDetailTableViewCell viewFromNib];
        [self setBorrowCell:cell withInfo:dicItem];
        [_arrayBorrow addObject:cell];
    }
    
    m_bBorrowHasMore = NO;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        [arrayCellsTemp removeAllObjects];
    }
}

- (void)dealWithBorrowingInfo:(NSDictionary*)dicResponse withRequest:(NSDictionary*)dicRequest
{
    NSMutableArray *arrayCellsTemp = _arrayBorrowing;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        _arrayBorrowing = [NSMutableArray array];
    }
    
    for (NSDictionary* dicItem in dicResponse[@"data"]) {
        BorrowDetailTableViewCell *cell = [BorrowDetailTableViewCell viewFromNib];
        [self setBorrowingCell:cell withInfo:dicItem];
        [_arrayBorrowing addObject:cell];
    }
    
    m_bBorrowingHasMore = NO;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        [arrayCellsTemp removeAllObjects];
    }
}

- (void)dealWithLendInfo:(NSDictionary*)dicResponse withRequest:(NSDictionary*)dicRequest
{
    NSMutableArray *arrayCellsTemp = _arrayLend;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        _arrayLend = [NSMutableArray array];
    }
    
    for (NSDictionary* dicItem in dicResponse[@"data"]) {
        LendDetailTableViewCell *cell = [LendDetailTableViewCell viewFromNib];
        [self setLendCell:cell withInfo:dicItem];
        [_arrayLend addObject:cell];
    }
    
    m_bLendHasMore = NO;

    if ([dicRequest[@"From"] intValue] == 0) {
        [arrayCellsTemp removeAllObjects];
    }
}

- (void)dealWithLendingInfo:(NSDictionary*)dicResponse withRequest:(NSDictionary*)dicRequest
{
    NSMutableArray *arrayCellsTemp = _arrayLending;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        _arrayLending = [NSMutableArray array];
    }
    
    for (NSDictionary* dicItem in dicResponse[@"data"]) {
        LendDetailTableViewCell *cell = [LendDetailTableViewCell viewFromNib];
        [self setLendingCell:cell withInfo:dicItem];
        [_arrayLending addObject:cell];
    }
    
    m_bLendingHasMore = NO;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        [arrayCellsTemp removeAllObjects];
    }
}

- (void)dealWithDoneInfo:(NSDictionary*)dicResponse withRequest:(NSDictionary*)dicRequest
{
    NSMutableArray *arrayCellsTemp = _arrayDone;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        _arrayDone = [NSMutableArray array];
    }
    
    for (NSDictionary* dicItem in dicResponse[@"data"]) {
        LendDetailTableViewCell *cell = [LendDetailTableViewCell viewFromNib];
        [self setDoneCell:cell withInfo:dicItem];
        [_arrayDone addObject:cell];
    }
    
    m_bDoneHasMore = NO;
    
    if ([dicRequest[@"From"] intValue] == 0) {
        [arrayCellsTemp removeAllObjects];
    }
}

- (NSArray*)getborrowCells
{
    return _arrayBorrow;
}

- (BOOL)isborrowHasMore
{
    return m_bBorrowHasMore;
}


- (NSArray*)getBorrowingCells
{
    return _arrayBorrowing;
}

- (BOOL)isBorrowingHasMore
{
    return m_bBorrowingHasMore;
}

- (NSArray*)getLendCells
{
    return _arrayLend;
}

- (BOOL)isLendHasMore
{
    return m_bLendHasMore;
}


- (NSArray*)getLendingCells
{
    return _arrayLending;
}

- (BOOL)isLendingHasMore
{
    return m_bLendingHasMore;
}

- (NSArray*)getDoneCells
{
    return _arrayDone;
}

- (BOOL)isDoneHasMore
{
    return m_bDoneHasMore;
}

- (void)setBorrowCell:(BorrowDetailTableViewCell*)cell withInfo:(NSDictionary*)dicInfo
{
    cell.labelStatus.text = @"申请中";
    cell.labelAmount.text = dicInfo[@"amount"];
    cell.labelRate.text = [NSString stringWithFormat:@"%.2f%%", [dicInfo[@"interest"]doubleValue]/[dicInfo[@"amount"]doubleValue] * 100];
    cell.labelProfit.text = dicInfo[@"interest"];
    cell.labelRepayDate.text = [[BasicUtility sharedInstance]defaultTimeForTimeInterval:[dicInfo[@"repayDate"] doubleValue]];
    cell.dicInfo = dicInfo;
}

- (void)setBorrowingCell:(BorrowDetailTableViewCell*)cell withInfo:(NSDictionary*)dicInfo
{
    cell.labelStatus.text = @"已借入";
    cell.labelAmount.text = dicInfo[@"amount"];
    cell.labelRate.text = [NSString stringWithFormat:@"%.2f%%", [dicInfo[@"interest"]doubleValue]/[dicInfo[@"amount"]doubleValue] * 100];
    cell.labelProfit.text = dicInfo[@"interest"];
    cell.labelRepayDate.text = [[BasicUtility sharedInstance]defaultTimeForTimeInterval:[dicInfo[@"repayDate"] doubleValue]];
    cell.dicInfo = dicInfo;
}

- (void)setLendCell:(LendDetailTableViewCell*)cell withInfo:(NSDictionary*)dicInfo
{
    cell.labelAmount.text = dicInfo[@"amount"];
    cell.labelRate.text = [NSString stringWithFormat:@"%.2f%%", [dicInfo[@"interest"]doubleValue]/[dicInfo[@"amount"]doubleValue] * 100];
    cell.labelProfit.text = dicInfo[@"interest"];
    cell.labelRepayDate.text = [[BasicUtility sharedInstance]defaultTimeForTimeInterval:[dicInfo[@"repayDate"] doubleValue]];
    cell.dicInfo = dicInfo;
}

- (void)setLendingCell:(LendDetailTableViewCell*)cell withInfo:(NSDictionary*)dicInfo
{
    cell.labelAmount.text = dicInfo[@"amount"];
    cell.labelRate.text = [NSString stringWithFormat:@"%.2f%%", [dicInfo[@"interest"]doubleValue]/[dicInfo[@"amount"]doubleValue] * 100];
    cell.labelProfit.text = dicInfo[@"interest"];
    cell.labelRepayDate.text = [[BasicUtility sharedInstance]defaultTimeForTimeInterval:[dicInfo[@"repayDate"] doubleValue]];
    cell.dicInfo = dicInfo;
}

- (void)setDoneCell:(LendDetailTableViewCell*)cell withInfo:(NSDictionary*)dicInfo
{
    cell.labelAmount.text = dicInfo[@"amount"];
    cell.labelRate.text = [NSString stringWithFormat:@"%.2f%%", [dicInfo[@"interest"]doubleValue]/[dicInfo[@"amount"]doubleValue] * 100];
    cell.labelProfit.text = dicInfo[@"interest"];
    cell.labelRepayDate.text = [[BasicUtility sharedInstance]defaultTimeForTimeInterval:[dicInfo[@"repayDate"] doubleValue]];
    cell.dicInfo = dicInfo;
}
@end
