//
//  UIView+TFExtension.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "UIView+TFExtension.h"

@implementation UIView (TFExtension)

- (CGSize)xtf_size
{
    return self.frame.size;
}

- (void)setXtf_size:(CGSize)xtf_size
{
    CGRect frame = self.frame;
    frame.size = xtf_size;
    self.frame = frame;
}

- (CGFloat)xtf_width
{
    return self.frame.size.width;
}

- (CGFloat)xtf_height
{
    return self.frame.size.height;
}

- (void)setXtf_width:(CGFloat)xtf_width
{
    CGRect frame = self.frame;
    frame.size.width = xtf_width;
    self.frame = frame;
}

- (void)setXtf_height:(CGFloat)xtf_height
{
    CGRect frame = self.frame;
    frame.size.height = xtf_height;
    self.frame = frame;
}

- (CGFloat)xtf_x
{
    return self.frame.origin.x;
}

- (void)setXtf_x:(CGFloat)xtf_x
{
    CGRect frame = self.frame;
    frame.origin.x = xtf_x;
    self.frame = frame;
}

- (CGFloat)xtf_y
{
    return self.frame.origin.y;
}

- (void)setXtf_y:(CGFloat)xtf_y
{
    CGRect frame = self.frame;
    frame.origin.y = xtf_y;
    self.frame = frame;
}

- (CGFloat)xtf_centerX
{
    return self.center.x;
}

- (void)setXtf_centerX:(CGFloat)xtf_centerX
{
    CGPoint center = self.center;
    center.x = xtf_centerX;
    self.center = center;
}

- (CGFloat)xtf_centerY
{
    return self.center.y;
}

- (void)setXtf_centerY:(CGFloat)xtf_centerY
{
    CGPoint center = self.center;
    center.y = xtf_centerY;
    self.center = center;
}

- (CGPoint)xtf_origin
{
    return self.frame.origin;
}

- (void)setXtf_origin:(CGPoint)xtf_origin
{
    CGRect frame = self.frame;
    frame.origin = xtf_origin;
    self.frame = frame;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (BOOL)intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}
@end
