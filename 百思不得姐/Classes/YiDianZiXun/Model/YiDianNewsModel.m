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

+ (void)requestYDNewsWith:(NSInteger)cstart forNews:(void (^)(YiDianNewsModel *model))completion failture:(void (^)(NSError *))failture
{
	BLNetworkTool *manager = [BLNetworkTool sharedTool];
	
	[manager.requestSerializer setValue:@"JSESSIONID=dT8Gkj0PmUmUR7hqLmlwPg" forHTTPHeaderField:@"Cookie"];
	NSString *url =[NSString stringWithFormat: @"http://a1.go2yd.com/Website/channel/news-list-for-best-channel?fields=title&fields=url&fields=source&fields=date&fields=image&fields=image_urls&fields=comment_count&fields=like&fields=up&fields=down&cstart=%ld&cend=%ld&collection_num=0&refresh=1&infinite=true&appid=yidian&version=020113&distribution=com.apple.appstore&appid=yidian&cv=4.3.3.11&platform=0&net=wifi",cstart,(cstart + 30)];
	
	[manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		// 默认返回的数据是Data需要进行序列化
		responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
		YiDianNewsModel *model = [YiDianNewsModel mj_objectWithKeyValues:responseObject];
		completion(model);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求一点资讯失败=%@",error);
		failture(error);
	}];
}

@end
