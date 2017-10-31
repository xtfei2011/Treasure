//
//  TFShopViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFShopViewController.h"
#import "TFShopViewCell.h"
#import "TFShopTopView.h"
#import "TFAlertView.h"
#import "TFPopView.h"

@interface TFShopViewController ()<TFShopViewCellDelegate, TFPopViewDelegate, TFShopTopViewBtnDelegate>
@property (nonatomic ,strong) TFShopTopView *shopTopView;
/** 商城数据 */
@property (nonatomic ,strong) NSMutableArray<TFShop *> *shop;
@property (nonatomic ,strong) TFAlertView *alertView;
/*** 兑换流量 ***/
@property (nonatomic ,strong) NSString *phoneStr;
@property (nonatomic ,strong) NSString *commodStr;
@end

@implementation TFShopViewController
NSString * const ShopViewCellID = @"ShopViewCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupTopView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"积分商城";
    
    [self.view addSubview:self.shopListView];
    
    [self setupRefresh];
}

- (void)setupTopView
{
    self.shopTopView = [TFShopTopView viewFromXib];
    self.shopTopView.delegate = self;
    [self.shopListView addSubview:self.shopTopView];
}

- (void)setupRefresh
{
    self.shopListView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadShopViewData)];
    [self.shopListView.mj_header beginRefreshing];
}

- (void)loadShopViewData
{
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:@"api/activity/exchangeGoodsList" params:nil success:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        
        homeSelf.shop = [TFShop mj_objectArrayWithKeyValuesArray:dict];
        [homeSelf.shopListView reloadData];
        [homeSelf.shopListView.mj_header endRefreshing];
    } failure:^(NSError *error) { }];
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(TFMainScreen_Width/2, TFMainScreen_Width/2 + 50);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _layout;
}

- (UICollectionView *)shopListView
{
    if (_shopListView == nil) {
        
        _shopListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, TFMainScreen_Height - 64) collectionViewLayout:self.layout];
        _shopListView.backgroundColor = TFGlobalBg;
        _shopListView.dataSource = self;
        _shopListView.delegate = self;
        
        [self registerSectionReuseViewOrCell];
    }
    return _shopListView;
}

/*** 各 section 头部 ReuseView 和 cell 的注册 ***/
- (void)registerSectionReuseViewOrCell
{
    [_shopListView registerClass:[TFShopViewCell class] forCellWithReuseIdentifier:ShopViewCellID];
}

#pragma mark 头视图尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(TFMainScreen_Width, 98);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shop.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFShopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.shop = self.shop[indexPath.row];
    return cell;
}

/*** 商城顶部按钮代理方法 ***/
- (void)shopTopViewButtonClick:(UIButton *)sender
{
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

/*** 兑换话费和流量的情况 ***/
- (void)shopViewCellConversionBtnClick:(TFShopViewCell *)cell
{
    TFAccount *account = [TFAccountTool account];
    if (account.access_token == nil) {
        [TFProgressHUD showInfoMsg:@"您还没有登录哦！"]; return;
    }
    
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    [_alertView setHintType:TFHintTypeSelect];
    NSString *titleStr = [NSString stringWithFormat:@"兑换该产品将消费您 【%@】 积分，您确定要兑换吗？",cell.shop.price];
    [_alertView setPromptTitle:titleStr font:14];
    [TFkeyWindowView addSubview:_alertView];
    
    __weak typeof(self) homeSelf = self;
 
    if ([cell.shop.title hasSuffix:@"流量"] || [cell.shop.title hasSuffix:@"话费"]) {
        
        _alertView.block = ^(NSInteger index) {
            [homeSelf.alertView removeFromSuperview];
            
            if (index == 2001) {
                [homeSelf importPhoneView];
                homeSelf.commodStr = cell.shop.ID;
            }
        };
        
    } else {
        _alertView.block = ^(NSInteger index) {
            [homeSelf.alertView removeFromSuperview];
            
            if (index == 2001) {
                [homeSelf.alertView removeFromSuperview];
                [homeSelf conversionWithCommodityID:cell.shop.ID phone:nil];
            }
        };
    }
}

- (void)importPhoneView
{
    TFPopView *popView = [[TFPopView alloc] init];
    popView.delegate = self;
    popView.textFieldView.textField.placeholder = @"输入您要兑换的手机号码";
    popView.textFieldView.titleLabel.text = @"兑换手机号";
    [self.view addSubview:popView];
}

- (void)popViewDetermineBtnClick:(NSString *)text className:(__unsafe_unretained Class)className
{
    if (text.length == 0) {
        [TFProgressHUD showInfoMsg:@"手机号码不能为空！"];
    } else {
        [self conversionWithCommodityID:self.commodStr phone:text];
        self.commodStr = nil;
    }
}

- (void)conversionWithCommodityID:(NSString *)ID phone:(NSString *)phone
{
    [TFProgressHUD showLoading:@"正在兑换···"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"goods_id"] = ID;
    params[@"mobile"] = phone;
    
    [TFNetworkTools getResultWithUrl:@"api/activity/exchange" params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@200]) {
            [TFProgressHUD showSuccess:responseObject[@"msg"]];
        } else {
            [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) { }];
}
@end
