//
//  TFRecommend.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRecommend.h"

@implementation TFRecommend
- (NSString *)is_reward
{
    if ([_is_reward isEqualToString:@"0"]) {
        _is_reward = @"未发放";
    }else{
        _is_reward = @"已发放";
    }
    return _is_reward;
}
@end
