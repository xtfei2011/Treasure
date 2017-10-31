//
//  TFPhotoViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/22.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPhotoViewController.h"
#import <Photos/Photos.h>

@interface TFPhotoViewController ()<UIScrollViewDelegate>
/** 图片控件 */
@property (nonatomic ,weak) UIImageView *imageView;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,strong) UILabel *titleLab;
@end

@implementation TFPhotoViewController

- (UILabel *)titleLab
{
    if (!_titleLab) {
        self.titleLab = [[UILabel alloc] init];
    }
    return _titleLab;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setUpScrollView];
    [self setUpTopView];
}

- (void)setUpTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 64)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(TFMainScreen_Width / 2 - 50, 25, 100, 32)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:18];
    _titleLab.textColor = [UIColor whiteColor];
    [topView addSubview:_titleLab];
    
    if (self.data.count > 1) {
        _titleLab.text = [NSString stringWithFormat:@"1/%ld", (unsigned long)self.data.count];
    }
}

- (void)setUpScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.contentSize = CGSizeMake(self.data.count *TFMainScreen_Width, TFMainScreen_Height);
    
    for (int i = 0; i < self.data.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *TFMainScreen_Width, 0, TFMainScreen_Width, TFMainScreen_Height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *url = _data[i][@"img"];
        url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        self.imageView = imageView;
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.hidden = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}

- (void)tapAct:(UITapGestureRecognizer *)tap
{
    TFPictureViewItem *item = self.pictureView.items[_index];
    item.backgroundColor = [UIColor clearColor];
    [item.superview bringSubviewToFront:item];
    
    CGPoint point = [self.view convertPoint:CGPointZero toView:self.pictureView];
    
    item.frame = CGRectMake(point.x, point.y, TFMainScreen_Width, TFMainScreen_Height);
    
    [self dismissViewControllerAnimated:NO completion:^{
        [UIView animateWithDuration:0.5 animations:^{
            item.frame = item.originFrame;
        }];
    }];
}

/*** 视图即将出现时 ***/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect newFrame = [self.item.superview convertRect:self.item.frame toView:self.view];
    self.item.frame = newFrame;
    [self.view addSubview:self.item];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.item.frame = self.view.frame;
    } completion:^(BOOL finished) {
        _scrollView.hidden = NO;
        [self.item removeFromSuperview];
        self.item.frame = self.item.originFrame;
        [self.pictureView addSubview:self.item];
        [_scrollView scrollRectToVisible:CGRectMake(self.item.index * TFMainScreen_Width, 0, TFMainScreen_Width, TFMainScreen_Height) animated:NO];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _index = scrollView.contentOffset.x / TFMainScreen_Width;
    _titleLab.text = [NSString stringWithFormat:@"%ld / %ld",(unsigned long)_index + 1,(unsigned long)self.data.count];
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  返回一个scrollView的子控件进行缩放
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
