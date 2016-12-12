//
//  BLFollowVC.m
//  百思不得姐
//
//  Created by cyz on 16/11/7.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLFollowVC.h"
#import "BLAllTableVC.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface BLFollowVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *duanzi;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) BLAllTableVC *duanziVC;
@property (nonatomic, strong) BLAllTableVC *videoVC;
@property (nonatomic, strong) BLAllTableVC *allVC;


@end

@implementation BLFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}
#pragma mark - l懒加载

/**
 初始化View
 */
- (void)setupView
{
    _duanziVC = [[BLAllTableVC alloc] init];
    _duanziVC.typeID = @"29";
    _videoVC = [[BLAllTableVC alloc] init];
    _videoVC.typeID = @"41";
    _allVC = [[BLAllTableVC alloc] init];
    _allVC.typeID = @"1";
    
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    
    NSArray<UIView *> *views = @[_duanziVC.view, _videoVC.view, _allVC.view];
    for (int i = 0; i < views.count; i++) {
        // 添加三个view
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth *i, 0, kScreenWidth, _mainScrollView.frame.size.height)];
        [pageView addSubview:views[i]];
        [_mainScrollView addSubview:pageView];
    }
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth *(views.count), 0);
}

/**
 获取按钮
 */
- (UIButton *)buttonWithTag:(NSInteger)tag
{
    if (tag == 1) {
        return _duanzi;
    }else if (tag == 2){
        return _videoButton;
    }else if(tag == 3){
        return _allButton;
    }else{
        return nil;
    }
}
- (void)siderAction:(UIButton *)sender{
    [self sliderAnimationWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        _mainScrollView.contentOffset = CGPointMake(kScreenWidth*(sender.tag - 1), 0);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 滑动动画
- (void)sliderAnimationWithTag:(NSInteger)tag{
    _duanzi.selected = NO;
    _videoButton.selected = NO;
    _allButton.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    // 动画
//    [UIView animateWithDuration:0.3 animations:^{
//            
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    _duanzi.titleLabel.font = [UIFont systemFontOfSize:16];
    _videoButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _allButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    sender.titleLabel.font = [UIFont systemFontOfSize:19];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double index_ = scrollView.contentOffset.x / kScreenWidth;
    [self sliderAnimationWithTag:(int)(index_+0.5)+1];
}

- (IBAction)buttonClick:(UIButton *)sender {
    NSLog(@"sender.title=%@",sender.currentTitle);
    [self sliderAnimationWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        _mainScrollView.contentOffset = CGPointMake(kScreenWidth*(sender.tag - 1), 0);
    } completion:^(BOOL finished) {
        
    }];
}

















- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"cehsi";
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
