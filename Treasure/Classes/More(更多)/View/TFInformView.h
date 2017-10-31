//
//  TFInformView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFInformView : UIView
/*** 是否可以拖拽 ***/
@property (nonatomic ,assign) BOOL isCanScroll;
/*** 关闭定时器 ***/
- (void)removeTimer;
/*** 添加定时器 ***/
- (void)addTimer;
@end
