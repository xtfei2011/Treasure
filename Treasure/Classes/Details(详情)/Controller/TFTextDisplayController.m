//
//  TFTextDisplayController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/18.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTextDisplayController.h"

@interface TFTextDisplayController ()
@property (nonatomic ,strong) UIScrollView *scorllView;
@property (nonatomic ,strong) UILabel *contentLabel;
@end

@implementation TFTextDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadTextContent];
}

- (void)loadTextContent
{
    [TFNetworkTools getResultWithUrl:self.urlStr params:nil success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            return ;
        } else {
            [self setupScrollView:responseObject];
        }
    } failure:^(NSError *error) {  }];
}

- (void)setupScrollView:(NSDictionary *)dict
{
    _scorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.xtf_width, self.view.xtf_height)];
    _scorllView.backgroundColor = [UIColor whiteColor];
    _scorllView.contentSize = CGSizeMake(0, 0);
    [self.view addSubview:_scorllView];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.xtf_width - 20, 100)];
    _contentLabel.backgroundColor = [UIColor whiteColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = TFMoreTitleFont;
    _contentLabel.text = dict[@"data"];
    
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(_contentLabel.xtf_width, MAXFLOAT)];
    _contentLabel.xtf_height = size.height;
    [_scorllView addSubview:_contentLabel];
    _scorllView.contentSize = CGSizeMake(self.view.xtf_width, size.height);
}
@end
