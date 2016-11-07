//
//  BLJinhuaALLModel.m
//  不得姐模型
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "BLJinhuaALLModel.h"
#import <MJExtension.h>
#import "BLNetworkTool.h"

@implementation info

@end


@implementation list


+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"top_cmt":[cmt class]};
}

@end

@implementation BLJinhuaALLModel

+ (NSDictionary *)mj_objectClassInArray{
    
	return @{@"list":[list class]};
}

// 请求数据
+ (void)getEssenceModelWith:(NSDictionary *)dic complection:(void (^)(BLJinhuaALLModel *))complection failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValuesForKeysWithDictionary:dic];
    param[@"a"] = @"list";
    param[@"c"] = @"data";
    
    [BLNetworkTool BL_GET:@"http://api.budejie.com/api/api_open.php" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"返回的数据是%@",responseObject);
        BLJinhuaALLModel *model = [BLJinhuaALLModel mj_objectWithKeyValues:responseObject];
        complection(model);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取数据失败");
        failure(error);
    }];
    
}
// 在一开始加载的时候就将所有类的ID替换了id
+ (void)load
{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
}

@end
