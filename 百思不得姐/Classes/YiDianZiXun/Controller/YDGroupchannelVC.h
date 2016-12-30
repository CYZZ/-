//
//  YDGroupchannelVC.h
//  百思不得姐
//
//  Created by cyz on 16/12/28.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class channels;
@interface YDGroupchannelVC : UIViewController
/// 已订阅的频道
@property (nonatomic, strong) NSMutableArray *titleArray;

/// 订阅频道回调的block
@property (nonatomic, copy) void(^addChannelsBlock)(NSArray<channels*> *channelsArr);
/// 通过方法回调订阅频道数组
- (void)subscribeChannel:(void(^)(NSArray<channels*> *channelsArr))channelsBlock;
@end
