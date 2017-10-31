//
//  TFCountdownManager.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/7/21.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCountdownNotification @"TFCountdownNotification"
@interface TFCountdownManager : NSObject
/*** 时间差 ***/
@property (nonatomic ,assign) NSInteger timeInterval;

/***  使用单例 ***/
+ (instancetype)manager;
/***  开始倒计时 ***/
- (void)start;
/***  刷新倒计时 ***/
- (void)reload;
/***  停止倒计时 ***/
- (void)invalidate;
@end
