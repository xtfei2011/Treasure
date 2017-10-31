//
//  TFSegmentedView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFSegmentedView.h"

@interface TFSegmentedView ()
@property (nonatomic ,copy) SegmentedBlock block;
@property (nonatomic ,strong) NSMutableArray *buttonArray;
@property (nonatomic ,strong) UIView *indicatorView;
@end

@implementation TFSegmentedView

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(SegmentedBlock)block
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.block = block;
        CGFloat width = self.xtf_width / titles.count;
        CGFloat height = self.xtf_height;
        
        for (NSInteger i = 0; i < titles.count; i ++) {
            
            UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
            topButton.frame = CGRectMake(i * width, 0, width, height);
            [self.buttonArray addObject:topButton];
            
            [topButton setTitle:titles[i] forState:UIControlStateNormal];
            topButton.titleLabel.font = [UIFont systemFontOfSize:16];
            topButton.tag = i + 100;
            [topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0) {
                
                [topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 80, 2)];
                [topButton.titleLabel sizeToFit];
                _indicatorView.center = CGPointMake(topButton.xtf_centerX, _indicatorView.xtf_centerY);
                _indicatorView.backgroundColor = [UIColor whiteColor];
                
                [self addSubview:_indicatorView];
                
            }else{
                [topButton setTitleColor:TFColor(244, 180, 186) forState:UIControlStateNormal];
            }
            [self addSubview:topButton];
        }
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender
{
    [self scrollIndicatorViewWithIndex:sender.tag - 100];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *button = [self viewWithTag:i + 100];
        if (button.tag == sender.tag) {
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        } else {
            [button setTitleColor:TFColor(244, 180, 186) forState:UIControlStateNormal];
        }
    }
    if (self.block) {
        self.block(sender.tag - 100);
    }
}

/*** 指示条 ***/
- (void)scrollIndicatorViewWithIndex:(NSInteger)index
{
    UIButton *button = self.buttonArray[index];
    [UIView animateWithDuration:0.5 animations:^{
        _indicatorView.center = CGPointMake(button.center.x, 38);
    }];
}
@end
