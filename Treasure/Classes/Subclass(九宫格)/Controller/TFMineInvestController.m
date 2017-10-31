//
//  TFMineInvestController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFMineInvestController.h"

@interface TFMineInvestController ()

@end

@implementation TFMineInvestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的投资";
}

- (TFBaseModelType)type
{
    return TFBaseTypeMineInvest;
}
@end
