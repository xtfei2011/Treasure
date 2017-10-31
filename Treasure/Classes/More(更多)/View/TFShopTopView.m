//
//  TFShopTopView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFShopTopView.h"
#import "TFInformView.h"
#import "TFAlertView.h"
#import "TFLoginViewController.h"
#import "TFShopViewController.h"
#import "TFNavigationController.h"
#import "TFTabBarController.h"

@interface TFShopTopView ()
@property (nonatomic ,strong) TFInformView *informView;
@property (weak, nonatomic) IBOutlet UIView *informBaseView;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UIButton *examineBtn;
@property (nonatomic ,strong) TFAlertView *alertView;
@end

@implementation TFShopTopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadInformData];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    
    self.informView = [[TFInformView alloc] initWithFrame:self.informBaseView.bounds];
    [self.informBaseView addSubview:self.informView];
}

- (void)loadInformData
{
    TFAccount *account = [TFAccountTool account];
    if (account.access_token) {
        
        self.examineBtn.hidden = YES;
        self.integralLabel.hidden = NO;
        
        [TFNetworkTools getResultWithUrl:@"api/user/queryIntegral" params:nil success:^(id responseObject) {
            
            self.integralLabel.text = responseObject[@"data"];
            
        } failure:^(NSError *error) { }];
    }else{
        self.examineBtn.hidden = NO;
        self.integralLabel.hidden = YES;
    }
}

- (IBAction)shopViewButtonClick:(UIButton *)sender
{
    if (sender.tag == 803) {
        [self signInButtonClick];
        
    } else if (sender.tag == 804) {
        [self notAccessToken];
        
    } else if ([self.delegate respondsToSelector:@selector(shopTopViewButtonClick:)]) {
        [self.delegate shopTopViewButtonClick:sender];
    }
}

- (void)signInButtonClick
{
    TFAccount *account = [TFAccountTool account];
    
    if (account.access_token == nil) {
        [self notAccessToken];
        
    } else {
        [TFNetworkTools getResultWithUrl:@"api/activity/signIn" params:nil success:^(id responseObject) {
            
            __weak typeof(self) homeSelf = self;
            
            _alertView.block = ^(NSInteger index){
                [homeSelf.alertView removeFromSuperview];
            };
            
            [_alertView setHintType:TFHintTypeDefault];
            [_alertView setPromptTitle:responseObject[@"msg"] font:14];
            [TFkeyWindowView addSubview:_alertView];
            
        } failure:^(NSError *error) {  }];
    }
}

- (void)notAccessToken
{
    TFTabBarController *tabBar = (TFTabBarController *)self.window.rootViewController;
    TFNavigationController *nav = tabBar.selectedViewController;
    
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
