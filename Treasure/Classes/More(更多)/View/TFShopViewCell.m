//
//  TFShopViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFShopViewCell.h"

@implementation TFShopViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    CGFloat baseViewW = self.xtf_width - 20;
    CGFloat baseViewH = self.xtf_height - 20;
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, baseViewW, baseViewH)];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.borderWidth = 1;
    _baseView.layer.borderColor = TFColor(239, 239, 239).CGColor;
    [self.contentView addSubview:_baseView];
    
    _commodityView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, baseViewW - 20, (baseViewW - 20)/1.3)];
    _commodityView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:_commodityView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_commodityView.frame) + 5, baseViewW - 20, 15)];
    _titleLabel.font = TFMoreTitleFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:_titleLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 5, baseViewW - 40, 0.5)];
    lineView.image = [UIImage imageNamed:@"线"];
    [_baseView addSubview:lineView];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = TFCommentTitleFont;
    [_baseView addSubview:_priceLabel];
    
    _conversionBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame) + 30, baseViewW - 40, 25)];
    [_conversionBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    _conversionBtn.titleLabel.font = TFMoreTitleFont;
    _conversionBtn.backgroundColor = TFColor(252, 99, 102);
    _conversionBtn.layer.masksToBounds = YES;
    _conversionBtn.layer.cornerRadius = 12.5;
    [_conversionBtn addTarget:self action:@selector(conversionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_conversionBtn];
}

- (void)setShop:(TFShop *)shop
{
    _shop = shop;
    
    [_commodityView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:nil];
    
    _titleLabel.text = shop.title;
    
    _priceLabel.text = [NSString stringWithFormat:@"兑换价:%ld积分",[shop.price integerValue]];
    _priceLabel.keywords = [NSString stringWithFormat:@"%ld",[shop.price integerValue]];
    _priceLabel.keywordsColor = TFColor(252, 99, 102);
    
    CGSize priceSize =  [_priceLabel getLableSizeWithMaxWidth:200];
    _priceLabel.frame = CGRectMake((_baseView.xtf_width - priceSize.width)/2, CGRectGetMaxY(_titleLabel.frame) + 10, priceSize.width, priceSize.height);
    [_baseView addSubview:_priceLabel];
}

/*** 兑换按钮点击事件 ***/
- (void)conversionButtonClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(shopViewCellConversionBtnClick:)]) {
        [_delegate shopViewCellConversionBtnClick:self];
    }
}
@end
