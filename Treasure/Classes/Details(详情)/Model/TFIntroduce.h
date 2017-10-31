//
//  TFIntroduce.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFIntroduce : NSObject
/*** 还款类型 ***/
@property (nonatomic ,strong) NSString *repay_method;
/*** 标金额 ***/
@property (nonatomic ,strong) NSString *amount;
/*** 发布时间 ***/
@property (nonatomic ,strong) NSString *create_time;
/*** 剩余可投金额 ***/
@property (nonatomic ,strong) NSString *can_invested_money;
/*** 投标进度 ***/
@property (nonatomic ,strong) NSString *invest_schedule;
/*** 编号 ***/
@property (nonatomic ,strong) NSString *ID;
@end
