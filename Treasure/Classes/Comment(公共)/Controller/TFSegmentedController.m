//
//  TFSegmentedController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFSegmentedController.h"
#import "TFSegmentedView.h"

@interface TFSegmentedController ()<UIScrollViewDelegate>
/*** UIScrollView ***/
@property (nonatomic ,strong) UIScrollView *scorllView;
/*** 导航栏上文字按钮 ***/
@property (nonatomic ,strong) TFSegmentedView *segmentedView;
@end

@implementation TFSegmentedController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupInvestTitleView];
    
    [self setupChildViewControllers];
    
    [self.view addSubview:self.scorllView];
}

- (void)setupInvestTitleView
{
    NSArray *topTitles = [NSMutableArray new];
    topTitles = (self.type == 0) ? @[@"定期产品", @"新手体验"] : @[@"待回收", @"已回收"];
    
    _segmentedView = [[TFSegmentedView alloc] initWithFrame:CGRectMake((TFMainScreen_Width - 170)/2, 0, 160, 44) titles:topTitles block:^(NSInteger index) {
        
        CGPoint point = CGPointMake(index *TFMainScreen_Width, _scorllView.contentOffset.y);
        [self.scorllView setContentOffset:point animated:YES];
    }];
    
    /*** 添加导航栏文字按钮View ***/
    self.navigationItem.titleView = self.segmentedView;
}

- (UIScrollView *)scorllView
{
    if (!_scorllView) {
        /*** 不允许自动调整scrollView的内边距 ***/
        self.automaticallyAdjustsScrollViewInsets = NO;
        _scorllView = [[UIScrollView alloc] init];
        _scorllView.frame = self.view.bounds;
        _scorllView.backgroundColor = TFGlobalBg;
        _scorllView.pagingEnabled = YES;
        _scorllView.showsHorizontalScrollIndicator = NO;
        _scorllView.showsVerticalScrollIndicator = NO;
        _scorllView.delegate = self;
    }
    return _scorllView;
}

/*** 添加子视图 ***/
- (void)setupChildViewControllers
{
    NSArray *viewArray = [NSMutableArray new];
    
    viewArray = (self.type == 0) ? @[@"TFTerminalController" ,@"TFNoviceController"] : @[@"TFNotRecoveredController" ,@"TFHasBeenBackController"];
    
    for (NSInteger i = 0; i < viewArray.count; i ++) {
        
        UIViewController *viewClass = [[NSClassFromString(viewArray[i]) alloc] init];
        [self addChildViewController:viewClass];
    }
    _scorllView.contentSize = CGSizeMake(TFMainScreen_Width * viewArray.count, 0);
    /*** 默认显示第一页 ***/
    _scorllView.contentOffset = CGPointMake(0, 0);
    [self scrollViewDidEndScrollingAnimation:self.scorllView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / TFMainScreen_Width;
    
    UIViewController *childVc = self.childViewControllers[index];
    [self.segmentedView scrollIndicatorViewWithIndex:index];
    
    /*** 判断是否加载 ***/
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = CGRectMake(offsetX, 0, TFMainScreen_Width, TFMainScreen_Height);
    [_scorllView addSubview:childVc.view];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self setupInvestTitleView];
}
@end
