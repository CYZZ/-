//
//  BLLoginViewModel.m
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLLoginViewModel.h"


@implementation BLLoginViewModel
#pragma mark - lazy懒加载
- (BLAccount *)account
{
	if (_account == nil) {
		_account = [[BLAccount alloc] init];
	}
	return _account;
}

- (instancetype)init
{
	if (self =[super init]) {
		[self initialBind];
	}
	
	return self;
}

/// 初始化绑定
- (void)initialBind
{
	// 监听账号属性值的改变，把他们聚合成一个信号
	_enableLoginSignal = [[RACSignal combineLatest:@[RACObserve(self.account, account),RACObserve(self.account, password)] reduce:^id(NSString *account, NSString *pwd){
		return @(account.length &&pwd.length);
	}] throttle:0.3]; // 延迟0.3秒，防止快速输入文字的时候连续发信信号
	
	// 处理登录业务逻辑
	_loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		NSLog(@"点击了登录");
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			// 模仿网络延迟
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				
				[subscriber sendNext:@"登录成功"];
				// 数据传送完成，必须吊阴功完成信号，否则命令永远处于执行状态
				[subscriber sendCompleted];
			});
			return nil;
		}];
	}];
	
	// 监听所产生的数据
	[_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
		if ([x isEqualToString:@"登录成功"]) {
			NSLog(@"登录成功");
		}
	}];
	
	// 监听登录状态
	[[_loginCommand.executing skip:1] subscribeNext:^(id x) {
		if ([x isEqualToNumber:@(YES)]) {
			
			// 正在登录
			// 用弹框提示
//			[MBProgressHUD showMessage@"正在登录..."];
		}else{
			// 登录成功
			// 隐藏蒙版
//			[MBProgressHud hideHUD];
		}
	}];
}

@end
