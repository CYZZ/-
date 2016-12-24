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

#import "BLNotificationDetailVC.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface YDController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 模型数组
@property (nonatomic, strong) NSMutableArray<YDresult*> *ydArrayM;
/// 资讯开始加载的位置
@property (nonatomic, assign) NSInteger cstart;

@end

@implementation YDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[self.tableView registerNib:[UINib nibWithNibName:@"YDCell" bundle:nil] forCellReuseIdentifier:@"YDCell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"YDThreeImageCell" bundle:nil] forCellReuseIdentifier:@"YDThreeImageCell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"YDVideoCell" bundle:nil] forCellReuseIdentifier:@"YDVideoCell"];
	
	self.tableView.rowHeight = 80;
	[self setupRefreshView];
//	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:0];
//	[indexSet addIndex:1]; 
//	[_ydArrayM insertObjects:<#(nonnull NSArray<YDresult *> *)#> atIndexes:<#(nonnull NSIndexSet *)#>]
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
		[cell playVideoWithBlock:^{
			BLPlayerVC_RB *RBPlayerVC = [[BLPlayerVC_RB alloc] init];
			RBPlayerVC.videoURL = model.video_url;
			RBPlayerVC.videoTitle = model.title;
			[weakSelf.navigationController pushViewController:RBPlayerVC animated:YES];
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
	NSString *detaiUrl = self.ydArrayM[indexPath.row].url;
	BLNotificationDetailVC *vc = [[BLNotificationDetailVC alloc] initWKWebViewWith:detaiUrl];
	[self.navigationController pushViewController:vc animated:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll; // 支持屏幕旋转的方向
}

- (BOOL)shouldAutorotate
{
	return YES;
}

@end
