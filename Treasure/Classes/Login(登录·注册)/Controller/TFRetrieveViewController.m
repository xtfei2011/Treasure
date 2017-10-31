//
//  TFRetrieveViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/14.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRetrieveViewController.h"
#import "TFTextField.h"
#import "TFEncryption.h"
#import "TFCountDownButton.h"

@interface TFRetrieveViewController ()
@property (weak, nonatomic) IBOutlet TFTextField *phoneField;
@property (weak, nonatomic) IBOutlet TFTextField *passwordField;
@property (weak, nonatomic) IBOutlet TFTextField *repetitionField;
@property (weak, nonatomic) IBOutlet TFTextField *verificationField;
@property (weak, nonatomic) IBOutlet TFCountDownButton *verificationBtn;
@end

@implementation TFRetrieveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"忘记密码";
}

- (IBAction)verificationButtonClick:(UIButton *)sender
{
    if (!_phoneField.text.isValidateMobile) {
        [TFProgressHUD showInfoMsg:@"手机号码输入有误！"];
        
    } else {
        
        NSString *str = [@"d53x6w8df4" stringByAppendingString:_phoneField.text];
        NSString *encryption = [TFEncryption xtf_Encryption:str];
        NSString *string = [@"5sdf6987f2" stringByAppendingString:encryption];
        NSString *secretKey = [TFEncryption xtf_Encryption:string];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"mobile"] = _phoneField.text;
        params[@"type"] = @"getpwd";
        params[@"code"] = secretKey;
        
        [TFNetworkTools getResultWithUrl:@"api/requireSmsCode" params:params success:^(id responseObject) {
            
            [TFProgressHUD showSuccess:@"验证码在发送的路上！"];
            /*** 开始倒计时 ***/
            [self.verificationBtn countDownButtonClick];
        } failure:^(NSError *error) { }];
    }
}

- (IBAction)countersignButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (!_phoneField.text.isValidateMobile) {
        [TFProgressHUD showInfoMsg:@"手机号码输入有误！"];
        
    } else if (_passwordField.text.length < 5) {
        [TFProgressHUD showInfoMsg:@"您的密码设置过于简单！"];
        
    } else if (_verificationField.text.length < 4) {
        [TFProgressHUD showFailure:@"验证码输入错误！"];
        
    } else if (![_passwordField.text isEqualToString:_repetitionField.text]) {
        [TFProgressHUD showFailure:@"两次密码输入不一致！"];
        
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = _phoneField.text;
        params[@"new_password"] = _passwordField.text;
        params[@"new_password_confirmation"] = _passwordField.text;
        params[@"smscode"] = _verificationField.text;
        
        [TFNetworkTools postResultWithUrl:@"api/getpwd" params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqual:@200]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [TFProgressHUD showSuccess:responseObject[@"msg"]];
        } failure:^(NSError *error) { }];
    }
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
