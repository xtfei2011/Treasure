//
//  TFTextField.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTextField.h"
#import "UITextField+TFExtension.h"

@implementation TFTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置光标颜色
    self.tintColor = TFColor(252, 99, 102);
    // 设置默认的占位文字颜色
    self.placeholderColor = [UIColor grayColor];
}

/**
 *  调用时刻 : 成为第一响应者(开始编辑\弹出键盘\获得焦点)
 */
- (BOOL)becomeFirstResponder
{
    self.placeholderColor = [UIColor grayColor];
    return [super becomeFirstResponder];
}

/**
 *  调用时刻 : 不做第一响应者(结束编辑\退出键盘\失去焦点)
 */
- (BOOL)resignFirstResponder
{
    self.placeholderColor = [UIColor lightGrayColor];
    return [super resignFirstResponder];
}
@end
