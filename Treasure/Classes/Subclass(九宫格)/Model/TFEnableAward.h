//
//  TFEnableAward.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** 枚举 ***/
typedef NS_ENUM(NSUInteger, TFEnableAwardType) {
    
    /** 我的奖励 */
    TFBaseTypeEnableAward = 0,
    /** 我的积分 */
    TFBaseTypeIntegral = 1,
};

@interface TFEnableAward : NSObject
/** 优惠券状态 **/
@property (nonatomic ,strong) NSString *remark_str;
/** 优惠券类型 **/
@property (nonatomic ,strong) NSString *type;
/** 优惠券金额 **/
@property (nonatomic ,strong) NSString *money;
/** 券的使用描述 **/
@property (nonatomic ,strong) NSString *descrip;
/** 优惠券生效日期 **/
@property (nonatomic ,strong) NSString *start_date;
/** 优惠券过期时间 **/
@property (nonatomic ,strong) NSString *end_date;
/** 券的类型 **/
@property (nonatomic ,strong) NSString *name;

@property (nonatomic ,strong) NSString *ID;
@end
