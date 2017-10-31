//
//  TFCommentBaseController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFCommentBaseController.h"

@interface TFCommentBaseController ()

@end

@implementation TFCommentBaseController

- (void)viewWillAppear:(BOOL)animated
{
    /*** 键盘出现，消失的通知 ***/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*** 键盘出现的时候 ***/
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    /** 取出动画时长 */
    CGFloat animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    /** 取出键盘位置大小信息 */
    CGRect keyboardBounds = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    /** 记录Y轴变化 */
    CGFloat keyboardHeight = keyboardBounds.size.height;
    
    [UIView animateKeyframesWithDuration:animationDuration delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, - keyboardHeight + keyboardHeight/2);
    } completion:nil];
}

/*** 键盘消失的时候 ***/
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    /** 取出动画时长 */
    CGFloat animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    /** 回复动画 */
    [UIView animateKeyframesWithDuration:animationDuration delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

/*** 销毁通知 ***/
- (void)dealloc
{
    TFLog(@"--->销毁通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
