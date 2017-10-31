//
//  TFRecommendController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRecommendController.h"
#import "TFRecommendView.h"
#import "TFRecommendViewCell.h"
#import "TFAwardStatistics.h"

@interface TFRecommendController ()
@property (nonatomic ,strong) TFRecommendView *recommendView;
/** 分页 */
@property (nonatomic ,assign) NSInteger page;
/** 推荐奖励数据 */
@property (nonatomic ,strong) NSMutableArray<TFRecommend *> *recommend;
@property (nonatomic ,strong) TFAwardStatistics *awardStatistics;
@end

@implementation TFRecommendController

/** cell的重用标识 */
static NSString * const RecommendViewID = @"TFRecommendViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐有奖";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"help" highImage:nil target:self action:@selector(recommendHelpClickBtn)];
    
    [self setupRefresh];
    [self setupTabelView];
}

- (void)recommendHelpClickBtn
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/inviteHelp")];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)setupTopView
{
    _recommendView = [TFRecommendView viewFromXib];
    _recommendView.awardStatistics = self.awardStatistics;
    self.tableView.tableHeaderView = _recommendView;
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFRecommendViewCell class]) bundle:nil] forCellReuseIdentifier:RecommendViewID];
    self.tableView.sectionHeaderHeight = 44;
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecordData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [TFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecordData)];
}

- (void)loadRecordData
{
    self.page = 1;
    
    __weak typeof(self) homeSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    [TFNetworkTools getResultWithUrl:@"api/user/inviteReward" params:params success:^(id responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        homeSelf.awardStatistics = [TFAwardStatistics mj_objectWithKeyValues:dic];
        NSDictionary *dict = responseObject[@"total_invite_record"];
        homeSelf.recommend = [TFRecommend mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        
        [self setupTopView];
        [homeSelf.tableView reloadData];
        [homeSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
    }];
}

- (void)loadMoreRecordData
{
    self.page ++;
    __weak typeof(self) homeSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    [TFNetworkTools getResultWithUrl:@"api/user/inviteReward" params:params success:^(id responseObject) {
        
        NSDictionary *data = responseObject[@"data"][@"total_invite_record"];
        NSArray<TFRecommend *>*moreRecommend = [TFRecommend mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [homeSelf.recommend addObjectsFromArray:moreRecommend];
        [homeSelf.tableView reloadData];
        [homeSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recommend.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendViewID];
    cell.recommend = self.recommend[indexPath.row];
    return cell;
}
@end
