//
//  UIButton+TFExtension.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "UIButton+TFExtension.h"

@implementation UIButton (TFExtension)

+ (UIButton *)buttonWithTitle:(NSString *)title subTitle:(NSString *)subTitle target:(id)target selector:(SEL)selector frame:(CGRect)frame image:(UIImage *)image
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = TFMoreTitleFont;
    button.backgroundColor = [UIColor whiteColor];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(-20, 5 , 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-20, 0 , 0, 5);
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *smallTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, button.xtf_width, 20)];
    smallTitle.textAlignment = NSTextAlignmentCenter;
    smallTitle.text = subTitle;
    smallTitle.textColor = [UIColor grayColor];
    smallTitle.font = TFCommentTitleFont;
    [button addSubview:smallTitle];
    
    return button;
}

+ (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = TFColor(251, 99, 102);
    btn.layer.cornerRadius = 3.0f;
    btn.frame = frame;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
