//
//  BLCustomerPlayer.m
//  百思不得姐
//
//  Created by cyz on 16/11/14.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLCustomerPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIButton+Extension.h"

@interface BLCustomerPlayer ()
@property(nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;
@end

@implementation BLCustomerPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];   
    // Do any additional setup after loading the view.
//    [self setupCustomPlayer];
    [self setupAVPlayerViewController];
    [self setupNav];
}

/**
 初始化导航栏
 */
- (void)setupNav
{
//    UINavigationItem *item = [[UINavigationItem alloc] init];
//    item.title = @"快进";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"快进" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 12;
    [rightBtn BL_addActionforControLEvents:UIControlEventTouchUpInside respond:^(UIButton *sender) {
        NSLog(@"在block中调用点击事件");
        NSLog(@"sender=%@",sender);
    }];
    
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

/**
 快进
 */
- (void)rightBtnClick
{
    // 获取当前时间
    CGFloat curtime = CMTimeGetSeconds(_player.currentTime);
    // 在此基础上加快5秒
    curtime += 5;
    [_player seekToTime:CMTimeMake(curtime, 1)];
}

/**
 创建播放器
 */
- (void)setupCustomPlayer
{
    // 1. 创建播放的元素
    NSURL *url = [NSURL URLWithString:self.videoURL];
    NSLog(@"url = %@",self.videoURL);
    // 2. 加载url
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    //TODO: KVO监听item状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.item = item;
    // 3.创建播放器
    self.player = [AVPlayer playerWithPlayerItem:item];
//    [AVPlayer alloc]initWithURL:<#(nonnull NSURL *)#>
    
    // 4.创建视频显示的图层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame  = self.view.frame;
    
    [self.view.layer addSublayer:layer];
    
    // 最后一步开始播放
    [_player play];
    
    // 获取当前的时间
//    CGFloat curTime = CMTimeGetSeconds(_player.currentTime);
}


/**
 使用系统的播放控制器
 */
- (void)setupAVPlayerViewController
{
    // 1. 创建播放的元素
    NSURL *url = [NSURL URLWithString:self.videoURL];
    NSLog(@"url = %@",self.videoURL);
    // 2. 加载url
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    //TODO: KVO监听item状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.item = item;
    // 3.创建播放器
    self.player = [AVPlayer playerWithPlayerItem:item];
    
    // 创建一个控制器
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = _player;
    
    playerVC.view.frame = CGRectMake(0, 70, 300, 300);
    [self.view addSubview:playerVC.view];
//    _player.externalPlaybackVideoGravity = AVLayerVideoGravityResizeAspectFill;
    _player.externalPlaybackVideoGravity =AVLayerVideoGravityResizeAspect;
    [_player play]; // 开始播放
    
    
}


#pragma mark - KVO调用方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    switch ([change[@"new"] integerValue]) {
        case 0:
            NSLog(@"未知状态");
            break;
        case 1:
            NSLog(@"获取视频时长 %f",CMTimeGetSeconds(_player.currentItem.duration));
            break;
        case 2:
            NSLog(@"加载失败");
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [_item removeObserver:self forKeyPath:@"status"];
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
