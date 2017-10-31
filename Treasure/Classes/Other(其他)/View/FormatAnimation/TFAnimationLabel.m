//
//  TFAnimationLabel.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/5.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAnimationLabel.h"
#import <QuartzCore/QuartzCore.h>

#define TFCounterRate 3.0

@protocol TFAnimationCounter <NSObject>

- (CGFloat)numIncrease:(CGFloat)rate;
@end

/*** 计数器匀速 ***/
@interface TFCounterLinear : NSObject<TFAnimationCounter>
@end

/*** 计数器先慢后快 ***/
@interface TFCounterEaseIn : NSObject<TFAnimationCounter>
@end

/*** 计数器先快后慢 ***/
@interface TFCounterEaseOut : NSObject<TFAnimationCounter>
@end

/*** 计数器先慢后快再慢 ***/
@interface TFCounterEaseInOut : NSObject<TFAnimationCounter>
@end

@implementation TFCounterLinear
/*** 计数器匀速 ***/
- (CGFloat)numIncrease:(CGFloat)rate
{
    return rate;
}
@end

@implementation TFCounterEaseIn
/*** 计数器先慢后快 ***/
- (CGFloat)numIncrease:(CGFloat)rate
{
    return pow(rate, TFCounterRate);
}
@end

@implementation TFCounterEaseOut
/*** 计数器先快后慢 ***/
- (CGFloat)numIncrease:(CGFloat)rate
{
    return 1.0 - powf((1.0 - rate), TFCounterRate);
}
@end

@implementation TFCounterEaseInOut
/*** 计数器先慢后快再慢 ***/
- (CGFloat)numIncrease:(CGFloat)rate
{
    rate *= 2;
    if (rate < 1) {
        
        return 0.5f *pow(rate, TFCounterRate);
    }else{
        return 0.5f *(2.0f - pow(2.0 - rate, TFCounterRate));
    }
}
@end

#pragma mark ----- TFAnimationLabel

@interface TFAnimationLabel ()

@property CGFloat startingValue;
@property CGFloat endValue;
@property NSTimeInterval progress;
@property NSTimeInterval duration;
@property NSTimeInterval totalTime;
@property CGFloat frequency;

@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) id<TFAnimationCounter> counter;

@end

@implementation TFAnimationLabel

- (void)countStartValue:(CGFloat)startValue endValue:(CGFloat)endValue duration:(NSTimeInterval)duration
{
    self.startingValue = startValue;
    self.endValue = endValue;
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (duration == 0.0) {
        [self setCountValue:endValue];
        [self runCompletionBlock];
        return;
    }
    
    self.frequency = 3.0f;
    self.progress = 0;
    self.totalTime = duration;
    self.duration = [NSDate timeIntervalSinceReferenceDate];
    
    if (self.format == nil) self.format = @"%f";
    
    self.counter = [[TFCounterEaseOut alloc] init];
    
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
    timer.frameInterval = 2;
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    self.timer = timer;
}

- (void)updateValue:(NSTimer *)timer
{
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    self.progress += now - self.duration;
    self.duration = now;
    
    if (self.progress >= self.totalTime) {
        [self.timer invalidate];
        self.timer = nil;
        self.progress = self.totalTime;
    }
    
    [self setCountValue:[self currentValue]];
    
    if (self.progress == self.totalTime) {
        [self runCompletionBlock];
    }
}

- (void)setCountValue:(CGFloat)value
{
    if (self.formatBlock != nil) {
        self.text = self.formatBlock(value);
        
    } else {
        
        if([self.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound || [self.format rangeOfString:@"%(.*)i"].location != NSNotFound ) {
            
            self.text = [NSString stringWithFormat:self.format,(int)value];
        } else {
            self.text = [NSString stringWithFormat:self.format,value];
        }
    }
}

- (void)runCompletionBlock
{
    if (self.completionBlock) {
        
        self.completionBlock();
        self.completionBlock = nil;
    }
}

- (CGFloat)currentValue
{
    if (self.progress >= self.totalTime) {
        return self.endValue;
    }
    
    CGFloat percent = self.progress / self.totalTime;
    CGFloat durationValue = [self.counter numIncrease:percent];
    return self.startingValue + (durationValue * (self.endValue - self.startingValue));
}
@end
