//
//  YDMainViewController.m
//  百思不得姐
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDMainViewController.h"
#import "YDController.h"
#import "YiDianHaoVC.h"
#import "YiDianChannelModel.h"
#import "user_channels.h"
#import "channels.h"
//#import "subchannels.h"
#import "YDChannelVC.h"
#import <UIButton+WebCache.h>
#import <SVProgressHUD.h>

@interface YDMainViewController ()
/// 标题数组
@property(nonatomic, strong) NSMutableArray<NSString *> *titleArray;

/// 频道数组
@property (nonatomic, strong) NSMutableArray<channels *> *channelsArr;

@property (nonatomic, weak) UITextField *textFile;

/// 用户的分组id
@property (nonatomic, copy) NSString *groupID;
@end

@implementation YDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.magicView.navigationHeight = 36;
	self.magicView.headerHeight = 64;
//	self.edgesForExtendedLayout = UIRectEdgeAll;
	[self.magicView reloadData];
	
	[self setupNav];
	[self loadChannelData]; // 首次启动就加载频道数据
}

- (void)setupNav
{
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新频道" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
	UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"频道" style:UIBarButtonItemStylePlain target:self action:@selector(sortChannel)];
	UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
	
	self.navigationItem.leftBarButtonItem = leftItem;
	self.navigationItem.rightBarButtonItems = @[rightItem1, rightItem2];
	
	// 添加输入框
	UITextField *textFile = [[UITextField alloc] init];
	textFile.borderStyle = UITextBorderStyleRoundedRect;
	textFile.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.7, 36);
	self.textFile = textFile;
	self.navigationItem.titleView = textFile;
	
	NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:YDToken];
	textFile.text = token;
	textFile.placeholder = @"请求输入用户token";
}
/// 刷新频道
- (void)leftItemClick
{
	[self loadChannelData];
}
/// 重新登录
- (void)rightItemClick
{
	// 保存token
	[[NSUserDefaults standardUserDefaults] setValue:self.textFile.text forKey:YDToken];
	
	[self loadChannelData];
}
/// 频道排序
- (void)sortChannel
{
	YDChannelVC *channel = [[YDChannelVC alloc] init];
	channel.titleArray = self.titleArray;
	channel.channeslArr = self.channelsArr;
	channel.groupID = self.groupID;
	
	__weak typeof(self) weakSelf = self;
	channel.channelBackBlock =^(NSMutableArray<channels*> *channelsArr){
		weakSelf.channelsArr = channelsArr;
		if (channelsArr.count > 0) {
			[weakSelf.titleArray removeAllObjects];
		}
		[weakSelf.channelsArr enumerateObjectsUsingBlock:^(channels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//			NSLog(@"返回的标题=%@",obj.name);
			[weakSelf.titleArray addObject:obj.name];
		}];
		[weakSelf.magicView reloadData];
	};
	
//	channel.channelBackBlock = ^(NSArray *titleArray){
//		
//		NSLog(@"排序完成回调");
//	};
	
//	__weak typeof(self) weakSelf = self;
	channel.selectChannel = ^(NSString *title){
		NSInteger index = [weakSelf.titleArray indexOfObject:title];
		[weakSelf switchToPage:index animated:NO];
//		NSLog(@"选中了频道=%@",title);
	};
	
	[self.navigationController pushViewController:channel animated:YES];
}

/// 加载频道数据
- (void)loadChannelData
{
	[SVProgressHUD show];
	__weak typeof(self) weakSelf = self;
	[YiDianChannelModel requestYDChannels:^(YiDianChannelModel *model) {
		
		weakSelf.groupID = model.user_channels[0].group_id; // 存储group_id用于频道排序
		
		weakSelf.titleArray = @[].mutableCopy;
		weakSelf.channelsArr = model.user_channels[0].channels.mutableCopy;
		
		channels *best = [[channels alloc] init];
		best.name = @"推荐";
		channels *hot = [[channels alloc] init];
		hot.name = @"要闻";
		
		[weakSelf.channelsArr insertObject:best atIndex:0];
		[weakSelf.channelsArr insertObject:hot atIndex:1];
		
//		__weak typeof(self) weakSelf = self;
		[self.channelsArr enumerateObjectsUsingBlock:^(channels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[weakSelf.titleArray addObject:obj.name];
		}];
		
		[weakSelf.magicView reloadData];
		[SVProgressHUD dismiss];
	} failture:^(NSError *error) {
		[SVProgressHUD dismiss];
	}];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
	return self.titleArray;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
	static NSString *itemIdentifier = @"itemIdentifier";
	UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
	if (!menuItem) {
//		subchannels *channel = self.subchannelArr[itemIndex];
		
		menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
//		[menuItem setImage:[UIImage imageNamed:@"header_cry_icon"] forState:UIControlStateNormal];
//		[menuItem sd_setImageWithURL:[NSURL URLWithString:channel.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"header_cry_icon"]];
		[menuItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[menuItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
		menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
	}
	return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
	channels *channel = self.channelsArr[pageIndex];
	if ([channel.name isEqualToString:@"一点号"]) {
		YiDianHaoVC *controller = nil;
		controller = [magicView dequeueReusablePageWithIdentifier:channel.channel_id];
		if (controller == nil) {
			controller = [[YiDianHaoVC alloc] init];
			controller.groupID = self.groupID;
		}
		return controller;
	}
	
	YDController *controller = nil;
	controller = [magicView dequeueReusablePageWithIdentifier:channel.channel_id];
	if (controller == nil) {
		controller = [[YDController alloc] init];
		controller.channel_id = self.channelsArr[pageIndex].channel_id;
		controller.position = pageIndex;
		controller.reuseIdentifier = controller.channel_id;
//		NSLog(@"controller.channel_id = %@",controller.channel_id);
	}
	return controller;
	
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//	return UIInterfaceOrientationMaskAll; // 支持屏幕旋转的方向
//}
//
//- (BOOL)shouldAutorotate
//{
//	return YES;
//}

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
