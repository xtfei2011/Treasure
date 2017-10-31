//
//  TFParticulViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFParticulViewCell.h"

@interface TFParticulViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *particulLabel;
@property (weak, nonatomic) IBOutlet UILabel *principalLabel;
@end

@implementation TFParticulViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setParticul:(TFParticul *)particul
{
    _particul = particul;
    
    _periodLabel.text = [NSString stringWithFormat:@"  %@  ",particul.periods];
    
    _timeLabel.text = particul.repay_time;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    NSNumber *number = [formatter numberFromString:particul.bx];
    NSString *str = [formatter stringFromNumber:number];
    _particulLabel.text = [NSString stringWithFormat:@"本期还款:%@元",str];
    
    NSNumber *principalNumber = [formatter numberFromString:particul.bxye];
    NSString *string = [formatter stringFromNumber:principalNumber];
    
    if ([string isEqualToString:@"0"]) {
        _principalLabel.text = @" 结清本金 ";
        _principalLabel.textColor = TFColor(36, 180, 233);
    } else {
        _principalLabel.text = [NSString stringWithFormat:@"剩余本金:%@元",string];
    }
}
@end
