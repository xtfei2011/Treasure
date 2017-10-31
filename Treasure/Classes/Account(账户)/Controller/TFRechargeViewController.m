//
//  TFRechargeViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRechargeViewController.h"
#import "TFParams.h"
#import "TFAlertView.h"
#import "TFLoginViewController.h"
#import "TFNavigationController.h"
#import "TFFundRecordController.h"
#import "TFCountDownButton.h"

@interface TFRechargeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet TFTextField *moneyField;
@property (weak, nonatomic) IBOutlet TFTextField *codeField;
@property (weak, nonatomic) IBOutlet TFCountDownButton *keyBtn;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (nonatomic ,strong) TFAlertView *alertView;
@property (nonatomic ,strong) TFParams *params;
@property (nonatomic ,strong) NSString *codeStr;
@end

@implementation TFRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
    
    self.determineBtn.userInteractionEnabled = NO;
    
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    [_alertView setHintType:TFHintTypeSelect];
    
    [self setupNavigationItem];
    
    [self getBalance];
}

- (void)getBalance
{
    [TFNetworkTools getResultWithUrl:@"api/user/queryBalance" params:nil success:^(id responseObject) {
        _balanceLabel.text = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"balance"] doubleValue]];
        
    } failure:^(NSError *error) { }];
}

- (void)setupNavigationItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"help" highImage:nil target:self action:@selector(rechargeHelpClickBtn)];
}

- (void)rechargeHelpClickBtn
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/rechargeHelp")];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)theTextField
{
    if (_codeField.text.length < 6 || _moneyField.text.length == 0) {
        
        [_determineBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.determineBtn.userInteractionEnabled = NO;
    } else {
        [_determineBtn setBackgroundColor:TFColor(252, 99, 102)];
        _determineBtn.userInteractionEnabled = YES;
    }
}

/*** 获取验证码 ***/
- (IBAction)verificationCodeButtonClick:(UIButton *)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"money"] = _moneyField.text;
    
    [TFNetworkTools postResultWithUrl:@"api/user/recharge/sms" params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@200]) {
            self.codeStr = responseObject[@"data"][@"pay_id"];
            [TFProgressHUD showSuccess:@"验证码在发送的路上！"];
            /*** 开始倒计时 ***/
            [self.keyBtn countDownButtonClick];
            
        } else {
            [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) { }];
}

/*** 充值提交 ***/
- (IBAction)prepaidImmediately:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    __weak typeof(self) homeSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"money"] = _moneyField.text;
    params[@"pay_id"] = self.codeStr;
    params[@"smscode"] = _codeField.text;
    [TFProgressHUD showLoading:@"充值中，请稍后"];
    
    [TFNetworkTools postResultWithUrl:@"api/user/recharge/pay" params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@401]) {
            [TFProgressHUD dismiss];
            
            [_alertView setPromptTitle:@"系统检测到您还没有登录，现在去登录吗?" font:14];
            [TFkeyWindowView addSubview:_alertView];
            
            _alertView.block = ^(NSInteger index) {
                [homeSelf.alertView removeFromSuperview];
                
                if (index == 2001) {
                    TFLoginViewController *loginVC = [[TFLoginViewController alloc] init];
                    TFNavigationController *loginNav = [[TFNavigationController alloc] initWithRootViewController:loginVC];
                    [homeSelf.navigationController presentViewController:loginNav animated:YES completion:nil];
                }
            };
        } else if ([responseObject[@"code"] isEqual:@500011]) {
            
            [TFProgressHUD dismiss];
            [_alertView setPromptTitle:@"您还没有开户，部分功能因此受限！现在去开户吗?" font:14];
            [TFkeyWindowView addSubview:_alertView];
            
            _alertView.block = ^(NSInteger index) {
                [homeSelf.alertView removeFromSuperview];
                if (index == 2001) {
                    /*** 众邦开户 ***/
                    [homeSelf authentication];
                }
            };
        } else if ([responseObject[@"code"] isEqual:@200]) {
            
            [TFProgressHUD showSuccess:responseObject[@"msg"]];
            TFFundRecordController *fund = [[TFFundRecordController alloc] init];
            [self.navigationController pushViewController:fund animated:YES];
            
        } else {
            [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) { }];
}

/*** 众邦开户 ***/
- (void)authentication
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/user/zbankRegister.html")];
    [self.navigationController pushViewController:webView animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.codeField) {
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        } else {
            return YES;
        }
    } else {
        if (string.length == 0) return YES;
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
        
        return [self isValid:checkStr withRegex:regex];
    }
}

- (BOOL)isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
