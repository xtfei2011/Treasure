//
//  TFNoviceViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFNovice.h"

@class TFNoviceViewCell;
@protocol TFNoviceBtnDelegate <NSObject>

- (void)prefectureMoreBtnClick:(TFNoviceViewCell *)cell;
- (void)onceInvestmentBtnClick:(TFNoviceViewCell *)cell;
@end

@interface TFNoviceViewCell : UITableViewCell

@property (nonatomic ,strong) TFNovice *novice;
@property (nonatomic ,weak) id<TFNoviceBtnDelegate>delegate;
@end
