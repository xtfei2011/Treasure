//
//  TFEnableAwardController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFEnableAwardController.h"
#import "TFAwardViewCell.h"
#import "TFAlertView.h"
#import "TFTiedCardController.h"

@interface TFEnableAwardController ()<TFAwardViewCellDelegate>
/** 奖励数据 */
@property (nonatomic ,strong) NSMutableArray<TFEnableAward *> *enableAward;
@property (nonatomic ,strong) TFAlertView *alertView;
@end

@implementation TFEnableAwardController
/** cell的重用标识 */
static NSString * const AwardID = @"AwardViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TFGlobalBg;
    
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupTabelView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 90;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFAwardViewCell class]) bundle:nil] forCellReuseIdentifier:AwardID];
    self.tableView.contentInset = UIEdgeInsetsMake(36, 0, 64, 0);
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecordData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadRecordData
{
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:@"api/user/couponList/unused" params:nil success:^(id responseObject) {
        TFLog(@"--->%@",responseObject);
        [responseObject writeToFile:@"/Users/xietengfei/Desktop/veryCheap.plist" atomically:YES];
        homeSelf.enableAward = [TFEnableAward mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [homeSelf.tableView reloadData];
        [homeSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) { }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.enableAward.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFAwardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AwardID];
    cell.enableAward = self.enableAward[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)awardViewCellClick:(TFAwardViewCell *)cell
{
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)activateBtnClick:(UIButton *)sender
{
    if ([[TFUSER_DEFAULTS objectForKey:@"Account_State"] isEqualToString:@"off"]){
    
        [_alertView setPromptTitle:@"系统检测到您还没有开户，暂时无法激活红包劵！现在去开户吗？" font:14];
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
    } else if ([[TFUSER_DEFAULTS objectForKey:@"Card_State"] isEqualToString:@"off"]) {

        [_alertView setPromptTitle:@"系统检测到您还没有绑定银行卡，暂时无法激活红包劵！现在去绑卡吗？" font:14];
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
        __weak typeof(self) homeSelf = self;
        _alertView.block = ^(NSInteger index){
            [homeSelf.alertView removeFromSuperview];
        };
        [_alertView setPromptTitle:@"发送已激活红包劵页面截图 + 注册手机号给“新纪元金服”微信公众号领取红包奖励" font:14];
        [_alertView setHintType:TFHintTypeDefault];
        [TFkeyWindowView addSubview:_alertView];
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
@end
