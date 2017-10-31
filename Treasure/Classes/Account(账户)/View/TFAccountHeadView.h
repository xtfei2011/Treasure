//
//  TFAccountHeadView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFAccountModel.h"

@interface TFAccountHeadView : UIView
/*** 头像 ***/
@property (weak ,nonatomic) IBOutlet UIImageView *headerView;
/*** 注册/登录视图 ***/
@property (weak ,nonatomic) IBOutlet UIView *loginView;

@property (nonatomic ,strong) TFAccountModel *accountModel;
@end
