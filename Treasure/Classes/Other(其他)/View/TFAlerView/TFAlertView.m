//
//  TFAlertView.m
//  JYTreasure
//
//  Created by 谢腾飞 on 2017/5/8.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAlertView.h"

@interface TFAlertView ()
/*** 取消按钮 ***/
@property (nonatomic ,strong) UIButton *cancelBtn;
/*** 确认按钮 ***/
@property (nonatomic ,strong) UIButton *sureBtn;
/*** 提示文字 ***/
@property (nonatomic ,strong) UILabel *tipeLabel;
/*** 提示View ***/
@property (nonatomic ,strong) UIView *promptView;
@end

@implementation TFAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = TFRGBColor(5, 5, 5, 0.5);
        [self initView];
    }
    return self;
}

- (void)initView
{
    _promptView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.xtf_height - 150)/2, self.xtf_width - 60, 150)];
    _promptView.backgroundColor = [UIColor whiteColor];
    _promptView.layer.cornerRadius = 5;
    [self addSubview:_promptView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _promptView.xtf_width, 20)];
    titleLabel.text = @"温馨提示";
    titleLabel.textColor = TFColor(252, 99, 102);
    titleLabel.font = TFSetPromptTitleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_promptView addSubview:titleLabel];
    
    _tipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, _promptView.xtf_width - 20, _promptView.xtf_height - 90)];
    _tipeLabel.textAlignment = NSTextAlignmentCenter;
    _tipeLabel.numberOfLines = 0;
    [_promptView addSubview:_tipeLabel];

    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitleColor:TFrayColor(154) forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = TFMoreTitleFont;
    [_cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.backgroundColor = TFrayColor(247);
    [_promptView addSubview:_cancelBtn];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = TFMoreTitleFont;
    [_sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.backgroundColor = TFColor(252, 99, 102);
    [_promptView addSubview:_sureBtn];
}

- (void)setHintType:(TFHintType)hintType
{
    switch (hintType) {
        case TFHintTypeDefault:
            [self defaultHintTypeFrame];
            break;
            
        case TFHintTypeSelect:
            [self selectHintTypeFrame];
            break;
        default:
            break;
    }
}

- (void)selectHintTypeFrame
{
    _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_tipeLabel.frame) + 10, _promptView.xtf_width * 0.5, 40);
    _cancelBtn.tag = 2000;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _sureBtn.frame = CGRectMake(CGRectGetMaxX(_cancelBtn.frame), CGRectGetMinY(_cancelBtn.frame), _cancelBtn.xtf_width, _cancelBtn.xtf_height);
    _sureBtn.tag = 2001;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
}

- (void)defaultHintTypeFrame
{
    _sureBtn.frame = CGRectMake(0, CGRectGetMaxY(_tipeLabel.frame) + 10, _promptView.xtf_width, 40);
    _sureBtn.tag = 2000;
    [_sureBtn setTitle:@"我知道啦！" forState:UIControlStateNormal];
}

//设置提示语
- (void)setPromptTitle:(NSString *)title font:(CGFloat)font
{
    _tipeLabel.font = [UIFont systemFontOfSize:font];
    _tipeLabel.text = title;
}

//按钮方法
- (void)buttonClick:(UIButton *)sender
{
    if (self.block) {
        self.block(sender.tag);
    }
}
@end
