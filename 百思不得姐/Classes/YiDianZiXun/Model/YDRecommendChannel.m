//
//  YDRecommendChannel.m
//  百思不得姐
//
//  Created by cyz on 16/12/23.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDRecommendChannel.h"
#import <MJExtension.h>
#import "channels.h"
#import "BLNetworkTool.h"
@implementation YDRecommendChannel

+(NSDictionary *)mj_objectClassInArray
{
	return @{@"channels" : [channels class],
			 @"created_channels" : [channels class],
			 };
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//	return @{@"channels":@"created_channels"};
//}

+ (void)requestYDRecommendChannels:(void (^)(YDRecommendChannel *))completion failture:(void (^)(NSError *))failture
{
	NSString *url = @"http://a1.go2yd.com/Website/channel/recommend-channel?appid=yidian&cv=4.3.4.4&distribution=com.apple.appstore&group_id=100476746196&net=wifi&platform=0&position=navigator&version=020113";
	NSString *Cookie = [self getCookie];
	
	BLNetworkTool *manager = [BLNetworkTool sharedToolWithJSON];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
	[manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		YDRecommendChannel *model = [YDRecommendChannel mj_objectWithKeyValues:responseObject];
		completion(model);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		failture(error);
	}];
}

+(void)channgeChannels:(NSArray<channels *> *)preChannels At:(NSInteger)index type:(ChannelChangeType)type groupID:(NSString *)groupID completion:(void (^)(channels *))completion failture:(void (^)(NSError *))failture
{
	NSMutableArray *creted_channels = [NSMutableArray array];
	NSMutableArray *deleted_channels = [NSMutableArray array];
	
	if (type == ChannelChangeTypeAdd) { // 如果是新增频道
		NSMutableDictionary *cretedDic = [NSMutableDictionary dictionary];
		channels *addChannel = [preChannels firstObject];
		cretedDic[@"channel_id"] = addChannel.ID;
		cretedDic[@"insert_at"] = [NSNumber numberWithInteger:index];
		cretedDic[@"name"] = addChannel.name;
		cretedDic[@"group_id"]  = groupID;
		
		[creted_channels addObject:cretedDic]; // 字典添加到数组
	}else{
		[preChannels enumerateObjectsUsingBlock:^(channels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSMutableDictionary *deletedDic = [NSMutableDictionary dictionary];
			deletedDic[@"channel_id"] = obj.channel_id;
			deletedDic[@"insert_at"] = @2;
			deletedDic[@"name"] = obj.name;
			deletedDic[@"group_id"] = groupID;
			
			[deleted_channels addObject:deletedDic];
		}];
	}
	
	NSString *url = @"http://a1.go2yd.com/Website/channel/batch-modify?version=020113&distribution=com.apple.appstore&appid=yidian&cv=4.3.4.4&platform=0&net=wifi";
	NSMutableDictionary *param = [NSMutableDictionary dictionary];
	param[@"created_channels"] = creted_channels;
	param[@"deleted_channels"] = deleted_channels;
	
	BLNetworkTool *manager = [BLNetworkTool sharedToolWithJSON];
	NSString *Cookie = [self getCookie];
	manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 声明请求的参数是json类型
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"]; // 需要先设置请求类型在设置Cookie否则会被覆盖
	[manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		YDRecommendChannel *model = [YDRecommendChannel mj_objectWithKeyValues:responseObject];
		if (model.created_channels.count > 0) {
			completion([model.created_channels firstObject]);
		}else{
			failture(nil);
		}
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		failture(error);
	}];

	
}

/// 获取Cookie
+ (NSString *)getCookie
{
	NSString *Cookie = @"JSESSIONID=a2Kxk5sCtOy6I4nzvipDrw";
	NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:YDToken];
	// 如果用户输入的话就替换
	if (token.length > 1) {
		Cookie = [NSString stringWithFormat:@"JSESSIONID=%@",token];
	}
	
	return Cookie;
}

@end
