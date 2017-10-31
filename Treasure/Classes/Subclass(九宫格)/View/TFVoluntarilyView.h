//
//  TFVoluntarilyView.h
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFVoluntarily.h"

@interface TFVoluntarilyView : UIView
@property (weak, nonatomic) IBOutlet UITextField *rentalField;
@property (weak, nonatomic) IBOutlet UITextField *onceField;
@property (weak, nonatomic) IBOutlet UITextField *surplusField;
@property (weak, nonatomic) IBOutlet UILabel *lowestLabel;
@property (weak, nonatomic) IBOutlet UILabel *highestLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumLabel;
@property (weak, nonatomic) IBOutlet UILabel *tallestLabel;

/*** 点击手势 ***/
@property (nonatomic ,strong) UITapGestureRecognizer *lowestRecognizer;
@property (nonatomic ,strong) UITapGestureRecognizer *highestRecognizer;
@property (nonatomic ,strong) UITapGestureRecognizer *minimumRecognizer;
@property (nonatomic ,strong) UITapGestureRecognizer *tallestRecognizer;

@property (nonatomic ,strong) TFVoluntarily *voluntarily;
@end
