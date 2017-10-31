//
//  TFInvestOperationController.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFCommentBaseController.h"
#import "TFComment.h"
#import "TFInvestDetail.h"

@interface TFInvestOperationController : TFCommentBaseController
@property (nonatomic ,strong) TFComment *comment;
@property (nonatomic ,strong) TFInvestDetail *investDetail;
@end
