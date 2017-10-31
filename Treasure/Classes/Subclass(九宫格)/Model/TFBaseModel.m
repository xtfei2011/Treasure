//
//  TFBaseModel.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFBaseModel.h"

@implementation TFBaseModel

+ (void)load
{
    [TFBaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"loan_id"
                 };
    }];
}

- (NSString *)create_time
{
    if (_create_time) {
        NSArray *array = [_create_time componentsSeparatedByString:@" "];
        _create_time = array[0];
    }
    return _create_time;
}
@end
