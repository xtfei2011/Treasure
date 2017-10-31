//
//  TFCommentController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFCommentController.h"
#import "TFCommentViewCell.h"
#import "TFHeaderMenuView.h"
#import "TFInvestDetailsController.h"
#import "TFCountdownManager.h"

@interface TFCommentController ()
@property (nonatomic ,strong) TFHeaderMenuView *headerView;
/** 数据 */
@property (nonatomic ,strong) NSMutableArray<TFComment *> *comment;
/** 分页 */
@property (nonatomic ,assign) NSInteger page;
/** 年化率排序 */
@property (nonatomic ,strong) NSString *apr;
/** 投资期限排序 */
@property (nonatomic ,strong) NSString *deadline;
/** 接口尾部 */
@property (nonatomic ,strong) NSString *service;
@end

@implementation TFCommentController
/** cell的重用标识 */
static NSString * const TFCommentID = @"CommentViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*** 启动倒计时 ***/
    [[TFCountdownManager manager] start];
    
    self.view.backgroundColor = TFGlobalBg;
    
    self.service = (self.type == 2) ? @"api/invest" : @"api/investNewbie";
    
    [self setupMenuView];
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupMenuView
{
    _headerView = [[TFHeaderMenuView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 35)];
    [self.view addSubview:_headerView];
    
    [_headerView selectMenu:^(id object) {
        UIButton *sender = (UIButton *)object;
        
        if (sender.tag == 1) {
            self.apr = self.deadline = @"";
            [self setupRefresh];
            
        } else if (sender.tag == 2) {
            self.apr = @"asc";
        } else {
            self.apr = @""; self.deadline = @"asc";
        }
    }];
    
    [_headerView selectMenuAscend:^{
        self.apr = @"asc";
        [self setupRefresh];
    }];
    
    [_headerView selectMenuDescend:^{
        self.apr = @"desc";
        [self setupRefresh];
    }];
}

- (void)setupTabelView
{
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), TFMainScreen_Width, TFMainScreen_Height - 99)];
    _commentTableView.backgroundColor = TFGlobalBg;
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.rowHeight = 135;
    [self.view addSubview:_commentTableView];
    
    [_commentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFCommentViewCell class]) bundle:nil] forCellReuseIdentifier:TFCommentID];
    _commentTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setupRefresh
{
    [[TFCountdownManager manager] reload];
    
    self.commentTableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCommentData)];
    [self.commentTableView.mj_header beginRefreshing];
    
    self.commentTableView.mj_footer = [TFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentData)];
}

- (void)loadCommentData
{
    self.page = 1;
    
    __weak typeof(self) homeSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"page"] = @(self.page);
    params[@"apr"] = self.apr;
    params[@"deadline"] = self.deadline;
    
    [TFNetworkTools getResultWithUrl:self.service params:params success:^(id responseObject) {
       
        NSDictionary *dict = responseObject[@"data"];
        
        homeSelf.comment = [TFComment mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        [homeSelf.commentTableView reloadData];
        [homeSelf.commentTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [TFProgressHUD showFailure:@"网络繁忙，稍后再试"];
        [homeSelf.commentTableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreCommentData
{
    self.page ++;
    
    __weak typeof(self) homeSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"page"] = @(self.page);
    params[@"apr"] = self.apr;
    params[@"deadline"] = self.deadline;
    
    [TFNetworkTools getResultWithUrl:self.service params:params success:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        
        NSArray<TFComment *>*moreComment = [TFComment mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        [homeSelf.comment addObjectsFromArray:moreComment];
        [homeSelf.commentTableView reloadData];
        [homeSelf.commentTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
        [homeSelf.commentTableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TFCommentID];
    cell.comment = self.comment[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TFInvestDetailsController *investDetailsVC = [[TFInvestDetailsController alloc] init];
    investDetailsVC.comment = self.comment[indexPath.row];
    [self.navigationController pushViewController:investDetailsVC animated:YES];
}
@end
