//
//  TFCountdownManager.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/7/21.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFCountdownManager.h"

@interface TFCountdownManager ()
@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation TFCountdownManager

+ (instancetype)manager
{
    static TFCountdownManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TFCountdownManager alloc]init];
    });
    return manager;
}

- (void)start {
    // 启动定时器
    [self timer];
}

- (void)reload {
    // 刷新只要让时间差为0即可
    _timeInterval = 0;
}

- (void)invalidate
{
    [self.timer invalidate];
    self.timer = nil;
    self.timeInterval = 0;
}

- (void)timerAction
{
    // 时间差+1
    self.timeInterval ++;
    // 发出通知--可以将时间差传递出去,或者直接通知类属性取
    [[NSNotificationCenter defaultCenter] postNotificationName:kCountdownNotification object:nil userInfo:@{@"TimeInterval" : @(self.timeInterval)}];
}

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
