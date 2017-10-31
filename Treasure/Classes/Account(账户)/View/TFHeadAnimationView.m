//
//  TFHeadAnimationView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFHeadAnimationView.h"

@interface TFHeadAnimationView ()
@property (nonatomic ,strong) CADisplayLink *displayLink;
@property (nonatomic ,strong) CAShapeLayer *firstLayer;
@property (nonatomic ,strong) CAShapeLayer *secondeLayer;
@property (nonatomic ,strong) CAShapeLayer *thirdLayer;

/*** 参数·振幅 ***/
@property (nonatomic ,assign) CGFloat amplitude;
/*** 参数·周期 ***/
@property (nonatomic ,assign) CGFloat cycle;
/*** 参数·速度 ***/
@property (nonatomic ,assign) CGFloat speedOne;
/*** 参数·速度 ***/
@property (nonatomic ,assign) CGFloat speedTwo;
/*** 参数·位移 ***/
@property (nonatomic ,assign) CGFloat offsetX;

@property (nonatomic ,assign) CGFloat pointY;
@end

@implementation TFHeadAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TFColor(252, 99, 102);
        self.layer.masksToBounds = YES;
        [self configAnimationParams];
    }
    return self;
}

- (void)configAnimationParams
{
    _speedOne = 0.25 / M_PI;
    _speedTwo = 0.3 / M_PI;
    _offsetX = 0;
    _pointY = self.xtf_height - 50;
    _amplitude = 13;
    _cycle = 1.29 *M_PI / self.xtf_width;
    
    [self.layer addSublayer:self.firstLayer];
    [self.layer addSublayer:self.secondeLayer];
    [self.layer addSublayer:self.thirdLayer];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (CAShapeLayer *)firstLayer
{
    if (!_firstLayer) {
        _firstLayer = [CAShapeLayer layer];
        _firstLayer.fillColor = [TFRGBColor(255, 255, 255, 0.1) CGColor];
    }
    return _firstLayer;
}

- (CAShapeLayer *)secondeLayer
{
    if (!_secondeLayer) {
        _secondeLayer = [CAShapeLayer layer];
        _secondeLayer.fillColor = [TFRGBColor(255, 255, 255, 0.1) CGColor];
    }
    return _secondeLayer;
}

- (CAShapeLayer *)thirdLayer
{
    if (!_thirdLayer) {
        _thirdLayer = [CAShapeLayer layer];
        _thirdLayer.fillColor = [TFRGBColor(255, 255, 255, 0.1) CGColor];
    }
    return _thirdLayer;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(loadCurrentWaveView)];
    }
    return _displayLink;
}

- (void)loadCurrentWaveView
{
    _offsetX += _speedOne;
    
    [self setfirstLayerPath];
    [self setSecondLayerPath];
    [self setthirdLayerPath];
}

- (void)setfirstLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _pointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= self.xtf_width; x++) {
        y = _amplitude * sin(_cycle * x + _offsetX - 10) + _pointY + 10;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.xtf_width, self.xtf_height);
    CGPathAddLineToPoint(path, nil, 0, self.xtf_height);
    CGPathCloseSubpath(path);
    
    _firstLayer.path = path;
    
    CGPathRelease(path);
}

- (void)setSecondLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _pointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= self.xtf_width; x ++) {
        y = (_amplitude - 2) * sin(_cycle * x + _offsetX) + _pointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.xtf_width, self.xtf_height);
    CGPathAddLineToPoint(path, nil, 0, self.xtf_height);
    CGPathCloseSubpath(path);
    
    _secondeLayer.path = path;
    
    CGPathRelease(path);
}

- (void)setthirdLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _pointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x <= self.xtf_width; x ++) {
        y = (_amplitude + 2) * sin(_cycle * x + _offsetX + 20) + _pointY - 10;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.xtf_width, self.xtf_height);
    CGPathAddLineToPoint(path, nil, 0, self.xtf_height);
    CGPathCloseSubpath(path);
    
    _thirdLayer.path = path;
    
    CGPathRelease(path);
}
@end
