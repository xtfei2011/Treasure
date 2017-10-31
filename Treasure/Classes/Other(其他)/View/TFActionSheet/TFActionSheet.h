//
//  TFActionSheet.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/4/25.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFActionSheetCell.h"

@class TFActionSheet;
typedef void(^ClickBlock)(TFActionSheet *sheet, NSIndexPath *indexPath);

@interface TFActionSheet : UIView

- (instancetype)initWithTitles:(NSArray *)titles clickAction:(ClickBlock)clickBlock;

- (void)show;

- (void)hide;

@end
