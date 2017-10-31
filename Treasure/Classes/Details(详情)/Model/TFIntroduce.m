//
//  TFIntroduce.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntroduce.h"

@implementation TFIntroduce
+ (void)load
{
    [TFIntroduce mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}

- (NSString *)repay_method
{
    if (_repay_method) {
        
        if ([_repay_method isEqualToString:@"ayfx"]) {
            
            _repay_method = @"按月付息，到期还本";
        }else if ([_repay_method isEqualToString:@"debx"]){
            
            _repay_method = @"按月等额本息";
        }
    }
    return _repay_method;
}

- (NSString *)amount
{
    if (_amount) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:_amount];
        formatter.numberStyle = kCFNumberFormatterDecimalStyle;
        _amount = [formatter stringFromNumber:number];
    }
    return _amount;
}

- (NSString *)can_invested_money
{
    if (_can_invested_money) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:_can_invested_money];
        formatter.numberStyle = kCFNumberFormatterDecimalStyle;
        _can_invested_money = [formatter stringFromNumber:number];
    }
    return _can_invested_money;
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
