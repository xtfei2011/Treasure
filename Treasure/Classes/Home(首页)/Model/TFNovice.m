//
//  TFNovice.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFNovice.h"

@implementation TFNovice
+ (void)load
{
    [TFNovice mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}
@end
