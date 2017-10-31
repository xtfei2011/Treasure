//
//  TFIntroduceViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/13.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFIntroduce.h"

typedef void(^IntroduceBtnClickBlock)(NSInteger index);

@interface TFIntroduceViewCell : UITableViewCell
@property (nonatomic ,copy) IntroduceBtnClickBlock block;
@property (nonatomic ,strong) TFIntroduce *introduce;
@end
