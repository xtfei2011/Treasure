//
//  TFNormalViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPersonGroup.h"

@interface TFNormalViewCell : UITableViewCell
@property (nonatomic ,strong) TFNormalModel *normalModel;
+ (instancetype)initWithTableView:(UITableView *)tableview;
@end
