//
//  TFAccountViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFAccountModel.h"

@class TFAccountViewCell;
@protocol TFAccountViewDelegate <NSObject>
- (void)accountViewBtnClick:(UIButton *)sender;
@end

@interface TFAccountViewCell : UITableViewCell

@property (nonatomic ,weak) id<TFAccountViewDelegate>delegate;
@property (nonatomic ,strong) TFAccountModel *accountModel;
@end
