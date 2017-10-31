//
//  TFHeaderMenuView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/12.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat MenuHeight;
typedef void (^HeaderMenuBlock)(id object);
typedef void (^MenuSortBlock)(void);

@interface TFHeaderMenuView : UIView
@property (nonatomic ,copy) HeaderMenuBlock headerBlock;
/*** 升序 ***/
@property (nonatomic ,copy) MenuSortBlock ascendBlock;
/*** 降序 ***/
@property (nonatomic ,copy) MenuSortBlock descendBlock;

+ (CGFloat)menuHeight;

- (void)selectMenu:(HeaderMenuBlock)block;
- (void)selectMenuAscend:(MenuSortBlock)ascendBlock;
- (void)selectMenuDescend:(MenuSortBlock)descendBlock;
@end


#pragma mark =====  /*** TFMenuView ***/

typedef void (^HeaderMenuSelectBlock)(id object);
typedef void (^MenuAscendSortBlock)(void);
typedef void (^MenuDescendSortBlock)(void);

@interface TFMenuView : UIView

@property (nonatomic ,assign) NSInteger selectIndex;
@property (nonatomic ,strong) NSArray *titleArray;
@property (nonatomic ,strong) UIView *bottomLine;

@property (nonatomic ,copy) HeaderMenuSelectBlock selectBlock;
/*** 升序 ***/
@property (nonatomic ,copy) MenuAscendSortBlock ascendSortBlock;
/*** 降序 ***/
@property (nonatomic ,copy) MenuDescendSortBlock descendSortBlock;

- (instancetype)initWithDataArray:(NSArray *)titleArray;
@end
