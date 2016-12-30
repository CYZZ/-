//
//  YDGroupchannelVC.m
//  百思不得姐
//
//  Created by cyz on 16/12/28.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDGroupchannelVC.h"
#import "YDGroupViewModel.h"
#import "channels.h"
#import "YDSubscribeCell.h"

#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import <SVProgressHUD.h>

@interface YDGroupchannelVC ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
/// 左边分组表格
@property(nonatomic, strong) UITableView *groupTableView;
/// 右边频道表格
@property (nonatomic, strong) UITableView *channelTableView;
/// 全部模型
@property (nonatomic, strong) YDGroupViewModel *groupModel;
/// 分组下的模型
@property (nonatomic, strong) NSArray<channels*> *channelsArr;
/// 被订阅的频道数组用于回调使用
@property (nonatomic, strong) NSMutableArray<channels*> *subscribeArr;

@end

@implementation YDGroupchannelVC

- (UITableView *)groupTableView
{
	if (!_groupTableView) {
		_groupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_groupTableView.delegate = self;
		_groupTableView.dataSource = self;
		_groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_groupTableView.contentInset = UIEdgeInsetsZero; // 先添加的scrollView默认会有顶部导航栏长度
	}
	return _groupTableView;
}

- (UITableView *)channelTableView
{
	if (!_channelTableView) {
		_channelTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_channelTableView.delegate = self;
		_channelTableView.dataSource = self;
		_channelTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0); // 后添加的scrollView顶部会顶格
		_channelTableView.rowHeight = 60;
	}
	return _channelTableView;
}

- (NSArray<channels *> *)channelsArr
{
	if (!_channelsArr) {
		_channelsArr = [NSMutableArray array];
	}
	return _channelsArr;
}

- (NSMutableArray<channels *> *)subscribeArr
{
	if (!_subscribeArr) {
		_subscribeArr = [NSMutableArray array];
	}
	return _subscribeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
	
	[self.view addSubview:self.groupTableView];
	[self.view addSubview:self.channelTableView];
	
	[self.groupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.bottom.offset(0);
		make.width.equalTo(self.view.mas_width).multipliedBy(1/4.0).offset(20);
	}];
	[self.channelTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.right.bottom.offset(0);
		make.left.equalTo(self.groupTableView.mas_right).offset(01); // 设置间隙
	}];
	
	[self requestGroupModel];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(requestGroupModel)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)requestGroupModel
{
	[SVProgressHUD setViewForExtension:self.view];
	[SVProgressHUD show];
	[YDGroupViewModel requestYDAllChannelViewModel:^(YDGroupViewModel *model) {
//		NSLog(@"model.group = %@",model.groupChannel);
		self.groupModel = model;
		self.channelsArr = [model.groupChannel firstObject].channels;
		[self.groupTableView reloadData];
		[self.channelTableView reloadData];
		
		[SVProgressHUD dismiss];
	} failture:^(NSError *error) {
		NSLog(@"请求全部频道失败=%@",error);
		
		[SVProgressHUD dismiss];
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.groupTableView) {
		return  self.groupModel.groupChannel.count;
	}else{
		return self.channelsArr.count;
	}
//	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.groupTableView) {
	
		static NSString *groupID = @"groupID";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:groupID];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupID];
		}
		cell.textLabel.font = [UIFont systemFontOfSize:13];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.text = self.groupModel.groupChannel[indexPath.row].category;
		
		return cell;
	}else{
		
		static NSString *chanelID = @"channelID";
		YDSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:chanelID];
		if (cell == nil) {
			cell = [[YDSubscribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chanelID];
		}
		channels *channel = self.channelsArr[indexPath.row];
		channel.subscribe = [self.titleArray containsObject:channel.name];
		
		cell.model = channel;
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.groupTableView) { // 点击了分组

		self.channelsArr = self.groupModel.groupChannel[indexPath.row].channels;
		[self.channelTableView reloadData];
		[self.channelTableView setContentOffset:CGPointMake(0, -64) animated:YES];
	}else{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		channels *channel = self.channelsArr[indexPath.row];
		
		// 如果已订阅就移除
		if ([self.titleArray containsObject:channel.name]) {
			[self.titleArray removeObject:channel.name];
			[self.subscribeArr removeObject:channel];
		}else{
			[self.titleArray addObject:channel.name];
			[self.subscribeArr addObject:channel]; // 点击了就订阅频道
		}
		// 刷新
		[self.channelTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		NSLog(@"点击了频道");
		
	}
	
}

- (void)subscribeChannel:(void (^)(NSArray<channels *> *))channelsBlock
{
	self.addChannelsBlock = channelsBlock;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//	
//	
//}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	/// 当视图消失的时候发送回调数组
	if (self.addChannelsBlock) {
		self.addChannelsBlock(self.subscribeArr);
	}
}

- (void)dealloc
{
	NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
