//
//  TFTextView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placehoder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placehoderColor;
@end
