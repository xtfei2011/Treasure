//
//  TFPlanView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/21.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPlanView.h"

@interface TFPlanView ()
@property (nonatomic ,strong) UIView *viewTop;
@property (nonatomic ,strong) UIView *baseView;
@end

@implementation TFPlanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    _baseView = [[UIView alloc]initWithFrame:self.bounds];
    _baseView.backgroundColor = TFGlobalBg;
    _baseView.layer.cornerRadius = 3;
    _baseView.layer.masksToBounds = YES;
    [self addSubview:_baseView];
    
    _viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, _baseView.xtf_height)];
    _viewTop.backgroundColor = TFColor(251, 99, 102);
    _viewTop.layer.cornerRadius = 3;
    _viewTop.layer.masksToBounds = YES;
    [_baseView addSubview:_viewTop];
}

- (void)setSpeed:(float)speed
{
    _speed = speed;
}

- (void)setPlanValue:(NSString *)planValue
{
    if (!_speed) {
        _speed = 3.0f;
    }
    _planValue = planValue;
    
    [UIView animateWithDuration:_speed animations:^{
        _viewTop.frame = CGRectMake(_viewTop.frame.origin.x, _viewTop.frame.origin.y, _baseView.frame.size.width*[planValue floatValue], _viewTop.frame.size.height);
    }];
}

- (void)setBaseColor:(UIColor *)baseColor
{
    _baseColor = baseColor;
    _baseView.backgroundColor = baseColor;
}

- (void)setPlanColor:(UIColor *)planColor
{
    _planColor = planColor;
    _viewTop.backgroundColor = planColor;
}
@end
