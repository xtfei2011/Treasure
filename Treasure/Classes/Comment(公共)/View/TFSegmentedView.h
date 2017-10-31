//
//  TFSegmentedView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SegmentedBlock)(NSInteger index);

@interface TFSegmentedView : UIView
/*** 初始化 ***/
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(SegmentedBlock)block;
/*** 指示条 ***/
- (void)scrollIndicatorViewWithIndex:(NSInteger)index;
@end
