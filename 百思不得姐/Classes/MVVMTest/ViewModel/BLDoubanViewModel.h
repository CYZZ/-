//
//  BLDoubanViewModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface BLDoubanViewModel : NSObject<UITableViewDataSource>
/// 请求命令
@property (nonatomic, strong) RACCommand *requestCommand;
/// 模型数组
@property (nonatomic, strong) NSArray *models;
/// 搜索关键字
@property (nonatomic, copy) NSString *keyWord;

@end
