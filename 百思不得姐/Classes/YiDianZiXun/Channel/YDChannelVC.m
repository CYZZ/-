//
//  YDChannelVC.m
//  百思不得姐
//
//  Created by cyz on 16/12/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDChannelVC.h"
#import "YDTagView.h"
#import "YiDianChannelModel.h" // 用于发送排序结果以及重新请求频道
#import "YDRecommendChannel.h"
#import <MJExtension.h>
#import <ReactiveCocoa.h>
#import <SVProgressHUD.h>

@interface YDChannelVC ()
/// 更多频道
@property(nonatomic, weak) YDTagView *moreTagView;
/// 我的频道
@property (nonatomic, weak) YDTagView *myTagView;
/// 推荐频道数组
@property (nonatomic, strong) NSMutableArray<channels *> *recommandArr;
/// 创建一个可变字典，key为频道的名字，value为频道模型，
@property (nonatomic, strong) NSMutableDictionary<NSString *, channels*> *AllChannelDic;
/// 删除的频道数组
@property (nonatomic, strong) NSMutableArray<channels *> *deletedChannels;
@end

@implementation YDChannelVC

#pragma mark - lazyload懒加载
- (NSMutableDictionary<NSString *,channels *> *)AllChannelDic
{
	if (_AllChannelDic == nil) {
		_AllChannelDic = [NSMutableDictionary dictionary];
	}
	return _AllChannelDic;
}

- (NSMutableArray<channels *> *)deletedChannels
{
	if (_deletedChannels == nil) {
		_deletedChannels = [NSMutableArray array];
	}
	return _deletedChannels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self setupTagView];
	[self setupNav];
	// 把我的频道映射到字典上
	[self creatDicFromArram:self.channeslArr];
}
/// 初始化页面
- (void)setupTagView
{
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:scrollView];
	// 创建标签列表
	YDTagView *tagView = [[YDTagView alloc] init];
	self.myTagView = tagView;
	tagView.backgroundColor = [UIColor lightGrayColor];
	// 高度可以为0，会自动随标题数量变化
	tagView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
	// 排序的缩放比例
	tagView.scaleTagInSort = 1.5;
	// 可排序
	tagView.isSort = YES;
	// 标签尺寸
	CGFloat itemWidth = (self.view.frame.size.width - 2 *tagView.contentMargin - 3 * tagView.tagMargin) / 4;
	CGFloat itemHeight = 30;
	tagView.tagSize  = CGSizeMake(itemWidth, itemHeight);
	// 不需要自适应标签高度
//	tagView.isFitTagViewH = NO;
	tagView.ignoreSortCount = 1; // 忽略头两个标签(不允许排序)
//	[self.view addSubview:tagView];
	[scrollView addSubview:tagView];
	
	tagView.tagBackgroundColor = [UIColor whiteColor];
	// 设置标签字体颜色
	tagView.tagColor = [UIColor orangeColor];
	tagView.tagBorderWidth = 1;
	
	/// *********** 一定要设置好属性之后添加标签
	[tagView addTags:self.titleArray];
	
	// 点击按钮
	__weak typeof(self) weakSelf = self;
	__weak typeof(tagView) weakTagView = tagView;
	
	/// 在这里对频道的数据源进行排序
	[tagView exchangeItemsBetween:^(NSInteger index1, NSInteger index2) {
		channels *changeObject = weakSelf.channeslArr[index1];
		[weakSelf.channeslArr removeObjectAtIndex:index1];
		[weakSelf.channeslArr insertObject:changeObject atIndex:index2];
//		[weakSelf sortChannelCompletion];
	}];
	
	//******************* 更多频道 **************
	YDTagView *moreTagView = [[YDTagView alloc] init];
	moreTagView.backgroundColor = [UIColor cyanColor];
	self.moreTagView = moreTagView;
	CGFloat tagViewX = 0;
	CGFloat tagViewY = CGRectGetMaxY(tagView.frame);
	CGFloat tagViewW = self.view.frame.size.width;
	moreTagView.frame = CGRectMake(tagViewX, tagViewY, tagViewW, 0);
	moreTagView.tagSize = tagView.tagSize;
//	[self.view addSubview:moreTagView];
	[scrollView addSubview:moreTagView];
	moreTagView.tagBackgroundColor = [UIColor whiteColor];
	moreTagView.tagBorderWidth = 1;
	moreTagView.tagColor = [UIColor grayColor];
	
	NSArray *moreTitle = @[@"更多1",@"更多2",@"更多3",@"更多4",@"更多5",@"更多6",@"更多7",];
	[moreTagView addTags:moreTitle];
	
	// 计算scrollView的滚动范围
	CGFloat maxY = CGRectGetMaxY(moreTagView.frame);
	scrollView.contentSize = CGSizeMake(0, maxY);
	
	
	__weak typeof(moreTagView) weakMoreTagView = moreTagView;
	tagView.clickTagBlock = ^(NSString *str){
		//		if (weakSelf.selectChannel) {
		//			weakSelf.selectChannel(str);
		//		}
		//		[weakSelf.navigationController popViewControllerAnimated:YES];
		[weakTagView deleteTag:str];
		
		// 根据名字找到模型删除
		[weakSelf.channeslArr removeObject:[weakSelf.AllChannelDic objectForKey:str]];
		// 点击一次就把删除的频道添加到预删除的频道数组
		[weakSelf.deletedChannels addObject:[weakSelf.AllChannelDic objectForKey:str]];
	};
	
	moreTagView.clickTagBlock = ^(NSString *str){
//		[weakTagView insetTag:str At:3];
		
		
		[weakSelf changeChannels:@[[weakSelf.AllChannelDic objectForKey:str]] At:2 type:ChannelChangeTypeAdd];
//		[weakSelf.channeslArr insertObject:[weakSelf.AllChannelDic objectForKey:str] atIndex:3];
//		[weakSelf.recommandArr removeObject:[weakSelf.AllChannelDic objectForKey:str]];
//		NSLog(@"[weakSelf.AllChannelDic objectForKey:str] = %@",[weakSelf.AllChannelDic objectForKey:str]);
	};
	
	/// 当我订阅的频道发生变化的时候
	[[[[tagView rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] distinctUntilChanged] throttle:0.25] subscribeNext:^(id x) {
//		RACTupleUnpack(id key) = x;
//		CGRect rect = [key CGRectValue];
		NSLog(@"我的频道发生了变化%@",x);
		CGRect frame = moreTagView.frame;
		frame.origin.y = CGRectGetMaxY(weakTagView.frame);
		moreTagView.frame = frame;
	}];
	
	/// 当更多频道发生变化的时候
	[[[[moreTagView rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] distinctUntilChanged] throttle:0.25] subscribeNext:^(id x) {
//		NSConcreteValue 包含的类型有NSNumber和NSValue 可以转换成原始类型
		NSLog(@"更多频道发生了变化%@",x);
		RACTupleUnpack(id key) = x;
		CGRect rect = [key CGRectValue];
		scrollView.contentSize = CGSizeMake(0, rect.origin.y + rect.size.height);
	}];
	/// 请求更多频道
	[self requestRecommendChannel:nil];
}

/// 请求更多频道
- (void)requestRecommendChannel:(void (^)(YDRecommendChannel *))completion
{
	__weak typeof(self) weakSelf = self;
	[YDRecommendChannel requestYDRecommendChannels:^(YDRecommendChannel *model) {
		if (completion) {
			completion(model);
		}
//		// 遍历数组存进字典
		[model.channels enumerateObjectsUsingBlock:^(channels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[weakSelf.AllChannelDic setValue:obj forKey:obj.name];
		}];
//		NSLog(@"ALLKEYcount = %ld",weakSelf.AllChannelDic.allKeys.count);
		
		weakSelf.recommandArr = model.channels.mutableCopy;
		NSMutableArray *titles = [NSMutableArray array];
		[model.channels enumerateObjectsUsingBlock:^(channels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[titles addObject: obj.name];
		}];
		weakSelf.moreTagView.tagArrays = titles;
	} failture:^(NSError *error) {
		
	}];
}

/// 添加频道或者删除频道
- (void)changeChannels:(NSArray<channels*> *)cretedChannels At:(NSInteger)index type:(ChannelChangeType)type
{
	[SVProgressHUD show];
	__weak typeof(self) weakSelf = self;
	[YDRecommendChannel channgeChannels:cretedChannels At:index type:type groupID:self.groupID completion:^(channels *creted_channels) {
		[SVProgressHUD dismiss];
		if (cretedChannels.count == 0) { // 如果没有新增频道就不用添加频道
			return ;
		}
		[weakSelf.channeslArr insertObject:creted_channels atIndex:index+2]; // 由于存在“推荐”和“要闻”
		[weakSelf.myTagView insetTag:creted_channels.name At:index+2];
		[weakSelf.moreTagView deleteTag:creted_channels.name];
	} failture:^(NSError *error) {
		[SVProgressHUD dismiss];
		
	}];
	
//	[YDRecommendChannel insertChannels:[cretedChannels firstObject] At:index groupID:self.groupID completion:^(channels *creted_channels) {
//		[SVProgressHUD dismiss];
//		// 插入频道成功
//		if (creted_channels == nil) {
//			return ;
//		}
//		[weakSelf.channeslArr insertObject:creted_channels atIndex:index+2]; // 由于存在“推荐”和“要闻”
//		[weakSelf.myTagView insetTag:creted_channels.name At:index+2];
//		[weakSelf.moreTagView deleteTag:creted_channels.name];
//		
//	} failture:^(NSError *error) {
//		[SVProgressHUD dismiss];
//	}];
}

/// 通过数组创建字典
- (void)creatDicFromArram:(NSMutableArray<channels *> *)array
{
	[array enumerateObjectsUsingBlock:^(channels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[self.AllChannelDic setValue:obj forKey:obj.name];
	}];
}

- (void)setupNav
{
	UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"完成排序" style:UIBarButtonItemStylePlain target:self action:@selector(sortChannelCompletion)];
	UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(addMoreChannel)];
	
	self.navigationItem.rightBarButtonItems =@[rightItem1, rightItem2];
}

/// 点击完成排序
- (void)sortChannelCompletion
{
	/// 把排序结果返回
	if (self.channelBackBlock) {
		// 删除频道
		[self changeChannels:self.deletedChannels At:2 type:ChannelChangeTypeDeleted];
		
		[YiDianChannelModel sortChannelbyGroupID:self.groupID order:self.channeslArr completion:^(YiDianChannelModel *model) {
//			weakSelf.channelBackBlock(weakSelf.channeslArr);
		} failture:^(NSError *error) {
			
		}];
		self.channelBackBlock(self.channeslArr);
	}
}
/// 添加频道（测试)
- (void)addMoreChannel
{
//	[self.myTagView.tagArrays addObject:<#(nonnull id)#>]
	
//	self.myTagView.tagArrays = @[].mutableCopy;
//	[self.moreTagView addTag:@"新增"];
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
