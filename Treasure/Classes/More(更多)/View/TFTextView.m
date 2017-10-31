//
//  TFTextView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTextView.h"

@interface TFTextView ()
@property (nonatomic, weak) UILabel *placehoderLable;
@end

@implementation TFTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceVertical = YES;
        
        UILabel *placehoderLable = [[UILabel alloc] init];
        placehoderLable.numberOfLines = 0;
        placehoderLable.backgroundColor = [UIColor clearColor];
        
        [self addSubview:placehoderLable];
        self.placehoderLable = placehoderLable;
        self.placehoderColor = [UIColor lightGrayColor];
        
        self.font = TFMoreTitleFont;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange
{
    self.placehoderLable.hidden = self.hasText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    self.placehoderLable.text = placehoder;
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placehoderLable.font = TFMoreTitleFont;
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    self.placehoderLable.textColor = placehoderColor;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placehoderLable.xtf_x = 5;
    self.placehoderLable.xtf_y = 8;
    self.placehoderLable.xtf_width = self.xtf_width - 2 * self.placehoderLable.xtf_x;
    CGSize maxSize = CGSizeMake(self.placehoderLable.xtf_width, MAXFLOAT);
    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLable.font maxSize:maxSize];
    self.placehoderLable.xtf_height = placehoderSize.height;
}
@end
