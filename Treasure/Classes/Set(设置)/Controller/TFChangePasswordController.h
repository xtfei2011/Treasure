//
//  TFChangePasswordController.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFAccountModel.h"

@interface TFChangePasswordController : UIViewController
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic ,strong) TFAccountModel *accountModel;
@end
