//
//  TFMoreViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFMoreViewController.h"
#import "TFTopScrollView.h"
#import "TFScrollViewModel.h"
#import "TFPersonGroup.h"
#import "TFNormalViewCell.h"
#import "TFMoreViewCell.h"
#import "TFShopViewController.h"
#import "TFOpinionViewController.h"
#import "TFLoginViewController.h"
#import "TFNavigationController.h"

@interface TFMoreViewController ()<ClickPushDelegate>
/*** Top 滚动视图 ***/
@property (nonatomic ,strong) TFTopScrollView *topScrollView;
@property (nonatomic ,strong) NSMutableArray *array;
/*** 添加组的数组 ***/
@property (nonatomic ,strong) NSMutableArray *normalArray;
@end

@implementation TFMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    
    [self setTopScrollView];
    [self loadTopScrollData];
    
    [self setupGroup];
}

- (void)setupGroup
{
    self.normalArray = [NSMutableArray array];
    
    /*** 第一组 ***/
    TFPersonGroup *group0 = [[TFPersonGroup alloc] init];
    TFNormalModel *info0 = [[TFNormalModel alloc] initWithTitle:@"公告信息"];
    TFNormalModel *info1 = [[TFNormalModel alloc] initWithTitle:@"新闻报道"];
    TFNormalModel *info2 = [[TFNormalModel alloc] initWithTitle:@"安全保障"];
    
    group0.items = @[info0, info1, info2];
    
    /*** 第二组 ***/
    TFPersonGroup *group1 = [[TFPersonGroup alloc] init];
    TFNormalModel *info6 = [[TFNormalModel alloc] initWithTitle:@"关于我们"];
    TFNormalModel *info7 = [[TFNormalModel alloc] initWithTitle:@"联系我们"];
    TFNormalModel *info8 = [[TFNormalModel alloc] initWithTitle:@"意见反馈"];
    
    group1.items = @[info6, info7, info8];
    
    [self.normalArray addObject:group0];
    [self.normalArray addObject:group1];
}

/*** 轮播视图 ***/
- (void)setTopScrollView
{
    _topScrollView = [[TFTopScrollView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width,ScrollViewHeight)];
    _topScrollView.delegate = self;
    
    self.tableView.tableHeaderView = _topScrollView;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section ? 44 : (340 * (TFMainScreen_Width /2 - 0.25) / 720);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    TFPersonGroup *temp = self.normalArray[section - 1];
    return temp.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.normalArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        TFMoreViewCell *moreCell = [TFMoreViewCell cellWithTableView:tableView];
        moreCell.block = ^(NSInteger index){
            if (index == 0) {
                TFAccount *account = [TFAccountTool account];
                if (!account.access_token) {
                    [self setupLoginView];
                    return ;
                }
                TFWebViewController *webView = [[TFWebViewController alloc] init];
                [webView loadWebURLString:Common_Interface_Montage(@"api/activity/lottery.html")];
                [self.navigationController pushViewController:webView animated:YES];
            }
            if (index == 1) {
                
                TFShopViewController *shopView = [[TFShopViewController alloc] init];
                [self.navigationController pushViewController:shopView animated:YES];
            }
        };
        return moreCell;
    }
    
    TFNormalViewCell *cell = [TFNormalViewCell initWithTableView:tableView];
    TFPersonGroup *group = self.normalArray[indexPath.section - 1];
    
    TFNormalModel *normalModel = group.items[indexPath.row];
    cell.normalModel = normalModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *urlStr = @[@"api/noticeListPage?device=ios", @"api/newsListPage?device=ios", @"api/activity/advantage.html", @"api/aboutus", @"api/contactus"];
    
    if (indexPath.section == 1) {
        
        [self jumpTargetWebView:urlStr[indexPath.row]];
        
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        
        TFOpinionViewController *opinionVC = [[TFOpinionViewController alloc] init];
        [self.navigationController pushViewController:opinionVC animated:YES];
    } else {
        [self jumpTargetWebView:urlStr[indexPath.row + 3]];
    }
}

/*** 轮播代理点击事件 ***/
- (void)pushController:(NSInteger)selectIndex
{
    NSString *status = [(TFScrollViewModel *)self.array[selectIndex] imageTitle];
    if ([status isEqualToString:@"mall"]){
        
        TFShopViewController *shopVC = [[TFShopViewController alloc] init];
        [self.navigationController pushViewController:shopVC animated:YES];
    } else {
        TFWebViewController *webView = [[TFWebViewController alloc] init];
        [webView loadWebURLString:[(TFScrollViewModel *)self.array[selectIndex] imageID]];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

/*** 所有跳转WebView ***/
- (void)jumpTargetWebView:(NSString *)url
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(url)];
    [self.navigationController pushViewController:webView animated:YES];
}

/*** 登录 ***/
- (void)setupLoginView
{
    if (whetherHaveNetwork == NO) {
        [TFProgressHUD showInfoMsg:@"无法连接服务器，请检查你的网络设置"];
        return;
    }
    TFLoginViewController *loginVC = [[TFLoginViewController alloc] init];
    TFNavigationController *loginNav = [[TFNavigationController alloc] initWithRootViewController:loginVC];
    
    [self.navigationController presentViewController:loginNav animated:YES completion:nil];
}
@end
