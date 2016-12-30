//
//  YDDetailViewModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
//@class YDDocumentModel;
@class YDresult;
/// 资讯详情页模型
@interface YDDetailViewModel : NSObject


/// 列表模型用于获取文章id
@property (nonatomic, strong) YDresult *result;
/// 获取资讯详情的命令
@property (nonatomic, strong) RACCommand *fetchNewsDetaiCommand;

/// 资讯显示的html字符串
- (NSString *)getHtmlString;

@end
