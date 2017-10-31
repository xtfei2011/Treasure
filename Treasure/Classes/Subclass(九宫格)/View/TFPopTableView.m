//
//  TFPopTableView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/19.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFPopTableView.h"
#import "TFPopupViewCell.h"
#import "TFPopup.h"

@interface TFPopTableView ()
/*** 弹出视图 ***/
@property (nonatomic ,strong) UIView *popupView;
/*** 列表视图 ***/
@property (nonatomic ,strong) UITableView *listTableView;
/*** 标题 ***/
@property (nonatomic ,strong) UILabel *titleLabel;
/*** 取消按钮 ***/
@property (nonatomic ,strong) UIButton *cancelBtn;
/*** 备注 ***/
@property (nonatomic ,strong) UILabel *remarkLabel;
/*** 查看按钮 ***/
@property (nonatomic ,strong) UIButton *checkBtn;
@end

@implementation TFPopTableView
/** cell的重用标识 */
static NSString * const PopupViewID = @"PopupViewCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, TFMainScreen_Width, TFMainScreen_Height);
        self.backgroundColor = TFRGBColor(5, 5, 5, 0.5);
        
        [self setupPopupView];
        [self setupListTableView];
        
        [self.listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TFPopupViewCell class]) bundle:nil] forCellReuseIdentifier:PopupViewID];
    }
    return self;
}

- (void)setupPopupView
{
    CGFloat popupH = self.xtf_height/2;
    CGFloat popupW = self.xtf_width - 100;
    
    _popupView = [[UIView alloc] initWithFrame:CGRectMake(50, (self.xtf_height - popupH)/2, popupW, popupH)];
    _popupView.backgroundColor = [UIColor whiteColor];
    _popupView.layer.cornerRadius = 3;
    _popupView.layer.masksToBounds = YES;
    
    [self addSubview:_popupView];
    
    for (int i = 0; i < 2; i ++) {
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 39 + i * (popupH - 140.5), popupW - 20, 0.5)];
        lineView.image = [UIImage imageNamed:@"线"];
        [_popupView addSubview:lineView];
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, popupW - 100, 40)];
    _titleLabel.text = @"收益记录";
    _titleLabel.font = TFCommentTitleFont;
    _titleLabel.textColor = TFColor(36, 180, 231);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_popupView addSubview:_titleLabel];
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 10, 5, 30, 30)];
    [_cancelBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_popupView addSubview:_cancelBtn];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _popupView.xtf_height - 65, popupW - 20, 30)];
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.font = TFCommentSubTitleFont;
    _remarkLabel.textColor = [UIColor lightGrayColor];
    [_popupView addSubview:_remarkLabel];
    
    NSArray *textArr = @[@"发放时间", @"奖励金额", @"发放状态"];
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(popupW/3 * i, 45, popupW/3, 20)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = TFCommentTitleFont;
        textLabel.textColor = [UIColor lightGrayColor];
        textLabel.text = textArr[i];
        [_popupView addSubview:textLabel];
    }
    
    _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake((popupW - 80)/2, CGRectGetMaxY(_remarkLabel.frame) + 3, 80, 25)];
    [_checkBtn addTarget:self action:@selector(examineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_checkBtn setTitle:@"我知道啦" forState:UIControlStateNormal];
    _checkBtn.backgroundColor = TFColor(251, 99, 102);
    _checkBtn.layer.cornerRadius = 12.5;
    _checkBtn.titleLabel.font = TFCommentTitleFont;
    [_popupView addSubview:_checkBtn];
}

- (void)setupListTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, _popupView.xtf_width, _popupView.xtf_height - 140)];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.backgroundColor = TFGlobalBg;
    _listTableView.rowHeight = 40;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    
    [self.popupView addSubview:_listTableView];
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.popup.record.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFPopupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopupViewID];
    cell.timeLabel.text = self.popup.record[indexPath.row][@"send_date"];
    cell.moneyLabel.text =  [NSString stringWithFormat:@"¥ %.2f",[self.popup.record[indexPath.row][@"money"] doubleValue]];
    cell.stateLabel.text = self.popup.record[indexPath.row][@"remark_str"];
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint pt = [touch locationInView:self];
    
    if (!CGRectContainsPoint([self.popupView frame], pt)) {
        [self closeAction];
    }
}

- (void)closeAction
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)setPopup:(TFPopup *)popup
{
    _popup = popup;
    
    TFInfo *info = popup.info;
    
    _remarkLabel.text = [NSString stringWithFormat:@"投标详情: %@  [投资期限%@个月 / 年化率%@%% / 投资金额%.2f元]",info.loan_title,info.loan_deadline,info.loan_apr,[info.invest_money doubleValue]];
    _checkBtn.tag = [info.loan_id integerValue];
}

- (void)examineButtonClick:(UIButton *)sender
{
    [self closeAction];
}
@end
