//
//  TFCommentViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFComment.h"

@interface TFCommentViewCell : UITableViewCell
@property (nonatomic ,strong) TFComment *comment;
@property (nonatomic, assign) BOOL needCountDown;

/// 倒计时到0时回调
@property (nonatomic ,copy) void(^countdownZero)();
@end
