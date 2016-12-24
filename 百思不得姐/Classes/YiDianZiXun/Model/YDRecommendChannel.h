//
//  YDRecommendChannel.h
//  百思不得姐
//
//  Created by cyz on 16/12/23.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
@class channels;

/// 频道改变类型
typedef NS_ENUM(NSUInteger, ChannelChangeType) {
	ChannelChangeTypeAdd, // 添加
	ChannelChangeTypeDeleted, // 删除
};

@interface YDRecommendChannel : NSObject
/// 状态码
@property (nonatomic, assign) NSInteger code;
/// 成功失败信息
@property (nonatomic, copy) NSString *status;
/// 频道数组
@property (nonatomic, strong) NSArray<channels *> *channels;
/// 发送频道的时候返回的频道数组
@property (nonatomic, strong) NSArray<channels *> *created_channels;

/// 请求一点资讯的更多频道
+ (void)requestYDRecommendChannels:(void (^)(YDRecommendChannel *model))completion failture:(void (^)(NSError *error))failture;

///  在指定索引修改频道
+ (void)channgeChannels:(NSArray<channels *>*)preChannels At:(NSInteger)index type:(ChannelChangeType)type groupID:(NSString *)groupID completion:(void (^)(channels *creted_channels))completion failture:(void (^)(NSError *error))failture;

@end
