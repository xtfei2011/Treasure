//
//  TFAccountHeadView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAccountHeadView.h"
#import "TFTabBarController.h"
#import "TFNavigationController.h"
#import "TFLoginViewController.h"

@interface TFAccountHeadView ()
/*** 资产 ***/
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;
/*** 收益 ***/
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
/*** 冻结 ***/
@property (weak, nonatomic) IBOutlet UILabel *frostLabel;
@end

@implementation TFAccountHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setAccountModel:(TFAccountModel *)accountModel
{
    _accountModel = accountModel;
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:accountModel.face] placeholderImage:[UIImage imageNamed:@"header"]];
    
    _propertyLabel.text = accountModel.total_money;
    
    _earningsLabel.text = accountModel.net_income;
    
    _frostLabel.text = accountModel.frozen;
}

- (IBAction)loginButtonClick:(UIButton *)sender
{
    if (whetherHaveNetwork == NO) {
        [TFProgressHUD showInfoMsg:@"无法连接服务器，请检查你的网络设置"];
        return;
    }
    /*** 获得"账号"模块对应的导航控制器 ***/
    TFTabBarController *tabBar = (TFTabBarController *)self.window.rootViewController;
    TFNavigationController *nav = tabBar.selectedViewController;
    
    /*** 弹出登录视图 ***/
    TFLoginViewController *loginVC = [[TFLoginViewController alloc] init];
    TFNavigationController *loginNav = [[TFNavigationController alloc] initWithRootViewController:loginVC];
    [nav presentViewController:loginNav animated:YES completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.xtf_width = TFMainScreen_Width;
}
@end
