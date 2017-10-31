//
//  TFEnableAwardController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFEnableAwardController.h"
#import "TFAwardViewCell.h"

@interface TFEnableAwardController ()<TFAwardViewCellDelegate>
/** 奖励数据 */
@property (nonatomic ,strong) NSMutableArray<TFEnableAward *> *enableAward;
@end

@implementation TFEnableAwardController
/** cell的重用标识 */
static NSString * const AwardID = @"AwardViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TFGlobalBg;
    
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
@end
