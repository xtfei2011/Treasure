//
//  TFShop.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFShop : NSObject
/** 产品图 */
@property (nonatomic ,strong) NSString *img;
/** 产品名 */
@property (nonatomic ,strong) NSString *title;
/** 积分 */
@property (nonatomic ,strong) NSString *price;
/** 商品id */
@property (nonatomic ,strong) NSString *ID;
@end
