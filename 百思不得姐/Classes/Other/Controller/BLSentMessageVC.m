//
//  BLSentMessageVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/8.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLSentMessageVC.h"
#import "BLPlayerView.h"
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
    
    [self.webView loadHTMLString:@"<html><head><link rel=\"stylesheet\" href=\"file:///Users/cyz/Library/Developer/CoreSimulator/Devices/0CC2F3FB-6F3C-42CA-815F-12A3868305BA/data/Containers/Bundle/Application/8F44E089-170B-4ACB-ACCD-50B47DD4CECC/81%20-%20%E7%BD%91%E6%98%93%E6%96%B0%E9%97%BB.app/SXDetails.css\"></head><body style=\"background:#f6f6f6\"><div class=\"title\">火箭擒开拓者避连败 哈登3节三双贝弗利复出11分</div><div class=\"time\">2016-11-18 11:15:21</div><p>　　网易体育11月18日报道：</p><p>　　休斯敦火箭队（7胜5负）在主场迅速反弹。哈登得到三双26分、14次助攻和12个篮板，贝弗利复出贡献11分，利拉德17投7中只有18分，火箭队利用三四节攻势把领先优势拉开到20分以上，他们在主场以126-109大胜波特兰开拓者队（7胜6负）。开拓者队遭遇2连败。</p><div class=\"img-parent\"><img onload=\"this.onclick = function() {  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;};\" width=\"300\" height=\"200\" src=\"http://img4.cache.netease.com/photo/0005/2016-11-18/C656VFMS4TM10005.jpg\"></div><p>　　火箭队的哈登得到三双26分、14次助攻、12个篮板和3次抢断，阿里扎得到16分和7个篮板，戈登得到16分、5个篮板和3次助攻，卡佩拉得到15分、7个篮板和2次盖帽，安德森得到13分和5个篮板，贝弗利得到11分、3次助攻和3次盖帽。开拓者队的麦科勒姆得到26分和4次助攻，哈克莱斯得到19分和6个篮板，利拉德17投7中，得到18分、5个篮板和5次助攻，特纳得到12分、4个篮板和3次助攻。</p><p>　　火箭队的贝弗利复出首发。开拓者队开赛后反客为主，他们先得6分领跑。阿里扎和哈登分别投中三分，火箭队连拿10分反超。之后的比赛两队展开对攻战，场上比分交替增加，戈登和哈雷尔各得两分，首节还有3分55秒时火箭队以27-20领先。利拉德罚中两球，戈登连中2个三分球，哈登也罚中三球，他们带领球队以14-7的小高潮结束首节，火箭队以41-29领先12分。</p><p>　　徳克尔跳投命中开启第二节，莱曼和冯莱分别投中三分，他们带领球队打出13-3的反击波，开拓者队在这一节进行了3分5秒时追至42-46。戈登罚中两球，哈登突破得分，这为球队稳住局势。利拉德率队迅速追回4分，安德森保持手感连取5分，半场前2分20秒时火箭队以60-53领先。半场前最后1分15秒内火箭队哑火，哈克莱斯命中三分率队以7-0的反击波结束第二节，两队在半场时以62平握手言和。</p><p>　　火箭队的哈登上半场得到18分、9次助攻和7个篮板，安德森得到11分和4个篮板，戈登得到10分；开拓者队的麦科勒姆得到19分和3次助攻，利拉德得到11分，哈克莱斯得到10分和4个篮板。</p><p>　　火箭队连得5分开始第三节，他们再次领跑。开拓者队暂停后哈克莱斯回敬三分，麦科勒姆打3分成功，他们以68-69落后。阿里扎开火连进2个三分球，卡佩拉也上篮得手，火箭队连得8分再次拉开比分。利拉德两次单打成功，戈登连进两球回应，阿里扎保持手感再中三分，第三节还有3分55秒火箭队以92-78领先。特纳上篮得手，哈登保持攻击性连取4分，双方差距被拉大到18分。克拉布还击三分，哈雷尔一记暴扣，三节结束时火箭队以100-83领先17分。</p><p>　　卡佩拉在第四节开始后独得5分帮助球队扩大优势，麦科勒姆跳投命中，安德森和布鲁尔联手4分，火箭队以111-87领先。利拉德打3分成功，他率队连续得分，可他们防不住火箭队的进攻，贝弗利突破得分，第四节还有5分35秒时火箭队以117-94领先23分。大比分差距让比赛提前进入垃圾时间，开拓者队换下主力缴械，哈登上来拿了一个篮板后又被换下，火箭队最终以126-109大胜。</p><p>　　开拓者队首发阵容：利拉德、麦科勒姆、克拉布、哈克莱斯、普拉姆利</p><p>　　火箭队首发阵容：贝弗利、哈登、阿里扎、安德森、卡佩拉</p><p>　　作者：小柳</p></body></html>" baseURL:nil];

    }
    NSLog(@"htmlString=%@",htmlString);
    return self;
}


/**
 初始化播放界面
 */
- (void)setupPlayerView
{
//    ZFPlayerView *playerView = [[ZFPlayerView alloc] init];
//    self.playerView = playerView;
//    [self.view addSubview:playerView];
//    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.mas_topLayoutGuideBottom);
//        make.leading.bottom.trailing.insets(UIEdgeInsetsZero);
//    }];
//    
//    // 可指定控制器层(自定义)
//    ZFPlayerControlView *controllView = [[ZFPlayerControlView alloc] init];
//    playerView.controlView = controllView;
//    // 设置模型要在后面设置控制层之后（warming否则会有约束警告⚠️）
//    self.playerView.playerModel = self.playerModel;
    
    
    UIView *temView = [[UIView alloc] init];
    temView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:temView];
//        **********************
    BLPlayerView *playerView = [BLPlayerView playWithModel:self.playerModel showIn:temView];
//    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.leading.bottom.trailing.insets(UIEdgeInsetsZero).priorityHigh();
//        make.top.offset(64).priorityHigh();
//    }];
    playerView.playerModel = self.playerModel;

    // 设置代理
    playerView.delegate = self;
    // 可选设置视频填充模式内部默认模式（ZFPlayerLayerGravityResizeAspect)
//    playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    /// 打开下载功能
    playerView.hasDownload = YES; 
    // 打开预览图
    playerView.hasPreviewView =  YES;
    // 是否自动播放，默认没有
    [playerView autoPlayTheVideo];
    
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
