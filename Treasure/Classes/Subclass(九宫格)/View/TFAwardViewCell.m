//
//  TFAwardViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAwardViewCell.h"

@interface TFAwardViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIButton *awardBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *pastBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation TFAwardViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setEnableAward:(TFEnableAward *)enableAward
{
    _enableAward = enableAward;
    
    if ([enableAward.name isEqualToString:@"relived"]) {
        _nameLabel.text = @"体验金";
        _moneyLabel.text = [NSString stringWithFormat:@"¥ %ld",[enableAward.money integerValue]];
    }
    if ([enableAward.name isEqualToString:@"award"]) {
        _nameLabel.text = @"现金券";
        _moneyLabel.text = [NSString stringWithFormat:@"¥ %ld",[enableAward.money integerValue]];
    }else if ([enableAward.name isEqualToString:@"addinterest"]){
        _nameLabel.text = @"加息券";
        _moneyLabel.text = [NSString stringWithFormat:@"¥ %.1f%%",[enableAward.money doubleValue]];
    }
    
    _moneyLabel.keywords = @"¥";
    _moneyLabel.keywordsFont = TFCommentTitleFont;
    _sourceLabel.text = [NSString stringWithFormat:@"(%@)",enableAward.type];
    _descriptionLabel.text = [NSString stringWithFormat:@"·%@",enableAward.descrip];
    _timeLabel.text = [NSString stringWithFormat:@"·%@ 至 %@",enableAward.start_date, enableAward.end_date];
    
    if ([enableAward.remark_str isEqualToString:@"未使用"]) {
        
        _checkBtn.hidden = YES; _awardBtn.hidden = NO; _pastBtn.hidden = YES;
        _awardBtn.layer.masksToBounds = YES;
        _awardBtn.layer.cornerRadius = 10;
        _awardBtn.layer.borderWidth = 1;
        _awardBtn.layer.borderColor = TFColor(252, 99, 102).CGColor;
        [_awardBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        return;
    }
    if ([enableAward.remark_str isEqualToString:@"已使用"]) {
        
        _checkBtn.hidden = NO; _awardBtn.hidden = YES; _pastBtn.hidden = YES;
        _checkBtn.layer.masksToBounds = YES;
        _checkBtn.layer.cornerRadius = 10;
        _checkBtn.layer.borderWidth = 1;
        _checkBtn.layer.borderColor = TFColor(252, 99, 102).CGColor;
        [_checkBtn setTitle:@"查看收益" forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(popTableView) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    if ([enableAward.remark_str isEqualToString:@"已过期"]) {
        
        _checkBtn.hidden = YES; _awardBtn.hidden = YES; _pastBtn.hidden = NO;
        _pastBtn.layer.masksToBounds = YES;
        _pastBtn.layer.cornerRadius = 10;
        _pastBtn.backgroundColor = TFrayColor(123);
        [_pastBtn setTitle:@"已过期" forState:UIControlStateNormal];
        return;
    }
}

- (void)layoutSubviews
{
    CGSize investSize =  [_moneyLabel getLableSizeWithMaxWidth:200];
    _moneyLabel.frame = CGRectMake(0, 0, investSize.width, investSize.height);
    [self.contentView addSubview:_moneyLabel];
}

- (IBAction)awardButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(awardViewCellClick:)]) {
        [self.delegate awardViewCellClick:self];
    }
}

- (void)popTableView
{
    if ([self.delegate respondsToSelector:@selector(awardViewCellClick:)]) {
        [self.delegate awardViewCellClick:self];
    }
}
@end
