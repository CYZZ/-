//
//  YidianhaoModel.m
//  百思不得姐
//
//  Created by cyz on 16/12/30.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YidianhaoModel.h"
#import "subchannels.h"
#import <MJExtension.h>
@implementation YidianhaoModel

+ (NSDictionary *)mj_objectClassInArray
{
	return @{@"channels":[subchannels class]};
	
}
@end
