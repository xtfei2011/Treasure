//
//  TFPickerView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFPickerView : UIView
/*** 标题 ***/
@property (nonatomic ,strong) NSString *title;
/*** 数据 ***/
@property (nonatomic ,strong) NSArray *dataSource;
@property (nonatomic, strong) NSString *defaultStr;
/*** 数据回调 ***/
@property (nonatomic ,copy) void(^selectValue)(NSString *value);
/*** 显示视图 ***/
- (void)show;
@end
