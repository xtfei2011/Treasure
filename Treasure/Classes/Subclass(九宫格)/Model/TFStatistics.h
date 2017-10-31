//
//  TFStatistics.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** 理财部分 ***/
@interface TFFinancial : NSObject
/** 总借出金额 **/
@property (nonatomic ,strong) NSString *total_lending_amount;
/** 总借出笔数 **/
@property (nonatomic ,strong) NSString *total_lending_count;
/** 已回收本息 **/
@property (nonatomic ,strong) NSString *has_received_principal_and_interest;
/** 待回收本息 **/
@property (nonatomic ,strong) NSString *wait_received_principal_and_interest;
/** 已回收奖励 **/
@property (nonatomic ,strong) NSString *has_received_reward;
/** 待回收奖励 **/
@property (nonatomic ,strong) NSString *wait_received_reward;
@end



/*** 回报部分 ***/
@interface TFHarvest : NSObject
/** 净赚利息 **/
@property (nonatomic ,strong) NSString *net_interest_income;
/** 待赚利息 **/
@property (nonatomic ,strong) NSString *wait_interest_income;
/** 已收本金 **/
@property (nonatomic ,strong) NSString *has_received_principal;
/** 待收本金 **/
@property (nonatomic ,strong) NSString *wait_received_principal;
@end
