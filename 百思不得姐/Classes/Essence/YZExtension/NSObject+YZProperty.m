//
//  NSObject+YZProperty.m
//  百思不得姐
//
//  Created by cyz on 16/11/3.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "NSObject+YZProperty.h"
#import <objc/runtime.h>

// 定义一个结构体
typedef  struct property_t {
    const char *name;
    const char *attributes;
}*propertyStruct;

@implementation NSObject (YZProperty)

+ (instancetype)YZmodelWithDic:(NSDictionary *)dic
{
    id obj = [[self alloc] init];
    for (NSString *propertyName in [self YZproperties]) {
        if (dic[propertyName]) {
            [obj setValue:dic[propertyName] forKey:propertyName];
        }
    }
    return obj;
}

+ (NSArray *)YZproperties
{
    
    NSMutableArray *propertiesArray = [NSMutableArray array];
    // 1. 获得所有的属性
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    // ...
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
//        NSLog(@"name:%s---attries:%s",((propertyStruct)property)->name,((propertyStruct)property)->attributes);
        const char *cPropertyName = ((propertyStruct)property)->name;
        // 转换成oc字符串
        NSString *ocPropertyName = [[NSString alloc] initWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        // 添加到数组
        [propertiesArray addObject:ocPropertyName];
    }
    // 释放
    free(properties);
    return propertiesArray;
}
@end
