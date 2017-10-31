//
//  TFBanksViewController.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/9/8.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectBank)(NSString *bankName ,NSString *bankID);
@interface TFBanksViewController : UITableViewController
@property (nonatomic ,strong) SelectBank selectBank;
@end
