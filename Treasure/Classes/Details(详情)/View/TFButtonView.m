//
//  TFButtonView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFButtonView.h"

@interface TFButtonView ()
@property (nonatomic ,assign) CGFloat width;
@property (nonatomic ,assign) CGFloat height;
@property (nonatomic ,assign) CGFloat W;
@property (nonatomic ,assign) CGFloat H;
@property (nonatomic ,strong) UILabel *cashLabel;
@property (nonatomic ,strong) UILabel *increaseLabel;
@property (nonatomic ,strong) UILabel *experiLabel;
@end

@implementation TFButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.height = 110;
        self.userInteractionEnabled = YES;
        
        _mainscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.xtf_width, self.xtf_height)];
        _mainscrollView.backgroundColor = TFGlobalBg;
        [self addSubview:_mainscrollView];
        
        _experiLabel = [self createLabel];
        _experiLabel.frame = CGRectMake(10, 10, 50 , 20);
        [_mainscrollView addSubview:_experiLabel];
        
        _cashLabel = [self createLabel];
        [_mainscrollView addSubview:_cashLabel];
        
        _increaseLabel = [self createLabel];
        [_mainscrollView addSubview:_increaseLabel];
    }
    return self;
}

- (void)setButtonModel:(TFButtonModel *)buttonModel
{
    _buttonModel = buttonModel;
    self.cashArray = [NSMutableArray array];
    self.increaseArray = [NSMutableArray array];
    self.dict = [NSDictionary new];
    
    if ([buttonModel.relived[@"money"] doubleValue] == 0) {
        
        _experiLabel.hidden = YES;
        
    }else{
        _experiLabel.hidden = NO;
        _experiLabel.text = @"体验金:";
        self.dict = buttonModel.relived;
        [self experienceSelectButtonView];
    }
    
    if (buttonModel.award.count > 0) {
        [self.cashArray addObjectsFromArray:buttonModel.award];
        _cashLabel.hidden = NO;
        _cashLabel.text = @"现金劵:";
        [self cashSelectButtonView];
        
    }else{
        _cashLabel.hidden = YES;
    }
    
    if (buttonModel.addinterest.count > 0) {
        [self.increaseArray addObjectsFromArray:buttonModel.addinterest];
        _increaseLabel.hidden = NO;
        _increaseLabel.text = @"加息劵:";
        [self increaseSelectButtonView];
        
    }else{
        _increaseLabel.hidden = YES;
    }
}

/*** 体验金选择 ***/
- (void)experienceSelectButtonView
{
    NSString *btnTitle = [NSString stringWithFormat:@"%.2f",[self.dict[@"money"] doubleValue]];
    
    _experiButton = [self createButtonFrame:CGRectMake(10, CGRectGetMaxY(_experiLabel.frame) + 10, 80, 30) title:btnTitle target:self action:@selector(cashSelectBtnClick:)];
    _experiButton.tag = 1;
    
    _mainscrollView.contentSize = CGSizeMake(self.xtf_width, CGRectGetMaxY(self.experiButton.frame) + 50);
    [self.mainscrollView addSubview:_experiButton];
}

/*** 现金劵选择 ***/
- (void)cashSelectButtonView
{
    _cashLabel.frame = CGRectMake(10, CGRectGetMaxY(self.experiButton.frame) + 10, 50, 20);
    [_mainscrollView addSubview:_cashLabel];
    
    NSInteger num = self.cashArray.count;
    for (int i = 0; i < num; i++){
        
        NSString *btnTitle = [NSString stringWithFormat:@"%.2f",[self.cashArray[i][@"money"] doubleValue]];
        
        CGRect rect = [btnTitle boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
        self.width = CGRectGetMaxX(_cashButton.frame) + 10;
        
        if ((self.width + rect.size.width + 20) >= TFMainScreen_Width) {
            
            self.width = 10;
            self.height = CGRectGetMaxY(_cashButton.frame) + 10;
            _cashButton = [self createButtonFrame:CGRectMake(self.width, self.height, rect.size.width + 20, 30) title:btnTitle target:self action:@selector(cashSelectBtnClick:)];
        }else{
            
            self.width = CGRectGetMaxX(_cashButton.frame) + 10;
            _cashButton = [self createButtonFrame:CGRectMake(self.width, CGRectGetMaxY(_cashLabel.frame) + 10, rect.size.width + 20, 30) title:btnTitle target:self action:@selector(cashSelectBtnClick:)];
        }
        _cashButton.tag = i + 2;
        
        _mainscrollView.contentSize = CGSizeMake(self.xtf_width, CGRectGetMaxY(self.cashButton.frame) + 50);
        [self.mainscrollView addSubview:_cashButton];
    }
}

/*** 加息劵选择 ***/
- (void)increaseSelectButtonView
{
    _increaseLabel.frame = CGRectMake(10, CGRectGetMaxY(self.cashButton.frame) + 10, 50, 20);
    [_mainscrollView addSubview:_increaseLabel];
    
    NSInteger num = self.increaseArray.count;
    self.H = CGRectGetMaxY(_cashButton.frame) + 40;
    
    for (int i = 0; i < num; i++){
        
        NSString *btnTitle = [NSString stringWithFormat:@"%.2f%%",[self.increaseArray[i][@"money"] doubleValue]];
        
        CGRect sizeRect = [btnTitle boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
        self.W = CGRectGetMaxX(_increaseButton.frame) + 10;
        
        if ((self.W + sizeRect.size.width + 10) >= TFMainScreen_Width) {
            
            self.W = 10;
            self.H = CGRectGetMaxY(_increaseButton.frame) + 10;
            _increaseButton = [self createButtonFrame:CGRectMake(self.W, self.H, sizeRect.size.width + 20, 30) title:btnTitle target:self action:@selector(cashSelectBtnClick:)];
        }else{
            
            self.W = CGRectGetMaxX(_increaseButton.frame) + 10;
            _increaseButton = [self createButtonFrame:CGRectMake(self.W, self.H, sizeRect.size.width + 20, 30) title:btnTitle target:self action:@selector(cashSelectBtnClick:)];
        }
        _increaseButton.tag = i + self.cashArray.count + 2;
        
        _mainscrollView.contentSize = CGSizeMake(self.xtf_width, self.H + 50);
        [self.mainscrollView addSubview:_increaseButton];
    }
}

/*** 加息劵/代金券/体验金/点击事件 ***/
- (void)cashSelectBtnClick:(UIButton *)sender
{
    NSUInteger num = self.cashArray.count + self.increaseArray.count + 1;
    for (NSInteger i = 0; i < num; i++) {
        UIButton *button = [self viewWithTag:i + 1];
        if (button.tag == sender.tag) {
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.backgroundColor = TFColor(252, 99, 102);
            sender.layer.borderColor = TFColor(252, 99, 102).CGColor;
            
        } else {
            [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    
    if (sender.tag == 1) {
        self.idStr = self.dict[@"id"];
        self.moldStr = @"relived";
        self.moneyStr = [NSString stringWithFormat:@"%.2f",[self.dict[@"money"] doubleValue]];
    }
    if (1 < sender.tag && sender.tag < self.cashArray.count + 2){
        self.idStr = self.cashArray[sender.tag - 2][@"id"];
        self.moldStr = @"award";
        self.moneyStr = [NSString stringWithFormat:@"%.2f",[self.cashArray[sender.tag - 2][@"money"] doubleValue]];
    }
    if (sender.tag > self.cashArray.count + 1) {
        self.idStr = self.increaseArray[sender.tag - self.cashArray.count - 2][@"id"];
        self.moldStr = @"addinterest";
        self.moneyStr = [NSString stringWithFormat:@"%.2f%%",[self.increaseArray[sender.tag - self.cashArray.count - 2][@"money"] doubleValue]];;
    }
    if (self.buttonBlock) {
        self.buttonBlock(self.idStr, self.moldStr, self.moneyStr);
    }
}

- (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.layer.cornerRadius = 4;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button setBackgroundColor:[UIColor whiteColor]];
    button.titleLabel.font = TFCommentTitleFont;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UILabel *)createLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = TFColor(252, 99, 102);
    titleLabel.font = TFMoreTitleFont;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return titleLabel;
}
@end
