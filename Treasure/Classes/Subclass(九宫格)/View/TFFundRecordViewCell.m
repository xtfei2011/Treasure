//
//  TFFundRecordViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFFundRecordViewCell.h"

@interface TFFundRecordViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@end

@implementation TFFundRecordViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setBaseModel:(TFBaseModel *)baseModel
{
    _baseModel = baseModel;
    
    _timeLabel.text = baseModel.create_time;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    if ([baseModel.income integerValue] == 0) {
        
        NSNumber *number = [formatter numberFromString:baseModel.outlay];
        NSString *str = [formatter stringFromNumber:number];
        
        _moneyLabel.text = [NSString stringWithFormat:@"- %@",str];
        _moneyLabel.textColor = TFColor(36, 181, 232);
    }else{
        
        NSNumber *number = [formatter numberFromString:baseModel.income];
        NSString *str = [formatter stringFromNumber:number];
        
        _moneyLabel.text = [NSString stringWithFormat:@"+ %@",str];
        _moneyLabel.textColor = TFColor(251, 99, 102);
    }
    _remarkLabel.text = baseModel.remark_str;
}
@end
