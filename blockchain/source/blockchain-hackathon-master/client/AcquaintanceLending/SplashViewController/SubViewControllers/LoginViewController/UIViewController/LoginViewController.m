//
//  LoginViewController.m
//  ECarDriver
//
//  Created by sola on 15/8/18.
//  Copyright (c) 2015年 upluscar. All rights reserved.
//

#import "LoginViewController.h"
#import "STUtilities.h"
#import "TextFieldWithTipTableViewCell.h"
#import "ECContext.h"
#import "ECButtonFooterView.h"
#import "ECNetworkDataModel+User.h"
#import "ConstantVariables.h"
#import "TNCryptor.h"
#import "SplashViewController.h"
#import <MBProgressHUDExtensions/UIViewController+MBProgressHUD.h>
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *dicCells;

@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellUser;
@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellPassword;

@property (strong, nonatomic) ECButtonFooterView *viewFooter;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"login_title", @"登录");
    [self initCells];
    [self initViews];
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
    
    _cellUser = [TextFieldWithTipTableViewCell viewFromNib];
    _cellUser.labelInfo.text = NSLocalizedString(@"login_cell_account_info", @"账号");
    _cellUser.textValue.placeholder = NSLocalizedString(@"login_cell_account_placeholder", @"请输入用户名或手机号");
    _cellUser.textValue.text = [[ECContext sharedInstance]getLastLoginUser]?:@"";
    _cellUser.textValue.returnKeyType = UIReturnKeyNext;
    _cellUser.textValue.keyboardType = UIKeyboardTypeNumberPad;
    _cellUser.textValue.delegate = self;
    _cellUser.lcTextLeft.constant = 60;
    [_dicCells[@"Info"]addObject:_cellUser];
    
    
    
    NSData *dataBack = [[PersistentHelper sharedInstance]getDataForKey:LastLoginUserBackData];
    NSString *strBack = @"";
    if (dataBack) {
        strBack = [TNCryptor stringByAES256WithData:dataBack];
    }
    
    _cellPassword = [TextFieldWithTipTableViewCell viewFromNib];
    _cellPassword.labelInfo.text = NSLocalizedString(@"login_cell_account_password", @"密码");
    _cellPassword.textValue.placeholder = NSLocalizedString(@"login_cell_password_placeholder", @"请输入密码");
    _cellPassword.textValue.text = strBack.length?strBack:@"";
    _cellPassword.textValue.secureTextEntry = YES;
    _cellPassword.textValue.delegate = self;
    _cellPassword.lcTextLeft.constant = 60;
    [_dicCells[@"Info"]addObject:_cellPassword];
}

- (void)initViews
{
    _viewFooter = [ECButtonFooterView viewFromNib];
    [_viewFooter.btnMain addTarget:self action:@selector(onButtonLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[BasicUtility sharedInstance]setButton:_viewFooter.btnMain titleForAllState:NSLocalizedString(@"login_title", @"登录")];

    _viewFooter.btnDetail.hidden = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonRegisterClicked)];
    [[BasicUtility sharedInstance]setRightBarButtonItem:item navItem:self.navigationItem];
}

- (void)login
{
    __weak __typeof(self)weakSelf = self;

    [self showHUD];
    [[ECNetworkDataModel sharedInstance]login:_cellUser.textValue.text password:_cellPassword.textValue.text withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSDictionary *dicRet= responseObject;
        
        [weakSelf saveUserInfo:dicRet];
        
        SplashViewController *viewController = [[SplashViewController alloc]initWithNibName:nil bundle:nil];
        [[UIApplication sharedApplication]delegate].window.rootViewController = viewController;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        [[ECNetworkDataModel sharedInstance]showCommonAlertViewWithError:error title:@"登录失败"];
    }];
}

- (void)onButtonLoginClicked:(id)sender
{
    if (!_cellUser.textValue.text.length || !_cellPassword.textValue.text.length) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"global_alert_login_info_cant_be_null", @"用户名或密码不能为空") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"global_message_ok", @"确认") otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    [self login];
}

- (void)saveUserInfo:(NSDictionary*)dicInfo
{
    NSString *strToken = dicInfo[@"id"];
    NSData *data = [TNCryptor dataByAES256WithString:strToken];
    [[PersistentHelper sharedInstance]saveData:data forKey:LastLoginUserData];
    
    NSString *strBack = _cellPassword.textValue.text;
    data = [TNCryptor dataByAES256WithString:strBack];
    [[PersistentHelper sharedInstance]saveData:data forKey:LastLoginUserBackData];
    [[PersistentHelper sharedInstance]saveString:dicInfo[@"displayName"] forKey:UserDisplayName];
    
    NSMutableDictionary *dicSave = [NSMutableDictionary dictionary];
    dicSave[@"token"] = dicInfo[@"id"];
    dicSave[@"displayName"] = dicInfo[@"name"];
    
    [ECContext sharedInstance].userInfo = dicSave;
    
    [[ECContext sharedInstance]setLastLoginUser:_cellUser.textValue.text];
    [[PersistentHelper sharedInstance]saveNumber:[NSNumber numberWithBool:YES] forKey:UserHasLogined];
}

- (void)onButtonRegisterClicked
{
    RegisterViewController *viewController = [[RegisterViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [UIScreen mainScreen].bounds.size.height - 35 - 44 * 2 - 64;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _viewFooter;
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _cellUser.textValue) {
        return [_cellPassword.textValue becomeFirstResponder];
    }
    else {
        BOOL bRet = [textField resignFirstResponder];
        [self login];
        return bRet;
    }
}

@end
