//
//  TFStatisticsViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFStatistics.h"

@interface TFStatisticsViewCell : UITableViewCell
/*** 回报部分 ***/
@property (nonatomic ,strong) TFHarvest *harvest;
/*** 理财部分 ***/
@property (nonatomic ,strong) TFFinancial *financial;
@end
