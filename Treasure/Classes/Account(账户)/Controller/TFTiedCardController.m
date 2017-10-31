//
//  TFTiedCardController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/9/8.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTiedCardController.h"
#import "TFBanksViewController.h"

@interface TFTiedCardController ()
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet TFTextField *tiedCardField;
@property (weak, nonatomic) IBOutlet TFTextField *phoneNumberLabel;
@property (nonatomic ,strong) NSString *bank_id;
@end

@implementation TFTiedCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定银行卡";
    [self getTiedCardInformation];
    [self getAccountState];
}

/*** 获取开户状态 ***/
- (void)getAccountState
{
    /*** 开户状态 ***/
    [TFNetworkTools getResultWithUrl:@"api/user/queryZBankStatus" params:nil success:^(id responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        [TFUSER_DEFAULTS setObject:dict[@"status"] forKey:@"Account_State"];
        [TFUSER_DEFAULTS synchronize];
        
    } failure:^(NSError *error) { }];
}

- (void)getTiedCardInformation
{
    [TFNetworkTools getResultWithUrl:@"api/user/oldUserBankInfo" params:nil success:^(id responseObject) {
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        if ([[dict objectForKey:@"card"] isEqualToString:@""]) return;
        _tiedCardField.text = [dict objectForKey:@"card"];
        
    } failure:^(NSError *error) { }];
}

- (IBAction)chooseBankButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    TFBanksViewController *bankList = [[TFBanksViewController alloc] init];
    bankList.selectBank = ^(NSString *bankName, NSString *bankID) {
        self.bankNameLabel.text = bankName;
        self.bank_id = bankID;
    };
    [self.navigationController pushViewController:bankList animated:YES];
}

- (IBAction)tiedCardButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if ([self.bankNameLabel.text isEqualToString:@"选择开户银行"]) {
        
        [TFProgressHUD showInfoMsg:@"您还没有选择开户行"];
    } else if (!self.tiedCardField.text.length) {
        
        [TFProgressHUD showInfoMsg:@"银行卡号不能为空"];
    } else if (!self.phoneNumberLabel.text.isValidateMobile) {
        
        [TFProgressHUD showInfoMsg:@"手机号码输入有误"];
    } else {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"bank_id"] = _bank_id;
        params[@"bank_no"] = _tiedCardField.text;
        params[@"mobile"] = _phoneNumberLabel.text;
       
        [TFProgressHUD showLoading:@"正在提交信息"];
        [TFNetworkTools postResultWithUrl:@"api/user/bindCard" params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqual:@200]) {
                [TFProgressHUD showSuccess:responseObject[@"msg"]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) { TFLog(@"---->%@",error);}];
    }
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
