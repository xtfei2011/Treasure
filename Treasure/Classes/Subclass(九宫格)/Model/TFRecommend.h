//
//  TFRecommend.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFRecommend : NSObject
/** 手机 */
@property (nonatomic ,strong) NSString *mobile;
/** 金额 */
@property (nonatomic ,strong) NSString *money;
/** 投资人*/
@property (nonatomic ,strong) NSString *info;
/** 未发放 */
@property (nonatomic ,strong) NSString *is_reward;
@end
