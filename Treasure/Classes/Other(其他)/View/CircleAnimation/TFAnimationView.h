//
//  TFAnimationView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFAnimationView : UIView

/*************************  图形定制  *************************/
@property (nonatomic, strong) UIColor *pathBackColor;      /*** 线条背景色 ***/
@property (nonatomic, strong) UIColor *pathFillColor;      /*** 线条填充色 ***/

//角度相关
@property (nonatomic, assign) CGFloat startAngle;          /** <起点角度。角度从水平右侧开始为0，顺时针为增加角度。直接传度数 如-90 */
@property (nonatomic, assign) CGFloat reduceValue;         /** <减少的角度 直接传度数 如30*/
@property (nonatomic, assign) CGFloat strokeWidth;         /** <线宽*/

@property (nonatomic, assign) BOOL showProgressText;       /** <是否显示文字*/
@property (nonatomic, assign) BOOL increaseFromLast;       /** <是否从上次数值开始动画，默认为NO*/
@property (nonatomic, assign) BOOL notAnimated;            /** <不加动画，默认为NO*/
@property (nonatomic, assign) BOOL forceRefresh;           /** <set的progress等于上次时是否仍刷新，默认为NO*/

//进度
@property (nonatomic, assign) CGFloat progress;            /** <进度 0-1 */

//初始化 坐标 线条背景色 填充色 起始角度 线宽
- (instancetype)initWithFrame:(CGRect)frame pathBackColor:(UIColor *)pathBackColor pathFillColor:(UIColor *)pathFillColor startAngle:(CGFloat)startAngle strokeWidth:(CGFloat)strokeWidth;
@end
