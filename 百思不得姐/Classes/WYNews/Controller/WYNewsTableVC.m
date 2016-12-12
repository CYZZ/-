//
//  WYNewsTableVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "WYNewsTableVC.h"
#import "WYNewsModel.h"
#import "listModel.h"
#import "WYNewsCell.h"
#import "BLRefreshFooter.h"
#import "BLRefreshHeader.h"
#import "WYDetailNewsVC.h"

#import "BLTestRACViewController.h"

#import <Masonry.h>
#import <ReactiveCocoa.h>


@interface WYNewsTableVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<listModel*> *newsArray;

/**
 空视图
 */
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation WYNewsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self.tableView registerClass:[WYNewsCell class] forCellReuseIdentifier:NSStringFromClass([WYNewsCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYNewsCell" bundle:nil] forCellReuseIdentifier:@"WYNewsCell"];
    [self setupRefreshView];
    self.tableView.rowHeight = 80;
    
    [self setupEmptyView];
}

- (void)setupEmptyView
{
    UIView *emptyView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.tableView addSubview:emptyView];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.insets(UIEdgeInsetsZero);
        
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂时没有数据";
    [emptyView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    self.emptyView = emptyView;
    emptyView.backgroundColor = [UIColor greenColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边按钮" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边按钮" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    RAC(label, text) = RACObserve(self.navigationItem.rightBarButtonItem, title);
}

- (void)leftItemClick
{
    self.navigationItem.rightBarButtonItem.title = @"789456";
}

- (void)rightItemClick
{
    self.navigationItem.leftBarButtonItem.title = @"12345";
}

/**
 初始胡刷新控件
 */
- (void)setupRefreshView
{
    
    self.tableView.mj_header = [BLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [BLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = YES;
}


/**
 下拉刷新数据
 */
- (void)loadNewData
{
    [self loadDataForType:1 withURL:@"http://c.m.163.com/nc/article/list/T1348649580692/0-20.html"];
}

/**
 上拉刷新数据
 */
- (void)loadMoreData
{
    NSString *allUrlString = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/T1348649580692/%ld-20.html",(self.newsArray.count-self.newsArray.count%10)];
    [self loadDataForType:2 withURL:allUrlString];
}


// --------公共方法
/**
 请求新闻数据

 @param type         下拉刷新最新数据type=1，上拉刷新type=2
 @param allUrlString 请求数据的链接
 */
- (void)loadDataForType :(int)type withURL:(NSString *)allUrlString
{
    MJWeakSelf
    [WYNewsModel request:allUrlString ForWYNews:^(WYNewsModel *model) {
        
        if (type == 1) {
            weakSelf.newsArray = @[].mutableCopy;
            [weakSelf.newsArray addObjectsFromArray:model.list];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }else if (type == 2){
            [weakSelf.newsArray addObjectsFromArray:model.list];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            NSLog(@"上拉成功");
        }

    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSLog(@"请求网易新闻失败");
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.newsArray.count > 0) {
//        self.emptyView.hidden = YES;
    }else{
//        self.emptyView.hidden = NO;
    }
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WYNewsCell class])];
    cell.model = self.newsArray[indexPath.row];
	__weak typeof(self) weakSelf = self;
	cell.rightBtnBlock = ^{
		[weakSelf.navigationController pushViewController:[[BLTestRACViewController alloc] init] animated:YES];
	};
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WYDetailNewsVC *detailVC = [[WYDetailNewsVC alloc] init];
    detailVC.listModel = self.newsArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
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
