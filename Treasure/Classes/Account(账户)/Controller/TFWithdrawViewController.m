//
//  TFWithdrawViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFWithdrawViewController.h"
#import "TFParams.h"
#import "TFFundRecordController.h"

@interface TFWithdrawViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet TFTextField *moneyField;
@property (weak, nonatomic) IBOutlet TFTextField *passwordField;

@property (nonatomic ,strong) TFParams *params;
@end

@implementation TFWithdrawViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moneyField.delegate = self;
    
    [self setupNavigationItem];
    [self getupQueryBalance];
}

- (void)setupNavigationItem
{
    self.navigationItem.title = @"提现";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"help" highImage:nil target:self action:@selector(withdrawHelpClickBtn)];
}

- (void)getupQueryBalance
{
    [TFProgressHUD showLoading:@"获取当前余额"];
    [TFNetworkTools getResultWithUrl:@"api/user/queryBalance" params:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@200]) {
            [TFProgressHUD dismiss];
            _balanceLabel.text = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"balance"] doubleValue]];
        }
        [TFProgressHUD showFailure:responseObject[@"msg"]];
    } failure:^(NSError *error) { }];
}

- (void)withdrawHelpClickBtn
{
    [self.view endEditing:YES];
    
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/cashHelp")];
    [self.navigationController pushViewController:webView animated:YES];
}

- (IBAction)confirmWithdrawal:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (_moneyField.text.length == 0) {
        [TFProgressHUD showInfoMsg:@"您还没有输入提现金额！"];
        
    } else if ([_moneyField.text integerValue] > 1000000) {
        [TFProgressHUD showInfoMsg:@"您的一次提现额度不得大于1000000元！"];
        
    } else if ([_moneyField.text integerValue] > [self.balance integerValue]) {
        [TFProgressHUD showInfoMsg:@"您输入的金额已经超出您的余额！"];
        
    } else {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"money"] = _moneyField.text;
        params[@"pay_password"] = _passwordField.text;
        
        [TFProgressHUD showLoading:@"处理中，请稍后"];
        [TFNetworkTools postResultWithUrl:@"api/user/withdrawsCash/v2" params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqual:@200]) {
                [TFProgressHUD showSuccess:responseObject[@"msg"]];
                _moneyField.text = nil;
                _passwordField.text = nil;
                
                TFFundRecordController *fund = [[TFFundRecordController alloc] init];
                [self.navigationController pushViewController:fund animated:YES];
            } else {
                [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) { }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //正则表达式
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    
    return [self isValid:checkStr withRegex:regex];
}

- (BOOL)isValid:(NSString *)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicte evaluateWithObject:checkStr];
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
