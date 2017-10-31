//
//  TFVoluntarilyView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFVoluntarilyView.h"

@interface TFVoluntarilyView ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *rentalControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *onceControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *surplusControl;

/*** 自动投标总额 ***/
@property (nonatomic ,strong) NSString *rentalStr;
/*** 单次投标总额 ***/
@property (nonatomic ,strong) NSString *onceStr;
/*** 账户保留金额 ***/
@property (nonatomic ,strong) NSString *surplusStr;
@end

@implementation TFVoluntarilyView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _lowestRecognizer = [[UITapGestureRecognizer alloc] init];
    [_lowestLabel addGestureRecognizer:_lowestRecognizer];
    
    _highestRecognizer = [[UITapGestureRecognizer alloc] init];
    [_highestLabel addGestureRecognizer:_highestRecognizer];
    
    _minimumRecognizer = [[UITapGestureRecognizer alloc] init];
    [_minimumLabel addGestureRecognizer:_minimumRecognizer];
    
    _tallestRecognizer = [[UITapGestureRecognizer alloc] init];
    [_tallestLabel addGestureRecognizer:_tallestRecognizer];
}

- (IBAction)segmentedChoose:(UISegmentedControl *)sender
{
    if (sender.tag == 1888) {
        TFLog(@"---->%ld<",sender.selectedSegmentIndex);
        if (_rentalControl.selectedSegmentIndex == 0) {
            _rentalField.hidden = YES;
            _rentalField.text = @"-1";
            
        }else if (_rentalControl.selectedSegmentIndex == 1){
            _rentalField.hidden = NO;
            _rentalField.text = self.rentalStr;
        }
    }
    if (sender.tag == 1889) {
        TFLog(@"---->%ld<",sender.selectedSegmentIndex);
        if (_onceControl.selectedSegmentIndex == 0) {
            _onceField.hidden = YES;
            _onceField.text = @"-1";
            
        }else if (_onceControl.selectedSegmentIndex == 1){
            _onceField.hidden = NO;
            _onceField.text = self.onceStr;
            
        }
    }else if (sender.tag == 1890) {
        TFLog(@"---->%ld<",sender.selectedSegmentIndex);
        if (_surplusControl.selectedSegmentIndex == 0) {
            _surplusField.hidden = YES;
            _surplusField.text = @"-1";
            
        }else if (_surplusControl.selectedSegmentIndex == 1){
            _surplusField.hidden = NO;
            _surplusField.text = self.surplusStr;
            
        }
    }
}

- (void)setVoluntarily:(TFVoluntarily *)voluntarily
{
    _voluntarily = voluntarily;
    
    _statusLabel.text = [voluntarily.status isEqualToString:@"0"] ? @"已关闭" : @"已开启";
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:voluntarily.balance];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *money = [formatter stringFromNumber:number];
    _moneyLabel.text = money;
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    NSNumber *num = [format numberFromString:voluntarily.finished_auto_invest_money];
    format.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *cumulative = [format stringFromNumber:num];
    _cumulativeLabel.text = [NSString stringWithFormat:@"累计自动投标¥:%@元",cumulative];
    
    if ([voluntarily.total isEqualToString:@"-1"]) {
        _rentalField.hidden = YES;
        _rentalControl.selectedSegmentIndex = 0;
    }else{
        _rentalField.hidden = NO;
        
        _rentalField.text = voluntarily.total;
        self.rentalStr = voluntarily.total;
        _rentalControl.selectedSegmentIndex = 1;
    }
    
    if ([voluntarily.money isEqualToString:@"-1"]) {
        _onceField.hidden = YES;
        _onceControl.selectedSegmentIndex = 0;
    }else{
        
        _onceField.hidden = NO;
        _onceField.text = voluntarily.money;
        self.onceStr = voluntarily.money;
        _onceControl.selectedSegmentIndex = 1;
    }
    
    if ([voluntarily.retains isEqualToString:@"-1"]) {
        _surplusField.hidden = YES;
        _surplusControl.selectedSegmentIndex = 0;
    }else{
        _surplusField.hidden = NO;
        _surplusField.text = voluntarily.retains;
        self.surplusStr = voluntarily.retains;
        _surplusControl.selectedSegmentIndex = 1;
    }
    
    _lowestLabel.text = [NSString stringWithFormat:@"%@%%",voluntarily.apr_min];
    _highestLabel.text = [NSString stringWithFormat:@"%@%%",voluntarily.apr_max];
    _minimumLabel.text = [NSString stringWithFormat:@"%@个月",voluntarily.month_min];
    _tallestLabel.text = [NSString stringWithFormat:@"%@个月",voluntarily.month_max];
}

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self endEditing:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, TFMainScreen_Width, 470);
}
@end
