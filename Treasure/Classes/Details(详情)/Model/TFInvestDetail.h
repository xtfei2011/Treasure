//
//  TFInvestDetail.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFInvestDetail : NSObject
/** 风险等级 */
@property (nonatomic ,strong) NSString *risk_level;
/** 还款类型 */
@property (nonatomic ,strong) NSString *repay_method;
/** 贷款方式 */
@property (nonatomic ,strong) NSString *loan_way;
/** 回款明细统计 */
@property (nonatomic ,strong) NSString *repay_details;
/** 标的金额 */
@property (nonatomic ,strong) NSString *amount;
/** 剩余可投金额 */
@property (nonatomic ,strong) NSString *can_invested_money;
/** 年化率 */
@property (nonatomic ,strong) NSString *apr;
/** 标题 */
@property (nonatomic ,strong) NSString *title;
/** 投资列表 统计 */
@property (nonatomic ,strong) NSString *invest_ok_count;
/** 投标进度 */
@property (nonatomic ,strong) NSString *invest_schedule;
/** 是否有约标密码 */
@property (nonatomic ,strong) NSString *lock;
/** 发布时间 */
@property (nonatomic ,strong) NSString *create_time;
/** 状态 */
@property (nonatomic ,strong) NSString *remark_str;
/** 期限 */
@property (nonatomic ,strong) NSString *deadline;
/** 编号 */
@property (nonatomic ,strong) NSString *loan_id;

@property (nonatomic ,strong) NSString *balance;
/*** 优惠劵 ***/
@property (nonatomic ,strong) NSString *reward_apr;
@end
