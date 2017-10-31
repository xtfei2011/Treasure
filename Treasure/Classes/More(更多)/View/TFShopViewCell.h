//
//  TFShopViewCell.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFShop.h"

@class TFShopViewCell;
@protocol TFShopViewCellDelegate <NSObject>
- (void)shopViewCellConversionBtnClick:(TFShopViewCell *)cell;
@end

@interface TFShopViewCell : UICollectionViewCell
@property (nonatomic ,strong) UIView *baseView;
@property (nonatomic ,strong) UIImageView *commodityView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) UIButton *conversionBtn;

@property (nonatomic ,strong) TFShop *shop;
@property (nonatomic ,weak) id<TFShopViewCellDelegate>delegate;
@end
