//
//  BLBook.h
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLBook : NSObject
/// 描述
@property (nonatomic, copy) NSString *subtitle;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 链接
@property (nonatomic, copy) NSString *alt;
/// 小图链接
@property (nonatomic, copy) NSString *small;

+ (instancetype)bookWithDict:(NSDictionary *)dic;

@end
