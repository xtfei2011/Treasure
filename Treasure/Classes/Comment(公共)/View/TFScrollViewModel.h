//
//  TFScrollViewModel.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFScrollViewModel : NSObject

@property (nonatomic ,retain) NSString *imageUrl;
@property (nonatomic ,retain) NSString *imageID;
@property (nonatomic ,retain) NSString *imageName;
@property (nonatomic ,retain) NSString *imageTitle;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)scrollViewWithDict:(NSDictionary *)dict;
@end
