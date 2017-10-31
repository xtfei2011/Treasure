//
//  TFStatistical.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFStatistical : NSObject
/** 累计投资金额 */
@property (nonatomic ,strong) NSString *total_invest_money;
/** 累计赚取收益 */
@property (nonatomic ,strong) NSString *total_repay_money;
/** 安全运营天数 */
@property (nonatomic ,strong) NSString *safe_run_days;
@end
