//
//  TFInvestDetailsController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInvestDetailsController.h"
#import "TFInvestDetailsHeaderView.h"
#import "TFIntroduceViewController.h"
#import "TFDocumentViewController.h"
#import "TFParticulViewController.h"
#import "TFTitleButton.h"
#import "TFInvestDetail.h"
#import "TFInvestOperationController.h"
#import "TFHeadAnimationView.h"

@interface TFInvestDetailsController ()<UIScrollViewDelegate>
/*** 头部动画 ***/
@property (nonatomic ,strong) TFHeadAnimationView *headerAnimationView;
/*** 头部视图 ***/
@property (nonatomic ,strong) TFInvestDetailsHeaderView *headerView;
/** 当前选中的标题按钮 */
@property (nonatomic ,weak) TFTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic ,weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic ,weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic ,weak) UIView *titlesView;
@property (nonatomic ,strong) TFInvestDetail *investDetail;
@end

@implementation TFInvestDetailsController
static CGFloat const SegmentationH = 43;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.comment.title;
    
    [self setupInvestDetailsData];
}

- (void)setupInvestDetailsData
{
    __weak typeof(self) homeSelf = self;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"api/loan/info/", self.comment.ID];
    
    [TFNetworkTools getResultWithUrl:urlStr params:nil success:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        homeSelf.investDetail = [TFInvestDetail mj_objectWithKeyValues:dict];
        [self loadAllView];
        
    } failure:^(NSError *error) {  }];
}

/*** 加载所有视图 ***/
- (void)loadAllView
{
    [self setupHeaderView];
    
    [self setupChildViewControllers];
    [self setupScrollView];
    [self setupTitlesView];
    // 默认添加子控制器的view
    [self addChildVcView];
    [self loadBottomButtonView];
}

/*** 加载头部视图 ***/
- (void)setupHeaderView
{
    _headerAnimationView = [[TFHeadAnimationView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 85)];
    [self.view addSubview:_headerAnimationView];
    
    _headerView = [TFInvestDetailsHeaderView viewFromXib];
    _headerView.investDetail = self.investDetail;
    [self.view addSubview:_headerView];
}

- (void)loadBottomButtonView
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,  TFMainScreen_Height - 114, TFMainScreen_Width, 50)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UIButton *btn = [UIButton createButtonFrame:CGRectMake(10, 5, baseView.xtf_width - 20, 40) title:self.investDetail.remark_str titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(actionButtonClick:)];
    
    if ([self.investDetail.remark_str isEqualToString:@"投标中"]) {
        btn.backgroundColor = TFColor(252, 99, 102);
    } else {
        btn.backgroundColor = TFColor(123, 123, 123);
        btn.userInteractionEnabled = NO;
    }
    [baseView addSubview:btn];
}

/*** 底部按钮点击事件 ***/
- (void)actionButtonClick:(UIButton *)sender
{
    TFAccount *account = [TFAccountTool account];
    if (!account.access_token) {
        [TFProgressHUD showInfoMsg:@"您还没有登录哦!"];
    } else {
        
        TFInvestOperationController *investOperation = [[TFInvestOperationController alloc] init];
        investOperation.comment = self.comment;
        investOperation.investDetail = self.investDetail;
        [self.navigationController pushViewController:investOperation animated:YES];
    }
}

- (void)setupChildViewControllers
{
    TFIntroduceViewController *introduce = [[TFIntroduceViewController alloc] init];
    introduce.comment = self.comment;
    [self addChildViewController:introduce];
    
    TFDocumentViewController *document = [[TFDocumentViewController alloc] init];
    document.comment = self.comment;
    [self addChildViewController:document];
    
    TFParticulViewController *particul = [[TFParticulViewController alloc] init];
    particul.comment = self.comment;
    [self addChildViewController:particul];
}

- (void)setupScrollView
{
    CGFloat scrollViewH = CGRectGetMaxY(_headerView.frame) + SegmentationH + 10;
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = TFGlobalBg;
    scrollView.frame = CGRectMake(0, scrollViewH + 0.5, self.view.xtf_width, self.view.xtf_height - scrollViewH);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.xtf_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesView
{
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame) + 10, self.view.xtf_width, SegmentationH);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSString *invest = [NSString stringWithFormat:@"投标记录 (%@)", self.investDetail.invest_ok_count];
    NSString *refund = [NSString stringWithFormat:@"还款明细 (%@)", self.investDetail.repay_details];
    
    NSArray *titles = @[@"项目信息", invest, refund];
    NSUInteger count = titles.count;
    CGFloat titleButtonW = titlesView.xtf_width / count;
    CGFloat titleButtonH = titlesView.xtf_height;
    
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        TFTitleButton *titleButton = [TFTitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton setImage:nil forState:UIControlStateNormal];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    
    // 按钮的选中颜色
    TFTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.xtf_height = 1;
    indicatorView.xtf_y = titlesView.xtf_height - indicatorView.xtf_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.xtf_width = firstTitleButton.titleLabel.xtf_width;
    indicatorView.xtf_centerX = firstTitleButton.xtf_centerX;
    
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
}

- (void)setupNav
{
    self.view.backgroundColor = TFGlobalBg;
}

#pragma mark - 监听点击
- (void)titleClick:(TFTitleButton *)titleButton
{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) return;
    
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
