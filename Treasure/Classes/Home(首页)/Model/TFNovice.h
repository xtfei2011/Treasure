//
//  TFNovice.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFNovice : NSObject
/*** 新手金额 ***/
@property (nonatomic ,strong) NSString *amount;
/*** 风险级别 ***/
@property (nonatomic ,strong) NSString *risk_level;
/*** 标的id ***/
@property (nonatomic ,strong) NSString *ID;
/*** 新手标可投金额 ***/
@property (nonatomic ,strong) NSString *can_invested_money;
/*** 标题 ***/
@property (nonatomic ,strong) NSString *title;
/*** 期限 ***/
@property (nonatomic ,strong) NSString *deadline;
/*** 年化率 ***/
@property (nonatomic ,strong) NSString *apr;
/*** 时间 ***/
@property (nonatomic ,strong) NSString *create_time;
/*** 优惠劵 ***/
@property (nonatomic ,strong) NSString *reward_apr;
@end
