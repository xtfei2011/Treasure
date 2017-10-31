//
//  TFPopup.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFInfo;
@interface TFPopup : NSObject
@property (nonatomic ,strong) TFInfo *info;
@property (nonatomic ,strong) NSArray *record;
@end


/*** 优惠劵投标信息 ***/
@interface TFInfo : NSObject
@property (nonatomic ,strong) NSString *loan_apr;
@property (nonatomic ,strong) NSString *loan_title;
@property (nonatomic ,strong) NSString *invest_money;
@property (nonatomic ,strong) NSString *loan_deadline;
@property (nonatomic ,strong) NSString *loan_id;
@end
