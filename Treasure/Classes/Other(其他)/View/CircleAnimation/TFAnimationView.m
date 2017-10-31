//
//  TFAnimationView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAnimationView.h"
#import "NSTimer+TFExtension.h"

#define AnimationRadian(d) ((d)*M_PI)/180.0

@interface TFAnimationView ()
/*** 进度 ***/
@property (nonatomic ,assign) CGFloat progressValue;
/*** 定时器 ***/
@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation TFAnimationView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self initializationAnimationView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initializationAnimationView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame pathBackColor:(UIColor *)pathBackColor pathFillColor:(UIColor *)pathFillColor startAngle:(CGFloat)startAngle strokeWidth:(CGFloat)strokeWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializationAnimationView];
        
        if (pathBackColor) {
            _pathBackColor = pathBackColor;
        }
        if (pathFillColor) {
            _pathFillColor = pathFillColor;
        }
        _startAngle = AnimationRadian(startAngle);
        _strokeWidth = strokeWidth;
    }
    return self;
}

- (void)initializationAnimationView
{
    self.backgroundColor = [UIColor clearColor];
    _pathBackColor = TFGlobalBg;
    _pathFillColor = TFColor(219, 184, 102);
    _strokeWidth = 10;
    _startAngle = - AnimationRadian(90);
    _reduceValue = AnimationRadian(0);
    _showProgressText = YES;
    _forceRefresh = NO;
    _progressValue = 0.0;
}

#pragma Set
- (void)setStartAngle:(CGFloat)startAngle
{
    if (_startAngle != AnimationRadian(startAngle)) {
        _startAngle = AnimationRadian(startAngle);
        [self setNeedsDisplay];
    }
}

- (void)setReduceValue:(CGFloat)reduceValue
{
    if (_reduceValue != AnimationRadian(reduceValue)) {
        if (reduceValue >= 360) {
            return;
        }
        _reduceValue = AnimationRadian(reduceValue);
        [self setNeedsDisplay];
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
        [self setNeedsDisplay];
    }
}

- (void)setPathBackColor:(UIColor *)pathBackColor
{
    if (_pathBackColor != pathBackColor) {
        _pathBackColor = pathBackColor;
        [self setNeedsDisplay];
    }
}

- (void)setPathFillColor:(UIColor *)pathFillColor
{
    if (_pathFillColor != pathFillColor) {
        _pathFillColor = pathFillColor;
        [self setNeedsDisplay];
    }
}

- (void)setShowProgressText:(BOOL)showProgressText
{
    if (_showProgressText != showProgressText) {
        _showProgressText = showProgressText;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置中心点 半径 起点及终点
    CGFloat maxWidth = self.xtf_width < self.xtf_height ? self.xtf_width : self.xtf_height;
    CGPoint center = CGPointMake(maxWidth *0.5, maxWidth *0.5);
    CGFloat radius = maxWidth *0.5 - _strokeWidth *0.5 - 1;
    CGFloat endA = _startAngle + (AnimationRadian(360) - _reduceValue);//圆终点位置
    CGFloat valueEndA = _startAngle + (AnimationRadian(360) - _reduceValue) * _progressValue;  //数值终点位置
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx, _strokeWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);

    [_pathBackColor setStroke];

    CGContextAddPath(ctx, basePath.CGPath);
    CGContextStrokePath(ctx);
    
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    [_pathFillColor setStroke];
    CGContextAddPath(ctx, valuePath.CGPath);
    CGContextStrokePath(ctx);
    
    if (_showProgressText) {
   
        NSString *currentText = [NSString stringWithFormat:@"%.2f%%",_progressValue *100];
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;//水平居中
        UIFont *font = [UIFont systemFontOfSize:0.15 * self.xtf_width];
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle};
        CGSize stringSize = [currentText sizeWithAttributes:attributes];
        CGRect r = CGRectMake((self.xtf_width-stringSize.width)/2.0, (self.xtf_height - stringSize.height)/2.0,stringSize.width, stringSize.height);
        [currentText drawInRect:r withAttributes:attributes];
    }
}

- (void)setProgress:(CGFloat)progress
{
    if ((_progress == progress && !_forceRefresh) || progress > 1.0 || progress < 0.0) return;
    
    _progressValue = (_increaseFromLast == YES) ? _progress : 0.0;
    BOOL isReverse = (progress < _progressValue) ? YES : NO;

    _progress = progress;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }

    if (_progress == 0.0 || _notAnimated) {
        _progressValue = _progress;
        [self setNeedsDisplay];
        return;
    }
    
    //设置每次增加的数值
    CGFloat defaultIncreaseValue = isReverse ? -0.01 : 0.01;
    
    __weak typeof(self) weakSelf = self;
    
    _timer = [NSTimer setWithTimeInterval:0.005 block:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if (isReverse) {
            if (_progressValue <= _progress || _progressValue <= 0.0f) {
                
                [strongSelf dealWithLast];
                return;
                
            } else {

                [strongSelf setNeedsDisplay];
            }
        } else {
         
            if (_progressValue >= _progress || _progressValue >= 1.0f) {
                [strongSelf dealWithLast];
                return;
                
            } else {
             
                [strongSelf setNeedsDisplay];
            }
        }
      
        _progressValue += defaultIncreaseValue;//进度越大动画时间越长。
        
    } repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)dealWithLast
{
    _progressValue = _progress;
    
    [self setNeedsDisplay];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
