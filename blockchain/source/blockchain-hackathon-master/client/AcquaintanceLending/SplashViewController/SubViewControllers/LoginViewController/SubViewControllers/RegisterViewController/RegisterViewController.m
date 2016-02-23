//
//  RegisterViewController.m
//  AcquaintanceLending
//
//  Created by 李晓春 on 16/1/9.
//  Copyright © 2016年 ctcf. All rights reserved.
//

#import "RegisterViewController.h"
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

@interface RegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *dicCells;

@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellPhone;
@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellName;
@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellPassword;
@property (strong, nonatomic) TextFieldWithTipTableViewCell *cellPersonalId;

@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@property (nonatomic, strong) NSArray *contacts;

@property (strong, nonatomic) ECButtonFooterView *viewFooter;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    [self initViews];
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
    
    _cellPhone = [TextFieldWithTipTableViewCell viewFromNib];
    _cellPhone.labelInfo.text = @"手机号码";
    _cellPhone.textValue.placeholder = @"请输入您的手机号码";
    _cellPhone.textValue.text = @"";
    _cellPhone.textValue.returnKeyType = UIReturnKeyNext;
    _cellPhone.textValue.keyboardType = UIKeyboardTypeNumberPad;
    _cellPhone.textValue.delegate = self;
    [_dicCells[@"Info"]addObject:_cellPhone];
    
    _cellName = [TextFieldWithTipTableViewCell viewFromNib];
    _cellName.labelInfo.text = @"用户姓名";
    _cellName.textValue.placeholder = @"请输入您的真实姓名";
    _cellName.textValue.text = @"";
    _cellName.textValue.returnKeyType = UIReturnKeyNext;
    _cellName.textValue.delegate = self;
    [_dicCells[@"Info"]addObject:_cellName];
    
    
    NSData *dataBack = [[PersistentHelper sharedInstance]getDataForKey:LastLoginUserBackData];
    NSString *strBack = @"";
    if (dataBack) {
        strBack = [TNCryptor stringByAES256WithData:dataBack];
    }
    
    _cellPassword = [TextFieldWithTipTableViewCell viewFromNib];
    _cellPassword.labelInfo.text = NSLocalizedString(@"login_cell_account_password", @"密码");
    _cellPassword.textValue.placeholder = NSLocalizedString(@"login_cell_password_placeholder", @"请输入密码");
    _cellPassword.textValue.text = strBack.length?strBack:@"";
    _cellPassword.textValue.returnKeyType = UIReturnKeyNext;
    _cellPassword.textValue.secureTextEntry = YES;
    _cellPassword.textValue.delegate = self;
    [_dicCells[@"Info"]addObject:_cellPassword];
    
    _cellPersonalId = [TextFieldWithTipTableViewCell viewFromNib];
    _cellPersonalId.labelInfo.text = @"身份证号";
    _cellPersonalId.textValue.placeholder = @"请输入您的身份证号码";
    _cellPersonalId.textValue.text = @"";
    _cellPersonalId.textValue.delegate = self;
    [_dicCells[@"Info"]addObject:_cellPersonalId];
}

- (void)initViews
{
    _viewFooter = [ECButtonFooterView viewFromNib];
    [_viewFooter.btnMain addTarget:self action:@selector(onButtonRegisterClicked) forControlEvents:UIControlEventTouchUpInside];
    [[BasicUtility sharedInstance]setButton:_viewFooter.btnMain titleForAllState:@"注册"];
    
    _viewFooter.btnDetail.hidden = YES;
}

- (void)onButtonRegisterClicked
{
    if (!_cellName.textValue.text.length || !_cellPassword.textValue.text.length || !_cellPersonalId.textValue.text.length || !_cellPhone.textValue.text.length) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册信息不能为空" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"global_message_ok", @"确认") otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    [self getPhonebook];
}

- (void)registerUser:(NSArray*)arrayInfos
{
    [self showHUD];
    __weak __typeof(self)weakSelf = self;

    [[ECNetworkDataModel sharedInstance]registerUser:_cellPhone.textValue.text realName:_cellName.textValue.text password:_cellPassword.textValue.text personalId:_cellPersonalId.textValue.text contracts:arrayInfos withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSDictionary *dicRet= responseObject;
        
        [weakSelf saveUserInfo:dicRet];
        
        SplashViewController *viewController = [[SplashViewController alloc]initWithNibName:nil bundle:nil];
        [[UIApplication sharedApplication]delegate].window.rootViewController = viewController;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        [[ECNetworkDataModel sharedInstance]showCommonAlertViewWithError:error title:@"注册失败"];
    }];
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
    
    [[ECContext sharedInstance]setLastLoginUser:_cellPhone.textValue.text];
    [[PersistentHelper sharedInstance]saveNumber:[NSNumber numberWithBool:YES] forKey:UserHasLogined];
}

- (void)getPhonebook
{
    CFErrorRef error;
    self.addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        } else {
            
        }
    });
}

-(void)getContactsFromAddressBook
{
    CFErrorRef error = NULL;
    self.contacts = [[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *arrayInfos = [NSMutableArray array];
        
        NSUInteger i = 0;
        for (i = 0; i<MIN([allContacts count], 10); i++)
        {
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            NSMutableDictionary *dicItem = [NSMutableDictionary dictionary];
            CFStringRef strFullName = ABRecordCopyCompositeName(contactPerson);
            dicItem[@"name"] = [NSString stringWithFormat:@"%@", strFullName];
            ABMultiValueRef phone = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            for (int k = 0; k<ABMultiValueGetCount(phone); k++)
            {
                NSString * personPhone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                dicItem[@"phone"] = personPhone;
            }
            [arrayInfos addObject:dicItem];
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
        
        [self registerUser:arrayInfos];
    }
    else
    {
        NSLog(@"Error");
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [UIScreen mainScreen].bounds.size.height - 35 - 44 * 4 - 64;
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
    if (textField == _cellPhone.textValue) {
        return [_cellName.textValue becomeFirstResponder];
    }
    else if (textField == _cellName.textValue) {
        return [_cellPassword.textValue becomeFirstResponder];
    }
    else if (textField == _cellPassword.textValue) {
        return [_cellPersonalId.textValue becomeFirstResponder];
    }
    else {
        BOOL bRet = [textField resignFirstResponder];
        [self onButtonRegisterClicked];
        return bRet;
    }
}

@end
