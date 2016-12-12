//
//  WYNewsModel.m
//  不得姐模型
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "WYNewsModel.h"
#import "listModel.h"
#import "BLNetworkTool.h"
#import <MJExtension.h>

@implementation WYNewsModel

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"list":[listModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"list":@"T1348649580692"
             };
}

+ (void)request:(NSString *)url ForWYNews:(void(^)(WYNewsModel *model))commplet failture:(void(^)(NSError *error))failture 
{
    [BLNetworkTool BL_GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         WYNewsModel *model = [WYNewsModel mj_objectWithKeyValues:responseObject];
        
        commplet(model);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failture(error);
    }];
}

@end
