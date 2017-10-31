//
//  TFPickerView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPickerView.h"

@interface TFPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic ,strong) UIView *bottomView;       //底层视图
@property (nonatomic ,strong) UIPickerView *statePicker;//运营状态轱辘
@property (nonatomic ,strong) UIView *controllerToolBar;//控制工具栏
@property (nonatomic ,strong) UIButton *finishBtn;      //取消按钮
@property (nonatomic ,strong) UIButton *cancelBtn;      //取消按钮
@property (nonatomic ,strong) UILabel *titleLabel;      //标题
@property (nonatomic ,strong) NSString *stateStr;       //选中的运营状态
@property (nonatomic ,assign) NSInteger pickerHeight;    //弹层的高度
@end

@implementation TFPickerView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, TFMainScreen_Height)]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.userInteractionEnabled = YES;
        [self addSubview:self.maskView];
        self.pickerHeight = 280 - 160;
        
        /*** 初始化子视图 ***/
        [self initSubViews];
    }
    return self;
}

/*** 初始化子视图 ***/
- (void)initSubViews
{
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    
    self.statePicker = [[UIPickerView alloc] init];
    self.statePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.statePicker.backgroundColor = [UIColor whiteColor];
    self.statePicker.showsSelectionIndicator = YES;
    self.statePicker.dataSource = self;
    self.statePicker.delegate = self;
    [self.bottomView addSubview:self.statePicker];
    
    self.controllerToolBar = [[UIView alloc] init];
    self.controllerToolBar.backgroundColor = TFColor(252, 99, 102);
    [self.bottomView addSubview:_controllerToolBar];
    
    self.finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.finishBtn.titleLabel.font = TFMoreTitleFont;
    [self.finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.controllerToolBar addSubview:self.finishBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelBtn.titleLabel.font = TFMoreTitleFont;
    [self.cancelBtn addTarget:self action:@selector(canceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.controllerToolBar addSubview:_cancelBtn];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = TFSetPromptTitleFont;
    [self.controllerToolBar addSubview:self.titleLabel];
}

- (void)layoutSelfSubviews
{
    self.bottomView.frame = CGRectMake(0, TFMainScreen_Height, TFMainScreen_Width, self.pickerHeight);
    self.statePicker.frame = CGRectMake(0, 40, TFMainScreen_Width, self.pickerHeight - 40);
    self.controllerToolBar.frame = CGRectMake(0, 0, TFMainScreen_Width, 40);
    self.finishBtn.frame = CGRectMake(TFMainScreen_Width - 60, 5, 50, 30);
    self.cancelBtn.frame = CGRectMake(0, 5, 50, 30);
    self.titleLabel.frame = CGRectMake(70, 5, TFMainScreen_Width - 140, 30);
}

#pragma mark - set相关
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    //设置弹层高度
    if (280 - 160 + self.dataSource.count * 20 > 280 - 24) {
        self.pickerHeight = 280 - 24;
    } else {
        self.pickerHeight = 280 - 160 + self.dataSource.count * 20;
    }
    
    //设置返回默认值
    self.stateStr = [NSString stringWithFormat:@"%@/%@",_dataSource[0],@(1)];
    
    //刷新布局
    [self layoutSelfSubviews];
    [self.statePicker setNeedsLayout];
    
    //刷新轱辘数据
    [self.statePicker reloadAllComponents];
    [self.statePicker selectRow:0 inComponent:0 animated:NO];
}

- (void)setDefaultStr:(NSString *)defaultStr
{
    _defaultStr = defaultStr;
    
    self.stateStr = defaultStr;
    NSArray * selectArr = [defaultStr componentsSeparatedByString:@"/"];
    [self.statePicker selectRow:[selectArr[1] integerValue] - 1 inComponent:0 animated:NO];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataSource[row];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.stateStr = [NSString stringWithFormat:@"%@/%@",self.dataSource[row], @(row + 1)];
}

#pragma mark - 按钮相关
/**点击完成按钮*/
- (void)finishBtnClicked:(UIButton *)button
{
    self.selectValue(self.stateStr);
    [self removeSelfFromSupView];
}

/**点击取消按钮*/
- (void)canceBtnClicked:(UIButton *)button
{
    [self removeSelfFromSupView];
}

/**点击背景释放界面*/
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeSelfFromSupView];
}

#pragma mark - 显示弹层相关
/**弹出视图*/
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    //动画出现
    CGRect frame = self.bottomView.frame;
    if (frame.origin.y == TFMainScreen_Height) {
        frame.origin.y -= self.pickerHeight;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.frame = frame;
        }];
    }
}

/**移除视图*/
- (void)removeSelfFromSupView
{
    CGRect selfFrame = self.bottomView.frame;
    if (selfFrame.origin.y == TFMainScreen_Height - self.pickerHeight) {
        selfFrame.origin.y += self.pickerHeight;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.frame = selfFrame;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
