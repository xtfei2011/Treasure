//
//  TFChangePasswordController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFChangePasswordController.h"

@interface TFChangePasswordController ()
/*** 旧密码 ***/
@property (weak, nonatomic) IBOutlet TFTextField *ancientField;
/*** 新密码 ***/
@property (weak, nonatomic) IBOutlet TFTextField *freshField;
@property (weak, nonatomic) IBOutlet TFTextField *repetitionField;

@end

@implementation TFChangePasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"密码修改";
}

- (IBAction)countersignBtnClick:(UIButton *)sender
{
    if (_ancientField.text.length < 6) {
        [TFProgressHUD showInfoMsg:@"旧密码输入错误！"];
        
    } else if (_freshField.text.length < 6) {
        [TFProgressHUD showFailure:@"验证码输入错误！"];
        
    } else if (![_freshField.text isEqualToString:_repetitionField.text]) {
        [TFProgressHUD showFailure:@"两次密码输入不一致！"];
       
    } else {
        NSString *url = nil;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.type == false) {
            
            url = @"api/user/changePaypasswd";
            params[@"old_pay_password"] = _ancientField.text;
            params[@"new_pay_password"] = _freshField.text;
            params[@"new_pay_password_confirmation"] = _freshField.text;
        } else if (self.type == true) {
            
            url = @"api/user/changePasswd";
            params[@"old_password"] = _ancientField.text;
            params[@"new_password"] = _freshField.text;
            params[@"new_password_confirmation"] = _freshField.text;
        }
        
        [TFNetworkTools postResultWithUrl:url params:params success:^(id responseObject) {
            [TFProgressHUD showSuccess:responseObject[@"msg"]];
            
            if ([responseObject[@"code"] isEqual:@200]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {  }];
    }
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
