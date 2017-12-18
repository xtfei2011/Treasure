//
//  TFTextFieldPopView.m
//  JYTreasure
//
//  Created by 谢腾飞 on 2017/5/10.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTextFieldPopView.h"

typedef void(^determineBtnClick)(NSString *text);
typedef void(^cancelBtnClick)(void);

@interface TFTextFieldPopView ()
@property (nonatomic ,strong) UIButton *cancelBtn;
@property (nonatomic ,strong) UIButton *determineBtn;
@property (nonatomic ,copy) determineBtnClick determineBtnClick;
@property (nonatomic ,copy) cancelBtnClick cancelBtnClick;
@end
@implementation TFTextFieldPopView

+ (instancetype)textFieldPopView:(void(^)(NSString *text))determineBtnClick cancelBtnClick:(void(^)())cancelBtnClick
{
    TFTextFieldPopView *popView = [[self alloc] init];
    popView.frame = CGRectMake(30, TFMainScreen_Height/3, TFMainScreen_Width - 60, 155);
    popView.determineBtnClick = determineBtnClick;
    popView.cancelBtnClick = cancelBtnClick;
    
    return popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        
        [self createTitleLabel];
        [self createTextField];
        [self createButton];
        [self createOkBtn];
    }
    return self;
}

- (void)createTitleLabel
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width - 60, 44)];
    _titleLabel.font = TFMoreTitleFont;
    _titleLabel.backgroundColor = TFColor(252, 99, 102);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
}

- (void)createTextField
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 15, TFMainScreen_Width - 90, 38)];
    _textField.font = TFMoreTitleFont;
    _textField.tintColor = [UIColor grayColor];
    _textField.layer.borderWidth = 0.5;
    _textField.layer.borderColor = TFColor(205, 205, 205).CGColor;
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 3;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 38)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:_textField];
}

- (void)createButton
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textField.frame) + 15, TFMainScreen_Width - 60, 0.5)];
    line.backgroundColor = TFColor(205, 205, 205);
    [self addSubview:line];
    
    UIView *lines = [[UIView alloc] initWithFrame:CGRectMake(TFMainScreen_Width/2 - 29.5, CGRectGetMaxY(_textField.frame) + 15, 0.5, 45)];
    lines.backgroundColor = TFColor(205, 205, 205);
    [self addSubview:lines];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBtn.frame = CGRectMake(15, CGRectGetMaxY(line.frame) + 5, (TFMainScreen_Width - 120)/2, 35);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
}

- (void)createOkBtn
{
    _determineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _determineBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame)+30, CGRectGetMinY(_cancelBtn.frame), (TFMainScreen_Width - 120)/2.0, 35);
    [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_determineBtn setTitleColor:TFColor(252, 99, 102) forState:UIControlStateNormal];
    [_determineBtn addTarget:self action:@selector(determineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_determineBtn];
}

- (void)determineBtnClick:(UIButton *)btn
{
    if (self.determineBtnClick) {
        
        NSString *text = nil;
        if (_textField.text.length == 0) {
            [TFProgressHUD showInfoMsg:@"没有任何输入！"];
        } else {
            text = _textField.text;
        }
        self.determineBtnClick(text);
        [self endEditing:YES];
    }
}

- (void)cancelBtnPress:(UIButton *)btn
{
    if (self.cancelBtnClick) {
        self.cancelBtnClick();
        [self endEditing:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}
@end
