//
//  UITextField+TFExtension.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "UITextField+TFExtension.h"

@implementation UITextField (TFExtension)
static NSString * const TFPlaceholderColorKey = @"placeholderLabel.textColor";

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 提前设置占位文字, 目的 : 让它提前创建placeholderLabel
    NSString *oldPlaceholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = oldPlaceholder;
    
    // 恢复到默认的占位文字颜色
    if (placeholderColor == nil) {
        placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:TFPlaceholderColorKey];
}

- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:TFPlaceholderColorKey];
}
@end
