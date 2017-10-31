//
//  TFIntroduceViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntroduceViewCell.h"
#import "TFPlanView.h"

@interface TFIntroduceViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *enableMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mannerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *planLabel;
@property (nonatomic ,strong) TFPlanView *planView;
@end

@implementation TFIntroduceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIntroduce:(TFIntroduce *)introduce
{
    _introduce = introduce;
    
    _dateLabel.text = [NSString stringWithFormat:@"投标日期:%@",introduce.create_time];
    _enableMoneyLabel.text = introduce.amount;
    _residueLabel.text = introduce.can_invested_money;
    _mannerLabel.text = introduce.repay_method;
    _numberLabel.text = introduce.ID;
    
    _planView = [[TFPlanView alloc] initWithFrame:CGRectMake(0, 0, _baseView.xtf_width - 50, 5)];
    _planView.planValue = [NSString stringWithFormat:@"%.2f",[introduce.invest_schedule doubleValue]/100];
    [_baseView addSubview:_planView];
    
    _planLabel.text = [NSString stringWithFormat:@"%@%%",introduce.invest_schedule];
}

- (IBAction)IntroduceViewBtnClick:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1000;
    if (self.block) {
        self.block(index);
    }
}
@end
