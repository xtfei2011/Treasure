//
//  TFDropMenuView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/16.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFIndexPath : NSObject

@property (nonatomic, assign) NSInteger row; //行
@property (nonatomic, assign) NSInteger column; //列
@property (nonatomic, assign) NSInteger item; //item

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item;

@end

#pragma  mark - datasource
@class TFDropMenuView;
@protocol TFDropMenuDataSource <NSObject>

@required
/*** 行数 ***/
- (NSInteger)menu:(TFDropMenuView *)menu numberOfRowsInColumn:(NSInteger)column;
/*** 每行的Title ***/
- (NSString *)menu:(TFDropMenuView *)menu titleForRowAtIndexPath:(TFIndexPath *)indexPath;
@optional
//有多少个column，默认为1列
- (NSInteger)numberOfColumnsInMenu:(TFDropMenuView *)menu;
//第column列，没行的image
- (NSString *)menu:(TFDropMenuView *)menu imageNameForRowAtIndexPath:(TFIndexPath *)indexPath;
//detail text
- (NSString *)menu:(TFDropMenuView *)menu detailTextForRowAtIndexPath:(TFIndexPath *)indexPath;
@end

#pragma mark - delegate
@protocol TFDropMenuDelegate <NSObject>

@optional
//点击
- (void)menu:(TFDropMenuView *)menu didSelectRowAtIndexPath:(TFIndexPath *)indexPath;

@end

@interface TFDropMenuView : UIView

@property (nonatomic, weak) id<TFDropMenuDelegate> delegate;
@property (nonatomic, weak) id<TFDropMenuDataSource> dataSource;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) NSInteger fontSize;
//当前选中的列
@property (nonatomic, strong) NSMutableArray *currentSelectedRows;
//获取title
- (NSString *)titleForRowAtIndexPath:(TFIndexPath *)indexPath;
//初始化方法
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
//菜单切换，选中的indexPath
- (void)selectIndexPath:(TFIndexPath *)indexPath;
//默认选中
- (void)selectDeafultIndexPath;
//数据重载
- (void)reloadData;
@end
