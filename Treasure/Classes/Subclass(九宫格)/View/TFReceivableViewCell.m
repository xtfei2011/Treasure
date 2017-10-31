//
//  TFReceivableViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFReceivableViewCell.h"

@interface TFReceivableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *periodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *remaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@end

@implementation TFReceivableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setBaseModel:(TFBaseModel *)baseModel
{
    _baseModel = baseModel;
    
    _periodsLabel.text = [NSString stringWithFormat:@"[%@]",baseModel.periods];
    _titleLabel.text = baseModel.title;
    _timeLabel.text = baseModel.back_time;
    _noteLabel.text = baseModel.name;
    
    NSNumberFormatter *interest = [[NSNumberFormatter alloc] init];
    NSNumber *interestNum = [interest numberFromString:baseModel.bx];
    interest.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *interestStr = [interest stringFromNumber:interestNum];
    _interestLabel.text = interestStr;
    
    if ([baseModel.to_be_recovered isEqualToString:@""]) {
        
        _waitLabel.hidden = YES;
        _yuanLabel.hidden = YES;
        _remaiLabel.hidden = YES;
    }else{
        
        _waitLabel.hidden = NO;
        _yuanLabel.hidden = NO;
        _remaiLabel.hidden = NO;
        
        NSNumberFormatter *remai = [[NSNumberFormatter alloc] init];
        NSNumber *remaiNum = [remai numberFromString:baseModel.to_be_recovered];
        remai.numberStyle = kCFNumberFormatterDecimalStyle;
        NSString *remaiStr = [remai stringFromNumber:remaiNum];
        _remaiLabel.text = remaiStr;
    }
}
@end
