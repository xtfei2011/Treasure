//
//  TFDocumentViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFDocumentViewCell.h"

@interface TFDocumentViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@end

@implementation TFDocumentViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setDocument:(TFDocument *)document
{
    _document = document;
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:document.face] placeholderImage:[UIImage imageNamed:@"set"]];
    _phoneLabel.text = document.mobile;
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",document.remark_str, document.create_time];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:document.money];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *str = [formatter stringFromNumber:number];
    _moneyLabel.text = [NSString stringWithFormat:@"投资金额: %@元",str];
    
    if ([document.coupon isEqualToString:@""]) {
        
        _couponLabel.text = @" 没有使用优惠券  ";
    }else{
        _couponLabel.text = [NSString stringWithFormat:@" %@  ",document.coupon];
    }
}
@end
