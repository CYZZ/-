//
//  cmt.m
//  百思不得姐
//
//  Created by cyz on 16/11/5.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "cmt.h"
#import <MJExtension.h>
@implementation cmt
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"user":[user class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
