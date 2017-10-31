//
//  TFInvestDetailsHeaderView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInvestDetailsHeaderView.h"

@interface TFInvestDetailsHeaderView ()
/*** 年化率 ***/
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
/*** 安全等级 ***/
@property (weak, nonatomic) IBOutlet UILabel *riskLabel;
/*** 周期 ***/
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
/*** 起投金额 ***/
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/*** 贷款方式 ***/
@property (weak, nonatomic) IBOutlet UILabel *repaymentLabel;
/*** 优惠劵 ***/
@property (weak, nonatomic) IBOutlet UILabel *treatmentLabel;
@end

@implementation TFInvestDetailsHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.treatmentLabel.layer.cornerRadius = 2;
    self.treatmentLabel.layer.masksToBounds = YES;
    self.treatmentLabel.layer.borderWidth = 0.5;
    self.treatmentLabel.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setInvestDetail:(TFInvestDetail *)investDetail
{
    _investDetail = investDetail;
    
    _interestLabel.text = investDetail.apr;
    _riskLabel.text = investDetail.risk_level;
    
    if (!investDetail.reward_apr) {
        _treatmentLabel.hidden = YES;
        
    } else if ([investDetail.reward_apr doubleValue] == 0) {
        
        _treatmentLabel.hidden = YES;
    } else {
        _treatmentLabel.text = [NSString stringWithFormat:@" +%@%% ",investDetail.reward_apr];
    }
    
    _periodLabel.text = [NSString stringWithFormat:@"%@个月", investDetail.deadline];
    _repaymentLabel.text = investDetail.loan_way;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.xtf_width = TFMainScreen_Width;
}
@end
