//
//  TFActionSheetCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/4/25.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFActionSheetCell.h"

@implementation TFActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
    }
    [self setNeedsLayout];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, 0, TFMainScreen_Width, 50);
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = TFSetPromptTitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
@end
