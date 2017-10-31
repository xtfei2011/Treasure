//
//  TFPictureView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/22.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFPictureView : UIView
@property (nonatomic ,retain) NSArray *data;
@property (nonatomic ,retain) NSMutableArray *items;
@end


@interface TFPictureViewItem : UIImageView
@property (nonatomic ,assign) CGRect originFrame;
@property (nonatomic ,assign) NSInteger index;
@end
