//
//  TFAccountViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAccountViewCell.h"

@interface TFAccountViewCell ()
@property (weak, nonatomic) IBOutlet UIView *classificationView;
/*** 可用余额 ***/
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
/*** 回收收益 ***/
@property (weak, nonatomic) IBOutlet UILabel *accruedLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIView *openAccountView;
@end

@implementation TFAccountViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setAccountModel:(TFAccountModel *)accountModel
{
    _accountModel = accountModel;
    
    _balanceLabel.text = (accountModel) ? [NSString stringWithFormat:@"%.2f",[accountModel.balance doubleValue]] : @"--";
    _accruedLabel.text = (accountModel) ? [NSString stringWithFormat:@"%.2f",[accountModel.wait_received_interest doubleValue]] : @"--";
    
    if ([accountModel.open_zbank isEqualToString:@"activated"]) {
        self.openAccountView.hidden = YES;
    } else {
        self.openAccountView.hidden = NO;
    }
}

- (IBAction)accountViewButtonClick:(UIButton *)sender
{
    TFAccount *account = [TFAccountTool account];
    
    if (account.access_token) {
        if ([_delegate respondsToSelector:@selector(accountViewBtnClick:)]) {
            [_delegate accountViewBtnClick:sender];
        }
    } else {
        [TFProgressHUD showInfoMsg:@"您还没有登录哦"];
    }
}
@end
