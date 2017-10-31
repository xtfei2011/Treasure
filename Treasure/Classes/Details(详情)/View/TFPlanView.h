//
//  TFPlanView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/21.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFPlanView : UIView
/*** 进度值 ***/
@property (nonatomic ,strong) NSString *planValue;
/*** 进度条颜色 ***/
@property (nonatomic ,strong) UIColor *planColor;
/*** 进度条背景色 ***/
@property (nonatomic ,strong) UIColor *baseColor;
/*** 进度条速度 ***/
@property (nonatomic ,assign) float speed;
@end
