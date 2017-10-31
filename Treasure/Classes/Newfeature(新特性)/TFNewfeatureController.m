//
//  TFNewfeatureController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFNewfeatureController.h"
#import "TFTabBarController.h"

@interface TFNewfeatureController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation TFNewfeatureController
static CGFloat const TFNewfeatureCount = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat scrollW = scrollView.xtf_width;
    CGFloat scrollH = scrollView.xtf_height;
    
    for (int i = 0; i < TFNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.xtf_width = scrollW;
        imageView.xtf_height = scrollH;
        imageView.xtf_y = 0;
        imageView.xtf_x = i *scrollW;
        
        NSString *name = [NSString stringWithFormat:@"introduced00%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        if (i == 2) {
            [self setupLastImageView:imageView];
        }
    }
    scrollView.contentSize = CGSizeMake(TFNewfeatureCount *scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"开启财富之旅"] forState:UIControlStateNormal];
    
    startBtn.xtf_width = 200;
    startBtn.xtf_height = 40;
    startBtn.xtf_centerX = imageView.xtf_width * 0.5;
    startBtn.xtf_centerY = imageView.xtf_height * 0.9;
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}

- (void)startClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[TFTabBarController alloc] init];
}

- (void)dealloc
{
    TFLog(@"TFNewfeatureViewController-dealloc");
}
@end
