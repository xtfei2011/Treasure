//
//  TFHomeViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFHomeViewController.h"
#import "TFTopScrollView.h"
#import "TFScrollViewModel.h"
#import "TFStatisticalViewCell.h"
#import "TFNoviceViewCell.h"
#import "TFRecomViewCell.h"
#import "TFInvestDetailsController.h"
#import "TFShopViewController.h"
#import "TFAlertView.h"

@interface TFHomeViewController ()<ClickPushDelegate, TFNoviceBtnDelegate>
/*** Top 滚动视图 ***/
@property (nonatomic ,strong) TFTopScrollView *topScrollView;
@property (nonatomic ,strong) NSMutableArray *array;
/*** 累计统计 ***/
@property (nonatomic ,strong) TFStatistical *statistical;
/*** 新手数据 ***/
@property (nonatomic ,strong) NSMutableArray<TFNovice *> *novice;
/*** 推荐数据 ***/
@property (nonatomic ,strong) NSMutableArray<TFComment *> *comment;
@property (nonatomic ,strong) TFAlertView *alertView;
@end

@implementation TFHomeViewController
/** cell的重用标识 */
static NSString * const TFStatisticalID = @"TFStatisticalViewCell";
static NSString * const TFNoviceID = @"TFNoviceViewCell";
static NSString * const TFRecommendID = @"TFRecomViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    
    self.hidesBottomBarWhenPushed = NO;
    
    [self setupNavigationItem];
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupNavigationItem
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 117, 21.6)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:titleView.bounds];
    image.image = [UIImage imageNamed:@"biaoti"];
    [titleView addSubview:image];
    
    self.navigationItem.titleView = titleView;
}

- (void)setupTabelView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    /*** 注册 cell ***/
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFStatisticalViewCell class]) bundle:nil] forCellReuseIdentifier:TFStatisticalID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFNoviceViewCell class]) bundle:nil] forCellReuseIdentifier:TFNoviceID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFRecomViewCell class]) bundle:nil] forCellReuseIdentifier:TFRecommendID];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataSource
{
    [self loadVersionNumber];
    [self setTopScrollView];
    [self loadTopScrollData];
    [self loadHomeData];
}

/*** 轮播视图 ***/
- (void)setTopScrollView
{
    _topScrollView = [[TFTopScrollView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width,ScrollViewHeight)];
    _topScrollView.delegate = self;
    self.tableView.tableHeaderView = _topScrollView;
}

- (void)loadVersionNumber
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"device"] = @"ios";
    params[@"version"] = @"2.0.4";
    
    [TFNetworkTools getResultWithUrl:@"api/checkversion" params:params success:^(id responseObject) {
        
        if ([responseObject[@"data"][@"is_update"] isEqualToString:@"no"] || ![responseObject[@"code"] isEqual:@200]) return;
        
        [self update];
    } failure:^(NSError *error) { }];
}

/*** 版本检测 ***/
- (void)update
{
    _alertView.block = ^(NSInteger index) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Upgrade_StoreInterface]];
    };
    
    [_alertView setPromptTitle:@"为了让您的资金得到更加安全的保障，我们程序猿GG夜以继日，终于推出了更优质的全新版本！快去更新体验一下吧!" font:14];
    [_alertView setHintType:TFHintTypeDefault];
    [TFkeyWindowView addSubview:_alertView];
}

/*** 加载滚动数据 ***/
- (void)loadTopScrollData
{
    __weak typeof(self) homeSelf = self;
    
    [TFNetworkTools getResultWithUrl:@"api/banner" params:nil success:^(id responseObject) {
        
        NSArray *topArray = responseObject[@"data"];
        self.array = [[NSMutableArray alloc] initWithCapacity:topArray.count];
        for (NSDictionary * dict in topArray) {
            [self.array addObject:[[TFScrollViewModel alloc] initWithDict:dict]];
        }
        homeSelf.topScrollView.dataSource = self.array;
        [homeSelf.topScrollView startScroll];
    } failure:^(NSError *error) { }];
}

/*** 加载首页数据 ***/
- (void)loadHomeData
{
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:@"api/home" params:nil success:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        
        homeSelf.statistical = [TFStatistical mj_objectWithKeyValues:responseObject[@"data"]];
        homeSelf.novice = [TFNovice mj_objectArrayWithKeyValuesArray:dict[@"newbie"]];
        homeSelf.comment = [TFComment mj_objectArrayWithKeyValuesArray:dict[@"other"]];
        NSArray<TFComment *>*moreComment = [TFComment mj_objectArrayWithKeyValuesArray:dict[@"longloan"]];
        [homeSelf.comment addObjectsFromArray:moreComment];
        
        [homeSelf.tableView reloadData];
        [homeSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [TFProgressHUD showFailure:@"网络繁忙，稍后再试"];
        [homeSelf.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 2) ? self.comment.count : (self.comment.count) ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? 70 : (indexPath.section == 1) ? 325 : 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TFStatisticalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TFStatisticalID];
        cell.statistical = self.statistical;
        return cell;
        
    } else if (indexPath.section == 1) {
        TFNoviceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TFNoviceID];
        cell.novice = self.novice[indexPath.row];
        cell.delegate = self;
        return cell;
        
    } else {
        TFRecomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TFRecommendID];
        cell.comment = self.comment[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 || indexPath.section == 1) return;
     
    TFInvestDetailsController *investDetailsVC = [[TFInvestDetailsController alloc] init];
    investDetailsVC.comment = self.comment[indexPath.row];
    [self.navigationController pushViewController:investDetailsVC animated:YES];
}

/*** 轮播代理点击事件 ***/
- (void)pushController:(NSInteger)selectIndex
{
    NSString *status = [(TFScrollViewModel *)self.array[selectIndex] imageTitle];
    if ([status isEqualToString:@"mall"]) {
        
        TFShopViewController *shopVC = [[TFShopViewController alloc] init];
        [self.navigationController pushViewController:shopVC animated:YES];
    } else {
        TFWebViewController *webView = [[TFWebViewController alloc] init];
        [webView loadWebURLString:[(TFScrollViewModel *)self.array[selectIndex] imageID]];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

/*** 更多按钮代理点击 ***/
- (void)prefectureMoreBtnClick:(TFNoviceViewCell *)cell
{
    self.tabBarController.selectedIndex = 1;
}

/*** 新手立即投标按钮代理点击 ***/
- (void)onceInvestmentBtnClick:(TFNoviceViewCell *)cell
{
    TFInvestDetailsController *investDetailsVC = [[TFInvestDetailsController alloc] init];
    investDetailsVC.comment = (TFComment *)cell.novice;
    [self.navigationController pushViewController:investDetailsVC animated:YES];
}
@end
