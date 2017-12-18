//
//  TFRegisterViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRegisterViewController.h"
#import "TFEncryption.h"
#import "TFCountDownButton.h"

@interface TFRegisterViewController ()
@property (weak, nonatomic) IBOutlet TFTextField *phoneField;
@property (weak, nonatomic) IBOutlet TFTextField *passwordField;
@property (weak, nonatomic) IBOutlet TFTextField *repetitionField;
@property (weak, nonatomic) IBOutlet TFTextField *masterField;
@property (weak, nonatomic) IBOutlet TFTextField *keyField;
@property (weak, nonatomic) IBOutlet TFCountDownButton *keyBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@end

@implementation TFRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"homePageBgView"]];
    self.navigationItem.title = @"注 册";
}

/*** 获取验证码 ***/
- (IBAction)verificationButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 888:
            [self getValidCode];
            break;
        case 889:
            sender.selected = !sender.selected;
            break;
        case 900: {
            TFWebViewController *webView = [[TFWebViewController alloc] init];
            [webView loadWebURLString:Common_Interface_Montage(@"api/privacy")];
            [self.navigationController pushViewController:webView animated:YES];
        }
            break;
        default:
            break;
    }
}

/*** 获取验证码 ***/
- (void)getValidCode
{
    if (!(_phoneField.text.isValidateMobile)) {
        [TFProgressHUD showInfoMsg:@"手机号码输入有误！"];
        
    } else {
        
        NSString *str = [@"d53x6w8df4" stringByAppendingString:_phoneField.text];
        NSString *encryption = [TFEncryption xtf_Encryption:str];
        NSString *string = [@"5sdf6987f2" stringByAppendingString:encryption];
        NSString *secretKey = [TFEncryption xtf_Encryption:string];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"mobile"] = _phoneField.text;
        params[@"type"] = @"register";
        params[@"code"] = secretKey;
        
        [TFNetworkTools getResultWithUrl:@"api/requireSmsCode" params:params success:^(id responseObject) {
            TFLog(@"--->%@",responseObject);
            if ([responseObject[@"code"] isEqual:@400015]) {
                
                [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
            } else {
                [TFProgressHUD showSuccess:@"验证码在发送的路上！"];
                /*** 开始倒计时 ***/
                [self.keyBtn countDownButtonClick];
            }
        } failure:^(NSError *error) { }];
    }
}

/*** 注册 ***/
- (IBAction)regusterButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (!(_phoneField.text.isValidateMobile)) {
        [TFProgressHUD showInfoMsg:@"手机号码输入有误!"];
    } else if (_passwordField.text.length < 5) {
        [TFProgressHUD showInfoMsg:@"您的密码设置过于简单!"];
    } else if (!_agreeBtn.selected) {
        [TFProgressHUD showInfoMsg:@"请先阅读条款!"];
    } else if (![_passwordField.text isEqualToString:_repetitionField.text]) {
        [TFProgressHUD showFailure:@"两次密码输入不一致!"];
    } else {
        [TFProgressHUD showLoading:@"请稍后···"];
        
        NSString *inviter = (_masterField.text.length == 0) ? @"" : _masterField.text;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = _phoneField.text;
        params[@"password"] = _passwordField.text;
        params[@"password_confirmation"] = _passwordField.text;
        params[@"smscode"] = _keyField.text;
        params[@"agree"] = @"1";
        params[@"device"] = @"ios";
        params[@"inviter"] = inviter;
        
        [TFNetworkTools postResultWithUrl:@"api/register" params:params success:^(id responseObject) {
            if ([responseObject[@"code"] isEqual:@200]) {
                [TFProgressHUD showSuccess:responseObject[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else if ([responseObject[@"code"] isEqual:@400001]) {
                [TFProgressHUD showFailure:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) { }];
    }
}
@end
