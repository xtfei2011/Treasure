//
//  UIView+TFExtension.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TFExtension)
@property (nonatomic ,assign) CGSize xtf_size;
@property (nonatomic ,assign) CGFloat xtf_width;
@property (nonatomic ,assign) CGFloat xtf_height;
@property (nonatomic ,assign) CGFloat xtf_x;
@property (nonatomic ,assign) CGFloat xtf_y;
@property (nonatomic ,assign) CGFloat xtf_centerX;
@property (nonatomic ,assign) CGFloat xtf_centerY;
@property (nonatomic ,assign) CGPoint xtf_origin;

+ (instancetype)viewFromXib;
- (BOOL)intersectWithView:(UIView *)view;
@end
