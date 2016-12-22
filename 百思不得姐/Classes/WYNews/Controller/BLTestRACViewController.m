//
//  BLTestRACViewController.m
//  百思不得姐
//
//  Created by cyz on 16/12/12.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLTestRACViewController.h"
#import "WYDetailNewsVC.h"
#import "BLLoginPage.h" // 登录页面

#import "BLDoubanSearchPage.h"// 豆瓣搜索书籍

#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <RACReturnSignal.h>
#import <Masonry.h>

@interface BLTestRACViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/// 需要强引用，不被销毁否则接收不到数据
@property (nonatomic, strong) RACCommand *strongCommand;
/// 输入框
@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, strong) RACSubject *signal;

@end

@implementation BLTestRACViewController
#pragma mark - 懒加载
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
	}
	return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.view addSubview:self.tableView];
	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.insets(UIEdgeInsetsZero);
	}];
	[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
	
	UITextField *textField = [[UITextField alloc] init];
	textField.frame = CGRectMake(0, 0, 200, 40);
	textField.borderStyle = UITextBorderStyleRoundedRect;
	_textField = textField;
	self.navigationItem.titleView = _textField;
	
	[self setupNav];
}

/// 初始化导航栏
- (void)setupNav
{
	UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginBtnClick)];
	self.navigationItem.rightBarButtonItem = loginItem;
}

- (void)loginBtnClick
{
//	[self.navigationController pushViewController:[[BLLoginPage alloc] init] animated:YES];
	[self.navigationController pushViewController:[[BLDoubanSearchPage alloc] init] animated:YES];
}

- (void)testRAC:(NSInteger)index
{
	
	switch (index) {
		case 0:{
			
			// RACSignal 使用步骤
			// 1. 创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
			// 2. 订阅信号，才会激发信号。 -
			
			// 1. 创建信号
			RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				// block调用时刻：每当有订阅者订阅信号，就会调用block。
				// 2. 发送信号
				[subscriber sendNext:@1];
				
				// 如果不再发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号
				[subscriber sendCompleted];
				
				return [RACDisposable disposableWithBlock:^{
					// block 调用时刻：当信号发送完成或者发送错误，就会自动执行这个block，取消订阅信号
					// 执行完block后，当前信号就不再被订阅了
					NSLog(@"信号被销毁了");
				}];
			}];
			
			// 3. 订阅信号才会激活信号
			[signal subscribeNext:^(id x) {
				// block 调用时刻：每当有信号发出数据，就会调用block
				NSLog(@"接收到数据：%@",x);
			}];
			/*
			//6.2 RACSubscriber:表示订阅者的意思，用于发送信号这是一个协议，不是一个了类，只要遵守这个协议，并且实现方法才能成为订阅者，通过create创建的信号，都有一个订阅者帮助他发送数据。
			// 6.3 RACDisposable:用于取消订阅或者清理资源，当信号发送完成你活着发送错误的时候，就会自动触发它。
			// *使用场景：不想监听某个信号是，可以通过它主动取消订阅信号
			// RACSubject：信号提供者，自己可以充当信号，又能发送信号。
			// *使用场景：通常用来代替代理，有了它，就不必要定义代理了。
			// RACReplaySubject 可以先发送信号，再订阅信号，RACSubject就不可以
			 使用场景一：如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类
			 使用场景二：可以设置Capacity数量来限制缓存的value的数量，即只能缓冲最新的几个值
			 
			 */


			break;
		}
		case 1:{
			/*
			 RACSubject和RACReplaySubject简单使用
			 1. 创建信号[RACSubject subject]，
			 */
			// 1.创建信号
			RACSubject *subject = [RACSubject subject];
			// 2. 订阅信号
			[subject subscribeNext:^(id x) {
				// block调用时刻：当信号发出新值的时候就会调用
				NSLog(@"第一个订阅者%@",x);
			}];
			[subject subscribeNext:^(id x) {
				NSLog(@"第二个订阅者%@",x);
			}];
			// 3. 发送信号
			[subject sendNext:@2];
			break;
		}
		case 2:{
			// RACReplaySubject使用步骤
			//1. 创建信号
			RACReplaySubject *replaySubject = [RACReplaySubject subject];
			// 对一个订阅者发送多个信号(可以有多个订阅者就是多对多发送信号）
			// 2. 发送信号
			[replaySubject sendNext:@1];
			[replaySubject sendNext:@2];
			
			// 3. 订阅信号
			[replaySubject subscribeNext:^(id x) {
				NSLog(@"第一个订阅者接收信号=%@",x);
			}];
			[replaySubject subscribeNext:^(id x) {
				NSLog(@"第二订阅者接收信号=%@",x);
			}];
			
			break;
		}
		case 3:{
			// 跳转到下一个控制器，监听下一个控制器的按钮点击tabBarItem
			// 步骤1 在下一个控制器添加一个RACSubject代理属性
			// 步骤2 在下一个控制器添加监听事件
			
			// 步骤3 在第一个控制器对dialing信号赋值
			WYDetailNewsVC *detailVC = [[WYDetailNewsVC alloc] init];
			// 设置代理
			detailVC.delegateSinal = [RACSubject subject];
			// 订阅信号
			[detailVC.delegateSinal subscribeNext:^(id x) {
				NSLog(@"点击了右边按钮=%@",x);
			}];
			[self.navigationController pushViewController:detailVC animated:YES];
			
			break;
		}
		case 4:{
			// RAC的元组
			// 1. 遍历数组
			NSArray *number = @[@1,@2,@3,@4];
			/*
			 这里其实有三步
			 第一步：把数组转成集合 RACSeguqence number.rac_sequence
			 第二步：把集合RACSequence转换RACSignal信号类，numbers.rac_sequence.signal
			 第三步：订阅信号，激活信号，会自动把集合中的所有值遍历出来。
			 */
			[number.rac_sequence.signal subscribeNext:^(id x) {
				NSLog(@"遍历数组%@",x);
			}];
			
			// 2. 遍历字典会包装成元组对象
			NSDictionary *dic = @{@"name":@"cyz", @"age":@"18"};
			[dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
				// 解包元组，会吧元组的值，按顺序给参数的变量赋值
				RACTupleUnpack(NSString *key, NSString *value) = x;
				
				NSLog(@"key=%@ value=%@",key,value);
			}];
			
			
			// 可以利用遍历数组进行字典转模型
//			NSArray *dicArr;
//			NSArray *flags = [[dicArr.rac_sequence map:^id(id value) {
//				return [value objectForKey:@""];
//			}] array];
			
			
			break;
		}
		case 5:{
			
			NSLog(@"case5");
			/*
			 RACCommand：RAC中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递包装到这个类中，它可以很方便的监听事件的执行过程。
			 使用场景：监听按钮点击，网络请求
			 使用RACCommand需要进行强引用防止释放
			 */
			// 创建命令
			RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
				NSLog(@"开始执行命令");
				
				// 创建空信号，必须有返回信号
//				return [RACSignal empty];
				// 2. 创建信号，用来传递数据
				return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
					[subscriber sendNext:@"请求数据"];
					// 注意：数据传递完成，最好调用sendCompleted，这时命令才执行完毕
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						
						[subscriber sendCompleted];
					});
					
					return nil;
				}];
				
			}];
			_strongCommand = command;
			// 3. 订阅RACCommand中的信号
//			[command.executionSignals subscribeNext:^(id x) {
//				
//				[x subscribeNext:^(id x) {
//					NSLog(@"x2=%@",x);
//				}];
//			}];
			
//			[[command execute:nil] subscribeNext:^(id x) {
//				NSLog(@"x1=%@",x);
//			}];

			//高级用法
			[command.executionSignals.switchToLatest subscribeNext:^(id x) {
				NSLog(@"x2=%@",x);
			}];
			// 4. 监听命令是否执行完毕，默认会来一次，可以直接跳过，skip表示跳过第一次信号
			[[command.executing skip:1] subscribeNext:^(id x) {
				if ([x boolValue] == YES) {
					// 正在执行
					NSLog(@"正在执行");
				}else{
					// 执行完毕
					NSLog(@"执行完毕");
				}
			}];
			// 5. 执行命令
			[command execute:@"为什么要调用这一句"];
			
			
			break;
		}
		case 6:{
			// RACMulticastConnection简单使用
//			1. 创建请求信号
//			RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//				NSLog(@"发送请求");
//				return nil;
//			}];
//			// 2. 订阅信号
//			[signal subscribeNext:^(id x) {
//				NSLog(@"接收数据=%@",x);
//			}];
//			[signal subscribeNext:^(id x) {
//				NSLog(@"再次接收数据=%@",x);
//			}];
			
			//以上diamante会执行两次发送请求
			// 使用RACMulticastConnetion解决重复请求问题
			// 1. 创建信号
			RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				NSLog(@"发送请求");
				[subscriber sendNext:@1];
				return nil;
			}];
			
			// 2. 创建连接
			RACMulticastConnection *connect = [signal publish];
			
			// 3. 订阅信号
			// 注意：订阅信号，也不能激活信号，知识保存订阅者到数组，必须通过连接，当调用连接，就会一次性调用所有sendNext
			[connect.signal subscribeNext:^(id x) {
				NSLog(@"订阅者信号1=%@",x);
			}];
			[connect.signal subscribeNext:^(id x) {
				NSLog(@"订阅信号2=%@",x);
			}];
			// 4. 连接信号
			[connect connect];
			
			break;
		}
		case 7:{
			// 处理多个请求都返回结果的时候，统一做处理
			RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				// 发送请求1
				[subscriber sendNext:@"发送请求1"];
				return nil;
			}];
			RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				// 发送请求1
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					
					[subscriber sendNext:@"发送请求2"];
				});
				
				return nil;
			}];
			
			// 需要注意的是几个信号方法的参数就要几个
			[self rac_liftSelector:@selector(doAllSignalWith:and:) withSignalsFromArray:@[signal1,signal2]];
			
			
			break;
		}
		case 8:{
			//1. 代替代理 可以监听按钮点击并且调用了某个方法：redBtn(按钮） btnClick(点击按钮会触发的方法)
//			UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//			[[redBtn rac_signalForSelector:@selector(btnClick)] subscribeNext:^(id x) {
//				NSLog(@"点击按钮并触发了方法");
//			}];
			
			// 2. KVO
			// 把监听redBtn的center属性的改变转换成信号，只要改变就会发送信号
			// observer可以传nil
//			[[redBtn rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
//				NSLog(@"center发生改变了=%@",x);
//			}];
			
			// 3. 监听事件
			// 把按钮点击事件转换为信号，点击按钮，就会发送信号
//			[[redBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//				NSLog(@"按钮被点击了%@",x);
//			}];
			
			// 4. 代替通知
			// 把监听到的通知转换为信号
//			[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
//				NSLog(@"键盘弹出了%@",x);
//			}];

			// 需要导入RACReturnSignal 头文件
			
			
			[[_textField.rac_textSignal bind:^RACStreamBindBlock{
				// 什么时候调用这个block：当信号有新的值发出，就会来到这个block
				// block作用：做表示绑定一个信号。
				return ^RACStream *(id value, BOOL *stop){
					
					// block作用：做返回值的处理
					// 做好处理，铜鼓欧信号返回出去
					return [RACReturnSignal return:[NSString stringWithFormat:@"输出=%@",value]];
				};
				
			}] subscribeNext:^(id x) {
				
				NSLog(@"回调->%@",x);
			}];
			break;
		}
		case 9:{
			// flattenMap简单使用
			// 监听文本框的改变，把结构重新映射成一个新值
			// flattenMap作用，把源信号的内容映射成一个新的信号，信号可以是任意的类型
			// 使用步骤:
			// 1.传入一个block，block类型是返回值RACStream，参数value
			// 2.参数value就是源信号的内容，拿到源信号的内容做处理
			// 3.包装成RACReturnSignal，返回出去
			
			// 底层实现：使用bind
			[[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
				// block 什么时候调用：源信号发出的时候，就会调用这个block
				// block 作用：改变源信号的内容
				// 返回值：绑定信号的内容
				return [RACReturnSignal return:[NSString stringWithFormat:@"改变后的+%@",value]];
			}] subscribeNext:^(id x) {
				// 订阅绑定信号，每当源信号法搜内容，做完处理，就会调用这个block。
				NSLog(@"%@",x);
			}];
			
			break;
		}
		case 10:{
			// Map简单使用，
			// Map作用：把源信号的值映射成一个新的值
			
			// Map使用步骤
			// 1. 传入一个block，类型是返回对象，参数是value
			// 2. value就是源信号的内容，直接拿到源信号的内容做处理
			// 3. 把处理好的内容，直接返回就好了，不用包装成信号，返回的值就是映射的值
			
			// Map底层实现：
			// 0.调用faltternMap，Map中的block中的返回值会作为faltternMap中的block的值。
			// 1. 当订阅绑定信号，就会生成bindBLock。
			// 3. 当源信号发送内容，就会调用bindBLock（value,*stop)
			// 4. 调用bindBlock，内部就会调用flattenMap的block，把Map中的block返回内容包装成返回的信号
			// 5. flattenMap的block内部会调用Map中国女的block，把Map中的block返回的泥工包装成返回的信号
			// 6. 返回的信号最终会作为ibindBlock中的返回信号，当做binBlock的返回信号
			// 7. 订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出去。
			[[_textField.rac_textSignal map:^id(id value) {
				// 当源信号发出，就会调用这个block，修改源信号的内容
				// 返回值：就是处理完源信号的内容。
				return [NSString stringWithFormat:@"Map+%@",value];
			}] subscribeNext:^(id x) {
				NSLog(@"%@",x);
			}];
			break;
			/*
			 对比FlattenMap和Map的区别
			 1.FaltternMap中的Block返回信号
			 2.Map中的Block返回对象
			 3.开发中，如果信号发出的值不是信号，映射一般使用Map
			 4.开发汇总，如果信号发出的值是信号，映射一般使用FlattenMap
			 
			 */
		}
		case 11:{
			// 信号中的信号
			RACSubject *signalOfSignals = [RACSubject subject];
			RACSubject *signal = [RACSubject subject];
			
			[[signalOfSignals flattenMap:^RACStream *(id value) {
				// 当signalOfsignal的signals发出信号才会调用
				return value;
			}] subscribeNext:^(id x) {
				//只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的喜好，也就是flattenMap返回的信号
				// 也就是flattenMap返回的信号发出内容，才会调用。
				NSLog(@"aaa=%@",x);
			}];
			
			// 信号的信号发送信号
			[signalOfSignals sendNext:signal];
			// 信号发送内容
			[signal sendNext:@1];
			
			break;
		}
		case 12:{
			// ReactiveCocoa操作方法组合
			// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
			RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				[subscriber sendCompleted]; // 发送完毕
				return nil;
			}];
			
			RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@2];
				[subscriber sendCompleted];
				return nil;
			}];
			// 拼接信号
			RACSignal *concatSignal = [signalA concat:signalB];
			// 后续开发只要面对拼接信号开发
			// 订阅信号，不需要单独订阅signal，signalB
			// 内部会自动订阅
			// 注意：第一个信号必须发送完成，第二个信号才会被激活
			[concatSignal subscribeNext:^(id x) {
				NSLog(@"%@",x);
			}];
			break;
		}
		case 13:{
			// then：用于连接两个信号，当第一个信号完成，才会连接then返回的信号
			// 只有使用了then之前的信号才会被忽略
			// 底层实现：1、先过滤掉之前的信号发出的值。2、使用concat连接then返回的信号
			[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				[subscriber sendCompleted];
				return nil;
			}]then:^RACSignal *{
				return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
					[subscriber sendNext:@2];
					[subscriber sendCompleted];
					return nil;
				}];
			}] subscribeNext:^(id x) {
				// 只能接收到第二个信号的值，也就是then返回的信号值
				NSLog(@"then=%@",x);
			}];
			break;
		}
		case 14:{
			// merge的用法：合成信号
			RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				
				[subscriber sendNext:@1];
				[subscriber sendCompleted];
				return nil;
				
			}];
			
			RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@2];
				[subscriber sendCompleted];
				return nil;
			}];
			// 合并信号
			RACSignal *mergeSignal = [signalA merge:signalB];
			// 任何一个信号发出都能监听到
			[mergeSignal subscribeNext:^(id x) {
				NSLog(@"merge=%@",x);
			}];
			break;
			// 底层实现：信号被订阅的时候，就会遍历所有信号，并且发出这些信号
			// 2.每发出一个信号，这个信号就会被订阅
			// 3. 也就是合并信号一被订阅，就会订阅里面的所有信号
			// 4.只要有一个信号被发出就会被监听
		}
		case 15:{
			// zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出的时候，并且把两个信号的内容合并成一个元组，次奥胡触发压缩流的next事件
			RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				return nil;
			}];
			RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@2];
				return nil;
			}];
			
			// 压缩信号A和信号B
			RACSignal *zipSignal = [signalA zipWith:signalB];
			[zipSignal subscribeNext:^(id x) {
				NSLog(@"zipWith=%@",x);
			}];
			break;
			// 底层实现：
			// 1. 定义压缩信号，内部就会自动订阅SignalA和SignalB
			// 2. 每当signalA或者signalB发出信号，就会判断SignalA，signalB有没有翻出信号，就会把最近发出的信号都包装车能够元组发出
			/* <RACTuple: 0x17400e5f0> (
			1,
			2
			)*/
		}
		case 16:{
			// combineLatest:将多个信号合并起来，并且拿到各个辛哈偶的最新的值，必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
			RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				return nil;
			}];
			RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@2];
				return nil;
			}];
			
			// 把两个信号组合成一个信号，根zip一样没什么区别
			RACSignal *combineSignal = [signalA combineLatestWith:signalB];
			[combineSignal subscribeNext:^(id x) {
				NSLog(@"combineSignal=%@",x);
			}];
			/*
			 底层实现：
			 1. 当组合信号被订阅，内部会自动订阅signalA，signalB，必须两个信号都发出内容，才会被触发
			 2.并且把两个信号组合成元组发出
			 */
			break;
		}
		case 17:{
			// combineLatest:将多个信号合并起来，并且拿到各个辛哈偶的最新的值，必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
			RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				return nil;
			}];
			RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@2];
				return nil;
			}];
			
			// 聚合
			// 常见用法，（先组合再聚合）。
			// reduce中国女的block简介：
			// reduceblock中的参数，有多少信号组合，reduce比例从宽就有多少个参数，每个参数就是之前发出的内容
			// reduceblock的返回值：聚合信号之后的内容。
			RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA,signalB] reduce:^id(NSNumber *num1, NSNumber *num2){
				return [NSString stringWithFormat:@"%@, %@",num1,num2];
			}];
			
			[reduceSignal subscribeNext:^(id x) {
				NSLog(@"%@",x);
			}];
			// 底层实现：订阅聚合信号，每次有内容发出就会执行reduceblock，把信号转换成reduceblock返回的值
			
			break;
		}
		case 18:{
			//filter 过滤信号，会先执行过滤条件判断
			[_textField.rac_textSignal filter:^BOOL(NSString* value) {
				return value.length > 3;
			}];
			break;
		}
		case 19:{
			//ignore 忽略某些值的信号
			[[_textField.rac_textSignal ignore:@"123" ] subscribeNext:^(id x) {
				
//				return value.length > 3;
				NSLog(@"忽略123=%@",x);
			}];
			break;
		}
		case 20:{
			// distinctuntilChanged 当上一次的值和当前的值由明显变化的时候就会发出信号，否则会被忽略。
			// 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
			[[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
				NSLog(@"有变化=%@",x);
			}];
			break;
		}
		case 21:{
			// take:从开始一共取N次的信号
			// 1. 创建信号，订阅信号
			RACSubject *signal  = [RACSubject subject];
			
			// 2. 处理信号，订阅信号
			[[signal take:1] subscribeNext:^(id x) {
				NSLog(@"%@",x);
			}];
			
			// 3. 发出信号
			[signal sendNext:@1];
			[signal sendNext:@2];
			break;
		}
		case 22:{
			// takeLast:取最后N次的信号前提条件，订阅者必须调用完成，因为只有完成才能知道有多少信号
			// 1. 创建信号
			RACSubject *signal = [RACSubject subject];
			
			// 2. 处理信号，订阅信号
			[[signal takeLast:1] subscribeNext:^(id x) {
				NSLog(@"takelast=%@",x);
			}];
			
			// 3. 发送信号
			[signal sendNext:@1];
			[signal sendNext:@2];
			[signal sendCompleted];
			break;
		}
		case 23:{
			// 执行秩序
			/*
			 doNext:在执行Next之前会先执行这个block
			 doCompleted:执行sendCompleted之前，会先执行这个block
			 */
			[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				[subscriber sendCompleted];
				return nil;
			}] doNext:^(id x) {
				NSLog(@"donext=%@",x); // 执行sendNext之前会先执行这个block
			}] doCompleted:^{
				NSLog(@"doCompleted"); // 执行sendCompleted之前会先执行这个block
			}] subscribeNext:^(id x) {
				NSLog(@"subscribeNext=%@",x);
			}];
			break;
		}
		case 24:{
			// 超时，可以让一个信号在一定时间后自动报错
			RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				return nil;
			}] timeout:2 onScheduler:[RACScheduler currentScheduler]];
			
			[signal subscribeNext:^(id x) {
				
				NSLog(@"%@",x);
			}error:^(NSError *error) {
				// 两秒后自动调用
				NSLog(@"error=%@",error);
			}];
			break;
		}
		case 25:{
			// 定时发送：每隔一段时间发出信号
			//:warning: 这个代码是定时器，控制器销毁了还是会继续执行
			[[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler] withLeeway:2] subscribeNext:^(id x) {
				NSLog(@"定时发送=%@",x);
			}];
			break;
		}
		case 26:{
			// 延迟发送

			RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				return nil;
			}] delay:2] subscribeNext:^(id x) {
				NSLog(@"延迟发送消息=%@",x);
			}];
			break;
		}
		case 27:{
			// 重试 retry
			__block int i = 0;
			[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				if (i == 10) {
					[subscriber sendNext:@1];
				}else{
					NSLog(@"接收到错误");
					[subscriber sendError:nil];
				}
				i++;
				return nil;
			}] retry] subscribeNext:^(id x) {
				NSLog(@"重试之后收到消息=%@",x);
			}error:^(NSError *error) {
				NSLog(@"错误信息=%@",error);
			}];
			break;
		}
		case 28:{
			// 重放replay：当一个信号被多次订阅，反复播放内容
			RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
				[subscriber sendNext:@1];
				[subscriber sendNext:@2];
				return nil;
			}] replay];
			
			[signal subscribeNext:^(id x) {
				NSLog(@"第一个订阅者=%@",x);
			}];
			[signal subscribeNext:^(id x) {
				NSLog(@"第二个订阅者=%@",x);
			}];
			break;
		}
		case 29:{
			RACSubject *signal = [RACSubject subject];
			_signal = signal;
			// 节流，在一定时间（1秒内），不接收任何信号，过了这个时间，获取最后发送的信号内容发出
			[[signal throttle:1] subscribeNext:^(id x) {
				NSLog(@"延迟=%@",x);
			}];
//			[_textField.rac_textSignal ]
			[[_textField.rac_textSignal throttle:1] subscribeNext:^(id x) {
				NSLog(@"延迟输出=%@",x);
			}];
		}
			
			
			
  default:
			break;
	}
	
}

- (NSArray<NSString *> *)cellTitles
{
	return @[@"0RACSinal使用",
			 @"1RACSubject",
			 @"2RACReplaySubject使用步骤 多对多发送信号",
			 @"3使用RACSubject监听下一个控制器按钮的点击",
			 @"4遍历数组字典",
			 @"5RACCommand",
			 @"6RACMulticastConnection简单使用,防止重复调用发送",
			 @"7当所有的信号都返回数据的时候调用方法",
			 @"8bind用法",
			 @"9flattenMap,Map映射",
			 @"10Map简单使用",
			 @"11信号中的信号",
			 @"12信号拼接，连续发送",
			 @"13then的用法：只能接收到第二个信号的返回值",
			 @"14merge的用法：把多个信号合成一个信号",
			 @"15zipWith的用法：把多个信号压缩成为一个信号",@"combined的用法：把多个信号合并成为一个信号",
			 @"reduce聚合的用法：把信号发出元组的值聚合成一个值",
			 @"filter过滤",
			 @"ignore忽略某些值",
			 @"distinctUntilChanged数据发生变化的时候发送",
			 @"取固定数量的信号",
			 @"22去最后几个信号",
			 @"23执行秩序",
			 @"24 timeout超时，可以让一个信号在一定时间自动报错",
			 @"25定时发送",
			 @"延迟发送消息",
			 @"27重试,如果一个消息发送失败就会重新发送，直到成功",
			 @"replay重放",
			 @"throttle节流，防止过去频繁的访问",
			 ];
}
/*
 RACScheduler:RAC中的队列，用GCD封装的。
 RACUnit:表示stream中不包含有意义的值，也就是可以直接理解为nil
 RACEvent：把数据包装成信号事件(signal event).它主要是通过RACSignal的materialize来使用，很少用
 */

- (void)doAllSignalWith:(id)one and:(id)two
{
	NSLog(@"统一接收数据结果one=%@，two=%@",one,two);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.cellTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
	cell.textLabel.text = [NSString stringWithFormat:@"%@",self.cellTitles[indexPath.row]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self testRAC:indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	NSLog(@"%s", __func__);
}


@end
