//
//  BLAccount.h
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLAccount : NSObject
/// 账号
@property (nonatomic, copy) NSString *account;
/// 密码
@property (nonatomic, copy) NSString *password;

@end
