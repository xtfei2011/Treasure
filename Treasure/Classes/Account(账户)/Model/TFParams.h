//
//  TFParams.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFParams : NSObject
@property (nonatomic ,strong) NSString *money;
@property (nonatomic ,strong) NSString *rsa_sign;
@property (nonatomic ,strong) NSString *mchnt_txn_ssn;
@property (nonatomic ,strong) NSString *idcard;
@property (nonatomic ,strong) NSString *realname;
@end
