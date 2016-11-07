//
//  BLAllTableVC.m
//  百思不得姐
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLAllTableVC.h"
#import "BLJinhuaALLModel.h"
#import "BLWordCell.h"
#import "BLRefreshHeader.h"
#import "BLRefreshFooter.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "NSObject+YZProperty.h"

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
//        _tableView.estimatedRowHeight = 100.0f;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
//    [self refreshData];
    // 注册cell
    [self.tableView registerClass:[BLWordCell class] forCellReuseIdentifier:NSStringFromClass([BLWordCell class])];
    
    [self setupRefreshView];
    
}
- (void)testJSON {
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MainVCSettings.json" ofType:nil];
    //    NSData *data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"data====%@",data);
    //    NSError *error = nil;
    //    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"json数组=%@",array[1]);
    //    
    //    BLtestModel *model = [BLtestModel YZmodelWithDic:array[1]];
    //    NSLog(@"model.vcName = %@",model.vcName);
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
    __weak typeof(self) weakSelf = self;
    
    [BLJinhuaALLModel getEssenceModelWith:@{@"type" : @"29"} complection:^(BLJinhuaALLModel *ALLModel) {
        
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
    dic[@"type"] = @"29";
    NSLog(@"dic=%@",dic);
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
    BLWordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLWordCell class])];
    list *model = self.dataList[indexPath.row];
    cell.model = model;
    cell.buttonBlock = ^{
        NSLog(@"在cell中调用了block");
        model.expanded = !model.expanded;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    list *model = self.dataList[indexPath.row];
    return  [tableView fd_heightForCellWithIdentifier:NSStringFromClass([BLWordCell class]) cacheByIndexPath:indexPath configuration:^(BLWordCell *cell) {
        cell.model = model;
    }];
//    return  UITableViewAutomaticDimension;
//    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self refreshData];
//    NSLog(@"高度为%f",UITableViewAutomaticDimension);
//    BLWordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLWordCell class])];
//    NSLog(@"cell.imageView = %@",NSStringFromCGSize( cell.profileImageView.image.size));
//    NSLog(@"cell.height = %f",tableView.rowHeight);
    list *model = self.dataList[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[[BLCommentVC alloc] initWithCommentID:model.ID] animated:YES];
    
//    model.expanded = !model.expanded;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
