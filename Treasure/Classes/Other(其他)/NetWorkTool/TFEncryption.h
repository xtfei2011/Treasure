//
//  TFEncryption.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFEncryption : NSObject
/*** 32位小写MD5加密 ***/
+ (NSString *)xtf_Encryption:(NSString *)input;
@end
