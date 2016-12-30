//
//  subchannels.m
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "subchannels.h"
#import <MJExtension.h>


@implementation subchannels

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
	return @{@"articlelist":@"articlelist[0]"}; // 取数组的第一个元素
}

@end
