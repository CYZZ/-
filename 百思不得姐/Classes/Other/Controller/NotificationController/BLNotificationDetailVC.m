//
//  BLNotificationDetailVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLNotificationDetailVC.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface BLNotificationDetailVC ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) WKWebView *wkwebView;

/**
 网络加载进度条
 */
@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation BLNotificationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (instancetype)initWKWebViewWith:(NSString *)weburl
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
        wkwebView.scrollView.backgroundColor  = [UIColor whiteColor];
        // 创建一个webView
        self.wkwebView = wkwebView;
        // 创建一个进度条
        UIProgressView *progressView = [[UIProgressView alloc] init];
        self.progressView = progressView;
        progressView.tintColor = [UIColor colorWithRed:80.0/255.0 green:120.0/255.0 blue:240.0/255.0 alpha:1];
        progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:wkwebView];
//        [self.view addSubview:progressView];
        [self.view insertSubview:progressView aboveSubview:wkwebView];
        
        
        __weak typeof(self) weakSelf = self;
        [wkwebView mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.top.equalTo(weakSelf.mas_topLayoutGuideBottom);
//            make.left.bottom.right.insets(UIEdgeInsetsZero);
            make.edges.insets(UIEdgeInsetsZero);
        }];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakSelf.mas_topLayoutGuideBottom);
            make.left.right.offset(0);
            make.height.offset(2);
        }];
        
        
        [wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]]];
        //TODO: kvo监听进度
        [wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change 
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.wkwebView.estimatedProgress animated:YES];
        // 加载完成隐藏
        if (self.wkwebView.estimatedProgress == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                self.progressView.alpha = 0;
            }];
        }
    }
}

#pragma mark - <WKWebViewDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"网页加载失败");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"网络加载完成");
}


- (void)dealloc
{
    NSLog(@"%s",__func__);
    // 移除观察者
    [self.wkwebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
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
