//
//  user_channels.m
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import "user_channels.h"
#import "channels.h"
#import <MJExtension.h>
@implementation user_channels

+ (NSDictionary *)mj_objectClassInArray{
	return @{@"channels":[channels class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
	return @{ @"override" : @"override_"};
}

@end
