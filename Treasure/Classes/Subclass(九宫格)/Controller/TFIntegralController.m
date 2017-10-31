//
//  TFIntegralController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFIntegralController.h"

@interface TFIntegralController ()

@end

@implementation TFIntegralController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的积分";
}

- (TFEnableAwardType)type
{
    return TFBaseTypeIntegral;
}
@end
