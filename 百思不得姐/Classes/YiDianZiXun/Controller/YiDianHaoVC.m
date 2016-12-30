//
//  YiDianHaoVC.m
//  百思不得姐
//
//  Created by cyz on 16/12/30.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YiDianHaoVC.h"
#import "subchannels.h"
#import "YiDianHaoViewModel.h"
#import "BLRefreshHeader.h"
#import "BLRefreshFooter.h"
#import "YiDianhaoCell.h"

@interface YiDianHaoVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<subchannels*> *channels;
@end

@implementation YiDianHaoVC

- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.rowHeight = 60;
	}
	return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.view addSubview:self.tableView];
	[self.tableView registerClass:[YiDianhaoCell class] forCellReuseIdentifier:NSStringFromClass([YiDianhaoCell class])];
	
	[self requestSubChannels];
	[self setupRefreshView];
}

- (void)setupRefreshView
{
	self.tableView.mj_header = [BLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestSubChannels)];
}

- (void)requestSubChannels
{
	MJWeakSelf
	[YiDianHaoViewModel requesYDHWithgroupID:self.groupID completion:^(NSArray<subchannels *> *channels) {
		weakSelf.channels = channels.mutableCopy;
		[weakSelf.tableView reloadData];
		[weakSelf.tableView.mj_header endRefreshing];
		
	} failture:^(NSError *error) {
		[weakSelf.tableView.mj_header endRefreshing];
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	subchannels *model = self.channels[indexPath.row];
	YiDianhaoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YiDianhaoCell class])];
	
	cell.model = model;
	
	return cell;
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
