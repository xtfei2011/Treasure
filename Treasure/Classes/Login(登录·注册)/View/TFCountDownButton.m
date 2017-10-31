//
//  TFCountDownButton.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/9/26.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFCountDownButton.h"

@interface TFCountDownButton ()
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSInteger time;
@end

@implementation TFCountDownButton

- (void)awakeFromNib
{
    [super awakeFromNib];
   
    self.enabled = YES;
    [self refreshButtonView];
}

- (void)setStarted:(int)started
{
    _started = started;
    _time = started;
}

- (void)countDownButtonClick
{
    _time = 60;
    self.enabled = NO;
    
    [self refreshButtonView];
    
    [self setTitle:[NSString stringWithFormat:@"获取验证码(%zi)", _time] forState:UIControlStateNormal];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startedTimer) userInfo:nil repeats:YES];
}

- (void)startedTimer
{
    [self setTitle:[NSString stringWithFormat:@"获取验证码(%zi)", _time] forState:UIControlStateNormal];
    
    if (_time <= 0) {
        
        [self setTitle:@"重新获取" forState:UIControlStateNormal];
        self.enabled = YES;
        [self refreshButtonView];
        _timer = nil;
        
    } else {
        _time --;
    }
}

- (void)refreshButtonView
{
    [self setBackgroundImage:[self imageWithColor:TFColor(252, 99, 102) tf_size:self.xtf_size] forState:UIControlStateNormal];
    [self setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor] tf_size:self.xtf_size] forState:UIControlStateDisabled];
}

- (UIImage *)imageWithColor:(UIColor *)color tf_size:(CGSize)tf_size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, tf_size.width, tf_size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
