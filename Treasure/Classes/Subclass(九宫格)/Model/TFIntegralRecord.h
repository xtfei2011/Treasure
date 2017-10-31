//
//  TFIntegralRecord.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFIntegralRecord : NSObject
/*** 时间 ***/
@property (nonatomic ,strong) NSString *create_time;
/*** 收入积分数 ***/
@property (nonatomic ,strong) NSString *income;
/*** 支出积分数 ***/
@property (nonatomic ,strong) NSString *outlay;
/*** 类型 ***/
@property (nonatomic ,strong) NSString *remark_str;
@end
