//
//  TFPersonGroup.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFPersonGroup : NSObject
@property (nonatomic, strong) NSArray *items;
@end

@interface TFNormalModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) Class destVc;

- (TFNormalModel *)initWithTitle:(NSString *)titile;
- (TFNormalModel *)initWithTitle:(NSString *)titile subTitle:(NSString *)subTitle;
@end
