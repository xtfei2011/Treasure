//
//  TFInstruction.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/12/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInstruction.h"

@interface TFInstruction ()
@property (nonatomic, strong) UIView *backgroundView;
/*** 背景图 ***/
@property (nonatomic, strong) UIImageView *backgroundImage;
@end

@implementation TFInstruction

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor clearColor];
        
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.xtf_width, self.xtf_height)];
    _backgroundImage.userInteractionEnabled = YES;
    [self addSubview:_backgroundImage];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(60,self.xtf_height - 60,self.xtf_width - 120, 40);
    [confirmBtn setBackgroundColor:TFColor(252, 99, 102)];
    confirmBtn.layer.cornerRadius = 20;
    [confirmBtn addTarget:self action:@selector(signatureClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"知道啦" forState:UIControlStateNormal];
    [_backgroundImage addSubview:confirmBtn];
}

- (void)setNum:(NSInteger)num
{
    _num = num;
    _backgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",self.num]];
}

- (void)signatureClickButton:(UIButton *)signatureBtn
{
    [self close];
}

- (void)show
{
    if (self.backgroundView) return;
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, TFMainScreen_Height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    self.backgroundView.userInteractionEnabled = YES;
    self.backgroundView.backgroundColor = TFRGBColor(5, 5, 5, 0.6);
    [self.backgroundView addGestureRecognizer:tap];
    
    [TFkeyWindowView addSubview:self.backgroundView];
    [TFkeyWindowView addSubview:self];
}

- (void)close
{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self removeFromSuperview];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self close];
}
@end
