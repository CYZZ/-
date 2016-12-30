//
//  BLSentMessageVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/8.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLSentMessageVC.h"
#import <AVFoundation/AVFoundation.h>
#import <ZFPlayer.h>
#import <Masonry.h>
//#import <>

@interface BLSentMessageVC () <ZFPlayerDelegate>

/**
 视频播放视图
 */
@property(weak, nonatomic) ZFPlayerView *playerView;

/**
 视频播放模型
 */
@property (nonatomic, strong) ZFPlayerModel *playerModel;

/**
 自定义uiwebView
 */
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BLSentMessageVC

#pragma mark - 懒加载
- (ZFPlayerModel *)playerModel
{
    if (!_playerModel) {
        _playerModel = [[ZFPlayerModel alloc] init];
        _playerModel.title = @"自定义标题";
        _playerModel.videoURL = [NSURL URLWithString: self.videourl];
//        _playerModel.placeholderImage = [UIImage imageNamed:<#(nonnull NSString *)#>];
        
    }
    return _playerModel;
}

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _webView = web;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    ZFPlayerShared.isLockScreen
    [self setupNavigation];
    self.view.backgroundColor = [UIColor lightGrayColor];
//    [self setupPlayerView];
    [self.view addSubview:self.webView];
}

- (instancetype)initWithHtmlString:(NSString *)htmlString
{
    if (self = [super init]) {
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bailitop.com/usa/ranking/20161118/164454.html"]]];
    
    [self.webView loadHTMLString:@"<html><head><link rel=\"stylesheet\" href=\"file:///Users/cyz/Library/Developer/CoreSimulator/Devices/0CC2F3FB-6F3C-42CA-815F-12A3868305BA/data/Containers/Bundle/Application/8F44E089-170B-4ACB-ACCD-50B47DD4CECC/81%20-%20%E7%BD%91%E6%98%93%E6%96%B0%E9%97%BB.app/SXDetails.css\"></head>\"<body><!-- wemedia true --><div id=\"imedia-article\" class=\"imedia-article\"><p style=\"text-align: left\">随着互联网经济的发展，传统的企业也纷纷加入互联网的行业进行转型，但是很多企业在转型的这条路上走的相当曲折，也有很多企业转型失败。其实这些企业表面上是进行转型了，但是实质上并没有真正的进行转型，都死在了转型的道路上。</p><p style=\"text-align: left\"><img id=\"\" src=\"http://i1.go2yd.com/image.php?url=0EpfBtakqr&net=wifi;url=0EpfBtakqr\" alt=\"http://image1.hipu.com/image.php?url=0EpfBtakqr\" width=\"504\" height=\"352\"  style=\"width:290px; height:202px;\" /></p><p style=\"text-align: left\">许多企业在转型的过程中，没有弄清到底怎么样转型，为什么进行转型就开始了所谓的转型。而它的这种转型也没有做到真正的转型，为什么这样说呢？有的企业感觉线下的生意不好做了，就在线上进行做生意，在网上建个网站，做做<a href=\"http://www.yidianzixun.com/m/channel/keyword/网络推广?display=网络推广&amp;word_id=网络^^推广&amp;type=token\">网络推广</a>，这就做到在互联网形式下的与时俱进，认为这就是转型。其实转型不单单是你形式上的转变，利用了互联网就成了互联网行业吗？这种方式只不过是将互联网当做一种途径而已，店铺从实体店搬到网上，把你的广告推广渠道搬到网上而已，实质的东西并没有发生改变。</p><p style=\"text-align: left\"><img id=\"\" src=\"http://image1.hipu.com/image.php?type=thumbnail_580x000&amp;url=0EpfBtvsni\" alt=\"http://image1.hipu.com/image.php?url=0EpfBtvsni\" width=\"590\" height=\"380\"  style=\"width:290px; height:186px;\" /></p><p style=\"text-align: left\">曾经看过一篇文章《传统企业转型互联网的十大死法》其中文中有句话说得特别好。这句话是这样说的：老思想加新模式解决不了新问题。也就是说传统企业想要进行转型，思维方式不去改变，只是利用新的模式是解决不了实质性的问题的。因此，传统企业在进行转型的时候应该先进行思想转型。</p><p style=\"text-align: left\"><img id=\"\" src=\"http://image1.hipu.com/image.php?type=thumbnail_580x000&amp;url=0EpfBtsBTt\" alt=\"http://image1.hipu.com/image.php?url=0EpfBtsBTt\" width=\"571\" height=\"416\"  style=\"width:290px; height:211px;\" /></p><p style=\"text-align: left\">一些传统企业经营不善而进行转型，其问题的根本是经营思路的问题。也就是说在进行转型前先转变经营思想。传统思维的核心是产品，所有的一切都要围绕着产品进行，盈利方式主要是通过产品。而<a href=\"http://www.yidianzixun.com/m/channel/keyword/互联网思维?display=互联网思维&amp;word_id=互联网^^思维&amp;type=token\">互联网思维</a>的核心则是用户，所有的一切都围绕着用户进行的，刚开始考虑的不是产品怎样卖出，而是如何吸引用户的关注。有了用户之后，再根据用户的特点和需求进行产品的制造。盈利的方式也不单单是利用产品本身，有的产品甚至可以免费，通过其他的服务进行挣钱。譬如像<a href=\"http://www.yidianzixun.com/m/channel/keyword/奇虎360?display=奇虎360&amp;word_id=奇虎360&amp;type=token\">奇虎360</a>，刚开始产品本身就是免费的。</p><p style=\"text-align: left\">传统企业的思维模式是如何卖产品，而在互联网的大环境下，需要的不是如何卖产品，而是考虑如何将产品和用户连接起来。有了用户群体之后，然后去维护这些用户群体，建立和用户的信任，在与用户接触的过程中，通过优质的产品、服务以及一些必要的策略，让用户成为我们的忠实粉丝，然后再利用其挣钱。</p><p style=\"text-align: left\">总之，传统企业在进行转型的过程中要保持内外的一致性，也就是说不仅仅简单的形式上的转型，更应该的是让表面形式和内在思维模式都进行转型。</p></div></body>\"</html>" baseURL:nil];
		
		
//		NSString *searchStr = @"LOOK239832LOOK";
//		NSString *regExpStr = @"[0-9A-Z].";
//		NSString *replacement = @"ha";
//		
//		// 创建NSRegularExpression 对象，匹配 正则表达式
//		NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
//		NSString *resultStr = searchStr;
//		
//		// 替换匹配的字符串为 searchStr
//		resultStr = [regExp stringByReplacingMatchesInString:searchStr options:NSMatchingReportProgress range:NSMakeRange(0, searchStr.length) withTemplate:replacement];
//		
//		NSLog(@"searchStr = %@  resultStr = %@",searchStr,resultStr);
		
//		NSNumber *testNumber = @123;
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = 123"];
//		if ([predicate evaluateWithObject:testNumber]) {
//			NSLog(@"相同");
//		}else{
//			NSLog(@"不相同");
//		}
//		
//		NSArray *testArray = @[@1,@2,@3,@4,@5,@6];
//		NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF > 2 && SELF < 5"];
//		NSArray *filterArray = [testArray filteredArrayUsingPredicate:predicate2];
//		NSLog(@"filterArray = %@",filterArray);
		
		NSArray *filerArray = @[@"ab", @"abc"];
		NSArray *array = @[@"a",@"ab", @"abc", @"abcd"];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",filerArray];
		NSLog(@"删除剩余的数组=%@",[array filteredArrayUsingPredicate:predicate]);
		
		
    }
    return self;
}


/**
 初始化播放界面
 */
- (void)setupPlayerView
{
    
}

#pragma mark - <ZFPlayerDelegate>
// 点击左上角返回按钮
- (void)zf_playerBackAction
{
    NSLog(@"%ld",self.navigationController.viewControllers.count);
//    if (self.navigationController.viewControllers.count > 1) {
        NSLog(@"popViewController");
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        NSLog(@"dismissViewControllerAnimated");
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
}

// 开始下载
- (void)zf_playerDownload:(NSString *)url
{
//    ZFDownloadCallBack
    NSLog(@"%s",__func__);
}


/**
 初始化导航栏
 */
- (void)setupNavigation
{
    // 左上角的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton]; 
}

- (void)backBtnClick
{
    if (self.navigationController.viewControllers.count > 1) {
        NSLog(@"popViewController");
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"dismissViewControllerAnimated");
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
