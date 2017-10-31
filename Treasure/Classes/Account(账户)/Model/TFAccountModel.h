//
//  TFAccountModel.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/14.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFAccountModel : NSObject
/** 用户名 */
@property (nonatomic ,strong) NSString *username;
/** 用户头像 */
@property (nonatomic ,strong) NSString *face;
/** 手机号 */
@property (nonatomic ,strong) NSString *mobile;
/** 用户余额 */
@property (nonatomic ,strong) NSString *balance;
/** 可用积分 */
@property (nonatomic ,strong) NSString *score;
/** 已赚收益 */
@property (nonatomic ,strong) NSString *net_income;
/** 资产总额 */
@property (nonatomic ,strong) NSString *total_money;
/** 冻结金额 */
@property (nonatomic ,strong) NSString *frozen;
/** 资金记录条数 */
@property (nonatomic ,strong) NSString *funds_records;
/** 投标记录条数 */
@property (nonatomic ,strong) NSString *invest_records;
/** 自动投标状态 */
@property (nonatomic ,strong) NSString *autobid;
/** 银行卡 */
@property (nonatomic ,strong) NSString *bank_card;
/** 开通存管状态 */
@property (nonatomic ,strong) NSString *open_zbank;
/** 客户类型 */
@property (nonatomic ,strong) NSString *customer_type;
/** 待收总额 */
@property (nonatomic ,strong) NSString *wait_received_interest;
/** 优惠券数量 */
@property (nonatomic ,strong) NSString *coupon_num;
/** 用户编号 */
@property (nonatomic ,strong) NSString *ID;
@end
