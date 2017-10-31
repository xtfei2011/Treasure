//
//  TFTitleButton.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/12.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTitleButton.h"

@implementation TFTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:TFColor(252, 99, 102) forState:UIControlStateSelected];
        self.titleLabel.font = TFMoreTitleFont;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted{}
@end
