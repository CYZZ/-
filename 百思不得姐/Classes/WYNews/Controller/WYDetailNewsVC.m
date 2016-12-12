//
//  WYDetailNewsVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "WYDetailNewsVC.h"
#import "WYNewsDeaiViewModel.h"

#import <Masonry.h>

@interface WYDetailNewsVC ()<UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *webView;

/**
 资讯详情模型
 */
@property (nonatomic, strong) WYNewsDeaiViewModel *viewModel;

/**
 字体大小
 */
@property (nonatomic, assign) NSInteger fonSize;

@end

@implementation WYDetailNewsVC

#pragma mark - 懒加载
- (WYNewsDeaiViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[WYNewsDeaiViewModel alloc] init];
    }
    return _viewModel;
}

- (NSInteger)fonSize
{
    if (!_fonSize) {
        _fonSize = 15;
    }
    return _fonSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    // 监听数据变化
    RAC(self.viewModel, listModel) = RACObserve(self, listModel);
    NSLog(@"self.viewModel=%@",self.viewModel.listModel);
    [[self.viewModel.fetchNewsDetailCommand execute:nil] subscribeError:^(NSError *error) {
        // 暂时不做处理
        NSLog(@"接收信号失败=%@",error);
    } completed:^{
        [self showInWebView];
        NSLog(@"进入了subscribeError");
    }];
    
    
    [self setupNav];
    
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.delegate = self;
//        _webView.alpha = 0;
    }
    return _webView;
}

- (void)setupNav
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"切换页面模式" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换夜间模式" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
}

- (void)rightItemClick
{
    //TODO: 调用 js方法设置夜间模式
    [self.webView stringByEvaluatingJavaScriptFromString:@"myFunction(\"night\");"];
    
    
//    if (self.fonSize < 40) {
//        self.fonSize++;
//    }else{
//        self.fonSize = 15;
//    }
//    
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.getElementsByClassName('content')[0].style.fontSize = '%ldpx'",self.fonSize]];
    
}

- (void)leftItemClick
{
	// FIXME: y没有实现
	[self.webView stringByEvaluatingJavaScriptFromString:@"ifr_doc.execCommand('Undo',false,param);"];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"myFunction(\"day\");"];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"myScrollfunc();"];
//    
//    NSLog(@"切换夜间模式%@",[[NSBundle mainBundle] URLForResource:@"WYNight.css" withExtension:nil]);
//    
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.documentElement.getElementsById('night').href='%@'",[[NSBundle mainBundle] URLForResource:@"WYNight.css" withExtension:nil]]];
	
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"<link rel=\"stylesheet\" id=\"night\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"WYNight.css" withExtension:nil]]];
}

- (void)showInWebView
{
    [self.webView loadHTMLString:[self.viewModel getHtmlString] baseURL:nil];
    NSLog(@"[self.viewModel getHtmlString]=%@",[self.viewModel getHtmlString]);
    NSLog(@"%@",[self.viewModel getHtmlString]);
//    [UIView animateWithDuration:0.5 animations:^{
//       self.webView.alpha = 1; 
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:"];
    if (range.location != NSNotFound) {
        //        NSInteger begin = range.location + range.length;
        //        NSString *src = [url substringFromIndex:begin];
        //        [self savePictureToAlbum:src];
        NSLog(@"点击的图片是%@",url);
//        [self showPictureWithAbsoluteUrl:url];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"网页开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
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
