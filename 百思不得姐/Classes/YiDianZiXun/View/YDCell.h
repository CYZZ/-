//
//  YDCell.h
//  百思不得姐
//
//  Created by cyz on 16/12/14.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDresult;

@interface YDCell : UITableViewCell
@property (nonatomic, strong) YDresult *model;

/// 播放视频调用的block
@property (nonatomic, copy) void(^playVideoBlock)();

- (void)playVideoWithBlock:(void(^)())block;
@end
