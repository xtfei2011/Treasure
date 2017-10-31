//
//  TFStatisticalViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFStatisticalViewCell.h"
#import "TFAnimationLabel.h"

@interface TFStatisticalViewCell ()

@property (weak, nonatomic) IBOutlet TFAnimationLabel *investLabel;
@property (weak, nonatomic) IBOutlet TFAnimationLabel *repayLabel;
@property (weak, nonatomic) IBOutlet TFAnimationLabel *operationLabel;
@end

@implementation TFStatisticalViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (int i = 1; i < 3; i ++) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((TFMainScreen_Width - 0.8) * i/3, 10, 0.8, 40)];
        lineView.backgroundColor = TFGlobalBg;
        [self.contentView addSubview:lineView];
    }
}

- (void)setStatistical:(TFStatistical *)statistical
{
    _statistical = statistical;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    _investLabel.formatBlock = ^NSString *(CGFloat value) {
        NSString *formatted = [formatter stringFromNumber:@((double)value)];
        return [NSString stringWithFormat:@"%@",formatted];
    };
    [_investLabel countStartValue:10000 endValue:[statistical.total_invest_money doubleValue]/10000.00 duration:2.5];
    
    _repayLabel.formatBlock = ^NSString *(CGFloat value) {
        NSString *formatted = [formatter stringFromNumber:@((double)value)];
        return [NSString stringWithFormat:@"%@",formatted];
    };
    [_repayLabel countStartValue:10000 endValue:[statistical.total_repay_money doubleValue]/10000.00 duration:2.5];
    
    _operationLabel.formatBlock = ^NSString *(CGFloat value) {
        return [NSString stringWithFormat:@"%.lf",value];
    };
    [_operationLabel countStartValue:10000 endValue:[statistical.safe_run_days integerValue] duration:2.5];
}
@end
