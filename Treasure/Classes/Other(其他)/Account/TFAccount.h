//
//  TFAccount.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFAccount : NSObject<NSCoding>
/*** access_token ***/
@property (nonatomic ,strong) NSString *access_token;
@end
