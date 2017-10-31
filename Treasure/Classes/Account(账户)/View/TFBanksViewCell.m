//
//  TFBanksViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/9/8.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFBanksViewCell.h"

@interface TFBanksViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@end

@implementation TFBanksViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setBank:(TFBank *)bank
{
    _bank = bank;
    
    self.bankNameLabel.text = bank.bank_name;
}
@end
