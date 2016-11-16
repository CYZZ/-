//
//  BLTabBar.m
//  百思不得姐
//
//  Created by cyz on 16/11/7.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLTabBar.h"
#import "BLNavigationController.h"
#import "BLSentMessageVC.h"

@interface BLTabBar ()

/**
 中间的加号按钮
 */
@property (nonatomic, weak) UIButton *publishButton;
@end

@implementation BLTabBar

#pragma mark - 懒加载
- (UIButton *)publishButton
{
    if (!_publishButton) {
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        _publishButton = publishButton;
        
    }
    return _publishButton;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 在这里可以设置背景颜色和图片
        
        // 如果设置这个属性如果没有设置选中状态的图片，则选中图片就是把原图进行渲染之后的图片
        // 选中文字就是选中之后的文字
        [self setTintColor:[UIColor darkGrayColor]];
    }
    return self;
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 按钮的尺寸
    CGFloat buttonW = self.frame.size.width / 5;
    CGFloat buttonH = self.frame.size.height;
    
    //** 设置所有UITabBarButton的frame *********
    CGFloat tabBarButtonY = 0;
    // 按钮的索引
    __block int tabBarButtonIndex = 0;
//    for (UIView *subView in self.subviews) {
//        if (subView.class != NSClassFromString(@"UITabBarButton")) {
//            continue;
//        }
//    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 过滤掉非UITabbarButton
        if (obj.class != NSClassFromString(@"UITabBarButton"))  return ;

        // 设置frame
        CGFloat tabBarButtonX = tabBarButtonIndex * buttonW;
        if (tabBarButtonIndex >=2) {
            tabBarButtonX += buttonW;
        }
        obj.frame = CGRectMake(tabBarButtonX, tabBarButtonY, buttonW, buttonH);
        
        // 增加索引
        tabBarButtonIndex++;
        
    }];
    
    //*************** 设置中间的发布按钮的frame  ********
    self.publishButton.frame = CGRectMake(0, 0, buttonW, buttonH);
    self.publishButton.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
}

#pragma mark - 监听中间按钮点击
-  (void)publishClick
{
    NSLog(@"%s",__func__);
    [self.window.rootViewController presentViewController:[[BLNavigationController alloc] initWithRootViewController:[[BLSentMessageVC alloc] init]] animated:YES completion:^{
        
    }];
}



@end
