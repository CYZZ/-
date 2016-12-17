//
//  WYDetailNewsVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "WYDetailNewsVC.h"
#import "WYNewsDeaiViewModel.h"
#import "WYNewsDetailBottomView.h"

#import <Masonry.h>

@interface WYDetailNewsVC ()<UIWebViewDelegate, UIScrollViewDelegate>

@property(nonatomic, strong)UIWebView *webView;
/// 底部视图
@property (nonatomic, weak) WYNewsDetailBottomView *bottomView;

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
	
//	UIView *footerView = [[UIView alloc] init];
//	footerView.backgroundColor = [UIColor greenColor];
//	
//	footerView.frame = CGRectMake(0, self.webView.scrollView.contentSize.height, self.webView.frame.size.width, 40);
//	RAC(footerView.frame.size, width) = RACObserve(self.webView.scrollView, contentSize.width);
	
//	[self.webView.scrollView addSubview:footerView];
	
    // 监听数据变化
    RAC(self.viewModel, listModel) = RACObserve(self, listModel);
//    NSLog(@"self.viewModel=%@",self.viewModel.listModel);
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
		_webView.scrollView.delegate = self;
		_webView.scrollView.backgroundColor = [UIColor whiteColor];
//        _webView.alpha = 0;
    }
    return _webView;
}

- (void)setupNav
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"切换页面模式" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换夜间模式" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
}

- (void)rightItemClick:(UIBarButtonItem *)item
{
    //TODO: 调用 js方法设置夜间模式
    [self.webView stringByEvaluatingJavaScriptFromString:@"myFunction(\"night\");"];
	
	// 通知代理
	// 判断代理信号是否有值
	if (self.delegateSinal) {
		// 有值才需要通知
		[self.delegateSinal sendNext:item];
	}
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
    [self.webView stringByEvaluatingJavaScriptFromString:@"myFunction(\"day\");"];
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
//    NSLog(@"[self.viewModel getHtmlString]=%@",[self.viewModel getHtmlString]);
//    NSLog(@"%@",[self.viewModel getHtmlString]);
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
	
//	[self setupBottomViewAt:webView];
	WYNewsDetailBottomView *bottomView = [WYNewsDetailBottomView theBootomCloseView];
	self.bottomView = bottomView;
	bottomView.layer.borderWidth = 1.0;
	bottomView.layer.borderColor = [UIColor grayColor].CGColor;
	
	bottomView.frame = CGRectMake(3, webView.scrollView.contentSize.height+5, webView.frame.size.width - 6, 44);
	[webView.scrollView addSubview:bottomView];
}

// 正在滚动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (self.bottomView) {
		self.bottomView.isCloseing = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height) > 50;
	}
}

/// 松手的时候
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (self.bottomView.isCloseing) {
		UIImageView *imgV = [[UIImageView alloc] initWithFrame:scrollView.frame];
		imgV.image = [self getImage];
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
- (UIImage *)getImage
{
	UIGraphicsBeginImageContextWithOptions(self.webView.frame.size, NO, 1.0);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}


/**
 设置底部控件

 @param webView 所在的webView
 */
- (void)setupBottomViewAt:(UIWebView *)webView
{
	WYNewsDetailBottomView *bottomView = [WYNewsDetailBottomView theBootomCloseView];
	self.bottomView = bottomView;
	
	bottomView.frame = CGRectMake(0, webView.scrollView.contentSize.height, webView.frame.size.width, 44);
	[webView.scrollView addSubview:bottomView];
	
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll; // 支持屏幕旋转的方向
}

- (BOOL)shouldAutorotate
{
	return YES;
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
