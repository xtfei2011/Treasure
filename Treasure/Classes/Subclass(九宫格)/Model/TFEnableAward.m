//
//  TFEnableAward.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFEnableAward.h"

@implementation TFEnableAward
+ (void)load
{
    [TFEnableAward mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descrip" : @"description",
                 @"ID" : @"id"
                 };
    }];
}
@end
