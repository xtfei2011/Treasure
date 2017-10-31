//
//  TFSetHeaderView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFAccountModel.h"

@class TFSetHeaderView;
@protocol ReplaceHeaderDelegate <NSObject>
- (void)replaceHeaderButtonClick:(UIButton *)sender;
@end

@interface TFSetHeaderView : UIView
/*** 头像 ***/
@property (weak, nonatomic) IBOutlet UIImageView *headerView;

@property (nonatomic ,strong) TFAccountModel *accountModel;
@property (nonatomic ,weak) id<ReplaceHeaderDelegate>delegate;
@end
