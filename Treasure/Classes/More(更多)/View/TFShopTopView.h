//
//  TFShopTopView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFShopTopView;
@protocol TFShopTopViewBtnDelegate <NSObject>
- (void)shopTopViewButtonClick:(UIButton *)sender;
@end

@interface TFShopTopView : UIView
@property (nonatomic ,weak) id<TFShopTopViewBtnDelegate>delegate;
@end
