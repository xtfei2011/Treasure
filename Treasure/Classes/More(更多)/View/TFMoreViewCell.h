//
//  TFMoreViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IntegralBtnClickBlock)(NSInteger index);
@interface TFMoreViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,copy) IntegralBtnClickBlock block;
@end
