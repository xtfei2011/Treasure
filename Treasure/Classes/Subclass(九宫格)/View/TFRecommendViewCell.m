//
//  TFRecommendViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRecommendViewCell.h"

@interface TFRecommendViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *investLabel;
@end

@implementation TFRecommendViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecommend:(TFRecommend *)recommend
{
    _recommend = recommend;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:recommend.money];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *money = [formatter stringFromNumber:number];
    
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",money];
    _moneyLabel.keywords = money;
    _moneyLabel.keywordsColor = [UIColor redColor];
    _moneyLabel.keywordsFont = TFMoreTitleFont;
    
    _statusLabel.text = recommend.is_reward;
    
    _investLabel.text = [NSString stringWithFormat:@"(%@)",recommend.info];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize investSize =  [_moneyLabel getLableSizeWithMaxWidth:200];
    _moneyLabel.frame = CGRectMake(0, 0, investSize.width, investSize.height);
    [self.contentView addSubview:_moneyLabel];
}
@end
