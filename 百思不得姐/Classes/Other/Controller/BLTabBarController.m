//
//  BLTabBarController.m
//  百思不得姐
//
//  Created by cyz on 16/11/7.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLTabBarController.h"
#import "BLTabBar.h"
#import "BLEssenceVC.h"
#import "BLNewVC.h"
#import "BLFollowVC.h"
#import "BLMeVC.h"
#import "BLNavigationController.h"
#import "BLAllTableVC.h"
#import "WYNewsTableVC.h"

#import "BLVTGPageController.h"

#import "BLNotificationDetailVC.h"
#import "YDController.h" // 一点资讯数据

@interface BLTabBarController ()

@end

@implementation BLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupItemTitleTextAttributes];
    
    [self setupChildViewControllers];
    
    [self setupTabBar];
}


/**
 设置所有Item的文字属性
 */
- (void)setupItemTitleTextAttributes
{
    // 拿到appearence设置完了之后所有的属性就会跟着改变
    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 设置选中状态的位置属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}


/**
 添加所有子控制器
 */
- (void)setupChildViewControllers
{
//    BLAllTableVC *jinhuaTable = [[BLAllTableVC alloc] init];
//    jinhuaTable.typeID = @"1";
//    BLNavigationController *jinhuaNav = [[BLNavigationController alloc] initWithRootViewController:jinhuaTable];
//    [self setupOneChildViewController:jinhuaNav title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    WYNewsTableVC *wyVC = [[WYNewsTableVC alloc] init];
    [self setupOneChildViewController:[[BLNavigationController alloc] initWithRootViewController:wyVC] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    
    BLAllTableVC *xintieTable = [[BLAllTableVC alloc] init];
    xintieTable.typeID = @"41";
    BLNavigationController *xintieNav = [[BLNavigationController alloc] initWithRootViewController:xintieTable];
    [self setupOneChildViewController:xintieNav title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
//    [self setupOneChildViewController:[[BLNavigationController alloc] initWithRootViewController:[[BLFollowVC alloc] init]] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
	[self setupOneChildViewController:[[BLNavigationController alloc] initWithRootViewController:[[BLVTGPageController alloc] init]] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
//    BLNotificationDetailVC *notifactionVC = [[BLNotificationDetailVC alloc] initWKWebViewWith:@"http://m.bailitop.com/japan/language_school/20161202/164533.html"];
//    [self setupOneChildViewController:[[BLNavigationController alloc] initWithRootViewController:notifactionVC] title:@"wkwebView" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
	
	YDController *yidianzixun = [[YDController alloc] init];
	[self setupOneChildViewController:[[BLNavigationController alloc] initWithRootViewController:yidianzixun] title:@"一点资讯" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
//    [self setupOneChildViewController:[[BLNavigationController alloc] initWithRootViewController:[[BLMeVC alloc] init]] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    
    
    
}


/**
 初始化一个子控制器

 @param vc            自控制器
 @param title         标题
 @param image         图片
 @param selectedImage 选中的图片
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    if (image.length) { // 如果图片名长度不为零 
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    [self addChildViewController:vc];
}

/**
 使用KVC替换TabBar(只读属性）
 */
- (void)setupTabBar
{
    [self setValue:[[BLTabBar alloc] init] forKey: @"tabBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
