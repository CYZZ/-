//
//  BLDoubanViewModel.m
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLDoubanViewModel.h"
#import "BLNetworkTool.h"
#import "BLBook.h"
#import "BLDoubanCell.h"

@implementation BLDoubanViewModel

- (instancetype)init
{
	if (self = [super init]) {
		[self initialBind];
	}
	return self;
}
/// 初始化命令
- (void)initialBind
{
	__weak typeof(self) weakSelf = self;
	_requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			// 参数
			
			NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
			parameters[@"q"] = weakSelf.keyWord;
			NSLog(@"关键字=%@",weakSelf.keyWord);
			// url
			NSString *url = @"https://api.douban.com/v2/book/search";
			
			// 发送请求
			[BLNetworkTool BL_GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
				
			} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//				NSLog(@"data.数据=%@",responseObject);
				//				responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
				
				[subscriber sendNext:responseObject];
				[subscriber sendCompleted];
				
			} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//				[subscriber sendCompleted];
				[subscriber sendError:error];
			}];
			return nil;
		}];
		
		// 在返回信号的时候，把数据中的字典映射成模型
		return [requestSignal map:^id(NSDictionary *value) {
			NSMutableArray *dicArr = value[@"books"];
			// 字典转模型
			NSArray *modelArr = [[dicArr.rac_sequence map:^id(id value) {
				return [BLBook bookWithDict:value];
			}] array];
			return modelArr;
		}];
		
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BLDoubanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BLDoubanCell class])];
//	if (cell == nil) {
//		cell = [[BLDoubanCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//	}
	
	BLBook *book = self.models[indexPath.row];
	cell.model = book;
//	cell.textLabel.text = book.title;
//	cell.detailTextLabel.text = book.subtitle;
	
	return cell;
}

@end
