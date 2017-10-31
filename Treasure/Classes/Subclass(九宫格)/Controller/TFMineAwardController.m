//
//  TFMineAwardController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFMineAwardController.h"

@interface TFMineAwardController ()

@end

@implementation TFMineAwardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的奖励";
}

- (TFEnableAwardType)type
{
    return TFBaseTypeEnableAward;
}
@end
