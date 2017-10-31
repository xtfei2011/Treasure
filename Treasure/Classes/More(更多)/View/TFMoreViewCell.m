//
//  TFMoreViewCell.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/6.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFMoreViewCell.h"

@interface TFMoreViewCell ()
/** 新手福利·积分商城 */
@property (nonatomic ,strong) UIButton *integralBtn;
@end

@implementation TFMoreViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"moreViewCell";
    TFMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFMoreViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    NSArray *imageArr = @[@"benefit", @"store"];
    NSInteger Height = 340 * (TFMainScreen_Width /2 - 0.25) / 720;
    
    for (int i = 0; i < 2; i ++) {
        
        _integralBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _integralBtn.tag = 1000 + i;
        [_integralBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        _integralBtn.frame = CGRectMake((TFMainScreen_Width /2 + 0.5) * i, 0, TFMainScreen_Width /2 - 0.25, Height);
        [_integralBtn addTarget:self action:@selector(integralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_integralBtn];
    }
}

- (void)integralBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 1000;
    if (self.block) {
        self.block(index);
    }
}
@end
