//
//  YDGroupViewModel.m
//  百思不得姐
//
//  Created by cyz on 16/12/28.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDGroupViewModel.h"
#import "channels.h"
#import "BLNetworkTool.h"
#import <MJExtension.h>

@interface YDGroupViewModel ()

@end

@implementation YDGroupViewModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
	return @{@"groupChannel":@"channels"};
}

+ (NSDictionary *)mj_objectClassInArray
{
	return @{@"groupChannel":[channels class]};
}

+ (void)requestYDAllChannelViewModel:(void (^)(YDGroupViewModel *))completion failture:(void (^)(NSError *))failture
{
	NSString *url = @"http://a1.go2yd.com/Website/group/get-channels?appid=yidian&cv=4.3.4.4&distribution=com.apple.appstore&group_id=g181&net=wifi&platform=0&preset_only=0&version=020113";
	NSString *Cookie = [self getCookie];
	BLNetworkTool *manager = [BLNetworkTool sharedToolWithJSON];
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
	
	[manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		YDGroupViewModel *model = [YDGroupViewModel mj_objectWithKeyValues:responseObject];
		completion(model);
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
