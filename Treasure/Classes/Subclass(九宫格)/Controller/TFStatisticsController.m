//
//  TFStatisticsController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFStatisticsController.h"
#import "TFStatisticsViewCell.h"
#import "TFStatistics.h"

@interface TFStatisticsController ()
/*** 回报部分 ***/
@property (nonatomic ,strong) TFHarvest *harvest;
/*** 理财部分 ***/
@property (nonatomic ,strong) TFFinancial *financial;
@end

@implementation TFStatisticsController
/** cell的重用标识 */
static NSString * const StatisticsViewID = @"TFStatisticsViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"理财统计";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 558;
    [self setupRefresh];
    [self setupTabelView];
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFStatisticsViewCell class]) bundle:nil] forCellReuseIdentifier:StatisticsViewID];
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
    [TFNetworkTools getResultWithUrl:@"api/user/financialStatistics" params:nil success:^(id responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        homeSelf.financial = [TFFinancial mj_objectWithKeyValues:dic[@"financial_statistics"]];
        homeSelf.harvest = [TFHarvest mj_objectWithKeyValues:dic[@"return_statistics"]];
        
        [homeSelf.tableView reloadData];
        [homeSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) { }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFStatisticsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StatisticsViewID];
    cell.financial = self.financial;
    cell.harvest = self.harvest;
    return cell;
}
@end
