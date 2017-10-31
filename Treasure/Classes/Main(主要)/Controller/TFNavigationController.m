//
//  TFNavigationController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFNavigationController.h"

@interface TFNavigationController ()

@end

@implementation TFNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackground"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"ArialMT" size:18], NSFontAttributeName,  nil]];
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        viewController.view.backgroundColor = TFGlobalBg;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [backButton setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [backButton setTitle:@" 返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        // 这句代码放在sizeToFit后面
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backButtonClick
{
    [self.view endEditing:YES];
    
    [self popViewControllerAnimated:YES];
}
@end
