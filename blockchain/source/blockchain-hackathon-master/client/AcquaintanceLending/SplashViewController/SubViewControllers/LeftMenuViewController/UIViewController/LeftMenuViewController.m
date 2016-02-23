//
//  LeftMenuViewController.m
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "STUtilities.h"
#import "TextFieldWithTipTableViewCell.h"
#import "ECContext.h"
#import "ECButtonFooterView.h"
#import "ECNetworkDataModel+User.h"
#import "ConstantVariables.h"
#import "TNCryptor.h"
#import "SplashViewController.h"
#import <MBProgressHUDExtensions/UIViewController+MBProgressHUD.h>
#import <AddressBook/AddressBook.h>
#import "JSONKit.h"
#import "LeftMenuSectionHeaderView.h"
#import "SimpleHorizontalTableViewCell.h"

@interface LeftMenuViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *dicCells;

@property (strong, nonatomic) LeftMenuSectionHeaderView *viewHeader;
@property (strong, nonatomic) ECButtonFooterView *viewFooter;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    [self initCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak __typeof(self) weakSelf = self;
    _viewHeader.textAmount.text = @"";
    [[ECNetworkDataModel sharedInstance]getUserDetailWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dicInfo = responseObject;
        dicInfo[@"token"] = dicInfo[@"id"];
        [ECContext sharedInstance].userInfo = dicInfo;
        
        [self resetCells];
        [_tableView reloadData];
        [weakSelf hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUD];
    }];
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
    
    
    [self resetCells];
//    SimpleHorizontalTableViewCell *cellBlack = [SimpleHorizontalTableViewCell viewFromNib];
//    cellBlack.labelInfo.text = @"黑名单";
//    cellBlack.labelValue.text = @"";
//    cellBlack.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    [_dicCells[@"Info"] addObject:cellPhone];
}

- (void)resetCells
{
    [_dicCells[@"Info"] removeAllObjects];
    
    NSDictionary *dicInfo = [ECContext sharedInstance].userInfo;
    
    SimpleHorizontalTableViewCell *cellName = [SimpleHorizontalTableViewCell viewFromNib];
    cellName.labelInfo.text = @"姓名";
    cellName.labelValue.text = dicInfo[@"name"];
    cellName.lcTail.constant = 120;
    cellName.bSetTail = YES;
    [_dicCells[@"Info"] addObject:cellName];
    
    SimpleHorizontalTableViewCell *cellAmount = [SimpleHorizontalTableViewCell viewFromNib];
    cellAmount.labelInfo.text = @"持有金额";
    cellAmount.labelValue.text = dicInfo[@"amount"];
    cellAmount.lcTail.constant = 120;
    cellAmount.bSetTail = YES;
    [_dicCells[@"Info"] addObject:cellAmount];
    
    
    SimpleHorizontalTableViewCell *cellPhone = [SimpleHorizontalTableViewCell viewFromNib];
    cellPhone.labelInfo.text = @"手机号";
    cellPhone.labelValue.text = dicInfo[@"phone"];
    cellPhone.lcTail.constant = 120;
    cellPhone.bSetTail = YES;
    [_dicCells[@"Info"] addObject:cellPhone];
}

- (void)initViews
{
    _viewHeader = [LeftMenuSectionHeaderView viewFromNib];
    _viewHeader.textAmount.delegate = self;
    [_viewHeader.btnRecharge addTarget:self action:@selector(onButtonRechargeClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _viewFooter = [ECButtonFooterView viewFromNib];
    [_viewFooter.btnMain addTarget:self action:@selector(onButtonLogoutClicked) forControlEvents:UIControlEventTouchUpInside];
    [[BasicUtility sharedInstance]setButton:_viewFooter.btnMain titleForAllState:@"退出"];
    
    _viewFooter.btnDetail.hidden = YES;
}

- (void)onButtonLogoutClicked
{
    [ECContext sharedInstance].userInfo = nil;
    [[PersistentHelper sharedInstance]saveNumber:[NSNumber numberWithBool:NO] forKey:UserHasLogined];
    
    SplashViewController *viewController = [[SplashViewController alloc]initWithNibName:nil bundle:nil];
    [[UIApplication sharedApplication]delegate].window.rootViewController = viewController;
}

- (void)onButtonRechargeClicked
{
    if (!_viewHeader.textAmount.text.length) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"充值金额不能为空" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"global_message_ok", @"确认") otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    [self showHUD];
    __weak __typeof(self) weakSelf = self;
    
    [[ECNetworkDataModel sharedInstance]requestForRecharge:_viewHeader.textAmount.text withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[ECNetworkDataModel sharedInstance]getUserDetailWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *dicInfo = responseObject;
            dicInfo[@"token"] = dicInfo[@"id"];
            [ECContext sharedInstance].userInfo = dicInfo;
            
            [self resetCells];
            [_tableView reloadData];
            [weakSelf hideHUD];
            [_viewHeader.textAmount resignFirstResponder];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf hideHUD];
            [_viewHeader.textAmount resignFirstResponder];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUD];
        [[ECNetworkDataModel sharedInstance]showCommonAlertViewWithError:error title:@"充值失败"];
        [_viewHeader.textAmount resignFirstResponder];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dicCells.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 145;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _viewFooter;
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL bRet = [textField resignFirstResponder];
    [self onButtonRechargeClicked];
    return bRet;
}

@end
