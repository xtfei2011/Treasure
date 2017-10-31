//
//  TFChooseView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFButtonView.h"
#import "TFButtonModel.h"

@class TFChooseView;
@protocol TFChooseViewDelegate <NSObject>
@optional
/*** 确定按钮点击事件 ***/
- (void)chooseViewSureButtonClick:(UIButton *)sender;
@end

@interface TFChooseView : UIView
@property (nonatomic ,strong) UIView *baseView;
@property (nonatomic ,strong) UIButton *sureBtn;
@property (nonatomic ,strong) UIButton *cancelBtn;

@property (nonatomic ,strong) TFButtonView *buttonView;
@property (nonatomic ,strong) TFButtonModel *buttonModel;
@property (nonatomic ,weak) id<TFChooseViewDelegate> delegate;
@end
