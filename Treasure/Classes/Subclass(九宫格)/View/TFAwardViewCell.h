//
//  TFAwardViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFEnableAward.h"

@class TFAwardViewCell, TFEnableAward;
@protocol TFAwardViewCellDelegate <NSObject>
- (void)awardViewCellClick:(TFAwardViewCell *)cell;
@end

@interface TFAwardViewCell : UITableViewCell
@property (nonatomic ,strong) TFEnableAward *enableAward;
@property (nonatomic ,weak) id<TFAwardViewCellDelegate>delegate;
@end
