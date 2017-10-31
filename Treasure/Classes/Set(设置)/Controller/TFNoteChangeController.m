//
//  TFNoteChangeController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFNoteChangeController.h"
#import "TFTextField.h"
#import "TFEncryption.h"
#import "TFCountDownButton.h"

@interface TFNoteChangeController ()
/*** 接收验证码的手机 ***/
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/*** 验证码 ***/
@property (weak, nonatomic) IBOutlet TFTextField *verifyField;
/*** 获取验证码按钮 ***/
@property (weak, nonatomic) IBOutlet TFCountDownButton *acquireBtn;
/*** 新密码 ***/
@property (weak, nonatomic) IBOutlet TFTextField *passwordField;
@property (weak, nonatomic) IBOutlet TFTextField *repetitionField;
@end

@implementation TFNoteChangeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    _phoneLabel.text = self.accountModel.mobile;
}

- (IBAction)acquireBtnClick:(UIButton *)sender
{
    [TFProgressHUD showLoading:@"验证码在发送的路上！"];
    
    NSString *str = [@"d53x6w8df4" stringByAppendingString:_phoneLabel.text];
    NSString *encryption = [TFEncryption xtf_Encryption:str];
    NSString *string = [@"5sdf6987f2" stringByAppendingString:encryption];
    NSString *secretKey = [TFEncryption xtf_Encryption:string];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"mobile"] = _phoneLabel.text;
    params[@"type"] = @"getpwd";
    params[@"code"] = secretKey;
    
    [TFNetworkTools getResultWithUrl:@"api/requireSmsCode" params:params success:^(id responseObject) {
        
        [TFProgressHUD dismiss];
        /*** 开始倒计时 ***/
        [self.acquireBtn countDownButtonClick];
    } failure:^(NSError *error) {  }];
}

- (IBAction)countersignBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (_passwordField.text.length < 6) {
        [TFProgressHUD showInfoMsg:@"您的密码设置过于简单！"];
        return;
    } else if (_verifyField.text.length < 4) {
        
        [TFProgressHUD showFailure:@"验证码输入错误！"];
        return;
    } else if (![_passwordField.text isEqualToString:_repetitionField.text]) {
        
        [TFProgressHUD showFailure:@"两次密码输入不一致！"];
        return;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"new_password"] = _passwordField.text;
        params[@"new_password_confirmation"] = _passwordField.text;
        params[@"smscode"] = _verifyField.text;
        
        [TFNetworkTools postResultWithUrl:@"api/user/getpwd" params:params success:^(id responseObject) {
            [TFProgressHUD showSuccess:responseObject[@"msg"]];
        } failure:^(NSError *error) {  }];
    }
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
