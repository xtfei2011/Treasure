//
//  TFInformView.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInformView.h"
#import "TFInformViewCell.h"
#import "TFInform.h"
#define TFMaxSections 6

@interface TFInformView ()<UITableViewDelegate, UITableViewDataSource>
/*** 滚动视图 ***/
@property (nonatomic ,strong) UITableView *noticeView;
/*** 定时器 ***/
@property (nonatomic ,strong) NSTimer *timer;
/** 滚动通知数据 */
@property (nonatomic ,strong) NSMutableArray<TFInform *> *inform;
@end

@implementation TFInformView

/***  懒加载 noticeView ***/
- (UITableView *)noticeView
{
    if (!_noticeView) {
        _noticeView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _noticeView.sectionFooterHeight = 0;
        _noticeView.sectionHeaderHeight = 0;
        _noticeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noticeView.rowHeight = 32;
        _noticeView.delegate = self;
        _noticeView.dataSource = self;
        _noticeView.showsHorizontalScrollIndicator = NO;
        _noticeView.showsVerticalScrollIndicator = NO;
        _noticeView.scrollEnabled = NO;
        _noticeView.pagingEnabled = YES;
        
        [_noticeView registerClass:[TFInformViewCell class] forCellReuseIdentifier:@"cell"];
        _noticeView.tableFooterView = [[UIView alloc]init];
        [self addSubview:_noticeView];
    }
    return _noticeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadNoticeData];
    }
    return self;
}

- (void)loadNoticeData
{
    __weak typeof(self) homeSelf = self;
    
    [TFNetworkTools getResultWithUrl:@"api/activity/record/lottery" params:nil success:^(id responseObject)
    {
        homeSelf.inform = [TFInform mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [homeSelf.noticeView reloadData];
        
    } failure:^(NSError *error) {  }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.noticeView.frame = self.bounds;
}

- (void)setInform:(NSMutableArray<TFInform *> *)inform
{
    _inform = inform;
    
    if (inform == nil) {
        
        [self removeTimer];
        return;
    }
    if (inform.count == 1) {
        
        [self removeTimer];
    }
    [self.noticeView reloadData];
    [self.noticeView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:TFMaxSections / 2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [self addTimer];
}

- (NSIndexPath *)resetIndexPath
{
    /*** 当前正在展示的位置 ***/
    NSIndexPath *currentIndexPath = [[self.noticeView indexPathsForVisibleRows] lastObject];
    
    /*** 下一条展示的位置 ***/
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForRow:currentIndexPath.row inSection:TFMaxSections/2];
    [self.noticeView scrollToRowAtIndexPath:currentIndexPathReset atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    return currentIndexPathReset;
}

- (void)nextPage
{
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    
    /*** 计算下一条展示的位置 ***/
    NSInteger nextItem = currentIndexPathReset.row + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.inform.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextItem inSection:nextSection];
    
    /*** 动画滚动到下一条位置 ***/
    [self.noticeView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)setIsCanScroll:(BOOL)isCanScroll
{
    _isCanScroll = isCanScroll;
    self.noticeView.scrollEnabled = isCanScroll;
}

#pragma mark ---------- UITableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TFMaxSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.inform.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFInformViewCell *cell = [TFInformViewCell cellWithTableView:tableView];
    cell.inform = self.inform[indexPath.row];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)addTimer
{
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}
@end
