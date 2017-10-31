//
//  TFInformViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFInform.h"

@interface TFInformViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,strong) TFInform *inform;
@end
