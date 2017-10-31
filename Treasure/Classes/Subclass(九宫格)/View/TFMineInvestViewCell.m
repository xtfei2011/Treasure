//
//  TFMineInvestViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFMineInvestViewCell.h"

@interface TFMineInvestViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *mannerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorableLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;
@property (weak, nonatomic) IBOutlet UILabel *investTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enjoyLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@end

@implementation TFMineInvestViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setBaseModel:(TFBaseModel *)baseModel
{
    _baseModel = baseModel;
    
    _titleLabel.text = baseModel.title;
    _stateLabel.text = baseModel.remark_str;
    
    if ([baseModel.loan_way isEqualToString:@"车贷"]) {
        _pictureView.image = [UIImage imageNamed:@"车贷"];
    }else{
        _pictureView.image = [UIImage imageNamed:@"房贷"];
    }
    
    _numberLabel.text = [NSString stringWithFormat:@"借款编号:%@",baseModel.ID];
    _mannerLabel.text = [NSString stringWithFormat:@"贷款方式:%@",baseModel.loan_way];
    _timeLabel.text = [NSString stringWithFormat:@"投资期限:%@个月",baseModel.deadline];
    _interestLabel.text = [NSString stringWithFormat:@"预期年化率:%@%%",baseModel.apr];
    
    _gradeLabel.text = [NSString stringWithFormat:@"安全级别:%@",baseModel.risk_level];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:baseModel.money];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *money = [formatter stringFromNumber:number];
    _moneyLabel.text = [NSString stringWithFormat:@"投资金额:%@",money];
    
    if ([baseModel.coupon isEqualToString:@""]) {
        _favorableLabel.hidden = YES;
        _enjoyLabel.hidden = YES;
    }else{
        
        _favorableLabel.hidden = NO;
        _enjoyLabel.hidden = NO;
        _favorableLabel.text = [NSString stringWithFormat:@"  %@  ",baseModel.coupon];
    }

    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    NSNumber *num = [format numberFromString:baseModel.income];
    format.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *income = [formatter stringFromNumber:num];
    _earningsLabel.text = [NSString stringWithFormat:@"预期收益:%@元",income];
    
    _investTimeLabel.text = baseModel.create_time;
}
@end
