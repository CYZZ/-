//
//  T1348649145984.m
//  不得姐模型
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "listModel.h"
#import "WYNewsDetailEntity.h"
#import "BLNetworkTool.h"
#import <MJExtension.h>
#import <UIKit/UIKit.h>

@implementation listModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"wytemplate":@"template"
             };
}

- (WYNewsDetailEntity *)detailModel
{
    if (!_detailModel) {
        _detailModel = [[WYNewsDetailEntity alloc] init];
        __block typeof(_detailModel) entity = _detailModel;
        __weak typeof(self) weakSelf = self;
        NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.docid];
        [BLNetworkTool BL_GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            NSDictionary *dic = [NSDictionary dictionary];
            NSLog(@"字典类型=%@",[dic class]);
//            NSLog(@"加载htmlresponseObject=%@",responseObject);
            
            _detailModel = [WYNewsDetailEntity mj_objectWithKeyValues:responseObject[weakSelf.docid]];
            
            NSLog(@"加载页面数据=%@",entity.body);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"加载web数据失败");
        }];
//        _detailModel = entity;
    }
    return _detailModel;;
    
}



@end
