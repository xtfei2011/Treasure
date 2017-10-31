//
//  TFVoluntarily.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFVoluntarily.h"

@implementation TFVoluntarily
+ (void)load
{
    [TFVoluntarily mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"retains" : @"retain"
                 };
    }];
}
@end
