//
//  TFCountDownButton.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/9/26.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFCountDownButton : UIButton
// 开始时间数
@property (nonatomic ,assign) int started;
- (void)countDownButtonClick;
@end
