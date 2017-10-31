//
//  TFBanksViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/9/8.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFBanksViewController.h"
#import "TFBanksViewCell.h"
#import "TFAccountViewController.h"

@interface TFBanksViewController ()
@property (nonatomic ,strong) NSMutableArray<TFBank *> *bank;
@end

@implementation TFBanksViewController
/** cell的重用标识 */
static NSString * const BanksID = @"TFBanksViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupTabelView];
    
    [self loadBanksListData];
}

/*** 导航栏设置 ***/
- (void)setupNavigationItem
{
    self.navigationItem.title = @"选择银行";
}

- (void)setupTabelView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = 44;
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /*** 注册 cell ***/
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFBanksViewCell class]) bundle:nil] forCellReuseIdentifier:BanksID];
}

- (void)loadBanksListData
{
    __weak typeof(self) weakSelf = self;
    
    [TFNetworkTools getResultWithUrl:@"api/bankCode/zbank" params:nil success:^(id responseObject) {
        weakSelf.bank = [TFBank mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) { }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bank.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFBanksViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BanksID];
    cell.bank = self.bank[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TFBank *bank = self.bank[indexPath.row];
    self.selectBank(bank.bank_name, bank.bank_id);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
