//
//  TFTopScrollView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickPushDelegate <NSObject>
- (void)pushController:(NSInteger)selectIndex;
@end

@interface TFTopScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,assign) CGFloat touchPoint;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger currentPage;

/*** 数据源 ***/
@property (nonatomic ,strong) NSArray *dataSource;
@property (nonatomic ,assign) id<ClickPushDelegate>delegate;

/*** 开始滚动 ***/
- (void)startScroll;
/*** 停止滚动 ***/
- (void)stopScroll;
@end
