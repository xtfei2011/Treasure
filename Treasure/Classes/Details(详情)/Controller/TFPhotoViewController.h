//
//  TFPhotoViewController.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/22.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPictureView.h"

@interface TFPhotoViewController : UIViewController
@property (nonatomic ,retain) TFPictureViewItem *item;
@property (nonatomic ,retain) TFPictureView *pictureView;
@property (nonatomic ,retain) NSArray *data;
@end
