//
//  BLTestColletionVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/26.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLTestColletionVC.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import "BLCollectionFlowLayout.h"
#import "YZWaterFlowLayout.h"
#import "YZCollectionCell.h"
#import "BLRefreshHeader.h"
#import "BLRefreshFooter.h"

#import "BLJinhuaALLModel.h"
#import "BLCommentVC.h"

#import "BLSeeBigImageVC.h" // 查看大图


@interface BLTestColletionVC ()<UICollectionViewDataSource, UICollectionViewDelegate, YZWaterFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *colletionView;

@property (nonatomic, strong) NSMutableArray<list *> *dataList;


/**
 加载数据类型
 */
@property (nonatomic, copy) NSString *typeID;
/// 最后刷新时间
@property (nonatomic, copy) NSString *maxTime;

@end

@implementation BLTestColletionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.colletionView];
    [self.colletionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    [self setupRefresh];
}


/**
 初始化刷新控件
 */
- (void)setupRefresh
{
    self.typeID = @"10";
    self.colletionView.mj_header = [BLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.colletionView.mj_footer = [BLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.colletionView.mj_header beginRefreshing];
    self.colletionView.mj_footer.automaticallyHidden = YES;
}


/**
 加载最新数据
 */
- (void)loadNewData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
//    dic[@"maxtime"] = self.maxTime;
    dic[@"type"] = self.typeID;
    __weak typeof(self) weakSelf = self;
    
    [BLJinhuaALLModel getEssenceModelWith:dic complection:^(BLJinhuaALLModel *ALLModel) {
        
        NSLog(@"加载数据完成ID=%@",ALLModel.list[0].ID);
        
        weakSelf.maxTime = ALLModel.info.maxtime; // 最后刷新时间
        weakSelf.dataList = ALLModel.list.mutableCopy;
        [weakSelf.colletionView reloadData];
        [weakSelf.colletionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.colletionView.mj_header endRefreshing];
    }];

    NSLog(@"loadNewData");
}

/**
 加载更多数据
 */
- (void)loadMoreData
{
     NSLog(@"loadMoreData");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"maxtime"] = self.maxTime;
    dic[@"type"] = self.typeID;
    __weak typeof(self) weakSelf = self;
    
    [BLJinhuaALLModel getEssenceModelWith:dic complection:^(BLJinhuaALLModel *ALLModel) {
        
        NSLog(@"加载数据完成ID=%@",ALLModel.list[0].ID);
        
        weakSelf.maxTime = ALLModel.info.maxtime; // 最后刷新时间
        [weakSelf.dataList addObjectsFromArray:ALLModel.list];
        [weakSelf.colletionView reloadData];
        [weakSelf.colletionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.colletionView.mj_footer endRefreshing];
    }];
}

/**
 请求新闻数据
 
 @param type         下拉刷新最新数据type=1，上拉刷新type=2
 @param allUrlString 请求数据的链接
 */
- (void)loadDataForType :(int)type withURL:(NSString *)allUrlString
{
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return YES;
//}

- (BOOL)shouldAutorotate
{
//    NSLog(@"允许屏幕旋转");
    [self.colletionView reloadData];
    return YES;
}

/**
 初始化collectionView
 */
- (UICollectionView *)colletionView
{
    if (!_colletionView) {
        // 创建一个layou布局类
        YZWaterFlowLayout *layout = [[YZWaterFlowLayout alloc] init];
        
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置每一个item的大小为100*100
//        layout.itemSize = CGSizeMake(100, 100);
        // 创建引导页
//        layout.itemSize = [UIScreen mainScreen].bounds.size;
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 0;
//        // 设置水平滚动
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _colletionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
//        _colletionView.pagingEnabled = YES;
//        _colletionView.showsHorizontalScrollIndicator = NO;
//        _colletionView.bounces = NO;
        
        // 创建colletionView通过一个布局策略layout来创建
        // 设置代理
        _colletionView.dataSource = self;
        _colletionView.delegate = self;
        layout.delegate = self;
        
        _colletionView.backgroundColor = [UIColor lightGrayColor];
        
        
        // 注册item类型这里使用系统的类型
        [_colletionView registerClass:[YZCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([YZCollectionCell class])];
        
    }
    return _colletionView;
}



//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 3;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YZCollectionCell class]) forIndexPath:indexPath];
    list *model = self.dataList[indexPath.item];
    cell.model = model;
    
    __weak typeof(self) weakSelf = self;
    cell.buttonBlock = ^{
        BLSeeBigImageVC *imageVC = [[BLSeeBigImageVC alloc] init];
        imageVC.model = model;
        [weakSelf.navigationController pushViewController:imageVC animated:YES];
    };

    return cell;
}

- (CGFloat)waterflowLayout:(YZWaterFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    list *model = self.dataList[indexPath.item];
    CGFloat height = itemWidth * [model.height floatValue] / [model.width floatValue];
//    return 30 + arc4random_uniform(200);
    return height;
}

- (CGFloat)rowMarginInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout
{
    return 10;
}

- (CGFloat)columnMarginInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout
{
    return 5;
}

- (CGFloat)columnCountInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout
{
    return 2;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(5, 5, 10, 5);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"选中的是%ld",indexPath.item);
//    
//    YZCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YZCollectionCell class]) forIndexPath:indexPath];
//    NSLog(@"cell=%@",cell);
    [self.navigationController pushViewController:[[BLCommentVC alloc] initWithCommentID:self.dataList[indexPath.row].ID] animated:YES];
    
    
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
