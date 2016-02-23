//
//  BorrowDetailViewController.m
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import "BorrowDetailViewController.h"
#import "STUtilities.h"
#import "SimpleHorizontalTableViewCell.h"
#import "ECNetworkDataModel+Operation.h"
#import <MBProgressHUDExtensions/UIViewController+MBProgressHUD.h>
#import "ECContext.h"
#import <Toast/UIView+Toast.h>

@interface BorrowDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) NSMutableDictionary *dicCells;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcBottom;

@end

@implementation BorrowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([_dicInfo[@"status"]isEqualToString:@"INIT"]) {
        self.title = @"借款信息";
        if (_bHashMode) {
            self.title = @"借款信息校验";
        }
        _lcBottom.constant = 0;
        _viewBottom.hidden = YES;
    }
    else {
        self.title = @"借款信息";
        if (_bHashMode) {
            self.title = @"借款信息校验";
        }
        _lcBottom.constant = 60;
        _viewBottom.hidden = NO;
    }
    
    [self initCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initCells
{
    _dicCells = [NSMutableDictionary dictionary];
    _dicCells[@"Info"] = [NSMutableArray array];
    
    SimpleHorizontalTableViewCell *cellBorrowName = [SimpleHorizontalTableViewCell viewFromNib];
    cellBorrowName.labelInfo.text = @"借款人";
    cellBorrowName.labelValue.text = _dicInfo[@"borrowerUser"][@"name"];
    [_dicCells[@"Info"] addObject:cellBorrowName];
    
    if (![_dicInfo[@"status"]isEqualToString:@"INIT"]) {
        SimpleHorizontalTableViewCell *cellLender = [SimpleHorizontalTableViewCell viewFromNib];
        cellLender.labelInfo.text = @"出借人";
        cellLender.labelValue.text = _dicInfo[@"lenderUser"][@"name"];
        [_dicCells[@"Info"] addObject:cellLender];
    }
    
    SimpleHorizontalTableViewCell *cellAmount = [SimpleHorizontalTableViewCell viewFromNib];
    cellAmount.labelInfo.text = @"借款总额";
    cellAmount.labelValue.text = _dicInfo[@"amount"];
    [_dicCells[@"Info"] addObject:cellAmount];
    
//    SimpleHorizontalTableViewCell *cellCreateTime = [SimpleHorizontalTableViewCell viewFromNib];
//    cellCreateTime.labelInfo.text = @"借款时间";
//    cellCreateTime.labelValue.text = [[BasicUtility sharedInstance]defaultTimeForTimeInterval:[_dicInfo[@"createTime"] doubleValue]];
//    [_dicCells[@"Info"] addObject:cellCreateTime];

    SimpleHorizontalTableViewCell *cellRepayTime = [SimpleHorizontalTableViewCell viewFromNib];
    cellRepayTime.labelInfo.text = @"承诺还款时间";
    cellRepayTime.labelValue.text = [[BasicUtility sharedInstance]defaultTimeForTimeInterval:[_dicInfo[@"repayDate"] doubleValue]];
    [_dicCells[@"Info"] addObject:cellRepayTime];
    
    SimpleHorizontalTableViewCell *cellRate = [SimpleHorizontalTableViewCell viewFromNib];
    cellRate.labelInfo.text = @"借款利率";
    cellRate.labelValue.text = [NSString stringWithFormat:@"%.2f%%", [_dicInfo[@"interest"]doubleValue]/[_dicInfo[@"amount"]doubleValue] * 100];
    [_dicCells[@"Info"] addObject:cellRate];
    
    SimpleHorizontalTableViewCell *cellProfit = [SimpleHorizontalTableViewCell viewFromNib];
    cellProfit.labelInfo.text = @"利息";
    cellProfit.labelValue.text = _dicInfo[@"interest"];
    [_dicCells[@"Info"] addObject:cellProfit];
    
    if (!_bHashMode) {
        if ([_dicInfo[@"borrowerHash"] length]) {
            SimpleHorizontalTableViewCell *cellHash = [SimpleHorizontalTableViewCell viewFromNib];
            cellHash.labelInfo.text = @"HashCode";
            cellHash.labelValue.text = _dicInfo[@"borrowerHash"];
            cellHash.labelValue.numberOfLines = 0;
            [cellHash setHeight:80];
            [_dicCells[@"Info"] addObject:cellHash];
        }
    }
}

- (IBAction)onButtonRepayClicked:(id)sender {
    [self showHUD];
    [[ECNetworkDataModel sharedInstance]requestForRepay:_dicInfo[@"tradeNo"] withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        
        [self.navigationController popViewControllerAnimated:YES];
        [[ECContext sharedInstance].vcMainContent.view makeToast:@"还款成功" duration:2.0 position:CSToastPositionCenter];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        [[ECNetworkDataModel sharedInstance]showCommonAlertViewWithError:error title:@"还款失败"];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dicCells.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dicCells[@"Info"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _dicCells[@"Info"][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    SimpleHorizontalTableViewCell *cellHash = (SimpleHorizontalTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cellHash.labelInfo.text isEqualToString:@"HashCode"]) {
        [self showHUD];
        [[ECNetworkDataModel sharedInstance]requestForHashInfo:cellHash.labelValue.text withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideHUD];
            BorrowDetailViewController *viewController = [[BorrowDetailViewController alloc]initWithNibName:nil bundle:nil];
            viewController.dicInfo = responseObject;
            viewController.bHashMode = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self hideHUD];
        }];
    }
}

@end
