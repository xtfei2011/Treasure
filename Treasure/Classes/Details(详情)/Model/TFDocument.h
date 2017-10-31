//
//  TFDocument.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFDocument : NSObject
/** 头像 */
@property (nonatomic ,strong) NSString *face;
/** 时间 */
@property (nonatomic ,strong) NSString *create_time;
/** 金额 */
@property (nonatomic ,strong) NSString *money;
/** 手机 */
@property (nonatomic ,strong) NSString *mobile;
/** 优惠劵 */
@property (nonatomic ,strong) NSString *coupon;
/** 端口 */
@property (nonatomic ,strong) NSString *remark_str;
@end
