//
//  YDCell.h
//  百思不得姐
//
//  Created by cyz on 16/12/14.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDresult;

/// cell类型
typedef NS_ENUM(NSUInteger, YDCellType) {
	YDCellTypeNoImage, // 无图模式
	YDCellTypeOneImage, // 单张图
	YDCellTypeThreeImage, // 三张图
	YDCellTypeVideo, // 视频
};

@interface YDCell : UITableViewCell
@property (nonatomic, strong) YDresult *model;
@property (nonatomic, weak) UIImageView *playerImageView;

/// 播放视频调用的block
@property (nonatomic, copy) void(^playVideoBlock)();

- (void)playVideoWithBlock:(void(^)())block;

/// 注册cell
+ (void)registerCellWithTypes:(NSArray<NSString *>*)types onTableView:(UITableView *)tableView;
@end
