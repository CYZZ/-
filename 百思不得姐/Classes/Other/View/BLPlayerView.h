//
//  BLPlayerView.h
//  百思不得姐
//
//  Created by cyz on 16/11/11.
//  Copyright © 2016年 yuze. All rights reserved.
//

//#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayerView.h>

@interface BLPlayerView : ZFPlayerView


/**
 指定在哪个视图上播放视频
 
 @param model 播放的模型
 @param view  底层视图

 @return 创建完成之后的播放视图
 */
+ (instancetype)playWithModel:(ZFPlayerModel *)model showIn:(UIView *)view;
@end
