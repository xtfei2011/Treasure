//
//  TFNormalViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFNormalViewCell.h"

@implementation TFNormalViewCell

+ (instancetype)initWithTableView:(UITableView *)tableview
{
    TFNormalViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"normalModel"];
    if (cell == nil) {
        cell = [[TFNormalViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"normalModel"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = TFMoreTitleFont;
        self.detailTextLabel.font = TFCommentTitleFont;
    }
    return self;
}

- (void)setNormalModel:(TFNormalModel *)normalModel
{
    _normalModel = normalModel;
    
    self.textLabel.text = normalModel.title;
    self.detailTextLabel.text = (normalModel.subTitle) ? normalModel.subTitle : nil;
    self.detailTextLabel.textColor = TFColor(36, 181, 232);
}
@end
