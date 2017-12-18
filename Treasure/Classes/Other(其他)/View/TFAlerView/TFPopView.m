//
//  TFPopView.m
//  JYTreasure
//
//  Created by 谢腾飞 on 2017/5/10.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPopView.h"

@interface TFPopView ()
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation TFPopView

+ (instancetype)popView
{
    TFPopView *popView = [[self alloc] init];
    popView.frame = [UIScreen mainScreen].bounds;
    return popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        [self setupBgView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardTextView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setupBgView
{
    self.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView.backgroundColor = TFRGBColor(5, 5, 5, 0.5);
    
    [TFkeyWindowView addSubview:self.backgroundView];
    
    [self popViewNicknameEditor];
}

- (void)keyboardTextView:(NSNotification *)note
{
    CGRect keyboardFrame = [note.userInfo[UIKeyboardIsLocalUserInfoKey] CGRectValue];
    CGFloat keyboard_Y = keyboardFrame.origin.y;
    if (keyboard_Y == TFMainScreen_Height) {
        self.transform = CGAffineTransformIdentity;
        return;
    }
    CGFloat text_Y = CGRectGetMaxY(_textFieldView.frame);
    
    if (text_Y > keyboard_Y) {
        self.transform = CGAffineTransformMakeTranslation(0, keyboard_Y);
    }
}

- (void)textDismiss
{
    [UIView animateWithDuration:0.1 animations:^{
        self.textFieldView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    }completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        self.backgroundView = nil;
    }];
}

/*** 号码编辑 ***/
- (void)popViewNicknameEditor
{
    TFTextFieldPopView *textField = [TFTextFieldPopView textFieldPopView:^(NSString *text) {
        if (_delegate && [_delegate respondsToSelector:@selector(popViewDetermineBtnClick:className:)]) {
            [_delegate popViewDetermineBtnClick:text className:[TFTextFieldPopView class]];
        }
        [self dismiss:self.textFieldView];
    } cancelBtnClick:^{
        if (_delegate && [_delegate respondsToSelector:@selector(popViewCancelBtnClick:)]) {
            [_delegate popViewCancelBtnClick:[TFTextFieldPopView class]];
        }
        [self dismiss:self.textFieldView];
    }];
    
    [TFkeyWindowView addSubview:textField];
    self.textFieldView = textField;
    
    textField.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        textField.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss:(UIView *)view
{
    [UIView animateWithDuration:0.5 animations:^{
        
        view.transform = CGAffineTransformMakeScale(0, 0);
        
    }completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        self.backgroundView = nil;
    }];
}

- (void)setSelectDataSource:(NSArray<NSString *> *)selectDataSource
{
    _selectDataSource = selectDataSource;
}
@end
