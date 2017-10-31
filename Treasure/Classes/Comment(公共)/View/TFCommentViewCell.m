//
//  TFCommentViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/7.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFCommentViewCell.h"
#import "TFAnimationView.h"
#import "TFCountdownManager.h"

@interface TFCommentViewCell ()
/*** 环形进度条 ***/
@property (weak, nonatomic) IBOutlet UIView *baseView;
/*** 标题 ***/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/*** 编号 ***/
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
/*** 收益率 ***/
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
/*** 期限 ***/
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
/*** 剩余可投 ***/
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;
/*** 状态 ***/
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/*** 优惠 ***/
@property (weak, nonatomic) IBOutlet UILabel *treatmentLabel;

@property (nonatomic ,strong) TFAnimationView *animationView;
@end

@implementation TFCommentViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.treatmentLabel.layer.cornerRadius = 2;
    self.treatmentLabel.layer.masksToBounds = YES;
    self.treatmentLabel.layer.borderWidth = 0.5;
    self.treatmentLabel.layer.borderColor = TFColor(252, 99, 102).CGColor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countdownNotification) name:kCountdownNotification object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countdownNotification) name:kCountdownNotification object:nil];
    }
    return self;
}

- (void)countdownNotification
{
    if (0) return;
    
    NSInteger countdown = self.comment.invest_start_wait_time - [TFCountdownManager manager].timeInterval;
    /// 当倒计时到了进行回调
    if (countdown <= 0) {
        _statusLabel.text = self.comment.remark_str;
        // 回调给控制器
        !self.countdownZero ?: self.countdownZero();
        return;
    }
    /// 重新赋值
    _statusLabel.text = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", countdown/3600, (countdown/60)%60, countdown%60];
}

- (void)setComment:(TFComment *)comment
{
    _comment = comment;
    
    _titleLabel.text = comment.title;
    _numberLabel.text = [NSString stringWithFormat:@"编号:%@",comment.ID];
    _interestLabel.text = comment.apr;
    
    _periodLabel.text = [NSString stringWithFormat:@"期限：%@个月",comment.deadline];
    
    if (!comment.reward_apr) {
        _treatmentLabel.hidden = YES;
        
    } else if ([comment.reward_apr doubleValue] == 0) {
        
        _treatmentLabel.hidden = YES;
    } else {
        
        _treatmentLabel.hidden = NO;
        _treatmentLabel.text = [NSString stringWithFormat:@" +%@%% ",comment.reward_apr];
    }
    
    /*** 剩余可投金额 ***/
    if ([comment.can_invested_money doubleValue] == 0) {
        _residueLabel.text = @"剩余可投：已售罄";
        
    } else if ([comment.can_invested_money doubleValue] >= 10000) {
        _residueLabel.text = [NSString stringWithFormat:@"剩余可投：%.2f 万元",[comment.can_invested_money doubleValue] / 10000];
        _residueLabel.keywords = @"万元";
        
    } else {
        _residueLabel.text = [NSString stringWithFormat:@"剩余可投：%.2f 元",[comment.can_invested_money doubleValue]];
        _residueLabel.keywords = @"元";
    }
    
    /*** 状态 ***/
    if ([comment.remark_str isEqualToString:@"还款中"]) {
        _statusLabel.textColor = TFrayColor(123);
        
    } else {
        _statusLabel.textColor = TFColor(251, 99, 102);
    }
    
    if (comment.invest_start_wait_time != 0) {
        _statusLabel.font = TFCommentSubTitleFont;
   
    } else {
        _statusLabel.font = TFMoreTitleFont;
    }
    
    /*** 环形进度条 ***/
    CGFloat total = [comment.amount doubleValue];
    CGFloat remain = [comment.can_invested_money doubleValue];
    
    _animationView = [[TFAnimationView alloc] initWithFrame:self.baseView.bounds pathBackColor:nil pathFillColor:TFColor(252, 99, 102) startAngle:0 strokeWidth:5];
    _animationView.showProgressText = NO;
    _animationView.increaseFromLast = YES;
    _animationView.progress = ((total - remain)/total);
    [self.baseView addSubview:_animationView];
    
    [self countdownNotification];
}

- (void)dealloc
{
    TFLog(@"销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
