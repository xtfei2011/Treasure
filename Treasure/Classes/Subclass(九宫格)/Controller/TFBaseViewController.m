//
//  TFBaseViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFBaseViewController.h"
#import "TFDropMenuView.h"
#import "TFFundRecordViewCell.h"
#import "TFMineInvestViewCell.h"
#import "TFReceivableViewCell.h"
#import "TFMenuGenre.h"
#import "TFMenuPeriod.h"
#import "TFInvestDetailsController.h"

@interface TFBaseViewController ()<TFDropMenuDelegate, TFDropMenuDataSource>
@property (nonatomic ,strong) TFDropMenuView *dropMenuView;
/** 公共数据 */
@property (nonatomic ,strong) NSMutableArray<TFBaseModel *> *baseModel;
/** 状态数据 */
@property (nonatomic ,strong) NSMutableArray<TFMenuGenre *> *menuGenre;
/** 时间数据 */
@property (nonatomic ,strong) NSMutableArray<TFMenuPeriod *> *menuPeriod;
/** 分页 */
@property (nonatomic ,assign) NSInteger page;
/*** 状态分类 ***/
@property (nonatomic ,strong) NSString *status;
/*** 时间分类 ***/
@property (nonatomic ,strong) NSString *time;
@end

@implementation TFBaseViewController
/** cell的重用标识 */
static NSString * const FundRecordViewID = @"TFFundRecordViewCell";
static NSString * const MineInvestViewID = @"TFMineInvestViewCell";
static NSString * const ReceivableViewID = @"TFReceivableViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*** 初始化分类设置 ***/
    [self setupSort];
    
    /*** 初始化TabelView ***/
    [self setupTabelView];
    
    [self.view addSubview:_baseTableView];
    
    /*** 加载资金记录数据 ***/
    [self setupRefresh];
}

- (void)setupSort
{
    switch (self.type) {
        case 0:
            [self loadMenuData:MENU_BASE_FUNDRECORD];
            self.baseTableView.rowHeight = 44.5;
            
            break;
        case 1:
            [self loadMenuData:MENU_BASE_MINEINVEST];
            self.baseTableView.rowHeight = 173;
            
            break;
        case 2:
            [self loadMenuData:MENU_BASE_NOTRECOVERED];
            self.baseTableView.rowHeight = 65;
            
            break;
        case 3:
            [self loadMenuData:MENU_BASE_HASBEENBACK];
            self.baseTableView.rowHeight = 65;
            
            break;
        default:
            break;
    }
}

- (void)loadMenuData:(NSString *)url
{
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:url params:nil success:^(id responseObject) {
        
        NSDictionary *dic = responseObject[@"data"];
        NSMutableArray *genreArray = [NSMutableArray new];
        NSMutableArray *periodArray = [NSMutableArray new];
        
        if (dic[@"funds_status"]) {
            genreArray = dic[@"funds_status"]; periodArray = dic[@"funds_time"];
            
        } else if (dic[@"invest_status"]) {
            genreArray = dic[@"invest_status"]; periodArray = dic[@"invest_time"];
            
        } else if (dic[@"invest_repay_filter"]) {
            genreArray = dic[@"invest_repay_filter"]; periodArray = dic[@"invest_repay_time"];
        }
        homeSelf.menuGenre = [TFMenuGenre mj_objectArrayWithKeyValuesArray:genreArray];
        homeSelf.menuPeriod = [TFMenuPeriod mj_objectArrayWithKeyValuesArray:periodArray];
        
        [self setupMenuView];
    } failure:^(NSError *error) { }];
}

#pragma mark ---------------------  设置顶部下拉菜单栏
- (void)setupMenuView
{
    _dropMenuView = [[TFDropMenuView alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    _dropMenuView.delegate = self;
    _dropMenuView.dataSource = self;
    [self.view addSubview:_dropMenuView];
    
    [_dropMenuView selectDeafultIndexPath];
}

- (NSInteger)numberOfColumnsInMenu:(TFDropMenuView *)menu
{
    return 2;
}

- (NSInteger)menu:(TFDropMenuView *)menu numberOfRowsInColumn:(NSInteger)column
{
    return (column == 0) ? self.menuGenre.count : self.menuPeriod.count;
}

- (NSString *)menu:(TFDropMenuView *)menu titleForRowAtIndexPath:(TFIndexPath *)indexPath
{
    return (indexPath.column == 0) ? self.menuGenre[indexPath.row].name : self.menuPeriod[indexPath.row].name;
}

- (void)menu:(TFDropMenuView *)menu didSelectRowAtIndexPath:(TFIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        [self topMenuViewBtnClick:self.menuGenre[indexPath.row].code time:self.time];
    }else{
        [self topMenuViewBtnClick:self.status time:self.menuPeriod[indexPath.row].code];
    }
}

/*** 点击状态菜单 ***/
- (void)topMenuViewBtnClick:(NSString *)status time:(NSString *)time
{
    self.status = status; self.time = time;
    
    [self setupRefresh];
}

#pragma mark ---------------------  设置TableView
- (UITableView *)baseTableView
{
    if (!_baseTableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _baseTableView = [[UITableView alloc] init];
        _baseTableView.frame = CGRectMake(0, 0, TFMainScreen_Width, TFMainScreen_Height - 44);
        _baseTableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = TFGlobalBg;
    }
    return _baseTableView;
}

- (void)setupTabelView
{
    /*** 资金记录 ***/
    [self.baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFFundRecordViewCell class]) bundle:nil] forCellReuseIdentifier:FundRecordViewID];
    /*** 我的投资 ***/
    [self.baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFMineInvestViewCell class]) bundle:nil] forCellReuseIdentifier:MineInvestViewID];
    /*** 回款明细 ***/
    [self.baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFReceivableViewCell class]) bundle:nil] forCellReuseIdentifier:ReceivableViewID];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.tableFooterView = [UIView new];
}

- (void)setupRefresh
{
    self.baseTableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecordData)];
    [self.baseTableView.mj_header beginRefreshing];
    
    self.baseTableView.mj_footer = [TFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecordData)];
}

/*** 获取数据 ***/
- (void)loadRecordData
{
    self.page = 1;
    
    __weak typeof(self) homeSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    
    if (self.type == 1) {
        params[@"invest_status"] = self.status;
        params[@"invest_time"] = self.time;
        
    } else {
        params[@"funds_status"] = self.status;
        params[@"funds_time"] = self.time;
    }
    
    NSString *urlString = (self.type == 0) ? BASE_LIST_FUNDRECORD : (self.type == 1) ? BASE_LIST_MINEINVEST : (self.type == 2) ? BASE_LIST_NOTRECOVERED : BASE_LIST_HASBEENBACK;
    
    [TFNetworkTools getResultWithUrl:urlString params:params success:^(id responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        homeSelf.baseModel = [TFBaseModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
        if (homeSelf.baseModel.count == 0) {
            [homeSelf.baseTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [homeSelf.baseTableView reloadData];
        }
        [homeSelf.baseTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {  }];
}

/*** 获取更多数据 ***/
- (void)loadMoreRecordData
{
    self.page ++;
    
    __weak typeof(self) homeSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"page"] = @(self.page);
    
    if (self.type == 1) {
        params[@"invest_status"] = self.status;
        params[@"invest_time"] = self.time;
        
    } else {
        params[@"funds_status"] = self.status;
        params[@"funds_time"] = self.time;
    }
    
    NSString *urlString = (self.type == 0) ? BASE_LIST_FUNDRECORD : (self.type == 1) ? BASE_LIST_MINEINVEST : (self.type == 2) ? BASE_LIST_NOTRECOVERED : BASE_LIST_HASBEENBACK;
    
    [TFNetworkTools getResultWithUrl:urlString params:params success:^(id responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        NSArray<TFBaseModel *>*moreBaseModel = [TFBaseModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        if (moreBaseModel.count == 0) {
            [homeSelf.baseTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [homeSelf.baseModel addObjectsFromArray:moreBaseModel];
            [homeSelf.baseTableView reloadData];
        }
        [homeSelf.baseTableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baseModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 0) {
        TFFundRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FundRecordViewID];
        cell.baseModel = self.baseModel[indexPath.row];
        return cell;
        
    } else if(self.type == 1) {
        TFMineInvestViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineInvestViewID];
        cell.baseModel = self.baseModel[indexPath.row];
        return cell;
        
    } else {
        TFReceivableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReceivableViewID];
        cell.baseModel = self.baseModel[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!(self.type == 1)) return;
    
    TFInvestDetailsController *investDetails = [[TFInvestDetailsController alloc] init];
    investDetails.comment = (TFComment *)self.baseModel[indexPath.row];
    [self.navigationController pushViewController:investDetails animated:YES];
}
@end
