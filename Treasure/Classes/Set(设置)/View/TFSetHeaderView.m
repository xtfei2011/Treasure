//
//  TFSetHeaderView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFSetHeaderView.h"

@interface TFSetHeaderView ()
/*** 编号 ***/
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
/*** 用户名 ***/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation TFSetHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setAccountModel:(TFAccountModel *)accountModel
{
    _accountModel = accountModel;
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:accountModel.face] placeholderImage:[UIImage imageNamed:@"small_header"]];
    _numberLabel.text = accountModel.ID;
    _nameLabel.text = accountModel.username;
}

- (IBAction)headerViewClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(replaceHeaderButtonClick:)]){
        [_delegate replaceHeaderButtonClick:sender];
    }
}
@end
