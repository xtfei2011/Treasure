//
//  TFRefreshHeader.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRefreshHeader.h"

@interface TFRefreshHeader()
/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation TFRefreshHeader
/*** 初始化 ***/
- (void)prepare
{
    [super prepare];
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    self.stateLabel.textColor = [UIColor grayColor];
    self.stateLabel.font = self.lastUpdatedTimeLabel.font = TFMoreTitleFont;
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@""];
    [self addSubview:logo];
    self.logo = logo;
}

/**
 *  摆放子控件
 */
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.logo.xtf_width = self.xtf_width;
    self.logo.xtf_height = 50;
    self.logo.xtf_x = 0;
    self.logo.xtf_y = - 50;
}
@end
