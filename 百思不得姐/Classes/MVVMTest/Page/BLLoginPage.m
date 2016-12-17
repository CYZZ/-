//
//  BLLoginPage.m
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLLoginPage.h"
#import "BLLoginViewModel.h"

@interface BLLoginPage ()
@property (weak, nonatomic) IBOutlet UITextField *accountiField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/// 控制器的ViewModel
@property (nonatomic, strong) BLLoginViewModel *loginViewModel;

@end

@implementation BLLoginPage
#pragma mark - 懒加载
- (BLLoginViewModel *)loginViewModel
{
	if (_loginViewModel == nil) {
		_loginViewModel = [[BLLoginViewModel alloc] init];
	}
	return _loginViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self bindModel];
}

/// 视图模型绑定
- (void)bindModel
{
	// 给模型的属性绑定信号
	// 只要账号文本框一改变，就会给account赋值
	RAC(self.loginViewModel.account, account) = _accountiField.rac_textSignal;
	RAC(self.loginViewModel.account, password) = _pwdField.rac_textSignal;
	[[_accountiField rac_textSignal] subscribeNext:^(id x) {
		NSLog(@"正在输入账号信息=%@",x);
	}];
	
	// 绑定登录按钮
	RAC(self.loginButton, enabled) = self.loginViewModel.enableLoginSignal;
	
	// 监听登录按钮的点击
	[[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		
//		NSLog(@"点击了登录按钮");
		// 执行登录事件
		[self.loginViewModel.loginCommand execute:nil];
		
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
	[super awakeFromNib];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
