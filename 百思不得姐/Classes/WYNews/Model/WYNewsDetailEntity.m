//
//  WYNewsDetailEntity.m
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "WYNewsDetailEntity.h"
#import <MJExtension.h>

@implementation bodyimg


@end

@implementation WYNewsDetailEntity

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"img":[bodyimg class]
             };
}

@end
