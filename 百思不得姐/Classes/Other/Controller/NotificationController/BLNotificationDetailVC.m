//
//  BLNotificationDetailVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLNotificationDetailVC.h"
#import "WYNewsDetailBottomView.h"

#import <ReactiveCocoa.h>
#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface BLNotificationDetailVC ()<WKNavigationDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) WKWebView *wkwebView;
@property (nonatomic, copy) void (^themeChangeBlock)();

@property (nonatomic, assign) BOOL isNight;
/// 底部视图
@property (nonatomic, weak) WYNewsDetailBottomView *bottomView;

/**
 网络加载进度条
 */
@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation BLNotificationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavItem];
    
}

/**
 初始化Item
 */
- (void)setupNavItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Item1" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Item2" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
}
/// 右边按钮
- (void)rightItemClick
{
    NSLog(@"点击了右边按钮");
    if (self.themeChangeBlock) {
        self.themeChangeBlock();
    }
}
/// 左边按钮
- (void)leftItemClick
{
    NSLog(@"点击了左边按钮");
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
    // 设置背景颜色
    __weak typeof(self) weakSelf= self;
    self.themeChangeBlock = ^{
         NSLog(@"调用了block代码");
        if (!weakSelf.isNight) {
            [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'" completionHandler:nil];
            [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'" completionHandler:nil];
            weakSelf.isNight = YES;
        }else{
            weakSelf.isNight = NO;
            [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#ffffff'" completionHandler:nil];
            [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'" completionHandler:nil];
        }
        
    };
//    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'" completionHandler:nil];
	[self addCloseView:webView.scrollView];
}

- (void)addCloseView:(UIScrollView *)scrollView
{
	WYNewsDetailBottomView *bottomView = [WYNewsDetailBottomView theBootomCloseView];
	self.bottomView = bottomView;
	bottomView.layer.borderWidth = 1.0;
	bottomView.layer.borderColor = [UIColor grayColor].CGColor;
	
	bottomView.frame = CGRectMake(3, scrollView.contentSize.height+5, scrollView.frame.size.width - 6, 44);
	[scrollView addSubview:bottomView];
}


// 正在滚动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (self.bottomView) {
		self.bottomView.isCloseing = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height) > 50;
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	NSLog(@"停止滑动了");
}

/// 松手的时候
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (self.bottomView.isCloseing) {
		UIImageView *imgV = [[UIImageView alloc] initWithFrame:scrollView.frame];
		imgV.image = [self getImageOn:scrollView];
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[window addSubview:imgV];
		[self.navigationController popViewControllerAnimated:NO];
		imgV.alpha = 1.0;
		[UIView animateWithDuration:0.3 animations:^{
			imgV.frame = CGRectMake(0, scrollView.frame.size.height/2, scrollView.frame.size.width, 0);
			imgV.alpha = 0;
		} completion:^(BOOL finished) {
			[imgV removeFromSuperview];
		}];
		NSLog(@"松手了");
	}
}

/// 截图
- (UIImage *)getImageOn:(UIScrollView *)scrollView
{
	UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, NO, 1.0);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
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
