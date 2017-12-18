//
//  TFRewardsViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/12/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRewardsViewController.h"
#import "TFRewardsCell.h"
#import "TFInstruction.h"
#import "TFActivity.h"

@interface TFRewardsViewController ()
@property (nonatomic ,strong) TFActivity *activity;
@end

@implementation TFRewardsViewController
static NSString *const RewardsID = @"activity";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TFRandomColor;
    
    [self setupCollectionView];
    [self setupTopView];
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:@"api/user/blessingData" params:nil success:^(id responseObject) {
        TFLog(@"%@",responseObject);
        homeSelf.activity = [TFActivity mj_objectWithKeyValues:responseObject[@"data"][@"blessing"]];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
    }];
}

- (void)setupTopView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, TFMainScreen_Width, 580 *TFMainScreen_Width/720);
    imageView.image = [UIImage imageNamed:@"总规则"];
    [self.collectionView addSubview:imageView];
}

- (void)setupCollectionView
{
    self.collectionView.backgroundColor = TFGlobalBg;
    self.collectionView.contentInset = UIEdgeInsetsMake(36, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"TFRewardsCell" bundle:nil] forCellWithReuseIdentifier:RewardsID];
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    return [self initWithCollectionViewLayout:layout];
}

#pragma mark 头视图尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(TFMainScreen_Width, 580 *TFMainScreen_Width/720 + 10);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((TFMainScreen_Width - 10)/2, (TFMainScreen_Width - 10)/2 + 70);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFRewardsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RewardsID forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        if ([self.activity.bless_xin_status isEqualToString:@"enable"]) {
            cell.rewardsView.image = [UIImage imageNamed:@"黑福0"];
        } else {
            cell.rewardsView.image = [UIImage imageNamed:@"福0"];
        }
    }
    
    if (indexPath.row == 1) {
        if ([self.activity.bless_ji_status isEqualToString:@"enable"]) {
            cell.rewardsView.image = [UIImage imageNamed:@"黑福1"];
        } else {
            cell.rewardsView.image = [UIImage imageNamed:@"福1"];
        }
    }
    
    if (indexPath.row == 2) {
        if ([self.activity.bless_yuan_status isEqualToString:@"enable"]) {
            cell.rewardsView.image = [UIImage imageNamed:@"黑福2"];
        } else {
            cell.rewardsView.image = [UIImage imageNamed:@"福2"];
        }
    }
    
    if (indexPath.row == 3) {
        if ([self.activity.bless_jin_status isEqualToString:@"enable"]) {
            cell.rewardsView.image = [UIImage imageNamed:@"黑福3"];
        } else {
            cell.rewardsView.image = [UIImage imageNamed:@"福3"];
        }
    }
    
    if (indexPath.row == 4) {
        if ([self.activity.bless_fu_status isEqualToString:@"enable"]) {
            cell.rewardsView.image = [UIImage imageNamed:@"黑福4"];
        } else {
            cell.rewardsView.image = [UIImage imageNamed:@"福4"];
        }
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat alertH = TFMainScreen_Height /2 + 50;
    TFInstruction *instruction = [[TFInstruction alloc] initWithFrame:CGRectMake(50, ((TFMainScreen_Height - alertH)/2), TFMainScreen_Width - 100, alertH)];
    instruction.num = indexPath.row + 1;
    
    [instruction show];
}
@end
