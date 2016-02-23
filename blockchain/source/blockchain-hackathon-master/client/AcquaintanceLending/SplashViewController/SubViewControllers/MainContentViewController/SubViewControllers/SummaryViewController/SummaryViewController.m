//
//  SummaryViewController.m
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import "SummaryViewController.h"
#import "STUtilities.h"
#import "SimpleHorizontalTableViewCell.h"
#import "SummaryDataModel.h"

@interface SummaryViewController () <SummaryDataModelDelegate, SplashFailedViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *dicCells;

@property (strong, nonatomic) SummaryDataModel *dataModel;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新的借款";
    [self initCells];
    _dataModel = [SummaryDataModel new];
    _dataModel.delegate = self;
    
    [self st_setViewControlerInLoading];
    
    [_dataModel requestForData];
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
}

- (void)resetCells:(NSDictionary*)dicInfo
{
    SimpleHorizontalTableViewCell *cellBorrow = [SimpleHorizontalTableViewCell viewFromNib];
    cellBorrow.labelInfo.text = @"借款总额";
    cellBorrow.labelValue.text = dicInfo[@"borrow"];
    [_dicCells[@"Info"]addObject:cellBorrow];
    
    SimpleHorizontalTableViewCell *cellProfit = [SimpleHorizontalTableViewCell viewFromNib];
    cellProfit.labelInfo.text = @"支付利息";
    cellProfit.labelValue.text = dicInfo[@"outCome"];
    [_dicCells[@"Info"]addObject:cellProfit];

    SimpleHorizontalTableViewCell *cellLend = [SimpleHorizontalTableViewCell viewFromNib];
    cellLend.labelInfo.text = @"放款总额";
    cellLend.labelValue.text = dicInfo[@"lend"];
    [_dicCells[@"Info"]addObject:cellLend];

    SimpleHorizontalTableViewCell *cellIncome = [SimpleHorizontalTableViewCell viewFromNib];
    cellIncome.labelInfo.text = @"获得利息";
    cellIncome.labelValue.text = dicInfo[@"inCome"];
    [_dicCells[@"Info"]addObject:cellIncome];

    SimpleHorizontalTableViewCell *cellCredit = [SimpleHorizontalTableViewCell viewFromNib];
    cellCredit.labelInfo.text = @"信用评分";
    cellCredit.labelValue.text = dicInfo[@"credit"];
    [_dicCells[@"Info"]addObject:cellCredit];
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
}

#pragma mark - SummaryDataModelDelegate
- (void)dataHasBeenReached:(NSDictionary*)dicInfo
{
    [self resetCells:dicInfo];
    [self st_setViewControlerLoadingSuccess];
    [_tableView reloadData];
}

- (void)requestFailed:(NSError*)error
{
    [self st_setViewControlerLoadingFailed:error];
}

#pragma mark - SplashFailedViewDelegate
- (void)st_reloadData
{
    [_dataModel requestForData];
}

@end
