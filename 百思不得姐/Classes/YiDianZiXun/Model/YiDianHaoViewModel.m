//
//  YiDianHaoViewModel.m
//  百思不得姐
//
//  Created by cyz on 16/12/30.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YiDianHaoViewModel.h"
#import "subchannels.h"
#import "YidianhaoModel.h"
#import "BLNetworkTool.h"
#import <MJExtension.h>

@implementation YiDianHaoViewModel

+(void)requesYDHWithgroupID:(NSString *)groupID completion:(void (^)(NSArray<subchannels*> *))completion failture:(void (^)(NSError *))failture
{
	NSString *url =[NSString stringWithFormat: @"http://a1.go2yd.com/Website/group/get-user-channels?appid=yidian&cv=4.3.4.4&distribution=com.apple.appstore&group_id=%@&net=wifi&platform=0&type=media&version=020113", groupID];
	BLNetworkTool *manger = [BLNetworkTool sharedToolWithJSON];
	[manger.requestSerializer setValue:[self getCookie] forHTTPHeaderField:@"Cookie"];
	
	[manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		YidianhaoModel *model = [YidianhaoModel mj_objectWithKeyValues:responseObject];
		NSLog(@"article=%@",model.channels[0].articlelist);
		completion(model.channels);
		
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
