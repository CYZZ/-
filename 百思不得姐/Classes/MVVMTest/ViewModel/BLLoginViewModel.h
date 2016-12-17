//
//  BLLoginViewModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLAccount.h"
#import <ReactiveCocoa.h>

@interface BLLoginViewModel : NSObject
/// 账号密码模型
@property (nonatomic, strong) BLAccount *account;
/// 是否允许登录的信号
@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;
/// 信号管理者
@property (nonatomic, strong,readonly) RACCommand *loginCommand;
@end
