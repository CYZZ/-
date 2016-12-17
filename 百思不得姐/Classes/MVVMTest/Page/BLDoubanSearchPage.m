//
//  BLDoubanSearchPage.m
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLDoubanSearchPage.h"
#import "BLDoubanViewModel.h"
#import "BLNotificationDetailVC.h"
#import "BLBook.h"
#import "BLDoubanCell.h"

@interface BLDoubanSearchPage ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// 数据模型ViewModel
@property (nonatomic, strong) BLDoubanViewModel *requestViewModel;

@property (nonatomic, weak) UITextField *textFiled;

@end

@implementation BLDoubanSearchPage

#pragma mark - lazyload懒加载
- (BLDoubanViewModel *)requestViewModel
{
	if (_requestViewModel == nil) {
		_requestViewModel = [[BLDoubanViewModel alloc] init];
	}
	return _requestViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.tableView.dataSource = self.requestViewModel;
	self.tableView.delegate = self;
	self.tableView.rowHeight = 100;
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BLDoubanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BLDoubanCell class])];
//	RACSignal *requestSignal = [self.requestViewModel.requestCommand execute:nil];
//	
//	// 获取请求的数据
//	[requestSignal subscribeNext:^(NSArray *x) {
//		NSLog(@"加载完开始赋值");
//		self.requestViewModel.models = x;
//		[self.tableView reloadData];
//	}];
	
	[self setupNav];
}

- (void)setupNav
{
	UITextField *textFile = [[UITextField alloc] init];
	textFile.frame = CGRectMake(0, 0, 200, 30);
	textFile.borderStyle = UITextBorderStyleRoundedRect;
	textFile.placeholder = @"请输入搜索关键字";
	self.textFiled = textFile;
	self.navigationItem.titleView = textFile;
	__weak typeof(self) weakSelf = self;
	
	
	/**
	 <#Description#>

	 @param x <#x description#>
	 @return <#return value description#>
	 */
	[[[[textFile.rac_textSignal skip:1] throttle:0.5] distinctUntilChanged]  subscribeNext:^(NSString *x) {
		[weakSelf searchBeggin];

	}];
	
	UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBeggin)];
	self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)searchBeggin
{
	// 执行请求
	NSLog(@"发送请求");
	self.requestViewModel.keyWord = _textFiled.text;
	
	[[self.requestViewModel.requestCommand execute:nil] subscribeNext:^(NSArray *x) {
		
		NSLog(@"加载完开始赋值");
		self.requestViewModel.models = x;
//		[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentInset.top)  animated:NO];
		[self.tableView reloadData];
	} error:^(NSError *error) {
		NSLog(@"请求失败=%@",error);
	} completed:^{
		NSLog(@"请求完成");
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BLBook *book = self.requestViewModel.models[indexPath.row];
	
	NSLog(@"book.url=%@",book.alt);
	[self.navigationController pushViewController:[[BLNotificationDetailVC alloc] initWKWebViewWith:book.alt]  animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	NSLog(@"正在滚动");
	[self.textFiled resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
