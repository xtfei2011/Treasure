//
//  TFVoluntarily.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFVoluntarily : NSObject
/** 自动投标状态 */
@property (nonatomic ,strong) NSString *status;
/** 自动投标总额 */
@property (nonatomic ,strong) NSString *total;
/** 单次投标金额 */
@property (nonatomic ,strong) NSString *money;
/** 最小年利 率 */
@property (nonatomic ,strong) NSString *apr_min;
/** 最大年利 */
@property (nonatomic ,strong) NSString *apr_max;
/** 最小贷款期限 */
@property (nonatomic ,strong) NSString *month_min;
/** 最大贷款期限 */
@property (nonatomic ,strong) NSString *month_max;
/** 贷款还款方式 */
@property (nonatomic ,strong) NSString *repay_method;
/** 账户保留金额 */
@property (nonatomic ,strong) NSString *retains;
/** 用户余额 */
@property (nonatomic ,strong) NSString *balance;
/** 已完成的自动投标总额 */
@property (nonatomic ,strong) NSString *finished_auto_invest_money;
@end
