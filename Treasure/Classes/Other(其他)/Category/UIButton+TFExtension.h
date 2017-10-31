//
//  UIButton+TFExtension.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TFExtension)
+ (UIButton *)buttonWithTitle:(NSString *)title subTitle:(NSString *)subTitle target:(id)target selector:(SEL)selector frame:(CGRect)frame image:(UIImage *)image;

+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
@end
