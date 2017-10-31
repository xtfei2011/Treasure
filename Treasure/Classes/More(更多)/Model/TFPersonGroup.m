//
//  TFPersonGroup.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPersonGroup.h"

@implementation TFPersonGroup

@end

@implementation TFNormalModel

- (TFNormalModel *)initWithTitle:(NSString *)titile
{
    TFNormalModel *model = [[TFNormalModel alloc] init];
    model.title = titile;
    return model;
}

- (TFNormalModel *)initWithTitle:(NSString *)titile subTitle:(NSString *)subTitle
{
    TFNormalModel *model = [[TFNormalModel alloc] init];
    
    model.title = titile;
    model.subTitle = subTitle;
    
    return model;
}
@end
