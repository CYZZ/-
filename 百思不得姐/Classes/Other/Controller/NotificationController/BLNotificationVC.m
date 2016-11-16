//
//  BLNotificationVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/7.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLNotificationVC.h"
#import <WebKit/WebKit.h>
#import <SVProgressHUD.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface BLNotificationVC ()<WKNavigationDelegate, UIScrollViewDelegate, UINavigationControllerDelegate>

@property(nonatomic, weak) WKWebView *wkwebView;

@end

@implementation BLNotificationVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
//    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.delegate = self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
    //- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//{
//    // 判断要显示的控制器是否是自己
////    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//    NSLog(@"调用了willShowViewController代理方法");
//    [navigationController setNavigationBarHidden:YES animated:YES];
//}

- (instancetype)initWithWkwebView:(NSString *)URL
{
    
    if (self = [super init]) {
        NSLog(@"初始化页面");
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 通过js与webView内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        // 初始化WKWebView带有config
        WKWebView *wkwebView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:config];
//        wkwebView.
        wkwebView.navigationDelegate = self;
        wkwebView.scrollView.delegate = self;
        wkwebView.scrollView.backgroundColor  = [UIColor lightGrayColor];
        // 创建一个webView
        self.wkwebView = wkwebView;
        [self.view addSubview:wkwebView];
        
        [wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    }
    return self;
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    [SVProgressHUD setViewForExtension:self.view];
    [SVProgressHUD show];
    NSLog(@"网页开始加载");
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
    NSLog(@"网页加载完成");
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
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
