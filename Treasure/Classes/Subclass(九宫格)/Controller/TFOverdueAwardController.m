//
//  TFOverdueAwardController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFOverdueAwardController.h"
#import "TFAwardViewCell.h"
#import "TFPopTableView.h"
#import "TFPopup.h"
#import "TFInvestDetailsController.h"

@interface TFOverdueAwardController ()<TFAwardViewCellDelegate>
/** 奖励数据 */
@property (nonatomic ,strong) NSMutableArray<TFEnableAward *> *enableAward;
@property (nonatomic ,strong) TFPopup *popup;
@end

@implementation TFOverdueAwardController
/** cell的重用标识 */
static NSString * const AwardID = @"AwardViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupTabelView
{
    self.view.backgroundColor = TFGlobalBg;
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
    [TFNetworkTools getResultWithUrl:@"api/user/couponList/use" params:nil success:^(id responseObject) {
        
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
    NSString *urlStr = [NSString stringWithFormat:@"api/user/couponReward/%@/%@",cell.enableAward.name, cell.enableAward.ID];
   
    [TFNetworkTools getResultWithUrl:urlStr params:nil success:^(id responseObject) {
        
        self.popup = [TFPopup mj_objectWithKeyValues:responseObject[@"data"]];
        
        TFPopTableView *tableView = [[TFPopTableView alloc] init];
        tableView.popup = self.popup;
        [TFkeyWindowView addSubview:tableView];
    } failure:^(NSError *error) { }];
}
@end
