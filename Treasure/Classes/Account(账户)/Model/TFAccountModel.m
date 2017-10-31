//
//  TFAccountModel.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/14.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAccountModel.h"

@implementation TFAccountModel

+ (void)load
{
    [TFAccountModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}
@end
