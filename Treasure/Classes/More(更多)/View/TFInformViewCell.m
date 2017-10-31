//
//  TFInformViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInformViewCell.h"

@implementation TFInformViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TFInformViewCell";
    TFInformViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFInformViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.font = TFMoreTitleFont;
    }
    return self;
}

- (void)setInform:(TFInform *)inform
{
    _inform = inform;
    
    self.textLabel.text = [NSString stringWithFormat:@"用户%@成功兑换%@", self.inform.mobile, self.inform.title];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.xtf_x = 0;
    self.textLabel.xtf_y = 0;
    self.textLabel.xtf_width = self.contentView.xtf_width;
    self.textLabel.xtf_height = self.contentView.xtf_height;
    
    self.textLabel.textAlignment = NSTextAlignmentLeft;
}
@end
