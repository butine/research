//
//  NewBorrowViewController.m
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import "NewBorrowViewController.h"
#import "STUtilities.h"
#import "TextFieldWithTipTableViewCell.h"
#import "ECNetworkDataModel+Operation.h"
#import <MBProgressHUDExtensions/UIViewController+MBProgressHUD.h>
#import <NSDate-Extensions/NSDate-Utilities.h>
#import <Toast/UIView+Toast.h>
#import "ECContext.h"

@interface NewBorrowViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *dicCells;

@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellAmount;
@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellProfit;
@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellDays;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcBottom;

@end

@implementation NewBorrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新的借款";
    [self initCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    _cellAmount = [TextFieldWithTipTableViewCell viewFromNib];
    _cellAmount.labelInfo.text = @"借款总额";
    _cellAmount.textValue.placeholder = @"请输入您要借款的金额";
    _cellAmount.textValue.text = @"";
    _cellAmount.textValue.returnKeyType = UIReturnKeyNext;
    _cellAmount.textValue.keyboardType = UIKeyboardTypeNumberPad;
    _cellAmount.textValue.delegate = self;
    [_dicCells[@"Info"]addObject:_cellAmount];
    
    _cellProfit = [TextFieldWithTipTableViewCell viewFromNib];
    _cellProfit.labelInfo.text = @"承诺利息";
    _cellProfit.textValue.placeholder = @"请输入您打算提供的利息";
    _cellProfit.textValue.text = @"";
    _cellProfit.textValue.returnKeyType = UIReturnKeyNext;
    _cellProfit.textValue.keyboardType = UIKeyboardTypeNumberPad;
    _cellProfit.textValue.delegate = self;
    [_dicCells[@"Info"]addObject:_cellProfit];

    
    _cellDays = [TextFieldWithTipTableViewCell viewFromNib];
    _cellDays.labelInfo.text = @"借款天数";
    _cellDays.textValue.placeholder = @"请输入您要借款的天数";
    _cellDays.textValue.text = @"";
    _cellDays.textValue.returnKeyType = UIReturnKeyNext;
    _cellDays.textValue.keyboardType = UIKeyboardTypeNumberPad;
    _cellDays.textValue.delegate = self;
    [_dicCells[@"Info"]addObject:_cellDays];
}

- (IBAction)onButtonBorrowClicked:(id)sender {
    if (!_cellAmount.textValue.text.length || !_cellProfit.textValue.text.length || !_cellDays.textValue.text.length) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"借款信息不能为空" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"global_message_ok", @"确认") otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    NSDate *date = [NSDate dateWithDaysFromNow:[_cellDays.textValue.text integerValue]];
    NSString *strDate = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970] * 1000];
    [[ECNetworkDataModel sharedInstance]requestForNewBorrow:_cellAmount.textValue.text profit:_cellProfit.textValue.text repayDate:strDate withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
        [[ECContext sharedInstance].vcMainContent.view makeToast:@"借款成功" duration:2.0 position:CSToastPositionCenter];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        [[ECNetworkDataModel sharedInstance]showCommonAlertViewWithError:error title:@"借款失败"];
    }];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    _lcBottom.constant = keyboardHight;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _lcBottom.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
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
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _cellAmount.textValue) {
        return [_cellProfit.textValue becomeFirstResponder];
    }
    else if (textField == _cellProfit.textValue) {
        return [_cellDays.textValue becomeFirstResponder];
    }
    else {
        BOOL bRet = [textField resignFirstResponder];
        [self onButtonBorrowClicked:nil];
        return bRet;
    }
}

@end
