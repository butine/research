//
//  MainContentViewController.m
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "MainContentViewController.h"
#import "ECNetworkDataModel.h"
#import "STUtilities.h"
#import "ConstantVariables.h"
#import "ECContext.h"
#import "SplashViewController.h"
#import <DZNSegmentedControl/DZNSegmentedControl.h>
#import "MJRefresh.h"
#import "JSONKit.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MainContentDataModel.h"
#import "LendDetailViewController.h"
#import "LendDetailTableViewCell.h"
#import "BorrowDetailViewController.h"
#import "BorrowDetailTableViewCell.h"
#import "NewBorrowViewController.h"
#import "SummaryViewController.h"


@interface MainContentViewController () <MainContentDataModelDelegate>
{
    BOOL m_bInShow;
    
    dispatch_source_t m_timer;
}

@property (weak, nonatomic) IBOutlet DZNSegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIView *viewTag;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *dicCells;

@property (strong, nonatomic) MainContentDataModel *dataModel;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcBottom;
@end

@implementation MainContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"用户" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];

    _dataModel = [MainContentDataModel new];
    _dataModel.delegate = self;
    
    [self initCells];
    [self initViews];
    
    __weak __typeof(self)weakSelf = self;

    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestForUpdateData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestForUpdateData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)leftBarButtonAction:(id)sender
{
    [[ECContext sharedInstance].sideMenu presentLeftMenuViewController];
}

- (void)rightBarButtonAction:(id)sender
{
    SummaryViewController *viewController = [[SummaryViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)initCells
{
    _dicCells = [NSMutableDictionary dictionary];
}

- (void)initViews
{
    _segment.showsCount = NO;
    _segment.autoAdjustSelectionIndicatorWidth = NO;
    _segment.height = 44;
    [_segment setTitle:@"借款信息" forSegmentAtIndex:0];
    [_segment setTitle:@"我的借款" forSegmentAtIndex:1];
    [_segment setTitle:@"出借信息" forSegmentAtIndex:2];
    [_segment setTitle:@"我的放款" forSegmentAtIndex:3];
    [_segment setTitle:@"已完成" forSegmentAtIndex:4];
    
    [_segment addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [_segment setSelectedSegmentIndex:0];
    
    _lcBottom.constant = 60;
    _viewBottom.hidden = NO;
    
    self.title = [_segment titleForSegmentAtIndex:_segment.selectedSegmentIndex];
}

- (void)selectedSegment:(id)sender
{
    self.title = [_segment titleForSegmentAtIndex:_segment.selectedSegmentIndex];
    
    
    _lcBottom.constant = 0;
    _viewBottom.hidden = YES;
    
    switch (_segment.selectedSegmentIndex) {
        case MAIN_CONTENT_TAB_BORROW:
            [self st_setViewControlerInLoadingWithViewEdgeInstets:UIEdgeInsetsMake(64+44, 0, 0, 0)];
            [self requestForData];
            
            _lcBottom.constant = 60;
            _viewBottom.hidden = NO;
            break;
        case MAIN_CONTENT_TAB_BORROW_ING:
            [self st_setViewControlerInLoadingWithViewEdgeInstets:UIEdgeInsetsMake(64+44, 0, 0, 0)];
            [self requestForData];
            break;
        case MAIN_CONTENT_TAB_LEND:
            [self st_setViewControlerInLoadingWithViewEdgeInstets:UIEdgeInsetsMake(64+44, 0, 0, 0)];
            [self requestForData];
            break;
        case MAIN_CONTENT_TAB_LEND_ING:
            [self st_setViewControlerInLoadingWithViewEdgeInstets:UIEdgeInsetsMake(64+44, 0, 0, 0)];
            [self requestForData];
            break;
        case MAIN_CONTENT_TAB_DONE:
            [self st_setViewControlerInLoadingWithViewEdgeInstets:UIEdgeInsetsMake(64+44, 0, 0, 0)];
            [self requestForData];
            break;
        default:
            break;
    }
    
    [_tableView reloadData];
}

- (void)requestForData
{
    [self requestForUpdateData];
}

- (void)requestForUpdateData
{
    NSMutableDictionary *dicRequest = [NSMutableDictionary dictionary];
    dicRequest[@"Type"] = [NSString stringWithFormat:@"%ld", (long)_segment.selectedSegmentIndex];
    [_dataModel requestForData:dicRequest];
}

- (IBAction)onButtonBorrowClicked:(id)sender {
    NewBorrowViewController *viewController = [[NewBorrowViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - SplashFailedViewDelegate
- (void)st_reloadData
{
    [self requestForUpdateData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return _viewHeader;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return _viewFooter;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_segment.selectedSegmentIndex) {
        case MAIN_CONTENT_TAB_BORROW:
        {
            return [_dicCells[@"Borrow"]count];
        }
            break;
        case MAIN_CONTENT_TAB_BORROW_ING:
        {
            return [_dicCells[@"Borrowing"]count];
        }
            break;
        case MAIN_CONTENT_TAB_LEND:
        {
            return [_dicCells[@"Lend"]count];
        }
            break;
        case MAIN_CONTENT_TAB_LEND_ING:
        {
            return [_dicCells[@"Lending"]count];
        }
            break;
        case MAIN_CONTENT_TAB_DONE:
        {
            return [_dicCells[@"Done"]count];
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_segment.selectedSegmentIndex) {
        case MAIN_CONTENT_TAB_BORROW:
        {
            return _dicCells[@"Borrow"][indexPath.row];
        }
            break;
        case MAIN_CONTENT_TAB_BORROW_ING:
        {
            return _dicCells[@"Borrowing"][indexPath.row];
        }
            break;
        case MAIN_CONTENT_TAB_LEND:
        {
            return _dicCells[@"Lend"][indexPath.row];
        }
            break;
        case MAIN_CONTENT_TAB_LEND_ING:
        {
            return _dicCells[@"Lending"][indexPath.row];
        }
            break;
        case MAIN_CONTENT_TAB_DONE:
        {
            return _dicCells[@"Done"][indexPath.row];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    switch (_segment.selectedSegmentIndex) {
        case MAIN_CONTENT_TAB_BORROW:
        {
            BorrowDetailTableViewCell *cell = (BorrowDetailTableViewCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            NSDictionary *dicInfo = cell.dicInfo;
            BorrowDetailViewController *viewController = [[BorrowDetailViewController alloc]initWithNibName:nil bundle:nil];
            viewController.dicInfo = dicInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case MAIN_CONTENT_TAB_BORROW_ING:
        {
            BorrowDetailTableViewCell *cell = (BorrowDetailTableViewCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            NSDictionary *dicInfo = cell.dicInfo;
            BorrowDetailViewController *viewController = [[BorrowDetailViewController alloc]initWithNibName:nil bundle:nil];
            viewController.dicInfo = dicInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case MAIN_CONTENT_TAB_LEND:
        {
            LendDetailTableViewCell *cell = (LendDetailTableViewCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            NSDictionary *dicInfo = cell.dicInfo;
            LendDetailViewController *viewController = [[LendDetailViewController alloc]initWithNibName:nil bundle:nil];
            viewController.dicInfo = dicInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case MAIN_CONTENT_TAB_LEND_ING:
        {
            LendDetailTableViewCell *cell = (LendDetailTableViewCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            NSDictionary *dicInfo = cell.dicInfo;
            LendDetailViewController *viewController = [[LendDetailViewController alloc]initWithNibName:nil bundle:nil];
            viewController.dicInfo = dicInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case MAIN_CONTENT_TAB_DONE:
        {
            LendDetailTableViewCell *cell = (LendDetailTableViewCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            NSDictionary *dicInfo = cell.dicInfo;
            LendDetailViewController *viewController = [[LendDetailViewController alloc]initWithNibName:nil bundle:nil];
            viewController.dicInfo = dicInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - MainContentDataModelDelegate
- (void)dataHasBeenReached
{
    if ([_dataModel getborrowCells]) {
        _dicCells[@"Borrow"] = [_dataModel getborrowCells];
    }
    
    if ([_dataModel getBorrowingCells]) {
        _dicCells[@"Borrowing"] = [_dataModel getBorrowingCells];
    }
    
    if ([_dataModel getLendCells]) {
        _dicCells[@"Lend"] = [_dataModel getLendCells];
    }
    
    if ([_dataModel getLendingCells]) {
        _dicCells[@"Lending"] = [_dataModel getLendingCells];
    }
    
    if ([_dataModel getDoneCells]) {
        _dicCells[@"Done"] = [_dataModel getDoneCells];
    }
    
    [self st_setViewControlerLoadingSuccess];
    
    [_tableView.header endRefreshing];
    
    switch (_segment.selectedSegmentIndex) {
        case MAIN_CONTENT_TAB_BORROW:
        {
            [_tableView.footer noticeNoMoreData];

            [self st_setViewControlerLoadingSuccess];
        }
            break;
        case MAIN_CONTENT_TAB_BORROW_ING:
        {
            [_tableView.footer noticeNoMoreData];
            
            [self st_setViewControlerLoadingSuccess];
        }
            break;
        case MAIN_CONTENT_TAB_LEND:
        {
            [_tableView.footer noticeNoMoreData];
            
            [self st_setViewControlerLoadingSuccess];
        }
            break;
        case MAIN_CONTENT_TAB_LEND_ING:
        {
            [_tableView.footer noticeNoMoreData];
            
            [self st_setViewControlerLoadingSuccess];
        }
            break;
        case MAIN_CONTENT_TAB_DONE:
        {
            [_tableView.footer noticeNoMoreData];
            
            [self st_setViewControlerLoadingSuccess];
        }
            break;
        default:
            break;
    }
    
    [_tableView reloadData];
}

- (void)requestFailed:(NSError*)error
{
    [self st_setViewControlerLoadingFailed:error withViewEdgeInstets:UIEdgeInsetsMake(64+44, 0, 0, 0)];
    
}

#pragma mark - RESideMenuDelegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    [menuViewController viewWillAppear:YES];
}


@end
