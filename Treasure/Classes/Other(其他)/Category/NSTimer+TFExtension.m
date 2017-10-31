//
//  NSTimer+TFExtension.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "NSTimer+TFExtension.h"

@implementation NSTimer (TFExtension)

+ (NSTimer *)setWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(invokeBlock:) userInfo:[block copy] repeats:repeats];
}

+ (void)invokeBlock:(NSTimer *)timer
{
    void (^ block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end
