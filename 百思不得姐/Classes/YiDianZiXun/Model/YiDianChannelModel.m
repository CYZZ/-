//
//  YiDianChannelModel.m
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "YiDianChannelModel.h"
#import "user_channels.h"
#import "channels.h"
#import <MJExtension.h>
#import "BLNetworkTool.h"

//@interface YiDianChannelModel ()
//
//@property(class) NSString *name;
//@end

@implementation YiDianChannelModel

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"user_channels":[user_channels class]};
}

+ (void)requestYDChannels:(void (^)(YiDianChannelModel *model))completion failture:(void (^)(NSError *error))failture
{
	NSString *url = @"http://a1.go2yd.com/Website/user/get-info?appid=yidian&cv=4.3.4.4&distribution=com.apple.appstore&net=wifi&platform=0&version=020113";
	NSString *Cookie = [self getCookie];
	
	BLNetworkTool *manager = [BLNetworkTool sharedToolWithJSON];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
	[manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		YiDianChannelModel *model = [YiDianChannelModel mj_objectWithKeyValues:responseObject];
		completion(model);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		failture(error);
	}];
	
}


+ (void)sortChannelbyGroupID:(NSString *)groupID order:(NSArray<channels *> *)channelsArr completion:(void (^)(YiDianChannelModel *model))completion failture:(void (^)(NSError *error))failture
{
	NSString *url = @"http://a1.go2yd.com/Website/group/group-set-order?version=020113&distribution=com.apple.appstore&appid=yidian&cv=4.3.4.4&platform=0&net=wifi";
	NSMutableArray *order = [NSMutableArray array];
	for (channels *channels in channelsArr) {
		// 由于推荐和要闻没有id不需要参与排序
		if (channels.channel_id) {
			[order addObject:channels.channel_id];
		}
//		NSLog(@"channels.channel_id=%@",channels.channel_id);
	}
	
	NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
	paramer[@"group_id"] = groupID;
	paramer[@"order"] = order;
	
	NSString *Cookie = [self getCookie];
	
	BLNetworkTool *manager = [BLNetworkTool sharedToolWithJSON];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
	
	[manager POST:url parameters:paramer progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
//		NSArray *channels = responseObject[@"channels"];
		// 如果成功了就重新请求一次频道数据
		if (![responseObject[@"status"] isEqualToString:@"success"]) {
			return ;
		}
		[self requestYDChannels:^(YiDianChannelModel *model) {
			completion(model);
			NSString *name = model.user_channels[0].channels[0].name;
			NSLog(@"重新请求的频道数=%@",name);
		} failture:^(NSError *error) {
			NSLog(@"请求频道失败");
			failture(error); // 请求频道数据失败
		}];
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"发送频道数据失败");
		failture(error);
	}];
	
}

//+ (void)getChnnelID:(void(^)(NSString *channel_id))getChnanelId
//{
//	
//}

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

//post 请求发送最新平道排序结果 url:
// http://a1.go2yd.com/Website/group/group-set-order?version=020113&distribution=com.apple.appstore&appid=yidian&cv=4.3.4.4&platform=0&net=wifi
// 参数设置:
//{
//	"cv": "4.3.4.4",
//	"group_id": "100161200516",
//	"order": ["4728081492", "5380737876", "7434119636", "6656414852", "6619172756", "5544308900", "5342521732", "5381182004", "7320093060", "5381100260", "5380790708", "5340021940", "4728193956", "5103195508", "4730118820", "4728164084", "4653863284", "4233292132", "4402003412", "4729554788", "4653861252", "7535950852", "4555952388", "4531595300", "4491357252", "4240796644", "4233238260", "7650715316", "4240796676", "4401721012", "4240796660", "4418971684", "4233294180", "4233290644", "4233289204", "4233288100", "4233287636", "4233286340", "4233280452", "4233278212", "4233265540", "4233265524", "4233265508", "4233238036", "4233238068", "4233238084", "4233238116", "4233238132", "4233304532", "4233238148", "4233238164", "4233238180", "7650702868", "4233238196", "4233238228", "4233238244"],
//	"platform": "0",
//	"distribution": "com.apple.appstore",
//	"version": "020113",
//	"appid": "yidian",
//	"net": "wifi"
//}

@end
