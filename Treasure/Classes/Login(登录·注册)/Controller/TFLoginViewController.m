//
//  TFLoginViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFLoginViewController.h"
#import "TFRegisterViewController.h"
#import "TFRetrieveViewController.h"

@interface TFLoginViewController ()
/*** 账号 ***/
@property (weak, nonatomic) IBOutlet TFTextField *accountField;
/*** 密码 ***/
@property (weak, nonatomic) IBOutlet TFTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (nonatomic ,strong) NSString *url;

@end

@implementation TFLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getupTopImageView];
    [self setupNavigationItem];
}

- (void)getupTopImageView
{
    [TFNetworkTools getResultWithUrl:@"api/loginImg" params:nil success:^(id responseObject) {
        self.url = responseObject[@"data"][@"url"];
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"homePageBgView"]];
    } failure:^(NSError *error) { }];
}

- (void)setupNavigationItem
{
    self.navigationItem.title = @"登 录";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"login_close_icon" highImage:nil target:self action:@selector(closeLoginClickBtn)];
}

- (void)closeLoginClickBtn
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (!_accountField.text.isValidateMobile) {
        [TFProgressHUD showInfoMsg:@"号码输入有误！"];
        
    } else if (_passwordField.text.length < 5) {
        [TFProgressHUD showInfoMsg:@"密码输入有误"];
        
    } else {
        [TFProgressHUD showLoading:@"登录中···"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"username"] = _accountField.text;
        params[@"password"] = _passwordField.text;
        
        [TFNetworkTools postResultWithUrl:@"api/login/ios" params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"]isEqual:@200]) {
                [TFProgressHUD showSuccess:responseObject[@"msg"]];
                
                TFAccount *account = [TFAccount mj_objectWithKeyValues:responseObject[@"data"]];
                [TFAccountTool saveAccount:account];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [self closeLoginClickBtn];
                }];
            }else{
                [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {  }];
    }
}

- (IBAction)registerButtonClick:(UIButton *)sender
{
    TFRegisterViewController *registerVC = [[TFRegisterViewController alloc] init];
    registerVC.url = self.url;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)forgetPasswordButtonClick:(UIButton *)sender
{
    TFRetrieveViewController *retrieveVC = [[TFRetrieveViewController alloc] init];
    [self.navigationController pushViewController:retrieveVC animated:YES];
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
