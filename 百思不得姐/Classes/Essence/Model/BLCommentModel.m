//
//  BLCommentModel.m
//  不得姐模型
//
//  Created by cyz on 16/11/05.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "BLCommentModel.h"
#import "BLNetworkTool.h"
#import <MJExtension.h>
@implementation BLCommentModel

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"hot":[cmt class],
             @"data":[cmt class]};
}

+ (void)getCommentModelWith:(NSDictionary *)dic complection:(void (^)(BLCommentModel *))complection failure:(void (^)(NSError *))failure
{
    [BLNetworkTool BL_GET:@"http://api.budejie.com/api/api_open.php" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"请求到的评论数据=%@",responseObject);
        BLCommentModel *model = [BLCommentModel mj_objectWithKeyValues:responseObject];
        complection(model); // 将模型数据装到block当返回值
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)dealloc
{
//    NSLog(@"%s dealloc",__func__);
}

@end
