//
//  TFAccountBottomView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAccountBottomView.h"
#import "TFTabBarController.h"
#import "TFNavigationController.h"
#import "TFTiedCardController.h"
#import "TFCardInformationController.h"
#import "TFAlertView.h"
#import "TFLoginViewController.h"

@interface TFAccountBottomView ()
@property (nonatomic ,strong) UIButton *sortButton;
@property (nonatomic ,strong) NSArray *btnSubTitleArr;
@property (nonatomic ,strong) TFAlertView *alertView;
@end

@implementation TFAccountBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
        
        [self selectButtonView];
    }
    return self;
}

- (void)selectButtonView
{
    NSInteger num = 9;
    
    NSArray *btnTitleArr = @[@"资金记录", @"理财统计", @"我的投资", @"回款明细",@"我的奖励", @"推荐有奖", @"我的积分", @"自动投标", @"银行卡绑定"];
    
    for (int i = 0; i < num; i++) {
        
        self.sortButton = [UIButton buttonWithTitle:btnTitleArr[i] subTitle:_btnSubTitleArr[i] target:self selector:@selector(classificationBtnNine:) frame:CGRectMake(i % 3 * TFMainScreen_Width/3, i/3 * 70.5, (TFMainScreen_Width - 2)/3, 70) image:[UIImage imageNamed:btnTitleArr[i]]];
        self.sortButton.tag = 1000 + i;
        
        [self addSubview:self.sortButton];
    }
}

- (void)setAccountModel:(TFAccountModel *)accountModel
{
    _accountModel = accountModel;
    
    NSString *switchStr = [accountModel.autobid isEqualToString:@"on"] ? @"已开启" : @"已关闭";
    NSString *stateStr = [[TFUSER_DEFAULTS objectForKey:@"Card_State"] isEqualToString:@"off"] ? @"现在去绑定" : @"已绑定银行卡";
    
    _btnSubTitleArr = @[accountModel.funds_records, @"", accountModel.invest_records, @"", @"现金劵/加息劵/体验金", @"邀请得红包", accountModel.score, switchStr, stateStr];
    [self selectButtonView];
}

- (void)classificationBtnNine:(UIButton *)sender
{
    if (whetherHaveNetwork == NO) {
        [TFProgressHUD showInfoMsg:@"无法连接服务器，请检查你的网络设置"];
        return;
    }
    TFAccount *account = [TFAccountTool account];
    
    /*** 获得"账号"模块对应的导航控制器 ***/
    TFTabBarController *tabBar = (TFTabBarController *)self.window.rootViewController;
    TFNavigationController *nav = tabBar.selectedViewController;
    
    if (!account.access_token) {
        
        TFLoginViewController *loginVC = [[TFLoginViewController alloc] init];
        TFNavigationController *loginNav = [[TFNavigationController alloc] initWithRootViewController:loginVC];
        [nav presentViewController:loginNav animated:YES completion:nil];
    } else {
        
        if (sender.tag == 1008) {
            
            if ([[TFUSER_DEFAULTS objectForKey:@"Account_State"] isEqualToString:@"off"]) {
                
                [_alertView setPromptTitle:@"您还没有开户，部分功能因此受限！现在去开户吗？" font:14];
                [_alertView setHintType:TFHintTypeSelect];
                [TFkeyWindowView addSubview:_alertView];
                
                __weak typeof(self) homeSelf = self;
                _alertView.block = ^(NSInteger index){
                    
                    [homeSelf.alertView removeFromSuperview];
                    
                    if (index == 2001) {
                        
                        TFWebViewController *webView = [[TFWebViewController alloc] init];
                        [webView loadWebURLString:Common_Interface_Montage(@"api/user/zbankRegister.html")];
                        [nav pushViewController:webView animated:YES];
                    }
                };
            } else if ([[TFUSER_DEFAULTS objectForKey:@"Card_State"] isEqualToString:@"on"]) {
                    
                TFCardInformationController *cardInformation = [[TFCardInformationController alloc] init];
                [nav pushViewController:cardInformation animated:YES];
            } else {
                TFTiedCardController *tiedCard = [[TFTiedCardController alloc] init];
                [nav pushViewController:tiedCard animated:YES];
            }
        } else {
            UIViewController *viewClass = [[NSClassFromString(ControllerArray[sender.tag - 1000]) alloc] init];
            [nav pushViewController:viewClass animated:YES];
        }
    }  
}
@end
