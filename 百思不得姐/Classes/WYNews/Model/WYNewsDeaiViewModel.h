//
//  WYNewsDeaiViewModel.h
//  百思不得姐
//
//  Created by cyz on 16/11/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYNewsDetailEntity.h"
#import "listModel.h"
#import <ReactiveCocoa.h>


@interface WYNewsDeaiViewModel : NSObject

/**
 详情页显示的内容
 */
@property (nonatomic, strong) WYNewsDetailEntity *detailModel;
/// 列表模型
@property (nonatomic, strong) listModel *listModel;



/** 获取资讯详情数据命令 */
@property (nonatomic, strong) RACCommand *fetchNewsDetailCommand;

/**
 拼接html字符串

 @return 返回拼接完成的字符串
 */
- (NSString *)getHtmlString;

@end
