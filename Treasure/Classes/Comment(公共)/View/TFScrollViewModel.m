//
//  TFScrollViewModel.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFScrollViewModel.h"

@implementation TFScrollViewModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.imageUrl = dict[@"img"];
        self.imageID = dict[@"url"];
        self.imageName = dict[@"title"];
        self.imageTitle = dict[@"action"];
    }
    return self;
}

+ (instancetype)scrollViewWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
