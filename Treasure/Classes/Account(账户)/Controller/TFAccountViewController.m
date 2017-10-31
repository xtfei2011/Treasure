//
//  TFAccountViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAccountViewController.h"
#import "TFHeadAnimationView.h"
#import "TFAccountHeadView.h"
#import "TFAccountViewCell.h"
#import "TFAccountModel.h"
#import "TFSetViewController.h"
#import "TFAccountBottomView.h"
#import "TFWithdrawViewController.h"
#import "TFRechargeViewController.h"
#import "TFAlertView.h"
#import "TFTiedCardController.h"
#import "TFLoginViewController.h"
#import "TFNavigationController.h"

@interface TFAccountViewController ()<TFAccountViewDelegate>
/*** 头部动画 ***/
@property (nonatomic ,strong) TFHeadAnimationView *headerAnimationView;
/*** 头部数据展示 ***/
@property (nonatomic ,strong) TFAccountHeadView *accountHeadView;
/*** 底部分类按钮View ***/
@property (nonatomic ,strong) TFAccountBottomView *accountBottomView;
@property (nonatomic ,strong) TFAccountModel *accountModel;
@property (nonatomic ,strong) TFAlertView *alertView;
@end

@implementation TFAccountViewController
/** cell的重用标识 */
static NSString * const TFAccountViewID = @"TFAccountViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    if (whetherHaveNetwork == YES) {
        [self loadFetchRequests];
    } else {
        self.accountHeadView.hidden = YES;
        [self setupLoginWithNoToken];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    
    _headerAnimationView = [[TFHeadAnimationView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 140)];
    self.tableView.tableHeaderView = _headerAnimationView;
    
    [self setupNavigationItem];
    [self setupTabelView];
}

- (void)loadFetchRequests
{
    [_accountHeadView removeFromSuperview];
    [_accountBottomView removeFromSuperview];
    [TFProgressHUD showLoading:@"账户验证中"];
    
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:@"api/user/userInfo" params:nil success:^(id responseObject) {
        
        [TFProgressHUD dismiss];
        
        if ([responseObject[@"code"] isEqual:@401]) {
            
            homeSelf.accountModel = [TFAccountModel mj_objectWithKeyValues:nil];
            [self setupLoginWithNoToken];
            
            [TFUSER_DEFAULTS setObject:@"off" forKey:@"Account_State"];
            [TFUSER_DEFAULTS synchronize];
            
            [homeSelf.tableView reloadData];
            
            TFAccount *account = [TFAccount mj_objectWithKeyValues:nil];
            [TFAccountTool saveAccount:account];
        }else{
            
            /*** 登录情况 ***/
            homeSelf.accountModel = [TFAccountModel mj_objectWithKeyValues:responseObject[@"data"]];
            [homeSelf.tableView reloadData];
            
            [self getAccountState];
            [self getCardState];
        }
    } failure:^(NSError *error) {
         [TFProgressHUD showFailure:@"网络繁忙，稍后再试"];
    }];
}

/*** 获取开户状态 ***/
- (void)getAccountState
{
    /*** 开户状态 ***/
    [TFNetworkTools getResultWithUrl:@"api/user/queryZBankStatus" params:nil success:^(id responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        [TFUSER_DEFAULTS setObject:dict[@"status"] forKey:@"Account_State"];
        [TFUSER_DEFAULTS synchronize];
        
        [self.tableView reloadData];

    } failure:^(NSError *error) { }];
}

/*** 绑卡状态 ***/
- (void)getCardState
{
    [TFNetworkTools getResultWithUrl:@"api/user/queryBindCardStatus" params:nil success:^(id responseObject) {

        NSDictionary *dict = [responseObject objectForKey:@"data"];
        [TFUSER_DEFAULTS setObject:dict[@"status"] forKey:@"Card_State"];
        [TFUSER_DEFAULTS synchronize];
        
        [self setupLoginWithToken];
        
    } failure:^(NSError *error) { }];
}

- (void)setupLoginWithToken
{
    self.navigationItem.title = self.accountModel.mobile;
    
    _accountHeadView = [TFAccountHeadView viewFromXib];
    _accountHeadView.accountModel = self.accountModel;
    _accountHeadView.loginView.hidden = YES;
    _accountHeadView.headerView.hidden = NO;
    [_headerAnimationView addSubview:_accountHeadView];
    
    _accountBottomView = [[TFAccountBottomView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 210)];
    _accountBottomView.accountModel = self.accountModel;
    self.tableView.tableFooterView = _accountBottomView;
}

- (void)setupLoginWithNoToken
{
    self.navigationItem.title = @"个人中心";
    
    _accountHeadView = [TFAccountHeadView viewFromXib];
    _accountHeadView.headerView.hidden = YES;
    _accountHeadView.loginView.hidden = NO;
    [_headerAnimationView addSubview:_accountHeadView];
    
    _accountBottomView = [[TFAccountBottomView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 210)];
    self.tableView.tableFooterView = _accountBottomView;
}

- (void)setupNavigationItem
{
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"设置" highImage:nil target:self action:@selector(leftClickBtn)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"sign" highImage:nil target:self action:@selector(rightClickBtn)];
}

- (void)leftClickBtn
{
    if (whetherHaveNetwork == NO) {
        [TFProgressHUD showInfoMsg:@"无法连接服务器，请检查你的网络设置"];
        return;
    }
    
    TFAccount *account = [TFAccountTool account];
    if (account.access_token) {
        
        TFSetViewController *setVC = [[TFSetViewController alloc] init];
        setVC.accountModel = self.accountModel;
        [self.navigationController pushViewController:setVC animated:YES];
    } else {
        [self setupLoginView];
    }
}

- (void)rightClickBtn
{
    TFAccount *account = [TFAccountTool account];
    if (account.access_token) {
        [self registerButtonClick];
    } else {
        [self setupLoginView];
    }
}

/*** 签到 ***/
- (void)registerButtonClick
{
    [TFNetworkTools getResultWithUrl:@"api/activity/signIn" params:nil success:^(id responseObject) {
        __weak typeof(self) homeSelf = self;
        _alertView.block = ^(NSInteger index){
            [homeSelf.alertView removeFromSuperview];
            [homeSelf loadFetchRequests];
        };
        [_alertView setPromptTitle:responseObject[@"msg"] font:14];
        [_alertView setHintType:TFHintTypeDefault];
        [TFkeyWindowView addSubview:_alertView];
        
    } failure:^(NSError *error) { }];
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFAccountViewCell class]) bundle:nil] forCellReuseIdentifier:TFAccountViewID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[TFUSER_DEFAULTS objectForKey:@"Account_State"] isEqualToString:@"off"] ? 220 : 153;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFAccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TFAccountViewID];
    cell.accountModel = self.accountModel;
    cell.delegate = self;
    return cell;
}

- (void)accountViewBtnClick:(UIButton *)sender
{
    if ([[TFUSER_DEFAULTS objectForKey:@"Account_State"] isEqualToString:@"off"]) {
    
        if (sender.tag == 802) {
            [self authentication];  /***  去绑定众邦银行 ***/
            
        } else {
            [_alertView setPromptTitle:@"您还没有开户，部分功能因此受限！现在去开户吗？" font:14];
            [_alertView setHintType:TFHintTypeSelect];
            [TFkeyWindowView addSubview:_alertView];
            
            __weak typeof(self) homeSelf = self;
            _alertView.block = ^(NSInteger index){
                
                if (index == 2000) {
                    [homeSelf.alertView removeFromSuperview];
                } else {
                    [homeSelf authentication];
                    [homeSelf.alertView removeFromSuperview];
                }
            };
        }
    } else if ([[TFUSER_DEFAULTS objectForKey:@"Card_State"] isEqualToString:@"off"]) {
        
        [_alertView setPromptTitle:@"您还没有绑定银行卡，充值提现功能因此受限！现在去绑卡吗？" font:14];
        [_alertView setHintType:TFHintTypeSelect];
        [TFkeyWindowView addSubview:_alertView];
        
        __weak typeof(self) homeSelf = self;
        _alertView.block = ^(NSInteger index){
            
            if (index == 2000) {
                [homeSelf.alertView removeFromSuperview];
            } else {
                [homeSelf jumpTopup];
                [homeSelf.alertView removeFromSuperview];
            }
        };
    } else {
        if (sender.tag == 800) {
            TFRechargeViewController *rechargeVC = [[TFRechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
            
        } else if (sender.tag == 801) {
            TFWithdrawViewController *withdrawVC = [[TFWithdrawViewController alloc] init];
            withdrawVC.balance = self.accountModel.balance;
            [self.navigationController pushViewController:withdrawVC animated:YES];
        }
    }
}

/*** 众邦银行开户 ***/
- (void)authentication
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/user/zbankRegister.html")];
    [self.navigationController pushViewController:webView animated:YES];
}

/*** 跳转银行卡绑定 ***/
- (void)jumpTopup
{
    TFTiedCardController *tiedCard = [[TFTiedCardController alloc] init];
    [self.navigationController pushViewController:tiedCard animated:YES];
}

/*** 登录 ***/
- (void)setupLoginView
{
    if (whetherHaveNetwork == NO) {
        [TFProgressHUD showInfoMsg:@"无法连接服务器，请检查你的网络设置"];
        return;
    }
    TFLoginViewController *loginVC = [[TFLoginViewController alloc] init];
    TFNavigationController *loginNav = [[TFNavigationController alloc] initWithRootViewController:loginVC];
    
    [self.navigationController presentViewController:loginNav animated:YES completion:nil];
}
@end
