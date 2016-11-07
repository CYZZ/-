//
//  AppDelegate.m
//  百思不得姐
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "AppDelegate.h"
#import "BLAllTableVC.h"
#import "BLTabBarController.h"
#import "JPUSHService.h" // 极光推送
#import "BLNotificationVC.h"

// iOS 10注册APNS所需文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要导入的头文件（可选)
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1. 初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    BLAllTableVC *AllVC = [[BLAllTableVC alloc] init];
    //2. 添加根控制器
//    self.window.rootViewController =[[UINavigationController alloc] initWithRootViewController: AllVC]; 
    self.window.rootViewController = [[BLTabBarController alloc] init];
    //3. 显示窗口
    [self.window makeKeyAndVisible];
    [self setupJPushWithOptions:launchOptions];
    
    return YES;
}

/**
 极光推送配置
 */
- (void)setupJPushWithOptions:(NSDictionary *)launchOptions
{
    // required
    if ([UIDevice currentDevice].systemVersion.floatValue >=10) {
        
        // 在iOS 10以上
        JPUSHRegisterEntity *entity =[[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else{
        
        // 在iOS8以上
        // 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|
                                                          UIUserNotificationTypeSound|
                                                          UIUserNotificationTypeAlert) categories:nil];
    }
    
    // Optional
    // 获取IDFA
    // 如需要使用IDFA请添加代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"c72e0ecd62070788ee2d2c45" channel:@"App Store" apsForProduction:YES];
}

// 回调方法
#pragma mark - 注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark - 实现APNs失败接口(可选)
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册APNs通知失败");
}

//*******************  JPUSH  ******************* 
#pragma mark - <JPUSHRegisterDelegate> 添加APNs通知回调方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    // required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(); // 系统要求执行这个方法
}

// iOS 10之前调用这个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 支持iOS6以下
    [JPUSHService handleRemoteNotification:userInfo];
}
//*******************  JPUSH  ******************* 


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
