//
//  TFNoviceViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFNoviceViewCell.h"
#import "TFAnimationView.h"

@interface TFNoviceViewCell ()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UILabel *treatmentLabel;

@property (nonatomic ,strong) TFAnimationView *circlesView;
@end

@implementation TFNoviceViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.treatmentLabel.layer.cornerRadius = 2;
    self.treatmentLabel.layer.masksToBounds = YES;
    self.treatmentLabel.layer.borderWidth = 0.5;
    self.treatmentLabel.layer.borderColor = TFColor(252, 99, 102).CGColor;
}

/*** 更多按钮点击 ***/
- (IBAction)moreButtonClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(prefectureMoreBtnClick:)]){
        [_delegate prefectureMoreBtnClick:self];
    }
}

/*** 投标按钮点击 ***/
- (IBAction)onceInvestmentButtonClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(onceInvestmentBtnClick:)]){
        [_delegate onceInvestmentBtnClick:self];
    }
}

- (void)setNovice:(TFNovice *)novice
{
    _novice = novice;
    
    /*** 标题 ***/
    _titleLabel.text = novice.title;
    
    /*** 年化收益 ***/
    _yieldLabel.text = novice.apr;
    
    if (!novice.reward_apr) {
        _treatmentLabel.hidden = YES;
    }
    
    if ([novice.reward_apr isEqualToString:@"0.00"]) {
        
        _treatmentLabel.hidden = YES;
    } else {
        _treatmentLabel.hidden = NO;
        _treatmentLabel.text = [NSString stringWithFormat:@" +%@%% ",novice.reward_apr];
    }

    /*** 总金额 ***/
    if ([novice.amount doubleValue] > 10000) {
        _moneyLabel.text = [NSString stringWithFormat:@"总额 %.2f 万元",[novice.amount doubleValue]/10000];
    }else{
        _moneyLabel.text = [NSString stringWithFormat:@"总额 %.2f 元",[novice.amount doubleValue]];
    }
    
    /*** 投资周期 ***/
    _timeLabel.text = [NSString stringWithFormat:@"%@ 个月",novice.deadline];
    
    /*** 剩余可投金额 ***/
    if ([novice.can_invested_money doubleValue] > 10000) {
        
        _surplusLabel.text = [NSString stringWithFormat:@"剩余 %.2f 万元",[novice.can_invested_money doubleValue]/10000];
    }else{
        _surplusLabel.text = [NSString stringWithFormat:@"剩余 %.2f 元",[novice.can_invested_money doubleValue]];
    }
    
    /*** 安全等级 ***/
    _gradeLabel.text = novice.risk_level;
    
    /*** 环形进度条 ***/
    CGFloat total = [novice.amount doubleValue];
    CGFloat remain = [novice.can_invested_money doubleValue];
   
    _circlesView = [[TFAnimationView alloc] initWithFrame:self.animationView.bounds pathBackColor:nil pathFillColor:TFColor(252, 99, 102) startAngle:-255 strokeWidth:10];
    _circlesView.reduceValue = 30;
    _circlesView.showProgressText = NO;
    _circlesView.increaseFromLast = YES;
    _circlesView.progress = ((total - remain)/total);
    [self.animationView addSubview:_circlesView];
}
@end
