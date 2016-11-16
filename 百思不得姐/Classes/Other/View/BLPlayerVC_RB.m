//
//  BLPlayerVC_RB.m
//  百思不得姐
//
//  Created by cyz on 16/11/12.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLPlayerVC_RB.h"
#import <RBVideoPlayer.h>
#import <Masonry.h>

@interface BLPlayerVC_RB () <RBPlayerViewDelegate>

@property(nonatomic, strong)RBVideoPlayer *player;

@end

@implementation BLPlayerVC_RB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRBPlayer];
}

- (void)setupRBPlayer
{
    // 忽略导航栏
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    NSString *url = @"http://v.jxvdy.com/sendfile/HbTMxpilOKa7NyPRqdN3FDvIrYgTLhBMB5Hj_-dHcy5IPDOZXFD1HW2WgQUYTpDcBSnUL2xD5rDf2BujUbiMg6_rJl50vg";
    NSString *url = self.videoURL;
    
    self.player = [[RBVideoPlayer alloc] init];
    //self.player.view.ignoreScreenSystemLock = YES;
    [self.view addSubview:self.player.view];
    
//    self.player.view.delegate = self;
//    self.player.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_topLayoutGuideBottom);;
//        make.leading.bottom.trailing.insets(UIEdgeInsetsZero);
        make.leading.bottom.trailing.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[playerView]-10-|" options:0 metrics:nil views:@{@"playerView":self.player.view}]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[playerView(200)]" options:0 metrics:nil views:@{@"playerView":self.player.view}]];
    
    // 设置标题
    RBPlayerItem *item = [[RBPlayerItem alloc] init];
    item.title = @"这都是什么电影";
    item.assetTitle = @"清晰";
    
    RBPlayerItemAsset *itemAsset1 = [[RBPlayerItemAsset alloc] initWithType:@"清晰" URL:[NSURL URLWithString:url]];
    RBPlayerItemAsset *itemAsset2 = [[RBPlayerItemAsset alloc] initWithType: @"高清" URL:[NSURL URLWithString:url]];
    
    item.assets = @[itemAsset1, itemAsset2];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player playWithItemAsset:itemAsset1]; // 默认播放的清晰度
    
    
    // 设置左边按钮
    if ([_player.topMask isKindOfClass:[RBPlayerTopMask class]]) {
        RBPlayerTopMask *topMask = (RBPlayerTopMask *)_player.topMask;
        
        __weak typeof(self) weakSelf = self;
        RBPlayerControlBackButton *backButton = [[RBPlayerControlBackButton alloc] initWithMask:topMask mainBlock:^{
            weakSelf.player.view.supportedOrientations = UIInterfaceOrientationMaskAll;
            [weakSelf.player.view performOrientationChange:UIInterfaceOrientationUnknown animated:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
        topMask.leftButtons = @[ backButton ];
    }


}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


#pragma mark - RBPlayerViewDelegate

- (BOOL)playerView:(RBPlayerView *)playerView willOrientationChange:(UIInterfaceOrientation)orientation {
    
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation != UIInterfaceOrientationUnknown) {
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        if (UIInterfaceOrientationIsLandscape(statusBarOrientation) && [playerView containsMask:self.player.topMask]) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        } else {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        });
    }
    return YES;
}

- (BOOL)playerView:(RBPlayerView *)playerView willAddMask:(RBPlayerViewMask *)mask animated:(BOOL)animated {
    if ([mask isEqual:self.player.topMask]) {        
        UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
        }
    }
    return YES;
}

- (BOOL)playerView:(RBPlayerView *)playerView willRemoveMask:(RBPlayerViewMask *)mask animated:(BOOL)animated {
    if ([mask isEqual:self.player.topMask] && playerView.isFullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    }
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
