//
//  TFIntegralRecord.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntegralRecord.h"

@implementation TFIntegralRecord
- (NSString *)create_time
{
    if (_create_time) {
        NSArray *array = [_create_time componentsSeparatedByString:@" "];
        _create_time = array[0];
    }
    return _create_time;
}
@end
