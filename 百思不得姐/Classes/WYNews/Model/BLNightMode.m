//
//  BLNightMode.m
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLNightMode.h"

@implementation BLNightMode

/// 单例创建实例对象
+ (instancetype)sharedTool
{
    static BLNightMode *instance;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
