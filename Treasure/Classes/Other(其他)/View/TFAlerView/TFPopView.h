//
//  TFPopView.h
//  JYTreasure
//
//  Created by 谢腾飞 on 2017/5/10.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTextFieldPopView.h"

@protocol TFPopViewDelegate <NSObject>
@optional
- (void)popViewCancelBtnClick:(Class)className;
- (void)popViewDetermineBtnClick:(NSString *)text className:(Class)className;
@end

@interface TFPopView : UIView
@property (nonatomic ,strong) TFTextFieldPopView *textFieldView;
@property (nonatomic ,weak) id <TFPopViewDelegate> delegate;
@property (nonatomic ,strong) NSArray<NSString *> *selectDataSource;
+ (instancetype)popView;
@end
