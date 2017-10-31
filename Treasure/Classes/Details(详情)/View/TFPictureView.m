//
//  TFPictureView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/22.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPictureView.h"
#import "TFPhotoViewController.h"

@implementation TFPictureView

- (void)setData:(NSArray *)data
{
    _data = data;
    
    CGFloat height = [self heightForCount:_data.count];
    self.xtf_height = height;
    _items = [NSMutableArray array];
    
    for (int i = 0; i < _data.count; i++) {
        
        TFPictureViewItem *item = [[TFPictureViewItem alloc]initWithFrame:[self frameForItemIndex:i]];
        [item sd_setImageWithURL:[NSURL URLWithString:_data[i][@"img"]]];
        item.contentMode = UIViewContentModeScaleAspectFit;
        item.originFrame = item.frame;
        item.index = i;
        item.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct:)];
        [item addGestureRecognizer:tap];
        
        [_items addObject:item];
        [self addSubview:item];
    }
}

- (void)tapAct:(UITapGestureRecognizer *)tap
{
    TFPictureViewItem *item = (TFPictureViewItem *)tap.view;
    
    TFPhotoViewController *pictureScroll = [[TFPhotoViewController alloc]init];
    pictureScroll.item = item;
    pictureScroll.pictureView = self;
    pictureScroll.data = self.data;
    
    [TFkeyWindowView.rootViewController presentViewController:pictureScroll animated:NO completion:nil];
}

- (CGFloat)heightForCount:(NSInteger)count
{
    long row = count/3;
    
    if (count % 3 != 0) {
        row ++;
    }
    CGFloat itemW = (TFMainScreen_Width - 40)/3;
    CGFloat height = itemW *row + 10 * (row + 1)/2;
    
    return height;
}

- (CGRect)frameForItemIndex:(int)count
{
    CGFloat itemW = (TFMainScreen_Width - 40) /3;
    CGFloat x = count %3 * itemW + 10 *(count %3+1)/2;
    CGFloat y = count /3 * itemW + 10 *(count /3+1)/2;
    
    return CGRectMake(x, y, itemW, itemW);
}
@end


@implementation TFPictureViewItem

@end
