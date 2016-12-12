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
#import "BLNotificationDetailVC.h"
#import <SVProgressHUD.h>

#import <JPFPSStatus.h>

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
    self.window.backgroundColor = [UIColor whiteColor];
//    BLAllTableVC *AllVC = [[BLAllTableVC alloc] init];
    //2. 添加根控制器
//    self.window.rootViewController =[[UINavigationController alloc] initWithRootViewController: AllVC]; 
    self.window.rootViewController = [[BLTabBarController alloc] init];
    //3. 显示窗口
    [self.window makeKeyAndVisible];
    [self setupJPushWithOptions:launchOptions];
    
    [self debugFPS];
    
    return YES;
}


/**
 测试FPS
 */
- (void)debugFPS
{
#if defined(DEBUG)||defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
#endif
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
    
    
    
    [JPUSHService setupWithOption:launchOptions 
                           appKey:@"c72e0ecd62070788ee2d2c45"
                          channel:@"App Store" 
                 apsForProduction:YES];
    
    //TODO: 1.开始处理app退出后收到的通知消息（双击home键退出app/手机关闭后收到通知）
    if (launchOptions) {
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"remoteNotification=%@",remoteNotification);
        if (remoteNotification) {
//            NSLog(@"启动程序开始处理推送消息");
            /// iOS 10之前在后台收到通知（启动应用）
            NSLog(@"4 jpushNotificationCenter弹框了");
                [self pushNotificationViewController:remoteNotification];
            // 角标设置 推送消息+1
            [JPUSHService setBadge:[remoteNotification[@"aps"][@"badge"] integerValue]];
            // 开始跳转资讯页
        }
    }
    
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
/// 前台收到的通知（在使用应用过程中收到通知）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];

        NSLog(@"1 jpushNotificationCenter弹框了");
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"新闻推送" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* updateAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self pushNotificationViewController:userInfo];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertvc addAction:cancelAction];
        [alertvc addAction:updateAction];
        [self.window.rootViewController presentViewController:alertvc animated:YES completion:nil];
    }
    
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

/// iOS 10Support(app在后台或者未启动app）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    // required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        // 跳转
        [self pushNotificationViewController:userInfo];
        NSLog(@" 2 jpushNotificationCenter跳转");
    }
    completionHandler(); // 系统要求执行这个方法
}

/// iOS 10之前调用这个方法（app在后台或者未启动app）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
#warning bug通过后台发送的通在iOS 10会跳转到这个方法
    // 跳转
    [self pushNotificationViewController:userInfo];
    NSLog(@"3 jpushNotificationCenter跳转");
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 支持iOS6以下
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)pushNotificationViewController:(NSDictionary *)info 
{
    // 找到当前选中的导航控制器
    UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = tabBarVC.selectedViewController;
    
    NSString *url = [info valueForKey:@"url"];
    [nav pushViewController:[[BLNotificationDetailVC alloc] initWKWebViewWith:url] animated:YES];
    
    
    NSLog(@"info=%@",info);
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
