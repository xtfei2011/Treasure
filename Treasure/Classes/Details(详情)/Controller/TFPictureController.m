//
//  TFPictureController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPictureController.h"
#import "TFPictureView.h"

@interface TFPictureController ()
@property (nonatomic ,strong) TFPictureView *topScrollView;
@end

@implementation TFPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"相关资料图片";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPictureViewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadPictureViewData
{
    NSString *urlStr = [NSString stringWithFormat:@"api/loan/img/%@",self.comment.ID];
    
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:urlStr params:nil success:^(id responseObject) {
        
        [self loadTopScrollView:responseObject[@"data"]];
        [homeSelf.tableView reloadData];
        [homeSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {  }];
}

/*** 加载图片九宫格 ***/
- (void)loadTopScrollView:(NSArray *)array
{
    _topScrollView = [[TFPictureView alloc]initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 0)];
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.data = array;
    [self.tableView addSubview:_topScrollView];
}
@end
