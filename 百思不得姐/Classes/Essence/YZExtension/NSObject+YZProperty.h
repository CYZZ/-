//
//  NSObject+YZProperty.h
//  百思不得姐
//
//  Created by cyz on 16/11/3.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YZProperty)

+ (instancetype)YZmodelWithDic:(NSDictionary *)dic;
/**
 runtime获取所有属性

 @return 属性列表
 */
+ (NSArray *)YZproperties;
/// 根据字典自动转换成模型类型
+ (void)resolveDict:(NSDictionary *)dict;
@end
