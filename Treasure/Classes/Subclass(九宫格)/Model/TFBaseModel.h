//
//  TFBaseModel.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** 账户子菜单枚举 ***/
typedef NS_ENUM(NSUInteger, TFBaseModelType) {
    
    /** 资金记录 */
    TFBaseTypeFundRecord = 0,
    /** 我的投资 */
    TFBaseTypeMineInvest = 1,
    /** 待回收 */
    TFBaseTypeNotRecovered = 2,
    /** 已回收 */
    TFBaseTypeHasBeenBack = 3
};

@interface TFBaseModel : NSObject

/*********  * 资金记录·我的投资 *  *********/
/** 收益 **/
@property (nonatomic ,strong) NSString *income;
/** 时间 **/
@property (nonatomic ,strong) NSString *create_time;
/** 备注 **/
@property (nonatomic ,strong) NSString *remark_str;

/*********  * 资金记录 *  *********/
@property (nonatomic ,strong) NSString *outlay;

/*********  * 我的投资 *  *********/
/** 投标金额 **/
@property (nonatomic ,strong) NSString *money;
/** 标名称 **/
@property (nonatomic ,strong) NSString *title;
/** 标期限 **/
@property (nonatomic ,strong) NSString *deadline;
/** 标风险等级 **/
@property (nonatomic ,strong) NSString *risk_level;
/** 标类型 **/
@property (nonatomic ,strong) NSString *loan_way;
/** 投标使用的优惠券 **/
@property (nonatomic ,strong) NSString *coupon;
/** 编号 **/
@property (nonatomic ,strong) NSString *ID;
/*** 收益率 **/
@property (nonatomic ,strong) NSString *apr;

/*********  * 收益明细 *  *********/
/*** 期数 ***/
@property (nonatomic ,strong) NSString *periods;
/*** 利息 ***/
@property (nonatomic ,strong) NSString *bx;
/*** 回款时间 ***/
@property (nonatomic ,strong) NSString *back_time;
/*** 剩余本息 ***/
@property (nonatomic ,strong) NSString *to_be_recovered;
/*** 备注 ***/
@property (nonatomic ,strong) NSString *name;
@end
