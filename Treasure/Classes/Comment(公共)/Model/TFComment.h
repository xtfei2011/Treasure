//
//  TFComment.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** 公共分段枚举 ***/
typedef NS_ENUM(NSUInteger, TFSegmentedType) {
    
    /*** 投资 ***/
    TFSegmentedTypeInvest = 0,
    /*** 回收收益 ***/
    TFSegmentedTypeReceivable = 1,
    /*** 定期产品 ***/
    TFSegmentedTypeTerminal = 2,
    /*** 新手体验 ***/
    TFSegmentedTypeNovice = 3
};

@interface TFComment : NSObject

/*** 可投金额 ***/
@property (nonatomic ,strong) NSString *amount;
/*** 风险等级 ***/
@property (nonatomic ,strong) NSString *risk_level;
/*** 标的ID ***/
@property (nonatomic ,strong) NSString *ID;
/*** 剩余金额 ***/
@property (nonatomic ,strong) NSString *can_invested_money;
/*** 标题 ***/
@property (nonatomic ,strong) NSString *title;
/*** 期限 ***/
@property (nonatomic ,strong) NSString *deadline;
/*** 利率 ***/
@property (nonatomic ,strong) NSString *apr;
/*** 时间 ***/
@property (nonatomic ,strong) NSString *create_time;
/*** 状态 ***/
@property (nonatomic ,strong) NSString *remark_str;
/*** 倒计时 ***/
@property (nonatomic ,assign) NSInteger invest_start_wait_time;
/*** 优惠劵 ***/
@property (nonatomic ,strong) NSString *reward_apr;
@end
