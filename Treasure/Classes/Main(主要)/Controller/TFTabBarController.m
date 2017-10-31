//
//  TFTabBarController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFTabBarController.h"
#import "TFNavigationController.h"
#import "TFHomeViewController.h"
#import "TFInvestViewController.h"
#import "TFMoreViewController.h"
#import "TFAccountViewController.h"

@interface TFTabBarController ()

@end

@implementation TFTabBarController

+ (void)initialize
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = TFCommentTitleFont;
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = TFColor(252, 99, 102);
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**** 添加子控制器 ****/
    [self setupChildViewControllers];
}

/**** 添加子控制器 ****/
- (void)setupChildViewControllers
{
    TFHomeViewController *home = [[TFHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"home" selectedImage:@"home_highlight"];
    
    TFInvestViewController *invest = [[TFInvestViewController alloc] init];
    [self addChildVc:invest title:@"投资" image:@"invest" selectedImage:@"invest_highlight"];
    
    TFMoreViewController *more = [[TFMoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:more title:@"更多" image:@"more" selectedImage:@"more_highlight"];
    
    TFAccountViewController *account = [[TFAccountViewController alloc] init];
    [self addChildVc:account title:@"账户" image:@"account" selectedImage:@"account_highlight"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.view.backgroundColor = TFGlobalBg;
    
    TFNavigationController *nav = [[TFNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}
@end
