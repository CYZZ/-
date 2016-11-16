//
//  BLPlayerView.m
//  百思不得姐
//
//  Created by cyz on 16/11/11.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLPlayerView.h"

@implementation BLPlayerView

#pragma mark - 重写这个方法
+ (instancetype)sharedPlayerView
{
    static BLPlayerView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BLPlayerView alloc] init];
    });
    return instance;
}

+ (instancetype)playWithModel:(ZFPlayerModel *)model showIn:(UIView *)view
{
    BLPlayerView *playerView = [[self alloc] init];
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    playerView.controlView = controlView;
    playerView.playerModel = model;
    [view addSubview:playerView];
    playerView.frame = view.frame;
    
    return playerView;
}

@end
