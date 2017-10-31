//
//  TFIntegralEmployController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntegralEmployController.h"
#import "TFIntegralEmployCell.h"

@interface TFIntegralEmployController ()
/** 积分使用数据 */
@property (nonatomic ,strong) NSMutableArray<TFIntegralEmploy *> *integralEmploy;
/** 分页 */
@property (nonatomic ,assign) NSInteger page;
@end

@implementation TFIntegralEmployController
/** cell的重用标识 */
static NSString * const IntegralEmployID = @"IntegralEmployCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TFGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFIntegralEmployCell class]) bundle:nil] forCellReuseIdentifier:IntegralEmployID];
    self.tableView.rowHeight = 70;
    self.tableView.contentInset = UIEdgeInsetsMake(36, 0, 64, 0);
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
    
    [TFNetworkTools getResultWithUrl:@"api/user/activityRecord/" params:params success:^(id responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        homeSelf.integralEmploy = [TFIntegralEmploy mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [homeSelf.tableView reloadData];
        [homeSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) { }];
}

- (void)loadMoreRecordData
{
    self.page ++;
    __weak typeof(self) homeSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    [TFNetworkTools getResultWithUrl:@"api/user/activityRecord/" params:params success:^(id responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        NSArray<TFIntegralEmploy *>*moreIntegralEmploy = [TFIntegralEmploy mj_objectArrayWithKeyValuesArray:data[@"data"]];
        if (moreIntegralEmploy.count == 0) {
            [homeSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [homeSelf.integralEmploy addObjectsFromArray:moreIntegralEmploy];
            [homeSelf.tableView reloadData];
            [homeSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.integralEmploy.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFIntegralEmployCell *cell = [tableView dequeueReusableCellWithIdentifier:IntegralEmployID];
    cell.integralEmploy = self.integralEmploy[indexPath.row];
    return cell;
}
@end
