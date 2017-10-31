//
//  TFActionSheet.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/4/25.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFActionSheet.h"

@interface TFActionSheet ()<UITableViewDelegate ,UITableViewDataSource ,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) UITableView *actionSheetView;
@property (nonatomic ,strong) UIButton *cancleBtn;
@property (nonatomic ,strong) NSArray *titles;
@property (nonatomic ,copy) ClickBlock btnClick;

@end

@implementation TFActionSheet

static NSString * const ActionSheetID = @"ActionSheetCell";

- (instancetype)initWithTitles:(NSArray *)titles clickAction:(ClickBlock)clickBlock
{
    if (self = [super init]) {
        
        _btnClick = clickBlock;
        _titles = titles;
        [self commnInit];
    }
    return self;
}

- (void)commnInit
{
    [self addSubview:self.actionSheetView];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
}

#pragma mark - 数据源

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:ActionSheetID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TFActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActionSheetID];
    }
    cell.titleLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.btnClick) {
        self.btnClick(self , indexPath);
    }
    [self hide];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = self.superview.bounds;
    self.actionSheetView.frame = CGRectMake(0, TFMainScreen_Height - (_titles.count + 1) * 50 - 5, TFMainScreen_Width, (_titles.count + 1) * 50 + 5);
}

- (UITableView *)actionSheetView
{
    if (!_actionSheetView) {
        _actionSheetView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _actionSheetView.delegate = self;
        _actionSheetView.dataSource = self;
        _actionSheetView.tableFooterView = [self createFooterView];
        _actionSheetView.tableFooterView.backgroundColor = TFGlobalBg;
        _actionSheetView.showsVerticalScrollIndicator = NO;
        _actionSheetView.scrollEnabled = NO;
        if ([_actionSheetView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_actionSheetView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_actionSheetView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_actionSheetView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_actionSheetView registerClass:[TFActionSheetCell class] forCellReuseIdentifier:ActionSheetID];
    }
    return _actionSheetView;
}

- (UIView *)createFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, 54)];
    footerView.backgroundColor = TFGlobalBg;
    [footerView addSubview:self.cancleBtn];
    return footerView;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(0, 8, TFMainScreen_Width, 46);
        [_cancleBtn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:TFColor(252, 99, 102) forState:UIControlStateNormal];
        [_cancleBtn setBackgroundColor:[UIColor whiteColor]];
    }
    return _cancleBtn;
}

- (void)cancleClick
{
    [self hide];
}

- (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alpha = 0.0f;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.35f delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
            self.actionSheetView.transform = CGAffineTransformMakeTranslation(0, -200);
            
        } completion:^(BOOL finished) { }];
    });
}

- (void)hide
{
    [UIView animateWithDuration:0.35f delay:0.0 usingSpringWithDamping:0.9  initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
        self.actionSheetView.frame = CGRectMake(0, TFMainScreen_Height, TFMainScreen_Width, (_titles.count + 1) * 50 + 5);

    } completion:^(BOOL finished) {
        
        self.alpha = 1.0f;
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.actionSheetView.frame, point))
    {
        [self hide];
    }
}
@end
