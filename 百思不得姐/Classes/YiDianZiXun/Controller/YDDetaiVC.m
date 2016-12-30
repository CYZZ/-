//
//  YDDetaiVC.m
//  百思不得姐
//
//  Created by cyz on 16/12/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDDetaiVC.h"
#import "YDDetailViewModel.h"
#import <Masonry.h>

@interface YDDetaiVC () <UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
/// 资讯详情模型viewModel
@property (nonatomic, strong) YDDetailViewModel *viewModel;

@end

@implementation YDDetaiVC
#pragma mark - 懒加载
- (YDDetailViewModel *)viewModel
{
	if (!_viewModel) {
		_viewModel = [[YDDetailViewModel alloc] init];
	}
	return _viewModel;
}

- (UIWebView *)webView
{
	if (!_webView) {
		_webView = [[UIWebView alloc] initWithFrame:self.view.frame];
		_webView.delegate = self;
		_webView.scrollView.delegate = self;
		_webView.scrollView.backgroundColor = [UIColor whiteColor];
	}
	return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view addSubview:self.webView];
	[self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.insets(UIEdgeInsetsZero);
	}];
	
	RAC(self.viewModel, result) = RACObserve(self, result);
	
	[[self.viewModel.fetchNewsDetaiCommand execute:nil] subscribeError:^(NSError *error) {
		NSLog(@"接收信号失败=%@",error);
	} completed:^{
		[self showInWebView]; // 显示网页
		NSLog(@"接收信号成功");
	}];
	
}

- (void)showInWebView
{
	[self.webView loadHTMLString:[self.viewModel getHtmlString] baseURL:nil];
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
