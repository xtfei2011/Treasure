//
//  UILabel+TFExtension.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TFExtension)
/**
 *  字间距
 */
@property (nonatomic ,assign)CGFloat characterSpace;

/**
 *  行间距
 */
@property (nonatomic ,assign)CGFloat lineSpace;

/**
 *  关键字
 */
@property (nonatomic ,copy)NSString *keywords;
@property (nonatomic ,strong)UIFont *keywordsFont;
@property (nonatomic ,strong)UIColor *keywordsColor;

/**
 *  下划线
 */
@property (nonatomic ,copy)NSString *underlineStr;
@property (nonatomic ,strong)UIColor *underlineColor;

/**
 *  计算label宽高，必须调用
 *
 *  @param maxWidth 最大宽度
 *
 *  @return label的size
 */
- (CGSize)getLableSizeWithMaxWidth:(CGFloat)maxWidth;
@end
