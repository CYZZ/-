//
//  BLNetworkTool.m
//  百思不得姐
//
//  Created by cyz on 16/10/27.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLNetworkTool.h"

@implementation BLNetworkTool

/// 使用单例创建一个有初始URL的实例对象
+ (instancetype)ToolWithNewsBaseUrl
{
    static BLNetworkTool *instance;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://www.bailitop.com"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        instance = [[self alloc] initWithBaseURL:url sessionConfiguration:config];
        
        // 加入 text/html 解析
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return instance;
}

/// 单例创建实例对象
+ (instancetype)sharedTool
{
    static BLNetworkTool *instance;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@""];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        instance = [[self alloc] initWithBaseURL:url sessionConfiguration:config];
        
        // 返回原始的data数据需要在success中对responseObject进行转成字典或数组对象
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 加入 text/html 解析
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return instance;
}

/// 单例创建实例对象
+ (instancetype)sharedToolWithJSON
{
	static BLNetworkTool *instance;
	static dispatch_once_t onceToken;
	_dispatch_once(&onceToken, ^{
		NSURL *url = [NSURL URLWithString:@""];
		NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
		instance = [[self alloc] initWithBaseURL:url sessionConfiguration:config];
		
		// 返回的数据类型是JSON
		instance.responseSerializer = [AFJSONResponseSerializer serializer];
		// 请求发送的参数类型是Json
		instance.requestSerializer = [AFJSONRequestSerializer serializer];
		[instance.requestSerializer setTimeoutInterval:10.0]; // 设置超时限制
		// 加入 text/html 解析
		instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
	});
	return instance;
}

+ (NSURLSessionDataTask *)BL_GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return  [[self sharedTool] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull Progress) {
        if (downloadProgress) {
            downloadProgress(Progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            NSString *responstr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"转成的json字符串=%@",responstr);
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}
+(NSURLSessionDataTask *)BL_POST:(NSString *)URLString
                      parameters:(nullable id)parameters
                        progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                         success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                         failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
{
    
    return [[self sharedTool] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull upProgress) {
        if (uploadProgress) {
            uploadProgress(upProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}


@end
