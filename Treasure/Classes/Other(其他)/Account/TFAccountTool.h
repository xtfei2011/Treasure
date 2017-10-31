//
//  TFAccountTool.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFAccount.h"

@interface TFAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(TFAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (TFAccount *)account;

/**
 *  注销登录，删掉账户
 */
+ (void)logoutAccount;
@end
