//
//  TFCardInformationController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/9/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFCardInformationController.h"

@interface TFCardInformationController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end

@implementation TFCardInformationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑卡信息";
    [self getupCardInformation];
}

- (void)getupCardInformation
{
    [TFProgressHUD showLoading:@"处理中···"];
    [TFNetworkTools getResultWithUrl:@"api/user/userBankInfo" params:nil success:^(id responseObject) {
        
        [TFProgressHUD dismiss];
        
        if ([responseObject[@"code"] isEqual:@200]) {
            [self valuation:responseObject[@"data"]];
        }
    } failure:^(NSError *error) {
        [TFProgressHUD showFailure:@"信息获取失败"];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)valuation:(NSDictionary *)dict
{
    _nameLabel.text = [dict objectForKey:@"realname"];
    _codeLabel.text = [dict objectForKey:@"idcard"];
    _bankLabel.text = [dict objectForKey:@"bank_card"];
    _phoneLabel.text = [dict objectForKey:@"yuliu_mobile"];
}
@end
