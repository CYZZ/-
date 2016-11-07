//
//  BLNetworkTool.h
//  百思不得姐
//
//  Created by cyz on 16/10/27.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN
@interface BLNetworkTool : AFHTTPSessionManager

/**
 创建一个有初始URL的单例对象
 */
+ (instancetype)ToolWithNewsBaseUrl;


/**
 创建一个单例对象
 */
+ (instancetype)sharedTool;


/**
 Get请求

 @param URLString        url链接
 @param parameters       参数列表
 @param downloadProgress 加载进度
 @param success          请求成功
 @param failure          请求失败

 @return task对象
 */
+ (nullable NSURLSessionDataTask *)BL_GET:(NSString *)URLString
                               parameters:(nullable id)parameters
                                 progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


/**
 发送POST请求

 @param URLString      url链接
 @param parameters     参数列表
 @param uploadProgress 下载进度
 @param success        请求成功
 @param failure        请求失败

 @return task对象
 */
+ (nullable NSURLSessionDataTask *)BL_POST:(NSString *)URLString
                                parameters:(nullable id)parameters
                                  progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end
NS_ASSUME_NONNULL_END
