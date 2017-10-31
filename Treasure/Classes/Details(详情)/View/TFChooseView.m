//
//  TFChooseView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFChooseView.h"

@implementation TFChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView
{
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.xtf_width, self.xtf_height)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.xtf_width, 40)];
    titleLabel.textColor = TFColor(252, 99, 102);
    titleLabel.text = @"优惠选择";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:titleLabel];
    
    _cancelBtn = [UIButton createButtonFrame:CGRectMake(self.xtf_width - 50, 10, 40, 20) title:@"取消" titleColor:[UIColor whiteColor] font:TFSetPromptTitleFont target:self action:@selector(determine:)];
    _cancelBtn.tag = 1111;
    [_baseView addSubview:_cancelBtn];
    
    _buttonView = [[TFButtonView alloc] initWithFrame:CGRectMake(0, 40, self.xtf_width, self.xtf_height - 95)];
    _buttonView.backgroundColor = [UIColor yellowColor];
    [_baseView addSubview:_buttonView];
    
    _sureBtn = [UIButton createButtonFrame:CGRectMake(10, _baseView.xtf_height - 45, _buttonView.xtf_width - 20, 35) title:@"确定" titleColor:[UIColor whiteColor] font:TFSetPromptTitleFont target:self action:@selector(determine:)];
    _sureBtn.tag = 1112;
    [_baseView addSubview:_sureBtn];
}

- (void)setButtonModel:(TFButtonModel *)buttonModel
{
    _buttonModel = buttonModel;
    
    _buttonView.buttonModel = buttonModel;
}

- (void)determine:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(chooseViewSureButtonClick:)]) {
        [self.delegate chooseViewSureButtonClick:sender];
    }
}
@end
