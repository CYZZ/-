//
//  BLNavigationController.m
//  百思不得姐
//
//  Created by cyz on 16/11/7.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLNavigationController.h"

@interface BLNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation BLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏控制的手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}


/**
 重写push方法的目的：拦截所有push进来的子控制器进行设置

 @param viewController 需要设置的子控制器
 @param animated       动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果不是navigation的根控制器
        // 左上角的返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        // 设置布局需要在sizeToFit后面才有效
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // 隐藏底部的工具条(UItabBar)
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 所有的设置布局完了之后再进行push
    [super pushViewController:viewController animated:animated];
    
}
- (void)back 
{
    [self popViewControllerAnimated:YES];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    NSLog(@"%s",__func__);
//    return  [super popViewControllerAnimated:animated];
//}

/**
 控制器手势代理方法

 @param gestureRecognizer 滑动手势

 @return 是否有效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效:当控制器数量大于1的时候有效
    return self.childViewControllers.count > 1;
    
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
