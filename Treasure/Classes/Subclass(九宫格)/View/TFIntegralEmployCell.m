//
//  TFIntegralEmployCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntegralEmployCell.h"

@interface TFIntegralEmployCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation TFIntegralEmployCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setIntegralEmploy:(TFIntegralEmploy *)integralEmploy
{
    _integralEmploy = integralEmploy;
    
    _titleLabel.text = [NSString stringWithFormat:@"[%@] %@",integralEmploy.goods_type, integralEmploy.title];
    
    _timeLabel.text = integralEmploy.create_time;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:integralEmploy.outlay];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *str = [formatter stringFromNumber:number];
    
    _integralLabel.text = [NSString stringWithFormat:@"使用积分：%@ 分",str];
    _integralLabel.keywords = str;
    _integralLabel.keywordsColor = TFColor(36, 181, 232);
    _integralLabel.keywordsFont = TFMoreTitleFont;
    
    _statusLabel.text = [NSString stringWithFormat:@"状态：%@", integralEmploy.reward_status];
    _statusLabel.keywords = integralEmploy.reward_status;
    _statusLabel.keywordsColor = TFColor(22, 153, 71);
    _statusLabel.keywordsFont = TFMoreTitleFont;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize investSize =  [_integralLabel getLableSizeWithMaxWidth:200];
    _integralLabel.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), investSize.width, investSize.height);
    [self.contentView addSubview:_integralLabel];
    
    CGSize statusSize =  [_statusLabel getLableSizeWithMaxWidth:200];
    _statusLabel.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), statusSize.width, statusSize.height);
    [self.contentView addSubview:_statusLabel];
}
@end
