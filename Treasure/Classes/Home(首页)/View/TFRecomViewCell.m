//
//  TFRecomViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRecomViewCell.h"

@interface TFRecomViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *treatmentLabel;
@end

@implementation TFRecomViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.treatmentLabel.layer.cornerRadius = 2;
    self.treatmentLabel.layer.masksToBounds = YES;
    self.treatmentLabel.layer.borderWidth = 0.5;
    self.treatmentLabel.layer.borderColor = TFColor(252, 99, 102).CGColor;
}

- (void)setComment:(TFComment *)comment
{
    _comment = comment;
    
    _titleLabel.text = comment.title;
    _timeLabel.text = comment.create_time;
    _yieldLabel.text = comment.apr;
    
    if (!comment.reward_apr) {
        _treatmentLabel.hidden = YES;
    } else if ([comment.reward_apr doubleValue] == 0) {
        
        _treatmentLabel.hidden = YES;
    } else {
        _treatmentLabel.hidden = NO;
        _treatmentLabel.text = [NSString stringWithFormat:@" +%@%% ",comment.reward_apr];
    }

    if ([comment.amount doubleValue] >= 10000) {
        _moneyLabel.text = [NSString stringWithFormat:@"可投金额：%.2f 万元",[comment.amount doubleValue] / 10000];
        _moneyLabel.keywords = @"万元";
    } else {
        _moneyLabel.text = [NSString stringWithFormat:@"可投金额：%.2f 元",[comment.amount doubleValue]];
        _moneyLabel.keywords = @"元";
    }
    
    if ([comment.can_invested_money doubleValue] == 0) {
        _surplusLabel.text = @"剩余可投：已售罄";
        
    } else if ([comment.can_invested_money doubleValue] >= 10000) {
        _surplusLabel.text = [NSString stringWithFormat:@"剩余可投：%.2f 万元",[comment.can_invested_money doubleValue] / 10000];
        _surplusLabel.keywords = @"万元";
    } else {
        _surplusLabel.text = [NSString stringWithFormat:@"剩余可投：%.2f 元",[comment.can_invested_money doubleValue]];
        _surplusLabel.keywords = @"元";
    }
}
@end
