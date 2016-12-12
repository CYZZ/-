//
//  BLTestRACViewController.m
//  百思不得姐
//
//  Created by cyz on 16/12/12.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLTestRACViewController.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>

@interface BLTestRACViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

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
}

- (NSString *)testRAC:(NSInteger)index
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

			return @"基本使用";
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
			return @"RACSubject使用";
			break;
		}
		case 2:{
			return @"还没有定义";
			break;
		}
		case 3:{
			return @"还没有定义";
			break;
		}
		case 4:{
			return @"还没有定义";
			break;
		}
		case 5:{
			return @"还没有定义";
			break;
		}
		case 6:{
			return @"还没有定义";
			break;
		}
		case 7:{
			return @"还没有定义";
			break;
		}
		case 8:{
			return @"还没有定义";
			break;
		}
			
  default:
			return @"还没有定义";
			break;
	}
	
}

- (NSString *)cellTitleAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:
			return @"RACSinal使用";
			break;
		case 1:
			return @"RACSubject";
			break;
		case 2:
			return @"RACSinal";
			break;
		case 3:
			return @"RACSinal";
			break;
			
  default:
			return @"还没有定义";
			break;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ = %ld",[self cellTitleAtIndexPath:indexPath],indexPath.row];
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
