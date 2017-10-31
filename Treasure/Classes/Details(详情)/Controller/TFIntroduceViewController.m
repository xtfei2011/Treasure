//
//  TFIntroduceViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntroduceViewController.h"
#import "TFIntroduceViewCell.h"
#import "TFIntroduce.h"
#import "TFTextDisplayController.h"
#import "TFPictureController.h"

@interface TFIntroduceViewController ()
@property (nonatomic ,strong) TFIntroduce *introduce;
@end

@implementation TFIntroduceViewController
/** cell的重用标识 */
static NSString * const IntroduceID = @"IntroduceViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TFGlobalBg;
    [self setupTabelView];
    [self setupRefresh];
}

- (void)setupTabelView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFIntroduceViewCell class]) bundle:nil] forCellReuseIdentifier:IntroduceID];
    self.tableView.rowHeight = 408;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 51, 0);
}

- (void)setupRefresh
{
    self.tableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecordData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadRecordData
{
    NSString *urlStr = [NSString stringWithFormat:@"api/loan/info/%@",self.comment.ID];
    
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:urlStr params:nil success:^(id responseObject) {
        
        self.introduce = [TFIntroduce mj_objectWithKeyValues:responseObject[@"data"]];
        [homeSelf.tableView.mj_header endRefreshing];
        [homeSelf.tableView reloadData];
    } failure:^(NSError *error) { }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFIntroduceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IntroduceID];
    cell.introduce = self.introduce;
    
    NSString *urlStr1 = [NSString stringWithFormat:@"api/loan/description/%@", self.comment.ID];
    NSString *urlStr2 = [NSString stringWithFormat:@"api/loan/riskDescription/%@", self.comment.ID];
    
    cell.block = ^(NSInteger index){
        if (index == 2) {
            TFPictureController *picture = [[TFPictureController alloc] init];
            picture.comment = self.comment;
            [self.navigationController pushViewController:picture animated:YES];
            
        } else if (index < 2) {
            TFTextDisplayController *textDisplay = [[TFTextDisplayController alloc] init];
            textDisplay.urlStr = (index == 0) ? urlStr1 : urlStr2;
            textDisplay.navigationItem.title = (index == 0) ? @"贷款描述" : @"风险描述";
            [self.navigationController pushViewController:textDisplay animated:YES];
        }
    };
    return cell;
}
@end
