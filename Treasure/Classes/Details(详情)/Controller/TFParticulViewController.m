//
//  TFParticulViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFParticulViewController.h"
#import "TFParticulViewCell.h"

@interface TFParticulViewController ()
/** 投资明细数据 */
@property (nonatomic ,strong) NSMutableArray<TFParticul *> *particul;
/** 分页 */
@property (nonatomic ,assign) NSInteger page;
@end

@implementation TFParticulViewController
/** cell的重用标识 */
static NSString * const ParticulID = @"TFParticulViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TFGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFParticulViewCell class]) bundle:nil] forCellReuseIdentifier:ParticulID];
    self.tableView.rowHeight = 62;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 51, 0);
}

- (void)setupRefresh
{
    self.tableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRepaymentData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [TFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRepaymentData)];
}

- (void)loadRepaymentData
{
    self.page = 1;
    __weak typeof(self) homeSelf = self;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"api/loan/repaymentDetails/", self.comment.ID];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    [TFNetworkTools getResultWithUrl:urlStr params:params success:^(id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        homeSelf.particul = [TFParticul mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        if (homeSelf.particul.count == 0) {
            [homeSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [homeSelf.tableView.mj_header endRefreshing];
        } else {
            [homeSelf.tableView.mj_header endRefreshing];
            [homeSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {  }];
}

- (void)loadMoreRepaymentData
{
    self.page ++;
    __weak typeof(self) homeSelf = self;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"api/loan/repaymentDetails/", self.comment.ID];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    [TFNetworkTools getResultWithUrl:urlStr params:params success:^(id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSArray<TFParticul *>*moreParticul = [TFParticul mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        
        if (moreParticul.count == 0) {
            [homeSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        } else {
            [homeSelf.particul addObjectsFromArray:moreParticul];
            [homeSelf.tableView.mj_footer endRefreshing];
            [homeSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.particul.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFParticulViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParticulID];
    cell.particul = self.particul[indexPath.row];
    return cell;
}
@end
