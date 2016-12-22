//
//  YDChannelVC.m
//  百思不得姐
//
//  Created by cyz on 16/12/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDChannelVC.h"
#import "YDTagView.h"

@interface YDChannelVC ()

@end

@implementation YDChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self setupTagView];
	[self setupNav];
}

- (void)setupTagView
{
	// 创建标签列表
	YDTagView *tagView = [[YDTagView alloc] init];
	// 高度可以为0，会自动随标题数量变化
	tagView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
	// 排序的缩放比例
	tagView.scaleTagInSort = 1.0;
	// 可排序
	tagView.isSort = YES;
	// 标签尺寸
	CGFloat itemWidth = (self.view.frame.size.width - 2 *tagView.contentMargin - 3 * tagView.tagMargin) / 4;
	CGFloat itemHeight = 30;
	tagView.tagSize  = CGSizeMake(itemWidth, itemHeight);
	// 不需要自适应标签高度
	tagView.isFitTagViewH = NO;
	tagView.ignoreSortCount = 1; // 忽略头两个标签(不允许排序)
	[self.view addSubview:tagView];
	
	tagView.tagBackgroundColor = [UIColor grayColor];
	// 设置标签字体颜色
	tagView.tagColor = [UIColor cyanColor];
	
	/// *********** 一定要设置好属性之后添加标签
//	NSLog(@"传进来的标题数量=%ld",self.titleArray.count);
	[tagView addTags:self.titleArray];
	
	// 点击按钮
	__weak typeof(self) weakSelf = self;
	__weak typeof(tagView) weakTagView = tagView;
	tagView.clickTagBlock = ^(NSString *str){
		if (weakSelf.selectChannel) {
			weakSelf.selectChannel(str);
		}
		[weakSelf.navigationController popViewControllerAnimated:YES];
		
//		NSLog(@"点击频道返回的数量%ld",weakSelf.channeslArr.count);
	};
	
	/// 在这里对频道的数据源进行排序
	[tagView exchangeItemsBetween:^(NSInteger index1, NSInteger index2) {
#warning change 其实不是交换元素是先删除后插入
//		[weakSelf.channeslArr exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
		channels *changeObject = weakSelf.channeslArr[index1];
		[weakSelf.channeslArr removeObjectAtIndex:index1];
		[weakSelf.channeslArr insertObject:changeObject atIndex:index2];
		[weakSelf sortChannelCompletion];
//		NSLog(@"begin=%ld,endIndex=%ld",index1,index2);
//		NSLog(@"松开手频道数=%ld",weakSelf.channeslArr.count);
	}];
	
//	tagView.clickTagBlock = self.selectChannel;
}

- (void)setupNav
{
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成排序" style:UIBarButtonItemStylePlain target:self action:@selector(sortChannelCompletion)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)sortChannelCompletion
{
	/// 把排序结果返回
	if (self.channelBackBlock) {
		NSLog(@"完成排序%ld",self.channeslArr.count);
		self.channelBackBlock(self.channeslArr);
	}
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
