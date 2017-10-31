//
//  TFInvestDetail.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInvestDetail.h"

@implementation TFInvestDetail
+ (void)load
{
    [TFInvestDetail mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"loan_id" : @"id"
                 };
    }];
}
@end
