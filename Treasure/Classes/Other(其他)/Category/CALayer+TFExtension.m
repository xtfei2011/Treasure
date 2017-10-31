//
//  CALayer+TFExtension.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "CALayer+TFExtension.h"

@implementation CALayer (TFExtension)

- (void)setBorderUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
