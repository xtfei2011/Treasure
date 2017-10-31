//
//  TFPopTableView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPopup.h"

@class TFPopup, TFPopTableView;
@protocol TFPopTableViewDelegate <NSObject>
- (void)popTableViewButtonClick:(UIButton *)sender;
@end

@interface TFPopTableView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) TFPopup *popup;
@property (nonatomic ,strong) TFInfo *info;
@property (nonatomic, weak) id<TFPopTableViewDelegate>delegate;
@end
