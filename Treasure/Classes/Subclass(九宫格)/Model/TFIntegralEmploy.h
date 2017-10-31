//
//  TFIntegralEmploy.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFIntegralEmploy : NSObject
/** 积分支出 */
@property (nonatomic ,strong) NSString *outlay;
/** 奖励发放状态 */
@property (nonatomic ,strong) NSString *reward_status;
/** 商品名称 */
@property (nonatomic ,strong) NSString *title;
/** 时间 */
@property (nonatomic ,strong) NSString *create_time;
/** 记录类型 */
@property (nonatomic ,strong) NSString *goods_type;
@end
