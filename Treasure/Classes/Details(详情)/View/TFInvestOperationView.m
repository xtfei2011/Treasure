//
//  TFInvestOperationView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInvestOperationView.h"

@interface TFInvestOperationView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *passView;
@end

@implementation TFInvestOperationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _moneyfield.delegate = self;
}

- (void)setInvestDetail:(TFInvestDetail *)investDetail
{
    _investDetail = investDetail;
    
    _titleLabel.text = investDetail.title;
    
    if ([investDetail.loan_way isEqualToString:@"车贷"]) {
        _iconView.image = [UIImage imageNamed:@"车贷"];
    }else{
        _iconView.image = [UIImage imageNamed:@"房贷"];
    }
    
    _numberLabel.text = [NSString stringWithFormat:@"借款编号:%@",investDetail.loan_id];
    _loanLabel.text = [NSString stringWithFormat:@"贷款方式:%@",investDetail.loan_way];
    _timelabel.text = [NSString stringWithFormat:@"投资期限:%@个月",investDetail.deadline];
    _interestLabel.text = [NSString stringWithFormat:@"预期年化率:%@%%",investDetail.apr];
    _levelLabel.text = [NSString stringWithFormat:@"安全级别:%@",investDetail.risk_level];
    
    NSNumberFormatter *castTer = [[NSNumberFormatter alloc] init];
    NSNumber *number = [castTer numberFromString:investDetail.amount];
    castTer.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *str = [castTer stringFromNumber:number];
    _castLabel.text = [NSString stringWithFormat:@"%@元",str];
    
    NSNumberFormatter *moneyTer = [[NSNumberFormatter alloc] init];
    NSNumber *moneyber = [moneyTer numberFromString:investDetail.can_invested_money];
    moneyTer.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *moneystr = [moneyTer stringFromNumber:moneyber];
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",moneystr];
    
    if ([investDetail.lock isEqualToString:@"on"]) {
        _passView.hidden = NO;
    }else{
        _passView.hidden = YES;
    }
}

- (IBAction)rechargeButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(investmentOperationChooseBtn:)]) {
        [self.delegate investmentOperationChooseBtn:sender];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    
    return [self isValid:checkStr withRegex:regex];
}

- (BOOL)isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicte evaluateWithObject:checkStr];
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self endEditing:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.xtf_width = TFMainScreen_Width;
}
@end
