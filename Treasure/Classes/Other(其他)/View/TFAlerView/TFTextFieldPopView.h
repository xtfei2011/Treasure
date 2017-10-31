//
//  TFTextFieldPopView.h
//  JYTreasure
//
//  Created by 谢腾飞 on 2017/5/10.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTextFieldPopView : UIView
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UILabel *titleLabel;

+ (instancetype)textFieldPopView:(void(^)(NSString *text))determineBtnClick cancelBtnClick:(void(^)())cancelBtnClick;
@end
