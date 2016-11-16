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

@end

@implementation BLSentMessageVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    ZFPlayerShared.isLockScreen
    [self setupNavigation];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupPlayerView];
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
//    NSLog(@"backButton.frame = %@",NSStringFromCGRect(backButton.frame));
//    [backButton setBackgroundColor:[UIColor greenColor]];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton]; 
//     [self.navigationItem.leftBarButtonItem setCustomView:backButton];
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
