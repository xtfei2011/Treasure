//
//  TFBaseViewController.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFBaseModel.h"

@interface TFBaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UITableView *baseTableView;
@property (nonatomic ,assign) TFBaseModelType type;
@end
