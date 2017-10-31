//
//  TFInvestOperationView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFInvestDetail.h"

@class TFInvestOperationView, TFTextField;
@protocol TFInvestOperationViewDelegate <NSObject>
@optional
/*** 充值代理点击事件 ***/
- (void)investmentOperationChooseBtn:(UIButton *)sender;
@end

@interface TFInvestOperationView : UIView
@property (nonatomic ,strong) TFInvestDetail *investDetail;
@property (weak, nonatomic) IBOutlet TFTextField *moneyfield;
@property (weak, nonatomic) IBOutlet TFTextField *passField;
@property (weak, nonatomic) IBOutlet UILabel *favorLabel;
@property (weak, nonatomic) id<TFInvestOperationViewDelegate> delegate;

/*** 余额 ***/
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@end
