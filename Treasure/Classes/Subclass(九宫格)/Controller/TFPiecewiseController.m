//
//  TFPiecewiseController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPiecewiseController.h"
#import "TFEnableAwardController.h"
#import "TFOverdueAwardController.h"
#import "TFRewardsViewController.h"
#import "TFTitleButton.h"
#import "TFIntegralRecordController.h"
#import "TFIntegralEmployController.h"
#import "TFRewards.h"

@interface TFPiecewiseController ()<UIScrollViewDelegate>
/** 当前选中的标题按钮 */
@property (nonatomic ,weak) TFTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic ,weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic ,weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic ,weak) UIView *titlesView;

@property (nonatomic ,strong) TFRewards *rewards;
/** 活动状态 */
@property (nonatomic ,strong) NSString *activity;
@end

@implementation TFPiecewiseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self loadData];
    
//    [self setupChildViewControllers];
}

- (void)loadData
{
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:@"api/blessOpen" params:nil success:^(id responseObject) {
        TFLog(@"%@",responseObject);
        homeSelf.rewards = [TFRewards mj_objectWithKeyValues:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setRewards:(TFRewards *)rewards
{
    _rewards = rewards;
    
    self.activity = rewards.name;
    
    if ([rewards.status isEqualToString:@"open"]) {
        
        [self setupChildViewControllers:1];
    } else {
        [self setupChildViewControllers:0];
    }
    
    [self setupScrollView];
    
    [self setupTitlesView];
    
    // 默认添加子控制器的view
    [self addChildVcView];
}

- (void)setupChildViewControllers:(NSInteger )teger
{
    if (self.type == 0 && teger == 1) {
        
        TFRewardsViewController *rewards = [[TFRewardsViewController alloc] init];
        [self addChildViewController:rewards];
        
        TFEnableAwardController *enableAward = [[TFEnableAwardController alloc] init];
        [self addChildViewController:enableAward];
        
        TFOverdueAwardController *overdueAward = [[TFOverdueAwardController alloc] init];
        [self addChildViewController:overdueAward];
        
    } else if (self.type == 0 && teger == 0) {
        
        TFEnableAwardController *enableAward = [[TFEnableAwardController alloc] init];
        [self addChildViewController:enableAward];
        
        TFOverdueAwardController *overdueAward = [[TFOverdueAwardController alloc] init];
        [self addChildViewController:overdueAward];
        
    } else {
        TFIntegralRecordController *integralRecord = [[TFIntegralRecordController alloc] init];
        [self addChildViewController:integralRecord];
        
        TFIntegralEmployController *integralEmploy = [[TFIntegralEmployController alloc] init];
        [self addChildViewController:integralEmploy];
    }
}

- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = TFGlobalBg;
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;

    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.xtf_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.frame = CGRectMake(0, 0, self.view.xtf_width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSArray *activity = [self.rewards.status isEqualToString:@"open"] ? @[self.activity ,@"可使用", @"已过期"] : @[@"可使用", @"已过期"];
    
    NSArray *titles = (self.type) ? @[@"积分记录", @"使用记录"] : activity;
    NSUInteger count = titles.count;
    CGFloat titleButtonW = titlesView.xtf_width / count;
    CGFloat titleButtonH = titlesView.xtf_height;
    for (NSUInteger i = 0; i < count; i++) {
  
        TFTitleButton *titleButton = [TFTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    
    TFTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.xtf_height = 1;
    indicatorView.xtf_y = titlesView.xtf_height - indicatorView.xtf_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.xtf_width = firstTitleButton.titleLabel.xtf_width;
    indicatorView.xtf_centerX = firstTitleButton.xtf_centerX;
    
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(TFMainScreen_Width/2 - 0.5, 5, 1, 25)];
    line.backgroundColor = TFGlobalBg;
    [self.titlesView addSubview:line];
}

- (void)setupNav
{
    self.view.backgroundColor = TFGlobalBg;
    if (self.type == 1) return;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"help" highImage:nil target:self action:@selector(helpClickBtn)];
}

- (void)helpClickBtn
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/couponHelp")];
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - 监听点击
- (void)titleClick:(TFTitleButton *)titleButton
{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        return;
    }
    
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.xtf_width = titleButton.titleLabel.xtf_width;
        self.indicatorView.xtf_centerX = titleButton.xtf_centerX;
    }];
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.xtf_width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.xtf_width;
    
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.xtf_width;
    TFTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    
    [self addChildVcView];
}
@end
