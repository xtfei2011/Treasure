//
//  TFRecommendView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRecommendView.h"

@interface TFRecommendView ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end

@implementation TFRecommendView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setAwardStatistics:(TFAwardStatistics *)awardStatistics
{
    _awardStatistics = awardStatistics;
    
    _numLabel.text = awardStatistics.total_invite_count;
    
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f",[awardStatistics.total_ok_invite_money doubleValue]];
}
@end
