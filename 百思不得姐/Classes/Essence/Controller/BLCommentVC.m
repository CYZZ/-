//
//  BLCommentVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/5.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLCommentVC.h"
#import "BLCommentModel.h"
#import "BLCommentCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "BLNotificationVC.h"

@interface BLCommentVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic ,strong) UITableView *tableView;
/// 最热评论模型数组
@property (nonatomic, strong) NSMutableArray<cmt *> *hotcmtArrayM;
/// 全部评论模型数组
@property (nonatomic, strong) NSMutableArray<cmt *> *cmtArrayM;

@end

@implementation BLCommentVC

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (instancetype)initWithCommentID:(NSString *)ID
{
    self = [super init];
    if (self) {
        NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
        paramer[@"a"] = @"dataList";
        paramer[@"c"] = @"comment";
        paramer[@"data_id"] = ID;
        paramer[@"hot"] = @"1";
        
        __weak typeof(self) weakSelf = self;
        [BLCommentModel getCommentModelWith:paramer complection:^(BLCommentModel *commentModel) {
            
            weakSelf.hotcmtArrayM = commentModel.hot.mutableCopy;
            weakSelf.cmtArrayM = commentModel.data.mutableCopy;
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"请求数据失败");
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    // 注册cell
    [self.tableView registerClass:[BLCommentCell class] forCellReuseIdentifier:NSStringFromClass([BLCommentCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotcmtArrayM.count;
    }else{
        return self.cmtArrayM.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLCommentCell class])];
    if (indexPath.section == 0) {
        cell.model = self.hotcmtArrayM[indexPath.row];
    }else{
        cell.model = self.cmtArrayM[indexPath.row];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([BLCommentCell class]) cacheByIndexPath:indexPath configuration:^(BLCommentCell *cell) {
        
        cell.model =indexPath.section == 0? self.hotcmtArrayM[indexPath.row] : self.cmtArrayM[indexPath.row];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"最热评论";
    }else{
        return @"最新评论";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [BLNotificationVC alloc] initWithWkwebView:<#(NSString *)#>
    [self.navigationController pushViewController:[[BLNotificationVC alloc] initWithWkwebView:@"http://blog.csdn.net/yangxuanlun/article/details/39582857"] animated:YES];
}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)dealloc
{
//    NSLog(@"%@ delloc",self);
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
