//
//  TFTopScrollView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTopScrollView.h"
#import "TFScrollViewModel.h"
#import "UIButton+AFNetworking.h"

@interface TFTopScrollView ()

@end

@implementation TFTopScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addScrollView];
        [self addScrollIndicator];
    }
    return self;
}

#pragma mark  设置子视图
- (void)addScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
}

/*** 滚动指示 ***/
- (void)addScrollIndicator
{
    CGFloat pageControlY = self.xtf_height - 12;
    CGFloat pageControlW = self.xtf_width;
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, pageControlY, pageControlW, 6)];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPage = 0;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    self.pageControl.numberOfPages = _dataSource.count;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    self.touchPoint = self.xtf_width / _dataSource.count;
    
    for (int i = 0; i < _dataSource.count; i++) {
        
        TFScrollViewModel *scrollModel = _dataSource[i];
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.tag = 10001 + i;
        imageBtn.frame = CGRectMake(self.xtf_width * i, 0.0, self.xtf_width, self.xtf_height);
        
        [imageBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:scrollModel.imageUrl] placeholderImage:[UIImage imageNamed:@"homePageBgView"]];
        
        [imageBtn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchDown];
        
        [self.scrollView addSubview:imageBtn];
        [self addSubview:self.pageControl];
    }
    self.scrollView.contentSize = CGSizeMake(_dataSource.count * self.scrollView.xtf_width, 0);
}

- (void)startScroll
{
    [self stopScroll];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(cycleScroll) userInfo:nil repeats:YES];
}

#pragma mark 轮播方法
- (void)cycleScroll
{
    self.currentPage ++;
    
    if (self.currentPage == _dataSource.count) {
        self.currentPage = 0;
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.xtf_width * (self.currentPage % _dataSource.count), 0);
}

- (void)stopScroll
{
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self startScroll];
    
    [UIView animateWithDuration:1 animations:^{
        self.pageControl.currentPage = scrollView.contentOffset.x / TFMainScreen_Width;
    }];
}

- (void)imageButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(pushController:)]) {
        [self.delegate  pushController:button.tag - 10001];
    }
}
@end
