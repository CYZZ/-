//
//  BLAllTableVC.m
//  百思不得姐
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLAllTableVC.h"
#import "BLJinhuaALLModel.h"

#import "BLEssenceVideoCell.h"

#import "BLRefreshHeader.h"
#import "BLRefreshFooter.h"
#import <UITableView+FDTemplateLayoutCell.h>


#import "BLSentMessageVC.h"
#import "BLPlayerVC_RB.h"
#import "BLCustomerPlayer.h"
#import "BLNotificationDetailVC.h" // 通知详情页

#import "BLCommentVC.h"


@interface BLAllTableVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/// 全部数据
@property (nonatomic, strong) NSMutableArray<list *> *dataList;
/// 最后刷新时间
@property (nonatomic, copy) NSString *maxTime;

@end

@implementation BLAllTableVC

#pragma mark - 懒加载
// 初始化tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
//        _tableView.estimatedRowHeight = 300.0f;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
//    [self refreshData];
    // 注册cell
//    [self.tableView registerClass:[BLBaseEssenceCell class] forCellReuseIdentifier:NSStringFromClass([BLBaseEssenceCell class])];
    
    // 通过xib注册一个cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BLEssenceVideoCell" bundle:nil] forCellReuseIdentifier:@"BLEssenceVideoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLEssenceWordCell" bundle:nil] forCellReuseIdentifier:@"BLEssenceWordCell"];
    
    [self setupRefreshView];
    
}

/**
 添加刷新控件
 */
- (void)setupRefreshView
{
    BLRefreshHeader *header = [BLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    BLRefreshFooter *footer = [BLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    // 设置在没有数据的时候自动隐藏上拉刷新控件
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    
}

/// 加载最新数据
- (void)refreshData 
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"maxtime"] = self.maxTime;
    dic[@"type"] = self.typeID;
    __weak typeof(self) weakSelf = self;
    
    [BLJinhuaALLModel getEssenceModelWith:dic complection:^(BLJinhuaALLModel *ALLModel) {
        
        NSLog(@"加载数据完成ID=%@",ALLModel.list[0].ID);
        
        weakSelf.maxTime = ALLModel.info.maxtime; // 最后刷新时间
        weakSelf.dataList = ALLModel.list.mutableCopy;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    
}

- (void)loadMoreData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"maxtime"] = self.maxTime;
    dic[@"type"] = self.typeID;
//    NSLog(@"dic=%@",dic);
    __weak typeof(self) weakSelf = self;
    
    [BLJinhuaALLModel getEssenceModelWith:dic complection:^(BLJinhuaALLModel *ALLModel) {
        
        weakSelf.maxTime = ALLModel.info.maxtime;
        [weakSelf.dataList addObjectsFromArray:ALLModel.list];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
        NSLog(@"获取更多数据失败"); 
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - <tableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    list *model = self.dataList[indexPath.row];
    
    BLEssenceVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[BLEssenceVideoCell cellReuseIDWith:model] forIndexPath:indexPath];
    cell.model = model;
    
    
//    BLBaseEssenceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLBaseEssenceCell class])];
    
    
    __weak typeof(self) weakSelf = self;
//    cell.playerBtnClick = ^{
//        NSLog(@"在cell中调用了播放按钮的block");
//    };
//    
//    cell.buttonBlock = ^{
//        NSLog(@"在cell中调用了block");
//        BLPlayerVC_RB *jpPlayer = [[BLPlayerVC_RB alloc] init];
//        jpPlayer.videoURL = model.videouri;
//        
//        [weakSelf.navigationController pushViewController:jpPlayer animated:YES];
////        model.expanded = !model.expanded;
////        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    };
    
    cell.playBLock = ^{
                BLPlayerVC_RB *RBPlayerVC = [[BLPlayerVC_RB alloc] init];
                RBPlayerVC.videoURL = model.videouri;
                
                [weakSelf.navigationController pushViewController:RBPlayerVC animated:YES];
    };
    
    cell.commentBlock = ^{
        
        [weakSelf.navigationController pushViewController:[[BLNotificationDetailVC alloc] initWKWebViewWith:@"http://www.jianshu.com/p/88c2f3e207c4"] animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    list *model = self.dataList[indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:[BLEssenceVideoCell cellReuseIDWith:model] cacheByIndexPath:indexPath configuration:^(BLEssenceVideoCell *cell) {
        cell.model = model;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[BLCommentVC alloc] initWithCommentID:self.dataList[indexPath.row].ID] animated:YES];
    
    BLEssenceVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[BLEssenceVideoCell cellReuseIDWith:self.dataList[indexPath.row]] forIndexPath:indexPath];
    
//    [cell layoutIfNeeded];
    NSLog(@"cell.frame = %@",NSStringFromCGRect(cell.frame));

//    BLCustomerPlayer *customPlayer = [[BLCustomerPlayer alloc] init];
//    customPlayer.videoURL = self.dataList[indexPath.row].videouri;
//    [self.navigationController pushViewController:customPlayer animated:YES];
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
