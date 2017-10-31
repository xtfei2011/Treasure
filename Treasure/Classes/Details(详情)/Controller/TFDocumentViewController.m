//
//  TFDocumentViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFDocumentViewController.h"
#import "TFDocumentViewCell.h"
#import "TFDocument.h"

@interface TFDocumentViewController ()
/** 投资记录数据 */
@property (nonatomic ,strong) NSMutableArray<TFDocument *> *document;
/** 分页 */
@property (nonatomic ,assign) NSInteger page;
@end

@implementation TFDocumentViewController
/** cell的重用标识 */
static NSString * const DocumentID = @"DocumentViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = TFGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFDocumentViewCell class]) bundle:nil] forCellReuseIdentifier:DocumentID];
    self.tableView.rowHeight = 75;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 51, 0);
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"api/loan/record/", self.comment.ID];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    [TFNetworkTools getResultWithUrl:urlStr params:params success:^(id responseObject) {

        NSDictionary *dict = responseObject[@"data"];
        homeSelf.document = [TFDocument mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        [homeSelf.tableView.mj_header endRefreshing];
        if (homeSelf.document.count == 0) {
            [homeSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [homeSelf.tableView reloadData];
        }
    } failure:^(NSError *error) { }];
}

- (void)loadMoreRecordData
{
    self.page ++;
    __weak typeof(self) homeSelf = self;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"api/loan/record/", self.comment.ID];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    [TFNetworkTools getResultWithUrl:urlStr params:params success:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        NSArray<TFDocument *>*moreDocument = [TFDocument mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        [homeSelf.tableView.mj_footer endRefreshing];
        
        if (moreDocument.count == 0) {
            [homeSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [homeSelf.document addObjectsFromArray:moreDocument];
            [homeSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.document.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFDocumentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DocumentID];
    cell.document = self.document[indexPath.row];
    
    return cell;
}
@end
