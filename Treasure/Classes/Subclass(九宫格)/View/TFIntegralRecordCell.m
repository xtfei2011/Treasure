//
//  TFIntegralRecordCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntegralRecordCell.h"

@interface TFIntegralRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@end

@implementation TFIntegralRecordCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setIntegralRecord:(TFIntegralRecord *)integralRecord
{
    _integralRecord = integralRecord;
    
    _timeLabel.text = integralRecord.create_time;
    
    if ([integralRecord.income integerValue] == 0) {
        _integralLabel.text = [NSString stringWithFormat:@"- %.f分",[integralRecord.outlay doubleValue]];
        _integralLabel.textColor = TFColor(36, 181, 232);
    }else{
        _integralLabel.text = [NSString stringWithFormat:@"+ %.f分",[integralRecord.income doubleValue]];
        _integralLabel.textColor = TFColor(251, 99, 102);
    }
    _sourceLabel.text = integralRecord.remark_str;
}
@end
