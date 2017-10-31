//
//  TFAnimationLabel.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/5.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *(^AnimationFormatBlock)(CGFloat value);

@interface TFAnimationLabel : UILabel
/*** 格式 ***/
@property (nonatomic ,strong) NSString *format;
/*** 动画持续时间 ***/
@property (nonatomic ,assign) NSTimeInterval animationDuration;
@property (nonatomic ,copy) AnimationFormatBlock formatBlock;
@property (nonatomic ,copy) void (^completionBlock)();

- (void)countStartValue:(CGFloat)startValue endValue:(CGFloat)endValue duration:(NSTimeInterval)duration;
@end
