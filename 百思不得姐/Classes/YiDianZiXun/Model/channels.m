//
//  channels.m
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "channels.h"
#import "subchannels.h"
#import <MJExtension.h>

@implementation channels

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"subchannels":[subchannels class],
			 @"channels":[channels class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
	return @{@"id":@"ID"};
}

@end
