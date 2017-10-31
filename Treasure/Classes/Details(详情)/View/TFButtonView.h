//
//  TFButtonView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFButtonModel.h"

typedef void(^TFButtonBlock)(NSString *favorableID, NSString *favorable, NSString *money);

@interface TFButtonView : UIView
/*** 存储现金劵数据数组 ***/
@property (nonatomic ,retain) NSMutableArray *cashArray;
/*** 存储加息劵数据数组 ***/
@property (nonatomic ,retain) NSMutableArray *increaseArray;
/*** 存储体验金数据字典 ***/
@property (nonatomic ,strong) NSDictionary *dict;
@property (nonatomic ,strong) UIScrollView *mainscrollView;

@property (nonatomic ,strong) UIButton *cashButton;
@property (nonatomic ,strong) UIButton *increaseButton;
@property (nonatomic ,strong) UIButton *experiButton;

/*** Button对应的id ***/
@property (nonatomic ,strong) NSString *idStr;
/*** Button对应的优惠类型 ***/
@property (nonatomic ,strong) NSString *moldStr;
/*** Button对应的金额 ***/
@property (nonatomic ,strong) NSString *moneyStr;

@property (nonatomic ,copy) TFButtonBlock buttonBlock;
@property (nonatomic ,strong) TFButtonModel *buttonModel;
@end
