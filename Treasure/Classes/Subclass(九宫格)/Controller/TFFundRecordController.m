//
//  TFFundRecordController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFFundRecordController.h"

@interface TFFundRecordController ()

@end

@implementation TFFundRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"资金记录";
}

- (TFBaseModelType)type
{
    return TFBaseTypeFundRecord;
}

@end
