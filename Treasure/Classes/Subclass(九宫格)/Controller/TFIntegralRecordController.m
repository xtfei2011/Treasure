//
//  TFIntegralRecordController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntegralRecordController.h"
#import "TFIntegralRecordCell.h"

@interface TFIntegralRecordController ()
/** 积分记录数据 */
@property (nonatomic ,strong) NSMutableArray<TFIntegralRecord *> *integralRecord;
/** 分页 */
@property (nonatomic ,assign) NSInteger page;
@end

@implementation TFIntegralRecordController

/** cell的重用标识 */
static NSString * const IntegralRecordID = @"IntegralRecordCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TFGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFIntegralRecordCell class]) bundle:nil] forCellReuseIdentifier:IntegralRecordID];
    self.tableView.contentInset = UIEdgeInsetsMake(36, 0, 64, 0);
    self.tableView.rowHeight = 40;
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
    
    [TFNetworkTools getResultWithUrl:@"api/user/integralRecord" params:params success:^(id responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        homeSelf.integralRecord = [TFIntegralRecord mj_objectArrayWithKeyValuesArray:dic[@"data"]];
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
    
    [TFNetworkTools getResultWithUrl:@"api/user/integralRecord" params:params success:^(id responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        NSArray<TFIntegralRecord *>*moreIntegralRecord = [TFIntegralRecord mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        if (moreIntegralRecord.count == 0) {
            [homeSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [homeSelf.integralRecord addObjectsFromArray:moreIntegralRecord];
            [homeSelf.tableView reloadData];
            [homeSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) { }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.integralRecord.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFIntegralRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:IntegralRecordID];
    cell.integralRecord = self.integralRecord[indexPath.row];
    return cell;
}
@end
