//
//  YDController.m
//  百思不得姐
//
//  Created by cyz on 16/12/13.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDController.h"
#import "YDCell.h"
#import "YDresult.h"
#import "YiDianNewsModel.h"
#import "BLRefreshFooter.h"
#import "BLRefreshHeader.h"
#import "BLPlayerVC_RB.h"

#import <ZFPlayer.h>
#import "BLNotificationDetailVC.h"
#import "YDDetaiVC.h"
#import <UITableView+FDTemplateLayoutCell.h>
//#import <>

@interface YDController ()<UITableViewDelegate, UITableViewDataSource, ZFPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 模型数组
@property (nonatomic, strong) NSMutableArray<YDresult*> *ydArrayM;
/// 资讯开始加载的位置
@property (nonatomic, assign) NSInteger cstart;
/// 播放器view
@property (nonatomic, strong) ZFPlayerView *playerView;
/// 控制层
@property (nonatomic, strong) ZFPlayerControlView *controView;

@end

@implementation YDController

- (ZFPlayerView *)playerView
{
	if (!_playerView) {
		_playerView = [ZFPlayerView sharedPlayerView]; // 创建单例
		_playerView.delegate = self;
		// 当cell播放视频有全屏变为小屏的时候，不会到中间位置
		_playerView.cellPlayerOnCenter = NO;
		// 当cell划出屏幕的时候停止播放
//		_playerView.stopPlayWhileCellNotVisable = YES;
		//静音
//		_playerView.mute = YES;
		
	}
	return _playerView;
}

- (ZFPlayerControlView *)controView
{
	if (!_controView) {
		_controView = [[ZFPlayerControlView alloc] init];
	}
	return _controView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	NSArray *types = @[@"YDCell",@"YDThreeImageCell",@"YDVideoCell"];
	// 遍历数组注册cell
	[YDCell registerCellWithTypes:types onTableView:self.tableView];
	
	self.tableView.rowHeight = 80;
	[self setupRefreshView];
}

/// 初始化刷新控件
- (void)setupRefreshView
{
	self.tableView.mj_header = [BLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	[self.tableView.mj_header beginRefreshing];
	
	self.tableView.mj_footer = [BLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	self.tableView.mj_footer.automaticallyHidden = YES;
	
}

/// 下拉刷新
- (void)loadNewData
{
	[self loadDataForType:1];
}

/// 上拉刷新
- (void)loadMoreData
{
	[self loadDataForType:2];
}


/**
 请求资讯数据

 @param type 类型为1表示下拉刷新 ，type=2表示上拉刷新
 */
- (void)loadDataForType:(int)type
{
	MJWeakSelf
	[YiDianNewsModel requestYDNewsWith:weakSelf.cstart position:weakSelf.position channelID:weakSelf.channel_id forNews:^(YiDianNewsModel *model) {
		
		if (type == 1) {
			// 下拉刷新
			weakSelf.ydArrayM = @[].mutableCopy;
			weakSelf.ydArrayM = model.result.mutableCopy;
			[weakSelf.tableView reloadData];
			[weakSelf.tableView.mj_header endRefreshing];
//			NSLog(@"positon=%ld,)
		}else if (type == 2){
			// 上拉刷新
			[weakSelf.ydArrayM addObjectsFromArray: model.result];
			[weakSelf.tableView reloadData];
			[weakSelf.tableView.mj_footer endRefreshing];
		}
		weakSelf.cstart += 30;
	} failture:^(NSError *error) {
		[weakSelf.tableView.mj_footer endRefreshing];
		[weakSelf.tableView.mj_header endRefreshing];
		NSLog(@"请求失败=%@",error);
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	NSLog(@"ydArrayM = %@",_ydArrayM);
	return self.ydArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	YDresult *model =self.ydArrayM[indexPath.row];
	YDCell *cell = nil;
	if (model.image_urls.count >= 3) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"YDThreeImageCell"];
	}else if ([model.ctype isEqualToString:@"video_live"]){
		cell = [tableView dequeueReusableCellWithIdentifier:@"YDVideoCell"];
		__weak typeof(self) weakSelf = self;
		__weak typeof(cell) weakCell = cell;
		[cell playVideoWithBlock:^{
			
			NSLog(@"cell.imageView.tag = %ld",weakCell.playerImageView.tag);
			[weakSelf playerVideoOn:weakCell.playerImageView tableView:tableView atIndexPath:indexPath title:model.title url:model.video_url];
		}];
		
	}else{
		cell = [tableView dequeueReusableCellWithIdentifier:@"YDCell"];
	}
	
	cell.model = model;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	YDresult *model =self.ydArrayM[indexPath.row];
	if (model.image_urls.count >= 3) {
		return  [tableView fd_heightForCellWithIdentifier:@"YDThreeImageCell" cacheByIndexPath:indexPath configuration:^(YDCell *cell) {
			cell.model = model;
		}];
	}else if ([model.ctype isEqualToString:@"video_live"]){
		return  [tableView fd_heightForCellWithIdentifier:@"YDVideoCell" cacheByIndexPath:indexPath configuration:^(YDCell *cell) {
			cell.model = model;
		}];
	}else{
		return 80;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSString *detaiUrl = self.ydArrayM[indexPath.row].url;
//	BLNotificationDetailVC *vc = [[BLNotificationDetailVC alloc] initWKWebViewWith:detaiUrl];
//	[self.navigationController pushViewController:vc animated:YES];
	YDresult *model = self.ydArrayM[indexPath.row];
	if ([model.ctype isEqualToString:@"news"]) {
		YDDetaiVC *vc = [[YDDetaiVC alloc] init];
		vc.result = model;
		[self.navigationController pushViewController:vc animated:YES];
	}else{
		NSString *detaiUrl = self.ydArrayM[indexPath.row].url;
		BLNotificationDetailVC *vc = [[BLNotificationDetailVC alloc] initWKWebViewWith:detaiUrl];
		[self.navigationController pushViewController:vc animated:YES];
	}
	
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

/// tableView的cell上播放视频
- (void)playerVideoOn:(UIView *)fatherView
			tableView:(UITableView *)tableView
		  atIndexPath:(NSIndexPath *)indexPath
				title:(NSString *)title
				  url:(NSString *)url
{
	ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
	playerModel.title = title;
	playerModel.videoURL = [NSURL URLWithString:url];
	playerModel.tableView = tableView;
	playerModel.indexPath = indexPath;
	playerModel.resolutionDic = @{@"高清" : url};
	playerModel.fatherView = fatherView;
	
	//设置播放view的model
	[self.playerView playerControlView:self.controView playerModel:playerModel];
	self.playerView.hasDownload = YES;
	// 自动播放
	[self.playerView autoPlayTheVideo];
}

@end
