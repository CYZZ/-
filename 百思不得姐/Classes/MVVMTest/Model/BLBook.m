//
//  BLBook.m
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLBook.h"

@implementation BLBook

+ (instancetype)bookWithDict:(NSDictionary *)dic
{
	return [[self alloc] initWithDic:dic];;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
	if (self = [self init]) {
		self.title = dic[@"title"];
		self.subtitle = dic[@"summary"];
		self.alt = dic[@"alt"];
		self.small = dic[@"images"][@"small"];
	}
	return self;
}

@end
