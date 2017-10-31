//
//  TFStatisticsViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFStatisticsViewCell.h"

@interface TFStatisticsViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *netValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *regainCapitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncoveredCapitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *regainPrincipalLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncollectedPrincipalLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncollectedAwardLabel;
@end

@implementation TFStatisticsViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

/*** 回报部分 ***/
- (void)setHarvest:(TFHarvest *)harvest
{
    _harvest = harvest;
    
    _netValueLabel.text = harvest.net_interest_income;
    _propertyLabel.text = harvest.wait_interest_income;
    _regainCapitalLabel.text = harvest.has_received_principal;
    _uncoveredCapitalLabel.text = harvest.wait_received_principal;
}

/*** 理财部分 ***/
- (void)setFinancial:(TFFinancial *)financial
{
    _financial = financial;
    
    _loanTotalLabel.text = financial.total_lending_amount;
    _loanSumLabel.text = [NSString stringWithFormat:@"%ld",[financial.total_lending_count integerValue]];
    _regainPrincipalLabel.text = financial.has_received_principal_and_interest;
    _uncollectedPrincipalLabel.text = financial.wait_received_principal_and_interest;
    _awardLabel.text = financial.has_received_reward;
    _uncollectedAwardLabel.text = financial.wait_received_reward;
}
@end
