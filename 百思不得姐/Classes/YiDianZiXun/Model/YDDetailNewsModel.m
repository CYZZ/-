//
//  YDDetailNewsModel.m
//  百思不得姐
//
//  Created by cyz on 16/12/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDDetailNewsModel.h"
#import <YYModel.h>
#import "YDDocumentModel.h"

@interface YDDetailNewsModel ()<YYModel>

@end

@implementation YDDetailNewsModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
	return @{@"documents" : [YDDocumentModel class]};
}
@end
