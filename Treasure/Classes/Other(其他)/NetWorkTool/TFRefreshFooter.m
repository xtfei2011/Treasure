//
//  TFRefreshFooter.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFRefreshFooter.h"

@implementation TFRefreshFooter

- (void)prepare
{
    [super prepare];
    
    self.stateLabel.textColor = [UIColor grayColor];
    self.stateLabel.font = TFMoreTitleFont;
    
    [self setTitle:@"--- 数据打烊啦 ---" forState:MJRefreshStateNoMoreData];
}
@end
