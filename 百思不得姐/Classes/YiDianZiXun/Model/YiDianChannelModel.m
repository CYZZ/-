//
//  YiDianChannelModel.m
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "YiDianChannelModel.h"
#import "user_channels.h"
#import <MJExtension.h>
#import "BLNetworkTool.h"
@implementation YiDianChannelModel

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"user_channels":[user_channels class]};
}

+ (void)requestYDChannels:(void (^)(YiDianChannelModel *model))completion failture:(void (^)(NSError *error))failture
{
	NSString *url = @"http://a1.go2yd.com/Website/user/get-info?appid=yidian&cv=4.3.4.4&distribution=com.apple.appstore&net=wifi&platform=0&version=020113";
	
	NSString *Cookie = @"JSESSIONID=IGkQZAu3-tAUEYyryNeZNA";
	NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:YDToken];
	// 如果用户输入的话就替换
	if (token.length > 1) {
		Cookie = [NSString stringWithFormat:@"JSESSIONID=%@",token];
	}
	
	BLNetworkTool *manager = [BLNetworkTool sharedTool];
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
	
	[manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		// 默认返回的数据是Data需要进行序列化
		responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
		YiDianChannelModel *model = [YiDianChannelModel mj_objectWithKeyValues:responseObject];
		completion(model);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		failture(error);
	}];
}

@end
