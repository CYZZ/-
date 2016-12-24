//
//  YiDianNewsModel.m
//  一点资讯模型
//
//  Created by cyz on 16/12/13.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "YiDianNewsModel.h"
#import "YDresult.h"
#import <MJExtension.h>
#import "BLNetworkTool.h"

@implementation YiDianNewsModel

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"result":[YDresult class]};
}

+ (void)requestYDNewsWith:(NSInteger)cstart position:(NSInteger)position channelID:(NSString *)channelID forNews:(void (^)(YiDianNewsModel *model))completion failture:(void (^)(NSError *error))failture
{
	BLNetworkTool *manager = [BLNetworkTool sharedToolWithJSON];
	
	NSString *Cookie = @"JSESSIONID=a2Kxk5sCtOy6I4nzvipDrw";
	NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:YDToken];
	// 如果用户输入的话就替换
	if (token.length > 1) {
		Cookie = [NSString stringWithFormat:@"JSESSIONID=%@",token];
	}
	
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
	
//	NSString *type = nil;
	// 推荐
	NSString *url =[NSString stringWithFormat: @"http://a1.go2yd.com/Website/channel/news-list-for-best-channel?fields=title&fields=url&fields=source&fields=date&fields=image&fields=image_urls&fields=comment_count&fields=like&fields=up&fields=down&cstart=%ld&cend=%ld&collection_num=0&refresh=1&infinite=true&appid=yidian&version=020113&distribution=com.apple.appstore&appid=yidian&cv=4.3.3.11&platform=0&net=wifi",cstart,(cstart + 30)];
	
	if (position == 1) {
		// 要闻
		url =[NSString stringWithFormat:@"http://a1.go2yd.com/Website/channel/news-list-for-hot-channel?cend=%ld&channel_position=1&cstart=%ld&fields%%5B%%5D=title&fields%%5B%%5D=url&fields%%5B%%5D=source&fields%%5B%%5D=date&fields%%5B%%5D=image&fields%%5B%%5D=image_urls&fields%%5B%%5D=comment_count&fields%%5B%%5D=like&fields%%5B%%5D=up&fields%%5B%%5D=down&group_fromid=g181&infinite=true&refresh=1&version=020113&distribution=com.apple.appstore&appid=yidian&cv=4.3.4.4&platform=0&net=wifi",(cstart + 30),cstart];
	}else if (position > 1){
		// 其他频道
		url =[NSString stringWithFormat:@"http://a1.go2yd.com/Website/channel/news-list-for-channel?cend=%ld&channel_id=%@&channel_position=%ld&cstart=%ld&fields%%5B%%5D=title&fields%%5B%%5D=url&fields%%5B%%5D=source&fields%%5B%%5D=date&fields%%5B%%5D=image&fields%%5B%%5D=image_urls&fields%%5B%%5D=comment_count&fields%%5B%%5D=like&fields%%5B%%5D=up&fields%%5B%%5D=down&group_fromid=g181&infinite=true&refresh=1&version=020113&distribution=com.apple.appstore&appid=yidian&cv=4.3.4.4&platform=0&net=wifi",(cstart + 30),channelID,position,cstart];
	}
	
	
	[manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		YiDianNewsModel *model = [YiDianNewsModel mj_objectWithKeyValues:responseObject];
		completion(model);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求一点资讯失败=%@",error);
		failture(error);
	}];
}

@end
