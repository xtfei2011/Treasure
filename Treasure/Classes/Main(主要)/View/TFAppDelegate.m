//
//  TFAppDelegate.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFAppDelegate.h"
#import "TFTabBarController.h"
#import "TFNavigationController.h"
#import "TFNewfeatureController.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface TFAppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation TFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*** 状态栏颜色 ***/
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = TFScreeFrame;
    self.window.backgroundColor = TFGlobalBg;
    
    /*** 版本新特征 ***/
    [self versionMonitor];
    /*** 网络判断 ***/
    [self networkMonitor];
    /*** 推送 ***/
    [self jpushNotificationCenter:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/*** 推送 ***/
- (void)jpushNotificationCenter:(NSDictionary *)launchOptions
{
    /*** 推送 ***/
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"1dad2f31c65c22cfb771f737" channel:@"App Store" apsForProduction:NO advertisingIdentifier:nil];
    
    [JPUSHService setLogOFF];
}

/*** 版本新特征 ***/
- (void)versionMonitor
{
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [TFUSER_DEFAULTS objectForKey:key];
    /*** 当前软件的版本号（从Info.plist中获得） ***/
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        self.window.rootViewController = [[TFTabBarController alloc] init];
    } else {
        /*** 这次打开的版本和上一次不一样，显示新特性 ***/
        self.window.rootViewController = [[TFNewfeatureController alloc] init];
        /*** 将当前的版本号存进沙盒 ***/
        [TFUSER_DEFAULTS setObject:currentVersion forKey:key];
        [TFUSER_DEFAULTS synchronize];
    }
}

/*** 网络判断 ***/
- (void)networkMonitor
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            whetherHaveNetwork = NO;
            [TFProgressHUD showInfoMsg:@"网络中断，请检查您的网络环境！"];
        } else {
            whetherHaveNetwork = YES;
            [TFProgressHUD showSuccess:@"网络已连接，请刷新页面！"];
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
@end
