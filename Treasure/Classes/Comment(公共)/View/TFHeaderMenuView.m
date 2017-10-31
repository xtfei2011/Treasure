//
//  TFHeaderMenuView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/12.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFHeaderMenuView.h"
#import "TFTitleButton.h"

@interface TFHeaderMenuView ()
@property (nonatomic ,strong) NSArray *selectItenms;
@property (nonatomic ,strong) TFMenuView *menuView;
@end

@implementation TFHeaderMenuView

- (NSArray *)selectItenms
{
    if (!_selectItenms) {
        
        _selectItenms = @[@"默认排序" ,@"预期年化" ,@"投资期限"];
    }
    return _selectItenms;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _menuView = [[TFMenuView alloc] initWithDataArray:self.selectItenms];
        _menuView.xtf_origin = CGPointMake(0, 0);
        _menuView.xtf_size = CGSizeMake(TFMainScreen_Width, 35);
        
        [self addSubview:_menuView];
    }
    return self;
}

+ (CGFloat)menuHeight
{
    return 35;
}

- (void)selectMenu:(HeaderMenuBlock)block
{
    _headerBlock = block;
    
    __weak typeof(self) homeSelf = self;
    _menuView.selectBlock = ^(UIButton *sender) {
        if (homeSelf.headerBlock) {
            homeSelf.headerBlock(sender);
        }
    };
}

- (void)selectMenuAscend:(MenuSortBlock)ascendBlock
{
    _ascendBlock = ascendBlock;
    
    __weak typeof(self) homeSelf = self;
    _menuView.ascendSortBlock = ^(void){
        if (homeSelf.ascendBlock) {
            homeSelf.ascendBlock();
        }
    };
}

- (void)selectMenuDescend:(MenuSortBlock)descendBlock
{
    _descendBlock = descendBlock;
    
    __weak typeof(self) homeSelf = self;
    _menuView.descendSortBlock = ^(void){
        if (homeSelf.descendBlock) {
            homeSelf.descendBlock();
        }
    };
}
@end


#pragma mark =====   /*** TFMenuView ***/

@interface TFMenuView ()
@property (nonatomic ,strong) UIButton *selectBtn;
@end

@implementation TFMenuView

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        
        _bottomLine = [UIView new];
        
        _bottomLine.frame = CGRectMake(20, 33, (TFMainScreen_Width - 120)/3, 2);
        _bottomLine.backgroundColor = TFColor(252, 99, 102);
    }
    return _bottomLine;
}

- (instancetype)initWithDataArray:(NSArray *)titleArray
{
    if ([super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        _titleArray = titleArray;
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    CGFloat titleButtonW = TFMainScreen_Width / 3;
    CGFloat titleButtonH = 35;
    
    [_titleArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        
        TFTitleButton *menuBtn = [TFTitleButton buttonWithType:UIButtonTypeCustom];
        
        menuBtn.tag = i + 1;
        menuBtn.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        [menuBtn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [menuBtn setImage:[UIImage imageNamed:@"list_nav_need"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /*** 调整按钮 文字 和 图片 间距 ***/
        [menuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -menuBtn.imageView.xtf_width - 5, 0, menuBtn.imageView.xtf_width)];
        [menuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, menuBtn.titleLabel.xtf_width + 5, 0, -menuBtn.titleLabel.xtf_width)];
        
        [self addSubview:menuBtn];
        
        if (i == 0) {
            menuBtn.selected = YES;
            menuBtn.userInteractionEnabled = NO;
            _selectBtn = menuBtn;
        }
    }];
    [self addSubview:self.bottomLine];
}

- (void)menuButtonClick:(UIButton *)sender
{
    NSString *btnStr = [sender titleForState:UIControlStateNormal];
    
    if ([btnStr isEqualToString:@"预期年化"]) {
        
        UIButton *button = [self viewWithTag:3];
        [button setImage:[UIImage imageNamed:@"list_nav_need"] forState:UIControlStateNormal];
        
        if ([[sender imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"list_nav_need_aesc"]]) {
            [sender setImage:[UIImage imageNamed:@"list_nav_need_desc"] forState:UIControlStateNormal];
            
            if (_descendSortBlock) {
                _descendSortBlock();
            }
            return;
        }
        [sender setImage:[UIImage imageNamed:@"list_nav_need_aesc"] forState:UIControlStateNormal];
        if (_ascendSortBlock) {
            _ascendSortBlock();
        }
    } else if ([btnStr isEqualToString:@"投资期限"]) {
        
        UIButton *button = [self viewWithTag:2];
        [button setImage:[UIImage imageNamed:@"list_nav_need"] forState:UIControlStateNormal];
        
        if ([[sender imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"list_nav_need_aesc"]]) {
            [sender setImage:[UIImage imageNamed:@"list_nav_need_desc"] forState:UIControlStateNormal];
            if (_descendSortBlock) {
                _descendSortBlock();
            }
            return;
        }
        [sender setImage:[UIImage imageNamed:@"list_nav_need_aesc"] forState:UIControlStateNormal];
        if (_ascendSortBlock) {
            _ascendSortBlock();
        }
    } else {
        for (NSInteger j = 2; j < 4; j ++) {
            UIButton *button = [self viewWithTag:j];
            [button setImage:[UIImage imageNamed:@"list_nav_need"] forState:UIControlStateNormal];
        }
    }
    [self refreshButtonState:sender];
    
    CGFloat lineWidth = _bottomLine.xtf_width;
    CGFloat x = (sender.tag - 1) * (20 + lineWidth) + (sender.tag) * 20;
    
    [self scrollBottomLine:x];
    
    if (_selectBlock) {
        _selectBlock(sender);
    }
}

- (void)refreshButtonState:(UIButton *)sender
{
    _selectBtn.selected = NO;
    _selectBtn.userInteractionEnabled = YES;
    sender.selected = !sender.selected;
    sender.userInteractionEnabled = NO;
    _selectBtn = sender;
    
    if (_selectBtn.tag == 3 || _selectBtn.tag == 2) {
        _selectBtn.userInteractionEnabled = YES;
    }
}

- (void)scrollBottomLine:(CGFloat)x
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _bottomLine.frame;
        rect.origin.x = x;
        _bottomLine.frame = rect;
    }];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    UIButton *sender = [self viewWithTag:_selectIndex + 1];
    [self refreshButtonState:sender];
    
    CGFloat lineWidth = _bottomLine.xtf_width;
    CGFloat x = (sender.tag - 1) * (20 + lineWidth) + (sender.tag) * 20;
    [self scrollBottomLine:x];
}
@end
