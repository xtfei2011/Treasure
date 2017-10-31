//
//  TFAlertView.h
//  JYTreasure
//
//  Created by 谢腾飞 on 2017/5/8.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

/*** 提示类型枚举 ***/
typedef NS_ENUM(NSUInteger, TFHintType) {
    /** 文字提醒 */
    TFHintTypeDefault = 0,
    /** 选择提醒 */
    TFHintTypeSelect = 1,
};
typedef void(^TFAlertSelectBlock)(NSInteger index);
@interface TFAlertView : UIView

@property (nonatomic ,assign) TFHintType hintType;
@property (nonatomic ,copy) TFAlertSelectBlock block;
/*** 提示文字 **/
- (void)setPromptTitle:(NSString *)title font:(CGFloat)font;
- (void)setHintType:(TFHintType)hintType;
@end
